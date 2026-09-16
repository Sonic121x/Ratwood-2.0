#define Z121_CUBE_PAGE_SIZE 20
#define Z121_CUBE_EXTRACT_LIMIT 100
#define Z121_CUBE_COIN_STACK 20

// Counted records contain only a canonical type and a quantity. Sealed and old
// snapshot records stay separate: opening the UI must never normalize old items.
/obj/item/void_cube
	name = "虚空魔方"
	desc = "一枚刻满虚空纹路的黄铜魔方。将手持杂物化为可堆叠的数据；衣服、武器、卷轴、技能书和容器则保留原有状态完整封存。"
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
	var/filter = "all"
	var/page = 1
	var/selected_id
	var/message = "仅可存入手持物品。数据化会重置物品状态；封存保留原物品。"
	var/list/expanded = list()

/obj/item/void_cube/Initialize(mapload)
	. = ..()
	vault = new(null)

/obj/item/void_cube/Destroy()
	SStgui.close_uis(src)
	for(var/mob/user as anything in cube_sessions)
		qdel(cube_sessions[user])
	cube_sessions.Cut()
	var/turf/destination = get_turf(src)
	var/list/data_to_release = list()
	for(var/list/record in stored_data)
		unseal_record(record)
		if(!("item" in record))
			data_to_release += list(record.Copy())
	if(!QDELETED(vault))
		if(destination)
			for(var/obj/item/I in vault.contents.Copy())
				I.forceMove(destination)
		qdel(vault)
	vault = null
	if(destination && length(data_to_release))
		// This worker owns its records and outlives the deleted cube.
		new /datum/z121_void_cube_release(destination, data_to_release)
	stored_data.Cut()
	return ..()

/obj/item/void_cube/proc/can_operate(mob/user)
	if(QDELETED(src) || !isliving(user) || QDELETED(user) || user.incapacitated())
		return FALSE
	return loc == user || (isturf(loc) && user.Adjacent(src))

/obj/item/void_cube/attack_self(mob/user)
	ui_interact(user)

/obj/item/void_cube/ui_status(mob/user, datum/ui_state/state)
	if(!can_operate(user))
		return UI_CLOSE
	return min(..(), user.shared_ui_interaction(src))

/obj/item/void_cube/ui_interact(mob/user, datum/tgui/ui)
	if(!can_operate(user))
		return
	get_session(user)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VoidCube", name)
		ui.open()

/obj/item/void_cube/ui_close(mob/user)
	var/datum/z121_void_cube_session/session = cube_sessions[user]
	cube_sessions -= user
	if(session)
		qdel(session)

/obj/item/void_cube/proc/get_session(mob/user)
	if(!cube_sessions[user])
		cube_sessions[user] = new /datum/z121_void_cube_session
	return cube_sessions[user]

/obj/item/void_cube/proc/prepare_records()
	for(var/list/record in stored_data)
		if(!record["id"])
			var/new_id
			do
				new_id = "entry_[next_record_id++]"
			while(find_record(new_id))
			record["id"] = new_id

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
	if(record["mode"] == "counted")
		var/item_path = record["type"]
		return initial(item_path:name)
	return record["name"]

/obj/item/void_cube/proc/storage_reason(obj/item/target, mob/user)
	if(!can_operate(user))
		return "现在无法操作虚空魔方。"
	if(QDELETED(target) || target.loc != user || !user.is_holding(target))
		return "只能存入此刻拿在手上的物品。"
	if(target.item_flags & (ABSTRACT | DROPDEL))
		return "这件物品无法安全存入。"
	if(HAS_TRAIT(target, TRAIT_NODROP))
		return "这件物品无法脱手。"
	for(var/atom/A as anything in target.GetAllContents())
		if(ismob(A) || istype(A, /obj/item/void_cube))
			return "物品内部不能包含生物或任何虚空魔方。"
		var/datum/component/storage/S = A.GetComponent(/datum/component/storage)
		if(S)
			var/datum/component/storage/concrete/master = S.master()
			if(S.real_location() != A || (master && length(master.slaves)))
				return "连接外部或共享储物空间的容器不能封存。"
	if(!should_seal(target) && !counted_spec(target))
		return "无法确定物品的类型或实际数量，未存入。"
	return null

/obj/item/void_cube/proc/should_seal(obj/item/I)
	// Learning scrolls keep their type after use; used/oneuse, names and icons
	// are instance state. Recreating the type would grant a fresh use. Preserve
	// the whole family, including unused scrolls and spell-point/skill books.
	if(istype(I, /obj/item/book/granter) || istype(I, /obj/item/teleportation_scroll) || istype(I, /obj/item/enchantmentscroll) || istype(I, /obj/item/paper/scroll))
		return TRUE
	if(istype(I, /obj/item/clothing) || istype(I, /obj/item/rogueweapon) || istype(I, /obj/item/gun) || istype(I, /obj/item/melee))
		return TRUE
	// Some optional modules use the alternate weapon hierarchy.
	var/weapon_path = text2path("/obj/item/weapon")
	if(weapon_path && istype(I, weapon_path))
		return TRUE
	if(istype(I, /obj/item/storage) || I.GetComponent(/datum/component/storage) || length(I.contents))
		return TRUE
	// Snacks contain nutrition reagents but are food, not liquid containers.
	if(!istype(I, /obj/item/reagent_containers/food/snacks) && (istype(I, /obj/item/reagent_containers) || I.reagents))
		return TRUE
	return FALSE

/obj/item/void_cube/proc/counted_spec(obj/item/I)
	if(should_seal(I))
		return null
	var/item_path = I.type
	var/amount = 1
	if(istype(I, /obj/item/natural/bundle))
		var/obj/item/natural/bundle/B = I
		item_path = B.stacktype
		amount = B.amount
	else if(istype(I, /obj/item/construction/bundle))
		var/obj/item/construction/bundle/B = I
		item_path = B.stacktype
		amount = B.amount
	else if(istype(I, /obj/item/roguecoin))
		var/obj/item/roguecoin/C = I
		// Pile subtypes randomize on Initialize; use the single-coin type.
		for(var/coin_path in list(/obj/item/roguecoin/gold, /obj/item/roguecoin/silver, /obj/item/roguecoin/copper, /obj/item/roguecoin/inqcoin, /obj/item/roguecoin/gilbranze))
			if(C.base_type == initial(coin_path:base_type))
				item_path = coin_path
				break
		amount = C.quantity
	else
		// This checkout has no /obj/item/stack definition. Support that optional
		// hierarchy without introducing a compile-time dependency on it.
		var/stack_path = text2path("/obj/item/stack")
		if(stack_path && istype(I, stack_path) && hasvar(I, "amount"))
			amount = I.vars["amount"]
	if(!ispath(item_path, /obj/item) || ispath(item_path, /obj/item/void_cube) || !isnum(amount) || amount < 1 || amount != round(amount))
		return null
	return list("mode" = "counted", "type" = item_path, "count" = amount)

/obj/item/void_cube/proc/unseal_record(list/record)
	var/list/locks = record["locks"]
	if(!islist(locks))
		return
	for(var/list/lock_record in locks)
		var/datum/component/storage/S = lock_record["storage"]
		if(!QDELETED(S))
			S.set_locked(src, lock_record["locked"])
	record["locks"] = null

// Called under ui_act's operation lock; old hrefs have no mutation handler.
/obj/item/void_cube/proc/store_item(obj/item/target, mob/user)
	var/reason = storage_reason(target, user)
	if(reason)
		return reason
	if(QDELETED(vault))
		vault = new(null)
	var/list/record = list("name" = target.name, "item" = target)
	var/list/locks = list()
	record["locks"] = locks
	for(var/atom/A as anything in target.GetAllContents())
		var/datum/component/storage/S = A.GetComponent(/datum/component/storage)
		if(S)
			locks += list(list("storage" = S, "locked" = S.locked))
			S.set_locked(src, TRUE)
	var/transferred = FALSE
	try
		transferred = user.transferItemToLoc(target, vault)
	catch(var/exception/transfer_error)
		log_runtime("Void cube inventory transfer failed: [transfer_error]")
	if(!transferred || QDELETED(target) || target.loc != vault)
		if(!QDELETED(target) && target.loc == vault)
			stored_data += list(record)
			prepare_records()
			return "脱手回调发生异常；原物品已保留为封存记录，可完整取回。"
		unseal_record(record)
		return "物品无法转移，未建立记录。"
	// Keep a recovery record until normalization commits. A failed callback must
	// not leave an unreachable object in the private vault.
	stored_data += list(record)
	prepare_records()
	// Re-evaluate after dropped()/movement callbacks, before deleting anything.
	if(should_seal(target))
		return "已封存原物品，内部内容和液体均保留。"
	var/list/spec = counted_spec(target)
	if(!spec)
		return "物品数量发生变化，原物品已保留为封存记录。"
	var/list/existing
	for(var/list/candidate in stored_data)
		if(candidate["mode"] == "counted" && candidate["type"] == spec["type"])
			existing = candidate
			break
	var/old_count = existing ? existing["count"] : 0
	var/new_count = old_count + spec["count"]
	if(new_count - old_count != spec["count"])
		return "数量超出可精确记录的范围，原物品已保留为封存记录。"
	if(existing)
		existing["count"] = new_count
	else
		stored_data += list(spec)
	prepare_records()
	try
		qdel(target)
	catch(var/exception/deletion_error)
		log_runtime("Void cube normalization deletion failed: [deletion_error]")
	if(!QDELETED(target))
		if(existing)
			existing["count"] = old_count
		else
			stored_data -= list(spec)
		return "物品无法数据化，原物品已保留为封存记录。"
	stored_data -= list(record)
	return "已存入 [spec["count"]] 个基础单位；提取时恢复默认状态。"

/obj/item/void_cube/proc/retrieve_item(id, mob/user, amount)
	if(!can_operate(user))
		return "现在无法操作虚空魔方。"
	var/list/record = find_record(id)
	if(!record)
		return "记录已被提取或不存在，请刷新。"
	var/turf/destination = get_turf(user)
	if(!destination)
		return "当前位置无法释放物品。"
	if(record["mode"] == "counted")
		if(!isnum(amount) || amount < 1 || amount > Z121_CUBE_EXTRACT_LIMIT || amount != round(amount) || amount > record["count"])
			return "提取数量必须为 1～100 的整数，且不能超过库存。"
		var/released = 0
		while(released < amount && can_operate(user))
			var/list/created = z121_void_cube_materialize(record, amount - released)
			if(!created)
				break
			var/obj/item/I = created["item"]
			if(!z121_void_cube_place(I, destination, user))
				qdel(I)
				break
			released += created["count"]
			record["count"] -= created["count"]
		if(record["count"] <= 0)
			stored_data -= list(record)
		if(released < amount)
			return "成功提取 [released] / [amount] 个单位；未成功部分仍保留在魔方中。"
		return "已提取 [released] 个单位；手中放不下的已放在脚下。"
	var/obj/item/I
	if("item" in record)
		I = record["item"]
		if(QDELETED(I) || QDELETED(vault) || I.loc != vault)
			return "封存物品已失效，记录保留供检查。"
	else
		I = z121_void_cube_restore_legacy(record)
		if(QDELETED(I))
			return "旧数据无法完整还原，记录仍被保留。"
	if(!z121_void_cube_place(I, destination, user))
		if(!("item" in record))
			qdel(I)
		return "释放失败，记录仍被保留。"
	unseal_record(record)
	stored_data -= list(record)
	return "已取回物品；没有空手时放在脚下。"

// Produces one normal object/stack and reports how many base units it represents.
// No runtime item/reagent/component state is copied into counted records.
/proc/z121_void_cube_materialize(list/record, requested)
	var/item_path = record["type"]
	if(!ispath(item_path, /obj/item) || ispath(item_path, /obj/item/void_cube) || requested < 1)
		return null
	var/spawn_path = item_path
	var/units = 1
	var/bundle_path
	if(ispath(item_path, /obj/item/natural) || ispath(item_path, /obj/item/construction))
		bundle_path = initial(item_path:bundletype)
	if(requested > 1 && (ispath(bundle_path, /obj/item/natural/bundle) || ispath(bundle_path, /obj/item/construction/bundle)))
		if(initial(bundle_path:stacktype) == item_path && initial(bundle_path:maxamount) >= 2)
			spawn_path = bundle_path
			units = min(requested, initial(bundle_path:maxamount))
	var/obj/item/I
	try
		I = new spawn_path(null)
		if(QDELETED(I))
			return null
		if(istype(I, /obj/item/roguecoin))
			var/obj/item/roguecoin/C = I
			units = min(requested, Z121_CUBE_COIN_STACK)
			C.set_quantity(units)
		else if(istype(I, /obj/item/natural/bundle))
			var/obj/item/natural/bundle/B = I
			B.amount = units
			B.update_bundle()
		else if(istype(I, /obj/item/construction/bundle))
			var/obj/item/construction/bundle/B = I
			B.amount = units
			B.update_bundle()
		else
			var/stack_path = text2path("/obj/item/stack")
			if(stack_path && istype(I, stack_path) && hasvar(I, "amount") && hasvar(I, "max_amount"))
				units = min(requested, I.vars["max_amount"])
				I.vars["amount"] = units
				I.update_icon()
	catch(var/exception/error)
		log_runtime("Void cube materialization failed: [error]")
		if(!QDELETED(I))
			qdel(I)
		return null
	if(QDELETED(I) || I.type != spawn_path || units < 1)
		if(!QDELETED(I))
			qdel(I)
		return null
	return list("item" = I, "count" = units)

/proc/z121_void_cube_place(obj/item/I, turf/destination, mob/user)
	if(QDELETED(I) || !destination)
		return FALSE
	try
		// Try hands without first crossing a turf (which can merge coins).
		if(user)
			if(user.put_in_active_hand(I))
				return TRUE
			for(var/hand_index = 1, hand_index <= length(user.held_items), hand_index++)
				if(!user.held_items[hand_index] && user.put_in_hand(I, hand_index))
					return TRUE
		if(!QDELETED(I))
			I.forceMove(destination)
	catch(var/exception/placement_error)
		// Movement/equip callbacks can fail after moving the item. Inspect its
		// final location before deciding whether its data should be consumed.
		log_runtime("Void cube placement callback failed: [placement_error]")
	if(QDELETED(I))
		// Coins can be deleted by a successful native merge during forceMove.
		return istype(I, /obj/item/roguecoin) && I:quantity <= 0
	if(user && I.loc == user && user.is_holding(I))
		return TRUE
	if(I.loc != destination)
		return FALSE
	I.layer = initial(I.layer)
	I.plane = initial(I.plane)
	if(user)
		try
			I.dropped(user)
		catch(var/exception/drop_error)
			// Placement already succeeded; retrying would duplicate an item.
			log_runtime("Void cube floor drop callback failed: [drop_error]")
	return TRUE

// Compatibility only: new liquid containers always keep their original object.
/proc/z121_void_cube_restore_legacy(list/record)
	var/item_path = record["type"]
	if(!ispath(item_path, /obj/item) || ispath(item_path, /obj/item/void_cube))
		return null
	var/list/liquids = record["reagents"]
	var/total = 0
	for(var/list/R in liquids)
		if(!GLOB.chemical_reagents_list[R["type"]] || !isnum(R["volume"]) || R["volume"] <= 0)
			return null
		total += R["volume"]
	var/obj/item/I = new item_path(null)
	if(QDELETED(I))
		return null
	if(total && (!I.reagents || I.reagents.maximum_volume < total))
		qdel(I)
		return null
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

/datum/z121_void_cube_release
	var/turf/destination
	var/list/records

/datum/z121_void_cube_release/New(turf/release_turf, list/release_records)
	..()
	destination = release_turf
	records = release_records
	addtimer(CALLBACK(src, PROC_REF(release_batch)), 1)

/datum/z121_void_cube_release/proc/release_batch()
	// At most 25 objects per tick, even for an unlimited counted inventory.
	for(var/i = 1, i <= 25 && length(records), i++)
		var/list/record = records[1]
		var/list/created
		if(record["mode"] == "counted")
			created = z121_void_cube_materialize(record, min(record["count"], Z121_CUBE_EXTRACT_LIMIT))
		else
			var/obj/item/legacy = z121_void_cube_restore_legacy(record)
			if(!QDELETED(legacy))
				created = list("item" = legacy, "count" = 1)
		if(!created || !z121_void_cube_place(created["item"], destination))
			if(created)
				qdel(created["item"])
			log_runtime("Void cube destruction could not release [record["type"]].")
			records.Cut(1, 2)
			continue
		if(record["mode"] == "counted")
			record["count"] -= created["count"]
			if(record["count"] > 0)
				continue
		records.Cut(1, 2)
	if(length(records))
		addtimer(CALLBACK(src, PROC_REF(release_batch)), 1)
	else
		qdel(src)

/obj/item/void_cube/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	var/mob/user = ui.user
	if(usr != user || !can_operate(user))
		return TRUE
	var/datum/z121_void_cube_session/session = get_session(user)
	if(busy)
		session.message = "魔方正在处理另一项操作。"
		return TRUE
	prepare_records()
	busy = TRUE
	try
		switch(action)
			if("store")
				var/obj/item/target
				for(var/obj/item/I in user.held_items)
					if(REF(I) == params["item"])
						target = I
						break
				session.message = store_item(target, user)
			if("extract")
				session.message = retrieve_item(params["id"], user, params["amount"])
			if("inspect")
				session.selected_id = find_record(params["id"]) ? params["id"] : null
				session.expanded.Cut()
			if("expand")
				var/list/record = find_record(session.selected_id)
				var/obj/item/root = record ? record["item"] : null
				if(!QDELETED(root) && root.loc == vault)
					for(var/obj/item/I in root.GetAllContents())
						if(REF(I) == params["node"])
							if(session.expanded[REF(I)])
								session.expanded -= REF(I)
							else
								session.expanded[REF(I)] = TRUE
							break
			if("search")
				if(istext(params["query"]))
					session.query = copytext_char(params["query"], 1, 101)
					session.page = 1
			if("filter")
				if(params["filter"] in list("all", "counted", "sealed"))
					session.filter = params["filter"]
					session.page = 1
			if("page")
				if(isnum(params["page"]))
					session.page = max(1, round(params["page"]))
			if("refresh")
				session.message = "已刷新库存与手持物品。"
	catch(var/exception/error)
		log_runtime("Void cube operation failed: [error]")
		session.message = "操作发生异常，请检查当前库存后再试。"
	busy = FALSE
	return TRUE

/obj/item/void_cube/proc/item_ui(obj/item/I)
	var/quantity = 1
	if(hasvar(I, "quantity"))
		quantity = I.vars["quantity"]
	else if(hasvar(I, "amount"))
		quantity = I.vars["amount"]
	var/children = 0
	for(var/obj/item/child in I.contents)
		children++
	var/list/liquids = list()
	if(I.reagents)
		for(var/datum/reagent/R in I.reagents.reagent_list)
			liquids += list(list("name" = R.name, "volume" = round(R.volume, 0.01)))
	return list(
		"name" = I.name,
		"description" = I.desc,
		"icon" = "[I.icon]",
		"icon_state" = I.icon_state,
		"quantity" = quantity,
		"children" = children,
		"volume" = I.reagents ? round(I.reagents.total_volume, 0.01) : 0,
		"liquids" = liquids,
		"integrity" = I.obj_integrity,
		"max_integrity" = I.max_integrity,
	)

/obj/item/void_cube/proc/record_ui(list/record)
	var/list/data
	var/obj/item/I = record["item"]
	if(!QDELETED(I) && I.loc == vault)
		data = item_ui(I)
	else
		data = list("name" = record_name(record), "quantity" = 1, "children" = 0, "volume" = 0, "liquids" = list())
		var/item_path = record["type"]
		if(ispath(item_path, /obj/item))
			data["icon"] = "[initial(item_path:icon)]"
			data["icon_state"] = initial(item_path:icon_state)
			data["description"] = record["mode"] == "counted" ? initial(item_path:desc) : record["desc"]
		if("item" in record)
			data["error"] = "封存物品已失效，记录保留供检查。"
		else if(record["mode"] != "counted")
			data["legacy"] = TRUE
			data["quantity"] = record["amount"] ? record["amount"] : 1
			data["integrity"] = record["integrity"]
			var/list/liquids = list()
			for(var/list/R in record["reagents"])
				var/datum/reagent/reagent = GLOB.chemical_reagents_list[R["type"]]
				liquids += list(list("name" = reagent ? reagent.name : "未知试剂", "volume" = R["volume"]))
				data["volume"] += R["volume"]
			data["liquids"] = liquids
	data["id"] = record["id"]
	data["mode"] = record["mode"] == "counted" ? "counted" : "sealed"
	if(record["mode"] == "counted")
		data["quantity"] = record["count"]
	return data

/obj/item/void_cube/proc/contents_ui(obj/item/root, datum/z121_void_cube_session/session, list/budget, depth = 0)
	var/list/nodes = list()
	if(depth >= 20)
		return nodes
	for(var/obj/item/I in root.contents)
		if(budget["remaining"]-- <= 0)
			break
		var/list/node = item_ui(I)
		node["id"] = REF(I)
		node["expanded"] = !!session.expanded[REF(I)]
		node["contents"] = list()
		if(node["expanded"])
			node["contents"] = contents_ui(I, session, budget, depth + 1)
		nodes += list(node)
	return nodes

/obj/item/void_cube/ui_data(mob/user)
	if(!can_operate(user))
		return list()
	prepare_records()
	var/datum/z121_void_cube_session/session = get_session(user)
	var/list/hands = list()
	for(var/obj/item/I in user.held_items)
		if(I == src)
			continue
		var/list/hand = item_ui(I)
		hand["id"] = REF(I)
		hand["mode"] = should_seal(I) ? "sealed" : "counted"
		hand["error"] = storage_reason(I, user)
		hands += list(hand)
	var/list/matches = list()
	var/kinds = 0
	var/units = 0
	var/sealed = 0
	for(var/list/record in stored_data)
		var/mode = record["mode"] == "counted" ? "counted" : "sealed"
		if(mode == "counted")
			kinds++
			units += record["count"]
		else
			sealed++
		if(session.filter != "all" && session.filter != mode)
			continue
		if(length(session.query) && !findtext(record_name(record), session.query))
			continue
		matches += list(record)
	var/pages = max(1, CEILING(length(matches) / Z121_CUBE_PAGE_SIZE, 1))
	session.page = clamp(session.page, 1, pages)
	var/list/entries = list()
	var/first = (session.page - 1) * Z121_CUBE_PAGE_SIZE + 1
	for(var/i = first, i <= min(length(matches), first + Z121_CUBE_PAGE_SIZE - 1), i++)
		entries += list(record_ui(matches[i]))
	var/list/selected = find_record(session.selected_id)
	var/list/detail
	if(selected)
		detail = record_ui(selected)
		detail["contents"] = list()
		var/obj/item/root = selected["item"]
		if(!QDELETED(root) && root.loc == vault)
			var/list/budget = list("remaining" = 200)
			detail["contents"] = contents_ui(root, session, budget)
			detail["tree_limited"] = budget["remaining"] <= 0
	return list(
		"hands" = hands,
		"entries" = entries,
		"detail" = detail,
		"kinds" = kinds,
		"units" = units,
		"sealed" = sealed,
		"query" = session.query,
		"filter" = session.filter,
		"page" = session.page,
		"pages" = pages,
		"matches" = length(matches),
		"message" = session.message,
		"busy" = busy,
		"extract_limit" = Z121_CUBE_EXTRACT_LIMIT,
	)

#undef Z121_CUBE_PAGE_SIZE
#undef Z121_CUBE_EXTRACT_LIMIT
#undef Z121_CUBE_COIN_STACK
