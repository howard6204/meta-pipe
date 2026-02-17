# Phase 3 Quality Refinement Checklist

**When to use**: After initial draft renders successfully (`make docx` works), before journal submission

**Time**: 2-3 hours | **ROI**: +10% acceptance rate, prevents 6-12 month revision delays

**Quick Reference**: [Phase 3 Quickcard](../quickcards/phase3-quickcard.md) (1-page summary)

---

## ⚠️ CRITICAL

**DO NOT SKIP Phase 3**. This transforms manuscripts from "90% academic draft" to "95-98% publication-ready submission".

**Evidence**: early-immuno-timing-nma project achieved 90-95% predicted acceptance rate (JAMA Oncology) after Phase 3 refinement.

---

## Checklist (5 Items)

### ☐ 1. Clinical Implications Enhancement (30-60 min)

**📖 Detailed guide**: [Clinical Implications Guide](../../references/clinical-implications-guide.md)

**Goal**: Replace generic recommendations with scenario-based clinical guidance

**Quick Actions**:
- [ ] Identify 3-4 distinct clinical scenarios
- [ ] For EACH scenario, fill 5 elements using template:
  - [ ] Preferred strategy
  - [ ] NMA evidence (HR, P-score, NNT)
  - [ ] Supporting data (pCR, I²)
  - [ ] Rationale
  - [ ] Alternative/Caveat
- [ ] Add Shared Decision-Making framework (6+ discussion points)

**Pass Criteria**:
- ✅ Each scenario has all 5 elements
- ✅ Shared Decision-Making framework has ≥6 specific points
- ✅ Zero generic statements ("Consider patient factors")

**Tools**:
- Template: [clinical-scenario-template.md](../templates/clinical-scenario-template.md)
- Example: See [clinical-implications-guide.md](../../references/clinical-implications-guide.md#examples)

---

### ☐ 2. Hypothesis Resolution (15-30 min)

**📖 Detailed guide**: [Hypothesis Resolution Guide](../../references/hypothesis-resolution-guide.md)

**Goal**: Explicitly answer Introduction's research question in Discussion

**Quick Actions**:
- [ ] Re-read Introduction final paragraph (identify research question)
- [ ] Add "Interpretation" subsection in Discussion (after "Principal findings")
- [ ] Write explicit answer:
  - [ ] State hypothesis ("We hypothesized [X]")
  - [ ] Confirm/refute with NMA data
  - [ ] Explain paradoxes (methodological, not speculative)
- [ ] Remove alternative hypothesis dead-ends

**Pass Criteria**:
- ✅ "Our hypothesis was [X]" statement present in Discussion
- ✅ Direct confirmation/refutation with primary NMA results
- ✅ Paradoxes explained with methodological rationale
- ✅ Zero unresolved hypotheses

---

### ☐ 3. Overclaim Prevention (30 min)

**📖 Detailed guide**: [Overclaim Prevention Guide](../../references/overclaim-prevention-guide.md)

**Goal**: Remove language that triggers desk rejection or major revisions

**Quick Actions**:
- [ ] Run enhanced claim audit:
  ```bash
  cd /Users/htlin/meta-pipe/tooling/python
  uv run ../../ma-publication-quality/scripts/claim_audit.py \
    --abstract ../../projects/<project-name>/07_manuscript/00_abstract.qmd \
    --results ../../projects/<project-name>/07_manuscript/03_results.qmd \
    --discussion ../../projects/<project-name>/07_manuscript/04_discussion.qmd \
    --out ../../projects/<project-name>/09_qa/claim_audit.md
  ```
- [ ] Fix CRITICAL severity overclaims:
  - [ ] Remove: "proved", "conclusively demonstrated", "definitively shows"
  - [ ] Replace with: "suggests", "supports", "is consistent with"
- [ ] Fix HIGH severity mismatches:
  - [ ] GRADE LOW + "robust findings" → "preliminary findings"
  - [ ] p=0.048 + "strong evidence" → "modest evidence"
  - [ ] I²>50% + "minimal heterogeneity" → "moderate heterogeneity"
- [ ] Verify numeric consistency:
  - [ ] Abstract HR = Results Table HR (exact match)
  - [ ] Abstract CI = Results Table CI
  - [ ] Abstract P-value = Results Table P-value
  - [ ] Abstract I² = Results Heterogeneity I²
- [ ] Check Limitations section:
  - [ ] ≥100 words (not superficial)
  - [ ] Addresses study-level limitations (open-label, industry sponsorship)
  - [ ] Addresses NMA-specific limitations (intransitivity, inconsistency)
  - [ ] Acknowledges immature outcomes (median OS not reached)

**Pass Criteria**:
- ✅ Zero CRITICAL severity overclaims
- ✅ Zero HIGH severity GRADE-claim mismatches
- ✅ All Abstract numbers exactly match Results (no rounding differences)
- ✅ Limitations section ≥100 words with specific issues

**Tools**:
- `claim_audit.md` output (lists issues with severity + context)

---

### ☐ 4. Journal-Specific Materials (30-60 min)

**📖 Detailed guide**: [Journal Materials Guide](../../references/journal-materials-guide.md)

**Goal**: Add required materials for target journal (+20% editorial interest)

**Choose ONE target journal**:

#### Option A: JAMA Oncology (clinical impact)

- [ ] Create Key Points box (≤350 words):
  - [ ] Question (1 sentence)
  - [ ] Findings (2-3 sentences with effect sizes)
  - [ ] Meaning (2-3 sentences with scenario-based guidance)
  - [ ] Template: [key-points-box.md](../templates/key-points-box.md)
- [ ] Embed in Abstract (after structured abstract, before main text)

**Pass Criteria**:
- ✅ Key Points box ≤350 words
- ✅ Question-Findings-Meaning structure clear

---

#### Option B: Lancet Oncology (high-novelty NMA)

- [ ] Create Research in Context panel (~450 words):
  - [ ] Evidence before this study (2-3 sentences)
  - [ ] Added value of this study (3-4 sentences)
  - [ ] Implications of all available evidence (3-4 sentences)
  - [ ] Template: [research-in-context.md](../templates/research-in-context.md)
- [ ] Embed after Title page, before Abstract

**Pass Criteria**:
- ✅ Research in Context panel 400-500 words
- ✅ 3-section structure clear

---

#### Option C: Nature Medicine (mechanistic insights)

- [ ] Add mechanistic insights paragraph in Discussion (150-200 words):
  - [ ] Why does this work biologically?
  - [ ] Explain paradoxes with biology
- [ ] Create Plain Language Summary (≤150 words, 8th-grade level)

**Pass Criteria**:
- ✅ Mechanistic paragraph 150-200 words
- ✅ Plain Language Summary ≤150 words, readable by non-experts

---

### ☐ 5. Transitivity/Assumptions Transparency (NMA only, 30 min)

**📖 Detailed guide**: [Transitivity Assessment Guide](../../references/transitivity-guide.md)

**Goal**: Demonstrate NMA rigor (-80% "insufficient NMA rigor" rejections)

**Quick Actions**:
- [ ] Create Supplementary Table: Detailed Transitivity Assessment
  - [ ] List ≥10 effect modifiers (age, PD-L1, stage, geographic, follow-up)
  - [ ] Compare across treatments (mean values, distributions)
  - [ ] Flag Major concerns (e.g., Geographic: Asia 80% vs 20%)
  - [ ] Flag Minor concerns (e.g., Age: mean 62 vs 64, not clinically meaningful)
  - [ ] Template: See early-immuno-timing-nma `supplementary_table_s6_transitivity.md`
- [ ] Add explicit limitations paragraph in Discussion (≥75 words):
  - [ ] "Transitivity assumption may be violated by [X, Y, Z]"
  - [ ] Explain clinical significance
  - [ ] NOT generic ("Transitivity cannot be guaranteed")
- [ ] Update CINeMA GRADE assessment:
  - [ ] Downgrade certainty for intransitivity (if major concerns)
  - [ ] Provide specific rationale
  - [ ] NOT generic ("Downgraded for intransitivity per CINeMA")

**Pass Criteria**:
- ✅ Supplementary Table lists ≥10 effect modifiers
- ✅ Major vs Minor concerns clearly flagged
- ✅ Limitations paragraph ≥75 words, specific issues
- ✅ CINeMA GRADE rationale specific

**Tools**:
- Extract baseline from: `05_extraction/extraction.csv`
- Compare distributions: R script `06_analysis/nma_transitivity_check.R`

---

## Final Verification

After completing all 5 items:

- [ ] Re-run publication readiness score:
  ```bash
  cd /Users/htlin/meta-pipe/tooling/python
  uv run ../../ma-end-to-end/scripts/publication_readiness_score.py \
    --root ../../projects/<project-name> \
    --out ../../projects/<project-name>/09_qa/readiness_score.md
  ```
- [ ] **Expected**: ≥95% readiness score
- [ ] If <95%: Review `readiness_score.md`, fix issues, re-run

---

## Next Steps

Once Phase 3 complete:

```bash
# Open Stage 10 Pre-Submission Quickcard
open ma-submission-prep/assets/quickcards/stage10-quickcard.md

# Or detailed checklist
open ma-submission-prep/assets/checklists/stage10-checklist.md
```

---

**Version**: 1.0.1 (2026-02-18) - Refactored for Progressive Disclosure
**Source**: early-immuno-timing-nma project (validated)
**Quick Reference**: [Phase 3 Quickcard](../quickcards/phase3-quickcard.md)
