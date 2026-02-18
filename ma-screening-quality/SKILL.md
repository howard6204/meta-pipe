---
name: ma-screening-quality
description: Perform title and abstract screening, apply inclusion and exclusion criteria, and assess study quality or risk of bias. Use when selecting eligible studies for meta-analysis.
---

# Ma Screening Quality

## Overview

Screen search results, document decisions, and assess risk of bias or quality.

## Inputs

- `03_screening/screening-database.csv` (created by search stage)
- `01_protocol/eligibility.md`

## Outputs

- `03_screening/round-01/decisions.csv`
- `03_screening/round-01/exclusions.csv`
- `03_screening/round-01/quality.csv`
- `03_screening/round-01/included.bib`
- `03_screening/round-01/agreement.md`

## Commands

### AI Screening (Reviewer 1)

```bash
# AI screens all records as Reviewer 1 (uses claude -p with OAuth)
uv run tooling/python/ai_screen.py --project <project-name>

# AI screens as Reviewer 2 (for dual AI review)
uv run tooling/python/ai_screen.py --project <project-name> --reviewer 2

# Specify a different round
uv run tooling/python/ai_screen.py --project <project-name> --round round-02
```

### Dual-Review Agreement

```bash
# Compute Cohen's kappa after both reviewers finish
uv run ma-screening-quality/scripts/dual_review_agreement.py \
  --file projects/<project-name>/03_screening/round-01/decisions.csv \
  --col-a Reviewer1_Decision --col-b Reviewer2_Decision \
  --out projects/<project-name>/03_screening/round-01/agreement.md
```

## Workflow

1. **AI Screening (Reviewer 1)**: Run `ai_screen.py --project <name>` to auto-screen all records against `eligibility.md`. Fills `Reviewer1_Decision` and `Reviewer1_Reason` columns.
2. **Human/AI Reviewer 2**: Either run `ai_screen.py --reviewer 2` for dual-AI review, or have a human fill `Reviewer2_Decision` and `Reviewer2_Reason` columns manually.
3. **Compute agreement**: Run `dual_review_agreement.py` to calculate Cohen's kappa (target >= 0.60).
4. **Resolve conflicts**: Review records where Reviewer 1 and 2 disagree; fill `Final_Decision`.
5. **Record exclusion reasons** using standardized labels from `references/screening-labels.md`.
6. **Quality/RoB assessment**: Assess included studies using the tool appropriate for the study design.
7. **Create `included.bib`** from final included studies.

## How `ai_screen.py` Works

- **Topic-agnostic**: reads `eligibility.md` from any project, passes it to Claude as screening criteria
- **Uses `claude -p --model haiku`**: OAuth-based, no API key needed, fast and cheap
- **Skips already-decided rows**: safe to re-run if interrupted
- **Liberal screening**: when uncertain, defaults to MAYBE (standard practice at title/abstract stage)
- **Generic exclusion codes**: P1/P2 (population), I1/I2 (intervention), C1 (comparator), S1-S4 (study design), O1/O2 (outcomes), T1/T2 (time), L1 (language), D1 (duplicate)

## Resources

- `references/screening-labels.md` provides standardized decision labels.
- `references/dual-review-schema.md` defines recommended decision columns.
- `scripts/dual_review_agreement.py` computes agreement and Cohen's kappa.

## Validation

- Compute agreement for dual screening when applicable (kappa >= 0.60).
- Confirm all included studies meet eligibility criteria.

## Pipeline Navigation

| Step | Skill                     | Stage                       |
| ---- | ------------------------- | --------------------------- |
| Prev | `/ma-search-bibliography` | 02 Search & Bibliography    |
| Next | `/ma-fulltext-management` | 04 Full-text Management     |
| All  | `/ma-end-to-end`          | Full pipeline orchestration |
