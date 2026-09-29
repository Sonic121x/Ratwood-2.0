/datum/sex_action/manticore_maw_rimjob
	parent_type = /datum/sex_action/tailmaw
	name = "用尾口舔弄对方的肛门"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_TAIL_MAW
	target_sex_part = SEX_PART_ANUS

/datum/sex_action/manticore_maw_rimjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]的尾口大张，随后吸住[target]的后臀，好奇的触须开始按摩、探弄对方的肛门。"))

/datum/sex_action/manticore_maw_rimjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!can_perform(user, target))
		return FALSE
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "每根触须都[user.sexcon.get_generic_force_adjective()]沿着满是褶皱的肛缘游走、绕圈，偶尔试探着戳入，挑逗[target]的内部。"
		if(SEX_FORCE_MID)
			message = "伴着急促的啜吸声，数百根触须在[target]的后臀上涂满亮晶晶的黏稠毒液。触须[user.sexcon.get_generic_force_adjective()]逗弄着[target.p_their()]肛门，将肛缘一点点拉开。"
		if(SEX_FORCE_HIGH)
			message = "[user]的尾口紧紧吸住[target]。伸出的触须挤作一团、相互缠绕，[user.sexcon.get_generic_force_adjective()]钻入[target.p_their()]后穴，在这团蠕动的触须周围将其痛苦地撑开。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "触须深入钻探，在[target]的肠道中蠕动前行，[user.sexcon.get_generic_force_adjective()]刮擦肠壁，粗大的触须团将肛门撑得大张，使血肉几乎裂开。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(target, 2, 0, TRUE)
	user.sexcon.perform_sex_action(user, 1, 0, FALSE)
	target.sexcon.handle_passive_ejaculation()
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)
	return TRUE

/datum/sex_action/manticore_maw_rimjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]的尾口伴着湿润的叹息声松开[target]，触须从[target.p_their()]痛苦地撑开、淌着液体的肛门中滑出。"))

/datum/sex_action/manticore_maw_rimjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.finished_check() || target.sexcon.finished_check()
