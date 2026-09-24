// ============================================================================
// 迷药 (Knockout Potion / Sleeping Draught) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 触发：5 级"平静"气味 + 水70/毒药30；技能：专家。
// 效果：饮下后立即陷入强制昏睡——无视盔甲的睡眠免疫(TRAIT_SLEEPIMMUNE)，
//       Sleeping() 以 ignore_canstun=TRUE 调用，确保任何防御都无法阻止昏迷。
//       药效持续期间持续刷新睡眠计时器，药剂耗尽时醒来。
// 框架见 refining_framework.dm。
// ============================================================================

// 中文：消化速度——每单位约维持 6 秒。30 单位 ≈ 180 秒(3 分钟)的强制昏睡。
#define KNOCKOUT_SECONDS_PER_UNIT 6

// 中文：成品试剂——迷药。
/datum/reagent/knockout_potion
	name = "迷药"											// In-game name (Knockout Potion).
	description = "循平静的气息、以清水与毒药为底精炼的淡紫色糖浆。饮下后一股倦意迅速席卷全身，整个人不受控制地沉沉睡去——无论穿着多厚的盔甲都抵挡不住这股药力。"	// Flavour + hint.
	reagent_state = LIQUID									// Drinkable liquid.
	color = "#c8a2c8"										// Pale purple (sleepy lavender).
	taste_description = "令人昏昏欲睡的甘甜"					// Taste: sleep-inducing sweetness.
	// 中文：消化速度 = 每单位 6 秒。
	metabolization_rate = REAGENTS_METABOLISM * 2 / KNOCKOUT_SECONDS_PER_UNIT	// 1 unit per 6 seconds.
	alpha = 200

// 中文：代谢开始时——以 ignore_canstun=TRUE 强制施加睡眠，无视 TRAIT_SLEEPIMMUNE/盔甲等一切睡眠免疫。
/datum/reagent/knockout_potion/on_mob_metabolize(mob/living/carbon/M)
	. = ..()												// Base setup.
	if(!M || QDELETED(M))									// Guard against missing/deleted mob.
		return
	// ★核心★ Sleeping(3 分钟, 更新移动力, 无视昏睡免疫)→连盔甲/特质都不挡。
	M.Sleeping(3 MINUTES, TRUE, TRUE)						// Force-sleep: ignore sleep immunity flags/armor.
	M.visible_message(span_warning("[M]眼皮一沉，整个人软软地瘫倒昏睡了过去！"), span_userdanger("一股无法抗拒的倦意吞没了我……"))	// KO feedback.

// 中文：每代谢一拍——持续刷新睡眠计时器，确保药效期间不会被偶然唤醒(外力唤醒仍需 ignore_canstun)。
/datum/reagent/knockout_potion/on_mob_life(mob/living/carbon/M)
	if(!M || QDELETED(M))									// Guard against missing/deleting mob.
		return ..()
	// 中文：每拍把睡眠计时器推后 6 秒(一个消化拍的时长+一些冗余)，维持持续昏睡。
	if(M.AmountSleeping() < 6 SECONDS)						// About to wake up?
		M.Sleeping(6 SECONDS, TRUE, TRUE)					// Push sleep further: keep KO'd while potion lasts.
	return ..()												// Standard metabolism.

// 中文：代谢结束(药剂耗尽/被清除)时——拔除药力睡眠，让玩家自然苏醒。
/datum/reagent/knockout_potion/on_mob_end_metabolize(mob/living/carbon/M)
	if(M && !QDELETED(M))									// Valid target.
		M.SetSleeping(0)									// End the forced sleep.
		M.visible_message(span_warning("[M]缓缓睁开了眼睛。"), span_notice("那股昏沉的倦意终于散去了……"))	// Wake-up feedback.
	return ..()												// Let the base finish up.

// ============================================================================
// 配方：★按气味等级①★ 5 级"平静"气味 + 底料(清水 70 + 毒药 30) → 迷药 30。技能：专家。
// ----------------------------------------------------------------------------
// 中文：
//   · "平静"是原版【镇定剂(calming potion)】配方的 smells_like，尚未被任何精炼配方占用。
//     带此气味的现成材料有 薰衣草(lavender)[major,3]、甘菊(chamomile)[med,2]、
//     薄荷花(poppy)[minor,1] 等。例：薰衣草(3)+甘菊(2)=5 即满足"5 级平静"门槛。
//   · 底料：清水 70 + 毒药(berrypoison) 30。毒药底色与"迷药"主题契合(让人昏迷)。
// ============================================================================
/datum/alch_refining_formula/knockout
	name = "迷药"												// Formula name.
	required_scent = "平静"									// Require the "calm" scent (vanilla calming potion, unused)...
	required_scent_points = 5								// ...at level 5.
	required_base = list(/datum/reagent/water = 70,			// 70 water...
						/datum/reagent/berrypoison = 30)	// ...+ 30 common poison.
	output_reagents = list(/datum/reagent/knockout_potion = 30)	// Refined output: 30u.
	skill_required = SKILL_LEVEL_EXPERT						// Expert gate.
	smells_like = "令人昏昏欲睡的甜味"							// Success scent.

#undef KNOCKOUT_SECONDS_PER_UNIT