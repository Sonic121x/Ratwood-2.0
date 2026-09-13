/obj/item/void_cube
	name = "虚空魔方"
	desc = "一枚刻满虚空纹路的黄铜魔方。它能把物品化作数据保存，再将数据重构回原物。"
	icon = 'modular_z121/icon/item.dmi'
	icon_state = "void_cube"
	w_class = WEIGHT_CLASS_SMALL
	var/list/stored_data = list()
	var/mob/interface_user

/obj/item/void_cube/attack_self(mob/user)
	if(user)
		interface_user = user
		show_interface(user)

/obj/item/void_cube/proc/show_interface(mob/user, message)
	if(!user || QDELETED(src)) return
	var/html = "<!DOCTYPE html><html lang='zh-CN'><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><meta charset='UTF-8'><title>虚空魔方</title><style>body{font-family:Arial,'Microsoft YaHei','SimSun',sans-serif;font-size:14px;}</style></head><body bgcolor='#101018' text='#eeeeff'><h2>虚空魔方</h2><p>数据记录：[length(stored_data)]</p>"
	if(message) html += "<p><b>[z121_html_encode(message)]</b></p>"
	html += "<hr><h3>已保存数据</h3>"
	if(!length(stored_data)) html += "<p>暂无数据。</p>"
	else
		for(var/i in 1 to length(stored_data))
			var/list/record = stored_data[i]
			var/record_name = record["name"]
			var/record_type = record["type"]
			var/record_amount = record["amount"]
			var/record_reagents = record["reagents"]
			html += "<p>[i]. [z121_html_encode(record_name)]（[record_type]）"
			if(record_amount != null) html += " × [record_amount]"
			if(length(record_reagents)) html += "<br>试剂：[reagent_summary(record_reagents)]"
			html += "<br><a href='byond://?src=\ref[src];action=inspect;id=[i]'>查看</a> <a href='byond://?src=\ref[src];action=extract;id=[i]'>提取</a></p>"
	html += "<hr><h3>存入物品</h3>"
	var/has_items = FALSE
	for(var/obj/item/I in user.contents)
		if(I == src || istype(I, /obj/item/void_cube) || istype(I, /obj/item/storage)) continue
		has_items = TRUE
		html += "<p>[z121_html_encode(I.name)] <a href='byond://?src=\ref[src];action=store;ref=\ref[I]'>存入</a></p>"
	if(!has_items) html += "<p>没有可存入的物品。</p>"
	html += "<hr><a href='byond://?src=\ref[src];action=refresh'>刷新</a> | <a href='byond://?src=\ref[src];action=close'>关闭</a></body></html>"
	user << browse(html, "window=void_cube;size=620x700")

/obj/item/void_cube/Topic(href, href_list)
	. = ..()
	var/mob/user = usr
	if(!user || user != interface_user || QDELETED(src) || (!user.Adjacent(src) && src.loc != user)) return
	var/action = href_list["action"]
	if(action == "close")
		user << browse(null, "window=void_cube")
		interface_user = null
		return
	if(action == "store")
		var/obj/item/target = locate(href_list["ref"])
		if(target && target.loc == user && target != src && !istype(target, /obj/item/void_cube) && !istype(target, /obj/item/storage)) store_item(target)
		show_interface(user)
		return
	var/index = text2num(href_list["id"])
	if(index < 1 || index > length(stored_data))
		show_interface(user)
		return
	if(action == "extract") show_interface(user, retrieve_item(index, user))
	else if(action == "inspect")
		var/list/record = stored_data[index]
		var/record_name = record["name"]
		var/record_type = record["type"]
		var/record_reagents = record["reagents"]
		var/summary = reagent_summary(record_reagents)
		show_interface(user, "[record_name]：类型 [record_type]；[summary]")

/obj/item/void_cube/proc/store_item(obj/item/target)
	var/list/record = list("type" = target.type, "name" = target.name, "desc" = target.desc)
	if(hasvar(target, "amount")) record["amount"] = target.vars["amount"]
	if(hasvar(target, "atom_integrity")) record["integrity"] = target.vars["atom_integrity"]
	if(target.reagents) record["reagents"] = snapshot_reagents(target.reagents)
	stored_data += list(record)
	qdel(target)

/obj/item/void_cube/proc/snapshot_reagents(datum/reagents/source)
	var/list/result = list()
	for(var/datum/reagent/R in source.reagent_list)
		result += list(list("type" = R.type, "volume" = R.volume, "temperature" = source.chem_temp, "data" = R.data ? R.data.Copy() : null))
	return result

/obj/item/void_cube/proc/retrieve_item(index, mob/user)
	var/list/record = stored_data[index]
	var/typepath = record["type"]
	var/obj/item/restored = new typepath(get_turf(user))
	if(!restored) return "数据无法重构，记录已保留。"
	restored.name = record["name"]
	restored.desc = record["desc"]
	if(record["amount"] != null && hasvar(restored, "amount")) restored.vars["amount"] = record["amount"]
	if(record["integrity"] != null && hasvar(restored, "atom_integrity")) restored.vars["atom_integrity"] = record["integrity"]
	if(length(record["reagents"]) && restored.reagents)
		for(var/list/R in record["reagents"])
			restored.reagents.add_reagent(R["type"], R["volume"], R["data"], R["temperature"], TRUE)
	stored_data.Cut(index, index + 1)
	if(!user.put_in_hands(restored)) restored.forceMove(get_turf(user))
	return "[restored.name]已成功提取。"

/obj/item/void_cube/proc/reagent_summary(list/reagents_data)
	if(!length(reagents_data)) return "无试剂"
	var/list/names = list()
	for(var/list/R in reagents_data)
		var/reagent_type = R["type"]
		var/reagent_volume = R["volume"]
		names += "[reagent_type] [reagent_volume]u"
	return jointext(names, ", ")

/obj/item/void_cube/proc/z121_html_encode(value)
	var/text = "[value]"
	text = replacetext(text, "&", "&amp;")
	text = replacetext(text, "<", "&lt;")
	text = replacetext(text, ">", "&gt;")
	text = replacetext(text, "\"", "&quot;")
	return text

