/datum/sex_action/manticore_maw2pit
	parent_type = /datum/sex_action/tailmaw
	name = "用尾口吮吸对方的腋下"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_CHEST
	user_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_maw2pit/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]的尾口贴着[target]抬起的手臂收拢，吸住对方的腋下，触须开始将性液涂满气味浓烈的肌肤，使其泛起湿光。"))

/datum/sex_action/manticore_maw2pit/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!can_perform(user, target))
		return FALSE
	..()
	var/armpit_description = user.sexcon.get_armpit_description(target)
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]的尾口[user.sexcon.get_generic_force_adjective()]磨蹭着[target]的臂下，将[target.p_their()][armpit_description]吸入其中，随后松开，让肌肤发出湿润的+啪+声！"
		if(SEX_FORCE_MID)
			message = "触须舔舐、抚弄着[target]的[armpit_description]，[user.sexcon.get_generic_force_adjective()]吮去[target.p_their()]皮肤上的盐分，尾苞则温热而紧密地吸附着。"
		if(SEX_FORCE_HIGH)
			message = "[user]的尾巴[user.sexcon.get_generic_force_adjective()]夹在[target]的臂下，触须将亮晶晶的毒液涂上[target.p_their()][armpit_description]，尾口贪婪地吸入汗水与蜜液混合的浓烈气味。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "尾巴[user.sexcon.get_generic_force_adjective()]摩擦着[target]的[armpit_description]，黏液四溢。触须伸出，缠住[target]的肩膀，[user]用[target.p_their()]腋下取悦着自己的尾穴。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.oralcourse_noise(user, TRUE)
	user.sexcon.perform_sex_action(target, 1, 0, TRUE)
	user.sexcon.perform_sex_action(user, 1, 0, FALSE)
	target.sexcon.handle_passive_ejaculation()
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)
	return TRUE

/datum/sex_action/manticore_maw2pit/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]的尾巴伴着湿润的啪声松开[target]的腋下，触须拖曳着离去，留下受蹂躏的肌肤阵阵酥麻，沾满[user.p_their()]尾穴的湿滑分泌物。"))

/datum/sex_action/manticore_maw2pit/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.finished_check() || target.sexcon.finished_check()
