"""Shared fixtures for meta-pipe unit tests."""

from __future__ import annotations

import csv
import io
from pathlib import Path
from typing import Any

import pytest


@pytest.fixture
def tmp_file(tmp_path: Path):
    """Helper to create a temp file with given content."""

    def _create(name: str, content: str) -> Path:
        p = tmp_path / name
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(content, encoding="utf-8")
        return p

    return _create


@pytest.fixture
def sample_data_dict(tmp_file):
    """Create a sample data dictionary markdown file."""
    content = """\
# Data Dictionary

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `study_id` | str | Unique study identifier |
| `authors` | str | Author list |
| `year` | int | Publication year |
| `n_randomized_total` | int | Total randomized |
| `effect_size` | float | Effect estimate |

### Critical Fields (Must Not Be Missing)

1. study_id
2. authors
3. year
4. effect_size
"""
    return tmp_file("data-dictionary.md", content)


@pytest.fixture
def sample_extraction_rows() -> list[dict[str, str]]:
    """Sample extraction CSV rows for validation tests."""
    return [
        {
            "study_id": "Smith2020",
            "authors": "Smith J et al",
            "year": "2020",
            "n_randomized_total": "200",
            "n_intervention": "100",
            "n_control": "100",
            "effect_size": "0.85",
            "effect_95ci_lower": "0.70",
            "effect_95ci_upper": "1.02",
            "response_pct": "45.5",
        },
        {
            "study_id": "Jones2021",
            "authors": "Jones A et al",
            "year": "2021",
            "n_randomized_total": "300",
            "n_intervention": "150",
            "n_control": "150",
            "effect_size": "1.10",
            "effect_95ci_lower": "0.90",
            "effect_95ci_upper": "1.35",
            "response_pct": "52.0",
        },
    ]


@pytest.fixture
def sample_headers() -> list[str]:
    """Headers matching sample_extraction_rows."""
    return [
        "study_id",
        "authors",
        "year",
        "n_randomized_total",
        "n_intervention",
        "n_control",
        "effect_size",
        "effect_95ci_lower",
        "effect_95ci_upper",
        "response_pct",
    ]
