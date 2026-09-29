/datum/sex_action/manticore_tail_suck_breast
	parent_type = /datum/sex_action/tailmaw
	name = "用尾口吮吸对方的乳房"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_TAIL_MAW
	target_sex_part = SEX_PART_BREASTS

/datum/sex_action/manticore_tail_suck_breast/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴抬起，在[target]的乳房上方绽开，尾口紧裹住柔软的血肉，触须涌出，探索每一道曲线，伴着湿润的吮吸声吸住乳头。"))
	playsound(target, 'sound/misc/mat/insert (1).ogg', 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_tail_suck_breast/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/obj/item/organ/breasts/tits = target.getorganslot(ORGAN_SLOT_BREASTS)
	var/lactating = tits?.lactating
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			if(lactating)
				message = "[user]的尾口裹着[target]的乳房，缓慢地一阵阵诱哄般搏动，触须绕着乳头画圈，温热的乳汁在细小的触须上凝成液珠，每一滴都被急切地吸入孔口。"
			else
				message = "[user]的尾巴慵懒地一阵阵揉捏、吮吸着[target]的乳房，触须缠住乳头轻轻牵拉，在柔软的血肉上留下小小的圆形印记。"
		if(SEX_FORCE_MID)
			if(lactating)
				message = "[user]尾巴里的触须紧紧缠住[target]的乳头，有节律地搏动牵拉，以机械般的精确度挤奶，尾口的负压将源源不断的温热乳汁吸入饥渴的孔口。"
			else
				message = "[user]的尾口更加用力地吮吸，触须紧紧螺旋缠住[target]的乳头，每一阵吸力都将血肉拉进温热湿滑的尾口更深处。"
		if(SEX_FORCE_HIGH)
			if(lactating)
				message = "[user]的尾巴以足以造成淤伤的吸力夹住[target]的乳房，触须凶猛地抽吸乳头，乳汁成股喷入尾口，孔口每次收缩都发出清晰的吞咽声。"
			else
				message = "[user]的尾巴压住[target]的乳房，触须吸得如此紧，以至于留下红肿的痕迹，尾口用肌肉质的内壁咀嚼、按摩着血肉。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			if(lactating)
				message = "[user]的尾口吞住[target]的整个乳房，触须吸满每一寸，以急切、足以造成淤伤的力道榨乳，不停地吮饮，乳汁从紧闭的孔口边缘溢出。"
			else
				message = "[user]的尾口将[target]的乳房整个包住，里面的触须贴着捕获的每一寸血肉扭动，吮吸之猛烈，让最终松开时的皮肤布满暗色瘀斑。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.oralcourse_noise(user)
	user.sexcon.perform_sex_action(target, 3, 0, TRUE)
	user.sexcon.perform_sex_action(user, 1, 0, FALSE)
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_tail_suck_breast/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾巴伴着湿润的啪声松开[target]的乳房，触须不情愿地逐渐脱离，留下沾满湿滑蜜液、遍布小圆形吸痕的血肉。"))

/datum/sex_action/manticore_tail_suck_breast/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()
