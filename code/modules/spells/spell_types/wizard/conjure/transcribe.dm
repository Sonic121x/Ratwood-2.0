/datum/action/cooldown/spell/transcribe
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	name = "抄录术"
	desc = "召出羊皮纸与魔法羽毛笔，为你记录文字。\n\
	魔法羊皮纸最多聆听十分钟，并将听到的内容抄录在纸上。\n\
	（在手中使用以开始，再次使用以停止记录。）"
	button_icon_state = "transcribe"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_LIGHT
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("记下此言。")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 0.5 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/item
	var/item_type = /obj/item/paper/magictranscription
	var/delete_old = TRUE //TRUE to delete the last summoned object if it's still there, FALSE for infinite item stream weeeee

/datum/action/cooldown/spell/transcribe/cast(list/targets, mob/user = usr)
	. = ..()
	if (delete_old && item && !QDELETED(item))
		QDEL_NULL(item)
	if(user.dropItemToGround(user.get_active_held_item()))
		user.put_in_hands(make_item(), TRUE)
		user.visible_message(span_info("羊皮纸与蓝色魔法羽毛笔出现在[user]手中！"), span_info("你召出了羊皮纸与魔法羽毛笔！"))
	return TRUE

/datum/action/cooldown/spell/transcribe/Destroy()
	if(item)
		qdel(item)
	return ..()

/datum/action/cooldown/spell/transcribe/proc/make_item()
	item = new item_type
	var/mutable_appearance/magic_overlay = mutable_appearance('icons/roguetown/items/misc.dmi', "magicquill")
	item.add_overlay(magic_overlay)
	return item

/obj/item/paper/transcript
	name = "抄录稿"
	desc = "一张写满抄录内容的魔法纸张。"

/obj/item/paper/transcript/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		if(info)
			add_sleep_experience(user, /datum/skill/misc/reading, 2)
		return
	if(in_range(user, src) || isobserver(user))
//		var/obj/screen/read/R = user.hud_used.reads
		user << browse_rsc('html/book.png')
		var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html><head><style type=\"text/css\">
			body { background-image:url('book.png');background-repeat: repeat; }</style></head><body scroll=yes>"}
		dat += info
		dat += "<br>"
		dat += "<a href='?src=[REF(src)];close=1' style='position:absolute;right:50px'>关闭</a>"
		dat += "</body></html>"
		user << browse(dat, "window=reading;size=500x400;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=0;border=0")
		onclose(user, "reading", src)
	else
		return span_warning("我离得太远，无法阅读。")

/obj/item/paper/magictranscription
	name = "魔法抄录稿" //this is essentially just modern TG's tape recorder clumped together with our parchment code c:
	desc = "神秘的羊皮纸，激活时记录话语，停用时可将内容抄写出来。"
	icon_state = "paper"
	var/recording = FALSE
	var/list/storedinfo = list()
	var/list/timestamp = list()
	var/used_capacity = 0
	var/max_capacity = 6000 // 10 minutes
	var/time_warned = FALSE
	var/time_left_warning = 600 // 60 seconds
	var/canprint = TRUE

/obj/item/paper/magictranscription/Initialize(mapload)
	. = ..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)

/obj/item/paper/magictranscription/attack_self(mob/user)
	if(recording)
		stop_recording(user)
	else
		start_recording(user)

/obj/item/paper/magictranscription/proc/start_recording(mob/user)
	if(recording)
		to_chat(user, span_warning("羊皮纸已经在记录了！"))
		return
	if(used_capacity >= max_capacity)
		to_chat(user, span_warning("羊皮纸充满了魔法能量！"))
		return
	recording = TRUE
	become_hearing_sensitive()
	to_chat(user, span_notice("羊皮纸开始泛起微光，魔法羽毛笔记录着周围的话语……"))
	update_icon()
	while(recording && used_capacity < max_capacity)
		used_capacity += 10
		if(max_capacity - used_capacity < time_left_warning && !time_warned)
			time_warned = TRUE
			to_chat(user, span_warning("羊皮纸的光芒正在减弱……魔力还可持续 [(max_capacity - used_capacity) / 10] 秒。"))
		sleep(10)
	if(used_capacity >= max_capacity)
		to_chat(user, span_warning("羊皮纸的魔力耗尽了！"))
		stop_recording(user)

/obj/item/paper/magictranscription/proc/stop_recording(mob/user)
	if(!recording)
		return

	recording = FALSE
	time_warned = FALSE
	lose_hearing_sensitivity()
	update_icon()
	to_chat(user, span_notice("羊皮纸不再发光。"))
	if(storedinfo.len > 0)
		print_transcript(user)
		qdel(src)
	else
		to_chat(user, span_warning("羊皮纸是空白的，什么也没记录。"))

/obj/item/paper/magictranscription/Hear(message, atom/movable/speaker, message_langs, raw_message, list/spans, message_mods)
	. = ..()
	if(!recording)
		return
	if(speaker == src)
		return
	timestamp += used_capacity
	var/speaker_description = "未知"
	var/speaker_stature = "人物"
	if(ismob(speaker))
		var/mob/living/carbon/human/target = speaker
		var/list/d_list = target.get_mob_descriptors()
		var/descriptor_voice = build_coalesce_description_nofluff(d_list, speaker, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
		var/descriptor_stature = build_coalesce_description_nofluff(d_list, speaker, list(MOB_DESCRIPTOR_SLOT_STATURE), "%DESC1%")
		speaker_description = descriptor_voice
		speaker_stature = descriptor_stature
	else if(speaker)
		speaker_description = speaker.name
	storedinfo += "\[[time2text(used_capacity,"mm:ss")]\] [speaker_description] [speaker_stature]: [raw_message]"

/obj/item/paper/magictranscription/proc/print_transcript(mob/user)
	if(!storedinfo.len)
		return
	if(!canprint)
		to_chat(user, span_warning("再次输出前，羊皮纸需要时间恢复魔力！")) //failsafe incase it fails or something
		return
	var/transcribed_text = "<b>魔法抄录稿：</b><br><br>"
	var/paper_name = "魔法抄录稿"
	var/list/pages = list()
	for(var/excerpt in storedinfo)
		var/excerpt_length = length(excerpt)
		if(excerpt_length > maxlen)
			continue
		if((length(transcribed_text) + excerpt_length) > maxlen)
			pages += transcribed_text
			transcribed_text = "<b>魔法抄录稿（续）：</b><br><br>"
		transcribed_text += "[excerpt]<br>"
	if(transcribed_text != "<b>魔法抄录稿（续）：</b><br><br>")
		pages += transcribed_text
	var/page_index = 1
	var/obj/item/paper/first_page = null
	for(var/page_text in pages)
		var/obj/item/paper/transcript = new /obj/item/paper/transcript(get_turf(src))
		if(pages.len > 1)
			transcript.name = "[paper_name] - 第 [page_index]/[pages.len] 页"
		else
			transcript.name = paper_name
		transcript.info = page_text
		transcript.update_icon()
		transcript.updateinfolinks()
		if(page_index == 1)
			first_page = transcript
		page_index++
	if(first_page && user)
		user.put_in_hands(first_page)
	to_chat(user, span_notice("羽毛笔将内容魔法般地抄录到羊皮纸[pages.len > 1 ? "上" : "上"]，随后碎成尘埃！"))
	if(pages.len > 1)
		to_chat(user, span_notice("共生成 [pages.len] 页。"))

/obj/item/paper/magictranscription/update_icon_state()
	. = ..()
	if(recording)
		add_overlay("paper_onfire_overlay")
	else
		cut_overlay("paper_onfire_overlay")

/obj/item/paper/magictranscription/examine(mob/user)
	. = ..()
	if(recording)
		. += span_notice("它正记录周围的话语，泛着微弱的魔法光晕。")
	else if(storedinfo.len > 0)
		var/time = used_capacity / 10
		var/mins = round(time / 60)
		var/secs = time - mins * 60
		. += span_notice("它记录了 [storedinfo.len] 段话语（魔力剩余 [mins] 分 [secs] 秒）。")
	else
		. += span_notice("它还是空白的，随时可以开始记录。")
