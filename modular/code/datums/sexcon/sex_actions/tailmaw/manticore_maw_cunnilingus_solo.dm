/datum/sex_action/manticore_maw_cunnilingus_solo
	parent_type = /datum/sex_action/tailmaw
	name = "用尾口舔舐自己的阴部"
	category = SEX_CATEGORY_HANDS
	user_sex_part = SEX_PART_CUNT | SEX_PART_TAIL_MAW // only user part to avoid self-targeting restrictions
	solo = TRUE

/datum/sex_action/manticore_maw_cunnilingus_solo/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴绽开，尾口紧紧罩住[user.p_their()]阴部……"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/manticore_maw_cunnilingus_solo/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = do_subtle

	var/chosen_verb = pick(list("用尾巴里的触须舔舐[user.p_their()]阴唇", "将[user.p_their()]尾口罩在[user.p_their()]阴部上揉动", "摆动[user.p_their()]髋部，在[user.p_their()]尾巴上磨蹭"))
	user.sexcon_action_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)][chosen_verb]……"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.generic_sex_noise()

	user.sexcon.perform_sex_action(user, 2, 0, TRUE)

	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

	user.sexcon.suppress_moan = FALSE

/datum/sex_action/manticore_maw_cunnilingus_solo/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴伴着湿润的叹息声松开[user.p_their()]阴部。"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/manticore_maw_cunnilingus_solo/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
