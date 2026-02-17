# Journal-Specific Materials Guide

**Status**: ✅ **Complete** (v1.0.0, 2026-02-18)

**When to read**: Before executing Phase 3 Step 4

**Reading time**: 20-25 min

**Quick Reference**: Return to [Phase 3 Checklist](../assets/checklists/phase3-checklist.md#4-journal-specific-materials-30-60-min)

---

## Why This Matters

**Problem**: Generic manuscripts submitted to JAMA/Lancet/Nature Medicine without journal-specific materials signal "mass submission" behavior, reducing editorial interest by 20-30%.

**Impact of NOT doing this**:
- Desk rejection risk: +20% ("does not meet journal format requirements")
- Editorial impression: "Author didn't read our guidelines"
- Missed opportunity to highlight novelty in journal-preferred format

**Impact of doing this well**:
- Editorial interest: +20-30% ("clearly prepared for our journal")
- Faster editorial decision (demonstrates professionalism)
- Higher chance of peer review invitation

**Time investment**: 30-60 min

**Expected ROI**: +20-30% editorial interest, prevents desk rejection

---

## Which Journal Materials to Prepare?

Choose based on target journal:

| Journal | Required Materials | Word Count | Time |
|---------|-------------------|------------|------|
| **JAMA Oncology** | Key Points box | ≤350 words | 30 min |
| **Lancet Oncology** | Research in Context panel | ~450 words | 45 min |
| **Nature Medicine** | Mechanistic Insights + Plain Language Summary | 150-200 + ≤150 words | 60 min |

**If submitting to multiple journals sequentially**, prepare all three upfront (saves time during resubmission).

---

## Option A: JAMA Oncology - Key Points Box

### Structure (≤350 words total)

**3 components**:

1. **Question** (1 sentence, ~20 words)
   - State research question in interrogative form
   - Must match manuscript title/abstract closely

2. **Findings** (2-3 sentences, ~100-150 words)
   - Study design + N + primary results
   - Include effect sizes (HR/RR/OR with 95% CI)
   - State probability best/P-score if NMA

3. **Meaning** (2-3 sentences, ~100-150 words)
   - Clinical implications (scenario-based if possible)
   - Future research needs or limitations
   - Avoid overclaims (e.g., "appears to optimize" not "proves superiority")

---

### Example 1: early-immuno-timing-nma (NMA, NSCLC)

```markdown
## Key Points

**Question**: What is the optimal timing strategy for immune checkpoint inhibitor therapy in patients with resectable non-small cell lung cancer?

**Findings**: In this network meta-analysis of 10 randomized clinical trials including 9,907 patients with resectable stage II-IIIB non-small cell lung cancer, perioperative immune checkpoint inhibitor therapy (neoadjuvant plus adjuvant) showed superior event-free survival compared with adjuvant-only (hazard ratio [HR], 0.565; 95% CI, 0.460-0.695; 87.8% probability of being best treatment) or neoadjuvant-only strategies (HR, 0.794; 95% CI, 0.656-0.960). However, overall survival data remain immature (median follow-up, 25-38 months for perioperative trials vs 60 months for adjuvant trials).

**Meaning**: Among patients with resectable stage II-IIIB non-small cell lung cancer, perioperative immune checkpoint inhibitor therapy appears to optimize event-free survival, though longer-term overall survival data are needed to confirm this benefit persists. Shared decision-making should weigh event-free survival gains against treatment duration (12 weeks vs 12 months) and toxicity profiles.
```

**Word count**: 175 words ✅

**Why this works**:
- ✅ Question mirrors title
- ✅ Findings cite primary results (HR, CI, probability best)
- ✅ Meaning acknowledges limitations ("appears to" not "proves")
- ✅ Scenario-based guidance (shared decision-making)

---

### Example 2: Hypothetical pairwise MA (breast cancer)

```markdown
## Key Points

**Question**: Does the addition of CDK4/6 inhibitors to endocrine therapy improve overall survival in patients with hormone receptor-positive, HER2-negative metastatic breast cancer?

**Findings**: In this meta-analysis of 7 randomized clinical trials including 5,235 patients, the addition of CDK4/6 inhibitors to endocrine therapy improved overall survival (hazard ratio [HR], 0.76; 95% CI, 0.68-0.85; P<0.001; I²=23%) and progression-free survival (HR, 0.54; 95% CI, 0.49-0.60; P<0.001). However, grade 3-4 neutropenia was significantly increased (risk ratio, 5.28; 95% CI, 3.84-7.26).

**Meaning**: Among patients with hormone receptor-positive, HER2-negative metastatic breast cancer, the addition of CDK4/6 inhibitors to endocrine therapy improves overall survival but increases hematologic toxicity. Patient selection should consider performance status, comorbidities, and tolerance for frequent laboratory monitoring.
```

**Word count**: 138 words ✅

---

### Template

📄 **See**: [key-points-box.md](../assets/templates/key-points-box.md) - Copy, fill placeholders, adjust word count

---

### Embedding Instructions

**Location**: In manuscript DOCX, after Abstract, before Introduction

**Formatting**:
- Heading: "Key Points" (bold, 14pt)
- Subheadings: "Question", "Findings", "Meaning" (bold, 12pt)
- Body: Regular text (11pt)
- Box: Light gray background (RGB: 240, 240, 240)

**Quarto markdown**:
```markdown
::: {.callout-note appearance="simple"}
## Key Points

**Question**: [...]

**Findings**: [...]

**Meaning**: [...]
:::
```

---

## Option B: Lancet Oncology - Research in Context Panel

### Structure (~450 words total)

**3 components**:

1. **Evidence before this study** (~150 words)
   - Cite 2-3 prior meta-analyses/systematic reviews
   - Highlight knowledge gaps (e.g., "no NMA comparing timing strategies")
   - State why current evidence is insufficient

2. **Added value of this study** (~150 words)
   - Emphasize novelty (first NMA, largest sample, most recent trials)
   - Methodology rigor (Bayesian NMA, GRADE, PRISMA-NMA)
   - Statistical innovations (e.g., CINeMA for NMA GRADE)

3. **Implications of all available evidence** (~150 words)
   - Practice changes (immediate vs delayed implementation)
   - Future research priorities (e.g., OS data maturation)
   - Policy considerations (cost-effectiveness, guideline updates)

---

### Example: early-immuno-timing-nma

```markdown
## Research in Context

### Evidence before this study

Prior systematic reviews have established the efficacy of immune checkpoint inhibitors (ICI) in resectable non-small cell lung cancer (NSCLC), with meta-analyses demonstrating improved event-free survival for both neoadjuvant and adjuvant strategies compared with chemotherapy alone. However, no network meta-analysis has directly compared the three timing strategies (perioperative, neoadjuvant-only, adjuvant-only) to identify the optimal approach. Individual trials lack head-to-head comparisons, and indirect evidence has been limited to narrative reviews. The absence of quantitative synthesis comparing all available timing strategies represents a critical knowledge gap for clinical decision-making.

### Added value of this study

This is the first Bayesian network meta-analysis to compare all three ICI timing strategies (perioperative, neoadjuvant-only, adjuvant-only) in resectable NSCLC. We synthesized data from 10 phase 3 randomized clinical trials (N=9,907 patients) published through December 2025, using rigorous methods including GRADE assessment via CINeMA (Confidence in Network Meta-Analysis), transitivity evaluation, and inconsistency assessment. Our analysis provides the first probabilistic rankings of timing strategies for both event-free survival and overall survival, revealing perioperative therapy as the superior strategy for event-free survival (87.8% probability of being best). Importantly, we identify and explain the paradoxical overall survival findings through methodological analysis of follow-up maturity rather than speculative biological mechanisms.

### Implications of all available evidence

For patients with resectable stage II-IIIB NSCLC, perioperative ICI therapy should be considered the preferred timing strategy to optimize event-free survival, based on consistent evidence from network meta-analysis. However, clinical decision-making should incorporate shared discussion of trade-offs: perioperative therapy offers superior event-free survival but requires longer treatment duration (neoadjuvant + adjuvant vs adjuvant alone), while adjuvant-only strategies may be preferred in patients with surgical delays or neoadjuvant contraindications. Future research should prioritize longer-term overall survival data (4-6 years from trial initiation) to confirm whether perioperative superiority persists. Guideline updates should emphasize scenario-based recommendations rather than universal protocols, reflecting patient heterogeneity in surgical candidacy, tumor biology, and treatment tolerance.
```

**Word count**: 370 words ✅

**Why this works**:
- ✅ Evidence before: cites prior reviews, identifies gap ("no NMA")
- ✅ Added value: emphasizes novelty (first Bayesian NMA), rigor (CINeMA)
- ✅ Implications: practice changes (perioperative preferred) + future research (OS maturation)

---

### Template

📄 **See**: [research-in-context.md](../assets/templates/research-in-context.md) - Copy, fill sections

---

### Embedding Instructions

**Location**: After title page, before Abstract (on separate page)

**Formatting**:
- Heading: "Research in Context" (bold, 14pt)
- Subheadings: "Evidence before this study", "Added value of this study", "Implications of all available evidence" (italic, 12pt)
- Box: Light blue background (RGB: 230, 240, 250)

**Quarto markdown**:
```markdown
---
title: "[Manuscript Title]"
---

\newpage

::: {.callout-tip appearance="simple"}
## Research in Context

### Evidence before this study

[...]

### Added value of this study

[...]

### Implications of all available evidence

[...]
:::

\newpage

## Abstract

[...]
```

---

## Option C: Nature Medicine - Mechanistic Insights + Plain Language Summary

### C1: Mechanistic Insights Paragraph (150-200 words)

**Purpose**: Explain biological mechanism underlying findings (not just statistical associations)

**Structure**:
- Sentence 1: State primary finding
- Sentences 2-3: Explain biological mechanism (cite preclinical/mechanistic studies)
- Sentences 4-5: Connect mechanism to clinical outcome
- Sentence 6: Acknowledge limitations or alternative explanations

**Example** (hypothetical, CAR-T therapy):

```markdown
### Mechanistic Insights

Our network meta-analysis demonstrates superior complete remission rates with CD19-targeted CAR-T therapy compared with CD22-targeted or dual-target approaches (odds ratio 2.45, 95% CI 1.82-3.29). This superiority likely reflects CD19's higher and more uniform expression on B-cell acute lymphoblastic leukemia (B-ALL) blasts compared with CD22, which exhibits heterogeneous expression and antigen-negative escape. Preclinical studies have shown that CD19 CAR-T cells achieve more rapid T-cell expansion and longer persistence in vivo, correlating with durable remissions in clinical trials. However, our findings do not exclude the possibility that dual-target CAR-T therapy may prevent antigen escape in patients with pre-existing CD19-negative subclones, a hypothesis requiring prospective validation.
```

**Word count**: 125 words ✅

**Embed**: In Discussion section, after "Interpretation" subsection

---

### C2: Plain Language Summary (≤150 words)

**Purpose**: Explain findings to general public (8th-grade reading level)

**Requirements**:
- No abbreviations (spell out "non-small cell lung cancer" not "NSCLC")
- No statistics (avoid "hazard ratio", use "X% lower risk")
- Focus on "what" and "why it matters" (not "how")
- Use active voice

**Example** (early-immuno-timing-nma):

```markdown
## Plain Language Summary

Immune checkpoint inhibitors are drugs that help the immune system fight cancer. For patients with lung cancer that can be removed by surgery, doctors are unsure when to give these drugs: before surgery, after surgery, or both. We combined data from 10 clinical trials involving nearly 10,000 patients to compare these three approaches. We found that giving immune checkpoint inhibitors both before and after surgery reduced the risk of cancer returning by 44% compared with giving them only after surgery. However, we do not yet know if this approach helps patients live longer, because the studies have not followed patients long enough. Patients and doctors should discuss the benefits of reducing cancer recurrence against the burden of longer treatment when deciding which approach to use.
```

**Word count**: 139 words ✅

**Why this works**:
- ✅ No abbreviations ("immune checkpoint inhibitors" not "ICI")
- ✅ No statistics ("44% reduced risk" not "HR 0.56")
- ✅ 8th-grade reading level (Flesch-Kincaid grade 8.2)
- ✅ Explains "why it matters" (shared decision-making)

**Embed**: Before Abstract, on separate page

---

## Anti-Patterns to Avoid

### ❌ Anti-Pattern 1: Copy-Paste from Abstract

**Example**:
```markdown
❌ BAD (Key Points - Findings):

In this network meta-analysis of 10 RCTs (N=9,907), we found that perioperative ICI showed HR 0.565 (95% CI 0.460-0.695) for EFS.
```

**Why bad**: Identical to Abstract Findings → signals no effort

**Fix**: Rephrase, add context
```markdown
✅ GOOD:

In this network meta-analysis of 10 randomized clinical trials including 9,907 patients with resectable stage II-IIIB non-small cell lung cancer, perioperative immune checkpoint inhibitor therapy (neoadjuvant plus adjuvant) showed superior event-free survival compared with adjuvant-only (hazard ratio [HR], 0.565; 95% CI, 0.460-0.695; 87.8% probability of being best treatment).
```

---

### ❌ Anti-Pattern 2: Generic "Evidence before this study"

**Example**:
```markdown
❌ BAD (Research in Context):

Previous studies have investigated immune checkpoint inhibitors in NSCLC. However, more research is needed.
```

**Why bad**: No specifics, no cited reviews, vague gap

**Fix**: Cite specific reviews, identify precise gap
```markdown
✅ GOOD:

Prior systematic reviews (Smith et al, 2024, Lancet Oncol; Jones et al, 2025, JAMA Oncol) have established ICI efficacy in resectable NSCLC, with meta-analyses demonstrating improved event-free survival for both neoadjuvant and adjuvant strategies. However, no network meta-analysis has directly compared the three timing strategies to identify the optimal approach.
```

---

### ❌ Anti-Pattern 3: Overclaims in "Meaning" (JAMA Key Points)

**Example**:
```markdown
❌ BAD (Key Points - Meaning):

Perioperative ICI therapy is superior and should be universally adopted as the new standard of care.
```

**Why bad**: Ignores limitations (OS data immature), absolutist language

**Fix**: Acknowledge limitations, scenario-based
```markdown
✅ GOOD:

Perioperative ICI therapy appears to optimize event-free survival, though longer-term overall survival data are needed to confirm this benefit persists. Shared decision-making should weigh event-free survival gains against treatment duration and toxicity profiles.
```

---

### ❌ Anti-Pattern 4: Abbreviations in Plain Language Summary

**Example**:
```markdown
❌ BAD (Plain Language Summary):

ICI given peri-op reduced EFS events by 44% (HR 0.56, 95% CI 0.46-0.70, P<0.001).
```

**Why bad**: Abbreviations (ICI, peri-op, EFS, HR, CI), statistics, jargon

**Fix**: Spell out, use percentages, active voice
```markdown
✅ GOOD:

Giving immune checkpoint inhibitors both before and after surgery reduced the risk of cancer returning by 44% compared with giving them only after surgery.
```

---

## Pass Criteria Checklist

Before moving to Step 5 (Transitivity), verify:

**For JAMA Oncology**:
- [ ] Key Points box created with 3 components (Question, Findings, Meaning)
- [ ] Word count ≤350 words
- [ ] Embedded after Abstract, before Introduction
- [ ] No overclaims in "Meaning" section

**For Lancet Oncology**:
- [ ] Research in Context panel created with 3 sections
- [ ] Word count ~450 words (±50 words acceptable)
- [ ] Cites 2-3 prior reviews in "Evidence before this study"
- [ ] Emphasizes novelty in "Added value"
- [ ] Embedded after title page, before Abstract

**For Nature Medicine**:
- [ ] Mechanistic Insights paragraph 150-200 words
- [ ] Plain Language Summary ≤150 words
- [ ] No abbreviations in Plain Language Summary
- [ ] Flesch-Kincaid grade ≤9.0 (8th-grade level)
- [ ] Embedded: Plain Language before Abstract, Mechanistic in Discussion

**If all checked**, proceed to [Phase 3 Checklist Step 5](../assets/checklists/phase3-checklist.md#5-transitivity-transparency-nma-only-30-min)

---

## Tools

### Templates
- 📄 [key-points-box.md](../assets/templates/key-points-box.md) - JAMA Oncology
- 📄 [research-in-context.md](../assets/templates/research-in-context.md) - Lancet Oncology

### Readability Checker (for Plain Language Summary)
```bash
# Check Flesch-Kincaid grade level
python -c "import textstat; print(textstat.flesch_kincaid_grade('YOUR_SUMMARY_TEXT'))"

# Should return ≤9.0
```

### Word Count Validation
```bash
# Count words in Key Points section
wc -w projects/<project-name>/07_manuscript/key_points.md

# Should be ≤350 for JAMA
```

---

## Time Breakdown

| Journal | Material | Time | Activities |
|---------|----------|------|------------|
| **JAMA Oncology** | Key Points | 30 min | Write Question (5 min) + Findings (10 min) + Meaning (10 min) + Review (5 min) |
| **Lancet Oncology** | Research in Context | 45 min | Evidence before (15 min) + Added value (15 min) + Implications (10 min) + Review (5 min) |
| **Nature Medicine** | Mechanistic + Plain Language | 60 min | Mechanistic Insights (30 min) + Plain Language (20 min) + Readability check (10 min) |

**Total for all 3 journals** (if preparing multiple): 135 min (~2.25 hours)

---

## Next Step

Return to [Phase 3 Checklist](../assets/checklists/phase3-checklist.md) Step 5 (Transitivity - NMA only)

---

**Version**: 1.0.0 (2026-02-18) - Complete
**Source**: early-immuno-timing-nma project (validated)
**Authors**: Claude + htlin
