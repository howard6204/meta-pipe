#!/usr/bin/env python3
"""
Rule-based title/abstract screening for BTK inhibitors in Waldenström Macroglobulinemia
Fast screening without external AI dependencies
"""

import csv
import sys
from pathlib import Path
import re


def screen_study(record):
    """
    Screen a study based on title and abstract using rule-based logic
    Returns: (decision, reason, confidence, exclusion_code)
    """
    title = record.get("Title", "").lower()
    abstract = record.get("Abstract", "").lower()
    year = int(record.get("Year", 0)) if record.get("Year", "").isdigit() else 0
    journal = record.get("Journal", "").lower()

    # === KNOWN KEY TRIALS (MUST INCLUDE) ===
    key_trials = [
        "aspen", "innovate", "pcyc-1118e", "owen 2020", "tam 2023", "dimopoulos 2021",
        "pcyc-1127", "nct03053440", "nct02165397"
    ]
    title_abstract = title + " " + abstract
    for trial in key_trials:
        if trial in title_abstract:
            return ("INCLUDE", f"Known key trial: {trial.upper()}", "HIGH", "NONE")

    # === DEFINITE EXCLUDES ===

    # Exclude: Wrong study type (reviews, meta-analyses, editorials)
    exclude_types = [
        "systematic review", "meta-analysis", "scoping review", "literature review",
        "editorial", "commentary", "letter to", "corrigendum", "correction",
        "book chapter", "guidelines", "consensus", "state of the art"
    ]
    for exc_type in exclude_types:
        if exc_type in title or exc_type in abstract[:200]:  # Check abstract start
            return ("EXCLUDE", f"Study type: {exc_type}", "HIGH", "S1")

    # Exclude: Preclinical studies
    if any(word in title_abstract for word in ["in vitro", "cell line", "mouse model", "xenograft", "preclinical"]):
        if "clinical trial" not in title_abstract:  # Unless it mentions clinical trial
            return ("EXCLUDE", "Preclinical study", "HIGH", "S3")

    # Exclude: Case reports/small series
    case_indicators = ["case report", "case series", "single patient", "pediatric case"]
    if any(ind in title for ind in case_indicators):
        return ("EXCLUDE", "Case report or small series", "HIGH", "S2")

    # Exclude: Wrong population (clearly not WM)
    wrong_population = [
        "acute myeloid leukemia", "acute lymphoblastic leukemia", "multiple myeloma",
        "diffuse large b-cell lymphoma", "dlbcl", "follicular lymphoma",
        "marginal zone lymphoma", "hodgkin", "breast cancer", "lung cancer"
    ]
    for wrong_pop in wrong_population:
        if wrong_pop in title:
            # Unless it mentions WM alongside
            if "waldenstr" not in title_abstract and "lymphoplasmacytic" not in title_abstract:
                return ("EXCLUDE", f"Wrong population: {wrong_pop}", "HIGH", "P1")

    # Exclude: No BTK inhibitor mentioned
    btk_inhibitors = [
        "ibrutinib", "zanubrutinib", "acalabrutinib", "tirabrutinib",
        "orelabrutinib", "pirtobrutinib", "fenebrutinib", "btk inhibitor",
        "bruton", "brukinsatm", "imbruvica", "calquence"
    ]
    has_btk = any(btk in title_abstract for btk in btk_inhibitors)
    has_wm = "waldenstr" in title_abstract or "lymphoplasmacytic" in title_abstract

    if has_wm and not has_btk:
        # WM study but no BTK inhibitor - likely other treatment
        return ("EXCLUDE", "No BTK inhibitor mentioned", "MEDIUM", "I1")

    if has_btk and not has_wm:
        # BTK inhibitor but not WM - check if it's CLL/MCL only
        if any(disease in title_abstract for disease in ["chronic lymphocytic leukemia", "cll", "mantle cell", "mcl"]):
            if "waldenstr" not in title_abstract:
                return ("EXCLUDE", "BTK inhibitor for non-WM indication", "MEDIUM", "I2")

    # === DEFINITE INCLUDES ===

    # Include: Clinical trial of BTK inhibitor in WM
    trial_indicators = [
        "phase 2", "phase 3", "phase ii", "phase iii", "clinical trial",
        "randomized", "multicenter", "prospective"
    ]

    if has_wm and has_btk:
        if any(ind in title_abstract for ind in trial_indicators):
            return ("INCLUDE", "Clinical trial of BTK inhibitor in WM", "HIGH", "NONE")

    # Include: Studies with outcomes (response rates, PFS, OS)
    outcome_indicators = [
        "response rate", "progression-free survival", "overall survival",
        "complete response", "partial response", "vgpr", "efficacy", "safety"
    ]
    if has_wm and has_btk:
        if any(out in abstract for out in outcome_indicators):
            return ("INCLUDE", "WM study with BTK inhibitor and outcomes", "MEDIUM", "NONE")

    # === UNCERTAIN (MAYBE) ===

    # Maybe: WM + BTK inhibitor mentioned, but unclear if clinical trial
    if has_wm and has_btk:
        return ("MAYBE", "WM and BTK inhibitor mentioned, need full text", "MEDIUM", "NONE")

    # Maybe: Only title available (no abstract)
    if has_wm or has_btk:
        if not abstract or len(abstract) < 50:
            return ("MAYBE", "No abstract, need full text", "LOW", "NONE")

    # Default: exclude if neither WM nor BTK mentioned
    if not has_wm and not has_btk:
        return ("EXCLUDE", "Not relevant to WM or BTK inhibitors", "HIGH", "P1")

    # Catchall
    return ("MAYBE", "Unclear from title/abstract", "LOW", "NONE")


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Rule-based screening for WM meta-analysis")
    parser.add_argument("--project", required=True, help="Project name (e.g., btk-wm)")
    parser.add_argument("--csv", required=True, help="Input CSV file path")
    parser.add_argument("--output", required=True, help="Output CSV file path")
    args = parser.parse_args()

    # Resolve paths
    input_csv = Path(args.csv)
    output_csv = Path(args.output)

    # Load input CSV
    print(f"📂 Reading screening database from: {input_csv}")
    with open(input_csv, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        records = list(reader)

    print(f"✅ Loaded {len(records)} records")

    # Screen each record
    results = []
    for i, record in enumerate(records, 1):
        pmid = record.get("PMID", "")
        title = record.get("Title", "")
        abstract = record.get("Abstract", "")
        year = record.get("Year", "")
        authors = record.get("Authors", "")
        journal = record.get("Journal", "")

        print(f"[{i}/{len(records)}] Screening PMID {pmid}... ", end="")

        decision, reason, confidence, exclusion_code = screen_study(record)

        print(f"{decision} ({confidence})")

        results.append({
            "PMID": pmid,
            "Year": year,
            "Authors": authors,
            "Title": title,
            "Journal": journal,
            "Abstract": abstract,
            "AI_Decision": decision,
            "AI_Reason": reason,
            "AI_Confidence": confidence,
            "Exclusion_Code": exclusion_code,
            "Manual_Review_Required": "YES" if decision == "MAYBE" or confidence == "LOW" else "NO"
        })

    # Write output
    print(f"\n💾 Writing results to: {output_csv}")
    output_csv.parent.mkdir(parents=True, exist_ok=True)

    with open(output_csv, "w", newline="", encoding="utf-8") as f:
        fieldnames = [
            "PMID", "Year", "Authors", "Title", "Journal", "Abstract",
            "AI_Decision", "AI_Reason", "AI_Confidence", "Exclusion_Code",
            "Manual_Review_Required"
        ]
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(results)

    # Summary statistics
    include_count = sum(1 for r in results if r["AI_Decision"] == "INCLUDE")
    exclude_count = sum(1 for r in results if r["AI_Decision"] == "EXCLUDE")
    maybe_count = sum(1 for r in results if r["AI_Decision"] == "MAYBE")

    print(f"\n" + "="*60)
    print(f"📊 SCREENING SUMMARY")
    print(f"="*60)
    print(f"Total records screened: {len(results)}")
    print(f"  ✅ INCLUDE: {include_count} ({include_count/len(results)*100:.1f}%)")
    print(f"  ❌ EXCLUDE: {exclude_count} ({exclude_count/len(results)*100:.1f}%)")
    print(f"  ❓ MAYBE: {maybe_count} ({maybe_count/len(results)*100:.1f}%)")
    print(f"\n🔍 Manual review required: {sum(1 for r in results if r['Manual_Review_Required'] == 'YES')}")
    print(f"="*60)

    print(f"\n✅ Screening complete! Results saved to: {output_csv}")


if __name__ == "__main__":
    main()
