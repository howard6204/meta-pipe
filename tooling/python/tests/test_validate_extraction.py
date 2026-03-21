"""Tests for validate_extraction.py — CSV validation engine."""

from __future__ import annotations

import pytest

from validate_extraction import _find_column, _is_missing, _try_float, validate


class TestIsMissing:
    """Tests for _is_missing()."""

    @pytest.mark.parametrize("value", ["", "  ", "NR", "NA", "N/A", "MISSING", "nr", "na", "n/a", "missing"])
    def test_missing_values(self, value: str):
        assert _is_missing(value) is True

    @pytest.mark.parametrize("value", ["0", "0.0", "text", "1", "Smith2020"])
    def test_present_values(self, value: str):
        assert _is_missing(value) is False

    def test_whitespace_around_missing(self):
        assert _is_missing("  NR  ") is True
        assert _is_missing(" NA ") is True


class TestTryFloat:
    """Tests for _try_float()."""

    def test_valid_integer(self):
        assert _try_float("42") == 42.0

    def test_valid_float(self):
        assert _try_float("3.14") == 3.14

    def test_negative(self):
        assert _try_float("-1.5") == -1.5

    def test_missing_returns_none(self):
        assert _try_float("NR") is None
        assert _try_float("") is None

    def test_text_returns_none(self):
        assert _try_float("not a number") is None

    def test_whitespace_stripped(self):
        assert _try_float("  42  ") == 42.0


class TestFindColumn:
    """Tests for _find_column()."""

    def test_exact_match(self):
        assert _find_column(["study_id", "year"], "study_id") == "study_id"

    def test_case_insensitive(self):
        assert _find_column(["Study_ID", "year"], "study_id") == "Study_ID"

    def test_not_found(self):
        assert _find_column(["study_id", "year"], "authors") is None

    def test_empty_headers(self):
        assert _find_column([], "study_id") is None


class TestValidate:
    """Tests for validate() — the main validation engine."""

    def test_clean_data_no_issues(self, sample_extraction_rows, sample_headers):
        issues = validate(sample_extraction_rows, sample_headers, ["study_id"])
        assert issues == []

    def test_missing_study_id(self, sample_headers):
        rows = [{"study_id": "", "authors": "X", "year": "2020"}]
        issues = validate(rows, sample_headers, ["study_id"])
        assert any("missing study_id" in i for i in issues)

    def test_missing_study_id_nr(self, sample_headers):
        rows = [{"study_id": "NR", "authors": "X", "year": "2020"}]
        issues = validate(rows, sample_headers, ["study_id"])
        assert any("missing study_id" in i for i in issues)

    def test_duplicate_study_id(self, sample_headers):
        rows = [
            {"study_id": "Smith2020", "authors": "A"},
            {"study_id": "Smith2020", "authors": "B"},
        ]
        issues = validate(rows, sample_headers, [])
        assert any("duplicate study_id" in i for i in issues)

    def test_missing_critical_field(self, sample_headers):
        rows = [{"study_id": "Smith2020", "authors": "", "year": "2020"}]
        issues = validate(rows, sample_headers, ["authors"])
        assert any("missing critical field 'authors'" in i for i in issues)

    def test_ci_lower_greater_than_upper(self):
        headers = ["study_id", "effect_95ci_lower", "effect_95ci_upper"]
        rows = [
            {
                "study_id": "Bad2020",
                "effect_95ci_lower": "1.50",
                "effect_95ci_upper": "0.80",
            }
        ]
        issues = validate(rows, headers, [])
        assert any("CI lower" in i and "upper" in i for i in issues)

    def test_ci_valid_passes(self):
        headers = ["study_id", "effect_95ci_lower", "effect_95ci_upper"]
        rows = [
            {
                "study_id": "Good2020",
                "effect_95ci_lower": "0.70",
                "effect_95ci_upper": "1.20",
            }
        ]
        issues = validate(rows, headers, [])
        assert not any("CI lower" in i for i in issues)

    def test_percentage_out_of_range(self):
        headers = ["study_id", "response_pct"]
        rows = [{"study_id": "X2020", "response_pct": "150"}]
        issues = validate(rows, headers, [])
        assert any("outside 0-100 range" in i for i in issues)

    def test_percentage_negative(self):
        headers = ["study_id", "mortality_percent"]
        rows = [{"study_id": "X2020", "mortality_percent": "-5"}]
        issues = validate(rows, headers, [])
        assert any("outside 0-100 range" in i for i in issues)

    def test_percentage_valid(self):
        headers = ["study_id", "response_pct"]
        rows = [{"study_id": "X2020", "response_pct": "55.5"}]
        issues = validate(rows, headers, [])
        assert not any("outside 0-100 range" in i for i in issues)

    def test_sample_size_mismatch(self):
        headers = ["study_id", "n_randomized_total", "n_intervention", "n_control"]
        rows = [
            {
                "study_id": "X2020",
                "n_randomized_total": "200",
                "n_intervention": "100",
                "n_control": "50",  # 100+50=150 != 200, >5% diff
            }
        ]
        issues = validate(rows, headers, [])
        assert any("n_randomized_total" in i for i in issues)

    def test_sample_size_within_tolerance(self):
        headers = ["study_id", "n_randomized_total", "n_intervention", "n_control"]
        rows = [
            {
                "study_id": "X2020",
                "n_randomized_total": "201",
                "n_intervention": "100",
                "n_control": "100",  # 200 vs 201 = 0.5% diff, within 5%
            }
        ]
        issues = validate(rows, headers, [])
        assert not any("n_randomized_total" in i for i in issues)

    def test_missing_ci_columns_no_crash(self):
        """CI check should gracefully handle missing columns."""
        headers = ["study_id", "effect_95ci_lower"]  # no _upper
        rows = [{"study_id": "X", "effect_95ci_lower": "0.5"}]
        issues = validate(rows, headers, [])
        assert not any("CI lower" in i for i in issues)

    def test_study_label_uses_study_id(self):
        headers = ["study_id", "response_pct"]
        rows = [{"study_id": "MyStudy2020", "response_pct": "999"}]
        issues = validate(rows, headers, [])
        assert any("MyStudy2020" in i for i in issues)

    def test_study_label_falls_back_to_row(self):
        headers = ["response_pct"]
        rows = [{"response_pct": "999"}]
        issues = validate(rows, headers, [])
        assert any("Row 1" in i for i in issues)

    def test_empty_rows_no_issues(self):
        issues = validate([], ["study_id"], ["study_id"])
        assert issues == []

    def test_multiple_issues_combined(self):
        headers = ["study_id", "response_pct", "effect_95ci_lower", "effect_95ci_upper"]
        rows = [
            {
                "study_id": "",
                "response_pct": "200",
                "effect_95ci_lower": "2.0",
                "effect_95ci_upper": "1.0",
            }
        ]
        issues = validate(rows, headers, ["study_id"])
        assert len(issues) >= 3  # missing study_id + pct out of range + CI inverted
