/datum/sex_action/manticore_tailjob_solo
	parent_type = /datum/sex_action/tailmaw
	name = "用尾口自慰"
	category = SEX_CATEGORY_HANDS
	user_sex_part = SEX_PART_COCK | SEX_PART_TAIL_MAW // only user part to avoid self-targeting restrictions
	solo = TRUE

/datum/sex_action/manticore_tailjob_solo/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴绽开，尾口向下罩住[user.p_their()]肉棒……"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/manticore_tailjob_solo/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = do_subtle

	var/chosen_verb = pick(list("用[user.p_their()]尾巴套弄[user.p_their()]肉棒", "将[user.p_their()]尾口罩在[user.p_their()]肉棒上揉动", "挺动腰身，抽插[user.p_their()]尾口"))
	user.sexcon_action_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)][chosen_verb]……"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.generic_sex_noise()

	user.sexcon.perform_sex_action(user, 2, 0, TRUE)

	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

	user.sexcon.suppress_moan = FALSE

/datum/sex_action/manticore_tailjob_solo/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴伴着湿润的啪声松开[user.p_their()]肉棒。"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/manticore_tailjob_solo/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
