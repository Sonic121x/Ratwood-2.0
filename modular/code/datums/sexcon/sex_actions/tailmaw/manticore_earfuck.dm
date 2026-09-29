/datum/sex_action/manticore_earfuck
	parent_type = /datum/sex_action/tailmaw
	name = "用触须插弄对方的耳朵"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_TAIL_MAW
	var/wound_type = /datum/wound/fracture/head/ears

/datum/sex_action/manticore_earfuck/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]的尾巴抬起，吞住[target]的头，骨质板片紧紧合拢，一簇欲火难耐的触须开始探入[target.p_their()]耳朵。"))

/datum/sex_action/manticore_earfuck/proc/apply_force_effects(mob/living/carbon/human/target, force)
	var/obj/item/organ/ears/ears = target.getorganslot(ORGAN_SLOT_EARS)
	if(!ears || ears.damage_multiplier <= 0)
		return

	var/blurriness = 0
	var/ringing_volume = 0
	switch(force)
		if(SEX_FORCE_LOW)
			ringing_volume = 10
		if(SEX_FORCE_MID)
			blurriness = 2
			ringing_volume = 20
		if(SEX_FORCE_HIGH)
			blurriness = 5
			ringing_volume = 35
		if(SEX_FORCE_EXTREME)
			blurriness = 8
			ringing_volume = 50
			target.apply_status_effect(/datum/status_effect/knot_fucked_stupid)
		if(SEX_FORCE_LUDICROUS)
			blurriness = 10
			ringing_volume = 65
			target.apply_status_effect(/datum/status_effect/knot_fucked_stupid)

	if(blurriness > target.eye_blurry)
		target.set_blurriness(blurriness)

	if(ringing_volume && world.time >= target.mob_timers["manticore_earfuck_ringing"])
		target.mob_timers["manticore_earfuck_ringing"] = world.time + 10 SECONDS
		target.playsound_local(target, 'sound/combat/bombard/flash_ring.ogg', ringing_volume, FALSE)

/datum/sex_action/manticore_earfuck/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	try_tailmaw_bedbreaker_wound(user, target, BODY_ZONE_HEAD, wound_type)
	apply_force_effects(target, user.sexcon.force)
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]尾部的触须带着小心而甜腻的动作，[user.sexcon.get_generic_force_adjective()]抽插着[target]的耳朵，每根蠕动的触须都在内部留下轻微酥麻，以及沉重、令人不适的压力。"
		if(SEX_FORCE_MID)
			message = "[user]的触须[user.sexcon.get_generic_force_adjective()]侵入[target.p_their()]耳道，耳鸣充斥着[target]的脑海。这股压力很不对劲，一阵令人晕眩的朦胧恶心感在[target.p_their()]眼后积聚。"
		if(SEX_FORCE_HIGH)
			message = "数十根触须蠕动着穿过[target]的耳膜，[user.sexcon.get_generic_force_adjective()]摩擦[target.p_their()]大脑，将令人迷醉的有毒黏液涂满柔软的脑回。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]的尾口[user.sexcon.get_generic_force_adjective()]夹紧[target]的头部两侧，触须蜂拥钻入[target.p_their()]头颅。[target]的听觉在冲击下崩溃；意识被震耳欲聋的鸣响取代，震荡般的压力钻入[target.p_their()]颅骨。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.oralcourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(target, 2, 0, TRUE)
	user.sexcon.perform_sex_action(user, 2, 0, FALSE)
	target.sexcon.handle_passive_ejaculation()
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)
	return TRUE

/datum/sex_action/manticore_earfuck/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]的尾巴从[target]头上退开，触须从[target.p_their()]遭到摧残的耳中抽出，留下毒液、鲜血与颅内液体混成的浊液不断渗出。"))

/datum/sex_action/manticore_earfuck/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.finished_check() || target.sexcon.finished_check()
