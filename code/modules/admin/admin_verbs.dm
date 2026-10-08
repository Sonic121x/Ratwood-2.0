//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
//the procs are cause you can't put the comments in the GLOB var define

GLOBAL_LIST_INIT(admin_verbs_default, world.AVerbsDefault())
GLOBAL_PROTECT(admin_verbs_default)
/world/proc/AVerbsDefault()
	return list(
	/client/proc/check_pq,
	/client/proc/adjust_pq,
	/client/proc/recalc_pq_bulk,
	/client/proc/recalc_pq_single,
	/client/proc/hearallasghost,
	/client/proc/hearglobalLOOC,
	/client/proc/togglespawnmessages,
	/client/proc/toggle_aghost_invis,
	/client/proc/set_admin_ghost_image,
	/client/proc/clear_admin_ghost_image,
	/client/proc/admin_ghost,
	/client/proc/admin_move_oasis,
	/datum/admins/proc/start_vote,
	/datum/admins/proc/show_player_panel,
	/datum/admins/proc/admin_heal,
	/datum/admins/proc/admin_show_inventory,
	/datum/admins/proc/admin_revive,
	/datum/admins/proc/admin_sleep,
	/client/proc/jumptoarea,
	/client/proc/jumptokey,
	/client/proc/mass_direct,
	/client/proc/local_lightsout,
	/datum/admins/proc/checkpq,
	/datum/admins/proc/adjustpq,
	/client/proc/cmd_assume_direct_control,
	/client/proc/jumptomob,
	/client/proc/returntolobby,
	/datum/verbs/menu/Admin/verb/playerpanel,
	/client/proc/check_antagonists,
	/client/proc/admin_force_next_migrant_wave,
	/client/proc/cmd_admin_say,
	/client/proc/deadmin,				/*destroys our own admin datum so we can play as a regular player*/
	/client/proc/set_context_menu_enabled,
	/client/proc/delete_player_book,
	/client/proc/amend_player_book,
	/client/proc/enable_browser_debug,
	/client/proc/pull_book_file_names,
	/client/proc/admin_spread_effect,
	/client/proc/open_bounty_menu,
	/client/proc/remove_bounty,
	/client/proc/agevet_player,
	/client/proc/list_severed_heads,
	// RATWOOD MODULAR START
	/client/proc/bunker_bypass,
	// RATWOOD MODULAR END
	)
GLOBAL_LIST_INIT(admin_verbs_admin, world.AVerbsAdmin())
GLOBAL_PROTECT(admin_verbs_admin)
/world/proc/AVerbsAdmin()
	return list(
	/client/proc/adjusttriumph,
	/client/proc/end_party,
	/client/proc/cmd_admin_say,			/*admin-only ooc chat*/
	/client/proc/toggle_lobby_ooc,
	/client/proc/hide_verbs,			/*hides all our adminverbs*/
	/client/proc/hide_most_verbs,		/*hides all our hideable adminverbs*/
	/client/proc/investigate_show,		/*various admintools for investigation. Such as a singulo grief-log*/
	/client/proc/secrets,				/* Almost entirely non-functional after Azure Peak Debloatening. Final few are redundant, but keeping just in case */
	/client/proc/toggle_hear_radio,		/*allows admins to hide all radio output*/
	/client/proc/reload_admins,
	/client/proc/reload_whitelist,
	/client/proc/reestablish_db_connection, /*reattempt a connection to the database*/
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/cmd_admin_pm_panel,		/*admin-pm list*/
	/client/proc/stop_sounds,
	/client/proc/mark_datum_mapview,

	/client/proc/invisimin,				/*allows our mob to go invisible/visible*/
//	/datum/admins/proc/show_traitor_panel,	/*interface which shows a mob's mind*/ -Removed due to rare practical use. Moved to debug verbs ~Errorage
//	/datum/admins/proc/show_player_panel,	/*shows an interface for individual players, with various links (links require additional flags*/
//	/datum/verbs/menu/Admin/verb/playerpanel,
	/client/proc/game_panel,			/*game panel, allows to change game-mode etc*/
	/datum/admins/proc/toggleooc,		/*toggles ooc on/off for everyone*/
	/datum/admins/proc/toggleoocdead,	/*toggles ooc on/off for everyone who is dead*/
	/datum/admins/proc/toggleenter,		/*toggles whether people can join the current game*/
	/datum/admins/proc/toggleguests,	/*toggles whether guests can join the current game*/
	/datum/admins/proc/announce,		/*priority announce something to all clients.*/
	/datum/admins/proc/set_admin_notice, /*announcement all clients see when joining the server.*/
	/client/proc/toggle_aghost_invis, /* lets us choose whether our in-game mob goes visible when we aghost (off by default) */
	/client/proc/set_admin_ghost_image,
	/client/proc/clear_admin_ghost_image,
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/client/proc/hearallasghost,
	/client/proc/toggle_view_range,		/*changes how far we can see*/
	/client/proc/getserverlogs,		/*for accessing server logs*/
	/client/proc/getcurrentlogs,		/*for accessing server logs for the current round*/
	/client/proc/cmd_admin_subtle_message,	/*send an message to somebody as a 'voice in their head'*/
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_admin_check_contents,	/*displays the contents of an instance*/
	/client/proc/check_antagonists,		/*shows all antags*/
	/client/proc/jumptocoord,			/*we ghost and jump to a coordinate*/
	/client/proc/Getmob,				/*teleports a mob to our location*/
	/client/proc/Getkey,				/*teleports a mob with a certain ckey to our location*/
//	/client/proc/sendmob,				/*sends a mob somewhere*/ -Removed due to it needing two sorting procs to work, which were executed every time an admin right-clicked. ~Errorage
	/client/proc/jumptoarea,
	/client/proc/jumptokey,				/*allows us to jump to the location of a mob with a certain ckey*/
	/client/proc/jumptomob,				/*allows us to jump to a specific mob*/
	/client/proc/jumptoturf,			/*allows us to jump to a specific turf*/
	/client/proc/cmd_admin_direct_narrate,	/*send text directly to a player with no padding. Useful for narratives and fluff-text*/
	/client/proc/cmd_admin_world_narrate,	/*sends text to all players with no padding*/
	/client/proc/cmd_admin_local_narrate,	/*sends text to all mobs within view of atom*/
	/client/proc/cmd_admin_set_ic_date,	/*set/clear the IC calendar date override*/
	/client/proc/cmd_admin_economic_panel,	/*economy inspector: fiscal snapshot, players, blockades, debug ticks*/
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/cmd_admin_check_player_exp, /* shows players by playtime */
	/client/proc/toggle_combo_hud, // toggle display of the combination pizza antag and taco sci/med/eng hud
	/client/proc/toggle_AI_interact, /*toggle admin ability to interact with machines as an AI*/
	/client/proc/toggleprayers,
	/client/proc/toggle_prayer_sound,
	/client/proc/colorasay,
	/client/proc/resetasaycolor,
	/client/proc/toggleadminhelpsound,
	/client/proc/toggledeathalarmsound,
	/client/proc/respawn_character,
	/client/proc/discord_id_manipulation, /* No Discord implementation? */
	/datum/admins/proc/sleep_view,
	/datum/admins/proc/wake_view,
	/datum/admins/proc/extend_round,
	/client/proc/open_fax_panel,
	)
GLOBAL_LIST_INIT(admin_verbs_ban, list(
	/client/proc/unban_panel,
	/client/proc/ban_panel,
	/client/proc/stickybanpanel,
	/client/proc/check_pq,
	/client/proc/adjust_pq,
	/client/proc/getcurrentlogs,
	/client/proc/getserverlogs
	))
GLOBAL_PROTECT(admin_verbs_ban)
GLOBAL_LIST_INIT(admin_verbs_sounds, list(
	/client/proc/play_local_sound,
	/client/proc/play_local_sound_variable,
	/client/proc/play_sound,
	/client/proc/set_round_end_sound,
	/client/proc/play_music_global_url,
	/client/proc/play_music_local_url,
	/client/proc/play_music_direct_url
	))
GLOBAL_PROTECT(admin_verbs_sounds)
GLOBAL_LIST_INIT(admin_verbs_fun, list(
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/set_dynex_scale,
	/client/proc/drop_dynex_bomb,
	/client/proc/cinematic,
//	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/object_say,
	/client/proc/force_say,
	/client/proc/toggle_random_events,
	/client/proc/set_ooc,
	/client/proc/reset_ooc,
	/client/proc/forceEvent,
	/client/proc/forceGamemode,
//	/client/proc/admin_change_sec_level,
//	/client/proc/run_weather,
	/client/proc/run_particle_weather,
	/client/proc/run_custom_particle_weather,
	/client/proc/show_tip,
	/client/proc/smite
	))
GLOBAL_PROTECT(admin_verbs_fun)
GLOBAL_LIST_INIT(admin_verbs_spawn, list(/datum/admins/proc/spawn_atom, /datum/admins/proc/podspawn_atom, /client/proc/respawn_character, /datum/admins/proc/beaker_panel))
GLOBAL_PROTECT(admin_verbs_spawn)
GLOBAL_LIST_INIT(admin_verbs_server, world.AVerbsServer())
GLOBAL_PROTECT(admin_verbs_server)
/world/proc/AVerbsServer()
	return list(
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/end_round,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
//	/client/proc/everyone_random,
//	/datum/admins/proc/toggleAI,
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_debug_del_all,
	/client/proc/cmd_controller_view_ui,
	/client/proc/toggle_random_events,
	/client/proc/adminchangemap,
	/client/proc/panicbunker,
	// /datum/admins/proc/BC_WhitelistKeyVerb,
	// /datum/admins/proc/BC_RemoveKeyVerb,
	/datum/admins/proc/admin_add_donator_verb,
	/datum/admins/proc/admin_remove_donator_verb,
	/client/proc/whitelistbunker,
	/client/proc/toggle_hub
	)
GLOBAL_LIST_INIT(admin_verbs_debug, world.AVerbsDebug())
GLOBAL_PROTECT(admin_verbs_debug)
/world/proc/AVerbsDebug()
	return list(
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify*/
	/client/proc/check_timer_sources,
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/Debug2,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all,
	/client/proc/cmd_controller_view_ui,
	/client/proc/restart_controller,
	/client/proc/enable_debug_verbs,
	/client/proc/callproc,
	/client/proc/callproc_datum,
	/client/proc/SDQL2_query,
	/client/proc/test_movable_UI,
	/client/proc/test_snap_UI,
	/client/proc/check_bomb_impacts,
	/client/proc/debug_influences,
	/client/proc/get_dynex_power,		//*debug verbs for dynex explosions.
	/client/proc/get_dynex_range,		//*debug verbs for dynex explosions.
	/client/proc/set_dynex_scale,
	/client/proc/cmd_display_del_log,
	/client/proc/dump_memory_stats,
	/client/proc/outfit_manager,
	/client/proc/debug_huds,
	/client/proc/map_template_load,
	/client/proc/map_template_upload,
	/client/proc/jump_to_ruin,
	/client/proc/toggle_medal_disable,
	/client/proc/view_runtimes,
	/client/proc/pump_random_event,
	/client/proc/cmd_display_init_log,
	/client/proc/cmd_display_overlay_log,
	/client/proc/reload_configuration,
	/datum/admins/proc/create_or_modify_area,
	/client/proc/returntolobby,
	/client/proc/set_tod_override,
	/client/proc/stresstest_chat,
	/client/proc/performance_stress_test, // Uncomment these if you tick the performance stress test .dm file
	/client/proc/cleanup_stress_test_mobs
	)
GLOBAL_LIST_INIT(admin_verbs_possess, list(/proc/possess, GLOBAL_PROC_REF(release)))
GLOBAL_PROTECT(admin_verbs_possess)
GLOBAL_LIST_INIT(admin_verbs_permissions, list(/client/proc/edit_admin_permissions))
GLOBAL_PROTECT(admin_verbs_permissions)
GLOBAL_LIST_INIT(admin_verbs_poll, list(/client/proc/poll_panel))
GLOBAL_PROTECT(admin_verbs_poll)

//verbs which can be hidden - needs work
GLOBAL_LIST_INIT(admin_verbs_hideable, list(
	/client/proc/set_ooc,
	/client/proc/reset_ooc,
	/client/proc/deadmin,
	/datum/admins/proc/show_traitor_panel,
	/datum/admins/proc/toggleenter,
	/datum/admins/proc/toggleguests,
	/datum/admins/proc/announce,
	/datum/admins/proc/set_admin_notice,
	/client/proc/toggle_aghost_invis,
	/client/proc/admin_ghost,
	/client/proc/toggle_view_range,
	/client/proc/cmd_admin_subtle_message,
//	/client/proc/cmd_admin_headset_message,
	/client/proc/cmd_admin_check_contents,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/cmd_admin_local_narrate,
	/client/proc/play_local_sound,
	/client/proc/play_local_sound_variable,
	/client/proc/play_sound,
	/client/proc/set_round_end_sound,
	/client/proc/play_music_global_url,
	/client/proc/play_music_local_url,
	/client/proc/play_music_direct_url,
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/drop_dynex_bomb,
	/client/proc/get_dynex_range,
	/client/proc/get_dynex_power,
	/client/proc/set_dynex_scale,
	/client/proc/cinematic,
//	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_create_centcom_report,
//	/client/proc/cmd_change_command_name,
	/client/proc/object_say,
	/client/proc/toggle_random_events,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
//	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/client/proc/restart_controller,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/callproc,
	/client/proc/callproc_datum,
	/client/proc/Debug2,
	/client/proc/reload_admins,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_del_all,
	/client/proc/cmd_controller_view_ui,
	/client/proc/enable_debug_verbs,
	/proc/possess,
	/proc/release,
	/client/proc/reload_whitelist,
	/client/proc/panicbunker,
//	/client/proc/admin_change_sec_level,
	/client/proc/cmd_display_del_log,
	/client/proc/toggle_combo_hud,
	/client/proc/debug_huds
	))
GLOBAL_PROTECT(admin_verbs_hideable)

/client/proc/add_admin_verbs()
	if(holder)
		control_freak = CONTROL_FREAK_SKIN | CONTROL_FREAK_MACROS

		var/rights = holder.rank.rights
		verbs += GLOB.admin_verbs_default
		if(rights & R_BUILD)
			verbs += /client/proc/togglebuildmodeself
		if(rights & R_ADMIN)
			verbs += GLOB.admin_verbs_admin
		if(rights & R_BAN)
			verbs += GLOB.admin_verbs_ban
		if(rights & R_FUN)
			verbs += GLOB.admin_verbs_fun
		if(rights & R_SERVER)
			verbs += GLOB.admin_verbs_server
		if(rights & R_DEBUG)
			verbs += GLOB.admin_verbs_debug
		if(rights & R_POSSESS)
			verbs += GLOB.admin_verbs_possess
		if(rights & R_PERMISSIONS)
			verbs += GLOB.admin_verbs_permissions
		if(rights & R_STEALTH)
			verbs += /client/proc/stealth
		if(rights & R_ADMIN)
			verbs += GLOB.admin_verbs_poll
		if(rights & R_SOUND)
			verbs += GLOB.admin_verbs_sounds
			if(CONFIG_GET(string/invoke_youtubedl))
				verbs += /client/proc/play_web_sound
		if(rights & R_SPAWN)
			verbs += GLOB.admin_verbs_spawn

/client/proc/remove_admin_verbs()
	verbs.Remove(
		GLOB.admin_verbs_default,
		/client/proc/togglebuildmodeself,
		GLOB.admin_verbs_admin,
		GLOB.admin_verbs_ban,
		GLOB.admin_verbs_fun,
		GLOB.admin_verbs_server,
		GLOB.admin_verbs_debug,
		GLOB.admin_verbs_possess,
		GLOB.admin_verbs_permissions,
		/client/proc/stealth,
		GLOB.admin_verbs_poll,
		GLOB.admin_verbs_sounds,
		/client/proc/play_web_sound,
		GLOB.admin_verbs_spawn,
		/*Debug verbs added by "show debug verbs"*/
		GLOB.admin_verbs_debug_mapping,
		/client/proc/disable_debug_verbs,
		/client/proc/readmin
		)

/client/proc/hide_most_verbs()//Allows you to keep some functionality while hiding some verbs
	set name = "管理指令 - 隐藏大部分"
	set category = "偏好设置 - 管理"

	verbs.Remove(/client/proc/hide_most_verbs, GLOB.admin_verbs_hideable)
	verbs += /client/proc/show_verbs

	to_chat(src, span_interface("已隐藏大部分管理指令。"))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Hide Most Adminverbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/hide_verbs()
	set name = "管理指令 - 全部隐藏"
	set category = "偏好设置 - 管理"

	remove_admin_verbs()
	verbs += /client/proc/show_verbs

	to_chat(src, span_interface("已隐藏几乎所有管理指令。"))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Hide All Adminverbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/show_verbs()
	set name = "管理指令 - 显示"
	set category = "偏好设置 - 管理"

	verbs -= /client/proc/show_verbs
	add_admin_verbs()

	to_chat(src, span_interface("现在可以看到所有管理指令。"))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Adminverbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/set_context_menu_enabled()
	set category = "偏好设置 - 管理"
	set name = "切换右键菜单"
	if(!holder)
		return
	show_popup_menus = !show_popup_menus
	to_chat(src, show_popup_menus ? "已启用右键菜单" : "已禁用右键菜单")

/client/proc/open_bounty_menu()
	set category = "-管理-"
	set name = "查看悬赏列表"
	if(!holder)
		return
	var/bounty_found = FALSE
	var/consult_menu
	consult_menu += "<center>悬赏<BR>"
	consult_menu += "--------------<BR>"
	for(var/datum/bounty/saved_bounty in GLOB.head_bounties)
		consult_menu += saved_bounty.banner
		bounty_found = TRUE
	if(bounty_found)
		var/datum/browser/popup = new(mob, "BOUNTIES", "", 500, 300)
		popup.set_content(consult_menu)
		popup.open()
	else
		to_chat(mob, "当前没有生效的悬赏。")

/client/proc/toggle_aghost_invis()
	set category = "偏好设置 - 管理"
	set name = "管理员幽灵化（切换隐身）"
	if (!holder)
		return
	aghost_toggle = !aghost_toggle
	to_chat(src, aghost_toggle ? "管理员幽灵化时会将你的身体隐形。" : "管理员幽灵化时不再将你的身体隐形。")

/client/proc/set_admin_ghost_image()
	set category = "-管理-"
	set name = "设置幽灵图像"
	if(!holder || !prefs)
		return
	var/uploaded_file = input(src, "选择一张 32x32 的图片或 GIF，作为你的管理员幽灵图像。", "设置幽灵图像") as null|file
	if(!uploaded_file)
		return
	var/icon/new_icon = new(uploaded_file)
	if(new_icon.Width() != 32 || new_icon.Height() != 32)
		new_icon.Scale(32, 32)
	prefs.admin_ghost_icon = new_icon
	prefs.save_preferences()
	apply_admin_ghost_image()
	to_chat(src, span_notice("已保存管理员幽灵图像。"))

/client/proc/clear_admin_ghost_image()
	set category = "-管理-"
	set name = "清除幽灵图像"
	if(!holder || !prefs)
		return
	prefs.admin_ghost_icon = null
	prefs.save_preferences()
	apply_admin_ghost_image()
	to_chat(src, span_notice("已清除管理员幽灵图像。"))

/client/proc/apply_admin_ghost_image()
	var/mob/dead/observer/admin_ghost = mob
	if(!istype(admin_ghost))
		return
	admin_ghost.apply_admin_ghost_image()

/client/proc/admin_ghost()
	set category = "-管理-"
	set name = "管理员幽灵化"
	if(!holder)
		return
	. = TRUE
	if(isobserver(mob))
		//re-enter
		var/mob/dead/observer/ghost = mob
		if(!ghost.mind || !ghost.mind.current) //won't do anything if there is no body
			return FALSE
		if(!ghost.can_reenter_corpse)
			log_admin("[key_name(usr)] re-entered corpse")
			message_admins("[key_name_admin(usr)] 重新进入了尸体")
		if(istype(ghost.mind.current, /mob/living))
			var/mob/living/M = ghost.mind.current
			var/datum/status_effect/incapacitating/sleeping/S = M.IsSleeping()
			if(S && !M.IsKnockdown() && !M.IsStun() && !M.IsParalyzed()) // Wake them up unless they're asleep for another reason
				M.remove_status_effect(S)
				M.set_resting(FALSE, TRUE)
			M.density = initial(M.density)
			M.invisibility = initial(M.invisibility)
		else
			var/mob/M = ghost.mind.current
			M.invisibility = initial(M.invisibility)
			M.density = initial(M.density)
		ghost.can_reenter_corpse = 1 //force re-entering even when otherwise not possible
		ghost.reenter_corpse()
		show_popup_menus = FALSE
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Admin Reenter") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else if(isnewplayer(mob))
//		to_chat(src, "<font color='red'>Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.</font>")
//		return FALSE
		var/mob/dead/new_player/NP = mob
		NP.make_me_an_observer()
	else
		//ghostize
		log_admin("[key_name(usr)] admin ghosted.")
		message_admins("[key_name_admin(usr)] 使用了管理员幽灵化。")
		var/mob/body = mob
		if (aghost_toggle)
			body.invisibility = INVISIBILITY_MAXIMUM
			body.density = 0
		body.ghostize(TRUE, admin = TRUE)
		if(body && !body.key)
			body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		show_popup_menus = TRUE
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Admin Ghost") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/invisimin()
	set name = "管理员隐身"
	set category = "偏好设置 - 管理"
	set desc = ""
	if(holder && mob)
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.invisibility = initial(mob.invisibility)
			to_chat(mob, span_boldannounce("已关闭管理员隐身，隐形状态已重置。"))
		else
			mob.invisibility = INVISIBILITY_OBSERVER
			to_chat(mob, span_adminnotice("<b>已开启管理员隐身，你现在如幽灵般不可见。</b>"))

/client/proc/check_antagonists()
	set name = "查看反派"
	set category = "-GameMaster-"
	if(holder)
		holder.check_antagonists()
		log_admin("[key_name(usr)] checked antagonists.")	//for tsar~
		if(!isobserver(usr) && SSticker.HasRoundStarted())
			message_admins("[key_name_admin(usr)] 查看了反派。")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Check Antagonists") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/set_tod_override()
	set category = "调试"
	set name = "设置强制时段"
	var/list/TODs = list("黎明" = "dawn", "白昼" = "day", "黄昏" = "dusk", "夜晚" = "night")
	var/choice = TODs[input(src,"","设置强制时段") as null|anything in TODs]
	if(choice)
		GLOB.todoverride = choice
		world << "[ckey]已将时段强制设为[list("day" = "白昼", "night" = "夜晚", "dawn" = "黎明", "dusk" = "黄昏")[choice] || choice]。"
	else
		GLOB.todoverride = null
		world << "[ckey]已关闭强制时段设置。"
	settod()

/client/proc/stresstest_chat()
	set name = "聊天压力测试"
	set category = "调试"
	set hidden = TRUE

	if(!holder)
		return

	var/who = usr
	var/languages = list(
		"human",
		"dwarf",
		"elf",
		"sandspeak",
		"delf",
		"beast",
		"orc",
		//"undead",
		"hellspeak",
		"reptile",
		"lupian",
		//"cat"

	)

	for(var/i = 1; i <= 100; i++)
		for(var/lang in languages)
			to_chat(who, "<span class='say'><span class='name'><span style='color:#ff6600;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'>Jorrel</span></span> <span class='message'>说道：\"<span class=' [lang] '>我正在说 [lang]。</span>\"</span></span>")


/client/proc/ban_panel()
	set name = "封禁面板"
	set category = "-管理-"
	if(!check_rights(R_BAN))
		return
	holder.ban_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Banning Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/unban_panel()
	set name = "解封面板"
	set category = "-管理-"
	if(!check_rights(R_BAN))
		return
	holder.unban_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Unbanning Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/game_panel()
	set name = "游戏面板"
	set category = "-管理-"
	if(holder)
		holder.Game()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Game Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/secrets()
	set name = "秘密功能"
	set category = "-管理-"
	set hidden = 1
	if (holder)
		holder.Secrets()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Secrets Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/poll_panel()
	set name = "服务器投票管理"
	set category = "-服务器-"
	if(!check_rights(R_POLL))
		return
	holder.poll_list_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Server Poll Management") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/findStealthKey(txt)
	if(txt)
		for(var/P in GLOB.stealthminID)
			if(GLOB.stealthminID[P] == txt)
				return P
	txt = GLOB.stealthminID[ckey]
	return txt

/client/proc/createStealthKey()
	var/num = (rand(0,1000))
	var/i = 0
	while(i == 0)
		i = 1
		for(var/P in GLOB.stealthminID)
			if(num == GLOB.stealthminID[P])
				num++
				i = 0
	GLOB.stealthminID["[ckey]"] = "@[num2text(num)]"

/client/proc/stealth()
	set category = "偏好设置 - 管理"
	set name = "潜行模式"
	if(holder)
		if(holder.fakekey)
			holder.fakekey = null
			if(isobserver(mob))
				mob.invisibility = initial(mob.invisibility)
				mob.alpha = initial(mob.alpha)
				mob.name = initial(mob.name)
				mob.mouse_opacity = initial(mob.mouse_opacity)
		else
			var/new_key = ckeyEx(input("输入你想使用的显示名称。", "账号化名", key) as text|null)
			if(!new_key)
				return
			if(length(new_key) >= 26)
				new_key = copytext(new_key, 1, 26)
			holder.fakekey = new_key
			createStealthKey()
			if(isobserver(mob))
				mob.invisibility = INVISIBILITY_MAXIMUM //JUST IN CASE
				mob.alpha = 0 //JUUUUST IN CASE
				mob.name = " "
				mob.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		log_admin("[key_name(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
		message_admins("[key_name_admin(usr)] 已[holder.fakekey ? "开启" : "关闭"]潜行模式")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Stealth Mode") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/drop_bomb()
	set category = "-GameMaster-"
	set name = "爆炸..."
	set desc = ""

	var/list/choices = list("小型爆炸 (1, 2, 3, 3)", "中型爆炸 (2, 3, 4, 4)", "大型爆炸 (3, 5, 7, 5)", "爆炸上限", "自定义爆炸")
	var/choice = input("你想制造多大规模的爆炸？注意：使用配置／发射补给舱指令，可通过巡航导弹快速以角色内方式完成这些操作！警告：这些爆炸会忽略爆炸上限。") as null|anything in choices
	var/turf/epicenter = mob.loc

	switch(choice)
		if(null)
			return 0
		if("小型爆炸 (1, 2, 3, 3)")
			explosion(epicenter, 1, 2, 3, 3, TRUE, TRUE)
		if("中型爆炸 (2, 3, 4, 4)")
			explosion(epicenter, 2, 3, 4, 4, TRUE, TRUE)
		if("大型爆炸 (3, 5, 7, 5)")
			explosion(epicenter, 3, 5, 7, 5, TRUE, TRUE)
		if("爆炸上限")
			explosion(epicenter, GLOB.MAX_EX_DEVESTATION_RANGE, GLOB.MAX_EX_HEAVY_RANGE, GLOB.MAX_EX_LIGHT_RANGE, GLOB.MAX_EX_FLASH_RANGE)
		if("自定义爆炸")
			var/devastation_range = input("毁灭范围（格）：") as null|num
			if(devastation_range == null)
				return
			var/heavy_impact_range = input("重度冲击范围（格）：") as null|num
			if(heavy_impact_range == null)
				return
			var/light_impact_range = input("轻度冲击范围（格）：") as null|num
			if(light_impact_range == null)
				return
			var/flash_range = input("闪光范围（格）：") as null|num
			if(flash_range == null)
				return
			if(devastation_range > GLOB.MAX_EX_DEVESTATION_RANGE || heavy_impact_range > GLOB.MAX_EX_HEAVY_RANGE || light_impact_range > GLOB.MAX_EX_LIGHT_RANGE || flash_range > GLOB.MAX_EX_FLASH_RANGE)
				if(alert("爆炸规模超过上限。继续吗？",,"是","否") != "是")
					return
			epicenter = mob.loc //We need to reupdate as they may have moved again
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, TRUE, TRUE)
	message_admins("[ADMIN_LOOKUPFLW(usr)] 在 [epicenter.loc] 制造了管理员爆炸。")
	log_admin("[key_name(usr)] created an admin explosion at [epicenter.loc].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Drop Bomb") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/drop_dynex_bomb()
	set category = "-GameMaster-"
	set name = "爆炸 - 动态爆炸..."
	set desc = ""

	var/ex_power = input("爆炸威力：") as null|num
	var/turf/epicenter = mob.loc
	if(ex_power && epicenter)
		dyn_explosion(epicenter, ex_power)
		message_admins("[ADMIN_LOOKUPFLW(usr)] 在 [epicenter.loc] 制造了管理员爆炸。")
		log_admin("[key_name(usr)] created an admin explosion at [epicenter.loc].")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Drop Dynamic Bomb") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/get_dynex_range()
	set category = "调试"
	set name = "计算动态爆炸范围"
	set desc = ""

	var/ex_power = input("爆炸威力：") as null|num
	if (isnull(ex_power))
		return
	var/range = round((2 * ex_power)**GLOB.DYN_EX_SCALE)
	to_chat(usr, "预计爆炸范围：（毁灭：[round(range*0.25)]，重度：[round(range*0.5)]，轻度：[round(range)]）")

/client/proc/get_dynex_power()
	set category = "调试"
	set name = "计算动态爆炸威力"
	set desc = ""

	var/ex_range = input("轻度爆炸范围：") as null|num
	if (isnull(ex_range))
		return
	var/power = (0.5 * ex_range)**(1/GLOB.DYN_EX_SCALE)
	to_chat(usr, "预计爆炸威力：[power]")

/client/proc/set_dynex_scale()
	set category = "调试"
	set name = "设置动态爆炸系数"
	set desc = ""

	var/ex_scale = input("新的动态爆炸系数：") as null|num
	if(!ex_scale)
		return
	GLOB.DYN_EX_SCALE = ex_scale
	log_admin("[key_name(usr)] has modified Dynamic Explosion Scale: [ex_scale]")
	message_admins("[key_name_admin(usr)] 将动态爆炸系数改为：[ex_scale]")

/client/proc/give_spell(mob/T in GLOB.mob_list)
	set category = "-GameMaster-"
	set name = "授予法术"
	set desc = ""

	var/list/spell_list = list()
	var/type_length = length("/obj/effect/proc_holder/spell") + 2
	for(var/A in GLOB.spells)
		spell_list[copytext("[A]", type_length)] = A
	var/obj/effect/proc_holder/spell/S = input("选择要授予目标的法术", "授予法术") as null|anything in sortList(spell_list)
	if(!S)
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Give Spell") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(T)] the spell [S].")
	message_admins(span_adminnotice("[key_name_admin(usr)] 授予了 [key_name_admin(T)] 法术 [S]。"))

	S = spell_list[S]
	if(T.mind)
		T.mind.AddSpell(new S)
	else
		T.AddSpell(new S)
		message_admins(span_danger("授予无心智生物的法术不会随心智交换或克隆转移！"))

/client/proc/remove_spell(mob/T in GLOB.mob_list)
	set category = "-GameMaster-"
	set name = "移除法术"
	set desc = ""

	if(T && T.mind)
		var/obj/effect/proc_holder/spell/S = input("选择要移除的法术", "移除法术") as null|anything in sortList(T.mind.spell_list)
		if(S)
			T.mind.RemoveSpell(S)
			log_admin("[key_name(usr)] removed the spell [S] from [key_name(T)].")
			message_admins(span_adminnotice("[key_name_admin(usr)] 移除了 [key_name_admin(T)] 的法术 [S]。"))
			SSblackbox.record_feedback("tally", "admin_verb", 1, "Remove Spell") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/object_say(obj/O in world)
	set category = "-特殊指令-"
	set name = "物体发言"
	set desc = ""
	var/message = input(usr, "你想让物体说什么？", "物体发声") as text | null
	if(!message)
		return
	O.say(message)
	log_admin("[key_name(usr)] made [O] at [AREACOORD(O)] say \"[message]\"")
	message_admins(span_adminnotice("[key_name_admin(usr)] 让 [AREACOORD(O)] 的 [O] 说：\"[message]\""))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Object Say") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/force_say(mob/living/L in GLOB.mob_list)
	set category = "-特殊指令-"
	set name = "强制发言"
	set desc = ""

	if(!L)
		to_chat(usr, span_warning("未选择生物。"))
		return

	if(!isliving(L))
		to_chat(usr, span_warning("目标必须是生物。"))
		return

	if(!L.loc)
		to_chat(usr, span_warning("目标生物没有所在位置。"))
		return

	var/message = input(usr, "你想让目标说什么？", "强制发言") as text | null
	if(!message)
		return

	L.say(message, forced = "admin speech")
	log_admin("[key_name(usr)] forced [key_name(L)] at [AREACOORD(L)] to say \"[message]\"")
	message_admins(span_adminnotice("[key_name_admin(usr)] 强迫 [AREACOORD(L)] 的 [key_name_admin(L)] 说：\"[message]\""))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Force Say") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/togglebuildmodeself()
	set name = "切换建造模式"
	set category = "-特殊指令-"
	if (!holder || !(holder.rank.rights & R_BUILD))
		return
	if(src.mob)
		togglebuildmode(src.mob)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Build Mode") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/deadmin()
	set name = "暂卸管理权限"
	set category = "偏好设置 - 管理"
	set desc = ""

	if(!holder)
		return

	if(has_antag_hud())
		toggle_combo_hud()

	holder.deactivate()

	to_chat(src, span_interface("你现在是普通玩家。"))
	update_ooc_verb_visibility()
	log_admin("[src] deadmined themself.")
	message_admins("[src] 暂时卸下了管理权限。")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Deadmin")

/client/proc/readmin()
	set name = "恢复管理权限"
	set category = "-管理-"
	set desc = ""

	var/datum/admins/A = GLOB.deadmins[ckey]

	if(!A)
		A = GLOB.admin_datums[ckey]
		if (!A)
			var/msg = " 尝试恢复管理权限，但没有对应的暂卸权限记录"
			message_admins("[key_name_admin(src)][msg]")
			log_admin_private("[key_name(src)][msg]")
			return

	A.associate(src)

	if (!holder)
		return //This can happen if an admin attempts to vv themself into somebody elses's deadmin datum by getting ref via brute force

	to_chat(src, span_interface("你现在是管理员。"))
	message_admins("[src] 恢复了管理权限。")
	log_admin("[src] re-adminned themselves.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Readmin")
	update_ooc_verb_visibility()

/client/proc/toggle_AI_interact()
	set name = "切换管理员AI交互"
	set category = "-管理-"
	set desc = ""
	set hidden = 1

	AI_Interact = !AI_Interact
	if(mob && IsAdminGhost(mob))
		mob.has_unlimited_silicon_privilege = AI_Interact

	log_admin("[key_name(usr)] has [AI_Interact ? "activated" : "deactivated"] Admin AI Interact")
	message_admins("[key_name_admin(usr)] 已[AI_Interact ? "启用" : "禁用"]AI交互")

/client/proc/toggle_lobby_ooc()
	set name = "显示或隐藏大厅场外聊天"
	set category = "偏好设置 - 管理"
	set desc = "切换离开大厅后是否仍显示大厅场外聊天消息。"
	if(!holder)
		return
	show_lobby_ooc = !show_lobby_ooc
	to_chat(src, span_interface("大厅场外聊天现已[show_lobby_ooc ? "显示" : "隐藏"]。"))

/client/proc/end_party()
	set category = "-GameMaster-"
	set name = "结束试玩"
	set hidden = 1
	if(!holder)
		return
	if(!SSticker.end_party)
		SSticker.end_party=TRUE
		to_chat(src, span_interface("已允许结束回合。"))
	else
		SSticker.end_party=FALSE
		to_chat(src, span_interface("已禁止结束回合。"))

/client/proc/delete_player_book()
	set name = "数据库 - 删除玩家书籍"
	set category = "调试"
	set desc = ""
	if(!holder)
		return
	var/player_book = input(src, "要删除哪个书籍文件？（文件名中的空格和其他字符需使用 URL 编码，例如空格写作 +）")
	if(player_book)
		SSlibrarian.del_player_book(player_book)
		message_admins("[src] 删除了玩家书籍：[player_book]")
	else
		to_chat(src, span_notice("书籍文件不存在，或输入有误（可使用“数据库 - 书籍文件名”指令查询文件名）"))

/client/proc/pull_book_file_names()
	set name = "数据库 - 书籍文件名"
	set category = "调试"
	set desc = ""
	if(!holder)
		return
	var/list/book_titles = SSlibrarian.pull_player_book_titles()
	if(!book_titles)
		return
	var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>"
	for(var/I in book_titles)
		dat += "[I]<br>"
	src << browse(dat, "window=reading;size=250x500;can_close=1;can_minimize=1;can_maximize=1;can_resize=1;titlebar=1")

/client/proc/amend_player_book()
	set name = "数据库 - 修改玩家书籍"
	set category = "调试"
	set desc = ""
	if(!holder)
		return
	var/book_title = input(src, "书籍文件名是什么？")
	var/amend_type = alert(src, "要修改哪个字段？book_title 为书名，author 为作者，icon 为图标。", "", "book_title", "author", "icon")
	var/amend_text = input(src, "要改成什么内容？（无需使用文件名格式，空格可正常输入）")
	if(SSlibrarian.amend_player_book(book_title, amend_type, amend_text))
		message_admins("[src] 将 [book_title] 的 [amend_type] 改为 [amend_text]")
	else
		to_chat(src, span_notice("书籍文件不存在，或输入有误（可使用“数据库 - 书籍文件名”指令查询文件名）"))

/client/proc/remove_bounty()
	set category = "-管理-"
	set name = "移除悬赏"
	if(!holder)
		return
	var/list/bounty_list = list()

	for(var/datum/bounty/removable_bounties in GLOB.head_bounties)
		bounty_list += removable_bounties.target

	if(!bounty_list.len)
		to_chat(src, "没有可移除的生效悬赏。")
		return

	var/target_name = input(src, "要从通缉名单中划去谁的名字？", src) as null|anything in bounty_list
	if(!target_name)
		return

	to_chat(src,"正在从悬赏列表中移除 [target_name]...")

	for(var/datum/bounty/removing_bounty in GLOB.head_bounties)
		if(removing_bounty.target == target_name)
			GLOB.head_bounties -= removing_bounty
			scom_announce("一股未知的力量抹去了对[target_name]的悬赏。诸神对此感到不悦。")
			message_admins("[ADMIN_LOOKUPFLW(src)] 移除了对 [ADMIN_LOOKUPFLW(target_name)] 的悬赏")
			return
	to_chat(src, "错误：该悬赏已失效。")

/client/proc/enable_browser_debug()
	set category = "调试"
	set name = "启用浏览器调试"
	if(!holder)
		return

	to_chat(src, "已启用浏览器工具。")
	winset(src, null, "browser-options=devtools,find,byondstorage")

