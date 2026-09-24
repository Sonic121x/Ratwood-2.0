// ============================================================================
// 变换药水 (Polymorph Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 触发：5 级"力量"气味 + 水70/魔力药水30；技能：大师。
// 效果：饮下后立即随机变身为一种野生动物（猫/鹿兔/蝙蝠/狼/羚鹿/熊），药效期间保持兽形；
//       药剂消化完毕自动恢复人形。变形复用原版 wildshape_transformation/wildshape_untransform 系统。
// ----------------------------------------------------------------------------
// 机制说明：
//   变形调用 wildshape_transformation() 将玩家变成 /mob/living/carbon/human/species/wildshape 的子类；
//   原身(含此药剂的残余量)被存入兽形体内(stored_mob)，试剂在原身中继续代谢——代谢完毕时
//   on_mob_end_metabolize 在原身上触发，通过 M.loc 找到裹着它的兽形并调用 wildshape_untransform() 恢复人形。
//   若兽形期间死亡，也可通过 wildshape 自带的 death()→wildshape_untransform 安全退出。
// 框架见 refining_framework.dm。
// ============================================================================

// 中文：可随机变身的动物列表。
GLOBAL_LIST_INIT(polymorph_animal_forms, list(
	/mob/living/carbon/human/species/wildshape/cat,		// 猫 —— 小巧、潜行、敏捷。
	/mob/living/carbon/human/species/wildshape/cabbit,		// 鹿兔 —— 极快、脆弱、可爱。
	/mob/living/carbon/human/species/wildshape/bat,			// 蝙蝠 —— 能飞、极脆。
	/mob/living/carbon/human/species/wildshape/volf,		// 狼 —— 速度、咬击、群体。
	/mob/living/carbon/human/species/wildshape/saiga,		// 羚鹿 —— 速度、角击。
	/mob/living/carbon/human/species/wildshape/bear,		// 熊 —— 壮硕、近战、缓慢。
))

// 中文：消化速度——每单位约维持 6 秒。30 单位 ≈ 180 秒(3 分钟)的兽形体验。
#define POLYMORPH_SECONDS_PER_UNIT 6

// 中文：成品试剂——变换药水。
/datum/reagent/polymorph_potion
	name = "变换药水"										// In-game name (Polymorph Potion).
	description = "循力量的气息、以清水与魔力药水为底精炼的斑斓药水，液面不停变幻着色彩。饮下后身躯将扭曲重塑为荒野中随机一种走兽飞禽的形态——直至药力散尽、人形方复。"	// Flavour + hint.
	reagent_state = LIQUID									// Drinkable liquid.
	color = "#ff00ff"										// Vivid shifting magenta/purple.
	taste_description = "仿佛舌头变成了一只活物"				// Taste: like the tongue has become a living creature.
	// 中文：消化速度 = 每单位 6 秒。30u × 6s = 180s(3分钟)。
	metabolization_rate = REAGENTS_METABOLISM * 2 / POLYMORPH_SECONDS_PER_UNIT	// 1 unit per 6 seconds.
	alpha = 200

// 中文：代谢开始时——随机选取一种动物并调用 wildshape_transformation() 变形。
//       变形后原身被存入兽形体内、试剂在原身中继续代谢；当试剂消化完毕，on_mob_end_metabolize 触发还原。
/datum/reagent/polymorph_potion/on_mob_metabolize(mob/living/carbon/M)
	. = ..()												// Base setup.
	if(!M || QDELETED(M))									// Guard against missing/deleted mob.
		return
	// 中文：只有人类才能使用变换药水。
	if(!ishuman(M))											// Non-humans cannot wildshape.
		to_chat(M, span_warning("变换药水的魔力对你的身体毫无反应……"))
		return
	var/mob/living/carbon/human/H = M						// Typed for wildshape_transformation.
	// 中文：已经在兽形中 → 不再叠加变形(避免无限套娃)。
	if(istype(H, /mob/living/carbon/human/species/wildshape))	// Already in animal form.
		to_chat(H, span_warning("我已然是兽形之身，再饮一瓶也是徒劳。"))
		return
	// 中文：随机选取一种动物形态。
	var/picked_shape = pick(GLOB.polymorph_animal_forms)	// Roll the dice for a random animal.
	H.visible_message(span_warning("[H]的身形猛然扭曲、皮肉翻涌！"), span_userdanger("药水滑入喉咙的瞬间，我的身体开始剧烈翻转变幻……"))
	// ★核心★ 调用原版 wildshape 变身——原身被封入兽形、试剂在原身中继续代谢。
	H.wildshape_transformation(picked_shape)				// Transform into a random animal.
	// 中文：兽形也不应再喝变换药水（兽形也是 wildshape 子类，上方 istype 检查可拦住）。

// 中文：每代谢一拍——无需额外动作，试剂的消化在原身中自动进行(原身虽在兽形体内但仍在被 SSmobs 处理)。
/datum/reagent/polymorph_potion/on_mob_life(mob/living/carbon/M)
	return ..()												// Let metabolism tick down naturally in the stored original body.

// 中文：代谢结束(原身中试剂耗尽)——找到包裹原身的兽形并触发 wildshape_untransform 恢复人形。
/datum/reagent/polymorph_potion/on_mob_end_metabolize(mob/living/carbon/M)
	if(!M || QDELETED(M))									// Guard: original body still exists?
		return ..()
	// 中文：wildshape_transformation 将原身 forceMove 进兽形；故 M.loc 即为那只兽形。
	var/mob/living/carbon/human/species/wildshape/W = M.loc	// The wildshape animal that holds us.
	if(istype(W))											// Confirmed: loc is indeed a wildshape.
		W.wildshape_untransform()							// Return to human form.
	else													// Edge case: wildshape destroyed some other way.
		M.visible_message(span_warning("[M]的身形挣扎着想要恢复，却似乎被卡住了……"))
	return ..()												// Let the base finish up.

// ============================================================================
// 配方：★按气味等级①★ 5 级"力量"气味 + 底料(清水 70 + 魔力药水 30) → 变换药水 30。技能：大师。
// ----------------------------------------------------------------------------
// 中文：
//   · "力量"是原版【力量药剂(str_potion)】配方的 smells_like，尚未被任何精炼配方占用。
//     带此气味的现成材料有 铁粉(irondust)[major,3]、巨人骨(giantbone)[major,3]、
//     矮草(dwarfgrass)[med,2] 等。例：铁粉(3)+矮草(2)=5 即满足"5 级力量"门槛。
//   · 底料用现成试剂：清水 70 + 魔力药水 30，无酒精 → 非酒基。
// ============================================================================
/datum/alch_refining_formula/polymorph
	name = "变换药水"											// Formula name.
	required_scent = "力量"									// Require the "strength" scent (vanilla str_potion, unused)...
	required_scent_points = 5								// ...at level 5.
	required_base = list(/datum/reagent/water = 70,			// 70 water...
						/datum/reagent/medicine/manapot = 30)	// ...+ 30 Mana Potion.
	output_reagents = list(/datum/reagent/polymorph_potion = 30)	// Refined output: 30u.
	skill_required = SKILL_LEVEL_MASTER						// Master gate.
	smells_like = "野性的气息"									// Success scent.

#undef POLYMORPH_SECONDS_PER_UNIT