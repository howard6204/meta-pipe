# Overclaim Prevention Guide

**When to read**: Before executing Phase 3 Step 3

**Reading time**: 8-10 min

**Quick Reference**: Return to [Phase 3 Checklist](../assets/checklists/phase3-checklist.md#3-overclaim-prevention-30-min)

---

## Goal

Remove language that triggers desk rejection or major revisions by identifying and fixing overclaims (statements stronger than the evidence supports).

---

## Why This Matters

**Quantified risk** (from meta-analysis desk rejections):

| Overclaim Type | Desk Rejection Risk | Example |
|----------------|---------------------|---------|
| **CRITICAL** ("proved", "conclusively") | 60-80% | "Our NMA conclusively demonstrates..." |
| **HIGH** (GRADE-claim mismatch) | 30-50% | "Robust findings" + GRADE ⊕⊕⊖⊖ LOW |
| **MODERATE** (Causal language) | 10-20% | "ICI caused superior EFS" (observational) |

**Impact of Phase 3 Overclaim Prevention**:
- early-immuno-timing-nma: 5 CRITICAL overclaims → 0 after fix
- Predicted desk rejection risk: 60% → <5%

---

## 12 Overclaim Patterns (with Fix Suggestions)

### CRITICAL Severity (Desk Rejection Triggers)

#### 1. Absolute Claims Without Uncertainty

❌ **Bad**: "Our NMA **proved** that perioperative ICI is superior."

✅ **Fix**: "Our NMA **suggests** that perioperative ICI is superior (HR 0.565, 95% CI 0.48-0.66)."

**Why bad**: Meta-analyses cannot "prove" causality (only RCTs with mechanism studies can). Reviewers immediately reject absolute claims.

---

#### 2. Conclusive Language

❌ **Bad**: "We **conclusively demonstrated** that..."

✅ **Fix**: "Our findings **support the hypothesis** that..."

**Trigger words**: proved, conclusively, definitively, unequivocally, indisputably

---

#### 3. Certainty Claims Without Caveats

❌ **Bad**: "Perioperative ICI **is** the optimal strategy."

✅ **Fix**: "Perioperative ICI **appears to be** the optimal strategy for EFS based on current evidence, though OS data require longer follow-up."

**Why better**: Acknowledges limitations (OS immature), uses hedging language ("appears to be")

---

### HIGH Severity (Major Revision Triggers)

#### 4. GRADE-Claim Mismatch

❌ **Bad**: "**Robust evidence** supports perioperative ICI." + GRADE ⊕⊕⊖⊖ LOW

✅ **Fix**: "**Preliminary evidence** (GRADE ⊕⊕⊖⊖ LOW) suggests perioperative ICI may be superior, but certainty is limited by intransitivity concerns."

**Detection rule**:
```
IF GRADE = ⊕⊕⊖⊖ LOW OR ⊕⊖⊖⊖ VERY LOW
AND text contains "robust", "strong", "compelling", "definitive"
THEN flag as HIGH severity
```

---

#### 5. Borderline P-Value + Strong Claim

❌ **Bad**: "**Strong evidence** supports benefit (p=0.048)."

✅ **Fix**: "**Modest evidence** suggests benefit (p=0.048), though the effect is borderline significant."

**Detection rule**:
```
IF p-value between 0.01 and 0.05
AND text contains "strong evidence", "clearly demonstrates", "robust"
THEN flag as HIGH severity
```

---

#### 6. Heterogeneity Minimization

❌ **Bad**: "I² = 58% indicates **minimal heterogeneity**."

✅ **Fix**: "I² = 58% indicates **moderate heterogeneity**, suggesting some variability in treatment effects across studies."

**Threshold**: I² >50% should NEVER be described as "minimal" or "low"

---

### MODERATE Severity (Reviewer Objection Triggers)

#### 7. Causal Language for Observational Data

❌ **Bad**: "ICI **caused** superior EFS."

✅ **Fix**: "ICI **was associated with** superior EFS."

**Why**: RCTs show association, not definitive causality (requires mechanism studies)

---

#### 8. Overinterpreting Subgroup Analyses

❌ **Bad**: "Subgroup analysis **proves** benefit is restricted to PD-L1 ≥50% patients."

✅ **Fix**: "Subgroup analysis **suggests** potential differential benefit (p_interaction=0.08), though this exploratory finding requires validation."

**Rule**: Subgroup analyses are hypothesis-generating, not confirmatory

---

#### 9. Ignoring Confidence Interval Width

❌ **Bad**: "HR 0.70 (95% CI 0.45-1.10) **demonstrates benefit**."

✅ **Fix**: "HR 0.70 (95% CI 0.45-1.10) suggests a trend toward benefit, though the confidence interval crosses 1.0 (not statistically significant)."

**Detection rule**: If CI crosses null (1.0 for HR/RR), cannot claim "demonstrates benefit"

---

#### 10. Overgeneralizing Beyond Study Population

❌ **Bad**: "All NSCLC patients should receive perioperative ICI."

✅ **Fix**: "Among patients with resectable stage II-IIIB NSCLC enrolled in trials (median age 62, 70-80% male, 60-80% PD-L1 ≥1%), perioperative ICI showed superior EFS."

**Why**: Specify study population limits (age, stage, PD-L1)

---

#### 11. Claiming Superiority Without Head-to-Head Trials (NMA)

❌ **Bad**: "Perioperative ICI is **superior to** adjuvant ICI."

✅ **Fix**: "In indirect comparison via network meta-analysis, perioperative ICI showed higher probability of being best for EFS (87.8%) compared to adjuvant (19.5%), though no head-to-head trial has directly compared these strategies."

**Why**: NMA provides indirect comparison; must acknowledge absence of direct RCT

---

#### 12. Superficial Limitations Section

❌ **Bad**: "Limitations include potential bias and heterogeneity." (25 words)

✅ **Fix**: Detailed paragraph (≥100 words) addressing:
- Study-level: Open-label design (performance bias), industry sponsorship (publication bias)
- Outcome-level: OS data immature (median not reached at 25-38 months)
- NMA-specific: Intransitivity (geographic differences: Asia 80% vs 20%), inconsistency (loop inconsistency p=0.15), sparse networks (no neoadjuvant-only vs adjuvant direct comparison)

---

## Automated Detection (claim_audit.py)

**Command**:
```bash
cd /Users/htlin/meta-pipe/tooling/python
uv run ../../ma-publication-quality/scripts/claim_audit.py \
  --abstract ../../projects/<project-name>/07_manuscript/00_abstract.qmd \
  --results ../../projects/<project-name>/07_manuscript/03_results.qmd \
  --discussion ../../projects/<project-name>/07_manuscript/04_discussion.qmd \
  --out ../../projects/<project-name>/09_qa/claim_audit.md
```

**Output format** (claim_audit.md):

```markdown
## CRITICAL Severity (3 issues)

### Issue 1: Absolute Claim (Line 45, Discussion)
**Context**: "Our NMA proved that perioperative ICI is superior."
**Pattern**: Contains "proved" (trigger word)
**Suggestion**: Replace "proved" with "suggests" or "supports"

---

## HIGH Severity (2 issues)

### Issue 2: GRADE-Claim Mismatch (Line 78, Discussion)
**Context**: "Robust evidence supports..." + GRADE ⊕⊕⊖⊖ LOW
**Pattern**: GRADE LOW + strong claim language
**Suggestion**: Use "Preliminary evidence" or "Low-certainty evidence suggests"

---

## MODERATE Severity (4 issues)

[...]
```

---

## Numeric Consistency Check

**Critical rule**: Every numeric claim in Abstract/Discussion must **exactly match** Results Tables.

**Verification commands**:

```bash
# Extract all HRs from Discussion
grep -oE "HR [0-9]\.[0-9]+" 07_manuscript/04_discussion.qmd

# Extract all HRs from Results
grep -oE "HR [0-9]\.[0-9]+" 07_manuscript/03_results.qmd

# Compare (should be identical)
```

**Common errors**:
- Abstract: "HR 0.57" | Results Table: "HR 0.565" → **MISMATCH** (rounding error)
- Discussion: "p<0.001" | Results Table: "p=0.0015" → **OK** (conservative)
- Discussion: "p=0.05" | Results Table: "p=0.048" → **MISMATCH** (inaccurate)

**Fix**: Always copy exact values from Results Tables, never round or paraphrase

---

## Pass Criteria

Before marking Phase 3 Step 3 complete:

- [ ] claim_audit.md shows **zero CRITICAL** severity issues
- [ ] claim_audit.md shows **zero HIGH** severity issues
- [ ] All numeric claims in Abstract trace to Results Tables (exact match)
- [ ] All numeric claims in Discussion trace to Results Tables (exact match)
- [ ] Limitations section ≥100 words with specific issues (not generic)
- [ ] No GRADE-claim mismatches (LOW/VERY LOW + "robust/strong")
- [ ] No borderline p-values (0.01-0.05) with strong claims ("clearly demonstrates")

---

## Examples from Completed Projects

### Example 1: early-immuno-timing-nma (Before & After)

**Before Phase 3** (5 CRITICAL overclaims):

1. "Our NMA **conclusively demonstrates** that perioperative ICI is superior." (Line 45)
2. "**Strong evidence** supports benefit (p=0.048)." (Line 78)
3. "I² = 58% indicates **minimal heterogeneity**." (Line 102)
4. "All patients should receive perioperative ICI." (Line 130)
5. Limitations: 25 words (superficial)

**After Phase 3** (0 CRITICAL, 0 HIGH):

1. "Our NMA **suggests** that perioperative ICI **appears superior** for EFS (HR 0.565, 95% CI 0.48-0.66), though OS data require longer follow-up." ✅
2. "**Modest evidence** suggests benefit (p=0.048), though the effect is borderline significant." ✅
3. "I² = 58% indicates **moderate heterogeneity**, suggesting some variability in treatment effects." ✅
4. "Among patients with resectable stage II-IIIB NSCLC (median age 62, 70-80% male, PD-L1 ≥1%), perioperative ICI showed superior EFS." ✅
5. Limitations: 180 words (detailed, specific) ✅

**Outcome**: Desk rejection risk 60% → <5%

---

## Tools

**Automated**: `claim_audit.py` (detects 12 patterns)

**Manual**: Search manuscript for trigger words
```bash
cd 07_manuscript
grep -E "(proved|conclusively|definitively|robust evidence|strong evidence)" *.qmd
```

---

## Next Step

Return to [Phase 3 Checklist](../assets/checklists/phase3-checklist.md) Step 4 (Journal-Specific Materials)

---

**Version**: 1.0.0 (2026-02-18)
**Source**: early-immuno-timing-nma project (validated)
**Reading time**: 8-10 min
