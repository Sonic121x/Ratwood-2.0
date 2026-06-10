from __future__ import annotations

from difflib import SequenceMatcher
from pathlib import Path
import re


ROOT = Path(r"D:\SS13TEST\Github\Ratwood-2.0-KUKUtrans")
SRC_ROOT = ROOT / "code" / "modules" / "jobs"
TEST_ROOT = Path(r"D:\SS13TEST\Ratwood-2.0-test") / "code" / "modules" / "jobs"

PROCESSED = {
    "access.dm",
    "job_types/_job.dm",
    "job_types/_unassigned.dm",
    "job_types/roguetown/Inquisition/absolutionist.dm",
    "job_types/roguetown/Inquisition/orthoclasses/adjudicator.dm",
    "job_types/roguetown/adventurer/adventurer.dm",
    "job_types/roguetown/adventurer/types/_advclass.dm",
    "job_types/roguetown/adventurer/types/wretch/ancient.dm",
    "job_types/roguetown/adventurer/types/wretch/antipope.dm",
    "job_types/roguetown/courtier/apothecary.dm",
    "job_types/roguetown/garrison/arbalist.dm",
    "job_types/roguetown/Inquisition/orthoclasses/arbiter.dm",
    "job_types/roguetown/church/archivist.dm",
    "job_types/roguetown/church/artificer.dm",
    "job_types/roguetown/adventurer/types/antag/assassin.dm",
    "job_types/roguetown/adventurer/types/migrant/otavan/atgervi.dm",
    "job_types/roguetown/adventurer/types/migrant/otavan/avar.dm",
    "job_types/roguetown/garrison/bailiff.dm",
    "job_types/roguetown/adventurer/types/antag/bandit.dm",
    "job_types/roguetown/courtier/barbersurgeon.dm",
    "job_types/roguetown/courtier/barkeep.dm",
    "job_types/roguetown/courtier/bathmaid.dm",
    "job_types/roguetown/peasants/beggar.dm",
    "job_types/roguetown/youngfolk/vagabond/beggar.dm",
    "job_types/roguetown/adventurer/types/wretch/berserker.dm",
    "job_types/roguetown/adventurer/types/wretch/blackoak.dm",
    "job_types/roguetown/mercenaries/classes/blackoak.dm",
    "job_types/roguetown/yeomen/blacksmith.dm",
    "job_types/roguetown/peasants/brewer.dm",
    "job_types/roguetown/adventurer/types/antag/brigand.dm",
    "job_types/roguetown/adventurer/types/pilgrim/builder.dm",
    "job_types/roguetown/youngfolk/vagabond/busker.dm",
    "job_types/roguetown/courtier/butler.dm",
    "job_types/roguetown/nobility/captain.dm",
    "job_types/roguetown/garrison/manorguard/cavalry.dm",
    "job_types/roguetown/courtier/chaplain.dm",
    "job_types/roguetown/adventurer/types/pilgrim/cheesemaker.dm",
    "job_types/roguetown/youngfolk/churchling.dm",
    "job_types/roguetown/adventurer/types/combat/cleric.dm",
    "job_types/roguetown/nobility/clerk.dm",
    "job_types/roguetown/mercenaries/classes/condottiero.dm",
    "job_types/roguetown/Inquisition/orthoclasses/confessor.dm",
    "job_types/roguetown/nobility/consort.dm",
    "job_types/roguetown/peasants/cook.dm",
    "job_types/roguetown/courtier/councillor.dm",
    "job_types/roguetown/youngfolk/vagabond/courier.dm",
    "job_types/roguetown/adventurer/types/special/courtagent.dm",
    "job_types/roguetown/yeomen/crier.dm",
    "job_types/roguetown/mercenaries/classes/crocs.dm",
    "job_types/roguetown/adventurer/types/special/crusader.dm",
    "job_types/roguetown/trader/cuisiner.dm",
    "job_types/roguetown/adventurer/types/migrant/czwarteki/czwartekiheir.dm",
    "job_types/roguetown/adventurer/types/migrant/czwarteki/czwartekihussar.dm",
    "job_types/roguetown/adventurer/types/migrant/czwarteki/czwartekilord.dm",
    "job_types/roguetown/adventurer/types/migrant/czwarteki/czwartekiretainer.dm",
    "job_types/roguetown/adventurer/types/migrant/czwarteki/czwartekiservant.dm",
    "job_types/roguetown/youngfolk/vagabond/deprived.dm",
    "job_types/roguetown/adventurer/types/wretch/deserter.dm",
    "job_types/roguetown/mercenaries/classes/desertrider.dm",
    "job_types/roguetown/youngfolk/vagabond/destitute_scholar.dm",
    "job_types/roguetown/Inquisition/orthoclasses/disciple.dm",
    "job_types/roguetown/trader/doomsayer.dm",
    "job_types/roguetown/church/druid.dm",
    "job_types/roguetown/adventurer/types/pilgrim/drunkard.dm",
    "job_types/roguetown/garrison/dungeoneer.dm",
    "job_types/roguetown/adventurer/types/combat/foreigner/eastern.dm",
    "job_types/roguetown/adventurer/types/combat/foreigner/etrusca.dm",
    "job_types/roguetown/youngfolk/vagabond/excommunicado.dm",
    "job_types/roguetown/youngfolk/vagabond/failed_apprentice.dm",
    "job_types/roguetown/mercenaries/classes/ferentia.dm",
    "job_types/roguetown/adventurer/types/pilgrim/fisher.dm",
    "job_types/roguetown/garrison/manorguard/footman.dm",
    "job_types/roguetown/mercenaries/classes/forlorn.dm",
    "job_types/roguetown/mercenaries/classes/freifechter.dm",
    "job_types/roguetown/adventurer/types/antag/gnoll.dm",
    "job_types/roguetown/adventurer/types/antag/gnoll/gnoll_berserker.dm",
    "job_types/roguetown/adventurer/types/antag/gnoll/gnoll_impure.dm",
    "job_types/roguetown/adventurer/types/antag/gnoll/gnoll_knight.dm",
    "job_types/roguetown/adventurer/types/antag/gnoll/gnoll_shaman.dm",
    "job_types/roguetown/adventurer/types/antag/gnoll/gnoll_templar.dm",
    "job_types/roguetown/youngfolk/vagabond/goatherd.dm",
    "job_types/roguetown/other/goblin.dm",
    "job_types/roguetown/garrison/manorguard/gormless.dm",
    "job_types/roguetown/other/greater_skeleton.dm",
}

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


def remaining_batch() -> list[str]:
    files = sorted(
        p.relative_to(SRC_ROOT).as_posix()
        for p in SRC_ROOT.rglob("*.dm")
        if p.relative_to(SRC_ROOT).as_posix() not in PROCESSED
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

    report_path = ROOT / "tools" / "batch4_part2_apply_report.txt"
    report_path.write_text("\n".join(report_lines), encoding="utf-8", newline="")
    print(f"CHANGED_FILES={changed_files}")
    print(f"WROTE {report_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
