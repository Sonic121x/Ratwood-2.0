/datum/sex_action/chastityplay/masturbate_cage_penis
	name = "抚弄你被锁住的阴茎"
	category = SEX_CATEGORY_HANDS
	user_sex_part = SEX_PART_COCK
	user_needs_chastity = TRUE
	solo = TRUE

/datum/sex_action/chastityplay/masturbate_cage_penis/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]用[user.p_their()]手环住[user.p_their()]的[get_chastity_device_name(user)]，开始缓缓套弄，指节压进了栅栏之间。"))

/datum/sex_action/chastityplay/masturbate_cage_penis/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]让[user.p_their()]掌心沿着[user.p_their()]的[get_chastity_device_name(user)]上下摩擦，每一次来回都让阴茎徒劳地顶向栅栏……"))
	user.sexcon.perform_sex_action(user, 1.6, 0.5, TRUE)
	user.sexcon.handle_passive_ejaculation()

/datum/sex_action/chastityplay/masturbate_cage_penis/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]手从[user.p_their()]的[get_chastity_device_name(user)]上放了下来，气息紊乱，却依旧毫无进展。"))

/datum/sex_action/chastityplay/masturbate_cage_penis/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
