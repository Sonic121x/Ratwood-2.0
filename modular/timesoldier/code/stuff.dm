#define FUTURE_VOICE_MALE_GENERIC "Male Generic" // regular guy.
#define FUTURE_VOICE_FEMALE "Female" // girlboss.

#define FUTURE_LANGUAGE_IMPERIAL "Imperial"
#define FUTURE_LANGUAGE_NEW_IMPERIAL "New Imperial"


/obj/item/reagent_containers/food/snacks/rogue/timesoldier/ferenchow
	name = "费伦提亚军粮罐头"
	desc = "<span class='yellow'><i>在王田大批量生产，管饱，而且出乎意料地好吃。里面装的是人人喜爱、受伊奥拉祝福的炖肉。</i></span>"
	icon = 'modular/timesoldier/sprites/stuff.dmi'
	icon_state = "ferenchow"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	tastes = list("盐" = 2, "炖肉" = 2, "家乡" = 1)
	foodtype = MEAT | GRAIN
	faretype = FARE_POOR
	bitesize = 5
	trash = /obj/item/trash/timesoldier/ferenchow
	drop_sound = 'modular/timesoldier/sounds/candrop.ogg'
	var/opened = FALSE


/obj/item/reagent_containers/food/snacks/rogue/timesoldier/ferenchow/attack(mob/living/M, mob/living/user, def_zone)
	if(user.used_intent.type == INTENT_HARM || user.cmode)
		return ..()

	if(!opened)
		to_chat(user, span_warning("我得先打开[src]。"))
		return

	return ..()


/obj/item/reagent_containers/food/snacks/rogue/timesoldier/ferenchow/attackby(obj/item/W, mob/living/user, params)
	if(opened)
		return ..()

	if(W.wlength == WLENGTH_SHORT && (user.used_intent?.blade_class in list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB)))
		user.visible_message(
			span_notice("[user]用[W]撬开了[src]。"),
			span_notice("我用[W]撬开了[src]。")
		)
		playsound(src, 'modular/timesoldier/sounds/canopen.ogg', 60, TRUE)
		opened = TRUE
		icon_state = "ferenchow_open"
		return

	to_chat(user, span_warning("我需要一件短而锋利的东西来撬开[src]。"))
	return


/obj/item/trash/timesoldier/ferenchow
	name = "空费伦提亚军粮罐头"
	desc = "一个空军粮罐，底部还剩些炖肉。看起来像是王田出产的东西！"
	icon = 'modular/timesoldier/sprites/stuff.dmi'
	icon_state = "ferenchow_empty"
	experimental_inhand = TRUE


/obj/item/timesoldier/radio
	name = "野战收发器"
	desc = "<span class='yellow'><i>我还记得我们用它们替换旧传讯戒指的时候。即使相隔遥远，我们也能接到命令。它们由奥术魔法驱动，而这一台里面特别装了一块彗星碎片。他们告诉我，这样就能跨越'时间'通信。</span><br><br>你能感受到其中蕴藏着SYON彗星的力量……里面一定有一块极小的彗星碎片。"
	icon = 'modular/timesoldier/sprites/radio.dmi'
	icon_state = "HEART"
	var/broadcasting = FALSE
	var/voice_template = FUTURE_VOICE_MALE_GENERIC
	var/broadcast_language = FUTURE_LANGUAGE_NEW_IMPERIAL
	var/radio_noise_timer
	verb_say = "冷冷地说道"
	verb_ask = "冷冷地说道"
	verb_exclaim = "冷冷地说道"
	verb_yell = "冷冷地说道"
	grid_width = 32
	grid_height = 32 // smol
	voicecolor_override = "97cefd"
	var/tmp/language_icon_html = ""


/obj/item/timesoldier/radio/say_quote(input, list/spans = list(speech_span), message_mode)
	var/rendered = ..()
	return "<span style='color:#97cefd;'>[rendered]</span>"


/obj/item/timesoldier/radio/GetVoice()
	return "[language_icon_html]<span style='font-size: 115%;'><b>未知</b></span>"

/obj/item/timesoldier/radio/proc/get_language_icon_for(atom/movable/hearer, datum/language/language) // blatantly stolen from our language stuff.
	if(!language)
		return ""

	if(!ismob(hearer))
		return ""

	var/mob/M = hearer

	if(!M.client)
		return ""

	if(!M.show_language_icon())
		return ""

	if(!language.display_icon(M))
		return ""

	var/language_name = url_encode(language.name)
	var/language_desc = url_encode(language.desc)

	return "<a href='byond://?src=\ref[M.client];lang_name=[language_name];lang_desc=[language_desc]'><span style=\"position: relative; bottom: 4px;\">[language.get_icon()]</span></a>"



/obj/item/timesoldier/radio/Destroy() // so if we qdel it - which we will, we don't accidentally leave the looping sound hanging in the air.
	if(radio_noise_timer)
		deltimer(radio_noise_timer)
		radio_noise_timer = null



	return ..()


/obj/item/timesoldier/radio/proc/start_broadcast(selected_voice, selected_language)
	if(broadcasting)
		return

	broadcasting = TRUE

	// Set our resting state to open, then visually play the opening animation.
	icon_state = "NERVES"
	flick("LUNGS", src)

	voice_template = selected_voice
	broadcast_language = selected_language

	visible_message(
		span_notice("[src]中的纳莱迪时间水晶轻轻碰上彗星碎片，发出清脆声响；奇异的内部构件让它启动，响起低沉平稳的嗡鸣。")
	)

	playsound(src, 'modular/timesoldier/sounds/comms/broadstart.ogg', 55, FALSE)



	schedule_radio_noise()

/obj/item/timesoldier/radio/proc/message_is_yelling(message)
	if(!message)
		return FALSE

	for(var/i = length(message), i >= 1, i--)
		var/character = copytext(message, i, i + 1)

		if(character == "!")
			return TRUE

		if(character in list (" ", "\t", ".", "?", "\"", "'", ")", "]"))
			continue
		return FALSE
	return FALSE


/obj/item/timesoldier/radio/proc/receive_broadcast(message)
	if(!broadcasting)
		return

	playsound(src, 'modular/timesoldier/sounds/comms/startspeak.ogg', 55, FALSE)
	addtimer(CALLBACK(src, PROC_REF(deliver_broadcast), message), 4)

/obj/item/timesoldier/radio/proc/deliver_broadcast(message)
	if(!broadcasting)
		return

	var/sound_to_play

	switch(voice_template)
		if(FUTURE_VOICE_MALE_GENERIC)
			sound_to_play = pick('modular/timesoldier/sounds/comms/male_generic/generic1.ogg', 'modular/timesoldier/sounds/comms/male_generic/generic2.ogg', 'modular/timesoldier/sounds/comms/male_generic/generic3.ogg')

		if(FUTURE_VOICE_FEMALE)
			sound_to_play = pick('modular/timesoldier/sounds/comms/female/female1.ogg', 'modular/timesoldier/sounds/comms/female/female2.ogg', 'modular/timesoldier/sounds/comms/female/female3.ogg')
	if(sound_to_play)
		playsound(src, sound_to_play, 55, FALSE)

	switch(broadcast_language)
		if(FUTURE_LANGUAGE_IMPERIAL)
			say_imperial(message)
		if(FUTURE_LANGUAGE_NEW_IMPERIAL)
			say_new_imperial(message)

/obj/item/timesoldier/radio/proc/schedule_radio_noise()
	if(!broadcasting)
		return

	if(radio_noise_timer)
		deltimer(radio_noise_timer)

	var/noise_delay = rand(15 SECONDS, 40 SECONDS) // i cant believe the compiler choked on this.
	var/datum/callback/noise_callback = CALLBACK(src, PROC_REF(play_radio_noise))
	radio_noise_timer = addtimer(noise_callback, noise_delay, TIMER_STOPPABLE) // this should hopefully properly fix it.

/obj/item/timesoldier/radio/proc/play_radio_noise()
	radio_noise_timer = null

	if(!broadcasting)
		return

	playsound(src, 'modular/timesoldier/sounds/comms/lsnoise.ogg', 50, FALSE)
	schedule_radio_noise()

/obj/item/timesoldier/radio/proc/end_broadcast()
	if(!broadcasting)
		return

	broadcasting = FALSE

	// Set our resting state to closed, then visually play the closing animation.
	icon_state = "HEART"
	flick("LIVER", src)



	playsound(
		src,
		'modular/timesoldier/sounds/comms/broadend.ogg',
		45,
		FALSE
	)

	visible_message(
		span_notice("[src]内部的嗡鸣逐渐减弱，直至完全沉寂；纳莱迪时间水晶与彗星碎片分开了。")
	)

	if(radio_noise_timer)
		deltimer(radio_noise_timer)
		radio_noise_timer = null

// RADIO TRANSLATION STUFF.

/obj/item/timesoldier/radio/proc/say_imperial(message)
	var/list/hearers = get_hearers_in_view(7, src)
	var/list/spans = list()
	spans |= speech_span

	var/rendered_message = compose_message(
		src,
		/datum/language/common,
		message,
		null,
		spans,
		null
	)

	for(var/atom/movable/hearer as anything in hearers)
		if(!hearer)
			continue

		hearer.Hear(
			rendered_message,
			src,
			/datum/language/common,
			message,
			null,
			spans,
			null
		)


/obj/item/timesoldier/radio/proc/say_new_imperial(message)
	var/datum/language/new_imperial/new_imperial = GLOB.language_datum_instances[/datum/language/new_imperial]
	if(!new_imperial)
		return

	var/list/hearers = get_hearers_in_view(7, src)
	var/list/spans = list()
	spans |= speech_span

	for(var/atom/movable/hearer as anything in hearers)
		if(!hearer)
			continue

		var/heard_message = "\[完全听不懂这番话……\]"
		var/datum/language/delivery_language = /datum/language/common
		if(isobserver(hearer))
			heard_message = message
		else if(isliving(hearer))
			var/mob/living/living_hearer = hearer
			heard_message = new_imperial.translate_for(living_hearer, message)

			// native New Imperial speakers should receive ACTUAL New Imperial. because this is literally a hack and its actually old imperial.
			if(living_hearer.has_language(/datum/language/new_imperial))
				delivery_language = /datum/language/new_imperial

		// if we're delivering actual New Imperial, Ratwood will render
		// the language icon natively.
		//
		// Otherwise we're using old imperial internally only as a carrier for
		// our manually translated partial-comprehension text, so manually
		// show the New Imperial icon.
		if(delivery_language == /datum/language/new_imperial)
			language_icon_html = ""
		else
			language_icon_html = get_language_icon_for(hearer, new_imperial)

		var/rendered_message = compose_message(
			src,
			delivery_language,
			heard_message,
			null,
			spans,
			null
		)

		hearer.Hear(
			rendered_message,
			src,
			delivery_language,
			heard_message,
			null,
			spans,
			null
		)

		language_icon_html = "" // gotta be after hear otherwise hear recomposes the message so only clear this after we...uh...hear.
