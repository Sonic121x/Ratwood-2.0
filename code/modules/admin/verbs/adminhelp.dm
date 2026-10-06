/client/var/adminhelptimerid = 0	//a timer id for returning the ahelp verb
/client/var/datum/admin_help/current_ticket	//the current ticket the (usually) not-admin client is dealing with

//
// ADMIN HELP UI STATE
//

// Custom UI state for admin ticket panel that requires R_AHELP permission
/datum/ui_state/ahelp_state

/datum/ui_state/ahelp_state/can_use_topic(src_object, mob/user)
	if(check_rights_for(user.client, R_AHELP))
		return UI_INTERACTIVE
	return UI_CLOSE

GLOBAL_DATUM_INIT(ahelp_state, /datum/ui_state/ahelp_state, new)

//
//TICKET MANAGER
//

GLOBAL_DATUM_INIT(ahelp_tickets, /datum/admin_help_tickets, new)

/datum/admin_help_tickets
	var/list/active_tickets = list()
	var/list/closed_tickets = list()
	var/list/resolved_tickets = list()

	// Track selected ticket per user
	var/list/selected_tickets = list()  // Maps ckey -> ticket_id

	var/obj/effect/statclick/ticket_list/astatclick = new(null, null, AHELP_ACTIVE)
	var/obj/effect/statclick/ticket_list/cstatclick = new(null, null, AHELP_CLOSED)
	var/obj/effect/statclick/ticket_list/rstatclick = new(null, null, AHELP_RESOLVED)

/datum/admin_help_tickets/Destroy()
	QDEL_LIST(active_tickets)
	QDEL_LIST(closed_tickets)
	QDEL_LIST(resolved_tickets)
	QDEL_NULL(astatclick)
	QDEL_NULL(cstatclick)
	QDEL_NULL(rstatclick)
	return ..()

/datum/admin_help_tickets/proc/TicketByID(id)
	var/list/lists = list(active_tickets, closed_tickets, resolved_tickets)
	for(var/I in lists)
		for(var/J in I)
			var/datum/admin_help/AH = J
			if(AH.id == id)
				return J

/datum/admin_help_tickets/proc/TicketsByCKey(ckey)
	. = list()
	var/list/lists = list(active_tickets, closed_tickets, resolved_tickets)
	for(var/I in lists)
		for(var/J in I)
			var/datum/admin_help/AH = J
			if(AH.initiator_ckey == ckey)
				. += AH

//private
/datum/admin_help_tickets/proc/ListInsert(datum/admin_help/new_ticket)
	var/list/ticket_list
	switch(new_ticket.state)
		if(AHELP_ACTIVE)
			ticket_list = active_tickets
		if(AHELP_CLOSED)
			ticket_list = closed_tickets
		if(AHELP_RESOLVED)
			ticket_list = resolved_tickets
		else
			CRASH("Invalid ticket state: [new_ticket.state]")
	var/num_closed = ticket_list.len
	if(num_closed)
		for(var/I in 1 to num_closed)
			var/datum/admin_help/AH = ticket_list[I]
			if(AH.id > new_ticket.id)
				ticket_list.Insert(I, new_ticket)
				return
	ticket_list += new_ticket

//opens the ticket listings for one of the 3 states
/datum/admin_help_tickets/proc/BrowseTickets(state)
	if(!check_rights(R_AHELP))
		to_chat(usr, "<font color='red'>Error: You do not have permission to view tickets.</font>")
		return
	
	// Redirect to TGUI panel instead of old HTML browser
	ui_interact(usr)

//Tickets statpanel
/datum/admin_help_tickets/proc/stat_entry()
	SHOULD_CALL_PARENT(TRUE)
	var/label = "Open Ticket Manager ([active_tickets.len] active)"
	stat(null, astatclick.update(label))

//Reassociate still open ticket if one exists
/datum/admin_help_tickets/proc/ClientLogin(client/C)
	C.current_ticket = CKey2ActiveTicket(C.ckey)
	if(C.current_ticket)
		C.current_ticket.initiator = C
		C.current_ticket.initiator_mob = C.mob
		C.current_ticket.AddInteraction("玩家已重新连接。")

//Dissasociate ticket
/datum/admin_help_tickets/proc/ClientLogout(client/C)
	if(C.current_ticket)
		C.current_ticket.AddInteraction("玩家已断开连接。")
		C.current_ticket.initiator = null
		C.current_ticket = null

//Get a ticket given a ckey
/datum/admin_help_tickets/proc/CKey2ActiveTicket(ckey)
	for(var/I in active_tickets)
		var/datum/admin_help/AH = I
		if(AH.initiator_ckey == ckey)
			return AH

//
// TGUI INTERFACE FOR ADMIN PANEL
//

/datum/admin_help_tickets/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AdminTicketPanel", "Admin Ticket Panel")
		ui.open()

/datum/admin_help_tickets/ui_data(mob/user)
	var/list/data = list()
	
	data["active_tickets"] = list()
	for(var/datum/admin_help/ticket in active_tickets)
		var/list/ticket_data = list()
		ticket_data["id"] = ticket.id
		ticket_data["name"] = html_decode(ticket.name)
		ticket_data["state"] = "ACTIVE"
		ticket_data["initiator_ckey"] = ticket.initiator_ckey
		ticket_data["initiator_name"] = ticket.initiator_key_name
		ticket_data["opened_at"] = ticket.opened_at
		ticket_data["closed_at"] = ticket.closed_at
		ticket_data["initiator_connected"] = ticket.initiator ? TRUE : FALSE
		data["active_tickets"] += list(ticket_data)
	
	data["closed_tickets"] = list()
	for(var/datum/admin_help/ticket in closed_tickets)
		var/list/ticket_data = list()
		ticket_data["id"] = ticket.id
		ticket_data["name"] = html_decode(ticket.name)
		ticket_data["state"] = "CLOSED"
		ticket_data["initiator_ckey"] = ticket.initiator_ckey
		ticket_data["initiator_name"] = ticket.initiator_key_name
		ticket_data["opened_at"] = ticket.opened_at
		ticket_data["closed_at"] = ticket.closed_at
		ticket_data["initiator_connected"] = ticket.initiator ? TRUE : FALSE
		data["closed_tickets"] += list(ticket_data)
	
	data["resolved_tickets"] = list()
	for(var/datum/admin_help/ticket in resolved_tickets)
		var/list/ticket_data = list()
		ticket_data["id"] = ticket.id
		ticket_data["name"] = html_decode(ticket.name)
		ticket_data["state"] = "RESOLVED"
		ticket_data["initiator_ckey"] = ticket.initiator_ckey
		ticket_data["initiator_name"] = ticket.initiator_key_name
		ticket_data["opened_at"] = ticket.opened_at
		ticket_data["closed_at"] = ticket.closed_at
		ticket_data["initiator_connected"] = ticket.initiator ? TRUE : FALSE
		data["resolved_tickets"] += list(ticket_data)
	
	// Include selected ticket details if any
	data["selected_ticket"] = null
	var/user_ckey = user.ckey
	if(user_ckey && selected_tickets[user_ckey])
		var/selected_id = selected_tickets[user_ckey]
		var/datum/admin_help/selected = TicketByID(selected_id)
		if(selected)
			var/list/full_ticket = selected.ui_data(user)
			full_ticket["initiator_connected"] = selected.initiator ? TRUE : FALSE
			data["selected_ticket"] = full_ticket

	return data

/datum/admin_help_tickets/ui_static_data(mob/user)
	return list()

/datum/admin_help_tickets/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	
	var/mob/user = usr
	if(!check_rights_for(user.client, R_AHELP))
		return FALSE
	
	switch(action)
		if("select_ticket")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket)
				return FALSE

			// Store the selected ticket for this user
			selected_tickets[user.ckey] = ticket_id
			return TRUE

		if("send_message")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || ticket.state != AHELP_ACTIVE)
				return FALSE

			var/message = params["message"]
			if(!message)
				return FALSE

			// Preserve newlines as <br> so they survive sanitization and render correctly in TGUI
			message = sanitize_preserve_newlines(trim(message))
			if(!message)
				return FALSE


			ticket.AddInteraction("<font color='blue'>PM from [key_name_ahelp(user)]: [message]</font>")

			// Send to player if connected
			if(ticket.initiator)
				to_chat(ticket.initiator, span_adminhelp("<b>来自管理员<font color='red'>[key_name_ahelp(user)]</font>的私信</b>：<span class='linkify'>[message]</span>"))
				SEND_SOUND(ticket.initiator, sound('sound/adminhelp.ogg'))
				window_flash(ticket.initiator, ignorepref = TRUE)

			// Log with real name for accountability (strip <br> for log readability)
			var/log_msg = replacetext(message, "<br>", "\n")
			log_admin_private("Ticket #[ticket.id]: [key_name(user)] -> [ticket.initiator_key_name]: [log_msg]")
			// Notify other admins in chat with real identity
			message_admins(span_adminnotice("<font color='blue'>Ticket #[ticket.id] [ticket.TicketHref("Show Ticket")] - [key_name_admin(user)] replied to [ticket.initiator_key_name]: [log_msg]</font>"))

			return TRUE
		
		if("jump_to", "observe", "pm")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !ticket.initiator)
				return FALSE
			
			switch(action)
				if("jump_to")
					user.client.holder.Topic(null, list("adminplayerobservejump" = "[REF(ticket.initiator.mob)]", "_src_" = "holder"))
				if("observe")
					user.client.holder.Topic(null, list("adminplayerobservefollow" = "[REF(ticket.initiator.mob)]", "_src_" = "holder"))
				if("pm")
					user.client.cmd_ahelp_reply(ticket.initiator)
			return TRUE
		
		if("reject")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket)
				return FALSE
			ticket.Reject()
			return TRUE
		
		if("ic_issue")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket)
				return FALSE
			ticket.ICIssue()
			return TRUE
		
		if("close")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket)
				return FALSE
			ticket.Close()
			return TRUE
		
		if("resolve")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket)
				return FALSE
			ticket.Resolve()
			return TRUE
		
		if("handle")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket)
				return FALSE
			ticket.HandleIssue()
			return TRUE
		
		if("reopen")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket)
				return FALSE
			ticket.Reopen()
			return TRUE
		
		if("retitle")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket)
				return FALSE
			ticket.Retitle()
			return TRUE
		
		if("ticket_pp")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !user.client?.holder)
				return FALSE
			var/mob/pp_target = ticket.initiator ? ticket.initiator.mob : ticket.initiator_mob
			if(!pp_target)
				return FALSE
			// Let the ticket know the admin is opening the player panel
			admin_ticket_log(pp_target, "<font color='green'>[key_name_admin(user)]正在通过玩家面板检查你的角色。</font>")
			user.client.holder.show_player_panel_next(pp_target)
			return TRUE

		if("ticket_vv")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !user.client)
				return FALSE
			var/mob/vv_target = ticket.initiator ? ticket.initiator.mob : ticket.initiator_mob
			if(!vv_target)
				return FALSE
			// Transparency: viewing variables for this ticket's initiator
			admin_ticket_log(vv_target, "<font color='green'>[key_name_admin(user)]正在查看与你的求助有关的变量。</font>")
			user.client.debug_variables(vv_target)
			return TRUE

		if("ticket_sm")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !ticket.initiator || !ticket.initiator.mob || !user.client)
				return FALSE
			user.client.cmd_admin_subtle_message(ticket.initiator.mob)
			return TRUE

		if("ticket_flw")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !user.client)
				return FALSE
			var/mob/flw_target = ticket.initiator ? ticket.initiator.mob : ticket.initiator_mob
			if(!flw_target)
				return FALSE
			// Only allow non-observers with proper admin rights to follow
			var/client/C = user.client
			if(!isobserver(user) && !check_rights_for(C, R_ADMIN))
				return FALSE

			// Let the player know an admin is observing them (only if connected)
			admin_ticket_log(flw_target, "<font color='green'>[key_name_admin(user)]正在观察你。</font>")

			// Mirror the behaviour of the adminplayerobservefollow href
			var/can_ghost = TRUE
			if(!isobserver(user))
				can_ghost = C.admin_ghost()
			if(!can_ghost)
				return FALSE

			var/mob/dead/observer/A = C.mob
			if(!istype(A))
				return FALSE
			A.ManualFollow(flw_target)
			return TRUE

		if("ticket_tp")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !ticket.initiator || !ticket.initiator.mob || !user.client?.holder)
				return FALSE
			// Traitor panel / status review transparency
			admin_ticket_log(ticket.initiator.mob, "<font color='green'>[key_name_admin(user)]正在检查与你的求助有关的角色与状态。</font>")
			user.client.holder.show_traitor_panel(ticket.initiator.mob)
			return TRUE

		if("ticket_logs")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !user.client)
				return FALSE
			var/mob/log_target = ticket.initiator ? ticket.initiator.mob : ticket.initiator_mob
			if(!log_target)
				return FALSE
			admin_ticket_log(log_target, "<font color='green'>[key_name_admin(user)]正在检查与你的求助有关的日志。</font>")
			show_individual_logging_panel(log_target)
			return TRUE

		if("ticket_smite")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !ticket.initiator || !ticket.initiator.mob || !user.client)
				return FALSE
			user.client.smite(ticket.initiator.mob)
			return TRUE

		if("ticket_cake")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !ticket.initiator || !ticket.initiator.mob || !user.client)
				return FALSE
			user.client.admin_spawn_cake(ticket.initiator.mob)
			return TRUE

		if("ticket_aheal")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !ticket.initiator || !ticket.initiator.mob || !user.client)
				return FALSE
			user.client.cmd_admin_rejuvenate(ticket.initiator.mob)
			return TRUE

		if("ticket_pq")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !ticket.initiator_ckey)
				return FALSE
			// PQ / history transparency
			admin_ticket_log(ticket.initiator_ckey, "<font color='green'>[key_name_admin(user)]正在检查与你的求助有关的账号历史与游玩时间。</font>")
			check_pq_menu(ticket.initiator_ckey)
			return TRUE

		if("ticket_gm")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !ticket.initiator || !ticket.initiator.mob || !user.client)
				return FALSE
			user.client.Getmob(ticket.initiator.mob)
			return TRUE

		if("ticket_jm")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !ticket.initiator || !ticket.initiator.mob || !user.client)
				return FALSE
			user.client.jumptomob(ticket.initiator.mob)
			return TRUE

		if("ticket_nd")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !ticket.initiator || !ticket.initiator.mob || !user.client)
				return FALSE
			admin_ticket_log(ticket.initiator.mob, "<font color='green'>[key_name_admin(user)]正在为你编写与此次求助有关的叙事消息。</font>")
			user.client.cmd_admin_direct_narrate(ticket.initiator.mob)
			return TRUE

		if("ticket_ap")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || !ticket.initiator || !ticket.initiator.mob || !user.client)
				return FALSE
			admin_ticket_log(ticket.initiator.mob, "<font color='green'>[key_name_admin(user)]正在对你的角色使用与此次求助有关的高级工具。</font>")
			user.client.callproc_datum(ticket.initiator.mob)
			return TRUE

		if("embed_media")
			var/ticket_id = params["ticket_id"]
			var/datum/admin_help/ticket = TicketByID(ticket_id)
			if(!ticket || ticket.state != AHELP_ACTIVE)
				return FALSE
			var/url = params["url"]
			var/embed_type = params["embed_type"]
			if(!url || !embed_type)
				return FALSE
			url = trim(url)
			// Only allow https URLs for safety
			if(findtext(url, "https://") != 1)
				return FALSE
			// Only allow image or video types
			if(embed_type != "image" && embed_type != "video")
				return FALSE
			var/prefix = embed_type == "image" ? "EMBED_IMAGE:" : "EMBED_VIDEO:"
			ticket.AddInteraction("<font color='blue'>PM from [key_name_ahelp(user)]: [prefix][url]</font>")
			// Notify the player if connected
			if(ticket.initiator)
				to_chat(ticket.initiator, span_adminhelp("<b>[key_name_ahelp(user)]在你的求助记录中嵌入了[list("image" = "图片", "video" = "视频")[embed_type] || "媒体"]。</b>"))
			log_admin_private("Ticket #[ticket.id]: [key_name(user)] embedded [embed_type]: [url]")
			// Notify other admins in chat with a placeholder - no raw URLs to prevent flashbanging
			message_admins(span_adminnotice("<font color='blue'>Ticket #[ticket.id] [ticket.TicketHref("Show Ticket")] - [key_name_admin(user)] sent [ticket.initiator_key_name] an (embedded [embed_type]).</font>"))
			return TRUE
	
	return FALSE

/datum/admin_help_tickets/ui_state(mob/user)
	return GLOB.ahelp_state

//
//TICKET LIST STATCLICK
//

/obj/effect/statclick/ticket_list
	var/current_state

/obj/effect/statclick/ticket_list/New(loc, name, state)
	current_state = state
	..()

/obj/effect/statclick/ticket_list/Click()
	// Open TGUI panel instead of old HTML browser
	if(usr?.client)
		GLOB.ahelp_tickets.ui_interact(usr)

//called by admin topic
/obj/effect/statclick/ticket_list/proc/Action()
	Click()

//
//TICKET DATUM
//

/datum/admin_help
	var/id
	var/name
	var/state = AHELP_ACTIVE

	var/opened_at
	var/closed_at

	var/client/initiator	//semi-misnomer, it's the person who ahelped/was bwoinked
	var/mob/initiator_mob	//stored separately so tools still work when player is DC'd
	var/initiator_ckey
	var/initiator_key_name
	var/heard_by_no_admins = FALSE

	var/list/_interactions	//use AddInteraction() or, preferably, admin_ticket_log()

	var/obj/effect/statclick/ahelp/statclick

	var/static/ticket_counter = 0

//call this on its own to create a ticket, don't manually assign current_ticket
//msg is the title of the ticket: usually the ahelp text
//is_bwoink is TRUE if this ticket was started by an admin PM
/datum/admin_help/New(msg, client/C, is_bwoink)
	//clean the input msg
	msg = copytext_char(msg,1,MAX_MESSAGE_LEN)
	if(!msg || !C || !C.mob)
		qdel(src)
		return

	id = ++ticket_counter
	opened_at = world.time

	name = copytext_char(msg, 1, 100)

	initiator = C
	initiator_mob = C.mob
	initiator_ckey = initiator.ckey
	initiator_key_name = key_name(initiator, FALSE, TRUE)
	if(initiator.current_ticket)	//This is a bug
		stack_trace("Multiple ahelp current_tickets")
		initiator.current_ticket.AddInteraction("Ticket erroneously left open by code")
		initiator.current_ticket.Close()
	initiator.current_ticket = src

	TimeoutVerb()

	statclick = new(null, src)
	_interactions = list()

	if(is_bwoink)
		AddInteraction("<font color='blue'>PM from [key_name_ahelp(usr)]: [msg]</font>")
		message_admins("<font color='blue'>Ticket [TicketHref("#[id]")] created</font>")
	else
		// Add a clean initial message for the player's view
		AddInteraction("<font color='green'>求助已创建。你的消息已发送给管理员团队。</font>")
		
		MessageNoRecipient(msg)

		//send it to irc if nobody is on and tell us how many were on
		var/admin_number_present = send2irc_adminless_only(initiator_ckey, "Ticket #[id]: [name]")
		log_admin_private("Ticket #[id]: [key_name(initiator)]: [name] - heard by [admin_number_present] non-AFK admins who have +BAN.")
		if(admin_number_present <= 0)
			to_chat(C, span_notice("目前没有在线值勤的管理员，你的求助已发送至管理员IRC频道。"))
			heard_by_no_admins = TRUE
		else
			to_chat(C, span_notice("你的求助已发送给[admin_number_present]位管理员。"))

	GLOB.ahelp_tickets.active_tickets += src
	
	// Open the TGUI chat window for the initiator
	if(C && C.mob)
		ui_interact(C.mob)

/datum/admin_help/Destroy()
	RemoveActive()
	GLOB.ahelp_tickets.closed_tickets -= src
	GLOB.ahelp_tickets.resolved_tickets -= src
	return ..()

/datum/admin_help/proc/AddInteraction(formatted_message)
	if(heard_by_no_admins && usr && usr.ckey != initiator_ckey)
		heard_by_no_admins = FALSE
		send2irc(initiator_ckey, "Ticket #[id]: Answered by [key_name(usr)]")
	_interactions += "[time_stamp()]: [formatted_message]"
	// Update any open TGUI windows
	SStgui.update_uis(src)

//Removes the ahelp verb and returns it after 2 minutes
/datum/admin_help/proc/TimeoutVerb()
	initiator.verbs -= /client/verb/adminhelp
	initiator.adminhelptimerid = addtimer(CALLBACK(initiator, TYPE_PROC_REF(/client, giveadminhelpverb)), 1200, TIMER_STOPPABLE) //2 minute cooldown of admin helps

//private
/datum/admin_help/proc/FullMonty(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = ADMIN_FULLMONTY_NONAME(initiator.mob)
	if(state == AHELP_ACTIVE)
		. += ClosureLinks(ref_src)

//private
/datum/admin_help/proc/ClosureLinks(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=reject'>REJT</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=icissue'>IC</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=close'>CLOSE</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=resolve'>RSLVE</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=handleissue'>HANDLE</A>)"

//private
/datum/admin_help/proc/LinkedReplyName(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	return "<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=reply'>[initiator_key_name]</A>"

//private
/datum/admin_help/proc/TicketHref(msg, ref_src, action = "ticket")
	if(!ref_src)
		ref_src = "[REF(src)]"
	return "<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=[action]'>[msg]</A>"

//message from the initiator without a target, all admins will see this
//won't bug irc
/datum/admin_help/proc/MessageNoRecipient(msg, play_sound = TRUE)
	msg = copytext_char(msg, 1, MAX_MESSAGE_LEN)
	var/ref_src = "[REF(src)]"
	// Truncate the displayed name in the inline notification to keep the header readable
	var/display_name = length_char(name) > 60 ? "[copytext_char(name, 1, 61)]..." : name
	// Simplified message to be sent to all admins, including title and action links
	var/admin_msg = span_adminnotice("<font color='#c87941'><b>Ticket #[id]: [display_name] ([initiator_ckey]) - [TicketHref("Show Ticket", ref_src)][ClosureLinks(ref_src)]</b><br><span class='linkify' style='font-weight:normal;color:#c87941'>[msg]</span></font>")

	AddInteraction("<font color='red'>[LinkedReplyName(ref_src)]: [msg]</font>")

	// Log full player message content in addition to title
	log_admin_private("Ticket #[id]: [initiator_key_name] -> Admins: [msg]")

	//send this msg to all admins
	for(var/client/X in GLOB.admins)
		if(play_sound && (X.prefs.toggles & SOUND_ADMINHELP))
			SEND_SOUND(X, sound('sound/adminhelp.ogg'))
		window_flash(X, ignorepref = TRUE)
		to_chat(X, type = MESSAGE_TYPE_ADMINPM, html = admin_msg)

	//show it to the person adminhelping too
	to_chat(initiator, type = MESSAGE_TYPE_ADMINPM, html = span_adminnotice("发送给<b>管理员</b>的私信：<font color='#FFA040'><span class='linkify'>[msg]</span></font>"))

//Reopen a closed ticket
/datum/admin_help/proc/Reopen()
	if(state == AHELP_ACTIVE)
		to_chat(usr, span_warning("This ticket is already open."))
		return

	if(GLOB.ahelp_tickets.CKey2ActiveTicket(initiator_ckey))
		to_chat(usr, span_warning("This user already has an active ticket, cannot reopen this one."))
		return

	statclick = new(null, src)
	GLOB.ahelp_tickets.active_tickets += src
	GLOB.ahelp_tickets.closed_tickets -= src
	GLOB.ahelp_tickets.resolved_tickets -= src
	switch(state)
		if(AHELP_CLOSED)
			SSblackbox.record_feedback("tally", "ahelp_stats", -1, "closed")
		if(AHELP_RESOLVED)
			SSblackbox.record_feedback("tally", "ahelp_stats", -1, "resolved")
	state = AHELP_ACTIVE
	closed_at = null
	if(initiator)
		initiator.current_ticket = src

	AddInteraction("<font color='purple'>Reopened by [key_name_ahelp(usr)]</font>")
	var/msg = span_adminhelp("Ticket [TicketHref("#[id]")] reopened by [key_name_admin(usr)].")
	message_admins(msg)
	log_admin_private(msg)
	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "reopened")
	// TGUI will auto-update

//private
/datum/admin_help/proc/RemoveActive()
	if(state != AHELP_ACTIVE)
		return
	closed_at = world.time
	QDEL_NULL(statclick)
	GLOB.ahelp_tickets.active_tickets -= src
	if(initiator && initiator.current_ticket == src)
		initiator.current_ticket = null

//Mark open ticket as closed/meme
/datum/admin_help/proc/Close(key_name = key_name_admin(usr), display_name = key_name_ahelp(usr), silent = FALSE)
	if(state != AHELP_ACTIVE)
		return
	RemoveActive()
	state = AHELP_CLOSED
	GLOB.ahelp_tickets.ListInsert(src)
	to_chat(initiator, span_adminhelp("[display_name]已关闭此次求助。"))
	AddInteraction("<font color='purple'>[display_name]已关闭此次求助。</font>")
	if(!silent)
		SSblackbox.record_feedback("tally", "ahelp_stats", 1, "closed")
		var/msg = "Ticket [TicketHref("#[id]")] closed by [key_name]."
		message_admins(msg)
		log_admin_private(msg)

//Mark open ticket as resolved/legitimate, returns ahelp verb
/datum/admin_help/proc/Resolve(key_name = key_name_admin(usr), display_name = key_name_ahelp(usr), silent = FALSE)
	if(state != AHELP_ACTIVE)
		return
	RemoveActive()
	state = AHELP_RESOLVED
	GLOB.ahelp_tickets.ListInsert(src)

	addtimer(CALLBACK(initiator, TYPE_PROC_REF(/client, giveadminhelpverb)), 50)

	AddInteraction("<font color='green'>[display_name]已解决此次求助。</font>")
	to_chat(initiator, span_adminhelp("[display_name]已解决你的求助。Adminhelp求助命令将很快恢复可用。"))
	if(!silent)
		SSblackbox.record_feedback("tally", "ahelp_stats", 1, "resolved")
		var/msg = "Ticket [TicketHref("#[id]")] resolved by [key_name]"
		message_admins(msg)
		log_admin_private(msg)

//Close and return ahelp verb, use if ticket is incoherent
/datum/admin_help/proc/Reject(key_name = key_name_admin(usr), display_name = key_name_ahelp(usr))
	if(state != AHELP_ACTIVE)
		return

	if(initiator)
		initiator.giveadminhelpverb()

		SEND_SOUND(initiator, sound('sound/adminhelp.ogg'))

		to_chat(initiator, "<font color='red' size='4'><b>- [display_name]拒绝了此次求助！-</b></font>")
		to_chat(initiator, "<font color='red'><b>你的求助已被拒绝。</b>Adminhelp求助命令已恢复，你可以重新提交。</font>")
		to_chat(initiator, "求助时请保持冷静，清楚、详细地描述问题。不要假定管理员已经见过相关事件，并明确写出你举报的玩家姓名。")

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "rejected")
	var/msg = "Ticket [TicketHref("#[id]")] rejected by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("[display_name]拒绝了此次求助。")
	Close(silent = TRUE)

//Resolve ticket with IC Issue message
/datum/admin_help/proc/ICIssue(key_name = key_name_admin(usr), display_name = key_name_ahelp(usr))
	if(state != AHELP_ACTIVE)
		return

	var/msg = "<font color='red' size='4'><b>- [display_name]将此次求助标记为角色内问题！-</b></font><br>"
	msg += "<font color='red'>由于问题涉及回合中的事件，管理员无法直接回答。这个问题可能应在角色扮演中解决，请通过角色内行动处理！</font>"
	if(initiator)
		to_chat(initiator, msg)

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "IC")
	msg = "Ticket [TicketHref("#[id]")] marked as IC by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("[display_name]将此次求助标记为角色内问题")
	Resolve(silent = TRUE)

//Let the initiator know their ahelp is being handled
/datum/admin_help/proc/HandleIssue(key_name = key_name_admin(usr), display_name = key_name_ahelp(usr))
	if(state != AHELP_ACTIVE)
		return

	var/msg = "<span class ='adminhelp'>管理员正在处理你的求助，请耐心等待。</span>"

	if(initiator)
		to_chat(initiator, msg)

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "handling")
	msg = "Ticket [TicketHref("#[id]")] is being handled by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("[display_name]正在处理此次求助")

//Show the ticket panel
/datum/admin_help/proc/TicketPanel()
	// Redirect to TGUI admin panel and pre-select this ticket
	if(usr?.client)
		// Remember this ticket as selected for this admin so that
		// "Show Ticket" links in chat focus the correct entry.
		GLOB.ahelp_tickets.selected_tickets[usr.ckey] = id
		GLOB.ahelp_tickets.ui_interact(usr)
		// The TGUI will handle rendering the selected ticket

/datum/admin_help/proc/Retitle()
	var/new_title = input(usr, "Enter a title for the ticket", "Rename Ticket", name) as text|null
	if(new_title)
		name = new_title
		//not saying the original name cause it could be a long ass message
		var/msg = "Ticket [TicketHref("#[id]")] titled [name] by [key_name_admin(usr)]"
		message_admins(msg)
		log_admin_private(msg)
		AddInteraction("Retitled by [key_name_ahelp(usr)]")

//Forwarded action from admin/Topic
/datum/admin_help/proc/Action(action)
	testing("Ahelp action: [action]")
	switch(action)
		if("ticket")
			TicketPanel()
		if("retitle")
			Retitle()
		if("reject")
			Reject()
		if("reply")
			usr.client.cmd_ahelp_reply(initiator)
		if("icissue")
			ICIssue()
		if("close")
			Close()
		if("resolve")
			Resolve()
		if("handleissue")
			HandleIssue()
		if("reopen")
			Reopen()

//
// TGUI INTERFACE
//

/datum/admin_help/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AdminHelpChat", "Admin Help")
		ui.open()

/datum/admin_help/ui_data(mob/user)
	var/list/data = list()
	
	data["ticket_id"] = id
	data["ticket_name"] = html_decode(name)
	data["ticket_state"] = state == AHELP_ACTIVE ? "ACTIVE" : (state == AHELP_CLOSED ? "CLOSED" : "RESOLVED")
	data["can_send"] = (state == AHELP_ACTIVE)
	data["initiator_ckey"] = initiator_ckey
	data["initiator_name"] = initiator_key_name
	data["opened_at"] = opened_at
	data["closed_at"] = closed_at
	data["is_admin"] = user.client?.holder ? TRUE : FALSE
	
	data["messages"] = list()
	for(var/interaction in _interactions)
		// Parse the interaction log
		var/list/msg_data = list()
		// time_stamp() format is "hh:mm:ss" (8 chars) + ": " (2 chars) = 10 chars total
		var/timestamp = copytext_char(interaction, 1, 9)  // Extract "hh:mm:ss"
		var/rest = copytext_char(interaction, 11)  // Skip "hh:mm:ss: " (10 chars)
		
		msg_data["timestamp"] = timestamp
		msg_data["full_text"] = interaction
		
		// Strip ALL HTML tags - simple and robust approach
		var/clean_text = rest
		// Convert <br> tags to actual newlines before stripping other tags
		clean_text = replacetext(clean_text, "<br>", "\n")
		clean_text = replacetext(clean_text, "<br/>", "\n")
		clean_text = replacetext(clean_text, "<br />", "\n")
		// Keep stripping tags until none remain
		var/max_iterations = 100 // Safety limit
		var/iterations = 0
		while(iterations < max_iterations)
			iterations++
			var/tag_start = findtext(clean_text, "<")
			if(!tag_start || tag_start == 0)
				break
			var/tag_end = findtext(clean_text, ">", tag_start)
			if(!tag_end || tag_end == 0)
				// Broken tag at end, just remove everything from < onwards
				// Use copytext (byte-based) to match findtext's byte positions
				clean_text = copytext(clean_text, 1, tag_start)
				break
			
			// Check if this is a link tag - extract the link text
			// copytext uses byte positions, consistent with findtext
			var/tag_section = copytext(clean_text, tag_start, tag_end + 1)
			if(findtext(tag_section, "<A ") == 1 || findtext(tag_section, "<a ") == 1)
				// Find the closing </A>
				var/close_pos = findtext(clean_text, "</A>", tag_end)
				if(!close_pos)
					close_pos = findtext(clean_text, "</a>", tag_end)
				if(close_pos && close_pos > 0)
					// Extract text between tags (all byte-based to match findtext)
					var/link_text = copytext(clean_text, tag_end + 1, close_pos)
					clean_text = copytext(clean_text, 1, tag_start) + link_text + copytext(clean_text, close_pos + 4)
					continue
			
			// Remove this tag (byte-based to match findtext)
			clean_text = copytext(clean_text, 1, tag_start) + copytext(clean_text, tag_end + 1)

		// Decode HTML entities so special characters like ', <, > display correctly
		clean_text = html_decode(clean_text)
		
		// Detect message type and parse accordingly
		if(findtext(rest, "<font color='red'>"))
			// Uses the first colon instead. The last one truncates the message in a silly way for admins

			msg_data["is_admin"] = FALSE
			msg_data["author"] = initiator_key_name
			var/search_from = 1 // Anchor past the initial colon, so a colon inside can't shift the boundary
			var/name_pos = findtext(clean_text, initiator_key_name)
			if(name_pos)
				search_from = name_pos + length(initiator_key_name) - 1
			var/colon_pos = findtext(clean_text, ": ", search_from)
			if(colon_pos)
				msg_data["message"] = trim(copytext(clean_text, colon_pos + 2))
			else
				msg_data["message"] = trim(clean_text)
		else if(findtext(rest, "<font color='blue'>") || findtext(rest, "PM from"))
			msg_data["is_admin"] = TRUE
			msg_data["author"] = "Admin"
			var/search_from = 1 // Again, like the admin shit, we want to ensure we start looking from the FIRST colon. So, we can properly truncate the incoming text field
			if(findtext(clean_text, "PM from"))
				var/name_start = findtext(clean_text, "PM from") + 8
				var/name_end = findtext(clean_text, ":", name_start)
				if(name_end)
					msg_data["author"] = trim(copytext(clean_text, name_start, name_end))
					search_from = name_end
			var/colon_pos = findtext(clean_text, ": ", search_from)
			if(colon_pos)
				msg_data["message"] = trim(copytext(clean_text, colon_pos + 2))
			else
				msg_data["message"] = trim(clean_text)
		else if(findtext(rest, "<font color='green'>"))
			// System message (positive/info)
			msg_data["is_admin"] = FALSE
			msg_data["author"] = "System"
			msg_data["message"] = trim(clean_text)
		else
			// Other system messages
			msg_data["is_admin"] = FALSE
			msg_data["author"] = "System"
			msg_data["message"] = trim(clean_text)

		// Detect embedded media — EMBED_IMAGE: and EMBED_VIDEO: are 12 chars each,
		// so the URL starts at position 13.
		var/raw_msg = msg_data["message"]
		if(raw_msg && findtext(raw_msg, "EMBED_IMAGE:") == 1)
			msg_data["embed_type"] = "image"
			msg_data["embed_url"] = copytext(raw_msg, 13)
			msg_data["message"] = "（嵌入图片）"
		else if(raw_msg && findtext(raw_msg, "EMBED_VIDEO:") == 1)
			msg_data["embed_type"] = "video"
			msg_data["embed_url"] = copytext(raw_msg, 13)
			msg_data["message"] = "（嵌入视频）"

		data["messages"] += list(msg_data)
	
	return data

/datum/admin_help/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	
	switch(action)
		if("send_message")
			if(state != AHELP_ACTIVE)
				return FALSE
			
			var/message = params["message"]
			if(!message)
				return FALSE

			// Preserve newlines as <br> so they survive sanitization and display correctly in TGUI
			message = sanitize_preserve_newlines(trim(message))
			if(!message)
				return FALSE

			// Send the message
			MessageNoRecipient(message, FALSE)
			TimeoutVerb()
			
			return TRUE
		
		if("embed_media")
			if(state != AHELP_ACTIVE)
				return FALSE
			if(!usr.client?.holder)
				return FALSE
			var/url = params["url"]
			var/embed_type = params["embed_type"]
			if(!url || !embed_type)
				return FALSE
			url = trim(url)
			if(findtext(url, "https://") != 1)
				return FALSE
			if(embed_type != "image" && embed_type != "video")
				return FALSE
			var/prefix = embed_type == "image" ? "EMBED_IMAGE:" : "EMBED_VIDEO:"
			AddInteraction("<font color='blue'>PM from [key_name_ahelp(usr)]: [prefix][url]</font>")
			if(initiator)
				to_chat(initiator, span_adminhelp("<b>[key_name_ahelp(usr)]在你的求助记录中嵌入了[list("image" = "图片", "video" = "视频")[embed_type] || "媒体"]。</b>"))
			log_admin_private("Ticket #[id]: [key_name(usr)] embedded [embed_type]: [url]")
			return TRUE

/datum/admin_help/ui_state(mob/user)
	return GLOB.always_state

//
// TICKET STATCLICK
//

/obj/effect/statclick/ahelp
	var/datum/admin_help/ahelp_datum

/obj/effect/statclick/ahelp/Initialize(mapload, datum/admin_help/AH)
	ahelp_datum = AH
	. = ..()

/obj/effect/statclick/ahelp/update()
	return ..(ahelp_datum.name)

/obj/effect/statclick/ahelp/Click()
	ahelp_datum.TicketPanel()

/obj/effect/statclick/ahelp/Destroy()
	ahelp_datum = null
	return ..()

//
// CLIENT PROCS
//

/client/proc/giveadminhelpverb()
	src.verbs |= /client/verb/adminhelp
	deltimer(adminhelptimerid)
	adminhelptimerid = 0

// Used for methods where input via arg doesn't work
/client/proc/get_adminhelp()
	// If there's an existing ticket, open the TGUI chat window
	if(current_ticket)
		current_ticket.ui_interact(mob)
		return
	
	// Otherwise, use the old input method for initial ticket creation
	var/msg = input(src, "请简明地描述问题，管理员会尽快提供帮助。", "管理员求助内容") as message|null
	adminhelp(msg)

/client/verb/adminhelp(msg as message)
	set category = "-Admin-"
	set name = "Adminhelp"

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("管理员暂时禁用了发言。"))
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, span_danger("无法发送管理员求助：你已被禁言。"))
		return
	
	// If no message provided and we have an existing ticket, open the TGUI window
	if(!msg && current_ticket)
		current_ticket.ui_interact(mob)
		return
	
	if(handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	msg = sanitize(trim(msg))

	if(!msg)
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Adminhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(current_ticket)
		if(alert(usr, "你已有一条未关闭的求助。这是同一个问题吗？",,"是","否") != "否")
			if(current_ticket)
				current_ticket.MessageNoRecipient(msg, FALSE)
				current_ticket.TimeoutVerb()
				return
			else
				to_chat(usr, span_warning("未找到求助记录，正在创建新求助……"))
		else
			current_ticket.AddInteraction("[key_name_ahelp(usr)] opened a new ticket.")
			current_ticket.Close()

	new /datum/admin_help(msg, src, FALSE)

/client/verb/reopenticket()
	set category = "-Admin-"
	set name = "View Ticket"
	set desc = "重新打开管理员求助聊天窗口"
	
	if(!current_ticket)
		to_chat(src, span_notice("你目前没有正在处理的管理员求助。"))
		return
	
	current_ticket.ui_interact(mob)

//
// LOGGING
//

//Use this proc when an admin takes action that may be related to an open ticket on what
//what can be a client, ckey, or mob
/proc/admin_ticket_log(what, message)
	var/client/C
	var/mob/Mob = what
	if(istype(Mob))
		C = Mob.client
	else
		C = what
	if(istype(C) && C.current_ticket)
		var/datum/admin_help/AH = C.current_ticket
		// Only log to admin logs; do not expose as a ticket chat message
		log_admin_private("Ticket #[AH.id]: [message]")
		return AH
	if(istext(what))	//ckey
		var/datum/admin_help/AH = GLOB.ahelp_tickets.CKey2ActiveTicket(what)
		if(AH)
			// Only log to admin logs; do not expose as a ticket chat message
			log_admin_private("Ticket #[AH.id]: [message]")
			return AH

//
// HELPER PROCS
//

/proc/get_admin_counts(requiredflags = R_BAN)
	. = list("total" = list(), "noflags" = list(), "afk" = list(), "stealth" = list(), "present" = list())
	for(var/client/X in GLOB.admins)
		.["total"] += X
		if(requiredflags != 0 && !check_rights_for(X, requiredflags))
			.["noflags"] += X
		else if(X.is_afk())
			.["afk"] += X
		else if(X.holder.fakekey)
			.["stealth"] += X
		else
			.["present"] += X

/proc/send2irc_adminless_only(source, msg, requiredflags = R_BAN)
	var/list/adm = get_admin_counts(requiredflags)
	var/list/activemins = adm["present"]
	. = activemins.len
	if(. <= 0)
		var/final = ""
		var/list/afkmins = adm["afk"]
		var/list/stealthmins = adm["stealth"]
		var/list/powerlessmins = adm["noflags"]
		var/list/allmins = adm["total"]
		if(!afkmins.len && !stealthmins.len && !powerlessmins.len)
			final = "[msg] - No admins online"
		else
			final = "[msg] - All admins stealthed\[[english_list(stealthmins)]\], AFK\[[english_list(afkmins)]\], or lacks +BAN\[[english_list(powerlessmins)]\]! Total: [allmins.len] "
		send2irc(source,final)
		send2otherserver(source,final)


/proc/send2irc(msg,msg2)
	msg = replacetext(replacetext(msg, "\proper", ""), "\improper", "")
	msg2 = replacetext(replacetext(msg2, "\proper", ""), "\improper", "")
	world.TgsTargetedChatBroadcast("[msg] | [msg2]", TRUE)

/proc/send2otherserver(source,msg,type = "Ahelp")
	var/comms_key = CONFIG_GET(string/comms_key)
	if(!comms_key)
		return
	var/list/message = list()
	message["message_sender"] = source
	message["message"] = msg
	message["source"] = "([CONFIG_GET(string/cross_comms_name)])"
	message["key"] = comms_key
	message += type

	var/list/servers = CONFIG_GET(keyed_list/cross_server)
	for(var/I in servers)
		world.Export("[servers[I]]?[list2params(message)]")


/proc/ircadminwho()
	var/list/message = list("Admins: ")
	var/list/admin_keys = list()
	for(var/adm in GLOB.admins)
		var/client/C = adm
		admin_keys += "[C][C.holder.fakekey ? "(Stealth)" : ""][C.is_afk() ? "(AFK)" : ""]"

	for(var/admin in admin_keys)
		if(LAZYLEN(message) > 1)
			message += ", [admin]"
		else
			message += "[admin]"

	return jointext(message, "")

/proc/keywords_lookup(msg,irc)

	//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
	var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as", "i")

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	var/founds = ""
	for(var/mob/M in GLOB.mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)
			indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i>=1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				var/mob/found = ckeys[word]
				if(!found)
					found = surnames[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
				if(found)
					if(!(found in mobs_found))
						mobs_found += found
						var/is_antag = 0
						if(found.mind && found.mind.special_role)
							is_antag = 1
						founds += "Name: [found.name]([found.real_name]) Key: [found.key] Ckey: [found.ckey] [is_antag ? "(Antag)" : null] "
						msg += "[original_word]<font size='1' color='[is_antag ? "red" : "black"]'>(<A HREF='?_src_=holder;[HrefToken(TRUE)];adminmoreinfo=[REF(found)]'>?</A>|<A HREF='?_src_=holder;[HrefToken(TRUE)];adminplayerobservefollow=[REF(found)]'>F</A>)</font> "
						continue
		msg += "[original_word] "
	if(irc)
		if(founds == "")
			return "Search Failed"
		else
			return founds

	return msg

//
// ADMIN TICKET PANEL VERB
//

/client/proc/open_ticket_panel()
	set category = "Admin"
	set name = "Open Ticket Panel"
	
	if(!check_rights(R_AHELP))
		return
	
	GLOB.ahelp_tickets.ui_interact(mob)
