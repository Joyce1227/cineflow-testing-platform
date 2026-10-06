"""只允许执行预定义测试套件的 pytest 安全执行器。"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from collections.abc import Callable, Sequence
from datetime import datetime, timezone
from pathlib import Path
from typing import Any
from uuid import uuid4


ALLOWED_SUITES: dict[str, tuple[str, ...]] = {
    "smoke": ("-m", "smoke"),
    "movie": ("tests/test_movie_api.py",),
    "regression": ("-m", "regression"),
}


class SafePytestRunner:
    """构造固定 argv 并以 ``shell=False`` 执行，不接受任意 pytest 参数。"""

    def __init__(
        self,
        *,
        project_root: Path | None = None,
        output_root: Path | None = None,
        timeout_seconds: int = 900,
        executor: Callable[..., subprocess.CompletedProcess[str]] = subprocess.run,
        python_executable: str | None = None,
    ) -> None:
        self.project_root = (project_root or Path(__file__).resolve().parents[1]).resolve()
        self.output_root = (output_root or self.project_root / "reports" / "executions").resolve()
        if not 1 <= timeout_seconds <= 3600:
            raise ValueError("pytest 超时必须在 1 到 3600 秒之间")
        self.timeout_seconds = timeout_seconds
        self.executor = executor
        self.python_executable = python_executable or sys.executable

    @staticmethod
    def _run_id() -> str:
        stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
        return f"{stamp}-{uuid4().hex[:8]}"

    def build_command(self, suite: str, junit_path: Path) -> list[str]:
        if suite not in ALLOWED_SUITES:
            raise ValueError(
                f"未知测试套件：{suite}；只允许：{', '.join(sorted(ALLOWED_SUITES))}"
            )
        return [
            self.python_executable,
            "-m",
            "pytest",
            *ALLOWED_SUITES[suite],
            f"--junitxml={junit_path}",
        ]

    def run(self, suite: str, *, approved_by: str) -> dict[str, Any]:
        reviewer = approved_by.strip()
        if not reviewer:
            raise ValueError("执行 pytest 前必须提供人工确认人 approved_by")
        if suite not in ALLOWED_SUITES:
            raise ValueError(
                f"未知测试套件：{suite}；只允许：{', '.join(sorted(ALLOWED_SUITES))}"
            )
        run_id = self._run_id()
        run_dir = self.output_root / run_id
        run_dir.mkdir(parents=True, exist_ok=False)
        junit_path = run_dir / "junit.xml"
        output_path = run_dir / "pytest-output.txt"
        command = self.build_command(suite, junit_path)
        try:
            completed = self.executor(
                command,
                cwd=self.project_root,
                shell=False,
                capture_output=True,
                text=True,
                timeout=self.timeout_seconds,
                check=False,
            )
            stdout = completed.stdout or ""
            stderr = completed.stderr or ""
            output_path.write_text(
                stdout + ("\n[stderr]\n" + stderr if stderr else ""), encoding="utf-8"
            )
            return_code = completed.returncode
            status = "passed" if return_code == 0 else "test_failures" if return_code == 1 else "execution_error"
        except subprocess.TimeoutExpired as exc:
            stdout = exc.stdout.decode(errors="replace") if isinstance(exc.stdout, bytes) else (exc.stdout or "")
            stderr = exc.stderr.decode(errors="replace") if isinstance(exc.stderr, bytes) else (exc.stderr or "")
            output_path.write_text(
                stdout + ("\n[stderr]\n" + stderr if stderr else ""), encoding="utf-8"
            )
            return_code = None
            status = "timeout"
        result = {
            "run_id": run_id,
            "status": status,
            "suite": suite,
            "approved_by": reviewer,
            "executed": True,
            "return_code": return_code,
            "junit_path": str(junit_path) if junit_path.is_file() else None,
            "output_path": str(output_path),
            "analysis_source": str(junit_path if junit_path.is_file() else output_path),
            "command": command,
        }
        result_path = run_dir / "execution.json"
        result_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
        result["result_path"] = str(result_path)
        return result


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="执行预定义 CineFlow pytest 套件")
    parser.add_argument("suite", choices=sorted(ALLOWED_SUITES), help="白名单测试套件")
    parser.add_argument("--approved-by", required=True, help="人工确认人")
    parser.add_argument("--output-root", type=Path, default=None, help="执行结果目录")
    args = parser.parse_args(argv)
    try:
        result = SafePytestRunner(output_root=args.output_root).run(
            args.suite, approved_by=args.approved_by
        )
    except ValueError as exc:
        print(json.dumps({"status": "input_error", "message": str(exc)}, ensure_ascii=False, indent=2))
        return 2
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if result["status"] == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
