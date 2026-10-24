#define FROST_OVERLAY_COLOR rgb(136, 191, 255)
#define FROST_BURST_IMMUNITY_DURATION (15 SECONDS)
#define FROST_BURST_IMMUNITY_KEY "frost_burst_immunity"

/proc/apply_frost_stack(mob/living/target, stacks = 1)
	if(!isliving(target))
		return
	var/final_tier = 0
	for(var/i in 1 to stacks)
		if(target.has_status_effect(/datum/status_effect/debuff/frosted3))
			// Fourth stack - burst for burn damage and clear all frost
			if(target.mob_timers[FROST_BURST_IMMUNITY_KEY] && world.time < target.mob_timers[FROST_BURST_IMMUNITY_KEY])
				target.apply_status_effect(/datum/status_effect/debuff/frosted3)
				var/remaining = round((target.mob_timers[FROST_BURST_IMMUNITY_KEY] - world.time) / 10)
				target.balloon_alert_to_viewers("<font color='#4cadee'>寒霜适应（[remaining] 秒）</font>")
				final_tier = max(final_tier, 3)
				break
			// Burst
			remove_all_frost_stacks(target)
			target.apply_status_effect(/datum/status_effect/debuff/exposed)
			target.mob_timers[FROST_BURST_IMMUNITY_KEY] = world.time + FROST_BURST_IMMUNITY_DURATION
			target.visible_message(span_danger("[target]身上的寒霜使其暴露破绽并减速！"), span_userdanger("寒霜暴露了我的弱点，拖慢了我的动作！"))
			target.balloon_alert_to_viewers("<font color='#4cadee'>冰碎——破绽暴露！</font>")
			playsound(get_turf(target), 'sound/spellbooks/crystal.ogg', 80, TRUE)
			target.Slowdown(2)
			final_tier = 0
			break
		if(target.has_status_effect(/datum/status_effect/debuff/frosted2))
			target.remove_status_effect(/datum/status_effect/debuff/frosted2)
			target.apply_status_effect(/datum/status_effect/debuff/frosted3)
			final_tier = 3
			continue
		if(target.has_status_effect(/datum/status_effect/debuff/frosted1))
			target.remove_status_effect(/datum/status_effect/debuff/frosted1)
			target.apply_status_effect(/datum/status_effect/debuff/frosted2)
			final_tier = 2
			continue
		target.apply_status_effect(/datum/status_effect/debuff/frosted1)
		final_tier = max(final_tier, 1)
	// Single alert for the final tier reached (burst handles its own alert)
	switch(final_tier)
		if(1)
			target.balloon_alert_to_viewers("<font color='#4cadee'>寒霜 I（速度 -1）！</font>")
		if(2)
			target.balloon_alert_to_viewers("<font color='#4cadee'>寒霜 II（速度 -2，减速 x1.1）！</font>")
		if(3)
			target.balloon_alert_to_viewers("<font color='#4cadee'>寒霜 III（速度 -2，减速 x1.2）！</font>")

/// Decrement one frost stack from the target. Used by fire spells.
/// Returns TRUE if a stack was removed.
/proc/remove_frost_stack(mob/living/target)
	if(!isliving(target))
		return FALSE
	if(target.has_status_effect(/datum/status_effect/debuff/frosted3))
		target.remove_status_effect(/datum/status_effect/debuff/frosted3)
		target.apply_status_effect(/datum/status_effect/debuff/frosted2)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/frosted2))
		target.remove_status_effect(/datum/status_effect/debuff/frosted2)
		target.apply_status_effect(/datum/status_effect/debuff/frosted1)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/frosted1))
		target.remove_status_effect(/datum/status_effect/debuff/frosted1)
		return TRUE
	return FALSE

/// Check if the target has any frost stacks.
/proc/has_frost_stacks(mob/living/target)
	if(!isliving(target))
		return FALSE
	return target.has_status_effect(/datum/status_effect/debuff/frosted1) || \
		target.has_status_effect(/datum/status_effect/debuff/frosted2) || \
		target.has_status_effect(/datum/status_effect/debuff/frosted3)

/// Returns the current frost stack count (0-3).
/proc/get_frost_stacks(mob/living/target)
	if(!isliving(target))
		return 0
	if(target.has_status_effect(/datum/status_effect/debuff/frosted3))
		return 3
	if(target.has_status_effect(/datum/status_effect/debuff/frosted2))
		return 2
	if(target.has_status_effect(/datum/status_effect/debuff/frosted1))
		return 1
	return 0

/// Remove all frost stacks. Used by fire damage and frost burst to cleanse frost.
/proc/remove_all_frost_stacks(mob/living/target)
	if(!isliving(target))
		return
	target.remove_status_effect(/datum/status_effect/debuff/frosted3)
	target.remove_status_effect(/datum/status_effect/debuff/frosted2)
	target.remove_status_effect(/datum/status_effect/debuff/frosted1)

// --- Status Effects ---

/datum/status_effect/debuff/frosted1
	id = "frosted1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/frosted1
	duration = 15 SECONDS
	effectedstats = list(STATKEY_SPD = -1)

/atom/movable/screen/alert/status_effect/debuff/frosted1
	name = "寒霜"
	desc = "寒意渗入骨髓。"
	icon_state = "debuff"

/datum/status_effect/debuff/frosted1/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.add_atom_colour(FROST_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)
	target.update_vision_cone()

/datum/status_effect/debuff/frosted1/on_remove()
	var/mob/living/target = owner
	target.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, FROST_OVERLAY_COLOR)
	target.update_vision_cone()
	. = ..()

/datum/status_effect/debuff/frosted2
	id = "frosted2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/frosted2
	duration = 15 SECONDS
	effectedstats = list(STATKEY_SPD = -2)

/atom/movable/screen/alert/status_effect/debuff/frosted2
	name = "寒霜 II"
	desc = "严寒深入体内，我的动作变得迟缓。"
	icon_state = "debuff"

/datum/status_effect/debuff/frosted2/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.add_atom_colour(FROST_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)
	target.update_vision_cone()

/datum/status_effect/debuff/frosted2/on_remove()
	var/mob/living/target = owner
	target.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, FROST_OVERLAY_COLOR)
	target.update_vision_cone()
	. = ..()

/datum/status_effect/debuff/frosted2/nextmove_modifier()
	return 1.1

/datum/status_effect/debuff/frosted3
	id = "frosted3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/frosted3
	duration = 15 SECONDS
	effectedstats = list(STATKEY_SPD = -2)

/atom/movable/screen/alert/status_effect/debuff/frosted3
	name = "寒霜 III"
	desc = "寒冷彻骨，我几乎无法动弹。"
	icon_state = "debuff"

/datum/status_effect/debuff/frosted3/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.add_atom_colour(FROST_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)
	target.update_vision_cone()

/datum/status_effect/debuff/frosted3/on_remove()
	var/mob/living/target = owner
	target.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, FROST_OVERLAY_COLOR)
	target.update_vision_cone()
	. = ..()

/datum/status_effect/debuff/frosted3/nextmove_modifier()
	return 1.2

// Temp visuals

/obj/effect/temp_visual/telegraph/ice
	icon = 'icons/effects/effects.dmi'
	icon_state = "frost"
	light_outer_range = 2
	light_color = "#4cadee"
	duration = 11
	layer = MASSIVE_OBJ_LAYER
	plane = GAME_PLANE

/obj/effect/temp_visual/snap_freeze
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	name = "涌动的奥术寒冰"
	desc = "快躲开！"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER

#undef FROST_OVERLAY_COLOR
#undef FROST_BURST_IMMUNITY_DURATION
#undef FROST_BURST_IMMUNITY_KEY
