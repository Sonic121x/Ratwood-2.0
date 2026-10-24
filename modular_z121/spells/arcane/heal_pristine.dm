// modular_z121 自定义奥术法术：愈合如初
// 仅在 modular_z121 内实现，不改动主线治疗与伤口系统。

/datum/action/cooldown/spell/z121/invoked/heal_pristine
	name = "愈合如初"
	desc = "以温和的奥术唤醒血肉中残存的生机，让伤躯渐渐重拾往日的模样。"
	point_cost = 6
	xp_gain = TRUE
	primary_resource_cost = 10
	hold_drain = 0
	charge_time = 0
	cooldown_time = 20 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	spell_tier = 3
	button_icon = 'modular_z121/icon/custompell.dmi'
	button_icon_state = "heal_pristine"
	invocations = list("愈合如初！")
	invocation_type = "shout"
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	associated_skill = /datum/skill/magic/arcane
	cast_range = 7
	miracle = FALSE
	gesture_required = TRUE
	// 治疗量按全身伤害计算，不随奥术技能等级变化。
	var/healing_amount = 5

/datum/action/cooldown/spell/z121/invoked/heal_pristine/z121_apply(atom/cast_on)
	var/list/targets = list(cast_on)
	var/mob/living/user = owner
	if(user?.curplaying)
		user.curplaying.on_mouse_up()

	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		to_chat(user, span_warning("愈合如初只能对活物施放。"))
		z121_cancel()
		return FALSE

	var/mob/living/target = target_atom
	if(target.stat == DEAD)
		to_chat(user, span_warning("这道法术无法令死者愈合。"))
		z121_cancel()
		return FALSE
	if(target.anti_magic_check())
		target.visible_message(span_warning("[target] 周身泛起一阵反魔法涟漪，将这股治愈魔力尽数震散！"))
		to_chat(user, span_warning("[target] 身上的反魔法抵消了愈合如初。"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		z121_cancel()
		return FALSE

	if(!can_heal_target(target))
		to_chat(user, span_warning("[target] 眼下没有可被愈合如初扭转的伤势。"))
		z121_cancel()
		return FALSE

	apply_direct_healing(target)

	playsound(get_turf(target), 'sound/magic/whiteflame.ogg', 80, TRUE)
	new /obj/effect/temp_visual/heal_rogue(get_turf(target))
	user.visible_message(span_notice("[user] 朝着 [target] 念出古老咒言，一股柔和却澎湃的魔力随即涌入 [target] 的伤躯。"))
	to_chat(user, span_notice("我将回春般的魔力灌入 [target] 体内，强行加快了 [target.p_their()] 伤势的愈合。"))
	to_chat(target, span_notice("暖流从伤处蔓延开来，我能感觉到血肉正在以反常的速度愈合。"))
	return TRUE

/datum/action/cooldown/spell/z121/invoked/heal_pristine/proc/can_heal_target(mob/living/target)
	return target.getBruteLoss() > 0 || target.getFireLoss() > 0

/datum/action/cooldown/spell/z121/invoked/heal_pristine/proc/apply_direct_healing(mob/living/target)
	// 仅恢复物理与烧伤，不处理伤口，避免普通版间接止血。
	target.adjustBruteLoss(-healing_amount, FALSE)
	target.adjustFireLoss(-healing_amount, FALSE)
	target.updatehealth()

/datum/action/cooldown/spell/z121/invoked/heal_pristine/greater
	name = "强效愈合如初"
	desc = "以丰沛的奥术抚平血肉的创痛，让流逝的生机重新安定于伤躯之中。"
	point_cost = 1
	cooldown_time = 3 SECONDS
	healing_amount = 20
	invocations = list("愈合如初！")

/datum/action/cooldown/spell/z121/invoked/heal_pristine/greater/can_heal_target(mob/living/target)
	if(..())
		return TRUE
	// 仅有伤口出血或疼痛时，强效版仍可施放。
	for(var/datum/wound/wound as anything in target.get_wounds())
		if(isnull(wound))
			continue
		if(wound.bleed_rate > 0 || wound.woundpain > 0)
			return TRUE
	return FALSE

/datum/action/cooldown/spell/z121/invoked/heal_pristine/greater/apply_direct_healing(mob/living/target)
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
