/obj/effect/proc_holder/spell/invoked/psydonlux_tamper
	name = "泣血"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "WEEP"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	desc = "为目标流出自己的鲜血，承受他们的伤口，并为其补足血量。"
	movement_interrupt = FALSE
	sound = 'sound/magic/psydonbleeds.ogg'
	invocations = list("我以鲜血代偿，好让你得以撑下去！")
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 SECONDS
	miracle = TRUE
	devotion_cost = 80

/obj/effect/proc_holder/spell/invoked/psydonlux_tamper/cast(list/targets, mob/living/user)
	if(!ishuman(targets[1]))
		to_chat(user, span_warning("对方的灵辉无需净化。"))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = targets[1]

	if(H == user)
		to_chat(user, span_warning("我自身的灵辉仍维持着纯净。"))
		revert_cast()
		return FALSE

	if(H.stat == DEAD)
		to_chat(user, span_warning("[H] 的灵辉已经离去。我已无能为力。"))
		user.emote("cry")
		revert_cast()
		return FALSE

	var/wounds_wept = FALSE
	var/blood_wept = FALSE

	// Transfer wounds.
	if(ishuman(H) && ishuman(user))
		var/mob/living/carbon/human/C_target = H
		var/mob/living/carbon/human/C_caster = user
		var/list/datum/wound/tw_List = C_target.get_wounds()

		if(tw_List.len)
			playsound(get_turf(user), 'sound/magic/psydonbleeds.ogg', 50, TRUE)
			C_caster.visible_message(span_warning("一缕银色灵辉从[C_caster]身上延伸而出，连上[C_target]，散发着柔和的光芒……"), span_warning("你开始将自己的灵辉与[C_target]的灵辉交织，将对方的伤口转移到自己身上……"))
			var/static/list/disallowed_wounds = typecacheof(list(/datum/wound/dismemberment, /datum/wound/facial, /datum/wound/fracture/head, /datum/wound/fracture/neck, /datum/wound/cbt/permanent, /datum/wound/grievous/pre_decapitation, /datum/wound/grievous/pre_skullshatter))
			for(var/datum/wound/targetwound in tw_List)
				if(disallowed_wounds[targetwound.type])
					continue
				if(move_after(user, 0.5 SECONDS, needhand = FALSE, target = user))
					if(!targetwound) // it's possible they might've healed on or advanced
						continue
					wounds_wept = TRUE // This isn't *particularly* hot code, so this should be fine.
					var/obj/item/bodypart/c_BP = C_caster.get_bodypart(targetwound.bodypart_owner.body_zone)
					// instead of recreating a new wound of the same type as the victims, we can just transfer theirs (includes any existing healing/clotting) over to us
					var/pre_bleeding = targetwound.bleed_rate
					targetwound.apply_to_bodypart(c_BP, silent = TRUE, crit_message = FALSE)
					targetwound.set_bleed_rate(pre_bleeding) // but we have to manually force a bleed_rate reset for it to cache properly
					if(targetwound.severity >= WOUND_SEVERITY_SEVERE)
						if(HAS_TRAIT(H, TRAIT_INQUISITION))
							to_chat(H, span_notice("你感到自己的伤口正悄然消逝。"))
						else
							to_chat(H, span_danger("你感到一阵撕裂，仿佛有一缕灵辉被替换掉了！"))
						C_caster.visible_message(span_danger("扭动的银色灵辉之线在[C_caster]的皮肉上绽开，将[targetwound]转移到了[C_caster.p_their()]的[c_BP.name]上！"), span_boldwarning("你的[c_BP.name]上骤然裂开一道[targetwound]，令你痛得浑身颤抖！"))
					new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#487e97")
					new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#487e97")
					C_target.Beam(C_caster, icon_state="heal_psycross", icon='modular_azurepeak/icons/effects/miracle-healing.dmi', time = 5)

	// Transfer blood
	if(H.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		blood_wept = TRUE
		var/blood_transfer = 0
		blood_transfer = BLOOD_VOLUME_NORMAL - H.get_blood_volume()
		H.set_blood_volume(BLOOD_VOLUME_NORMAL)
		user.adjust_blood_volume(-(blood_transfer))
		if(HAS_TRAIT(H, TRAIT_INQUISITION))
			to_chat(H, span_notice("我感到血液重新流回了体内。"))
		else
			to_chat(H, span_warning("随着血液得到补充，我感到自己的灵辉一阵战栗！"))
		user.visible_message(span_warning("一阵苍白骤然笼罩了[user]，[user.p_their()]的命髓从毛孔中涌出，流入[H]体内！"), span_warning("你感到自己的血液流入[H]体内！"))
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#487e97")
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#487e97")

	if(!wounds_wept && !blood_wept)
		to_chat(user, span_warning("[H]无需净化。"))
		revert_cast()
		return FALSE

	// Notify the user and target
	to_chat(user, span_notice("片刻之间，我以彼此相融的灵辉净化了对方。"))
	if(HAS_TRAIT(H, TRAIT_INQUISITION))
		to_chat(H, span_notice("你的伤口正被那银色的丝线抹去。"))
	else
		to_chat(H, span_danger("你感觉有什么东西正攫住你的灵辉，窃走其中一部分！"))
		to_chat(H, span_notice("你的伤口似乎在渐渐消失。"))
	return TRUE

/obj/effect/proc_holder/spell/self/psydonrespite
	name = "息憩"
	desc = "以少许维系生命的鲜血为代价，我可以静立原地，专心修补自身伤势。"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "RESPITE"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 5 SECONDS
	miracle = TRUE
	devotion_cost = 0

/obj/effect/proc_holder/spell/self/psydonrespite/cast(mob/living/carbon/human/user) // It's a very tame self-heal. Nothing too special.
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = user
	var/brute = H.getBruteLoss()
	var/burn = H.getFireLoss()
	var/conditional_buff = FALSE
	var/zcross_trigger = FALSE
	var/sit_bonus1 = 0
	var/sit_bonus2 = 0
	var/psicross_bonus = 0

	for(var/obj/item/clothing/neck/current_item in H.get_equipped_items(TRUE))
		if(current_item.type in list(/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient, /obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/wood, /obj/item/clothing/neck/roguetown/psicross/decrepit, /obj/item/clothing/neck/roguetown/psicross/silver, /obj/item/clothing/neck/roguetown/psicross/silver/sojourner, /obj/item/clothing/neck/roguetown/psicross/g))
			switch(current_item.type) // Worn Psicross Piety bonus. For fun.
				if(/obj/item/clothing/neck/roguetown/psicross/wood)
					psicross_bonus = -2
				if(/obj/item/clothing/neck/roguetown/psicross/decrepit)
					psicross_bonus = -4
				if(/obj/item/clothing/neck/roguetown/psicross)
					psicross_bonus = -5
				if(/obj/item/clothing/neck/roguetown/psicross/silver, /obj/item/clothing/neck/roguetown/psicross/silver/sojourner)
					psicross_bonus = -7
				if(/obj/item/clothing/neck/roguetown/psicross/g) // PURITY AFLOAT.
					psicross_bonus = -7
				if(/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient)
					zcross_trigger = TRUE
	if(brute > 100)
		sit_bonus1 = -2
	if(brute > 150)
		sit_bonus1 = -4
	if(brute > 200)
		sit_bonus1 = -6
	if(brute > 300)
		sit_bonus1 = -8
	if(brute > 350)
		sit_bonus1 = -10
	if(brute > 400)
		sit_bonus1 = -14

	if(burn > 100)
		sit_bonus2 = -2
	if(burn > 150)
		sit_bonus2 = -4
	if(burn > 200)
		sit_bonus2 = -6
	if(burn > 300)
		sit_bonus2 = -8
	if(burn > 350)
		sit_bonus2 = -10
	if(burn > 400)
		sit_bonus2 = -14

	if(sit_bonus1 || sit_bonus2)
		conditional_buff = TRUE

	var/bruthealval = -7 + psicross_bonus + sit_bonus1
	var/burnhealval = -7 + psicross_bonus + sit_bonus2

	to_chat(H, span_info("我稍作停顿，收束心神……"))

	if(HAS_TRAIT(user, TRAIT_LUX_FREAK) && zcross_trigger) // LUX ABOMINATIONS WONT STOP SO EASLY!!!
		user.visible_message(span_warning("[user]浑身一颤，但双眼闪过银光，随即继续施术。"), span_userdanger("一阵寒意贯穿我的脊背，黑暗的狂笑回荡不止，但我凝神于自己的灵辉，硬撑了下来。"))
		zcross_trigger = FALSE

	if(zcross_trigger)
		user.visible_message(span_warning("[user] 猛地一颤。情况很不对劲。"), span_userdanger("一股寒意窜上我的脊背。有什么东西在嘲笑我的尝试。"))
		user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)
		user.adjustBruteLoss(25)
		return FALSE

	if(do_after(H, 50))
		playsound(H, 'sound/magic/psydonrespite.ogg', 100, TRUE)
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4")
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4")
		H.adjustBruteLoss(bruthealval)
		H.adjustFireLoss(burnhealval)
		H.set_blood_volume(max(H.get_blood_volume()-6, 0))//Don't sit here and heal all day. Thanks.
		if (conditional_buff)
			to_chat(user, span_info("疼痛短暂退去，化作更清晰的意识，随后又钝钝地回到我身上。"))
		user.devotion?.update_devotion(-20)
		to_chat(user, "<font color='purple'>我失去了 20 点虔诚！</font>")
		cast(user)
		return TRUE
	else
		to_chat(H, span_warning("我的思绪与那份宁静从指缝间溜走了。"))
		return FALSE


/obj/effect/proc_holder/spell/self/psydonpersist
	name = "坚持"
	desc = "静立不动，专心修补你的伤势。你必须坚持下去。"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "PERSIST"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 5 SECONDS
	miracle = TRUE
	devotion_cost = 0

/obj/effect/proc_holder/spell/self/psydonpersist/cast(mob/living/carbon/human/user) // It's a very tame self-heal. Nothing too special.
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = user
	var/brute = H.getBruteLoss()
	var/burn = H.getFireLoss()
	var/conditional_buff = FALSE
	var/zcross_trigger = FALSE
	var/sit_bonus1 = 0
	var/sit_bonus2 = 0
	var/psicross_bonus = 0

	for(var/obj/item/clothing/neck/current_item in H.get_equipped_items(TRUE))
		if(current_item.type in list(/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient, /obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/wood, /obj/item/clothing/neck/roguetown/psicross/decrepit, /obj/item/clothing/neck/roguetown/psicross/silver, /obj/item/clothing/neck/roguetown/psicross/silver/sojourner, /obj/item/clothing/neck/roguetown/psicross/g))
			switch(current_item.type) // Worn Psicross Piety bonus. For fun.
				if(/obj/item/clothing/neck/roguetown/psicross/wood)
					psicross_bonus = -2
				if(/obj/item/clothing/neck/roguetown/psicross/decrepit)
					psicross_bonus = -4
				if(/obj/item/clothing/neck/roguetown/psicross)
					psicross_bonus = -5
				if(/obj/item/clothing/neck/roguetown/psicross/silver, /obj/item/clothing/neck/roguetown/psicross/silver/sojourner)
					psicross_bonus = -7
				if(/obj/item/clothing/neck/roguetown/psicross/g) // PURITY AFLOAT.
					psicross_bonus = -7
				if(/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient)
					zcross_trigger = TRUE
	if(brute > 100)
		sit_bonus1 = -2
	if(brute > 150)
		sit_bonus1 = -4
	if(brute > 200)
		sit_bonus1 = -6
	if(brute > 300)
		sit_bonus1 = -8
	if(brute > 350)
		sit_bonus1 = -10
	if(brute > 400)
		sit_bonus1 = -14

	if(burn > 100)
		sit_bonus2 = -2
	if(burn > 150)
		sit_bonus2 = -4
	if(burn > 200)
		sit_bonus2 = -6
	if(burn > 300)
		sit_bonus2 = -8
	if(burn > 350)
		sit_bonus2 = -10
	if(burn > 400)
		sit_bonus2 = -14

	if(sit_bonus1 || sit_bonus2)
		conditional_buff = TRUE

	var/bruthealval = -14 + psicross_bonus + sit_bonus1
	var/burnhealval = -14 + psicross_bonus + sit_bonus2

	to_chat(H, span_info("我凝神于自己体内，开始将血肉重新编织起来。")) // Why is he better then other psydonites? He is a lux freak that knows exactly what he is doing instead of just immitating miracles

	if(HAS_TRAIT(user, TRAIT_LUX_FREAK) && zcross_trigger) // LUX ABOMINATIONS WONT STOP SO EASLY!!! Kind of redoundant here since this is absolver special and he alwys has it, but futureprofing
		user.visible_message(span_warning("[user]浑身一颤，但双眼闪过银光，随即继续施术。"), span_userdanger("一阵寒意贯穿我的脊背，黑暗的狂笑回荡不止，但我凝神于自己的灵辉，硬撑了下来。"))
		zcross_trigger = FALSE
	
	if(zcross_trigger)
		user.visible_message(span_warning("[user]猛地一颤。情况非常不对劲。"), span_userdanger("一股寒意窜过我的脊背。有什么东西正在嘲笑我的尝试。"))
		user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)
		user.adjustBruteLoss(25)
		return FALSE

	if(do_after(H, 50))
		playsound(H, 'sound/magic/psydonrespite.ogg', 100, TRUE)
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4")
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4")
		H.adjustBruteLoss(bruthealval)
		H.adjustFireLoss(burnhealval)
		if (conditional_buff)
			to_chat(user, span_info("我的灵辉涌入伤口，迫使血肉重新弥合。"))
		user.devotion?.update_devotion(-60)
		to_chat(user, "<font color='purple'>我失去了 60 点虔诚！</font>")
		cast(user)
		return TRUE
	else
		to_chat(H, span_warning("我失去了专注，对灵辉的掌控也离我而去。"))
		return FALSE


/obj/effect/proc_holder/spell/invoked/psydonabsolve
	name = "赦免"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "ABSOLVE"
	desc = "赦免目标，将其伤害转移到自己身上，甚至可能以你的性命为代价代其赴死。"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	range = 1
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/psyabsolution.ogg'
	invocations = list("得蒙赦免吧！")
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 SECONDS 
	miracle = TRUE
	devotion_cost = 80

/obj/effect/proc_holder/spell/invoked/psydonabsolve/cast(list/targets, mob/living/user)

	if(!ishuman(targets[1]))
		to_chat(user, span_warning("“赦免”只对行于祂之形象下的人有效！"))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = targets[1]

	if(H == user)
		to_chat(user, span_warning("我不能对自己施展“赦免”！"))
		revert_cast()
		return FALSE

	// Special case for dead targets
	if(H.stat >= DEAD)
		if(!H.check_revive(user))
			revert_cast()
			return FALSE
		if(alert(user, "要伸手将其拉回来吗？", "其中已无灵辉", "否", "是") != "是")
			revert_cast()
			return FALSE
		to_chat(user, span_warning("我试图以“赦免”将 [H] 拉回人世！"))
		// Dramatic effect
		user.visible_message(span_danger("[user]一把抓住了[H]的手腕，银色的灵辉之线自其手中倾泻而出！"))

		if(alert(H, "对方想要赦免你。你愿意吗？", "赦免", "我愿接受", "我拒绝") != "我愿接受")
			H.visible_message(span_notice("什么也没有发生。"))
			return FALSE
		// Create visual effects
		H.apply_status_effect(/datum/status_effect/buff/psyvived)
		// Kill the caster
		user.say("我以此命换彼命！活下去，如他一般！", forced = TRUE)
		user.death()
		// Revive the target
		H.revive(full_heal = TRUE, admin_revive = FALSE)
		H.adjustOxyLoss(-H.getOxyLoss())
		H.grab_ghost(force = TRUE) // even suicides
		H.emote("breathgasp")
		H.Jitter(100)
		H.update_body()
		record_round_statistic(STATS_LUX_REVIVALS)
		ADD_TRAIT(H, TRAIT_IWASREVIVED, "[type]")
		H.apply_status_effect(/datum/status_effect/buff/psyvived)
		user.apply_status_effect(/datum/status_effect/buff/psyvived)
		H.visible_message(span_notice("[H]被赦免回生了！"), span_green("我自虚无中醒来，浑身覆满失去活性的银色丝线。"))
		H.mind.remove_antag_datum(/datum/antagonist/zombie)
		H.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it - Failsafe for it.
		H.apply_status_effect(/datum/status_effect/debuff/revived)	//Temp debuff on revive, your stats get hit temporarily. Doubly so if having rotted.
		return TRUE

	// Transfer afflictions from the target to the caster

	// Transfer damage
	var/brute_transfer = H.getBruteLoss()
	var/burn_transfer = H.getFireLoss()
	var/tox_transfer = H.getToxLoss()
	var/oxy_transfer = H.getOxyLoss()
	var/clone_transfer = H.getCloneLoss()

	// Heal the target
	H.adjustBruteLoss(-brute_transfer)
	H.adjustFireLoss(-burn_transfer)
	H.adjustToxLoss(-tox_transfer)
	H.adjustOxyLoss(-oxy_transfer)
	H.adjustCloneLoss(-clone_transfer)

	// Apply damage to the caster
	user.adjustBruteLoss(brute_transfer)
	user.adjustFireLoss(burn_transfer)
	user.adjustToxLoss(tox_transfer)
	user.adjustOxyLoss(oxy_transfer)
	user.adjustCloneLoss(clone_transfer)

	// Visual effects
	user.visible_message(span_danger("银色的灵辉之线自[user]身上迸发而出，击中[H]，赦免了其苦痛！"))
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717")

	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717")
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717")

	// Notify the user and target
	to_chat(user, span_warning("我牵动[H]的灵辉，赦免了他们的伤势！"))
	if(HAS_TRAIT(H, TRAIT_INQUISITION)) // inqusition is used to it
		to_chat(user, span_notice("你感到自己的灵魂被牵动，[user]赦免了你的苦痛。"))
	else
		to_chat(H, span_danger("你感到一阵可怕的撕裂，灵魂的一部分被银线生生扯走！")) // Someone just tore away something from your lux, that isn't calm  
		to_chat(H, span_notice("你的伤口似乎神秘地消失了，你的负担也随之减轻。"))
	return TRUE

// Weaker absolve for the Stigmata adventurer
/obj/effect/proc_holder/spell/invoked/psydonamend	
	name = "分担"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "ABSOLVE"
	desc = "这是强大神艺“赦免”的弱化形式，不具备复活之能，只会将目标的伤势转移到你身上。务必谨慎使用。"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	range = 5
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/psyabsolution.ogg'
	invocations = list("由我来分担！")
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 SECONDS 
	miracle = TRUE
	devotion_cost = 80

/obj/effect/proc_holder/spell/invoked/psydonamend/cast(list/targets, mob/living/user)

	if(!ishuman(targets[1]))
		to_chat(user, span_warning("“分担”只对行于祂之形象下的人有效！"))
		revert_cast()
		return FALSE
	
	var/mob/living/carbon/human/H = targets[1]
	
	if(H == user)
		to_chat(user, span_warning("我不能对自己施展“分担”！"))
		revert_cast()
		return FALSE

	// THE LESSER ART OF AMENDMENT CANNOT RETURN THE DEAD.
	
	// Transfer afflictions from the target to the caster
	
	// Transfer damage
	var/brute_transfer = H.getBruteLoss()
	var/burn_transfer = H.getFireLoss()
	var/tox_transfer = H.getToxLoss()
	var/oxy_transfer = H.getOxyLoss()
	var/clone_transfer = H.getCloneLoss()

	if (oxy_transfer >= 150)
		if (alert(user, "对方面如死灰、呼吸停滞。施展“分担”可能会立刻害死你，受印者。还要继续吗？", "自保", "是", "否") != "是")
			revert_cast()
			return
	
	// Heal the target
	H.adjustBruteLoss(-brute_transfer)
	H.adjustFireLoss(-burn_transfer)
	H.adjustToxLoss(-tox_transfer)
	H.adjustOxyLoss(-oxy_transfer)
	H.adjustCloneLoss(-clone_transfer)
	
	// Apply damage to the caster
	user.adjustBruteLoss(brute_transfer)
	user.adjustFireLoss(burn_transfer)
	user.adjustToxLoss(tox_transfer)
	user.adjustOxyLoss(oxy_transfer)
	user.adjustCloneLoss(clone_transfer)

	// Visual effects
	user.visible_message(span_danger("银色的灵辉之线自[user]身上射出，击中[H]，分担了其苦痛！"))
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717") 

	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717") 
	
	// Notify the user and target
	to_chat(user, span_warning("我牵动[H]的灵辉，修补了他们的伤势！"))
	if(HAS_TRAIT(H, TRAIT_INQUISITION)) // inqusition is used to it
		to_chat(user, span_notice("你感到自己的灵魂被牵动，[user]分担了你的苦痛。"))
	else
		to_chat(H, span_danger("你感到一阵可怕的撕裂，灵魂的一部分被银线生生扯走！")) // someone just torn away something from your lux, that isn't calm
		to_chat(H, span_notice("你的伤口似乎神秘地消失了，你的负担也随之减轻。"))
	
	return TRUE
