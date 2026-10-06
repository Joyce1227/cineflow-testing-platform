"""pytest 白名单执行器的命令、审批和超时边界测试。"""

from __future__ import annotations

import subprocess
from pathlib import Path

from ai_testing.safe_pytest_runner import SafePytestRunner as _SafePytestRunner


def test_runner_uses_fixed_argv_shell_false_and_writes_junit(tmp_path: Path) -> None:
    captured: dict = {}

    def fake_executor(command, **kwargs):
        captured.update(command=command, kwargs=kwargs)
        junit_arg = next(item for item in command if item.startswith("--junitxml="))
        Path(junit_arg.split("=", 1)[1]).write_text(
            '<testsuite><testcase name="ok" /></testsuite>', encoding="utf-8"
        )
        return subprocess.CompletedProcess(command, 0, stdout="1 passed", stderr="")

    runner = _SafePytestRunner(
        project_root=tmp_path,
        output_root=tmp_path / "reports",
        executor=fake_executor,
        python_executable="python-safe",
    )
    result = runner.run("smoke", approved_by="qa-reviewer")

    assert captured["command"][:5] == ["python-safe", "-m", "pytest", "-m", "smoke"]
    assert captured["kwargs"]["shell"] is False
    assert captured["kwargs"]["check"] is False
    assert result["status"] == "passed"
    assert result["executed"] is True
    assert Path(result["junit_path"]).is_file()
    assert Path(result["result_path"]).is_file()


def test_runner_rejects_unknown_suite_without_calling_executor(tmp_path: Path) -> None:
    called = False

    def fake_executor(*_args, **_kwargs):
        nonlocal called
        called = True
        raise AssertionError("不应执行")

    runner = _SafePytestRunner(project_root=tmp_path, output_root=tmp_path / "out", executor=fake_executor)
    try:
        runner.run("tests/test_anything.py;whoami", approved_by="qa")
    except ValueError as exc:
        assert "未知测试套件" in str(exc)
    else:
        raise AssertionError("任意 pytest 参数必须被拒绝")
    assert called is False


def test_runner_requires_explicit_human_approval(tmp_path: Path) -> None:
    runner = _SafePytestRunner(project_root=tmp_path, output_root=tmp_path / "out")
    try:
        runner.run("movie", approved_by="  ")
    except ValueError as exc:
        assert "人工确认人" in str(exc)
    else:
        raise AssertionError("未确认的测试不得执行")


def test_runner_records_timeout_without_retrying(tmp_path: Path) -> None:
    def timeout_executor(*_args, **_kwargs):
        raise subprocess.TimeoutExpired(cmd="pytest", timeout=5, output="partial")

    runner = _SafePytestRunner(
        project_root=tmp_path,
        output_root=tmp_path / "out",
        executor=timeout_executor,
        timeout_seconds=5,
    )
    result = runner.run("regression", approved_by="qa")

    assert result["status"] == "timeout"
    assert result["return_code"] is None
    assert result["junit_path"] is None
    assert "partial" in Path(result["output_path"]).read_text(encoding="utf-8")
