// 美德和两种缩小术共用娇小特性，潜行加值不改变角色原有经验。
#define TRAIT_PETITE "娇小"
#define Z121_SMALL_SIZE_SCALE 0.8
#define Z121_SMALL_SIZE_SHIFT ((Z121_SMALL_SIZE_SCALE - 1) * 16)

/datum/virtue/size/small
	name = "小体型"
	desc = "我的身形比常人更加娇小，步履轻盈，也更善于悄无声息地行动。"
	custom_text = "娇小的身躯让我更加灵巧，也更擅长潜行。矮人、侏儒、哥布林、狗头人与小兽裔本就身材矮小，不会因此变得更小。这份天赋无法与巨人的体魄共存。"
	triumph_cost = 0
	added_traits = list(TRAIT_PETITE)
	added_stats = list(STATKEY_SPD = 1)
	incompatible_virtues = list(/datum/virtue/size/giant)
	incompatible_traits = list(TRAIT_BIGGUY, TRAIT_PETITE)

/datum/virtue/size/small/apply_to_human(mob/living/carbon/human/recipient)
	z121_apply_small_size_scale(recipient)

// 按种族类型判断，自动覆盖侏儒和其他子种族，不依赖外观或玩家选择的身高。
/proc/z121_small_size_exempt(mob/living/carbon/target)
	var/datum/species/species = target.dna?.species
	return istype(species, /datum/species/dwarf) \
		|| istype(species, /datum/species/goblinp) \
		|| istype(species, /datum/species/kobold) \
		|| istype(species, /datum/species/anthromorphsmall)

// 返回是否实际缩放，供临时法术在结束时决定是否撤销。
/proc/z121_apply_small_size_scale(mob/living/carbon/target)
	if(z121_small_size_exempt(target))
		return FALSE
	target.transform = target.transform.Scale(Z121_SMALL_SIZE_SCALE, Z121_SMALL_SIZE_SCALE)
	target.transform = target.transform.Translate(0, Z121_SMALL_SIZE_SHIFT)
	target.update_transform()
	return TRUE

/proc/z121_remove_small_size_scale(mob/living/carbon/target)
	// 只撤销本次缩放与脚底对齐位移，保留目标其他来源的变换。
	target.transform = target.transform.Translate(0, -Z121_SMALL_SIZE_SHIFT)
	target.transform = target.transform.Scale(1 / Z121_SMALL_SIZE_SCALE, 1 / Z121_SMALL_SIZE_SCALE)
	target.update_transform()

/proc/register_z121_petite_trait()
	GLOB.roguetraits[TRAIT_PETITE] = span_info("我身形娇小，步履轻盈，更善于隐匿行踪。巨化的魔力无法改变我这副身躯。")

// 模块内扩展统一技能查询，保留原有生产激励和信仰加值。
/datum/skill_holder/get_skill_level(skill)
	var/datum/skill/S = GetSkillRef(skill)
	var/level = known_skills[S] || SKILL_LEVEL_NONE
	if(S?.abstract_type in list(/datum/skill/labor, /datum/skill/craft))
		level += current?.get_inspirational_bonus() || 0
	if(current)
		if(istype(S, /datum/skill/misc/lockpicking) && HAS_TRAIT(current, TRAIT_COMMIE))
			level += 1
		if(istype(S, /datum/skill/misc/music) && HAS_TRAIT(current, TRAIT_XYLIX))
			level += 1
		if(istype(S, /datum/skill/misc/sneaking) && HAS_TRAIT(current, TRAIT_PETITE))
			level += 1
	return clamp(level, SKILL_LEVEL_NONE, SKILL_LEVEL_LEGENDARY)
