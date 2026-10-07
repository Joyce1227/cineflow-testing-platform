from __future__ import annotations

import argparse
import csv
import json
import math
from collections import defaultdict
from pathlib import Path


def percentile(values: list[int], percent: float) -> int:
    if not values:
        return 0
    ordered = sorted(values)
    return ordered[max(0, math.ceil(percent * len(ordered)) - 1)]


def summarize(jtl_path: Path) -> dict:
    rows: list[dict] = []
    with jtl_path.open(newline="", encoding="utf-8-sig") as handle:
        rows.extend(csv.DictReader(handle))
    if not rows:
        raise ValueError(f"No samples found in {jtl_path}")

    grouped: dict[str, list[dict]] = defaultdict(list)
    for row in rows:
        grouped[row.get("label", "unknown")].append(row)

    # Transaction controllers and internal setup/assertion samplers are useful
    # diagnostics but are not HTTP requests. Exclude them from the overall
    # throughput/latency figures to avoid double-counting child requests.
    request_rows = [
        row for row in rows
        if not row.get("label", "").startswith(("TX ", "ASSERT ", "Reset "))
    ]
    if not request_rows:
        request_rows = rows
    timestamps = [int(row["timeStamp"]) for row in request_rows]
    elapsed = [int(row["elapsed"]) for row in request_rows]
    wall_seconds = max(0.001, (max(timestamps) + max(elapsed) - min(timestamps)) / 1000)

    def metrics(samples: list[dict]) -> dict:
        times = [int(item["elapsed"]) for item in samples]
        failures = sum(item.get("success", "false").lower() != "true" for item in samples)
        return {
            "samples": len(samples),
            "errors": failures,
            "errorRatePercent": round(failures * 100 / len(samples), 4),
            "averageMs": round(sum(times) / len(times), 2),
            "p90Ms": percentile(times, 0.90),
            "p95Ms": percentile(times, 0.95),
            "p99Ms": percentile(times, 0.99),
            "maxMs": max(times),
        }

    overall = metrics(request_rows)
    overall["throughputPerSecond"] = round(len(request_rows) / wall_seconds, 2)
    return {"overall": overall, "labels": {name: metrics(samples) for name, samples in sorted(grouped.items())}}


def markdown(summary: dict) -> str:
    overall = summary["overall"]
    lines = [
        "# CineFlow Performance Summary",
        "",
        "## Overall",
        "",
        "| Samples | Error rate | Throughput/s | Average | P90 | P95 | P99 | Max |",
        "|---:|---:|---:|---:|---:|---:|---:|---:|",
        f"| {overall['samples']} | {overall['errorRatePercent']}% | {overall['throughputPerSecond']} | "
        f"{overall['averageMs']} ms | {overall['p90Ms']} ms | {overall['p95Ms']} ms | "
        f"{overall['p99Ms']} ms | {overall['maxMs']} ms |",
        "",
        "## By sampler",
        "",
        "| Sampler | Samples | Errors | Error rate | Average | P95 | P99 | Max |",
        "|---|---:|---:|---:|---:|---:|---:|---:|",
    ]
    for label, item in summary["labels"].items():
        lines.append(
            f"| {label.replace('|', '/')} | {item['samples']} | {item['errors']} | "
            f"{item['errorRatePercent']}% | {item['averageMs']} ms | {item['p95Ms']} ms | "
            f"{item['p99Ms']} ms | {item['maxMs']} ms |"
        )
    return "\n".join(lines) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(description="Summarize JMeter CSV results and enforce an error-rate gate.")
    parser.add_argument("--jtl", type=Path, required=True)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--max-error-rate", type=float, default=0.0)
    args = parser.parse_args()

    summary = summarize(args.jtl)
    args.output_dir.mkdir(parents=True, exist_ok=True)
    (args.output_dir / "summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    (args.output_dir / "summary.md").write_text(markdown(summary), encoding="utf-8")
    print(markdown(summary))
    if summary["overall"]["errorRatePercent"] > args.max_error_rate:
        raise SystemExit(
            f"Error-rate gate failed: {summary['overall']['errorRatePercent']}% > {args.max_error_rate}%"
        )


if __name__ == "__main__":
    main()
