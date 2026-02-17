# JAMA Oncology Key Points Box Template

**Target word count**: ≤350 words
**Location**: After Abstract, before Introduction
**Reading time**: 2 min

📖 **See guide**: [journal-materials-guide.md](../../references/journal-materials-guide.md#option-a-jama-oncology---key-points-box)

---

## Template Structure

```markdown
## Key Points

**Question**: {{RESEARCH_QUESTION_IN_INTERROGATIVE_FORM}}

**Findings**: {{STUDY_DESIGN}} of {{N_TRIALS}} randomized clinical trials including {{N_PATIENTS}} patients {{WITH_POPULATION_CHARACTERISTICS}}, {{PRIMARY_TREATMENT}} showed {{PRIMARY_OUTCOME}} compared with {{COMPARATOR}} (hazard ratio [HR], {{HR_VALUE}}; 95% CI, {{CI_LOWER}}-{{CI_UPPER}}; {{PROBABILITY_BEST}}% probability of being best treatment). {{SECONDARY_FINDING_OR_LIMITATION}}.

**Meaning**: Among patients with {{POPULATION}}, {{PRIMARY_TREATMENT}} appears to {{PRIMARY_BENEFIT}}, though {{LIMITATION_OR_DATA_MATURITY}}. {{CLINICAL_RECOMMENDATION_OR_SHARED_DECISION_MAKING}}.
```

---

## Fill Instructions

### Question (~20 words)

**Replace**:
- `{{RESEARCH_QUESTION_IN_INTERROGATIVE_FORM}}` → Must start with "What", "Does", "Is", etc.

**Example**:
- ✅ "What is the optimal timing strategy for immune checkpoint inhibitor therapy in patients with resectable non-small cell lung cancer?"
- ❌ "To determine optimal ICI timing" (not interrogative)

---

### Findings (~100-150 words)

**Replace**:
- `{{STUDY_DESIGN}}` → "In this network meta-analysis" or "In this meta-analysis"
- `{{N_TRIALS}}` → Number of trials (e.g., "10")
- `{{N_PATIENTS}}` → Total sample size with comma (e.g., "9,907")
- `{{WITH_POPULATION_CHARACTERISTICS}}` → "with resectable stage II-IIIB NSCLC"
- `{{PRIMARY_TREATMENT}}` → "perioperative ICI" (full name first mention)
- `{{PRIMARY_OUTCOME}}` → "superior event-free survival"
- `{{COMPARATOR}}` → "adjuvant-only" or "monotherapy"
- `{{HR_VALUE}}` → "0.565" (2-3 decimal places)
- `{{CI_LOWER}}` → "0.460"
- `{{CI_UPPER}}` → "0.695"
- `{{PROBABILITY_BEST}}` → "87.8" (NMA only, omit if pairwise)
- `{{SECONDARY_FINDING_OR_LIMITATION}}` → "However, overall survival data remain immature"

**Tips**:
- Include [HR] bracket notation for abbreviations first use
- For pairwise MA, omit probability best
- For NMA, mention ranking if central finding

---

### Meaning (~100-150 words)

**Replace**:
- `{{POPULATION}}` → Repeat population from Findings (e.g., "resectable stage II-IIIB NSCLC")
- `{{PRIMARY_TREATMENT}}` → "perioperative ICI therapy"
- `{{PRIMARY_BENEFIT}}` → "optimize event-free survival" (avoid "prove", use "appears to")
- `{{LIMITATION_OR_DATA_MATURITY}}` → "longer-term OS data are needed to confirm this benefit persists"
- `{{CLINICAL_RECOMMENDATION_OR_SHARED_DECISION_MAKING}}` → "Shared decision-making should weigh EFS gains against treatment duration (12 weeks vs 12 months) and toxicity profiles"

**Tips**:
- Use "appears to", "suggests", "may" (not "proves", "demonstrates definitively")
- Acknowledge limitations (data maturity, heterogeneity)
- Add scenario-based guidance if possible (shared decision-making, patient subgroups)

---

## Checklist Before Submitting

- [ ] Word count ≤350 words (verify with `wc -w`)
- [ ] Question is interrogative (starts with What/Does/Is)
- [ ] Findings include study design, N, primary results with HR/RR + 95% CI
- [ ] Meaning acknowledges limitations (no overclaims)
- [ ] No abbreviations without [full form] on first use
- [ ] Embedded after Abstract, before Introduction in manuscript

---

## Example (from early-immuno-timing-nma)

```markdown
## Key Points

**Question**: What is the optimal timing strategy for immune checkpoint inhibitor therapy in patients with resectable non-small cell lung cancer?

**Findings**: In this network meta-analysis of 10 randomized clinical trials including 9,907 patients with resectable stage II-IIIB non-small cell lung cancer, perioperative immune checkpoint inhibitor therapy (neoadjuvant plus adjuvant) showed superior event-free survival compared with adjuvant-only (hazard ratio [HR], 0.565; 95% CI, 0.460-0.695; 87.8% probability of being best treatment) or neoadjuvant-only strategies (HR, 0.794; 95% CI, 0.656-0.960). However, overall survival data remain immature (median follow-up, 25-38 months for perioperative trials vs 60 months for adjuvant trials).

**Meaning**: Among patients with resectable stage II-IIIB non-small cell lung cancer, perioperative immune checkpoint inhibitor therapy appears to optimize event-free survival, though longer-term overall survival data are needed to confirm this benefit persists. Shared decision-making should weigh event-free survival gains against treatment duration (12 weeks vs 12 months) and toxicity profiles.
```

**Word count**: 175 words ✅

---

**Version**: 1.0.0 (2026-02-18)
**Source**: early-immuno-timing-nma project
