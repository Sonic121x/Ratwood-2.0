/datum/sex_action/chastityplay/masturbate_cage_anal_other
	name = "挑逗他们的后庭贞操盾"
	category = SEX_CATEGORY_HANDS
	target_sex_part = SEX_PART_ANUS
	target_needs_chastity = TRUE

/datum/sex_action/chastityplay/masturbate_cage_anal_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把手探到[target]身后，摸索[target.p_their()]贞操带后方护盾的边缘。"))

/datum/sex_action/chastityplay/masturbate_cage_anal_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]让[user.p_their()]手指沿着[target]后方护盾的接缝来回游走，朝着挡板贴住肌肤的地方持续压进去……"))
	user.sexcon.perform_sex_action(target, 1.5, 1, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/masturbate_cage_anal_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]手从[target]的后方护盾上抽了回来。"))

/datum/sex_action/chastityplay/masturbate_cage_anal_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
