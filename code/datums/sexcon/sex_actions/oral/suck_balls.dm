/datum/sex_action/suck_balls
	name = "含弄对方睾丸"
	user_sex_part = SEX_PART_JAWS
	target_sex_part = SEX_PART_BALLS

/datum/sex_action/suck_balls/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始含弄[target]的睾丸了……"))

/datum/sex_action/suck_balls/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]含弄着[target]的睾丸……"))
	user.sexcon.oralcourse_noise(user)

	user.sexcon.perform_sex_action(target, 1, 3, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/suck_balls/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了含弄[target]睾丸的动作……"))

/datum/sex_action/suck_balls/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
