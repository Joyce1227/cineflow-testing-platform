from __future__ import annotations

from llm.models import TestCase, ValidationIssue


SAFE_GENERATED_METHODS = {"GET"}
SENSITIVE_PATH_FRAGMENTS = ("payment", "refund", "admin")


def _issue(location: str, rule: str, message: str) -> ValidationIssue:
    return ValidationIssue(
        layer="business", location=location, rule=rule, message=message
    )


def validate_case_business_rules(index: int, case: TestCase) -> list[ValidationIssue]:
    base = f"cases.{index}.request"
    errors: list[ValidationIssue] = []

    if case.request.method not in SAFE_GENERATED_METHODS:
        errors.append(
            _issue(
                f"{base}.method",
                "CF-AI-003",
                f"模型生成的 {case.request.method} 用例必须人工审批",
            )
        )

    lowered_path = case.request.path.lower()
    if any(fragment in lowered_path for fragment in SENSITIVE_PATH_FRAGMENTS):
        errors.append(
            _issue(
                f"{base}.path",
                "CF-AI-004",
                "支付、退款或管理员接口必须人工审批",
            )
        )

    return errors
