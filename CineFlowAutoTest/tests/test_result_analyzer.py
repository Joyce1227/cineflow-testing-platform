"""结果解析器、结果分析 Agent 和 Markdown 报告的离线测试。"""

from __future__ import annotations

from pathlib import Path

from ai_testing.report_parser import parse_test_report
from ai_testing.result_analyzer import ResultAnalysisAgent as _ResultAnalysisAgent


FAILED_JUNIT = """<?xml version="1.0" encoding="utf-8"?>
<testsuite name="cineflow" tests="3" failures="1" errors="1" skipped="0" time="0.8">
  <testcase classname="tests.test_movie" name="test_list" time="0.1" />
  <testcase classname="tests.test_movie" name="test_detail" time="0.2">
    <failure message="assert 500 == 200">E AssertionError: assert 500 == 200\nAuthorization: Bearer private-token</failure>
  </testcase>
  <testcase classname="tests.test_auth" name="test_login" time="0.5">
    <error message="ConnectionError: database unavailable">connection refused password=secret123</error>
  </testcase>
</testsuite>
"""


ANALYSIS_OUTPUT = """
overview: 一个接口断言失败，另一个用例受数据库连接问题影响。
failure_analyses:
  - case_id: tests.test_movie::test_detail
    category: product_defect
    confidence: medium
    expected: HTTP 200
    actual: HTTP 500
    evidence: 断言显示 500 与 200 不相等
    root_cause: 接口返回服务端错误，仍需结合服务日志确认
    retest_suggestion: 修复后使用相同数据复测详情接口
  - case_id: tests.test_auth::test_login
    category: environment
    confidence: high
    expected: 登录接口可连接数据库
    actual: 数据库连接被拒绝
    evidence: 报告包含 ConnectionError 和 database unavailable
    root_cause: 测试环境数据库不可用
    retest_suggestion: 确认数据库健康后重新执行登录用例
recommendations:
  - 先恢复数据库，再单独复测两个失败用例
"""


def write_report(tmp_path: Path, content: str = FAILED_JUNIT, name: str = "junit.xml") -> Path:
    path = tmp_path / name
    path.write_text(content, encoding="utf-8")
    return path


def test_junit_parser_extracts_counts_failures_and_redacts_secrets(tmp_path: Path) -> None:
    summary = parse_test_report(write_report(tmp_path))

    assert summary.tests == 3
    assert summary.passed == 1
    assert summary.failures == 1
    assert summary.errors == 1
    assert [item.case_id for item in summary.failed_tests] == [
        "tests.test_movie::test_detail", "tests.test_auth::test_login",
    ]
    assert "private-token" not in summary.failed_tests[0].details
    assert "secret123" not in summary.failed_tests[1].details
    assert "<redacted>" in summary.failed_tests[1].details


def test_pytest_text_parser_reads_short_summary(tmp_path: Path) -> None:
    path = write_report(
        tmp_path,
        "FAILED tests/test_movie.py::test_detail - assert 500 == 200\n"
        "================ 1 failed, 2 passed, 1 skipped in 1.25s ================",
        "pytest.txt",
    )
    summary = parse_test_report(path)

    assert (summary.tests, summary.passed, summary.failures, summary.skipped) == (4, 2, 1, 1)
    assert summary.duration_seconds == 1.25
    assert summary.failed_tests[0].case_id == "tests/test_movie.py::test_detail"


def test_result_analyzer_classifies_every_failure_and_writes_markdown(tmp_path: Path) -> None:
    captured: dict[str, str] = {}

    def fake_generator(system: str, user: str) -> str:
        captured.update(system=system, user=user)
        return ANALYSIS_OUTPUT

    source = write_report(tmp_path)
    result = _ResultAnalysisAgent(generator=fake_generator, output_root=tmp_path / "out").run(source)

    assert result["valid"] is True
    assert result["status"] == "waiting_for_human_review"
    assert result["review_required"] is True
    assert result["executed"] is False
    markdown = Path(result["report_path"]).read_text(encoding="utf-8")
    assert "# CineFlow 自动化测试分析报告" in markdown
    assert "产品缺陷" in markdown
    assert "环境问题" in markdown
    assert "private-token" not in captured["user"]
    assert "测试结果事实" in captured["user"]


def test_result_analyzer_rejects_missing_or_fabricated_case_ids(tmp_path: Path) -> None:
    invalid = ANALYSIS_OUTPUT.replace(
        "tests.test_auth::test_login", "tests.test_auth::fabricated_case"
    )
    result = _ResultAnalysisAgent(
        generator=lambda _system, _user: invalid,
        output_root=tmp_path / "out",
    ).run(write_report(tmp_path))

    assert result["valid"] is False
    assert result["status"] == "analysis_rejected"
    assert result["report_path"] is None
    rules = {error["rule"] for error in result["errors"]}
    assert rules == {"MISSING_FAILURE_ANALYSIS", "UNKNOWN_CASE_ID"}


def test_all_passed_report_skips_llm_and_still_writes_summary(tmp_path: Path) -> None:
    passed = """<testsuite name="ok" tests="1" failures="0" errors="0" skipped="0">
      <testcase classname="tests.test_health" name="test_health" time="0.1" />
    </testsuite>"""

    def should_not_run(_system: str, _user: str) -> str:
        raise AssertionError("全通过报告不应调用模型")

    result = _ResultAnalysisAgent(
        generator=should_not_run, output_root=tmp_path / "out"
    ).run(write_report(tmp_path, passed))

    assert result["valid"] is True
    assert result["summary"]["passed"] == 1
    assert "**通过**" in Path(result["report_path"]).read_text(encoding="utf-8")


def test_junit_parser_rejects_doctype(tmp_path: Path) -> None:
    path = write_report(tmp_path, "<!DOCTYPE foo><testsuite />")

    try:
        parse_test_report(path)
    except ValueError as exc:
        assert "DOCTYPE" in str(exc)
    else:
        raise AssertionError("包含 DOCTYPE 的报告必须被拒绝")


def test_analyzer_rejects_truncated_pytest_summary(tmp_path: Path) -> None:
    source = write_report(tmp_path, "1 failed, 2 passed in 0.5s", "truncated.txt")

    try:
        _ResultAnalysisAgent(output_root=tmp_path / "out").run(source)
    except ValueError as exc:
        assert "缺少对应的失败用例摘要" in str(exc)
    else:
        raise AssertionError("缺少失败明细的报告不能进入模型分析")
