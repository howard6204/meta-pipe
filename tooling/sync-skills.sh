#!/usr/bin/env bash
# Sync */SKILL.md directories -> .claude/skills/
# Uses rsync to mirror entire module directories so Claude Code
# reads the full SKILL.md content directly (no proxy indirection).
#
# Usage:
#   ./tooling/sync-skills.sh          # from project root
#   ./tooling/sync-skills.sh --dry    # preview only, no writes

set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

SKILLS_DIR=".claude/skills"
DRY="${1:---no-dry}"

rsync_flags=(-a --delete --exclude='__pycache__')
[[ "$DRY" == "--dry" ]] && rsync_flags+=(--dry-run)

synced=0
for dir in */; do
  [[ -f "${dir}SKILL.md" ]] || continue
  rsync "${rsync_flags[@]}" -v "$dir" "${SKILLS_DIR}/${dir}"
  synced=$((synced + 1))
done

echo ""
echo "Synced ${synced} skill modules to ${SKILLS_DIR}/"
[[ "$DRY" == "--dry" ]] && echo "(dry run — no files were written)" || true
