// 两种缩小术共用目标检查和唯一状态，不能叠加或刷新。
/proc/z121_can_shrink(mob/living/carbon/target)
	return istype(target) && !QDELETED(target) \
		&& !HAS_TRAIT(target, TRAIT_BIGGUY) && !HAS_TRAIT(target, TRAIT_PETITE)

/obj/effect/proc_holder/spell/invoked/shrink
	name = "缩小术"
	desc = "以魔力使一具身躯变得娇小轻盈，步履灵巧，行踪难辨，约莫维持一分钟。天生矮小的族裔不会变得更小；已然娇小或拥有巨人体魄者不受此术影响。"
	cost = 2
	overlay_state = "rune1"
	releasedrain = 35
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 2 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	spell_tier = 2
	school = "evocation"
	invocations = list("轻盈缩小吧！")
	invocation_type = "shout"
	chargedloop = /datum/looping_sound/wind
	associated_skill = /datum/skill/magic/arcane
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	range = 7

/obj/effect/proc_holder/spell/invoked/shrink/cast(list/targets, mob/user = usr)
	if(!length(targets) || !z121_can_shrink(targets[1]))
		to_chat(user, span_warning("缩小的魔力无法改变眼前之物。"))
		revert_cast()
		return FALSE
	var/mob/living/carbon/target = targets[1]
	if(!target.apply_status_effect(/datum/status_effect/buff/z121_shrink, 60 SECONDS))
		revert_cast()
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/group_shrink
	parent_type = /obj/effect/proc_holder/spell/invoked/shrink
	name = "群体缩小术"
	desc = "让缩小的魔力环绕自身，使身旁近处的众生变得娇小轻盈，步履灵巧，行踪难辨，约莫维持两分钟。天生矮小的族裔不会变得更小；已然娇小或拥有巨人体魄者不受此术影响。"
	cost = 4
	overlay_state = "enlarge"
	releasedrain = 70
	chargetime = 2 SECONDS
	recharge_time = 4 MINUTES
	spell_tier = 3
	invocations = list("众躯轻盈缩小吧！")

/obj/effect/proc_holder/spell/invoked/group_shrink/cast(list/targets, mob/user = usr)
	var/affected_any = FALSE
	for(var/mob/living/carbon/target in range(1, user))
		if(!z121_can_shrink(target))
			continue
		if(target.apply_status_effect(/datum/status_effect/buff/z121_shrink, 120 SECONDS))
			affected_any = TRUE
	if(!affected_any)
		to_chat(user, span_warning("缩小的魔力流散开来，却未能改变周围的任何身躯。"))
		revert_cast()
		return FALSE
	user.visible_message(span_notice("[user]的法术化作轻盈的微光，笼罩着周围的身影！"))
	return TRUE

/datum/status_effect/buff/z121_shrink
	id = "z121_shrink"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 60 SECONDS
	tick_interval = -1
	alert_type = /atom/movable/screen/alert/status_effect/buff/z121_shrink
	var/was_scaled = FALSE
	var/applied = FALSE

/datum/status_effect/buff/z121_shrink/on_creation(mob/living/new_owner, buff_duration = 60 SECONDS)
	duration = buff_duration
	return ..()

/datum/status_effect/buff/z121_shrink/on_apply()
	if(!z121_can_shrink(owner))
		return FALSE
	// 父过程记录经过上限修正的属性增量，到期时只撤销实际施加的部分。
	effectedstats = list(STATKEY_SPD = 1)
	. = ..()
	if(!.)
		return FALSE
	applied = TRUE
	ADD_TRAIT(owner, TRAIT_PETITE, TRAIT_STATUS_EFFECT(id))
	was_scaled = z121_apply_small_size_scale(owner)
	to_chat(owner, span_notice("我感觉身躯轻盈，脚步也更加隐秘了。"))
	if(was_scaled)
		owner.visible_message(span_notice("[owner]的身体缩小了！"))
	return TRUE

/datum/status_effect/buff/z121_shrink/on_remove()
	if(!applied)
		return
	REMOVE_TRAIT(owner, TRAIT_PETITE, TRAIT_STATUS_EFFECT(id))
	if(!QDELETED(owner))
		if(was_scaled)
			z121_remove_small_size_scale(owner)
			owner.visible_message(span_notice("[owner]的身体恢复了原本的大小！"))
		to_chat(owner, span_notice("缩小术的魔力散去，我恢复了原本的状态。"))
	return ..()

/atom/movable/screen/alert/status_effect/buff/z121_shrink
	name = "缩小术"
	desc = "缩小的魔力令我的身躯轻盈灵巧，脚步也更难被察觉。在这股魔力散去之前，巨化术无法改变我的身形。"
	icon_state = "buff"

// 单体巨化的目标检查在模块内扩展，其余效果与原法术一致。
/obj/effect/proc_holder/spell/invoked/enlarge
	desc = "暂时将身躯放大成高大魁梧的巨型姿态，足以撞开门扉。对本就魁梧如巨人或身形娇小者无效。"

/obj/effect/proc_holder/spell/invoked/enlarge/cast(list/targets, mob/user = usr)
	if(length(targets) && isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_BIGGUY) || HAS_TRAIT(target, TRAIT_PETITE))
			to_chat(user, span_warning("巨化的魔力无法改变对方的身形！"))
			revert_cast()
			return FALSE
		ADD_TRAIT(target, TRAIT_BIGGUY, MAGIC_TRAIT)
		ADD_TRAIT(target, TRAIT_DEATHBYSNUSNU, MAGIC_TRAIT)
		target.transform = target.transform.Scale(1.25, 1.25)
		target.transform = target.transform.Translate(0, (0.25 * 16))
		target.update_transform()
		to_chat(target, span_warning("我感觉自己比平时高大得多，简直能直接撞穿一扇门！"))
		target.visible_message("[target]的身体膨胀变大了！")
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = 60 SECONDS)
		return TRUE
	return FALSE
