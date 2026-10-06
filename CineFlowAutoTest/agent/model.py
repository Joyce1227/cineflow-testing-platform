"""OpenAI 兼容的 Tool Calling 模型适配器。"""

from __future__ import annotations

from typing import Any, Callable

import requests

from llm.config import LLMSettings


class AgentModelError(RuntimeError):
    """模型请求或 Tool Calling 响应格式错误。"""


class OpenAICompatibleAgentModel:
    def __init__(self, base_url: str, api_key: str, model: str, *,
                 thinking_mode: str = "disabled", timeout: float = 60,
                 post: Callable[..., requests.Response] = requests.post) -> None:
        self.url = f"{base_url.rstrip('/')}/chat/completions"
        self.api_key, self.model = api_key, model
        self.thinking_mode, self.timeout, self.post = thinking_mode, timeout, post

    @classmethod
    def from_env(cls) -> "OpenAICompatibleAgentModel":
        """密钥仅从环境变量读取，不写入源码、轨迹或评测报告。"""
        settings = LLMSettings.from_env()
        return cls(settings.api_base, settings.api_key, settings.model,
                   thinking_mode=settings.thinking_mode)

    @staticmethod
    def _provider_messages(messages: list[dict[str, Any]]) -> list[dict[str, Any]]:
        """把内部简化工具调用恢复成 DeepSeek/OpenAI 标准消息格式。"""
        normalized: list[dict[str, Any]] = []
        for original in messages:
            message = dict(original)
            if message.get("role") == "assistant" and message.get("tool_calls"):
                message["tool_calls"] = [
                    {
                        "id": call["id"],
                        "type": "function",
                        "function": {
                            "name": call["name"],
                            "arguments": call.get("arguments", "{}"),
                        },
                    }
                    for call in message["tool_calls"]
                ]
            if message.get("role") == "tool":
                # DeepSeek 只需要 tool_call_id 和 content；内部 name 不发送给服务端。
                message.pop("name", None)
            normalized.append(message)
        return normalized

    def complete(self, messages: list[dict[str, Any]], tools: list[dict[str, Any]]) -> dict[str, Any]:
        payload: dict[str, Any] = {
            "model": self.model,
            "temperature": 0,
            "thinking": {"type": self.thinking_mode},
            "messages": self._provider_messages(messages),
        }
        if tools:
            payload.update({"tools": tools, "tool_choice": "auto"})
        try:
            response = self.post(self.url,
                headers={"Authorization": f"Bearer {self.api_key}", "Content-Type": "application/json"},
                json=payload, timeout=self.timeout)
        except requests.RequestException as exc:
            raise AgentModelError("Agent 模型服务当前不可用") from exc
        if not 200 <= response.status_code < 300:
            raise AgentModelError(f"Agent 模型返回 HTTP {response.status_code}")
        try:
            message = response.json()["choices"][0]["message"]
            calls = [{"id": item["id"], "name": item["function"]["name"],
                      "arguments": item["function"].get("arguments", "{}")}
                     for item in message.get("tool_calls", [])]
        except (ValueError, KeyError, IndexError, TypeError) as exc:
            raise AgentModelError("Agent 模型响应格式无效") from exc
        return {"content": message.get("content"), "tool_calls": calls}
