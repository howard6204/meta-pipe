# PROSPERO-Format Protocol
# HIV PrEP Network Meta-Analysis

**Title**: Comparative Efficacy and Safety of All HIV Pre-Exposure Prophylaxis
Modalities Including Investigational Agents: A Systematic Review and Network
Meta-Analysis

**Registration**: PROSPERO (pending)
**Protocol date**: 2026-03-28
**Version**: 1.0

---

## 1. Review Question
Among HIV-uninfected adults at risk of HIV-1 acquisition, what is the comparative
efficacy and safety of all approved and investigational PrEP interventions
(including dapivirine vaginal ring, long-acting injectables, and twice-yearly
lenacapavir), and how do they rank relative to each other and to placebo?

**PICO:**
- **P**: HIV-uninfected adults (>=18 years) at risk of HIV-1 acquisition
- **I**: Any PrEP intervention: TDF/FTC, TAF/FTC, TDF monotherapy, TDF/FTC
  on-demand, CAB-LA, lenacapavir, dapivirine vaginal ring
- **C**: Placebo, deferred treatment, or any active PrEP comparator
- **O**: HIV-1 incidence (primary); grade 3/4 AEs, SAEs, discontinuations (secondary)

## 2. Eligibility Criteria

### Inclusion
- Randomised controlled trials (parallel or factorial design)
- HIV-uninfected adults at risk of HIV-1 acquisition (any transmission route)
- Any PrEP intervention (oral, injectable, intravaginal)
- Report confirmed HIV-1 incident infection as an outcome
- Minimum 50 participants per arm

### Exclusion
- Non-randomised studies
- Post-exposure prophylaxis trials
- Treatment (not prevention) trials
- Trials enrolling only HIV-positive participants
- Trials not reporting HIV incidence

## 3. Search Strategy

**Databases**: PubMed/MEDLINE, Embase, Cochrane CENTRAL, ClinicalTrials.gov,
WHO ICTRP, CROI/IAS/IAC conference abstracts (2010–2026)

**Key terms**: HIV, pre-exposure prophylaxis, PrEP, tenofovir, emtricitabine,
cabotegravir, lenacapavir, dapivirine, vaginal ring, randomized controlled trial

**Date range**: Database inception to March 2026
**Language**: No restriction

## 4. Study Selection
Two independent reviewers screen titles/abstracts, then full texts, with
discrepancies resolved by consensus. PRISMA flow diagram documenting reasons
for exclusion at full-text stage.

## 5. Data Extraction
Standardised extraction form capturing: study ID, year, population demographics,
intervention and comparator arms, HIV events, person-years, incidence rates,
efficacy with 95% CI, grade 3/4 AEs, SAEs, discontinuation rates, and risk of
bias assessment.

## 6. Risk of Bias Assessment
RoB 2 tool (Cochrane) for parallel-group RCTs, across five domains. Studies
classified as low / some concerns / high overall.

## 7. Statistical Analysis

### Primary Analysis
Frequentist random-effects NMA using the graph-theoretic approach (Rucker 2012).
Outcome: log incidence rate ratio (Poisson model). Heterogeneity: DerSimonian–
Laird tau2. Reference: placebo.

### Ranking
SUCRA probabilities via Monte Carlo simulation (10,000 draws) from multivariate
normal distribution of NMA estimates.

### Consistency
Local: node-splitting. Global: design-by-treatment interaction test.

### Sensitivity Analyses
1. Excluding adherence-confounded trials (FEM-PrEP, VOICE)
2. Excluding open-label trial (PROUD)
3. MSM/TGW subgroup
4. Cisgender women subgroup

## 8. Transitivity Assessment
Assessed by comparing distribution of potential effect modifiers (population risk,
background incidence, geography, study era) across trials sharing each comparison.

## 9. Software
Python 3.14 (NumPy, SciPy, Matplotlib, Pandas)

## 10. Deviations from Protocol
None (prospective registration; no deviations).
