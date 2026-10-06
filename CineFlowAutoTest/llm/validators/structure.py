from __future__ import annotations

from pydantic import ValidationError

from llm.models import ValidationIssue


def strip_markdown_fence(value: str) -> str:
    """Remove one complete leading Markdown fence without guessing intent."""
    text = value.strip()
    if not text.startswith("```"):
        return text

    first_newline = text.find("\n")
    if first_newline == -1:
        raise ValueError("代码围栏缺少正文")

    body = text[first_newline + 1 :]
    if not body.rstrip().endswith("```"):
        raise ValueError("代码围栏没有闭合")

    return body.rstrip()[:-3].strip()


def pydantic_issues(error: ValidationError) -> list[ValidationIssue]:
    issues: list[ValidationIssue] = []
    for item in error.errors():
        location = ".".join(str(part) for part in item["loc"]) or "$"
        error_type = str(item["type"]).upper().replace(".", "_")
        issues.append(
            ValidationIssue(
                layer="structure",
                location=location,
                rule=f"PYDANTIC_{error_type}",
                message=item["msg"],
            )
        )
    return issues
