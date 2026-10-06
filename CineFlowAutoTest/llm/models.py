from __future__ import annotations

from typing import Any, Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator


class StrictModel(BaseModel):
    model_config = ConfigDict(extra="forbid", strict=True, populate_by_name=True)


class RequestSpec(StrictModel):
    method: Literal["GET", "POST", "PUT", "PATCH", "DELETE"]
    path: str = Field(min_length=1)
    params: dict[str, Any] | None = None
    json_body: dict[str, Any] | None = Field(default=None, alias="json")
    headers: dict[str, str] | None = None

    @field_validator("path")
    @classmethod
    def path_must_start_with_slash(cls, value: str) -> str:
        if not value.startswith("/"):
            raise ValueError("path 必须以 / 开头")
        return value


class ExpectedSpec(StrictModel):
    status: int = Field(ge=100, le=599)
    code: int | None = None
    schema_name: str | None = Field(default=None, alias="schema")


class TestCase(StrictModel):
    name: str = Field(min_length=1, max_length=100)
    tags: list[str] = Field(default_factory=list)
    request: RequestSpec
    expect: ExpectedSpec


class GeneratedCases(StrictModel):
    cases: list[TestCase] = Field(min_length=1, max_length=50)


class ValidationIssue(StrictModel):
    layer: Literal["syntax", "structure", "openapi", "business"]
    location: str
    rule: str
    message: str
