/datum/sex_action/kissing
	name = "与对方热吻"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_JAWS
	target_sex_part = SEX_PART_JAWS

/datum/sex_action/kissing/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	user.visible_message(span_warning("[user]开始与[target]热吻……"))

/datum/sex_action/kissing/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]与[target]热吻着……"))
	if(user.sexcon.force > SEX_FORCE_MID)
		user.sexcon.oralcourse_noise(target)
	else
		user.sexcon.make_sucking_noise()

	user.sexcon.perform_sex_action(user, 1, 2, TRUE)
	user.sexcon.handle_passive_ejaculation()

	user.sexcon.perform_sex_action(target, 1, 2, TRUE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/kissing/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	user.visible_message(span_warning("[user]停下了与[target]热吻的动作……"))
