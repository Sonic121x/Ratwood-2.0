/obj/item/organ/heart
	name = "心脏"
	desc = ""
	icon_state = "heart-on"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_HEART

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = 5 * STANDARD_ORGAN_DECAY		//designed to fail about 5 minutes after death

	low_threshold_passed = span_info("我的胸口传来阵阵刺痛，随后又渐渐消退……")
	high_threshold_passed = span_warning("我的胸腔里持续疼痛，丝毫没有缓解。我察觉自己的呼吸比之前急促了许多。")
	now_fixed = span_info("我的心脏重新开始跳动。")
	high_threshold_cleared = span_info("我的胸痛减轻了，呼吸也变得轻松起来。")

	// Heart attack code is in code/modules/mob/living/carbon/human/life.dm
	var/beating = 1
	var/icon_base = "heart"
	attack_verb = list("敲打", "捶打")
	var/beat = BEAT_NONE//is this mob having a heatbeat sound played? if so, which?
	var/failed = FALSE		//to prevent constantly running failing code
	var/operated = FALSE	//whether the heart's been operated on to fix some of its damages

	/// Marking on this heart for the maniac antagonist
	var/inscryption
	/// Associated maniac key
	var/inscryption_key

	var/static/sound/slowbeat = sound('sound/health/slowbeat.ogg', repeat = TRUE)
	var/static/sound/fastbeat = sound('sound/health/fastbeat.ogg', repeat = TRUE)


	food_type = /obj/item/reagent_containers/food/snacks/organ/heart

/obj/item/organ/heart/Destroy()
	for(var/datum/culling_duel/D in GLOB.graggar_cullings)
		var/obj/item/organ/heart/d_challenger_heart = D.challenger_heart?.resolve()
		var/obj/item/organ/heart/d_target_heart = D.target_heart?.resolve()
		if(src == d_challenger_heart)
			D.handle_heart_destroyed("challenger")
			continue
		else if(src == d_target_heart)
			D.handle_heart_destroyed("target")
			continue
	return ..()

/obj/item/organ/heart/examine(mob/user)
	. = ..()
	var/datum/antagonist/maniac/dreamer = user.mind?.has_antag_datum(/datum/antagonist/maniac)
	if(dreamer)
		if(!inscryption)
			. += "<span class='danger'><b>这颗心脏上什么都没有。\
				本该有吗？追寻真相——它不在这里。我必须继续寻找。继续追随我的心。</b></span>"
		else
			. += "<b><span class='warning'>这颗心脏上刻着什么。</span>\n\"[inscryption]。将它与其他钥匙组合，便能离开INRL。\"</b>"
			if(!(inscryption in dreamer.hearts_seen))
				dreamer.hearts_seen += inscryption
				SEND_SOUND(dreamer, 'sound/villain/newheart.ogg')

/obj/item/organ/heart/update_icon()
	if(beating)
		icon_state = "[icon_base]-on"
	else
		icon_state = "[icon_base]-off"

/obj/item/organ/heart/Remove(mob/living/carbon/M, special = 0)
	..()
	if(!special)
		addtimer(CALLBACK(src, PROC_REF(stop_if_unowned)), 120)

/obj/item/organ/heart/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	. = ..()
	if(owner)
		Restart()

/obj/item/organ/heart/proc/stop_if_unowned()
	if(!owner)
		Stop()

/obj/item/organ/heart/attack_self(mob/user)
	..()
	if(!beating)
		user.visible_message("<span class='notice'>[user]挤压[src]，\
			让它重新跳动起来！</span>",span_notice("我挤压[src]，让它重新跳动起来！"))
		Restart()
		addtimer(CALLBACK(src, PROC_REF(stop_if_unowned)), 80)

/obj/item/organ/heart/proc/Stop()
	beating = 0
	update_icon()
	return 1

/obj/item/organ/heart/proc/Restart()
	beating = 1
	update_icon()
	return 1

/obj/item/organ/heart/prepare_eat(mob/living/carbon/human/user)
	var/obj/item/reagent_containers/food/snacks/organ/S = ..()
	S.icon_state = "heart-off"
	var/nothing = FALSE
/*	if(user.mind)
		var/datum/antagonist/werewolf/C = user.mind.has_antag_datum(/datum/antagonist/werewolf)
		if(C)
			var/datum/objective/hearteating/H = locate(/datum/objective/hearteating) in C.objectives
			if(H)
				testing("heartseaten++")
				H.hearts_eaten++
				nothing = TRUE
				S.eat_effect = /datum/status_effect/buff/snackbuff*/
	if(!nothing)
		S.eat_effect = /datum/status_effect/debuff/uncookedfood
	return S

/obj/item/organ/heart/on_life()
	..()
	if(owner.client && beating)
		failed = FALSE
		var/mob/living/carbon/H = owner
		var/new_beat = BEAT_NONE
		if(H.health <= H.crit_threshold)
			new_beat = BEAT_SLOW
		else if(H.jitteriness && H.health > HEALTH_THRESHOLD_FULLCRIT)
			new_beat = BEAT_FAST
		if(beat != new_beat)	
			H.stop_sound_channel(CHANNEL_HEARTBEAT)
			beat = new_beat
			var/sound/heartbeat_sound
			switch(beat)
				if(BEAT_SLOW)
					heartbeat_sound = slowbeat
				if(BEAT_FAST)
					heartbeat_sound = fastbeat
			if(heartbeat_sound)
				H.playsound_local(null, heartbeat_sound, 40, FALSE, channel = CHANNEL_HEARTBEAT)
	if(organ_flags & ORGAN_FAILING)	//heart broke, stopped beating, death imminent
		if(owner.stat == CONSCIOUS)
			owner.visible_message(span_danger("[owner]紧抓着自己的胸口，仿佛心脏就要停止跳动！"), \
				span_danger("我的胸口传来剧痛，仿佛心脏已经停止跳动！"))
		owner.set_heartattack(TRUE)
		failed = TRUE
		owner.stop_sound_channel(CHANNEL_HEARTBEAT)


/obj/item/organ/heart/construct
	name = "构装体核心"
	desc = "阿斯特拉塔的祝福萦绕其上，灵辉在内部脉动。它使构装体得以活动。"
	icon_state = "heartcon-on"
	icon_base = "heartcon"

/obj/item/organ/heart/cursed
	name = "诅咒心脏"
	desc = ""
	icon_state = "cursedheart-off"
	icon_base = "cursedheart"
	decay_factor = 0
	actions_types = list(/datum/action/item_action/organ_action/cursed_heart)
	var/last_pump = 0
	var/add_colour = TRUE //So we're not constantly recreating colour datums
	var/pump_delay = 30 //you can pump 1 second early, for lag, but no more (otherwise you could spam heal)
	var/blood_loss = 100 //600 blood is human default, so 5 failures (below 122 blood is where humans die because reasons?)

	//How much to heal per pump, negative numbers would HURT the player
	var/heal_brute = 0
	var/heal_burn = 0
	var/heal_oxy = 0


/obj/item/organ/heart/cursed/attack(mob/living/carbon/human/H, mob/living/carbon/human/user, obj/target)
	if(H == user && istype(H))
		playsound(user,'sound/blank.ogg',40,TRUE)
		user.temporarilyRemoveItemFromInventory(src, TRUE)
		Insert(user)
	else
		return ..()

/obj/item/organ/heart/cursed/on_life()
	if(world.time > (last_pump + pump_delay))
		if(ishuman(owner) && owner.client) //While this entire item exists to make people suffer, they can't control disconnects.
			var/mob/living/carbon/human/H = owner
			if(H.dna && !(NOBLOOD in H.dna.species.species_traits))
				H.set_blood_volume(max(H.get_blood_volume() - blood_loss, 0))
				to_chat(H, span_danger("我必须不停地泵血！"))
				if(add_colour)
					H.add_client_colour(/datum/client_colour/cursed_heart_blood) //bloody screen so real
					add_colour = FALSE
		else
			last_pump = world.time //lets be extra fair *sigh*

/obj/item/organ/heart/cursed/Insert(mob/living/carbon/M, special = 0)
	..()
	if(owner)
		to_chat(owner, span_danger("我的心脏被换成了一颗诅咒心脏，我必须手动泵血，否则就会死！"))

/obj/item/organ/heart/cursed/Remove(mob/living/carbon/M, special = 0)
	..()
	M.remove_client_colour(/datum/client_colour/cursed_heart_blood)

/datum/action/item_action/organ_action/cursed_heart
	name = "手动泵血"

//You are now brea- pumping blood manually
/datum/action/item_action/organ_action/cursed_heart/Trigger()
	. = ..()
	if(. && istype(target, /obj/item/organ/heart/cursed))
		var/obj/item/organ/heart/cursed/cursed_heart = target

		if(world.time < (cursed_heart.last_pump + (cursed_heart.pump_delay-10))) //no spam
			to_chat(owner, span_danger("太快了！"))
			return

		cursed_heart.last_pump = world.time
		playsound(owner,'sound/blank.ogg',40,TRUE)
		to_chat(owner, span_notice("我的心脏跳动了一下。"))

		var/mob/living/carbon/human/H = owner
		if(istype(H))
			if(H.dna && !(NOBLOOD in H.dna.species.species_traits))
				H.set_blood_volume(min(H.get_blood_volume() + cursed_heart.blood_loss*0.5, BLOOD_VOLUME_MAXIMUM))
				H.remove_client_colour(/datum/client_colour/cursed_heart_blood)
				cursed_heart.add_colour = TRUE
				H.adjustBruteLoss(-cursed_heart.heal_brute)
				H.adjustFireLoss(-cursed_heart.heal_burn)
				H.adjustOxyLoss(-cursed_heart.heal_oxy)


/datum/client_colour/cursed_heart_blood
	priority = 100 //it's an indicator you're dying, so it's very high priority
	colour = "red"

/obj/item/organ/heart/t1
	name = "完善心脏"
	icon_state = "heart"
	desc = "完美的造物，感觉它已经……臻于完善。"
	sellprice = 100

/obj/item/organ/heart/t2
	name = "受祝福的心脏"
	icon_state = "heart"
	desc = "为了击败更大的异端，他们接纳了这种异端。他们称之为祝福，但我们都知道并非如此……"
	sellprice = 200

/obj/item/organ/heart/t3
	name = "腐化心脏"
	icon_state = "heart"
	desc = "一件受诅咒的扭曲造物。它能为你所用——为了活下去，你愿意付出怎样的牺牲？"
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	sellprice = 300

/datum/status_effect/buff/t1heart
	id = "t1heart"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t1heart

/atom/movable/screen/alert/status_effect/buff/t1heart
	name = "完善心脏"
	desc = "我现在有了一颗更强健的心脏。"

/obj/item/organ/heart/t1/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t1heart)
		ADD_TRAIT(M, TRAIT_SHOCKIMMUNE, ORGAN_TRAIT)

/obj/item/organ/heart/t1/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M.has_status_effect(/datum/status_effect/buff/t1heart))
		M.remove_status_effect(/datum/status_effect/buff/t1heart)
		REMOVE_TRAIT(M, TRAIT_SHOCKIMMUNE , ORGAN_TRAIT)

/datum/status_effect/buff/t2heart
	id = "t2heart"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t2heart

/atom/movable/screen/alert/status_effect/buff/t2heart //your helper against mages
	name = "受祝福的心脏"
	desc = "一颗受祝福的心脏……也许吧。"

/obj/item/organ/heart/t2/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t2heart)
		ADD_TRAIT(M, TRAIT_SHOCKIMMUNE, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_KNEESTINGER_IMMUNITY, ORGAN_TRAIT)

/obj/item/organ/heart/t2/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M.has_status_effect(/datum/status_effect/buff/t2heart))
		M.remove_status_effect(/datum/status_effect/buff/t2heart)
		REMOVE_TRAIT(M, TRAIT_SHOCKIMMUNE , ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_KNEESTINGER_IMMUNITY , ORGAN_TRAIT)


/datum/status_effect/buff/t3heart
	id = "t3heart"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t3heart

/atom/movable/screen/alert/status_effect/buff/t3heart
	name = "腐化心脏"
	desc = "那受诅咒的东西如今就在我体内。"

/obj/item/organ/heart/t3/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t3heart)
		ADD_TRAIT(M, TRAIT_SHOCKIMMUNE, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_KNEESTINGER_IMMUNITY, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_HEAVYARMOR, ORGAN_TRAIT)

/obj/item/organ/heart/t3/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M.has_status_effect(/datum/status_effect/buff/t3heart))
		M.remove_status_effect(/datum/status_effect/buff/t3heart)
		REMOVE_TRAIT(M, TRAIT_SHOCKIMMUNE , ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_KNEESTINGER_IMMUNITY , ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_HEAVYARMOR , ORGAN_TRAIT)
