/datum/action/cooldown/spell/message
	name = "传讯术"
	desc = "连接一位你熟识之人的心灵，将话语低声送入其脑海，或投去一道直觉性的幻景。"
	button_icon_state = "message"
	sound = 'sound/magic/message.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("心念之言")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 2

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// The stat threshold needed to pass the identify check.
	var/identify_difficulty = 15

/datum/action/cooldown/spell/message/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!istype(user) || !user.mind)
		return FALSE

	if(!user.mind.known_people.len)
		to_chat(user, span_warning("我不认识任何人。"))
		return FALSE

	var/list/eligible_players = list()
	for(var/people in user.mind.known_people)
		eligible_players += people
	eligible_players = sortList(eligible_players)

	var/input = tgui_input_list(user, "你想联系谁？", "传讯", eligible_players)
	if(isnull(input))
		to_chat(user, span_warning("未选择目标。"))
		return FALSE

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name != input)
			continue

		user.emote("me", 1, "低声念诵咒文，嘴边短暂闪过一道白光！", TRUE, custom_me = TRUE)

		var/message_color = "#7246ff"
		var/is_projection = FALSE

		if(alert(user, "传送无言的感官幻象，还是低语讯息？", "", "Projection", "传讯") == "Projection")
			is_projection = TRUE

		var/message = sanitize(input(user, "你成功建立了联结！[is_projection ? "你想向对方心中传送什么感官幻象？" : "你想在对方心中低语什么？"]"))
		if(!message)
			return FALSE

		if(alert(user, "Send anonymously?", "", "Yes", "No") == "No")
			identify_difficulty = 0

		HL.playsound_local(HL, 'sound/magic/message.ogg', 100)
		user.playsound_local(user, 'sound/magic/message.ogg', 100)

		var/identified = FALSE
		if(HL.STAPER >= identify_difficulty)
			if(HL.mind)
				if(HL.mind.do_i_know(name=user.real_name))
					identified = TRUE
					if(ishuman(user))
						message_color = user.voice_color
					if(!is_projection)
						to_chat(HL, span_big("奥术低语潜入我的心中，化作[user]的声音：<font color=[message_color]><i>\"[message]\"</i></font>"))
						to_chat(user, span_big("你在[HL]心中低语，并表明了身份：<font color=[message_color]><i>\"[message]\"</i></font>"))
					else
						to_chat(HL, span_big("一段短暂幻象突然掠过我的心间，熟悉的感觉表明它来自[user]的心境：<font color=[message_color]>\[<b>[message]</b>\]</font>"))
						to_chat(user, span_big("你将一段短暂幻象送入[HL]心中，并表明了身份：<font color=[message_color]>\[<b>[message]</b>\]</font>"))

		if(!identified)
			if(!is_projection)
				to_chat(HL, span_big("奥术低语潜入我的心中，化作陌生[user.gender == FEMALE ? "女子" : "男子"]的声音：<font color=[message_color]><i>\"[message]\"</i></font>"))
				to_chat(user, span_big("你匿名在[HL]心中低语：<font color=[message_color]><i>\"[message]\"</i></font>"))
			else
				to_chat(HL, span_big("一段来源不明的短暂幻象突然掠过我的心间：<font color=[message_color]>\[<b>[message]</b>\]</font>"))
				to_chat(user, span_big("你匿名将一段短暂幻象送入[HL]心中：<font color=[message_color]>\[<b>[message]</b>\]</font>"))

		if(!is_projection)
			user.whisper(message, language = /datum/language/common)
		else
			user.emote("me", 1, "无声地喃喃，仿佛在说些什么……", TRUE, custom_me = TRUE)

		log_game("[key_name(user)] sent a message to [key_name(HL)] with contents [message]")
		return TRUE

	to_chat(user, span_warning("我试图寻求心灵连接，却找不到[input]。"))
	return FALSE
