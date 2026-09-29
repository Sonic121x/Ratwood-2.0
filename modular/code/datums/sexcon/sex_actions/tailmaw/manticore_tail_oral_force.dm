/datum/sex_action/manticore_tail_oral_force
	parent_type = /datum/sex_action/tailmaw
	name = "强行用尾口覆住对方的嘴"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_JAWS
	user_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_tail_oral_force/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴抬起，夹住[target]的嘴，尾口绽开后紧紧包住[target]的嘴唇，触须涌过[target]的牙齿。"))

/datum/sex_action/manticore_tail_oral_force/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || user.STASTR > 12)
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_jaw_crush(target)
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]的尾口覆着[target]的嘴轻轻搏动，触须慵懒地探索[target]的舌头与牙龈，分泌出令人酥麻的甜蜜液体。"
		if(SEX_FORCE_MID)
			message = "[user]尾巴里的触须深入[target]口中，缠住[target]的舌头，将其拉入温热湿滑的尾口。"
		if(SEX_FORCE_HIGH)
			message = "[user]的尾口夹紧[target]的脸，触须深深挤入[target]的喉咙，孔口搏动着，将甜腻黏液强行灌入[target]的食道。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]的尾巴将[target]的嘴完全封住，触须扭成令人窒息的一团钻进[target]的喉咙，不断泵出蜜液，直到它冒着泡从[target]的鼻中溢出。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.oralcourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(target, 2, 2, TRUE)
	user.sexcon.perform_sex_action(user, 2, 0, FALSE)
	handle_tailmaw_oral_climax(user, target)

/datum/sex_action/manticore_tail_oral_force/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴松开[target]的嘴，触须逐渐脱离，其间牵着缕缕蜜液与唾液。"))

/datum/sex_action/manticore_tail_oral_force/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()
