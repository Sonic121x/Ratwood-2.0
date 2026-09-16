/datum/sex_action/rub_body
	name = "抚摸对方身体"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_CHEST
	category = SEX_CATEGORY_HANDS

/datum/sex_action/rub_body/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]的手放到了[target]身上……"))

/datum/sex_action/rub_body/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]抚摸着[target]的身体……"))
	user.sexcon.make_sucking_noise()

	user.sexcon.perform_sex_action(target, 0.5, 0, TRUE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/rub_body/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了抚摸[target]身体的动作……"))

/datum/sex_action/rub_body/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
