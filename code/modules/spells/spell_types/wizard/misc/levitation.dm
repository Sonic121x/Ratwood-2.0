/datum/action/cooldown/spell/levitation
	name = "悬浮术"
	desc = "让你轻盈地漂浮在离地不高处。遗憾的是重力仍会影响你，但脚步会变得无声；漂浮期间你也会处于失衡状态。"
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "rune5"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("我已疲惫。")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/original_pixel_y = 0 // so we can go back to our old position
	var/floating = FALSE
	var/hadtrait = FALSE // failsafe for if someone has silent footsteps so we don't remove it when they stop floating

/datum/action/cooldown/spell/levitation/cast(mob/living/user)
	. = ..()	
	if(floating == FALSE)
		floating = TRUE
		original_pixel_y = user.pixel_y
		animate(user, pixel_y = original_pixel_y + 4, time = 0, loop = -1)
		animate(pixel_y = original_pixel_y - 2, time = 15, loop = -1)
		animate(pixel_y = original_pixel_y + 4, time = 15, loop = -1)
		if(HAS_TRAIT(user, TRAIT_SILENT_FOOTSTEPS))
			hadtrait = TRUE
		else
			ADD_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, "floating")
		user.apply_status_effect(STATUS_EFFECT_OFFBALANCED, -1, "floatingoff")
		to_chat(user, span_notice("我开始轻轻漂浮在空中。"))
		return TRUE
	else
		floating = FALSE
		animate(user, time = 0)
		animate(user, pixel_y = original_pixel_y, time = 5)
		if(hadtrait == FALSE)
			REMOVE_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, "floating")
		user.apply_status_effect(STATUS_EFFECT_OFFBALANCED, 1, "floatingoff")
		to_chat(user, span_notice("我降回地面。"))
		return TRUE
