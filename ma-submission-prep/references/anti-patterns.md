# Anti-Patterns Consolidated Reference

**Status**: ✅ **Complete** (v1.0.0, 2026-02-18)

**Purpose**: Centralized repository of all anti-patterns from guides, organized by severity

**Usage**: Quick scan before submission (5 min) to catch common mistakes

---

## How to Use This Reference

**Before submission**:
1. Scan CRITICAL severity (3 min) — desk rejection triggers
2. Scan HIGH severity (2 min) — major revision triggers
3. Optional: Scan MODERATE severity — minor revisions

**Color code**:
- 🔴 **CRITICAL**: Desk rejection risk >30%
- ⚠️ **HIGH**: Major revision required >60%
- ℹ️ **MODERATE**: Minor revision or clarification request

---

## 🔴 CRITICAL Severity (Desk Rejection Triggers)

### 1. Absolute Claims Without Uncertainty (Overclaim)

**Source**: [overclaim-prevention-guide.md](overclaim-prevention-guide.md#pattern-1)

**Example**:
```markdown
❌ BAD:

Our NMA **proved** that perioperative ICI is superior to adjuvant.
```

**Fix**:
```markdown
✅ GOOD:

Our NMA **suggests** that perioperative ICI is superior to adjuvant (HR 0.565, 95% CI 0.460-0.695).
```

**Keywords to avoid**: "proved", "conclusively demonstrated", "definitively established", "confirmed beyond doubt"

**Replacement words**: "suggests", "indicates", "appears to", "is consistent with"

---

### 2. Submitting Without PROSPERO ID

**Source**: [lessons-repository.md](lessons-repository.md#anti-pattern-4)

**Consequence**: Automatic desk rejection at JAMA Oncology, Lancet Oncology

**Fix**: Register on PROSPERO before Stage 10 (30 min)

**URL**: https://www.crd.york.ac.uk/prospero/

---

### 3. Generic Transitivity Statement (NMA)

**Source**: [transitivity-guide.md](transitivity-guide.md#anti-pattern-1)

**Example**:
```markdown
❌ BAD:

Transitivity cannot be guaranteed in any network meta-analysis, as is standard for this methodology.
```

**Fix**:
```markdown
✅ GOOD:

Transitivity assumption may be violated by geographic distribution imbalances (Asia 80% vs 20%) and follow-up duration disparities (60 months vs 25-38 months). Geographic differences may affect outcomes, as Asian populations show higher PD-L1 positivity rates (45% vs 30%).
```

**Required**: Supplementary Table with ≥10 effect modifiers, Major/Minor/None assessment

---

### 4. Data Inconsistency (Abstract vs Results)

**Source**: [lessons-repository.md](lessons-repository.md#success-factor-3)

**Example**:
```markdown
❌ BAD:

Abstract: HR 0.56 (95% CI 0.46-0.70)
Results Table: HR 0.565 (95% CI 0.460-0.695)
```

**Why CRITICAL**: Reviewers cannot determine which is correct

**Fix**: Exact match across all sections (use `results_consistency_report.py`)

---

## ⚠️ HIGH Severity (Major Revision Triggers)

### 5. Implicit Hypothesis Resolution

**Source**: [hypothesis-resolution-guide.md](hypothesis-resolution-guide.md#anti-pattern-1)

**Example**:
```markdown
❌ BAD (Discussion):

Perioperative ICI showed superior EFS (HR 0.565, 95% CI 0.460-0.695). This finding is consistent with prior studies.
```

**Fix**:
```markdown
✅ GOOD (Discussion Interpretation):

**Our hypothesis that perioperative ICI would optimize EFS is confirmed**: HR 0.565 (95% CI 0.460-0.695), 87.8% probability best.
```

**Required**: Explicit "Our hypothesis was [confirmed/refuted]" statement in Discussion

---

### 6. Alternative Hypothesis Dead-End

**Source**: [hypothesis-resolution-guide.md](hypothesis-resolution-guide.md#anti-pattern-2)

**Example**:
```markdown
❌ BAD:

Alternatively, adjuvant-only might be superior due to prolonged immune activation. However, our NMA shows perioperative is best for EFS.
```

**Fix**: Delete entirely, or expand with subgroup data if available

---

### 7. Speculative Biology to Explain Paradoxes

**Source**: [hypothesis-resolution-guide.md](hypothesis-resolution-guide.md#anti-pattern-3)

**Example**:
```markdown
❌ BAD:

The OS superiority of adjuvant ICI may reflect enhanced memory T-cell formation post-surgery, leading to durable micrometastatic control.
```

**Fix**:
```markdown
✅ GOOD:

Adjuvant's paradoxically better OS ranking appears methodologically explainable: IMpower010 (adjuvant) has 5-year median follow-up with mature OS estimates, whereas perioperative trials report median OS not reached after only 25-38 months.
```

**Principle**: Use methodological rationale, not biological speculation

---

### 8. Generic "Evidence Before This Study" (Lancet Research in Context)

**Source**: [journal-materials-guide.md](journal-materials-guide.md#anti-pattern-2)

**Example**:
```markdown
❌ BAD:

Previous studies have investigated immune checkpoint inhibitors in NSCLC. However, more research is needed.
```

**Fix**:
```markdown
✅ GOOD:

Prior systematic reviews (Smith et al, 2024, Lancet Oncol; Jones et al, 2025, JAMA Oncol) have established ICI efficacy in resectable NSCLC. However, no network meta-analysis has directly compared the three timing strategies to identify the optimal approach.
```

**Required**: Cite 2-3 specific reviews, identify precise gap

---

### 9. Superficial Limitations Section (<50 words)

**Source**: [lessons-repository.md](lessons-repository.md#anti-pattern-5)

**Example**:
```markdown
❌ BAD (35 words):

This study has limitations. We used published data. Transitivity cannot be guaranteed. More research is needed.
```

**Fix**: ≥75 words, specific concerns with data (see transitivity-guide.md for NMA template)

---

### 10. Missing Supplementary Table for Transitivity (NMA)

**Source**: [transitivity-guide.md](transitivity-guide.md#anti-pattern-2)

**Consequence**: Reviewers ask "did you assess transitivity?"

**Fix**: Create Supplementary Table S6 with ≥10 effect modifiers

---

## ℹ️ MODERATE Severity (Minor Revisions)

### 11. Copy-Paste from Abstract (JAMA Key Points)

**Source**: [journal-materials-guide.md](journal-materials-guide.md#anti-pattern-1)

**Example**:
```markdown
❌ BAD (Key Points Findings):

In this NMA of 10 RCTs (N=9,907), perioperative ICI showed HR 0.565 (95% CI 0.460-0.695) for EFS.
```

**Fix**: Rephrase, add context (see key-points-box.md template)

---

### 12. Specific Year Predictions

**Source**: [hypothesis-resolution-guide.md](hypothesis-resolution-guide.md#anti-pattern-4), [lessons-repository.md](lessons-repository.md#anti-pattern-3)

**Example**:
```markdown
❌ BAD:

We expect perioperative OS data to mature by 2027-2028.
```

**Fix**:
```markdown
✅ GOOD:

We anticipate perioperative OS estimates will mature typically 4-6 years from trial initiation.
```

---

### 13. Abbreviations in Plain Language Summary

**Source**: [journal-materials-guide.md](journal-materials-guide.md#anti-pattern-4)

**Example**:
```markdown
❌ BAD:

ICI given peri-op reduced EFS events by 44% (HR 0.56, 95% CI 0.46-0.70, P<0.001).
```

**Fix**:
```markdown
✅ GOOD:

Giving immune checkpoint inhibitors both before and after surgery reduced the risk of cancer returning by 44%.
```

**Required**: 8th-grade reading level, no statistics

---

### 14. Overclaims in "Meaning" (JAMA Key Points)

**Source**: [journal-materials-guide.md](journal-materials-guide.md#anti-pattern-3)

**Example**:
```markdown
❌ BAD:

Perioperative ICI is superior and should be universally adopted as the new standard of care.
```

**Fix**:
```markdown
✅ GOOD:

Perioperative ICI appears to optimize EFS, though longer-term OS data are needed. Shared decision-making should weigh EFS gains against treatment duration.
```

---

### 15. Generic Factor List (Clinical Implications)

**Source**: [clinical-implications-guide.md](clinical-implications-guide.md#anti-pattern-1), [lessons-repository.md](lessons-repository.md#anti-pattern-2)

**Example**:
```markdown
❌ BAD:

Treatment selection should consider:
1. Patient eligibility for surgery
2. Tumor biology
3. Treatment tolerance
```

**Fix**: Scenario-based guidance with 4-5 scenarios, each with 5 elements (see clinical-scenario-template.md)

---

### 16. Generic CINeMA GRADE Rationale

**Source**: [transitivity-guide.md](transitivity-guide.md#anti-pattern-4)

**Example**:
```markdown
❌ BAD:

Downgraded for intransitivity per CINeMA.
```

**Fix**:
```markdown
✅ GOOD:

Downgraded 1 level for intransitivity: Geographic distribution imbalances (Asia 80% vs 20%) and PD-L1 differences may modify treatment effects.
```

---

### 17. All "None" Transitivity Assessments (NMA)

**Source**: [transitivity-guide.md](transitivity-guide.md#anti-pattern-3)

**Example**:

| Effect Modifier | Assessment |
|-----------------|------------|
| Age | None |
| Sex | None |
| Stage | None |

**Why MODERATE**: Unrealistic (every NMA has imbalances), signals superficial assessment

**Fix**: Honestly flag Major/Minor concerns

---

## Quick Scan Checklist (5 min)

Before submission, verify:

**CRITICAL (must fix)**:
- [ ] No "proved", "conclusively demonstrated" claims
- [ ] PROSPERO ID present in manuscript (not `[PENDING]`)
- [ ] Transitivity assessed with Supplementary Table (NMA only)
- [ ] Data consistency verified (Abstract = Results Table)

**HIGH (strongly recommended)**:
- [ ] Hypothesis explicitly resolved in Discussion ("Our hypothesis was confirmed")
- [ ] No alternative hypothesis dead-ends
- [ ] Paradoxes explained with methodological rationale (not speculative biology)
- [ ] Research in Context cites specific reviews (Lancet)
- [ ] Limitations ≥75 words, specific concerns

**MODERATE (nice to have)**:
- [ ] JAMA Key Points rephrased (not copy-paste from Abstract)
- [ ] Relative timeframes used (not "2027-2028")
- [ ] Plain Language Summary has no abbreviations (Nature Medicine)
- [ ] Clinical Implications scenario-based (not generic factor list)
- [ ] CINeMA GRADE rationale specific (not "downgraded per CINeMA")

---

## Statistics (Coverage)

**Total anti-patterns catalogued**: 17
- 🔴 CRITICAL: 4 (desk rejection triggers)
- ⚠️ HIGH: 6 (major revision triggers)
- ℹ️ MODERATE: 7 (minor revision triggers)

**Source guides**:
- [overclaim-prevention-guide.md](overclaim-prevention-guide.md): 12 patterns
- [hypothesis-resolution-guide.md](hypothesis-resolution-guide.md): 5 patterns
- [clinical-implications-guide.md](clinical-implications-guide.md): 5 patterns
- [journal-materials-guide.md](journal-materials-guide.md): 4 patterns
- [transitivity-guide.md](transitivity-guide.md): 4 patterns
- [lessons-repository.md](lessons-repository.md): 5 patterns

**Total unique anti-patterns**: 17 (some overlap consolidated)

---

**Version**: 1.0.0 (2026-02-18)
**Source**: Consolidated from 6 reference guides
**Authors**: Claude + htlin

**Future expansion**: Add anti-patterns from future projects, update severity based on empirical rejection rates
