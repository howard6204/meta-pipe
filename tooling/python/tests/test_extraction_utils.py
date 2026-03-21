"""Tests for extraction_utils.py — field name and critical field parsing."""

from __future__ import annotations

from pathlib import Path

from extraction_utils import load_critical_fields, load_field_names_from_dict


class TestLoadFieldNamesFromDict:
    """Tests for load_field_names_from_dict()."""

    def test_extracts_backtick_fields(self, tmp_file):
        md = tmp_file(
            "dict.md",
            "## Fields\n| `study_id` | str |\n| `authors` | str |\n",
        )
        result = load_field_names_from_dict(md)
        assert result == ["study_id", "authors"]

    def test_deduplicates_fields(self, tmp_file):
        md = tmp_file(
            "dict.md",
            "`study_id` appears here and `study_id` again\n",
        )
        result = load_field_names_from_dict(md)
        assert result == ["study_id"]
        assert len(result) == 1

    def test_preserves_document_order(self, tmp_file):
        md = tmp_file(
            "dict.md",
            "`year` then `authors` then `study_id`\n",
        )
        result = load_field_names_from_dict(md)
        assert result == ["year", "authors", "study_id"]

    def test_ignores_non_identifier_backticks(self, tmp_file):
        md = tmp_file(
            "dict.md",
            "`study_id` and `123bad` and `True` and `good_field2`\n",
        )
        result = load_field_names_from_dict(md)
        # Regex requires [a-z_] start, so '123bad' and 'True' are excluded
        assert "study_id" in result
        assert "good_field2" in result
        assert "123bad" not in result
        assert "True" not in result  # starts with uppercase

    def test_empty_file_returns_empty(self, tmp_file):
        md = tmp_file("dict.md", "# Empty\nNo fields here.\n")
        assert load_field_names_from_dict(md) == []

    def test_only_lowercase_start(self, tmp_file):
        md = tmp_file("dict.md", "`_private` and `CamelCase` and `ok`\n")
        result = load_field_names_from_dict(md)
        assert "_private" in result
        assert "ok" in result
        assert "CamelCase" not in result


class TestLoadCriticalFields:
    """Tests for load_critical_fields()."""

    def test_extracts_numbered_list(self, sample_data_dict):
        result = load_critical_fields(sample_data_dict)
        assert result == ["study_id", "authors", "year", "effect_size"]

    def test_no_critical_section_returns_empty(self, tmp_file):
        md = tmp_file("dict.md", "# Data Dictionary\n\n## Fields\n`study_id`\n")
        assert load_critical_fields(md) == []

    def test_case_insensitive_heading(self, tmp_file):
        md = tmp_file(
            "dict.md",
            "### critical fields (must not be missing)\n\n1. study_id\n2. year\n",
        )
        result = load_critical_fields(md)
        assert result == ["study_id", "year"]

    def test_stops_at_next_section(self, tmp_file):
        md = tmp_file(
            "dict.md",
            "### Critical Fields\n\n1. study_id\n\n### Other Section\n\n1. not_this\n",
        )
        result = load_critical_fields(md)
        assert result == ["study_id"]
        assert "not_this" not in result
