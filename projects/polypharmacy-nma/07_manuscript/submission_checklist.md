# Submission Checklist

## Target Journals (suggested, in order of fit)

| Journal | IF | Scope | NMA-friendly |
|---|---|---|---|
| Age and Ageing | ~7.5 | Geriatrics/gerontology | Yes |
| J Am Geriatr Soc | ~9.0 | Geriatrics, clinical | Yes |
| BMC Geriatrics | ~4.0 | Open access, geriatrics | Yes |
| Systematic Reviews | ~4.0 | Methods + systematic reviews | Yes |
| J Am Med Dir Assoc | ~6.5 | Long-term care | Yes |

---

## Pre-submission Checklist

### Manuscript
- [ ] Title (≤20 words, includes "network meta-analysis")
- [ ] Abstract structured (Background, Objectives, Methods, Results, Conclusions)
- [ ] Word count within journal limit (typically 3,500–5,000)
- [ ] PRISMA-NMA flow diagram (Figure 1)
- [ ] All figures have legends
- [ ] All tables have footnotes
- [ ] References formatted per target journal style

### Analysis
- [ ] PROSPERO registration confirmed
- [ ] Risk of bias (RoB 2 tool) completed for all 8 studies
- [ ] GRADE evidence profile for main outcomes
- [ ] Inconsistency formally tested (design-by-treatment interaction model)
- [ ] Comparison-adjusted funnel plots (if k ≥ 10 per comparison — note: currently k < 10, so optional)
- [ ] Sensitivity analysis: exclude Kua 2020 from hospitalization NMA

### Optional extensions
- [ ] Install JAGS → re-run Bayesian NMA (gemtc) for true SUCRA with credible intervals
- [ ] Add more Asian trials (PubMed Chinese-language, CNKI search)
- [ ] Update hospitalization estimate for Lapane 2011 with exact published HR

---

## Files in 07_manuscript/

- `manuscript.md` — Full manuscript (Title through References + Figure Legends)
- `supplementary.md` — Tables S1–S4, PRISMA checklist, full study extractions
- `submission_checklist.md` — This file

## Analysis outputs (in 06_analysis/)

| File | Description |
|---|---|
| `figures/REAL_falls_network.png` | Fig 2A — Falls network |
| `figures/REAL_hosp_network.png` | Fig 2B — Hospitalization network |
| `figures/REAL_pims_all_network.png` | Fig 2C — PIMs network |
| `figures/REAL_falls_forest.png` | Fig 3A — Falls forest plot |
| `figures/REAL_hosp_forest.png` | Fig 3B — Hospitalization forest plot |
| `figures/REAL_pims_all_forest.png` | Fig 3C — PIMs forest plot |
| `figures/REAL_falls_ranking.png` | Fig 4A — Falls P-score ranking |
| `figures/REAL_hosp_ranking.png` | Fig 4B — Hospitalization P-score ranking |
| `figures/REAL_pims_all_ranking.png` | Fig 4C — PIMs P-score ranking |
| `figures/REAL_combined_ranking.png` | Fig 5 — Combined ranking comparison |
| `figures/REAL_falls_league.png` | Fig S3A — Falls league table |
| `figures/REAL_hosp_league.png` | Fig S3B — Hospitalization league table |
| `figures/REAL_pims_all_league.png` | Fig S3C — PIMs league table |
| `figures/REAL_hosp_sg_institutionalized_forest.png` | Fig S1 — Hosp subgroup |
| `figures/REAL_pims_eu_forest.png` | Fig S2 — PIMs EU subgroup |
| `tables/REAL_evidence_table.csv` | Table 1 source data |
| `tables/REAL_falls_rankings.csv` | Table 2 source data |
| `tables/REAL_hosp_rankings.csv` | Table 2 source data |
| `tables/REAL_pims_all_rankings.csv` | Table 2 source data |
| `tables/REAL_pims_eu_rankings.csv` | Table S3 source data |
| `tables/REAL_nma_falls_contrast.csv` | Table S2a source data |
| `tables/REAL_nma_hosp_contrast.csv` | Table S2b source data |
| `tables/REAL_nma_pims_contrast.csv` | Table S2c source data |
