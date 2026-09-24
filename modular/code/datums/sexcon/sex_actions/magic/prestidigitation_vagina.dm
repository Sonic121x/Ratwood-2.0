/datum/sex_action/magic/masturbate_other_vagina_prestidigitation
	name = "用法师之手揉弄对方的阴蒂"
	check_same_tile = FALSE
	ranged_los_action = TRUE
	category = SEX_CATEGORY_HANDS
	target_sex_part = SEX_PART_CUNT

/datum/sex_action/magic/masturbate_other_vagina_prestidigitation/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]召出奥术之手，伸向[target]的阴部……"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/magic/masturbate_other_vagina_prestidigitation/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = do_subtle

	user.sexcon_action_message(user.sexcon.spanify_force("[user]引导悬空的魔法之手[user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)]揉弄着[target]的阴蒂……"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.generic_sex_noise()

	var/skill_level = max(user.get_skill_level(/datum/skill/magic/arcane), 1)
	user.sexcon.perform_sex_action(target, (2.5 * skill_level), 3, TRUE)
	target.sexcon.handle_passive_ejaculation()

	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE

/datum/sex_action/magic/masturbate_other_vagina_prestidigitation/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("随着戏法术消散，[user]放下了双手。"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/magic/masturbate_other_vagina_prestidigitation/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
