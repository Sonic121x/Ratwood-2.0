/datum/sex_action/holy/masturbate_other_anus_orison
	name = "用神圣之手指交对方的后穴"
	check_same_tile = FALSE
	ranged_los_action = TRUE
	category = SEX_CATEGORY_HANDS
	target_sex_part = SEX_PART_ANUS

/datum/sex_action/holy/masturbate_other_anus_orison/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]低声祷告，将能量引向[target]的臀部……"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/holy/masturbate_other_anus_orison/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	var/list/data = modular_get_orison_patron_data(user.patron?.type)
	var/message_suffix = data["message"]
	modular_try_show_orison_indulgence_notice(target, user, data)
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = do_subtle

	user.sexcon_action_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)]将悬空的神圣手指插入[target]的后穴……[message_suffix]"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.generic_sex_noise()
	if(data["jingle"])
		playsound(user, SFX_JINGLE_BELLS, 30, TRUE, -2, ignore_walls = FALSE)

	var/skill_level = max(user.get_skill_level(/datum/skill/magic/holy), 1)
	user.sexcon.perform_sex_action(target, (data["arousal_mult"] * skill_level), data["pain"], TRUE)
	target.sexcon.handle_passive_ejaculation()

	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE

/datum/sex_action/holy/masturbate_other_anus_orison/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]结束祷告，停止指交[target]的后穴。"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/holy/masturbate_other_anus_orison/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
