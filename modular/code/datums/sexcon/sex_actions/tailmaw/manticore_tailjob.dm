/datum/sex_action/manticore_tailjob
	parent_type = /datum/sex_action/tailmaw
	name = "用尾口包住对方的肉棒"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_COCK
	user_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_tailjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴绽开，骨质板片如扇叶般展开，尾口罩上[target]的肉棒，触须急切地吸附，发出湿润的吮吸声。"))
	playsound(target, 'sound/misc/mat/insert (1).ogg', 25, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_tailjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]的尾巴裹着[target]的肉棒，缓慢而慵懒地一阵阵搏动，里面的触须细致得令人煎熬，描摹着每一道隆起。"
		if(SEX_FORCE_MID)
			message = "[user]的尾口有意地收缩榨取，吮吸着[target]的肉棒，触须随着每一次搏动螺旋缠得更紧。"
		if(SEX_FORCE_HIGH)
			message = "[user]的尾巴紧紧夹住[target]的肉棒，里面的触须疯狂地翻涌，密封的负压发出淫靡的湿响。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]的尾口以足以造成淤伤的力道压住[target]的肉棒，每根触须都紧紧吸附、抽动，肌肉内壁猛烈而有节律地痉挛榨取。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.intercourse_noise(user, TRUE)
	user.sexcon.perform_sex_action(target, 3, 0, TRUE)
	handle_tailmaw_ejaculation(user, target, target, user)
	user.sexcon.perform_sex_action(user, 2, 0, FALSE)
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_tailjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴伴着湿润的啪声松开[target]的肉棒，触须不情愿地一根根脱离。"))
	playsound(target, 'sound/misc/mat/insert (2).ogg', 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_tailjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
