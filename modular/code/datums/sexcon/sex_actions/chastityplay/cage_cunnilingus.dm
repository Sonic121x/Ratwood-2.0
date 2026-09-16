/datum/sex_action/chastityplay/cage_cunnilingus
	name = "隔着贞操带舔弄对方"
	user_sex_part = SEX_PART_JAWS
	target_sex_part = SEX_PART_CUNT
	target_needs_chastity = TRUE
	category = SEX_CATEGORY_PENETRATE

/datum/sex_action/chastityplay/cage_cunnilingus/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]跪了下来，让[user.p_their()]的嘴与[target]的贞操带齐平。"))

/datum/sex_action/chastityplay/cage_cunnilingus/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]将[user.p_their()]的舌头探入[target]贞操带前方的缝隙里，寻找着仅能触及的那一点肌肤……"))
	user.sexcon.oralcourse_noise(target)

	user.sexcon.perform_sex_action(target, 1.8, 0, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/cage_cunnilingus/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]从[target]的贞操带前退开，嘴唇湿润，神情难辨。"))

/datum/sex_action/chastityplay/cage_cunnilingus/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
