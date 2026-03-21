# Publication Plan: meta-pipe IMRaD Manuscript

**Date**: 2026-03-21
**Target**: Software/methodology paper for *Systematic Reviews* or *Research Synthesis Methods*
**Output**: `manuscript/` directory with Quarto project

---

## Title (Working)

*"meta-pipe: An LLM-agent pipeline for end-to-end automated systematic review and meta-analysis"*

---

## IMRaD Structure

### Abstract (structured, ~350 words)

- **Background**: Manual SR/MA requires 100+ hours; existing tools (ASReview, Rayyan, Covidence, TrialMind) cover 1-3 of 10+ stages; none integrates statistical analysis or manuscript generation
- **Methods**: We developed meta-pipe, a 10-stage LLM-agent pipeline orchestrating topic intake through publication-ready manuscript. Architecture: Claude AI skills + Python automation (24 scripts) + R statistical engine (meta/metafor) + Quarto rendering. Quality gates enforce PRISMA compliance, dual-review kappa ≥0.60, GRADE assessment, and overclaim detection
- **Results**: Demonstration on ICI in TNBC (5 RCTs, N=2,402): pCR RR 1.26 (95% CI 1.16-1.37, p=0.0015, I²=0%, GRADE HIGH). Total time ~14 hours vs estimated 100+ hours manual. Publication readiness score 95-98%
- **Conclusions**: meta-pipe is the first end-to-end AI-assisted pipeline covering all SR/MA stages. Human-in-the-loop design with automated quality gates addresses concerns about standalone AI use in evidence synthesis

### 1. Introduction (~800 words)

| Paragraph | Content | Key References |
|-----------|---------|----------------|
| 1.1 | SR/MA as gold standard for clinical evidence; time/resource burden (100+ hours, 12-18 months) | Borah 2017, Tsafnat 2014 |
| 1.2 | Existing automation: ASReview (screening), Rayyan (screening), Covidence (screening+extraction), RobotReviewer (RoB), otto-SR (screening+extraction), TrialMind (screening+extraction) | van de Schoot 2021, Ouzzani 2016, Kellermeyer 2018, Marshall 2017, Blaizot 2022, Choi 2024 |
| 1.3 | Gap: No tool covers statistical analysis or manuscript generation; 2025 scoping review concluded "not yet ready for standalone use" | Gartlehner 2025 |
| 1.4 | Aim: Present meta-pipe, the first end-to-end pipeline from topic brainstorming (Stage 00) to submission-ready manuscript (Stage 10), with integrated quality gates |

### 2. Methods (~1,500 words)

| Section | Content |
|---------|---------|
| 2.1 Pipeline Architecture | 10-stage design (Table 1); modular skill-based orchestration; human-in-the-loop decision points |
| 2.2 Technology Stack | Claude AI (Anthropic) for LLM tasks; Python 3.12 + uv for automation; R 4.x + meta/metafor for statistics; Quarto + Typst for rendering; renv for reproducibility |
| 2.3 Search & Screening | PubMed + Scopus (minimum); LLM-assisted title/abstract screening with dual-review kappa validation (≥0.60); PRISMA flow generation |
| 2.4 Data Extraction & Quality | LLM-assisted PDF extraction with validation pipeline; RoB 2 / ROBINS-I assessment; confidence scoring and manual review flagging |
| 2.5 Statistical Analysis | REML + Hartung-Knapp for pairwise MA; Bayesian NMA (gemtc) + frequentist sensitivity (netmeta); heterogeneity diagnostics (I², prediction intervals); publication bias (Egger, trim-and-fill) |
| 2.6 Manuscript Generation | Quarto-based assembly with 5 IMRaD sections; automated citation management; figure/table integration; journal-specific formatting (Lancet, JAMA) |
| 2.7 Quality Assurance | Publication readiness score (0-100%, 8 components); overclaim detection (12 patterns); PRISMA compliance validation (27/27 items); GRADE assessment automation |
| 2.8 Demonstration Study | ICI in TNBC: PICO definition, search strategy, eligibility criteria, analysis plan |

### 3. Results (~1,200 words)

| Section | Content |
|---------|---------|
| 3.1 Pipeline Implementation | 12 skill modules, 24 Python scripts (~3,600 LOC), 74 methodology references; open-source availability |
| 3.2 Demonstration: ICI in TNBC | Search yield → screening → 5 RCTs included (KEYNOTE-522, IMpassion031, GeparNuevo, NeoTRIPaPDL1, CamRelief) |
| 3.3 Efficacy Outcomes | pCR: RR 1.26 (1.16-1.37), p=0.0015, I²=0%, GRADE HIGH; EFS: HR 0.66 (0.51-0.86), GRADE MODERATE; OS: HR 0.48 (k=2), GRADE LOW |
| 3.4 Safety Outcomes | Serious AE: RR 1.50 (1.13-1.98), NNH=10; Grade 3+ irAE: ~8.5x increase; Fatal AE: NNH=250 |
| 3.5 Time & Quality Metrics | 14 hours total; publication readiness 95-98%; PRISMA 27/27; 31 citations; 4,921-word manuscript |
| 3.6 Comparison with Existing Tools | Table 2: feature matrix (meta-pipe vs ASReview, Rayyan, Covidence, otto-SR, TrialMind) |

### 4. Discussion (~1,500 words)

| Paragraph | Content |
|-----------|---------|
| 4.1 | Principal findings: first end-to-end pipeline; 75-80% time savings; publication-quality output |
| 4.2 | Comparison with existing tools: coverage gap analysis; quality gate advantage over standalone AI |
| 4.3 | Human-in-the-loop design: 5 mandatory decision points (PICO, eligibility, analysis type, GRADE, interpretation); addresses Gartlehner 2025 concerns |
| 4.4 | Reproducibility: renv lock files, artifact hashing, version-controlled skill modules |
| 4.5 | Limitations: single demonstration study; Claude API dependency; R/Python skill requirement; English-language bias; cost (~$15-30 per project in API calls) |
| 4.6 | Future work: validation against published Cochrane reviews; living systematic review support; multi-language support; local LLM option |
| 4.7 | Conclusion: meta-pipe demonstrates feasibility of end-to-end AI-assisted evidence synthesis with human oversight |

---

## Tables

| Table | Content | Location |
|-------|---------|----------|
| Table 1 | Pipeline stages (10 rows: stage, module, key tasks, outputs, human decision points) | Methods 2.1 |
| Table 2 | Feature comparison matrix (meta-pipe vs 6 competitors across 10 capabilities) | Results 3.6 |
| Table 3 | Demonstration study characteristics (5 RCTs: trial, N, regimen, primary endpoint) | Results 3.2 |
| Table 4 | Time investment breakdown by stage (hours per stage, manual vs meta-pipe) | Results 3.5 |

## Figures

| Figure | Content | Source |
|--------|---------|--------|
| Figure 1 | Pipeline architecture diagram (10 stages with data flow arrows) | New (TikZ or Mermaid) |
| Figure 2 | PRISMA flow diagram for ICI-TNBC demonstration | `prisma_flow.py` output |
| Figure 3 | Forest plot: pCR primary outcome | `01_pCR_meta_analysis.R` output |
| Figure 4 | Publication readiness dashboard (radar chart of 8 QA components) | New (R/ggplot2) |

## Supplementary Materials

| Item | Content |
|------|---------|
| eTable 1 | Complete search strategies (PubMed, Scopus) |
| eTable 2 | Risk of bias assessment (RoB 2) for all 5 RCTs |
| eTable 3 | GRADE evidence profile |
| eFigure 1 | Funnel plot + Egger's test |
| eFigure 2 | Leave-one-out sensitivity analysis |
| eAppendix 1 | Complete list of Python scripts with descriptions |
| eAppendix 2 | SKILL.md orchestration guide excerpt |

---

## File Structure: `manuscript/`

```
manuscript/
├── _quarto.yml              # Quarto project config
├── index.qmd                # Master document (includes all sections)
├── 00_abstract.qmd          # Structured abstract
├── 01_introduction.qmd      # Background, gap, aim
├── 02_methods.qmd           # Pipeline architecture, tech stack, demo study
├── 03_results.qmd           # Implementation, demo results, comparison
├── 04_discussion.qmd        # Interpretation, limitations, future
├── tables.qmd               # Table legends and references
├── figures_legends.qmd      # Figure legends
├── references.bib           # BibTeX citations
├── style.csl                # Citation style (Vancouver/AMA)
├── figures/                  # Figure files (PNG 300 DPI)
│   ├── fig1_pipeline.png
│   ├── fig2_prisma.png
│   ├── fig3_forest.png
│   └── fig4_readiness.png
├── tables/                   # Table data (CSV)
│   ├── table1_stages.csv
│   ├── table2_comparison.csv
│   ├── table3_studies.csv
│   └── table4_time.csv
├── supplementary/            # Supplementary materials
│   ├── etable1_search.qmd
│   ├── etable2_rob.qmd
│   ├── etable3_grade.qmd
│   ├── efigure1_funnel.png
│   ├── efigure2_sensitivity.png
│   └── eappendix.qmd
└── output/                   # Rendered output
    ├── .gitkeep
    └── (generated HTML/PDF/DOCX)
```

---

## Execution Steps

| # | Task | Est. Time |
|---|------|-----------|
| 1 | Scaffold `manuscript/` directory with Quarto config and section stubs | 30 min |
| 2 | Write Introduction (lit review, gap analysis) | 2 hrs |
| 3 | Write Methods (architecture description, tech stack, demo protocol) | 3 hrs |
| 4 | Create Figure 1 (pipeline architecture diagram) | 1 hr |
| 5 | Copy/adapt PRISMA flow and forest plot from ici-breast-cancer | 30 min |
| 6 | Write Results (implementation stats, demo outcomes, comparison table) | 2 hrs |
| 7 | Write Discussion (interpretation, limitations, future) | 2 hrs |
| 8 | Write Abstract | 30 min |
| 9 | Compile references.bib | 1 hr |
| 10 | Create supplementary materials | 1 hr |
| 11 | Render and quality check | 1 hr |
| **Total** | | **~14 hrs** |

---

## Target Journal Requirements

### Systematic Reviews (BMC, IF 3.9)

- **Word limit**: 10,000 (excl. abstract, refs, tables)
- **Abstract**: Structured (Background, Methods, Results, Conclusions), 350 words
- **Figures**: No limit, 300 DPI minimum
- **Format**: DOCX or PDF submission; LaTeX accepted
- **Open access**: Yes (APC ~$2,490)
- **Review time**: ~4-8 weeks
- **Special**: Active "Automation in Systematic Reviews" thematic series

### Research Synthesis Methods (Wiley, IF ~5.0)

- **Word limit**: 8,000
- **Abstract**: Unstructured, 250 words
- **Figures**: 6 max in main text
- **Format**: DOCX preferred
- **Open access**: Optional (APC ~$3,800)
- **Review time**: ~6-12 weeks
