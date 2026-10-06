from __future__ import annotations

import re
from pathlib import Path
from typing import Any

import yaml

VARIABLE = re.compile(r"\$\{([A-Za-z_][A-Za-z0-9_.-]*)}")


def load_cases(path: Path) -> list[dict[str, Any]]:
    raw = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    cases = raw.get("cases", [])
    for index, case in enumerate(cases):
        missing = {"name", "request", "expect"} - case.keys()
        if missing:
            raise ValueError(f"{path.name} case[{index}] missing fields: {sorted(missing)}")
    return cases


def resolve(value: Any, variables: dict[str, Any]) -> Any:
    if isinstance(value, dict):
        return {key: resolve(item, variables) for key, item in value.items()}
    if isinstance(value, list):
        return [resolve(item, variables) for item in value]
    if not isinstance(value, str):
        return value
    full = VARIABLE.fullmatch(value)
    if full:
        return variables[full.group(1)]
    return VARIABLE.sub(lambda match: str(variables[match.group(1)]), value)


def json_path(document: Any, path: str) -> Any:
    if path == "$":
        return document
    if not path.startswith("$."):
        raise ValueError(f"unsupported JSON path: {path}")
    current = document
    for key, index in re.findall(r"([^.\[\]]+)|\[(\d+)]", path[2:]):
        current = current[int(index)] if index else current[key]
    return current

