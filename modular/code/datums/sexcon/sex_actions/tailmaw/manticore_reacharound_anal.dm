/datum/sex_action/manticore_reacharound_anal
	parent_type = /datum/sex_action/tailmaw
	name = "肛交并用尾口包住对方的肉棒"
	check_same_tile = FALSE
	user_needs_functional = TRUE
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_ANUS | SEX_PART_COCK
	user_sex_part = SEX_PART_TAIL_MAW | SEX_PART_COCK

/datum/sex_action/manticore_reacharound_anal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]的尾巴绕到[target]身前，吞住对方颤抖的肉棒。[user]双臂紧抱着[target.p_their()]腰，让[user.p_their()]伴侣缓缓坐下，将[user.p_their()]肉棒纳入体内..."))

/datum/sex_action/manticore_reacharound_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || user.STASTR > 12)
		user.sexcon.try_pelvis_crush(target)
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]的尾巴沿着[target]的阴茎上下绵长而撩人地舔舐，同时[user.p_their()]肉棒[user.sexcon.get_generic_force_adjective()]擦过[target.p_their()]内部，一路退到[target]的肛缘。"
		if(SEX_FORCE_MID)
			message = "[user]的尾穴[user.sexcon.get_generic_force_adjective()]榨取着[target]肉棒上渗出的浑浊前液。每次撞击[target]的前列腺都会引发全身战栗，尾穴也趁势尽情榨取。"
		if(SEX_FORCE_HIGH)
			message = "[user]的肉棒越来越轻松地[user.sexcon.get_generic_force_adjective()]牵扯着[target]的肛门。数百根触须蠕动、抚弄着[target]的肉棒，一心只想将其彻底榨干。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user] [user.sexcon.get_generic_force_adjective()]猛干着[target]的肠道。[target.p_their(TRUE)]腹部鼓起、肠道出血，尾穴痛苦地抽吸着[target.p_their()]饱受折磨的肉棒。每次欲壑难填的双重冲刺，都伴着尾穴的湿响与肛交时肉体撞击的闷声。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(target, 4, 1, TRUE)
	user.sexcon.perform_sex_action(user, 1, 0, TRUE)
	if(user.sexcon.check_active_ejaculation())
		for(var/i = 1; i <= user.sexcon.get_load_bursts(); i++)
			user.sexcon.cum_into(splashed_user = target, orifice = SEX_PART_ANUS, skip_knot_try = TRUE, consume_charge = i == 1)
			if(HAS_TRAIT(target, TRAIT_BAOTHA_FERTILITY_BOON) && !target.getorganslot(ORGAN_SLOT_VAGINA))
				user.try_impregnate(target)
		user.virginity = FALSE

		var/datum/status_effect/facial/external/coating = target.has_status_effect(/datum/status_effect/facial/external)
		if(coating)
			coating.refresh_cum()
		else
			target.apply_status_effect(/datum/status_effect/facial/external)

	handle_tailmaw_ejaculation(user, target, target, user)

/datum/sex_action/manticore_reacharound_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴从[target]痉挛、浸满毒液的肉棒上滑开。疲惫的肉棒溢出一缕前液，[user]也从[target.p_their()]同样不堪重负的肛门中猛然抽出。"))

/datum/sex_action/manticore_reacharound_anal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.finished_check() || target.sexcon.finished_check()
