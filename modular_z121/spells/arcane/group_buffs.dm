/atom/movable/screen/alert/status_effect/buff/group_darkvision
	name = "群体黑暗视觉"
	desc = "我能更清晰地在黑暗中视物。"
	icon_state = "buff"

/datum/status_effect/buff/group_darkvision
	id = "group_darkvision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/group_darkvision
	duration = 30 MINUTES

/datum/status_effect/buff/group_darkvision/on_apply(mob/living/new_owner, assocskill)
	if(assocskill)
		duration += 10 MINUTES * assocskill
	. = ..()
	to_chat(owner, span_warning("更强的黑暗视觉笼罩了我，黑暗变得清晰可辨。"))
	ADD_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)

/datum/status_effect/buff/group_darkvision/on_remove()
	. = ..()
	to_chat(owner, span_warning("强化的黑暗视觉消退了，黑暗重新恢复原样。"))
	REMOVE_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)

/datum/action/cooldown/spell/z121/invoked/group_darkvision
	name = "群体黑暗视觉"
	desc = "强化施法者与周围 1 格内活物的夜视能力，持续时间为黑暗视觉的两倍。"
	button_icon_state = "darkvision"
	primary_resource_cost = 160
	hold_drain = 0
	charge_time = 2 SECONDS
	cooldown_time = 3 MINUTES
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocations = list("群星之瞳，照彻黑夜。")
	invocation_type = "whisper"
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charge_slowdown = 2
	xp_gain = TRUE
	point_cost = 4

/datum/action/cooldown/spell/z121/invoked/group_darkvision/z121_apply(atom/cast_on)
	var/mob/user = owner
	for(var/mob/living/L in range(1, user))
		L.apply_status_effect(/datum/status_effect/buff/group_darkvision, user.get_skill_level(associated_skill))
	return TRUE

/atom/movable/screen/alert/status_effect/buff/group_fortitude
	name = "群体坚韧术"
	desc = "我的身心机能被群体坚韧术强化了。"
	icon_state = "buff"

/datum/status_effect/buff/group_fortitude
	parent_type = /datum/status_effect/buff/fortitude
	alert_type = /atom/movable/screen/alert/status_effect/buff/group_fortitude
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/buff/group_guidance
	name = "群体引导术"
	desc = "奥术之力正引导着我的动作。"
	icon_state = "buff"

/datum/status_effect/buff/group_guidance
	parent_type = /datum/status_effect/buff/guidance
	alert_type = /atom/movable/screen/alert/status_effect/buff/group_guidance
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/buff/group_haste
	name = "群体加速术"
	desc = "我正受到群体加速术的强化。"
	icon_state = "buff"

/datum/status_effect/buff/group_haste
	parent_type = /datum/status_effect/buff/attune_haste
	alert_type = /atom/movable/screen/alert/status_effect/buff/group_haste
	duration = 2 MINUTES

/atom/movable/screen/alert/status_effect/buff/group_longstrider
	name = "群体远行者之步"
	desc = "崎岖地形已无法阻碍我的步伐。"
	icon_state = "buff"

/datum/status_effect/buff/group_longstrider
	parent_type = /datum/status_effect/buff/longstrider
	alert_type = /atom/movable/screen/alert/status_effect/buff/group_longstrider
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/group_magic_flight
	name = "群体飞行术"
	desc = "魔法托举着我的身躯，让我得以自由飞行。"
	icon_state = "buff"

/datum/status_effect/buff/group_magic_flight
	parent_type = /datum/status_effect/buff/magic_flight
	alert_type = /atom/movable/screen/alert/status_effect/buff/group_magic_flight
	duration = 60 SECONDS

/datum/action/cooldown/spell/z121/invoked/group_enlarge
	name = "群体巨化术"
	desc = "暂时将自身与身旁近处的活物放大成高大魁梧的巨型姿态。本就魁梧如巨人或身形娇小者不受影响。"
	point_cost = 4
	button_icon_state = "enlarge"
	primary_resource_cost = 70
	hold_drain = 1
	charge_time = 2 SECONDS
	cooldown_time = 4 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	charge_slowdown = 3
	spell_tier = 3
	invocations = list("众躯膨胀壮大吧！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/arcane
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	cast_range = 7

/datum/action/cooldown/spell/z121/invoked/group_enlarge/z121_apply(atom/cast_on)
	var/mob/user = owner
	var/affected_any = FALSE
	for(var/mob/living/carbon/target in range(1, user))
		if(HAS_TRAIT(target, TRAIT_BIGGUY) || HAS_TRAIT(target, TRAIT_PETITE))
			continue
		ADD_TRAIT(target, TRAIT_BIGGUY, MAGIC_TRAIT)
		ADD_TRAIT(target, TRAIT_DEATHBYSNUSNU, MAGIC_TRAIT)
		target.transform = target.transform.Scale(1.25, 1.25)
		target.transform = target.transform.Translate(0, (0.25 * 16))
		target.update_transform()
		to_chat(target, span_warning("我感觉自己比平时高大得多，简直能直接撞穿一扇门！"))
		target.visible_message("[target]的身体膨胀变大了！")
		addtimer(CALLBACK(src, PROC_REF(remove_enlarge_buff), target), wait = 120 SECONDS)
		affected_any = TRUE

	if(!affected_any)
		to_chat(user, span_warning("周围没有可被群体巨化术影响的目标。"))
		z121_cancel()
		return FALSE

	user.visible_message(span_notice("[user] 的法术化作扩散的巨化之力，使周围的身影一同膨胀壮大！"))
	return TRUE

/datum/action/cooldown/spell/z121/invoked/group_enlarge/proc/remove_enlarge_buff(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_BIGGUY, MAGIC_TRAIT)
	REMOVE_TRAIT(target, TRAIT_DEATHBYSNUSNU, MAGIC_TRAIT)
	target.transform = target.transform.Translate(0, -(0.25 * 16))
	target.transform = target.transform.Scale(1/1.25, 1/1.25)
	target.update_transform()
	to_chat(target, span_warning("我突然感觉自己缩小了。"))
	target.visible_message("[target]的身体迅速缩小了！")

/datum/action/cooldown/spell/z121/invoked/group_fortitude_spell
	name = "群体坚韧术"
	desc = "强化施法者与周围 1 格内活物的耐力承受能力，持续时间翻倍。"
	point_cost = 6
	xp_gain = TRUE
	primary_resource_cost = 120
	hold_drain = 1
	charge_time = 2 SECONDS
	cooldown_time = 4 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	button_icon_state = "fortitude"
	spell_tier = 3
	invocations = list("赐吾等坚韧。")
	invocation_type = "whisper"
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charge_slowdown = 2
	associated_skill = /datum/skill/magic/arcane

/datum/action/cooldown/spell/z121/invoked/group_fortitude_spell/z121_apply(atom/cast_on)
	var/mob/user = owner
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)
	user.visible_message("[user]低声念诵咒文，绿色光辉如涟漪般扩散到周围。")
	for(var/mob/living/L in range(1, user))
		L.apply_status_effect(/datum/status_effect/buff/group_fortitude)
	return TRUE

/datum/action/cooldown/spell/z121/invoked/group_guidance
	name = "群体引导术"
	desc = "引导施法者与周围 1 格内活物的动作与战斗节奏，持续时间翻倍。"
	button_icon_state = "guidance"
	point_cost = 4
	xp_gain = TRUE
	primary_resource_cost = 120
	hold_drain = 1
	charge_time = 2 SECONDS
	cooldown_time = 4 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	spell_tier = 3
	invocations = list("指引吾等吧。")
	invocation_type = "whisper"
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charge_slowdown = 2
	associated_skill = /datum/skill/magic/arcane

/datum/action/cooldown/spell/z121/invoked/group_guidance/z121_apply(atom/cast_on)
	var/mob/user = owner
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)
	user.visible_message("[user]低声念诵咒文，橙色光辉化作薄幕笼罩周围。")
	for(var/mob/living/L in range(1, user))
		L.apply_status_effect(/datum/status_effect/buff/group_guidance)
	return TRUE

/datum/action/cooldown/spell/z121/invoked/group_haste
	shared_cooldown = "augment_attunement"
	name = "群体加速术"
	desc = "令施法者与周围 1 格内活物获得魔法加速效果，持续时间翻倍。"
	point_cost = 8
	xp_gain = TRUE
	primary_resource_cost = 120
	hold_drain = 1
	charge_time = 2 SECONDS
	cooldown_time = 4 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	button_icon_state = "haste"
	spell_tier = 3
	invocations = list("迅捷加诸吾等！")
	invocation_type = "shout"
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_MEDIUM
	charge_slowdown = 2
	associated_skill = /datum/skill/magic/arcane

/datum/action/cooldown/spell/z121/invoked/group_haste/z121_apply(atom/cast_on)
	var/mob/user = owner
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)
	user.visible_message("[user]高声念诵咒文，黄色光辉瞬间扩散到周围每个人身上。")
	for(var/mob/living/L in range(1, user))
		L.apply_status_effect(/datum/status_effect/buff/group_haste)
	return TRUE

/datum/action/cooldown/spell/z121/invoked/group_longstrider
	name = "群体远行者之步"
	desc = "赐予施法者与周围 1 格内活物持续 30 分钟的崎岖地形自由通行能力。"
	point_cost = 4
	xp_gain = TRUE
	primary_resource_cost = 100
	hold_drain = 0
	charge_time = 2 SECONDS
	cooldown_time = 3 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	spell_tier = 2
	invocations = list("长步远行，同行无阻。")
	invocation_type = "whisper"
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charge_slowdown = 2
	associated_skill = /datum/skill/magic/arcane
	cast_range = 7

/datum/action/cooldown/spell/z121/invoked/group_longstrider/z121_apply(atom/cast_on)
	var/mob/user = owner
	user.visible_message("[user] 低声念出咒文，一圈更为清晰的黯淡光晕自其身上扩散开来。")
	for(var/mob/living/L in range(1, user))
		L.apply_status_effect(/datum/status_effect/buff/group_longstrider)
	return TRUE

/datum/action/cooldown/spell/z121/invoked/group_stoneskin
	name = "群体防御增幅"
	button_icon_state = "stoneskin"
	desc = "清除自身与周围一格活物的易伤、暴露、施法干扰与佯攻破绽。"
	point_cost = 4
	xp_gain = TRUE
	primary_resource_cost = 120
	hold_drain = 1
	charge_time = 2 SECONDS
	cooldown_time = 4 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	spell_tier = 3
	invocations = list("如磐石般屹立，共承其坚。")
	invocation_type = "whisper"
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charge_slowdown = 2
	associated_skill = /datum/skill/magic/arcane
	cast_range = 7

/datum/action/cooldown/spell/z121/invoked/group_stoneskin/z121_apply(atom/cast_on)
	var/mob/user = owner
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)
	user.visible_message("[user]的魔力扩散开来，修复了周围众人的防御破绽。")
	for(var/mob/living/L in range(1, user))
		for(var/effect_type in list(/datum/status_effect/debuff/exposed, /datum/status_effect/debuff/cast_disrupted, /datum/status_effect/debuff/vulnerable, /datum/status_effect/debuff/feinted))
			L.remove_status_effect(effect_type)
	return TRUE

/datum/action/cooldown/spell/z121/invoked/group_giants_strength
	shared_cooldown = "augment_attunement"
	name = "群体巨人之力"
	desc = "强化自身与周围一格的活物，力量增加四点。与巨人、鹰眼和迅捷协调互斥。"
	point_cost = 8
	xp_gain = TRUE
	primary_resource_cost = 120
	hold_drain = 1
	charge_time = 2 SECONDS
	cooldown_time = 4 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	button_icon_state = "giants_strength"
	spell_tier = 3
	invocations = list("巨人之力，加诸吾等。")
	invocation_type = "whisper"
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charge_slowdown = 2
	associated_skill = /datum/skill/magic/arcane
	cast_range = 7

/datum/action/cooldown/spell/z121/invoked/group_giants_strength/z121_apply(atom/cast_on)
	var/mob/user = owner
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)
	user.visible_message("[user] 低声念诵咒文，周围众人的肌肉随之隆起壮大。")
	for(var/mob/living/L in range(1, user))
		L.apply_status_effect(/datum/status_effect/buff/attune_giant, ATTUNE_BUFF_DURATION)
	return TRUE

/datum/action/cooldown/spell/z121/invoked/group_leap
	name = "群体腾跃术"
	desc = "强化施法者与周围 1 格内活物的双腿，使其在更长时间内高高跃起。"
	point_cost = 4
	primary_resource_cost = 70
	hold_drain = 1
	charge_time = 2 SECONDS
	cooldown_time = 4 MINUTES
	gesture_required = TRUE
	spell_tier = 2
	invocations = list("众身齐跃！")
	invocation_type = "whisper"
	hide_charge_effect = TRUE
	charge_slowdown = 3
	associated_skill = /datum/skill/magic/arcane
	button_icon_state = "rune5"
	cast_range = 7

/datum/action/cooldown/spell/z121/invoked/group_leap/z121_apply(atom/cast_on)
	var/mob/user = owner
	var/affected_any = FALSE
	for(var/mob/living/carbon/target in range(1, user))
		if(HAS_TRAIT(target, TRAIT_ZJUMP))
			continue
		ADD_TRAIT(target, TRAIT_ZJUMP, MAGIC_TRAIT)
		to_chat(target, span_warning("我的双腿变得更有力了！我感觉自己能一跃而起！"))
		addtimer(CALLBACK(src, PROC_REF(remove_leap_buff), target), wait = 40 SECONDS)
		affected_any = TRUE

	if(!affected_any)
		to_chat(user, span_warning("周围没有可被群体腾跃术影响的目标。"))
		z121_cancel()
		return FALSE

	user.visible_message(span_notice("[user] 的法术化作轻盈之风，使周围众人的双腿都充满爆发力。"))
	return TRUE

/datum/action/cooldown/spell/z121/invoked/group_leap/proc/remove_leap_buff(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_ZJUMP, MAGIC_TRAIT)
	to_chat(target, span_warning("我的双腿忽然变得沉重无力。"))
	target.Immobilize(5)

// 群体协调与原生协调使用同一组状态；任一方向替换都会清除另两种。
// 鹰眼原有的感知增益互斥组保持不变。
/datum/status_effect/buff/attune_giant/on_apply()
	owner.remove_status_effect(/datum/status_effect/buff/attune_haste)
	owner.remove_status_effect(/datum/status_effect/buff/attune_hawk)
	return ..()

/datum/status_effect/buff/attune_haste/on_apply()
	owner.remove_status_effect(/datum/status_effect/buff/attune_giant)
	owner.remove_status_effect(/datum/status_effect/buff/attune_hawk)
	return ..()

/datum/status_effect/buff/attune_hawk/on_apply()
	owner.remove_status_effect(/datum/status_effect/buff/attune_giant)
	owner.remove_status_effect(/datum/status_effect/buff/attune_haste)
	return ..()
