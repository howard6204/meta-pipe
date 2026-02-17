#!/usr/bin/env python3
"""
Enhanced Claim Audit Script
============================

Compares claims in Abstract vs Results AND detects overclaims.

Features:
1. Numeric consistency (Abstract vs Results)
2. Overclaim detection (strength of language vs evidence)
3. Confidence level appropriateness (p-values vs claims)
4. Limitation acknowledgment check
5. GRADE-claim consistency

Overclaim Patterns:
- "strong evidence" when p=0.04 (borderline significance)
- "robust findings" when GRADE=LOW
- "conclusively demonstrated" when I²>75% (high heterogeneity)
- "minimal heterogeneity" when I²>50%
- Causal language for observational studies

Author: AI-assisted meta-analysis pipeline
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path
from typing import Dict, List, Tuple


# Regex patterns
NUMBER_RE = re.compile(r"\b\d+(?:\.\d+)?%?\b")
P_VALUE_RE = re.compile(r"p\s*[=<>]\s*0?\.\d+", re.IGNORECASE)
I_SQUARED_RE = re.compile(r"I[²2]\s*=\s*(\d+)%", re.IGNORECASE)


# Overclaim patterns (pattern, severity, explanation)
OVERCLAIM_PATTERNS = [
    # Strength claims
    (r"\b(strong|robust|compelling|conclusive|definitive)\s+(evidence|proof|demonstration)",
     "HIGH",
     "Use 'significant' or 'consistent' instead of 'strong/robust/conclusive'"),

    (r"\b(clearly|obviously|definitively|unequivocally)\s+(show|demonstrate|prove)",
     "HIGH",
     "Avoid absolute language - use 'suggest' or 'indicate'"),

    (r"\bprove[sd]?\b",
     "CRITICAL",
     "Meta-analyses do not 'prove' - use 'suggest' or 'support'"),

    # Causality overclaims
    (r"\b(cause[sd]?|led to|resulted in)\b",
     "MODERATE",
     "Use 'associated with' unless RCT evidence supports causality"),

    # Heterogeneity minimization
    (r"\b(minimal|low|negligible)\s+(heterogeneity|inconsistency)",
     "MODERATE",
     "Verify I² - 'minimal' only if I²<25%"),

    (r"\b(high|substantial)\s+(consistency|agreement)",
     "MODERATE",
     "Check I² - 'high consistency' only if I²<50%"),

    # Generalizability overclaims
    (r"\b(all|every|any)\s+(patient|population|setting)",
     "MODERATE",
     "Overgeneralization - acknowledge study limitations"),

    # Certainty overclaims
    (r"\b(certainly|undoubtedly|without question|beyond doubt)",
     "HIGH",
     "Overconfident language - science is always provisional"),

    # Effect size exaggeration
    (r"\b(dramatic|profound|remarkable|striking)\s+(effect|benefit|improvement)",
     "MODERATE",
     "Quantify effect size objectively (e.g., 'RR 2.5') rather than subjective adjectives"),

    # Missing limitations
    (r"\bno\s+(limitation|weakness|concern)",
     "MODERATE",
     "Every meta-analysis has limitations - acknowledge them"),
]


# Grade-inconsistent language
GRADE_INCONSISTENT = {
    "⊕⊖⊖⊖": ["strong", "robust", "conclusive", "clear"],
    "⊕⊕⊖⊖": ["strong", "robust", "conclusive"],
    "⊕⊕⊕⊖": ["conclusive", "definitive"],
}


def extract_numbers(text: str) -> set[str]:
    """Extract numeric tokens from text."""
    return set(NUMBER_RE.findall(text))


def extract_p_values(text: str) -> List[Tuple[str, float]]:
    """Extract p-values and their numeric values."""
    matches = P_VALUE_RE.findall(text)
    results = []

    for match in matches:
        # Extract numeric value
        num_match = re.search(r"0?\.\d+", match)
        if num_match:
            try:
                p_val = float(num_match.group())
                results.append((match, p_val))
            except ValueError:
                pass

    return results


def extract_i_squared(text: str) -> List[Tuple[str, int]]:
    """Extract I² values."""
    matches = I_SQUARED_RE.findall(text)
    results = []

    for match in matches:
        try:
            i_sq = int(match)
            results.append((f"I²={match}%", i_sq))
        except ValueError:
            pass

    return results


def check_overclaims(text: str, context: str = "") -> List[Dict]:
    """Check for overclaim patterns."""
    issues = []

    for pattern, severity, explanation in OVERCLAIM_PATTERNS:
        matches = re.finditer(pattern, text, re.IGNORECASE)

        for match in matches:
            # Extract surrounding context (50 chars before/after)
            start = max(0, match.start() - 50)
            end = min(len(text), match.end() + 50)
            snippet = text[start:end].replace("\n", " ")

            issues.append({
                "type": "OVERCLAIM",
                "severity": severity,
                "pattern": match.group(),
                "location": context,
                "snippet": f"...{snippet}...",
                "explanation": explanation
            })

    return issues


def check_p_value_claims(text: str, p_values: List[Tuple[str, float]]) -> List[Dict]:
    """Check if claim strength matches p-value magnitude."""
    issues = []

    # Check for borderline p-values with strong claims
    borderline = [pv for pv in p_values if 0.01 < pv[1] < 0.05]

    if borderline:
        # Look for strong language near borderline p-values
        strong_patterns = r"\b(strong|robust|compelling|conclusive)\b"

        for pv_str, pv_val in borderline:
            # Find position of p-value in text
            pos = text.find(pv_str)
            if pos == -1:
                continue

            # Check surrounding 200 characters
            start = max(0, pos - 200)
            end = min(len(text), pos + 200)
            context = text[start:end]

            if re.search(strong_patterns, context, re.IGNORECASE):
                issues.append({
                    "type": "P_VALUE_MISMATCH",
                    "severity": "MODERATE",
                    "pattern": f"Borderline significance ({pv_str}) with strong claim",
                    "location": "Results/Abstract",
                    "snippet": context.replace("\n", " "),
                    "explanation": f"p={pv_val:.3f} is borderline - use 'significant' not 'strong evidence'"
                })

    return issues


def check_heterogeneity_claims(text: str, i_squared_values: List[Tuple[str, int]]) -> List[Dict]:
    """Check if heterogeneity descriptions match I² values."""
    issues = []

    for i2_str, i2_val in i_squared_values:
        # Find position in text
        pos = text.find(i2_str)
        if pos == -1:
            continue

        # Check surrounding context
        start = max(0, pos - 100)
        end = min(len(text), pos + 100)
        context = text[start:end]

        # Check for inconsistent descriptions
        if i2_val >= 75:  # High heterogeneity
            if re.search(r"\b(low|minimal|negligible)\s+(heterogeneity|inconsistency)", context, re.IGNORECASE):
                issues.append({
                    "type": "HETEROGENEITY_MISMATCH",
                    "severity": "HIGH",
                    "pattern": f"I²={i2_val}% described as 'low heterogeneity'",
                    "location": "Results",
                    "snippet": context.replace("\n", " "),
                    "explanation": f"I²={i2_val}% is HIGH heterogeneity (≥75%) - acknowledge substantial inconsistency"
                })

        elif i2_val >= 50:  # Moderate heterogeneity
            if re.search(r"\b(low|minimal|negligible|high consistency)\s+", context, re.IGNORECASE):
                issues.append({
                    "type": "HETEROGENEITY_MISMATCH",
                    "severity": "MODERATE",
                    "pattern": f"I²={i2_val}% described inaccurately",
                    "location": "Results",
                    "snippet": context.replace("\n", " "),
                    "explanation": f"I²={i2_val}% is MODERATE heterogeneity (50-75%) - describe accurately"
                })

    return issues


def check_grade_consistency(abstract: str, results: str, discussion: str = "") -> List[Dict]:
    """Check if claim language matches GRADE ratings."""
    issues = []

    # Look for GRADE symbols in text
    grade_matches = re.finditer(r"(⊕{1,4}⊖{0,3})", abstract + results + discussion)

    for match in grade_matches:
        grade = match.group()

        if grade in GRADE_INCONSISTENT:
            incompatible_terms = GRADE_INCONSISTENT[grade]

            # Check for incompatible language near this GRADE rating
            pos = match.start()
            context_start = max(0, pos - 200)
            context_end = min(len(abstract + results + discussion), pos + 200)
            context = (abstract + results + discussion)[context_start:context_end]

            for term in incompatible_terms:
                if re.search(rf"\b{term}\b", context, re.IGNORECASE):
                    issues.append({
                        "type": "GRADE_INCONSISTENCY",
                        "severity": "HIGH",
                        "pattern": f"{grade} with '{term}' language",
                        "location": "Results/Abstract",
                        "snippet": context.replace("\n", " "),
                        "explanation": f"{grade} certainty incompatible with '{term}' - use modest language"
                    })

    return issues


def check_limitations_acknowledged(discussion: str) -> List[Dict]:
    """Check if limitations are acknowledged."""
    issues = []

    if not discussion:
        return issues

    # Look for limitations section
    limitations_section = re.search(
        r"(limitation|weakness|concern)s?\b.*?(?=\n\n|\n#|$)",
        discussion,
        re.IGNORECASE | re.DOTALL
    )

    if not limitations_section:
        issues.append({
            "type": "MISSING_LIMITATIONS",
            "severity": "MODERATE",
            "pattern": "No limitations section found",
            "location": "Discussion",
            "snippet": "",
            "explanation": "Every meta-analysis should acknowledge limitations (heterogeneity, publication bias, study quality)"
        })
    else:
        # Check if limitations are substantial (>50 words)
        lim_text = limitations_section.group()
        word_count = len(lim_text.split())

        if word_count < 50:
            issues.append({
                "type": "SUPERFICIAL_LIMITATIONS",
                "severity": "LOW",
                "pattern": f"Limitations section only {word_count} words",
                "location": "Discussion",
                "snippet": lim_text[:200],
                "explanation": "Limitations section seems superficial - provide substantive discussion"
            })

    return issues


def generate_audit_report(abstract_path: Path, results_path: Path,
                          discussion_path: Path = None) -> Dict:
    """Generate comprehensive claim audit report."""

    abstract_text = abstract_path.read_text()
    results_text = results_path.read_text()
    discussion_text = discussion_path.read_text() if discussion_path and discussion_path.exists() else ""

    # Original numeric consistency check
    abstract_numbers = extract_numbers(abstract_text)
    results_numbers = extract_numbers(results_text)
    missing_numbers = sorted(abstract_numbers - results_numbers)

    # Extract statistical values
    p_values = extract_p_values(results_text)
    i_squared = extract_i_squared(results_text)

    # Run all overclaim checks
    all_issues = []

    # Check each section for overclaims
    all_issues.extend(check_overclaims(abstract_text, "Abstract"))
    all_issues.extend(check_overclaims(results_text, "Results"))
    all_issues.extend(check_overclaims(discussion_text, "Discussion"))

    # Statistical claim checks
    all_issues.extend(check_p_value_claims(abstract_text + results_text, p_values))
    all_issues.extend(check_heterogeneity_claims(results_text, i_squared))

    # GRADE consistency
    all_issues.extend(check_grade_consistency(abstract_text, results_text, discussion_text))

    # Limitations check
    all_issues.extend(check_limitations_acknowledged(discussion_text))

    # Sort by severity
    severity_order = {"CRITICAL": 0, "HIGH": 1, "MODERATE": 2, "LOW": 3}
    all_issues.sort(key=lambda x: severity_order.get(x["severity"], 99))

    return {
        "numeric_consistency": {
            "abstract_numbers": len(abstract_numbers),
            "results_numbers": len(results_numbers),
            "missing": missing_numbers
        },
        "statistical_values": {
            "p_values": len(p_values),
            "i_squared": len(i_squared)
        },
        "overclaim_issues": all_issues,
        "total_issues": len(all_issues),
        "critical_count": sum(1 for i in all_issues if i["severity"] == "CRITICAL"),
        "high_count": sum(1 for i in all_issues if i["severity"] == "HIGH"),
        "moderate_count": sum(1 for i in all_issues if i["severity"] == "MODERATE")
    }


def format_audit_report(results: Dict) -> str:
    """Format audit results as markdown."""

    lines = [
        "# Enhanced Claim Audit Report",
        "",
        "## Summary",
        "",
        f"- **Total Issues**: {results['total_issues']}",
        f"- **Critical**: {results['critical_count']} 🔴",
        f"- **High**: {results['high_count']} ⚠️",
        f"- **Moderate**: {results['moderate_count']} ℹ️",
        "",
        "---",
        "",
        "## Numeric Consistency (Abstract vs Results)",
        "",
        f"- Abstract numbers: {results['numeric_consistency']['abstract_numbers']}",
        f"- Results numbers: {results['numeric_consistency']['results_numbers']}",
        ""
    ]

    if results['numeric_consistency']['missing']:
        lines.append("**⚠️ Numbers in Abstract NOT in Results:**")
        for num in results['numeric_consistency']['missing']:
            lines.append(f"- {num}")
    else:
        lines.append("✅ All abstract numbers found in results")

    lines.extend([
        "",
        "---",
        "",
        "## Overclaim Issues",
        ""
    ])

    if not results['overclaim_issues']:
        lines.append("✅ No overclaims detected")
    else:
        for i, issue in enumerate(results['overclaim_issues'], 1):
            severity_emoji = {
                "CRITICAL": "🔴",
                "HIGH": "⚠️",
                "MODERATE": "ℹ️",
                "LOW": "💡"
            }.get(issue['severity'], "")

            lines.extend([
                f"### {severity_emoji} Issue #{i}: {issue['type']}",
                "",
                f"**Severity**: {issue['severity']}",
                f"**Location**: {issue['location']}",
                f"**Pattern**: `{issue['pattern']}`",
                "",
                f"**Context**: {issue['snippet']}",
                "",
                f"**Fix**: {issue['explanation']}",
                "",
                "---",
                ""
            ])

    # Recommendations
    lines.extend([
        "",
        "## 📋 Recommendations",
        ""
    ])

    if results['critical_count'] > 0:
        lines.append("🔴 **CRITICAL**: Address all critical issues before submission")

    if results['high_count'] > 0:
        lines.append("⚠️ **HIGH**: Review high-severity issues - likely to trigger reviewer concerns")

    if results['moderate_count'] > 0:
        lines.append("ℹ️ **MODERATE**: Consider moderate issues to improve manuscript quality")

    if results['total_issues'] == 0:
        lines.append("✅ No overclaims detected - claims match evidence strength")

    lines.extend([
        "",
        "---",
        "",
        "## 💡 Best Practices",
        "",
        "1. **Use modest language**: 'suggest', 'indicate', 'consistent with' > 'prove', 'conclusively show'",
        "2. **Match p-values**: p<0.05 = 'significant', not 'strong evidence'",
        "3. **Acknowledge I²**: High heterogeneity (≥50%) weakens conclusions",
        "4. **Respect GRADE**: LOW/VERY LOW certainty ≠ 'robust findings'",
        "5. **Include limitations**: Every meta-analysis has methodological constraints",
        ""
    ])

    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Enhanced claim audit: numeric consistency + overclaim detection",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  uv run claim_audit.py --abstract 07_manuscript/00_abstract.qmd \\
                        --results 07_manuscript/03_results.qmd \\
                        --out 09_qa/claim_audit.md

  uv run claim_audit.py --abstract 07_manuscript/00_abstract.qmd \\
                        --results 07_manuscript/03_results.qmd \\
                        --discussion 07_manuscript/04_discussion.qmd \\
                        --out 09_qa/claim_audit.md
        """
    )

    parser.add_argument("--abstract", required=True, help="Abstract file path")
    parser.add_argument("--results", required=True, help="Results file path")
    parser.add_argument("--discussion", help="Discussion file path (optional)")
    parser.add_argument("--out", required=True, help="Output markdown report")

    args = parser.parse_args()

    abstract_path = Path(args.abstract)
    results_path = Path(args.results)
    discussion_path = Path(args.discussion) if args.discussion else None

    if not abstract_path.exists():
        raise SystemExit(f"Missing abstract file: {abstract_path}")
    if not results_path.exists():
        raise SystemExit(f"Missing results file: {results_path}")

    # Generate report
    results = generate_audit_report(abstract_path, results_path, discussion_path)

    # Format report
    report = format_audit_report(results)

    # Write output
    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(report)

    print(f"✅ Claim audit report written to: {out_path}")

    # Print summary
    print(f"\n📊 Summary: {results['total_issues']} issues detected")
    if results['critical_count'] > 0:
        print(f"   🔴 CRITICAL: {results['critical_count']}")
    if results['high_count'] > 0:
        print(f"   ⚠️  HIGH: {results['high_count']}")
    if results['moderate_count'] > 0:
        print(f"   ℹ️  MODERATE: {results['moderate_count']}")


if __name__ == "__main__":
    main()
