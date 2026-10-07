//Dead mobs can exist whenever. This is needful

INITIALIZE_IMMEDIATE(/mob/dead)

/mob/dead
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	move_resist = INFINITY
	throwforce = 0

/mob/dead/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1
	tag = "mob_[next_mob_id++]"
	GLOB.mob_list += src

	prepare_huds()

	if(length(CONFIG_GET(keyed_list/cross_server)))
		verbs += /mob/dead/proc/server_hop
	set_focus(src)
	return INITIALIZE_HINT_NORMAL

/mob/dead/Destroy()
	GLOB.mob_list -= src
	return ..()

/mob/dead/canUseStorage()
	return FALSE

/mob/dead/dust(just_ash, drop_items, force)	//ghosts can't be vaporised.
	return

/mob/dead/gib()		//ghosts can't be gibbed.
	return

/mob/dead/ConveyorMove()	//lol
	return

/mob/dead/forceMove(atom/destination)
	var/turf/old_turf = get_turf(src)
	var/turf/new_turf = get_turf(destination)
	if (old_turf?.z != new_turf?.z)
		onTransitZ(old_turf?.z, new_turf?.z)
	var/oldloc = loc
	loc = destination
	Moved(oldloc, NONE, TRUE)

/mob/dead/new_player/proc/lobby_refresh(actor_list)
	set waitfor = 0
	if(!client)
		return

	if(client.is_new_player())
		return

	var/time_remaining = SSticker.GetTimeLeft()
	if(SSticker.HasRoundStarted() || time_remaining <= 0)
		client << browse(null, "window=lobby_window")
		return
	if(!winexists(client, "lobby_window"))
		open_lobby()  // creates window + browser control
		sleep(0)
		if(!client) // client vanished while we slept
			return
	var/lobby_visible = winget(client, "lobby_window", "is-visible")
	if(lobby_visible == "false") // winget returns a string...
		client << browse(null, "window=lobby_window")
		open_lobby()
		sleep(0)
		if(!client) // client vanished while we slept
			return

	// UPDATE TIMER -- Script in html\lobby\lobby.html / .js
	var/timer_text
	if (time_remaining > 0)
		timer_text = "距离开局：[round(time_remaining/10)]秒"
	else if (time_remaining == -10)
		timer_text = "距离开局：已延迟"
	else
		timer_text = "距离开局：即将开始"
		client << browse(null, "window=lobby_window")
		return
	client << output(timer_text, "lobby_window.browser:update_timer")

	// Update players ready!!
	client << output(
	"已准备玩家总数：[SSticker.totalPlayersReady]",
	"lobby_window.browser:update_ready_count"
	)
	// Ready bonus
	var/bonus_html
	if (src.ready)
		bonus_html = span_good("已获得准备奖励！")
	else
		bonus_html = span_highlight("尚无奖励！请准备！")
	client << output(bonus_html, "lobby_window.browser:update_ready_bonus")
	client << output(actor_list, "lobby_window.browser:update_jobs")

/mob/dead/new_player/proc/open_lobby()
	if (!client)
		return
	client << browse(
		file("html/lobby/lobby.html"),
		"window=lobby_window;size=330x430"
	)
/mob/dead/proc/server_hop()
	set category = "OOC"
	set name = "切换服务器！"
	set desc= "前往其他服务器"
	set hidden = 1
	if(notransform)
		return
	var/list/csa = CONFIG_GET(keyed_list/cross_server)
	var/pick
	switch(csa.len)
		if(0)
			verbs -= /mob/dead/proc/server_hop
			to_chat(src, span_notice("服务器跳转已停用。"))
		if(1)
			pick = csa[1]
		else
			pick = input(src, "选择要前往的服务器", "服务器跳转") as null|anything in csa

	if(!pick)
		return

	var/addr = csa[pick]

	if(alert(src, "前往服务器[pick]（[addr]）？", "服务器跳转", "是", "否") != "是")
		return

	var/client/C = client
	to_chat(C, span_notice("正在将你送往[pick]。"))
	new /atom/movable/screen/splash(C)

	notransform = TRUE
	sleep(29)	//let the animation play
	notransform = FALSE

	if(!C)
		return

	winset(src, null, "command=.options") //other wise the user never knows if byond is downloading resources

	C << link("[addr]?server_hop=[key]")

/mob/dead/proc/update_z(new_z) // 1+ to register, null to unregister
	if (registered_z != new_z)
		if (registered_z)
			SSmobs.dead_players_by_zlevel[registered_z] -= src
		if (client)
			if (new_z)
				SSmobs.dead_players_by_zlevel[new_z] += src
			registered_z = new_z
		else
			registered_z = null

/mob/dead/Login()
	. = ..()
	var/turf/T = get_turf(src)
	if (isturf(T))
		update_z(T.z)

/mob/dead/auto_deadmin_on_login()
	return

/mob/dead/Logout()
	update_z(null)
	return ..()

/mob/dead/onTransitZ(old_z,new_z)
	..()
	update_z(new_z)
