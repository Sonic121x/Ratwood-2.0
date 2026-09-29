/datum/sex_action/manticore_tailjob_receive
	parent_type = /datum/sex_action/tailmaw
	name = "用对方的尾口套弄我的肉棒"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_COCK
	target_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_tailjob_receive/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]抓住[target]的尾巴，将[user.p_their()]肉棒推入绽开的尾口，在触须吸附上来时喘息出声。"))
	playsound(user, 'sound/misc/mat/insert (1).ogg', 25, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_tailjob_receive/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]朝[target]的尾口缓缓摆动[user.p_their()]胯部，里面的触须随着每次轻柔的挺动而搏动回应。"
		if(SEX_FORCE_MID)
			message = "[user]以稳定的节奏抽插着[target]的尾巴，尾口的触须沾满甜腻蜜液，每抽动一次便缠得更紧。"
		if(SEX_FORCE_HIGH)
			message = "[user]放纵地猛干着[target]的尾口，孔口裹着[user.p_their()]肉棒发出湿响，触须鞭打着棒身。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]以惩罚般的力道将[user.p_their()]肉棒撞入[target]的尾巴，尾口收紧得连触须都挤出了淤伤，每次冲刺都让板片咔哒作响。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(user, 3, 0, TRUE)
	handle_tailmaw_ejaculation(user, target, user, target)
	user.sexcon.perform_sex_action(target, 2, 0, FALSE)
	target.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_tailjob_receive/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]从[target]的尾口中抽出，湿滑的蜜液在两者之间牵出缕缕细丝。"))

/datum/sex_action/manticore_tailjob_receive/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
