"""Tests for validate_skills.py — SKILL.md structure validation."""

from __future__ import annotations

import pytest

from validate_skills import (
    KNOWN_MODULES,
    REQUIRED_FRONTMATTER,
    REQUIRED_SECTIONS,
    build_report,
    extract_sections,
    parse_frontmatter,
    validate_frontmatter,
    validate_pipeline_context,
    validate_sections,
)


class TestParseFrontmatter:
    """Tests for parse_frontmatter()."""

    def test_valid_frontmatter(self):
        text = '---\nname: ma-test\ndescription: A test\nstage: "01"\n---\n# Body'
        fields, end_idx = parse_frontmatter(text)
        assert fields["name"] == "ma-test"
        assert fields["description"] == "A test"
        assert fields["stage"] == '"01"'
        assert end_idx == 4

    def test_no_frontmatter(self):
        text = "# Just a heading\nSome text."
        fields, end_idx = parse_frontmatter(text)
        assert fields == {}
        assert end_idx == 0

    def test_empty_text(self):
        fields, end_idx = parse_frontmatter("")
        assert fields == {}
        assert end_idx == 0

    def test_frontmatter_with_colons_in_value(self):
        text = '---\nname: ma-test\ndescription: A test: with colons\n---\n'
        fields, _ = parse_frontmatter(text)
        assert fields["description"] == "A test: with colons"

    def test_frontmatter_missing_closing(self):
        text = "---\nname: test\nno closing delimiter"
        fields, end_idx = parse_frontmatter(text)
        # No closing --- means end_idx stays 0
        assert end_idx == 0


class TestExtractSections:
    """Tests for extract_sections()."""

    def test_extracts_h2_sections(self):
        text = "# Title\n## Overview\ntext\n## Workflow\ntext\n## Notes\n"
        assert extract_sections(text) == ["Overview", "Workflow", "Notes"]

    def test_ignores_h1_and_h3(self):
        text = "# Title\n## Overview\n### Subsection\n## Notes\n"
        assert extract_sections(text) == ["Overview", "Notes"]

    def test_no_sections(self):
        assert extract_sections("Just text\nMore text\n") == []

    def test_section_with_special_chars(self):
        text = "## Common Issues\n## Pipeline Context\n"
        assert extract_sections(text) == ["Common Issues", "Pipeline Context"]


class TestValidateFrontmatter:
    """Tests for validate_frontmatter()."""

    def test_all_fields_present_and_valid(self):
        fields = {
            "name": "ma-test",
            "description": "Test module",
            "stage": '"01"',
            "depends_on": "ma-topic-intake",
            "next": "ma-search-bibliography",
        }
        errors = validate_frontmatter(fields, "ma-test")
        assert errors == []

    def test_missing_required_field(self):
        fields = {"name": "ma-test", "description": "Test"}
        errors = validate_frontmatter(fields, "ma-test")
        missing = [e for e in errors if "missing frontmatter field" in e]
        assert len(missing) == 3  # stage, depends_on, next

    def test_name_mismatch(self):
        fields = {
            "name": "wrong-name",
            "description": "X",
            "stage": '"01"',
            "depends_on": "",
            "next": "",
        }
        errors = validate_frontmatter(fields, "ma-test")
        assert any("expected 'ma-test'" in e for e in errors)

    def test_invalid_stage_format(self):
        fields = {
            "name": "ma-test",
            "description": "X",
            "stage": "abc",
            "depends_on": "",
            "next": "",
        }
        errors = validate_frontmatter(fields, "ma-test")
        assert any("stage" in e and "two-digit" in e for e in errors)

    def test_orchestrator_stage_valid(self):
        fields = {
            "name": "ma-end-to-end",
            "description": "X",
            "stage": "orchestrator",
            "depends_on": "",
            "next": "",
        }
        errors = validate_frontmatter(fields, "ma-end-to-end")
        assert not any("stage" in e for e in errors)

    def test_unknown_module_reference(self):
        fields = {
            "name": "ma-test",
            "description": "X",
            "stage": '"01"',
            "depends_on": "ma-nonexistent",
            "next": "ma-also-fake",
        }
        errors = validate_frontmatter(fields, "ma-test")
        assert any("unknown module: ma-nonexistent" in e for e in errors)
        assert any("unknown module: ma-also-fake" in e for e in errors)


class TestValidateSections:
    """Tests for validate_sections()."""

    def test_all_required_in_order(self):
        errors = validate_sections(list(REQUIRED_SECTIONS), "ma-test")
        assert errors == []

    def test_missing_section(self):
        sections = [s for s in REQUIRED_SECTIONS if s != "Workflow"]
        errors = validate_sections(sections, "ma-test")
        assert any("missing section: ## Workflow" in e for e in errors)

    def test_wrong_order(self):
        sections = list(REQUIRED_SECTIONS)
        sections[0], sections[1] = sections[1], sections[0]  # swap first two
        errors = validate_sections(sections, "ma-test")
        assert any("order mismatch" in e for e in errors)

    def test_extra_sections_allowed(self):
        sections = list(REQUIRED_SECTIONS)
        sections.insert(3, "Custom Section")
        errors = validate_sections(sections, "ma-test")
        assert errors == []

    def test_empty_sections(self):
        errors = validate_sections([], "ma-test")
        assert len(errors) == len(REQUIRED_SECTIONS)


class TestValidatePipelineContext:
    """Tests for validate_pipeline_context()."""

    def test_matching_stage(self):
        text = "## Pipeline Context\n\n**Stage**: 1\n"
        fields = {"stage": '"01"'}
        errors = validate_pipeline_context(text, fields, "ma-test")
        assert errors == []

    def test_mismatched_stage(self):
        text = "## Pipeline Context\n\n**Stage**: 3\n"
        fields = {"stage": '"01"'}
        errors = validate_pipeline_context(text, fields, "ma-test")
        assert any("Pipeline Context stage (03) != frontmatter stage (01)" in e for e in errors)

    def test_no_stage_in_context(self):
        text = "## Pipeline Context\n\nNo stage here.\n"
        fields = {"stage": '"01"'}
        errors = validate_pipeline_context(text, fields, "ma-test")
        assert errors == []  # gracefully skip


class TestBuildReport:
    """Tests for build_report()."""

    def test_all_passing(self):
        results = {"ma-test": [], "ma-other": []}
        report = build_report(results, 2)
        assert "PASS" in report
        assert "Passed**: 2" in report
        assert "Total errors**: 0" in report

    def test_with_failures(self):
        results = {"ma-test": ["error 1", "error 2"], "ma-other": []}
        report = build_report(results, 2)
        assert "FAIL" in report
        assert "Failed**: 1" in report
        assert "error 1" in report
        assert "error 2" in report

    def test_empty_results(self):
        report = build_report({}, 0)
        assert "Passed**: 0" in report
