"""Tests for bib_to_csv.py — BibTeX field extraction."""

from __future__ import annotations

from bib_to_csv import extract_fields


class TestExtractFields:
    """Tests for extract_fields()."""

    def test_standard_entry(self):
        entry = {
            "ID": "Smith2020",
            "ENTRYTYPE": "article",
            "author": "Smith, John and Doe, Jane",
            "year": "2020",
            "title": "A great study",
            "journal": "Lancet",
            "abstract": "Background...",
            "doi": "10.1000/test",
            "pmid": "12345678",
            "keywords": "cancer, treatment",
        }
        result = extract_fields(entry)
        assert result["record_id"] == "Smith2020"
        assert result["entry_type"] == "article"
        assert result["authors"] == "Smith, John and Doe, Jane"
        assert result["year"] == "2020"
        assert result["title"] == "A great study"
        assert result["journal"] == "Lancet"
        assert result["abstract"] == "Background..."
        assert result["doi"] == "10.1000/test"
        assert result["pmid"] == "12345678"
        assert result["keywords"] == "cancer, treatment"

    def test_missing_fields_default_empty(self):
        entry = {"ID": "X2020", "ENTRYTYPE": "article"}
        result = extract_fields(entry)
        assert result["record_id"] == "X2020"
        assert result["authors"] == ""
        assert result["year"] == ""
        assert result["title"] == ""
        assert result["journal"] == ""
        assert result["abstract"] == ""
        assert result["doi"] == ""
        assert result["pmid"] == ""
        assert result["keywords"] == ""

    def test_journal_fallback_to_publication_name(self):
        """Scopus uses 'publicationName' instead of 'journal'."""
        entry = {"ID": "X", "ENTRYTYPE": "article", "publicationName": "Nature"}
        result = extract_fields(entry)
        assert result["journal"] == "Nature"

    def test_abstract_fallback_to_description(self):
        """Some sources use 'description' instead of 'abstract'."""
        entry = {"ID": "X", "ENTRYTYPE": "article", "description": "A study about..."}
        result = extract_fields(entry)
        assert result["abstract"] == "A study about..."

    def test_journal_prefers_journal_over_fallback(self):
        entry = {
            "ID": "X",
            "ENTRYTYPE": "article",
            "journal": "Lancet",
            "publicationName": "Nature",
        }
        result = extract_fields(entry)
        assert result["journal"] == "Lancet"

    def test_completely_empty_entry(self):
        result = extract_fields({})
        assert result["record_id"] == ""
        assert result["entry_type"] == ""

    def test_returns_exactly_10_fields(self):
        result = extract_fields({"ID": "test"})
        expected_keys = {
            "record_id", "entry_type", "authors", "year", "title",
            "journal", "abstract", "doi", "pmid", "keywords",
        }
        assert set(result.keys()) == expected_keys
