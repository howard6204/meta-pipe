# HIV PrEP Network Meta-Analysis — Project Overview

**Status**: COMPLETE (analysis run 2026-03-30)
**Topic**: Comparative efficacy of all HIV PrEP modalities including
investigational agents and dapivirine vaginal ring

---

## Key Results (NMA vs Placebo, random effects)

| Rank | Treatment | IRR (95% CI) | Efficacy | SUCRA |
|------|-----------|-------------|----------|-------|
| 1 | Lenacapavir (twice-yearly) | 0.03 (0.008–0.099) | 97% | 99.1% |
| 2 | Cabotegravir LA | 0.14 (0.069–0.273) | 86% | 79.2% |
| 3 | TDF/FTC on-demand | 0.14 (0.031–0.680) | 86% | 76.2% |
| 4 | TAF/FTC daily | 0.50 (0.277–0.899) | 50% | 47.6% |
| 5 | TDF/FTC daily | 0.58 (0.440–0.755) | 42% | 39.5% |
| 6 | TDF monotherapy | 0.61 (0.430–0.864) | 39% | 34.2% |
| 7 | Dapivirine ring | 0.71 (0.484–1.028) | 29%* | 23.5% |

*p = 0.069; not statistically significant in NMA (significant in direct analyses)

**Heterogeneity**: tau2 = 0.051, I2 = 52.3% (moderate)

---

## Trials Included (14 RCTs)

| Trial | Year | Population | Interventions |
|-------|------|-----------|---------------|
| iPrEx | 2010 | MSM/TGW | TDF/FTC vs PBO |
| Partners PrEP | 2012 | Serodiscordant | TDF/FTC, TDF vs PBO (3-arm) |
| TDF2 | 2012 | Heterosexual | TDF/FTC vs PBO |
| FEM-PrEP | 2012 | Cisgender women | TDF/FTC vs PBO |
| VOICE | 2015 | Cisgender women | TDF/FTC, TDF vs PBO (3-arm) |
| IPERGAY | 2015 | MSM/TGW | TDF/FTC on-demand vs PBO |
| PROUD | 2016 | MSM | TDF/FTC immediate vs deferred |
| ASPIRE | 2016 | Cisgender women | Dapivirine ring vs PBO |
| Ring Study | 2016 | Cisgender women | Dapivirine ring vs PBO |
| DISCOVER | 2020 | MSM/TGW | TAF/FTC vs TDF/FTC |
| HPTN 083 | 2021 | MSM/TGW | CAB-LA vs TDF/FTC |
| HPTN 084 | 2022 | Cisgender women | CAB-LA vs TDF/FTC |
| PURPOSE 1 | 2024 | Cisgender women | LEN vs TAF/FTC vs TDF/FTC (3-arm) |
| PURPOSE 2 | 2024 | MSM/TGW/NB | LEN vs TDF/FTC |

---

## Files

```
projects/hiv-prep-nma/
├── 00_overview/README.md           ← this file
├── 01_protocol/prospero_protocol.md
├── 05_extraction/extraction.csv    ← 14 trials, 31 arms
├── 06_analysis/nma_python.py       ← main analysis script
├── 07_manuscript/
│   ├── manuscript.qmd              ← full manuscript (Quarto)
│   └── sections/                   ← individual sections
├── figures/
│   ├── fig1_network_plot.png
│   ├── fig2_nma_forest.png
│   ├── fig3_sucra.png
│   ├── fig4_league_table.png
│   ├── fig5_direct_vs_nma.png
│   └── fig6_funnel_plot.png
└── tables/
    ├── table1_study_characteristics.md
    ├── table2_nma_results.md
    ├── nma_results_vs_placebo.csv
    ├── sucra_rankings.csv
    └── league_table.csv
```

## Reproduce Analysis

```bash
cd projects/hiv-prep-nma/06_analysis
python nma_python.py
```

Requires: Python 3.x, numpy, scipy, matplotlib, pandas
