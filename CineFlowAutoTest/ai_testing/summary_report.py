"""把可信测试统计和已校验的失败分析渲染为 Markdown。"""

from __future__ import annotations

from datetime import datetime, timezone

from ai_testing.report_parser import TestRunSummary


CATEGORY_LABELS = {
    "environment": "环境问题",
    "test_code": "测试代码问题",
    "product_defect": "产品缺陷",
    "unknown": "待确认",
}


def render_markdown(summary: TestRunSummary, analysis: dict) -> str:
    outcome = "通过" if summary.failures == 0 and summary.errors == 0 else "未通过"
    lines = [
        "# CineFlow 自动化测试分析报告",
        "",
        f"> 生成时间：{datetime.now(timezone.utc).isoformat()}  ",
        f"> 结果来源：{summary.source_format}  ",
        f"> 总体结论：**{outcome}**",
        "",
        "## 执行概览",
        "",
        "| 总数 | 通过 | 失败 | 错误 | 跳过 | 耗时（秒） |",
        "|---:|---:|---:|---:|---:|---:|",
        f"| {summary.tests} | {summary.passed} | {summary.failures} | {summary.errors} | {summary.skipped} | {summary.duration_seconds:.3f} |",
        "",
        "## 分析结论",
        "",
        analysis["overview"],
        "",
    ]
    failures = analysis.get("failure_analyses", [])
    if failures:
        lines.extend(["## 失败明细", ""])
        for item in failures:
            lines.extend([
                f"### {item['case_id']}",
                "",
                f"- 分类：{CATEGORY_LABELS[item['category']]}（置信度：{item['confidence']}）",
                f"- 预期结果：{item['expected']}",
                f"- 实际结果：{item['actual']}",
                f"- 判断依据：{item['evidence']}",
                f"- 根因判断：{item['root_cause']}",
                f"- 复测建议：{item['retest_suggestion']}",
                "",
            ])
    lines.extend(["## 后续建议", ""])
    recommendations = analysis.get("recommendations", [])
    lines.extend([f"- {item}" for item in recommendations] or ["- 暂无额外建议。"])
    lines.extend([
        "",
        "---",
        "本报告由结果分析 Agent 辅助生成；缺陷归因需由测试或研发人员复核。",
        "",
    ])
    return "\n".join(lines)
