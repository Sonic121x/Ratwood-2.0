/atom/movable/screen/alert/status_effect/buff/magic_flight
	name = "Flight"
	desc = "Magic suspends me above the earth, letting me fly freely."
	icon_state = "buff"

/datum/status_effect/buff/magic_flight
	id = "magic_flight"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic_flight
	duration = 60 SECONDS
	var/mob/living/flier
	var/obj/effect/flyer_shadow/shadow
	var/was_flying = FALSE
	var/was_marked_flying = FALSE

/datum/status_effect/buff/magic_flight/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	if(new_owner)
		was_flying = !!(new_owner.movement_type & FLYING)
		was_marked_flying = !!new_owner.flying
	return ..()

/datum/status_effect/buff/magic_flight/on_apply()
	. = ..()
	flier = owner
	if(!flier)
		return FALSE

	flier.setMovetype(flier.movement_type | FLYING)
	flier.flying = TRUE
	ADD_TRAIT(flier, TRAIT_INFINITE_STAMINA, MAGIC_TRAIT)
	UnregisterSignal(flier, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_LIVING_UPDATE_TURF_MOVESPEED,
	))
	RegisterSignal(flier, COMSIG_MOVABLE_MOVED, PROC_REF(check_movement))
	RegisterSignal(flier, COMSIG_LIVING_UPDATE_TURF_MOVESPEED, PROC_REF(on_turf_movespeed_update))

	if(!was_flying)
		animate(flier, pixel_y = flier.pixel_y + 3, time = 6, loop = -1)
		animate(pixel_y = flier.pixel_y - 3, time = 6)

	update_shadow()
	to_chat(flier, span_notice("Magic lifts me from the ground, and my body answers with effortless flight."))
	return TRUE

/datum/status_effect/buff/magic_flight/on_remove()
	. = ..()
	if(!flier)
		return

	UnregisterSignal(flier, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_LIVING_UPDATE_TURF_MOVESPEED,
	))
	QDEL_NULL(shadow)
	REMOVE_TRAIT(flier, TRAIT_INFINITE_STAMINA, MAGIC_TRAIT)

	if(!was_flying)
		animate(flier)
		flier.setMovetype(flier.movement_type & ~FLYING)
		var/turf/tile_under_flier = get_turf(flier)
		if(tile_under_flier)
			tile_under_flier.zFall(flier)
	if(!was_marked_flying)
		flier.flying = FALSE

	to_chat(flier, span_warning("The magic holding me aloft fades, and I drift back toward the ground."))
	flier = null

/datum/status_effect/buff/magic_flight/proc/check_movement(datum/source)
	SIGNAL_HANDLER
	update_shadow()

/datum/status_effect/buff/magic_flight/proc/update_shadow()

	if(!flier || was_flying)
		return

	var/turf/cur_turf = get_turf(flier)
	if(!cur_turf)
		return

	if(!shadow)
		shadow = new /obj/effect/flyer_shadow(cur_turf, flier)

	while(isopenspace(cur_turf))
		var/turf/temp_turf = GET_TURF_BELOW(cur_turf)
		if(!temp_turf || isclosedturf(temp_turf))
			break
		cur_turf = temp_turf

	shadow.forceMove(cur_turf)

/datum/status_effect/buff/magic_flight/proc/on_turf_movespeed_update()
	SIGNAL_HANDLER
	return TURF_MOVESPEED_BLOCKED

/obj/effect/proc_holder/spell/invoked/flight
	name = "Flight"
	desc = "Lets the target fly freely for 60 seconds through magical force alone."
	cost = 6
	releasedrain = 10
	chargetime = 6 SECONDS
	recharge_time = 2 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "haste"
	spell_tier = 3
	invocations = list("凌空而起！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_MEDIUM
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	gesture_required = TRUE
	range = 7
	miracle = FALSE
	xp_gain = TRUE
	mod_spell = TRUE
	mod_spell_learnable = TRUE

/obj/effect/proc_holder/spell/invoked/flight/cast(list/targets, mob/living/user = usr)
	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		revert_cast()
		return FALSE

	var/mob/living/spelltarget = target_atom
	var/already_enchanted = spelltarget.has_status_effect(/datum/status_effect/buff/magic_flight)
	spelltarget.apply_status_effect(/datum/status_effect/buff/magic_flight, 30 SECONDS)
	playsound(get_turf(spelltarget), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)

	if(spelltarget == user)
		if(already_enchanted)
			user.visible_message(span_notice("[user] renews the invisible force bearing [user.p_them()] aloft."))
			to_chat(user, span_notice("I renew the magic of flight around myself."))
		else
			user.visible_message(span_notice("[user] rises from the ground on unseen currents of magic."))
			to_chat(user, span_notice("Magic gathers beneath me and lifts me into free flight."))
	else
		if(already_enchanted)
			user.visible_message(span_notice("[user] renews the flight spell around [spelltarget]."))
			to_chat(user, span_notice("I renew the magic of flight on [spelltarget]."))
			to_chat(spelltarget, span_notice("The magic of flight swells anew around me."))
		else
			user.visible_message(span_notice("[user] gestures sharply, and [spelltarget] is lifted aloft by pure magic."))
			to_chat(user, span_notice("I bind a current of magic to [spelltarget], lifting [spelltarget.p_them()] into flight."))
			to_chat(spelltarget, span_notice("Invisible magic gathers beneath me and lifts me into flight."))

	return TRUE
