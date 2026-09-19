// modular_z121 自定义奥术法术：愈合如初
// 仅在 modular_z121 内实现，不改动主线治疗与伤口系统。

/obj/effect/proc_holder/spell/invoked/heal_pristine
	name = "愈合如初"
	desc = "以温和的奥术唤醒血肉中残存的生机，让伤躯渐渐重拾往日的模样。"
	cost = 6
	xp_gain = TRUE
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	recharge_time = 20 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	school = "restoration"
	spell_tier = 3
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "heal_pristine"
	invocations = list("愈合如初！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	no_early_release = TRUE
	movement_interrupt = FALSE
	associated_skill = /datum/skill/magic/arcane
	range = 7
	miracle = FALSE
	gesture_required = TRUE
	// 治疗量按全身伤害计算，不随奥术技能等级变化。
	var/healing_amount = 5

/obj/effect/proc_holder/spell/invoked/heal_pristine/cast(list/targets, mob/living/user = usr)
	if(user?.curplaying)
		user.curplaying.on_mouse_up()

	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		to_chat(user, span_warning("愈合如初只能对活物施放。"))
		revert_cast()
		return FALSE

	var/mob/living/target = target_atom
	if(target.stat == DEAD)
		to_chat(user, span_warning("这道法术无法令死者愈合。"))
		revert_cast()
		return FALSE
	if(target.anti_magic_check())
		target.visible_message(span_warning("[target] 周身泛起一阵反魔法涟漪，将这股治愈魔力尽数震散！"))
		to_chat(user, span_warning("[target] 身上的反魔法抵消了愈合如初。"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		revert_cast()
		return FALSE

	if(!can_heal_target(target))
		to_chat(user, span_warning("[target] 眼下没有可被愈合如初扭转的伤势。"))
		revert_cast()
		return FALSE

	apply_direct_healing(target)

	playsound(get_turf(target), 'sound/magic/whiteflame.ogg', 80, TRUE)
	new /obj/effect/temp_visual/heal_rogue(get_turf(target))
	if(!z121_silent(user))
		user.visible_message(span_notice("[user] 朝着 [target] 念出古老咒言，一股柔和却澎湃的魔力随即涌入 [target] 的伤躯。"))
	else
		user.visible_message(span_notice("[user] 指尖泛起柔光，一股温和的魔力涌入 [target] 的伤躯。"))
	to_chat(user, span_notice("我将回春般的魔力灌入 [target] 体内，强行加快了 [target.p_their()] 伤势的愈合。"))
	to_chat(target, span_notice("暖流从伤处蔓延开来，我能感觉到血肉正在以反常的速度愈合。"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/heal_pristine/proc/can_heal_target(mob/living/target)
	return target.getBruteLoss() > 0 || target.getFireLoss() > 0

/obj/effect/proc_holder/spell/invoked/heal_pristine/proc/apply_direct_healing(mob/living/target)
	// 仅恢复物理与烧伤，不处理伤口，避免普通版间接止血。
	// 只有实际存在数值伤势才把强效视为适用，单纯止血和消痛不扣额度。
	var/power = (target.getBruteLoss() > 0 || target.getFireLoss() > 0) ? z121_power(1) : 1
	target.adjustBruteLoss(-healing_amount * power, FALSE)
	target.adjustFireLoss(-healing_amount * power, FALSE)
	target.updatehealth()

/obj/effect/proc_holder/spell/invoked/heal_pristine/greater
	name = "强效愈合如初"
	desc = "以丰沛的奥术抚平血肉的创痛，让流逝的生机重新安定于伤躯之中。"
	cost = 1
	recharge_time = 3 SECONDS
	healing_amount = 20
	invocations = list("愈合如初！")

/obj/effect/proc_holder/spell/invoked/heal_pristine/greater/can_heal_target(mob/living/target)
	if(..())
		return TRUE
	// 仅有伤口出血或疼痛时，强效版仍可施放。
	for(var/datum/wound/wound as anything in target.get_wounds())
		if(isnull(wound))
			continue
		if(wound.bleed_rate > 0 || wound.woundpain > 0)
			return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/heal_pristine/greater/apply_direct_healing(mob/living/target)
	..()
	// 清除现有伤口的出血与疼痛，不删除伤口，也不赋予无痛免疫。
	for(var/datum/wound/wound as anything in target.get_wounds())
		if(isnull(wound))
			continue
		if(wound.bleed_rate > 0)
			wound.set_bleed_rate(0)
		wound.woundpain = 0
	target.mark_pain_hud_dirty()
	target.mark_zone_selector_hud_dirty()
