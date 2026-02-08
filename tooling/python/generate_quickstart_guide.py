#!/usr/bin/env python3
"""Generate project-specific quickstart guides from templates.

This script reads template files and replaces {{PLACEHOLDERS}} with
project-specific data from pico.yaml, CSV files, and other sources.

Usage:
    uv run generate_quickstart_guide.py --project my-project --stage screening
    uv run generate_quickstart_guide.py --project my-project --stage fulltext
    uv run generate_quickstart_guide.py --project my-project --stage analysis
    uv run generate_quickstart_guide.py --project my-project --stage manuscript
"""

from __future__ import annotations

import argparse
import re
from datetime import datetime
from pathlib import Path


def load_template(template_path: Path) -> str:
    """Load template file content."""
    if not template_path.exists():
        raise FileNotFoundError(f"Template not found: {template_path}")
    return template_path.read_text()


def replace_placeholders(template: str, replacements: dict[str, str]) -> str:
    """Replace {{PLACEHOLDERS}} in template with actual values."""
    result = template
    for key, value in replacements.items():
        placeholder = f"{{{{{key}}}}}"
        result = result.replace(placeholder, str(value))
    return result


def get_screening_replacements(project_name: str, project_root: Path) -> dict[str, str]:
    """Get replacement values for screening quickstart guide."""
    # TODO: Parse actual data from files
    # For now, return placeholder values
    return {
        "PROJECT_NAME": project_name,
        "DATE": datetime.now().strftime("%Y-%m-%d"),
        "RECORD_COUNT": "{{RECORD_COUNT}}",  # Count from dedupe.bib
        "STUDY_DESIGN": "{{STUDY_DESIGN}}",  # From pico.yaml
        "POPULATION": "{{POPULATION}}",  # From pico.yaml
        "INTERVENTION": "{{INTERVENTION}}",  # From pico.yaml
        "COMPARATOR": "{{COMPARATOR}}",  # From pico.yaml
        "OUTCOMES": "{{OUTCOMES}}",  # From pico.yaml
        "MIN_SAMPLE_SIZE": "{{MIN_SAMPLE_SIZE}}",  # From pico.yaml
        "EXPECTED_INCLUDE_COUNT": "{{EXPECTED_INCLUDE_COUNT}}",  # Estimate
        "EXPECTED_INCLUDE_PERCENT": "{{EXPECTED_INCLUDE_PERCENT}}",  # Estimate
        "EXPECTED_MAYBE_COUNT": "{{EXPECTED_MAYBE_COUNT}}",  # Estimate
        "EXPECTED_MAYBE_PERCENT": "{{EXPECTED_MAYBE_PERCENT}}",  # Estimate
        "EXPECTED_EXCLUDE_COUNT": "{{EXPECTED_EXCLUDE_COUNT}}",  # Estimate
        "EXPECTED_EXCLUDE_PERCENT": "{{EXPECTED_EXCLUDE_PERCENT}}",  # Estimate
        "KEY_STUDY_1": "{{KEY_STUDY_1}}",  # From user input
        "KEY_STUDY_2": "{{KEY_STUDY_2}}",  # From user input
        "KEY_STUDY_3": "{{KEY_STUDY_3}}",  # From user input
        "PROJECT_TIMELINE": "{{PROJECT_TIMELINE}}",  # Calculate from start date
    }


def get_fulltext_replacements(project_name: str, project_root: Path) -> dict[str, str]:
    """Get replacement values for fulltext quickstart guide."""
    return {
        "PROJECT_NAME": project_name,
        "DATE": datetime.now().strftime("%Y-%m-%d"),
        "FULLTEXT_COUNT": "{{FULLTEXT_COUNT}}",  # From decisions.csv
        "INCLUDE_COUNT": "{{INCLUDE_COUNT}}",  # From decisions.csv
        "MAYBE_COUNT": "{{MAYBE_COUNT}}",  # From decisions.csv
        "EXPECTED_FINAL_INCLUDE": "{{EXPECTED_FINAL_INCLUDE}}",  # Estimate
        "YOUR_EMAIL": "{{YOUR_EMAIL}}",  # From .env or config
        "EXAMPLE_PDF_1": "{{EXAMPLE_PDF_1}}",  # From key studies
        "EXAMPLE_PDF_2": "{{EXAMPLE_PDF_2}}",  # From key studies
        "KEY_STUDY_1": "{{KEY_STUDY_1}}",
        "KEY_STUDY_2": "{{KEY_STUDY_2}}",
        "PROJECT_TIMELINE": "{{PROJECT_TIMELINE}}",
    }


def get_analysis_replacements(project_name: str, project_root: Path) -> dict[str, str]:
    """Get replacement values for analysis progress guide."""
    return {
        "PROJECT_NAME": project_name,
        "DATE": datetime.now().strftime("%Y-%m-%d"),
        "PRIMARY_OUTCOME": "{{PRIMARY_OUTCOME}}",  # From pico.yaml
        "SECONDARY_OUTCOME": "{{SECONDARY_OUTCOME}}",  # From pico.yaml
        "STATUS_1": "⏳ Pending",
        "STATUS_2": "⏳ Pending",
        "STATUS_3": "⏳ Pending",
        # Add more as needed
    }


def get_manuscript_replacements(
    project_name: str, project_root: Path
) -> dict[str, str]:
    """Get replacement values for manuscript completion guide."""
    return {
        "PROJECT_NAME": project_name,
        "DATE": datetime.now().strftime("%Y-%m-%d"),
        "CURRENT_SESSION": "Session started",
        "TARGET_JOURNAL": "{{TARGET_JOURNAL}}",  # From user input
        "WC_TOTAL": "0",  # Count from manuscript files
        "OVERALL_PERCENT": "0",  # Calculate
        "ETA_HOURS": "{{ETA_HOURS}}",  # Estimate
    }


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate project-specific quickstart guides from templates"
    )
    parser.add_argument("--project", required=True, help="Project name")
    parser.add_argument(
        "--stage",
        required=True,
        choices=["screening", "fulltext", "analysis", "manuscript"],
        help="Pipeline stage",
    )
    parser.add_argument(
        "--out", help="Output file path (default: auto-generated in project directory)"
    )
    args = parser.parse_args()

    # Determine paths
    script_dir = Path(__file__).resolve().parent
    repo_root = script_dir.parent.parent
    project_root = repo_root / "projects" / args.project

    if not project_root.exists():
        print(f"❌ Project not found: {project_root}")
        print(f"   Create it first with: uv run init_project.py --name {args.project}")
        return

    # Map stage to template and output
    stage_config = {
        "screening": {
            "template": repo_root
            / "ma-screening-quality/references/screening-quickstart-template.md",
            "output": project_root / "03_screening/SCREENING_QUICKSTART.md",
            "replacements_func": get_screening_replacements,
        },
        "fulltext": {
            "template": repo_root
            / "ma-fulltext-management/references/fulltext-quickstart-template.md",
            "output": project_root / "04_fulltext/FULLTEXT_QUICKSTART.md",
            "replacements_func": get_fulltext_replacements,
        },
        "analysis": {
            "template": repo_root
            / "ma-meta-analysis/references/analysis-progress-template.md",
            "output": project_root / "06_analysis/ANALYSIS_PROGRESS.md",
            "replacements_func": get_analysis_replacements,
        },
        "manuscript": {
            "template": repo_root
            / "ma-manuscript-quarto/references/manuscript-completion-template.md",
            "output": project_root / "07_manuscript/COMPLETION_SUMMARY.md",
            "replacements_func": get_manuscript_replacements,
        },
    }

    config = stage_config[args.stage]
    template_path = config["template"]
    output_path = Path(args.out) if args.out else config["output"]

    # Load template
    print(f"📖 Loading template: {template_path.name}")
    template = load_template(template_path)

    # Get replacements
    print(f"🔧 Generating replacements for {args.project}")
    replacements = config["replacements_func"](args.project, project_root)

    # Replace placeholders
    print(f"✏️  Replacing {{PLACEHOLDERS}}")
    result = replace_placeholders(template, replacements)

    # Write output
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(result)

    print(f"✅ Generated: {output_path}")
    print(f"\nNext steps:")
    print(f"1. Review and customize {output_path.name}")
    print(f"2. Replace remaining {{PLACEHOLDERS}} with project-specific values")
    print(f"3. Use as guide for {args.stage} stage")


if __name__ == "__main__":
    main()
