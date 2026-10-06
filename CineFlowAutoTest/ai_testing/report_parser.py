"""安全、确定性地读取 JUnit XML 或 pytest 文本结果。"""

from __future__ import annotations

import re
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field


MAX_REPORT_BYTES = 10 * 1024 * 1024
MAX_FAILURE_DETAILS = 6000


class StrictModel(BaseModel):
    model_config = ConfigDict(extra="forbid", strict=True)


class FailedTest(StrictModel):
    case_id: str = Field(min_length=1, max_length=500)
    name: str = Field(min_length=1, max_length=300)
    classname: str = Field(default="", max_length=500)
    status: Literal["failed", "error"]
    message: str = Field(default="", max_length=2000)
    details: str = Field(default="", max_length=MAX_FAILURE_DETAILS)


class TestRunSummary(StrictModel):
    source_format: Literal["junit", "pytest_text"]
    tests: int = Field(ge=0)
    passed: int = Field(ge=0)
    failures: int = Field(ge=0)
    errors: int = Field(ge=0)
    skipped: int = Field(ge=0)
    duration_seconds: float = Field(ge=0)
    failed_tests: list[FailedTest]


def _redact(value: str) -> str:
    patterns = (
        (r"(?i)(authorization\s*[:=]\s*bearer\s+)[^\s]+", r"\1<redacted>"),
        (r"(?i)((?:api[_-]?key|password|token|secret)\s*[:=]\s*)[^\s,;]+", r"\1<redacted>"),
    )
    result = value
    for pattern, replacement in patterns:
        result = re.sub(pattern, replacement, result)
    return result[:MAX_FAILURE_DETAILS]


def _read_bounded(path: Path) -> str:
    size = path.stat().st_size
    if size > MAX_REPORT_BYTES:
        raise ValueError(f"测试结果文件超过 {MAX_REPORT_BYTES} 字节限制")
    return path.read_text(encoding="utf-8", errors="replace")


def parse_junit(path: Path) -> TestRunSummary:
    raw = _read_bounded(path)
    if "<!DOCTYPE" in raw.upper() or "<!ENTITY" in raw.upper():
        raise ValueError("JUnit XML 不允许 DOCTYPE 或 ENTITY")
    try:
        root = ET.fromstring(raw)
    except ET.ParseError as exc:
        raise ValueError(f"JUnit XML 格式无效：{exc}") from exc
    if root.tag not in {"testsuite", "testsuites"}:
        raise ValueError("JUnit XML 根节点必须是 testsuite 或 testsuites")

    cases = list(root.iter("testcase"))
    failed_tests: list[FailedTest] = []
    skipped = 0
    duration = 0.0
    errors = 0
    failures = 0
    for index, case in enumerate(cases):
        try:
            duration += max(float(case.attrib.get("time", "0")), 0.0)
        except ValueError:
            pass
        if case.find("skipped") is not None:
            skipped += 1
        node = case.find("failure")
        status: Literal["failed", "error"] = "failed"
        if node is None:
            node = case.find("error")
            status = "error"
        if node is None:
            continue
        if status == "failed":
            failures += 1
        else:
            errors += 1
        name = case.attrib.get("name", f"unnamed-{index + 1}")
        classname = case.attrib.get("classname", "")
        case_id = f"{classname}::{name}" if classname else name
        failed_tests.append(FailedTest(
            case_id=case_id,
            name=name,
            classname=classname,
            status=status,
            message=_redact(node.attrib.get("message", ""))[:2000],
            details=_redact(node.text or ""),
        ))
    tests = len(cases)
    passed = max(tests - failures - errors - skipped, 0)
    return TestRunSummary(
        source_format="junit",
        tests=tests,
        passed=passed,
        failures=failures,
        errors=errors,
        skipped=skipped,
        duration_seconds=round(duration, 3),
        failed_tests=failed_tests,
    )


_SUMMARY_ITEM = re.compile(r"(?P<count>\d+)\s+(?P<kind>passed|failed|error|errors|skipped)")
_FAILED_LINE = re.compile(r"^(?P<status>FAILED|ERROR)\s+(?P<case>\S+)(?:\s+-\s+(?P<message>.*))?$", re.MULTILINE)


def parse_pytest_text(path: Path) -> TestRunSummary:
    raw = _read_bounded(path)
    counts = {"passed": 0, "failed": 0, "errors": 0, "skipped": 0}
    for match in _SUMMARY_ITEM.finditer(raw):
        kind = match.group("kind")
        normalized = "errors" if kind in {"error", "errors"} else kind
        counts[normalized] = max(counts[normalized], int(match.group("count")))
    failed_tests: list[FailedTest] = []
    for match in _FAILED_LINE.finditer(raw):
        status = "failed" if match.group("status") == "FAILED" else "error"
        failed_tests.append(FailedTest(
            case_id=match.group("case"),
            name=match.group("case").split("::")[-1],
            status=status,
            message=_redact(match.group("message") or ""),
            details="",
        ))
    failures = max(counts["failed"], sum(item.status == "failed" for item in failed_tests))
    errors = max(counts["errors"], sum(item.status == "error" for item in failed_tests))
    tests = counts["passed"] + failures + errors + counts["skipped"]
    duration_match = re.search(r"in\s+([0-9]+(?:\.[0-9]+)?)s", raw)
    return TestRunSummary(
        source_format="pytest_text",
        tests=tests,
        passed=counts["passed"],
        failures=failures,
        errors=errors,
        skipped=counts["skipped"],
        duration_seconds=float(duration_match.group(1)) if duration_match else 0.0,
        failed_tests=failed_tests,
    )


def parse_test_report(path: Path) -> TestRunSummary:
    if not path.is_file():
        raise ValueError(f"测试结果文件不存在：{path}")
    return parse_junit(path) if path.suffix.lower() == ".xml" else parse_pytest_text(path)
