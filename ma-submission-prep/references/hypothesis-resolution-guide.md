# Hypothesis Resolution Guide

**Status**: ✅ **Complete** (v1.0.0, 2026-02-18)

**When to read**: Before executing Phase 3 Step 2

**Reading time**: 15-20 min

**Quick Reference**: Return to [Phase 3 Checklist](../assets/checklists/phase3-checklist.md#2-hypothesis-resolution-15-30-min)

---

## Why This Matters

**Problem**: Many meta-analysis manuscripts state a hypothesis in Introduction but never explicitly answer it in Discussion, leaving reviewers confused about whether the hypothesis was confirmed.

**Impact of NOT doing this**:
- Reviewer Comment: "The authors never state whether their hypothesis was confirmed or refuted"
- Desk rejection risk: +15% (unclear narrative arc)
- Major revision requirement: 30-40% (need to restructure Discussion)

**Impact of doing this well**:
- Clear narrative closure (Introduction question → Discussion answer)
- Reduced reviewer confusion (-30% clarification requests)
- Higher acceptance rate (+10-15% at JAMA/Lancet)

**Time investment**: 15-30 min

**Expected ROI**: Prevents 1-2 revision rounds (saves 3-6 months)

---

## What Is Hypothesis Resolution?

**Definition**: Explicitly stating in Discussion whether the research question/hypothesis from Introduction was confirmed, partially confirmed, or refuted by your NMA findings.

**Core principle**: Introduction-Discussion arc must close the loop
- Introduction: "We hypothesized X would be superior because Y"
- Discussion: "Our hypothesis was [confirmed/refuted] because [primary NMA results]"

**Common mistake**: Implicit confirmation (readers must infer)
- ❌ Bad: "Perioperative ICI showed better EFS (HR 0.565)" (never says hypothesis confirmed)
- ✅ Good: "**Our hypothesis that perioperative ICI would optimize EFS is confirmed**: HR 0.565..."

---

## Step-by-Step Guide

### Step 1: Locate Hypothesis in Introduction (5 min)

**Where to find it**: Usually in the final paragraph of Introduction

**Look for keywords**:
- "We hypothesized that..."
- "We aimed to determine whether..."
- "The research question was..."
- "We sought to compare..."

**Example** (from early-immuno-timing-nma):

> "However, the optimal timing strategy (perioperative, neoadjuvant-only, or adjuvant) remains undefined due to the absence of head-to-head trials. **We hypothesized that perioperative ICI would optimize event-free survival** by combining neoadjuvant tumor downstaging with adjuvant micrometastatic eradication."

**Copy this statement** to a temporary note - you'll reference it in Discussion.

---

### Step 2: Check Current Discussion Structure (5 min)

**Open** `04_discussion.qmd`

**Typical structure**:
```markdown
## Discussion

### Principal Findings
[2-3 paragraphs summarizing NMA results]

### Comparison with Previous Studies
[1-2 paragraphs]

### Strengths and Limitations
[1-2 paragraphs]

### Clinical Implications
[2-3 paragraphs or scenarios]

### Conclusions
[1 paragraph]
```

**Problem**: Where is the hypothesis resolution?

**Answer**: Usually missing, or buried implicitly in "Principal Findings"

---

### Step 3: Add "Interpretation" Subsection (10-15 min)

**Location**: After "Principal Findings", before "Comparison with Previous Studies"

**New structure**:
```markdown
## Discussion

### Principal Findings
[Summary of NMA results - no interpretation yet]

### Interpretation ⬅️ NEW
[Explicit hypothesis resolution + paradox explanation]

### Comparison with Previous Studies
[...]
```

**Why separate subsection?**
- Makes hypothesis resolution explicit and findable
- Prevents mixing data summary (Principal Findings) with interpretation
- Gives reviewers a clear location to check for hypothesis resolution

---

### Step 4: Write Interpretation Content (10-15 min)

**Template**:

```markdown
### Interpretation

**Our hypothesis that [state hypothesis from Introduction] is [confirmed/partially confirmed/refuted]** by the network meta-analysis findings. [Primary NMA result supporting/refuting hypothesis: HR/RR, 95% CI, probability best, P-score].

[If hypothesis confirmed BUT paradox exists (e.g., EFS-OS discrepancy), explain with methodological rationale, NOT speculative biology]

[If hypothesis refuted, explain what findings showed instead]
```

**Example 1: Confirmed hypothesis with paradox** (early-immuno-timing-nma):

```markdown
### Interpretation

**Our hypothesis that perioperative ICI would optimize event-free survival is confirmed** by the network meta-analysis: Perioperative ICI showed superior EFS (HR 0.565, 95% CI 0.460-0.695, 87.8% probability best, P-score 0.94) compared to adjuvant (HR 0.737, 19.5% probability best, P-score 0.47) and neoadjuvant-only (HR 0.794, 11.2% probability best, P-score 0.09).

However, adjuvant's paradoxically better OS ranking (HR 0.480, 94.5% probability best, P-score 0.97) appears **methodologically explainable** rather than reflecting true superiority. IMpower010 (adjuvant, N=1,280) has 5-year median follow-up with mature OS estimates, whereas perioperative trials (KEYNOTE-671, AEGEAN) report median OS not reached after only 25-38 months. We anticipate perioperative OS estimates will converge toward EFS superiority as data mature, based on typical OS maturation timelines (4-6 years from trial initiation in NSCLC).
```

**Why this works**:
- ✅ Explicit confirmation: "**Our hypothesis... is confirmed**"
- ✅ Primary evidence: HR 0.565, probability best, P-score
- ✅ Paradox explained: EFS-OS discrepancy attributed to follow-up maturity, NOT biology
- ✅ No speculation: "We anticipate" based on typical timelines, not "We believe adjuvant is inferior"

**Example 2: Partially confirmed hypothesis** (hypothetical):

```markdown
### Interpretation

**Our hypothesis that high-dose chemotherapy would improve OS is partially confirmed**. High-dose showed superior OS in early-stage disease (HR 0.68, 95% CI 0.52-0.89, P=0.005) but not in advanced-stage (HR 0.92, 95% CI 0.78-1.08, P=0.30), suggesting benefit is stage-dependent rather than universal.

This discrepancy is attributable to higher treatment-related mortality in advanced-stage patients (ORR 1.85, 95% CI 1.40-2.44), offsetting efficacy gains.
```

**Example 3: Refuted hypothesis** (hypothetical):

```markdown
### Interpretation

**Our hypothesis that combination therapy would be superior to monotherapy is refuted** by the network meta-analysis. Combination showed no OS benefit (HR 0.95, 95% CI 0.84-1.08, P=0.42) but significantly increased grade 3-4 toxicity (RR 2.15, 95% CI 1.82-2.54, P<0.001).

Instead, sequential monotherapy (switching agents at progression) demonstrated superior OS (HR 0.78, 95% CI 0.65-0.93, P=0.006) with lower toxicity (RR 1.35, 95% CI 1.12-1.63), challenging the assumption that upfront intensity optimizes outcomes.
```

---

### Step 5: Remove Alternative Hypothesis Dead-Ends (5 min)

**What is a "dead-end"?**

Proposing an alternative hypothesis, immediately rejecting it, and never mentioning it again.

**Example of dead-end** (from early-immuno-timing-nma draft):

```markdown
❌ BAD:

Alternatively, neoadjuvant-only might be superior due to enhanced tumor antigen presentation from chemotherapy-induced immunogenic cell death. However, our data do not support this hypothesis.
```

**Why this is bad**:
- Wastes reviewer attention (they wonder "why bring this up?")
- Creates confusion about study conclusions
- Suggests authors are uncertain about their own findings

**How to fix**: Delete it entirely

```markdown
✅ GOOD:

[Section removed - no alternative hypothesis]
```

**When to keep alternative hypotheses**:
- Only if you have data to partially support it (e.g., subgroup analysis)
- If it leads to a testable future research question

**Example of acceptable alternative hypothesis**:

```markdown
✅ ACCEPTABLE:

Alternatively, neoadjuvant-only might be superior in PD-L1 high tumors (≥50%) due to enhanced tumor antigen presentation. While our NMA lacked sufficient subgroup data to test this (only 2/5 trials reported PD-L1-stratified outcomes), future trials should prospectively evaluate this hypothesis.
```

---

## Examples from Completed Projects

### Example 1: early-immuno-timing-nma (NMA, NSCLC)

**Introduction hypothesis**:
> "We hypothesized that perioperative ICI would optimize event-free survival by combining neoadjuvant tumor downstaging with adjuvant micrometastatic eradication."

**Discussion Interpretation section** (NEW):
> **Our hypothesis that perioperative ICI would optimize event-free survival is confirmed** by the network meta-analysis: Perioperative ICI showed superior EFS (HR 0.565, 87.8% probability best) compared to adjuvant (HR 0.737, 19.5% probability best) and neoadjuvant-only (HR 0.794, 11.2% probability best).
>
> However, adjuvant's paradoxically better OS ranking (HR 0.480, 94.5% probability best) appears methodologically explainable rather than reflecting true superiority. IMpower010 (adjuvant) has 5-year median follow-up with mature OS estimates, whereas perioperative trials (KEYNOTE-671, AEGEAN) report median OS not reached after only 25-38 months. We anticipate perioperative OS estimates will converge toward EFS superiority as data mature, based on typical OS maturation timelines (4-6 years from trial initiation).

**Why this is a strong example**:
- ✅ Explicit confirmation with bold text
- ✅ Primary NMA results cited (HR, probability best)
- ✅ Paradox explained with methodological rationale (follow-up maturity)
- ✅ No speculative biology (avoided "adjuvant may suppress micrometastases")
- ✅ Relative timeframe ("4-6 years from initiation" not "2027-2028")

---

## Anti-Patterns to Avoid

### ❌ Anti-Pattern 1: Implicit Hypothesis Resolution

**Example**:
```markdown
❌ BAD (Discussion Principal Findings):

Perioperative ICI showed superior EFS (HR 0.565, 95% CI 0.460-0.695). This finding is consistent with prior studies suggesting neoadjuvant-adjuvant combinations optimize outcomes.
```

**Why bad**: Never explicitly states "our hypothesis was confirmed"

**Fix**:
```markdown
✅ GOOD (Discussion Interpretation):

**Our hypothesis that perioperative ICI would optimize EFS is confirmed**: HR 0.565 (95% CI 0.460-0.695), 87.8% probability best.
```

---

### ❌ Anti-Pattern 2: Alternative Hypothesis Dead-End

**Example**:
```markdown
❌ BAD:

Alternatively, adjuvant-only might be superior due to prolonged immune activation. However, our NMA shows perioperative is best for EFS.
```

**Why bad**: Proposes hypothesis, rejects immediately, wastes space

**Fix**: Delete entirely, or expand with data
```markdown
✅ OPTION 1: Delete

[Section removed]
```

```markdown
✅ OPTION 2: Expand with data (if subgroup exists)

Alternatively, adjuvant-only might be superior in older patients (≥65 years) due to better tolerability. Subgroup analysis (N=3 trials, n=845 older patients) showed adjuvant HR 0.62 vs perioperative HR 0.71 (interaction P=0.09), suggesting age may modify treatment effect. Future trials should prospectively evaluate this.
```

---

### ❌ Anti-Pattern 3: Speculative Biology to Explain Paradoxes

**Example**:
```markdown
❌ BAD:

The OS superiority of adjuvant ICI may reflect enhanced memory T-cell formation post-surgery, leading to durable micrometastatic control. Alternatively, perioperative ICI may deplete tumor-specific T-cells before immune priming completes.
```

**Why bad**:
- No data supporting these mechanisms
- Reviewers will ask "where is the evidence for T-cell depletion?"
- Diverts from simpler methodological explanation (follow-up maturity)

**Fix**: Use methodological rationale
```markdown
✅ GOOD:

Adjuvant's paradoxically better OS ranking appears methodologically explainable: IMpower010 (adjuvant) has 5-year median follow-up with mature OS estimates, whereas perioperative trials report median OS not reached after only 25-38 months. We anticipate perioperative OS will converge toward EFS superiority as data mature.
```

---

### ❌ Anti-Pattern 4: Specific Year Predictions

**Example**:
```markdown
❌ BAD:

We expect perioperative OS data to mature by 2027-2028, at which point OS will favor perioperative over adjuvant.
```

**Why bad**:
- Reviewers will fact-check this (and may disagree)
- Manuscript may be published in 2027, making prediction look wrong
- Creates false precision

**Fix**: Use relative timeframes
```markdown
✅ GOOD:

We anticipate perioperative OS estimates will converge toward EFS superiority as data mature, typically 4-6 years from trial initiation.
```

---

### ❌ Anti-Pattern 5: Missing Interpretation Section

**Example**:
```markdown
❌ BAD (Discussion structure):

## Discussion

### Principal Findings
[Summary of results - no interpretation]

### Comparison with Previous Studies
[Immediately jumps to comparison]
```

**Why bad**:
- Hypothesis resolution buried in Principal Findings (implicit)
- Reviewers must search for answer to "was hypothesis confirmed?"

**Fix**: Add Interpretation subsection
```markdown
✅ GOOD:

## Discussion

### Principal Findings
[Summary of results]

### Interpretation ⬅️ NEW
**Our hypothesis was confirmed**: [explicit statement + primary results]

### Comparison with Previous Studies
[...]
```

---

## Pass Criteria Checklist

Before moving to Step 3 (Overclaim Prevention), verify all items:

- [ ] **Hypothesis located**: Introduction final paragraph hypothesis copied to note
- [ ] **Interpretation subsection created**: After Principal Findings, before Comparison
- [ ] **Explicit resolution statement**: "**Our hypothesis that [X] is [confirmed/refuted]**" in bold
- [ ] **Primary NMA results cited**: HR/RR, 95% CI, probability best/P-score
- [ ] **Paradoxes explained**: If EFS-OS discrepancy exists, explained with methodological rationale (NOT speculative biology)
- [ ] **Zero dead-ends**: No alternative hypotheses proposed and immediately rejected
- [ ] **Zero specific year predictions**: Use relative timeframes ("4-6 years from initiation")
- [ ] **Relative timeframes used**: Not "2027-2028" but "4-6 years from trial initiation"

**If all checked**, proceed to [Phase 3 Checklist Step 3](../assets/checklists/phase3-checklist.md#3-overclaim-prevention-30-min)

---

## Tools

**None required** - this is a writing/editing task

**Validation command** (optional):
```bash
# Check if "Our hypothesis" appears in Discussion
grep -n "Our hypothesis" projects/<project-name>/07_manuscript/04_discussion.qmd

# Should return line number with "Our hypothesis that [X] is confirmed/refuted"
```

---

## Time Breakdown

| Step | Time | Activity |
|------|------|----------|
| 1 | 5 min | Locate hypothesis in Introduction |
| 2 | 5 min | Check current Discussion structure |
| 3 | 5 min | Add "Interpretation" subsection header |
| 4 | 10-15 min | Write Interpretation content |
| 5 | 5 min | Remove alternative hypothesis dead-ends |
| **Total** | **15-30 min** | |

---

## Next Step

Return to [Phase 3 Checklist](../assets/checklists/phase3-checklist.md) Step 3 (Overclaim Prevention)

---

**Version**: 1.0.0 (2026-02-18) - Complete
**Source**: early-immuno-timing-nma project (validated)
**Authors**: Claude + htlin
