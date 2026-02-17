# Phase 3 Quality Refinement - Quick Reference

**When**: After initial draft renders (`make docx` works)
**Time**: 2-3 hours
**Goal**: 90% → 95-98% publication readiness

---

## 5 Steps

- [ ] **1. Clinical Implications** (30-60 min)
  Create 3-4 scenario-based clinical guidance sections
  → [Details](../../references/clinical-implications-guide.md) | [Template](../templates/clinical-scenario-template.md)

- [ ] **2. Hypothesis Resolution** (15-30 min)
  Add explicit Introduction-Discussion arc completion
  → [Details](../../references/hypothesis-resolution-guide.md)

- [ ] **3. Overclaim Prevention** (30 min)
  Run claim audit, fix CRITICAL/HIGH severity issues
  → [Details](../../references/overclaim-prevention-guide.md)

- [ ] **4. Journal-Specific Materials** (30-60 min)
  Add JAMA Key Points / Lancet Research in Context / Nature Medicine mechanistic paragraph
  → [Details](../../references/journal-materials-guide.md)

- [ ] **5. Transitivity Assessment** (NMA only, 30 min)
  Create detailed Supplementary Table of effect modifiers
  → [Details](../../references/transitivity-guide.md)

---

## Pass Criteria

- [ ] Publication readiness score ≥95%
- [ ] Zero CRITICAL/HIGH overclaims in claim audit
- [ ] Journal-specific materials complete (Key Points box / Research in Context)

---

## Quick Commands

```bash
# Check readiness score
cd /Users/htlin/meta-pipe/tooling/python
uv run ../../ma-end-to-end/scripts/publication_readiness_score.py \
  --root ../../projects/<project-name> \
  --out ../../projects/<project-name>/09_qa/readiness_score.md

# Run claim audit
uv run ../../ma-publication-quality/scripts/claim_audit.py \
  --abstract ../../projects/<project-name>/07_manuscript/00_abstract.qmd \
  --results ../../projects/<project-name>/07_manuscript/03_results.qmd \
  --discussion ../../projects/<project-name>/07_manuscript/04_discussion.qmd \
  --out ../../projects/<project-name>/09_qa/claim_audit.md
```

---

**Next**: [Stage 10 Pre-Submission Checklist](stage10-quickcard.md)
**Full Checklist**: [Phase 3 Detailed Checklist](../checklists/phase3-checklist.md)

---

**Version**: 1.0.0 (2026-02-18)
**Source**: early-immuno-timing-nma project
