"""工具白名单、严格参数校验和统一调度。"""

from __future__ import annotations

import json
from dataclasses import dataclass
from typing import Any

from pydantic import BaseModel, ValidationError

from agent.models import MovieArguments, RecommendationArguments, RefundPolicyArguments, ScheduleArguments, SearchMoviesArguments, ToolCall
from agent.tools import CineFlowReadOnlyTools


class ToolNotAllowed(PermissionError):
    """模型请求了白名单之外的工具。"""


class ToolArgumentsInvalid(ValueError):
    """工具参数不是合法 JSON 或不满足严格模型。"""


@dataclass(frozen=True)
class ToolSpec:
    arguments_model: type[BaseModel]
    handler_name: str
    description: str


# 唯一注册表既生成给模型看的 schema，也控制实际可执行的方法。
TOOL_REGISTRY = {
    "search_movies": ToolSpec(SearchMoviesArguments, "search_movies", "按条件搜索电影"),
    "get_movie_detail": ToolSpec(MovieArguments, "get_movie_detail", "查询电影详情"),
    "get_movie_schedules": ToolSpec(MovieArguments, "get_movie_schedules", "查询电影场次"),
    "get_available_seats": ToolSpec(ScheduleArguments, "get_available_seats", "查询可用座位"),
    "get_hot_recommendations": ToolSpec(RecommendationArguments, "get_hot_recommendations", "查询热门推荐"),
    "get_refund_policy": ToolSpec(RefundPolicyArguments, "get_refund_policy", "查询退款规则"),
}


def tool_definitions() -> list[dict[str, Any]]:
    """由参数模型生成 function-calling schema，避免文档和校验规则漂移。"""
    return [{"type": "function", "function": {"name": name, "description": spec.description,
            "parameters": spec.arguments_model.model_json_schema()}}
            for name, spec in TOOL_REGISTRY.items()]


def dispatch_tool(call: ToolCall, tools: CineFlowReadOnlyTools) -> tuple[dict[str, Any], Any]:
    spec = TOOL_REGISTRY.get(call.name)
    if spec is None:
        raise ToolNotAllowed(f"工具 {call.name!r} 不在只读白名单中")
    try:
        raw_arguments = json.loads(call.arguments) if isinstance(call.arguments, str) else call.arguments
        validated = spec.arguments_model.model_validate(raw_arguments)
    except (json.JSONDecodeError, ValidationError, TypeError) as exc:
        raise ToolArgumentsInvalid(f"工具 {call.name!r} 参数校验失败") from exc
    arguments = validated.model_dump(exclude_none=True)
    return arguments, getattr(tools, spec.handler_name)(**arguments)
