# Screening Phase Quick Start Guide

**Project**: {{PROJECT_NAME}}
**Date**: {{DATE}}
**Phase**: Stage 3 - Title/Abstract Screening
**Records**: {{RECORD_COUNT}} records

---

## 📊 Current Status

### Preparation Checklist

- [ ] Screening file ready: `03_screening/round-01/decisions.csv` ({{RECORD_COUNT}} records)
- [ ] Inclusion/exclusion criteria defined: `01_protocol/eligibility.md`
- [ ] Rayyan setup guide reviewed: `ma-screening-quality/references/rayyan-setup.md`
- [ ] Known key studies verified in search results

### CSV Field Description

```csv
record_id          # Unique identifier
entry_type         # Publication type (article, conference paper, etc.)
authors            # Author list
year               # Publication year
title              # Title
journal            # Journal name
abstract           # Abstract (may be empty for some records)
doi                # DOI
pmid               # PubMed ID
keywords           # Keywords
decision_r1        # Reviewer 1 decision (to be filled)
decision_r2        # Reviewer 2 decision (to be filled)
final_decision     # Final consensus decision (to be filled)
exclusion_reason   # Reason for exclusion (to be filled)
notes              # Additional notes (to be filled)
```

---

## 🎯 Two Screening Options

### Option A: Dual Independent Screening via Rayyan (Recommended) ⭐

**Advantages**:

- Meets systematic review standards (dual independent review)
- Automatic Cohen's kappa calculation (inter-rater reliability)
- Blinding mode reduces bias
- User-friendly visual interface
- Automatic conflict detection

**Steps**:

1. Follow `ma-screening-quality/references/rayyan-setup.md` to set up Rayyan (30 min)
2. Upload `dedupe.bib` or `decisions.csv`
3. Invite co-reviewer
4. Pilot screening (10 articles together, 1 hour)
5. Independent screening (6-8 hours per reviewer)
6. Resolve conflicts (2-3 hours)

**Expected time**: 9-12 hours per reviewer (distributed over 1-2 weeks)

---

### Option B: Single Reviewer Screening (Not Recommended)

**Only suitable for**:

- Preliminary exploratory analysis
- Extremely time-sensitive situations
- Unable to find co-reviewer

**Warnings**: ⚠️

- May be criticized by journal reviewers
- Does not meet PRISMA guidelines
- Lacks inter-rater reliability data
- Increases risk of bias

---

## 📋 Inclusion/Exclusion Criteria Quick Reference

> **Note**: Replace the examples below with your actual PICO criteria from `01_protocol/eligibility.md`

### ✅ Inclusion Criteria (all must be met)

1. **Study design**: {{STUDY_DESIGN}} (e.g., RCTs, cohort studies)
2. **Population**: {{POPULATION}} (e.g., adults ≥18 years)
3. **Intervention**: {{INTERVENTION}}
4. **Comparator**: {{COMPARATOR}}
5. **Outcomes**: {{OUTCOMES}}
6. **Minimum sample size**: {{MIN_SAMPLE_SIZE}} per group

### ❌ Exclusion Criteria (exclude if any apply)

1. Wrong study design (non-RCT, observational, single-arm)
2. Wrong population
3. Wrong intervention
4. Wrong comparator
5. Wrong outcomes
6. Duplicate publication
7. Non-human studies
8. Reviews, editorials, commentaries

---

## 🔍 Quick Decision Tree

### Step 1: Is this the right study design?

- ✅ Yes ({{STUDY_DESIGN}}) → Continue to Step 2
- ❌ No (wrong design) → **Exclude** (wrong_study_design)
- ❓ Uncertain → Mark as **Maybe** (full-text needed)

### Step 2: Is this the right population?

- ✅ Yes ({{POPULATION}}) → Continue to Step 3
- ❌ No (wrong population) → **Exclude** (wrong_population)
- ❓ Uncertain → Mark as **Maybe**

### Step 3: Is this the right intervention/comparator?

- ✅ Yes ({{INTERVENTION}} vs {{COMPARATOR}}) → Continue to Step 4
- ❌ No (wrong intervention) → **Exclude** (wrong_intervention)
- ❓ Uncertain → Mark as **Maybe**

### Step 4: Reports relevant outcomes?

- ✅ Yes ({{OUTCOMES}}) → **Include**
- ❌ No (no results, protocol only) → **Exclude** (wrong_outcomes)
- ❓ Uncertain → Mark as **Maybe**

---

## 🎯 Known Key Studies

> **Note**: List known landmark studies that MUST be included

If you encounter these studies, they should be marked as **Include**:

1. {{KEY_STUDY_1}} - {{CITATION_1}}
2. {{KEY_STUDY_2}} - {{CITATION_2}}
3. {{KEY_STUDY_3}} - {{CITATION_3}}

⚠️ **Validation check**: After screening, verify all key studies are in the "Include" list!

---

## 📝 Handling Edge Cases

### Case 1: Conference abstract + full publication

- **Decision**: Include only the full publication, exclude abstract (mark as "duplicate")
- **Exception**: If abstract has unique data not in full publication, include both

### Case 2: Multiple follow-up reports

- **Decision**: Include the most recent/complete report
- **Exception**: Different time points may all be useful (e.g., 3-year vs 5-year survival), include all with notes

### Case 3: Post-hoc/subgroup analyses

- **Decision**: If reports new results or subgroups, include
- **Decision**: If only repeats main analysis, exclude

### Case 4: Title only, no abstract

- **Decision**: Evaluate based on title, mark as **Maybe** if uncertain
- **Reason**: Some PubMed records may not include abstracts, need full-text verification

### Case 5: Early Phase I/II trials

- **Decision**: If RCT with ≥{{MIN_SAMPLE_SIZE}} per group, include
- **Decision**: If single-arm or <{{MIN_SAMPLE_SIZE}} per group, exclude

---

## 📊 Expected Results

### Screening Rate Estimates

- **Include**: {{EXPECTED_INCLUDE_PERCENT}}% ({{EXPECTED_INCLUDE_COUNT}} studies)
- **Maybe**: {{EXPECTED_MAYBE_PERCENT}}% ({{EXPECTED_MAYBE_COUNT}} studies)
- **Exclude**: {{EXPECTED_EXCLUDE_PERCENT}}% ({{EXPECTED_EXCLUDE_COUNT}} studies)

### Common Exclusion Reasons

1. **Wrong study design** (observational, reviews): ~30%
2. **Wrong population**: ~20%
3. **Wrong intervention**: ~15%
4. **Wrong comparator**: ~10%
5. **Wrong outcomes** (protocol only, no results): ~5%

---

## ⏱️ Time Planning

### Using Rayyan (Recommended)

| Task                                   | Time      | Cumulative        |
| -------------------------------------- | --------- | ----------------- |
| Set up Rayyan + upload citations       | 30 min    | 30 min            |
| Invite co-reviewer                     | 15 min    | 45 min            |
| Pilot screening (10 articles together) | 1 hour    | 1.75 hours        |
| Independent screening (Reviewer 1)     | 6-8 hours | 7.75-9.75 hours   |
| Independent screening (Reviewer 2)     | 6-8 hours | (concurrent)      |
| Resolve conflicts                      | 2-3 hours | 9.75-12.75 hours  |
| Export and update CSV                  | 30 min    | 10.25-13.25 hours |

**Total**: ~10-13 hours per reviewer (distributed over 1-2 weeks)

### Screening Efficiency

- **Speed**: 20-30 articles/hour (after familiarization)
- **Quality**: Dual independent review reduces bias, improves reliability
- **Breaks**: Take breaks every 45-60 minutes to avoid fatigue

---

## 🚀 Start Today

### Option A: Rayyan Screening (Recommended)

**Step 1** (30 min): Set up Rayyan

```bash
# 1. Visit https://www.rayyan.ai/ and sign up
# 2. Create new review project: "{{PROJECT_NAME}}"
# 3. Upload 02_search/round-01/dedupe.bib
# or upload 03_screening/round-01/decisions.csv
```

**Step 2** (15 min): Configure inclusion/exclusion criteria

- Copy content from `01_protocol/eligibility.md` to Rayyan "Criteria" field
- Set up exclusion reason labels

**Step 3** (15 min): Invite co-reviewer

```
Co-reviewer email: ______________
Role: Reviewer (not Owner)
Blinding mode: Enabled
```

**Step 4** (1 hour): Pilot screening

- Randomly select 10 articles
- Both reviewers discuss and decide together
- Clarify any ambiguous inclusion/exclusion criteria
- Document decision rationale

**Step 5** (this week): Independent screening

- Reviewer 1: Independently screen all {{RECORD_COUNT}} articles
- Reviewer 2: Independently screen all {{RECORD_COUNT}} articles
- Do not discuss decisions until both complete

**Step 6** (next week): Conflict resolution

- Review discrepancies in Rayyan
- Discuss each disagreement and reach consensus
- Calculate Cohen's kappa (target ≥0.60)

---

### Option B: Single Reviewer Screening (Not Recommended)

If you're certain about single-reviewer screening (not meeting systematic review standards):

**Step 1**: Open `decisions.csv` in Excel or Google Sheets

**Step 2**: Fill in `decision_r1` column row by row:

- `include` = Include
- `exclude` = Exclude
- `maybe` = Uncertain (need full-text)

**Step 3**: Fill in `exclusion_reason` column (if excluded):

- `wrong_study_design`
- `wrong_population`
- `wrong_intervention`
- `wrong_comparator`
- `wrong_outcomes`
- `duplicate`
- `review_editorial`

**Step 4**: Copy `decision_r1` to `final_decision` (since single reviewer)

**Step 5**: Export updated CSV

---

## 📈 Quality Checks

### Must Do After Screening

1. **Verify key studies**

```bash
# Check that all known key studies are in the include list
grep -i "{{KEY_STUDY_1}}|{{KEY_STUDY_2}}|{{KEY_STUDY_3}}" \
  03_screening/round-01/decisions.csv | grep "include"
```

2. **Calculate screening statistics**

```python
# Count include/exclude/maybe
import pandas as pd
df = pd.read_csv('03_screening/round-01/decisions.csv')
print(df['final_decision'].value_counts())
```

3. **Check Cohen's kappa** (dual screening)

- Target: ≥0.60 (moderate or higher agreement)
- If <0.60: Review whether inclusion/exclusion criteria are clear

4. **Prepare PRISMA flow diagram data**

- Records identified: {{RECORD_COUNT}}
- Records after deduplication: {{RECORD_COUNT}}
- Records screened: {{RECORD_COUNT}}
- Records excluded: ? (to be counted after screening)
- Records for full-text review: ? (include + maybe)

---

## 🎯 Success Criteria

### Must Achieve

- [ ] All {{RECORD_COUNT}} records have screening decisions
- [ ] All known key studies are in the include list
- [ ] All excluded records have exclusion reasons
- [ ] (Dual screening) Cohen's kappa ≥0.60
- [ ] Expected to include {{EXPECTED_INCLUDE_COUNT}}-{{EXPECTED_MAYBE_COUNT}} records for full-text review

### Optional

- [ ] Screening guidelines documented (how edge cases were decided)
- [ ] Pilot screening recorded (learning curve analysis)
- [ ] Reviewer fatigue managed (break times recorded)

---

## 📞 Need Help?

### Technical Issues

- **Rayyan won't upload BibTeX**: Try CSV or RIS format
- **CSV formatting issues**: Use UTF-8 encoding, ensure no special characters
- **Co-reviewer can't access**: Check email spelling, resend invitation

### Methodological Questions

- **Uncertain whether to include**: Mark as **Maybe**, decide at full-text stage
- **Exclusion reason unclear**: Choose the primary exclusion reason
- **Kappa <0.60**: Review inclusion/exclusion criteria, conduct additional training

### Decision Difficulties

- **Mixed population with relevant subgroup**: Include (can extract from subgroup data)
- **Conference abstract only**: If data sufficient, include (note need to find full publication)
- **Phase I small sample**: If <{{MIN_SAMPLE_SIZE}} per group, exclude

---

## 📝 Next Phase Preview

After screening completion (expected 1-2 weeks), you will proceed to:

**Phase 4: Full-text Review** (Weeks 6-7)

- Obtain full-text PDFs of included studies
- Search for Open Access PDFs (Unpaywall)
- Manually obtain remaining PDFs (institutional subscription)
- Full-text review to confirm inclusion criteria
- Expected final inclusion: {{EXPECTED_FINAL_INCLUDE}} studies

---

## ✅ Start Now

**Immediate action** (choose one):

**Option A**: Set up Rayyan (30 min)

1. Visit https://www.rayyan.ai/
2. Follow `ma-screening-quality/references/rayyan-setup.md`
3. Upload `02_search/round-01/dedupe.bib`

**Option B**: Find co-reviewer (15 min)

1. Confirm co-reviewer availability
2. Send `ma-screening-quality/references/rayyan-setup.md` to them
3. Schedule pilot screening session (1 hour)

**Option C**: Practice with 10 articles (1 hour)

1. Open `decisions.csv` in Excel
2. Read title/abstract of first 10 articles
3. Practice applying inclusion/exclusion criteria
4. Record any uncertain cases

---

**Status**: ✅ Ready to start screening
**Confidence level**: High (clear criteria, key studies validated)
**Next milestone**: Complete screening (expected within 2 weeks)
**Overall project timeline**: {{PROJECT_TIMELINE}}

---

**Document version**: 1.0
**Date**: {{DATE}}
**Generated by**: Meta-analysis pipeline
