/*
Exercise Verbs
*/

/mob/living/carbon/human/verb/pushup()
	set name = "做俯卧撑"
	set desc = "让你做俯卧撑。"
	set category = "表情动作"

	do_pushups()

/mob/living/carbon/human/proc/do_pushups()
	if(!can_do_pushup())
		return

	setDir(EAST)
	visible_message(span_notice("[src]俯下身，准备做俯卧撑。"), span_notice("你俯下身，准备做俯卧撑。"), span_notice("你听到一阵窸窣声。"))

	switch(alert(src, "做标准俯卧撑还是跪姿俯卧撑？", "俯卧撑", "标准", "跪姿"))
		if("标准")
			visible_message(span_notice("[src]用双手和双脚撑起身体。"), span_notice("你用双手和双脚撑起身体。"), span_notice("你听到一阵窸窣声。"))
			execute_pushups(on_knees = FALSE)
		if("跪姿")
			visible_message(span_notice("[src]将身体的重量转移到双膝上。"), span_notice("你将身体的重量转移到双膝上。"), span_notice("你听到一阵窸窣声。"))
			execute_pushups(on_knees = TRUE)

/mob/living/carbon/human/proc/stop_pushups()
	setDir(null)

/mob/living/carbon/human/proc/execute_pushups(on_knees = FALSE)
	if(!can_do_pushup())
		return
	var/target_y = -5
	var/pushups_in_a_row

	var/stamina_loss = calculate_stamina_loss_per_pushup(on_knees)
	while(stamina + stamina_loss < max_stamina)
		if(!can_do_pushup())
			stop_pushups()
			return
		animate(src, pixel_y = target_y, time = 0.8 SECONDS, easing = QUAD_EASING) //down to the floor
		if(!lying || !do_after(src, 0.6 SECONDS, needhand = TRUE, progress = FALSE))
			visible_message(span_notice("[src]停止做俯卧撑。"), span_notice("你停止做俯卧撑。"), span_notice("你听到有人活动的声音。"))
			animate(src, pixel_y = 0, time = 0.2 SECONDS, easing = QUAD_EASING)
			stop_pushups()
			return
		animate(src, pixel_y = 0, time = 0.8 SECONDS, easing = QUAD_EASING) //back up
		if(!lying || !do_after(src, 0.6 SECONDS, needhand = TRUE, progress = FALSE))
			visible_message(span_notice("[src]停止做俯卧撑。"), span_notice("你停止做俯卧撑。"), span_notice("你听到有人活动的声音。"))
			animate(src, pixel_y = 0, time = 0.2 SECONDS, easing = QUAD_EASING)
			stop_pushups()
			return
		pushups_in_a_row++
		var/number_words = "第[pushups_in_a_row]次"
		balloon_alert_to_viewers(number_words, number_words, 7, y_offset = -12)
		stamina_add(stamina_loss)
	to_chat(src, span_warning("你累得瘫倒在地，没法再继续了。"))
	stop_pushups()

/mob/living/carbon/human/proc/can_do_pushup()
	if(incapacitated())
		return FALSE

	if(!resting)
		to_chat(src, span_warning("你得先趴在地上才能做俯卧撑。"))
		return FALSE

	if(buckling)
		to_chat(src, span_warning("你得先趴在地上才能做俯卧撑。"))
		return FALSE

	var/list/missing_limbs = get_missing_limbs()
	if(length(missing_limbs))
		to_chat(src, span_warning("你的肢体不完整，无法做俯卧撑。"))
		return FALSE

	if(!isturf(loc))
		to_chat(src, span_warning("你不能在这里做俯卧撑！"))
		return FALSE

	return TRUE

/mob/living/carbon/human/proc/calculate_stamina_loss_per_pushup(on_knees = FALSE)
	var/stamina_loss = 8 - get_skill_level(/datum/skill/misc/athletics)
	if(head)
		if(head.armor_class == ARMOR_CLASS_HEAVY)
			stamina_loss += 3
		else if(head.armor_class == ARMOR_CLASS_MEDIUM)
			stamina_loss += 1
	if(wear_armor)
		if(wear_armor.armor_class == ARMOR_CLASS_HEAVY)
			stamina_loss += 5
		else if(wear_armor.armor_class == ARMOR_CLASS_MEDIUM)
			stamina_loss += 2
	if(backr || backl)
		stamina_loss += 3
	var/painpercent = get_complex_pain() / pain_threshold
	if(painpercent > 0.5)
		stamina_loss += 8
	if(on_knees)
		stamina_loss -= 5
	return max(stamina_loss, 1)
