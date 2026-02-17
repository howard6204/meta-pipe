# Lancet Oncology Research in Context Panel Template

**Target word count**: ~450 words (±50 acceptable)
**Location**: After title page, before Abstract (separate page)
**Reading time**: 3 min

📖 **See guide**: [journal-materials-guide.md](../../references/journal-materials-guide.md#option-b-lancet-oncology---research-in-context-panel)

---

## Template Structure

```markdown
## Research in Context

### Evidence before this study

{{PRIOR_REVIEWS_SUMMARY}}. However, {{KNOWLEDGE_GAP}}. {{WHY_CURRENT_EVIDENCE_INSUFFICIENT}}.

### Added value of this study

This is the first {{NOVELTY}} to {{PRIMARY_AIM}}. We synthesized data from {{N_TRIALS}} {{STUDY_DESIGN}} trials (N={{N_PATIENTS}} patients) published through {{SEARCH_DATE}}, using rigorous methods including {{METHODOLOGY_HIGHLIGHTS}}. Our analysis provides {{UNIQUE_CONTRIBUTION}}, revealing {{PRIMARY_FINDING}}. Importantly, {{MECHANISTIC_OR_METHODOLOGICAL_INSIGHT}}.

### Implications of all available evidence

For patients with {{POPULATION}}, {{PRIMARY_RECOMMENDATION}} based on {{EVIDENCE_STRENGTH}}. However, clinical decision-making should incorporate {{SHARED_DECISION_MAKING_CONSIDERATIONS}}. Future research should prioritize {{RESEARCH_PRIORITIES}}. Guideline updates should {{POLICY_RECOMMENDATIONS}}.
```

---

## Fill Instructions

### Evidence before this study (~150 words)

**Replace**:
- `{{PRIOR_REVIEWS_SUMMARY}}` → Cite 2-3 prior meta-analyses/reviews (Author et al, Year, Journal)
  - Example: "Prior systematic reviews (Smith et al, 2024, Lancet Oncol; Jones et al, 2025, JAMA Oncol) have established ICI efficacy in resectable NSCLC"
- `{{KNOWLEDGE_GAP}}` → Specific gap your study addresses
  - Example: "no network meta-analysis has directly compared the three timing strategies"
- `{{WHY_CURRENT_EVIDENCE_INSUFFICIENT}}` → Why existing evidence doesn't answer the question
  - Example: "Individual trials lack head-to-head comparisons, and indirect evidence has been limited to narrative reviews"

**Tips**:
- Cite specific reviews (not "previous studies have shown")
- Identify precise gap (not "more research is needed")

---

### Added value of this study (~150 words)

**Replace**:
- `{{NOVELTY}}` → "Bayesian network meta-analysis" or "systematic review and meta-analysis"
- `{{PRIMARY_AIM}}` → "compare all three ICI timing strategies"
- `{{N_TRIALS}}` → "10 phase 3 randomized clinical"
- `{{N_PATIENTS}}` → "9,907"
- `{{SEARCH_DATE}}` → "December 2025"
- `{{METHODOLOGY_HIGHLIGHTS}}` → "GRADE assessment via CINeMA, transitivity evaluation, and inconsistency assessment"
- `{{UNIQUE_CONTRIBUTION}}` → "the first probabilistic rankings of timing strategies"
- `{{PRIMARY_FINDING}}` → "perioperative therapy as the superior strategy for EFS (87.8% probability best)"
- `{{MECHANISTIC_OR_METHODOLOGICAL_INSIGHT}}` → "we identify and explain the paradoxical OS findings through methodological analysis of follow-up maturity rather than speculative biological mechanisms"

**Tips**:
- Emphasize "first", "largest", "most rigorous", "only"
- List methodology rigor (Bayesian, GRADE, PRISMA-NMA)
- Highlight unique insights (e.g., explaining paradoxes)

---

### Implications of all available evidence (~150 words)

**Replace**:
- `{{POPULATION}}` → "resectable stage II-IIIB NSCLC"
- `{{PRIMARY_RECOMMENDATION}}` → "perioperative ICI therapy should be considered the preferred timing strategy to optimize event-free survival"
- `{{EVIDENCE_STRENGTH}}` → "consistent evidence from network meta-analysis"
- `{{SHARED_DECISION_MAKING_CONSIDERATIONS}}` → "trade-offs: perioperative offers superior EFS but requires longer treatment duration (neoadjuvant + adjuvant vs adjuvant alone), while adjuvant-only may be preferred in patients with surgical delays"
- `{{RESEARCH_PRIORITIES}}` → "longer-term overall survival data (4-6 years from trial initiation) to confirm whether perioperative superiority persists"
- `{{POLICY_RECOMMENDATIONS}}` → "emphasize scenario-based recommendations rather than universal protocols, reflecting patient heterogeneity in surgical candidacy, tumor biology, and treatment tolerance"

**Tips**:
- State practice change (immediate vs delayed implementation)
- List future research needs (specific, testable)
- Mention policy/guideline implications

---

## Checklist Before Submitting

- [ ] Word count ~450 words (±50 acceptable, verify with `wc -w`)
- [ ] Cites 2-3 specific prior reviews in "Evidence before"
- [ ] Emphasizes novelty in "Added value" (first/largest/only)
- [ ] Lists methodology rigor (GRADE, CINeMA, PRISMA-NMA)
- [ ] Provides specific recommendations in "Implications"
- [ ] Embedded after title page, before Abstract (separate page)

---

## Example (from early-immuno-timing-nma)

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

---

**Version**: 1.0.0 (2026-02-18)
**Source**: early-immuno-timing-nma project
