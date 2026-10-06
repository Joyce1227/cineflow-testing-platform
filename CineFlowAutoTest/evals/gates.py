"""统一比较评测指标和可版本化质量门禁。"""

from pathlib import Path
from typing import Any

import yaml


def load_thresholds(path: Path, suite: str) -> dict[str, float]:
    config = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    thresholds = config.get(suite)
    if not isinstance(thresholds, dict) or not thresholds:
        raise ValueError(f"未配置质量门禁：{suite}")
    return {str(name): float(value) for name, value in thresholds.items()}


def gate_failures(metrics: dict[str, Any], thresholds: dict[str, float]) -> list[str]:
    """返回所有未达标项，便于一次 CI 运行看到完整退化信息。"""
    failures = []
    for name, minimum in thresholds.items():
        actual = metrics.get(name)
        if not isinstance(actual, (int, float)) or actual < minimum:
            failures.append(f"{name}: actual={actual}, required>={minimum}")
    return failures
