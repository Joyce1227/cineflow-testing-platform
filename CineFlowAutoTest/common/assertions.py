from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from jsonschema import Draft202012Validator

from common.data import json_path

ROOT = Path(__file__).resolve().parents[1]


def assert_schema(document: Any, filename: str) -> None:
    schema = json.loads((ROOT / "schemas" / filename).read_text(encoding="utf-8"))
    errors = sorted(Draft202012Validator(schema).iter_errors(document), key=lambda item: list(item.path))
    assert not errors, "; ".join(error.message for error in errors)


def assert_response(response: Any, expected: dict[str, Any]) -> None:
    assert response.status_code == expected["status"], response.text
    body = response.json()
    if "code" in expected:
        assert body.get("code") == expected["code"], body
    if schema := expected.get("schema"):
        assert_schema(body, schema)
    for check in expected.get("checks", []):
        actual = json_path(body, check["path"])
        operator = check.get("op", "equals")
        expected_value = check.get("value")
        if operator == "equals":
            assert actual == expected_value
        elif operator == "not_empty":
            assert actual not in (None, "", [], {})
        elif operator == "contains":
            assert expected_value in actual
        elif operator == "gte":
            assert actual >= expected_value
        elif operator == "lte":
            assert actual <= expected_value
        elif operator == "unique":
            assert len(actual) == len(set(actual))
        else:
            raise ValueError(f"unknown assertion operator: {operator}")

