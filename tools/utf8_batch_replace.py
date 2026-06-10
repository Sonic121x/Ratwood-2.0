#!/usr/bin/env python3
"""
UTF-8 safe batch replacement tool.

Purpose:
- Avoid garbled Chinese caused by passing long Unicode text through PowerShell.
- Apply controlled, repeatable replacements from a UTF-8 JSON spec file.
- Preserve original line endings by reading/writing with newline="".

Example:
    python tools/utf8_batch_replace.py --spec replace_jobs.json --root .

Spec format:
{
  "operations": [
    {
      "path": "code/modules/jobs/job_types/_job.dm",
      "replacements": [
        {
          "old": "to_chat(player, span_notice(\"You are the <b>[used_title]</b>\"))",
          "new": "to_chat(player, span_notice(\"你的身份是 <b>[used_title]</b>\"))",
          "count": 1
        }
      ]
    }
  ]
}
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Apply UTF-8 safe batch replacements from a JSON spec."
    )
    parser.add_argument(
        "--spec",
        required=True,
        help="Path to the UTF-8 JSON spec file.",
    )
    parser.add_argument(
        "--root",
        default=".",
        help="Base directory used to resolve relative paths in the spec.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Preview changes without writing files.",
    )
    parser.add_argument(
        "--allow-noop",
        action="store_true",
        help="Allow replacements where old == new or where count is 0.",
    )
    return parser.parse_args()


def load_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8", newline="") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError(f"Spec root must be an object: {path}")
    return data


def resolve_path(base_dir: Path, raw_path: str) -> Path:
    path = Path(raw_path)
    if not path.is_absolute():
        path = (base_dir / path).resolve()
    return path


def replace_exact(
    content: str,
    old: str,
    new: str,
    count: int,
    file_path: Path,
    index: int,
    allow_noop: bool,
) -> str:
    if old == new and not allow_noop:
        raise ValueError(
            f"{file_path}: replacement #{index} old and new are identical; "
            "pass --allow-noop to ignore"
        )

    if count < 0:
        raise ValueError(f"{file_path}: replacement #{index} has negative count")

    occurrences = content.count(old)
    if count == 0:
        if allow_noop:
            return content
        raise ValueError(
            f"{file_path}: replacement #{index} requested count=0; "
            "pass --allow-noop to ignore"
        )

    if occurrences < count:
        raise ValueError(
            f"{file_path}: replacement #{index} expected at least {count} matches, "
            f"found {occurrences}"
        )

    return content.replace(old, new, count)


def process_file(
    file_path: Path,
    replacements: list[dict[str, Any]],
    dry_run: bool,
    allow_noop: bool,
) -> tuple[bool, int]:
    with file_path.open("r", encoding="utf-8", newline="") as handle:
        original = handle.read()

    updated = original
    applied = 0

    for index, replacement in enumerate(replacements, start=1):
        if not isinstance(replacement, dict):
            raise ValueError(f"{file_path}: replacement #{index} must be an object")

        try:
            old = replacement["old"]
            new = replacement["new"]
        except KeyError as exc:
            raise ValueError(
                f"{file_path}: replacement #{index} missing field {exc!s}"
            ) from exc

        if not isinstance(old, str) or not isinstance(new, str):
            raise ValueError(
                f"{file_path}: replacement #{index} old/new must be strings"
            )

        count = replacement.get("count", 1)
        if not isinstance(count, int):
            raise ValueError(f"{file_path}: replacement #{index} count must be int")

        before = updated
        updated = replace_exact(
            updated, old, new, count, file_path, index, allow_noop
        )
        if updated != before:
            applied += 1

    changed = updated != original

    if changed and not dry_run:
        with file_path.open("w", encoding="utf-8", newline="") as handle:
            handle.write(updated)

    return changed, applied


def main() -> int:
    args = parse_args()
    spec_path = Path(args.spec).resolve()
    root_dir = Path(args.root).resolve()

    spec = load_json(spec_path)
    operations = spec.get("operations")
    if not isinstance(operations, list) or not operations:
        raise ValueError("Spec must contain a non-empty 'operations' array")

    changed_files = 0
    changed_ops = 0

    for op_index, operation in enumerate(operations, start=1):
        if not isinstance(operation, dict):
            raise ValueError(f"Operation #{op_index} must be an object")

        raw_path = operation.get("path")
        replacements = operation.get("replacements")

        if not isinstance(raw_path, str) or not raw_path.strip():
            raise ValueError(f"Operation #{op_index} missing valid 'path'")
        if not isinstance(replacements, list) or not replacements:
            raise ValueError(
                f"Operation #{op_index} for '{raw_path}' needs non-empty 'replacements'"
            )

        file_path = resolve_path(root_dir, raw_path)
        if not file_path.exists():
            raise FileNotFoundError(f"Operation #{op_index}: file not found: {file_path}")

        changed, applied = process_file(
            file_path=file_path,
            replacements=replacements,
            dry_run=args.dry_run,
            allow_noop=args.allow_noop,
        )

        status = "DRY-RUN" if args.dry_run else "UPDATED" if changed else "UNCHANGED"
        print(f"[{status}] {file_path} ({applied} replacement groups applied)")

        if changed:
            changed_files += 1
        changed_ops += applied

    summary_prefix = "Previewed" if args.dry_run else "Finished"
    print(
        f"{summary_prefix}: {changed_files} file(s) changed, "
        f"{changed_ops} replacement group(s) applied."
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:  # pragma: no cover - CLI error path
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
