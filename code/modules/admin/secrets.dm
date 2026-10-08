/datum/admins/proc/Secrets()
	if(!check_rights(0))
		return

	var/list/dat = list("<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><B>滥用管理权限的第一条规矩：绝口不提滥用管理权限。</B><HR>")

	dat +={"
			<B>通用秘密功能</B><BR>
			<BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=admin_log'>管理日志</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=show_admins'>查看管理员列表</A><BR>
			<BR>
			"}

	if(check_rights(R_ADMIN,0))
		dat += {"
			<B>管理秘密功能</B><BR>
			<BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=clear_virus'>治愈当前所有疾病</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=list_bombers'>爆炸记录</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=list_signalers'>查看最近 [length(GLOB.lastsignalers)] 条信号记录</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=list_lawchanges'>查看最近 [length(GLOB.lawchanges)] 次法则变更</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=showailaws'>查看 AI 法则</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=showgm'>查看游戏模式</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=manifest'>查看人员名单</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=DNA'>列出血液 DNA</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=fingerprints'>列出指纹</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=ctfbutton'>启用/禁用夺旗模式</A><BR><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=tdomereset'>将雷霆竞技场恢复为默认状态</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=set_name'>修改空间站名称</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=reset_name'>重置空间站名称</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=night_shift_set'>设置夜班模式</A><BR>
			<BR>
			<B>穿梭机</B><BR>
			<BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=moveferry'>移动渡船</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=togglearrivals'>切换抵达渡船</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=moveminingshuttle'>移动采矿穿梭机</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=movelaborshuttle'>移动劳工穿梭机</A><BR>
			<BR>
			"}

	if(check_rights(R_FUN,0))
		dat += {"
			<B>趣味秘密功能</B><BR>
			<BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=monkey'>将所有人类变为猴子</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=anime'>中国动画</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=allspecies'>改变所有人类的种族</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=power'>为所有区域供电</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=unpower'>切断所有区域供电</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=quickpower'>为所有 SMES 充电</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=tripleAI'>三重 AI 模式（需在大厅阶段使用）</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=traitor_all'>人人都是叛徒</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=guns'>召唤枪械</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=magic'>召唤魔法</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=events'>召唤事件（开关）</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=onlyone'>只能有一人活下来！</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=delayed_onlyone'>只能有一人活下来！（延迟 40 秒）</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=eagles'>平等主义空间站模式</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=ancap'>无政府资本主义空间站模式</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=blackout'>破坏所有灯具</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=whiteout'>修复所有灯具</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=floorlava'>地板是熔岩！（危险：极其无聊）</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=customportal'>生成自定义传送门风暴</A><BR>
			<BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=changebombcap'>修改爆炸范围上限</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=masspurrbation'>全员猫化</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=massremovepurrbation'>解除全员猫化</A><BR>
			"}

	dat += "<BR>"

	if(check_rights(R_DEBUG,0))
		dat += {"
			<B>提升安保等级</B><BR>
			<BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=maint_access_engiebrig'>将所有维护门限制为工程/禁闭室权限</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=maint_access_brig'>将所有维护门限制为禁闭室权限</A><BR>
			<A href='?src=[REF(src)];[HrefToken()];secrets=infinite_sec'>移除安保人员名额上限</A><BR>
			<BR>
			"}

	usr << browse(dat.Join(), "window=secrets")
	return





/datum/admins/proc/Secrets_topic(item,href_list)
	var/datum/round_event/E
	var/ok = 0
	switch(item)
		if("admin_log")
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><B>管理日志<HR></B>"
			for(var/l in GLOB.admin_log)
				dat += "<li>[l]</li>"
			if(!GLOB.admin_log.len)
				dat += "本回合还没有管理操作！"
			usr << browse(dat, "window=admin_log")

		if("show_admins")
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><B>当前管理员：</B><HR>"
			if(GLOB.admin_datums)
				for(var/ckey in GLOB.admin_datums)
					var/datum/admins/D = GLOB.admin_datums[ckey]
					dat += "[ckey] - [D.rank.name]<br>"
				usr << browse(dat, "window=showadmins;size=600x500")
		if("set_name")
			if(!check_rights(R_ADMIN))
				return
			var/new_name = input(usr, "请输入空间站的新名称。", "重命名", "") as text|null
			if(!new_name)
				return
			set_station_name(new_name)
			log_admin("[key_name(usr)] renamed the station to \"[new_name]\".")
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] 将空间站重命名为：[new_name]。</span>")
			priority_announce("[command_name()] 将空间站重命名为\"[new_name]\"。")
		if("night_shift_set")
			if(!check_rights(R_ADMIN))
				return
			var/val = alert(usr, "将夜班模式设为什么？此设置会覆盖自动系统，直到重新设为自动。", "夜班模式", "开启", "关闭", "自动")
			switch(val)
				if("自动")
					if(CONFIG_GET(flag/enable_night_shifts))
						SSnightshift.can_fire = TRUE
						SSnightshift.fire()
					else
						SSnightshift.update_nightshift(FALSE, TRUE)
				if("开启")
					SSnightshift.can_fire = FALSE
					SSnightshift.update_nightshift(TRUE, TRUE)
				if("关闭")
					SSnightshift.can_fire = FALSE
					SSnightshift.update_nightshift(FALSE, TRUE)

		if("reset_name")
			if(!check_rights(R_ADMIN))
				return
			var/new_name = new_station_name()
			set_station_name(new_name)
			log_admin("[key_name(usr)] reset the station name.")
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] 重置了空间站名称。</span>")
			priority_announce("[command_name()] 将空间站重命名为\"[new_name]\"。")

		if("list_bombers")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><B>爆炸记录</B><HR>"
			for(var/l in GLOB.bombers)
				dat += text("[l]<BR>")
			usr << browse(dat, "window=bombers")

		if("list_signalers")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><B>最近 [length(GLOB.lastsignalers)] 条信号记录。</B><HR>"
			for(var/sig in GLOB.lastsignalers)
				dat += "[sig]<BR>"
			usr << browse(dat, "window=lastsignalers;size=800x500")

		if("list_lawchanges")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><B>最近 [length(GLOB.lawchanges)] 次法则变更。</B><HR>"
			for(var/sig in GLOB.lawchanges)
				dat += "[sig]<BR>"
			usr << browse(dat, "window=lawchanges;size=800x500")
		if("showgm")
			if(!check_rights(R_ADMIN))
				return
			if(!SSticker.HasRoundStarted())
				alert("游戏尚未开始！")
			else
				alert("游戏模式为故事讲述者")
		if("manifest")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><B>人员名单。</B><HR>"
			dat += "<table cellspacing=5><tr><th>姓名</th><th>职位</th></tr>"
			for(var/datum/data/record/t in GLOB.data_core.general)
				dat += "<tr><td>[t.fields["name"]]</td><td>[t.fields["rank"]]</td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=manifest;size=440x410")
		if("DNA")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><B>血液 DNA 列表。</B><HR>"
			dat += "<table cellspacing=5><tr><th>姓名</th><th>DNA</th><th>血型</th></tr>"
			for(var/i in GLOB.human_list)
				var/mob/living/carbon/human/H = i
				if(H.ckey)
					dat += "<tr><td>[H]</td><td>[H.dna.unique_enzymes]</td><td>[H.dna.blood_type]</td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=DNA;size=440x410")
		if("fingerprints")
			if(!check_rights(R_ADMIN))
				return
			var/dat = "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><B>指纹列表。</B><HR>"
			dat += "<table cellspacing=5><tr><th>姓名</th><th>指纹</th></tr>"
			for(var/i in GLOB.human_list)
				var/mob/living/carbon/human/H = i
				if(H.ckey)
					dat += "<tr><td>[H]</td><td>[md5(H.dna.uni_identity)]</td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=fingerprints;size=440x410")

		if("allspecies")
			if(!check_rights(R_FUN))
				return
			var/result = input(usr, "请选择新的种族","种族") as null|anything in GLOB.species_list
			if(result)
				SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Mass Species Change", "[result]"))
				log_admin("[key_name(usr)] turned all humans into [result]", 1)
				message_admins("\blue [key_name_admin(usr)] 将所有人类变为 [result]")
				var/newtype = GLOB.species_list[result]
				for(var/i in GLOB.human_list)
					var/mob/living/carbon/human/H = i
					H.set_species(newtype)

		if("traitor_all")
			if(!check_rights(R_FUN))
				return
			if(!SSticker.HasRoundStarted())
				alert("游戏尚未开始！")
				return
			var/objective = copytext(sanitize(input("输入目标")),1,MAX_MESSAGE_LEN)
			if(!objective)
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Traitor All", "[objective]"))
			for(var/mob/living/H in GLOB.player_list)
				if(H.stat == DEAD || !H.mind)
					continue
				if(is_special_character(H))
					continue
				var/datum/antagonist/traitor/T = new()
				T.give_objectives = FALSE
				var/datum/objective/new_objective = new
				new_objective.owner = H
				new_objective.explanation_text = objective
				T.add_objective(new_objective)
				H.mind.add_antag_datum(T)
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] 启用了人人都是叛徒。目标为：[objective]</span>")
			log_admin("[key_name(usr)] used everyone is a traitor secret. Objective is [objective]")

		if("changebombcap")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Bomb Cap"))

			var/newBombCap = input(usr,"设置新的爆炸范围上限（输入轻度破坏半径，即常见 (1,2,3) 表示法中的第三个数值；必须大于 4）", "爆炸范围上限", GLOB.MAX_EX_LIGHT_RANGE) as num|null
			if (!CONFIG_SET(number/bombcap, newBombCap))
				return

			message_admins("<span class='boldannounce'>[key_name_admin(usr)] 将爆炸范围上限改为 [GLOB.MAX_EX_DEVESTATION_RANGE], [GLOB.MAX_EX_HEAVY_RANGE], [GLOB.MAX_EX_LIGHT_RANGE]</span>")
			log_admin("[key_name(usr)] changed the bomb cap to [GLOB.MAX_EX_DEVESTATION_RANGE], [GLOB.MAX_EX_HEAVY_RANGE], [GLOB.MAX_EX_LIGHT_RANGE]")

		if("blackout")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Break All Lights"))
			message_admins("[key_name_admin(usr)] 破坏了所有灯具")
			for(var/obj/machinery/light/L in GLOB.machines)
				L.break_light_tube()

		if("whiteout")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Fix All Lights"))
			message_admins("[key_name_admin(usr)] 修复了所有灯具")
			for(var/obj/machinery/light/L in GLOB.machines)
				L.fix()

		if("floorlava")
			SSweather.run_weather(/datum/weather/floor_is_lava)

		if("dorf")
			if(!check_rights(R_FUN))
				return
			SSblackbox.record_feedback("nested tally", "admin_secrets_fun_used", 1, list("Dwarf Beards"))
			for(var/i in GLOB.human_list)
				var/mob/living/carbon/human/B = i
				B.facial_hairstyle = "Dward Beard"
				B.update_hair()
			message_admins("[key_name_admin(usr)] 启用了矮人胡须模式")

	if(E)
		E.processing = FALSE
		if(E.announceWhen>0)
			switch(alert(usr, "是否向玩家发布事件预警？", "预警", "是", "否", "取消"))
				if("是")
					E.announceChance = 100
				if("取消")
					E.kill()
					return
				if("否")
					E.announceChance = 0
		E.processing = TRUE
	if (usr)
		log_admin("[key_name(usr)] used secret [item]")
		if (ok)
			to_chat(world, text("<B>[] 启用了秘密功能！</B>", usr.key))

/proc/portalAnnounce(announcement, playlightning)
	set waitfor = 0
	if (playlightning)
		sound_to_playing_players('sound/blank.ogg')
		sleep(80)
	priority_announce(replacetext(announcement, "%STATION%", station_name()))
	if (playlightning)
		sleep(20)
		sound_to_playing_players('sound/blank.ogg')

/proc/doPortalSpawn(turf/loc, mobtype, numtospawn, portal_appearance, players, humanoutfit)
	for (var/i in 1 to numtospawn)
		var/mob/spawnedMob = new mobtype(loc)
		if (length(players))
			var/mob/chosen = players[1]
			if (chosen.client)
				chosen.client.prefs.copy_to(spawnedMob)
				spawnedMob.key = chosen.key
			players -= chosen
		if (ishuman(spawnedMob) && ispath(humanoutfit, /datum/outfit))
			var/mob/living/carbon/human/H = spawnedMob
			H.equipOutfit(humanoutfit)
	var/turf/T = get_step(loc, SOUTHWEST)
	flick_overlay_static(portal_appearance, T, 15)
	playsound(T, 'sound/blank.ogg', rand(80, 100), TRUE)
