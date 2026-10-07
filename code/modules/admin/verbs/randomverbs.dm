/client/proc/cmd_admin_drop_everything(mob/M in GLOB.mob_list)
	set category = null
	set name = "丢下所有物品"
	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "让 [M] 丢下所有物品吗？", "消息", "是", "否")
	if(confirm != "是")
		return

	for(var/obj/item/W in M)
		if(!M.dropItemToGround(W))
			qdel(W)
			M.regenerate_icons()

	log_admin("[key_name(usr)] made [key_name(M)] drop everything!")
	var/msg = "[key_name_admin(usr)] 让 [ADMIN_LOOKUPFLW(M)] 丢下了所有物品！"
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Drop Everything") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_subtle_message(mob/M in GLOB.mob_list)
	set category = "-特殊指令-"
	set name = "心声私信"

	if(!ismob(M))
		return
	if(!check_rights(R_ADMIN))
		return

	message_admins("[key_name_admin(src)] 开始回应 [ADMIN_LOOKUPFLW(M)] 的祈祷。")
	var/msg = input("消息：", text("向 [M.key] 传递心声")) as text|null

	if(!msg)
		message_admins("[key_name_admin(src)] 决定不回应 [ADMIN_LOOKUPFLW(M)] 的祈祷")
		return
	if(usr)
		if (usr.client)
			if(usr.client.holder)
				to_chat(M, "<i>我的脑海中响起一个声音……\n<b>[msg]</i></b>")

	log_admin("SubtlePM: [key_name(usr)] -> [key_name(M)] : [msg]")
	msg = span_adminnotice("<b> 心声私信：[key_name_admin(usr)] -> [key_name_admin(M)] :</b> [msg]")
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Subtle Message") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_mod_antag_rep(client/C in GLOB.clients, operation)
	set category = "-特殊指令-"
	set name = "修改反派声望"

	if(!check_rights(R_ADMIN))
		return

	var/msg = ""
	var/log_text = ""

	if(operation == "zero")
		log_text = "Set to 0"
		SSpersistence.antag_rep -= C.ckey
	else
		var/prompt = "请输入要[operation == "add" ? "增加" : operation == "subtract" ? "扣除" : operation]的声望数值："

		if(operation == "set")
			prompt = "请输入新的声望数值："

		msg = input("消息：", prompt) as num|null

		if (!msg)
			return

		var/ANTAG_REP_MAXIMUM = CONFIG_GET(number/antag_rep_maximum)

		if(operation == "set")
			log_text = "设为 [num2text(msg)]"
			SSpersistence.antag_rep[C.ckey] = max(0, min(msg, ANTAG_REP_MAXIMUM))
		else if(operation == "add")
			log_text = "增加 [num2text(msg)]"
			SSpersistence.antag_rep[C.ckey] = min(SSpersistence.antag_rep[C.ckey]+msg, ANTAG_REP_MAXIMUM)
		else if(operation == "subtract")
			log_text = "扣除 [num2text(msg)]"
			SSpersistence.antag_rep[C.ckey] = max(SSpersistence.antag_rep[C.ckey]-msg, 0)
		else
			to_chat(src, "反派声望修改操作无效：[operation]，操作者：[key_name(usr)]")
			return

		if(SSpersistence.antag_rep[C.ckey] <= 0)
			SSpersistence.antag_rep -= C.ckey

	log_admin("[key_name(usr)]: Modified [key_name(C)]'s antagonist reputation [log_text]")
	message_admins(span_adminnotice("[key_name_admin(usr)] 修改了 [key_name(C)] 的反派声望（[log_text]）"))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Modify Antagonist Reputation") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_mod_triumphs(mob/M in GLOB.mob_list, operation)
	set category = "-特殊指令-"
	set name = "调整凯旋点..."

	if(!check_rights(R_ADMIN))
		return

	var/msg = ""
	var/log_text = ""
	var/old_triumphs = M.get_triumphs()

	var/prompt = "请输入要增加或扣除的凯旋点："

	msg = input("消息：", prompt) as num|null

	if (!msg)
		return

	M.adjust_triumphs(msg)
	log_text = "by [msg], from [old_triumphs] to [old_triumphs + msg]"

	log_admin("[key_name(usr)]: Modified [M.ckey]'s Triumphs [log_text]")
	message_admins(span_adminnotice("[key_name_admin(usr)] 将 [M.ckey] 的凯旋点从 [old_triumphs] 调整为 [old_triumphs + msg]（变动：[msg]）"))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Modify Triumphs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_mod_pq(mob/M in GLOB.mob_list, operation)
	set category = "-特殊指令-"
	set name = "调整玩家质量分（PQ）"
	set hidden = 1

	if(!check_rights(R_ADMIN))
		return

	var/amt = ""
	var/reason = ""
	var/prompt = "请输入要增加或扣除的玩家质量分（PQ）："

	amt = input("消息：", prompt) as num|null

	if(!amt)
		return

	prompt = "请说明调整原因："
	reason = input("消息：", prompt) as text|null
	if(!reason)
		reason = "玩家面板调整"

	adjust_playerquality(amt, M.ckey, usr, reason)

	//Admin log happens in child proc
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Modify Player Quality") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_world_narrate()
	set category = "-特殊指令-"
	set name = "旁白 - 全域"

	if(!check_rights(R_ADMIN))
		return

	var/msg = input("消息：", text("输入要向所有人显示的文字：")) as text|null

	if (!msg)
		return
	to_chat(world, "[msg]")
	log_admin("GlobalNarrate: [key_name(usr)] : [msg]")
	message_admins(span_adminnotice("[key_name_admin(usr)] 发送了全域旁白"))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Global Narrate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_direct_narrate(mob/M)
	set category = "-特殊指令-"
	set name = "旁白 - 指定目标"

	if(!check_rights(R_ADMIN))
		return

	if(!M)
		M = input("向谁发送旁白？", "在线玩家") as null|anything in GLOB.player_list

	if(!M)
		return

	var/msg = input("消息：", text("输入要向目标显示的文字：")) as text|null

	if( !msg )
		return

	to_chat(M, msg)
	log_admin("DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]")
	msg = span_adminnotice("<b> 指定目标旁白：[key_name(usr)] 发给 ([M.name]/[M.key]):</b> [msg]<BR>")
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Direct Narrate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_local_narrate(atom/A)
	set category = "-特殊指令-"
	set name = "旁白 - 附近"

	if(!check_rights(R_ADMIN))
		return
	if(!A)
		return
	var/range = input("范围：", "向多少格内的生物发送旁白：", 7) as num|null
	if(!range)
		return
	var/msg = input("消息：", text("输入要向视野内所有人显示的文字：")) as text|null
	if (!msg)
		return
	for(var/mob/M in view(range,A))
		to_chat(M, msg)

	log_admin("LocalNarrate: [key_name(usr)] at [AREACOORD(A)]: [msg]")
	message_admins(span_adminnotice("<b> 附近旁白：[key_name_admin(usr)] 在 [ADMIN_VERBOSEJMP(A)]:</b> [msg]<BR>"))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Local Narrate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_godmode(mob/M in GLOB.mob_list)
	set category = "-特殊指令-"
	set name = "无敌模式"
	if(!check_rights(R_ADMIN))
		return

	M.status_flags ^= GODMODE
	to_chat(usr, span_adminnotice("已[(M.status_flags & GODMODE) ? "开启" : "关闭"]"))

	log_admin("[key_name(usr)] has toggled [key_name(M)]'s nodamage to [(M.status_flags & GODMODE) ? "On" : "Off"]")
	var/msg = "[key_name_admin(usr)] 已为 [ADMIN_LOOKUPFLW(M)][(M.status_flags & GODMODE) ? "开启" : "关闭"]免伤"
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Godmode", "[M.status_flags & GODMODE ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/proc/cmd_admin_mute(whom, mute_type, automute = 0)
	if(!whom)
		return

	var/muteunmute
	var/mute_string
	var/feedback_string
	switch(mute_type)
		if(MUTE_IC)
			mute_string = "IC (say and emote)"
			feedback_string = "IC"
		if(MUTE_OOC)
			mute_string = "OOC"
			feedback_string = "OOC"
		if(MUTE_LOOC)
			mute_string = "LOOC"
			feedback_string = "LOOC"
		if(MUTE_SLOOC)
			mute_string = "SLOOC"
			feedback_string = "SLOOC"
		if(MUTE_PRAY)
			mute_string = "pray"
			feedback_string = "Pray"
		if(MUTE_ADMINHELP)
			mute_string = "adminhelp, admin PM and ASAY"
			feedback_string = "Adminhelp"
		if(MUTE_DEADCHAT)
			mute_string = "deadchat and DSAY"
			feedback_string = "Deadchat"
		if(MUTE_ALL)
			mute_string = "everything"
			feedback_string = "Everything"
		else
			return

	var/client/C
	if(istype(whom, /client))
		C = whom
	else if(istext(whom))
		C = GLOB.directory[whom]
	else
		return

	var/datum/preferences/P
	if(C)
		P = C.prefs
	else
		P = GLOB.preferences_datums[whom]
	if(!P)
		return

	if(automute)
		if(!CONFIG_GET(flag/automute_on))
			return
	else
		if(!check_rights())
			return

	if(automute)
		muteunmute = "auto-muted"
		P.muted |= mute_type
		log_admin("SPAM AUTOMUTE: [muteunmute] [key_name(whom)] from [mute_string]")
		message_admins("防刷屏自动禁言：已禁言 [key_name_admin(whom)]，频道：[list("IC (say and emote)" = "角色内（发言与表情动作）", "pray" = "祈祷", "adminhelp, admin PM and ASAY" = "管理员求助、私信与聊天", "deadchat and DSAY" = "亡者聊天", "everything" = "所有频道")[mute_string] || mute_string]。")
		if(C)
			to_chat(C, "防刷屏系统已将你自动禁言，频道：[list("IC (say and emote)" = "角色内（发言与表情动作）", "pray" = "祈祷", "adminhelp, admin PM and ASAY" = "管理员求助、私信与聊天", "deadchat and DSAY" = "亡者聊天", "everything" = "所有频道")[mute_string] || mute_string]。请联系管理员。")
		SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Auto Mute [feedback_string]", "1")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return

	if(P.muted & mute_type)
		muteunmute = "unmuted"
		P.muted &= ~mute_type
	else
		muteunmute = "muted"
		P.muted |= mute_type

	log_admin("[key_name(usr)] has [muteunmute] [key_name(whom)] from [mute_string]")
	message_admins("[key_name_admin(usr)] 已对 [key_name_admin(whom)][muteunmute == "unmuted" ? "解除禁言" : "实施禁言"]，频道：[list("IC (say and emote)" = "角色内（发言与表情动作）", "pray" = "祈祷", "adminhelp, admin PM and ASAY" = "管理员求助、私信与聊天", "deadchat and DSAY" = "亡者聊天", "everything" = "所有频道")[mute_string] || mute_string]。")
	if(C)
		to_chat(C, "[key_name(usr, include_name = FALSE)]已对你[ muteunmute == "unmuted" ? "解除禁言" : "实施禁言"]，频道：[list("IC (say and emote)" = "角色内（发言与表情动作）", "pray" = "祈祷", "adminhelp, admin PM and ASAY" = "管理员求助、私信与聊天", "deadchat and DSAY" = "亡者聊天", "everything" = "所有频道")[mute_string] || mute_string]。")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Mute [feedback_string]", "[P.muted & mute_type]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/*
If a guy was gibbed and you want to revive him, this is a good way to do so.
Works kind of like entering the game with a new character. Character receives a new mind if they didn't have one.
Traitors and the like can also be revived with the previous role mostly intact.
/N */
/client/proc/respawn_character()
	set category = "调试"
	set name = "重生角色"
	set desc = ""
	if(!check_rights(R_ADMIN))
		return

	var/input = ckey(input(src, "请指定要重生的账号。", "账号", ""))
	if(!input)
		return

	var/mob/dead/observer/G_found
	for(var/mob/dead/observer/G in GLOB.player_list)
		if(G.ckey == input)
			G_found = G
			break

	if(!G_found)//If a ghost was not found.
		to_chat(usr, "<font color='red'>游戏中没有该在线账号，或该玩家当前不是幽灵。</font>")
		return

	//Ok, it's not a xeno or a monkey. So, spawn a human.
	var/mob/living/carbon/human/new_character = new//The mob being spawned.
	SSjob.SendToLateJoin(new_character)

	var/datum/data/record/record_found			//Referenced to later to either randomize or not randomize the character.
	if(G_found.mind && !G_found.mind.active)	//mind isn't currently in use by someone/something
		/*Try and locate a record for the person being respawned through GLOB.data_core.
		This isn't an exact science but it does the trick more often than not.*/
		var/id = md5("[G_found.real_name][G_found.mind.assigned_role]")

		record_found = find_record("id", id, GLOB.data_core.locked)

	if(record_found)//If they have a record we can determine a few things.
		new_character.real_name = record_found.fields["name"]
		new_character.gender = record_found.fields["gender"]
		new_character.age = record_found.fields["age"]
		new_character.hardset_dna(record_found.fields["identity"], record_found.fields["enzymes"], record_found.fields["name"], record_found.fields["blood_type"], new record_found.fields["species"], record_found.fields["features"])
	else
		var/datum/preferences/A = new()
		A.copy_to(new_character)
		A.real_name = G_found.real_name
		new_character.dna.update_dna_identity()

	new_character.name = new_character.real_name

	if(G_found.mind && !G_found.mind.active)
		G_found.mind.transfer_to(new_character)	//be careful when doing stuff like this! I've already checked the mind isn't in use
	else
		new_character.mind_initialize()
	if(!new_character.mind.assigned_role)
		new_character.mind.assigned_role = "Adventurer"//If they somehow got a null assigned role.

	new_character.key = G_found.key

	/*
	The code below functions with the assumption that the mob is already a traitor if they have a special role.
	So all it does is re-equip the mob with powers and/or items. Or not, if they have no special role.
	If they don't have a mind, they obviously don't have a special role.
	*/

	//Two variables to properly announce later on.
	var/admin = key_name_admin(src)
	var/player_key = G_found.key

	//Now for special roles and equipment.
	var/datum/antagonist/traitor/traitordatum = new_character.mind.has_antag_datum(/datum/antagonist/traitor)
	if(traitordatum)
		SSjob.EquipRank(new_character, new_character.mind.assigned_role, 1)
		traitordatum.equip()


	SSjob.EquipRank(new_character, new_character.mind.assigned_role, 1)//Or we simply equip them.

	var/msg = span_adminnotice("[admin] 让 [player_key] 以 [new_character.real_name] 的身份重生。")
	message_admins(msg)
	admin_ticket_log(new_character, msg)

	to_chat(new_character, "你已完全重生。祝你游戏愉快。")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Respawn Character") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return new_character

/client/proc/cmd_admin_rejuvenate(mob/living/M in GLOB.mob_list)
	set category = "-特殊指令-"
	set name = "完全治疗与复活"

	if(!check_rights(R_ADMIN))
		return

	if(!mob)
		return
	if(!istype(M))
		alert("无法复活幽灵")
		return
	M.revive(full_heal = TRUE, admin_revive = TRUE)

	log_admin("[key_name(usr)] healed / revived [key_name(M)]")
	var/msg = span_danger("管理员 [key_name_admin(usr)] 治愈／复活了 [ADMIN_LOOKUPFLW(M)]！")
	message_admins(msg)
	// Friendlier ticket-log line for the player
	admin_ticket_log(M, "<font color='green'>[key_name_admin(usr)]已针对此次求助为你完全治疗。</font>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Rejuvinate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/admin_spawn_cake(mob/living/M in GLOB.mob_list)
	set category = "-主持-"
	set name = "赠送蛋糕切片"

	if(!check_rights(R_ADMIN))
		return
	if(!M)
		return

	var/turf/T = get_turf(M)
	if(!T)
		return

	var/list/cake_types = list(
		/obj/item/reagent_containers/food/snacks/rogue/cakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/frostedcakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/applecakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/applenutcakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/berrycakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/blackberrycakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/carrotcakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/lemoncakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/limecakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/menthacakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/peacecakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/raspberrycakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/rocknutcakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/strawberrycakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/tangerinecakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/hcakeslice,
		/obj/item/reagent_containers/food/snacks/rogue/ccakeslice,
	)
	var/cake_type = pick(cake_types)
	new cake_type(T)

	log_admin("[key_name(usr)] gave a cake slice ([cake_type]) to [key_name(M)].")
	var/msg = span_adminnotice("[key_name_admin(usr)] 送给 [ADMIN_LOOKUPFLW(M)] 一块蛋糕。")
	message_admins(msg)
	// Tell the player (and ticket) in a friendly way
	to_chat(M, span_notice("[key_name_admin(usr)]送了你一块蛋糕。真好！"))
	admin_ticket_log(M, "<font color='green'>[key_name_admin(usr)]送了你一块蛋糕。真好！</font>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Give Cake Slice") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_create_centcom_report()
	set category = "-服务器-"
	set name = "创建指挥部报告"

	if(!check_rights(R_ADMIN))
		return

	var/input = input(usr, "输入指挥部报告，确保符合角色内语境。", "报告内容", "") as message|null
	if(!input)
		return

	var/confirm = alert(src, "要向全体成员公告报告内容吗？", "公告", "是", "否", "取消")
	switch(confirm)
		if("是")
			priority_announce(input, null, 'sound/blank.ogg')
		if("取消")
			return

	log_admin("[key_name(src)] has created a command report: [input]")
	message_admins("[key_name_admin(src)] 创建了指挥部报告")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Create Command Report") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_change_command_name()
	set category = "-特殊指令-"
	set name = "更改指挥部名称"
	set hidden = 1 // May have uses?

	if(!check_rights(R_ADMIN))
		return

	var/input = input(usr, "请输入中央司令部的新名称。", "新名称", "") as text|null
	if(!input)
		return
	change_command_name(input)
	message_admins("[key_name_admin(src)] 将中央司令部名称改为 [input]")
	log_admin("[key_name(src)] has changed the Central Command name to: [input]")

/client/proc/cmd_admin_delete(atom/A as obj|mob|turf in world)
	set category = "-主持-"
	set name = "删除..."

	if(!check_rights(R_SPAWN|R_DEBUG))
		return

	admin_delete(A)

/client/proc/cmd_admin_list_open_jobs()
	set category = "-服务器-"
	set name = "管理职业名额"

	if(!check_rights(R_DEBUG))
		return
	holder.manage_free_slots()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Manage Job Slots") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_explosion(atom/O as obj|mob|turf in world)
	set category = "-特殊指令-"
	set name = "爆炸"

	if(!check_rights(R_ADMIN))
		return

	var/devastation = input("完全毁灭的范围。-1 表示无", text("输入"))  as num|null
	if(devastation == null)
		return
	var/heavy = input("重度冲击的范围。-1 表示无", text("输入"))  as num|null
	if(heavy == null)
		return
	var/light = input("轻度冲击的范围。-1 表示无", text("输入"))  as num|null
	if(light == null)
		return
	var/flash = input("闪光的范围。-1 表示无", text("输入"))  as num|null
	if(flash == null)
		return
	var/flames = input("火焰的范围。-1 表示无", text("输入"))  as num|null
	if(flames == null)
		return

	if ((devastation != -1) || (heavy != -1) || (light != -1) || (flash != -1) || (flames != -1))
		if ((devastation > 20) || (heavy > 20) || (light > 20) || (flames > 20))
			if (alert(src, "确定要这样做吗？这会造成严重卡顿。", "确认", "是", "否") == "否")
				return

		explosion(O, devastation, heavy, light, flash, null, null,flames)
		log_admin("[key_name(usr)] created an explosion ([devastation],[heavy],[light],[flames]) at [AREACOORD(O)]")
		message_admins("[key_name_admin(usr)] 在 [AREACOORD(O)] 制造了爆炸 ([devastation],[heavy],[light],[flames])")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Explosion") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return
	else
		return

/client/proc/cmd_admin_emp(atom/O as obj|mob|turf in world)
	set category = "-特殊指令-"
	set name = "电磁脉冲"

	if(!check_rights(R_ADMIN))
		return

	var/heavy = input("强脉冲范围。", text("输入"))  as num|null
	if(heavy == null)
		return
	var/light = input("弱脉冲范围。", text("输入"))  as num|null
	if(light == null)
		return

	if (heavy || light)

		empulse(O, heavy, light)
		log_admin("[key_name(usr)] created an EM Pulse ([heavy],[light]) at [AREACOORD(O)]")
		message_admins("[key_name_admin(usr)] 在 [AREACOORD(O)] 制造了电磁脉冲 ([heavy],[light])")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "EM Pulse") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		return
	else
		return

/client/proc/cmd_admin_gib(mob/M in GLOB.mob_list)
	set category = "-特殊指令-"
	set name = "碎尸..."

	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "留下大脑吗？", "确认", "是", "否","取消")
	if(confirm == "取消")
		return
	//Due to the delay here its easy for something to have happened to the mob
	if(!M)
		return

	log_admin("[key_name(usr)] has gibbed [key_name(M)]")
	message_admins("[key_name_admin(usr)] 将 [key_name_admin(M)] 碎尸")

	if(isobserver(M))
		new /obj/effect/gibspawner/generic(get_turf(M))
		return
	if(confirm == "是")
		M.gib()
	else
		M.gib(1)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Gib") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_gib_self()
	set name = "自身碎尸"
	set category = "-主持-"

	var/confirm = alert(src, "确定吗？", "确认", "是", "否")
	if(confirm == "是")
		log_admin("[key_name(usr)] used gibself.")
		message_admins(span_adminnotice("[key_name_admin(usr)] 使用了自身碎尸指令。"))
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Gib Self") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		mob.gib(1, 1, 1)

/client/proc/cmd_admin_check_contents(mob/living/M in GLOB.mob_list)
	set category = "-特殊指令-"
	set name = "查看内容物"

	var/list/L = M.get_contents()
	for(var/t in L)
		to_chat(usr, "[t]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Check Contents") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_view_range()
	set category = "-特殊指令-"
	set name = "更改视野范围"
	set desc = ""

	if(view == CONFIG_GET(string/default_view))
		change_view(input("选择视野范围：", "视野范围", 7) in list(1,2,3,4,5,6,7,8,9,10,11,12,13,14,128))
	else
		change_view(CONFIG_GET(string/default_view))

	log_admin("[key_name(usr)] changed their view range to [view].")
	//message_admins("\blue [key_name_admin(usr)] changed their view range to [view].")	//why? removed by order of XSI

	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Change View Range", "[view]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!



/client/proc/toggle_random_events()
	set category = "-服务器-"
	set name = "切换随机事件"
	set desc = ""
	var/new_are = !CONFIG_GET(flag/allow_random_events)
	CONFIG_SET(flag/allow_random_events, new_are)
	if(new_are)
		to_chat(usr, "已启用随机事件")
		message_admins("管理员 [key_name_admin(usr)] 启用了随机事件。")
	else
		to_chat(usr, "已禁用随机事件")
		message_admins("管理员 [key_name_admin(usr)] 禁用了随机事件。")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Random Events", "[new_are ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/toggle_combo_hud()
	set category = "-管理-"
	set name = "切换综合状态栏"
	set desc = ""
	set hidden = 1 // If somebody loves this, I'm sorry, you can unhide it

	if(!check_rights(R_ADMIN))
		return

	var/adding_hud = !has_antag_hud()

	for(var/datum/atom_hud/antag/H in GLOB.huds) // add antag huds
		(adding_hud) ? H.add_hud_to(usr) : H.remove_hud_from(usr)

	if(prefs.toggles & COMBOHUD_LIGHTING)
		if(adding_hud)
			mob.lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		else
			mob.lighting_alpha = initial(mob.lighting_alpha)

	mob.update_sight()

	to_chat(usr, "你已[adding_hud ? "开启" : "关闭"]管理员综合状态栏。")
	message_admins("[key_name_admin(usr)] 已[adding_hud ? "开启" : "关闭"]管理员综合状态栏。")
	log_admin("[key_name(usr)] toggled their admin combo HUD [adding_hud ? "ON" : "OFF"].")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Combo HUD", "[adding_hud ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/has_antag_hud()
	var/datum/atom_hud/A = GLOB.huds[ANTAG_HUD_TRAITOR]
	return A.hudusers[mob]


/client/proc/run_weather()
	set category = "-主持-"
	set name = "触发天气"
	set desc = ""
	set hidden = 1 //Replaced by particle weather

	if(!holder)
		return

	var/weather_type = input("选择一种天气", "天气")  as null|anything in sortList(subtypesof(/datum/weather), GLOBAL_PROC_REF(cmp_typepaths_asc))
	if(!weather_type)
		return

	var/turf/T = get_turf(mob)
	var/z_level = input("目标Z层级？", "Z层级", T?.z) as num|null
	if(!isnum(z_level))
		return

	SSweather.run_weather(weather_type, z_level)

	message_admins("[key_name_admin(usr)] 在Z层级 [z_level] 触发了 [weather_type] 天气。")
	log_admin("[key_name(usr)] started weather of type [weather_type] on the z-level [z_level].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Run Weather")

/client/proc/show_tip()
	set category = "-管理-"
	set name = "发送提示"
	set desc = "向所有玩家发送你编写的提示。毕竟，\
		你才是这里经验丰富的玩家。"

	if(!check_rights(R_ADMIN))
		return

	var/input = input(usr, "请输入要发给玩家的提示。", "提示", "") as message|null
	if(!input)
		return

	if(!SSticker)
		return

	SSticker.selected_tip = input

	// If we've already tipped, then send it straight away.
	if(SSticker.tipped)
		SSticker.send_tip_of_the_round()


	message_admins("[key_name_admin(usr)] 发送了本回合提示。")
	log_admin("[key_name(usr)] sent \"[input]\" as the Tip of the Round.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Tip")

/client/proc/toggle_hub()
	set category = "-服务器-"
	set name = "切换服务器大厅可见性"

	world.update_hub_visibility(!GLOB.hub_visibility)

	log_admin("[key_name(usr)] has toggled the server's hub status for the round, it is now [(GLOB.hub_visibility?"on":"off")] the hub.")
	message_admins("[key_name_admin(usr)] 切换了本回合服务器大厅可见性，现已[(GLOB.hub_visibility?"显示":"隐藏")]。")
	if (GLOB.hub_visibility && !world.reachable)
		message_admins("警告：BYOND 检测到防火墙阻止传入连接，服务器不会出现在大厅中。")

	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggled Hub Visibility", "[GLOB.hub_visibility ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/smite(mob/living/target as mob)
	set name = "神罚"
	set category = "-主持-"
	if(!check_rights(R_ADMIN) || !check_rights(R_FUN))
		return
	var/static/list/punishment_list = list(
		"雷击" = ADMIN_PUNISHMENT_LIGHTNING,
		"脑损伤" = ADMIN_PUNISHMENT_BRAINDAMAGE,
		"爆体" = ADMIN_PUNISHMENT_GIB,
		"蓝空间火炮" = ADMIN_PUNISHMENT_BSA,
		"生殖器创伤（CBT）" = ADMIN_PUNISHMENT_CBT,
		"折断脖颈" = ADMIN_PUNISHMENT_NECKSNAP,
		"变为特雷·利亚姆" = ADMIN_PUNISHMENT_LIAM,
		"抛飞生物" = ADMIN_PUNISHMENT_THROWMOB,
		"四肢骨折" = ADMIN_PUNISHMENT_CRIPPLE,
		"普赛顿圣罚" = ADMIN_PUNISHMENT_PSYDON,
		"神圣之怒" = ADMIN_PUNISHMENT_DIVINE_WRATH,
	)

	var/punishment = input("选择一种惩罚", "神罚") as null|anything in sortList(punishment_list)

	if(QDELETED(target) || !punishment)
		return

	switch(punishment_list[punishment])
		if(ADMIN_PUNISHMENT_LIGHTNING)
			var/turf/T = get_step(get_step(target, NORTH), NORTH)
			T.Beam(target, icon_state="lightning[rand(1,12)]", time = 5)
			target.adjustFireLoss(75)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				H.electrocution_animation(40)
			record_round_statistic(STATS_PEOPLE_SMITTEN)
			to_chat(target, span_danger("诸神因我的罪行而降下惩罚！"))
		if(ADMIN_PUNISHMENT_BRAINDAMAGE)
			target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 199, 199)
		if(ADMIN_PUNISHMENT_PSYDON)
			sleep(60)
			target.psydo_nyte()
			target.playsound_local(target, 'sound/misc/psydong.ogg', 100, FALSE)
			sleep(20)
			target.psydo_nyte()
			target.playsound_local(target, 'sound/misc/psydong.ogg', 100, FALSE)
			sleep(15)
			target.psydo_nyte()
			target.playsound_local(target, 'sound/misc/psydong.ogg', 100, FALSE)
			sleep(10)
			target.gib(FALSE)
		if(ADMIN_PUNISHMENT_GIB)
			target.gib(FALSE)
		if(ADMIN_PUNISHMENT_BSA)
			bluespace_artillery(target)
		if(ADMIN_PUNISHMENT_CBT)
			if(!ishuman(target))
				to_chat(usr,span_warning("目标必须是人形角色！"))
				return
			var/mob/living/carbon/human/humie = target
			var/obj/item/bodypart/affecting = humie.get_bodypart(BODY_ZONE_CHEST)
			if(!affecting)
				to_chat(usr,span_warning("目标必须有胸部！"))
				return
			affecting.add_wound(/datum/wound/cbt/permanent)
		if(ADMIN_PUNISHMENT_NECKSNAP)
			if(!ishuman(target))
				to_chat(usr,span_warning("目标必须是人形角色！"))
				return
			var/mob/living/carbon/human/humie = target
			var/obj/item/bodypart/affecting = humie.get_bodypart(BODY_ZONE_HEAD)
			if(!affecting)
				to_chat(usr,span_warning("目标必须有头部！"))
				return
			affecting.add_wound(/datum/wound/fracture/neck)
		if(ADMIN_PUNISHMENT_CRIPPLE)
			if(!ishuman(target))
				to_chat(usr,span_warning("目标必须是人形角色！"))
				return
			var/limbs_to_cripple = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			var/mob/living/carbon/human/humie = target

			for(var/limb in limbs_to_cripple)
				var/obj/item/bodypart/limb_to_cripple = humie.get_bodypart(limb)
				limb_to_cripple.add_wound(/datum/wound/fracture)
		if(ADMIN_PUNISHMENT_THROWMOB)
			if(!ismob(target))
				to_chat(usr,span_warning("目标必须是生物！"))
				return
			var/list/directions = list("北" = NORTH, "南" = SOUTH, "东" = EAST, "西" = WEST, "东北" = NORTHEAST, "西北" = NORTHWEST, "东南" = SOUTHEAST, "西南" = SOUTHWEST)
			var/direction = input("哪个方向？") in directions
			direction = directions[direction]
			var/target_tile = target.loc
			for (var/i = 0; i < 10; i++)
				var/turf/next_tile = get_step(target_tile, direction)
				if (!next_tile)
					break
				target_tile = next_tile
			to_chat(target,span_warning("我被一股神秘力量抛飞了……"))
			target.throw_at(target = target_tile, range = 10, speed = 3, thrower = target, spin = 9, diagonals_first = FALSE, callback = null, force = 20)
		if(ADMIN_PUNISHMENT_LIAM)
			if(!ishuman(target))
				to_chat(usr,span_warning("不……这不可能……（目标必须是碳基生物！）"))
				return
			var/mob/living/carbon/human/humie = target
			playsound(humie, 'sound/villain/dreamer_win.ogg', 100, FALSE, -1)
			humie.gender = MALE
			humie.skin_tone = "ffe0d1"
			humie.hair_color = "999999"
			humie.hairstyle = "Plain Long"
			humie.facial_hair_color = "999999"
			humie.facial_hairstyle = "Knowledge"
			humie.age = AGE_OLD
			humie.equipOutfit(/datum/outfit/treyliam)
			humie.regenerate_icons()
			humie.SetSleeping(25 SECONDS)
			humie.add_stress(/datum/stressevent/maniac_woke_up)
			to_chat(humie, span_deadsay("<span class='reallybig'>……我在哪儿？……</span>"))
			var/static/list/slop_lore = list(
				span_deadsay("……岩丘？不……它根本不存在……"),
				span_deadsay("……我叫特雷。特雷·利亚姆，利亚姆提菲克·特罗维希尔……"),
				span_deadsay("……我在纳米“利亚姆”号上，这是一艘自给自足的船，用来保存人类最后的遗存……"),
				span_deadsay("……驶入残酷的黑暗，战争与黑暗维系着他们的残酷……他们的锋芒……"),
				span_deadsay("……让他们在只有战争的黑暗未来中活下去……"),
				span_deadsay("……希望已经消失。只有十三号空间站（商标名点题）让我还能活在特雷·利亚姆的世界里……"),
				span_deadsay("……我都做了些什么！？……"),
				span_reallybig("……该死，为什么这里有条会说话的狗？！……"),
		)
			for(var/slop in slop_lore)
				to_chat(humie, slop)
				sleep(3 SECONDS)
		if(ADMIN_PUNISHMENT_DIVINE_WRATH)
			if(!ishuman(target))
				to_chat(usr,span_warning("目标必须是人形角色！"))
				return
			divine_wrath(target)
	punish_log(target, punishment_list[punishment])

/client/proc/punish_log(whom, punishment)
	var/msg = "[key_name_admin(usr)] 对 [key_name_admin(whom)] 施加了 [list(ADMIN_PUNISHMENT_LIGHTNING = "雷击", ADMIN_PUNISHMENT_BRAINDAMAGE = "脑损伤", ADMIN_PUNISHMENT_GIB = "爆体", ADMIN_PUNISHMENT_BSA = "蓝空间火炮", ADMIN_PUNISHMENT_CBT = "生殖器创伤（CBT）", ADMIN_PUNISHMENT_NECKSNAP = "折断脖颈", ADMIN_PUNISHMENT_LIAM = "变为特雷·利亚姆", ADMIN_PUNISHMENT_THROWMOB = "抛飞生物", ADMIN_PUNISHMENT_CRIPPLE = "四肢骨折", ADMIN_PUNISHMENT_PSYDON = "普赛顿圣罚", ADMIN_PUNISHMENT_DIVINE_WRATH = "神圣之怒")[punishment] || punishment] 惩罚。"
	message_admins(msg)
	admin_ticket_log(whom, msg)
	log_admin("[key_name(usr)] punished [key_name(whom)] with [punishment].")

/client/proc/cmd_admin_check_player_exp()	//Allows admins to determine who the newer players are.
	set category = "-服务器-"
	set name = "玩家游玩时长"
	if(!check_rights(R_ADMIN))
		return

	if(!CONFIG_GET(flag/use_exp_tracking))
		to_chat(usr, span_warning("服务器配置文件已禁用时长追踪。"))
		return

	var/list/msg = list()
	msg += "<html><head><title>游玩时长报告</title></head><body>游玩时长：<BR><UL>"
	for(var/client/C in GLOB.clients)
		msg += "<LI> - [key_name_admin(C)]: <A href='?_src_=holder;[HrefToken()];getplaytimewindow=[REF(C.mob)]'>" + C.get_exp_living() + "</a></LI>"
	msg += "</UL></BODY></HTML>"
	src << browse(msg.Join(), "window=Player_playtime_check")

/datum/admins/proc/cmd_show_exp_panel(client/C)
	if(!check_rights(R_ADMIN))
		return
	if(!C)
		to_chat(usr, span_danger("错误：未找到客户端。"))
		return
	if(!CONFIG_GET(flag/use_exp_tracking))
		to_chat(usr, span_warning("服务器配置文件已禁用时长追踪。"))
		return

	var/list/body = list()
	body += "<html><head><title>[C.key] 的游玩时长</title></head><BODY><BR>游玩时长："
	body += C.get_exp_report()
	body += "<A href='?_src_=holder;[HrefToken()];toggleexempt=[REF(C)]'>切换时长要求豁免</a>"
	body += "</BODY></HTML>"
	usr << browse(body.Join(), "window=playerplaytime[C.ckey];size=550x615")

/datum/admins/proc/toggle_exempt_status(client/C)
	if(!check_rights(R_ADMIN))
		return
	if(!C)
		to_chat(usr, span_danger("错误：未找到客户端。"))
		return

	if(!C.set_db_player_flags())
		to_chat(usr, span_danger("错误：无法从数据库读取玩家标记。请查看日志。"))
	var/dbflags = C.prefs.db_flags
	var/newstate = FALSE
	if(dbflags & DB_FLAG_EXEMPT)
		newstate = FALSE
	else
		newstate = TRUE

	if(C.update_flag_db(DB_FLAG_EXEMPT, newstate))
		to_chat(usr, span_danger("错误：无法更新玩家标记。请查看日志。"))
	else
		message_admins("[key_name_admin(usr)] 已为 [key_name_admin(C)][newstate ? "启用" : "禁用"]职业时长要求豁免")
		log_admin("[key_name(usr)] has [newstate ? "activated" : "deactivated"] job exp exempt status on [key_name(C)]")

/// Every trait in the game listed as a checkbox, checked ones being the traits the datum ends up with
/datum/admins/proc/modify_traits(datum/D)
	if(!D)
		return

	var/list/items = list()
	var/list/descriptions = list()
	var/list/checked = list()
	for(var/define_name in GLOB.all_traits)
		var/trait = GLOB.all_traits[define_name]
		items += trait
		descriptions[trait] = trait_menu_description(trait, define_name)
		if(HAS_TRAIT(D, trait))
			checked += trait
	//traits it already has that aren't listed in all_traits, so they can still be taken away
	for(var/trait in D.status_traits)
		if(trait in items)
			continue
		items += trait
		descriptions[trait] = "未收录的特质。"
		checked += trait
	items = sortList(checked) + sortList(items - checked) //what it already has goes on top

	var/list/chosen = tgui_input_checkboxes(usr, "勾选的特质将成为 [D] 最终拥有的特质。", "修改 [D] 的特质", items, min_checked = 0, max_checked = length(items), default_checked = checked, descriptions = descriptions, strict_modern = TRUE, window_width = 600, window_height = 700)
	if(isnull(chosen) || QDELETED(D))
		return

	var/list/added = chosen - checked
	var/list/removed = checked - chosen
	if(!length(added) && !length(removed))
		return

	for(var/trait in added) //Not doing source choosing here intentionally to make this bit faster to use, you can always vv it.
		ADD_TRAIT(D, trait, "adminbus")
	for(var/trait in removed)
		var/list/sources = D.status_traits?[trait]
		if(!sources)
			continue
		for(var/source in sources.Copy()) //one at a time, REMOVE_TRAIT skips entries if it cuts several at once
			REMOVE_TRAIT(D, trait, source)

	log_admin("[key_name(usr)] modified the traits of [D] ([D.type]): added [english_list(added)], removed [english_list(removed)]")
	message_admins("[key_name_admin(usr)] 修改了 [D] ([D.type]) 的特质：新增 [english_list(added)]，移除 [english_list(removed)]")

/// "TRAIT_DEFINE - what the trait does", for the trait modification menu
/proc/trait_menu_description(trait, define_name)
	var/description = GLOB.roguetraits[trait]
	if(!description)
		return define_name
	return "[define_name] - [GLOB.html_tags.Replace(description, "")]"
