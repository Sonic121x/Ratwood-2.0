
/obj/effect/proc_holder/spell/invoked/chokeslam // 1st of the grapple spells, this one does 50 damage and throws the target a good distance.
	name = "锁喉摔"
	desc = "需要强力抓取。短暂蓄势后，将目标摔向地面，使双方倒地并造成耐力伤害。"

	recharge_time = 60 SECONDS
	invocation_type = "emote"
	overlay_icon = 'icons/mob/actions/vampspells.dmi'
	action_icon = 'icons/mob/actions/vampspells.dmi'
	overlay_state = "potence"
	action_icon_state = "potence"
	var/damage = 0

/obj/effect/proc_holder/spell/invoked/chokeslam/cast(list/targets, mob/living/user,)
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

	to_chat(user, span_notice("你开始举起[target]！"))
	to_chat(target, span_userdanger("[user]掐住[target]的喉咙，将其举到半空！"))

	tracker.channeling_throw = TRUE
	user.emote("attack")
	
	// Store original position for animation
	var/original_target_pixel_z = target.pixel_z
	
	// Animate lifting the target upwards
	if(target.lying)
		target.set_resting(FALSE)
	animate(target, pixel_z = original_target_pixel_z + 16, time = 5)
	
	// Then drop back down after a short delay
	var/drop_timer = addtimer(CALLBACK(src, PROC_REF(drop_target), target, original_target_pixel_z), 5, TIMER_STOPPABLE)



	if(user.IsKnockdown()) // can't do it while on the floor.
		tracker.channeling_throw = FALSE
		user.stop_pulling(TRUE)
		to_chat(user, span_notice("我的动作被打断了！"))
		deltimer(drop_timer)
		animate(target, pixel_z = original_target_pixel_z, time = 1 SECONDS) // reset animation
		revert_cast()

		return FALSE

	if(!do_after(user, channel_time, target = target)) //saftey check
		tracker.channeling_throw = FALSE
		deltimer(drop_timer)
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
		target.stamina_add((target.max_stamina - target.stamina) / 2) // some-fucking-how this is how you drain half their current stamina
		to_chat(user, span_notice("[user]掐着[target]的喉咙将其摔倒！"))
		target.Knockdown(2 SECONDS)
		user.Knockdown(2 SECONDS)
		playsound(user, 'sound/combat/tf2crit.ogg', 100, TRUE)
		
	// using spellblade melee thing for the damage and aimed zone.
	var/def_zone = user.zone_selected || BODY_ZONE_CHEST
	target.apply_damage(damage, BRUTE, def_zone)
	tracker.channeling_throw = FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/chokeslam/proc/drop_target(mob/living/target, original_pixel_z)
	animate(target, pixel_z = original_pixel_z, time = 5)

/datum/component/wrestle_combat_tracker // keeps track of if were channeling or not, used for all wrestling spells
	var/channeling_throw = FALSE
