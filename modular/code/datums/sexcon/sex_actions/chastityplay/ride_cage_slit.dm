/datum/sex_action/chastityplay/ride_cage_slit
	name = "用肉缝骑磨对方的贞操笼"
	stamina_cost = 1.0
	category = SEX_CATEGORY_PENETRATE
	user_sex_part = SEX_PART_SLIT_SHEATH
	user_needs_functional = TRUE // is this really necessary? well, it was checked...
	target_sex_part = SEX_PART_COCK
	target_needs_chastity = TRUE

/datum/sex_action/chastityplay/ride_cage_slit/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return FALSE
	if(user.sexcon.has_chastity_cage()) // isn't this redundant with the can_use_penis check?
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/ride_cage_slit/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]跨坐到[target]身上，向前挪动身体，直到[user.p_their()]的肉缝严丝合缝地贴上[target.p_their()]的[get_chastity_device_name(target)]。"))

/datum/sex_action/chastityplay/ride_cage_slit/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]让[user.p_their()]的肉缝沿着[target]的[get_chastity_device_name(target)]一路磨蹭，每一次来回都让金属从敏感的皮肉上拖刮过去……"))
	user.sexcon.outercourse_noise(target, TRUE)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
		user.sexcon.try_pelvis_crush(target)

	user.sexcon.perform_sex_action(user, 1.8, 0, TRUE)
	user.sexcon.perform_sex_action(target, 1.2, 1, TRUE)
	user.sexcon.handle_passive_ejaculation(target)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/ride_cage_slit/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]慢慢向后仰去，将[user.p_their()]的肉缝从[target]的[get_chastity_device_name(target)]上抬开，分离的动作安静而刻意。"))

/datum/sex_action/chastityplay/ride_cage_slit/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
