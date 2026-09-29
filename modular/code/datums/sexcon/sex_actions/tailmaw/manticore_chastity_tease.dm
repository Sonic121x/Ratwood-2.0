/datum/sex_action/manticore_chastity_tease
	parent_type = /datum/sex_action/tailmaw
	name = "用尾部触须挑逗对方的贞操笼"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_COCK
	user_sex_part = SEX_PART_TAIL_MAW
	target_needs_chastity = TRUE

/datum/sex_action/manticore_chastity_tease/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾口贴着[target]的贞操笼绽开，里面的触须钻过笼条，在被囚禁的血肉上蠕动。"))

/datum/sex_action/manticore_chastity_tease/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]尾巴内的触须慵懒地穿过[target]的笼条，以令人抓狂的缓慢速度描摹着[target]被囚禁的肉棒轮廓，每次触碰都留下毒液带来的酥麻。"
		if(SEX_FORCE_MID)
			message = "更多触须挤进[target]的笼条之间，细小的触须缠住一切能够触及的血肉，温热地搏动着，将令人酥麻的蜜液分泌到[target]在笼中膨胀的肉棒上。"
		if(SEX_FORCE_HIGH)
			message = "[user]的尾部触须凶猛地穿过[target]的贞操笼，数十根触须贴着被囚禁的肉棒蠕动，探入[target]的尿道口，将毒液抹进能够触及的每一道缝隙。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]的尾巴将[target]的贞操笼完全包住，里面的每根触须都争先恐后地挤过笼条，用甜腻的蜜液裹满被囚禁的肉棒，直到液体从笼子的排液孔流出。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.outercourse_noise(user, TRUE)
	user.sexcon.perform_sex_action(target, 3, 0, TRUE)
	user.sexcon.perform_sex_action(user, 1, 0, FALSE)
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_chastity_tease/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴从[target]的贞操笼上退开，触须不情愿地从笼条之间抽回，拖出缕缕蜜液。"))

/datum/sex_action/manticore_chastity_tease/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()
