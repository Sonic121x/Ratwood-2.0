/datum/action/cooldown/spell/chill_food
	button_icon = 'icons/mob/actions/mage_cryomancy.dmi'
	name = "食物冷藏术"
	desc = "以寒霜冷却一份食物，不影响品质，并延长半天保鲜时间（现实时间 15 分钟）。\
	无法逆转已经发生的腐烂。"
	fluff_desc = "用于保存食物的古老戏法。古时人们\
	将此法术的符文刻在桌上，大量制造冷藏桌来保存食物。\
	如今制作冷藏桌的工艺鲜有传承，价格自然高昂。\
	伊特鲁斯卡贸易公司以研发高等及大师级食物冷藏术闻名，并传授给公司法师，\
	用以保存货物，将优质鲜鱼与水果运往世界各地，高价出售。\
	配格隆黄油的冷藏格隆鳟鱼，在费伦提亚尤其受欢迎。"
	button_icon_state = "chill_food"
	sound = 'sound/spellbooks/crystal.ogg'
	spell_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 1

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("凝冻。")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_POKE
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/chill_food/cast(atom/cast_on)
	. = ..()
	if(!istype(cast_on, /obj/item/reagent_containers/food/snacks))
		to_chat(owner, span_warning("那不是食物。"))
		return FALSE

	var/obj/item/reagent_containers/food/snacks/food = cast_on

	if(!food.rotprocess)
		to_chat(owner, span_warning("[food]不会腐坏。"))
		return FALSE

	// Extend freshness by 15 minutes. Cannot reverse rot already set in.
	food.warming += 15 MINUTES

	new /obj/effect/temp_visual/small_smoke(get_turf(food))
	owner.visible_message(span_notice("[owner]将手拂过[food]，一层薄霜覆上表面，随后消退。"), span_notice("我用一缕寒霜冷却了[food]。"))
	return TRUE
