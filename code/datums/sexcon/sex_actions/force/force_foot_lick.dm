/datum/sex_action/force_foot_lick
	name = "强迫对方舔脚"
	check_same_tile = FALSE
	require_grab = TRUE
	stamina_cost = 1.0
	user_sex_part = SEX_PART_FOOT // yes, this is a special part just so you only need one foot out
	target_sex_part = SEX_PART_JAWS

/datum/sex_action/force_foot_lick/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]双脚狠狠顶到了[target]头上！"))

/datum/sex_action/force_foot_lick/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]强迫[target]舔[user.p_their()]双脚。"))
	target.sexcon.make_sucking_noise()

/datum/sex_action/force_foot_lick/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]双脚从[target]头边挪开了。"))
