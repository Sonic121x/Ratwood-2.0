/datum/sex_action/manticore_tail_sounding
	parent_type = /datum/sex_action/tailmaw
	name = "用尾部触须探入对方的尿道"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_COCK
	user_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_tail_sounding/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的尾口贴着[target]的肉棒绽开，触须好奇地戳弄着顶端，随后一根细触须绕着[target]的尿道口画圈，再挤入其中。"))
	playsound(target, 'sound/misc/mat/insert (1).ogg', 15, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_tail_sounding/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || user.STASTR > 12)
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_pelvis_crush(target)
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "一根触须蠕动着深入[target]的尿道，温热地搏动，分泌出令人酥麻的毒液，麻痹了最初的灼痛，从内部缓缓撑开组织。"
		if(SEX_FORCE_MID)
			message = "两根触须推入[target]的尿道口，细小的触须相互螺旋缠绕着深入，尖端将毒液抹上鲜少被触碰的内壁，直到灼痛转为电流般嗡鸣的快感。"
		if(SEX_FORCE_HIGH)
			message = "一束触须强行挤入[target]的尿道，随着每次搏动蠕动得更深，将尿道口撑得远超其极限，把酥麻的毒液泵到每一寸受损组织上。"
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]的触须从内部塞满[target]的肉棒，蠕动的触须团不断深入，将棒身撑得明显鼓起，毒液涌入饱受摧残的尿道，直到[target]的整根肉棒都不由自主地搏动、痉挛。"
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.intercourse_noise(target, TRUE)
	// Sounding: high pain, moderate arousal
	user.sexcon.perform_sex_action(target, 1, 7, TRUE)
	user.sexcon.try_do_pain_scream(target, 7)
	target.sexcon.handle_passive_ejaculation(user)
	user.sexcon.perform_sex_action(user, 1, 0, FALSE)
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_tail_sounding/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]的触须从[target]的尿道中一根根缓缓抽回，每根脱离时都发出轻微的啪声，留下大张的尿道口，淌着前液与甜腻毒液的混合物。"))

/datum/sex_action/manticore_tail_sounding/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()

/datum/sex_action/manticore_tail_sounding/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!..())
		return FALSE
	var/obj/item/organ/penis/penis = target.getorganslot(ORGAN_SLOT_PENIS)
	return penis.sheath_type != SHEATH_TYPE_SLIT
