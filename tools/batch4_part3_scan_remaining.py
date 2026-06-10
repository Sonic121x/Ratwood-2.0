from __future__ import annotations

from pathlib import Path
import re


ROOT = Path(r"D:\SS13TEST\Github\Ratwood-2.0-KUKUtrans")
SRC_ROOT = ROOT / "code" / "modules" / "jobs"
SAFE_APPLY_SCRIPT = ROOT / "tools" / "batch4_part2_safe_apply.py"
PART2_REPORT = ROOT / "tools" / "batch4_part2_apply_report.txt"

STRING_RE = re.compile(r'"((?:[^"\\]|\\.)*)"')
ENGLISH_RE = re.compile(r"[A-Za-z]{3,}")

IGNORE_SUBSTRINGS = (
    "title = ",
    "f_title = ",
    "display_title = ",
    "icon_state = ",
    "new_role = ",
    "special_role = ",
    "assigned_role = ",
    'GetJob("',
    "sound/",
    "map_name",
    "TRAIT_",
    "STATKEY_",
    "CTAG_",
    "JDO_",
)


def load_base_processed() -> set[str]:
    processed: set[str] = set()
    for raw_line in SAFE_APPLY_SCRIPT.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip().rstrip(",")
        if line.startswith('"') and line.endswith('"') and ".dm" in line:
            processed.add(line.strip('"'))
    return processed


def load_report_paths(report_path: Path) -> set[str]:
    paths: set[str] = set()
    for line in report_path.read_text(encoding="utf-8").splitlines():
        if "|" in line:
            paths.add(line.split("|", 1)[0].strip())
    return paths


def remaining_batch() -> list[Path]:
    processed = load_base_processed()
    processed |= load_report_paths(PART2_REPORT)
    files = sorted(
        p for p in SRC_ROOT.rglob("*.dm")
        if p.relative_to(SRC_ROOT).as_posix() not in processed
    )
    return files[:54]


def line_is_relevant(line: str) -> bool:
    stripped = line.strip()
    if not stripped or stripped.startswith("//"):
        return False
    for token in IGNORE_SUBSTRINGS:
        if token in line:
            return False
    return any(
        marker in line
        for marker in (
            "tutorial = ",
            "to_chat(",
            "input(",
            "alert(",
            "set name = ",
            "\tname = ",
            "recruitment_message = ",
            "accept_message = ",
            "refuse_message = ",
            "var/weapon_choice",
            "var/selected_helmet",
            "var/target_name",
        )
    )


def main() -> int:
    for path in remaining_batch():
        rel = path.relative_to(SRC_ROOT).as_posix()
        lines = path.read_text(encoding="utf-8").splitlines()
        emitted = False
        for number, line in enumerate(lines, start=1):
            if not line_is_relevant(line):
                continue
            matches = [m.group(1) for m in STRING_RE.finditer(line)]
            english_hits = [m for m in matches if ENGLISH_RE.search(m)]
            if not english_hits:
                continue
            if not emitted:
                print(f"[FILE] {rel}")
                emitted = True
            for hit in english_hits:
                print(f"  {number}: {hit}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
