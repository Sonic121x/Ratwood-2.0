// modular_z121 自定义奥术法术：愈合如初
// 仅在 modular_z121 内实现，不改动主线治疗与伤口系统。

/obj/effect/proc_holder/spell/invoked/heal_pristine
	name = "愈合如初"
	desc = "以魔力缓解伤势，随奥术造诣提升治疗量。可止住一处出血，高深造诣还可温和促进伤口愈合。"
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

	var/arcane_level = max(user.get_skill_level(/datum/skill/magic/arcane), 0)
	if(arcane_level <= 0)
		to_chat(user, span_warning("我对这道愈伤魔法的理解还远远不够。"))
		revert_cast()
		return FALSE
	if(!can_heal_target(target, arcane_level))
		to_chat(user, span_warning("[target] 眼下没有可被愈合如初扭转的伤势。"))
		revert_cast()
		return FALSE

	var/list/healing_profile = get_healing_profile(arcane_level)
	apply_direct_healing(
		target,
		healing_profile["brute"],
		healing_profile["burn"],
		healing_profile["toxin"],
		healing_profile["oxygen"],
	)

	var/stopped_bleeding = FALSE
	if(arcane_level >= 2)
		stopped_bleeding = stop_single_bleeding_wound(target)

	if(arcane_level >= 4)
		soften_remaining_wounds(target, healing_profile["wound_heal"])

	playsound(get_turf(target), 'sound/magic/whiteflame.ogg', 80, TRUE)
	new /obj/effect/temp_visual/heal_rogue(get_turf(target))
	user.visible_message(span_notice("[user] 朝着 [target] 念出古老咒言，一股柔和却澎湃的魔力随即涌入 [target] 的伤躯。"))
	to_chat(user, span_notice("我将回春般的魔力灌入 [target] 体内，强行加快了 [target.p_their()] 伤势的愈合。"))
	if(stopped_bleeding)
		to_chat(target, span_notice("我一处伤口的出血止住了，暖意逐渐浸入伤躯。"))
	else
		to_chat(target, span_notice("暖流从伤处蔓延开来，我能感觉到血肉正在以反常的速度愈合。"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/heal_pristine/proc/can_heal_target(mob/living/target, arcane_level)
	if(target.getBruteLoss() > 0)
		return TRUE
	if(target.getFireLoss() > 0)
		return TRUE
	if(arcane_level >= 3 && target.getToxLoss() > 0)
		return TRUE
	if(arcane_level >= 5 && target.getOxyLoss() > 0)
		return TRUE
	if(arcane_level >= 2 && has_bleeding_wound(target))
		return TRUE
	if(arcane_level >= 4)
		for(var/datum/wound/wound as anything in target.get_wounds())
			if(can_affect_wound(wound))
				return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/heal_pristine/proc/can_affect_wound(datum/wound/wound)
	// 出血单独判断；单有疼痛或不可正常治疗的特殊伤口不能触发施法。
	return !isnull(wound) && !isnull(wound.whp) && wound.whp > 0

/obj/effect/proc_holder/spell/invoked/heal_pristine/proc/get_healing_profile(arcane_level)
	var/list/profile = list(
		"brute" = 5,
		"burn" = 5,
		"toxin" = 0,
		"oxygen" = 0,
		"wound_heal" = 0,
	)
	if(arcane_level == 2)
		profile["brute"] = 10
		profile["burn"] = 10
	else if(arcane_level == 3)
		profile["brute"] = 20
		profile["burn"] = 20
		profile["toxin"] = 20
	else if(arcane_level == 4)
		profile["brute"] = 30
		profile["burn"] = 30
		profile["toxin"] = 30
		profile["wound_heal"] = 5
	else if(arcane_level >= 5)
		profile["brute"] = 40
		profile["burn"] = 40
		profile["toxin"] = 40
		profile["oxygen"] = 40
		profile["wound_heal"] = 10
	return profile

/obj/effect/proc_holder/spell/invoked/heal_pristine/proc/apply_direct_healing(mob/living/target, brute_heal, burn_heal, toxin_heal, oxygen_heal)
	if(brute_heal > 0)
		target.adjustBruteLoss(-brute_heal, FALSE)
	if(burn_heal > 0)
		target.adjustFireLoss(-burn_heal, FALSE)
	if(toxin_heal > 0)
		target.adjustToxLoss(-toxin_heal, FALSE)
	if(oxygen_heal > 0)
		target.adjustOxyLoss(-oxygen_heal, FALSE)
	target.updatehealth()

/obj/effect/proc_holder/spell/invoked/heal_pristine/proc/has_bleeding_wound(mob/living/target)
	for(var/datum/wound/wound as anything in target.get_wounds())
		if(isnull(wound))
			continue
		if(wound.bleed_rate > 0)
			return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/heal_pristine/proc/stop_single_bleeding_wound(mob/living/target)
	var/datum/wound/selected_wound
	for(var/datum/wound/wound as anything in target.get_wounds())
		if(isnull(wound) || wound.bleed_rate <= 0)
			continue
		if(!selected_wound || wound.bleed_rate > selected_wound.bleed_rate)
			selected_wound = wound

	if(!selected_wound)
		return FALSE

	selected_wound.set_bleed_rate(0)
	return TRUE

/obj/effect/proc_holder/spell/invoked/heal_pristine/proc/soften_remaining_wounds(mob/living/target, wound_heal)
	if(wound_heal <= 0)
		return FALSE
	return target.heal_wounds(wound_heal)
