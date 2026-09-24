/datum/sex_action/magic/masturbate_breasts_prestidigitation
	name = "用法师之手揉弄自己的乳房"
	category = SEX_CATEGORY_HANDS
	user_sex_part = SEX_PART_BREASTS
	solo = TRUE

/datum/sex_action/magic/masturbate_breasts_prestidigitation/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!check_location_accessible(user, user, BODY_ZONE_CHEST, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/magic/masturbate_breasts_prestidigitation/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始用召出的奥术之手挑逗自己的乳房……"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/magic/masturbate_breasts_prestidigitation/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = do_subtle

	user.sexcon_action_message(user.sexcon.spanify_force("[user]以带来酥麻感的奥术能量[user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)]揉捏着自己的乳房……"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

	var/skill_level = max(user.get_skill_level(/datum/skill/magic/arcane), 1)
	user.sexcon.perform_sex_action(user, max(1, (skill_level * 0.75)), 4, TRUE)
	user.sexcon.handle_passive_ejaculation()

	user.sexcon.suppress_moan = FALSE

/datum/sex_action/magic/masturbate_breasts_prestidigitation/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("随着戏法术消散，[user]放下了双手。"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/magic/masturbate_breasts_prestidigitation/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE

