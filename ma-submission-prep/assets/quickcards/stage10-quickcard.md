# Stage 10 Pre-Submission - Quick Reference

**When**: Manuscript at 95%+ readiness, planning to submit within 1-2 days
**Time**: 1-2 hours (5 steps)
**Prerequisites**: Phase 3 complete, publication readiness score ≥95%

---

## 5 Steps

- [ ] **1. PROSPERO Registration** (30 min) ⚠️ MANDATORY
  Register on https://www.crd.york.ac.uk/prospero/, get CRD42026XXXXXX ID
  → [Details](../../references/prospero-registration-guide.md)

- [ ] **2. Update 4 Files** (10 min)
  Replace `[PENDING]` with PROSPERO ID in: pico.yaml, 02_methods.qmd, author_statements.md, prisma_nma_checklist.md
  → [Details](../checklists/stage10-checklist.md#step-2)

- [ ] **3. Final QA Validation** (10 min)
  Run readiness score + claim audit (expect ≥95%, zero CRITICAL)
  → [Details](../checklists/stage10-checklist.md#step-3)

- [ ] **4. Final Rendering** (5 min)
  Run `make docx`, verify 500-800KB, visual QA (figures, PROSPERO ID, word count)
  → [Details](../checklists/stage10-checklist.md#step-4)

- [ ] **5. Cover Letter** (30 min)
  Write 5-paragraph cover letter (Hook-Novelty-Impact-Fit-Compliance)
  → [Templates](../templates/) | [Details](../../references/cover-letter-guide.md)

---

## Pass Criteria

- [ ] PROSPERO ID obtained (CRD42026XXXXXX format)
- [ ] All 4 files updated, no `[PENDING]` placeholders remain
- [ ] Readiness score ≥95%, zero CRITICAL/HIGH overclaims
- [ ] `index.docx` renders successfully (500-800KB)
- [ ] Cover letter complete and saved

---

## Submission Package Checklist

**Required (9 files)**:
- [ ] Manuscript (`index.docx`)
- [ ] Cover Letter (`cover_letter_<journal>.md`)
- [ ] PRISMA-NMA Checklist (`09_qa/prisma_nma_checklist.md`)
- [ ] Supplementary Materials (`07_manuscript/supplementary_materials.pdf`)
- [ ] Author Statements (`author_statements.md`)
- [ ] Figures 1-4 (300 DPI PNG)

**Optional (3 files)**:
- [ ] Graphical Abstract
- [ ] Video Abstract (JAMA Oncology encourages)
- [ ] Plain Language Summary (Nature Medicine requires)

---

## Quick Commands

```bash
# Verify no [PENDING] placeholders
cd projects/<project-name>
grep -r "\[PENDING\]" . --exclude-dir=.git

# Final rendering
cd 07_manuscript
make docx

# Check output
ls -lh index.docx
```

---

**Previous**: [Phase 3 Quality Refinement](phase3-quickcard.md)
**Full Checklist**: [Stage 10 Detailed Checklist](../checklists/stage10-checklist.md)
**After Submission**: Record date in pico.yaml, save confirmation email

---

**Version**: 1.0.0 (2026-02-18)
**Source**: early-immuno-timing-nma project
