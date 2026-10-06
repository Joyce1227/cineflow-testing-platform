"""Agent 输入、轨迹和工具参数的数据模型。"""

from __future__ import annotations

from typing import Any

from pydantic import BaseModel, ConfigDict, Field


class StrictArguments(BaseModel):
    """拒绝模型臆造的额外参数，避免它们被静默忽略。"""
    model_config = ConfigDict(extra="forbid", strict=True)


class SearchMoviesArguments(StrictArguments):
    genre: str | None = Field(default=None, max_length=30)
    region: str | None = Field(default=None, max_length=30)
    year: int | None = Field(default=None, ge=1888, le=2100)
    min_score: float | None = Field(default=None, ge=0, le=10)
    limit: int = Field(default=10, ge=1, le=20)


class MovieArguments(StrictArguments):
    movie_id: int = Field(ge=1)


class ScheduleArguments(StrictArguments):
    schedule_id: int = Field(ge=1)


class RecommendationArguments(StrictArguments):
    limit: int = Field(default=5, ge=1, le=20)


class RefundPolicyArguments(StrictArguments):
    """退款规则查询无需参数。"""


class ToolCall(BaseModel):
    id: str
    name: str
    arguments: str | dict[str, Any] = Field(default_factory=dict)


class AgentTraceStep(BaseModel):
    step: int
    tool_name: str
    arguments: dict[str, Any]
    outcome: str
    result: Any | None = None
    error: str | None = None


class AgentResult(BaseModel):
    answer: str
    status: str
    steps: list[AgentTraceStep] = Field(default_factory=list)
