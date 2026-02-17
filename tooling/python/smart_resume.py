#!/usr/bin/env python3
"""Smart resume: combines project status + session log for quick context recovery."""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


def run_command(cmd: list[str]) -> tuple[str, str, int]:
    """Run command and return stdout, stderr, returncode."""
    result = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
    )
    return result.stdout, result.stderr, result.returncode


def smart_resume(project_name: str, verbose: bool = False) -> None:
    """Run both status and resume, combine output."""

    print("\n" + "=" * 60)
    print("🔄 SMART RESUME: Recovering Context...")
    print("=" * 60 + "\n")

    # Determine project path
    script_dir = Path(__file__).resolve().parent
    repo_root = script_dir.parent.parent
    project_path = repo_root / "projects" / project_name

    if not project_path.exists():
        print(f"❌ Error: Project '{project_name}' not found at {project_path}")
        sys.exit(1)

    # Run project status
    print("📊 Checking project status...\n")
    status_cmd = ["uv", "run", "project_status.py", "--project", project_name]
    if verbose:
        status_cmd.append("--verbose")

    status_out, status_err, status_code = run_command(status_cmd)

    if status_code != 0:
        print(f"⚠️  Warning: project_status.py failed\n{status_err}")
    else:
        print(status_out)

    # Run session resume
    print("\n" + "=" * 60 + "\n")
    print("📋 Checking last session...\n")

    resume_cmd = ["uv", "run", "session_log.py", "--project", project_name, "resume"]
    resume_out, resume_err, resume_code = run_command(resume_cmd)

    if resume_code != 0:
        print("ℹ️  No previous session found (this might be a new project)")
    else:
        print(resume_out)

    # Suggest next action
    print("\n" + "=" * 60)
    print("💡 READY TO CONTINUE?")
    print("=" * 60 + "\n")

    print("Next steps:")
    print(f"\n1. Start a new session:")
    print(f"   uv run session_log.py --project {project_name} start \\")
    print(f'     --notes "Resuming work on <stage>"')

    print(f"\n2. Continue working on suggested next steps above")

    print(f"\n3. When done, end the session:")
    print(f"   uv run session_log.py --project {project_name} end \\")
    print(f'     --summary "Summary of what you did"')

    print("\n" + "=" * 60 + "\n")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Smart resume: quickly recover project context."
    )
    parser.add_argument(
        "--project",
        required=True,
        help="Project name (in projects/<name>/)",
    )
    parser.add_argument(
        "--verbose",
        "-v",
        action="store_true",
        help="Show detailed file information",
    )
    args = parser.parse_args()

    smart_resume(args.project, verbose=args.verbose)


if __name__ == "__main__":
    main()
