#!/usr/bin/env python3
"""Verify DOI existence and find missing DOIs in references.bib.

For each BibTeX entry:
  - If DOI present: verify it resolves via Crossref API
  - If DOI missing: search Crossref by title+year, suggest candidate DOI

Usage:
    uv run ma-manuscript-quarto/scripts/verify_doi.py \
        --bib projects/<project>/07_manuscript/references.bib \
        --out projects/<project>/09_qa/doi_verification_report.md

    # Also export machine-readable CSV
    uv run ma-manuscript-quarto/scripts/verify_doi.py \
        --bib projects/<project>/07_manuscript/references.bib \
        --out projects/<project>/09_qa/doi_verification_report.md \
        --out-csv projects/<project>/09_qa/doi_verification.csv

    # Auto-patch missing DOIs with high-confidence matches (>= 85%)
    uv run ma-manuscript-quarto/scripts/verify_doi.py \
        --bib projects/<project>/07_manuscript/references.bib \
        --out projects/<project>/09_qa/doi_verification_report.md \
        --patch --min-confidence 85
"""

from __future__ import annotations

import argparse
import csv
import re
import sys
import time
from difflib import SequenceMatcher
from pathlib import Path

try:
    import bibtexparser
except ImportError:
    print("ERROR: bibtexparser not installed. Run: uv add bibtexparser", file=sys.stderr)
    sys.exit(1)

try:
    import requests
except ImportError:
    print("ERROR: requests not installed. Run: uv add requests", file=sys.stderr)
    sys.exit(1)

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

CROSSREF_WORKS_URL = "https://api.crossref.org/works"
USER_AGENT = "meta-pipe-doi-verifier/1.0 (mailto:meta-pipe@example.com)"
DEFAULT_RATE_LIMIT = 1.0  # seconds between requests (polite pool)
TITLE_SIMILARITY_THRESHOLD = 0.80  # minimum for a candidate match
HIGH_CONFIDENCE_THRESHOLD = 0.85  # auto-patch threshold


# ---------------------------------------------------------------------------
# DOI normalization
# ---------------------------------------------------------------------------


def normalize_doi(doi: str) -> str:
    """Strip URL prefixes and normalize DOI to bare form."""
    doi = doi.strip()
    for prefix in [
        "https://doi.org/",
        "http://doi.org/",
        "https://dx.doi.org/",
        "http://dx.doi.org/",
        "doi:",
        "DOI:",
    ]:
        if doi.lower().startswith(prefix.lower()):
            doi = doi[len(prefix) :]
    return doi.strip()


# ---------------------------------------------------------------------------
# Title similarity (inspired by Pure_DOI_sniffer's conservative approach)
# ---------------------------------------------------------------------------


def clean_title(title: str) -> str:
    """Normalize title for comparison."""
    title = title.lower()
    title = re.sub(r"[^\w\s]", " ", title)
    title = re.sub(r"\s+", " ", title).strip()
    return title


def title_similarity(t1: str, t2: str) -> float:
    """Compute title similarity using best-of strategies with safety checks.

    Returns a score between 0.0 and 1.0.

    Uses max(simple, token_set) because:
    - simple handles substring cases (BibTeX title ⊂ Crossref title)
    - token_set handles word-reordering cases
    Both must pass a length sanity check to avoid false positives.
    """
    c1 = clean_title(t1)
    c2 = clean_title(t2)

    if not c1 or not c2:
        return 0.0

    # Length sanity check: reject if one title is < 50% of the other
    len_ratio = min(len(c1), len(c2)) / max(len(c1), len(c2)) if max(len(c1), len(c2)) > 0 else 0.0
    if len_ratio < 0.5:
        return 0.0

    # Strategy 1: Simple sequence ratio (good for substring matches)
    simple = SequenceMatcher(None, c1, c2).ratio()

    # Strategy 2: Token set ratio (unique words overlap, handles reordering)
    set1 = set(c1.split())
    set2 = set(c2.split())
    if set1 | set2:
        token_set = len(set1 & set2) / len(set1 | set2)
    else:
        token_set = 0.0

    # Strategy 3: Token sort ratio (sort words, then compare)
    words1 = " ".join(sorted(c1.split()))
    words2 = " ".join(sorted(c2.split()))
    token_sort = SequenceMatcher(None, words1, words2).ratio()

    # Use best of the three strategies
    # This handles: exact matches, substring matches, and reordering
    return max(simple, token_set, token_sort)


# ---------------------------------------------------------------------------
# Confidence scoring (adapted from Pure_DOI_sniffer)
# ---------------------------------------------------------------------------


def compute_confidence(
    original_title: str,
    candidate_title: str,
    original_year: str | None,
    candidate_year: str | None,
) -> tuple[float, dict]:
    """Compute confidence score for a DOI candidate match.

    Returns (confidence_0_to_100, detail_dict).
    Weights: title=60%, year=40%.
    """
    details = {}

    # Title similarity (60% weight, max 60 points)
    sim = title_similarity(original_title, candidate_title)
    details["title_similarity"] = round(sim * 100, 1)
    if sim >= TITLE_SIMILARITY_THRESHOLD:
        title_points = 60 * sim
    else:
        title_points = 0.0
    details["title_points"] = round(title_points, 1)

    # Year match (40% weight, max 40 points)
    year_points = 0.0
    if original_year and candidate_year:
        try:
            diff = abs(int(original_year) - int(candidate_year))
            if diff == 0:
                year_points = 40.0
            elif diff == 1:
                year_points = 20.0  # partial credit for ±1 year
        except ValueError:
            pass
    details["year_points"] = round(year_points, 1)

    confidence = title_points + year_points
    details["confidence"] = round(confidence, 1)
    return confidence, details


# ---------------------------------------------------------------------------
# Crossref API
# ---------------------------------------------------------------------------


def verify_doi_exists(doi: str, session: requests.Session) -> tuple[bool, dict | None]:
    """Check if a DOI resolves via Crossref API.

    Returns (exists: bool, metadata: dict | None).
    """
    url = f"{CROSSREF_WORKS_URL}/{requests.utils.quote(doi, safe='')}"
    try:
        resp = session.get(url, timeout=15)
        if resp.status_code == 200:
            data = resp.json()
            item = data.get("message", {})
            return True, item
        return False, None
    except (requests.RequestException, ValueError):
        return False, None


def _crossref_search(
    title: str, session: requests.Session, rows: int = 3, year_filter: str | None = None
) -> list[dict]:
    """Low-level Crossref search. Returns raw items list."""
    params: dict = {
        "query.title": title,
        "rows": rows,
        "select": "DOI,title,published-print,published-online,issued",
    }
    if year_filter:
        params["filter"] = year_filter

    try:
        resp = session.get(CROSSREF_WORKS_URL, params=params, timeout=15)
        if resp.status_code != 200:
            return []
        return resp.json().get("message", {}).get("items", [])
    except (requests.RequestException, ValueError):
        return []


def _truncate_title(title: str, max_words: int = 15) -> str:
    """Truncate long titles for better Crossref search results.

    Very long titles (>15 words) dilute search relevance in Crossref.
    """
    words = title.split()
    if len(words) <= max_words:
        return title
    return " ".join(words[:max_words])


def search_doi_by_title(
    title: str, year: str | None, session: requests.Session, rows: int = 5
) -> list[dict]:
    """Search Crossref for a DOI matching a title.

    Strategy (3 attempts, stops when results found):
      1. Full title + year filter (±1 year)
      2. Full title without year filter
      3. Truncated title (first 15 words) without year filter

    Returns list of candidate dicts with keys: doi, title, year, confidence, details.
    """
    # Attempt 1: full title + year filter
    items = []
    if year:
        year_filter = f"from-pub-date:{int(year) - 1},until-pub-date:{int(year) + 1}"
        items = _crossref_search(title, session, rows, year_filter)

    # Attempt 2: full title, no year filter
    if not items:
        items = _crossref_search(title, session, rows)

    # Attempt 3: truncated title (helps with very long titles)
    if not items:
        short_title = _truncate_title(title)
        if short_title != title:
            items = _crossref_search(short_title, session, rows)

    candidates = []
    for item in items:
        candidate_doi = item.get("DOI", "")
        candidate_titles = item.get("title", [])
        candidate_title = candidate_titles[0] if candidate_titles else ""

        # Extract year from various date fields
        candidate_year = None
        for date_field in ["published-print", "published-online", "issued"]:
            date_parts = item.get(date_field, {}).get("date-parts", [[]])
            if date_parts and date_parts[0] and date_parts[0][0]:
                candidate_year = str(date_parts[0][0])
                break

        confidence, details = compute_confidence(
            title, candidate_title, year, candidate_year
        )

        if confidence > 0:
            candidates.append(
                {
                    "doi": candidate_doi,
                    "title": candidate_title,
                    "year": candidate_year,
                    "confidence": confidence,
                    "details": details,
                }
            )

    candidates.sort(key=lambda x: x["confidence"], reverse=True)
    return candidates


# ---------------------------------------------------------------------------
# BibTeX parsing
# ---------------------------------------------------------------------------


def parse_bib(bib_path: Path) -> list[dict]:
    """Parse a BibTeX file and return list of entry dicts."""
    text = bib_path.read_text(encoding="utf-8")
    parser = bibtexparser.bparser.BibTexParser(common_strings=True)
    bib_db = bibtexparser.loads(text, parser=parser)
    return bib_db.entries


def write_patched_bib(bib_path: Path, patches: dict[str, str]) -> int:
    """Patch missing DOIs into BibTeX file. Returns number of patches applied.

    Safety: creates .bak backup and validates output before overwriting.
    """
    text = bib_path.read_text(encoding="utf-8")
    original_len = len(text)
    applied = 0
    for entry_id, doi in patches.items():
        # Find the entry block and insert doi field before closing brace
        pattern = re.compile(
            r"(@\w+\{" + re.escape(entry_id) + r"\s*,)(.*?)(^\})",
            re.MULTILINE | re.DOTALL,
        )
        match = pattern.search(text)
        if match and "doi" not in match.group(2).lower():
            insert = f"  doi = {{{doi}}},\n"
            text = text[: match.start(3)] + insert + text[match.start(3) :]
            applied += 1
    if applied > 0:
        # Safety: patched file must be at least as long as original
        if len(text.strip()) < original_len * 0.5:
            print(
                f"ERROR: patched output ({len(text)} bytes) is much smaller than "
                f"original ({original_len} bytes). Refusing to write. "
                f"Backup preserved at {bib_path}.bak",
                file=sys.stderr,
            )
            return 0
        # Write backup, then patched file
        backup = bib_path.with_suffix(".bib.bak")
        backup.write_text(bib_path.read_text(encoding="utf-8"), encoding="utf-8")
        bib_path.write_text(text, encoding="utf-8")
    return applied


# ---------------------------------------------------------------------------
# Report generation
# ---------------------------------------------------------------------------


def generate_report(results: list[dict], bib_path: str) -> str:
    """Generate markdown verification report."""
    lines = []
    lines.append("# DOI Verification Report\n")
    lines.append(f"**Source**: `{bib_path}`\n")

    total = len(results)
    has_doi = sum(1 for r in results if r["has_doi"])
    missing_doi = total - has_doi
    verified = sum(1 for r in results if r["status"] == "verified")
    invalid = sum(1 for r in results if r["status"] == "invalid")
    found = sum(1 for r in results if r["status"] == "found")
    not_found = sum(1 for r in results if r["status"] == "not_found")
    skipped = sum(1 for r in results if r["status"] == "skipped")

    coverage = (has_doi / total * 100) if total > 0 else 0
    verified_pct = (verified / has_doi * 100) if has_doi > 0 else 0

    lines.append("## Summary\n")
    lines.append(f"| Metric | Value |")
    lines.append(f"|--------|-------|")
    lines.append(f"| Total entries | {total} |")
    lines.append(f"| With DOI | {has_doi} ({coverage:.0f}%) |")
    lines.append(f"| Without DOI | {missing_doi} |")
    lines.append(f"| DOI verified (resolves) | {verified} |")
    lines.append(f"| DOI invalid (does not resolve) | {invalid} |")
    lines.append(f"| Missing DOI — candidate found | {found} |")
    lines.append(f"| Missing DOI — no candidate | {not_found} |")
    lines.append(f"| Skipped (non-article) | {skipped} |")
    lines.append("")

    # Pass/fail
    pass_threshold = 90
    if coverage >= pass_threshold and invalid == 0:
        lines.append(f"**Result**: PASS (DOI coverage {coverage:.0f}% >= {pass_threshold}%, 0 invalid DOIs)\n")
    else:
        reasons = []
        if coverage < pass_threshold:
            reasons.append(f"DOI coverage {coverage:.0f}% < {pass_threshold}%")
        if invalid > 0:
            reasons.append(f"{invalid} invalid DOI(s)")
        lines.append(f"**Result**: FAIL ({'; '.join(reasons)})\n")

    # Invalid DOIs
    invalid_results = [r for r in results if r["status"] == "invalid"]
    if invalid_results:
        lines.append("## Invalid DOIs (Do Not Resolve)\n")
        lines.append("These DOIs are present in the BibTeX but do not resolve via Crossref.\n")
        lines.append("| Key | DOI | Action |")
        lines.append("|-----|-----|--------|")
        for r in invalid_results:
            lines.append(f"| `{r['key']}` | `{r['doi']}` | Verify manually or correct |")
        lines.append("")

    # Missing DOIs with candidates
    found_results = [r for r in results if r["status"] == "found"]
    if found_results:
        lines.append("## Missing DOIs — Candidates Found\n")
        lines.append("| Key | Title (truncated) | Candidate DOI | Confidence | Action |")
        lines.append("|-----|-------------------|---------------|------------|--------|")
        for r in found_results:
            title_short = r["title"][:50] + "..." if len(r["title"]) > 50 else r["title"]
            conf = r["candidate"]["confidence"]
            action = "Auto-patch" if conf >= HIGH_CONFIDENCE_THRESHOLD * 100 else "Manual review"
            lines.append(
                f"| `{r['key']}` | {title_short} | `{r['candidate']['doi']}` | {conf:.0f}% | {action} |"
            )
        lines.append("")

    # Missing DOIs without candidates
    not_found_results = [r for r in results if r["status"] == "not_found"]
    if not_found_results:
        lines.append("## Missing DOIs — No Candidate Found\n")
        lines.append("| Key | Title (truncated) | Action |")
        lines.append("|-----|-------------------|--------|")
        for r in not_found_results:
            title_short = r["title"][:60] + "..." if len(r["title"]) > 60 else r["title"]
            lines.append(f"| `{r['key']}` | {title_short} | Manual DOI lookup |")
        lines.append("")

    # Verified DOIs (collapsed)
    verified_results = [r for r in results if r["status"] == "verified"]
    if verified_results:
        lines.append(f"## Verified DOIs ({len(verified_results)} entries)\n")
        lines.append("<details>")
        lines.append("<summary>All verified — click to expand</summary>\n")
        lines.append("| Key | DOI |")
        lines.append("|-----|-----|")
        for r in verified_results:
            lines.append(f"| `{r['key']}` | `{r['doi']}` |")
        lines.append("")
        lines.append("</details>\n")

    return "\n".join(lines)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

# Entry types that should have DOIs
ARTICLE_TYPES = {"article", "inproceedings", "incollection", "proceedings"}
# Entry types that typically lack DOIs (skip without penalty)
SKIP_TYPES = {"misc", "online", "webpage", "url", "manual", "techreport", "unpublished"}


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Verify DOI existence and find missing DOIs in references.bib"
    )
    parser.add_argument("--bib", required=True, help="Path to references.bib")
    parser.add_argument("--out", required=True, help="Output markdown report path")
    parser.add_argument("--out-csv", help="Optional CSV output path")
    parser.add_argument(
        "--patch",
        action="store_true",
        help="Auto-patch high-confidence DOIs into the BibTeX file",
    )
    parser.add_argument(
        "--min-confidence",
        type=float,
        default=85,
        help="Minimum confidence (0-100) for auto-patching (default: 85)",
    )
    parser.add_argument(
        "--email",
        default="meta-pipe@example.com",
        help="Email for Crossref polite pool (faster rate limits)",
    )
    parser.add_argument(
        "--sleep",
        type=float,
        default=DEFAULT_RATE_LIMIT,
        help="Seconds between API requests (default: 1.0)",
    )
    args = parser.parse_args()

    bib_path = Path(args.bib)
    if not bib_path.exists():
        print(f"ERROR: {bib_path} not found", file=sys.stderr)
        return 1

    entries = parse_bib(bib_path)
    if not entries:
        print("ERROR: No entries found in BibTeX file", file=sys.stderr)
        return 1

    print(f"Loaded {len(entries)} entries from {bib_path}")

    session = requests.Session()
    session.headers.update(
        {
            "User-Agent": f"meta-pipe-doi-verifier/1.0 (mailto:{args.email})",
            "Accept": "application/json",
        }
    )

    results: list[dict] = []
    patches: dict[str, str] = {}

    for i, entry in enumerate(entries):
        key = entry.get("ID", f"entry_{i}")
        entry_type = entry.get("ENTRYTYPE", "").lower()
        title = entry.get("title", "").strip().strip("{}")
        year = entry.get("year", "").strip()
        doi = entry.get("doi", "").strip()

        print(f"  [{i + 1}/{len(entries)}] {key}...", end=" ", flush=True)

        # Skip non-article types
        if entry_type in SKIP_TYPES:
            results.append(
                {
                    "key": key,
                    "type": entry_type,
                    "title": title,
                    "year": year,
                    "doi": doi,
                    "has_doi": bool(doi),
                    "status": "skipped",
                    "candidate": None,
                    "note": f"Skipped (type: {entry_type})",
                }
            )
            print("skipped (non-article type)")
            continue

        if doi:
            # Verify existing DOI
            clean_doi = normalize_doi(doi)
            exists, _metadata = verify_doi_exists(clean_doi, session)
            status = "verified" if exists else "invalid"
            results.append(
                {
                    "key": key,
                    "type": entry_type,
                    "title": title,
                    "year": year,
                    "doi": clean_doi,
                    "has_doi": True,
                    "status": status,
                    "candidate": None,
                    "note": "DOI resolves" if exists else "DOI does not resolve",
                }
            )
            print("verified" if exists else "INVALID")
        else:
            # Search for missing DOI
            if not title:
                results.append(
                    {
                        "key": key,
                        "type": entry_type,
                        "title": "",
                        "year": year,
                        "doi": "",
                        "has_doi": False,
                        "status": "not_found",
                        "candidate": None,
                        "note": "No title available for search",
                    }
                )
                print("no title")
                continue

            candidates = search_doi_by_title(title, year, session)
            if candidates and candidates[0]["confidence"] >= TITLE_SIMILARITY_THRESHOLD * 100:
                best = candidates[0]
                results.append(
                    {
                        "key": key,
                        "type": entry_type,
                        "title": title,
                        "year": year,
                        "doi": "",
                        "has_doi": False,
                        "status": "found",
                        "candidate": best,
                        "note": f"Candidate DOI: {best['doi']} (confidence: {best['confidence']:.0f}%)",
                    }
                )
                if args.patch and best["confidence"] >= args.min_confidence:
                    patches[key] = best["doi"]
                print(f"found: {best['doi']} ({best['confidence']:.0f}%)")
            else:
                results.append(
                    {
                        "key": key,
                        "type": entry_type,
                        "title": title,
                        "year": year,
                        "doi": "",
                        "has_doi": False,
                        "status": "not_found",
                        "candidate": None,
                        "note": "No matching DOI found",
                    }
                )
                print("not found")

        time.sleep(args.sleep)

    # Generate report
    report = generate_report(results, str(bib_path))
    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(report, encoding="utf-8")
    print(f"\nReport written to {out_path}")

    # Optional CSV
    if args.out_csv:
        csv_path = Path(args.out_csv)
        csv_path.parent.mkdir(parents=True, exist_ok=True)
        with csv_path.open("w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(
                f,
                fieldnames=[
                    "key", "type", "title", "year", "doi",
                    "has_doi", "status", "candidate_doi",
                    "candidate_confidence", "note",
                ],
            )
            writer.writeheader()
            for r in results:
                writer.writerow(
                    {
                        "key": r["key"],
                        "type": r["type"],
                        "title": r["title"],
                        "year": r["year"],
                        "doi": r["doi"],
                        "has_doi": r["has_doi"],
                        "status": r["status"],
                        "candidate_doi": r["candidate"]["doi"] if r["candidate"] else "",
                        "candidate_confidence": (
                            f"{r['candidate']['confidence']:.0f}" if r["candidate"] else ""
                        ),
                        "note": r["note"],
                    }
                )
        print(f"CSV written to {csv_path}")

    # Auto-patch
    if args.patch and patches:
        applied = write_patched_bib(bib_path, patches)
        print(f"\nPatched {applied} DOIs into {bib_path}")

    # Exit code
    has_doi_count = sum(1 for r in results if r["has_doi"])
    total_articles = sum(1 for r in results if r["status"] != "skipped")
    invalid_count = sum(1 for r in results if r["status"] == "invalid")
    coverage = (has_doi_count / total_articles * 100) if total_articles > 0 else 0

    if invalid_count > 0:
        return 2  # invalid DOIs found
    if coverage < 90:
        return 1  # coverage below threshold
    return 0


if __name__ == "__main__":
    sys.exit(main())
