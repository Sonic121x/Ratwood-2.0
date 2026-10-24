#define SCORCH_OVERLAY_COLOR rgb(255, 138, 61)
#define SCORCH_BURN_DAMAGE 60

/obj/effect/temp_visual/scorch_flash
	icon = 'icons/mob/OnFire.dmi'
	icon_state = "Generic_mob_burning"
	layer = ABOVE_MOB_LAYER
	duration = 8

/proc/apply_scorch_stack(mob/living/target, stacks = 1, zone_override = null)
	if(!isliving(target))
		return
	new /obj/effect/temp_visual/scorch_flash(get_turf(target))
	var/final_tier = 0
	for(var/i in 1 to stacks)
		if(target.has_status_effect(/datum/status_effect/debuff/scorched4))
			if(apply_scorch_burn(target, zone_override))
				remove_all_scorch_stacks(target)
			break
		if(target.has_status_effect(/datum/status_effect/debuff/scorched3))
			target.remove_status_effect(/datum/status_effect/debuff/scorched3)
			target.apply_status_effect(/datum/status_effect/debuff/scorched4)
			if(apply_scorch_burn(target, zone_override))
				remove_all_scorch_stacks(target)
			final_tier = 4
			break
		if(target.has_status_effect(/datum/status_effect/debuff/scorched2))
			target.remove_status_effect(/datum/status_effect/debuff/scorched2)
			target.apply_status_effect(/datum/status_effect/debuff/scorched3)
			final_tier = 3
			continue
		if(target.has_status_effect(/datum/status_effect/debuff/scorched1))
			target.remove_status_effect(/datum/status_effect/debuff/scorched1)
			target.apply_status_effect(/datum/status_effect/debuff/scorched2)
			final_tier = 2
			continue
		target.apply_status_effect(/datum/status_effect/debuff/scorched1)
		final_tier = max(final_tier, 1)
	switch(final_tier)
		if(1)
			target.balloon_alert_to_viewers("<font color='#ff8a3d'>灼烧 I</font>")
		if(2)
			target.balloon_alert_to_viewers("<font color='#ff8a3d'>灼烧 II</font>")
		if(3)
			target.balloon_alert_to_viewers("<font color='#ff8a3d'>灼烧 III</font>")

/proc/apply_scorch_burn(mob/living/target, zone_override = null)
	if(!isliving(target))
		return FALSE
	var/target_zone = prob(50) ? BODY_ZONE_HEAD : BODY_ZONE_CHEST
	var/aimed_zone = zone_override ? check_zone(zone_override) : null
	if(aimed_zone == BODY_ZONE_HEAD || aimed_zone == BODY_ZONE_CHEST)
		target_zone = aimed_zone
	var/mob/living/carbon/carbon_target
	if(iscarbon(target))
		carbon_target = target
		if(target_zone == BODY_ZONE_HEAD && !carbon_target.get_bodypart(BODY_ZONE_HEAD))
			target_zone = BODY_ZONE_CHEST
	target.apply_damage(SCORCH_BURN_DAMAGE, BURN, target_zone, 0)
	if(carbon_target)
		var/obj/item/bodypart/affecting = carbon_target.get_bodypart(check_zone(target_zone))
		if(affecting)
			var/datum/wound/dynamic/burn/burn_wound = affecting.has_wound(/datum/wound/dynamic/burn)
			if(!burn_wound)
				burn_wound = affecting.add_wound(/datum/wound/dynamic/burn)
			burn_wound?.upgrade(SCORCH_BURN_DAMAGE, 0, FALSE)
	var/hit_zone_name = parse_zone(target_zone)
	target.balloon_alert_to_viewers("<font color='#ff4a2a'>焦化！</font>")
	target.visible_message(
		span_boldwarning("火焰烧穿[target]的护甲，在[hit_zone_name]灼出深深的创口！"),
		span_userdanger("火焰烧穿了我的护甲，在[hit_zone_name]灼出深深的创口！"))
	playsound(get_turf(target), pick('sound/misc/explode/explosionclose (1).ogg', 'sound/misc/explode/explosionclose (2).ogg', 'sound/misc/explode/explosionclose (3).ogg'), 100, TRUE)
	new /obj/effect/temp_visual/fire(get_turf(target))
	new /obj/effect/temp_visual/explosion(get_turf(target))
	return TRUE

/proc/remove_scorch_stack(mob/living/target)
	if(!isliving(target))
		return FALSE
	if(target.has_status_effect(/datum/status_effect/debuff/scorched4))
		target.remove_status_effect(/datum/status_effect/debuff/scorched4)
		target.apply_status_effect(/datum/status_effect/debuff/scorched3)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/scorched3))
		target.remove_status_effect(/datum/status_effect/debuff/scorched3)
		target.apply_status_effect(/datum/status_effect/debuff/scorched2)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/scorched2))
		target.remove_status_effect(/datum/status_effect/debuff/scorched2)
		target.apply_status_effect(/datum/status_effect/debuff/scorched1)
		return TRUE
	if(target.has_status_effect(/datum/status_effect/debuff/scorched1))
		target.remove_status_effect(/datum/status_effect/debuff/scorched1)
		return TRUE
	return FALSE

/proc/has_scorch_stacks(mob/living/target)
	if(!isliving(target))
		return FALSE
	return get_scorch_stacks(target) > 0

/proc/get_scorch_stacks(mob/living/target)
	if(!isliving(target))
		return 0
	if(target.has_status_effect(/datum/status_effect/debuff/scorched4))
		return 4
	if(target.has_status_effect(/datum/status_effect/debuff/scorched3))
		return 3
	if(target.has_status_effect(/datum/status_effect/debuff/scorched2))
		return 2
	if(target.has_status_effect(/datum/status_effect/debuff/scorched1))
		return 1
	return 0

/proc/remove_all_scorch_stacks(mob/living/target)
	if(!isliving(target))
		return
	target.remove_status_effect(/datum/status_effect/debuff/scorched4)
	target.remove_status_effect(/datum/status_effect/debuff/scorched3)
	target.remove_status_effect(/datum/status_effect/debuff/scorched2)
	target.remove_status_effect(/datum/status_effect/debuff/scorched1)

/datum/status_effect/debuff/scorched1
	id = "scorched1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/scorched1
	duration = 15 SECONDS

/atom/movable/screen/alert/status_effect/debuff/scorched1
	name = "灼烧"
	desc = "火舌舔舐着我，但我还能摆脱。"
	icon_state = "debuff"

/datum/status_effect/debuff/scorched1/on_apply()
	. = ..()
	owner.add_atom_colour(SCORCH_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/scorched1/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, SCORCH_OVERLAY_COLOR)
	. = ..()

/datum/status_effect/debuff/scorched2
	id = "scorched2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/scorched2
	duration = 15 SECONDS

/atom/movable/screen/alert/status_effect/debuff/scorched2
	name = "灼烧 II"
	desc = "高温抽走了血肉中的活力。"
	icon_state = "debuff"

/datum/status_effect/debuff/scorched2/on_apply()
	. = ..()
	owner.add_atom_colour(SCORCH_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/scorched2/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, SCORCH_OVERLAY_COLOR)
	. = ..()

/datum/status_effect/debuff/scorched3
	id = "scorched3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/scorched3
	duration = 15 SECONDS

/atom/movable/screen/alert/status_effect/debuff/scorched3
	name = "灼烧 III"
	desc = "灼伤折磨着全身，使我虚弱。"
	icon_state = "debuff"

/datum/status_effect/debuff/scorched3/on_apply()
	. = ..()
	owner.add_atom_colour(SCORCH_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/scorched3/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, SCORCH_OVERLAY_COLOR)
	. = ..()

/datum/status_effect/debuff/scorched4
	id = "scorched4"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/scorched4
	duration = 15 SECONDS

/atom/movable/screen/alert/status_effect/debuff/scorched4
	name = "灼烧 IV"
	desc = "我被火焰彻底吞没，血肉正被烧裂。"
	icon_state = "debuff"

/datum/status_effect/debuff/scorched4/on_apply()
	. = ..()
	owner.add_atom_colour(SCORCH_OVERLAY_COLOR, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/scorched4/on_remove()
	owner.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, SCORCH_OVERLAY_COLOR)
	. = ..()

#undef SCORCH_OVERLAY_COLOR
#undef SCORCH_BURN_DAMAGE
