#!/bin/bash
# Cleanup root directory markdown files
# Move project-specific files to projects/ici-breast-cancer/

set -e

echo "🧹 Cleaning up root directory markdown files..."
echo ""

# Destination directories
ARCHIVE_DIR="projects/ici-breast-cancer/_archive"
mkdir -p "$ARCHIVE_DIR"

# Files that are ALREADY in projects/ici-breast-cancer/ (duplicates)
echo "📋 Checking for duplicate files already in projects/ici-breast-cancer/..."

DUPLICATES=(
    "FINAL_PROJECT_SUMMARY.md"
    "PROJECT_STATUS_FINAL.md"
    "CURRENT_STATUS.md"
    "FEASIBILITY_REPORT.md"
    "feasibility_hour1_analysis.md"
    "feasibility_hour2_pilot_extraction.md"
    "feasibility_hour3_scoring.md"
    "PARALLEL_WORK_SUMMARY.md"
    "CLAUDE_MD_UPDATE_SUMMARY.md"
    "PROGRESS_TRACKING_SUMMARY.md"
    "SKILLS_GENERALIZATION_REPORT.md"
)

echo "Found duplicates (already consolidated):"
for file in "${DUPLICATES[@]}"; do
    if [ -f "$file" ]; then
        echo "  - $file (already in projects/ici-breast-cancer/00_overview/)"
    fi
done
echo ""

# Files to archive (not needed in root, but keep for reference)
echo "📦 Archiving non-essential files..."
ARCHIVE_FILES=(
    "CLAUDE_MD_ADDITIONS.md"
    "PROJECT_START_PLAN.md"
)

for file in "${ARCHIVE_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ Archiving: $file → _archive/"
        mv "$file" "$ARCHIVE_DIR/"
    fi
done
echo ""

# Files to KEEP in root (essential)
echo "✅ Keeping essential files in root:"
KEEP_FILES=(
    "CLAUDE.md"
    "AGENTS.md"
    "README.md"
    "GETTING_STARTED.md"
    "FEASIBILITY_CHECKLIST.md"
    "CHANGELOG_UNPAYWALL.md"
)

for file in "${KEEP_FILES[@]}"; do
    if [ -f "$file" ] || [ -L "$file" ]; then
        echo "  ✓ $file"
    fi
done
echo ""

# Ask user before removing duplicates
echo "⚠️  The following files are DUPLICATES (already in projects/ici-breast-cancer/):"
echo ""
for file in "${DUPLICATES[@]}"; do
    if [ -f "$file" ]; then
        echo "  - $file"
    fi
done
echo ""
echo "These can be safely removed from root directory."
echo ""
echo "Would you like to:"
echo "  1) Remove duplicates (recommended)"
echo "  2) Move duplicates to _archive/"
echo "  3) Keep duplicates (do nothing)"
echo ""
read -p "Enter choice (1/2/3): " choice

case $choice in
    1)
        echo ""
        echo "🗑️  Removing duplicate files from root..."
        for file in "${DUPLICATES[@]}"; do
            if [ -f "$file" ]; then
                echo "  ✓ Removed: $file"
                rm "$file"
            fi
        done
        ;;
    2)
        echo ""
        echo "📦 Moving duplicates to _archive/..."
        for file in "${DUPLICATES[@]}"; do
            if [ -f "$file" ]; then
                echo "  ✓ Moved: $file → _archive/"
                mv "$file" "$ARCHIVE_DIR/"
            fi
        done
        ;;
    3)
        echo ""
        echo "ℹ️  Keeping duplicates in root directory (no changes)"
        ;;
    *)
        echo ""
        echo "❌ Invalid choice. No changes made."
        exit 1
        ;;
esac

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "📊 Summary:"
echo "  - Essential files in root: ${#KEEP_FILES[@]}"
echo "  - Archived files: ${#ARCHIVE_FILES[@]}"
echo "  - Duplicates handled: ${#DUPLICATES[@]}"
echo ""
echo "📁 File structure:"
echo "  Root directory: Clean, only essential files"
echo "  projects/ici-breast-cancer/00_overview/: All project summaries"
echo "  projects/ici-breast-cancer/_archive/: Non-essential archived files"
