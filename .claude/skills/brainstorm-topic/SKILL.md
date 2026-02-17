---
name: brainstorm-topic
description: Interactive brainstorming to develop a meta-analysis topic. Use when user wants to explore ideas, refine a topic, or needs help formulating a research question.
---

# Topic Brainstorming Skill (Enhanced v2.0)

Guide users through developing a **feasible, well-formed meta-analysis topic** via structured interactive conversation.

**⚠️ CRITICAL FOR AI AGENTS**: This skill contains **SELF-CHECK PROMPTS** throughout. Follow them to avoid common pitfalls.

---

## Trigger Phrases

- "help me find a topic"
- "brainstorm topic"
- "I'm not sure what to study"
- "help me refine my topic"
- "/brainstorm"

---

## 🎯 Core Principles (READ FIRST)

### For AI Agents: Your Mindset

1. **You are a GUARDIAN against wasted effort** - Your job is to help user find a **feasible** question, not just any question
2. **Flag red flags immediately** - Don't wait until Phase 3 to warn about problems
3. **Offer examples constantly** - Users often don't know what's possible
4. **Balance ambition with feasibility** - Encourage interesting questions, but ground in reality
5. **Document your reasoning** - Explain WHY you suggest/reject certain directions

### For Users: What Makes a Good Topic

✅ **GOOD topics**:
- Specific intervention (e.g., "SSRIs" not "antidepressants")
- Well-defined population (e.g., "adults with MDD" not "depressed people")
- Measurable outcomes (e.g., "response rate" not "feeling better")
- 5+ RCTs expected
- Clear comparator

❌ **BAD topics** (avoid these):
- Too broad ("cancer treatment")
- Too narrow ("CDK4/6 inhibitors in triple-negative breast cancer with PIK3CA mutations")
- No quantitative outcomes
- <3 studies likely
- Every study compares different things

---

## 📋 Structured Conversation Flow

### Phase 0: Pre-Assessment (NEW)

**Before starting PICO, ask:**

> 👋 Hi! Before we dive in, let me ask a few quick questions to guide us:
>
> 1. **Have you done a meta-analysis before?** (yes/no)
> 2. **Do you have a specific topic in mind, or are you exploring?** (specific/exploring)
> 3. **What's your timeline?** (urgent <2 weeks / standard 1-2 months / flexible)
> 4. **Do you have institutional journal access?** (yes/no)

**🤖 AI SELF-CHECK**: Based on answers, adjust your guidance style:
- First-timer? → Offer more examples, explain concepts
- Specific topic? → Jump to feasibility check first, then refine PICO
- Urgent? → Steer towards established topics with known studies
- No access? → Emphasize Open Access studies

---

### Phase 1: Clinical Area Exploration

Ask ONE question at a time. Start with:

> **What clinical area or health topic interests you?**
>
> Examples:
> - 🧠 Mental health (depression, anxiety, PTSD)
> - ❤️ Cardiovascular (heart failure, hypertension, stroke)
> - 🎗️ Oncology (breast, lung, colorectal cancer)
> - 🏥 Surgery (minimally invasive, robotic, outcomes)
> - 💊 Pharmacotherapy (drug comparisons, adherence)
> - 🏃 Rehabilitation (physical therapy, post-stroke, orthopedic)
> - 🍎 Nutrition & lifestyle (diet, exercise, supplements)

**🤖 AI SELF-CHECK after user answers**:
- [ ] Is this area too broad? (e.g., "cancer" → needs narrowing)
- [ ] Is this area too narrow? (e.g., "stage IIIb NSCLC with EGFR exon 19 deletion" → likely <5 studies)
- [ ] Is this area well-researched? (mental health, cardio → yes; rare diseases → maybe not)

**If red flag detected**, immediately say:

> ⚠️ Quick heads-up: [Area] is quite [broad/narrow]. Let me help you narrow/broaden this...

---

### Phase 2: PICO Element-by-Element (WITH CHECKPOINTS)

#### 2A. Population (P)

> Within [their area], which **patient group** interests you most?
>
> Consider:
> - **Age**: Pediatric? Adult? Elderly?
> - **Disease stage**: Early? Advanced? Any stage?
> - **Setting**: Inpatient? Outpatient? Primary care?
> - **Comorbidities**: Specific groups? (e.g., diabetes + heart disease)

**🤖 AI SELF-CHECK after user answers**:
- [ ] Is population too narrow? (e.g., "adults 65-70 with HbA1c 7.5-8.0" → very few studies)
- [ ] Is population unclear? (e.g., "sick people" → needs specificity)
- [ ] Will this population have enough studies? (use your knowledge: common conditions → yes; ultra-rare → no)

**Instant Feasibility Check (NEW)**:

After getting P, run a **quick mental/web check**:

```
🔍 Mental check: "How many RCTs exist for [this population]?"
- Common conditions (diabetes, depression, hypertension): Thousands → ✅
- Moderately common (COPD, Parkinson's): Hundreds → ✅
- Rare diseases (Cushing's, NMO): Tens → ⚠️
- Ultra-rare (specific gene mutations): <10 → ❌
```

If ⚠️ or ❌, **immediately flag**:

> ⚠️ Just so you know, [population] is relatively rare. This might limit the number of available studies. Want to broaden slightly, or shall we continue and check later?

---

#### 2B. Intervention (I)

> What **treatment or intervention** do you want to evaluate?
>
> Common types:
> - 💊 **Drug vs drug** (e.g., SSRI vs SNRI)
> - 🧪 **Drug vs placebo** (e.g., new medication efficacy)
> - 🧘 **Therapy vs control** (e.g., CBT vs waitlist)
> - 🏥 **Procedure A vs B** (e.g., robotic vs open surgery)
> - 🎯 **Dose comparison** (e.g., high-dose vs standard-dose)
> - 📱 **Delivery method** (e.g., telehealth vs in-person)

**🤖 AI SELF-CHECK after user answers**:
- [ ] Is intervention too vague? (e.g., "therapy" → specify CBT, IPT, etc.)
- [ ] Is intervention too specific? (e.g., "drug X manufactured by company Y batch 2023" → unnecessarily narrow)
- [ ] Is this intervention established enough to have studies? (FDA-approved drugs → yes; experimental → maybe)

**Instant Red Flag Check (NEW)**:

❌ **STOP if**:
- Intervention is a specific **brand name** and user wants only that brand (too narrow)
- Intervention is extremely new (FDA approved <1 year ago, unlikely to have RCTs)
- Intervention is obsolete (no longer used in practice → studies exist but not clinically relevant)

If detected, **immediately warn**:

> 🚨 Red flag: [Intervention] is [too new/too specific/obsolete]. This might severely limit available studies or clinical relevance. Let me suggest alternatives...

---

#### 2C. Comparator (C)

> What should we **compare it against**?
>
> Options:
> - 🔵 **Placebo/sham** (cleanest effect estimate, but ethics may limit availability)
> - 🟢 **Active comparator** (another drug/therapy - more clinically relevant)
> - 🟡 **Standard of care** / Treatment as usual (real-world comparison)
> - ⚪ **Waitlist control** (common in psychotherapy)
> - 🔴 **No treatment** (rare, ethical concerns)

**🤖 AI SELF-CHECK after user answers**:
- [ ] Does this comparator make clinical sense? (e.g., placebo for life-threatening condition → unethical, unlikely to find studies)
- [ ] Will there be enough studies with THIS specific comparison? (common comparison → yes; unusual → maybe not)
- [ ] Is the comparison fair? (dose X vs dose Y should use same drug, not different drugs)

**Heterogeneity Warning (NEW)**:

If you suspect studies will use **different comparators**, warn early:

> ⚠️ Heads-up: Studies on [intervention] often compare against different controls (some use placebo, some use active comparator). This might create heterogeneity. Want to focus on one specific comparison type, or include all?

---

#### 2D. Outcomes (O)

> What **outcomes** matter most to you?
>
> Think about:
> - 🎯 **Primary outcome** (main thing you want to measure)
>   - Mortality / survival
>   - Symptom reduction (scales, scores)
>   - Disease progression
>   - Quality of life
>   - Functional status
> - 🔍 **Secondary outcomes** (nice to have)
>   - Adverse events / safety
>   - Adherence / dropout
>   - Cost-effectiveness
>   - Subgroup effects

**🤖 AI SELF-CHECK after user answers**:
- [ ] Is primary outcome **quantifiable**? (e.g., "depression score" → yes; "feeling better" → too vague)
- [ ] Is outcome **commonly reported**? (survival, response rate → yes; rare biomarkers → maybe not)
- [ ] Can outcome be **pooled across studies**? (same measurement tool? or different scales?)

**CRITICAL Feasibility Check (NEW)**:

Ask yourself: "Do studies on [intervention] typically report [outcome]?"

Examples:
- ✅ Drug trials → almost always report adverse events
- ✅ Depression trials → almost always report symptom scales (PHQ, BDI, HAM-D)
- ❌ Old surgical studies → may NOT report QoL (only mortality)
- ❌ Pilot studies → may report feasibility but not clinical outcomes

**If outcome might not be reported**, warn:

> ⚠️ Quick reality check: Many studies on [intervention] may not report [outcome]. Let me do a quick search to verify...

**Then run WebSearch**:

```
WebSearch: "[intervention] [condition] [outcome] randomized trial"
```

Check if outcome appears in abstracts. If <30% mention it, **flag immediately**:

> 🚨 Concern: My quick search shows only ~X% of studies report [outcome]. You might end up with very few includable studies. Want to add a more commonly reported outcome as alternative?

---

### Phase 3: Early Feasibility Assessment (ENHANCED)

**⚠️ DO THIS IMMEDIATELY AFTER PICO IS COMPLETE, BEFORE FINALIZING**

This is NOT optional. Run all checks below:

#### 3A. Existing Systematic Reviews

**Search #1: Recent reviews**

```
WebSearch: "[intervention] [condition] systematic review meta-analysis 2024 OR 2025 OR 2026"
```

**🤖 AI SELF-CHECK**:
- [ ] Found recent systematic review (within 2 years)?
  - ✅ **Yes, and outdated**: Good! You can update it
  - ⚠️ **Yes, and recent (<1 year)**: Uh-oh, may be redundant. Check if you can add new angle (subgroup, new outcome)
  - ✅ **No recent review**: Great! Clear need for new synthesis

**If recent review exists**, present to user:

> 📚 I found a systematic review published [date] titled "[title]".
>
> Options:
> 1. **Update this review** (add new studies published since)
> 2. **Focus on a subgroup** they didn't analyze (e.g., only elderly patients)
> 3. **Add new outcome** they didn't include
> 4. **Different comparison** they didn't examine
>
> Which appeals to you?

**Search #2: Cochrane Library** (gold standard)

```
WebSearch: "cochrane review [intervention] [condition]"
```

- Cochrane review exists and recent (<3 years)? → Probably don't compete, find different angle
- Cochrane review outdated (>3 years)? → Updating is valuable
- No Cochrane review? → Green light!

---

#### 3B. Study Volume Estimation

**Search #3: RCT count**

```
WebSearch: "[intervention] [population] [outcome] randomized controlled trial"
```

**🤖 AI SELF-CHECK**:
- [ ] How many results mentioned in search snippet?
  - ✅ **10+ RCTs mentioned**: Excellent, proceed
  - ⚠️ **5-9 RCTs**: Marginal, doable but small
  - ❌ **<5 RCTs**: Too few, **STOP or revise PICO**

**Alternative: PubMed Clinical Queries** (more accurate)

If you have access, suggest user run:

```
PubMed Clinical Queries:
([intervention] AND [condition] AND [outcome]) AND (randomized controlled trial[pt])
Filter: Therapy/Narrow
```

**Report findings**:

> 🔍 **Feasibility snapshot**:
> - Estimated RCTs: ~[X] studies
> - Most recent: [year]
> - Assessment: ✅ Sufficient / ⚠️ Marginal / ❌ Too few
>
> [If marginal/too few]: Want to broaden the PICO to capture more studies?

---

#### 3C. Heterogeneity Risk Assessment (NEW)

**🤖 AI MENTAL CHECK**: Based on PICO, assess heterogeneity risk:

**Low risk** ✅ (proceed confidently):
- Same drug class, same dose range
- Same population (e.g., all adults with MDD)
- Same outcome measurement (e.g., all use HAM-D scale)

**Moderate risk** ⚠️ (flag to user):
- Different drugs within same class (e.g., various SSRIs)
- Mixed populations (e.g., adults + elderly)
- Different scales measuring same construct (e.g., BDI vs HAM-D vs PHQ-9)

**High risk** ❌ (warn strongly):
- Different interventions entirely (e.g., drug + therapy mixed)
- Vastly different populations (e.g., pediatric + adult + elderly)
- Incompatible outcomes (e.g., some report mortality, some report QoL)

**If moderate/high risk, warn**:

> ⚠️ Heterogeneity concern: Based on your PICO, studies might compare different [interventions/populations/outcomes], making pooling difficult. You may need subgroup analysis or sensitivity analysis to handle this. Aware of this complexity, or want to narrow PICO?

---

#### 3D. Data Availability Check (NEW)

**🤖 AI MENTAL CHECK**: Will studies report **extractable data**?

**Good scenarios** ✅:
- Mortality (always binary: dead/alive)
- Response rate (always binary: responded/not)
- Continuous outcomes with standard scales (HAM-D, MMSE, etc.)

**Risky scenarios** ⚠️:
- Rare outcomes (event rate <5% → need huge sample sizes)
- Composite outcomes (definitions vary across studies)
- Proprietary scales (not widely used, hard to compare)

**Bad scenarios** ❌:
- Qualitative outcomes only
- "Improvement" without definition
- Outcomes reported as medians (can't pool easily)

**If risky/bad, ask user**:

> 🤔 Quick question: Are you comfortable with the possibility that some studies might not report [outcome] in a poolable format? You might need to contact authors for raw data, or exclude some studies. Okay with that?

---

### Phase 4: Refined Topic Presentation (WITH FEASIBILITY REPORT)

**After all checks, present structured topic + feasibility summary**:

```markdown
## 🎯 Your Meta-Analysis Topic

**Research Question:**
[Full PICO question in sentence form]

**Population:** [specific group]
**Intervention:** [specific treatment]
**Comparator:** [specific control]
**Outcomes:**
- Primary: [main outcome]
- Secondary: [additional outcomes]

**Study Designs:** RCTs [+ observational if justified]

---

## ✅ Feasibility Assessment (Quick Check)

**Study Volume**: ~[X] RCTs estimated
**Recent Reviews**: [None / Update available / Recent exists]
**Heterogeneity Risk**: ✅ Low / ⚠️ Moderate / ❌ High
**Outcome Reporting**: ✅ Commonly reported / ⚠️ Sometimes / ❌ Rare
**Data Extractability**: ✅ Easy / ⚠️ Moderate / ❌ Difficult

**Recommendation**:
- ✅ **PROCEED** - This looks feasible! [X] studies expected, clear gap identified.
- ⚠️ **PROCEED WITH CAUTION** - [Specific concern]. Plan for [mitigation strategy].
- ❌ **REVISE PICO** - [Fatal flaw]. Suggested changes: [...]

---

**Next Steps**:
1. Run 4-hour formal feasibility assessment (see `ma-topic-intake/references/feasibility-checklist.md`)
2. If GO, proceed to protocol development

Does this capture what you want to study? Any adjustments?
```

---

### Phase 5: Save to TOPIC.txt (WITH METADATA)

Once confirmed, save **enhanced format** with feasibility notes:

```bash
# Write the finalized topic
cat > projects/<project-name>/TOPIC.txt << 'EOF'
# Meta-Analysis Topic
# Generated: [date]
# Feasibility: [Quick-check passed]

## Research Question
[Full PICO question]

## PICO Elements

**Population**: [detailed]
**Intervention**: [detailed]
**Comparator**: [detailed]
**Outcomes**:
- Primary: [main]
- Secondary: [list]

## Study Design
Randomized controlled trials (RCTs)
[Include observational if justified: reason]

## Feasibility Notes (from brainstorming)
- Estimated studies: ~[X] RCTs
- Existing reviews: [status]
- Heterogeneity risk: [Low/Moderate/High] - [reason]
- Data concerns: [any warnings]
- Recommended next step: 4-hour formal feasibility assessment

## Analysis Type
[pairwise / nma]
- If NMA: Justification: [≥3 treatments with connected comparisons]

## Search Strategy Notes
- Databases: PubMed, Scopus, Embase, Cochrane
- Date range: [suggest based on literature scan]
- Language: English [+ others if justified]

## Potential Challenges
[List any red flags identified during brainstorming]

## Mitigation Strategies
[How to address challenges above]

---
**Status**: Ready for 4-hour feasibility assessment
**Created by**: Brainstorming session [date]
EOF
```

Then say:

> ✅ **Topic saved to `projects/<project-name>/TOPIC.txt`**
>
> 🚦 **Next Step (MANDATORY)**: Run the **4-hour feasibility assessment**
>
> This will:
> - Validate the quick checks I just did
> - Extract data from 3 pilot studies
> - Score feasibility (0-16 points)
> - Give you a GO/REVISE/STOP decision
>
> **Why**: This prevents 10-40 hours of wasted work on unanswerable questions.
>
> Ready to start the feasibility assessment now, or want to refine the topic first?

---

## 🎓 Knowledge Base for AI Agents

### Common Failure Patterns (AVOID THESE)

| ❌ Failure | Why It Fails | ✅ How to Prevent |
|-----------|-------------|------------------|
| "All cancer treatments" | Too broad, can't pool | Narrow to specific cancer + specific treatment class |
| "Drug X in rare disease" | <5 studies exist | Check study count BEFORE finalizing |
| "Improvement in symptoms" | Outcome not quantifiable | Require specific scale (e.g., HAM-D score) |
| "Any control group" | High heterogeneity | Specify one comparator type |
| "Quality of life" (vague) | Different scales across studies | Specify QoL instrument (e.g., SF-36, EQ-5D) |

### Red Flags Checklist (Check BEFORE Phase 4)

- [ ] PICO too broad? (can't pool diverse studies)
- [ ] PICO too narrow? (<5 studies likely)
- [ ] Outcome not commonly reported? (will have missing data)
- [ ] Recent systematic review exists? (redundant work)
- [ ] High heterogeneity expected? (I²>75% likely)
- [ ] Data extraction difficulty? (outcome buried in text, not tables)

**If ANY red flag = YES, address BEFORE saving TOPIC.txt**

---

## 📚 Success Examples Library (Offer as Templates)

### ✅ Example 1: Well-Scoped Topic (GOOD)

**Research Question**: Are SSRIs more effective than SNRIs for reducing depression symptoms in adults with major depressive disorder?

**Why good**:
- ✅ Specific intervention classes (not "antidepressants")
- ✅ Clear population (adults with MDD)
- ✅ Quantifiable outcome (depression symptoms on validated scales)
- ✅ Expected studies: 20+ RCTs

**Feasibility**: HIGH (14/16 points)

---

### ✅ Example 2: Updating Existing Review (GOOD)

**Research Question**: Efficacy of digital CBT vs face-to-face CBT for anxiety disorders: An updated meta-analysis

**Why good**:
- ✅ Builds on existing review (Cochrane 2021)
- ✅ Clear comparison
- ✅ New studies published since 2021
- ✅ Well-defined outcome (anxiety scales)

**Feasibility**: HIGH (13/16 points)

---

### ⚠️ Example 3: Marginal Topic (Needs Revision)

**Research Question**: Are probiotics effective for improving gut health in adults?

**Why marginal**:
- ⚠️ "Probiotics" too vague (many strains)
- ⚠️ "Gut health" not quantifiable
- ⚠️ High heterogeneity expected

**Revision needed**:
→ Narrow to: "Lactobacillus rhamnosus GG for reducing IBS symptom severity (IBS-SSS scale) in adults"

**Feasibility**: After revision: MODERATE (11/16 → 14/16)

---

### ❌ Example 4: Unfeasible Topic (STOP)

**Research Question**: Effectiveness of mindfulness meditation for any mental health condition

**Why unfeasible**:
- ❌ Too broad ("any mental health condition")
- ❌ Outcome not specified
- ❌ Heterogeneity impossibly high (I²>90% certain)
- ❌ Can't pool studies meaningfully

**Recommendation**: STOP and choose a specific condition (e.g., depression OR anxiety, not both)

**Feasibility**: FAIL (4/16 points)

---

## 🤖 Self-Prompts for AI Agents (Use Throughout)

### After Each PICO Element

**Ask yourself**:
1. "If I were doing this meta-analysis, would I be confident finding ≥5 studies?"
2. "Can I name 2-3 actual RCTs that fit this PICO right now?"
3. "Is this PICO specific enough to pool, but broad enough to find studies?"

**If answer to ANY is "no" → flag to user immediately**

---

### Before Presenting Final Topic

**Ask yourself**:
1. "Have I checked for recent systematic reviews?" (Yes/No)
2. "Have I estimated study count?" (Yes/No)
3. "Have I warned about heterogeneity if applicable?" (Yes/No)
4. "Have I flagged outcome reporting concerns?" (Yes/No)
5. "Would I bet $100 this topic will succeed?" (Yes/No)

**If answer to ANY is "no" → go back and fix**

---

### When User Pushes Back on Warnings

**Your response template**:

> I understand you're excited about [topic]! My role is to help you succeed, which means being honest about challenges upfront. Here's what I'm concerned about: [specific issue].
>
> Options:
> 1. **Proceed anyway** - But let's plan mitigation strategies
> 2. **Revise slightly** - [Specific suggestion to address concern]
> 3. **Run quick feasibility check now** - 10 min to validate my concern
>
> What feels right to you?

**Never**: Blindly agree to unfeasible topics. **Always**: Offer alternatives.

---

## 📞 When to Suggest Formal Feasibility Assessment

**Trigger these situations**:
1. **Uncertain about study count** - "Let's run the 4-hour assessment to get exact numbers"
2. **Moderate heterogeneity risk** - "Pilot extraction will show if pooling is feasible"
3. **User is risk-averse** - "4 hours now saves 10-40 hours later"
4. **This is user's first meta-analysis** - "Standard practice, prevents wasted effort"
5. **Feasibility score borderline** (10-12 points) - "Assessment will give definitive answer"

**How to pitch it**:

> 🎯 **Recommended**: Before investing weeks in this project, let's run a **4-hour feasibility assessment**. This will:
> - Validate my quick checks (study count, heterogeneity)
> - Extract data from 3 pilot studies (see if outcome is reported)
> - Score feasibility 0-16 (≥12 = GO)
> - Save 10-40 hours if topic needs revision
>
> Want to do this now? It's in `ma-topic-intake/references/feasibility-checklist.md`

---

## 🎁 Deliverables at End of Brainstorming

When user says "looks good!", provide:

1. ✅ **TOPIC.txt file** (saved to `projects/<project-name>/TOPIC.txt`)
2. ✅ **Feasibility quick-check summary** (in TOPIC.txt metadata)
3. ✅ **Next steps** (formal 4-hour assessment)
4. ✅ **List of potential challenges** (from your checks)
5. ✅ **Suggested mitigation strategies**

**Template response**:

> 🎉 **Brainstorming complete!**
>
> ✅ **Saved**: `projects/<project-name>/TOPIC.txt` (includes PICO + feasibility notes)
>
> 📋 **Quick Feasibility Check**:
> - Study volume: ~[X] RCTs ✅
> - Recent reviews: [status] ✅/⚠️
> - Heterogeneity: [Low/Moderate] ✅/⚠️
> - Outcome reporting: [Good/Moderate] ✅/⚠️
>
> 🚦 **Recommendation**: [PROCEED / PROCEED WITH CAUTION / REVISE]
>
> ⚠️ **Potential Challenges**:
> - [List specific concerns from checks]
>
> 🛡️ **Mitigation Strategies**:
> - [How to address each concern]
>
> 📍 **Next Steps**:
> 1. **MANDATORY**: Run 4-hour formal feasibility assessment (`ma-topic-intake/references/feasibility-checklist.md`)
> 2. If GO: Proceed to protocol development (Stage 01)
> 3. If REVISE: Come back and we'll adjust PICO
> 4. If STOP: Choose a different topic (I'll help!)
>
> Ready to start the feasibility assessment now? Or want to refine anything first?

---

## 🔄 Iterative Refinement (When User Says "Not Quite Right")

If user isn't satisfied with the topic:

1. **Ask specifically**: "What feels off? [Population / Intervention / Comparator / Outcome / Scope]?"
2. **Offer 2-3 alternatives** based on their answer
3. **Re-run feasibility checks** for each alternative
4. **Let user choose** the most appealing option

**Example**:

> Okay, let's adjust! Which element feels off?
>
> **A. Population too narrow/broad**
> - Narrower: [example]
> - Broader: [example]
>
> **B. Intervention not quite right**
> - Alternative 1: [example]
> - Alternative 2: [example]
>
> **C. Outcome not what you want**
> - Instead of [X], try [Y]?
>
> **D. Comparison not ideal**
> - Switch to [alternative comparator]?
>
> Tell me which letter + option, and I'll revise!

---

## 🎯 Success Metrics (For This Skill)

**You've succeeded when**:
- ✅ User has a **feasible** topic (not just any topic)
- ✅ Quick feasibility checks completed (study count, reviews, heterogeneity)
- ✅ User understands **next steps** (4-hour assessment)
- ✅ Potential challenges **flagged early** (not discovered later)
- ✅ TOPIC.txt saved with **metadata** (not just PICO alone)

**You've failed when**:
- ❌ User starts extraction, then discovers <3 studies exist
- ❌ User discovers later that outcome isn't reported
- ❌ High heterogeneity makes pooling impossible (should've warned)
- ❌ Recent review makes work redundant (should've checked)

**Measure**: 4-hour feasibility assessment should **pass ≥80% of the time** for topics you help create. If not, you're being too lenient.

---

## 📖 Additional Resources for Users

**When user asks "How do I do X?"**:

| Question | Point Them To |
|---------|--------------|
| "How to search PubMed?" | `ma-search-bibliography/references/api-setup.md` |
| "What's a good PICO?" | This skill's Example Library above |
| "How many studies do I need?" | Rule of thumb: ≥5 RCTs minimum, ≥10 ideal |
| "What if outcome isn't reported?" | Contact authors, or use surrogate outcome |
| "What's the 4-hour assessment?" | `ma-topic-intake/references/feasibility-checklist.md` |
| "Can I skip feasibility check?" | **NO** - It's mandatory. Saves 10-40 hours later. |

---

**Version**: 2.0 (Enhanced)
**Date**: 2026-02-17
**Changes from v1.0**:
- Added Phase 0 (pre-assessment)
- Added instant feasibility checks after each PICO element
- Added heterogeneity risk assessment
- Added data availability checks
- Added AI self-check prompts throughout
- Added success examples library
- Added TOPIC.txt metadata (not just PICO)
- Added formal handoff to 4-hour assessment
- Added failure patterns and prevention strategies
