from __future__ import annotations

from typing import Any

from llm.models import TestCase, ValidationIssue


def _issue(location: str, rule: str, message: str) -> ValidationIssue:
    return ValidationIssue(
        layer="openapi", location=location, rule=rule, message=message
    )


def _allowed_query_parameters(path_item: dict[str, Any], method: str) -> set[str]:
    operation = path_item[method]
    parameters = [
        *path_item.get("parameters", []),
        *operation.get("parameters", []),
    ]
    return {
        parameter["name"]
        for parameter in parameters
        if parameter.get("in") == "query" and "name" in parameter
    }


def validate_case_against_openapi(
    openapi: dict[str, Any], index: int, case: TestCase
) -> list[ValidationIssue]:
    base = f"cases.{index}.request"
    path = case.request.path
    method = case.request.method.lower()
    path_item = openapi.get("paths", {}).get(path)

    if path_item is None:
        return [
            _issue(
                f"{base}.path",
                "OPENAPI_PATH_NOT_FOUND",
                f"OpenAPI 中不存在路径：{path}",
            )
        ]

    if method not in path_item:
        return [
            _issue(
                f"{base}.method",
                "OPENAPI_METHOD_NOT_ALLOWED",
                f"路径 {path} 不支持方法 {case.request.method}",
            )
        ]

    actual = set((case.request.params or {}).keys())
    allowed = _allowed_query_parameters(path_item, method)
    return [
        _issue(
            f"{base}.params.{name}",
            "OPENAPI_QUERY_PARAMETER_NOT_FOUND",
            f"未知查询参数：{name}",
        )
        for name in sorted(actual - allowed)
    ]
