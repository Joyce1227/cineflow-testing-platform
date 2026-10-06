"""测试设计 Agent 的离线契约、安全边界和四层校验衔接测试。"""

from __future__ import annotations

import json
from pathlib import Path

from ai_testing.test_designer import (
    TestDesignAgent as _TestDesignAgent,
    TestDesignSourceReader as _TestDesignSourceReader,
)


AUTOTEST_ROOT = Path(__file__).resolve().parents[1]
PROJECT_ROOT = AUTOTEST_ROOT.parent


def design_output(*, candidate_path: str = "/api/movies", candidate_method: str = "GET") -> str:
    return f"""
test_plan:
  summary: 覆盖电影查询的功能、异常、边界和访问控制风险。
  risks:
    - 查询参数边界可能处理不一致
  test_points:
    - id: TP-001
      category: positive
      priority: P0
      method: GET
      path: /api/movies
      title: 正常查询电影
      objective: 验证合法分页查询
      expected: 返回成功及电影列表
    - id: TP-002
      category: negative
      priority: P1
      method: GET
      path: /api/movies
      title: 非法分页参数
      objective: 验证错误参数被拒绝
      expected: 返回参数错误
    - id: TP-003
      category: boundary
      priority: P1
      method: GET
      path: /api/movies
      title: 最小分页边界
      objective: 验证最小合法分页值
      expected: 返回成功
    - id: TP-004
      category: authorization
      priority: P1
      method: GET
      path: /api/movies
      title: 匿名访问公开接口
      objective: 验证公开查询不要求身份
      expected: 返回成功且不泄露敏感字段
candidate:
  cases:
    - name: 电影列表正常查询
      tags: [movie, positive]
      request:
        method: {candidate_method}
        path: {candidate_path}
        params:
          pageNum: 1
          pageSize: 5
      expect:
        status: 200
        code: 0
"""


def reader() -> _TestDesignSourceReader:
    return _TestDesignSourceReader(
        openapi_path=PROJECT_ROOT / "cineflow-openapi.json",
        rules_dir=AUTOTEST_ROOT / "ai_knowledge" / "source",
    )


def test_source_reader_limits_openapi_scope_and_loads_rules() -> None:
    source = reader().read(["/api/movies"])

    assert list(source["openapi"]["paths"]) == ["/api/movies"]
    assert {item["source"] for item in source["business_rules"]} == {
        "booking_rules.md", "payment_rules.md", "recommendation_rules.md",
        "refund_rules.md", "review_rules.md",
    }


def test_designer_generates_plan_then_uses_existing_validation_pipeline(tmp_path: Path) -> None:
    captured: dict[str, str] = {}

    def fake_generator(system: str, user: str) -> str:
        captured.update(system=system, user=user)
        return design_output()

    result = _TestDesignAgent(
        source_reader=reader(), generator=fake_generator, output_root=tmp_path
    ).run(["/api/movies"])

    assert result["valid"] is True
    assert result["status"] == "waiting_for_human_review"
    assert result["review_required"] is True
    assert result["executed"] is False
    assert {point["category"] for point in result["test_plan"]["test_points"]} == {
        "positive", "negative", "boundary", "authorization",
    }
    assert Path(result["plan_path"]).is_file()
    assert Path(result["candidate_path"]).is_file()
    assert "只能放无需写数据" in captured["system"]
    assert '"/api/movies"' in captured["user"]
    assert "本次硬性范围" in captured["user"]
    assert captured["user"].rstrip().endswith("- GET /api/movies")


def test_designer_rejects_incomplete_structured_plan_without_running_pipeline(tmp_path: Path) -> None:
    raw = design_output().replace("      category: authorization", "      category: positive")
    result = _TestDesignAgent(
        source_reader=reader(), generator=lambda _system, _user: raw, output_root=tmp_path
    ).run(["/api/movies"])

    assert result["valid"] is False
    assert result["status"] == "design_rejected"
    assert result["executed"] is False
    assert result["candidate_path"] is None
    assert result["errors"][0]["rule"] == "DESIGN_OUTPUT_INVALID"


def test_designer_rejects_operation_outside_selected_scope(tmp_path: Path) -> None:
    result = _TestDesignAgent(
        source_reader=reader(),
        generator=lambda _system, _user: design_output(candidate_path="/health"),
        output_root=tmp_path,
    ).run(["/api/movies"])

    assert result["valid"] is False
    assert result["status"] == "design_rejected"
    assert result["candidate_path"] is None
    assert result["errors"][0]["rule"] == "DESIGN_OPERATION_OUT_OF_SCOPE"


def test_designer_candidate_is_still_rejected_by_business_validation(tmp_path: Path) -> None:
    result = _TestDesignAgent(
        source_reader=reader(),
        generator=lambda _system, _user: design_output(candidate_path="/api/admin/health"),
        output_root=tmp_path,
    ).run(["/api/movies", "/api/admin/health"])

    assert result["valid"] is False
    assert result["status"] == "rejected"
    assert result["executed"] is False
    assert any(error["rule"] == "CF-AI-004" for error in result["errors"])


def test_plan_file_contains_only_structured_plan(tmp_path: Path) -> None:
    result = _TestDesignAgent(
        source_reader=reader(), generator=lambda _system, _user: design_output(), output_root=tmp_path
    ).run(["/api/movies"])

    saved = json.loads(Path(result["plan_path"]).read_text(encoding="utf-8"))
    assert set(saved) == {"summary", "risks", "test_points"}
    assert "candidate" not in saved
