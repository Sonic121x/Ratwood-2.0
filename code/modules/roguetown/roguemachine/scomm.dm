#define GARRISON_SCOM_COLOR "#FF4242"

/obj/structure/roguemachine/scomm
	name = "SCOM传讯网"
	desc = "超自然光学通讯机是魔法与技术的奇迹。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "scomm1"
	density = FALSE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	pixel_y = 32
	anchored = TRUE
	var/next_decree = 0
	var/listening = TRUE
	var/speaking = TRUE
	var/dictating = FALSE
	var/scom_number
	var/obj/structure/roguemachine/scomm/calling = null
	var/obj/structure/roguemachine/scomm/called_by = null
	var/spawned_rat = FALSE
	var/garrisonline = FALSE

/obj/structure/roguemachine/scomm/Initialize(mapload)
	. = ..()
	become_hearing_sensitive()

/obj/structure/roguemachine/scomm/Destroy()
	lose_hearing_sensitivity()
	return ..()

/obj/structure/roguemachine/scomm/OnCrafted(dirin, mob/user)
	. = ..()
	loc = user.loc
	pixel_y = 0
	switch(dirin)
		if(NORTH)
			pixel_y = 32
		if(SOUTH)
			pixel_y = -32
		if(EAST)
			pixel_x = 32
		if(WEST)
			pixel_x = -32

/obj/structure/roguemachine/scomm/r
	pixel_y = 0
	pixel_x = 32

/obj/structure/roguemachine/scomm/l
	pixel_y = 0
	pixel_x = -32

/obj/structure/roguemachine/scomm/examine(mob/user)
	. = ..()
	if(scom_number)
		. += "其编号为 #[scom_number]。"
	if(user.loc == loc)
		. += "<b>此地律法：</b>"
		if(!length(GLOB.laws_of_the_land))
			. += span_danger("此地无法！<b>我们注定完蛋！</b>")
			return
		if(!user.is_literate())
			. += span_warning("呃……我看不懂这些……")
			return
		for(var/i in 1 to length(GLOB.laws_of_the_land))
			. += span_small("[i]. [GLOB.laws_of_the_land[i]]")

/obj/structure/roguemachine/scomm/process()
	if(world.time <= next_decree)
		return
	next_decree = world.time + rand(3 MINUTES, 8 MINUTES)
	if(!GLOB.lord_decrees.len)
		return
	if(!speaking)
		return
	say("[SSticker.rulertype]颁布法令：[pick(GLOB.lord_decrees)]", spans = list("info"))

/obj/structure/roguemachine/scomm/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(called_by && !calling)
		calling = called_by
		calling.say("密语线已接通。", spans = list("info"))
		say("密语线已接通。", spans = list("info"))
		update_icon()
		return
	if(calling)
		listening = !listening
		to_chat(user, span_info("我将 SCOM传讯网 的输入[listening ? "取消静音" : "静音"]了。"))
		return
	listening = !listening
	speaking = listening
	to_chat(user, span_info("我将 SCOM传讯网[speaking ? "取消静音" : "静音"]了。"))
	update_icon()

/obj/structure/roguemachine/scomm/attack_right(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(called_by && !calling)
		called_by.say("密语线被拒绝。", spans = list("info"))
		say("密语线被拒绝。", spans = list("info"))
		called_by.calling = null
		called_by = null
		return
	if(calling)
		speaking = !speaking
		to_chat(user, span_info("我将 SCOM传讯网 的输出[speaking ? "取消静音" : "静音"]了。"))
		return
	var/canread = user.can_read(src, TRUE)
	var/contents
	if(SSticker.rulertype == "Grand Duke")
		contents += "<center>大公法令<BR>"
	else
		contents += "<center>大公夫人法令<BR>"
	contents += "-----------<BR><BR></center>"
	for(var/i = GLOB.lord_decrees.len to 1 step -1)
		contents += "[i]. <span class='info'>[GLOB.lord_decrees[i]]</span><BR>"
	if(!canread)
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 220)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/scomm/MiddleClick(mob/living/carbon/human/user)
	if(.)
		return
	if((HAS_TRAIT(user, TRAIT_GUARDSMAN) || (user.job == "Warden") || (user.job == "Squire") || (user.job == "Marshal") || (user.job == "Grand Duke") || (user.job == "Knight Captain") || (user.job == "Grand Duchess")))
		if(alert("你想切换线路，还是接入密语线？",, "切换", "密语线") != "密语线")
			garrisonline = !garrisonline
			to_chat(user, span_info("我[garrisonline ? "接入了卫戍 SCOM 线路" : "接入了普通 SCOM 线路"]。"))
			playsound(loc, 'sound/misc/garrisonscom.ogg', 100, FALSE, -1)
			update_icon()
			return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(calling)
		calling.say("密语线已断开。", spans = list("info"))
		if(calling.calling == src)
			var/obj/structure/roguemachine/scomm/old_calling = calling
			old_calling.called_by = null
			old_calling.calling = null
			old_calling.speaking = old_calling.listening
			old_calling.update_icon()
		calling = null
		called_by = null
		speaking = listening
		to_chat(user, span_info("我切断了密语线。"))
		say("密语线已断开。", spans = list("info"))
		update_icon()
	else
		say("输入 SCOM传讯网 编号。", spans = list("info"))
		var/nightcall = input(user, "输入分配给你的编号。", "联络") as null|num
		if(!nightcall)
			return
		if(nightcall == scom_number)
			to_chat(user, span_warning("只有老鼠在吱吱地回应你。"))
			playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
			return
		if(SSroguemachine.scomm_machines.len < nightcall)
			say("没有老鼠在跑这条密语线。", spans = list("info"))
			return
		var/obj/structure/roguemachine/scomm/S = SSroguemachine.scomm_machines[nightcall]
		if(!S)
			to_chat(user, span_warning("只有老鼠在吱吱地回应你。"))
			playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
			return
		if(S.calling || S.called_by)
			say("这条密语线上的老鼠正忙着。", spans = list("info"))
			return
		if(!S.speaking)
			say("这条密语线上的老鼠被堵住嘴了。", spans = list("info"))
			return
		calling = S
		S.called_by = src
		update_icon()

		for(var/i in 1 to 10)
			if(!calling)
				update_icon()
				return
			if(calling.calling == src)
				return
			calling.ring_ring()
			ring_ring()
			sleep(30)
		say("这条密语线上的老鼠累坏了。", spans = list("info"))
		calling.called_by = null
		calling = null
		update_icon()

/obj/structure/roguemachine/scomm/obj_break(damage_flag)
	..()
	calling?.say("密语线已断开。", spans = list("info"))
	calling?.speaking = calling?.listening
	calling?.called_by = null
	calling?.calling = null
	called_by = null
	calling = null
	speaking = FALSE
	listening = FALSE
	update_icon()
	icon_state = "[icon_state]-br"

/obj/structure/roguemachine/scomm/Initialize(mapload)
	. = ..()
//	icon_state = "scomm[rand(1,2)]"
	START_PROCESSING(SSroguemachine, src)
	update_icon()
	SSroguemachine.scomm_machines += src
	scom_number = SSroguemachine.scomm_machines.len

/obj/structure/roguemachine/scomm/update_icon()
	if(obj_broken)
		set_light(0)
		return
	if(garrisonline)
		icon_state = "scomm2"
		return
	if(calling)
		icon_state = "scomm2"
	else if(listening)
		icon_state = "scomm1"
	else
		icon_state = "scomm0"

/obj/structure/roguemachine/scomm/Destroy()
	SSroguemachine.scomm_machines -= src
	STOP_PROCESSING(SSroguemachine, src)
	set_light(0)
	return ..()

/obj/structure/roguemachine/scomm/proc/ring_ring()
	playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
	var/oldx = pixel_x
	animate(src, pixel_x = oldx+1, time = 0.5)
	animate(pixel_x = oldx-1, time = 0.5)
	animate(pixel_x = oldx, time = 0.5)

/obj/structure/roguemachine/scomm/proc/repeat_message(message, atom/A, tcolor, message_language, list/tspans = list())
	if(A == src)
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
		say(message, spans = tspans, language = message_language)
	voicecolor_override = null

/obj/structure/roguemachine/scomm/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(speaker.loc != loc && !calling)
		return
	if(!ishuman(speaker))
		return
	if(!listening)
		return
	var/mob/living/carbon/human/H = speaker
	var/usedcolor = H.voice_color
	if(H.voicecolor_override)
		usedcolor = H.voicecolor_override
	var/list/tspans = list()
	if(H.client.patreonlevel() >= GLOB.patreonsaylevel)
		tspans |= SPAN_PATREON_SAY
	if(raw_message)
		if(calling)
			if(calling.calling == src)
				calling.repeat_message(raw_message, src, usedcolor, message_language, tspans)
			return
		if(length(raw_message) > 100) //When these people talk too much, put that shit in slow motion, yeah
			/*if(length(raw_message) > 200)
				if(!spawned_rat)
					visible_message(span_warning("一只被激怒的 rous 从 SCOM传讯网 线路里冲了出来！"))
					new /mob/living/simple_animal/hostile/retaliate/rogue/bigrat(get_turf(src))
					spawned_rat = TRUE
				return*/
			raw_message = "<small>[raw_message]</small>"
		if(garrisonline)
			raw_message = "<span style='color: [GARRISON_SCOM_COLOR]'>[raw_message]</span>" //Prettying up for Garrison line
			for(var/obj/item/scomstone/garrison/S in SSroguemachine.scomm_machines)
				S.repeat_message(raw_message, src, usedcolor, message_language, tspans)
			for(var/obj/item/scomstone/bad/garrison/S in SSroguemachine.scomm_machines)
				S.repeat_message(raw_message, src, usedcolor, message_language, tspans)
			for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
				if(S.garrisonline)
					S.repeat_message(raw_message, src, usedcolor, message_language, tspans)
			SSroguemachine.crown?.repeat_message(raw_message, src, usedcolor, message_language, tspans)
			return
		if(H.client.patreonlevel() >= GLOB.patreonsaylevel)
			raw_message = "<span class=\"[SPAN_PATREON_SAY]\">[raw_message]</span>"
		for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
			if(!S.calling)
				S.repeat_message(raw_message, src, usedcolor, message_language, tspans)
		for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
			S.repeat_message(raw_message, src, usedcolor, message_language, tspans)
		for(var/obj/item/listenstone/S in SSroguemachine.scomm_machines)
			S.repeat_message(raw_message, src, usedcolor, message_language, tspans)//make the listenstone hear scom
		SSroguemachine.crown?.repeat_message(raw_message, src, usedcolor, message_language, tspans)

/obj/structure/roguemachine/scomm/proc/dictate_laws()
	if(dictating)
		return
	dictating = TRUE
	repeat_message("THE LAWS OF THE LAND ARE...", tcolor = COLOR_RED)
	INVOKE_ASYNC(src, PROC_REF(dictation))

/obj/structure/roguemachine/scomm/proc/dictation()
	if(!length(GLOB.laws_of_the_land))
		sleep(2)
		repeat_message("THE LAND HAS NO LAWS!", tcolor = COLOR_RED)
		dictating = FALSE
		return
	for(var/i in 1 to length(GLOB.laws_of_the_land))
		sleep(2)
		repeat_message("[i]. [GLOB.laws_of_the_land[i]]", tcolor = COLOR_RED)
	dictating = FALSE

/proc/scom_announce(message)
	for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
		if(S.speaking)
			S.say(message, spans = list("info"))



//SCOMSTONE                 SCOMSTONE

/obj/item/scomstone
	name = "通讯石戒"
	icon_state = "ring_scom"
	desc = "一枚沉重的金属戒指。中央嵌着一颗宝石，光芒黯淡，却仍像活着一般。"
	gripped_intents = null
	dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_RING|ITEM_SLOT_HANDS
	obj_flags = null
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	muteinmouth = TRUE
	var/listening = TRUE
	var/speaking = TRUE
	var/messagereceivedsound = 'sound/misc/scom.ogg'
	var/hearrange = 1 // change to 0 if you want your special scomstone to be only hearable by wearer
	drop_sound = 'sound/foley/coinphy (1).ogg'
	sellprice = 100
	grid_width = 32
	grid_height = 32
//wip
/obj/item/scomstone/attack_right(mob/living/carbon/human/user)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	visible_message(span_notice ("[user]把戒指按在嘴边。"))
	var/input_text = input(user, "输入你的消息：", "消息")
	if(!input_text)
		return
	var/usedcolor = user.voice_color
	if(user.voicecolor_override)
		usedcolor = user.voicecolor_override
	user.whisper(input_text)
	var/list/tspans = list()
	if(user.client.patreonlevel() >= GLOB.patreonsaylevel)
		tspans |= SPAN_PATREON_SAY
	if(user.client.patreonlevel() >= GLOB.patreonsaylevel)
		input_text = "<span class=\"[SPAN_PATREON_SAY]\">[input_text]</span>"
	if(length(input_text) > 100) //When these people talk too much, put that shit in slow motion, yeah
		input_text = "<small>[input_text]</small>"
	for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor, tspans = tspans)
	for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor, tspans = tspans)
	for(var/obj/item/listenstone/S in SSroguemachine.scomm_machines)//make the listenstone hear scomstone
		S.repeat_message(input_text, src, usedcolor, tspans = tspans)
	SSroguemachine.crown?.repeat_message(input_text, src, usedcolor, tspans = tspans)

/obj/item/scomstone/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	listening = !listening
	speaking = !speaking
	to_chat(user, span_info("我将通讯石戒[speaking ? "取消静音" : "静音"]了。"))
	update_icon()

/obj/item/scomstone/Destroy()
	SSroguemachine.scomm_machines -= src
	lose_hearing_sensitivity()
	return ..()

/obj/item/scomstone/Initialize(mapload)
	. = ..()
	become_hearing_sensitive()
	update_icon()
	SSroguemachine.scomm_machines += src

/obj/item/scomstone/proc/repeat_message(message, atom/A, tcolor, message_language, list/tspans = list())
	if(A == src)
		return
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, messagereceivedsound, 100, TRUE, -1)
		say(message, spans = tspans, language = message_language)
	voicecolor_override = null


/obj/item/scomstone/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_default_language()
	if(istype(loc, /obj/item))
		var/obj/item/I = loc
		I.send_speech(message, hearrange, I, , spans, message_language=language)
	else
		send_speech(message, hearrange, src, , spans, message_language=language)

/obj/item/scomstone/bad
	name = "仆役石戒"
	desc = "一枚锈迹斑斑、做工粗糙的金属戒指。嵌在里面的宝石几乎快要撑不住了。"
	icon_state = "ring_serfscom"
	listening = FALSE
	sellprice = 20

/obj/item/scomstone/bad/attack_right(mob/user)
	return

//LISTENSTONE		LISTENSTONE
/obj/item/listenstone
	name = "翡翠项圈"
	icon_state = "listenstone"
	desc = "一只镶有翡翠的铁金项圈。"
	gripped_intents = null
	//dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	//force = 10
	//throwforce = 10
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_WRISTS
	obj_flags = null
	icon = 'icons/roguetown/clothing/neck.dmi'
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	muteinmouth = TRUE
	var/listening = TRUE
	var/speaking = TRUE
	sellprice = 200
	grid_width = 32
	grid_height = 32

/obj/item/listenstone/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	listening = !listening
	speaking = !speaking
	to_chat(user, span_info("我将通讯石戒[speaking ? "取消静音" : "静音"]了。"))
	update_icon()
	if(listening)
		icon_state = "listenstone"
	else
		icon_state = "listenstone_act"

/obj/item/listenstone/Initialize(mapload)
	. = ..()
	update_icon()
	SSroguemachine.scomm_machines += src//dont know what this is for


/obj/item/listenstone/proc/repeat_message(message, atom/A, tcolor, message_language, list/tspans = list())
	if(A == src)
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
		say(message, spans = tspans, language = message_language)
	voicecolor_override = null

/obj/item/listenstone/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_default_language()
	if(istype(loc, /obj/item))
		var/obj/item/I = loc
		I.send_speech(message, 1, I, , spans, message_language=language)
	else
		send_speech(message, 1, src, , spans, message_language=language)

	return

// MATTHIAN SCOMCOIN

/obj/item/mattcoin
	name = "隆茨戒指"
	icon_state = "mattcoin"
	desc = "一枚褪色的硬币，中央嵌着一颗红宝石。"
	gripped_intents = null
	dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_RING|ITEM_SLOT_HANDS
	obj_flags = null
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	muteinmouth = TRUE
	var/listening = TRUE
	var/speaking = TRUE
	sellprice = 0
	grid_width = 32
	grid_height = 32

/obj/item/mattcoin/Initialize(mapload)
	. = ..()
	become_hearing_sensitive()
	update_icon()
	SSroguemachine.scomm_machines += src
	name = pick("隆茨戒指", "金戒指")

/obj/item/mattcoin/pickup(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_COMMIE))
		to_chat(user, "这枚硬币在我手中化成了灰！")
		playsound(loc, 'sound/items/firesnuff.ogg', 100, FALSE, -1)
		qdel(src)
	..()

/obj/item/mattcoin/doStrip(mob/stripper, mob/owner)
	if(!(stripper?.mind.has_antag_datum(/datum/antagonist/bandit))) //You're not a bandit, you can't strip the bandit coin
		to_chat(stripper, "[src]在我手中化成了灰！")
		playsound(stripper.loc, 'sound/items/firesnuff.ogg', 100, FALSE, -1)
		qdel(src)
		return FALSE
	. = ..()

/obj/item/mattcoin/attack_right(mob/living/carbon/human/user)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	var/input_text = input(user, "输入你的消息：", "消息")
	if(input_text)
		var/usedcolor = user.voice_color
		if(user.voicecolor_override)
			usedcolor = user.voicecolor_override
		user.whisper(input_text)
		var/list/tspans = list()
		if(user.client.patreonlevel() >= GLOB.patreonsaylevel)
			tspans |= SPAN_PATREON_SAY
		if(length(input_text) > 100)
			input_text = "<small>[input_text]</small>"
		for(var/obj/item/mattcoin/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text, src, usedcolor, tspans = tspans)

/obj/item/mattcoin/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
	listening = !listening
	speaking = !speaking
	to_chat(user, span_info("我将马西奥斯通讯石[speaking ? "取消静音" : "静音"]了。"))
	update_icon()

/obj/item/mattcoin/Destroy()
	lose_hearing_sensitivity()
	SSroguemachine.scomm_machines -= src
	return ..()

/obj/item/mattcoin/Initialize(mapload)
	. = ..()
	update_icon()
	SSroguemachine.scomm_machines += src

/obj/item/mattcoin/proc/repeat_message(message, atom/A, tcolor, message_language, list/tspans = list())
	if(A == src)
		return
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, 'sound/foley/coins1.ogg', 20, TRUE, -1)
		say(message, spans = tspans, language = message_language)
	voicecolor_override = null


/obj/item/mattcoin/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_default_language()
	if(istype(loc, /obj/item))
		var/obj/item/I = loc
		I.send_speech(message, 0, I, , spans, message_language=language)
	else
		send_speech(message, 0, src, , spans, message_language=language)


// INQUISITORIAL LISTENERS AND RECEIVER


/obj/item/speakerinq
	name = "密语低语器"
	desc = "甜美的秘密，如此轻易地被低声道出。"
	var/speaking = TRUE
	sellprice = 20
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scomite"
	gripped_intents = null
	dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP|ITEM_SLOT_RING|ITEM_SLOT_HANDS
	possible_item_intents = list(INTENT_GENERIC)
	sleeved = 'icons/roguetown/clothing/onmob/neck.dmi'
	grid_width = 32
	grid_height = 32
	var/fakename = "密语低语器"

/obj/item/speakerinq/proc/repeat_message(message, atom/A, tcolor, message_language, list/tspans = list())
	if(A == src)
		return
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		var/mob/living/carbon/human/wearer = loc
		wearer.playsound_local(wearer, 'sound/vo/mobs/rat/rat_life.ogg', 50, TRUE)
		say(message, spans = tspans, language = message_language)
	voicecolor_override = null

/obj/item/speakerinq/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_default_language()
	if(istype(loc, /obj/item))
		var/obj/item/I = loc
		I.send_speech(message, 0, I, , spans, message_language=language)
	else
		send_speech(message, 0, src, , spans, message_language=language)


/obj/item/speakerinq/equipped(mob/user, slot)
	. = ..()
	switch(slot)
		if(SLOT_RING)
			fakename = "silver signet ring"	
			name = fakename
	return TRUE		


/obj/item/speakerinq/dropped(mob/user, silent)
	. = ..()
	name = initial(name)
	sleeved = null
	mob_overlay_icon = null

/obj/item/speakerinq/Destroy()
	SSroguemachine.scomm_machines -= src
	return ..()

/obj/item/speakerinq/Initialize(mapload)
	. = ..()
	icon_state = "scomite_active"
	update_icon()
	SSroguemachine.scomm_machines += src

/obj/item/speakerinq/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	speaking = !speaking
	to_chat(user, span_info("我将密语低语器[speaking ? "取消禁言" : "禁言"]了。"))
	if(speaking)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = "[initial(icon_state)]"
	update_icon()

/obj/item/listeningdevice
	name = "监听耳"
	desc = "一只时刻留神的耳朵……"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "listenstone"
	dropshrink = 0.6
	gripped_intents = null
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	alpha = 255
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	grid_width = 32
	grid_height = 32
	var/label = null
	var/inqdesc = null
	var/hidden = FALSE
	var/active = FALSE
	var/datum/status_effect/bugged/effect

/obj/item/listeningdevice/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		desc = inqdesc
	else
		desc = initial(desc)

/obj/item/listeningdevice/Initialize(mapload)
	. = ..()
	become_hearing_sensitive()
	inqdesc = "An ever-attentive ear... [span_notice("This ear hasn't been bent. It's unlabelled.")]"

/obj/item/listeningdevice/Destroy()
	lose_hearing_sensitivity()
	return ..()

/obj/item/listeningdevice/attack_self(mob/living/user)
	var/input = input(user, "SIX LETTERS", "BEND AN EAR")
	if(!input)
		label = null
		inqdesc = "An ever-attentive ear... [span_notice("This ear hasn't been bent. It's unlabelled.")]"
		desc = inqdesc
		return
	label = uppertext(trim(input, 7))
	inqdesc = "An ever-attentive ear... [span_notice("This ear's been bent. It's labelled as [label].")]"
	desc = inqdesc
	return

/obj/item/listeningdevice/attack_right(mob/living/user)
	if(!hidden)
		alpha = 30
		name = "东西"
		desc = "那是个什么东西？.."
		hidden = TRUE
		return TRUE
	alpha = 255
	name = initial(name)
	desc = initial(desc)
	hidden = FALSE
	return TRUE
/* FINISH THIS AT YOUR OWN LEISURE. IT WON'T TAKE MUCH WORK. AT MOST YOU'LL BE ADDING DISCOVERY CHECKS ON EXAMINE AND THE ABILITY TO RIP OFF DISCOVERED LISTENERS. HAVE FUN! - YISCHE
/obj/item/listeningdevice/attack(mob/living/M, mob/living/user)
	if(!active)
		to_chat(user, span_warning("[src]没有反应。"))
		return FALSE
	
	to_chat(user, span_notice("我把[src]装到了[M]身上。"))
	effect = M.apply_status_effect(/datum/status_effect/bugged)
	effect.device = src
	forceMove(M)
	M.contents.Add(src)

	if(M.STAPER > user.STASPD)
		to_chat(M, span_hidden("我感觉有什么掠过后颈，刺得发痛。"))

	..()
*/
/obj/item/listeningdevice/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/bug.ogg', 50, FALSE, -1)
	active = !active
	if(active)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = initial(icon_state)
	to_chat(user, span_info("我将窃听耳[active ? "取消失聪" : "静聋"]了。"))
	update_icon()
	return

/obj/item/listeningdevice/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(!active)
		return
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/H = speaker
	var/usedcolor = H.voice_color
	if(H.voicecolor_override)
		usedcolor = H.voicecolor_override
	var/list/tspans = list()
	if(H.client.patreonlevel() >= GLOB.patreonsaylevel)
		tspans |= SPAN_PATREON_SAY
	if(!raw_message)
		return
	if(length(raw_message) > 100)
		raw_message = "<small>[raw_message]</small>"
	for(var/obj/item/speakerinq/S in SSroguemachine.scomm_machines)
		S.name = label ? "#[label]" : "#NOTSET"
		S.repeat_message(raw_message, src, usedcolor, message_language, tspans)
		S.name = (S.fakename)

// garrison scoms/listenstones

/obj/item/scomstone/garrison
	name = "王冠石戒"
	icon_state = "ring_crownscom"
	desc = "一枚奢华的金戒，带着王冠的印记。厚重又张扬，嵌着的宝石兴奋地闪烁着。"
	var/garrisonline = TRUE
	messagereceivedsound = 'sound/misc/garrisonscom.ogg'
	hearrange = 0
	sellprice = 100

/obj/item/scomstone/garrison/attack_right(mob/living/carbon/human/user)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	visible_message(span_notice ("[user]把戒指按在嘴边。"))
	var/input_text = input(user, "输入你的消息：", "消息")
	if(!input_text)
		return
	var/usedcolor = user.voice_color
	if(user.voicecolor_override)
		usedcolor = user.voicecolor_override
	user.whisper(input_text)
	var/list/tspans = list()
	if(user.client.patreonlevel() >= GLOB.patreonsaylevel)
		tspans |= SPAN_PATREON_SAY
	if(length(input_text) > 100) //When these people talk too much, put that shit in slow motion, yeah
		input_text = "<small>[input_text]</small>"
	if(garrisonline)
		input_text = "<big><span style='color: [GARRISON_SCOM_COLOR]'>[input_text]</span></big>" //Prettying up for Garrison line
		for(var/obj/item/scomstone/bad/garrison/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text, src, usedcolor, tspans = tspans)
		for(var/obj/item/scomstone/garrison/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text, src, usedcolor, tspans = tspans)
		for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
			if(S.garrisonline)
				S.repeat_message(input_text, src, usedcolor, tspans = tspans)
		SSroguemachine.crown?.repeat_message(input_text, src, usedcolor, tspans = tspans)
		return
	for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor, tspans = tspans)
	for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor, tspans = tspans)
	for(var/obj/item/listenstone/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor, tspans = tspans)
	SSroguemachine.crown?.repeat_message(input_text, src, usedcolor, tspans = tspans)

/obj/item/scomstone/garrison/attack_self(mob/living/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	garrisonline = !garrisonline
	to_chat(user, span_info("我[garrisonline ? "接入了卫戍 SCOM 线路" : "接入了普通 SCOM 线路"]。"))
	update_icon()

/obj/item/scomstone/garrison/update_icon()
	icon_state = "[initial(icon_state)][garrisonline ? "_on" : ""]"

/obj/item/scomstone/bad/garrison
	name = "猎犬石戒"
	desc = "一枚朴素的金属戒指，上面镶着一颗切工精良却黯淡的宝石，带着王冠的印记。"
	icon_state = "ring_houndscom"
	listening = FALSE
	sellprice = 20
	messagereceivedsound = 'sound/misc/garrisonscom.ogg'
	hearrange = 0
