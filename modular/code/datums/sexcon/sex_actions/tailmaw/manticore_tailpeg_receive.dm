/datum/sex_action/manticore_tailpeg_receive
	parent_type = /datum/sex_action/tailmaw
	name = "插弄对方的尾口"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	user_sex_part = SEX_PART_COCK
	user_needs_functional = TRUE
	target_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_tailpeg_receive/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]掰开[target]尾巴上的板片，将[user.p_their()]肉棒埋入等待着的尾口，触须立即饥渴地吸附上来。"))

/datum/sex_action/manticore_tailpeg_receive/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]轻轻挺入[target]的尾口，里面的触须温热地裹着[user.p_their()]肉棒，一阵阵搏动榨取。"
		if(SEX_FORCE_MID)
			message = "[user]越发渴求地抽插[target]的尾巴，尾口收紧回应，触须紧紧螺旋缠住[user.p_their()]肉棒。"
		if(SEX_FORCE_HIGH)
			message = "[user]猛撞着[target]的尾口，每次冲刺都让孔口发出淫靡的湿响，里面的触须扭动、抓握着。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]将[target]的尾巴当作肉棒套，不顾一切地猛撞尾口，触须挣扎着抓握，却又被这股蛮力碾压。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(user, 3, 0, TRUE)
	handle_tailmaw_ejaculation(user, target, user, target)
	user.sexcon.perform_sex_action(target, 2.4, 7, FALSE)
	target.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_tailpeg_receive/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]将[user.p_their()]肉棒从[target]的尾口中抽出，发出湿滑的啪声，蜜液仍顽固地牵丝相连。"))

/datum/sex_action/manticore_tailpeg_receive/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.finished_check()
