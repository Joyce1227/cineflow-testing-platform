"""有限步、可追踪的只读 Agent 循环。"""

from __future__ import annotations

import json
from typing import Any, Protocol

from pydantic import ValidationError

from agent.model import AgentModelError
from agent.models import AgentResult, AgentTraceStep, ToolCall
from agent.policy import ToolArgumentsInvalid, ToolNotAllowed, dispatch_tool, tool_definitions
from agent.tools import CineFlowReadOnlyTools, ToolExecutionError


SYSTEM_PROMPT = """你是 CineFlow 电影助手，只能使用提供的只读工具回答。
不得创建订单、锁定座位、支付、退款、修改评论、执行管理操作或 SQL。
规则问题使用 get_refund_policy；实时电影、场次和座位使用对应 HTTP 工具。
资料不足或工具失败时明确说明无法确认，不得编造。"""


class AgentModel(Protocol):
    def complete(self, messages: list[dict[str, Any]], tools: list[dict[str, Any]]) -> dict[str, Any]: ...


class ReadOnlyAgent:
    def __init__(self, model: AgentModel, tools: CineFlowReadOnlyTools, max_steps: int = 4) -> None:
        if not 1 <= max_steps <= 5:
            raise ValueError("max_steps 必须位于 1 到 5 之间")
        self.model, self.tools, self.max_steps = model, tools, max_steps

    def run(self, question: str) -> AgentResult:
        """每次请求新建消息列表，不在用户之间保留隐式记忆。"""
        messages: list[dict[str, Any]] = [{"role": "system", "content": SYSTEM_PROMPT}, {"role": "user", "content": question}]
        trace: list[AgentTraceStep] = []
        for step_number in range(1, self.max_steps + 1):
            try:
                response = self.model.complete(messages, tool_definitions())
            except AgentModelError as exc:
                return AgentResult(answer="模型服务调用失败，当前无法回答。", status="model_error",
                                   steps=trace + [AgentTraceStep(step=step_number, tool_name="<model>", arguments={}, outcome="failed", error=str(exc))])
            content, raw_calls = response.get("content"), response.get("tool_calls") or []
            if not raw_calls:
                answer = content.strip() if isinstance(content, str) and content.strip() else "根据当前资料无法确认。"
                return AgentResult(answer=answer, status="completed", steps=trace)

            # 每回合只执行一个工具，限制模型并行放大请求。
            try:
                call = ToolCall.model_validate(raw_calls[0])
                arguments, result = dispatch_tool(call, self.tools)
                trace.append(AgentTraceStep(step=step_number, tool_name=call.name, arguments=arguments, outcome="success", result=result))
            except (ValidationError, ToolNotAllowed, ToolArgumentsInvalid) as exc:
                tool_name = raw_calls[0].get("name", "<invalid>") if isinstance(raw_calls[0], dict) else "<invalid>"
                trace.append(AgentTraceStep(step=step_number, tool_name=tool_name, arguments={}, outcome="blocked", error=str(exc)))
                return AgentResult(answer="该操作超出 CineFlow 助手的只读权限。", status="blocked", steps=trace)
            except ToolExecutionError as exc:
                trace.append(AgentTraceStep(step=step_number, tool_name=call.name, arguments={}, outcome="failed", error=str(exc)))
                return AgentResult(answer="工具调用失败，当前无法确认结果。", status="tool_error", steps=trace)

            messages.append({"role": "assistant", "content": content or "", "tool_calls": raw_calls[:1]})
            messages.append({"role": "tool", "tool_call_id": call.id, "name": call.name,
                             "content": json.dumps(result, ensure_ascii=False, default=str)})
        return AgentResult(answer="已达到最大工具调用步数，停止执行。", status="step_limit", steps=trace)
