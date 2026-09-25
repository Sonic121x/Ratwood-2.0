
/obj/effect/proc_holder/spell/invoked/stunner // 1st of the grapple spells, this one does 50 damage and throws the target a good distance.
	name = "碎颚摔"
	desc = "需要强力抓取。短暂蓄势后，施展碎颚摔，使双方倒地，并令目标眩晕。"

	recharge_time = 60 SECONDS
	invocation_type = "emote"
	overlay_icon = 'icons/mob/actions/vampspells.dmi'
	action_icon = 'icons/mob/actions/vampspells.dmi'
	overlay_state = "potence"
	action_icon_state = "potence"
	var/damage = 0

/obj/effect/proc_holder/spell/invoked/stunner/cast(list/targets, mob/living/user,)
	if(targets[1] == user)
		to_chat(user, span_notice("你不能和自己摔跤。"))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/target = targets[1]
	if(!ishuman(target))
		to_chat(user, span_warning("此招式只能对人形目标使用！"))
		revert_cast()
		return FALSE

	if(user.pulling != target || user.grab_state < GRAB_AGGRESSIVE)
		to_chat(user, span_warning("你必须先强力抓住[target]，才能施展摔跤招式！"))
		revert_cast()
		return FALSE

	var/datum/component/wrestle_combat_tracker/tracker = user.GetComponent(/datum/component/wrestle_combat_tracker)
	if(!tracker)
		tracker = user.AddComponent(/datum/component/wrestle_combat_tracker)

	var/channel_time = 1 SECONDS

	to_chat(user, span_notice("你用手臂锁住了[target]的脖子！"))
	to_chat(target, span_userdanger("[user]用手臂锁住了你的脖子！"))
	tracker.channeling_throw = TRUE
	user.emote("attack")
	
	// User faces away from target
	var/dir_to_target = get_dir(user, target)
	user.setDir(turn(dir_to_target, 180))
	
	//  user coming close to target
	var/close_time = 4
	var/close_offset = 8
	switch(dir_to_target)
		if(NORTH)
			animate(user, pixel_y = user.pixel_y + close_offset, time = close_time)
		if(SOUTH)
			animate(user, pixel_y = user.pixel_y - close_offset, time = close_time)
		if(EAST)
			animate(user, pixel_x = user.pixel_x + close_offset, time = close_time)
		if(WEST)
			animate(user, pixel_x = user.pixel_x - close_offset, time = close_time)
		if(NORTHEAST)
			animate(user, pixel_x = user.pixel_x + close_offset, pixel_y = user.pixel_y + close_offset, time = close_time)
		if(NORTHWEST)
			animate(user, pixel_x = user.pixel_x - close_offset, pixel_y = user.pixel_y + close_offset, time = close_time)
		if(SOUTHEAST)
			animate(user, pixel_x = user.pixel_x + close_offset, pixel_y = user.pixel_y - close_offset, time = close_time)
		if(SOUTHWEST)
			animate(user, pixel_x = user.pixel_x - close_offset, pixel_y = user.pixel_y - close_offset, time = close_time)
	

	var/original_user_pixel_x = user.pixel_x
	var/original_user_pixel_y = user.pixel_y
	var/original_user_pixel_z = user.pixel_z
	var/original_target_pixel_z = target.pixel_z
	
	
	// lifting both user and target upwards
	animate(user, pixel_z = original_user_pixel_z + 11, time = 5)
	if(target.lying)
		target.set_resting(FALSE)
		
	animate(target, pixel_z = original_target_pixel_z + 11, time = 5) // we shouldnt animate people on the floor because they break. so you body slam them or w/e
	
	//  drop back down after a short delay
	var/drop_timer = addtimer(CALLBACK(src, PROC_REF(drop_both), user, target, original_user_pixel_z, original_target_pixel_z), 5, TIMER_STOPPABLE)



	if(user.IsKnockdown()) // can't do it while on the floor.
		tracker.channeling_throw = FALSE
		user.stop_pulling(TRUE)
		to_chat(user, span_notice("我的动作被打断了！"))
		deltimer(drop_timer)
		animate(user, pixel_x = original_user_pixel_x, pixel_y = original_user_pixel_y, pixel_z = original_user_pixel_z, time = 1 SECONDS) // reset animation
		animate(target, pixel_z = original_target_pixel_z, time = 1 SECONDS) // reset animation
		revert_cast()

		return FALSE

	if(!do_after(user, channel_time, target = target)) //saftey check
		tracker.channeling_throw = FALSE
		deltimer(drop_timer)
		animate(user, pixel_x = original_user_pixel_x, pixel_y = original_user_pixel_y, pixel_z = original_user_pixel_z, time = 1 SECONDS) // reset animation
		animate(target, pixel_z = original_target_pixel_z, time = 1 SECONDS) // reset animation
		revert_cast()

		return FALSE

	// break grab
	user.stop_pulling(TRUE)
	
	// if we dont pause here they don't get tossed, this is also your chance to parry it. (sorry!)
	sleep(0.1 SECONDS)
	
	// Throw the target away from the user and knocks you and the other guy down.
	var/throw_dir = get_dir(user, target)
	var/turf/throw_target = get_ranged_target_turf(target, throw_dir, 3)
	
	

	if(target.has_status_effect(/datum/status_effect/buff/clash)) // if you parry this you knock down the guy and take no damage
		damage = 0
		user.Knockdown(2 SECONDS)
		target.safe_throw_at(throw_target, 2, 4, user, force = MOVE_FORCE_DEFAULT)
		target.remove_status_effect(/datum/status_effect/buff/clash)
		to_chat(user, span_notice("被反制了！"))
		playsound(user, 'sound/combat/crowdcheer.ogg', 100, TRUE) // sick parry dude
	
	else
		target.safe_throw_at(throw_target, 1, 4, user, force = MOVE_FORCE_DEFAULT)
		damage = 50
		
		target.apply_status_effect(/datum/status_effect/debuff/dazed/stunner) // -2 con -2 int for 30 seconds
		target.Knockdown(2 SECONDS)
		user.Knockdown(2 SECONDS)
		to_chat(user, span_notice("[user]对[target]使出了碎颚摔！"))
		playsound(user, 'sound/combat/tf2crit.ogg', 100, TRUE)
		
	// using spellblade melee thing for the damage and aimed zone.
	var/def_zone = user.zone_selected || BODY_ZONE_CHEST
	target.apply_damage(damage, BRUTE, def_zone)
	tracker.channeling_throw = FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/stunner/proc/drop_both(mob/living/user, mob/living/target, original_user_pixel_x, original_user_pixel_y, original_user_pixel_z, original_target_pixel_z)
	animate(user, pixel_x = original_user_pixel_x, pixel_y = original_user_pixel_y, pixel_z = original_user_pixel_z, time = 5)
	animate(target, pixel_z = original_target_pixel_z, time = 5)

/datum/component/wrestle_combat_tracker // keeps track of if were channeling or not, used for all wrestling spells
	channeling_throw = FALSE
