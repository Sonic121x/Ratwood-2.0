/proc/z121_get_magic_flight_duration(mob/living/user)
	var/arcane_level = max(user?.get_skill_level(/datum/skill/magic/arcane), 0)
	switch(arcane_level)
		if(0 to 1)
			return 30 SECONDS
		if(2)
			return 60 SECONDS
		if(3)
			return 120 SECONDS
		if(4)
			return 240 SECONDS
		if(5)
			return 360 SECONDS
	return 480 SECONDS

/proc/z121_get_group_magic_flight_duration(mob/living/user)
	return z121_get_magic_flight_duration(user) * 2

/atom/movable/screen/alert/status_effect/buff/magic_flight
	name = "飞行术"
	desc = "魔法将我托离地面，使我得以自由飞行。"
	icon_state = "buff"

/datum/status_effect/buff/magic_flight
	id = "magic_flight"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic_flight
	duration = 60 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = 1 SECONDS
	var/mob/living/flier
	var/obj/effect/flyer_shadow/shadow
	var/was_flying = FALSE
	var/was_marked_flying = FALSE
	var/ending_warning_sent = FALSE
	var/apply_message = "魔法将我托离地面，我的身体也随之轻盈地飞了起来。"
	var/remove_message = "托举我的魔法逐渐消散，我也缓缓落回地面。"
	var/ending_warning_message = "托举我的飞行魔法只剩不到 10 秒了。"

/datum/status_effect/buff/magic_flight/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	if(new_owner)
		was_flying = !!(new_owner.movement_type & FLYING)
		was_marked_flying = !!new_owner.flying
	return ..()

/datum/status_effect/buff/magic_flight/refresh(mob/living/new_owner, new_duration = null)
	ending_warning_sent = FALSE
	if(isnull(new_duration))
		return ..()
	duration = world.time + new_duration

/datum/status_effect/buff/magic_flight/on_apply()
	. = ..()
	flier = owner
	if(!flier)
		return FALSE

	flier.setMovetype(flier.movement_type | FLYING)
	flier.flying = TRUE
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
	to_chat(flier, span_notice(apply_message))
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

	if(!was_flying)
		animate(flier)
		flier.setMovetype(flier.movement_type & ~FLYING)
		var/turf/tile_under_flier = get_turf(flier)
		if(tile_under_flier)
			tile_under_flier.zFall(flier)
	if(!was_marked_flying)
		flier.flying = FALSE

	to_chat(flier, span_warning(remove_message))
	flier = null

/datum/status_effect/buff/magic_flight/proc/check_movement(datum/source)
	SIGNAL_HANDLER
	update_shadow()

/datum/status_effect/buff/magic_flight/tick()
	if(!flier || duration == -1 || ending_warning_sent)
		return

	if(duration - world.time > 10 SECONDS)
		return

	ending_warning_sent = TRUE
	to_chat(flier, span_warning(ending_warning_message))

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
	name = "飞行术"
	desc = "以纯粹魔力让目标自由飞行，持续时间会随施法者的奥术造诣提升。"
	cost = 4
	releasedrain = 10
	chargetime = 6 SECONDS
	recharge_time = 2 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "flight"
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

/obj/effect/proc_holder/spell/invoked/flight/cast(list/targets, mob/living/user = usr)
	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		revert_cast()
		return FALSE

	var/mob/living/spelltarget = target_atom
	var/already_enchanted = spelltarget.has_status_effect(/datum/status_effect/buff/magic_flight)
	var/flight_duration = z121_get_magic_flight_duration(user)
	spelltarget.apply_status_effect(/datum/status_effect/buff/magic_flight, flight_duration)
	playsound(get_turf(spelltarget), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)

	if(spelltarget == user)
		if(already_enchanted)
			user.visible_message(span_notice("[user] 周身那股无形的托举之力再次翻涌起来。"))
			to_chat(user, span_notice("我重新续上了自己身上的飞行术。"))
		else
			user.visible_message(span_notice("[user] 被无形的魔力气流托离地面，缓缓升空。"))
			to_chat(user, span_notice("魔法在我脚下汇聚，将我托入自由飞行。"))
	else
		if(already_enchanted)
			user.visible_message(span_notice("[user] 重新续接了 [spelltarget] 身上的飞行术。"))
			to_chat(user, span_notice("我重新续上了 [spelltarget] 身上的飞行魔法。"))
			to_chat(spelltarget, span_notice("环绕我的飞行魔法再次充盈起来。"))
		else
			user.visible_message(span_notice("[user] 猛然一挥手，[spelltarget] 随即被纯粹的魔力托举升空。"))
			to_chat(user, span_notice("我将一股魔力系在 [spelltarget] 身上，把 [spelltarget.p_them()] 托入空中。"))
			to_chat(spelltarget, span_notice("无形的魔法在我脚下汇聚，将我托入飞行。"))

	return TRUE

// 飞行术专用上下层移动覆盖：飞行移动不消耗体力，其他行为仍按正常规则消耗。
/datum/keybinding/mob/fly_up/down(client/user)
	. = TRUE
	var/mob/flyer = user.mob
	if(!flyer.flying)
		to_chat(flyer, span_red("我并没有在飞！"))
		return
	if(iscarbon(flyer))
		var/mob/living/carbon/carbon_flyer = flyer
		var/turf/open/transparent/openspace/turf_above = get_step_multiz(carbon_flyer, UP)
		if(!carbon_flyer.canZMove(UP, turf_above))
			to_chat(carbon_flyer, span_red("我没法飞到上面去！！"))
			return
		var/atom/movable/pulling = carbon_flyer.pulling
		var/time_taken = 1.5 SECONDS
		if(ismob(pulling))
			time_taken *= 2
		if(!do_after(carbon_flyer, time_taken))
			return
		if(QDELETED(pulling) || carbon_flyer.pulling != pulling)
			pulling = null
		if(ismob(pulling))
			ADD_TRAIT(pulling, TRAIT_PREVENT_Z_FALL, "z_transition")
			pulling.forceMove(turf_above)
		carbon_flyer.forceMove(turf_above)
		for(var/mob/buckled_living as anything in carbon_flyer.buckled_mobs)
			buckled_living.forceMove(turf_above)
		if(pulling)
			carbon_flyer.start_pulling(pulling, state = 1, supress_message = TRUE)
			if(carbon_flyer.pulling == pulling)
				carbon_flyer.buckle_mob(pulling, TRUE, TRUE, FALSE, 0, 0)
				var/obj/item/grabbing/I = carbon_flyer.get_inactive_held_item()
				if(istype(I, /obj/item/grabbing))
					I.icon_state = null
			if(ismob(pulling))
				REMOVE_TRAIT(pulling, TRAIT_PREVENT_Z_FALL, "z_transition")
		to_chat(carbon_flyer, span_notice("我向上飞去。"))
	else if(flyer.flying)
		var/mob/mobius = flyer
		if(mobius.zMove(UP, TRUE))
			to_chat(mobius, span_notice("我向上移动了。"))

/datum/keybinding/mob/fly_down/down(client/user)
	. = TRUE
	var/mob/flyer = user.mob
	if(!flyer.flying)
		to_chat(flyer, span_red("我并没有在飞！"))
		return
	if(iscarbon(flyer))
		var/mob/living/carbon/carbon_flyer = flyer
		var/turf/open/transparent/openspace/turf_below = get_step_multiz(carbon_flyer, DOWN)
		if(!carbon_flyer.canZMove(DOWN, turf_below))
			to_chat(carbon_flyer, span_red("我没法飞到下面去！！"))
			return
		var/atom/movable/pulling = carbon_flyer.pulling
		var/time_taken = 0.75 SECONDS
		if(ismob(pulling))
			time_taken *= 2
		if(!move_after(carbon_flyer, time_taken, target = carbon_flyer))
			return
		turf_below = get_step_multiz(carbon_flyer, DOWN)
		if(!carbon_flyer.canZMove(DOWN, turf_below))
			to_chat(carbon_flyer, span_red("I can't fly down there!!"))
			return
		if(QDELETED(pulling) || carbon_flyer.pulling != pulling)
			pulling = null
		if(ismob(pulling))
			ADD_TRAIT(pulling, TRAIT_PREVENT_Z_FALL, "z_transition")
			pulling.forceMove(turf_below)
		carbon_flyer.forceMove(turf_below)
		for(var/mob/buckled_living as anything in carbon_flyer.buckled_mobs)
			buckled_living.forceMove(turf_below)
		if(pulling)
			carbon_flyer.start_pulling(pulling, state = 1, supress_message = TRUE)
			if(carbon_flyer.pulling == pulling)
				carbon_flyer.buckle_mob(pulling, TRUE, TRUE, FALSE, 0, 0)
				var/obj/item/grabbing/I = carbon_flyer.get_inactive_held_item()
				if(istype(I, /obj/item/grabbing/))
					I.icon_state = null
			if(ismob(pulling))
				REMOVE_TRAIT(pulling, TRAIT_PREVENT_Z_FALL, "z_transition")
		to_chat(carbon_flyer, span_notice("我向下飞去。"))
	else if(flyer.flying)
		var/mob/mobius = flyer
		if(mobius.zMove(DOWN, TRUE))
			to_chat(mobius, span_notice("我向下移动了。"))


