/datum/sex_action/manticore_tailpeg
	parent_type = /datum/sex_action/tailmaw
	name = "用尾巴肛交对方"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_ANUS
	user_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_tailpeg/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴卷入[target]双腿之间，闭合的尾苞抵住[target]的肛缘，随后以缓慢而坚定的力道推入。"))
	playsound(target, 'sound/misc/mat/insert (1).ogg', 25, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_tailpeg/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || user.STASTR > 12)
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_pelvis_crush(target)
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]的尾巴缓缓进出[target]的后穴，每次小心的抽动都让闭合尾苞上带棱的板片擦过[target]的内壁。"
		if(SEX_FORCE_MID)
			message = "[user]将[user.p_their()]尾巴探得更深，尾苞扭转着抽插[target]的后穴，板片摩擦着被撑开的肛缘。"
		if(SEX_FORCE_HIGH)
			message = "[user]的尾巴如活塞般抽插[target]的后穴，闭合的尾苞撞得极深，让[target]的腹部鼓起，每次湿润的冲刺都让板片咔哒作响。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]像野兽般用[user.p_their()]尾巴猛干[target]的肠道，尾苞毫不顾忌地锤击着[target]的内部，每次冲刺都伴着令人作呕的湿润拍打声。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(target, 2, 3, TRUE)
	user.sexcon.perform_sex_action(user, 1, 0, TRUE)
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_tailpeg/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴从[target]饱受摧残的后穴中滑出，尾苞沾满黏液，闪着湿光。"))

/datum/sex_action/manticore_tailpeg/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()
