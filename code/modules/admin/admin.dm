////////////////////////////////
/proc/message_admins(msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">管理日志：</span> <span class=\"message linkify\">[msg]</span></span>"
	for(var/client/C in GLOB.admins)
		if(check_rights_for(C, R_ADMIN))
			to_chat(C, type = MESSAGE_TYPE_ADMINLOG, html = msg)

/proc/spawn_message_admins(msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">管理日志：</span> <span class=\"message linkify\">[msg]</span></span>"
	for(var/client/C in GLOB.admins)
		if(check_rights_for(C, R_ADMIN) && (C.prefs.admin_chat_toggles & CHAT_ADMINSPAWN))
			to_chat(C, type = MESSAGE_TYPE_ADMINLOG, html = msg)

/proc/relay_msg_admins(msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">转发：</span> <span class=\"message linkify\">[msg]</span></span>"
	to_chat(GLOB.admins, type = MESSAGE_TYPE_ADMINLOG, html = msg)


///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/admins/proc/show_player_panel_next(mob/M, clicked_flag = null)
	log_admin("[key_name(usr)] checked the individual player panel for [key_name(M)][isobserver(usr)?"":" while in game"].")

	if(!M)
		to_chat(usr, "<span class='warning'>所选生物已不存在。</span>")
		return

	var/body = "<html><meta charset='UTF-8'><head><title>Options for [M.key]</title><style>"
	body += "<style>"
	body += "html, body { height: 100%; margin: 0; padding: 0; overflow-x: hidden; }"
	body += "#container { display: flex; flex-direction: row; align-items: flex-start; width: 100%; overflow-x: hidden; flex-wrap: nowrap; }"
	body += "#left { flex: 2; padding-right: 10px; min-width: 0; }"
	body += "#skills-section, #languages-section, #stats-section, #patron-section { display: none; background: white; border: 1px solid black; padding: 10px; width: 100%; box-sizing: border-box; max-width: 100%; overflow-x: hidden; word-wrap: break-word; }"
	body += "#right { flex: 1; border-left: 2px solid black; padding-left: 10px; max-height: 500px; overflow-y: auto; width: 250px; min-width: 250px; box-sizing: border-box; position: relative; }"
	body += "#right-header { display: flex; justify-content: space-around; padding: 5px; background: white; border-bottom: 2px solid black; position: sticky; top: 0; z-index: 10; }"
	body += "#right-header button { flex: 1; margin: 2px; padding: 5px; cursor: pointer; font-weight: bold; border: none; background-color: #ddd; border-radius: 5px; }"
	body += "#right-header button:hover { background-color: #ccc; }"

	body += "</style>"

	body += "<script>"
	body += "function toggleSection(section) {"
	body += "    localStorage.setItem('activeSection', section);"
	body += "    document.getElementById('skills-section').style.display = (section === 'skills') ? 'block' : 'none';"
	body += "    document.getElementById('languages-section').style.display = (section === 'languages') ? 'block' : 'none';"
	body += "	 document.getElementById('stats-section').style.display = (section === 'stats') ? 'block' : 'none';"
	body += "    document.getElementById('patron-section').style.display = (section === 'patron') ? 'block' : 'none';"
	body += "}"

	body += "function refreshAndKeepSection(section) {"
	body += "    localStorage.setItem('activeSection', section);"
	body += "    location.reload();"
	body += "}"

	body += "window.onload = function() {"
	body += "    var activeSection = \"[clicked_flag]\";"
	body += "    if (activeSection !== \"0\" && activeSection !== \"\") {"
	body += "        toggleSection(activeSection);"
	body += "    }"
	body += "}"
	body += "</script>"

	body +="</head>"
	body += "<body><div id='container'>"
	body += "<div id='left'>"
	body += "<body><b>[M]</b> 的选项面板"
	if(M.client)
		body += " 由 <b>[M.client]</b> 扮演 "
		body += "\[<A href='?_src_=holder;[HrefToken()];editrights=[(GLOB.admin_datums[M.client.ckey] || GLOB.deadmins[M.client.ckey]) ? "rank" : "add"];key=[M.key]'>[M.client.holder ? M.client.holder.rank : "玩家"]</A>\]"
		if(CONFIG_GET(flag/use_exp_tracking))
			body += "\[<A href='?_src_=holder;[HrefToken()];getplaytimewindow=[REF(M)]'>" + M.client.get_exp_living() + "</a>\]"

	if(isnewplayer(M))
		body += " <B>尚未进入游戏</B> "
	else
		body += " \[<A href='?_src_=holder;[HrefToken()];revive=[REF(M)]'>治疗</A>\] "

	if(M.client)
		body += "<br>\[<b>首次加入：</b>[M.client.player_join_date]\]\[<b>BYOND 账号注册日期：</b>[M.client.account_join_date]\] IP: [M.client.address]"
		body += "<br><br><b>按以下条件查看关联账号：</b> "
		body += "\[ <a href='?_src_=holder;[HrefToken()];showrelatedacc=cid;client=[REF(M.client)]'>CID</a> | "
		body += "<a href='?_src_=holder;[HrefToken()];showrelatedacc=ip;client=[REF(M.client)]'>IP</a> \]"

		var/pq = get_playerquality(M.ckey, TRUE)
		var/pq_num = get_playerquality(M.ckey, FALSE)
		body += "<br><br>玩家质量分（PQ）：[pq] ([pq_num])"
		body += "<br><a href='?_src_=holder;[HrefToken()];editpq=add;mob=[REF(M)]'>\[修改 PQ\]</a> "
		body += "<a href='?_src_=holder;[HrefToken()];showpq=add;mob=[REF(M)]'>\[查看 PQ\]</a> "
		body += "<br><a href='?_src_=holder;[HrefToken()];edittriumphs=add;mob=[REF(M)]'>\[修改凯旋点\]</a> "
		body += "<br>"
		body += "<a href='?_src_=holder;[HrefToken()];roleban=add;mob=[REF(M)]'>\[角色封禁面板\]</a> "

		var/patron = "无"
		if(isliving(M))
			var/mob/living/living = M
			patron = initial(living.patron.name)
		body += "<br><br>当前信仰：[patron]"

		// Role and Advclass display
		body += "<br>职业：[M.job ? (SSjob.GetJob(M.job)?.display_title || M.job) : "无"]"
		body += "<br>进阶职业：[M.advjob ? M.advjob : "无"]"

		var/idstatus = "<br>年龄核验状态："
		if(!M.ckey)
			idstatus += "没有账号！"
		else if(!M.check_agevet())
			idstatus += "未核验"
		else
			var/vetadmin = LAZYACCESS(GLOB.agevetted_list, M.ckey)
			idstatus += "由 [vetadmin] <b>完成年龄核验</b>"
		body += idstatus

		//Azure port. Incompatibility.
		/*var/curse_string = ""
		if(ishuman(M))
			var/mob/living/carbon/human/living = M
			for(var/datum/curse/curse in living.curses)
				curse_string += "<br> - [curse.name]"
		body += "<br>Curses: [curse_string]"*/

		var/full_version = "未知"
		if(M.client.byond_version)
			full_version = "[M.client.byond_version].[M.client.byond_build ? M.client.byond_build : "xxx"]"
		body += "<br>\[<b>BYOND 版本：</b>[full_version]\]<br>"


	body += "<br><br>\[ "
	body += "<a href='?_src_=vars;[HrefToken()];Vars=[REF(M)]'>变量</a> - "
	if(M.mind)
		body += "<a href='?_src_=holder;[HrefToken()];traitor=[REF(M)]'>反派面板</a> - "
	else
		body += "<a href='?_src_=holder;[HrefToken()];initmind=[REF(M)]'>初始化意识</a> - "
	body += "<a href='?priv_msg=[M.ckey]'>私信</a> - "
	body += "<a href='?_src_=holder;[HrefToken()];subtlemessage=[REF(M)]'>隐秘消息</a> - "
	body += "<a href='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(M)]'>跟随</a> - "
	body += "<a href='?_src_=holder;[HrefToken()];cursemenu=[M.ckey]'>诅咒</a> - "
	//Default to client logs if available
	var/source = LOGSRC_MOB
	if(M.client)
		source = LOGSRC_CLIENT
	body += "<a href='?_src_=holder;[HrefToken()];individuallog=[REF(M)];log_src=[source]'>日志</a>\] <br>"

	body += "<b>角色类型</b> = [M.type]<br><br>"

	body += "<A href='?_src_=holder;[HrefToken()];boot2=[REF(M)]'>踢出</A> | "
	if(M.client)
		body += "<A href='?_src_=holder;[HrefToken()];newbankey=[M.key];newbanip=[M.client.address];newbancid=[M.client.computer_id]'>封禁</A> | "
	else
		body += "<A href='?_src_=holder;[HrefToken()];newbankey=[M.key]'>封禁</A> | "

	body += "<A href='?_src_=holder;[HrefToken()];showmessageckey=[M.ckey]'>备注 | 消息 | 观察名单</A> | "
	if(M.client)
		body += "\ <A href='?_src_=holder;[HrefToken()];sendbacktolobby=[REF(M)]'>送回大厅</A> | "
		var/muted = M.client.prefs.muted
		body += "<br><b>禁言：</b> "
		body += "\[<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"blue"]'>IC</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"blue"]'>OOC</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"blue"]'>祈祷</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"blue"]'>管理员求助</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"blue"]'>亡者聊天</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_LOOC]'><font color='[(muted & MUTE_LOOC)?"red":"blue"]'>LOOC</font></a> | "
		body += "<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_SLOOC]'><font color='[(muted & MUTE_SLOOC)?"red":"blue"]'>SLOOC</font></a>\]"
		body += "(<A href='?_src_=holder;[HrefToken()];mute=[M.ckey];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"blue"]'>切换全部</font></a>)"

	body += "<br><br>"
	body += "<A href='?_src_=holder;[HrefToken()];jumpto=[REF(M)]'><b>前往</b></A> | "
	body += "<A href='?_src_=holder;[HrefToken()];getmob=[REF(M)]'>拉取</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];sendmob=[REF(M)]'>传送至</A>"

	body += "<br><br>"
	body += "<A href='?_src_=holder;[HrefToken()];traitor=[REF(M)]'>反派面板</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];narrateto=[REF(M)]'>发送旁白</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];subtlemessage=[REF(M)]'>隐秘消息</A>"
	//body += "<A href='?_src_=holder;[HrefToken()];languagemenu=[REF(M)]'>Language Menu</A>"
	body += "<br><A href='?_src_=holder;[HrefToken()];heal_panel=[REF(M)]'>治疗面板</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];inventory_panel=[REF(M)]'>物品栏面板</A>"

	body += "</div>"

	body += "<div id='right'>"
	body += "<div id='right-header'>"
	body += "<button onclick=\"toggleSection('skills')\">技能</button>"
	body += "<button onclick=\"toggleSection('languages')\">语言</button>"
	body += "<button onclick=\"toggleSection('stats')\">属性</button>"
	body += "<button onclick=\"toggleSection('patron')\">信仰</button>"
	body += "</div>"


	body += "<div id='skills-section'>"
	body += "<h3>技能</h3><ul>"
	for(var/skill_type in SSskills.all_skills)
		var/datum/skill/skill = GetSkillRef(skill_type)
		var/skill_level = 0
		if(skill in M.skills?.known_skills)
			skill_level = M.skills?.known_skills[skill]
		body += "<li>[initial(skill.name)]: <a href='?_src_=holder;[HrefToken()];set_skill=[REF(M)];skill=[skill.type]'>[skill_level]</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];increase_skill=[REF(M)];skill=[skill.type]'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];decrease_skill=[REF(M)];skill=[skill.type]'>-</a></li>"
	body += "</ul></div>"

	body += "<div id='languages-section'>"
	body += "<h3>语言</h3><ul>"
	for(var/datum/language/ld as anything in GLOB.all_languages)
		body += "<li>[initial(ld.name)] - "
		if (M.mind?.language_holder?.has_language(ld))
			body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];remove_language=[REF(M)];language=[ld]'>移除</a></li>"
		else
			body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_language=[REF(M)];language=[ld]'>授予</a></li>"
	body += "</ul></div>"

	body += "<div id='stats-section'>"
	// Stats Section
	body += "<h3>属性</h3><ul>"
	if(isliving(M)) // Ensure M is a living mob
		var/mob/living/living = M // Explicitly cast M to /mob/living
		body += "<li>力量：<a href='?_src_=holder;[HrefToken()];set_stat=[REF(M)];stat=strength'>[living.STASTR]</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=strength'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=strength'>-</a></li>"

		body += "<li>感知：<a href='?_src_=holder;[HrefToken()];set_stat=[REF(M)];stat=perception'>[living.STAPER]</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=perception'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=perception'>-</a></li>"

		body += "<li>意志：<a href='?_src_=holder;[HrefToken()];set_stat=[REF(M)];stat=willpower'>[living.STAWIL]</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=willpower'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=willpower'>-</a></li>"

		body += "<li>体质：<a href='?_src_=holder;[HrefToken()];set_stat=[REF(M)];stat=constitution'>[living.STACON]</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=constitution'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=constitution'>-</a></li>"

		body += "<li>智力：<a href='?_src_=holder;[HrefToken()];set_stat=[REF(M)];stat=intelligence'>[living.STAINT]</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=intelligence'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=intelligence'>-</a></li>"

		body += "<li>速度：<a href='?_src_=holder;[HrefToken()];set_stat=[REF(M)];stat=speed'>[living.STASPD]</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=speed'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=speed'>-</a></li>"

		body += "<li>幸运：<a href='?_src_=holder;[HrefToken()];set_stat=[REF(M)];stat=fortune'>[living.STALUC]</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];add_stat=[REF(M)];stat=fortune'>+</a> "
		body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];lower_stat=[REF(M)];stat=fortune'>-</a></li>"
		body += "</ul>"
		body += "</div>"
		
		// Patron Section
		body += "<div id='patron-section'>"
		body += "<h3>信仰</h3>"
		body += "<p>当前：[initial(living.patron.name)]</p>"
		body += "<ul>"
		for(var/patron_type in GLOB.patronlist)
			// Skip Science patrons
			if(patron_type == /datum/patron/godless)
				continue
			var/datum/patron/P = GLOB.patronlist[patron_type]
			// Skip if patron is null or has no name
			if(!P || !initial(P.name))
				continue
			body += "<li>[initial(P.name)] "
			body += "<a class='skill-btn' href='?_src_=holder;[HrefToken()];set_patron=[REF(M)];patron=[patron_type]'>设置</a></li>"
		body += "</ul></div>"
		

		body += "</div>"
		body += "</div>"


		body += "<br>"
		body += "</body></html>"

	usr << browse(body, "window=adminplayeropts-[REF(M)];size=800x600")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Player Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/admin_heal(mob/living/M in GLOB.mob_list)
	set name = "显示健康面板"
	set category = "-GameMaster-"

	if(!check_rights(R_ADMIN))
		return

	show_heal_panel(M)

/client/proc/show_heal_panel(mob/M)
	holder?.show_heal_panel(M)

/datum/admins/proc/show_heal_panel(mob/living/M)
	log_admin("[key_name(usr)] opened heal panel for [key_name(M)]")
	
	if(!M)
		return

	var/body = "<html><meta charset='UTF-8'><head><title>Heal - [M.name]</title>"
	body += "<style>"
	body += "table { border-collapse: collapse; width: 100%; }"
	body += "th, td { border: 1px solid black; padding: 5px; text-align: left; }"
	body += "th { background-color: #ddd; }"
	body += "</style>"
	body +="</head><body>"
	
	body += "<b>治疗面板：[M.name]</b><br><br>"
	body += "<A href='?_src_=holder;[HrefToken()];heal_target=[REF(M)]'>完全治疗</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];heal_revive=[REF(M)]'>复活</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];heal_refresh=[REF(M)]'>刷新</A>"
	if(ishuman(M))
		body += " | <A href='?_src_=holder;[HrefToken()];heal_modify_organs=[REF(M)]'>修改器官</A>"
	body += "<br><br>"
	
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		
		// Blood Volume
		body += "<b>血量：</b>[H.get_blood_volume()] / [BLOOD_VOLUME_NORMAL] 单位<br>"
		body += "<A href='?_src_=holder;[HrefToken()];heal_blood_add100=[REF(M)]'>+100</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];heal_blood_add50=[REF(M)]'>+50</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];heal_blood_sub50=[REF(M)]'>-50</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];heal_blood_sub100=[REF(M)]'>-100</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];heal_blood_set=[REF(M)]'>设置数值</A>"
		body += "<br><br>"
		
		// Overall Damage (no label)
		body += "毒素：<A href='?_src_=holder;[HrefToken()];heal_edit_overall=[REF(M)];damage_type=toxin'>[H.getToxLoss()]</A> | "
		body += "窒息：<A href='?_src_=holder;[HrefToken()];heal_edit_overall=[REF(M)];damage_type=oxy'>[H.getOxyLoss()]</A>"
		body += "<br><br>"
		
		// Bodypart Damage
		body += "<b>肢体损伤：</b><br>"
		body += "<table><tr><th>肢体</th><th>物理损伤</th><th>烧伤</th><th>操作</th></tr>"
		for(var/obj/item/bodypart/BP in H.bodyparts)
			var/limb_name = BP.name
			if(BP.status == BODYPART_ROBOTIC)
				limb_name += "（义肢）"
			body += "<tr>"
			body += "<td>[limb_name]</td>"
			body += "<td>物理：<A href='?_src_=holder;[HrefToken()];heal_edit_damage=[REF(M)];bodypart=[REF(BP)];damage_type=brute'>[BP.brute_dam]</A></td>"
			body += "<td>烧伤：<A href='?_src_=holder;[HrefToken()];heal_edit_damage=[REF(M)];bodypart=[REF(BP)];damage_type=burn'>[BP.burn_dam]</A></td>"
			body += "<td>"
			body += "<A href='?_src_=holder;[HrefToken()];heal_fix_bodypart=[REF(M)];bodypart=[REF(BP)]'>治疗</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];heal_add_wound=[REF(M)];bodypart=[REF(BP)]'>添加伤口</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];heal_remove_bodypart=[REF(M)];bodypart=[REF(BP)]'>移除</A>"
			body += "</td>"
			body += "</tr>"
		body += "</table>"
		body += "<br>"
	else
		// Simplified menu for non-human mobs
		body += "<b>生命值：</b>[M.health] / [M.maxHealth]<br>"
		body += "物理：<A href='?_src_=holder;[HrefToken()];heal_edit_simple=[REF(M)];damage_type=brute'>[M.getBruteLoss()]</A> | "
		body += "烧伤：<A href='?_src_=holder;[HrefToken()];heal_edit_simple=[REF(M)];damage_type=burn'>[M.getFireLoss()]</A> | "
		body += "毒素：<A href='?_src_=holder;[HrefToken()];heal_edit_simple=[REF(M)];damage_type=toxin'>[M.getToxLoss()]</A> | "
		body += "窒息：<A href='?_src_=holder;[HrefToken()];heal_edit_simple=[REF(M)];damage_type=oxy'>[M.getOxyLoss()]</A>"
		body += "<br><br>"
	
	body += "<b>伤口：</b><br>"
	
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/list/all_wounds = list()
		
		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.wounds && BP.wounds.len)
				for(var/datum/wound/W in BP.wounds)
					all_wounds += list(list("bodypart" = BP, "wound" = W))
		
		if(all_wounds.len)
			body += "<table><tr><th>肢体</th><th>伤口类型</th><th>操作</th></tr>"
			for(var/list/wound_data in all_wounds)
				var/obj/item/bodypart/BP = wound_data["bodypart"]
				var/datum/wound/W = wound_data["wound"]
				body += "<tr>"
				body += "<td>[BP.name]</td>"
				body += "<td>[W.name]</td>"
				body += "<td><A href='?_src_=holder;[HrefToken()];heal_remove_wound=[REF(M)];wound=[REF(W)]'>移除</A></td>"
				body += "</tr>"
			body += "</table>"
		else
			body += "未发现伤口<br>"
	else
		body += "伤口系统仅适用于人形角色<br>"
	
	body += "</body></html>"

	usr << browse(body, "window=adminplayeropts-heal[REF(M)];size=650x550")

/datum/admins/proc/handle_heal_panel_topic(href_list)
	if(!check_rights())
		return FALSE
	
	if(!href_list["heal_action"])
		return FALSE
	
	var/mob/living/target = locate(href_list["target"])
	if(!target || !isliving(target))
		to_chat(usr, span_warning("目标已不存在！"))
		return TRUE
	
	switch(href_list["heal_action"])
		if("full_heal")
			target.fully_heal(admin_revive = TRUE)
			message_admins(span_danger("管理员 [key_name_admin(usr)] 完全治愈了 [key_name_admin(target)]！"))
			log_admin("[key_name(usr)] fully healed [key_name(target)].")
			show_heal_panel(target)
		
		if("blood_add")
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/amount = text2num(href_list["amount"])
				H.set_blood_volume(min(H.get_blood_volume() + amount, BLOOD_VOLUME_MAXIMUM))
				message_admins("[key_name_admin(usr)] 为 [key_name_admin(target)] 增加了 [amount] 血量。")
				log_admin("[key_name(usr)] added [amount] blood to [key_name(target)].")
				show_heal_panel(target)
		
		if("blood_sub")
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/amount = text2num(href_list["amount"])
				H.set_blood_volume(max(H.get_blood_volume() - amount, 0))
				message_admins("[key_name_admin(usr)] 为 [key_name_admin(target)] 减少了 [amount] 血量。")
				log_admin("[key_name(usr)] removed [amount] blood from [key_name(target)].")
				show_heal_panel(target)
		
		if("blood_set")
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				var/amount = text2num(href_list["amount"])
				H.set_blood_volume(amount)
				message_admins("[key_name_admin(usr)] 将 [key_name_admin(target)] 的血量设为 [amount]。")
				log_admin("[key_name(usr)] set [key_name(target)]'s blood to [amount].")
				show_heal_panel(target)
		
		if("remove_wound")
			var/datum/wound/W = locate(href_list["wound"])
			if(W && ishuman(target))
				var/mob/living/carbon/human/H = target
				for(var/obj/item/bodypart/BP in H.bodyparts)
					if(W in BP.wounds)
						BP.remove_wound(W)
						message_admins("[key_name_admin(usr)] 移除了 [key_name_admin(target)] 的伤口 [W.name]。")
						log_admin("[key_name(usr)] removed wound [W.name] from [key_name(target)].")
						break
				show_heal_panel(target)
		
		if("refresh")
			show_heal_panel(target)
		
		if("close")
			return TRUE
	
	return TRUE

/datum/admins/proc/show_inventory_panel(mob/living/M)
	log_admin("[key_name(usr)] opened inventory panel for [key_name(M)]")
	
	if(!M)
		to_chat(usr, "<span class='warning'>所选生物已不存在。</span>")
		return
	
	var/body = "<html><meta charset='UTF-8'><head><title>Inventory Panel - [M.name]</title>"
	body += "<style>"
	body += "table { border-collapse: collapse; width: 100%; }"
	body += "th, td { border: 1px solid black; padding: 5px; text-align: left; }"
	body += "th { background-color: #ddd; }"
	body += "</style>"
	body +="</head>"
	body += "<body>"
	
	body += "<b>物品栏面板：[M.name]</b><br><br>"
	body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=repair_all'>全部修复</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=refresh'>刷新</A>"
	body += "<br><br>"
	
	var/list/all_items = list()
	
	// Add held items
	for(var/obj/item/I in M.held_items)
		if(I && !(I in all_items))
			all_items += I
	
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/I in H.get_equipped_items(TRUE))
			// Only include equipable items: clothing, weapons, armor
			if(istype(I, /obj/item/clothing) || istype(I, /obj/item/rogueweapon) || I.slot_flags)
				if(!(I in all_items))
					all_items += I
	
	body += "<b>装备：</b><br>"
	
	if(all_items.len)
		body += "<table><tr><th>图标</th><th>物品</th><th>耐久</th><th>操作</th></tr>"
		for(var/obj/item/I in all_items)
			var/integrity_percent = 100
			
			if(I.obj_integrity && I.max_integrity)
				integrity_percent = round((I.obj_integrity / I.max_integrity) * 100)
			
			body += "<tr>"
			body += "<td><img src='data:image/png;base64,[icon2base64(icon(I.icon, I.icon_state))]' width=32 height=32></td>"
			body += "<td>"
			body += "<A href='?_src_=vars;[HrefToken()];Vars=[REF(I)]'>[I.name]</A>"
			
			// Check if item has contents
			if(I.contents.len > 0)
				body += " <A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=view_contents;item=[REF(I)]'>（内容物）</A>"
			
			body += "</td>"
			body += "<td>[I.obj_integrity] / [I.max_integrity] ([integrity_percent]%)"
			// Sharpness info below integrity if item has sharpness
			if(I.max_blade_int > 0)
				var/sharpness_percent = round((I.blade_int / I.max_blade_int) * 100)
				body += "<br>锋利度：[I.blade_int] / [I.max_blade_int] ([sharpness_percent]%)"
			body += "</td>"
			body += "<td>"
			body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=repair_item;item=[REF(I)]'>修复</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=drop_item;item=[REF(I)]'>丢弃</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=destroy_item;item=[REF(I)]'>删除</A>"
			body += "</td>"
			body += "</tr>"
		body += "</table>"
	else
		body += "未找到装备<br>"
	
	body += "</body></html>"

	usr << browse(body, "window=adminplayeropts-inventory[REF(M)];size=760x600")

/datum/admins/proc/show_item_contents_panel(mob/living/M, obj/item/container)
	if(!M || !container)
		return
	
	var/body = "<html><meta charset='UTF-8'><head><title>内容物 - [container.name]</title>"
	body += "<style>"
	body += "table { border-collapse: collapse; width: 100%; }"
	body += "th, td { border: 1px solid black; padding: 5px; text-align: left; }"
	body += "th { background-color: #ddd; }"
	body += "</style>"
	body += "</head>"
	body += "<body>"
	
	body += "<b>[container.name] 的内容物</b><br><br>"
	body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=view_contents;item=[REF(container)]'>刷新</A>"
	body += "<br><br>"
	
	if(container.contents.len > 0)
		body += "<table><tr><th>图标</th><th>物品</th><th>耐久</th><th>操作</th></tr>"
		for(var/obj/O in container.contents)
			var/integrity_percent = 100
			var/integrity_text = "不适用"
			
			if(istype(O, /obj/item))
				var/obj/item/I = O
				if(I.obj_integrity && I.max_integrity)
					integrity_percent = round((I.obj_integrity / I.max_integrity) * 100)
					integrity_text = "[I.obj_integrity] / [I.max_integrity] ([integrity_percent]%)"
			
			body += "<tr>"
			body += "<td><img src='data:image/png;base64,[icon2base64(icon(O.icon, O.icon_state))]' width=32 height=32></td>"
			body += "<td>"
			body += "<A href='?_src_=vars;[HrefToken()];Vars=[REF(O)]'>[O.name]</A>"
			
			// If this item also has contents, show contents button
			if(istype(O, /obj/item) && O.contents.len > 0)
				body += " <A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=view_contents;item=[REF(O)]'>（内容物）</A>"
			
			body += "</td>"
			body += "<td>[integrity_text]"
			// Sharpness info below integrity if item has sharpness
			if(istype(O, /obj/item))
				var/obj/item/I = O
				if(I.max_blade_int > 0)
					var/sharpness_percent = round((I.blade_int / I.max_blade_int) * 100)
					body += "<br>锋利度：[I.blade_int] / [I.max_blade_int] ([sharpness_percent]%)"
			body += "</td>"
			body += "<td>"
			if(istype(O, /obj/item))
				var/obj/item/I = O
				if(I.max_integrity)
					body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=repair_item;item=[REF(O)]'>修复</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=drop_item;item=[REF(O)]'>丢弃</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=destroy_item;item=[REF(O)]'>删除</A>"
			body += "</td>"
			body += "</tr>"
		body += "</table>"
	else
		body += "此容器为空。<br>"
	
	body += "</body></html>"
	
	usr << browse(body, "window=adminplayeropts-contents[REF(container)];size=760x600")


/datum/admins/proc/handle_inventory_panel_topic(href_list)
	if(!check_rights(R_ADMIN))
		return FALSE
	
	if(!href_list["inventory_action"])
		return FALSE
	
	var/mob/living/target = locate(href_list["target"])
	if(!target || !isliving(target))
		to_chat(usr, span_warning("目标已不存在！"))
		return TRUE
	
	switch(href_list["inventory_action"])
		if("repair_all")
			var/repaired_count = 0
			for(var/obj/item/I in target.held_items)
				if(I && I.obj_integrity < I.max_integrity)
					if(I.obj_broken)
						I.obj_fix(null, TRUE)
					else
						I.obj_integrity = I.max_integrity
					I.update_icon()
					repaired_count++
				// Also restore sharpness
				if(I && I.max_blade_int > 0 && I.blade_int < I.max_blade_int)
					I.blade_int = I.max_blade_int
			
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				for(var/obj/item/I in H.GetAllContents())
					if(I.obj_integrity < I.max_integrity)
						if(I.obj_broken)
							I.obj_fix(null, TRUE)
						else
							I.obj_integrity = I.max_integrity
						I.update_icon()
						repaired_count++
					// Also restore sharpness
					if(I.max_blade_int > 0 && I.blade_int < I.max_blade_int)
						I.blade_int = I.max_blade_int
			
			to_chat(usr, span_notice("已为 [target.name] 修复 [repaired_count] 件物品。"))
			to_chat(target, span_notice("我的装备被魔法修复了！"))
			message_admins("[key_name_admin(usr)] 修复了 [key_name_admin(target)] 的全部装备。")
			log_admin("[key_name(usr)] repaired all equipment for [key_name(target)].")
			show_inventory_panel(target)
		
		if("damage_all")
			var/damaged_count = 0
			for(var/obj/item/I in target.held_items)
				if(I && I.max_integrity)
					I.obj_integrity = I.max_integrity * 0.5
					I.update_icon()
					damaged_count++
			
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				for(var/obj/item/I in H.GetAllContents())
					if(I.max_integrity)
						I.obj_integrity = I.max_integrity * 0.5
						I.update_icon()
						damaged_count++
			
			to_chat(usr, span_notice("已损坏 [target.name] 的 [damaged_count] 件物品。"))
			to_chat(target, span_warning("我的装备突然变得脆弱了！"))
			message_admins("[key_name_admin(usr)] 损坏了 [key_name_admin(target)] 的全部装备。")
			log_admin("[key_name(usr)] damaged all equipment for [key_name(target)].")
			show_inventory_panel(target)
		
		if("destroy_all")
			if(alert(usr, "确定要销毁 [target.name] 的全部装备？", "确认", "是", "否") != "是")
				show_inventory_panel(target)
				return TRUE
			
			var/destroyed_count = 0
			for(var/obj/item/I in target.held_items)
				if(I)
					qdel(I)
					destroyed_count++
			
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				for(var/obj/item/I in H.GetAllContents())
					qdel(I)
					destroyed_count++
			
			to_chat(usr, span_notice("已销毁 [target.name] 的 [destroyed_count] 件物品。"))
			to_chat(target, span_danger("我的所有装备都瓦解了！"))
			message_admins("[key_name_admin(usr)] 销毁了 [key_name_admin(target)] 的全部装备。")
			log_admin("[key_name(usr)] destroyed all equipment for [key_name(target)].")
			show_inventory_panel(target)
		
		if("repair_item")
			var/obj/item/I = locate(href_list["item"])
			if(I && I.max_integrity)
				if(I.obj_broken)
					I.obj_fix(null, TRUE)
				else
					I.obj_integrity = I.max_integrity
				// Also restore sharpness
				if(I.max_blade_int > 0)
					I.blade_int = I.max_blade_int
				I.update_icon()
				to_chat(usr, span_notice("已修复 [I.name]。"))
				message_admins("[key_name_admin(usr)] 为 [key_name_admin(target)] 修复了 [I.name]。")
				log_admin("[key_name(usr)] repaired [I.name] for [key_name(target)].")
				// Check if item is in a container, if so refresh contents panel
				if(I.loc && istype(I.loc, /obj/item))
					show_item_contents_panel(target, I.loc)
				else
					show_inventory_panel(target)
		
		if("drop_item")
			var/obj/item/I = locate(href_list["item"])
			if(I)
				var/item_name = I.name
				var/obj/container = I.loc
				// Unequip if worn/held
				if(ishuman(target))
					var/mob/living/carbon/human/H = target
					H.dropItemToGround(I, force = TRUE)
				else if(isliving(target))
					var/mob/living/L = target
					L.dropItemToGround(I, force = TRUE)
				else
					I.forceMove(get_turf(target))
				to_chat(usr, span_notice("已丢弃 [item_name]。"))
				to_chat(target, span_warning("我的[item_name]掉到了地上！"))
				message_admins("[key_name_admin(usr)] 使 [key_name_admin(target)] 丢弃了 [item_name]。")
				log_admin("[key_name(usr)] dropped [item_name] for [key_name(target)].")
				// Check if item was in a container, if so refresh contents panel
				if(container && istype(container, /obj/item))
					show_item_contents_panel(target, container)
				else
					show_inventory_panel(target)
		
		if("damage_item")
			var/obj/item/I = locate(href_list["item"])
			if(I && I.max_integrity)
				I.obj_integrity = max(I.max_integrity * 0.25, 1)
				I.update_icon()
				to_chat(usr, span_notice("已损坏 [I.name]。"))
				message_admins("[key_name_admin(usr)] 损坏了 [key_name_admin(target)] 的 [I.name]。")
				log_admin("[key_name(usr)] damaged [I.name] for [key_name(target)].")
				show_inventory_panel(target)
		
		if("destroy_item")
			var/obj/item/I = locate(href_list["item"])
			if(I)
				var/item_name = I.name
				var/obj/container = I.loc
				qdel(I)
				to_chat(usr, span_notice("已销毁 [item_name]。"))
				to_chat(target, span_warning("我的[item_name]瓦解了！"))
				message_admins("[key_name_admin(usr)] 销毁了 [key_name_admin(target)] 的 [item_name]。")
				log_admin("[key_name(usr)] destroyed [item_name] for [key_name(target)].")
				// Check if item was in a container, if so refresh contents panel
				if(container && istype(container, /obj/item))
					show_item_contents_panel(target, container)
				else
					show_inventory_panel(target)
		
		if("view_contents")
			var/obj/item/I = locate(href_list["item"])
			if(I)
				show_item_contents_panel(target, I)
		
		if("refresh")
			show_inventory_panel(target)
		
		if("close")
			return TRUE
	
	return TRUE

/datum/admins/proc/admin_show_inventory(mob/living/M in GLOB.mob_list)
	set name = "显示物品栏面板"
	set category = "-GameMaster-"

	if(!check_rights(R_ADMIN))
		return

	show_inventory_panel(M)

/client/proc/show_inventory_panel(mob/M)
	holder?.show_inventory_panel(M)

/datum/admins/proc/show_player_panel(mob/M in GLOB.mob_list)
	set category = "-GameMaster-"
	set name = "显示玩家面板"
	set desc="编辑玩家（重生、封禁、治疗等）"

	if(!check_rights())
		return

	show_player_panel_next(M)

/client/proc/show_player_panel_next(mob/M)
	holder?.show_player_panel_next(M)

/datum/admins/proc/admin_revive(mob/living/M in GLOB.mob_list)
	set name = "生物 - 复活"
	set desc = "使生物复苏"
	set category = "-GameMaster-"

	if(!check_rights())
		return

	M.revive(full_heal = TRUE, admin_revive = TRUE)
	message_admins(span_danger("管理员 [key_name_admin(usr)] 复活了 [key_name_admin(M)]！"))
	log_admin("[key_name(usr)] Revived [key_name(M)].")

/datum/admins/proc/checkpq(mob/living/M in GLOB.mob_list)
	set name = "查看玩家质量分（PQ）"
	set desc = "查看生物所属玩家的质量分（PQ）"
	set category = null

	if(!check_rights())
		return

	if(!M.ckey)
		to_chat(src, span_warning("该生物未关联玩家账号。"))
		return

	check_pq_menu(M.ckey)

/datum/admins/proc/admin_sleep(mob/living/M in GLOB.mob_list)
	set name = "切换睡眠"
	set desc = "切换生物的睡眠状态"
	set category = "-GameMaster-"

	if(!check_rights())
		return

	var/S = M.IsSleeping()
	if(S)
		M.remove_status_effect(S)
		M.set_resting(FALSE, TRUE)
	else
		M.SetSleeping(999999)
	message_admins(span_danger("管理员 [key_name_admin(usr)] 切换了 [key_name_admin(M)] 的睡眠状态！"))
	log_admin("[key_name(usr)] toggled [key_name(M)]'s sleeping state.")

/datum/admins/proc/start_vote()
	set name = "发起投票"
	set desc = "发起一项投票"
	set category = "-服务器-"

	if(!check_rights(R_POLL))
		to_chat(usr, span_warning("你没有发起投票的权限。"))
		return

	var/list/allowed_modes = list("结束回合", "说书人", "自定义")

	var/type = input("要发起哪种投票？") as null|anything in allowed_modes
	switch(type)
		//if("Gamemode")
			//type = "gamemode"
		if("结束回合")
			type = "endround"
		if("自定义")
			type = "custom"
		if("说书人")
			type = "storyteller"
	SSvote.initiate_vote(type, usr.key)

/datum/admins/proc/adjustpq(mob/living/M in GLOB.mob_list)
	set name = "调整任意目标的玩家质量分（PQ）"
	set desc = "调整玩家质量分（PQ）"
	set category = "-GameMaster-"
	set hidden = 1

	if(!check_rights())
		return

	if(!M.ckey)
		to_chat(src, span_warning("该生物未关联玩家账号。"))
		return

	var/ckey = LOWER_TEXT(M.ckey)
	var/admin = LOWER_TEXT(usr.key)

	/*if(ckey == admin)
		to_chat(src, span_boldwarning("That's you!"))
		return
	*/
	if(!fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/preferences.sav"))
		to_chat(src, span_boldwarning("用户不存在。"))
		return
	var/amt2change = input("玩家质量分（PQ）要调整多少？（[!check_rights(R_ADMIN,0) ? "-20 至 20，或输入 " : ""]0 仅添加备注）") as null|num
	if(!check_rights(R_ADMIN,0))
		amt2change = CLAMP(amt2change, -20, 20)
	var/raisin = stripped_input("简要说明本次调整的原因", "游戏主持", "", null)
	if(!amt2change && !raisin)
		return
	adjust_playerquality(amt2change, ckey, admin, raisin)
	to_chat(M.client, "<span class=\"admin\"><span class=\"prefix\">管理员记录：</span> <span class=\"message linkify\">[admin]将你的玩家质量分（PQ）调整了[amt2change]，原因：[raisin]</span></span>")

/datum/admins/proc/Game()
	if(!check_rights(0))
		return

	var/dat = "<html><meta charset='UTF-8'><head><title>游戏面板</title></head><body>"
	dat += {"
		<center><B>游戏面板</B></center><hr>\n
		"}
	if(GLOB.master_mode == "secret")
		dat += "<A href='?src=[REF(src)];[HrefToken()];f_secret=1'>（强制秘密模式）</A><br>"
	if(SSticker.IsRoundInProgress())
		dat += "<a href='?src=[REF(src)];[HrefToken()];gamemode_panel=1'>（游戏模式面板）</a><BR>"
	dat += {"
		<BR>
		<A href='?src=[REF(src)];[HrefToken()];create_object=1'>创建物体</A><br>
		<A href='?src=[REF(src)];[HrefToken()];quick_create_object=1'>快速创建物体</A><br>
		<A href='?src=[REF(src)];[HrefToken()];create_turf=1'>创建地块</A><br>
		<A href='?src=[REF(src)];[HrefToken()];create_mob=1'>创建生物</A><br>
		"}

	if(marked_datum && istype(marked_datum, /atom))
		dat += "<A href='?src=[REF(src)];[HrefToken()];dupe_marked_datum=1'>复制已标记的数据对象</A><br>"

	dat += "</body></html>"
	usr << browse(dat, "window=admin2;size=240x280")
	return

/////////////////////////////////////////////////////////////////////////////////////////////////admins2.dm merge
//i.e. buttons/verbs


/datum/admins/proc/restart()
	set category = "-服务器-"
	set name = "重启游戏世界"
	set desc="立即重启游戏世界"
	if (!usr.client.holder)
		return

	var/list/options = list("Regular Restart", "Hard Restart (No Delay/Feeback Reason)", "Hardest Restart (No actions, just reboot)")
	if(world.TgsAvailable())
		options += "Server Restart (Kill and restart DD)";

	var/rebootconfirm
	if(SSticker.admin_delay_notice)
		if(alert(usr, "确定吗？已有管理员推迟回合结束，原因如下：[SSticker.admin_delay_notice]", "确认", "是", "否") == "是")
			rebootconfirm = TRUE
	else
		rebootconfirm = TRUE
	if(rebootconfirm)
		var/result = input(usr, "选择重启方式", "重启游戏世界", options[1]) as null|anything in options
		if(result)
			SSblackbox.record_feedback("tally", "admin_verb", 1, "Reboot World") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
			var/init_by = "由管理员发起。"
			switch(result)
				if("Regular Restart")
					SSticker.Reboot(init_by, "admin reboot - by Admin", 10)
				if("Hard Restart (No Delay, No Feeback Reason)")
					to_chat(world, "游戏世界重启 - [init_by]")
					world.Reboot()
				if("Hardest Restart (No actions, just reboot)")
					to_chat(world, "游戏世界强制重启 - [init_by]")
					world.Reboot(fast_track = TRUE)
				if("Server Restart (Kill and restart DD)")
					to_chat(world, "服务器重启 - [init_by]")
					world.TgsEndProcess()

/datum/admins/proc/end_round()
	set category = "-服务器-"
	set name = "结束回合"
	set desc = ""

	if (!usr.client.holder)
		return
	var/confirm = alert("结束回合并重启游戏世界吗？", "结束回合", "是", "取消")
	if(confirm == "取消")
		return
	if(confirm == "是")
		SSticker.force_ending = 1
		SSblackbox.record_feedback("tally", "admin_verb", 1, "End Round") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/announce()
	set category = "-特殊指令-"
	set name = "发布公告"
	set desc="向全服发布你的公告"
	if(!check_rights(0))
		return

	var/message = input("要发送的全域消息：", "管理员公告", null, null)  as message
	if(message)
		if(!check_rights(R_SERVER,0))
			message = adminscrub(message,500)
		to_chat(world, "<span class='adminnotice'><b>[usr.client.holder.fakekey ? "管理员" : usr.key]发布公告：</b></span>\n \t [message]")
		log_admin("Announce: [key_name(usr)] : [message]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Announce") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/set_admin_notice()
	set category = "-服务器-"
	set name = "设置管理员公告"
	set desc ="设置所有进入服务器的玩家都会看到的公告，仅在本回合生效"
	if(!check_rights(0))
		return

	var/new_admin_notice = input(src,"设置本回合公告，所有进入服务器的玩家都会看到。\n（留空将删除当前公告）：","设置公告",GLOB.admin_notice) as message|null
	if(new_admin_notice == null)
		return
	if(new_admin_notice == GLOB.admin_notice)
		return
	if(new_admin_notice == "")
		message_admins("[key_name(usr)] 删除了管理员公告。")
		log_admin("[key_name(usr)] removed the admin notice:\n[GLOB.admin_notice]")
	else
		message_admins("[key_name(usr)] 设置了管理员公告。")
		log_admin("[key_name(usr)] set the admin notice:\n[new_admin_notice]")
		to_chat(world, span_adminnotice("<b>管理员通知：</b>\n \t [new_admin_notice]"))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set Admin Notice") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	GLOB.admin_notice = new_admin_notice
	return

/datum/admins/proc/toggleooc()
	set category = "-服务器-"
	set desc="切换场外聊天可用性"
	set name="切换场外聊天"
	toggle_ooc()
	log_admin("[key_name(usr)] toggled OOC.")
	message_admins("[key_name_admin(usr)] 切换了场外聊天可用性。")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle OOC", "[GLOB.ooc_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleoocdead()
	set category = "-服务器-"
	set desc="切换亡者场外聊天可用性"
	set name="切换亡者场外聊天"
	toggle_dooc()

	log_admin("[key_name(usr)] toggled OOC.")
	message_admins("[key_name_admin(usr)] 切换了亡者场外聊天可用性。")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Dead OOC", "[GLOB.dooc_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/startnow()
	set category = "-服务器-"
	set desc="立即开始回合"
	set name="立即开始"
	if(SSticker.current_state == GAME_STATE_PREGAME || SSticker.current_state == GAME_STATE_STARTUP)
		SSticker.start_immediately = TRUE
		log_admin("[usr.key] has started the game.")
		var/msg = ""
		if(SSticker.current_state == GAME_STATE_STARTUP)
			msg = " （服务器仍在初始化，回合将\
				尽快开始。）"
		message_admins("<font color='blue'>\
			[usr.key] 已开始游戏。[msg]</font>")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Start Now") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return 1
	else
		to_chat(usr, "<font color='red'>错误：无法立即开始，游戏已经开始。</font>")

	return 0

/datum/admins/proc/toggleenter()
	set category = "-服务器-"
	set desc="切换玩家能否进入游戏"
	set name="切换玩家入场"
	GLOB.enter_allowed = !( GLOB.enter_allowed )
	if (!( GLOB.enter_allowed ))
		to_chat(world, "<B>新玩家暂时无法进入游戏。</B>")
	else
		to_chat(world, "<B>新玩家现在可以进入游戏。</B>")
	log_admin("[key_name(usr)] toggled new player game entering.")
	message_admins(span_adminnotice("[key_name_admin(usr)] 切换了新玩家入场许可。"))
	world.update_status()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Entering", "[GLOB.enter_allowed ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleAI()
	set category = "-服务器-"
	set desc="切换玩家能否选择人工智能职业"
	set name="切换人工智能职业"
	set hidden = 1
	var/alai = CONFIG_GET(flag/allow_ai)
	CONFIG_SET(flag/allow_ai, !alai)
	if (alai)
		to_chat(world, "<B>人工智能职业暂时无法选择。</B>")
	else
		to_chat(world, "<B>人工智能职业现在可以选择。</B>")
	log_admin("[key_name(usr)] toggled AI allowed.")
	world.update_status()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle AI", "[!alai ? "Disabled" : "Enabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleaban()
	set category = "-服务器-"
	set desc="切换玩家能否重生"
	set name="切换重生许可"
	set hidden = 1
	var/new_nores = !CONFIG_GET(flag/norespawn)
	CONFIG_SET(flag/norespawn, new_nores)
	if (!new_nores)
		to_chat(world, "<B>现在可以重生。</B>")
	else
		to_chat(world, "<B>暂时无法重生 :(</B>")
	message_admins(span_adminnotice("[key_name_admin(usr)] 已[!new_nores ? "允许" : "禁止"]重生。"))
	log_admin("[key_name(usr)] toggled respawn to [!new_nores ? "On" : "Off"].")
	world.update_status()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Respawn", "[!new_nores ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/delay()
	set category = "-服务器-"
	set desc="推迟游戏开始时间"
	set name="推迟回合开始"

	var/newtime = input("设置新的等待时间，单位为秒。-1 表示无限期推迟。","设置延迟",round(SSticker.GetTimeLeft()/10)) as num|null
	if(SSticker.current_state > GAME_STATE_PREGAME)
		return alert("太晚了……游戏已经开始！")
	if(newtime)
		newtime = newtime*10
		SSticker.SetTimeLeft(newtime)
		if(newtime < 0)
			to_chat(world, "<b>游戏开始时间已推迟。</b>")
			log_admin("[key_name(usr)] delayed the round start.")
		else
			to_chat(world, "<b>游戏将在[DisplayTimeText(newtime)]后开始。</b>")
			SEND_SOUND(world, sound('sound/blank.ogg'))
			log_admin("[key_name(usr)] set the pre-game delay to [DisplayTimeText(newtime)].")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Delay Game Start") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/unprison(mob/M in GLOB.mob_list)
	set category = "-管理-"
	set name = "解除监禁"
	if (is_centcom_level(M.z))
		SSjob.SendToLateJoin(M)
		message_admins("[key_name_admin(usr)] 解除了对 [key_name_admin(M)] 的监禁")
		log_admin("[key_name(usr)] has unprisoned [key_name(M)]")
	else
		alert("[M.name] 未被监禁。")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Unprison") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

/datum/admins/proc/spawn_atom(object as text)
	set category = "-GameMaster-"
	set desc = ""
	set name = "生成..."

	if(!check_rights(R_SPAWN) || !object)
		return

	var/list/preparsed = splittext(object,":")
	var/path = preparsed[1]
	var/amount = 1
	if(preparsed.len > 1)
		amount = CLAMP(text2num(preparsed[2]),1,ADMIN_SPAWN_CAP)

	var/chosen = pick_closest_path(path)
	if(!chosen)
		return
	var/turf/T = get_turf(usr)

	if(ispath(chosen, /turf))
		T.ChangeTurf(chosen)
	else
		for(var/i in 1 to amount)
			var/atom/A = new chosen(T)
			A.flags_1 |= ADMIN_SPAWNED_1

	message_admins("[key_name(usr)][ADMIN_LOOKUPFLW(usr)] 在 [AREACOORD(usr)] 生成了 [amount] 个 [chosen]")
	log_admin("[key_name(usr)] spawned [amount] x [chosen] at [AREACOORD(usr)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Spawn Atom") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/podspawn_atom(object as text)
	set category = "调试"
	set desc = ""
	set name = "补给舱生成"

	if(!check_rights(R_SPAWN))
		return

	var/chosen = pick_closest_path(object)
	if(!chosen)
		return
	var/turf/T = get_turf(usr)

	if(ispath(chosen, /turf))
		T.ChangeTurf(chosen)
	else
		var/obj/structure/closet/supplypod/centcompod/pod = new()
		var/atom/A = new chosen(pod)
		A.flags_1 |= ADMIN_SPAWNED_1
		new /obj/effect/DPtarget(T, pod)

	log_admin("[key_name(usr)] pod-spawned [chosen] at [AREACOORD(usr)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Podspawn Atom") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/spawn_cargo(object as text)
	set category = "调试"
	set desc = ""
	set name = "生成货物"

	if(!check_rights(R_SPAWN))
		return

	var/chosen = pick_closest_path(object, make_types_fancy(subtypesof(/datum/supply_pack)))
	if(!chosen)
		return
	var/datum/supply_pack/S = new chosen
	S.admin_spawned = TRUE
	S.generate(get_turf(usr))

	log_admin("[key_name(usr)] spawned cargo pack [chosen] at [AREACOORD(usr)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Spawn Cargo") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/show_traitor_panel(mob/M in GLOB.mob_list)
	set category = "-管理-"
	set desc = ""
	set name = "显示叛徒面板"

	if(!istype(M))
		to_chat(usr, "只能对 /mob 类型的实例使用")
		return
	if(!M.mind)
		to_chat(usr, "该生物没有心智！")
		return

	M.mind.traitor_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Traitor Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/toggletintedweldhelmets()
	set category = "调试"
	set desc="佩戴焊接头盔时缩小视野范围"
	set name="切换焊接头盔视野遮蔽"
	GLOB.tinted_weldhelh = !( GLOB.tinted_weldhelh )
	if (GLOB.tinted_weldhelh)
		to_chat(world, "<B>已启用焊接头盔视野着色（tinted_weldhelh）！</B>")
	else
		to_chat(world, "<B>已关闭焊接头盔视野着色（tinted_weldhelh）！</B>")
	log_admin("[key_name(usr)] toggled tinted_weldhelh.")
	message_admins("[key_name_admin(usr)] 切换了焊接头盔视野遮蔽。")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Tinted Welding Helmets", "[GLOB.tinted_weldhelh ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleguests()
	set category = "-服务器-"
	set desc="切换游客能否进入游戏"
	set name="切换游客入场"
	set hidden = 1
	var/new_guest_ban = !CONFIG_GET(flag/guest_ban)
	CONFIG_SET(flag/guest_ban, new_guest_ban)
	if (new_guest_ban)
		to_chat(world, "<B>游客暂时无法进入游戏。</B>")
	else
		to_chat(world, "<B>游客现在可以进入游戏。</B>")
	log_admin("[key_name(usr)] toggled guests game entering [!new_guest_ban ? "" : "dis"]allowed.")
	message_admins(span_adminnotice("[key_name_admin(usr)] 已[!new_guest_ban ? "允许" : "禁止"]游客入场。"))
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Guests", "[!new_guest_ban ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/manage_free_slots()
	if(!check_rights())
		return
	var/datum/browser/browser = new(usr, "jobmanagement", "管理空闲名额", 520)
	var/list/dat = list()
	var/count = 0

	if(!SSjob.initialized)
		alert(usr, "职业子系统初始化前，无法管理职业！")
		return

	dat += "<table>"

	for(var/j in SSjob.occupations)
		var/datum/job/job = j
		count++
		var/J_title = html_encode(job.display_title || job.title)
		var/J_opPos = html_encode(job.total_positions - (job.total_positions - job.current_positions))
		var/J_totPos = html_encode(job.total_positions)
		dat += "<tr><td>[J_title]:</td> <td>[J_opPos]/[job.total_positions < 0 ? " （无限）" : J_totPos]"

		dat += "</td>"
		dat += "<td>"
		if(job.total_positions >= 0)
			dat += "<A href='?src=[REF(src)];[HrefToken()];customjobslot=[job.title]'>自定义</A> | "
			dat += "<A href='?src=[REF(src)];[HrefToken()];addjobslot=[job.title]'>增加 1</A> | "
			if(job.total_positions > job.current_positions)
				dat += "<A href='?src=[REF(src)];[HrefToken()];removejobslot=[job.title]'>减少</A> | "
			else
				dat += "减少 | "
			dat += "<A href='?src=[REF(src)];[HrefToken()];unlimitjobslot=[job.title]'>取消上限</A></td>"
		else
			dat += "<A href='?src=[REF(src)];[HrefToken()];limitjobslot=[job.title]'>设置上限</A></td>"

	browser.height = min(100 + count * 20, 650)
	browser.set_content(dat.Join())
	browser.open()

/datum/admins/proc/create_or_modify_area()
	set category = "调试"
	set name = "创建或修改区域"
	create_area(usr)

//
//
//ALL DONE
//*********************************************************************************************************
//TO-DO:
//
//

//RIP ferry snowflakes

//Kicks all the clients currently in the lobby. The second parameter (kick_only_afk) determins if an is_afk() check is ran, or if all clients are kicked
//defaults to kicking everyone (afk + non afk clients in the lobby)
//returns a list of ckeys of the kicked clients
/proc/kick_clients_in_lobby(message, kick_only_afk = 0)
	var/list/kicked_client_names = list()
	for(var/client/C in GLOB.clients)
		if(isnewplayer(C.mob))
			if(kick_only_afk && !C.is_afk()) //Ignore clients who are not afk
				continue
			if(message)
				to_chat(C, message)
			kicked_client_names.Add("[C.key]")
			qdel(C)
	return kicked_client_names

//returns 1 to let the dragdrop code know we are trapping this event
//returns 0 if we don't plan to trap the event
/datum/admins/proc/cmd_ghost_drag(mob/dead/observer/frommob, mob/tomob)

	//this is the exact two check rights checks required to edit a ckey with vv.
	if (!check_rights(R_VAREDIT,0) || !check_rights(R_SPAWN|R_DEBUG,0))
		return 0

	if (!frommob.ckey)
		return 0

	var/question = ""
	if (tomob.ckey)
		question = "该生物已由玩家 ([tomob.key]) 控制！"
	question += "确定要让 [frommob.name]([frommob.key]) 控制 [tomob.name] 吗？"

	var/ask = alert(question, "让幽灵控制生物？", "是", "否")
	if (ask != "是")
		return 1

	if (!frommob || !tomob) //make sure the mobs don't go away while we waited for a response
		return 1

	tomob.ghostize(0)

	message_admins(span_adminnotice("[key_name_admin(usr)] 让 [frommob.key] 控制了 [tomob.name]。"))
	log_admin("[key_name(usr)] stuffed [frommob.key] into [tomob.name].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Ghost Drag Control")

	tomob.ckey = frommob.ckey
	qdel(frommob)

	return 1

/client/proc/adminGreet(logout)
	if(SSticker.HasRoundStarted())
		var/string
		if(logout && CONFIG_GET(flag/announce_admin_logout))
			string = pick(
				"管理员离线：[key_name(src)]")
		else if(!logout && CONFIG_GET(flag/announce_admin_login) && (prefs.toggles & ANNOUNCE_LOGIN))
			string = pick(
				"管理员上线：[key_name(src)]")
		if(string)
			message_admins("[string]")


/client/proc/returntolobby()
	set category = "-特殊指令-"
	set name = "返回大厅"

	var/mob/living/carbon/human/H = mob
	H.admin_send_back_to_lobby(usr)


/mob/living/carbon/human/proc/admin_send_back_to_lobby(mob/admin, delete_character = FALSE)
	var/datum/job/mob_job
	var/target_job = SSrole_class_handler.get_advclass_by_name(advjob)
	var/player_key = key ? key : mind?.key
	if(mind)
		mob_job = SSjob.GetJob(mind.assigned_role)
		if(mob_job)
			mob_job.current_positions = max(0, mob_job.current_positions - 1)
		if(target_job)
			SSrole_class_handler.adjust_class_amount(target_job, -1)
		mind.unknow_all_people()
		for(var/datum/mind/MF in get_minds())
			mind.become_unknown_to(MF)
		for(var/datum/bounty/removing_bounty in GLOB.head_bounties)
			if(removing_bounty.target == real_name)
				GLOB.head_bounties -= removing_bounty
	else if(admin)
		to_chat(admin, span_warning("目标没有心智！"))
	GLOB.chosen_names -= real_name
	if(!mob_job)
		LAZYREMOVE(GLOB.actors_list[SSjob.bitflag_to_department(WANDERERS, FALSE)], mobid)
	else
		LAZYREMOVE(GLOB.actors_list[SSjob.bitflag_to_department(mob_job.department_flag, mob_job.obsfuscated_job)], mobid)
	LAZYREMOVE(GLOB.roleplay_ads, mobid)
	if(client)
		SSdroning.kill_droning(client)
		SSdroning.kill_loop(client)
		SSdroning.kill_rain(client)
	if(player_key)
		var/mob/dead/new_player/NP = new()
		NP.key = player_key
	else if(admin)
		to_chat(admin, span_warning("[src] 没有关联账号，无法返回大厅。"))
	if(delete_character)
		qdel(src)
	return TRUE


/datum/admins/proc/sleep_view()
	set name = "视野内生物入睡"
	set category = "-GameMaster-"
	set hidden = FALSE

	if(!check_rights(R_ADMIN))
		return

	if(alert("这会使视野内所有生物入睡。确定吗？",,"是","取消") == "取消")
		return
	for(var/mob/living/M in view(usr.client))
		M.SetSleeping(999999)

	message_admins("[key_name(usr)] 使用了视野内生物入睡指令。")

/datum/admins/proc/wake_view()
	set name = "唤醒视野内生物"
	set category = "-GameMaster-"
	set hidden = FALSE

	if(!check_rights(R_ADMIN))
		return

	if(alert("这会唤醒视野内所有生物。确定吗？",,"是","取消") == "取消")
		return
	for(var/mob/living/M in view(usr.client))
		var/S = M.IsSleeping()
		if(S)
			M.remove_status_effect(S)
			M.set_resting(FALSE, TRUE)

	message_admins("[key_name(usr)] 使用了唤醒视野内生物指令。")

GLOBAL_VAR_INIT(extend_round_timestamp, 0)
/datum/admins/proc/extend_round()
	set name = "延长回合"
	set category = "-服务器-"
	set hidden = FALSE

	if(!check_rights(R_ADMIN))
		return

	if(alert("将回合结束时间推迟 30 分钟。这会推迟投票，或在投票通过后推迟回合结束。确定吗？",,"是","取消") == "取消")
		return

	if(world.time < GLOB.extend_round_timestamp + (1 MINUTES))
		to_chat(usr, "<span class='notice'>刚有人按过这个按钮！请等待一分钟再按。</span>")
		return

	if((GLOB.round_timer > world.time + (3 * ROUND_EXTENSION_TIME)) || SSgamemode.round_ends_at - world.time > (3 * ROUND_EXTENSION_TIME))
		to_chat(usr, "<span class='notice'>保护机制：回合剩余时间已超过延长时长的三倍！忽略本次操作。</span>")
		return
	if(SSgamemode.round_ends_at != 0) // End round is already ticking.
		SSgamemode.round_ends_at += ROUND_EXTENSION_TIME
	else //We push back the automated endround vote.
		GLOB.round_timer = GLOB.round_timer + ROUND_EXTENSION_TIME
	log_admin("[key_name(usr)] extended the round by 30 minutes.")
	message_admins("[key_name(usr)] 将回合延长了 30 分钟。")
	GLOB.extend_round_timestamp = world.time
