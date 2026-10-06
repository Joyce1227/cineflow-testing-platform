"""测试设计、人工确认、安全执行和结果分析的最小工作流。"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

from ai_testing.result_analyzer import ResultAnalysisAgent
from ai_testing.safe_pytest_runner import ALLOWED_SUITES, SafePytestRunner
from ai_testing.test_designer import TestDesignAgent


class FunctionalTestingWorkflow:
    def __init__(
        self,
        *,
        designer: TestDesignAgent | None = None,
        runner: SafePytestRunner | None = None,
        analyzer: ResultAnalysisAgent | None = None,
    ) -> None:
        self.designer = designer or TestDesignAgent()
        self.runner = runner or SafePytestRunner()
        self.analyzer = analyzer or ResultAnalysisAgent()

    def design(self, paths: list[str] | None = None) -> dict[str, Any]:
        return self.designer.run(paths)

    @staticmethod
    def _load_reviewed_design(report_path: Path) -> dict[str, Any]:
        if not report_path.is_file():
            raise ValueError(f"测试设计校验报告不存在：{report_path}")
        if report_path.stat().st_size > 1024 * 1024:
            raise ValueError("测试设计校验报告超过 1 MiB 限制")
        try:
            report = json.loads(report_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError as exc:
            raise ValueError(f"测试设计校验报告不是合法 JSON：{exc}") from exc
        required = {
            "valid": True,
            "status": "waiting_for_human_review",
            "review_required": True,
            "executed": False,
        }
        if not isinstance(report, dict) or any(report.get(key) != value for key, value in required.items()):
            raise ValueError("只有通过四层校验且等待人工复核的测试设计才能执行")
        candidate = report.get("candidate_path")
        if not isinstance(candidate, str) or not Path(candidate).is_file():
            raise ValueError("测试设计校验报告没有有效的候选用例文件")
        return report

    def execute_reviewed(
        self,
        design_report: Path,
        *,
        suite: str,
        approved_by: str,
        analyze: bool = True,
    ) -> dict[str, Any]:
        design = self._load_reviewed_design(design_report)
        execution = self.runner.run(suite, approved_by=approved_by)
        analysis = None
        can_analyze = execution["status"] in {"passed", "test_failures"} or (
            execution["status"] == "execution_error" and execution.get("junit_path") is not None
        )
        if analyze and can_analyze:
            analysis = self.analyzer.run(Path(execution["analysis_source"]))
        if execution["status"] == "passed":
            status = "completed"
        elif execution["status"] == "test_failures" and analysis is not None:
            status = "completed_with_failures"
        elif execution["status"] == "execution_error" and analysis is not None:
            status = "completed_with_execution_error"
        else:
            status = "execution_incomplete"
        return {
            "status": status,
            "design_report": str(design_report),
            "candidate_path": design["candidate_path"],
            "approved_by": approved_by.strip(),
            "execution": execution,
            "analysis": analysis,
        }

    def analyze(self, report_path: Path) -> dict[str, Any]:
        return self.analyzer.run(report_path)


def main() -> int:
    parser = argparse.ArgumentParser(description="CineFlow AI 辅助功能测试工作流")
    subparsers = parser.add_subparsers(dest="command", required=True)

    design_parser = subparsers.add_parser("design", help="生成测试计划和候选用例")
    design_parser.add_argument("--path", action="append", dest="paths")

    run_parser = subparsers.add_parser("run", help="人工确认后运行白名单套件并分析结果")
    run_parser.add_argument("design_report", type=Path, help="四层校验通过的候选报告 JSON")
    run_parser.add_argument("--suite", required=True, choices=sorted(ALLOWED_SUITES))
    run_parser.add_argument("--approved-by", required=True)
    run_parser.add_argument("--no-analyze", action="store_true")

    analyze_parser = subparsers.add_parser("analyze", help="单独分析已有测试报告")
    analyze_parser.add_argument("report", type=Path)

    args = parser.parse_args()
    workflow = FunctionalTestingWorkflow()
    try:
        if args.command == "design":
            result = workflow.design(args.paths)
        elif args.command == "run":
            result = workflow.execute_reviewed(
                args.design_report,
                suite=args.suite,
                approved_by=args.approved_by,
                analyze=not args.no_analyze,
            )
        else:
            result = workflow.analyze(args.report)
    except ValueError as exc:
        print(json.dumps({"status": "input_error", "message": str(exc)}, ensure_ascii=False, indent=2))
        return 2
    print(json.dumps(result, ensure_ascii=False, indent=2))
    failing_statuses = {
        "execution_incomplete", "completed_with_failures", "completed_with_execution_error"
    }
    return 0 if result.get("valid", True) and result.get("status") not in failing_statuses else 1


if __name__ == "__main__":
    raise SystemExit(main())
