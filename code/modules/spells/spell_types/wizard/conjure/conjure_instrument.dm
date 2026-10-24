/datum/action/cooldown/spell/conjure_instrument
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	name = "召唤乐器"
	desc = "在手中召出自选的乐器。\n\
	召出新的乐器或解除法术绑定时，原乐器会消失。"
	button_icon_state = "conjinstrum"
	sound = 'sound/magic/buffrollaccent.ogg'
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("演出之时！") // Showtime!
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 1 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1

	point_cost = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/rogue/instrument/conjured_instrument = null

	var/list/instrument = list(
		"Harp" = /obj/item/rogue/instrument/harp,
		"Lute" = /obj/item/rogue/instrument/lute,
		"Accordion" = /obj/item/rogue/instrument/accord,
		"Guitar" = /obj/item/rogue/instrument/guitar,
		"Hurdy-Gurdy" = /obj/item/rogue/instrument/hurdygurdy,
		"Viola" = /obj/item/rogue/instrument/viola,
		"声乐护符" = /obj/item/rogue/instrument/vocals,
		"Psyaltery" = /obj/item/rogue/instrument/psyaltery,
		"Flute" = /obj/item/rogue/instrument/flute,
		"Drum" = /obj/item/rogue/instrument/drum,
		"Shamisen" = /obj/item/rogue/instrument/shamisen,
	)

/datum/action/cooldown/spell/conjure_instrument/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/instrument_choice = input(user, "选择一种乐器", "召唤乐器") as anything in instrument
	if(!instrument_choice)
		return
	if(src.conjured_instrument)
		qdel(src.conjured_instrument)
	instrument_choice = instrument[instrument_choice]

	var/obj/item/rogue/instrument/R = new instrument_choice(user.drop_location())
	if(!QDELETED(R))
		R.AddComponent(/datum/component/conjured_item, GLOW_COLOR_ARCANE, FALSE, user, src)
	user.put_in_hands(R)
	src.conjured_instrument = R
	return TRUE
