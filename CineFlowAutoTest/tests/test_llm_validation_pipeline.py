from pathlib import Path

import pytest

from llm.pipeline import ValidationPipeline


AUTOTEST_ROOT = Path(__file__).resolve().parents[1]
SAMPLE_ROOT = AUTOTEST_ROOT / "evals" / "datasets" / "structured_output"


@pytest.mark.parametrize(
    ("filename", "expected_layer", "expected_rule"),
    [
        ("01_bad_indent.yaml", "syntax", "YAML_PARSE_ERROR"),
        ("02_unclosed_fence.txt", "syntax", "MARKDOWN_FENCE_INVALID"),
        ("03_root_not_cases.yaml", "structure", None),
        ("04_cases_not_list.yaml", "structure", None),
        ("05_missing_name.yaml", "structure", None),
        ("06_missing_path.yaml", "structure", None),
        ("07_fetch_method.yaml", "structure", None),
        ("08_invalid_status.yaml", "structure", None),
        ("09_unknown_path.yaml", "openapi", "OPENAPI_PATH_NOT_FOUND"),
        ("10_wrong_method.yaml", "openapi", "OPENAPI_METHOD_NOT_ALLOWED"),
        (
            "11_unknown_query.yaml",
            "openapi",
            "OPENAPI_QUERY_PARAMETER_NOT_FOUND",
        ),
        ("12_unapproved_write.yaml", "business", "CF-AI-003"),
    ],
)
def test_pipeline_rejects_required_error_samples(
    tmp_path: Path,
    filename: str,
    expected_layer: str,
    expected_rule: str | None,
) -> None:
    raw_output = (SAMPLE_ROOT / filename).read_text(encoding="utf-8")
    result = ValidationPipeline(output_root=tmp_path).validate(raw_output)

    assert result["valid"] is False
    assert result["status"] == "rejected"
    assert result["executed"] is False
    assert Path(result["raw_path"]).read_text(encoding="utf-8") == raw_output
    assert Path(result["report_path"]).is_file()
    assert any(error["layer"] == expected_layer for error in result["errors"])
    if expected_rule is not None:
        assert any(error["rule"] == expected_rule for error in result["errors"])


def test_pipeline_saves_valid_case_for_human_review(tmp_path: Path) -> None:
    raw_output = (SAMPLE_ROOT / "00_valid.yaml").read_text(encoding="utf-8")
    result = ValidationPipeline(output_root=tmp_path).validate(raw_output)

    assert result["valid"] is True
    assert result["status"] == "waiting_for_human_review"
    assert result["review_required"] is True
    assert result["executed"] is False
    assert result["errors"] == []
    assert Path(result["raw_path"]).is_file()
    assert Path(result["candidate_path"]).is_file()
    assert Path(result["report_path"]).is_file()
