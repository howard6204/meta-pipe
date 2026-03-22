#!/usr/bin/env python3
"""Generate semi-automated GRADE certainty suggestions from analysis outputs.

Wires Stage 06 analysis statistics (I², Egger's test, CI bounds, total events)
and Stage 03 RoB 2 assessments into the GRADE template as **suggested
downgrades with computed rationale**, for human confirmation/override.

Inputs
------
- ``--grade`` : grade_summary.csv (outcome list from ``init_grade_summary.py``)
- ``--stats`` : analysis_stats.json (from ``collect_analysis_stats.py``)

When ``--stats`` is provided the script populates each domain with computed
values and evidence-based suggestions.  Without it, the script falls back to
the previous text-parsing behaviour so existing workflows are unaffected.

Outputs
-------
- CSV / Markdown with per-outcome × per-domain computed values, suggested
  downgrade level, rationale, and reviewer decision placeholder.

References
----------
- Cochrane Handbook §14.4.4 (inconsistency)
- Guyatt et al. 2011 (PMID: 21208779) — imprecision
- Sterne et al. 2011 (PMID: 21952616) — publication bias
- Sterne et al. 2019 (PMID: 21208780) — risk of bias
"""

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path
from typing import Any, Dict, List, Tuple


DOMAIN_COLUMNS = [
    "risk_of_bias",
    "inconsistency",
    "indirectness",
    "imprecision",
    "publication_bias",
]


# ---------------------------------------------------------------------------
# Legacy text-based parsing (fallback when --stats not provided)
# ---------------------------------------------------------------------------


def parse_level(value: str) -> int:
    text = value.strip().lower()
    if not text:
        return 0
    if "very serious" in text or "critical" in text:
        return -2
    if "serious" in text or "high" in text:
        return -1
    return 0


def parse_upgrade(value: str) -> int:
    text = value.strip().lower()
    if not text:
        return 0
    if "very large" in text:
        return 2
    if "large" in text or "dose" in text or "confounding" in text:
        return 1
    if text in {"yes", "y", "true"}:
        return 1
    return 0


def start_level(row: Dict[str, str], default_start: str) -> int:
    start_map = {"high": 4, "moderate": 3, "low": 2, "very low": 1}
    design = ""
    for key in ("design", "study_design", "study_type"):
        if key in row and row[key]:
            design = row[key].lower()
            break
    if "random" in design or "rct" in design:
        return 4
    if "observational" in design or "cohort" in design or "case-control" in design:
        return 2
    return start_map.get(default_start, 3)


def level_to_label(level: int) -> str:
    return {4: "High", 3: "Moderate", 2: "Low", 1: "Very Low"}.get(level, "Moderate")


SYMBOLS = {
    4: "\u2295\u2295\u2295\u2295",
    3: "\u2295\u2295\u2295\u2296",
    2: "\u2295\u2295\u2296\u2296",
    1: "\u2295\u2296\u2296\u2296",
}


def suggest_legacy(row: Dict[str, str], default_start: str) -> Tuple[str, str]:
    """Legacy suggestion using only text labels in the CSV."""
    level = start_level(row, default_start)
    downgrades = 0
    upgrade = 0
    reasons: list[str] = []

    for col in DOMAIN_COLUMNS:
        val = row.get(col, "")
        delta = parse_level(val)
        if delta:
            downgrades += -delta
            reasons.append(f"{col}: {val}")

    for key in ("upgrade", "large_effect", "dose_response", "residual_confounding"):
        if key in row and row[key]:
            delta = parse_upgrade(row[key])
            if delta:
                upgrade += delta
                reasons.append(f"{key}: {row[key]}")

    level = max(1, min(4, level - downgrades + upgrade))
    label = level_to_label(level)
    note = f"Auto-suggested: start={level_to_label(start_level(row, default_start))}"
    if reasons:
        note += f"; reasons: {', '.join(reasons)}"
    return label, note


# ---------------------------------------------------------------------------
# Computed domain suggestions (using analysis_stats.json)
# ---------------------------------------------------------------------------


class DomainSuggestion:
    """Container for a per-domain computed GRADE suggestion."""

    __slots__ = ("domain", "computed", "downgrade", "rationale")

    def __init__(
        self, domain: str, computed: str, downgrade: int, rationale: str
    ) -> None:
        self.domain = domain
        self.computed = computed
        self.downgrade = downgrade
        self.rationale = rationale

    @property
    def label(self) -> str:
        if self.downgrade <= -2:
            return "Very serious"
        if self.downgrade == -1:
            return "Serious"
        return "Not serious"


def _suggest_inconsistency(stats: Dict[str, Any]) -> DomainSuggestion:
    """Inconsistency: I-squared, prediction interval, Q-test."""
    i2 = stats.get("i_squared")
    q_p = stats.get("q_p_value")
    pi_lower = stats.get("pi_lower")
    pi_upper = stats.get("pi_upper")

    parts: list[str] = []
    if i2 is not None:
        parts.append(f"I\u00b2 = {i2:.1f}%")
    if q_p is not None:
        parts.append(f"Q p={q_p:.3f}")
    if pi_lower is not None and pi_upper is not None:
        parts.append(f"PI [{pi_lower:.2f}, {pi_upper:.2f}]")

    computed = ", ".join(parts) if parts else "No data"

    if i2 is None:
        return DomainSuggestion(
            "inconsistency", computed, 0, "Insufficient data to assess"
        )

    pi_crosses_null = False
    if pi_lower is not None and pi_upper is not None:
        pi_crosses_null = pi_lower <= 1.0 <= pi_upper

    q_significant = q_p is not None and q_p < 0.10

    if i2 > 75:
        return DomainSuggestion(
            "inconsistency",
            computed,
            -2,
            "I\u00b2 >75% indicates substantial unexplained heterogeneity "
            "(Cochrane Handbook \u00a714.4.4)",
        )
    if i2 > 50 and (q_significant or pi_crosses_null):
        reasons = []
        if q_significant:
            reasons.append(f"Q-test significant (p={q_p:.3f})")
        if pi_crosses_null:
            reasons.append("prediction interval crosses null")
        return DomainSuggestion(
            "inconsistency",
            computed,
            -1,
            f"I\u00b2 >50% with {' and '.join(reasons)} "
            "(Cochrane Handbook \u00a714.4.4)",
        )
    return DomainSuggestion(
        "inconsistency",
        computed,
        0,
        f"I\u00b2 = {i2:.1f}%, no substantial heterogeneity",
    )


def _suggest_imprecision(stats: Dict[str, Any]) -> DomainSuggestion:
    """Imprecision: total events, CI width, OIS."""
    total_events = stats.get("total_events")
    ci_lower = stats.get("ci_lower")
    ci_upper = stats.get("ci_upper")
    measure = stats.get("effect_measure", "")
    n_total = stats.get("n_total")

    parts: list[str] = []
    if total_events is not None:
        parts.append(f"Total events: {total_events}")
    if n_total is not None:
        parts.append(f"N={n_total}")
    if ci_lower is not None and ci_upper is not None:
        parts.append(f"95% CI: {ci_lower}\u2013{ci_upper}")

    computed = ", ".join(parts) if parts else "No data"

    null_value = 1.0 if measure in ("HR", "RR", "OR") else 0.0
    ci_crosses_null = False
    if ci_lower is not None and ci_upper is not None:
        ci_crosses_null = ci_lower <= null_value <= ci_upper

    if total_events is not None and total_events < 100:
        extra = ""
        if ci_crosses_null:
            extra = " and CI crosses null"
        return DomainSuggestion(
            "imprecision",
            computed,
            -2,
            f"<100 total events ({total_events}){extra} \u2014 very imprecise "
            "(Guyatt et al. 2011, PMID: 21208779)",
        )

    if total_events is not None and total_events < 300 and ci_crosses_null:
        return DomainSuggestion(
            "imprecision",
            computed,
            -1,
            f"<300 total events ({total_events}) with CI crossing null "
            "(Guyatt et al. 2011, PMID: 21208779)",
        )

    if ci_crosses_null:
        return DomainSuggestion(
            "imprecision",
            computed,
            -1,
            f"CI crosses null ({ci_lower}\u2013{ci_upper}); optimal information size may not be met "
            "(Guyatt et al. 2011, PMID: 21208779)",
        )

    if total_events is None and ci_lower is None:
        return DomainSuggestion(
            "imprecision", computed, 0, "Insufficient data to assess"
        )

    return DomainSuggestion(
        "imprecision", computed, 0, "Adequate events and CI excludes null"
    )


def _suggest_publication_bias(stats: Dict[str, Any]) -> DomainSuggestion:
    """Publication bias: Egger's test, number of studies."""
    egger_p = stats.get("egger_p")
    k = stats.get("k_studies")

    parts: list[str] = []
    if egger_p is not None:
        parts.append(f"Egger's p={egger_p:.3f}")
    if k is not None:
        parts.append(f"k={k} studies")

    computed = ", ".join(parts) if parts else "No data"

    if egger_p is not None and egger_p < 0.10:
        caveat = ""
        if k is not None and k < 10:
            caveat = f" (caveat: only {k} studies, test underpowered)"
        return DomainSuggestion(
            "publication_bias",
            computed,
            -1,
            f"Egger's test significant (p={egger_p:.3f}){caveat} "
            "(Sterne et al. 2011, PMID: 21952616)",
        )

    if k is not None and k < 10:
        return DomainSuggestion(
            "publication_bias",
            computed,
            0,
            f"Egger's test not significant but limited power with {k} studies "
            "(assess visually via funnel plot)",
        )

    if egger_p is None:
        return DomainSuggestion(
            "publication_bias",
            computed,
            0,
            "Egger's test data not available; assess via funnel plot",
        )

    return DomainSuggestion(
        "publication_bias",
        computed,
        0,
        f"No evidence of publication bias (Egger's p={egger_p:.3f})",
    )


def _suggest_risk_of_bias(rob_summary: Dict[str, Any]) -> DomainSuggestion:
    """Risk of bias: RoB 2 per-study assessments."""
    if not rob_summary:
        return DomainSuggestion(
            "risk_of_bias", "No RoB data", 0, "RoB 2 assessment data not available"
        )

    n = rob_summary.get("n_studies", 0)
    n_high = rob_summary.get("n_high_risk", 0)
    n_some = rob_summary.get("n_some_concerns", 0)
    n_low = rob_summary.get("n_low_risk", 0)
    pct_high = rob_summary.get("pct_high_risk", 0)

    computed = f"{n_high}/{n} high risk, {n_some}/{n} some concerns, {n_low}/{n} low"

    if pct_high > 50:
        return DomainSuggestion(
            "risk_of_bias",
            computed,
            -2,
            f">50% of studies at high risk of bias ({pct_high:.0f}%) "
            "(Sterne et al. 2019, PMID: 31462531)",
        )
    if pct_high > 25:
        return DomainSuggestion(
            "risk_of_bias",
            computed,
            -1,
            f">25% of studies at high risk of bias ({pct_high:.0f}%) "
            "(Sterne et al. 2019, PMID: 31462531)",
        )
    if n_high > 0:
        return DomainSuggestion(
            "risk_of_bias",
            computed,
            0,
            f"{n_high}/{n} studies at high risk ({pct_high:.0f}%) \u2014 below 25% threshold, "
            "but review specific domains",
        )
    return DomainSuggestion(
        "risk_of_bias", computed, 0, "Majority of studies at low risk of bias"
    )


def _suggest_indirectness() -> DomainSuggestion:
    """Indirectness: requires human judgment (PICO vs study characteristics)."""
    return DomainSuggestion(
        "indirectness",
        "Requires human assessment",
        0,
        "Indirectness cannot be computed automatically. "
        "Assess whether study populations, interventions, comparators, and outcomes "
        "match the target PICO (Guyatt et al. 2011, PMID: 21208780)",
    )


def suggest_computed(
    outcome_id: str,
    outcome_stats: Dict[str, Any],
    rob_summary: Dict[str, Any],
) -> Dict[str, DomainSuggestion]:
    """Generate computed suggestions for all 5 GRADE domains."""
    return {
        "inconsistency": _suggest_inconsistency(outcome_stats),
        "imprecision": _suggest_imprecision(outcome_stats),
        "publication_bias": _suggest_publication_bias(outcome_stats),
        "risk_of_bias": _suggest_risk_of_bias(rob_summary),
        "indirectness": _suggest_indirectness(),
    }


# ---------------------------------------------------------------------------
# Outcome matching
# ---------------------------------------------------------------------------


def match_outcome(
    outcome_id: str,
    outcome_name: str,
    analysis_outcomes: Dict[str, Dict[str, Any]],
) -> Dict[str, Any] | None:
    """Try to match a grade_summary outcome to analysis stats."""
    if outcome_id in analysis_outcomes:
        return analysis_outcomes[outcome_id]

    lower_map = {k.lower(): v for k, v in analysis_outcomes.items()}
    if outcome_id.lower() in lower_map:
        return lower_map[outcome_id.lower()]

    search_terms = (outcome_id + " " + outcome_name).lower().split()
    best_match = None
    best_score = 0
    for key, stats in analysis_outcomes.items():
        key_lower = key.lower()
        score = sum(1 for t in search_terms if t in key_lower)
        if score > best_score:
            best_score = score
            best_match = stats
    return best_match if best_score > 0 else None


# ---------------------------------------------------------------------------
# IO
# ---------------------------------------------------------------------------


def read_csv(path: Path) -> Tuple[List[str], List[Dict[str, str]]]:
    with path.open(newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        rows = [{k: (v or "").strip() for k, v in row.items()} for row in reader]
        return (reader.fieldnames or [], rows)


def write_csv(path: Path, headers: List[str], rows: List[Dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=headers)
        writer.writeheader()
        writer.writerows(rows)


def write_md(path: Path, headers: List[str], rows: List[Dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    lines = ["# GRADE Auto-Suggestions", ""]
    lines.append("| " + " | ".join(headers) + " |")
    lines.append("| " + " | ".join(["---"] * len(headers)) + " |")
    for row in rows:
        line = "| " + " | ".join(row.get(h, "") for h in headers) + " |"
        lines.append(line)
    path.write_text("\n".join(lines) + "\n")


def write_detailed_md(
    path: Path,
    outcome_suggestions: List[Tuple[str, str, str, Dict[str, DomainSuggestion], int]],
) -> None:
    """Write detailed per-outcome x per-domain markdown with reviewer decision fields."""
    path.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "# GRADE Semi-Automated Suggestions",
        "",
        "> Generated from Stage 06 analysis outputs and Stage 03 RoB assessments.",
        "> Each domain shows computed statistics, suggested downgrade, and rationale.",
        "> **Reviewer**: Accept or override each suggestion below.",
        "",
    ]

    for (
        outcome_id,
        outcome_name,
        start_label,
        domains,
        final_level,
    ) in outcome_suggestions:
        lines.append(f"## {outcome_id}: {outcome_name}")
        lines.append("")
        start_num = {"High": 4, "Moderate": 3, "Low": 2, "Very Low": 1}.get(
            start_label, 3
        )
        start_sym = SYMBOLS.get(start_num, "")
        lines.append(f"**Starting certainty**: {start_label} ({start_sym})")
        lines.append("")

        for domain_key in DOMAIN_COLUMNS:
            ds = domains[domain_key]
            domain_title = domain_key.replace("_", " ").title()
            lines.append(f"### {domain_title}")
            lines.append(f"- **Computed**: {ds.computed}")
            lines.append(f"- **Suggested downgrade**: {ds.label} ({ds.downgrade})")
            lines.append(f"- **Rationale**: {ds.rationale}")
            lines.append(f"- **Reviewer decision**: [ ] Accept  [ ] Override to: ___")
            lines.append("")

        final_label = level_to_label(final_level)
        final_sym = SYMBOLS.get(final_level, "")
        lines.append(f"**Suggested overall certainty**: {final_sym} **{final_label}**")
        lines.append("")
        lines.append("---")
        lines.append("")

    path.write_text("\n".join(lines) + "\n")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate semi-automated GRADE certainty suggestions."
    )
    parser.add_argument("--grade", required=True, help="Input grade_summary.csv")
    parser.add_argument("--out-csv", required=True, help="Output CSV with suggestions")
    parser.add_argument(
        "--out-md", required=True, help="Output markdown with suggestions"
    )
    parser.add_argument(
        "--stats",
        default=None,
        help="analysis_stats.json from collect_analysis_stats.py (enables computed suggestions)",
    )
    parser.add_argument(
        "--out-detailed-md",
        default=None,
        help="Output detailed per-domain markdown with reviewer decision fields",
    )
    parser.add_argument(
        "--default-start",
        default="moderate",
        choices=["high", "moderate", "low", "very low"],
        help="Starting certainty if design missing",
    )
    args = parser.parse_args()

    headers, rows = read_csv(Path(args.grade))
    if not rows:
        raise SystemExit("No rows found in grade summary.")

    # Load analysis stats if provided
    analysis_stats: Dict[str, Any] | None = None
    if args.stats:
        stats_path = Path(args.stats)
        if stats_path.exists():
            analysis_stats = json.loads(stats_path.read_text(encoding="utf-8"))

    use_computed = analysis_stats is not None
    analysis_outcomes = (analysis_stats or {}).get("outcomes", {})
    rob_summary = (analysis_stats or {}).get("rob2_summary", {})

    # Build output
    out_headers = list(headers)
    if use_computed:
        for domain in DOMAIN_COLUMNS:
            for suffix in ("_computed", "_downgrade", "_rationale"):
                col = domain + suffix
                if col not in out_headers:
                    out_headers.append(col)
    for col in ("suggested_certainty", "suggested_notes"):
        if col not in out_headers:
            out_headers.append(col)

    out_rows: list[Dict[str, str]] = []
    detailed_outcomes: list[Tuple[str, str, str, Dict[str, DomainSuggestion], int]] = []

    for row in rows:
        row_out = dict(row)
        outcome_id = row.get("outcome_id", "")
        outcome_name = row.get("outcome_name", "")

        if use_computed:
            matched = match_outcome(outcome_id, outcome_name, analysis_outcomes)
            outcome_stats = matched or {}
            domains = suggest_computed(outcome_id, outcome_stats, rob_summary)

            level = start_level(row, args.default_start)
            total_downgrade = 0
            reasons: list[str] = []

            for domain_key in DOMAIN_COLUMNS:
                ds = domains[domain_key]
                row_out[f"{domain_key}_computed"] = ds.computed
                row_out[f"{domain_key}_downgrade"] = ds.label
                row_out[f"{domain_key}_rationale"] = ds.rationale

                if ds.downgrade:
                    total_downgrade += abs(ds.downgrade)
                    reasons.append(f"{domain_key}: {ds.label} ({ds.downgrade})")

                if not row_out.get(domain_key):
                    row_out[domain_key] = ds.label

            upgrade = 0
            for key in (
                "upgrade",
                "large_effect",
                "dose_response",
                "residual_confounding",
            ):
                if key in row and row[key]:
                    delta = parse_upgrade(row[key])
                    if delta:
                        upgrade += delta
                        reasons.append(f"{key}: {row[key]}")

            final_level = max(1, min(4, level - total_downgrade + upgrade))
            label = level_to_label(final_level)
            start_label = level_to_label(level)

            note = f"Computed from analysis stats; start={start_label}"
            if reasons:
                note += f"; {', '.join(reasons)}"
            if not matched:
                note += "; WARNING: no matching analysis data found for this outcome"

            row_out["suggested_certainty"] = label
            row_out["suggested_notes"] = note

            detailed_outcomes.append(
                (outcome_id, outcome_name, start_label, domains, final_level)
            )
        else:
            suggestion, notes = suggest_legacy(row, args.default_start)
            row_out["suggested_certainty"] = suggestion
            row_out["suggested_notes"] = notes

        out_rows.append(row_out)

    write_csv(Path(args.out_csv), out_headers, out_rows)
    write_md(Path(args.out_md), out_headers, out_rows)

    if use_computed and args.out_detailed_md:
        write_detailed_md(Path(args.out_detailed_md), detailed_outcomes)
        print(f"Detailed suggestions: {args.out_detailed_md}")

    mode = "computed (from analysis stats)" if use_computed else "legacy (text-parsing)"
    print(f"GRADE suggestions generated ({mode}): {len(out_rows)} outcome(s)")
    print(f"  CSV: {args.out_csv}")
    print(f"  MD:  {args.out_md}")


if __name__ == "__main__":
    main()
