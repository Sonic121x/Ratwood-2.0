/obj/structure/roguemachine/scrapper
	name = "废料回收机"
	desc = "一台镶着黄铜边的装置，上方是料斗，下方是铁制钱箱。带来破布、骨头和损坏的物品，回收机会称量并支付钱币。收购价格由业主设定。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	integrity_failure = 0.1
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/list/keycontrol = list("crafterguild", "craftermaster")
	var/budget = 0
	var/seed_budget = 0
	var/list/material_prices = list()
	var/list/material_caps = list()
	var/list/material_held = list()
	var/list/material_advertise = list()
	var/list/material_enabled = list()
	var/list/bark_candidates = list()
	var/bark_dirty = TRUE
	var/next_bark = 0

/obj/structure/roguemachine/scrapper/Initialize(mapload)
	. = ..()
	populate_defaults()
	if(seed_budget > 0)
		budget = seed_budget
	next_bark = world.time + SCRAPPER_BARK_INTERVAL
	START_PROCESSING(SSobj, src)

/obj/structure/roguemachine/scrapper/Destroy()
	STOP_PROCESSING(SSobj, src)
	material_prices?.Cut()
	material_caps?.Cut()
	material_held?.Cut()
	material_advertise?.Cut()
	return ..()

/obj/structure/roguemachine/scrapper/proc/populate_defaults()
	return

/obj/structure/roguemachine/scrapper/proc/material_name(path)
	if(!path)
		return ""
	var/atom/A = path
	return capitalize(initial(A.name))

/obj/structure/roguemachine/scrapper/proc/identify_material(obj/item/I)
	if(!I)
		return null
	if((I.type in material_prices) && material_enabled[I.type])
		return I.type
	if(I.smeltresult && (I.smeltresult in material_prices) && material_enabled[I.smeltresult])
		return I.smeltresult
	if(I.sewrepair && I.salvage_result && (I.salvage_result in material_prices) && material_enabled[I.salvage_result])
		return I.salvage_result
	return null

/obj/structure/roguemachine/scrapper/proc/is_keyholder(mob/user)
	if(!ishuman(user))
		return FALSE
	for(var/obj/item/roguekey/K in user.GetAllContents())
		if(K.lockid in keycontrol)
			return TRUE
	return FALSE

/obj/structure/roguemachine/scrapper/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("业主可设定各种材料的价格、收购容量和吆喝项目。投入的钱币会存入钱箱；钱箱空了，回收机就会拒绝收购。")
	. += span_info("用物品点击它即可出售。回收机会按照物品熔炼后所得的材料估价。")

/obj/structure/roguemachine/scrapper/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid in keycontrol)
			to_chat(user, span_notice("我拨动锁具，确认自己对这台机器的使用权限。"))
			SStgui.update_uis(src)
			return
		to_chat(user, span_warning("钥匙不对。"))
		return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/KR = P
		for(var/obj/item/roguekey/KE in KR)
			if(KE.lockid in keycontrol)
				to_chat(user, span_notice("我拨动锁具，确认自己对这台机器的使用权限。"))
				SStgui.update_uis(src)
				return

	if(istype(P, /obj/item/roguecoin/gilbranze) || istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		if(!is_keyholder(user))
			to_chat(user, span_warning("只有业主才能为机器补充资金。"))
			return
		budget += P.get_real_price()
		bark_dirty = TRUE
		qdel(P)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		SStgui.update_uis(src)
		return

	if(!ishuman(user))
		return
	try_recycle(P, user)

/obj/structure/roguemachine/scrapper/proc/try_recycle(obj/item/I, mob/user)
	var/path = identify_material(I)
	if(!path)
		to_chat(user, span_warning("[src]认为[I]没有回收价值。"))
		return
	var/units = 1
	if(I.salvage_result == path)
		units = I.salvage_amount
		if(units <= 0)
			to_chat(user, span_warning("[src]认为[I]没有回收价值。"))
			return
	var/unit_price = material_prices[path] || 0
	if(unit_price <= 0)
		to_chat(user, span_warning("[src]今天不收购[material_name(path)]。"))
		return
	var/total_price = unit_price * units
	var/cap = material_caps[path] || 0
	var/held = material_held[path] || 0
	if(cap > 0 && held + units > cap)
		to_chat(user, span_warning("[src]的[material_name(path)]料斗装不下这些了。"))
		playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(budget < total_price)
		to_chat(user, span_warning("[src]的钱箱里没有足够的钱币。"))
		playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	material_held[path] = held + units
	budget -= total_price
	bark_dirty = TRUE
	I.forceMove(src)
	budget2change(total_price, user)
	playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
	var/cap_text = cap > 0 ? "剩余容量：[max(0, cap - material_held[path])] / [cap]" : "不限容量"
	var/units_text = units > 1 ? "（[units]份）" : ""
	to_chat(user, span_notice("[material_name(path)]已称量，支付[total_price]玛门[units_text]。[cap_text]。"))
	SStgui.update_uis(src)

/obj/structure/roguemachine/scrapper/proc/rebuild_bark_candidates()
	bark_candidates = list()
	for(var/path in material_prices)
		if(!material_enabled[path])
			continue
		if(!material_advertise[path])
			continue
		var/price = material_prices[path] || 0
		if(price <= 0)
			continue
		if(budget < price)
			continue
		var/cap = material_caps[path] || 0
		var/held = material_held[path] || 0
		if(cap > 0 && held >= cap)
			continue
		bark_candidates += path
	bark_dirty = FALSE

/obj/structure/roguemachine/scrapper/process()
	if(world.time < next_bark)
		return
	next_bark = world.time + SCRAPPER_BARK_INTERVAL
	if(obj_broken)
		return
	if(bark_dirty)
		rebuild_bark_candidates()
	if(!length(bark_candidates))
		return
	var/pick = pick(bark_candidates)
	var/price = material_prices[pick]
	var/cap = material_caps[pick] || 0
	var/held = material_held[pick] || 0
	var/left_text = cap > 0 ? "还能收购[cap - held]份" : "不限收购数量"
	say("收破布，收废料！[material_name(pick)]每份[price]玛门！[left_text]！")

/obj/structure/roguemachine/scrapper/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/scrapper/ui_status(mob/user, datum/ui_state/state)
	if(!isliving(user) || user.stat == DEAD)
		return UI_CLOSE
	return ..()

/obj/structure/roguemachine/scrapper/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	ui_interact(user)

/obj/structure/roguemachine/scrapper/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
		ui = new(user, src, "Scrapper", name)
		ui.open()

/obj/structure/roguemachine/scrapper/proc/items_count_for(path)
	var/n = 0
	for(var/obj/item/I in contents)
		if(I.type == path || I.smeltresult == path || I.salvage_result == path)
			n++
	return n

/obj/structure/roguemachine/scrapper/ui_data(mob/user)
	var/list/data = list()
	data["budget"] = budget
	data["is_keyholder"] = is_keyholder(user) ? TRUE : FALSE
	var/total_items = 0
	var/list/rows = list()
	for(var/path in material_prices)
		var/cap = material_caps[path] || 0
		var/held = material_held[path] || 0
		var/items = items_count_for(path)
		total_items += items
		rows += list(list(
			"path" = "[path]",
			"name" = material_name(path),
			"price" = material_prices[path] || 0,
			"cap" = cap,
			"held" = held,
			"items" = items,
			"left" = cap > 0 ? max(0, cap - held) : -1,
			"advertise" = material_advertise[path] ? TRUE : FALSE,
			"enabled" = material_enabled[path] ? TRUE : FALSE,
		))
	data["materials"] = rows
	data["total_items"] = total_items
	return data

/obj/structure/roguemachine/scrapper/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!is_keyholder(usr))
		return
	switch(action)
		if("set_price")
			var/path = text2path(params["path"])
			var/n = text2num(params["value"])
			if(path && (path in material_prices) && isnum(n))
				material_prices[path] = max(0, round(n))
				bark_dirty = TRUE
			return TRUE
		if("set_cap")
			var/path = text2path(params["path"])
			var/n = text2num(params["value"])
			if(path && (path in material_prices) && isnum(n))
				material_caps[path] = max(0, round(n))
				bark_dirty = TRUE
			return TRUE
		if("toggle_advertise")
			var/path = text2path(params["path"])
			if(path && (path in material_prices))
				material_advertise[path] = !material_advertise[path]
				bark_dirty = TRUE
			return TRUE
		if("toggle_enable")
			var/path = text2path(params["path"])
			if(path && (path in material_prices))
				material_enabled[path] = !material_enabled[path]
				bark_dirty = TRUE
			return TRUE
		if("dump_held")
			var/path = text2path(params["path"])
			if(path && (path in material_held))
				var/turf/T = get_turf(src)
				for(var/obj/item/I in contents)
					if(I.type == path || I.smeltresult == path || I.salvage_result == path)
						I.forceMove(T)
				material_held[path] = 0
				bark_dirty = TRUE
			return TRUE
		if("dump_all")
			var/turf/T = get_turf(src)
			for(var/obj/item/I in contents)
				I.forceMove(T)
			for(var/path in material_held)
				material_held[path] = 0
			bark_dirty = TRUE
			return TRUE
		if("withdraw")
			if(budget <= 0)
				return TRUE
			var/amount = budget
			budget = 0
			bark_dirty = TRUE
			budget2change(amount, usr)
			playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
			to_chat(usr, span_notice("我从钱箱中取出[amount]玛门。"))
			return TRUE

/obj/structure/roguemachine/scrapper/obj_break(damage_flag)
	..()
	var/turf/T = get_turf(src)
	if(budget > 0)
		budget2change(budget, usr)
		budget = 0
		bark_dirty = TRUE
	for(var/obj/item/I in contents)
		I.forceMove(T)
	for(var/path in material_held)
		material_held[path] = 0
	update_icon()

/obj/structure/roguemachine/scrapper/smith
	name = "铁匠废料回收机"
	desc = "一台镶着黄铜边的装置，上方是料斗，下方是铁制钱箱。收购铁匠可以重新熔炼成金属锭的物品。"
	seed_budget = 50

/obj/structure/roguemachine/scrapper/smith/populate_defaults()
	material_prices = list(
		/obj/item/ingot/iron = 8,
		/obj/item/ingot/copper = 4,
		/obj/item/ingot/bronze = 10,
		/obj/item/ingot/steel = 14,
		/obj/item/ingot/silver = 60,
		/obj/item/ingot/gold = 50,
		/obj/item/ingot/blacksteel = 80,
	)
	var/list/defaults_on = list(/obj/item/ingot/iron, /obj/item/ingot/steel)
	material_caps[/obj/item/ingot/iron] = 10
	material_caps[/obj/item/ingot/copper] = 5
	material_caps[/obj/item/ingot/bronze] = 5
	material_caps[/obj/item/ingot/steel] = 10
	material_caps[/obj/item/ingot/silver] = 4
	material_caps[/obj/item/ingot/gold] = 4
	material_caps[/obj/item/ingot/blacksteel] = 3
	for(var/path in material_prices)
		material_held[path] = 0
		material_enabled[path] = (path in defaults_on)
		material_advertise[path] = (path in defaults_on)

/obj/structure/roguemachine/scrapper/tailor
	name = "旧衣回收机"
	desc = "一台镶着黄铜边的装置，上方是料斗，下方是铁制钱箱。收购裁缝可以重新加工成织物的物品。"
	seed_budget = 50

/obj/structure/roguemachine/scrapper/tailor/populate_defaults()
	material_prices = list(
		/obj/item/natural/fibers = 2,
		/obj/item/natural/cloth = 3,
		/obj/item/natural/silk = 4,
		/obj/item/natural/hide = 8,
		/obj/item/natural/hide/cured = 3,
		/obj/item/natural/fur = 10,
	)
	var/list/defaults_on = list(/obj/item/natural/hide, /obj/item/natural/fur)
	material_caps[/obj/item/natural/fibers] = 10
	material_caps[/obj/item/natural/cloth] = 10
	material_caps[/obj/item/natural/silk] = 10
	material_caps[/obj/item/natural/hide] = 8
	material_caps[/obj/item/natural/hide/cured] = 12
	material_caps[/obj/item/natural/fur] = 3
	for(var/path in material_prices)
		material_held[path] = 0
		material_enabled[path] = (path in defaults_on)
		material_advertise[path] = (path in defaults_on)
