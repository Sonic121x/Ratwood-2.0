//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki(query as text)
	set name = "维基"
	set desc = ""
	set category = "OOC"
	set hidden = 1
	var/wikiurl = CONFIG_GET(string/wikiurl)
	if(wikiurl)
		if(query)
			var/output = wikiurl + "/index.php?title=Special%3ASearch&profile=default&search=" + query
			src << link(output)
		else if (query != null)
			src << link(wikiurl)
	else
		to_chat(src, span_danger("服务器配置中尚未设置维基网址。"))
	return

/client/verb/discord()
	set name = "discord"
	set desc = ""
	set category = "OOC"
	set hidden = 1
	var/discordurl = CONFIG_GET(string/discordurl)
	if(discordurl)
		if(alert("即将打开 Discord。你确定吗？",,"是","否")!="是")
			return
		src << link(discordurl)
	else
		to_chat(src, span_danger("服务器配置中尚未设置论坛网址。"))
	return

/client/verb/rules()
	set name = "规则"
	set desc = ""
	set category = "OOC"
	set hidden = 1
	var/rulesurl = CONFIG_GET(string/rulesurl)
	if(rulesurl)
		if(alert("即将在浏览器中打开规则。你确定吗？",,"是","否")!="是")
			return
		src << link(rulesurl)
	else
		to_chat(src, span_danger("服务器配置中尚未设置规则网址。"))
	return

/client/verb/github()
	set name = "github"
	set desc = ""
	set category = "OOC"
	set hidden = 1
	var/githuburl = CONFIG_GET(string/githuburl)
	if(githuburl)
		if(alert("即将在浏览器中打开 GitHub 仓库。你确定吗？",,"是","否")!="是")
			return
		src << link(githuburl)
	else
		to_chat(src, span_danger("服务器配置中尚未设置 GitHub 网址。"))
	return

/client/verb/mentorhelp()
	set name = "导师求助"
	set desc = ""
	set category = "-管理-"
	if(mob)
		var/msg = input("向低语提出你的问题：", "导师求助") as text|null
		if(msg)
			mob.schizohelp(msg)
	else
		to_chat(src, span_danger("你目前无法在主菜单中使用导师求助。"))

/client/verb/reportissue()
	set name = "报告问题"
	set desc = ""
	set category = "-管理-"
	var/message = "即将在浏览器中打开 GitHub 问题追踪页面。你确定吗？"
	if(GLOB.revdata.testmerge.len)
		message += "<br>以下实验性改动正在生效，可能是新出现或突发问题的原因。如有可能，请寻找与你的问题相关的专门讨论帖，而非直接提交到通用问题追踪页面：<br>"
		message += GLOB.revdata.GetTestMergeInfo(FALSE)
	if(tgalert(src, message, "报告问题","是","否")!="是")
		return
	DIRECT_OUTPUT(src, link("https://github.com/Rotwood-Vale/Ratwood-2.0/issues"))
	return

/client/verb/recent_changelog()
	set name = "近期改动"
	set category = "OOC"
	to_chat(src, "<a href='byond://?command=open-changelog' style='display:inline-block;padding:4px 10px;border:1px solid #6f8f5f;border-radius:4px;background:#22331d;color:#d8f0c8;text-decoration:none;'><b>打开更新日志</b></a>")
	if(GLOB.changelog.len)
		to_chat(src, "近期改动：")
		for(var/change in GLOB.changelog)
			to_chat(src, span_info("- [change]"))

/client/verb/open_changelog()
	set name = "open-changelog"
	set category = "OOC"
	set hidden = 1
	if(mob)
		GLOB.changelog_tgui.ui_interact(mob)

/client/verb/hotkeys_help()
	set name = "_帮助-操作指南"
	set category = "OOC"
	mob.hotkey_help()


/mob/proc/hotkey_help()
	var/hotkey_mode = {"<font color='purple'>
快捷键模式：（需先开启快捷键模式）
\tTAB = 切换快捷键模式
\tw = 向北
\ta = 向西
\ts = 向南
\td = 向东
\tq = 左手
\te = 右手
\tr = 投掷
\tf = 固定视线（横移模式）
\tSHIFT + f = 向上看
\tz = 丢弃
\tx = 取消／挣脱抓取
\tc = 招架／闪避
\tv = 站起／躺下
\t1 至 4 = 切换意图（当前手）
\t鼠标滚轮 = 调整瞄准高度
\tg = 给予
\t<B></B>h = 啃咬
\tj = 跳跃
\tk = 踢踹
\tl = 偷窃
\tt = 说话
\tALT = 冲刺
\tCTRL + ALT = 潜行
\t鼠标左键 = 使用意图／交互（按住以持续施展）
\t鼠标右键 = 特殊交互
\t鼠标中键 = 给予／踢踹／跳跃／偷窃／施法
\t鼠标中键（无意图）= 特殊交互
\tSHIFT + 鼠标左键 = 检视
\tSHIFT + 鼠标右键 = 聚焦
\tALT + 鼠标右键 = 查看地块物体列表
\tCTRL + 鼠标右键 = 指向
</font>"}

	to_chat(src, hotkey_mode)

/client/verb/set_fixed()
	set name = "图标大小"
	set category = "选项"

	if(winget(src, "mapwindow.map", "icon-size") == "64")
		to_chat(src, "已切换为拉伸适应窗口。")
		winset(src, "mapwindow.map", "icon-size=0")
	else
		to_chat(src, "已切换为64像素图标。")
		winset(src, "mapwindow.map", "icon-size=64")

/client/verb/set_stretch()
	set name = "图标缩放"
	set category = "选项"
	if(prefs)
		if(prefs.crt == TRUE)
			to_chat(src, "CRT 显示模式已开启。")
			winset(src, "mapwindow.map", "zoom-mode=blur")
			return
	if(winget(src, "mapwindow.map", "zoom-mode") == "normal")
		to_chat(src, "已切换为像素精确缩放。")
		winset(src, "mapwindow.map", "zoom-mode=distort")
	else
		to_chat(src, "已切换为抗锯齿缩放。")
		winset(src, "mapwindow.map", "zoom-mode=normal")

/client/verb/crtmode()
	set category = "选项"
	set name = "切换显像管效果"
	set hidden = 1
	if(!prefs)
		return
	if(prefs.crt == TRUE)
		winset(src, "mapwindow.map", "zoom-mode=normal")
		prefs.crt = FALSE
		prefs.save_preferences()
		to_chat(src, "CRT 显示模式已关闭。")
		for(var/atom/movable/screen/scannies/S in screen)
			S.alpha = 0
	else
		winset(src, "mapwindow.map", "zoom-mode=blur")
		prefs.crt = TRUE
		prefs.save_preferences()
		to_chat(src, "CRT 显示模式已开启。")
		for(var/atom/movable/screen/scannies/S in screen)
			S.alpha = 70

/client/verb/grainfilter()
	set category = "选项"
	set name = "切换颗粒效果"
	set hidden = 1
	if(!prefs)
		return
	if(prefs.grain == TRUE)
		prefs.grain = FALSE
		prefs.save_preferences()
		to_chat(src, "画面颗粒效果<font color='gray'>已关闭。</font>")
		for(var/atom/movable/screen/grain/S in screen)
			S.alpha = 0
	else
		prefs.grain = TRUE
		prefs.save_preferences()
		to_chat(src, "画面颗粒效果<font color='#007fff'>已开启。</font>")
		for(var/atom/movable/screen/grain/S in screen)
			S.alpha = 55

/client/verb/triggercommend()
	set category = "OOC"
	set name = "称赞玩家"
	commendsomeone()

/client/verb/roleplay_ad_view()
	set category = "OOC"
	set name = "角色扮演告示（查看）"
	view_roleplay_ads()

/client/verb/roleplay_ad_set()
	set category = "OOC"
	set name = "角色扮演告示（设置）"
	if(mob)
		if(!ishuman(mob))
			return
		var/mob/living/carbon/human/C = mob
		var/has_old_ad = FALSE
		if(LAZYACCESS(GLOB.roleplay_ads,C.mobid))
			to_chat(C, span_info(LAZYACCESS(GLOB.roleplay_ads,C.mobid)))
			has_old_ad = TRUE
		var/msg = input("发布一则告示，说明你想参与哪种角色扮演。其他人可通过“角色扮演告示（查看）”命令查看。请勿滥用此功能。留空并确认即可移除告示。", "我热爱角色扮演") as message|null
		if(msg)
			LAZYSET(GLOB.roleplay_ads,C.mobid,"<b>[C.real_name]</b> - [html_encode(msg)]<BR>")
			to_chat(C, span_info("角色扮演告示已发布。"))
			log_game("[C] has set their Roleplay Ad to '[msg]'.")
			for(var/client/advertisee in (GLOB.clients - src))
				if(!(advertisee.prefs.toggles & ROLEPLAY_ADS))
					continue
				to_chat(advertisee, span_info("[C.real_name]发布了一则角色扮演告示。"))
		else if(has_old_ad)
			LAZYREMOVE(GLOB.roleplay_ads,C.mobid)
			to_chat(C, span_info("角色扮演告示已移除。"))

/client/verb/changefps()
	set category = "选项"
	set name = "修改帧率"
	if(!prefs)
		return
	var/newfps = input(usr, "输入新的帧率", "新帧率", 100) as null|num
	if (!isnull(newfps))
		prefs.clientfps = clamp(newfps, 1, 1000)
		fps = prefs.clientfps
		prefs.save_preferences()

/client/verb/set_picinchat()
	set name = "聊天头像"
	set category = "选项"
	set hidden = 1

	if(prefs)
		prefs.chatheadshot = !prefs.chatheadshot
		prefs.save_preferences()
		if(prefs.chatheadshot)
			to_chat(src, "聊天头像已启用。")
		else
			to_chat(src, "聊天头像已禁用。")

/client/verb/changelog()
	set name = "更新日志"
	set category = "OOC"

	if(!GLOB.changelog_tgui)
		GLOB.changelog_tgui = new /datum/changelog()

	GLOB.changelog_tgui.ui_interact(mob)
	if(prefs.lastchangelog != GLOB.changelog_hash)
		prefs.lastchangelog = GLOB.changelog_hash
		prefs.save_preferences()
		winset(src, "infobuttons.changelog", "font-style=;")

/*
/client/verb/set_blur()
	set name = "AAOn"
	set category = "Options"

	winset(src, "mapwindow.map", "zoom-mode=blur")

/client/verb/set_normal()
	set name = "AAOff"
	set category = "Options"

	winset(src, "mapwindow.map", "zoom-mode=normal")*/
