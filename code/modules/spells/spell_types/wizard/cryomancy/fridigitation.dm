/datum/action/cooldown/spell/fridigitation
	button_icon = 'icons/mob/actions/mage_cryomancy.dmi'
	name = "食物冷冻术"
	desc = "食物冷藏术的进阶版本。\n\
	将食物彻底冻实，大幅延长保存期限。\n\
	（机制说明：仅对成品食物有效，对农产品无效；完全移除腐烂计时。）"
	fluff_desc = "对古老戏法『食物冷藏术』的新近改良。在格伦泽霍夫的一次饥荒中，\
	天穹学院试图改进广泛使用的冷藏戏法。经过针对\
	伊特鲁斯卡商会及其巫师的多年谍报行动，以及该商会对阿普费尔魏因海姆向风郡国贸易的短暂封锁，\
	学院终于复现并改良了『高等食物冷藏术』，将其命名为食物冷冻术。效果十分直接：\
	将食物冻得近乎岩石般坚硬；只要保存得当，便能存放多年。\
	代价则是巫师们仍在设法改善的『冻灼』效应：\
	它令一些食物失去大部分乃至全部风味，水果、农产品与原料受影响尤其严重。"
	button_icon_state = "fridigitation"
	sound = 'sound/misc/bamf.ogg'
	spell_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 5

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("严霜呼啸！") // Icy Scream/Cry (get it, ice scream, ice cream.)
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 2

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/fridigitation/cast(atom/cast_on, mob/user = usr)
	. = ..()
	if(istype(cast_on, /obj/item/reagent_containers/food/snacks/rogue))
		var/obj/item/reagent_containers/food/snacks/rogue/F = cast_on
		var/turf/T = get_turf(F)
		F.rotprocess = null
		F.add_filter("fridigitation_glow", 2, list("type" = "outline", "color" = "#87CEEB", "alpha" = 150, "size" = 1))
		if(T)
			var/mutable_appearance/chilly = mutable_appearance('icons/effects/effects.dmi', "mist", layer = 10)
			T.add_overlay(chilly)
			addtimer(CALLBACK(T, TYPE_PROC_REF(/atom, cut_overlay), chilly), 1 SECONDS)
		to_chat(user, "[F.name]被冻住了，保存期限大幅延长。")
		F.name = "[F.name]（冷冻）"
		return TRUE
	else
		to_chat(user, span_warning("那不是食物冷冻术的有效目标。"))
		return FALSE
