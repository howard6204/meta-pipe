#!/usr/bin/env python3
"""Collect analysis statistics from Stage 06 outputs for GRADE assessment.

Parses markdown reports and CSV tables produced by R meta-analysis scripts
to extract I², Egger's test p-values, pooled effects, CI bounds, total events,
and number of studies.  Outputs a structured JSON file that
``auto_grade_suggestion.py`` can consume to pre-populate GRADE domain
suggestions with computed rationale.

References
----------
- Cochrane Handbook §14.4.4 (inconsistency)
- Guyatt et al. 2011 (PMID: 21208779) — imprecision
- Sterne et al. 2011 (PMID: 21952616) — publication bias
"""

from __future__ import annotations

import argparse
import csv
import json
import re
from pathlib import Path
from typing import Any


# ---------------------------------------------------------------------------
# Markdown parsing helpers
# ---------------------------------------------------------------------------

_NUM = r"[-+]?\d+\.?\d*"

# Patterns for I² (e.g. "I²=0.0%", "I² = 62.3%", "I²: 0.0%")
_I2_PAT = re.compile(rf"I[²2]\s*[:=]\s*({_NUM})\s*%", re.IGNORECASE)

# Cochran's Q p-value (e.g. "p=0.707", "p = 0.714")
_Q_P_PAT = re.compile(rf"Cochran.*?p\s*[:=]\s*({_NUM})", re.IGNORECASE)
# Fallback: generic Q line
_Q_P_PAT2 = re.compile(rf"Q\s*=\s*{_NUM}.*?p\s*[:=]\s*({_NUM})", re.IGNORECASE)

# Egger's test p-value (e.g. "p=0.713", "p = 0.915")
_EGGER_PAT = re.compile(rf"Egger.*?p\s*[:=]\s*({_NUM})", re.IGNORECASE)

# Pooled effect: HR or RR with CI
_EFFECT_HR_PAT = re.compile(
    rf"(?:Pooled\s+)?(?:Hazard\s+Ratio|HR)\s*[:=]?\s*({_NUM})\s*"
    rf"\(?95%\s*CI[:=]?\s*({_NUM})\s*[–—-]\s*({_NUM})\)?",
    re.IGNORECASE,
)
_EFFECT_RR_PAT = re.compile(
    rf"(?:Pooled\s+)?(?:Risk\s+Ratio|RR)\s*[:=]?\s*({_NUM})\s*"
    rf"\(?95%\s*CI[:=]?\s*({_NUM})\s*[–—-]\s*({_NUM})\)?",
    re.IGNORECASE,
)

# Number of studies (e.g. "k=3", "3 trials", "5 RCTs")
_K_PAT = re.compile(r"(\d+)\s*(?:trials?|RCTs?|stud(?:ies|y))", re.IGNORECASE)

# Total patients (e.g. "N=2,402" or "N=1681")
_N_PAT = re.compile(r"N\s*=\s*([\d,]+)", re.IGNORECASE)

# Prediction interval
_PI_PAT = re.compile(
    rf"prediction\s+interval.*?({_NUM})\s*[–—-]\s*({_NUM})",
    re.IGNORECASE,
)

# tau² (e.g. "τ²=0.0000" or "tau²=0")
_TAU2_PAT = re.compile(rf"[τt]au[²2]\s*[:=]\s*({_NUM})", re.IGNORECASE)


def _first_float(pattern: re.Pattern[str], text: str) -> float | None:
    m = pattern.search(text)
    return float(m.group(1)) if m else None


def _first_match(pattern: re.Pattern[str], text: str) -> re.Match[str] | None:
    return pattern.search(text)


def parse_report(text: str) -> dict[str, Any]:
    """Extract key statistics from a Stage 06 markdown report."""
    stats: dict[str, Any] = {}

    # I²
    val = _first_float(_I2_PAT, text)
    if val is not None:
        stats["i_squared"] = val

    # tau²
    val = _first_float(_TAU2_PAT, text)
    if val is not None:
        stats["tau_squared"] = val

    # Q-test p-value
    val = _first_float(_Q_P_PAT, text)
    if val is None:
        val = _first_float(_Q_P_PAT2, text)
    if val is not None:
        stats["q_p_value"] = val

    # Egger's p-value
    val = _first_float(_EGGER_PAT, text)
    if val is not None:
        stats["egger_p"] = val

    # Pooled effect (HR preferred, then RR)
    m = _first_match(_EFFECT_HR_PAT, text)
    if m:
        stats["effect_measure"] = "HR"
        stats["pooled_effect"] = float(m.group(1))
        stats["ci_lower"] = float(m.group(2))
        stats["ci_upper"] = float(m.group(3))
    else:
        m = _first_match(_EFFECT_RR_PAT, text)
        if m:
            stats["effect_measure"] = "RR"
            stats["pooled_effect"] = float(m.group(1))
            stats["ci_lower"] = float(m.group(2))
            stats["ci_upper"] = float(m.group(3))

    # Prediction interval
    m = _first_match(_PI_PAT, text)
    if m:
        stats["pi_lower"] = float(m.group(1))
        stats["pi_upper"] = float(m.group(2))

    # Number of studies
    val = _first_float(_K_PAT, text)
    if val is not None:
        stats["k_studies"] = int(val)

    # Total N
    m = _first_match(_N_PAT, text)
    if m:
        stats["n_total"] = int(m.group(1).replace(",", ""))

    return stats


def parse_results_csv(path: Path) -> dict[str, Any]:
    """Extract pooled row statistics from a Stage 06 results CSV."""
    stats: dict[str, Any] = {}
    if not path.exists():
        return stats

    with path.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    pooled_row = None
    non_pooled = []
    for row in rows:
        first_val = next(iter(row.values()), "")
        if "pool" in first_val.lower() or "random" in first_val.lower():
            pooled_row = row
        else:
            non_pooled.append(row)

    stats["k_studies"] = len(non_pooled)

    if pooled_row:
        # Try to get I² from CSV (column I2_Pct or similar)
        for key in ("I2_Pct", "I2", "i2", "i_squared"):
            if key in pooled_row and pooled_row[key]:
                try:
                    stats["i_squared"] = float(pooled_row[key].rstrip("%"))
                except ValueError:
                    pass

        # CI bounds
        ci_val = pooled_row.get("CI_95", "")
        ci_match = re.search(rf"({_NUM})\s*[–—-]\s*({_NUM})", ci_val)
        if ci_match:
            stats["ci_lower"] = float(ci_match.group(1))
            stats["ci_upper"] = float(ci_match.group(2))

        # P-value
        for key in ("P_value", "p_value", "P"):
            pval = pooled_row.get(key, "").strip()
            if pval and pval != "—":
                try:
                    stats["pooled_p"] = float(pval)
                except ValueError:
                    if pval.startswith("<"):
                        try:
                            stats["pooled_p"] = float(pval[1:])
                        except ValueError:
                            pass

    # Total events from individual rows (for binary outcomes)
    total_events = 0
    has_events = False
    for row in non_pooled:
        for key in ("ICI_Events", "Events_ICI", "events_intervention"):
            if key in row and row[key]:
                try:
                    total_events += int(row[key])
                    has_events = True
                except ValueError:
                    pass
        for key in ("Control_Events", "Events_Control", "events_control"):
            if key in row and row[key]:
                try:
                    total_events += int(row[key])
                    has_events = True
                except ValueError:
                    pass
        # pCR-style: "508/784 (64.8%)"
        for key in ("pCR_ICI", "pCR_Control"):
            val = row.get(key, "")
            frac_m = re.match(r"(\d+)/(\d+)", val)
            if frac_m:
                total_events += int(frac_m.group(1))
                has_events = True

    if has_events:
        stats["total_events"] = total_events

    return stats


def parse_rob2_csv(path: Path) -> dict[str, Any]:
    """Summarize RoB 2 judgments from a quality CSV.

    Returns counts by judgment level and proportion of high-risk studies.
    """
    if not path.exists():
        return {}

    with path.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    if not rows:
        return {}

    # Group by study
    studies: dict[str, list[str]] = {}
    for row in rows:
        sid = ""
        for key in ("record_id", "study_id", "id"):
            if key in row and row[key]:
                sid = row[key].strip()
                break
        judgment = ""
        for key in ("judgment", "overall", "risk"):
            if key in row and row[key]:
                judgment = row[key].strip().lower()
                break
        if sid:
            studies.setdefault(sid, []).append(judgment)

    # Determine overall per study
    overall: dict[str, str] = {}
    for sid, judgments in studies.items():
        if any("high" in j for j in judgments):
            overall[sid] = "high"
        elif any("concern" in j or "some" in j for j in judgments):
            overall[sid] = "some concerns"
        elif any("low" in j for j in judgments):
            overall[sid] = "low"
        else:
            overall[sid] = "unclear"

    n = len(overall)
    n_high = sum(1 for v in overall.values() if v == "high")
    n_some = sum(1 for v in overall.values() if v == "some concerns")
    n_low = sum(1 for v in overall.values() if v == "low")

    return {
        "n_studies": n,
        "n_high_risk": n_high,
        "n_some_concerns": n_some,
        "n_low_risk": n_low,
        "pct_high_risk": round(n_high / n * 100, 1) if n else 0,
        "per_study": overall,
    }


# ---------------------------------------------------------------------------
# Outcome discovery
# ---------------------------------------------------------------------------

def discover_outcomes(analysis_dir: Path) -> dict[str, dict[str, Any]]:
    """Discover outcomes by scanning for report files and result CSVs."""
    outcomes: dict[str, dict[str, Any]] = {}

    # Match report files: *_REPORT.md, *_SUMMARY.md
    for md_file in sorted(analysis_dir.glob("*_REPORT.md")):
        name = md_file.stem.replace("_META_ANALYSIS_REPORT", "").replace("_REPORT", "")
        text = md_file.read_text(encoding="utf-8")
        stats = parse_report(text)
        stats["_source_report"] = md_file.name
        outcomes.setdefault(name, {}).update(stats)

    # Also parse META_ANALYSIS_SUMMARY.md (often has pCR data)
    summary_file = analysis_dir / "META_ANALYSIS_SUMMARY.md"
    if summary_file.exists():
        text = summary_file.read_text(encoding="utf-8")
        stats = parse_report(text)
        # Determine outcome name from content
        if "pCR" in text or "pathologic" in text.lower():
            outcome_name = "pCR"
        else:
            outcome_name = "primary"
        stats["_source_report"] = summary_file.name
        outcomes.setdefault(outcome_name, {}).update(stats)

    # Merge data from CSV tables
    for csv_file in sorted(analysis_dir.glob("tables_*_results.csv")):
        # e.g. tables_pCR_meta_analysis_results.csv -> pCR
        name = csv_file.stem.replace("tables_", "").replace("_meta_analysis_results", "")
        csv_stats = parse_results_csv(csv_file)
        outcomes.setdefault(name, {}).update(
            {k: v for k, v in csv_stats.items() if k not in outcomes.get(name, {})}
        )
        outcomes[name].setdefault("_source_csv", csv_file.name)

    # Also check summary CSVs (safety)
    for csv_file in sorted(analysis_dir.glob("tables_*_summary.csv")):
        name = csv_file.stem.replace("tables_", "").replace("_meta_analysis_summary", "")
        csv_stats = parse_results_csv(csv_file)
        # Safety CSVs may contain multiple outcomes as rows
        if csv_file.exists():
            with csv_file.open(newline="", encoding="utf-8") as f:
                reader = csv.DictReader(f)
                for row in reader:
                    outcome_name = ""
                    for key in ("Outcome", "outcome", "outcome_name"):
                        if key in row and row[key]:
                            outcome_name = row[key].strip()
                            break
                    if not outcome_name:
                        continue
                    sub_stats: dict[str, Any] = {"_source_csv": csv_file.name}
                    for key in ("I2_Pct", "I2"):
                        if key in row and row[key] and row[key] != "—":
                            try:
                                sub_stats["i_squared"] = float(row[key].rstrip("%"))
                            except ValueError:
                                pass
                    for key in ("P_value", "p_value"):
                        if key in row and row[key] and row[key] != "—":
                            try:
                                sub_stats["pooled_p"] = float(row[key])
                            except ValueError:
                                pass
                    for key in ("Pooled_RR", "Pooled_HR", "Pooled_OR"):
                        if key in row and row[key] and row[key] != "—":
                            try:
                                sub_stats["pooled_effect"] = float(row[key])
                                sub_stats["effect_measure"] = key.replace("Pooled_", "")
                            except ValueError:
                                pass
                    ci_val = row.get("CI_95", "")
                    ci_match = re.search(rf"({_NUM})\s*[–—-]\s*({_NUM})", ci_val)
                    if ci_match:
                        sub_stats["ci_lower"] = float(ci_match.group(1))
                        sub_stats["ci_upper"] = float(ci_match.group(2))
                    for key in ("Trials", "trials", "k"):
                        if key in row and row[key] and row[key] != "—":
                            try:
                                sub_stats["k_studies"] = int(row[key])
                            except ValueError:
                                pass
                    # Total events
                    for key in ("ICI_Events",):
                        if key in row and row[key] and row[key] != "—":
                            try:
                                ev = int(row[key])
                                ctrl_ev = 0
                                for ck in ("Control_Events",):
                                    if ck in row and row[ck] and row[ck] != "—":
                                        ctrl_ev = int(row[ck])
                                sub_stats["total_events"] = ev + ctrl_ev
                            except ValueError:
                                pass

                    outcomes.setdefault(outcome_name, {}).update(sub_stats)

    return outcomes


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Collect analysis statistics from Stage 06 for GRADE assessment."
    )
    parser.add_argument(
        "--analysis-dir",
        required=True,
        help="Path to 06_analysis/ directory",
    )
    parser.add_argument(
        "--rob-csv",
        default=None,
        help="Path to quality_rob2.csv (RoB 2 assessment)",
    )
    parser.add_argument(
        "--out",
        required=True,
        help="Output JSON path (e.g., 08_reviews/analysis_stats.json)",
    )
    args = parser.parse_args()

    analysis_dir = Path(args.analysis_dir)
    if not analysis_dir.is_dir():
        raise SystemExit(f"Analysis directory not found: {analysis_dir}")

    result: dict[str, Any] = {
        "source": str(analysis_dir),
        "outcomes": discover_outcomes(analysis_dir),
    }

    # RoB 2 summary
    if args.rob_csv:
        rob_path = Path(args.rob_csv)
        rob_stats = parse_rob2_csv(rob_path)
        if rob_stats:
            result["rob2_summary"] = rob_stats

    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n")

    n = len(result["outcomes"])
    print(f"Collected statistics for {n} outcome(s):")
    for name, stats in result["outcomes"].items():
        keys = [k for k in stats if not k.startswith("_")]
        print(f"  {name}: {', '.join(keys)}")
    if "rob2_summary" in result:
        rob = result["rob2_summary"]
        print(
            f"  RoB 2: {rob['n_studies']} studies "
            f"({rob['n_high_risk']} high, {rob['n_some_concerns']} some concerns, "
            f"{rob['n_low_risk']} low)"
        )
    print(f"Output: {args.out}")


if __name__ == "__main__":
    main()
