/datum/sex_action/manticore_tail_oral_receive
	parent_type = /datum/sex_action/tailmaw
	name = "舔舐对方的尾口"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_JAWS
	target_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_tail_oral_receive/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]将[user.p_their()]脸埋入[target]绽开的尾口，舌头探过板片，触须吸住[user.p_their()]嘴唇。"))

/datum/sex_action/manticore_tail_oral_receive/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]轻柔地舔舐[target]的尾口，舌头描摹着板片的边缘，触须缠住[user.p_their()]下巴，品尝肌肤与咸味。"
		if(SEX_FORCE_MID)
			message = "[user]将[user.p_their()]舌头深入[target]的尾巴，触须缠住湿润的舌肌，将它拉向更深处，蜜液涌满[user.p_their()]嘴巴。"
		if(SEX_FORCE_HIGH)
			message = "[user]不顾一切地饥渴舔弄[target]的尾口，舌头来回深入，触须抽打、吮吸着[user.p_their()]嘴唇，双方的脸都沾满甜腻蜜液。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]将[user.p_their()]脸深深埋入[target]的尾巴，尾口夹住了[user.p_their()]头颅，触须覆满舌头与嘴唇的每一寸，孔口试图将[user.p_their()]整颗头吞下。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.oralcourse_noise(user, TRUE)
	user.sexcon.perform_sex_action(target, 3, 0, FALSE)
	handle_tailmaw_oral_climax(target, user)

/datum/sex_action/manticore_tail_oral_receive/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]将[user.p_their()]湿淋淋的脸从[target]的尾口中抽出，下巴滴着甜腻蜜液，触须奋力追逐着[user.p_them()]。"))

/datum/sex_action/manticore_tail_oral_receive/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()
