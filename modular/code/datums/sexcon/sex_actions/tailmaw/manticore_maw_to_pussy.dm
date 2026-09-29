/datum/sex_action/manticore_maw_to_pussy
	parent_type = /datum/sex_action/tailmaw
	name = "用尾口吸住对方的阴穴"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_CUNT
	user_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_maw_to_pussy/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴卷入[target]双腿之间，尾口绽开，紧紧贴住[target]的阴穴，里面的触须涌出，品尝湿滑的褶皱。"))
	playsound(target, 'sound/misc/mat/insert (1).ogg', 25, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_maw_to_pussy/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || user.STASTR > 12)
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_pelvis_crush(target)
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]的尾部触须慵懒地探索[target]的褶皱，细小的触须以令人发狂的精确度描摹着阴唇，几根更大胆的触须滑入穴口，品尝里面的温暖。"
		if(SEX_FORCE_MID)
			message = "触须向[target]的阴穴深处推进，数十根细小的触须蠕动着越过穴口，铺满[target]的内壁，各自搏动，将甜腻而酥麻的毒液分泌到每一道敏感的褶皱上。"
		if(SEX_FORCE_HIGH)
			message = "[user]的尾口以压迫般的强烈吸力吸住[target]的阴穴，触须扭成一团侵入、填满[target]的内部，鞭打着[target]的宫颈，交替泵出一波波毒液与蜜液。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]的尾巴将[target]的阴穴完全封住，尾口牢牢吸紧，每根触须都钻向更深处，翻搅的触须团撑开[target]的内壁，将甜腻黏液灌满[target]的子宫，直到[target]的腹部明显鼓起。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(target, 4, 1, TRUE)
	user.sexcon.perform_sex_action(user, 2, 0, FALSE)
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_maw_to_pussy/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴伴着绵长湿润的吮吸声从[target]的阴穴上揭开，触须一根根退回，大量蜜液从[target]大张、颤抖的阴穴中涌出。"))

/datum/sex_action/manticore_maw_to_pussy/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()
