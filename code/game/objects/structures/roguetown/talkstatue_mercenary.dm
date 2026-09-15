/*
Mercenary statue backend. Ported from Azure-Peak's talkstatue_mercenary.dm as-is.

ES port note (Step 9e): landed the backend procs below (message_single_mercenary(),
broadcast_to_mercenaries(), the Topic() register/response link handlers) plus a stopgap
input()-menu attack_hand() standing in for AP's real TGUI, since talkstatue_tgui.dm was
deferred at the time.

ES port note (Step 9f): the stopgap attack_hand() (and its cycle_mercenary_status() helper)
have been REMOVED and replaced by the real attack_hand() -> ui_interact() -> Talkstatue TGUI
wiring, now living in talkstatue_tgui.dm alongside ui_state()/ui_data()/ui_act(). Status is
now set via ui_act("set_merc_status") calling talkstatue_tgui.dm's set_role_status() against
mercenary_status, rather than the old three-way cycle. message_single_mercenary() and
broadcast_to_mercenaries() below are unchanged and are called directly from
talkstatue_tgui.dm's ui_act() ("contact_merc" / "broadcast_mercs").

This also replaces ES's old noticeboard-embedded mercenary DM system (silver/gold roguecoin
gate, GLOB.sellsword_noticeboardposts, MERC_STATUS_*, mercdmcooldown/mercbroadcastcooldown
status effects) - see noticeboard.dm's header comment for the full note. One behavioral
difference to flag: the old ES system required paying a roguecoin (silver to DM one merc,
gold to broadcast to all) to use it; this ported system has no coin cost, matching AP
upstream. That cost gate was not reimplemented here - flagged for follow-up if wanted.
*/

/obj/structure/roguemachine/talkstatue/mercenary/Initialize(mapload)
	. = ..()
	if(SSroguemachine.mercenary_statue == null)
		SSroguemachine.mercenary_statue = src
	SSroguemachine.mercenary_statues |= src

/obj/structure/roguemachine/talkstatue/mercenary/Destroy()
	SSroguemachine.mercenary_statues -= src
	if(SSroguemachine.mercenary_statue == src)
		SSroguemachine.mercenary_statue = length(SSroguemachine.mercenary_statues) ? SSroguemachine.mercenary_statues[1] : null
	return ..()

/// Real player entry point (Step 9f) - opens the Talkstatue TGUI (see talkstatue_tgui.dm)
/// instead of the old input() menu.
/obj/structure/roguemachine/talkstatue/mercenary/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	ui_interact(user)

/obj/structure/roguemachine/talkstatue/mercenary/proc/message_single_mercenary(mob/living/carbon/human/sender)
	var/list/available_mercenaries = list()
	var/list/stale_keys = list()

	for(var/merc_key in mercenary_status)
		var/list/merc_data = mercenary_status[merc_key]
		var/mob/living/carbon/human/merc = merc_data["mob"]

		if(!merc || QDELETED(merc))
			stale_keys += merc_key
			continue
		if(merc.stat == DEAD)
			continue
		if(merc_data["status"] == "Do not Disturb")
			continue

		var/status_text = merc_data["status"] || "Available"
		var/display_name = "[merc.real_name] ([status_text])"
		available_mercenaries[display_name] = merc

	for(var/key in stale_keys)
		mercenary_status -= key

	if(!available_mercenaries.len)
		to_chat(sender, span_warning("目前没有可供联络的佣兵。"))
		return

	var/choice = input(sender, "我想联络哪位佣兵？", "佣兵联络") as null|anything in available_mercenaries
	if(!choice)
		return

	var/mob/living/carbon/human/target_merc = available_mercenaries[choice]

	var/cooldown_key = "[sender.real_name]_[target_merc.real_name]"
	if(sender_cooldowns[cooldown_key])
		var/time_left = sender_cooldowns[cooldown_key] + single_cooldown - world.time
		if(time_left > 0)
			var/mins_left = max(1, round(time_left / 600))
			to_chat(sender, span_warning("我需要等待 [mins_left] 分钟后才能再次联络 [target_merc.real_name]。"))
			return

	if(!Adjacent(sender))
		to_chat(sender, span_warning("我需要靠近雕像。"))
		return

	var/message = stripped_input(sender, "我想发送什么讯息？（最多 [message_char_limit] 个字符）", "佣兵联络", "", message_char_limit)
	if(!message)
		return

	if(!Adjacent(sender))
		to_chat(sender, span_warning("我离雕像太远了。"))
		return

	sender_cooldowns[cooldown_key] = world.time

	response_id_counter++
	var/response_id = "[target_merc.real_name]_[world.time]_[response_id_counter]"
	if(!QDELETED(target_merc) && !QDELETED(sender))
		pending_direct_responses[response_id] = list("responder" = target_merc, "sender" = sender)
		addtimer(CALLBACK(src, PROC_REF(expire_direct_response), response_id), response_timeout)

	to_chat(target_merc, span_boldnotice("佣兵雕像在我脑海中低语：<i>[message]</i> - [sender.real_name]<br><a href='?src=[REF(src)];direct_response=yae;response_id=[response_id]'>\[YAE\]</a> | <a href='?src=[REF(src)];direct_response=nae;response_id=[response_id]'>\[NAE\]</a>"))
	to_chat(sender, span_notice("我的讯息已发送给 [target_merc.real_name]。"))
	playsound(target_merc.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)

	sender.log_talk(message, LOG_SAY, tag="mercenary statue (to [key_name(target_merc)])")
	target_merc.log_talk(message, LOG_SAY, tag="mercenary statue (from [key_name(sender)])", log_globally=FALSE)

/obj/structure/roguemachine/talkstatue/mercenary/proc/broadcast_to_mercenaries(mob/living/carbon/human/sender)
	var/broadcast_key = "broadcast_[sender.real_name]"
	if(sender_cooldowns[broadcast_key])
		var/time_left = sender_cooldowns[broadcast_key] + broadcast_cooldown_time - world.time
		if(time_left > 0)
			var/mins_left = max(1, round(time_left / 600))
			to_chat(sender, span_warning("我需要等待 [mins_left] 分钟后才能再次广播。"))
			return

	if(!Adjacent(sender))
		to_chat(sender, span_warning("我需要靠近雕像。"))
		return

	var/list/valid_recipients = list()
	for(var/merc_key in mercenary_status)
		var/list/merc_data = mercenary_status[merc_key]
		var/mob/living/carbon/human/merc = merc_data["mob"]

		if(!merc || merc.stat == DEAD)
			continue
		if(merc_data["status"] == "Do not Disturb")
			continue

		valid_recipients += merc

	if(valid_recipients.len == 0)
		to_chat(sender, span_warning("没有可供广播的佣兵。"))
		return

	var/message = stripped_input(sender, "我想向所有佣兵广播什么讯息？（最多 [message_char_limit] 个字符）", "佣兵广播", "", message_char_limit)
	if(!message)
		return

	if(!Adjacent(sender))
		to_chat(sender, span_warning("我离雕像太远了。"))
		return

	sender_cooldowns[broadcast_key] = world.time

	var/list/recipient_keys = list()
	for(var/mob/living/carbon/human/merc in valid_recipients)
		recipient_keys += key_name(merc)

	for(var/mob/living/carbon/human/merc in valid_recipients)
		response_id_counter++
		var/response_id = "[merc.real_name]_[world.time]_[response_id_counter]"
		if(!QDELETED(merc) && !QDELETED(sender))
			pending_broadcast_responses[response_id] = list("responder" = merc, "sender" = sender)
			addtimer(CALLBACK(src, PROC_REF(expire_broadcast_response), response_id), response_timeout)

		to_chat(merc, span_boldannounce("佣兵雕像高声宣告：<i>[message]</i> - [sender.real_name]<br><a href='?src=[REF(src)];broadcast_interest=[response_id]'>\[Signal Interest\]</a>"))
		playsound(merc.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)

	var/merc_count = valid_recipients.len
	to_chat(sender, span_notice("我的讯息已广播给 [merc_count] 名佣兵。"))
	src.statue_bark(1)

	sender.log_talk(message, LOG_SAY, tag="mercenary statue broadcast (to [recipient_keys.Join(", ")])")

/obj/structure/roguemachine/talkstatue/mercenary/Topic(href, href_list)
	. = ..()

	if(href_list["register"])
		var/mob/living/carbon/human/H = locate(href_list["register"])
		if(!H)
			return
		if(!pending_registrations[H.key])
			to_chat(usr, span_warning("该登记链接已失效。"))
			return
		if(H.mind?.assigned_role != "Mercenary")
			to_chat(usr, span_warning("我已不再是佣兵。"))
			pending_registrations -= H.key
			return
		if(!H.mind)
			return
		if(!H.advjob)
			to_chat(H, span_warning("在向雕像登记之前，我需要先选择我的佣兵职业。"))
			return

		var/list/merc_data = list("status" = "Available", "mob" = H, "message" = "")
		mercenary_status[H.real_name] = merc_data
		pending_registrations -= H.key

		to_chat(H, span_boldnotice("我已向佣兵行会登记！我现在的状态是 <b>可雇</b>。"))
		to_chat(H, span_notice("我可以亲自前往雕像更改状态，或从远处 <a href='?src=[REF(src)];set_message_remote=[REF(H)]'>召回我的佣兵讯息</a>。（此链接 2 分钟后失效）"))
		playsound(H.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)

		if(!QDELETED(H))
			pending_message_links[H.key] = H
			addtimer(CALLBACK(src, PROC_REF(expire_message_link), H.key), 2 MINUTES)
		return

	if(href_list["set_message_remote"])
		var/mob/living/carbon/human/H = locate(href_list["set_message_remote"])
		if(!H)
			return
		if(usr != H)
			to_chat(usr, span_warning("该链接并非为我而设。"))
			return
		if(!pending_message_links[H.key])
			to_chat(usr, span_warning("该讯息链接已失效。"))
			return
		if(!mercenary_status[H.real_name])
			to_chat(usr, span_warning("我未在佣兵雕像网络中登记。"))
			pending_message_links -= H.key
			return
		if(H.mind?.assigned_role != "Mercenary")
			to_chat(usr, span_warning("我已不再是佣兵。"))
			pending_message_links -= H.key
			return

		var/list/merc_data = mercenary_status[H.real_name]
		var/current_msg = merc_data["message"] || ""
		var/new_msg = stripped_input(H, "输入我的佣兵讯息（最多 300 个字符）：", "佣兵讯息", current_msg, 300)

		if(new_msg != null)
			merc_data["message"] = new_msg
			to_chat(H, span_notice("我的讯息已被雕像召回。若需进一步更改，我必须亲自前往。"))
			playsound(H.loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

		pending_message_links -= H.key
		return

	if(href_list["broadcast_interest"])
		if(!ishuman(usr))
			return
		var/mob/living/carbon/human/responder = usr
		var/response_id = href_list["broadcast_interest"]

		if(!pending_broadcast_responses[response_id])
			to_chat(responder, span_warning("该回应链接已失效或已被使用。"))
			return

		var/list/response_data = pending_broadcast_responses[response_id]
		var/mob/living/carbon/human/stored_responder = response_data["responder"]
		var/mob/living/carbon/human/sender = response_data["sender"]

		if(responder != stored_responder)
			to_chat(responder, span_warning("该回应链接并非为我而设。"))
			return

		if(!sender || QDELETED(sender))
			to_chat(responder, span_warning("发送者已不在可用状态。"))
			pending_broadcast_responses -= response_id
			return

		if(!responder.mind || responder.mind.assigned_role != "Mercenary")
			to_chat(responder, span_warning("我并非佣兵。"))
			return

		pending_broadcast_responses -= response_id

		to_chat(sender, span_notice("[responder.real_name] 对我的公告表示了兴趣。"))
		playsound(sender.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)

		to_chat(responder, span_notice("我已向 [sender.real_name] 表示了兴趣。"))
		playsound(responder.loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

		responder.log_talk("signaled interest", LOG_SAY, tag="mercenary statue broadcast response (to [key_name(sender)])")
		return

	if(href_list["direct_response"])
		if(!ishuman(usr))
			return
		var/mob/living/carbon/human/responder = usr
		var/response_type = href_list["direct_response"]
		var/response_id = href_list["response_id"]

		if(!pending_direct_responses[response_id])
			to_chat(responder, span_warning("该回应链接已失效或已被使用。"))
			return

		var/list/response_data = pending_direct_responses[response_id]
		var/mob/living/carbon/human/stored_responder = response_data["responder"]
		var/mob/living/carbon/human/sender = response_data["sender"]

		if(responder != stored_responder)
			to_chat(responder, span_warning("该回应链接并非为我而设。"))
			return

		if(!sender || QDELETED(sender))
			to_chat(responder, span_warning("发送者已不在可用状态。"))
			pending_direct_responses -= response_id
			return

		pending_direct_responses -= response_id

		if(response_type == "yae")
			to_chat(sender, span_notice("[responder.real_name] 对我的讯息作出了肯定的回应。"))
			to_chat(responder, span_notice("我已对 [sender.real_name] 作出了肯定的回应。"))
		else
			to_chat(sender, span_notice("[responder.real_name] 对我的讯息作出了否定的回应。"))
			to_chat(responder, span_notice("我已对 [sender.real_name] 作出了否定的回应。"))

		playsound(sender.loc, 'sound/misc/notice (2).ogg', 100, FALSE, -1)
		playsound(responder.loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

		responder.log_talk("direct response: [response_type]", LOG_SAY, tag="mercenary statue direct response (to [key_name(sender)])")
		return

/obj/structure/roguemachine/talkstatue/mercenary/proc/expire_registration(key)
	if(pending_registrations[key])
		pending_registrations -= key

/obj/structure/roguemachine/talkstatue/mercenary/proc/expire_message_link(key)
	if(pending_message_links[key])
		pending_message_links -= key

/obj/structure/roguemachine/talkstatue/mercenary/proc/expire_broadcast_response(response_id)
	if(pending_broadcast_responses[response_id])
		pending_broadcast_responses -= response_id

/obj/structure/roguemachine/talkstatue/mercenary/proc/expire_direct_response(response_id)
	if(pending_direct_responses[response_id])
		pending_direct_responses -= response_id

/obj/structure/roguemachine/talkstatue/mercenary/proc/statue_bark(mode)
	if(mode == 1)
		var/random = rand(1,4)
		switch(random)
			if(1)
				say("他们听到了！别的事我可不敢保证。")
			if(2)
				say("说不定你谈价时能捞到好价钱。")
			if(3)
				say("怎么，你是要去杀人吗？嘿嘿！开玩笑的。")
			if(4)
				say("你最后拿金子去做什么，那是你自己的事。")
