from __future__ import annotations

from pathlib import Path


ROOT = Path(r"D:\SS13TEST\Github\Ratwood-2.0-KUKUtrans")
SRC_ROOT = ROOT / "code" / "modules" / "jobs"
PART2_SAFE_APPLY = ROOT / "tools" / "batch4_part2_safe_apply.py"
PART2_REPORT = ROOT / "tools" / "batch4_part2_apply_report.txt"
PART3_REPORT = ROOT / "tools" / "batch4_part3_apply_report.txt"
LEGACY_PATH_MAP = {
    "job_types/roguetown/Inquisition/orthoclasses/arbiter.dm": "job_types/roguetown/Inquisition/puritanclasses/arbiter.dm",
    "job_types/roguetown/adventurer/types/antag/assassin.dm": "job_types/roguetown/adventurer/assassin.dm",
    "job_types/roguetown/adventurer/types/antag/bandit.dm": "job_types/roguetown/adventurer/bandit.dm",
    "job_types/roguetown/adventurer/types/migrant/otavan/atgervi.dm": "job_types/roguetown/mercenaries/classes/atgervi.dm",
    "job_types/roguetown/adventurer/types/migrant/otavan/avar.dm": "job_types/roguetown/adventurer/types/combat/foreigner/avar.dm",
    "job_types/roguetown/church/archivist.dm": "job_types/roguetown/yeomen/archivist.dm",
    "job_types/roguetown/church/artificer.dm": "job_types/roguetown/adventurer/types/pilgrim/artificer.dm",
    "job_types/roguetown/courtier/barbersurgeon.dm": "job_types/roguetown/adventurer/types/pilgrim/barbersurgeon.dm",
    "job_types/roguetown/courtier/barkeep.dm": "job_types/roguetown/yeomen/barkeep.dm",
    "job_types/roguetown/courtier/bathmaid.dm": "job_types/roguetown/peasants/bathmaid.dm",
    "job_types/roguetown/garrison/arbalist.dm": "job_types/roguetown/Inquisition/orthoclasses/arbalist.dm",
    "job_types/roguetown/garrison/bailiff.dm": "job_types/roguetown/nobility/bailiff.dm",
    "job_types/roguetown/peasants/brewer.dm": "job_types/roguetown/trader/brewer.dm",
    "job_types/roguetown/yeomen/blacksmith.dm": "job_types/roguetown/adventurer/types/pilgrim/blacksmith.dm",
}


def normalize_path(rel_path: str) -> str:
    return LEGACY_PATH_MAP.get(rel_path, rel_path)


def load_base_processed() -> set[str]:
    processed: set[str] = set()
    for raw_line in PART2_SAFE_APPLY.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip().rstrip(",")
        if line.startswith('"') and line.endswith('"') and ".dm" in line:
            rel_path = normalize_path(line.strip('"'))
            if (SRC_ROOT / rel_path).exists():
                processed.add(rel_path)
    return processed


def load_report_paths(report_path: Path) -> set[str]:
    paths: set[str] = set()
    for line in report_path.read_text(encoding="utf-8").splitlines():
        if "|" in line:
            rel_path = normalize_path(line.split("|", 1)[0].strip())
            if (SRC_ROOT / rel_path).exists():
                paths.add(rel_path)
    return paths


def main() -> int:
    processed = load_base_processed()
    processed |= load_report_paths(PART2_REPORT)
    processed |= load_report_paths(PART3_REPORT)

    remaining = sorted(
        path.relative_to(SRC_ROOT).as_posix()
        for path in SRC_ROOT.rglob("*.dm")
        if path.relative_to(SRC_ROOT).as_posix() not in processed
    )

    batch = remaining[:51]
    print(f"REMAINING={len(remaining)}")
    print(f"BATCH4_RANGE=0..{max(len(batch) - 1, 0)}")
    for index, rel_path in enumerate(batch):
        print(f"{index}: {rel_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
