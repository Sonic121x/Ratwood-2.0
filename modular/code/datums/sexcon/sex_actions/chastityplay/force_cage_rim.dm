/datum/sex_action/chastityplay/force_cage_rim
	name = "强迫他们舔你的贞操盾"
	require_grab = TRUE
	stamina_cost = 1.0
	user_sex_part = SEX_PART_ANUS
	user_needs_chastity = TRUE
	target_sex_part = SEX_PART_JAWS

/datum/sex_action/chastityplay/force_cage_rim/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]一把抓住[target]，毫不客气地把[target.p_their()]的脸塞到[user.p_their()]的贞操盾下方！"))

/datum/sex_action/chastityplay/force_cage_rim/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]把[target]的脸牢牢卡在[user.p_their()]的后庭贞操盾下，借着这股压制操控[target.p_their()]舌头的每一次动作……"))
	user.sexcon.oralcourse_noise(target)
	user.sexcon.perform_sex_action(user, 1.3, 0, TRUE)
	user.sexcon.perform_sex_action(target, 0, 2.5, FALSE)
	user.sexcon.handle_passive_ejaculation(target)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/chastityplay/force_cage_rim/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[target]猛地推开，贞操盾从[target.p_their()]的脸上挪开时带出一声轻微的湿响。"))

/datum/sex_action/chastityplay/force_cage_rim/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
