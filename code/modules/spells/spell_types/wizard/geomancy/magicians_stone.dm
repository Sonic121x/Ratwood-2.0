/datum/action/cooldown/spell/magicians_stone
	button_icon = 'icons/mob/actions/mage_geomancy.dmi'
	name = "法师之石"
	desc = "从大地中拔出数块石头，使其在脚边显现。"
	fluff_desc = "法师之砖的前身，或许是现存最古老的戏法之一。\
	最初的法师目睹有人用石头砸开别人的脑袋，并想象用魔法照做时，它也许便诞生了。\
	如法师之砖一样，它不受反魔法影响：向他人脑袋掷石的欲望如此原始，其魔法版本\
	不过是人类意志的延伸。不同之处在于，它需要很久才能再次施放；召出的石头\
	也是真实的物质。幸好，它的产石效率远不及采石场，世界各地的石工得以安心。"
	button_icon_state = "magicians_stone"
	sound = 'sound/items/stonestone.ogg'
	spell_color = GLOW_COLOR_EARTHEN
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("石块，升起。")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 2 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/stone_count_min = 3
	var/stone_count_max = 5

/datum/action/cooldown/spell/magicians_stone/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	var/count = rand(stone_count_min, stone_count_max)
	var/turf/T = user.drop_location()
	var/handed = FALSE

	for(var/i in 1 to count)
		var/obj/item/natural/stone/S = new /obj/item/natural/stone(T)
		if(!handed && user.put_in_hands(S))
			handed = TRUE

	playsound(user, 'sound/foley/stone_scrape.ogg', 50, TRUE)
	owner.visible_message(span_notice("[owner]握紧[owner.p_their()]的拳头，[count] 块石头从大地中挣出。"), span_notice("我从大地中拔出 [count] 块石头。"))

	return TRUE
