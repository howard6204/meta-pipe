# meta-pipe Manuscript Plan

## Target

**Paper 1 — Software/Methodology**
*"meta-pipe: An LLM-agent pipeline for end-to-end automated systematic review and meta-analysis"*

**Primary target**: Systematic Reviews (IF 3.9) — active "Automation in SRs" thematic series
**Backup**: Research Synthesis Methods (~5.0), JMIR (6.0)

## Core Argument (Revised)

~~meta-pipe is the first end-to-end tool → look what it can do~~

**The quality bottleneck in SR/MA is not in individual steps, but in the fragmentation between steps. Pipeline integration is itself a methodological contribution. meta-pipe is the implementation proof of this thesis.**

## IMRaD Structure

### Introduction (~800 words, 4 paragraphs)

| Para | Content | Key refs |
|------|---------|----------|
| 1 | Burden: SR/MA is gold standard but 100+ hours, error-prone | Borah 2017 (median 67 weeks), Allen 2019 |
| 2 | Existing tools cover fragments: ASReview (screening), Covidence (screening+extraction), RobotReviewer (RoB) — but each solves only 1-3 stages | Van de Schoot 2021, Tsou 2020, Marshall 2017 |
| 3 | **The real gap**: (a) manual data transfer between steps introduces errors, (b) quality gates cannot be retroactively enforced across stages, (c) reproducibility stops at the statistical layer | **This is the methodological argument** |
| 4 | Aim: present meta-pipe as integrated pipeline; demonstrate with ici-breast-cancer case | — |

### Methods (~2000 words, 8 sections)

| Section | Content | Focus |
|---------|---------|-------|
| 2.1 | Pipeline architecture overview | **Why 10 stages, boundary definitions** |
| 2.2 | Technology stack | Claude + Python + R + Quarto (brief) |
| 2.3 | Quality gate design | **Gate logic, thresholds, rationale** |
| 2.4 | Human-in-the-loop decision points | **Which 5 points, why these, not others** |
| 2.5 | Search & bibliography | PubMed + Scopus, deduplication |
| 2.6 | Data extraction & RoB | Structured extraction, RoB 2 |
| 2.7 | Statistical analysis | REML + Hartung-Knapp, NMA support |
| 2.8 | Manuscript generation | Quarto + Typst, PRISMA compliance |

### Results (~1500 words, 6 sections)

| Section | Content | Key numbers |
|---------|---------|-------------|
| 3.1 | Implementation metrics | 24 Python scripts, 12 skill modules, 74 reference docs |
| 3.2 | Demonstration: search | 847 records, 312 after dedup |
| 3.3 | Study characteristics | 5 RCTs, N=2,402, 2019-2023 |
| 3.4 | Efficacy results | pCR RR 1.26 (1.16-1.37), p=0.0015 |
| 3.5 | Safety results | Grade 3-4 AE analysis |
| 3.6 | Process metrics | **14h vs 100+h, stage-by-stage time, quality scores** |

### Discussion (~1200 words, 7 paragraphs)

| Para | Content |
|------|---------|
| 4.1 | Principal findings: pipeline integration as methodological advance |
| 4.2 | **Pipeline thinking vs tool thinking** — genomics (nf-core), imaging (BIDS) have pipelines; evidence synthesis is late |
| 4.3 | **Standardization dividends** — cross-project comparison of time/quality metrics becomes possible |
| 4.4 | **Living SR feasibility** — only possible with end-to-end automation |
| 4.5 | Human-in-the-loop safeguards vs full automation |
| 4.6 | Limitations: single demo case, Claude dependency, English-only |
| 4.7 | Future work: validation study (5-10 Cochrane reproductions), multi-LLM support |

## Tables (4)

| # | Title | Source |
|---|-------|--------|
| Table 1 | Pipeline stages, inputs/outputs, quality gates | Architecture docs |
| Table 2 | Feature comparison: meta-pipe vs ASReview, Covidence, otto-SR, TrialMind | Literature |
| Table 3 | Included study characteristics (5 RCTs) | 05_data_extraction |
| Table 4 | Time investment by stage: AI-assisted vs manual estimate | Session logs |

## Figures (4)

| # | Title | Status |
|---|-------|--------|
| Fig 1 | Pipeline architecture diagram (10 stages with quality gates) | TODO: generate |
| Fig 2 | PRISMA flow diagram | Copy from projects/ici-breast-cancer/ |
| Fig 3 | Forest plot: pCR (primary outcome) | Copy from 06_analysis/ |
| Fig 4 | Time comparison: meta-pipe vs manual (bar chart) | TODO: generate |

## Execution Timeline (~14 hours)

| Phase | Hours | Tasks |
|-------|-------|-------|
| 1. Scaffold + outline | 1-2h | ✅ Done |
| 2. Introduction + Discussion rewrite | 2-3h | **Current** |
| 3. Methods sections | 3-4h | Fill 8 sections |
| 4. Results + tables | 2-3h | Extract from ici-breast-cancer |
| 5. Figures | 1-2h | Pipeline diagram, time chart |
| 6. References + polish | 1-2h | Complete .bib, PRISMA check |
| 7. Render + review | 1h | Quarto render, final QA |

## Journal Requirements (Systematic Reviews)

- **Word limit**: ~6000 words (main text)
- **Abstract**: Structured (Background, Methods, Results, Conclusions) ≤350 words
- **Format**: IMRaD
- **Open access**: Yes (BioMed Central)
- **Software papers**: Accepted under "Methodology" article type
- **PRISMA**: Required for any SR/MA demonstration
