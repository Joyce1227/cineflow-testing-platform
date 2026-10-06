from __future__ import annotations

import argparse
import json
from datetime import datetime, timezone
from pathlib import Path
from typing import Any
from uuid import uuid4

import yaml
from pydantic import ValidationError

from llm.models import GeneratedCases, ValidationIssue
from llm.validators.business_rules import validate_case_business_rules
from llm.validators.openapi_contract import validate_case_against_openapi
from llm.validators.structure import pydantic_issues, strip_markdown_fence


OPENAPI_RELATIVE_PATH = Path("docs/api/cineflow-openapi.json")


def find_project_root(start: Path) -> Path:
    for directory in (start, *start.parents):
        if (directory / OPENAPI_RELATIVE_PATH).is_file():
            return directory
    raise FileNotFoundError(f"从 {start} 向上没有找到 {OPENAPI_RELATIVE_PATH.as_posix()}")


def _run_id() -> str:
    timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
    return f"{timestamp}-{uuid4().hex[:8]}"


class ValidationPipeline:
    """Treat model output as untrusted and validate it without executing it."""

    def __init__(
        self,
        openapi_path: Path | None = None,
        output_root: Path | None = None,
    ) -> None:
        module_path = Path(__file__).resolve()
        project_root = find_project_root(module_path)
        autotest_root = module_path.parents[1]
        self.openapi_path = openapi_path or project_root / OPENAPI_RELATIVE_PATH
        self.output_root = output_root or autotest_root / "generated"
        self.openapi = self._load_openapi()

    def _load_openapi(self) -> dict[str, Any]:
        try:
            data = json.loads(self.openapi_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError as exc:
            raise ValueError(f"OpenAPI 文件不是合法 JSON：{exc}") from exc
        if not isinstance(data, dict) or not isinstance(data.get("paths"), dict):
            raise ValueError("OpenAPI 文件缺少对象类型的 paths 字段")
        return data

    def _prepare_directories(self) -> None:
        for name in ("raw", "candidates", "rejected"):
            (self.output_root / name).mkdir(parents=True, exist_ok=True)

    @staticmethod
    def _yaml_location(error: yaml.YAMLError) -> str:
        mark = getattr(error, "problem_mark", None)
        if mark is None:
            return "$"
        return f"line.{mark.line + 1}.column.{mark.column + 1}"

    @staticmethod
    def _issue_dicts(issues: list[ValidationIssue]) -> list[dict[str, Any]]:
        return [issue.model_dump() for issue in issues]

    def _write_report(self, directory: str, run_id: str, report: dict[str, Any]) -> Path:
        report_path = self.output_root / directory / f"{run_id}.report.json"
        report_path.write_text(
            json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8"
        )
        return report_path

    def _reject(
        self,
        run_id: str,
        raw_path: Path,
        issues: list[ValidationIssue],
    ) -> dict[str, Any]:
        report: dict[str, Any] = {
            "run_id": run_id,
            "valid": False,
            "status": "rejected",
            "raw_path": str(raw_path),
            "candidate_path": None,
            "review_required": True,
            "executed": False,
            "errors": self._issue_dicts(issues),
        }
        report_path = self._write_report("rejected", run_id, report)
        report["report_path"] = str(report_path)
        return report

    def validate(self, raw_output: str) -> dict[str, Any]:
        self._prepare_directories()
        run_id = _run_id()
        raw_path = self.output_root / "raw" / f"{run_id}.txt"
        raw_path.write_text(raw_output, encoding="utf-8")

        try:
            cleaned = strip_markdown_fence(raw_output)
        except ValueError as exc:
            return self._reject(
                run_id,
                raw_path,
                [
                    ValidationIssue(
                        layer="syntax",
                        location="$",
                        rule="MARKDOWN_FENCE_INVALID",
                        message=str(exc),
                    )
                ],
            )

        try:
            parsed = yaml.safe_load(cleaned)
        except yaml.YAMLError as exc:
            return self._reject(
                run_id,
                raw_path,
                [
                    ValidationIssue(
                        layer="syntax",
                        location=self._yaml_location(exc),
                        rule="YAML_PARSE_ERROR",
                        message=str(exc),
                    )
                ],
            )

        try:
            generated = GeneratedCases.model_validate(parsed)
        except ValidationError as exc:
            return self._reject(run_id, raw_path, pydantic_issues(exc))

        issues: list[ValidationIssue] = []
        for index, case in enumerate(generated.cases):
            issues.extend(validate_case_against_openapi(self.openapi, index, case))
            issues.extend(validate_case_business_rules(index, case))

        if issues:
            return self._reject(run_id, raw_path, issues)

        candidate_path = self.output_root / "candidates" / f"{run_id}.yaml"
        candidate_path.write_text(
            yaml.safe_dump(
                generated.model_dump(by_alias=True, exclude_none=True),
                allow_unicode=True,
                sort_keys=False,
            ),
            encoding="utf-8",
        )
        report: dict[str, Any] = {
            "run_id": run_id,
            "valid": True,
            "status": "waiting_for_human_review",
            "raw_path": str(raw_path),
            "candidate_path": str(candidate_path),
            "review_required": True,
            "executed": False,
            "errors": [],
        }
        report_path = self._write_report("candidates", run_id, report)
        report["report_path"] = str(report_path)
        return report


def main() -> None:
    parser = argparse.ArgumentParser(description="校验不可信的 AI YAML 测试用例")
    parser.add_argument("input", type=Path, help="模型原始输出文件")
    parser.add_argument("--output-root", type=Path, default=None, help="生成物目录")
    args = parser.parse_args()

    result = ValidationPipeline(output_root=args.output_root).validate(
        args.input.read_text(encoding="utf-8")
    )
    print(json.dumps(result, ensure_ascii=False, indent=2))
    if not result["valid"]:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
