/datum/sex_action/manticore_fist_maw
	parent_type = /datum/sex_action/tailmaw
	name = "拳交对方的尾口"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_fist_maw/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]掰开[target]尾口的板片，将[user.p_their()]拳头推入其中，触须立即蜂拥而上，急切地吸住[user.p_their()]手指。"))

/datum/sex_action/manticore_fist_maw/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]在[target]的尾口内缓缓活动[user.p_their()]手指，触须分别缠住每一根手指，品尝着肌肤，轻轻牵拉。"
		if(SEX_FORCE_MID)
			message = "[user]将[user.p_their()]拳头在[target]的尾巴里来回抽动，尾口内壁紧裹着侵入物收缩，触须将温热甜腻的黏液涂满[user.p_their()]手腕。"
		if(SEX_FORCE_HIGH)
			message = "[user]粗暴地转动拳头，抽插着[target]的尾口，孔口裹着[user.p_their()]手臂发出淫靡水声，触须抓握、吮吸着每一处指节。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]将[user.p_their()]手臂撞入[target]的尾口，直没至肘，肌肉质的内壁以足以造成淤伤的力道挤压着，触须疯狂地扭成一团，吸住[user.p_their()]皮肤。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(target, 2, 3, FALSE)
	target.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_fist_maw/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]将[user.p_their()]手臂从[target]的尾口中抽出，孔口大张着颤抖，触须奋力追逐着退去的手臂。"))

/datum/sex_action/manticore_fist_maw/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()
