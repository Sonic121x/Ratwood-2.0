#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path
import re


SAFE_MARKERS = (
    'name = "',
    'tutorial = "',
    'desc = "',
    'extra_context = "',
    'examine_name = "',
    'recruitment_message = "',
    'accept_message = "',
    'to_chat(',
    'visible_message(',
    'priority_announce(',
    'alert(',
    'input(',
    'ORDER_INPUT(',
)

RISK_MARKERS = (
    'title = "',
    'display_title = "',
    'f_title = "',
    'icon_state',
    'item_state',
    'new_role',
    'special_role',
    'assigned_role',
    'mind.special_role',
    'mind.assigned_role',
    'real_name',
    'recruitment_faction',
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Apply proper noun translations to safe jobs text only.")
    parser.add_argument("--mapping", required=True, help="Path to proper noun mapping table.")
    parser.add_argument("--target", required=True, help="Target jobs directory.")
    parser.add_argument("--dry-run", action="store_true", help="Preview only.")
    return parser.parse_args()


def load_mapping(path: Path) -> list[tuple[str, str]]:
    mapping: list[tuple[str, str]] = []
    with path.open("r", encoding="utf-8", newline="") as handle:
        for raw_line in handle:
            line = raw_line.strip()
            if not line.startswith("- ") or " -> " not in line:
                continue
            left, right = line[2:].split(" -> ", 1)
            left = left.strip()
            right = right.strip()
            if not left or not right:
                continue
            mapping.append((left, right))
    mapping.sort(key=lambda item: len(item[0]), reverse=True)
    return mapping


def is_comment_or_block(line: str, in_block: bool) -> tuple[bool, bool]:
    stripped = line.lstrip()
    if in_block:
        if "*/" in line:
            return True, False
        return True, True
    if stripped.startswith("/*"):
        return True, "*/" not in stripped
    if stripped.startswith("//") or stripped.startswith("*"):
        return True, False
    return False, False


def is_safe_line(line: str) -> bool:
    if any(marker in line for marker in RISK_MARKERS):
        return False
    return any(marker in line for marker in SAFE_MARKERS)


def apply_mapping_to_line(line: str, mapping: list[tuple[str, str]]) -> tuple[str, int]:
    updated = line
    replacements = 0
    for old, new in mapping:
        if old not in updated:
            continue
        if new.startswith(old):
            suffix = new[len(old):]
            pattern = re.escape(old) + f"(?!{re.escape(suffix)})"
            updated, count = re.subn(pattern, new, updated)
            replacements += count
        else:
            count = updated.count(old)
            updated = updated.replace(old, new)
            replacements += count
    return updated, replacements


def process_file(path: Path, mapping: list[tuple[str, str]], dry_run: bool) -> tuple[bool, int]:
    with path.open("r", encoding="utf-8", newline="") as handle:
        original = handle.readlines()

    updated_lines: list[str] = []
    in_block = False
    file_replacements = 0

    for line in original:
        is_comment, new_in_block = is_comment_or_block(line, in_block)
        in_block = new_in_block
        if is_comment or not is_safe_line(line):
            updated_lines.append(line)
            continue
        updated, replaced = apply_mapping_to_line(line, mapping)
        updated_lines.append(updated)
        file_replacements += replaced

    changed = updated_lines != original
    if changed and not dry_run:
        with path.open("w", encoding="utf-8", newline="") as handle:
            handle.writelines(updated_lines)
    return changed, file_replacements


def main() -> int:
    args = parse_args()
    mapping_path = Path(args.mapping).resolve()
    target_path = Path(args.target).resolve()
    mapping = load_mapping(mapping_path)
    changed_files = 0
    total_replacements = 0

    for file_path in sorted(target_path.rglob("*.dm")):
        changed, replacements = process_file(file_path, mapping, args.dry_run)
        if changed:
            changed_files += 1
            total_replacements += replacements
            status = "DRY-RUN" if args.dry_run else "UPDATED"
            print(f"[{status}] {file_path} ({replacements} replacement(s))")

    summary = "Previewed" if args.dry_run else "Finished"
    print(f"{summary}: {changed_files} file(s) changed, {total_replacements} replacement(s) applied.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
