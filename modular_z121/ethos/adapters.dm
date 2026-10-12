// 成功动作的最小适配；原入口同步由 check_ethos.ps1 校验。
/datum/sex_controller/sex_action_loop()
	// 保留核心动作循环。
	if(!z121_ethos_adult_enabled(user) || !z121_ethos_adult_enabled(target))
		stop_current_action()
		return
	var/performed_action_type = current_action
	var/datum/sex_action/action = SEX_ACTION(current_action)
	var/base_speed = -1
	var/base_force = -1
	var/base_knot_mode = FALSE
	var/subtle_message_tick_counter = 0
	var/was_subtle_mode = do_subtle_action // 初始值沿用面板开关。
	show_progress = 1
	suppress_moan = FALSE
	action.on_start(user, target)
	find_occupying_furniture()
	find_occupying_grass()
	while(TRUE)
		if(!z121_ethos_adult_enabled(user) || !z121_ethos_adult_enabled(target)) // 双方都必须满足参与条件。
			break
		if(!user.stamina_add(action.stamina_cost * get_stamina_cost_multiplier()))
			break
		if(!do_after(user, (action.do_time / get_speed_multiplier()), target = target, progress = show_progress))
			break
		// 等待期间任一方关闭功能或改变角色条件，均不能继续执行本次动作。
		if(!z121_ethos_adult_enabled(user) || !z121_ethos_adult_enabled(target))
			break
		if(current_action == null || performed_action_type != current_action)
			break
		if(!can_perform_action(current_action, user.incapacitated()))
			break
		if(action.is_finished(user, target))
			break
		if(desire_stop)
			break
		var/current_knot_mode = FALSE
		if(action.knot_on_finish)
			if((action.user_sex_part & SEX_PART_COCK) && knot_penis_type())
				current_knot_mode = do_knot_action
			else if((action.target_sex_part & SEX_PART_COCK) && target?.sexcon?.knot_penis_type())
				current_knot_mode = do_knot_action_as_bottom
		var/show_action_message = (speed != base_speed || force != base_force)
		if(current_knot_mode != base_knot_mode)
			show_action_message = TRUE
		if(!do_subtle_action && was_subtle_mode)
			show_action_message = TRUE
		if(!show_action_message && do_subtle_action)
			subtle_message_tick_counter++
			if(subtle_message_tick_counter >= SEX_SUBTLE_MESSAGE_REPEAT_INTERVAL)
				show_action_message = TRUE
				subtle_message_tick_counter = 0
		else if(show_action_message)
			subtle_message_tick_counter = 0
		was_subtle_mode = do_subtle_action
		base_speed = speed
		base_force = force
		base_knot_mode = current_knot_mode
		suppress_action_messages = !show_action_message
		find_ringing_collar()
		var/mob/living/carbon/human/activity_actor = user
		var/mob/living/carbon/human/activity_target = target
		var/datum/z121_ethos_activity/activity = new(src, activity_actor, activity_target, current_action)
		try
			action.on_perform(activity_actor, activity_target)
		catch(var/exception/error)
			qdel(activity)
			stop_current_action()
			throw error
		qdel(activity)
		do_visual_effects(target, action)
		suppress_action_messages = FALSE
		// 动作执行后可能已经满足结束条件。
		if(action.is_finished(user, target))
			break
		if(!action.continous)
			break
	stop_current_action()

// 钱币拆分回退保持核心物品拾取、存储取出与危险接触检查。
/obj/item/roguecoin/proc/z121_ethos_pickup(mob/user)
	. = call(src, /atom/proc/attack_hand)(user)
	if(.)
		return
	if(!user)
		return
	if(anchored)
		return

	if(twohands_required)
		if(user.get_num_arms() < 2)
			to_chat(user, span_warning("[src]太过笨重，没法单手拿起！"))
			return
		var/obj/item/twohanded/required/H
		H = user.get_inactive_held_item()
		if(get_dist(src,user) > 1)
			return
		if(H != null)
			to_chat(user, span_warning("[src]太过笨重，没法单手拿起！"))
			return

	if(w_class == WEIGHT_CLASS_GIGANTIC)
		return

	if(resistance_flags & ON_FIRE)
		var/mob/living/carbon/C = user
		var/can_handle_hot = FALSE
		if(!istype(C))
			can_handle_hot = TRUE
		else if(C.gloves && (C.gloves.max_heat_protection_temperature > 360))
			can_handle_hot = TRUE
		else if(HAS_TRAIT(C, TRAIT_RESISTHEAT) || HAS_TRAIT(C, TRAIT_RESISTHEATHANDS))
			can_handle_hot = TRUE

		if(can_handle_hot)
			extinguish()
			user.visible_message(span_warning("[user]扑灭了[src]上的火。"))
		else
			user.visible_message(span_warning("[user]在扑灭[src]上的火时烧伤了[user.p_their()]手！"))
			extinguish()
			var/obj/item/bodypart/affecting = C.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
			if(affecting && affecting.receive_damage( 0, 5 ))
				C.update_damage_overlays()
			return

	if(acid_level > 20 && !ismob(loc))
		var/mob/living/carbon/C = user
		if(istype(C))
			if(!C.gloves || (!(C.gloves.resistance_flags & (UNACIDABLE|ACID_PROOF))))
				to_chat(user, span_warning("[src]上的酸液灼伤了我的手！"))
				var/obj/item/bodypart/affecting = C.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
				if(affecting && affecting.receive_damage( 0, 5 ))
					C.update_damage_overlays()

	if(!(interaction_flags_item & INTERACT_ITEM_ATTACK_HAND_PICKUP))
		return
	if(inv_storage_delay && SEND_SIGNAL(loc, COMSIG_CONTAINS_STORAGE))
		if(!move_after(user, inv_storage_delay, target = iscarbon(loc) ? src : src.loc, progress = TRUE))
			return
	SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_TAKE, src, user.loc, TRUE)
	if(QDELETED(src))
		return

	if(throwing)
		throwing.finalize(FALSE)
	if(loc == user)
		if(!allow_attack_hand_drop(user) || !user.temporarilyRemoveItemFromInventory(src))
			return

	pickup(user)
	add_fingerprint(user)
	if(!user.put_in_active_hand(src, FALSE, FALSE))
		user.dropItemToGround(src)
	else
		if(twohands_required)
			wield(user)

// 炼药锅完整替代流程仍执行核心灯具燃料消耗，避免再次执行旧锅的炼制流程。
/obj/machinery/light/proc/z121_ethos_light_process()
	if(!on || initial(fueluse) <= 0)
		return PROCESS_KILL
	fueluse = max(fueluse - 10, 0)
	if(fueluse == 0)
		burn_out()

// 药剂代谢沿用核心流程，只在单味药剂实际生效时建立治疗来源。
/datum/reagents/metabolize(mob/living/carbon/C, can_overdose = FALSE, liverless = FALSE)
	var/list/cached_reagents = reagent_list
	var/list/cached_addictions = addiction_list
	if(C)
		expose_temperature(C.bodytemperature, 0.25)
		if(HAS_TRAIT(C, TRAIT_CRACKHEAD))
			can_overdose = FALSE
	var/need_mob_update = 0
	for(var/reagent in cached_reagents)
		var/datum/reagent/R = reagent
		if(QDELETED(R.holder))
			continue

		if(!C)
			C = R.holder.my_atom

		if(C && R)
			if(C.reagent_check(R) != TRUE)
				if(liverless && !R.self_consuming)
					continue
				if(!R.metabolizing)
					R.metabolizing = TRUE
					R.on_mob_metabolize(C)
				if(can_overdose)
					if(R.overdose_threshold)
						if(R.volume >= R.overdose_threshold && !R.overdosed)
							R.overdosed = 1
							need_mob_update += R.overdose_start(C)
							log_game("[key_name(C)] has started overdosing on [R.name] at [R.volume] units.")
					if(R.addiction_threshold)
						if(R.volume >= R.addiction_threshold && !is_type_in_list(R, cached_addictions))
							var/datum/reagent/new_reagent = new R.type()
							cached_addictions.Add(new_reagent)
							log_game("[key_name(C)] has become addicted to [R.name] at [R.volume] units.")
					if(R.overdosed)
						need_mob_update += R.overdose_process(C)
					if(is_type_in_list(R,cached_addictions))
						for(var/addiction in cached_addictions)
							var/datum/reagent/A = addiction
							if(istype(R, A))
								A.addiction_stage = -15
				need_mob_update += z121_ethos_metabolize_reagent(R, C)

	if(can_overdose)
		if(addiction_tick == 6)
			addiction_tick = 1
			for(var/addiction in cached_addictions)
				var/datum/reagent/R = addiction
				if(C && R)
					R.addiction_stage++
					switch(R.addiction_stage)
						if(1 to 10)
							need_mob_update += R.addiction_act_stage1(C)
						if(10 to 20)
							need_mob_update += R.addiction_act_stage2(C)
						if(20 to 30)
							need_mob_update += R.addiction_act_stage3(C)
						if(30 to 40)
							need_mob_update += R.addiction_act_stage4(C)
						if(40 to INFINITY)
							remove_addiction(R)
		addiction_tick++
	if(C && need_mob_update)
		C.updatehealth()
		C.update_mobility()
		C.update_stamina()
	update_total()

