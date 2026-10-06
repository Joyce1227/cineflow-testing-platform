"""OpenAI 兼容接口客户端，集中处理重试、格式校验与调用指标。"""

from __future__ import annotations

import time
from dataclasses import dataclass
from typing import Any, Callable

import requests

from llm.config import LLMSettings


class LLMClientError(RuntimeError):
    """所有 LLM 客户端错误的基类。"""


class RequestFailedError(LLMClientError):
    """网络或 HTTP 请求在允许的重试次数内仍未成功。"""


class ResponseFormatError(LLMClientError):
    """成功响应不满足约定格式。"""


@dataclass(frozen=True)
class LLMResult:
    """回答以及可用于质量分析的调用元数据。"""

    content: str
    model: str
    attempts: int
    request_id: str | None
    prompt_tokens: int | None
    completion_tokens: int | None
    latency_ms: int


def _parse_success_response(response: requests.Response, attempts: int, latency_ms: int) -> LLMResult:
    """严格解析成功响应，防止把空回答当成正常结果。"""
    try:
        body = response.json()
    except (ValueError, requests.JSONDecodeError) as exc:
        raise ResponseFormatError("LLM 响应不是合法 JSON") from exc
    choices = body.get("choices") if isinstance(body, dict) else None
    if not isinstance(choices, list) or not choices:
        raise ResponseFormatError("LLM 响应的 choices 缺失或为空")
    message = choices[0].get("message") if isinstance(choices[0], dict) else None
    content = message.get("content") if isinstance(message, dict) else None
    if not isinstance(content, str) or not content.strip():
        raise ResponseFormatError("LLM 响应的 message.content 缺失或为空")
    usage = body.get("usage") if isinstance(body.get("usage"), dict) else {}
    return LLMResult(
        content=content,
        model=str(body.get("model", "unknown")),
        attempts=attempts,
        request_id=response.headers.get("x-request-id"),
        prompt_tokens=usage.get("prompt_tokens"),
        completion_tokens=usage.get("completion_tokens"),
        latency_ms=latency_ms,
    )


def complete_with_retry(
    *, url: str, api_key: str, model: str, system: str, user: str,
    max_retries: int = 2, timeout: float = 60, thinking_mode: str | None = None,
    post: Callable[..., requests.Response] = requests.post,
    sleep: Callable[[float], Any] = time.sleep,
) -> LLMResult:
    """调用模型并仅对暂时性故障重试，退避时间依次为 1、2、4 秒。"""
    payload = {"model": model, "temperature": 0.1, "messages": [
        {"role": "system", "content": system}, {"role": "user", "content": user},
    ]}
    # DeepSeek 的 thinking 是可选扩展；测试其他 OpenAI 兼容服务时可以不传。
    if thinking_mode is not None:
        payload["thinking"] = {"type": thinking_mode}
    retryable_statuses = {408, 429, 500, 502, 503, 504}
    started = time.perf_counter()
    for attempt in range(1, max_retries + 2):
        try:
            response = post(url, headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"}, json=payload, timeout=timeout)
        except (requests.Timeout, requests.ConnectionError) as exc:
            if attempt > max_retries:
                raise RequestFailedError(f"LLM 网络请求失败，共尝试 {attempt} 次") from exc
            sleep(2 ** (attempt - 1))
            continue
        if response.status_code in retryable_statuses:
            if attempt > max_retries:
                raise RequestFailedError(f"LLM 返回 HTTP {response.status_code}，共尝试 {attempt} 次")
            sleep(2 ** (attempt - 1))
            continue
        if not 200 <= response.status_code < 300:
            raise RequestFailedError(f"LLM 返回 HTTP {response.status_code}，该错误未自动重试")
        return _parse_success_response(response, attempt, round((time.perf_counter() - started) * 1000))
    raise AssertionError("重试循环不应执行到此处")


def complete(system: str, user: str) -> str:
    """使用统一 DeepSeek 配置调用模型，兼容 RAG 和用例生成代码。"""
    settings = LLMSettings.from_env()
    return complete_with_retry(
        url=f"{settings.api_base}/chat/completions", api_key=settings.api_key,
        model=settings.model, system=system, user=user,
        thinking_mode=settings.thinking_mode,
    ).content
