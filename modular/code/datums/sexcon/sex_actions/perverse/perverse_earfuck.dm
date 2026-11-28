/datum/sex_action/perverse_earfuck
	parent_type = /datum/sex_action/perverse
	name = "耳交"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_COCK
	user_needs_functional = TRUE
	target_sex_part = SEX_PART_JAWS
	var/wound_type = /datum/wound/fracture/head/ears

/datum/sex_action/perverse_earfuck/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]把阴茎抵在[target]的耳边，用力向前一挺，挤进了耳道。"))

/datum/sex_action/perverse_earfuck/proc/apply_force_effects(mob/living/carbon/human/target, force)
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

	if(ringing_volume && world.time >= target.mob_timers["perverse_earfuck_ringing"])
		target.mob_timers["perverse_earfuck_ringing"] = world.time + 10 SECONDS
		target.playsound_local(target, 'sound/combat/bombard/flash_ring.ogg', ringing_volume, FALSE)

/datum/sex_action/perverse_earfuck/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	try_perverse_bedbreaker_wound(user, target, BODY_ZONE_HEAD, wound_type)
	apply_force_effects(target, user.sexcon.force)
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]的阴茎[user.sexcon.get_generic_force_adjective()]滑入[target]的耳道。一股湿热漫过[target]的头，像是一阵挠不到的怪痒，在脑袋里慢慢散开。"
		if(SEX_FORCE_MID)
			message = "[user]的阴茎[user.sexcon.get_generic_force_adjective()]挤进[target]的耳道，[target]猛地浑身一颤，随即一阵头晕目眩，眼皮不由自主地抽动起来。"
		if(SEX_FORCE_HIGH)
			message = "[user]的阴茎穿过[target]的耳膜，[user.sexcon.get_generic_force_adjective()]向内耳挤压、碾磨。一声湿响过后，[target]什么也听不见了。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user][user.sexcon.get_generic_force_adjective()]钻入那残破的耳腔，灼热感涌遍了[target]的头。[target]只感觉到[user]的阴茎在颅内抽动，再也拼不出一个完整的念头。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.oralcourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(target, 2, 0, TRUE)
	user.sexcon.perform_sex_action(user, 2, 0, FALSE)
	target.sexcon.handle_passive_ejaculation()
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_COCK)
	return TRUE

/datum/sex_action/perverse_earfuck/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]从[target]的耳中抽出阴茎，带出一道混着血的湿痕。"))

/datum/sex_action/perverse_earfuck/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.finished_check() || target.sexcon.finished_check()
