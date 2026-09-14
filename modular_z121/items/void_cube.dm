// New records keep the original object in a private nullspace vault.
// stored_data also accepts the old scalar/reagent snapshots for compatibility.
/obj/item/void_cube
	name = "虚空魔方"
	desc = "一枚刻满虚空纹路的黄铜魔方。可将手持物品连同内部内容封存，再完整取回。"
	icon = 'modular_z121/icon/item.dmi'
	icon_state = "void_cube"
	w_class = WEIGHT_CLASS_SMALL
	var/list/stored_data = list()
	var/next_record_id = 1
	var/obj/effect/z121_void_cube_vault/vault
	var/list/cube_sessions = list()
	var/busy = FALSE

/obj/effect/z121_void_cube_vault
	name = "虚空封存空间"
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = 0

/datum/z121_void_cube_session
	var/query = ""
	var/page = 1
	var/selected_id
	var/list/expanded = list()

/obj/item/void_cube/Initialize(mapload)
	. = ..()
	vault = new(null)

/obj/item/void_cube/Destroy()
	for(var/mob/user as anything in cube_sessions)
		if(user.client)
			user << browse(null, "window=[window_id()]")
		qdel(cube_sessions[user])
	cube_sessions.Cut()
	for(var/list/record in stored_data)
		unseal_record(record)
	if(!QDELETED(vault))
		var/turf/destination = get_turf(src)
		if(destination)
			for(var/obj/item/I in vault.contents.Copy())
				I.forceMove(destination)
		qdel(vault)
	vault = null
	stored_data.Cut()
	return ..()

/obj/item/void_cube/proc/window_id()
	return "void_cube_[REF(src)]"

/obj/item/void_cube/proc/can_operate(mob/user)
	if(QDELETED(src) || !isliving(user) || QDELETED(user) || user.incapacitated())
		return FALSE
	// No operating another player's carried cube or a cube inside a container.
	return loc == user || (isturf(loc) && user.Adjacent(src))

/obj/item/void_cube/attack_self(mob/user)
	if(!can_operate(user))
		return
	if(!cube_sessions[user])
		cube_sessions[user] = new /datum/z121_void_cube_session
	show_interface(user)

/obj/item/void_cube/proc/prepare_records()
	// IDs never depend on list indices, which shift after every extraction.
	for(var/list/record in stored_data)
		if(!record["id"])
			record["id"] = "entry_[next_record_id++]"

/obj/item/void_cube/proc/find_record(id)
	if(!istext(id))
		return null
	for(var/list/record in stored_data)
		if(record["id"] == id)
			return record
	return null

/obj/item/void_cube/proc/record_name(list/record)
	var/obj/item/I = record["item"]
	if(!QDELETED(I))
		return I.name
	return record["name"]

/obj/item/void_cube/proc/storage_reason(obj/item/target, mob/user)
	if(!can_operate(user))
		return "现在无法操作虚空魔方。"
	if(QDELETED(target) || target.loc != user || !user.is_holding(target))
		return "只能存入此刻拿在手上的物品，请刷新界面。"
	if(target.item_flags & (ABSTRACT | DROPDEL))
		return "这件物品无法安全封存。"
	if(HAS_TRAIT(target, TRAIT_NODROP))
		return "这件物品无法脱手。"
	// Walk the full containment tree, not only backpack's direct children.
	for(var/atom/A as anything in target.GetAllContents())
		if(ismob(A) || istype(A, /obj/item/void_cube))
			return "物品内部不能包含生物或任何虚空魔方。"
		var/datum/component/storage/S = A.GetComponent(/datum/component/storage)
		if(S)
			var/datum/component/storage/concrete/master = S.master()
			if(S.real_location() != A || (master && length(master.slaves)))
				return "连接外部或共享储物空间的容器不能封存。"
	return null

/obj/item/void_cube/proc/unseal_record(list/record)
	var/list/locks = record["locks"]
	if(!islist(locks))
		return
	for(var/list/lock_record in locks)
		var/datum/component/storage/S = lock_record["storage"]
		if(!QDELETED(S))
			S.set_locked(src, lock_record["locked"])
	record["locks"] = null

/obj/item/void_cube/proc/store_item(obj/item/target, mob/user)
	if(busy)
		return "魔方正在处理另一项操作。"
	var/reason = storage_reason(target, user)
	if(reason)
		return reason
	busy = TRUE
	if(QDELETED(vault))
		vault = new(null)
	var/list/record = list("id" = "entry_[next_record_id++]", "name" = target.name, "item" = target)
	var/list/locks = list()
	record["locks"] = locks
	for(var/atom/A as anything in target.GetAllContents())
		var/datum/component/storage/S = A.GetComponent(/datum/component/storage)
		if(S)
			locks += list(list("storage" = S, "locked" = S.locked))
			S.set_locked(src, TRUE) // Also closes every existing storage HUD.
	if(!user.transferItemToLoc(target, vault) || QDELETED(target) || target.loc != vault)
		unseal_record(record)
		busy = FALSE
		return "物品无法转移，未建立封存记录。"
	stored_data += list(record)
	busy = FALSE
	return "封存成功，物品及内部内容已一同保存。"

/obj/item/void_cube/proc/retrieve_item(id, mob/user)
	if(!can_operate(user))
		return "现在无法操作虚空魔方。"
	if(busy)
		return "魔方正在处理另一项操作。"
	var/list/record = find_record(id)
	if(!record)
		return "这条记录已被提取或不再存在，请刷新界面。"
	busy = TRUE
	var/obj/item/I
	if("item" in record)
		I = record["item"]
		if(QDELETED(I) || QDELETED(vault) || I.loc != vault)
			busy = FALSE
			return "封存物品已失效，记录保留供检查。"
	else
		I = restore_legacy(record)
		if(QDELETED(I))
			busy = FALSE
			return "旧数据无法完整还原，记录仍被保留。"
	var/turf/destination = get_turf(user)
	if(!destination)
		if(!("item" in record))
			qdel(I)
		busy = FALSE
		return "当前位置无法释放物品。"
	I.forceMove(destination)
	if(QDELETED(I) || I.loc != destination)
		busy = FALSE
		return "释放失败，记录仍被保留。"
	unseal_record(record)
	stored_data -= list(record)
	// Already at the user's feet: no second forceMove, no stack merging.
	user.put_in_hands(I, merge_stacks = FALSE)
	busy = FALSE
	return "提取成功；没有空手时，物品会放在脚下。"

// Only legacy records are reconstructed. Newly stored backpacks never use this.
/obj/item/void_cube/proc/restore_legacy(list/record)
	var/item_path = record["type"]
	if(!ispath(item_path, /obj/item) || ispath(item_path, /obj/item/void_cube))
		return null
	var/list/liquids = record["reagents"]
	var/total = 0
	for(var/list/R in liquids)
		var/reagent_path = R["type"]
		if(!GLOB.chemical_reagents_list[reagent_path] || !isnum(R["volume"]) || R["volume"] <= 0)
			return null
		total += R["volume"]
	var/obj/item/I = new item_path(null)
	if(QDELETED(I))
		return null
	if(total && (!I.reagents || I.reagents.maximum_volume < total))
		qdel(I)
		return null
	// Do not add snapshots on top of the constructor's prefilled liquids.
	if(islist(liquids) && I.reagents)
		I.reagents.clear_reagents()
		for(var/list/R in liquids)
			var/temperature = R["temperature"]
			if(!isnum(temperature))
				temperature = 300
			if(!I.reagents.add_reagent(R["type"], R["volume"], R["data"], temperature, TRUE))
				qdel(I)
				return null
	I.name = record["name"]
	I.desc = record["desc"]
	if(record["amount"] != null && hasvar(I, "amount"))
		I.vars["amount"] = record["amount"]
	if(record["integrity"] != null)
		I.obj_integrity = record["integrity"]
	return I

/obj/item/void_cube/Topic(href, list/href_list)
	var/mob/user = usr
	var/datum/z121_void_cube_session/session = cube_sessions[user]
	if(!session)
		return
	var/action = href_list["action"]
	if(action == "close" || href_list["close"])
		user << browse(null, "window=[window_id()]")
		cube_sessions -= user
		qdel(session)
		return
	if(!can_operate(user))
		user << browse(null, "window=[window_id()]")
		cube_sessions -= user
		qdel(session)
		return
	prepare_records()
	var/message
	switch(action)
		if("store")
			// Search only hands; never resolve an arbitrary client-provided object.
			var/obj/item/target
			for(var/obj/item/I in user.held_items)
				if(REF(I) == href_list["item"])
					target = I
					break
			message = store_item(target, user)
		if("extract")
			message = retrieve_item(href_list["id"], user)
		if("inspect")
			session.selected_id = href_list["id"]
			session.expanded.Cut()
		if("expand")
			var/list/record = find_record(session.selected_id)
			var/obj/item/root = record ? record["item"] : null
			if(!QDELETED(root) && root.loc == vault)
				for(var/atom/A as anything in root.GetAllContents())
					if(REF(A) == href_list["node"])
						if(session.expanded[REF(A)])
							session.expanded -= REF(A)
						else
							session.expanded[REF(A)] = TRUE
						break
		if("search")
			session.query = copytext(href_list["query"], 1, 101)
			session.page = 1
		if("page")
			session.page = max(1, round(text2num(href_list["page"])))
	show_interface(user, message)

/obj/item/void_cube/proc/show_interface(mob/user, message)
	var/datum/z121_void_cube_session/session = cube_sessions[user]
	if(!session || !user.client || !can_operate(user))
		return
	user << browse(render_interface(user, session, message), "window=[window_id()];size=800x650;can_resize=1")
	onclose(user, window_id(), src)

/obj/item/void_cube/proc/escape_html(value)
	return html_encode("[value]")

/obj/item/void_cube/proc/action_link(label, action, extra = "")
	return "<a class='button' href='byond://?src=[REF(src)];action=[action][extra]'>[escape_html(label)]</a>"

/obj/item/void_cube/proc/item_summary(obj/item/I)
	var/list/parts = list()
	if(hasvar(I, "quantity"))
		parts += "数量：[I.vars["quantity"]]"
	else if(hasvar(I, "amount"))
		parts += "数量：[I.vars["amount"]]"
	var/item_count = 0
	for(var/obj/item/child in I.contents)
		item_count++
	if(item_count)
		parts += "内含 [item_count] 件物品"
	if(I.reagents)
		parts += "液体：[round(I.reagents.total_volume, 0.01)] 单位"
	return escape_html(jointext(parts, " · "))

/obj/item/void_cube/proc/render_interface(mob/user, datum/z121_void_cube_session/session, message)
	prepare_records()
	var/html = {"<!DOCTYPE html><html lang="zh-CN"><head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge"><title>虚空魔方</title>
	<style>
	body{margin:0;padding:20px;background:#12101b;color:#e8e3f2;font:14px 'Microsoft YaHei','SimSun',Arial,sans-serif;}
	h1{margin:0;color:#d4b577;font-size:26px;}h2{margin:0 0 12px;color:#dac6fa;font-size:17px;}
	p{line-height:1.6;} .muted{color:#aaa0b9;font-size:12px;}
	.panel{padding:16px;margin-top:16px;border:1px solid #40334f;background:#1e1829;border-radius:8px;}
	.notice{border-left:3px solid #c2a16b;padding:10px;background:#30253d;}
	.button{display:inline-block;text-decoration:none;color:#f3eafa;background:#514064;border:1px solid #79608e;padding:6px 12px;margin:3px;border-radius:4px;}
	.button:hover{background:#6c5087;} .disabled{color:#9b899e;} .toolbar{text-align:right;}
	table{border-collapse:collapse;width:100%;}td{padding:10px 4px;border-bottom:1px solid #372c44;vertical-align:top;}td.actions{text-align:right;white-space:nowrap;}
	input{font:inherit;padding:7px;color:#f3eafa;background:#15101e;border:1px solid #6c577f;}
	ul{padding-left:22px;}li{padding:5px 0;}.pager{margin-top:12px;text-align:center;}
	</style></head><body>"}
	html += "<h1>虚空魔方</h1><p class='muted'>物品封存 · 容量不限 · 已存 [length(stored_data)] 条记录</p>"
	html += "<div class='toolbar'>[action_link("刷新", "refresh")] [action_link("关闭", "close")]</div>"
	if(message)
		html += "<p class='notice'>[escape_html(message)]</p>"
	html += "<div class='panel'><h2>手持物品</h2><table>"
	var/shown = FALSE
	for(var/obj/item/I in user.held_items)
		if(I == src)
			continue
		shown = TRUE
		var/reason = storage_reason(I, user)
		html += "<tr><td>[escape_html(I.name)]<br><span class='muted'>[item_summary(I)]</span></td><td class='actions'>"
		if(reason)
			html += "<span class='disabled'>[escape_html(reason)]</span>"
		else
			html += action_link("存入", "store", ";item=[REF(I)]")
		html += "</td></tr>"
	html += "</table>"
	if(!shown)
		html += "<p class='muted'>请先将物品拿在手上。穿戴装备与口袋中的物品不会列入。</p>"
	html += "</div><div class='panel'><h2>已存物品</h2>"
	// A native GET form works in BYOND's legacy browser without JavaScript.
	html += "<form action='byond://' method='get'><input type='hidden' name='src' value='[REF(src)]'><input type='hidden' name='action' value='search'>"
	html += "<input name='query' maxlength='100' value='[escape_html(session.query)]'> <input type='submit' value='搜索名称'></form>"
	var/list/matches = list()
	for(var/list/record in stored_data)
		var/display_name = record_name(record)
		if(!length(session.query) || findtext(display_name, session.query))
			matches += list(record)
	var/pages = max(1, CEILING(length(matches) / 20, 1))
	session.page = clamp(session.page, 1, pages)
	html += "<table>"
	var/first = (session.page - 1) * 20 + 1
	for(var/i = first, i <= min(length(matches), first + 19), i++)
		var/list/record = matches[i]
		var/id = record["id"]
		var/obj/item/I = record["item"]
		html += "<tr><td>[escape_html(record_name(record))]<br><span class='muted'>"
		if(!("item" in record))
			html += "旧版数据"
		else if(QDELETED(I) || I.loc != vault)
			html += "物品已失效，记录保留供检查"
		else
			html += item_summary(I)
		html += "</span></td><td class='actions'>[action_link("查看", "inspect", ";id=[id]")] [action_link("提取", "extract", ";id=[id]")]</td></tr>"
	html += "</table>"
	if(!length(matches))
		html += "<p class='muted'>暂无匹配的记录。</p>"
	html += "<div class='pager'>[action_link("上一页", "page", ";page=[session.page - 1]")] [session.page] / [pages] [action_link("下一页", "page", ";page=[session.page + 1]")]</div></div>"
	var/list/selected = find_record(session.selected_id)
	if(selected)
		html += "<div class='panel'><h2>物品详情</h2>"
		var/obj/item/I = selected["item"]
		if(!QDELETED(I) && I.loc == vault)
			html += render_details(I, session)
		else
			html += "<p>[escape_html(record_name(selected))]</p><p>[escape_html(selected["desc"])]</p>"
			html += "<p class='muted'>旧数据仅保留当时记录的属性；已丢失的内容无法恢复。</p>"
		html += "</div>"
	return html + "<p class='muted'>背包将连同内容完整取回。封存不会暂停腐败或其他计时效果。</p></body></html>"

/obj/item/void_cube/proc/render_details(obj/item/I, datum/z121_void_cube_session/session)
	var/html = "<p><b>[escape_html(I.name)]</b><br>[escape_html(I.desc)]</p>"
	html += "<p class='muted'>[item_summary(I)] · 耐久：[I.obj_integrity] / [I.max_integrity]</p>"
	if(I.reagents)
		html += "<ul>"
		for(var/datum/reagent/R in I.reagents.reagent_list)
			html += "<li>[escape_html(R.name)]：[round(R.volume, 0.01)] 单位</li>"
		html += "</ul>"
	html += render_contents(I, session, 0)
	return html

/obj/item/void_cube/proc/render_contents(atom/root, datum/z121_void_cube_session/session, depth)
	if(!length(root.contents))
		return ""
	if(depth >= 20)
		return "<p class='muted'>更深层内容已保留，提取后可查看。</p>"
	var/html = "<ul>"
	for(var/obj/item/I in root.contents)
		html += "<li>[escape_html(I.name)] <span class='muted'>[item_summary(I)]</span>"
		if(length(I.contents) || I.reagents?.total_volume)
			var/is_expanded = session.expanded[REF(I)]
			html += action_link(is_expanded ? "收起" : "展开", "expand", ";node=[REF(I)]")
			if(is_expanded)
				if(I.reagents)
					for(var/datum/reagent/R in I.reagents.reagent_list)
						html += "<p class='muted'>[escape_html(R.name)]：[round(R.volume, 0.01)] 单位</p>"
				html += render_contents(I, session, depth + 1)
		html += "</li>"
	return html + "</ul>"
