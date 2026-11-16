#define POTIONSELLER_TANKS 3
#define POTIONSELLER_TANK_VOLUME 500

/// A shelf of one kind of empty container, sold for a flat price
/datum/potion_shelf
	/// Singular name, shown in the UI and the machine's speech
	var/name
	/// Type of container this shelf takes, subtypes included
	var/accepts
	var/price = 0
	var/capacity = 0
	var/list/stock = list()

/datum/potion_shelf/New(name, accepts, price, capacity)
	src.name = name
	src.accepts = accepts
	src.price = price
	src.capacity = capacity

/datum/potion_shelf/Destroy()
	stock.Cut()
	return ..()

/datum/potion_shelf/proc/is_full()
	return length(stock) >= capacity

/obj/structure/roguemachine/potionseller
	parent_type = /obj/structure/roguemachine/shop
	name = "药剂商"
	desc = "这东西的肚子里可以装满液体供你购买。"
	debris = list(/obj/item/grown/log/tree/small, /obj/item/roguegear, /obj/item/natural/glass)
	tgui_id = "PotionSeller"
	key_name = "药剂商钥匙"
	key_icon_state = "greenkey"
	/// The container in the slot, bought into or poured from
	var/obj/item/reagent_containers/inserted
	/// How many of each empty container the shelves hold
	var/max_bottles = 20
	var/max_vials = 20
	/// Empty containers for sale: bottles, then vials
	var/list/shelves = list()
	/// One reagent holder per tank, each holding any mixture
	var/list/tanks = list()
	var/list/tank_labels = list()
	/// Price per dram, in 0.1 steps
	var/list/tank_prices = list()
	/// Which tank right-click bag loading pours into
	var/loading_tank = 1
	var/tank_volume = POTIONSELLER_TANK_VOLUME

/obj/structure/roguemachine/potionseller/crafted
	is_crafted = TRUE
	max_integrity = 100

/obj/structure/roguemachine/potionseller/Initialize(mapload)
	. = ..()
	shelves += new /datum/potion_shelf("药瓶", /obj/item/reagent_containers/glass/bottle/rogue, 10, max_bottles)
	shelves += new /datum/potion_shelf("小药瓶", /obj/item/reagent_containers/glass/bottle/alchemical, 5, max_vials)
	for(var/i in 1 to POTIONSELLER_TANKS)
		var/datum/reagents/tank = new(tank_volume, NO_REACT)
		tank.my_atom = src
		tanks += tank
		tank_labels += null
		tank_prices += 0
	if(!is_crafted)
		for(var/datum/potion_shelf/shelf as anything in shelves)
			for(var/i in 1 to min(10, shelf.capacity))
				shelf.stock += new shelf.accepts(src)

/obj/structure/roguemachine/potionseller/Destroy()
	drop_bottles()
	QDEL_LIST(tanks)
	QDEL_LIST(shelves)
	return ..()

/obj/structure/roguemachine/potionseller/obj_break(damage_flag)
	..()
	for(var/datum/reagents/tank as anything in tanks)
		splash_tank(tank)
	drop_bottles()

/// Drops the container in the slot and everything on the shelves
/obj/structure/roguemachine/potionseller/proc/drop_bottles()
	if(inserted)
		inserted.forceMove(drop_location())
		inserted = null
	for(var/datum/potion_shelf/shelf as anything in shelves)
		for(var/obj/item/B in shelf.stock.Copy())
			B.forceMove(drop_location())
		shelf.stock.Cut()

/obj/structure/roguemachine/potionseller/Exited(atom/movable/gone, atom/newLoc)
	. = ..()
	if(gone == inserted)
		inserted = null
	for(var/datum/potion_shelf/shelf as anything in shelves)
		shelf.stock -= gone

/obj/structure/roguemachine/potionseller/proc/default_tank_label(index)
	return "储液罐 [index]"

/obj/structure/roguemachine/potionseller/proc/tank_label(index)
	return tank_labels[index] || default_tank_label(index)

/// Parses a tank number from ui params, or null if it isn't a valid tank
/obj/structure/roguemachine/potionseller/proc/tank_index(param)
	var/index = text2num("[param]")
	if(!isnum(index) || index != round(index) || index < 1 || index > length(tanks))
		return null
	return index

/// Parses a shelf number from ui params, returning that shelf, or null if it isn't a valid one
/obj/structure/roguemachine/potionseller/proc/shelf_from_param(param)
	var/index = text2num("[param]")
	if(!isnum(index) || index != round(index) || index < 1 || index > length(shelves))
		return null
	return shelves[index]

/obj/structure/roguemachine/potionseller/proc/is_liquid_container(obj/item/I)
	if(!istype(I, /obj/item/reagent_containers/glass) || !I.reagents)
		return FALSE
	if(istype(I, /obj/item/reagent_containers/glass/mortar) || istype(I, /obj/item/reagent_containers/glass/crucible) || istype(I, /obj/item/reagent_containers/glass/rag))
		return FALSE
	return TRUE

/// The shelf an empty container would be stocked on, or null if none takes it
/obj/structure/roguemachine/potionseller/proc/shelf_for(obj/item/I)
	for(var/datum/potion_shelf/shelf as anything in shelves)
		if(istype(I, shelf.accepts))
			return shelf
	return null

/// Pours from a container into a tank, returning drams moved
/obj/structure/roguemachine/potionseller/proc/pour_into_tank(obj/item/reagent_containers/C, index, amount, mob/user)
	var/datum/reagents/tank = tanks[index]
	if(!C.reagents.total_volume || tank.total_volume >= tank.maximum_volume)
		return 0
	return C.reagents.trans_to(tank, amount, no_react = TRUE, transfered_by = user) || 0

/obj/structure/roguemachine/potionseller/proc/stock_bottle(obj/item/I, datum/potion_shelf/shelf, mob/user)
	if(shelf.is_full())
		to_chat(user, span_warning("[shelf.name]货架已满。"))
		return FALSE
	if(!user.transferItemToLoc(I, src))
		to_chat(user, span_warning("[I]黏在你的手上了！"))
		return FALSE
	shelf.stock += I
	playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
	SStgui.update_uis(src)
	return TRUE

/// Empties the filled liquid containers in a bag into the loading tank, as far as it has room,
/// and moves empty bottles and vials from the bag onto their shelves
/obj/structure/roguemachine/potionseller/load_from_storage(datum/component/storage/STR, mob/living/user)
	var/poured = 0
	var/shelved = 0
	var/tank_full = FALSE
	/// Shelves that couldn't take everything offered
	var/list/full_shelves = list()
	for(var/obj/item/reagent_containers/C in STR.contents())
		if(!is_liquid_container(C))
			continue
		if(C.reagents.total_volume)
			poured += pour_into_tank(C, loading_tank, C.reagents.total_volume, user)
			// anything left over didn't fit
			if(C.reagents.total_volume)
				tank_full = TRUE
			// a bottle emptied here isn't shelved until the next right-click
			continue
		var/datum/potion_shelf/shelf = shelf_for(C)
		if(shelf)
			if(shelf.is_full())
				full_shelves |= shelf
				continue
			STR.remove_from_storage(C, src)
			shelf.stock += C
			shelved++

	if(poured || shelved)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		var/list/parts = list()
		if(poured)
			parts += "将[round(poured)]打兰液体倒入[tank_label(loading_tank)]"
		if(shelved)
			parts += "将[shelved]个容器放上货架"
		to_chat(user, span_notice("[src][jointext(parts, "，并")]。"))
		update_icon()
		SStgui.update_uis(src)
	if(tank_full)
		to_chat(user, span_warning("[tank_label(loading_tank)]已满。"))
	for(var/datum/potion_shelf/shelf as anything in full_shelves)
		to_chat(user, span_warning("[shelf.name]货架已满。"))
	if(!poured && !shelved && !tank_full && !length(full_shelves))
		to_chat(user, span_warning("没有[src]能收下的物品。"))

/obj/structure/roguemachine/potionseller/refuses_unowned(obj/item/I)
	return ..() || is_liquid_container(I)

/obj/structure/roguemachine/potionseller/handle_item(obj/item/I, mob/user)
	if(is_liquid_container(I))
		var/datum/potion_shelf/shelf = shelf_for(I)
		if(!locked && shelf && !I.reagents.total_volume)
			stock_bottle(I, shelf, user)
			return TRUE
		if(inserted)
			to_chat(user, span_warning("里面已经有东西了！"))
			return TRUE
		if(!user.transferItemToLoc(I, src))
			to_chat(user, span_warning("[I]黏在你的手上了！"))
			return TRUE
		inserted = I
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
		SStgui.update_uis(src)
		return TRUE
	if(!locked)
		to_chat(user, span_warning("这不是容器。"))
		return TRUE
	return FALSE

/obj/structure/roguemachine/potionseller/has_stock()
	for(var/datum/reagents/tank as anything in tanks)
		if(tank.total_volume >= 1)
			return TRUE
	return FALSE

/obj/structure/roguemachine/potionseller/ui_data(mob/user)
	var/list/data = ..()
	data["loading_tank"] = loading_tank

	var/list/shelf_data = list()
	for(var/datum/potion_shelf/shelf as anything in shelves)
		shelf_data += list(list(
			"name" = shelf.name,
			"price" = shelf.price,
			"stock" = length(shelf.stock),
			"capacity" = shelf.capacity,
		))
	data["shelves"] = shelf_data

	var/list/tank_data = list()
	for(var/i in 1 to length(tanks))
		var/datum/reagents/tank = tanks[i]
		tank_data += list(list(
			// labels are stored html-encoded for hawking; tgui escapes text itself
			"label" = html_decode(tank_label(i)),
			"default_label" = default_tank_label(i),
			"price" = tank_prices[i],
			"volume" = round(tank.total_volume, 0.1),
			"drawable" = floor(tank.total_volume),
			"max" = tank.maximum_volume,
			"color" = tank.total_volume ? mix_color_from_reagents(tank.reagent_list) : null,
		))
	data["tanks"] = tank_data

	// always sent: tgui merges updates, so an omitted key would keep showing the old container
	data["container"] = null
	if(inserted)
		data["container"] = list(
			"name" = html_decode(inserted.name),
			"volume" = round(inserted.reagents.total_volume, 0.1),
			"max" = inserted.reagents.maximum_volume,
			"color" = inserted.reagents.total_volume ? mix_color_from_reagents(inserted.reagents.reagent_list) : null,
		)
	return data

/// Hands an item to the user, or drops it at their feet
/obj/structure/roguemachine/potionseller/proc/give_to(obj/item/I, mob/living/user)
	if(!user.put_in_hands(I))
		I.forceMove(get_turf(user))

/obj/structure/roguemachine/potionseller/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = usr
	if(!istype(H))
		return

	switch(action)
		if("eject")
			if(!inserted)
				return
			var/obj/item/I = inserted
			inserted = null
			give_to(I, H)
			return TRUE

		if("pour")
			if(!inserted)
				return
			var/list/draws = params["draws"]
			if(!islist(draws) || length(draws) != length(tanks))
				return
			var/space = inserted.reagents.maximum_volume - inserted.reagents.total_volume
			var/total_drams = 0
			var/cost = 0
			for(var/i in 1 to length(tanks))
				var/datum/reagents/tank = tanks[i]
				var/amount = round(text2num("[draws[i]]"))
				if(!amount)
					draws[i] = 0
					continue
				// !(x >= 0) rather than x < 0 so NaN is rejected too
				if(!(amount >= 0) || amount > tank.total_volume)
					return
				draws[i] = amount
				total_drams += amount
				cost += tank_prices[i] * amount
			if(!total_drams || total_drams > space)
				return
			if(locked)
				cost = CEILING(round(cost, 0.1), 1)
				if(!charge(cost, "旅人，你买不起我的药剂！"))
					return TRUE
			for(var/i in 1 to length(tanks))
				if(draws[i])
					var/datum/reagents/tank = tanks[i]
					tank.trans_to(inserted, draws[i], no_react = TRUE, transfered_by = H)
			inserted.reagents.handle_reactions()
			playsound(loc, 'sound/misc/potionseller.ogg', 100, TRUE, -1)
			update_icon()
			return TRUE

		if("buy_bottle")
			var/datum/potion_shelf/shelf = shelf_from_param(params["shelf"])
			if(!shelf)
				return
			var/shouted = shelf.name
			if(!length(shelf.stock))
				say("旅人，我的[shouted]已经卖光了！")
				return TRUE
			// a bought container goes into the slot, so it has to be free
			if(locked && inserted)
				say("旅人，先取走你的容器！")
				return TRUE
			if(locked && !charge(shelf.price, "旅人，你买不起我的[shouted]！"))
				return TRUE
			var/obj/item/B = shelf.stock[length(shelf.stock)]
			shelf.stock -= B
			if(inserted)
				give_to(B, H)
			else
				inserted = B
			return TRUE

		if("pour_in")
			if(locked || !inserted)
				return
			var/index = tank_index(params["tank"])
			if(!index)
				return
			var/amount = isnull(params["amount"]) ? inserted.reagents.total_volume : round(text2num("[params["amount"]]"))
			if(!(amount > 0))
				return
			var/datum/reagents/tank = tanks[index]
			if(tank.total_volume >= tank.maximum_volume)
				to_chat(H, span_warning("[tank_label(index)]已满。"))
				return TRUE
			if(!pour_into_tank(inserted, index, amount, H))
				return TRUE
			playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
			update_icon()
			return TRUE

		if("flush")
			if(locked)
				return
			var/index = tank_index(params["tank"])
			if(!index)
				return
			splash_tank(tanks[index])
			update_icon()
			return TRUE

		if("set_loading_tank")
			if(locked)
				return
			var/index = tank_index(params["tank"])
			if(index)
				loading_tank = index
			return TRUE

		if("set_label")
			if(locked || !H.can_read(src, TRUE))
				return
			var/index = tank_index(params["tank"])
			if(!index)
				return
			var/newlabel = sanitize(copytext(trim("[params["label"]]"), 1, MAX_NAME_LEN + 1))
			// blank or the default name means no label, so the tank keeps the default
			tank_labels[index] = (length(newlabel) && newlabel != default_tank_label(index)) ? newlabel : null
			return TRUE

		if("set_price")
			if(locked)
				return
			var/index = tank_index(params["tank"])
			var/newprice = text2num("[params["price"]]")
			if(!index || isnull(newprice) || !(newprice >= 0))
				return
			tank_prices[index] = round(min(newprice, SHOP_MAX_PRICE), 0.1)
			return TRUE

		if("set_bottle_price")
			if(locked)
				return
			var/datum/potion_shelf/shelf = shelf_from_param(params["shelf"])
			var/newprice = text2num("[params["price"]]")
			if(!shelf || isnull(newprice) || !(newprice >= 0))
				return
			shelf.price = round(min(newprice, SHOP_MAX_PRICE))
			return TRUE

/obj/structure/roguemachine/potionseller/proc/splash_tank(datum/reagents/tank)
	if(!tank.total_volume)
		return
	var/turf/T = get_turf(src)
	visible_message(span_warning("[src]喷出的液体洒满了地板！"))
	playsound(T, 'sound/foley/water_land1.ogg', 100, TRUE)
	tank.reaction(T, TOUCH)
	tank.clear_reagents()

/obj/structure/roguemachine/potionseller/hawk()
	var/list/stocked = list()
	for(var/i in 1 to length(tanks))
		var/datum/reagents/tank = tanks[i]
		if(tank.total_volume >= 1)
			stocked += i
	if(!length(stocked))
		return
	var/index = pick(stocked)
	var/label = capitalize(tank_label(index))
	if(tank_prices[index])
		say("出售[label]！每打兰[tank_prices[index]]玛蒙！")
	else
		say("免费供应[label]！带上瓶子来吧！")

/obj/structure/roguemachine/potionseller/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("用容器点击可将其放入槽位。拖动储液罐液位或使用加减按钮，选择从各罐取出的量，再点击倒出。价格按每打兰计算。")
	. += span_info("空药瓶和小药瓶分架出售。买下的瓶子会直接进入槽位，请先取走原有容器。")
	. += span_info("解锁后，可将槽中容器的液体倒入储液罐、将储液罐排空到地上，或设置罐名和价格。用空药瓶或小药瓶点击可将其放上货架。")
	. += span_info("解锁后，用袋子右键点击，可将袋中容器的液体倒入指定装填罐，并将空药瓶和小药瓶上架。")
	. += span_info("损坏后，储液罐中的液体会洒满地面。")

// POTION CARTS

/obj/structure/roguemachine/potionseller/mobile
	name = "药剂推车"
	desc = "带有车轮、可以移动的小型药剂售货机。"
	icon_state = "svendorcart1"
	icon_prefix = "svendorcart"
	anchored = FALSE
	is_cart = TRUE
	max_integrity = 400
	climbable = TRUE
	tank_volume = 250
	max_bottles = 10
	max_vials = 10
	// no owner until it's claimed, or crafted with its key
	keycontrol = null
	key_name = "药剂推车钥匙"

/obj/structure/roguemachine/potionseller/mobile/crafted
	is_crafted = TRUE

#undef POTIONSELLER_TANKS
#undef POTIONSELLER_TANK_VOLUME
