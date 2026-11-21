// ============================================================================
// 哈比的尾口（Tail Maw）器官支持
// ----------------------------------------------------------------------------
// 核心哈比只提供“Harpy Plumage”尾羽定制项，尾口/Manticore 尾巴器官
// (/datum/customizer/organ/tail/manticore) 没有列进哈比的 customizers。
// 这里在物种实例创建后追加，让哈比也能像龙裔/兽裔那样在角色定制里选择
// “Tail Maw”，从而获得 /obj/item/organ/tail/manticore 以及对应的尾口玩法。
// ============================================================================

/datum/species/harpy/New()
	. = ..()
	customizers |= /datum/customizer/organ/tail/manticore
