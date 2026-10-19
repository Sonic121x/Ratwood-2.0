/mob/dead/new_player/Login()
	if(CONFIG_GET(flag/use_exp_tracking))
		client.set_exp_from_db()
		client.set_db_player_flags()
	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	..()

	if(client)
		client.update_ooc_verb_visibility()

	sight |= SEE_TURFS

	addtimer(CALLBACK(src, PROC_REF(do_after_login)), 4 SECONDS)
	new_player_panel()

	if(client)
		client.playtitlemusic()

/mob/dead/new_player/proc/do_after_login()
	PRIVATE_PROC(TRUE)
	if(!client)
		return

	var/motd = global.config.motd
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>", handle_whitespace=FALSE)

	if(GLOB.rogue_round_id)
		to_chat(src, span_info("回合编号：[GLOB.rogue_round_id]"))

	if(client.is_new_player())
		to_chat(src, span_userdanger("由于有大批哥布林试图涌入ROGUETOWN，你需要绑定Discord账户，或在Patreon上赞助我们，才能加入。"))
		to_chat(src, span_info("我们也不喜欢Discord，但这是必要的。要绑定Discord或Patreon，请点击窗口右上角的“Register”（注册）标签，再选择其中一个选项。"))
	else
		var/shown_patreon_level = client.patreonlevel()
		if(!shown_patreon_level)
			shown_patreon_level = "<font color='#617C46'><b>谷地居民</b></font>"
		switch(shown_patreon_level)
			if(1)
				shown_patreon_level = "白银"
			if(2)
				shown_patreon_level = "黄金"
			if(3)
				shown_patreon_level = "秘银"
			if(4)
				shown_patreon_level = "商人"
			if(5)
				shown_patreon_level = "领主"
		to_chat(src, span_info("赞助等级：[shown_patreon_level]"))
	client.changelog()

	var/primary_server = "byond://103.40.13.27:25388"
	var/secondary_server = "byond://222.187.254.125:25388"
	var/link_style = "color:#638500;text-decoration:underline;"

	if(world.port == 22096)
		to_chat(src, "<span style='color:#638500;'>副服务器：[secondary_server] <a href='?src=[REF(src)];join_server=secondary' style='[link_style]'><b>（加入）</b></a></span>")
	else if(world.port == 22099)
		to_chat(src, "<span style='color:#638500;'>主服务器：[primary_server] <a href='?src=[REF(src)];join_server=primary' style='[link_style]'><b>（加入）</b></a></span>")
	else
		to_chat(src, "<span style='color:#638500;'>主服务器：[primary_server] <a href='?src=[REF(src)];join_server=primary' style='[link_style]'><b>（加入）</b></a></span>")
		to_chat(src, "<span style='color:#638500;'>副服务器：[secondary_server] <a href='?src=[REF(src)];join_server=secondary' style='[link_style]'><b>（加入）</b></a></span>")

	to_chat(src, "<a href='?src=[REF(src)];open_changelog=1' style='color:#638500;text-decoration:underline;'><b>查看更新日志</b></a>")

	if(GLOB.admin_notice)
		to_chat(src, span_notice("<b>管理员公告：</b>\n \t [GLOB.admin_notice]"))

	var/spc = CONFIG_GET(number/soft_popcap)
	if(spc && living_player_count() >= spc)
		to_chat(src, span_notice("<b>服务器公告：</b>\n \t [CONFIG_GET(string/soft_popcap_message)]"))

	if(SSticker.current_state < GAME_STATE_SETTING_UP)
		var/tl = SSticker.GetTimeLeft()
		var/postfix
		if(tl > 0)
			postfix = "将在约[DisplayTimeText(tl)]后"
		else
			postfix = "即将"
		to_chat(src, "游戏[postfix]开始。")

		SSvote.on_client_login(client)
		var/usedkey = ckey(key)
		var/list/thinz = list("坐了下来。", "安顿了下来。", "加入了本局游戏。", "坐到了桌边。", "成为了玩家。")
		SEND_TEXT(world, span_notice("[usedkey] [pick(thinz)]"))
