# Methods

## Protocol and Registration
This systematic review and NMA was conducted following the Preferred Reporting
Items for Systematic Reviews and Meta-Analyses extension for Network
Meta-Analyses (PRISMA-NMA) guidelines.^1 The protocol will be registered in
PROSPERO prior to final data lock.

## Eligibility Criteria
We included RCTs (Phase 2b, 3, or 3b/4) that: (1) enrolled HIV-uninfected adults
(aged ≥18 years) at risk of HIV-1 acquisition; (2) evaluated at least one PrEP
intervention (TDF/FTC, TAF/FTC, TDF monotherapy, event-driven TDF/FTC,
CAB-LA, lenacapavir, or dapivirine vaginal ring) versus placebo, deferred
initiation, or another active PrEP agent; (3) reported confirmed HIV-1 incident
infections with person-time data; and (4) had a minimum follow-up duration of
24 weeks. We imposed no language restriction. We excluded post-exposure
prophylaxis trials, prevention of mother-to-child transmission studies, and
pharmacokinetic-only studies.

## Search Strategy
We searched PubMed/MEDLINE, Embase, Cochrane CENTRAL, ClinicalTrials.gov, and
WHO ICTRP from January 2000 to March 2026. We supplemented electronic searches
with hand-searching of conference abstracts from the Conference on Retroviruses
and Opportunistic Infections (CROI), the International AIDS Society (IAS)
Conference, and the HIV Research for Prevention conference (HIVR4P).
Full search strings are provided in the Supplementary Appendix.

## Study Selection and Data Extraction
Two reviewers independently screened titles and abstracts and then full texts.
Disagreements were resolved by consensus. Data were extracted independently in
duplicate using a standardized extraction form, capturing: trial name, year,
country, population characteristics, intervention details, sample size per arm,
HIV events, and person-years at risk.

## Risk of Bias Assessment
Risk of bias was assessed using the Cochrane Risk of Bias tool version 2 (RoB 2)
across five domains: randomization process, deviations from intended
interventions, missing outcome data, measurement of outcome, and selection of
reported results.

## Statistical Analysis

### Network Meta-Analysis
We conducted a frequentist random-effects NMA using the `netmeta` package
(version 2.9) in R (version 4.4.0).^2 For each study arm, the primary effect
measure was the incidence rate ratio (IRR) on the log scale, computed from
events and person-time data. Variability was estimated using the Poisson
approximation (SE of log IRR = √[1/e₁ + 1/e₂]), with a continuity correction
of 0.5 added to studies with zero events in either arm (PURPOSE 1, lenacapavir
arm). Consistency between direct and indirect evidence was evaluated using
node-splitting.^3 We estimated heterogeneity using τ (between-study standard
deviation) and I².

We additionally performed Bayesian NMA using the `gemtc` package interfacing
with JAGS as sensitivity validation, specifying a vague half-normal prior on
between-study standard deviation (half-normal, SD=0.5).

### Ranking
Treatments were ranked using Surface Under the Cumulative Ranking curve (SUCRA)
values, with higher SUCRA indicating better HIV prevention.^4

### Subgroup Analyses
Pre-specified subgroup analyses were performed by: (1) population (MSM/
transgender vs cisgender women vs heterosexual serodiscordant couples); (2)
income setting (high-income vs low-/middle-income countries).

### Sensitivity Analyses
We conducted sensitivity analyses: (1) excluding adherence-confounded trials
(FEM-PrEP and VOICE, in which plasma tenofovir levels confirmed <30–40%
adherence); (2) excluding open-label trials (PROUD); (3) restricting to
double-blind trials only; (4) per-protocol analysis where available.

### Transitivity Assumption
We assessed the transitivity assumption by comparing the distribution of
potential effect modifiers (population sex, risk group, background HIV incidence,
study year) across trials grouped by comparison type.

---
**References for methods will be formatted per target journal style.**
