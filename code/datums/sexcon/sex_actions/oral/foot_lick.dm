/datum/sex_action/foot_lick
	name = "舔对方的脚"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_FEET
	user_sex_part = SEX_PART_JAWS

/datum/sex_action/foot_lick/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始舔[target]的脚了……"))

/datum/sex_action/foot_lick/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]舔弄着[target]的双脚……"))
	user.sexcon.make_sucking_noise()

/datum/sex_action/foot_lick/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了舔[target]双脚的动作……"))
