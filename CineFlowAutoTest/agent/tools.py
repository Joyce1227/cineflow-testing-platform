"""只读工具执行层：只允许固定 GET 接口或本地规则知识库。"""

from __future__ import annotations

from typing import Any, Callable

import requests


class ToolExecutionError(RuntimeError):
    """后端不可用或返回不符合 CineFlow 信封协议。"""


SENSITIVE_KEYS = {"password", "token", "authorization", "secret", "api_key"}


def sanitize_tool_result(value: Any, depth: int = 0) -> Any:
    """限制工具结果大小并移除常见敏感字段，再交给不可信模型。"""
    if depth > 6:
        return "<truncated>"
    if isinstance(value, dict):
        return {str(key): "<redacted>" if str(key).lower() in SENSITIVE_KEYS else sanitize_tool_result(item, depth + 1)
                for key, item in list(value.items())[:50]}
    if isinstance(value, list):
        return [sanitize_tool_result(item, depth + 1) for item in value[:100]]
    if isinstance(value, str):
        return value[:2000]
    return value


class CineFlowReadOnlyTools:
    def __init__(self, base_url: str, *, timeout: float = 10,
                 get: Callable[..., requests.Response] = requests.get,
                 refund_policy_lookup: Callable[[str], Any] | None = None) -> None:
        self.base_url = base_url.rstrip("/")
        self.timeout = timeout
        self.get = get
        self.refund_policy_lookup = refund_policy_lookup

    def _get(self, path: str, params: dict[str, Any] | None = None) -> Any:
        """统一校验 HTTP 状态和业务 code，只向模型返回 data 字段。"""
        try:
            response = self.get(f"{self.base_url}{path}", params=params or None, timeout=self.timeout)
        except requests.RequestException as exc:
            raise ToolExecutionError("CineFlow 服务当前不可用") from exc
        if not 200 <= response.status_code < 300:
            raise ToolExecutionError(f"CineFlow 接口返回 HTTP {response.status_code}")
        try:
            body = response.json()
        except ValueError as exc:
            raise ToolExecutionError("CineFlow 接口没有返回合法 JSON") from exc
        if not isinstance(body, dict) or body.get("code") != 0:
            message = body.get("message", "未知业务错误") if isinstance(body, dict) else "响应格式错误"
            raise ToolExecutionError(f"CineFlow 业务请求失败：{message}")
        return sanitize_tool_result(body.get("data"))

    def search_movies(self, *, genre=None, region=None, year=None, min_score=None, limit=10):
        params = {"genre": genre, "region": region, "year": year, "minScore": min_score, "pageNum": 1, "pageSize": limit}
        return self._get("/api/movies", {key: value for key, value in params.items() if value is not None})

    def get_movie_detail(self, *, movie_id: int):
        return self._get(f"/api/movies/{movie_id}")

    def get_movie_schedules(self, *, movie_id: int):
        return self._get(f"/api/movies/{movie_id}/schedules")

    def get_available_seats(self, *, schedule_id: int):
        seats = self._get(f"/api/schedules/{schedule_id}/seats")
        if not isinstance(seats, list):
            raise ToolExecutionError("座位接口 data 字段应为数组")
        # 只返回可售座位，避免模型把已锁定座位误报为可购买。
        return [seat for seat in seats if seat.get("status") == "AVAILABLE"]

    def get_hot_recommendations(self, *, limit: int = 5):
        return self._get("/api/recommendations/hot", {"limit": limit})

    def get_refund_policy(self):
        if self.refund_policy_lookup is None:
            raise ToolExecutionError("退款规则知识库尚未初始化")
        return sanitize_tool_result(self.refund_policy_lookup("CineFlow 的退款规则是什么？"))
