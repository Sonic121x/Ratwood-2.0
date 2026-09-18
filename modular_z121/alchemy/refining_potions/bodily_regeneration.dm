// ============================================================================
// 身体再生药剂 (Bodily Regeneration Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 中文总览：
//   触发气味：5 级"潮湿的苔藓"气味(=原版"解毒剂"配方 antidote 的 smells_like，尚无任何精炼配方占用，
//             故为"未被使用的等级5气味"；由现成材料 煤尘[major,3] + 银粉[med,2] = 5 点即可满足)。
//   液体底料：清水 50 + 强效生命药水 30 + 强效耐力药水 30(均为现成试剂，无酒 → 成品【非酒基】)。
//   所需技能：炼金 5 级(SKILL_LEVEL_MASTER=5，即"大师")。
//   效果：饮用并【累计消化满 10 单位】后，一次性【再生所有已失去的四肢】(断掉的手臂/腿会重新长出)。
//   产量：30 单位。
//   框架见 refining_framework.dm(配方以 required_scent 气味档① + required_base 底料 + output_reagents 描述)。
//
//   为什么这样设计：
//     · "潮湿的苔藓"象征自然的萌发与愈合，契合"身体再生"主题，且未与其它精炼配方冲突(见 refining_potions/ 内各
//       required_scent，无一使用它)——满足"任意未使用的等级5气味"要求。
//     · 用【生命+耐力】两味强效药作底，呼应"以生命力与体魄为原料重塑肢体"的意象。
//     · "至少摄入 10 单位才生效"用【累计代谢量 + 一次性闭锁】实现，确保少量误饮不会触发再生。
//   本文件全部位于 modular_z121 之下，符合项目硬性约束。
// ============================================================================


// ============================================================================
// 1) 成品试剂——身体再生药剂(非酒基，普通 /datum/reagent)。
// 中文：每代谢一拍累加"已消化量"，累计 >= 10 单位后触发一次【断肢再生】。
//   涉及的原版接口(只读引用，不修改)：
//     · mob/living/carbon/get_bodypart(zone)   —— 取某部位的肢体对象；返回 null 即"该部位已缺失"。
//     · obj/item/bodypart/attach_limb()       —— 将按当前角色数据创建的肢体接回对应部位。
//     · BODY_ZONE_R_ARM/L_ARM/R_LEG/L_LEG       —— 四肢部位常量(见 __DEFINES；life.dm 断肢再生逻辑同款用法)。
// ============================================================================
/datum/reagent/bodily_regeneration_potion
	name = "身体再生药剂"									// In-game name (Bodily Regeneration Potion).
	description = "循潮湿苔藓的气息、以强效生命与耐力药剂为底精炼而成的翠绿黏稠药液。饮下足量并待其在体内充分吸收后，将循着古老的生机重新生出失去的肢体。"	// Flavour + hint.
	reagent_state = LIQUID									// It's a liquid potion.
	color = "#3fae5a"										// Vital mossy green.
	taste_description = "苔藓与草木汁液的清苦"					// Taste flavour.
	metabolization_rate = REAGENTS_METABOLISM				// Standard metabolism (1 unit per digest tick baseline).
	// 中文：累计已代谢(消化)的总量。因每次代谢约扣除 metabolization_rate，故按其累加≈实际已消化量，
	//       以此判定"是否至少摄入并消化了 10 单位"。
	var/digested = 0										// Total amount metabolized so far.
	// 中文：一次性闭锁标记——再生只触发一次，避免持续代谢时反复刷肢体/刷提示。
	var/regenerated = FALSE									// Ensures the regeneration fires only once.

// 中文：每代谢一拍——累加已消化量；当【消化满 10 单位】且尚未再生过时，执行一次断肢再生。
//   ★错误处理★：先校验 M 有效(存在、未被删除、确为 carbon)，无效则安全跳过，绝不崩溃。
/datum/reagent/bodily_regeneration_potion/on_mob_life(mob/living/carbon/M)
	// 中文：目标缺失/正被删除/非 carbon(没有肢体系统) → 直接交还父类，不做任何再生。
	if(!M || QDELETED(M) || !iscarbon(M))					// Guard against invalid target.
		return ..()
	// 中文：把本拍代谢掉的量累加进"已消化"计数(近似按代谢速率累加)。
	digested += metabolization_rate							// Accumulate digested amount.
	// 中文：消化满 10 单位且未再生过 → 执行一次断肢再生(闭锁后不再重复)。
	if(!regenerated && digested >= 10)						// Threshold reached, once only.
		regenerated = TRUE									// Latch so it never repeats.
		restore_lost_limbs(M)								// Perform the regeneration.
	return ..()												// Let the base reagent finish its metabolize step.

// 中文：核心效果——扫描四肢，凡缺失者逐一重新长出。
//   ★为什么逐一检查★：只补回真正缺失的部位，避免替换现有肢体或重置其外观；
//     用返回值统计成功数，以给出恰当反馈(有断肢→再生提示；本就完好→提示无需再生)。
//   ★错误处理★：目标失效直接返回；每次再生用返回值判定成败，全程不假设一定成功。
/datum/reagent/bodily_regeneration_potion/proc/restore_lost_limbs(mob/living/carbon/M)
	// 中文：二次校验(异步/延迟场景下目标可能已失效)。
	if(!M || QDELETED(M) || !iscarbon(M))					// Safety: target still valid?
		return
	// 中文：可再生的四肢部位列表(手臂、腿)。这些是可被断掉、且能重新生长的部位。
	var/list/limb_zones = list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)	// Regrowable limbs.
	var/restored_count = 0									// How many limbs we actually regrew.
	for(var/zone in limb_zones)								// Check each limb slot.
		// 中文：该部位已存在 → 无需再生，跳过(避免无谓调用)。
		if(M.get_bodypart(zone))							// Limb already present?
			continue
		// 中文：该部位缺失 → 尝试重新生成；成功(返回 1)才计数。
		if(restore_character_limb(M, zone))					// 按当前角色数据再生，成功后才计数。
			restored_count++								// Count the successful regrowth.
	// 中文：根据是否真的补回了肢体给出不同反馈。
	if(restored_count > 0)									// At least one limb regrew.
		M.update_mobility()								// 接回四肢后重新计算站立、行走和手部能力。
		// 中文：刷新外观，让新长出的肢体贴图/装备槽即时生效(仅人类需要重建人体贴图)。
		if(ishuman(M))										// Human sprites must be rebuilt.
			var/mob/living/carbon/human/H = M				// Typed handle.
			H.regenerate_icons()							// Rebuild the body sprite.
			H.update_body_parts(TRUE)						// Refresh body-part overlays.
		to_chat(M, span_userdanger("一股蓬勃的生机自断口涌出，血肉与骨骼重新生长——我失去的肢体回来了！"))	// Self message.
		M.visible_message(span_warning("[M]的断口处涌起翠绿的生机，血肉飞快地重新生长了出来！"))	// Onlookers' message.
	else													// Nothing was missing.
		// 中文：身体本就完好，没有可再生的断肢 → 温和提示，不做任何改动。
		to_chat(M, span_notice("一阵暖流游遍全身，但我的身体本就完好，没有需要再生的地方。"))	// No-op feedback.


// ============================================================================
// 中文：只为缺失部位创建肢体，外观取自本局身体的种族与 DNA，不依赖在线客户端或当前选择的角色存档。
/datum/reagent/bodily_regeneration_potion/proc/restore_character_limb(mob/living/carbon/M, zone)
	if(!M || QDELETED(M) || M.get_bodypart(zone))
		return FALSE
	if(!ishuman(M) || !M.dna?.species)
		return M.regenerate_limb(zone)

	var/mob/living/carbon/human/H = M
	var/datum/species/species = H.dna.species
	var/limb_type = species.bodypart_overrides?[zone]
	// 中文：优先采用种族专用肢体；没有覆盖时，按当前种族特性或 DNA 中保存的腿型选择趾行腿。
	if(!limb_type && ((DIGITIGRADE in species.species_traits) || (("legs" in species.mutant_bodyparts) && H.dna.features["legs"] == "Digitigrade Legs")))
		if(zone == BODY_ZONE_L_LEG)
			limb_type = /obj/item/bodypart/l_leg/digitigrade
		else if(zone == BODY_ZONE_R_LEG)
			limb_type = /obj/item/bodypart/r_leg/digitigrade

	var/obj/item/bodypart/limb
	if(limb_type)
		limb = new limb_type()
	else
		limb = H.newBodyPart(zone, FALSE, FALSE)
	if(!limb)
		return FALSE
	// 中文：四肢药剂不允许种族覆盖生成其他部位，也不替换已经存在的部位。
	if(limb.body_zone != zone)
		qdel(limb)
		return FALSE

	limb.update_limb(FALSE, H)
	// 中文：只复制新生肢体及其附属部位的花纹，避免修改其他肢体或共享 DNA 中的列表。
	limb.markings = H.dna.body_markings?[limb.body_zone]?.Copy()
	limb.aux_markings = H.dna.body_markings?[limb.aux_zone]?.Copy()
	limb.invalidate_limb_cache()
	if(!limb.attach_limb(H, TRUE))
		qdel(limb)
		return FALSE
	return TRUE

// ============================================================================
// 2) 精炼配方——★按气味等级(气味档①)★：5 级"潮湿的苔藓"气味 + 清水50+强效生命30+强效耐力30 → 身体再生药剂。
// 中文："潮湿的苔藓"是原版【解毒剂】配方(antidote)的 smells_like，尚未被任何精炼配方占用；带它的现成材料：
//       煤尘(coaldust, major_pot→antidote = 3 点)、银粉(silverdust, med_pot→antidote = 2 点)，
//       煤尘(3)+银粉(2)=5 点即满足"等级5气味"。
//   底料均为现成试剂：清水、强效生命药水(强效生命灵药 big_health_potion 的产物)、
//                     强效耐力药水(强效耐力灵药 big_stamina_potion 的产物)；三者皆无酒 → 成品非酒基。
// ============================================================================
/datum/alch_refining_formula/bodily_regeneration
	name = "身体再生药剂"									// Formula name (shown on success / in guide).
	// 中文：★气味档①★ 要求"潮湿的苔藓"气味累计达到 5 点(即"等级5、未被使用的气味")。
	required_scent = "潮湿的苔藓"							// Require the "damp moss" scent (antidote's smell, unused)...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points: coaldust 3 + silverdust 2).
	// 中文：★复合底料★ 清水 50 + 强效生命药水 30 + 强效耐力药水 30。
	//       reagent 路径用【具体产出类型】(has_reagent/remove_reagent 为精确类型匹配，非子类感知)。
	required_base = list(/datum/reagent/water = 50,							// 50 water.
						/datum/reagent/medicine/stronghealth = 30,			// 30 Great Life Potion.
						/datum/reagent/medicine/strongstam = 30)			// 30 Great Endurance Potion.
	// 中文：产物——30 单位身体再生药剂。
	output_reagents = list(/datum/reagent/bodily_regeneration_potion = 30)	// Refined output (30 units).
	// 中文：所需技能——炼金 5 级(大师)。
	skill_required = SKILL_LEVEL_MASTER						// Level-5 (Master) alchemy gate.
	// 中文：成功时散发的气味词。
	smells_like = "萌发的生机"								// Success scent.
