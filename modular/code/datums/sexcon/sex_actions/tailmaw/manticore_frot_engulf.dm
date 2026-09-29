/datum/sex_action/manticore_frot_engulf
	parent_type = /datum/sex_action/tailmaw
	name = "磨蹭肉棒后用尾口包住双方"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_COCK | SEX_PART_TAIL_MAW
	target_sex_part = SEX_PART_COCK

/datum/sex_action/manticore_frot_engulf/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]将[user.p_their()]肉棒贴上[target]的肉棒，两根相互磨蹭，随后[user.p_their()]尾口绽开、落下，将两根肉棒一同裹进温热、布满触须的血肉中。"))
	playsound(user, 'sound/misc/mat/insert (1).ogg', 25, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_frot_engulf/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]的尾口裹着两根肉棒，慵懒地一阵阵收缩榨取，触须分别照料着每根肉棒，在两者相贴之处蜷曲缠绕。"
		if(SEX_FORCE_MID)
			message = "[user]尾巴内的触须同时螺旋缠住两根肉棒，随着尾口内壁起伏而挤压、按摩，湿滑的蜜液让两根肉棒相互滑动摩擦。"
		if(SEX_FORCE_HIGH)
			message = "[user]的尾巴以猛烈的压力将两根肉棒夹在一起，触须疯狂地吸住每一寸血肉，尾口用力而有节律地收缩抽动。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]的尾巴以急切、足以造成淤伤的力道挤压两根肉棒，触须在两者之间疯狂地扭结，尾口的肌肉内壁痉挛着，试图同时将双方榨至高潮。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.intercourse_noise(user, TRUE)
	user.sexcon.perform_sex_action(user, 3, 0, TRUE)
	user.sexcon.perform_sex_action(target, 3, 0, TRUE)
	handle_tailmaw_ejaculation(user, target, target, user)
	handle_tailmaw_ejaculation(user, target, user, user)

/datum/sex_action/manticore_frot_engulf/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴不情愿地松开两根肉棒，尾口徐徐张开，露出沾满蜜液与彼此精液、闪着湿光的肉棒。"))

/datum/sex_action/manticore_frot_engulf/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check() || target.sexcon.finished_check())
		return TRUE
	return FALSE
