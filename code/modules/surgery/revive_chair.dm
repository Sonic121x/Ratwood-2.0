#define WEATHER_RAIN "rain"

// The immovable chair structure
/obj/structure/chair/frankenstein
	name = "富尔门诺椅"
	desc = "一个由管道和火花电极组成的噩梦般装置，似乎永久固定在地面上，被亲切地称为ZRONK设备。"
	icon = 'icons/roguetown/misc/struc48x48.dmi'
	icon_state = "frankenchair0"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	max_integrity = 10000
	item_chair = null // Cannot be picked up
	buildstacktype = null
	buildstackamount = 0

	// Chair state variables
	var/charge = 0
	var/max_charge = 100
	var/brew_required = 48
	var/current_brew = 0
	var/max_brew = 96
	var/chair_skill_level = 4

	var/static/list/brew_overlays = list(
		"low" = "frankenbrew_low",
		"medium" = "frankenbrew_med",
		"high" = "frankenbrew_high"
	)
	var/brew_color = "#00ff15"
	var/brew_alpha = 200
	var/cranking = FALSE
	pixel_x = -8

/obj/structure/chair/frankenstein/zizo
	chair_skill_level = 2
	current_brew = 48

/obj/structure/chair/frankenstein/debug
	name = "Fulmenor chair (debug)"
	desc = "A testing copy of the ZRONK device. It fills its own tank and winds its own crank, so the only things left to fail are the surgeon and the soul."

/obj/structure/chair/frankenstein/debug/Initialize(mapload)
	. = ..()
	top_up()

/obj/structure/chair/frankenstein/debug/MiddleClick(mob/user)
	. = ..()
	top_up() // So a foreign binding can be run again without brewing a second tank

/// Refills the tank and the crank. Every skill, consent and foreign brain gate is deliberately left alone
/obj/structure/chair/frankenstein/debug/proc/top_up()
	current_brew = max_brew
	charge = max_charge
	update_icon()

/obj/structure/chair/frankenstein/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/chair/frankenstein/update_icon()
	cut_overlays()

	// Add fluid overlay if there's brew
	if(current_brew > 0)
		var/brew_percent = current_brew / max_brew
		var/overlay_state

		// Select appropriate overlay based on fill level
		if(brew_percent < 0.33)
			overlay_state = brew_overlays["low"]
		else if(brew_percent < 0.66)
			overlay_state = brew_overlays["medium"]
		else
			overlay_state = brew_overlays["high"]

		// Create and apply overlay
		var/mutable_appearance/fluid_overlay = mutable_appearance(icon, overlay_state)
		fluid_overlay.color = brew_color
		fluid_overlay.alpha = brew_alpha
		add_overlay(fluid_overlay)

	// Add charge effects if charged
	if(charge > 0)
		var/charge_percent = charge / max_charge
		var/charge_alpha = 55 + 200 * charge_percent
		var/mutable_appearance/charge_overlay = mutable_appearance(icon, "frankenspark")
		charge_overlay.alpha = charge_alpha
		add_overlay(charge_overlay)

/obj/structure/chair/frankenstein/attackby(obj/item/I, mob/user)
	if(!ishuman(user))
		to_chat(user, span_warning("我完全不知道如何操作这个。"))
		return // Everything below needs a human
	var/mob/living/carbon/human/H = user
	// Handle filling with brew containers
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = I

		// Check if container has our special brew
		if(container.reagents.has_reagent(/datum/reagent/frankenbrew, 1))
			if(current_brew >= max_brew)
				to_chat(user, span_warning("[src]已经满了！"))
				return

			// Calculate how much we can transfer
			var/remaining_capacity = max_brew - current_brew
			var/available_brew = container.reagents.get_reagent_amount(/datum/reagent/frankenbrew)

			if(available_brew <= 0)
				to_chat(user, span_warning("[container]是空的！"))
				return

			// Animate filling
			user.visible_message(
				span_notice("[user]开始用[container]填充[src]。"), 
				span_notice("你开始用[container]填充[src]。")
			)

			var/skill_mod = get_user_skill(H)
			var/transferred = 0
			var/transfer_amount = 3
			var/transfer_time = 1.5 SECONDS * skill_mod

			while(remaining_capacity > 0 && available_brew > 0)
				// Check if we can continue
				if(!user.Adjacent(src) || !container)
					break

				// Calculate actual transfer for this iteration
				var/actual_transfer = min(transfer_amount, remaining_capacity, available_brew)

				// Short transfer animation
				if(!do_after(user, transfer_time, target = src))
					break

				// Transfer fluid
				container.reagents.remove_reagent(/datum/reagent/frankenbrew, actual_transfer)
				current_brew += actual_transfer
				transferred += actual_transfer
				remaining_capacity = max_brew - current_brew
				available_brew = container.reagents.get_reagent_amount(/datum/reagent/frankenbrew)

				// Update appearance
				update_icon()
				playsound(src, 'sound/items/drink_bottle (2).ogg', 30, TRUE)

			if(transferred > 0)
				to_chat(user, span_notice("你向[src]转移了[transferred]单位的灵药。现在它有[current_brew]/[max_brew]单位。"))
			else
				to_chat(user, span_warning("你在填充[src]时被打断了。"))

				update_icon()
				return TRUE
		else
			to_chat(user, span_warning("这个容器没有特殊药剂！"))
			return
	return ..()

/obj/structure/chair/frankenstein/examine(mob/user)
	. = ..()
	. += span_info("液面高度：[current_brew]/[max_brew] 单位")
	. += span_info("充能等级：[charge]/[max_charge]")
	. += span_info("实用传单：将逝者绑缚在座椅上，倒入灵液，再用固定在右侧的曲柄为它充能。有人在把手上刻下了「RMB」字样。")
	. += span_info("背面正中央有一根看上去很诱人的大拉杆，正是它负责唤醒。这上面刻着「MMB」。")
	. += span_info("RMB。MMB。唔。想必是两兄弟的首字母缩写之类吧。")
	. += span_info("传单上更小的字印着：倘若肩上的颅骨并非其自身所有，此物便不是修补躯体，而是夺走一具——将原本之人拆解，好让另一个灵魂披上它。它会将储罐一饮而尽，非大师级医师之手不得尝试，而工匠们对冥下侍女信徒将称之为渎神的一切后果，概不负责。")
	. += span_info("有人在下方以一手局促的字迹潦草回了一句，墨色是病态的绿：<i><font color='#8ea63a'>「佩斯特拉信徒在此。尽管我喜爱蛆虫，但任血肉腐坏对谁都无益，而明明有办法让人入座，却将灵魂拒之门外，才是大得多的罪过。」</font></i>")

	if(current_brew > 0)
		. += span_notice("流体罐中含有发光的绿色液体。")
	else
		. += span_warning("流体罐是空的。")

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron.type == /datum/patron/divine/pestra || H.patron.type == /datum/patron/inhumen/zizo)
			. += span_info("你回想起这些椅子通常装在标有白色十字架的神秘黑箱中运输。零件由神秘的鸟喙身影在现场组装，再将其拆开似乎是不可能完成的任务。")

// Special brew reagent
/datum/reagent/frankenbrew
	name = "复活灵药"
	description = "一种挥发性化学混合物，帮助死者导电。"
	color = "#00ff15"
	taste_description = "闪电与悔恨"

/obj/item/reagent_containers/glass/bottle/frankenbrew
	name = "一瓶复活灵药"
	desc = "一种挥发性化学混合物，帮助死者导电。看起来很昂贵……"
	list_reagents = list(/datum/reagent/frankenbrew = 48)

/obj/item/reagent_containers/glass/bottle/frankenbrew/third
	list_reagents = list(/datum/reagent/frankenbrew = 16)

/obj/structure/chair/frankenstein/proc/start_cranking_animation()
	if(cranking)
		return
	cranking = TRUE
	icon_state = "frankenchair_crank"
	update_icon()

/obj/structure/chair/frankenstein/proc/stop_cranking_animation()
	cranking = FALSE
	icon_state = "frankenchair0"
	update_icon()

/obj/structure/chair/frankenstein/proc/get_user_skill(mob/living/carbon/human/user)
	var/medical_skill = user.get_skill_level(/datum/skill/misc/medicine)
	var/skill_mod = 1.0

	switch(medical_skill)
		if(0 to 3)
			skill_mod = 4.0
		if(4)
			skill_mod = 1.0
		if(5)
			skill_mod = 0.9
		if(6)
			skill_mod = 0.8

	return skill_mod

/obj/structure/chair/frankenstein/attack_right(mob/user)
	if(!ishuman(user))
		to_chat(user, span_warning("我完全不知道如何操作这个。"))
		return // Everything below needs a human
	var/mob/living/carbon/human/H = user

	if(cranking)
		to_chat(user, span_warning("已经有人在摇动[src]了！"))
		return

	if(charge >= max_charge)
		to_chat(user, span_warning("[src]已经充满能了！"))
		return

	// Start cranking
	user.visible_message(
		span_notice("[user]开始摇动[src]。"), 
		span_notice("你开始摇动[src]……")
	)

	start_cranking_animation()

	var/cranks = 0
	var/skill_mod = get_user_skill(H)
	var/crank_time = 2 SECONDS * skill_mod
	var/charge_per_crank = 10

	while(charge < max_charge && do_after(user, crank_time, target = src))
		// Add charge
		charge = min(charge + charge_per_crank, max_charge)
		cranks++
		update_icon()

		// Play sound
		playsound(src, 'sound/misc/click.ogg', 50, 1)

		// Check if we reached max charge
		if(charge >= max_charge)
			break

	stop_cranking_animation()

	if(cranks > 0)
		to_chat(user, span_notice("你摇了[src] [cranks]次。"))
	else
		to_chat(user, span_warning("你停止了摇动。"))

	return TRUE

/obj/structure/chair/frankenstein/MiddleClick(mob/user)
	if(!ishuman(user))
		return ..()

	var/mob/living/carbon/human/H = user

	// Check medical skill requirement
	if(H.get_skill_level(/datum/skill/misc/medicine) < chair_skill_level)
		to_chat(H, span_warning("我没有操作此设备的医疗专业知识！"))
		return

	// Check if chair is occupied
	var/mob/living/carbon/occupant
	for(var/mob/living/carbon/C in get_turf(src))
		if(C != user)
			occupant = C
			break

	//OV edit
	for(var/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/suffering/slime in get_turf(src))
		if(slime != user)
			occupant = slime
			break
	//OV edit end

	if(!occupant)
		to_chat(H, span_warning("椅子需要有被复活者才能执行复活！"))
		return

	// Check resources
	if(current_brew < brew_required)
		to_chat(H, span_warning("液体不足！"))
		return
	if(charge < max_charge)
		to_chat(H, span_warning("充能不足！"))
		return

	//OV edit
	if(istype(occupant, /mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/suffering))
		playsound(src, 'sound/magic/lightning.ogg', 100, TRUE)
		do_sparks(8, TRUE, occupant)
		occupant.visible_message(span_danger("电流贯穿了[occupant]！"))
		occupant.revive()
		current_brew -= brew_required
		charge = 0
	//OV edit end

	// Soul-binding: a foreign brain revives only here, at a full tank and a master's hand
	var/binding_foreign = FALSE
	if(ishuman(occupant))
		var/mob/living/carbon/human/human_occupant = occupant
		binding_foreign = human_occupant.has_foreign_brain()
	if(binding_foreign)
		if(H.get_skill_level(/datum/skill/misc/medicine) < SKILL_LEVEL_MASTER)
			to_chat(H, span_warning("Binding a soul to stranger's flesh is beyond my skill. Only a master of medicine could attempt it."))
			return
		if(current_brew < max_brew)
			to_chat(H, span_warning("Binding a stranger's soul to this flesh would drink the entire tank. It must be filled to the brim!"))
			return

	// Check if occupant is valid
	if(!occupant.check_revive(user, bypass_foreign_brain_check = binding_foreign))
		return

	// Prompt ghost
	to_chat(occupant, span_ghostalert("你感觉到强大的能量正在试图将你拉回身体！"))
	var/alert_result = alert(occupant, "他们在呼唤你。你准备好了吗？", "复活", "我需要醒来", "不要放开我")

	// Verify occupant is still valid
	if(occupant.stat != DEAD || occupant.loc != get_turf(src) || !occupant.buckled)
		to_chat(H, span_warning("对象不再适当地固定在椅子上！"))
		return

	// The alert above blocks on the occupant's player, so anything checked before it can be stale
	var/still_foreign = FALSE
	if(ishuman(occupant))
		var/mob/living/carbon/human/rechecked_occupant = occupant
		still_foreign = rechecked_occupant.has_foreign_brain()
	if(still_foreign && !binding_foreign)	// Became foreign mid-prompt, the binding gates above never ran
		to_chat(H, span_warning("在你思忖之际，这具血肉的羁绊已然转移！一切须得从头再来。"))
		return
	binding_foreign = still_foreign	// The rightful brain returning mid-prompt downgrades this to an ordinary revival
	if(current_brew < (binding_foreign ? max_brew : brew_required) || charge < max_charge)
		to_chat(H, span_warning("在你思忖之际，座椅的储备已然耗减！"))
		return

	if(alert_result != "我需要醒来")
		to_chat(H, span_warning("[occupant]拒绝回来。"))
		return

	// Animation and sound
	playsound(src, 'sound/magic/lightning.ogg', 100, TRUE)
	do_sparks(8, TRUE, occupant)
	occupant.visible_message(span_danger("电流贯穿了[occupant]！"))

	// Revive process
	occupant.adjustOxyLoss(-occupant.getOxyLoss())
	// The flag pierces only the foreign brain gate, the conversion itself keys on state
	if(occupant.revive(full_heal = FALSE, bypass_foreign_brain_check = binding_foreign))
		// Restore consciousness
		occupant.grab_ghost(force = TRUE)
		occupant.emote("gasp")
		occupant.Jitter(100)
		occupant.electrocute_act(100, src, 1)
		occupant.visible_message(span_notice("[occupant]喘着气猛然醒来！"),
								span_userdanger("你痛苦地醒来，非自然的能量在你的血管中奔涌！"))
		current_brew -= (binding_foreign ? max_brew : brew_required)
		charge = 0
		update_icon()

		// Apply debuffs
		occupant.apply_status_effect(/atom/movable/screen/alert/status_effect/debuff/revived)

	return TRUE
