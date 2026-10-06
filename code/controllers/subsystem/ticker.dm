#define ROUND_START_MUSIC_LIST "strings/round_start_sounds.txt"


GLOBAL_VAR_INIT(round_timer, INITIAL_ROUND_TIMER)

SUBSYSTEM_DEF(ticker)
	name = "Ticker"
	init_order = INIT_ORDER_TICKER

	priority = FIRE_PRIORITY_TICKER
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME

	var/current_state = GAME_STATE_STARTUP	//state of current round (used by process()) Use the defines GAME_STATE_* !
	var/force_ending = 0					//Round was ended by admin intervention
	// If true, there is no lobby phase, the game starts immediately.
	var/start_immediately = FALSE
	var/setup_done = FALSE //All game setup done including mode post setup and

	var/login_music							//music played in pregame lobby
	var/round_end_sound						//music/jingle played when the world reboots
	var/round_end_sound_sent = TRUE			//If all clients have loaded it

	var/list/datum/mind/minds = list()		//The characters in the game. Used for objective tracking.

	var/delay_end = 0						//if set true, the round will not restart on it's own
	var/admin_delay_notice = ""				//a message to display to anyone who tries to restart the world after a delay
	var/ready_for_reboot = FALSE			//all roundend preparation done with, all that's left is reboot

	var/triai = 0							//Global holder for Triumvirate
	var/tipped = 0							//Did we broadcast the tip of the day yet?
	var/selected_tip						// What will be the tip of the day?

	var/timeLeft						//pregame timer
	var/start_at
	//576000 dusk
	//376000 day
	var/gametime_offset = 288001		//Deciseconds to add to world.time for station time.
	var/station_time_rate_multiplier = 50		//factor of station time progressal vs real time.
	var/time_until_vote = 180 MINUTES
	var/last_vote_time = null
	var/autovote = TRUE
	var/firstvote = TRUE

	var/totalPlayers = 0					//used for pregame stats on statpanel
	var/totalPlayersReady = 0				//used for pregame stats on statpanel

	var/queue_delay = 0
	var/list/queued_players = list()		//used for join queues when the server exceeds the hard population cap

	var/maprotatechecked = 0

	var/news_report

	var/late_join_disabled

	var/roundend_check_paused = FALSE

	var/round_start_time = 0
	var/round_start_irl = 0
	var/list/round_start_events
	var/list/round_end_events
	var/mode_result = "undefined"
	var/end_state = "undefined"
	var/job_change_locked = FALSE
	var/list/royals_readied = list()

	/// Realm name, the location name of the current map
	var/realm_name = "Rotwood Vale"
	/// Reports the current ruler's display name
	var/rulertype = "Grand Duke"
	/// The current ruling mob
	var/rulermob = null
	/// Current regent mob
	var/regentmob = null
	/// Prevent regent shuffling
	var/regentday = -1
	var/failedstarts = 0
	var/list/manualmodes = list()

	var/gamemode_voted = FALSE
	var/end_party = FALSE
	var/last_lobby = 0
	var/round_end = FALSE

	var/next_lord_check = 0
	var/missing_lord_time = 0

	/// Sunsteal gamestate bool.
	var/sunstolen = FALSE

/datum/controller/subsystem/ticker/Initialize(timeofday)
	load_mode()

	var/list/byond_sound_formats = list(
		"mid"  = TRUE,
		"midi" = TRUE,
		"mod"  = TRUE,
		"it"   = TRUE,
		"s3m"  = TRUE,
		"xm"   = TRUE,
		"oxm"  = TRUE,
		"wav"  = TRUE,
		"ogg"  = TRUE,
		"raw"  = TRUE,
		"wma"  = TRUE,
		"aiff" = TRUE
	)

	var/list/provisional_title_music = flist("[global.config.directory]/title_music/sounds/")
	var/list/music = list()
	var/use_rare_music = prob(1)

	for(var/S in provisional_title_music)
		var/lower = LOWER_TEXT(S)
		var/list/L = splittext(lower,"+")
		switch(L.len)
			if(3) //rare+MAP+sound.ogg or MAP+rare.sound.ogg -- Rare Map-specific sounds
				if(use_rare_music)
					if(L[1] == "rare" && L[2] == SSmapping.current_map.map_name)
						music += S
					else if(L[2] == "rare" && L[1] == SSmapping.current_map.map_name)
						music += S
			if(2) //rare+sound.ogg or MAP+sound.ogg -- Rare sounds or Map-specific sounds
				if((use_rare_music && L[1] == "rare") || (L[1] == SSmapping.current_map.map_name))
					music += S
			if(1) //sound.ogg -- common sound
				if(L[1] == "exclude")
					continue
				music += S

//	var/old_login_music = trim(file2text("data/last_round_lobby_music.txt"))
//	if(music.len > 1)
//		music -= old_login_music

	for(var/S in music)
		var/list/L = splittext(S,".")
		if(L.len >= 2)
			var/ext = LOWER_TEXT(L[L.len]) //pick the real extension, no 'honk.ogg.exe' nonsense here
			if(byond_sound_formats[ext])
				continue
		music -= S

	if(isemptylist(music))
		music = world.file2list(ROUND_START_MUSIC_LIST, "\n")
		login_music = pick(music)
	else
		login_music = "[global.config.directory]/title_music/sounds/[pick(music)]"


	// TODO: Make music map dependent
	login_music = pick('sound/music/title.ogg','sound/music/title2.ogg','sound/music/title3.ogg','sound/music/title4.ogg')

	if(!GLOB.syndicate_code_phrase)
		GLOB.syndicate_code_phrase	= generate_code_phrase(return_list=TRUE)

		var/codewords = jointext(GLOB.syndicate_code_phrase, "|")
		var/regex/codeword_match = new("([codewords])", "ig")

		GLOB.syndicate_code_phrase_regex = codeword_match

	if(!GLOB.syndicate_code_response)
		GLOB.syndicate_code_response = generate_code_phrase(return_list=TRUE)

		var/codewords = jointext(GLOB.syndicate_code_response, "|")
		var/regex/codeword_match = new("([codewords])", "ig")

		GLOB.syndicate_code_response_regex = codeword_match

	start_at = world.time + (CONFIG_GET(number/lobby_countdown) * 10)
	if(CONFIG_GET(flag/randomize_shift_time))
		gametime_offset = rand(0, 23) HOURS
	else if(CONFIG_GET(flag/shift_time_realtime))
		gametime_offset = world.timeofday
	return ..()

/datum/controller/subsystem/ticker/fire()
	switch(current_state)
		if(GAME_STATE_STARTUP)
//			if(Master.initializations_finished_with_no_players_logged_in)
//			start_at = world.time + (CONFIG_GET(number/lobby_countdown) * 10)
			for(var/client/C in GLOB.clients)
				window_flash(C, ignorepref = TRUE) //let them know lobby has opened up.
//			to_chat(world, span_boldnotice("Welcome to [station_name()]!"))
			send2chat(new /datum/tgs_message_content("New round starting on [SSmapping.current_map.map_name]!"), CONFIG_GET(string/chat_announce_new_game))
			current_state = GAME_STATE_PREGAME
			//Everyone who wants to be an observer is now spawned
			create_observers()
			fire()
		if(GAME_STATE_PREGAME)
			//lobby stats for statpanels
			if(isnull(timeLeft))
				timeLeft = max(0,start_at - world.time)
			totalPlayers = LAZYLEN(GLOB.new_player_list)
			totalPlayersReady = 0
			for(var/i in GLOB.new_player_list)
				var/mob/dead/new_player/player = i
				if(player.ready == PLAYER_READY_TO_PLAY)
					++totalPlayersReady
			if(!gamemode_voted)
				gamemode_voted = TRUE
				SSvote.initiate_vote("chaos", "PSYDON", null, forced = TRUE)

			if(start_immediately)
				timeLeft = 0

			//countdown
			if(timeLeft < 0)
				return
			timeLeft -= wait

			if(timeLeft <= 300 && !tipped)
#ifdef MATURESERVER
				send_tip_of_the_round()
#endif
				tipped = TRUE

			if(timeLeft <= 0)
				if(!checkreqroles())
					current_state = GAME_STATE_STARTUP
					start_at = world.time + 600
					timeLeft = null
					Master.SetRunLevel(RUNLEVEL_LOBBY)
				else
					current_state = GAME_STATE_SETTING_UP
					Master.SetRunLevel(RUNLEVEL_SETUP)
					if(start_immediately)
						fire()

		if(GAME_STATE_SETTING_UP)
			if(!setup())
				//setup failed
				current_state = GAME_STATE_STARTUP
				start_at = world.time + 600
				timeLeft = null
				Master.SetRunLevel(RUNLEVEL_LOBBY)

		if(GAME_STATE_PLAYING)
			check_queue()

			check_for_lord()
			if(!roundend_check_paused && SSgamemode.check_finished(force_ending) || force_ending)
				SSgamemode.refresh_alive_stats()
				current_state = GAME_STATE_FINISHED
				toggle_ooc(TRUE) // Turn it on
				toggle_dooc(TRUE)
				declare_completion(force_ending)
				Master.SetRunLevel(RUNLEVEL_POSTGAME)

/datum/controller/subsystem/ticker
	var/last_bot_update = 0

/datum/controller/subsystem/ticker/proc/checkreqroles()
	var/list/readied_jobs = list()
	var/list/required_jobs = list()

	//var/list/required_jobs = list("Queen","King","Merchant") //JTGSZ - 4/11/2024 - This was the prev set of required jobs to go with the hardcoded checks commented out below

	for(var/V in required_jobs)
		for(var/mob/dead/new_player/player in GLOB.player_list)
			if(!player)
				continue
			if(player.client.prefs.job_preferences[V] == JP_HIGH)
				if(player.ready == PLAYER_READY_TO_PLAY)
					if(player.client.prefs.lastclass == V)
						if(player.IsJobUnavailable(V) != JOB_AVAILABLE)
							to_chat(player, span_warning("你无法担任[SSjob.GetJob(V)?.display_title || V]，因此不会被纳入候选。"))
							continue
				readied_jobs.Add(V)
		/*
			// These else conditions stop the round from starting unless there is a merchant, king, and queen.
		else
			var/list/stuffy = list("Set a Ruler to 'high' in your class preferences to start the game!", "PLAY Ruler NOW!", "A Ruler is required to start.", "Pray for a Ruler.", "One day, there will be a Ruler.", "Just try playing Ruler.", "If you don't play Ruler, the game will never start.", "We need at least one Ruler to start the game.", "We're waiting for you to pick Ruler to start.", "Still no Ruler is readied..", "I'm going to lose my mind if we don't get a Ruler readied up.","No. The game will not start because there is no Ruler.","What's the point of ROGUETOWN without a Ruler?")
			to_chat(world, span_purple("[pick(stuffy)]"))
			return FALSE
	else
		var/list/stuffy = list("Set Merchant to 'high' in your class preferences to start the game!", "PLAY Merchant NOW!", "A Merchant is required to start.", "Pray for a Merchant.", "One day, there will be a Merchant.", "Just try playing Merchant.", "If you don't play Merchant, the game will never start.", "We need at least one Merchant to start the game.", "We're waiting for you to pick Merchant to start.", "Still no Merchant is readied..", "I'm going to lose my mind if we don't get a Merchant readied up.","No. The game will not start because there is no Merchant.","What's the point of ROGUETOWN without a Merchant?")
		to_chat(world, span_purple("[pick(stuffy)]"))
		return FALSE
	*/

	/*
	for(var/mob/dead/new_player/player in GLOB.player_list)
		if(!player)
			continue
		if(player.ready == PLAYER_READY_TO_PLAY)
			amt_ready++

	if(amt_ready < 2)
		to_chat(world, span_purple("[amt_ready]/20 players ready."))
		failedstarts++
		if(failedstarts > 7)
			to_chat(world, span_purple("[failedstarts]/13"))
		if(failedstarts >= 13)
			to_chat(world, span_greentext("Starting ROGUEFIGHT..."))
			var/icon/ikon
			var/file_path = "icons/roguefight_title.dmi"
			ASSERT(fexists(file_path))
			ikon = new(fcopy_rsc(file_path))
			if(SStitle.splash_turf && ikon)
				SStitle.splash_turf.icon = ikon
			for(var/mob/dead/new_player/player in GLOB.player_list)
				player.playsound_local(player, 'sound/music/wartitle.ogg', 100, TRUE)
		return FALSE
	*/
	job_change_locked = TRUE
	return TRUE

/datum/controller/subsystem/ticker
	var/isroguefight = FALSE
	var/isrogueworld = FALSE

/datum/controller/subsystem/ticker/proc/setup()
	message_admins(span_boldannounce("Starting game..."))
	var/init_start = world.timeofday

	if(SSmapping.map_adjustment)
		realm_name = SSmapping.map_adjustment.realm_name
	CHECK_TICK
	//Configure mode and assign player to special mode stuff
	var/can_continue = 0

	CHECK_TICK

	can_continue =	SSgamemode.pre_setup()

	CHECK_TICK

	can_continue = can_continue && SSjob.DivideOccupations(list()) 				//Distribute jobs

	CHECK_TICK

	log_game("GAME SETUP: Divide Occupations success")

	CHECK_TICK

	// Previously: if(!CONFIG_GET(flag/ooc_during_round)) toggle_ooc(FALSE)
	// OOC has been repurposed to be lobby-only (non-lobby players can't see or use it),
	// so there's no longer a gameplay reason to auto-disable it at round start.
	// Keeping it enabled prevents admins from needing to hit the toggle every round.
	if(!GLOB.ooc_allowed)
		toggle_ooc(TRUE) // Ensure lobby OOC is on for the new round

	CHECK_TICK
	GLOB.start_landmarks_list = shuffle(GLOB.start_landmarks_list) //Shuffle the order of spawn points so they dont always predictably spawn bottom-up and right-to-left
	if(!isrogueworld && !isroguefight)
		create_characters() //Create player characters
		log_game("GAME SETUP: create characters success")
		collect_minds()
		log_game("GAME SETUP: collect minds success")
		equip_characters()
		log_game("GAME SETUP: equip characters success")

		GLOB.data_core.manifest()
		log_game("GAME SETUP: manifest success")

		transfer_characters()	//transfer keys to the new mobs
		log_game("GAME SETUP: transfer characters success")

	for(var/I in round_start_events)
		var/datum/callback/cb = I
		cb.InvokeAsync()

	log_game("GAME SETUP: round start events success")
	LAZYCLEARLIST(round_start_events)
	CHECK_TICK
	if(isrogueworld)
		for(var/obj/structure/fluff/traveltile/TT in GLOB.traveltiles)
			if(TT.aallmig)
				TT.aportalgoesto = TT.aallmig
		for(var/i in GLOB.mob_living_list)
			var/mob/living/L = i
			var/turf/T = get_turf(L)
			if(!T || !(T.z in list(2,3,4,5)))
				continue
			qdel(L)
		for(var/i in SSmachines.processing)
			var/obj/machinery/light/L = i
			if(istype(L))
				var/turf/T = get_turf(L)
				if(!T || !(T.z in list(2,3,4,5)))
					continue
				qdel(L)

	log_game("GAME SETUP: Game start took [(world.timeofday - init_start)/10]s")
	round_start_time = world.time
	round_start_irl = REALTIMEOFDAY
//	SSshuttle.emergency.startTime = world.time
//	SSshuttle.emergency.setTimer(ROUNDTIMERBOAT)

	SSdbcore.SetRoundStart()

	for(var/client/C in GLOB.clients)
		if(C.mob)
			C.mob.playsound_local(C.mob, 'sound/misc/roundstart.ogg', 100, FALSE)

//	SEND_SOUND(world, sound('sound/misc/roundstart.ogg'))
	current_state = GAME_STATE_PLAYING


	Master.SetRunLevel(RUNLEVEL_GAME)
/*
	if(SSevents.holidays)
		to_chat(world, span_notice("and..."))
		for(var/holidayname in SSevents.holidays)
			var/datum/holiday/holiday = SSevents.holidays[holidayname]
			to_chat(world, "<h4>[holiday.greet()]</h4>")
*/
	PostSetup()
	log_game("GAME SETUP: postsetup success")

	return TRUE

/datum/controller/subsystem/ticker/proc/PostSetup()
	set waitfor = FALSE

	SSgamemode.roll_round_modifiers()
	SSgamemode.open_villain_signups()
	SSgamemode.current_storyteller?.process(STORYTELLER_WAIT_TIME * 0.1) // we want this asap
	SSgamemode.current_storyteller?.round_started = TRUE

	world.TgsAnnounceRoundStart()

	setup_done = TRUE

	job_change_locked = FALSE

//	setup_hell()
	SStriumphs.fire_on_PostSetup()

	// Reset the found_lords list for the new round
	reset_found_lords()

	for(var/i in GLOB.start_landmarks_list)
		var/obj/effect/landmark/start/S = i
		if(istype(S))							//we can not runtime here. not in this important of a proc.
			S.after_round_start()
		else
			stack_trace("[S] [S.type] found in start landmarks list, which isn't a start landmark!")

/*	if(living_player_count() < 10) //If it's lowpop, open up the gates so people don't have to start doing assassin's creed bullshit to get into town
		for(var/obj/structure/gate/obstacle in GLOB.biggates)
			obstacle.open() */

	if(!rulermob)
		lord_color_default()
	barony_color_default()


//These callbacks will fire after roundstart key transfer
/datum/controller/subsystem/ticker/proc/OnRoundstart(datum/callback/cb)
	if(!HasRoundStarted())
		LAZYADD(round_start_events, cb)
	else
		cb.InvokeAsync()

//These callbacks will fire before roundend report
/datum/controller/subsystem/ticker/proc/OnRoundend(datum/callback/cb)
	if(current_state >= GAME_STATE_FINISHED)
		cb.InvokeAsync()
	else
		LAZYADD(round_end_events, cb)

/datum/controller/subsystem/ticker/proc/station_explosion_detonation(atom/bomb)
	if(bomb)	//BOOM
		var/turf/epi = bomb.loc
		qdel(bomb)
		if(epi)
			explosion(epi, 0, 256, 512, 0, TRUE, TRUE, 0, TRUE)

/datum/controller/subsystem/ticker/proc/create_characters()
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(!player)
			message_admins("THERES A FUCKING NULL IN THE NEW_PLAYER_LIST, REPORT IT TO RATWOOD DEVELOPMENT STAFF NOW!")
			continue
		if(!player.mind)
			message_admins("THERES A MIND LACKING PLAYER IN THE NEW_PLAYER_LIST, REPORT IT TO RATWOOD DEVELOPMENT STAFF NOW!")
			continue
		if(player.ready == PLAYER_READY_TO_PLAY)
			GLOB.joined_player_list += player.ckey
			player.create_character(FALSE)
		else
			player.new_player_panel()
		CHECK_TICK

/datum/controller/subsystem/ticker/proc/collect_minds()
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/P = i
		if(P.new_character && P.new_character.mind)
			SSticker.minds += P.new_character.mind
		CHECK_TICK

/datum/controller/subsystem/ticker/proc/equip_characters()
	var/list/valid_characters = list()
	for(var/mob/dead/new_player/new_player as anything in GLOB.new_player_list)
		var/mob/living/carbon/human/player = new_player.new_character
		if(istype(player) && player.mind?.assigned_role)
			if(player.mind.assigned_role != player.mind.special_role)
				valid_characters[player] = new_player
	sortTim(valid_characters, GLOBAL_PROC_REF(cmp_assignedrole_dsc))
	for(var/mob/character as anything in valid_characters)
		var/mob/new_player = valid_characters[character]
		SSjob.EquipRank(new_player, character.mind.assigned_role, joined_late = FALSE)
		CHECK_TICK

/datum/controller/subsystem/ticker/proc/transfer_characters()
	var/list/livings = list()
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		var/mob/living = player?.transfer_character()
		if(living)
			qdel(player)
			living.notransform = TRUE
			if(living.client)
				var/atom/movable/screen/splash/S = new(living.client, TRUE)
				S.Fade(TRUE)
			livings += living
			if(ishuman(living))
				SSrole_class_handler.setup_class_handler(living)
				try_apply_character_post_equipment(living)
		else
			continue
	if(livings.len)
		addtimer(CALLBACK(src, PROC_REF(release_characters), livings), 30, TIMER_CLIENT_TIME)

/datum/controller/subsystem/ticker/proc/release_characters(list/livings)
	for(var/I in livings)
		var/mob/living/L = I
		if(L)
			L?.notransform = FALSE

/datum/controller/subsystem/ticker/proc/send_tip_of_the_round()
	return
/*	var/m
	if(selected_tip)
		m = selected_tip
	else
		var/list/randomtips = world.file2list("strings/tips.txt")
//		var/list/memetips = world.file2list("strings/sillytips.txt")
//		if(randomtips.len && prob(95))
		m = pick(randomtips)
//		else if(memetips.len)
//			m = pick(memetips)
	if(m)
		to_chat(world, span_purple("Before we begin, remember: [html_encode(m)]"))
*/
/datum/controller/subsystem/ticker/proc/check_queue()
	if(!queued_players.len)
		return
	var/hpc = CONFIG_GET(number/hard_popcap)
	if(!hpc)
		listclearnulls(queued_players)
		for (var/mob/dead/new_player/NP in queued_players)
			to_chat(NP, span_danger("存活玩家人数限制已解除！<br><a href='?src=[REF(NP)];late_join=override'>[html_encode(">>加入游戏<<")]</a>"))
			SEND_SOUND(NP, sound('sound/blank.ogg'))
			NP.LateChoices()
		queued_players.len = 0
		queue_delay = 0
		return

	queue_delay++
	var/mob/dead/new_player/next_in_line = queued_players[1]

	switch(queue_delay)
		if(5) //every 5 ticks check if there is a slot available
			listclearnulls(queued_players)
			if(living_player_count() < hpc)
				if(next_in_line && next_in_line.client)
					to_chat(next_in_line, span_danger("有空位了！你有约20秒时间加入。<a href='?src=[REF(next_in_line)];late_join=override'>\>\>加入游戏\<\<</a>"))
					SEND_SOUND(next_in_line, sound('sound/blank.ogg'))
					next_in_line.LateChoices()
					return
				queued_players -= next_in_line //Client disconnected, remove he
			queue_delay = 0 //No vacancy: restart timer
		if(25 to INFINITY)  //No response from the next in line when a vacancy exists, remove he
			to_chat(next_in_line, span_danger("未收到回应，你已被移出队列。"))
			queued_players -= next_in_line
			queue_delay = 0


/datum/controller/subsystem/ticker/proc/HasRoundStarted()
	return current_state >= GAME_STATE_PLAYING

/datum/controller/subsystem/ticker/proc/IsRoundInProgress()
	return current_state == GAME_STATE_PLAYING

/datum/controller/subsystem/ticker/Recover()
	current_state = SSticker.current_state
	force_ending = SSticker.force_ending

	login_music = SSticker.login_music
	round_end_sound = SSticker.round_end_sound

	minds = SSticker.minds

	delay_end = SSticker.delay_end

	triai = SSticker.triai
	tipped = SSticker.tipped
	selected_tip = SSticker.selected_tip

	timeLeft = SSticker.timeLeft

	totalPlayers = SSticker.totalPlayers
	totalPlayersReady = SSticker.totalPlayersReady

	queue_delay = SSticker.queue_delay
	queued_players = SSticker.queued_players
	maprotatechecked = SSticker.maprotatechecked
	round_start_time = SSticker.round_start_time
	round_start_irl = SSticker.round_start_irl

	queue_delay = SSticker.queue_delay
	queued_players = SSticker.queued_players
	maprotatechecked = SSticker.maprotatechecked

	switch (current_state)
		if(GAME_STATE_SETTING_UP)
			Master.SetRunLevel(RUNLEVEL_SETUP)
		if(GAME_STATE_PLAYING)
			Master.SetRunLevel(RUNLEVEL_GAME)
		if(GAME_STATE_FINISHED)
			Master.SetRunLevel(RUNLEVEL_POSTGAME)

/datum/controller/subsystem/ticker/proc/send_news_report()
	var/news_message
	var/news_source = "纳米新闻网"
	switch(news_report)
		if(NUKE_SYNDICATE_BASE)
			news_message = "在一次大胆的突袭中，[station_name()]的英勇船员在恐怖分子基地的核心引爆了一枚核装置。"
		if(STATION_DESTROYED_NUKE)
			news_message = "请全体员工放心，有关辛迪加支持对[station_name()]发动核袭击的报道其实是骗局。祝各位平安度过今天！"
		if(STATION_EVACUATED)
			news_message = "在传出尚未证实的敌方活动消息后，[station_name()]的船员已经撤离。"
		if(BLOB_WIN)
			news_message = "[station_name()]遭到未知生物灾害侵袭，全体船员遇难。别让同样的事发生在你身上！请记住，干净的工作环境才是安全的工作环境。"
		if(BLOB_NUKE)
			news_message = "[station_name()]以一次可控的辐射爆发清除了生物黏液，目前正在进行净化。全体员工此前已安全撤离，正享受轻松的假期。"
		if(BLOB_DESTROYED)
			news_message = "[station_name()]在消灭生物危害后，正在进行净化处理。提醒各位船员：出现痉挛或腹胀者，请立即到安保部门报到并接受焚烧处理。"
		if(CULT_ESCAPE)
			news_message = "安全警报：一群宗教狂热分子已从[station_name()]逃脱。"
		if(CULT_FAILURE)
			news_message = "[station_name()]上的非法教派已被瓦解。提醒全体员工：严禁在礼拜堂之外进行宗教崇拜，违者将被终止雇佣。"
		if(CULT_SUMMON)
			news_message = "公司发言人特此澄清：[station_name()]在今年早些时候遭到陨石损坏后，就已被安排退役。此前关于不可名状的恐怖存在的报道有误。"
		if(NUKE_MISS)
			news_message = "辛迪加对[station_name()]的恐怖袭击失败，核武器在附近的空旷太空中引爆。"
		if(OPERATIVES_KILLED)
			news_message = "船员歼灭了一支辛迪加精锐死亡小队后，[station_name()]的维修工作已展开。"
		if(OPERATIVE_SKIRMISH)
			news_message = "[station_name()]上的安保部队与辛迪加特工发生了一场小规模冲突，双方均有伤亡，但仍保持战斗力。"
		if(REVS_WIN)
			news_message = "公司发言人向投资者保证，尽管[station_name()]发生了工会领导的叛乱，工人的工资仍不会提高。"
		if(REVS_LOSE)
			news_message = "[station_name()]迅速镇压了一场误入歧途的叛变。请记住，组织工会是违法行为！"
		if(WIZARD_KILLED)
			news_message = "太空巫师联邦的一名成员在[station_name()]死亡，双方关系因此趋于紧张。"
		if(STATION_NUKED)
			news_message = "[station_name()]因未知原因启动了自毁装置。目前正尝试克隆船长，以便将其逮捕并处决。"
		if(CLOCK_SUMMON)
			news_message = "[station_name()]传出的关于向老鼠致敬的混乱消息及异常能量读数，经查是一名小丑策划的恶作剧。准备虽周全，却十分不明智。"
		if(CLOCK_SILICONS)
			news_message = "[station_name()]使用先进设备升级硅基单位的项目已大体成功，但他们至今拒绝公开设计图，违反了公司政策。"
		if(CLOCK_PROSELYTIZATION)
			news_message = "[station_name()]附近释放的能量爆发已被证实只是新武器试验。不过，一次意外的机械故障导致其通信系统离线。"
		if(SHUTTLE_HIJACK)
			news_message = "在例行撤离过程中，[station_name()]的紧急穿梭机因导航协议受损而偏离航线，但不久后便被找回。"

	if(news_message)
		send2otherserver(news_source, news_message,"News_Report")

/datum/controller/subsystem/ticker/proc/GetTimeLeft()
	if(isnull(SSticker.timeLeft))
		return max(0, start_at - world.time)
	return timeLeft

/datum/controller/subsystem/ticker/proc/SetTimeLeft(newtime)
	if(newtime >= 0 && isnull(timeLeft))	//remember, negative means delayed
		start_at = world.time + newtime
	else
		timeLeft = newtime

//Everyone who wanted to be an observer gets made one now
/datum/controller/subsystem/ticker/proc/create_observers()
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_OBSERVE && player.mind)
			//Break chain since this has a sleep input in it
			addtimer(CALLBACK(player, TYPE_PROC_REF(/mob/dead/new_player, make_me_an_observer)), 1)

/datum/controller/subsystem/ticker/proc/load_mode()
	var/mode = trim(file2text("data/mode.txt"))
	if(mode)
		GLOB.master_mode = mode
	else
		GLOB.master_mode = "extended"
	log_game("Saved mode is '[GLOB.master_mode]'")

/datum/controller/subsystem/ticker/proc/save_mode(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	WRITE_FILE(F, the_mode)

/datum/controller/subsystem/ticker/proc/SetRoundEndSound(the_sound)
	set waitfor = FALSE
	round_end_sound_sent = FALSE
	round_end_sound = fcopy_rsc(the_sound)
	for(var/thing in GLOB.clients)
		var/client/C = thing
		if (!C)
			continue
		C.Export("##action=load_rsc", round_end_sound)
	round_end_sound_sent = TRUE

/datum/controller/subsystem/ticker/proc/Reboot(reason, end_string, delay)
	set waitfor = FALSE
	if(usr && !check_rights(R_SERVER, TRUE))
		return

	if(!delay)
		delay = CONFIG_GET(number/round_end_countdown) * 10

	var/skip_delay = check_rights()
	if(delay_end && !skip_delay)
		to_chat(world, span_boldannounce("游戏管理员推迟了回合结束。"))
		return

	SStriumphs.end_triumph_saving_time()
	to_chat(world, span_boldannounce("世界将在[DisplayTimeText(delay, chinese=TRUE)]后重启。[reason]"))

	var/start_wait = world.time
	UNTIL(round_end_sound_sent || (world.time - start_wait) > (delay * 2))	//don't wait forever
	sleep(delay - (world.time - start_wait))

	if(delay_end && !skip_delay)
		to_chat(world, span_boldannounce("管理员取消了重启。"))
		return
	if(end_string)
		end_state = end_string

	var/statspage = CONFIG_GET(string/roundstatsurl)
	var/gamelogloc = CONFIG_GET(string/gamelogurl)
	if(statspage)
		to_chat(world, span_info("可在<a href=\"[statspage][GLOB.round_id]\">此网站</a>查看回合统计和日志！"))
	else if(gamelogloc)
		to_chat(world, span_info("可在<a href=\"[gamelogloc]\">此网站</a>查看回合日志！"))

	log_game(span_boldannounce("Rebooting World. [reason]"))

	if(end_party)
		to_chat(world, span_boldannounce("结束了！"))
		world.Del()
	else
		world.Reboot()

/datum/controller/subsystem/ticker/Shutdown()
	save_admin_data()
	update_everything_flag_in_db()

	text2file(login_music, "data/last_round_lobby_music.txt")

/// Wrapper for setting rulermob and rulertype
/datum/controller/subsystem/ticker/proc/set_ruler_mob(mob/newruler)
	rulermob = newruler
	var/datum/job/lord_job = SSjob.GetJob("Grand Duke")
	if(should_wear_femme_clothes(rulermob))
		SSticker.rulertype = lord_job?.f_title || lord_job.title
	else
		SSticker.rulertype = lord_job?.display_title || lord_job?.title
	SEND_GLOBAL_SIGNAL(COMSIG_TICKER_RULERMOB_SET, rulermob)

/// Wrapper for sunsteal proc
/datum/controller/subsystem/ticker/proc/sunsteal(mob/living/sunstealer)
	ASSERT(sunstealer)
	RegisterSignal(sunstealer, list(COMSIG_QDELETING, COMSIG_MOB_DEATH), PROC_REF(on_sunstealer_death))
	INVOKE_ASYNC(src, PROC_REF(on_sunsteal)) // Invoke async since on_sunsteal() sleeps in CHECK_TICK

/// Proc called when the sunstealer successfully steals the sun, causing world-wide effects
/datum/controller/subsystem/ticker/proc/on_sunsteal()
	GLOB.todoverride = "night"
	settod()
	priority_announce("太阳被从天空中撕去了！", "可怖的凶兆", 'sound/misc/astratascream.ogg')
	addomen(OMEN_SUNSTEAL)
	SSParticleWeather.run_weather(/datum/particle_weather/fog/blood, TRUE)
	for(var/mob/living/carbon/human/astrater as anything in GLOB.human_list)
		if(!istype(astrater.patron, /datum/patron/divine/astrata))
			continue
		to_chat(astrater, span_userdanger("你感受到了[astrater.patron]的痛苦！"))
		astrater.emote("painscream", intentional = FALSE)

	for(var/turf/open/water/W in world)
		W.water_reagent = /datum/reagent/blood
		W.water_color = "#C80000"
		W.mapped = FALSE
		W.update_icon()
		CHECK_TICK

	for(var/obj/machinery/light/light in GLOB.machines)
		if(prob(40))
			light.extinguish()
		else
			light.flicker(rand(2, 5))
		CHECK_TICK

	for(var/obj/item/flashlight/flare/torch/torch in GLOB.weather_act_upon_list)
		torch.turn_off()
		CHECK_TICK

	for(var/obj/structure/soil/soil in GLOB.soil_list)
		soil.plant_dead = TRUE
		soil.produce_ready = FALSE
		soil.update_icon()
		CHECK_TICK

	for(var/mob/living/carbon/human in GLOB.human_list)
		if(human.clan)
			continue

		human.stress_freakout()

	var/list/spawn_locs = GLOB.hauntstart.Copy()
	if(LAZYLEN(GLOB.hauntstart))
		for(var/i in 1 to 20)
			var/turf/_T = pick_n_take(spawn_locs)
			if(isfloorturf(_T))
				new /mob/living/carbon/human/species/skeleton/npc(_T)

/// Returns universe state to normal after the sunstealer has been slain
/datum/controller/subsystem/ticker/proc/on_sunstealer_death()
	GLOB.todoverride = null
	sunstolen = FALSE
	settod()
	SSParticleWeather.run_weather(/datum/particle_weather/rain_gentle, TRUE)
