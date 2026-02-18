---
name: ma-search-bibliography
description: Conduct literature searches for meta-analysis using Python with uv, query PubMed and other databases, deduplicate results, and store round-based bibliographies with notes. Use when building or updating the evidence corpus.
---

# Ma Search Bibliography

## Overview

Run reproducible database searches, capture the search strategy, and produce versioned `.bib` files.

## Inputs

- `01_protocol/search-plan.md`
- `01_protocol/pico.yaml`

## Outputs

- `02_search/round-01/queries.txt`
- `02_search/round-01/results.bib`
- `02_search/round-01/dedupe.bib`
- `02_search/round-01/log.md`

## Workflow

1. Translate PICO terms into database-specific queries and save them in `queries.txt`.
2. Initialize Python tooling with uv in `tooling/python/` using `uv init` and `uv add` dependencies.
3. Run search scripts with `uv run` from `tooling/python/` (avoid direct `python3` calls).
4. Use `uv tool` for any one-off CLI utilities (do not install them globally).
5. Query PubMed first, then extend to other databases (Scopus, Embase, Cochrane) defined in the protocol.
6. Export results to `.bib` and record the run date, database, and query hash in `log.md`.
7. Deduplicate by DOI, PMID, and title, then save `dedupe.bib`.
8. If running updates, increment the round folder name and record deltas.
9. **Generate PRISMA flowchart** after search completion using `generate_prisma_flowchart.R` (see below).

## PubMed Implementation Notes

- Use `scripts/pubmed_fetch.py` for the default PubMed pipeline with `uv run`.
- Set an email and API key, respect rate limits, and use history for batch retrieval.
- See `references/pubmed-eutils.md` for a compact tutorial and API notes.
- Read API keys from `.env` in the project root.

## Resources

### Python Scripts (Search & Deduplication)
- `scripts/pubmed_fetch.py` fetches PubMed records and writes BibTeX.
- `scripts/dedupe_bib.py` removes duplicate records based on DOI, PMID, or title.
- `scripts/build_queries.py` builds multi-DB queries from `pico.yaml`.
- `scripts/mesh_expand.py` expands terms via the MeSH RDF lookup service.
- `scripts/expand_terms.py` expands PICO terms using MeSH and optional Emtree synonyms.
- `scripts/run_multi_db_search.py` runs multi-DB search, merge, and counts.
- `scripts/multi_db_dedupe.py` merges and deduplicates multiple BibTeX files.
- `scripts/db_counts.py` summarizes per-database counts for PRISMA.
- `scripts/search_report.py` generates a per-database query + count report.
- `scripts/search_audit.py` generates a JSON audit with query hashes and parameters.
- `scripts/scopus_fetch.py` fetches Scopus Search API results.
- `scripts/embase_fetch.py` fetches Embase Search API results.
- `scripts/cochrane_fetch.py` fetches Cochrane ReviewDB API results.
- `scripts/bib_subset_by_ids.py` extracts a BibTeX subset from CSV record IDs.
- `scripts/zotero_fetch.py` fetches records from a Zotero collection.
- `scripts/zotero_sync.py` syncs a `.bib` file back to a Zotero collection.
- `scripts/env_utils.py` loads `.env` credentials.

### R Scripts (PRISMA Flowchart)
- `scripts/generate_prisma_flowchart.R` generates PRISMA 2020 compliant flow diagrams in PNG/PDF/SVG/HTML formats.

### Reference Documentation
- `references/pubmed-eutils.md` summarizes the E-utilities workflow.
- `references/database-auth.md` summarizes authentication per database.
- `references/emtree-synonyms-template.csv` provides a template for Emtree synonyms.
- `references/prisma-flowchart-guide.md` provides complete PRISMA 2020 flowchart generation guide.

## Notes

- Keep all rounds. Do not overwrite prior `.bib` files.
- Add a short note in each `.bib` entry for the round (example: `note = {round-01}` ).

## PRISMA Flowchart Generation

**Purpose**: Generate publication-quality PRISMA 2020 flow diagrams automatically.

**When**: After completing database searches and deduplication.

**Command**:
```bash
cd ma-search-bibliography/scripts

Rscript generate_prisma_flowchart.R \
  DB_RECORDS \
  SCREENED \
  EXCLUDED \
  FULLTEXT \
  INCLUDED \
  [PARTICIPANTS] \
  [OUTPUT_DIR]
```

**Example** (after search completion, before screening):
```bash
# Count database records
DB_RECORDS=$(wc -l < ../../projects/<project-name>/02_search/round-01/dedupe.bib | xargs)

# Generate initial flowchart (screening numbers TBD)
Rscript generate_prisma_flowchart.R $DB_RECORDS 0 0 0 0 NA ../../projects/<project-name>/figures/
```

**Outputs**:
- `prisma_flowchart.png` (300 DPI, for manuscript)
- `prisma_flowchart.pdf` (vector, for publication)
- `prisma_flowchart.svg` (scalable, for presentations)
- `prisma_flowchart_interactive.html` (interactive, for supplementary materials)

**Time**: 30 seconds to 2 minutes

**See**: `references/prisma-flowchart-guide.md` for complete documentation

## Validation

- Confirm query coverage matches the protocol scope.
- Verify dedupe retains the best metadata per record.
- **Generate PRISMA flowchart** to visualize search results and verify counts.

## Pipeline Navigation

| Step | Skill                   | Stage                       |
| ---- | ----------------------- | --------------------------- |
| Prev | `/ma-topic-intake`      | 01 Protocol & PICO          |
| Next | `/ma-screening-quality` | 03 Screening & Quality      |
| All  | `/ma-end-to-end`        | Full pipeline orchestration |
