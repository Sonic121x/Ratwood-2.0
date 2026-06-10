from __future__ import annotations

from pathlib import Path


ROOT = Path(r"D:\SS13TEST\Github\Ratwood-2.0-KUKUtrans")
SRC_ROOT = ROOT / "code" / "modules" / "jobs"
SAFE_APPLY_SCRIPT = ROOT / "tools" / "batch4_part2_safe_apply.py"
PART2_REPORT = ROOT / "tools" / "batch4_part2_apply_report.txt"


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


def main() -> int:
    processed = load_base_processed()
    processed |= load_report_paths(PART2_REPORT)

    remaining = sorted(
        path.relative_to(SRC_ROOT).as_posix()
        for path in SRC_ROOT.rglob("*.dm")
        if path.relative_to(SRC_ROOT).as_posix() not in processed
    )

    print(f"REMAINING={len(remaining)}")
    print("BATCH3_RANGE=0..53")
    for index, rel_path in enumerate(remaining[:54]):
        print(f"{index}: {rel_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
