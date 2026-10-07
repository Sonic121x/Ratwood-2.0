#define TIMESOLDIER_TEMPERANCE "Temperance"
#define TIMESOLDIER_ARSONIST "Arsonist"
#define TIMESOLDIER_INTERWAR "awuff button" // to be removed

#define TIMESOLDIER_SPAWN_CKEY "Ckey"
#define TIMESOLDIER_SPAWN_GHOST "Ghost"
#define TIMESOLDIER_SPAWN_SELF "Self"
#define TIMESOLDIER_SPAWN_OFFER "Offer to Ghosts"
#define TIMESOLDIER_SPAWN_CANCEL "Cancel"

/client/proc/timesoldier_start_broadcast()
	set category = "-GameMaster-"
	set name = "未来广播 - 开始"
	set desc = "通过所有时空士兵的收发器开始广播。"

	if(!check_rights(R_FUN))
		return
	
	var/list/voice_options = list(
		"普通男声" = FUTURE_VOICE_MALE_GENERIC,
		"女声" = FUTURE_VOICE_FEMALE
	)

	var/list/language_options = list(
		"帝国语" = FUTURE_LANGUAGE_IMPERIAL,
		"新帝国语" = FUTURE_LANGUAGE_NEW_IMPERIAL
	)

	var/selected_language = input(usr, "选择广播语言", "广播语言") as null|anything in language_options
	if(!selected_language)
		return

	var/selected_voice = input(usr, "选择声音类型。", "广播声音") as null|anything in voice_options
	if(!selected_voice)
		return
	
	var/radios_found = 0

	for(var/obj/item/timesoldier/radio/R in world)
		R.start_broadcast(voice_options[selected_voice], language_options[selected_language])
		radios_found++
	
	if(!radios_found)
		to_chat(usr, span_warning("世界中没有野战收发器！正在取消……"))
		return
	
	log_admin("[key_name(usr)] begun a Future Broadcast using the [selected_voice] voice in [selected_language].")
	message_admins(span_adminnotice("[key_name_admin(usr)] 开始了未来广播，使用[selected_voice]，语言为[selected_language]。"))


/client/proc/timesoldier_broadcast_message()
	set category = "-GameMaster-"
	set name = "未来广播 - 发送消息"
	set desc = "通过正在广播的时空士兵收发器发送消息。"

	if(!check_rights(R_FUN))
		return

	var/message = input(usr, "要广播什么内容？", "广播消息") as text|null
	if(!message)
		return
	
	var/radios_found = 0
	var/radios_active = 0

	for(var/obj/item/timesoldier/radio/R in world)
		radios_found++

		if(!R.broadcasting)	
			continue
		
		R.receive_broadcast(message)
		radios_active++
	
	if(!radios_found)
		to_chat(usr, span_warning("世界中没有野战收发器！正在取消……"))
		return
	
	if(!radios_active)
		to_chat(usr, span_warning("野战收发器目前没有广播。请先开启广播！"))
		return
	
	log_admin("[key_name(usr)] sent a Future Broadcast: \"[message]\"")
	message_admins(span_adminnotice("[key_name_admin(usr)] 发送了未来广播：\"[message]\""))


/client/proc/timesoldier_end_broadcast()
	set category = "-GameMaster-"
	set name = "未来广播 - 结束"
	set desc = "结束当前的时空士兵收发器广播。"

	if(!check_rights(R_FUN))
		return
	
	var/radios_found = 0
	var/radios_active = 0
	for(var/obj/item/timesoldier/radio/R in world)
		radios_found++

		if(!R.broadcasting)
			continue

		R.end_broadcast()
		radios_active++

	if(!radios_found)
		to_chat(usr, span_warning("世界中没有野战收发器！正在取消……"))
		return

	if(!radios_active)
		to_chat(usr, span_warning("野战收发器目前没有广播。请先开启广播！"))
		return

	log_admin("[key_name(usr)] ended the Future Broadcast.")
	message_admins(span_adminnotice("[key_name_admin(usr)] 结束了未来广播。"))


// i dont want to edit the core admin modules to register the verbs from here and want to keep it modular, so i'll just do it here

// REGISTRAR ====  === = == == =

/datum/timesoldier_admin_verb_registrar

/datum/timesoldier_admin_verb_registrar/New()
	. = ..()

	GLOB.admin_verbs_fun += list(
		/client/proc/timesoldier_start_broadcast,
		/client/proc/timesoldier_broadcast_message,
		/client/proc/timesoldier_end_broadcast,
		/client/proc/timesoldier_spawn
	)

GLOBAL_DATUM_INIT(timesoldier_admin_verb_registrar, /datum/timesoldier_admin_verb_registrar, new)


// TIME SOLDIER SPAWNING ===========


/client/proc/timesoldier_spawn()
	set category = "-GameMaster-"
	set name = "生成时空士兵"
	set desc = "在你的管理员幽灵所在位置生成一名时空士兵。"

	if(!check_rights(R_FUN))
		return

	if(!isobserver(mob))
		to_chat(src, span_warning("我需要处于管理员幽灵状态才能使用此指令。")) // sorry bud no bussing.
		return

	var/turf/spawn_turf = get_turf(mob)

	if(!spawn_turf)
		to_chat(src, span_warning("无法在我所在的位置找到有效地块。")) // somehow.
		return


	// what flavor we feelin
	var/list/soldier_types = list(
		"节制型" = TIMESOLDIER_TEMPERANCE,
		"纵火者" = TIMESOLDIER_ARSONIST,
		"嗷呜按钮" = TIMESOLDIER_INTERWAR
	)

	var/selected_type

	while(TRUE)
		selected_type = input(
			src,
			"要生成哪种时空士兵？",
			"时空士兵"
		) as null|anything in soldier_types

		// Cancelled the window.
		if(!selected_type)
			return

		// the illusion of choice.
		switch(soldier_types[selected_type])
			if(TIMESOLDIER_TEMPERANCE, TIMESOLDIER_ARSONIST)
				break

			if(TIMESOLDIER_INTERWAR)
				switch(rand(1, 3))
					if(1)
						src << sound('sound/vo/mobs/vw/awuff.ogg')
					if(2)
						src << sound('sound/vo/mobs/vw/awuff2.ogg')
					if(3)
						src << sound('sound/vo/mobs/vw/awuff3.ogg')

				continue

	// How are we giving control of them?
	var/list/spawn_options = list(
		"指定 ckey" = TIMESOLDIER_SPAWN_CKEY,
		"选择幽灵" = TIMESOLDIER_SPAWN_GHOST,
		"自己控制" = TIMESOLDIER_SPAWN_SELF,
		"征集幽灵志愿者" = TIMESOLDIER_SPAWN_OFFER,
		"取消" = TIMESOLDIER_SPAWN_CANCEL
	)

	var/spawn_method = input(
		src,
		"由谁控制这名[selected_type]时空士兵？",
		"时空士兵"
	) as null|anything in spawn_options

	if(!spawn_method || spawn_options[spawn_method] == TIMESOLDIER_SPAWN_CANCEL)
		return


	var/client/target_client


	switch(spawn_options[spawn_method])

		// SPECIFIC CKEY


		if(TIMESOLDIER_SPAWN_CKEY)

			var/target_ckey = ckey(input(
				src,
				"输入将控制时空士兵的玩家 ckey。",
				"时空士兵"
			) as text|null)

			if(!target_ckey)
				return

			target_client = GLOB.directory[target_ckey]

			if(!target_client)
				to_chat(src, span_warning("找不到 ckey 为 '[target_ckey]' 的在线玩家。"))
				return


		// PICK FROM CURRENT GHOSTS

		if(TIMESOLDIER_SPAWN_GHOST)

			var/list/ghost_options = list()

			for(var/mob/dead/observer/G in GLOB.player_list)
				if(!G.client || !G.ckey)
					continue

				ghost_options["[G.ckey]"] = G.client

			if(!length(ghost_options))
				to_chat(src, span_warning("没有可供选择的幽灵。"))
				return

			var/selected_ghost = input(
				src,
				"由哪名幽灵控制时空士兵？",
				"时空士兵"
			) as null|anything in ghost_options

			if(!selected_ghost)
				return

			target_client = ghost_options[selected_ghost]


		// ADMIN THEMSELF

		if(TIMESOLDIER_SPAWN_SELF)

			target_client = src


		// OFFER TO ALL GHOSTS

		if(TIMESOLDIER_SPAWN_OFFER)

			var/list/mob/dead/observer/candidates = pollGhostCandidates(
				"时空裂开了。一位纳莱迪时间领主已开启通路。你愿意从未来归来，执行一项任务吗？",
				null,
				null,
				FALSE,
				100
			)

			if(!length(candidates))
				to_chat(src, span_warning("没有人自愿扮演时空士兵。"))
				return

			var/mob/dead/observer/chosen_ghost = pick(candidates)

			if(!chosen_ghost?.client)
				to_chat(src, span_warning("选中的志愿者已无法参与。"))
				return

			target_client = chosen_ghost.client


	if(!target_client)
		return


	// make sure they didn't disconnect while we were clicking through menus.
	if(QDELETED(target_client))
		to_chat(src, span_warning("该玩家已断开连接。"))
		return


	var/mob/living/carbon/human/H = create_time_soldier(
		target_client,
		spawn_turf,
		soldier_types[selected_type]
	)

	if(!H)
		to_chat(src, span_warning("创建时空士兵失败。"))
		return


	log_admin("[key_name(src)] spawned [key_name(H)] as a [selected_type] Time Soldier at [AREACOORD(H)].")
	message_admins(span_adminnotice("[key_name_admin(src)] 在 [ADMIN_VERBOSEJMP(H)] 将 [ADMIN_LOOKUPFLW(H)] 生成为[selected_type]时空士兵。"))


/proc/create_time_soldier(
	client/player,
	turf/spawn_turf,
	soldier_type
)
	if(!player)
		return

	if(!player.key)
		return

	if(!player.prefs)
		return

	if(!spawn_turf)
		return

	var/player_key = player.key

	// completely ordinary human.
	var/mob/living/carbon/human/H = new(spawn_turf)

	// build the human from this client's currently selected character.
	player.prefs.copy_to(H)
	H.dna.update_dna_identity()

	// equipment, stats, skills, languages, etc.
	apply_time_soldier_setup(H, soldier_type)

	// hand control over only after the body is completely prepared.
	H.key = player_key

	setup_timesoldier_languages(H) // use the helper from language.dm

	return H


/proc/apply_time_soldier_setup(mob/living/carbon/human/H, soldier_type)
	if(!H)
		return

	switch(soldier_type)
		if(TIMESOLDIER_TEMPERANCE)
			apply_timesoldier_temperance(H)

		if(TIMESOLDIER_ARSONIST)
			apply_timesoldier_arsonist(H)

