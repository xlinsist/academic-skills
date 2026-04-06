#!/usr/bin/env python3
import argparse
import json
import re
import sys
import urllib.parse
import urllib.request


def _extract_keywords_from_guide(text: str) -> list[str]:
    # Pull the bullet list under "Focus on:" from GUIDE.md.
    focus_match = re.search(
        r"(?im)^Focus on:\s*(?:\r?\n)+(?P<block>(?:- [^\r\n]*(?:\r?\n|$))+)", text
    )
    if not focus_match:
        return []
    block = focus_match.group("block")
    return [line[2:].strip() for line in block.splitlines() if line.strip().startswith("- ")]


def _extract_topic_from_guide(text: str) -> str | None:
    topic_match = re.search(r"(?im)^Topic:\s*(?P<topic>.+?)\s*$", text)
    if not topic_match:
        return None
    return topic_match.group("topic").strip()


def openalex_search(
    query: str,
    *,
    from_date: str,
    to_date: str,
    per_page: int,
    mailto: str | None,
) -> dict:
    params: dict[str, str] = {
        "search": query,
        "per-page": str(per_page),
        "select": "id,display_name,publication_year,publication_date,doi,primary_location",
        "filter": f"from_publication_date:{from_date},to_publication_date:{to_date}",
    }
    url = "https://api.openalex.org/works?" + urllib.parse.urlencode(params)
    user_agent = "codex-cli/verify-openalex"
    if mailto:
        user_agent += f" (mailto:{mailto})"
    req = urllib.request.Request(url, headers={"User-Agent": user_agent})
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.load(resp)


def main() -> int:
    ap = argparse.ArgumentParser(description="Verify OpenAlex access and run a sample query using GUIDE.md keywords.")
    ap.add_argument("--guide", default="GUIDE.md", help="Path to GUIDE.md (default: GUIDE.md)")
    ap.add_argument("--from-date", default="2022-01-01", help="from_publication_date (default: 2022-01-01)")
    ap.add_argument("--to-date", default="2026-12-31", help="to_publication_date (default: 2026-12-31)")
    ap.add_argument("--per-page", type=int, default=10, help="Number of results (default: 10)")
    ap.add_argument("--mailto", default=None, help="Optional email for OpenAlex User-Agent")
    ap.add_argument("--query", default=None, help="Override query (default: derived from GUIDE.md)")
    args = ap.parse_args()

    try:
        guide_text = open(args.guide, "r", encoding="utf-8").read()
    except FileNotFoundError:
        print(f"error: guide not found: {args.guide}", file=sys.stderr)
        return 2

    keywords = _extract_keywords_from_guide(guide_text)
    topic = _extract_topic_from_guide(guide_text)

    if args.query:
        query = args.query
    else:
        parts: list[str] = []
        if topic:
            parts.append(topic)
        if keywords:
            parts.extend(keywords)
        if not parts:
            print("error: failed to derive query from GUIDE.md; pass --query", file=sys.stderr)
            return 2
        query = " ".join(parts)

    try:
        data = openalex_search(
            query,
            from_date=args.from_date,
            to_date=args.to_date,
            per_page=args.per_page,
            mailto=args.mailto,
        )
    except Exception as e:
        print(f"error: OpenAlex request failed: {e}", file=sys.stderr)
        return 1

    meta = data.get("meta", {})
    results = data.get("results", []) or []
    print("OpenAlex request: ok")
    print("query:", query)
    print("date range:", f"{args.from_date} .. {args.to_date}")
    print("matched works:", meta.get("count"))
    print()
    for i, w in enumerate(results, 1):
        primary_location = w.get("primary_location") or {}
        venue = ((primary_location.get("source") or {}).get("display_name")) or ""
        title = w.get("display_name") or ""
        year = w.get("publication_year")
        doi = w.get("doi") or ""
        wid = w.get("id") or ""
        print(f"{i}. {year} - {title}")
        if venue or doi or wid:
            tail = " | ".join([x for x in [venue, doi, wid] if x])
            print(f"   {tail}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
