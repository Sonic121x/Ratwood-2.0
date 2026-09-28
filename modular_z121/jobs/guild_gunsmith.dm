#define TRAIT_Z121_GUNSMITH "枪匠"

// 沿用工会工匠的装备、技能与出生能力，枪匠只追加自己的身份和制造权限。
/datum/advclass/guildsman/artificer/z121_gunsmith
	name = "工会枪匠"
	tutorial = "你曾跟随经验丰富的枪匠学习锻造枪管、修整机匣与校准机括。后来，漂泊的生活将你带到了这里。此地的枪械技艺早已凋零，尚存的火器多靠修补勉强维持，能够制造它们的人更是寥寥无几。为了谋生，也为了不让这门手艺失传，你加入工会，重新拿起工具，让炉火与敲击声再次唤醒那些几乎被遗忘的技艺。"

/datum/advclass/guildsman/artificer/z121_gunsmith/New()
	. = ..()
	// 复制继承的列表，避免向原工会工匠授予枪匠特质。
	traits_applied = traits_applied.Copy()
	traits_applied |= TRAIT_Z121_GUNSMITH

/datum/job/roguetown/guildsman/New()
	. = ..()
	job_subclasses = job_subclasses.Copy()
	job_subclasses |= /datum/advclass/guildsman/artificer/z121_gunsmith

/proc/register_z121_gunsmith_trait()
	GLOB.roguetraits[TRAIT_Z121_GUNSMITH] = span_info("我掌握枪械制造技艺，能够辨识并制作精密的枪械零件，理解各种枪械机括的结构与装配原理。")
