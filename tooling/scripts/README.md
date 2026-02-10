# Tooling Scripts

Utility scripts for managing the meta-analysis pipeline.

---

## 📜 Available Scripts

### cleanup_root_markdown.sh

**Purpose**: Clean up root directory markdown files after project consolidation

**Usage**:

```bash
cd /Users/htlin/meta-pipe
./tooling/scripts/cleanup_root_markdown.sh
```

**What it does**:

1. Identifies duplicate files (already in `projects/ici-breast-cancer/`)
2. Archives non-essential draft files to `_archive/`
3. Keeps only essential files in root directory

**Interactive options**:

- Option 1: Remove duplicates (recommended)
- Option 2: Move duplicates to `_archive/`
- Option 3: Keep duplicates (no changes)

**Essential files kept in root**:

- `AGENTS.md` - Agent instructions
- `CLAUDE.md` - Symlink to AGENTS.md
- `README.md` - Project overview
- `GETTING_STARTED.md` - Getting started guide
- `ma-topic-intake/references/feasibility-checklist.md` - Feasibility assessment template
- `ma-fulltext-management/references/changelog-unpaywall.md` - Unpaywall API changelog

**Use case**: Run after consolidating a project to keep root directory clean for future projects

---

## 🐍 Python Scripts

See `tooling/python/` for Python utility scripts:

- `consolidate_project_outputs.py` - Organize all project outputs into structured directory
- `ai_screen_titles.py` - AI-assisted title/abstract screening
- `assemble_figures.py` - Multi-panel figure assembly at 300 DPI

---

## 📖 Usage Guidelines

### When to Use Cleanup Script

✅ **Use when**:

- Finishing a project (99%+ complete)
- Root directory has many temporary markdown files
- Preparing to start a new project
- Want to keep root directory clean

❌ **Don't use when**:

- Project is still in progress (< 95% complete)
- Files haven't been consolidated yet
- Unsure if files are duplicates

### Recommended Workflow

1. **Complete project** → Get to 99%+ completion
2. **Consolidate outputs** → Run `consolidate_project_outputs.py`
3. **Verify consolidation** → Check `projects/{name}/` has all files
4. **Clean root** → Run `cleanup_root_markdown.sh`
5. **Start new project** → Clean slate for next meta-analysis

---

## 🔧 Maintenance

### Adding New Scripts

1. Place script in appropriate directory:
   - Bash/Shell: `tooling/scripts/`
   - Python: `tooling/python/`

2. Make executable (if shell script):

   ```bash
   chmod +x tooling/scripts/your_script.sh
   ```

3. Update this README with:
   - Script name and purpose
   - Usage instructions
   - Example output

4. Add to consolidation script if needed:
   - Update `consolidate_project_outputs.py` file mappings
   - Ensure script is copied to `09_scripts/`

---

## 📚 Related Documentation

- [Time Investment Guidance](../../ma-end-to-end/references/time-guidance.md) - Pipeline timeline
- [Skill Generalization](../../ma-end-to-end/references/skill-generalization.md) - Extract reusable workflows
- [Getting Started](../../GETTING_STARTED.md) - Complete pipeline guide
