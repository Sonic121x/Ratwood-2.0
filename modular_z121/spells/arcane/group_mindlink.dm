// 每人只持有一个界面和发言监听器，主链接及其私聊分别保存，避免多条链接串台。
GLOBAL_LIST_EMPTY(active_group_mindlinks)

#define GML_MESSAGE_LIMIT 1024
#define GML_HISTORY_LIMIT 200

/proc/group_mindlink_session(mob/living/member, create = TRUE)
	var/datum/group_mindlink_session/session = GLOB.active_group_mindlinks[member]
	if(QDELETED(session) && create && !QDELETED(member))
		session = new(member)
	return session

// 候选仅来自施法者自身实际视野，筛选之前不得向界面暴露隐藏身份。
/proc/group_mindlink_candidates(mob/living/user)
	var/list/result = list()
	if(QDELETED(user) || !user.client || user.client.eye != user || user.group_mindlink_view || user.stat != CONSCIOUS || user.IsUnconscious())
		return result
	for(var/mob/living/carbon/human/member in view(user.client.view, user))
		if(member == user || QDELETED(member) || !member.client || QDELETED(member.mind) || member.mind.current != member || member.stat != CONSCIOUS || member.IsUnconscious())
			continue
		if(!length(member.real_name) || member.get_face_name("") != member.real_name || member.get_visible_name() != member.real_name)
			continue
		if(group_mindlink_visible(user, member))
			result[REF(member)] = member
	return result

/proc/group_mindlink_people_data(list/people, datum/group_mindlink_custom/link)
	var/list/result = list()
	var/list/counts = list()
	var/list/ordinals = list()
	for(var/mob/living/member as anything in people)
		counts[link ? link.member_name(member) : member.get_visible_name()]++
	for(var/mob/living/member as anything in people)
		var/label = link ? link.member_name(member) : member.get_visible_name()
		if(counts[label] > 1)
			ordinals[label]++
			label = "[label]（同名 [ordinals[label]]）"
		result += list(list("id" = REF(member), "name" = label, "online" = !!member.client))
	return result

// 一个主链接拥有自己的到期计时器，删除法术对象不会让计时器失效。
/datum/group_mindlink_custom
	var/mob/living/owner
	var/list/participants = list()
	var/list/member_names = list()
	var/initializing = TRUE
	var/list/rooms = list()
	var/list/vision_contexts = list()
	var/datum/group_mindlink_room/main_room
	var/active = TRUE
	var/expires_at
	var/expiry_timer

/datum/group_mindlink_custom/New(mob/living/caster, list/members)
	. = ..()
	owner = caster
	expires_at = world.time + (15 MINUTES)
	main_room = new(src, caster, "main", "主群")
	rooms += main_room
	for(var/mob/living/member as anything in members)
		add_member(member)
	initializing = FALSE
	main_room.system_message("心灵链接已建立。成员可以私聊、创建小房间或直接视听旁观彼此；主链接不能中途追加成员。")
	expiry_timer = addtimer(CALLBACK(src, PROC_REF(end_link), "十五分钟已到，心灵链接逐渐消散。"), (15 MINUTES), TIMER_STOPPABLE)

/datum/group_mindlink_custom/Destroy()
	active = FALSE
	for(var/datum/group_mindlink_vision_context/context as anything in vision_contexts.Copy())
		qdel(context)
	vision_contexts.Cut()
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
	member_names.Cut()
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

/datum/group_mindlink_custom/proc/member_name(mob/living/member)
	return member_names[member] || "已离开的成员"

/datum/group_mindlink_custom/proc/add_member(mob/living/member)
	if(!initializing || length(participants) >= 6 || !active || world.time >= expires_at || !istype(member) || QDELETED(member) || member.stat == DEAD || (member in participants))
		return FALSE
	member_names[member] = member.get_visible_name()
	participants += member
	var/datum/group_mindlink_session/session = group_mindlink_session(member)
	var/first_link = !length(session.links)
	session.links |= src
	member.verbs |= /mob/living/proc/group_mindlink_reopen
	main_room.add_member(member)
	if(first_link)
		session.current_room = main_room
	to_chat(member, span_notice("你已加入[html_encode(member_name(owner))]建立的心灵链接。请在 IC 分类下点击「群体心灵链接」打开心灵链接窗口；输入 ,m 可向当前选中的会话发言。"))
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
	member_names -= member
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

// 房间加入序号隔离历史；主链接只允许创建时加入，小房间重新加入则重新计序。
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
				return "与[link.member_name(member)]私聊"
	return title

/datum/group_mindlink_room/proc/add_member(mob/living/member)
	if(!link.active || !(member in link.participants) || (member in members))
		return FALSE
	members[member] = sequence + 1
	read_sequence[member] = sequence
	system_message("[link.member_name(member)]加入了会话。")
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
		system_message("[link.member_name(member)]离开了会话。")
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
	var/list/entry = list("seq" = sequence, "name" = speaker ? link.member_name(speaker) : "系统", "speaker" = speaker ? REF(speaker) : null, "text" = message, "time" = station_time_timestamp(), "system" = !speaker)
	messages += list(entry)
	if(length(messages) > GML_HISTORY_LIMIT)
		messages.Cut(1, length(messages) - GML_HISTORY_LIMIT + 1)
	if(speaker)
		for(var/mob/living/member as anything in members)
			if(can_access(member))
				to_chat(member, span_purple("\[心灵链接 · [html_encode(display_title(member))]\] [html_encode(link.member_name(speaker))]：[html_encode(message)]"))
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
	var/feedback = "选择视野内最多五名玩家邀请加入链接，或选择已有会话。"
	var/last_send_at = -10
	var/list/ack = list()
	var/cleaning_up = FALSE

/datum/group_mindlink_session/New(mob/living/user)
	. = ..()
	holder = user
	GLOB.active_group_mindlinks[user] = src
	RegisterSignal(user, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	RegisterSignal(user, list(COMSIG_QDELETING, COMSIG_LIVING_DEATH, COMSIG_MIND_TRANSFER), PROC_REF(holder_gone))
	RegisterSignal(user, COMSIG_MOB_LOGOUT, PROC_REF(vision_logout))

/datum/group_mindlink_session/Destroy()
	if(selection_spell?.cast_request)
		selection_spell.cast_request.cancel()
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
	// 等待邀请时关闭施法窗口即取消；已建立的聊天窗口与旁观状态独立。
	if(selection_spell?.inviting)
		selection_spell.cancel_invites()
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
	var/list/data = list("self" = REF(holder), "feedback" = feedback, "selecting" = !QDELETED(selection_spell), "busy" = !!selection_spell?.casting, "waiting" = !!selection_spell?.inviting, "selection" = selection.Copy(), "ack" = ack.Copy(), "groups" = list(), "active" = null, "candidates" = list())
	data["vision"] = vision_data()
	var/list/groups = data["groups"]
	for(var/datum/group_mindlink_custom/link as anything in links)
		if(QDELETED(link) || !link.active || !(holder in link.participants))
			continue
		var/list/room_data = list()
		for(var/datum/group_mindlink_room/room as anything in link.rooms)
			if(room.can_access(holder))
				room_data += list(list("id" = REF(room), "name" = room.display_title(holder), "kind" = room.kind, "unread" = room.unread_count(holder)))
		groups += list(list("id" = REF(link), "name" = "[link.member_name(link.owner)]的链接", "remaining" = max(0, round((link.expires_at - world.time) / 10)), "rooms" = room_data))
	if(!QDELETED(current_room) && current_room.can_access(holder))
		var/datum/group_mindlink_custom/link = current_room.link
		var/list/active = list("id" = REF(current_room), "name" = current_room.display_title(holder), "kind" = current_room.kind, "creator" = REF(current_room.creator), "owner" = REF(link.owner), "members" = group_mindlink_people_data(current_room.members, link), "people" = group_mindlink_people_data(link.participants, link), "messages" = current_room.visible_messages(holder), "sequence" = current_room.sequence)
		data["active"] = active
		active["link"] = REF(link)
	if(!QDELETED(selection_spell))
		var/list/candidates = group_mindlink_candidates(holder)
		var/list/available = list()
		for(var/id in candidates)
			available += candidates[id]
		data["candidates"] = group_mindlink_people_data(available)
		var/list/visible_selection = list()
		for(var/id in selection)
			if(istext(id) && candidates[id])
				visible_selection += id
		data["selection"] = visible_selection
		if(!selection_spell.casting)
			selection = visible_selection.Copy()
	return data

/datum/group_mindlink_session/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(ui.user != holder || usr != holder || ui_status(holder) != UI_INTERACTIVE)
		return FALSE
	if(findtext(action, "vision_") == 1)
		return vision_action(action, params)
	if(action == "cancel_selection" && selection_spell?.inviting)
		selection_spell.cancel_invites()
		return TRUE
	if(selection_spell?.casting)
		return FALSE
	if(action == "toggle_person" && selection_spell)
		var/list/candidates = group_mindlink_candidates(holder)
		var/id = params["id"]
		if(istext(id) && (id in candidates))
			if(id in selection)
				selection -= id
			else if(length(selection) < 5)
				selection += id
		return TRUE
	if(action == "select_all" && selection_spell)
		selection.Cut()
		var/list/candidates = group_mindlink_candidates(holder)
		for(var/id in candidates)
			if(length(selection) >= 5)
				break
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
	if(action == "leave_link")
		for(var/datum/group_mindlink_custom/link as anything in links.Copy())
			if(REF(link) == params["link"] && (holder in link.participants))
				link.remove_member(holder)
				return TRUE
		return FALSE
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
		title = "[link.member_name(holder)]的小房间"
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
	school = "divination"
	desc = "邀请自身视野内最多五名面容与真名公开的玩家，经同意及五秒引导建立十五分钟的心灵链接。成员可以聊天、私聊、创建小房间并直接视听旁观彼此。主链接不可中途追加成员；输入 ,m 向当前会话发言，使用 IC 下的群体心灵链接重开窗口。"
	associated_skill = /datum/skill/magic/arcane
	cost = 5
	xp_gain = TRUE
	recharge_time = 5 MINUTES
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
	var/inviting = FALSE
	var/charge_reserved = FALSE
	var/datum/group_mindlink_cast_request/cast_request
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
	session.feedback = "选择视野内一至五名玩家；对方同意加入后开始五秒引导，施法者自动加入。"
	session.ui_interact(user)

/obj/effect/proc_holder/spell/self/group_mindlink/charge_check(mob/user)
	// 引导后的条件复查只豁免本次已预留的冷却，其他施法条件仍由父类检查。
	if(casting && charge_reserved && user == casting_user)
		return TRUE
	return ..()

/obj/effect/proc_holder/spell/self/group_mindlink/proc/cancel_invites()
	if(inviting && !QDELETED(cast_request))
		cast_request.cancel()

/obj/effect/proc_holder/spell/self/group_mindlink/proc/begin_cast(datum/group_mindlink_session/session)
	if(casting || QDELETED(session) || session.selection_spell != src)
		return
	var/mob/living/user = session.holder
	if(!user?.client || user.group_mindlink_view || user.client.eye != user)
		session.notice("请先返回自身视角，再开始施法。")
		return
	if(length(session.selection) < 1 || length(session.selection) > 5)
		session.notice("每次只能邀请一至五名玩家。")
		return
	var/list/candidates = group_mindlink_candidates(user)
	var/list/chosen = list()
	for(var/id in session.selection)
		if(istext(id) && candidates[id])
			chosen |= candidates[id]
	if(!length(chosen))
		session.notice("已选对象均已失效，请重新选择视野内面容与真名公开的玩家。")
		return
	// 先做无消耗检查，邀请阶段不预留冷却；至少一人同意后才正式引导。
	if(!cast_check(TRUE, user))
		return
	casting = TRUE
	casting_user = user
	inviting = TRUE
	cast_request = new(src, session, chosen)
	var/datum/group_mindlink_cast_request/request = cast_request
	session.feedback = "正在等待加入确认，最多二十秒；可以取消。"
	session.refresh()
	request.open_invitations()
	while(!QDELETED(src) && !QDELETED(request) && !request.cancelled && request.caster_valid() && world.time < request.deadline && !request.all_answered())
		sleep(1)
	if(QDELETED(src))
		return
	var/success = FALSE
	if(!QDELETED(request))
		request.close_invitations()
		pending_members = request.accepted_members()
		if(length(pending_members) && cast_check(FALSE, user))
			charge_reserved = TRUE
			inviting = FALSE
			session.feedback = "已确认有效成员，正在引导心灵链接……"
			session.refresh()
			invocation(user)
			user.visible_message(span_notice("[user]闭目凝神，牵引着愿意回应之人的心念……"))
			success = do_after(user, get_chargetime(), target = user, progress = TRUE)
			if(QDELETED(src))
				return
			if(success && !QDELETED(request) && request.caster_valid())
				success = cast_check(TRUE, user)
			else
				success = FALSE
			if(success)
				// 咒文已在引导开始时念出，仍由原有流程结算成功消耗及经验。
				var/list/saved_invocations = invocations
				invocations = null
				success = perform(null, user = user)
				invocations = saved_invocations
	if(!success && !QDELETED(user))
		if(charge_reserved)
			revert_cast(user)
		if(!QDELETED(session))
			session.notice("链接未能成形：无人有效同意、已取消或引导中断。未结算成功消耗，本次预留冷却已恢复。")
	casting = FALSE
	inviting = FALSE
	charge_reserved = FALSE
	casting_user = null
	cast_request = null
	if(!QDELETED(request))
		qdel(request)
	pending_members.Cut()
	if(!QDELETED(session))
		if(success || !SStgui.get_open_ui(user, session))
			session.selection_spell = null
			session.selection.Cut()
		session.refresh()
		session.cleanup_if_unused()

/obj/effect/proc_holder/spell/self/group_mindlink/cast(list/targets, mob/living/user = usr)
	if(!casting || inviting || user != casting_user || QDELETED(cast_request) || !cast_request.caster_valid())
		return FALSE
	var/list/accepted = cast_request.accepted_members()
	var/list/members = list(user)
	for(var/mob/living/member as anything in pending_members)
		if(member in accepted)
			members |= member
	if(length(members) < 2 || length(members) > 6)
		return FALSE
	if(length(members) != length(pending_members) + 1)
		to_chat(user, span_notice("部分已同意对象已不满足接入条件，已跳过失效对象。"))
	new /datum/group_mindlink_custom(user, members)
	return ..()

/obj/effect/proc_holder/spell/self/group_mindlink/Destroy()
	if(!QDELETED(cast_request))
		cast_request.cancel()
		qdel(cast_request)
	cast_request = null
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
	set name = "群体心灵链接"
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
