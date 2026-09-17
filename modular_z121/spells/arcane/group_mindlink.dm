// 每人只持有一个界面和发言监听器，主链接及其私聊分别保存，避免多条链接串台。
GLOBAL_LIST_EMPTY(active_group_mindlinks)

#define GML_MESSAGE_LIMIT 1024
#define GML_HISTORY_LIMIT 200

/proc/group_mindlink_session(mob/living/member, create = TRUE)
	var/datum/group_mindlink_session/session = GLOB.active_group_mindlinks[member]
	if(QDELETED(session) && create && !QDELETED(member))
		session = new(member)
	return session

// 熟人姓名只用于查找候选对象，后续选择与权限检查均使用实际对象。
// NPC 和离线角色仍可加入链接；客户端只决定能否开窗和主动发言，不决定成员资格。
/proc/group_mindlink_candidates(mob/living/user)
	var/list/result = list()
	if(QDELETED(user) || !user.mind)
		return result
	for(var/mob/living/carbon/human/member as anything in GLOB.human_list)
		if(member == user || QDELETED(member) || member.stat == DEAD)
			continue
		if(member.real_name in user.mind.known_people)
			result[REF(member)] = member
	return result

/proc/group_mindlink_people_data(list/people)
	var/list/result = list()
	var/list/counts = list()
	var/list/ordinals = list()
	for(var/mob/living/member as anything in people)
		counts[member.real_name]++
	for(var/mob/living/member as anything in people)
		var/label = member.real_name
		if(counts[label] > 1)
			ordinals[label]++
			label = "[label]（同名 [ordinals[label]]）"
		result += list(list("id" = REF(member), "name" = label, "online" = !!member.client))
	return result

// 一个主链接拥有自己的到期计时器，删除法术对象不会让计时器失效。
/datum/group_mindlink_custom
	var/mob/living/owner
	var/list/participants = list()
	var/list/rooms = list()
	var/list/vision_permissions = list()
	var/datum/group_mindlink_room/main_room
	var/active = TRUE
	var/expires_at
	var/expiry_timer

/datum/group_mindlink_custom/New(mob/living/caster, list/members)
	. = ..()
	owner = caster
	expires_at = world.time + 5 MINUTES
	main_room = new(src, caster, "main", "主群")
	rooms += main_room
	for(var/mob/living/member as anything in members)
		add_member(member)
	main_room.system_message("心灵链接已建立。每位成员都可以发起私聊或创建小房间。")
	expiry_timer = addtimer(CALLBACK(src, PROC_REF(end_link), "五分钟已到，心灵链接逐渐消散。"), 5 MINUTES, TIMER_STOPPABLE)

/datum/group_mindlink_custom/Destroy()
	active = FALSE
	for(var/datum/group_mindlink_vision_permission/permission as anything in vision_permissions.Copy())
		qdel(permission)
	vision_permissions.Cut()
	if(expiry_timer)
		deltimer(expiry_timer)
	for(var/datum/group_mindlink_room/room as anything in rooms.Copy())
		qdel(room)
	for(var/mob/living/member as anything in participants.Copy())
		var/datum/group_mindlink_session/session = group_mindlink_session(member, FALSE)
		if(session)
			session.links -= src
			session.refresh()
			session.cleanup_if_unused()
	participants.Cut()
	rooms.Cut()
	owner = null
	main_room = null
	return ..()

/datum/group_mindlink_custom/proc/end_link(reason)
	if(!active)
		return
	active = FALSE
	for(var/mob/living/member as anything in participants)
		if(!QDELETED(member))
			to_chat(member, span_notice("\[心灵链接\] [reason]"))
	qdel(src)

/datum/group_mindlink_custom/proc/add_member(mob/living/member)
	if(!active || world.time >= expires_at || !istype(member) || QDELETED(member) || member.stat == DEAD || (member in participants))
		return FALSE
	participants += member
	var/datum/group_mindlink_session/session = group_mindlink_session(member)
	var/first_link = !length(session.links)
	session.links |= src
	member.verbs |= /mob/living/proc/group_mindlink_reopen
	main_room.add_member(member)
	if(first_link)
		session.current_room = main_room
		// 资源发送可能等待客户端，不能让开窗打断主链接的成员登记流程。
		INVOKE_ASYNC(session, TYPE_PROC_REF(/datum/group_mindlink_session, ui_interact), member)
	to_chat(member, span_notice("你已加入[html_encode(owner.real_name)]建立的心灵链接。可使用『Group Mindlink』重开窗口；,m 发往当前选中的会话。"))
	refresh()
	return TRUE

/datum/group_mindlink_custom/proc/remove_member(mob/living/member)
	if(!active || !(member in participants))
		return
	if(member == owner)
		end_link("施法者离开，心灵链接随之结束。")
		return
	clear_member_vision(member)
	for(var/datum/group_mindlink_room/room as anything in rooms.Copy())
		if(member in room.members)
			room.remove_member(member)
	participants -= member
	var/datum/group_mindlink_session/session = group_mindlink_session(member, FALSE)
	if(session)
		session.links -= src
		session.refresh()
		session.cleanup_if_unused()
	if(!QDELETED(member))
		to_chat(member, span_notice("你已退出该主链接及其全部私聊和小房间。"))
	refresh()

/datum/group_mindlink_custom/proc/refresh()
	for(var/mob/living/member as anything in participants)
		var/datum/group_mindlink_session/session = group_mindlink_session(member, FALSE)
		session?.refresh()

// 加入序号隔离历史；离开后重新加入会得到新的起始序号。
/datum/group_mindlink_room
	var/datum/group_mindlink_custom/link
	var/mob/living/creator
	var/kind
	var/title
	var/list/members = list()
	var/list/read_sequence = list()
	var/list/messages = list()
	var/sequence = 0

/datum/group_mindlink_room/New(datum/group_mindlink_custom/parent_link, mob/living/room_creator, room_kind, room_title)
	. = ..()
	link = parent_link
	creator = room_creator
	kind = room_kind
	title = room_title

/datum/group_mindlink_room/Destroy()
	for(var/mob/living/member as anything in members)
		var/datum/group_mindlink_session/session = group_mindlink_session(member, FALSE)
		if(session?.current_room == src)
			session.current_room = null
			session.feedback = "当前会话已结束，请选择发送目标。"
	link?.rooms.Remove(src)
	members.Cut()
	messages.Cut()
	read_sequence.Cut()
	link = null
	creator = null
	return ..()

/datum/group_mindlink_room/proc/can_access(mob/living/member)
	return !QDELETED(link) && link.active && world.time < link.expires_at && !QDELETED(member) && member.stat != DEAD && (member in link.participants) && (member in members)

/datum/group_mindlink_room/proc/display_title(mob/living/viewer)
	if(kind == "dm")
		for(var/mob/living/member as anything in members)
			if(member != viewer)
				return "与[member.real_name]私聊"
	return title

/datum/group_mindlink_room/proc/add_member(mob/living/member)
	if(!link.active || !(member in link.participants) || (member in members))
		return FALSE
	members[member] = sequence + 1
	read_sequence[member] = sequence
	system_message("[member.real_name]加入了会话。")
	return TRUE

/datum/group_mindlink_room/proc/remove_member(mob/living/member)
	if(!(member in members))
		return
	if(kind == "dm" || (kind == "room" && member == creator))
		close_room()
		return
	members -= member
	read_sequence -= member
	var/datum/group_mindlink_session/session = group_mindlink_session(member, FALSE)
	if(session?.current_room == src)
		session.current_room = null
		session.feedback = "你已离开当前会话，请重新选择发送目标。"
	if(!QDELETED(member))
		system_message("[member.real_name]离开了会话。")
	link.refresh()

/datum/group_mindlink_room/proc/close_room()
	var/datum/group_mindlink_custom/parent_link = link
	for(var/mob/living/member as anything in members)
		if(!QDELETED(member))
			to_chat(member, span_notice("\[心灵链接\] [html_encode(display_title(member))]已结束。"))
	qdel(src)
	parent_link?.refresh()

/datum/group_mindlink_room/proc/system_message(message)
	append_message(null, message)

/datum/group_mindlink_room/proc/append_message(mob/living/speaker, message)
	sequence++
	var/list/entry = list("seq" = sequence, "name" = speaker ? speaker.real_name : "系统", "speaker" = speaker ? REF(speaker) : null, "text" = message, "time" = station_time_timestamp(), "system" = !speaker)
	messages += list(entry)
	if(length(messages) > GML_HISTORY_LIMIT)
		messages.Cut(1, length(messages) - GML_HISTORY_LIMIT + 1)
	if(speaker)
		for(var/mob/living/member as anything in members)
			if(can_access(member))
				to_chat(member, span_purple("\[心灵链接 · [html_encode(display_title(member))]\] [html_encode(speaker.real_name)]：[html_encode(message)]"))
	link.refresh()

/datum/group_mindlink_room/proc/visible_messages(mob/living/viewer)
	var/list/result = list()
	if(!can_access(viewer))
		return result
	for(var/list/entry as anything in messages)
		if(entry["seq"] >= members[viewer])
			result += list(entry.Copy())
	return result

/datum/group_mindlink_room/proc/unread_count(mob/living/viewer)
	. = 0
	if(!can_access(viewer))
		return
	for(var/list/entry as anything in messages)
		if(entry["seq"] >= members[viewer] && entry["seq"] > read_sequence[viewer] && !entry["system"] && entry["speaker"] != REF(viewer))
			.++

// 该对象只允许所属玩家访问，不能沿用默认允许旁观者查看的界面权限。
/datum/group_mindlink_session
	var/mob/living/holder
	var/list/links = list()
	var/datum/group_mindlink_room/current_room
	var/obj/effect/proc_holder/spell/self/group_mindlink/selection_spell
	var/list/selection = list()
	var/feedback = "选择熟人建立链接，或选择已有会话。"
	var/last_send_at = -10
	var/list/ack = list()
	var/cleaning_up = FALSE
	var/last_vision_request = -50

/datum/group_mindlink_session/New(mob/living/user)
	. = ..()
	holder = user
	GLOB.active_group_mindlinks[user] = src
	RegisterSignal(user, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	RegisterSignal(user, list(COMSIG_QDELETING, COMSIG_LIVING_DEATH, COMSIG_MIND_TRANSFER), PROC_REF(holder_gone))
	RegisterSignal(user, COMSIG_MOB_LOGOUT, PROC_REF(vision_logout))

/datum/group_mindlink_session/Destroy()
	if(holder?.group_mindlink_view)
		qdel(holder.group_mindlink_view)
	SStgui.close_uis(src)
	if(holder)
		UnregisterSignal(holder, list(COMSIG_MOB_SAY, COMSIG_QDELETING, COMSIG_LIVING_DEATH, COMSIG_MIND_TRANSFER, COMSIG_MOB_LOGOUT))
		if(GLOB.active_group_mindlinks[holder] == src)
			GLOB.active_group_mindlinks -= holder
		if(!QDELETED(holder))
			holder.verbs -= /mob/living/proc/group_mindlink_reopen
	links.Cut()
	selection.Cut()
	holder = null
	current_room = null
	selection_spell = null
	return ..()

/datum/group_mindlink_session/proc/holder_gone()
	SIGNAL_HANDLER
	// 先关闭权限，防止死亡或换身信号处理期间继续操作旧窗口。
	cleaning_up = TRUE
	var/list/old_links = links.Copy()
	links.Cut()
	for(var/datum/group_mindlink_custom/link as anything in old_links)
		if(!QDELETED(link))
			link.remove_member(holder)
	qdel(src)

/datum/group_mindlink_session/proc/cleanup_if_unused()
	if(!QDELETED(src) && !cleaning_up && !length(links) && QDELETED(selection_spell))
		qdel(src)

/datum/group_mindlink_session/ui_state(mob/user)
	return GLOB.always_state

/datum/group_mindlink_session/ui_status(mob/user, datum/ui_state/state)
	if(cleaning_up || user != holder || QDELETED(holder) || !holder.client || holder.stat == DEAD)
		return UI_CLOSE
	return holder.stat == CONSCIOUS ? UI_INTERACTIVE : UI_DISABLED

/datum/group_mindlink_session/ui_interact(mob/user, datum/tgui/ui)
	if(ui_status(user) == UI_CLOSE)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GroupMindlink", "群体心灵链接")
		ui.open()

/datum/group_mindlink_session/ui_close(mob/user)
	if(holder?.group_mindlink_view)
		qdel(holder.group_mindlink_view)
	if(!selection_spell?.casting)
		selection_spell = null
		selection.Cut()
	cleanup_if_unused()

/datum/group_mindlink_session/proc/refresh()
	if(!QDELETED(src))
		SStgui.try_update_ui(holder, src)

/datum/group_mindlink_session/proc/notice(message)
	feedback = message
	if(!QDELETED(holder))
		to_chat(holder, span_notice("\[心灵链接\] [html_encode(message)]"))
	refresh()

/datum/group_mindlink_session/proc/find_room(id)
	for(var/datum/group_mindlink_custom/link as anything in links)
		if(QDELETED(link) || !link.active)
			continue
		for(var/datum/group_mindlink_room/room as anything in link.rooms)
			if(REF(room) == id && room.can_access(holder))
				return room

/datum/group_mindlink_session/ui_data(mob/user)
	if(cleaning_up || user != holder || QDELETED(holder) || holder.stat == DEAD)
		return list()
	var/list/data = list("self" = REF(holder), "feedback" = feedback, "selecting" = !QDELETED(selection_spell), "busy" = !!selection_spell?.casting, "selection" = selection.Copy(), "ack" = ack.Copy(), "groups" = list(), "active" = null, "candidates" = list())
	data["vision"] = vision_data()
	var/list/groups = data["groups"]
	for(var/datum/group_mindlink_custom/link as anything in links)
		if(QDELETED(link) || !link.active || !(holder in link.participants))
			continue
		var/list/room_data = list()
		for(var/datum/group_mindlink_room/room as anything in link.rooms)
			if(room.can_access(holder))
				room_data += list(list("id" = REF(room), "name" = room.display_title(holder), "kind" = room.kind, "unread" = room.unread_count(holder)))
		groups += list(list("id" = REF(link), "name" = "[link.owner.real_name]的链接", "remaining" = max(0, round((link.expires_at - world.time) / 10)), "rooms" = room_data))
	if(!QDELETED(current_room) && current_room.can_access(holder))
		var/datum/group_mindlink_custom/link = current_room.link
		var/list/active = list("id" = REF(current_room), "name" = current_room.display_title(holder), "kind" = current_room.kind, "creator" = REF(current_room.creator), "owner" = REF(link.owner), "members" = group_mindlink_people_data(current_room.members), "people" = group_mindlink_people_data(link.participants), "messages" = current_room.visible_messages(holder), "sequence" = current_room.sequence)
		data["active"] = active
		active["link"] = REF(link)
		if(link.owner == holder)
			var/list/candidates = group_mindlink_candidates(holder)
			var/list/available = list()
			for(var/id in candidates)
				var/mob/living/member = candidates[id]
				if(!(member in link.participants))
					available += member
			data["candidates"] = group_mindlink_people_data(available)
	if(!QDELETED(selection_spell))
		var/list/candidates = group_mindlink_candidates(holder)
		var/list/available = list()
		for(var/id in candidates)
			available += candidates[id]
		data["candidates"] = group_mindlink_people_data(available)
	return data

/datum/group_mindlink_session/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(ui.user != holder || usr != holder || ui_status(holder) != UI_INTERACTIVE)
		return FALSE
	if(findtext(action, "vision_") == 1)
		return vision_action(action, params)
	if(selection_spell?.casting)
		return FALSE
	if(action == "toggle_person" && selection_spell)
		var/list/candidates = group_mindlink_candidates(holder)
		var/id = params["id"]
		if(id in candidates)
			if(id in selection)
				selection -= id
			else
				selection += id
		return TRUE
	if(action == "select_all" && selection_spell)
		selection.Cut()
		var/list/candidates = group_mindlink_candidates(holder)
		for(var/id in candidates)
			selection += id
		return TRUE
	if(action == "clear_selection")
		selection.Cut()
		return TRUE
	if(action == "cancel_selection")
		selection_spell = null
		selection.Cut()
		cleanup_if_unused()
		return TRUE
	if(action == "cast" && selection_spell)
		selection_spell.begin_cast(src)
		return TRUE
	if(action == "select_room")
		var/datum/group_mindlink_room/room = find_room(params["id"])
		if(room)
			current_room = room
			selection_spell = null
			selection.Cut()
			feedback = "当前发送目标：[room.display_title(holder)]。"
		return TRUE
	var/datum/group_mindlink_room/room = find_room(params["room"])
	if(!room || room != current_room)
		notice("会话已失效或发送目标已改变，请重新选择。")
		return TRUE
	var/datum/group_mindlink_custom/link = room.link
	switch(action)
		if("read")
			var/seen = text2num("[params["sequence"]]")
			if(isnum(seen))
				room.read_sequence[holder] = max(room.read_sequence[holder], min(seen, room.sequence))
		if("send")
			var/nonce = params["nonce"]
			if(istext(nonce) && length(nonce) <= 80 && send_to_room(room, params["text"]))
				ack = list("nonce" = params["nonce"], "room" = REF(room))
		if("leave")
			if(room.kind == "main")
				link.remove_member(holder)
			else
				room.remove_member(holder)
		if("close_room")
			if(room.kind == "main" && link.owner == holder)
				link.end_link("施法者主动结束了链接。")
			else if(room.kind == "room" && room.creator == holder)
				room.close_room()
		if("kick")
			for(var/mob/living/member as anything in room.members.Copy())
				if(REF(member) != params["id"] || member == holder)
					continue
				if(room.kind == "main" && link.owner == holder)
					link.remove_member(member)
				else if(room.kind == "room" && room.creator == holder)
					room.remove_member(member)
		if("add_known")
			if(link.owner == holder)
				var/list/candidates = group_mindlink_candidates(holder)
				var/list/ids = params["ids"]
				if(islist(ids))
					for(var/id in ids)
						// 数字索引会被 DM 当作列表位置，必须拒绝，避免绕过对象标识解析。
						if(!istext(id))
							continue
						var/mob/living/member = candidates[id]
						if(member)
							link.add_member(member)
		if("add_room_members")
			if(room.kind == "room" && room.creator == holder)
				var/list/ids = params["ids"]
				if(islist(ids))
					for(var/mob/living/member as anything in link.participants)
						if((REF(member) in ids) && !QDELETED(member) && member.stat != DEAD)
							room.add_member(member)
		if("create_dm", "create_room")
			create_room(link, params["ids"], action == "create_dm", params["name"])
	if(!QDELETED(link))
		link.refresh()
	return TRUE

/datum/group_mindlink_session/proc/create_room(datum/group_mindlink_custom/link, list/ids, direct, room_name)
	if(!islist(ids) || !(holder in link.participants))
		return
	var/list/chosen = list(holder)
	for(var/mob/living/member as anything in link.participants)
		if(member != holder && (REF(member) in ids) && !QDELETED(member) && member.stat != DEAD)
			chosen |= member
	if(length(chosen) < 2 || (direct && length(chosen) != 2))
		notice("请选择有效的链接成员；单人私聊只能选择一名对象。")
		return
	if(direct)
		for(var/datum/group_mindlink_room/existing as anything in link.rooms)
			if(existing.kind == "dm" && length(existing.members) == 2 && (chosen[1] in existing.members) && (chosen[2] in existing.members))
				current_room = existing
				return
	var/title = istext(room_name) ? trim(copytext_char(room_name, 1, 41)) : ""
	if(!length(title))
		title = "[holder.real_name]的小房间"
	var/datum/group_mindlink_room/new_room = new(link, holder, direct ? "dm" : "room", title)
	link.rooms += new_room
	for(var/mob/living/member as anything in chosen)
		new_room.add_member(member)
		if(member != holder)
			to_chat(member, span_notice("\[心灵链接\] 你已加入[html_encode(new_room.display_title(member))]，可从会话列表打开。"))
	current_room = new_room
	feedback = "当前发送目标：[new_room.display_title(holder)]。"

/datum/group_mindlink_session/proc/send_to_room(datum/group_mindlink_room/room, raw_text)
	if(QDELETED(src) || QDELETED(holder) || holder.stat != CONSCIOUS || !holder.client)
		return FALSE
	if(QDELETED(room) || room != current_room || !room.can_access(holder))
		notice("当前会话已失效，请重新选择发送目标；消息未发送。")
		return FALSE
	if(!istext(raw_text))
		return FALSE
	var/message = trim(copytext_char(raw_text, 1, GML_MESSAGE_LIMIT + 1))
	if(!length(message))
		return FALSE
	if(world.time < last_send_at + 1 SECONDS)
		notice("发送过快，请稍候再试。")
		return FALSE
	last_send_at = world.time
	room.append_message(holder, message)
	feedback = "已发送至[room.display_title(holder)]。"
	return TRUE

/datum/group_mindlink_session/proc/handle_speech(mob/living/speaker, list/speech_args)
	SIGNAL_HANDLER
	var/message = speech_args[SPEECH_MESSAGE]
	if(speaker != holder || !istext(message) || lowertext(copytext(message, 1, 3)) != ",m")
		return
	// 先阻止普通发言，再校验目标；异步调用携带原会话，不能临时改投新会话。
	speech_args[SPEECH_MESSAGE] = null
	INVOKE_ASYNC(src, PROC_REF(send_to_room), current_room, html_decode(trim(copytext(message, 3))))

/obj/effect/proc_holder/spell/self/group_mindlink
	name = "群体心灵链接"
	desc = "选择任意数量的熟人，吟唱后建立持续五分钟的心灵链接。成员可以在主群交流、单独私聊或创建小房间。发言前输入 ,m 会发送到当前选中的会话；使用 IC 下的 Group Mindlink 可重新打开窗口。"
	associated_skill = /datum/skill/magic/arcane
	cost = 5
	xp_gain = TRUE
	recharge_time = 6 MINUTES
	spell_tier = 3
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "group_mindlink"
	invocations = list("群念相连。")
	invocation_type = "whisper"
	chargedloop = /datum/looping_sound/invokegen
	chargedrain = 1
	chargetime = 5 SECONDS
	releasedrain = 30
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	warnie = "spellwarning"
	miracle = FALSE
	human_req = TRUE
	var/casting = FALSE
	var/mob/living/casting_user
	var/list/pending_members = list()

/obj/effect/proc_holder/spell/self/group_mindlink/Click()
	choose_targets(usr)
	return TRUE

/obj/effect/proc_holder/spell/self/group_mindlink/choose_targets(mob/user = usr)
	if(!isliving(user) || user.stat != CONSCIOUS || !user.client || casting)
		return
	if(!(src in user.mob_spell_list) && !(src in user.mind?.spell_list))
		return
	var/datum/group_mindlink_session/session = group_mindlink_session(user)
	session.selection_spell = src
	session.selection.Cut()
	session.feedback = "勾选至少一名熟人后确认施法；施法者自动加入。"
	session.ui_interact(user)

/obj/effect/proc_holder/spell/self/group_mindlink/charge_check(mob/user)
	// 引导后的条件复查只豁免本次已预留的冷却，其他施法条件仍由父类检查。
	if(casting && user == casting_user)
		return TRUE
	return ..()

/obj/effect/proc_holder/spell/self/group_mindlink/proc/begin_cast(datum/group_mindlink_session/session)
	if(casting || QDELETED(session) || session.selection_spell != src)
		return
	if(session.holder?.group_mindlink_view)
		session.notice("请先返回自身视角，再开始施法。")
		return
	var/mob/living/user = session.holder
	var/datum/mind/original_mind = user.mind
	var/list/candidates = group_mindlink_candidates(user)
	pending_members.Cut()
	for(var/id in session.selection)
		if(candidates[id])
			pending_members |= candidates[id]
	if(!length(pending_members))
		session.notice("没有有效的已选熟人，请重新选择。")
		return
	if(!cast_check(FALSE, user))
		pending_members.Cut()
		return
	casting = TRUE
	casting_user = user
	session.feedback = "正在引导心灵链接……"
	session.refresh()
	invocation(user)
	user.visible_message(span_notice("[user]闭目凝神，牵引着熟识之人的心念……"))
	var/success = do_after(user, get_chargetime(), target = user, progress = TRUE)
	if(QDELETED(src))
		return
	if(success && !QDELETED(user) && user.client && user.mind == original_mind && !QDELETED(session) && session.selection_spell == src)
		success = cast_check(TRUE, user)
	else
		success = FALSE
	if(success)
		// 咒文已在引导开始时念出，正常结算仍使用 perform 的消耗与经验流程。
		var/list/saved_invocations = invocations
		invocations = null
		success = perform(null, user = user)
		invocations = saved_invocations
	if(!success && !QDELETED(user))
		revert_cast(user)
		if(!QDELETED(session))
			session.notice("链接未能成形，冷却已恢复；请重新选择或再次尝试。")
	casting = FALSE
	casting_user = null
	pending_members.Cut()
	if(!QDELETED(session))
		if(success || !SStgui.get_open_ui(user, session))
			session.selection_spell = null
			session.selection.Cut()
		session.refresh()
		session.cleanup_if_unused()

/obj/effect/proc_holder/spell/self/group_mindlink/cast(list/targets, mob/living/user = usr)
	if(!casting || user != casting_user || QDELETED(user) || !user.mind)
		return FALSE
	var/list/candidates = group_mindlink_candidates(user)
	var/list/members = list(user)
	var/list/missing = list()
	for(var/mob/living/member as anything in pending_members)
		if(!QDELETED(member) && candidates[REF(member)] == member)
			members |= member
		else
			missing += QDELETED(member) ? "已失效的对象" : member.real_name
	if(length(missing))
		to_chat(user, span_notice("以下对象无法接入：[html_encode(english_list(missing))]。"))
	if(length(members) < 2)
		return FALSE
	new /datum/group_mindlink_custom(user, members)
	return ..()

/obj/effect/proc_holder/spell/self/group_mindlink/Destroy()
	for(var/mob/living/member as anything in GLOB.active_group_mindlinks.Copy())
		var/datum/group_mindlink_session/session = group_mindlink_session(member, FALSE)
		if(session?.selection_spell == src)
			session.selection_spell = null
			session.selection.Cut()
			session.refresh()
			session.cleanup_if_unused()
	pending_members.Cut()
	casting_user = null
	return ..()

/mob/living/proc/group_mindlink_reopen()
	set name = "Group Mindlink"
	set category = "IC"
	set desc = "重新打开群体心灵链接，选择主群、私聊或小房间。"
	var/datum/group_mindlink_session/session = group_mindlink_session(src, FALSE)
	if(session)
		session.ui_interact(src)
	else
		verbs -= /mob/living/proc/group_mindlink_reopen
		to_chat(src, span_notice("当前没有可用的群体心灵链接。"))

#undef GML_MESSAGE_LIMIT
#undef GML_HISTORY_LIMIT
