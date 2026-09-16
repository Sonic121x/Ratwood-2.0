/datum/sex_action/chastityplay/masturbate_cage_penis_other
	name = "抚弄他们被锁住的阴茎"
	category = SEX_CATEGORY_HANDS
	target_sex_part = SEX_PART_COCK
	target_needs_chastity = TRUE

/datum/sex_action/chastityplay/masturbate_cage_penis_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]用[user.p_their()]手指握住[target]的[get_chastity_device_name(target)]，开始缓慢而刻意地抚弄。"))

/datum/sex_action/chastityplay/masturbate_cage_penis_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]以稳定的力道套弄[target]的[get_chastity_device_name(target)]，每一次拉动都只让[target.p_their()]的阴茎徒劳地顶向栅栏……"))
	user.sexcon.perform_sex_action(target, 1.9, 0.5, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/masturbate_cage_penis_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]松开了[target]的[get_chastity_device_name(target)]，向后退了一步。"))

/datum/sex_action/chastityplay/masturbate_cage_penis_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
