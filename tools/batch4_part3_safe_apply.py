from __future__ import annotations

from difflib import SequenceMatcher
from pathlib import Path
import re


ROOT = Path(r"D:\SS13TEST\Github\Ratwood-2.0-KUKUtrans")
SRC_ROOT = ROOT / "code" / "modules" / "jobs"
TEST_ROOT = Path(r"D:\SS13TEST\Ratwood-2.0-test") / "code" / "modules" / "jobs"
PREPARE_SCRIPT = ROOT / "tools" / "batch4_part3_prepare.py"
PART2_SAFE_APPLY = ROOT / "tools" / "batch4_part2_safe_apply.py"
PART2_REPORT = ROOT / "tools" / "batch4_part2_apply_report.txt"

STRING_RE = re.compile(r'"(?:[^"\\]|\\.)*"')
WS_RE = re.compile(r"\s+")
BLACKLIST = [
    "title =",
    "f_title =",
    "display_title =",
    "new_role =",
    "special_role =",
    "assigned_role =",
    ".job =",
    " job =",
    "real_name =",
    "mind.special_role",
    "mind.assigned_role",
    "icon_state =",
    "name =",
]


def load_base_processed() -> set[str]:
    processed: set[str] = set()
    for raw_line in PART2_SAFE_APPLY.read_text(encoding="utf-8").splitlines():
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


def remaining_batch() -> list[str]:
    processed = load_base_processed()
    processed |= load_report_paths(PART2_REPORT)
    files = sorted(
        p.relative_to(SRC_ROOT).as_posix()
        for p in SRC_ROOT.rglob("*.dm")
        if p.relative_to(SRC_ROOT).as_posix() not in processed
    )
    return files[:54]


def skeleton(line: str) -> str:
    return WS_RE.sub("", STRING_RE.sub('""', line))


def safe(old: str, new: str) -> bool:
    if '"' not in old or '"' not in new:
        return False
    old_skeleton = skeleton(old)
    if old_skeleton != skeleton(new):
        return False
    for token in BLACKLIST:
        if token.replace(" ", "") in old_skeleton:
            return False
    return True


def main() -> int:
    report_lines: list[str] = []
    changed_files = 0

    for rel in remaining_batch():
        src_path = SRC_ROOT / rel
        test_path = TEST_ROOT / rel

        if not test_path.exists():
            report_lines.append(f"{rel} | applied=0 skipped=0 changed=False missing_test=True")
            continue

        src_content = src_path.read_text(encoding="utf-8")
        test_content = test_path.read_text(encoding="utf-8")
        src_lines = src_content.splitlines(keepends=True)
        test_lines = test_content.splitlines(keepends=True)

        applied = 0
        skipped = 0
        output_lines: list[str] = []

        matcher = SequenceMatcher(a=src_lines, b=test_lines)
        for tag, a0, a1, b0, b1 in matcher.get_opcodes():
            if tag == "equal":
                output_lines.extend(src_lines[a0:a1])
                continue
            if tag == "replace" and (a1 - a0) == (b1 - b0):
                for old_line, new_line in zip(src_lines[a0:a1], test_lines[b0:b1]):
                    if safe(old_line.rstrip("\r\n"), new_line.rstrip("\r\n")):
                        output_lines.append(new_line)
                        applied += 1
                    else:
                        output_lines.append(old_line)
                        skipped += 1
            else:
                output_lines.extend(src_lines[a0:a1])
                skipped += max(a1 - a0, b1 - b0)

        new_content = "".join(output_lines)
        changed = new_content != src_content
        if changed:
            src_path.write_text(new_content, encoding="utf-8", newline="")
            changed_files += 1

        report_lines.append(f"{rel} | applied={applied} skipped={skipped} changed={changed}")

    report_path = ROOT / "tools" / "batch4_part3_apply_report.txt"
    report_path.write_text("\n".join(report_lines), encoding="utf-8", newline="")
    print(f"CHANGED_FILES={changed_files}")
    print(f"WROTE {report_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
