# Topic Feasibility Quick Reference Card

**🎯 Use this**: Before finalizing any meta-analysis topic
**⏱️ Time**: 2 minutes to review
**🎓 Audience**: Researchers, AI agents

---

## ✅ The "GO" Checklist (All Must Be YES)

- [ ] **Can name ≥3 RCTs that fit PICO** (from memory or quick search)
- [ ] **Population is specific** (not "sick people" or "anyone")
- [ ] **Intervention is clear** (specific drug/therapy class)
- [ ] **Outcome is measurable** (validated scale/binary endpoint)
- [ ] **Comparator is standard** (placebo, active control, or usual care)
- [ ] **Expected ≥5 studies** (from quick PubMed search)
- [ ] **No recent comprehensive review** (<1 year old covering same PICO)

**All ✅?** → Proceed to formal feasibility assessment
**Any ❌?** → STOP and revise PICO first

---

## 🚩 Instant Red Flags (STOP if ANY present)

| Red Flag | Example | Fix |
|----------|---------|-----|
| **Too broad** | "Cancer treatment" | → "Pembrolizumab for NSCLC" |
| **Too narrow** | "Drug X in 65-70 year olds only" | → "Drug X in elderly (≥65)" |
| **Vague outcome** | "Feeling better" | → "HAM-D score reduction" |
| **<3 studies** | Rare disease | → Broaden or choose different topic |
| **No comparator** | Single-arm studies only | → Require comparative studies |
| **Outcome not reported** | <30% studies report it | → Switch to commonly reported outcome |

---

## 📊 Quick Feasibility Score (0-8 points)

Score each: **2 = Yes**, **1 = Maybe**, **0 = No**

| Check | Score (0-2) |
|-------|------------|
| ≥10 RCTs expected? | ___ |
| Outcome commonly reported? | ___ |
| Intervention homogeneous? | ___ |
| Population well-defined? | ___ |
| **TOTAL** | **___/8** |

**Interpretation:**

- **7-8**: ✅ Excellent, proceed
- **5-6**: ⚠️ Marginal, plan mitigation
- **0-4**: ❌ Revise or stop

---

## 🎯 The "Goldilocks" PICO

| Element | ❌ Too Broad | ✅ Just Right | ❌ Too Narrow |
|---------|-------------|--------------|--------------|
| **P** | "Cancer patients" | "Adults with advanced NSCLC" | "65-70 yo with NSCLC EGFR exon 19 del" |
| **I** | "Treatment" | "Pembrolizumab 200mg Q3W" | "Pembrolizumab batch XYZ only" |
| **C** | "Any control" | "Platinum-based chemo" | "Cisplatin 75mg/m² + pemetrexed 500mg/m² only" |
| **O** | "Health" | "Progression-free survival" | "Biomarker X at week 3" |

**Goal**: Specific enough to pool + Broad enough to find studies

---

## 🔍 3-Minute Web Check

**Step 1**: PubMed search (1 min)

```
([intervention] OR [drug]) AND [condition] AND (randomized controlled trial[pt])
```

**✅ >50 results**: Excellent
**⚠️ 20-49 results**: Marginal
**❌ <20 results**: Too narrow

---

**Step 2**: Recent review check (1 min)

```
[intervention] [condition] systematic review 2024 OR 2025
```

**✅ No review**: Clear need
**⚠️ Review >2 years old**: Can update
**❌ Review <1 year**: Probably redundant

---

**Step 3**: Outcome check (1 min)

```
[intervention] [condition] [outcome] trial
```

**Check abstracts**: ≥50% mention outcome?
**✅ Yes**: Proceed
**❌ No**: Change outcome

---

## 🧠 Mental Check for AI Agents

Before presenting topic to user, ask yourself:

1. **"Would I bet $50 this will succeed?"** (Yes → proceed | No → revise)
2. **"Can I name 2 actual RCTs right now?"** (Yes → feasible | No → too obscure)
3. **"Is PICO specific enough to pool?"** (Yes → good | No → too broad)
4. **"Is PICO broad enough to find ≥5 studies?"** (Yes → good | No → too narrow)

**All YES?** → Present topic
**Any NO?** → Revise first

---

## 🎓 Common Patterns (Learn These)

### ✅ High-Success Topics

- Drug class vs drug class (SSRIs vs SNRIs)
- New drug vs standard (pembrolizumab vs chemo)
- Therapy vs control (CBT vs waitlist)
- Procedure A vs B (robotic vs open surgery)

**Why**: Clear comparisons, well-studied, measurable outcomes

---

### ❌ High-Failure Topics

- "Treatment for condition X" (too broad)
- "Rare intervention for rare disease" (too few studies)
- "Quality of life" without specifying instrument (not measurable)
- "Any improvement" (vague outcome)

**Why**: Heterogeneity too high, studies don't report outcome, <5 studies

---

## 🛡️ Quick Mitigation Strategies

| Challenge | Quick Fix |
|-----------|-----------|
| Only 8 RCTs (marginal) | ✅ Accept (8 is feasible) + plan sensitivity analysis |
| High heterogeneity expected | ✅ Plan subgroup analysis + random-effects model |
| Outcome in 60% of studies | ✅ Contact authors for missing data |
| Recent review exists (1-2 yrs) | ✅ Update it (add new studies) or focus on subgroup |

---

## 📞 When to Escalate to Formal Assessment

**Always recommend 4-hour assessment if:**

- First-time meta-analysis
- Feasibility score 5-6 (borderline)
- User is risk-averse
- Moderate heterogeneity risk
- Uncertain study count

**How to pitch it**:

> 🎯 Recommended: Run 4-hour formal assessment before investing weeks. This validates my quick checks and prevents 10-40 hours of wasted work if topic needs revision.

---

## 🎁 Outputs to Deliver

When brainstorming ends, user gets:

1. ✅ **TOPIC.txt** (PICO + feasibility notes + metadata)
2. ✅ **Study count estimate** (~X RCTs expected)
3. ✅ **Red flags identified** (if any)
4. ✅ **Mitigation strategies** (how to address challenges)
5. ✅ **Next steps** (formal assessment recommended)

---

## 📚 Quick Links

- **Full brainstorming guide**: [brainstorming-best-practices.md](brainstorming-best-practices.md)
- **4-hour assessment**: [feasibility-checklist.md](feasibility-checklist.md)
- **Success example**: [ici-breast-cancer project](../../projects/ici-breast-cancer/)

---

**Keep this card handy**: Refer to it before finalizing ANY meta-analysis topic.

**Version**: 1.0 | **Date**: 2026-02-17
