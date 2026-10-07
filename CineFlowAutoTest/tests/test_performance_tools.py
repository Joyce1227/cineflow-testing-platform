import csv

import pytest

from performance.cleanup_performance_data import _ensure_safe_target
from performance.prepare_performance_data import prepare
from performance.summarize_jtl import percentile, summarize


def test_percentile_uses_nearest_rank():
    assert percentile([10, 20, 30, 40], 0.95) == 40
    assert percentile([], 0.95) == 0


def test_jtl_summary_reports_latency_throughput_and_errors(tmp_path):
    jtl = tmp_path / "results.jtl"
    fields = ["timeStamp", "elapsed", "label", "responseCode", "success"]
    with jtl.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields)
        writer.writeheader()
        writer.writerows([
            {"timeStamp": "1000", "elapsed": "100", "label": "GET Movies", "responseCode": "200", "success": "true"},
            {"timeStamp": "1100", "elapsed": "300", "label": "GET Movies", "responseCode": "500", "success": "false"},
        ])

    result = summarize(jtl)

    assert result["overall"]["samples"] == 2
    assert result["overall"]["errorRatePercent"] == 50
    assert result["overall"]["p95Ms"] == 300
    assert result["overall"]["throughputPerSecond"] == 5


def test_cleanup_rejects_remote_database_by_default():
    with pytest.raises(ValueError, match="Refusing to clean remote database"):
        _ensure_safe_target("mysql+pymysql://user:pass@db.example.com/cineflow", allow_remote=False)


def test_data_preparation_requires_contention_users(tmp_path):
    with pytest.raises(ValueError, match="at least 2"):
        prepare("http://127.0.0.1:8000", tmp_path, 1, "admin", "Admin123")
