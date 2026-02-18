---
name: ma-fulltext-management
description: Collect and manage full-text PDFs for included studies, track provenance, and prepare documents for extraction. Use when moving from screening to data extraction.
---

# Ma Fulltext Management

## Overview

Gather full texts, validate completeness, and prepare a clean manifest.

## Inputs

- `03_screening/round-01/included.bib`

## Outputs

- `04_fulltext/manifest.csv`
- `04_fulltext/unpaywall_results.csv` (optional OA lookup)
- `04_fulltext/README.md`
- `04_fulltext/` PDF files
- `04_fulltext/previews/` (optional PDF image previews)

## Workflow (Web-First Hybrid — Default)

⚠️ **Default approach**: Web-based extraction first, PDF retrieval only for gaps.

### Phase 1: Web-Based Data Gathering (Default — No PDFs Needed)

1. Create `04_fulltext/` and build `manifest.csv` with `record_id`, DOI, PMID, title, and access notes.
2. **Automatically run web extraction** for all included studies using Claude Code's `WebSearch` and `WebFetch` tools:
   - Query PubMed structured abstracts (`https://pubmed.ncbi.nlm.nih.gov/<pmid>/`)
   - Query ClinicalTrials.gov registries (`https://clinicaltrials.gov/study/<nct_id>`)
   - Search Europe PMC, journal supplementary materials
3. Record confidence scores per field (see `references/web-extraction.md` for scoring).
4. Flag studies with confidence < 0.7 for primary outcome fields → these need PDFs.

### Phase 2: Targeted PDF Retrieval (Only for Low-Confidence Studies)

5. For flagged studies only (~20-30%), query Unpaywall for OA links using `scripts/unpaywall_fetch.py` via `uv run`.
6. Download available PDFs with `scripts/download_oa_pdfs.py`.
7. Optionally render PDF previews with `scripts/render_pdf_previews.py` for visual QA.
8. Request user to manually deposit any remaining PDFs that cannot be auto-retrieved.
9. Run OCR only when needed and preserve original files.

### Why Web-First?

- **Speed**: 50-70% faster than PDF-only (2-3h vs 8-12h)
- **No institutional access required** for Phase 1
- **90-95% completeness** with hybrid approach
- PDFs are only needed for ~20-30% of studies

## Resources

- `references/manifest-template.csv` provides a manifest header.
- `scripts/unpaywall_fetch.py` queries Unpaywall for open-access links.
- `scripts/analyze_unpaywall.py` analyzes Unpaywall results and generates summary statistics.
- `scripts/download_oa_pdfs.py` downloads open-access PDFs automatically from Unpaywall URLs.
- `scripts/render_pdf_previews.py` renders PDF pages to PNG previews.
  Note: Unpaywall requires `UNPAYWALL_EMAIL` in `.env`.
  Note: PDF previews require `pdftoppm` or `mutool` installed.

## Validation

- Ensure every included record has a matching full-text file or a documented reason for absence.
- Ensure `record_id` continuity with screening decisions.

## Pipeline Navigation

| Step | Skill                   | Stage                       |
| ---- | ----------------------- | --------------------------- |
| Prev | `/ma-screening-quality` | 03 Screening & Quality      |
| Next | `/ma-data-extraction`   | 05 Data Extraction          |
| All  | `/ma-end-to-end`        | Full pipeline orchestration |
