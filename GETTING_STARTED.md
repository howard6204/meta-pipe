# Getting Started

Quick guide to set up and run the meta-analysis pipeline.

## Prerequisites

- `uv` on PATH
- R (≥ 4.2) + `renv`
- Quarto
- API keys in `.env` ([setup guide](ma-search-bibliography/references/api-setup.md))

## 0. Configure API Keys

```bash
cp .env.example .env  # Edit with your keys
```

Minimum: `PUBMED_API_KEY` — [Get from NCBI](https://www.ncbi.nlm.nih.gov/account/)

## 1. Initialize Project

```bash
cd /Users/htlin/meta-pipe
uv run tooling/python/init_project.py --name <project-name>
```

This creates `projects/<project-name>/` with all stage folders and a `TOPIC.txt` file.

## 2. Edit TOPIC.txt

Write your research question in `projects/<project-name>/TOPIC.txt`.

Or say **"brainstorm"** to get interactive help refining your topic.

## 3. Run the Pipeline

All stage-by-stage commands are in **[AGENTS.md](AGENTS.md)** — the single source of truth for the pipeline.

| Stage | Section in AGENTS.md | Key Output         |
| ----- | -------------------- | ------------------ |
| 01    | Protocol & PROSPERO  | pico.yaml          |
| 02    | Search               | dedupe.bib         |
| 03    | Screening            | decisions.csv      |
| 04    | Fulltext             | manifest.csv       |
| 05    | Extraction           | extraction.csv     |
| 06    | Analysis (R)         | figures/, tables/  |
| 07    | Manuscript           | manuscript.pdf     |
| 08    | GRADE                | grade_summary.md   |
| 09    | QA                   | final_qa_report.md |

## 4. Example Project

See `projects/ici-breast-cancer/` for a complete (99%) meta-analysis you can use as a template.

## Notes

- Always use `uv run` for Python scripts, never `python3` directly
- Use `uv add <package>` for dependencies
- Keep all `round-XX` data (never overwrite)
- Use `rip` not `rm` for deletions
- If PRISMA shows NA, check that `db_counts.csv` and `decisions.csv` exist
