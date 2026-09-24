// ============================================================================
// 抗火药水 (Fire Resistance Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 触发：5 级"火焰"气味 + 水70/魔力药水30；技能：专家。
// 效果：代谢期间【完全免疫火焰伤害】——不被点燃、不受任何烧伤(/burn)影响。
//       复用原版 TRAIT_NOFIRE（原版抗火buff /datum/status_effect/buff/alch/fire_resist 也用此trait）。
// 框架见 refining_framework.dm。
// ============================================================================

// 中文：消化速度——每单位约维持 3 秒。30 单位 ≈ 90 秒(1.5 分钟)的火焰免疫。
#define FIRE_RESIST_SECONDS_PER_UNIT 3

// 中文：成品试剂——抗火药水。
/datum/reagent/medicine/fire_resistance_potion
	name = "抗火药水"										// In-game name (Fire Resistance Potion).
	description = "循火焰的气息、以清水与魔力药水为底精炼的赤橙色药水。饮下后皮肤宛如罩上一层无形的隔热纱，烈焰不能伤其分毫。"	// Flavour + hint.
	reagent_state = LIQUID									// Drinkable liquid.
	color = "#ff7300"										// Fire-orange.
	taste_description = "喉咙里翻滚着一股灼热的暖流"			// Taste: a hot, rolling warmth.
	// 中文：消化速度 = 每单位 3 秒。
	metabolization_rate = REAGENTS_METABOLISM * 2 / FIRE_RESIST_SECONDS_PER_UNIT	// 1 unit per 3 seconds.
	alpha = 200

// 中文：代谢开始时——挂载 TRAIT_NOFIRE，使饮者完全免疫火焰(不被点燃、不受任何烧伤)。
/datum/reagent/medicine/fire_resistance_potion/on_mob_metabolize(mob/living/carbon/M)
	. = ..()												// Base setup.
	if(!M || QDELETED(M))									// Guard against missing/deleted mob.
		return
	if(!HAS_TRAIT(M, TRAIT_NOFIRE))							// Avoid double-applying.
		ADD_TRAIT(M, TRAIT_NOFIRE, type)					// Fire immunity — same trait as the vanilla fire_resist buff.
	to_chat(M, span_notice("一层无形的热纱笼罩了全身，火焰仿佛再也触碰不到我。"))	// Onset feedback.

// 中文：代谢结束——拔除 TRAIT_NOFIRE，恢复可被烧伤的状态。
/datum/reagent/medicine/fire_resistance_potion/on_mob_end_metabolize(mob/living/carbon/M)
	if(M && !QDELETED(M))									// Valid target still exists.
		REMOVE_TRAIT(M, TRAIT_NOFIRE, type)					// Remove fire immunity.
		to_chat(M, span_warning("那层护体的热纱消散了，火焰重新变得危险。"))	// Fade feedback.
	return ..()												// Let the base finish up.

// ============================================================================
// 配方：★按气味等级①★ 5 级"火焰"气味 + 底料(清水 70 + 魔力药水 30) → 抗火药水 30。技能：专家。
// ----------------------------------------------------------------------------
// 中文：
//   · "火焰"是原版【抗火药剂(fire_potion)】配方的 smells_like，已被 vanilla 配方用作自身的气味；
//     带此气味的现成材料有 火之精质(firedust minor=1)、地狱尘(infernaldust major=3)、太阳尘(solardust major=3)。
//     取 地狱尘(3)+太阳尘(3)=6 ≥ 5 即满足"5 级火焰"门槛。
//   · 底料用现成试剂：清水 70 + 魔力药水 30，总量 100 ≥ 精炼锅 waterneed(60)，无酒精 → 非酒基。
// ============================================================================
/datum/alch_refining_formula/fire_resistance
	name = "抗火药水"											// Formula name.
	required_scent = "火焰"									// Require the "flame" scent (from vanilla fire_potion)...
	required_scent_points = 5								// ...at level 5.
	required_base = list(/datum/reagent/water = 70,			// 70 water...
						/datum/reagent/medicine/manapot = 30)	// ...+ 30 Mana Potion.
	output_reagents = list(/datum/reagent/medicine/fire_resistance_potion = 30)	// Refined output: 30u.
	skill_required = SKILL_LEVEL_EXPERT						// Expert gate.
	smells_like = "温暖的热浪"									// Success scent.

#undef FIRE_RESIST_SECONDS_PER_UNIT