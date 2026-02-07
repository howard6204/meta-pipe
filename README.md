# Meta-Analysis Pipeline

AI-assisted, end-to-end meta-analysis with reproducible tooling.

## Quick Start

```bash
# 1. Setup (one-time)
cp .env.example .env        # Add your API keys
cd tooling/python && uv init

# 2. Edit your research question
# Open TOPIC.txt and paste your topic

# 3. Launch Claude Code and say:
```

> **"See TOPIC.txt and start"**

That's it. Claude will handle the rest.

**Don't have a topic yet?** Say:

> **"Help me brainstorm a topic"**

Claude will guide you through an interactive session to develop your research question.

---

## What Claude Does

1. Reads your topic from `TOPIC.txt`
2. Asks clarifying questions (databases, outcomes, dates)
3. Runs the 9-stage pipeline automatically
4. Generates manuscript-ready outputs

## Pipeline Overview

| Stage         | Output                    |
| ------------- | ------------------------- |
| 01_protocol   | pico.yaml, eligibility.md |
| 02_search     | dedupe.bib                |
| 03_screening  | decisions.csv             |
| 04_fulltext   | manifest.csv              |
| 05_extraction | extraction.csv            |
| 06_analysis   | figures/, tables/         |
| 07_manuscript | manuscript.pdf            |
| 08_reviews    | grade_summary.md          |
| 09_qa         | final_qa_report.md        |

## Utility Scripts

### Project Consolidation

After completing a project (99%+), organize all outputs:

```bash
uv run tooling/python/consolidate_project_outputs.py --project-name your-project
```

Creates `projects/your-project/` with:
- 10 organized directories (00_overview → 09_scripts)
- INDEX.md with complete file listings
- README.md with navigation guide

### Root Directory Cleanup

After consolidation, remove duplicate files:

```bash
./tooling/scripts/cleanup_root_markdown.sh
```

Keeps only essential files in root directory. See [tooling/scripts/README.md](tooling/scripts/README.md).

---

## Documentation

| Doc                                      | Purpose                      |
| ---------------------------------------- | ---------------------------- |
| [GETTING_STARTED.md](GETTING_STARTED.md) | Manual step-by-step guide    |
| [docs/API_SETUP.md](docs/API_SETUP.md)   | Database API keys            |
| [CLAUDE.md](CLAUDE.md)                   | Agent behavior (auto-loaded) |
| [tooling/scripts/](tooling/scripts/)     | Utility scripts              |

## Requirements

- `uv` (Python)
- R ≥ 4.2 + `renv`
- Quarto
- API keys in `.env`
