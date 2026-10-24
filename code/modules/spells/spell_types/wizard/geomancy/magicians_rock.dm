/datum/action/cooldown/spell/magicians_rock
	button_icon = 'icons/mob/actions/mage_geomancy.dmi'
	name = "法师之岩"
	desc = "从大地中拔出一块巨石，使其在脚边显现。"
	fluff_desc = "若说法师之石诞生于目睹有人用石头砸开另一个人的脑袋，\
	那么法师之岩便诞生于希望那块石头更大一些的念头。\
	它是战斗法师与攻城施法者钟爱的实用法术，不过也常被用来顶住门，\
	或在长途行军时充当座椅。"
	button_icon_state = "magicians_rock"
	sound = 'sound/items/stonestone.ogg'
	spell_color = GLOW_COLOR_EARTHEN
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("巨岩，升起。")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 2 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/magicians_rock/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	var/turf/T = user.drop_location()
	var/obj/item/natural/rock/R = new /obj/item/natural/rock(T)
	user.put_in_hands(R)

	playsound(user, 'sound/foley/stone_scrape.ogg', 50, TRUE)
	owner.visible_message(span_notice("[owner]握紧[owner.p_their()]的拳头，一块巨石从大地中挣出。"), span_notice("我从大地中拔出一块巨石。"))

	return TRUE
