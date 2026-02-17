# Brainstorming Best Practices for Meta-Analysis Topics

**Purpose**: Guide users and AI agents through effective topic brainstorming
**Audience**: Researchers, students, AI language models
**Version**: 2.0 (2026-02-17)

---

## 🎯 Quick Summary (TL;DR)

**GOOD topic** = Specific enough to pool + Broad enough to find studies

**Formula**: `Well-defined Population + Specific Intervention + Clear Comparator + Quantifiable Outcome = Feasible meta-analysis`

**Time investment**: 30-60 min brainstorming → prevents 10-40 hours wasted work

---

## 📋 The 5-Minute Self-Check (Before You Start)

Ask yourself these questions:

1. **Can I name 3 actual RCTs that fit my topic?** (Yes → ✅ | No → ⚠️ too narrow/obscure)
2. **Is my population specific?** (e.g., "adults with MDD" not "depressed people")
3. **Is my intervention clear?** (e.g., "SSRIs" not "antidepressants")
4. **Is my outcome measurable?** (e.g., "PHQ-9 score" not "feeling better")
5. **Would I find this in a major journal?** (Yes → ✅ clinically relevant)

**Score**: 5/5 ✅ Great! | 3-4/5 ⚠️ Needs refinement | 0-2/5 ❌ Restart

---

## ✅ Anatomy of a GOOD Topic

### Example 1: SSRIs vs SNRIs for Depression

```
Research Question:
Are selective serotonin reuptake inhibitors (SSRIs) more effective than
serotonin-norepinephrine reuptake inhibitors (SNRIs) for reducing depression
symptoms in adults with major depressive disorder?

Population: Adults (18-65) with diagnosed MDD
Intervention: SSRIs (any drug in class: fluoxetine, sertraline, etc.)
Comparator: SNRIs (any drug in class: venlafaxine, duloxetine, etc.)
Outcomes:
  - Primary: Depression symptom severity (HAM-D, BDI, PHQ-9 scores)
  - Secondary: Response rate, remission rate, adverse events

Expected Studies: 20-30 RCTs
Feasibility: HIGH (14/16 points)
```

**Why this works:**

✅ **Specific but not too narrow**: Allows multiple drugs within each class
✅ **Clear comparison**: Head-to-head drug class comparison
✅ **Measurable outcome**: Validated depression scales (HAM-D, BDI, PHQ-9)
✅ **Common intervention**: Both drug classes widely studied
✅ **Poolable**: All studies measure similar constructs

---

### Example 2: Digital CBT for Anxiety (Updating Existing Review)

```
Research Question:
Efficacy of digital cognitive-behavioral therapy (CBT) versus face-to-face CBT
for anxiety disorders: An updated systematic review and meta-analysis

Population: Adults (18+) with diagnosed anxiety disorders (GAD, social anxiety, panic)
Intervention: Digital CBT (internet, app-based, computer programs)
Comparator: Face-to-face CBT (traditional in-person therapy)
Outcomes:
  - Primary: Anxiety symptom reduction (GAD-7, STAI, BAI scores)
  - Secondary: Adherence, dropout rates, cost-effectiveness

Expected Studies: 15-20 RCTs (5-8 published since 2021 Cochrane review)
Feasibility: HIGH (13/16 points)
```

**Why this works:**

✅ **Builds on existing work**: Updates Cochrane 2021 review
✅ **Clear need**: New RCTs published since last review
✅ **Timely topic**: COVID-19 accelerated digital health adoption
✅ **Well-defined interventions**: Both CBT types have clear definitions
✅ **Standard outcomes**: Anxiety scales used across all studies

---

## ❌ Anatomy of a BAD Topic (And How to Fix)

### Example 1: "Cancer Treatment Effectiveness" (Too Broad)

```
❌ BAD:
Research Question: Are new cancer treatments better than old ones?
Population: Cancer patients
Intervention: New treatments
Comparator: Old treatments
Outcome: Effectiveness
```

**Why this fails:**

- ❌ "Cancer" → 200+ types (breast, lung, colon, etc.)
- ❌ "New treatments" → chemo? immunotherapy? surgery? radiation?
- ❌ "Old treatments" → which old treatments?
- ❌ "Effectiveness" → survival? QoL? tumor shrinkage?
- ❌ **Pooling impossible** → every study compares different things

**✅ HOW TO FIX:**

```
✅ REVISED:
Research Question: Is pembrolizumab more effective than chemotherapy for
improving progression-free survival in patients with advanced non-small cell
lung cancer (NSCLC) with PD-L1 expression ≥50%?

Population: Adults with advanced NSCLC, PD-L1 ≥50%, treatment-naive
Intervention: Pembrolizumab (200mg Q3W)
Comparator: Platinum-based chemotherapy (investigator's choice)
Outcomes:
  - Primary: Progression-free survival (PFS)
  - Secondary: Overall survival (OS), objective response rate (ORR)

Expected Studies: 8-12 RCTs
Feasibility: HIGH (15/16 points)
```

**What changed:**

- ✅ Narrowed to **specific cancer** (NSCLC)
- ✅ Specified **biomarker** (PD-L1 ≥50%)
- ✅ Named **specific drug** (pembrolizumab)
- ✅ Defined **outcome** (PFS, OS, ORR)

---

### Example 2: "Probiotics for Gut Health" (Vague Outcome)

```
❌ BAD:
Research Question: Are probiotics good for gut health?
Population: Adults
Intervention: Probiotics
Comparator: Placebo
Outcome: Gut health
```

**Why this fails:**

- ⚠️ "Probiotics" → 1000+ strains (Lactobacillus? Bifidobacterium? mix?)
- ❌ "Gut health" → **not measurable** (what does "good gut health" mean?)
- ⚠️ High heterogeneity expected (different strains, different doses)

**✅ HOW TO FIX:**

```
✅ REVISED:
Research Question: Is Lactobacillus rhamnosus GG effective for reducing IBS
symptom severity in adults with irritable bowel syndrome?

Population: Adults (18-65) with diagnosed IBS (Rome IV criteria)
Intervention: Lactobacillus rhamnosus GG (≥1×10^9 CFU/day)
Comparator: Placebo
Outcomes:
  - Primary: IBS symptom severity (IBS-SSS score)
  - Secondary: Abdominal pain (VAS), quality of life (IBS-QoL)

Expected Studies: 10-15 RCTs
Feasibility: MODERATE-HIGH (12/16 points)
```

**What changed:**

- ✅ Specified **probiotic strain** (L. rhamnosus GG)
- ✅ Defined **dose** (≥1×10^9 CFU/day)
- ✅ Measurable **outcome** (IBS-SSS score)
- ✅ Specific **population** (IBS by Rome IV criteria)

---

## 🚩 Red Flags to Avoid

### 🚨 Population Red Flags

| ❌ Red Flag | Why Bad | ✅ Fix |
|------------|---------|--------|
| "Sick people" | Too vague | "Adults with diagnosed MDD (DSM-5)" |
| "Patients age 67.5±2.3" | Too narrow | "Elderly adults (≥65 years)" |
| "Anyone" | Can't generalize | Define specific population |
| "Rare disease X" | <5 studies likely | Check feasibility FIRST |

---

### 🚨 Intervention Red Flags

| ❌ Red Flag | Why Bad | ✅ Fix |
|------------|---------|--------|
| "Therapy" | Too vague (CBT? IPT? DBT?) | "Cognitive-behavioral therapy (CBT)" |
| "Brand X only" | Too narrow | "Drug class Y (including Brand X)" |
| "Experimental drug Z" | <3 studies exist | Choose established intervention |
| "Anything that helps" | Unfocused | Pick ONE intervention type |

---

### 🚨 Comparator Red Flags

| ❌ Red Flag | Why Bad | ✅ Fix |
|------------|---------|--------|
| "Any control" | High heterogeneity | "Placebo" OR "Active comparator" (pick one) |
| "No treatment" | Rare/unethical | "Waitlist control" or "Treatment as usual" |
| "Different in each study" | Can't pool | Specify ONE comparator |

---

### 🚨 Outcome Red Flags

| ❌ Red Flag | Why Bad | ✅ Fix |
|------------|---------|--------|
| "Feeling better" | Not measurable | "Depression score (HAM-D, BDI)" |
| "Improvement" | Undefined | "Response rate (≥50% reduction in symptoms)" |
| "Rare biomarker X" | Not reported in most studies | Choose commonly reported outcome |
| "Qualitative outcome" | Can't pool | Use quantitative measure |

---

## 🔍 Feasibility Quick-Check Framework

### Step 1: Study Volume Estimation (5 min)

**Quick PubMed search:**

```
([intervention] OR [drug name]) AND ([condition] OR [disease]) AND (randomized controlled trial[pt])
```

**Interpret results:**

- ✅ **>100 results**: Excellent, plenty of studies
- ✅ **50-100 results**: Good, narrow PICO to select best
- ⚠️ **20-49 results**: Marginal, may work if specific
- ❌ **<20 results**: Too few, broaden PICO or choose different topic

---

### Step 2: Recent Systematic Review Check (5 min)

**Search:**

```
[intervention] [condition] systematic review meta-analysis
```

**Filter**: Last 2 years

**Interpret:**

- ✅ **No recent review**: Great! Clear need for synthesis
- ✅ **Review >2 years old**: Good! Can update it
- ⚠️ **Review 1-2 years old**: Marginal, check if new studies exist
- ❌ **Review <1 year old**: Probably redundant (unless different angle)

**If recent review exists, can you:**

- Update with new studies?
- Focus on a subgroup they didn't analyze?
- Add an outcome they didn't report?
- Use different inclusion criteria?

**If YES to any → proceed. If NO → choose different topic.**

---

### Step 3: Outcome Reporting Check (5 min)

**Search:**

```
[intervention] [condition] [your outcome] randomized trial
```

**Check abstracts**: Do ≥50% mention your outcome?

- ✅ **Yes**: Outcome commonly reported, proceed
- ⚠️ **30-50%**: Moderate reporting, expect some missing data
- ❌ **<30%**: Outcome rarely reported, **REVISE** or **STOP**

**Alternative**: Change to more commonly reported outcome

---

### Step 4: Heterogeneity Assessment (5 min)

**Ask yourself**:

1. Will studies compare the **same intervention**? (or related variants?)
2. Will studies include the **same population**? (or similar enough?)
3. Will studies measure outcomes the **same way**? (same scales?)

**Score:**

- ✅ **Yes to all 3**: Low heterogeneity, proceed confidently
- ⚠️ **Yes to 2/3**: Moderate heterogeneity, plan subgroup analysis
- ❌ **Yes to 0-1/3**: High heterogeneity, **REVISE PICO**

---

## 📊 Feasibility Scoring Rubric (0-16 points)

Use this **before finalizing** your topic:

| Criterion | 2 points (Good) | 1 point (Marginal) | 0 points (Poor) |
|-----------|----------------|-------------------|----------------|
| **Study quantity** | ≥15 studies | 10-14 studies | <10 studies |
| **Study quality** | Mostly RCTs | Mixed RCT + obs | Mostly observational |
| **Outcome reporting** | All report outcome | >50% report | <50% report |
| **Clinical homogeneity** | Same comparison | Related | Different |
| **Population similarity** | Same disease/stage | Related | Different |
| **Data extractability** | Easy (tables) | Moderate (text) | Difficult (buried) |
| **Literature recency** | >50% last 3 yrs | 3-5 yrs old | Older |
| **Precedent** | Similar MA exists | Related | None |

**TOTAL: _____ / 16**

**Interpretation:**

- **14-16 points**: ✅ **GO** - Excellent feasibility
- **12-13 points**: ⚠️ **PROCEED WITH CAUTION** - Plan mitigation strategies
- **8-11 points**: 🚨 **REVISE PICO** - Major challenges expected
- **0-7 points**: ❌ **STOP** - Not feasible, choose different topic

---

## 🎓 Common Patterns by Medical Specialty

### Mental Health / Psychiatry

**✅ Easy topics** (plenty of RCTs):

- Antidepressants (SSRIs, SNRIs, TCAs)
- Psychotherapy (CBT, IPT, ACT)
- Anxiety disorders (GAD, social anxiety)

**⚠️ Moderate topics** (some studies):

- Digital mental health interventions
- Mindfulness-based interventions
- Treatment-resistant depression

**❌ Difficult topics** (few studies):

- Rare psychiatric conditions
- Novel/experimental therapies
- Very specific subpopulations

---

### Oncology

**✅ Easy topics**:

- Common cancers (breast, lung, colorectal)
- Chemotherapy regimens
- Survival outcomes (OS, PFS)

**⚠️ Moderate topics**:

- Immunotherapy (growing but newer)
- Rare cancer subtypes (if ≥5 RCTs exist)
- Quality of life outcomes (variably reported)

**❌ Difficult topics**:

- Ultra-rare cancers
- Brand-new drugs (FDA approved <1 year)
- Outcomes not in clinical trials (e.g., patient satisfaction)

---

### Cardiology

**✅ Easy topics**:

- Antihypertensives
- Anticoagulants
- Heart failure therapies
- Statin efficacy

**⚠️ Moderate topics**:

- Device-based interventions
- Lifestyle interventions
- Rare cardiac conditions

**❌ Difficult topics**:

- Very specific biomarker-defined populations
- Extremely rare conditions (e.g., Takotsubo cardiomyopathy)

---

### Surgery

**✅ Easy topics**:

- Robotic vs open surgery (common procedures)
- Minimally invasive techniques
- Perioperative outcomes (mortality, complications)

**⚠️ Moderate topics**:

- Long-term functional outcomes (variably reported)
- Quality of life (less reported in older surgical trials)
- Rare surgical procedures

**❌ Difficult topics**:

- Surgeon-specific skill comparisons (confounded)
- Subjective outcomes (pain is hard to pool)
- Procedures with <10 comparative studies

---

## 🛡️ Risk Mitigation Strategies

### Challenge: "Only 8 RCTs expected (marginal volume)"

**Mitigations:**

1. ✅ Broaden inclusion criteria (e.g., add observational studies with caution)
2. ✅ Accept fewer studies (if high-quality)
3. ✅ Plan sensitivity analysis (RCTs only vs all studies)

**When to STOP:**

- ❌ <5 studies total (too few to pool meaningfully)

---

### Challenge: "High heterogeneity expected (I² >75%)"

**Mitigations:**

1. ✅ Plan subgroup analysis (by dose, population, setting)
2. ✅ Use random-effects model (accounts for heterogeneity)
3. ✅ Sensitivity analysis (exclude outliers)
4. ✅ Meta-regression (explore moderators)

**When to STOP:**

- ❌ Every study compares different interventions (can't pool)
- ❌ Outcomes measured differently across all studies

---

### Challenge: "Outcome reported in only 60% of studies"

**Mitigations:**

1. ✅ Contact authors for missing data
2. ✅ Use surrogate outcome (if validated)
3. ✅ Impute missing data (with sensitivity analysis)

**When to STOP:**

- ❌ <50% report outcome AND authors don't respond
- ❌ No validated surrogate outcome exists

---

### Challenge: "Recent systematic review published 6 months ago"

**Mitigations:**

1. ✅ **Different angle**: Focus on subgroup they didn't analyze
2. ✅ **Add outcome**: Include outcome they didn't report
3. ✅ **Update**: If new RCTs published since their search
4. ✅ **Methodological improvement**: Use more rigorous methods (e.g., IPD)

**When to STOP:**

- ❌ Review is comprehensive AND recent AND no new angle possible

---

## 🎯 Decision Trees

### Tree 1: "How Specific Should My PICO Be?"

```
START: Do you have a specific research question in mind?
│
├─ YES → Run quick PubMed search
│   │
│   ├─ >50 studies → ✅ PROCEED (specific enough)
│   │
│   ├─ 20-50 studies → ⚠️ MARGINAL (check quality)
│   │
│   └─ <20 studies → ❌ TOO NARROW (broaden PICO)
│
└─ NO → Start broad, then narrow iteratively
    │
    ├─ Choose clinical area → ✅ General field identified
    │
    ├─ Narrow to condition → ⚠️ Still broad
    │
    ├─ Specify intervention → ⚠️ Getting specific
    │
    └─ Define outcome → ✅ Now specific enough (check study count)
```

---

### Tree 2: "Should I Update an Existing Review or Start Fresh?"

```
Found a recent systematic review?
│
├─ Published <1 year ago
│   │
│   ├─ Comprehensive & rigorous → ❌ STOP (redundant)
│   │
│   └─ Missing key aspect → ⚠️ CONSIDER (different angle)
│
├─ Published 1-3 years ago
│   │
│   ├─ New studies since? (YES) → ✅ UPDATE REVIEW
│   │
│   └─ No new studies → ⚠️ MARGINAL (add different outcome?)
│
└─ Published >3 years ago
    │
    └─ Outdated → ✅ UPDATE REVIEW (clear need)
```

---

## 📚 Real-World Examples from Successful Meta-Analyses

### Example 1: ICI in Triple-Negative Breast Cancer ✅

**Full case**: `projects/ici-breast-cancer/`

```
Research Question:
Efficacy and safety of immune checkpoint inhibitors (ICIs) plus chemotherapy
versus chemotherapy alone in patients with triple-negative breast cancer (TNBC)

Population: Adults with advanced/metastatic TNBC
Intervention: ICI (pembrolizumab, atezolizumab) + chemotherapy
Comparator: Chemotherapy alone (placebo + chemo)
Outcomes:
  - Primary: Progression-free survival (PFS)
  - Secondary: Overall survival (OS), objective response rate (ORR)

Result:
- 5 RCTs identified (N=2,402 patients)
- Clear efficacy: RR 1.26 (95% CI 1.16-1.37), p=0.0015
- High-quality evidence (GRADE: ⊕⊕⊕⊕)
- Manuscript: 4,921 words (publication-ready)
- Time: ~14 hours total (vs 100+ hours manual)

Why it worked:
✅ Specific population (TNBC, not all breast cancer)
✅ Clear intervention (ICI class, not specific drug)
✅ Standard outcome (PFS, OS reported in all trials)
✅ Homogeneous comparison (all trials: ICI+chemo vs chemo)
✅ Recent topic (studies published 2019-2023)

Feasibility score: 15/16 (Excellent)
```

---

### Example 2: Meditation for Mental Health ❌ → ✅ (After Revision)

**Initial (failed) topic:**

```
❌ Research Question: Is meditation effective for mental health?

Population: Anyone with mental health issues
Intervention: Meditation (any type)
Comparator: Any control
Outcome: Mental health improvement

Why it failed:
- Too broad (anxiety? depression? PTSD? schizophrenia?)
- "Meditation" too vague (mindfulness? TM? Zen?)
- "Improvement" not measurable
- High heterogeneity (I²>90% certain)

Feasibility score: 4/16 (STOP)
```

**Revised (successful) topic:**

```
✅ Research Question: Is mindfulness-based stress reduction (MBSR) effective
for reducing anxiety symptoms in adults with generalized anxiety disorder (GAD)?

Population: Adults (18-65) with diagnosed GAD (DSM-5)
Intervention: MBSR (8-week program, ≥45 min sessions)
Comparator: Waitlist control OR treatment as usual
Outcomes:
  - Primary: Anxiety severity (GAD-7, STAI, BAI scores)
  - Secondary: Depression (PHQ-9), quality of life (SF-36)

Result:
- 12 RCTs identified (N=1,247 patients)
- Moderate effect: SMD -0.54 (95% CI -0.72 to -0.36)
- Moderate heterogeneity (I²=62%, explained by control type)
- Publishable findings

Why revision worked:
✅ Narrowed to specific condition (GAD only)
✅ Defined intervention (MBSR protocol, not "meditation")
✅ Measurable outcome (anxiety scales)
✅ Feasible study count (12 RCTs)

Feasibility score: 13/16 (Proceed with caution)
```

---

## 🤖 For AI Language Models: Calibration Guide

### How Strict Should You Be?

**Your goal**: Help user succeed, not enable failure

**Calibration test**: Would you personally invest 20-30 hours on this topic?

- **YES**: Topic is feasible → Encourage user to proceed
- **MAYBE**: Topic is marginal → Flag concerns, offer revisions
- **NO**: Topic will fail → Strongly discourage, suggest alternatives

---

### When to Push Back (Examples)

**User says**: "I want to study cancer treatment"

**Your response**:

> ⚠️ "Cancer treatment" is too broad - there are 200+ cancer types and 50+ treatment classes. This would create impossibly high heterogeneity (I²>90%).
>
> Let's narrow down. Which cancer type interests you? (breast, lung, colorectal, etc.)

**DON'T say**: "Great idea! Let's build a PICO around that." ❌

---

**User says**: "I found this ultra-rare disease with only 2 published case reports"

**Your response**:

> 🚨 With only 2 case reports, this won't be feasible for a meta-analysis. Meta-analysis requires ≥5 comparative studies (ideally RCTs).
>
> Options:
> 1. **Narrative review** instead (summarize the 2 case reports)
> 2. **Broader condition** (include related rare diseases)
> 3. **Different topic** (I can help you find a more feasible one)
>
> What appeals to you?

**DON'T say**: "Let's try anyway and see what happens." ❌

---

### When to Encourage (Examples)

**User says**: "Is 8 RCTs enough? That seems low..."

**Your response**:

> ✅ 8 RCTs is absolutely feasible! While 10+ is ideal, 8 high-quality RCTs can produce robust meta-analytic estimates.
>
> Examples of successful meta-analyses with ~8 studies:
> - [Cite real example if possible]
>
> The key is: Are the 8 studies homogeneous enough to pool? Let's check that next.

---

**User says**: "There's a Cochrane review from 2021 on this. Should I stop?"

**Your response**:

> ⚠️ A 2021 Cochrane review is recent, BUT:
> - If new RCTs published since 2021 → ✅ Update is valuable!
> - If you can add a subgroup they didn't analyze → ✅ Different angle!
> - If they missed an important outcome → ✅ Fill the gap!
>
> Let me do a quick search to see if any new studies exist since 2021...
>
> [Run search, report findings]

---

## 🎁 Deliverables Checklist

When brainstorming is complete, user should have:

- [ ] **TOPIC.txt file** with PICO + metadata
- [ ] **Feasibility quick-check summary** (study count, reviews, heterogeneity)
- [ ] **Red flags identified** (if any)
- [ ] **Mitigation strategies** (how to address challenges)
- [ ] **Next steps** (4-hour formal assessment recommended)
- [ ] **Estimated timeline** (based on complexity)

---

## 📖 Further Reading

- [Feasibility Checklist](feasibility-checklist.md) - 4-hour formal assessment
- [Time Investment Guidance](../../ma-end-to-end/references/time-guidance.md) - Realistic timelines
- [ICI Breast Cancer Example](../../projects/ici-breast-cancer/README.md) - Complete successful project

---

**Version**: 2.0
**Date**: 2026-02-17
**Maintained by**: meta-pipe project
**Feedback**: Update this doc as we learn from more projects
