#!/usr/bin/env python3
"""
Validate meta-pipe pipeline using metadat benchmark datasets

Usage:
    python3 validate_pipeline.py --project validation-bcg
"""

import argparse
import pandas as pd
from pathlib import Path
import json


def validate_against_known_results(
    project_name: str,
    expected_results: dict,
    tolerance: float = 0.05,
    root_dir: Path = None,
):
    """
    驗證分析結果是否與已知結果一致

    Args:
        project_name: 專案名稱
        expected_results: 預期結果 {'RR': 0.51, 'CI_lower': 0.34, ...}
        tolerance: 容許誤差範圍 (預設 5%)
        root_dir: meta-pipe 根目錄
    """

    if root_dir is None:
        root_dir = Path(__file__).parent.parent.parent

    project_path = root_dir / "projects" / project_name
    results_file = project_path / "06_analysis/results/summary.csv"

    if not results_file.exists():
        print(f"❌ Results file not found: {results_file}")
        return None

    # 讀取實際結果
    actual_results = pd.read_csv(results_file)

    print(f"\n{'=' * 60}")
    print(f"Validation Report: {project_name}")
    print(f"{'=' * 60}\n")

    validation_passed = True
    results = {}

    for metric, expected_value in expected_results.items():
        if metric not in actual_results.columns:
            print(f"⚠️  Metric '{metric}' not found in results")
            continue

        actual_value = actual_results[metric].iloc[0]
        diff = abs(actual_value - expected_value)
        rel_diff = diff / expected_value if expected_value != 0 else diff

        passed = rel_diff <= tolerance

        if not passed:
            validation_passed = False

        results[metric] = {
            "passed": bool(passed),
            "expected": float(expected_value),
            "actual": float(actual_value),
            "diff": float(diff),
            "rel_diff_pct": float(rel_diff * 100),
        }

        status = "✅" if passed else "❌"
        print(
            f"{status} {metric:15s}: {actual_value:7.4f}  "
            f"(expected: {expected_value:7.4f}, "
            f"diff: {rel_diff * 100:5.1f}%)"
        )

    print(f"\n{'=' * 60}")
    if validation_passed:
        print("✅ VALIDATION PASSED - All metrics within tolerance")
    else:
        print("❌ VALIDATION FAILED - Some metrics outside tolerance")
    print(f"{'=' * 60}\n")

    # 儲存驗證結果
    validation_json = project_path / "06_analysis/results/validation_result.json"
    with open(validation_json, "w") as f:
        json.dump(
            {
                "project": project_name,
                "passed": validation_passed,
                "tolerance": tolerance,
                "metrics": results,
            },
            f,
            indent=2,
        )

    print(f"📊 Validation results saved: {validation_json}")

    return results


# Benchmark datasets with known results
BENCHMARK_DATASETS = {
    "validation-bcg": {
        "dataset": "dat.bcg",
        "description": "BCG vaccine efficacy (13 RCTs)",
        "expected": {
            "RR": 0.51,
            "CI_lower": 0.34,
            "CI_upper": 0.70,
            "I2": 92.0,
        },
        "tolerance": 0.10,  # 10% tolerance
    },
    "validation-smoking": {
        "dataset": "dat.hackshaw1998",
        "description": "Secondhand smoke and lung cancer (37 studies)",
        "expected": {
            "RR": 1.24,
            "CI_lower": 1.13,
            "CI_upper": 1.36,
        },
        "tolerance": 0.10,
    },
}


def main():
    parser = argparse.ArgumentParser(
        description="Validate meta-pipe pipeline with benchmark data"
    )
    parser.add_argument(
        "--project", required=True, help="Project name (e.g., validation-bcg)"
    )
    parser.add_argument(
        "--tolerance",
        type=float,
        default=None,
        help="Tolerance for validation (default: dataset-specific)",
    )
    parser.add_argument(
        "--root", type=Path, default=None, help="meta-pipe root directory"
    )

    args = parser.parse_args()

    # Get expected results
    if args.project in BENCHMARK_DATASETS:
        benchmark = BENCHMARK_DATASETS[args.project]
        expected = benchmark["expected"]
        tolerance = args.tolerance or benchmark["tolerance"]

        print(f"📋 Benchmark: {benchmark['description']}")
        print(f"📊 Dataset: {benchmark['dataset']}")
        print(f"🎯 Tolerance: {tolerance * 100:.0f}%\n")
    else:
        print(f"⚠️  No benchmark data for project: {args.project}")
        print(f"Available benchmarks: {', '.join(BENCHMARK_DATASETS.keys())}")
        return

    # Run validation
    results = validate_against_known_results(
        args.project, expected, tolerance=tolerance, root_dir=args.root
    )

    if results is None:
        exit(1)

    # Check if validation passed
    all_passed = all(r["passed"] for r in results.values())
    exit(0 if all_passed else 1)


if __name__ == "__main__":
    main()
