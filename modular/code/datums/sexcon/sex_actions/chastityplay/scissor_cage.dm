/datum/sex_action/chastityplay/scissor_cage
	name = "隔着对方贞操带磨蹭"
	user_sex_part = SEX_PART_CUNT
	user_needs_functional = TRUE
	target_sex_part = SEX_PART_CUNT
	target_needs_chastity = TRUE

/datum/sex_action/chastityplay/scissor_cage/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]贴近[target]，将[user.p_their()]裸露的阴部紧紧压上[target]贞操带的正面。"))

/datum/sex_action/chastityplay/scissor_cage/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]让[user.p_their()]裸露的阴部沿着[target]贞操带的硬质挡板缓慢磨转，徒劳追逐着那冰冷金属不肯给予的摩擦……"))
	user.sexcon.outercourse_noise(target, TRUE)
	user.sexcon.do_thrust_animate(target)
	user.sexcon.perform_sex_action(user, 1.8, 0, TRUE)
	user.sexcon.perform_sex_action(target, 1.5, 1, TRUE)
	user.sexcon.handle_passive_ejaculation(target)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/scissor_cage/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]向后仰身，从[target]的贞操带上抬离，满脸潮红却依旧不得满足。"))

/datum/sex_action/chastityplay/scissor_cage/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
