/*
The Rosewall. A bathhouse service board, spiritually kin to the mercenary statue
(talkstatue_mercenary.dm): bathhouse workers pin an advert for their services, and any
passerby may peruse the board, examine a worker's headshot, or send them an offer.

- Only Bathmasters and Bathhouse Attendants may pin/edit/remove an advert or set a status.
- Statuses: Available / Hired / Do not Disturb. A worker set to Do not Disturb cannot be sent offers (the button is hidden client-side and enforced server-side).
- Offers are delivered as a whisper to the worker with YAE/NAE response hrefs, handled in Topic() below (same pattern as the mercenary statue's direct responses).
- "Examine Headshot" opens the poster's /datum/examine_panel (the examine closer window), the same datum used by the examine chat link.
- Icon state rises with the number of pinned adverts: noticeboardbh0 -> noticeboardbh3.
*/

#define ROSEWALL_STATUS_AVAILABLE "Available"
#define ROSEWALL_STATUS_HIRED "Hired"
#define ROSEWALL_STATUS_DND "Do not Disturb"

/obj/structure/roguemachine/rosewall
	name = "蔷薇墙"
	desc = "一块浸染着浴油香气的红木告示板，上面挂着散发芬芳的羊皮纸笺。浴场侍者在这里张贴服务告示，供来往之人浏览。"
	icon = 'icons/roguetown/structure/noticeboard32.dmi'
	icon_state = "noticeboardbh0"
	density = FALSE
	anchored = TRUE
	max_integrity = 0
	blade_dulling = DULLING_BASH
	layer = ABOVE_MOB_LAYER
	pixel_y = 32

	/// All adverts currently pinned to the Rosewall, keyed by the worker's real_name. Shared by every Rosewall board.
	var/static/list/rosewall_adverts = list()
	/// Pending YAE/NAE offer responses, keyed by response id.
	var/static/list/pending_offer_responses = list()
	/// Per sender/target cooldowns for sending offers.
	var/static/list/sender_cooldowns = list()
	var/static/response_id_counter = 0
	var/message_char_limit = 300
	var/response_timeout = 2 MINUTES
	var/offer_cooldown = 10 MINUTES

/obj/structure/roguemachine/rosewall/Initialize(mapload)
	. = ..()
	SSroguemachine.rosewalls += src
	update_icon()

/obj/structure/roguemachine/rosewall/Destroy()
	SSroguemachine.rosewalls -= src
	return ..()

/obj/structure/roguemachine/rosewall/update_icon()
	. = ..()
	switch(length(rosewall_adverts))
		if(0)
			icon_state = "noticeboardbh0"
		if(1 to 3)
			icon_state = "noticeboardbh1"
		if(4 to 6)
			icon_state = "noticeboardbh2"
		else
			icon_state = "noticeboardbh3"

/// Refreshes every mapped Rosewall so a new advert shows up on all of them.
/obj/structure/roguemachine/rosewall/proc/update_all_boards()
	for(var/obj/structure/roguemachine/rosewall/board in SSroguemachine.rosewalls)
		board.update_icon()

/obj/structure/roguemachine/rosewall/proc/is_bathhouse_worker(mob/living/carbon/human/H)
	return istype(H) && (H.job in list("Bathmaster", "Bathhouse Attendant"))

/obj/structure/roguemachine/rosewall/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	ui_interact(user)

/obj/structure/roguemachine/rosewall/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/rosewall/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Rosewall", name)
		ui.open()

/// Prunes stale entries from the static lists: adverts whose worker is gone or
/// disconnected, offer responses past their timeout (whose expiry timer may have
/// died with a destroyed board), and offer cooldowns that have already elapsed.
/// Returns TRUE if any adverts were pruned.
/obj/structure/roguemachine/rosewall/proc/prune_stale_adverts()
	for(var/response_id in pending_offer_responses)
		var/list/response_data = pending_offer_responses[response_id]
		if(!response_data["expires"] || world.time > response_data["expires"])
			pending_offer_responses -= response_id
	for(var/cooldown_key in sender_cooldowns)
		if(sender_cooldowns[cooldown_key] + offer_cooldown < world.time)
			sender_cooldowns -= cooldown_key
	var/list/stale_keys = list()
	for(var/advert_key in rosewall_adverts)
		var/list/advert_data = rosewall_adverts[advert_key]
		var/mob/living/carbon/human/worker = advert_data["mob"]
		if(!worker || QDELETED(worker) || !worker.ckey)
			stale_keys += advert_key
	if(!length(stale_keys))
		return FALSE
	for(var/key in stale_keys)
		rosewall_adverts -= key
	return TRUE

/obj/structure/roguemachine/rosewall/ui_data(mob/user)
	var/list/data = list()
	if(prune_stale_adverts())
		update_all_boards()
	var/mob/living/carbon/human/H = user
	data["is_bathhouse"] = is_bathhouse_worker(H) ? TRUE : FALSE
	data["my_key"] = istype(H) ? H.real_name : ""
	data["message_char_limit"] = message_char_limit
	data["status_options"] = list(ROSEWALL_STATUS_AVAILABLE, ROSEWALL_STATUS_HIRED, ROSEWALL_STATUS_DND)
	var/list/adverts = list()
	for(var/advert_key in rosewall_adverts)
		var/list/advert_data = rosewall_adverts[advert_key]
		var/mob/living/carbon/human/worker = advert_data["mob"]
		adverts += list(list(
			"key" = advert_key,
			"name" = worker.real_name,
			"status" = advert_data["status"] || ROSEWALL_STATUS_AVAILABLE,
			"message" = advert_data["message"] || "",
			"advjob" = worker.advjob || "",
		))
	data["adverts"] = adverts
	return data

/obj/structure/roguemachine/rosewall/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(!Adjacent(H))
		to_chat(H, span_warning("我得再靠近告示板一些。"))
		return
	switch(action)
		if("set_status")
			if(!is_bathhouse_worker(H))
				return
			var/new_status = params["status"]
			if(!(new_status in list(ROSEWALL_STATUS_AVAILABLE, ROSEWALL_STATUS_HIRED, ROSEWALL_STATUS_DND)))
				return
			var/list/advert_data = rosewall_adverts[H.real_name]
			if(!advert_data)
				advert_data = list("status" = ROSEWALL_STATUS_AVAILABLE, "mob" = H, "message" = "")
				rosewall_adverts[H.real_name] = advert_data
			advert_data["status"] = new_status
			advert_data["mob"] = H
			to_chat(H, span_notice("我将自己在蔷薇墙上的状态设为：<b>[new_status == ROSEWALL_STATUS_AVAILABLE ? "可接待" : new_status == ROSEWALL_STATUS_HIRED ? "已受雇" : "请勿打扰"]</b>"))
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			log_admin_private("[key_name(H)] set Rosewall status to [new_status]")
			update_all_boards()
			return TRUE
		if("edit_advert")
			if(!is_bathhouse_worker(H))
				return
			var/list/advert_data = rosewall_adverts[H.real_name]
			if(!advert_data)
				advert_data = list("status" = ROSEWALL_STATUS_AVAILABLE, "mob" = H, "message" = "")
				rosewall_adverts[H.real_name] = advert_data
			var/current_msg = advert_data["message"] || ""
			var/new_msg = stripped_input(H, "撰写我要张贴在蔷薇墙上的告示（最多[message_char_limit]个字符）：", "蔷薇墙告示", current_msg, message_char_limit)
			if(new_msg == null)
				return
			if(!Adjacent(H))
				to_chat(H, span_warning("我离告示板太远了。"))
				return
			advert_data["message"] = new_msg
			advert_data["mob"] = H
			to_chat(H, span_notice("我的告示已张贴在蔷薇墙上。"))
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			log_admin_private("[key_name(H)] set Rosewall advert: \"[new_msg]\"")
			update_all_boards()
			return TRUE
		if("remove_advert")
			if(!is_bathhouse_worker(H))
				return
			if(!rosewall_adverts[H.real_name])
				to_chat(H, span_warning("我没有在这里张贴告示。"))
				return
			rosewall_adverts -= H.real_name
			to_chat(H, span_notice("我从蔷薇墙上撤下了自己的告示。"))
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			log_admin_private("[key_name(H)] removed their Rosewall advert")
			update_all_boards()
			return TRUE
		if("send_offer")
			var/target_key = params["key"]
			if(!target_key || target_key == H.real_name)
				return
			send_offer(H, target_key)
			return TRUE
		if("examine_headshot")
			var/target_key = params["key"]
			if(!target_key)
				return
			examine_headshot(H, target_key)
			return TRUE

/// Opens the poster's examine closer window for the viewer.
/obj/structure/roguemachine/rosewall/proc/examine_headshot(mob/living/carbon/human/viewer, target_key)
	var/list/advert_data = rosewall_adverts[target_key]
	if(!advert_data)
		to_chat(viewer, span_warning("那张告示已经不在这里了。"))
		return
	var/mob/living/carbon/human/worker = advert_data["mob"]
	if(!worker || QDELETED(worker))
		rosewall_adverts -= target_key
		update_all_boards()
		to_chat(viewer, span_warning("那张告示已经不在这里了。"))
		return
	var/datum/examine_panel/mob_examine_panel = new(worker)
	mob_examine_panel.holder = worker
	mob_examine_panel.viewing = viewer
	mob_examine_panel.ui_interact(viewer)

/// Sends an offer message to the advert's worker, with YAE/NAE response links.
/obj/structure/roguemachine/rosewall/proc/send_offer(mob/living/carbon/human/sender, target_key)
	var/list/advert_data = rosewall_adverts[target_key]
	if(!advert_data)
		to_chat(sender, span_warning("那张告示已经不在这里了。"))
		return
	var/mob/living/carbon/human/worker = advert_data["mob"]
	if(!worker || QDELETED(worker) || worker.stat == DEAD || !worker.ckey)
		rosewall_adverts -= target_key
		update_all_boards()
		to_chat(sender, span_warning("不知为何，我的邀约无法送达。"))
		return
	if(advert_data["status"] == ROSEWALL_STATUS_DND)
		to_chat(sender, span_warning("[worker.real_name]目前不希望被打扰。"))
		return
	var/cooldown_key = "rosewall_[sender.real_name]_[worker.real_name]"
	if(sender_cooldowns[cooldown_key])
		var/time_left = sender_cooldowns[cooldown_key] + offer_cooldown - world.time
		if(time_left > 0)
			var/mins_left = max(1, round(time_left / 600))
			to_chat(sender, span_warning("我还得等[mins_left]分钟，才能再次向[worker.real_name]发出邀约。"))
			return
	if(!Adjacent(sender))
		to_chat(sender, span_warning("我得待在告示板附近。"))
		return
	var/message = stripped_input(sender, "我想发出怎样的邀约？（最多[message_char_limit]个字符）", "蔷薇墙邀约", "", message_char_limit)
	if(!message)
		return
	if(!Adjacent(sender))
		to_chat(sender, span_warning("我离告示板太远了。"))
		return
	sender_cooldowns[cooldown_key] = world.time
	response_id_counter++
	var/response_id = "rosewall_[worker.real_name]_[world.time]_[response_id_counter]"
	if(!QDELETED(worker) && !QDELETED(sender))
		// Tracked by expiry time rather than an addtimer bound to this board, so the
		// entry cannot leak (holding refs to both mobs) if this board is destroyed.
		pending_offer_responses[response_id] = list("responder" = worker, "sender" = sender, "expires" = world.time + response_timeout)
	to_chat(worker, span_boldnotice("一张散发芬芳的纸笺从蔷薇墙飘到了我面前：<i>[message]</i> - [sender.real_name]<br><a href='?src=[REF(src)];offer_response=yae;response_id=[response_id]'>\[接受\]</a> | <a href='?src=[REF(src)];offer_response=nae;response_id=[response_id]'>\[拒绝\]</a>"))
	to_chat(sender, span_notice("我的邀约已送达[worker.real_name]。"))
	playsound(worker.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)
	sender.log_talk(message, LOG_SAY, tag="rosewall offer (to [key_name(worker)])")
	worker.log_talk(message, LOG_SAY, tag="rosewall offer (from [key_name(sender)])", log_globally=FALSE)

/obj/structure/roguemachine/rosewall/Topic(href, href_list)
	. = ..()
	if(href_list["offer_response"])
		if(!ishuman(usr))
			return
		var/mob/living/carbon/human/responder = usr
		var/response_type = href_list["offer_response"]
		var/response_id = href_list["response_id"]

		if(!pending_offer_responses[response_id])
			to_chat(responder, span_warning("这个回复链接已过期或已被使用。"))
			return

		var/list/response_data = pending_offer_responses[response_id]
		if(world.time > response_data["expires"])
			pending_offer_responses -= response_id
			to_chat(responder, span_warning("这个回复链接已过期或已被使用。"))
			return
		var/mob/living/carbon/human/stored_responder = response_data["responder"]
		var/mob/living/carbon/human/sender = response_data["sender"]

		if(responder != stored_responder)
			to_chat(responder, span_warning("这个回复链接不是给我的。"))
			return

		if(!sender || QDELETED(sender))
			to_chat(responder, span_warning("已经联系不上邀约人了。"))
			pending_offer_responses -= response_id
			return

		pending_offer_responses -= response_id

		if(response_type == "yae")
			to_chat(sender, span_notice("[responder.real_name]接受了我的邀约。"))
			to_chat(responder, span_notice("我接受了[sender.real_name]的邀约。"))
		else
			to_chat(sender, span_notice("[responder.real_name]拒绝了我的邀约。"))
			to_chat(responder, span_notice("我拒绝了[sender.real_name]的邀约。"))

		playsound(sender.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)
		playsound(responder.loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

		responder.log_talk("offer response: [response_type]", LOG_SAY, tag="rosewall offer response (to [key_name(sender)])")
		return

#undef ROSEWALL_STATUS_AVAILABLE
#undef ROSEWALL_STATUS_HIRED
#undef ROSEWALL_STATUS_DND
