/mob/living/carbon/examine(mob/user)
	var/t_He = p_they(TRUE)
	var/t_his = p_their()
	var/t_has = "有"
	var/t_is = ""

	. = list("<span class='info'>✠ ------------ ✠\n这是<EM>[src]</EM>！")
	var/list/obscured = check_obscured_slots()

	var/m1 = "[t_He][t_is]"
	var/m2 = "[t_his]"
	var/m3 = "[t_He][t_has]"
	if(user == src)
		m1 = "我"
		m2 = "我的"
		m3 = "我有"

	if (handcuffed)
		. += span_warning("[m1]被[handcuffed]绑住了！")
	if (head)
		. += "[m1]头上戴着[head.get_examine_string(user)]。 "
	if(wear_mask && !(SLOT_WEAR_MASK in obscured))
		. += "[m1]脸上戴着[wear_mask.get_examine_string(user)]。"
	if(wear_neck && !(SLOT_NECK in obscured))
		. += "[m1]脖子上戴着[wear_neck.get_examine_string(user)]。"

	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT))
			. += "[m1]用[get_held_index_name(get_held_index_of_item(I))]拿着[I.get_examine_string(user)]。"

	if (back)
		. += "[m1]背上背着[back.get_examine_string(user)]。"
	var/appears_dead = 0
/*	if (stat == DEAD)
		appears_dead = 1
		if(getorgan(/obj/item/organ/brain))
			. += span_dead("[t_He] [t_is] limp and unresponsive, with no signs of life.")
		else if(get_bodypart(BODY_ZONE_HEAD))
			. += span_dead("It appears that [t_his] brain is missing...")*/

	var/list/missing = get_missing_limbs()
	for(var/t in missing)
		if(t==BODY_ZONE_HEAD)
			. += span_dead("<B>[capitalize(m2)][parse_zone(t)]没了。</B>")
			continue
		. += span_warning("<B>[capitalize(m2)][parse_zone(t)]没了。</B>")

	var/list/msg = list("<span class='warning'>")
	var/temp = getBruteLoss()
	if(!(user == src && src.hal_screwyhud == SCREWYHUD_HEALTHY)) //fake healthy
		var/brute_text = get_damage_descriptor_text(temp, "[m3]一些瘀伤。\n", "[m3]很多瘀伤！\n", "<B>[m1]浑身青一块紫一块！！</B>\n")
		if(brute_text)
			msg += brute_text

		temp = getFireLoss()
		var/fire_text = get_damage_descriptor_text(temp, "[m3]一些烧伤。\n", "[m3]很多烧伤！\n", "<B>[m1]烧得像是被龙烤过一样！！</B>\n")
		if(fire_text)
			msg += fire_text

		temp = getCloneLoss()
		if(temp)
			if(temp < 25)
				msg += "[m1]身体略微畸形。\n"
			else if (temp < 50)
				msg += "[m1]身体有<b>中度</b>畸形！\n"
			else
				msg += "<b>[m1]身体严重畸形！</b>\n"

	if(HAS_TRAIT(src, TRAIT_DUMB))
		msg += "[m1]看起来笨手笨脚，脑袋也不太灵光。\n"
	
	var/list/modular_lines = carbon_modular_examine_lines(user, t_He, m1, m2, m3)
	if(length(modular_lines))
		msg += modular_lines

	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks))
		msg += "[m1]身上沾着某种易燃物。\n"
	if(has_status_effect(/datum/status_effect/fire_handler/wet_stacks))
		msg += "[m1]看起来湿漉漉的。\n"

	if(pulledby && pulledby.grab_state)
		msg += "[m1]被[pulledby]牢牢抓住。\n"

	msg += "</span>"

	. += msg.Join("")

	if(!appears_dead)
		if(stat == UNCONSCIOUS)
			. += span_warning("[m1]失去了意识。")
		else if(InCritical())
			. += span_warning("[m1]勉强还有意识。")
	if (stat == DEAD)
		appears_dead = 1
		. += span_warning("[m1]失去了意识。")
	var/trait_exam = common_trait_examine()
	if (!isnull(trait_exam))
		. += trait_exam

	if(isliving(user))
		var/mob/living/L = user
		if(STASTR > L.STASTR)
			if(STASTR > 15)
				. += span_warning("[t_He]看起来比我强壮。")
			else
				. += span_warning("<B>[t_He]看起来比我强壮。</B>")

	. += "✠ ------------ ✠</span>"

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)

// Helper for generating damage description text based on thresholds, used by both examine and condition summary on cursed collar UI.
/mob/living/carbon/proc/get_damage_descriptor_text(damage_amount, minor_text, moderate_text, severe_text)
	if(!damage_amount)
		return null
	if(damage_amount < 25)
		return minor_text
	if(damage_amount < 50)
		return moderate_text
	return severe_text

/mob/living/carbon/proc/get_damage_condition_summary()
	var/list/conditions = list()

	var/brute_condition = get_damage_descriptor_text(getBruteLoss(), "少量瘀伤", "大量瘀伤", "浑身青一块紫一块")
	if(brute_condition)
		conditions += brute_condition

	var/fire_condition = get_damage_descriptor_text(getFireLoss(), "少量烧伤", "大量烧伤", "烧得像是被龙烤过一样")
	if(fire_condition)
		conditions += fire_condition

	if(!length(conditions))
		return "没有明显的瘀伤或烧伤"

	return capitalize(jointext(conditions, "；"))

/mob/living/carbon/proc/carbon_modular_examine_lines(mob/user, t_He, m1, m2, m3)
	var/list/lines = list()
	var/list/ext_lines = carbon_modular_examine_extension(user, t_He, m1, m2, m3)
	if(length(ext_lines))
		lines += ext_lines
	return lines
