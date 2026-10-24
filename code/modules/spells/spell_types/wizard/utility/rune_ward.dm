/datum/action/cooldown/spell/touch/rune_ward
	button_icon = 'icons/mob/actions/mage_utilities.dmi'
	name = "符文结界"
	desc = "将奥术能量引入灰烬，在地面铭刻防护符文。闯入者经过时触发，但可跳跃或飞越避开。包含以下模式：\n \
	<b>绘制</b>：用副手的灰烬在地面画符文。可选择眩晕、火焰、寒冷、伤害或警报。\n \
	<b>清洁</b>：擦去已有符文，熟练法师可无声完成。\n \
	<b>使用</b>：记住或遗忘盟友；记住的人不会触发你的符文。"

	button_icon_state = "rune_ward"

	draw_message = span_notice("我将奥术之力凝于指尖，准备铭刻。")
	drop_message = span_notice("我散去了手中的奥术焦点。")

	hand_path = /obj/item/melee/new_touch_attack/rune_ward
	can_cast_on_self = TRUE
	infinite_use = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 1
	requires_aspect_access = TRUE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	cooldown_time = 30 SECONDS

	var/list/allowed_names = list()
	var/list/obj/structure/rune_ward/active_runes = list()
	var/max_runes = 10

	var/draw_time = 4 SECONDS
	var/scrub_time_skilled = 3 SECONDS
	var/scrub_time_unskilled = 8 SECONDS

/datum/action/cooldown/spell/touch/rune_ward/Destroy()
	for(var/obj/structure/rune_ward/rune in active_runes)
		UnregisterSignal(rune, COMSIG_PARENT_QDELETING)
	active_runes.Cut()
	return ..()

/datum/action/cooldown/spell/touch/rune_ward/proc/on_rune_destroyed(obj/structure/rune_ward/source)
	SIGNAL_HANDLER
	active_runes -= source

/datum/action/cooldown/spell/touch/rune_ward/cast_on_hand_hit(obj/item/melee/new_touch_attack/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	switch(caster.used_intent.type)
		if(/datum/intent/hand/draw)
			return draw_rune(hand, victim, caster)
		if(/datum/intent/hand/clean)
			return scrub_rune(hand, victim, caster)
		if(/datum/intent/use)
			return memorize_allies(caster)
	return FALSE

/datum/action/cooldown/spell/touch/rune_ward/proc/draw_rune(obj/item/melee/new_touch_attack/hand, atom/victim, mob/living/carbon/caster)
	var/turf/target_turf = get_turf(victim)
	if(!target_turf)
		to_chat(caster, span_warning("这里没有可以画符文的地方。"))
		return FALSE

	if(!caster.Adjacent(target_turf))
		to_chat(caster, span_warning("我必须紧邻要铭刻的表面。"))
		return FALSE

	var/obj/item/ash/ash_item = locate(/obj/item/ash) in caster.held_items
	if(!ash_item)
		to_chat(caster, span_warning("绘制符文需要另一只手拿着灰烬。"))
		return FALSE

	var/list/choices = list()
	choices[RUNE_WARD_STUN] = image(icon = 'icons/roguetown/misc/rune_wards.dmi', icon_state = RUNE_WARD_ICON_STUN)
	choices[RUNE_WARD_FIRE] = image(icon = 'icons/roguetown/misc/rune_wards.dmi', icon_state = RUNE_WARD_ICON_FIRE)
	choices[RUNE_WARD_CHILL] = image(icon = 'icons/roguetown/misc/rune_wards.dmi', icon_state = RUNE_WARD_ICON_CHILL)
	choices[RUNE_WARD_DAMAGE] = image(icon = 'icons/roguetown/misc/rune_wards.dmi', icon_state = RUNE_WARD_ICON_DAMAGE)
	choices[RUNE_WARD_ALARM] = image(icon = 'icons/roguetown/misc/rune_wards.dmi', icon_state = RUNE_WARD_ICON_ALARM)

	var/choice = show_radial_menu(caster, caster, choices)
	if(!choice)
		return FALSE

	if(QDELETED(ash_item) || !(ash_item in caster.held_items))
		to_chat(caster, span_warning("我弄丢了灰烬。"))
		return FALSE

	var/adjusted_time = draw_time
	var/skill_level = caster.get_skill_level(associated_skill)
	if(skill_level >= SKILL_LEVEL_EXPERT)
		adjusted_time *= 0.5
	else if(skill_level >= SKILL_LEVEL_JOURNEYMAN)
		adjusted_time *= 0.75

	caster.visible_message(span_notice("[caster]跪下，开始用灰烬在地上描画符号。"), span_notice("我开始铭刻符文结界……"))
	if(!do_after(caster, adjusted_time, target = target_turf))
		to_chat(caster, span_warning("我的专注被打断了。"))
		return FALSE

	if(QDELETED(ash_item) || !(ash_item in caster.held_items))
		to_chat(caster, span_warning("我弄丢了灰烬。"))
		return FALSE

	var/rune_path
	switch(choice)
		if(RUNE_WARD_STUN)
			rune_path = /obj/structure/rune_ward/stun
		if(RUNE_WARD_FIRE)
			rune_path = /obj/structure/rune_ward/fire
		if(RUNE_WARD_CHILL)
			rune_path = /obj/structure/rune_ward/chill
		if(RUNE_WARD_DAMAGE)
			rune_path = /obj/structure/rune_ward/damage
		if(RUNE_WARD_ALARM)
			rune_path = /obj/structure/rune_ward/alarm

	if(!rune_path)
		return FALSE

	qdel(ash_item)
	var/obj/structure/rune_ward/rune = new rune_path(target_turf)
	rune.owner_ref = WEAKREF(caster)
	rune.spell_ref = WEAKREF(src)
	rune.owner_name = caster.real_name
	rune.owner_ckey = caster.ckey || "no ckey"
	active_runes += rune
	RegisterSignal(rune, COMSIG_PARENT_QDELETING, PROC_REF(on_rune_destroyed))

	if(length(active_runes) > max_runes)
		var/obj/structure/rune_ward/oldest = active_runes[1]
		if(!QDELETED(oldest))
			oldest.visible_message(span_warning("创造者铭刻新符文时，最早的符文消退了。"))
			qdel(oldest)

	caster.visible_message(span_notice("[caster]完成了地面符文的铭刻。"), span_notice("我完成了[choice]符文结界。"))
	playsound(target_turf, 'sound/magic/whiteflame.ogg', 30, TRUE)

	var/fatigue = get_adjusted_cost(primary_resource_cost)
	caster.stamina_add(fatigue)
	StartCooldown()
	return FALSE

/datum/action/cooldown/spell/touch/rune_ward/proc/scrub_rune(obj/item/melee/new_touch_attack/hand, atom/victim, mob/living/carbon/caster)
	var/obj/structure/trap/target_trap
	if(istype(victim, /obj/structure/trap))
		target_trap = victim
	else
		var/turf/T = get_turf(victim)
		if(T)
			target_trap = locate(/obj/structure/rune_ward) in T

	if(!target_trap)
		to_chat(caster, span_warning("这里没有可擦去的符文或陷阱。"))
		return FALSE

	if(!caster.Adjacent(target_trap))
		to_chat(caster, span_warning("我必须靠近才能擦去它。"))
		return FALSE

	var/skill_level = caster.get_skill_level(associated_skill)
	var/skilled = skill_level >= SKILL_LEVEL_EXPERT

	if(skilled)
		caster.visible_message(span_notice("[caster]小心地将手拂过地面。"), span_notice("我开始谨慎地解开结界……"))
	else
		caster.visible_message(span_warning("[caster]开始擦拭地上的某个东西。"), span_notice("我开始擦除结界……"))

	var/scrub_time = skilled ? scrub_time_skilled : scrub_time_unskilled

	if(!do_after(caster, scrub_time, target = target_trap))
		to_chat(caster, span_warning("我的专注被打断了！"))
		if(!skilled && target_trap.armed)
			target_trap.trap_effect(caster)
		return FALSE

	if(QDELETED(target_trap))
		return FALSE

	if(skilled)
		to_chat(caster, span_notice("我无声地抹去了结界。"))
	else
		caster.visible_message(span_notice("[caster]擦去了地上的结界。"), span_notice("我成功擦去了结界。"))

	qdel(target_trap)
	return FALSE

/datum/action/cooldown/spell/touch/rune_ward/proc/memorize_allies(mob/living/carbon/caster)
	if(!caster.mind)
		to_chat(caster, span_warning("我无法集中思绪。"))
		return FALSE

	var/list/known = caster.mind.known_people
	if(!length(known))
		to_chat(caster, span_warning("我没有认识的人可以记住。"))
		return FALSE

	var/list/options = list()
	for(var/person_name in known)
		if(person_name in allowed_names)
			options["[person_name]（已记住）"] = person_name
		else
			options[person_name] = person_name

	var/choice = input(caster, "选择要记住或遗忘的人：", "符文结界——记忆") as null|anything in options
	if(!choice)
		return FALSE

	var/real_name = options[choice]

	if(real_name in allowed_names)
		allowed_names -= real_name
		to_chat(caster, span_notice("我从结界记忆中抹去了[real_name]。今后的符文将不再放过对方。"))
	else
		allowed_names += real_name
		to_chat(caster, span_notice("我将[real_name]记入结界记忆。今后的符文将放过对方。"))

	return FALSE

// --- Touch Attack Item ---

/obj/item/melee/new_touch_attack/rune_ward
	name = "\improper 铭刻之手"
	desc = "奥术能量在指尖噼啪作响，随时可铭刻结界。触碰自己可解除。"
	possible_item_intents = list(/datum/intent/hand/draw, /datum/intent/hand/clean, /datum/intent/use)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#FF8844"
	experimental_inhand = FALSE

/obj/item/melee/new_touch_attack/rune_ward/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	var/datum/action/cooldown/spell/touch/rune_ward/spell = spell_which_made_us?.resolve()
	if(spell)
		spell.cast_on_hand_hit(src, target, user)

