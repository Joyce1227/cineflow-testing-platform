"""功能测试工作流的人工审批断点和阶段编排测试。"""

from __future__ import annotations

import json
from pathlib import Path

from workflows.functional_testing import FunctionalTestingWorkflow as _Workflow


class FakeRunner:
    def __init__(self, source: Path) -> None:
        self.source = source
        self.calls: list[tuple[str, str]] = []

    def run(self, suite: str, *, approved_by: str):
        self.calls.append((suite, approved_by))
        return {
            "status": "test_failures",
            "analysis_source": str(self.source),
            "executed": True,
        }


class FakeAnalyzer:
    def __init__(self) -> None:
        self.calls: list[Path] = []

    def run(self, source: Path):
        self.calls.append(source)
        return {"valid": True, "status": "waiting_for_human_review", "report_path": "report.md"}


def reviewed_design(tmp_path: Path, **overrides) -> Path:
    candidate = tmp_path / "candidate.yaml"
    candidate.write_text("cases: []", encoding="utf-8")
    value = {
        "valid": True,
        "status": "waiting_for_human_review",
        "review_required": True,
        "executed": False,
        "candidate_path": str(candidate),
        **overrides,
    }
    report = tmp_path / "validation.report.json"
    report.write_text(json.dumps(value), encoding="utf-8")
    return report


def test_workflow_runs_only_reviewed_design_then_analyzes(tmp_path: Path) -> None:
    junit = tmp_path / "junit.xml"
    junit.write_text("<testsuite />", encoding="utf-8")
    runner = FakeRunner(junit)
    analyzer = FakeAnalyzer()
    workflow = _Workflow(runner=runner, analyzer=analyzer)

    result = workflow.execute_reviewed(
        reviewed_design(tmp_path), suite="smoke", approved_by="qa-lead"
    )

    assert result["status"] == "completed_with_failures"
    assert runner.calls == [("smoke", "qa-lead")]
    assert analyzer.calls == [junit]
    assert result["approved_by"] == "qa-lead"


def test_workflow_rejects_unvalidated_design_before_execution(tmp_path: Path) -> None:
    runner = FakeRunner(tmp_path / "never.xml")
    workflow = _Workflow(runner=runner, analyzer=FakeAnalyzer())
    report = reviewed_design(tmp_path, valid=False, status="rejected")

    try:
        workflow.execute_reviewed(report, suite="smoke", approved_by="qa")
    except ValueError as exc:
        assert "通过四层校验" in str(exc)
    else:
        raise AssertionError("校验失败的候选不得执行")
    assert runner.calls == []


def test_workflow_can_stop_after_execution_without_agent_analysis(tmp_path: Path) -> None:
    source = tmp_path / "pytest.txt"
    source.write_text("1 failed", encoding="utf-8")
    runner = FakeRunner(source)
    analyzer = FakeAnalyzer()
    workflow = _Workflow(runner=runner, analyzer=analyzer)

    result = workflow.execute_reviewed(
        reviewed_design(tmp_path), suite="movie", approved_by="qa", analyze=False
    )

    assert result["status"] == "execution_incomplete"
    assert result["analysis"] is None
    assert analyzer.calls == []
