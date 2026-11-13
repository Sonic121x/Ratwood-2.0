/obj/item/ccg_deck
	name = "阿莱特牌组"
	desc = "用于回合制阿莱特卡牌游戏的牌盒。将卡牌放入其中即可组建牌组。"
	icon = 'modular_twilight_axis/icons/obj/gwynt_objs.dmi'
	icon_state = "gwint_deck"
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32
	var/list/card_ids = list()
	var/faction_id = CCG_FACTION_AZURIA
	var/leader_id = "azuria_ducal_marshal"
	var/datum/ccg_match/match
	var/obj/item/ccg_deck/match_host
	var/inviter_ckey
	var/inviter_name
	/// Starter decks fill themselves with this faction's starter cards when created.
	var/starter_faction

/obj/item/ccg_deck/Initialize(mapload)
	. = ..()
	if(!length(GLOB.ccg_base_card_ids))
		ccg_build_card_registry()
	if(starter_faction)
		set_faction(starter_faction)
		set_cards(ccg_starter_deck_cards(starter_faction))

/obj/item/ccg_deck/Destroy()
	var/datum/ccg_match/active_match = get_active_match()
	if(active_match?.owner == src)
		qdel(active_match)
	else if(active_match?.challenger == src)
		active_match.challenger = null
	match = null
	match_host = null
	return ..()

/obj/item/ccg_deck/examine(mob/user)
	. = ..()
	var/datum/ccg_faction/faction = ccg_faction(faction_id)
	var/datum/ccg_leader/leader = ccg_leader(leader_id)
	. += span_info("阵营：[faction ? faction.name : "无"]。领袖：[leader ? leader.name : "无"]。")
	. += span_info("内含[card_ids.len]/[CCG_DECK_SIZE]张牌。至少需要[CCG_MIN_DECK_SIZE]张牌才能对战。")

/obj/item/ccg_deck/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("在手中使用牌组，可浏览卡牌、取出卡牌，或更改阵营与领袖。")
	. += span_info("用散卡点击牌组即可加入卡牌。右键点击手中的牌组可取出卡牌。")
	. += span_info("将牌组放在桌上，再让另一位玩家用自己的牌组点击它，即可对战。")

/obj/item/ccg_deck/proc/set_cards(list/new_cards)
	card_ids = list()
	var/list/card_counts = list()
	for(var/card_id in new_cards)
		var/datum/ccg_card/card = ccg_card(card_id)
		if(!card || !ccg_card_allowed_for_faction(card_id, faction_id) || card_ids.len >= CCG_DECK_SIZE)
			continue
		var/card_count = card_counts[card_id]
		if(!card_count)
			card_count = 0
		if(card_count >= ccg_card_deck_limit(card))
			continue
		card_counts[card_id] = card_count + 1
		card_ids += card_id

/obj/item/ccg_deck/proc/set_faction(new_faction_id, new_leader_id)
	var/datum/ccg_faction/faction = ccg_faction(new_faction_id)
	if(!faction)
		return FALSE
	faction_id = faction.id
	var/datum/ccg_leader/leader = ccg_leader(new_leader_id)
	if(!leader || leader.faction != faction_id)
		leader_id = faction.default_leader
	else
		leader_id = leader.id
	return TRUE

/obj/item/ccg_deck/proc/is_on_table()
	var/turf/T = get_turf(src)
	return T && locate(/obj/structure/table) in T

/obj/item/ccg_deck/proc/in_active_match()
	var/datum/ccg_match/active_match = get_active_match()
	if(active_match && !active_match.result_text)
		return TRUE
	if(active_match)
		release_finished_match()
	return FALSE

/obj/item/ccg_deck/proc/show_card_list(mob/user)
	var/datum/ccg_faction/faction = ccg_faction(faction_id)
	var/datum/ccg_leader/leader = ccg_leader(leader_id)
	var/list/lines = list("<b>[name]</b>：[card_ids.len]/[CCG_DECK_SIZE]张牌。阵营：[faction ? faction.name : "无"]。领袖：[leader ? leader.name : "无"]。")
	if(leader?.desc)
		lines += "<i>[leader.desc]</i>"
	var/list/card_lines = ccg_describe_card_list(card_ids)
	if(length(card_lines))
		lines += card_lines
	else
		lines += "牌组为空。"
	to_chat(user, span_info(jointext(lines, "<br>")))

/// Pulls one copy of a chosen card out of the deck and puts it in the user's hands.
/obj/item/ccg_deck/proc/take_card_out(mob/user)
	if(!length(card_ids))
		to_chat(user, span_warning("牌组为空。"))
		return FALSE
	var/list/choices = list()
	for(var/card_id in card_ids)
		var/datum/ccg_card/card = ccg_card(card_id)
		if(!card)
			continue
		var/label = "[card.name] ([ccg_row_label(card.row)], [ccg_rarity_label(card.rarity)]) x[ccg_card_count_in_list(card_ids, card_id)]"
		choices[label] = card_id
	var/choice = tgui_input_list(user, "取出哪张卡牌？", "[name]", sortList(choices))
	if(!choice || QDELETED(src) || !user.is_holding(src) || in_active_match())
		return FALSE
	var/card_id = choices[choice]
	if(!(card_id in card_ids))
		return FALSE
	card_ids -= card_id
	var/obj/item/ccg_card_single/single = new(get_turf(user))
	single.set_card(card_id)
	user.put_in_hands(single)
	to_chat(user, span_notice("我从牌组中取出了[single.name]。"))
	return TRUE

/// Changes the deck's faction. Cards that don't belong to the new faction fall out as loose cards.
/obj/item/ccg_deck/proc/choose_faction(mob/user)
	if(!length(GLOB.ccg_factions_by_id))
		ccg_build_faction_registry()
	var/list/choices = list()
	for(var/id in GLOB.ccg_factions_by_id)
		var/datum/ccg_faction/faction = GLOB.ccg_factions_by_id[id]
		choices[faction.name] = faction.id
	var/choice = tgui_input_list(user, "选择牌组阵营。其他阵营的卡牌将被移出。", "[name]", sortList(choices))
	if(!choice || QDELETED(src) || !user.is_holding(src) || in_active_match())
		return FALSE
	if(!set_faction(choices[choice]))
		return FALSE
	var/list/kept = list()
	var/dropped = 0
	for(var/card_id in card_ids)
		if(ccg_card_allowed_for_faction(card_id, faction_id))
			kept += card_id
			continue
		var/obj/item/ccg_card_single/single = new(get_turf(user))
		single.set_card(card_id)
		dropped++
	card_ids = kept
	to_chat(user, span_notice("牌组阵营现为[choice][dropped ? "，已移出[dropped]张其他阵营的卡牌" : ""]。"))
	return TRUE

/obj/item/ccg_deck/proc/choose_leader(mob/user)
	if(!length(GLOB.ccg_leaders_by_id))
		ccg_build_leader_registry()
	var/list/choices = list()
	var/list/descriptions = list()
	for(var/id in GLOB.ccg_leaders_by_id)
		var/datum/ccg_leader/leader = GLOB.ccg_leaders_by_id[id]
		if(leader.faction != faction_id)
			continue
		choices[leader.name] = leader.id
		descriptions[leader.name] = leader.desc
	if(!length(choices))
		to_chat(user, span_warning("该阵营没有可选领袖。"))
		return FALSE
	var/choice = tgui_input_list(user, "选择牌组领袖。", "[name]", sortList(choices), descriptions = descriptions)
	if(!choice || QDELETED(src) || !user.is_holding(src) || in_active_match())
		return FALSE
	set_faction(faction_id, choices[choice])
	to_chat(user, span_notice("[choice]现已成为牌组领袖。"))
	return TRUE

/obj/item/ccg_deck/attack_self(mob/user)
	if(!user)
		return
	var/datum/ccg_match/active_match = get_active_match()
	if(active_match && !active_match.result_text)
		ui_interact(user)
		return TRUE
	if(active_match)
		release_finished_match()
	var/list/options = list("浏览牌组", "取出卡牌", "更改阵营", "更改领袖")
	var/choice = tgui_input_list(user, "你想对牌组做什么？", "[name]", options)
	if(!choice || QDELETED(src) || !user.is_holding(src))
		return TRUE
	switch(choice)
		if("浏览牌组")
			show_card_list(user)
		if("取出卡牌")
			take_card_out(user)
		if("更改阵营")
			choose_faction(user)
		if("更改领袖")
			choose_leader(user)
	return TRUE

/obj/item/ccg_deck/attack_hand(mob/user, params)
	var/datum/ccg_match/active_match = get_active_match()
	if(active_match && !active_match.result_text)
		ui_interact(user)
		return TRUE
	if(active_match)
		release_finished_match()
	return ..()

/obj/item/ccg_deck/attack_right(mob/user)
	if(!user)
		return
	var/datum/ccg_match/active_match = get_active_match()
	if(active_match && !active_match.result_text)
		ui_interact(user)
		return TRUE
	if(active_match)
		release_finished_match()
	if(!user.is_holding(src))
		show_card_list(user)
		return TRUE
	take_card_out(user)
	return TRUE

/obj/item/ccg_deck/MouseDrop(atom/over_object)
	var/datum/ccg_match/active_match = get_active_match()
	if(active_match && !active_match.result_text)
		return
	if(active_match)
		release_finished_match()
	. = ..()
	var/mob/living/user = usr
	if(!istype(user) || !(user.mobility_flags & MOBILITY_PICKUP) || !Adjacent(user))
		return
	if(over_object == user && loc != user)
		user.put_in_hands(src)
	else if(istype(over_object, /atom/movable/screen/inventory/hand))
		var/atom/movable/screen/inventory/hand/hand = over_object
		user.putItemFromInventoryInHandIfPossible(src, hand.held_index)

/obj/item/ccg_deck/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/ccg_deck))
		var/obj/item/ccg_deck/other = I
		release_finished_match()
		other.release_finished_match()
		if(get_active_match() || other.get_active_match())
			return TRUE
		try_start_match(user, other)
		return TRUE
	if(istype(I, /obj/item/ccg_card_single))
		var/obj/item/ccg_card_single/single = I
		add_single_card(user, single)
		return TRUE
	return ..()

/obj/item/ccg_deck/dropped(mob/user, silent = FALSE)
	. = ..()
	var/datum/ccg_match/active_match = get_active_match()
	if(active_match?.result_text)
		release_finished_match()
	if(get_active_match())
		return
	var/turf/T = get_turf(src)
	if(T && locate(/obj/structure/table) in T)
		inviter_ckey = user?.ckey
		inviter_name = user?.real_name ? user.real_name : user?.name
		if(user)
			to_chat(user, span_notice("你摆出牌组，邀请他人进行阿莱特对战。"))
	else
		clear_invitation()

/obj/item/ccg_deck/proc/clear_invitation()
	inviter_ckey = null
	inviter_name = null

/obj/item/ccg_deck/proc/get_active_match()
	if(match)
		return match
	if(match_host?.match)
		return match_host.match
	return null

/obj/item/ccg_deck/proc/release_finished_match()
	var/datum/ccg_match/active_match = get_active_match()
	if(!active_match?.result_text)
		return FALSE
	return clear_match(active_match)

/obj/item/ccg_deck/proc/collect_finished_match()
	var/datum/ccg_match/active_match = get_active_match()
	if(!active_match?.result_text)
		return FALSE
	return clear_match(active_match)

/obj/item/ccg_deck/proc/clear_match(datum/ccg_match/active_match)
	if(!active_match)
		return FALSE
	active_match.stop_soundtracks()
	var/obj/item/ccg_deck/host = active_match.owner
	var/obj/item/ccg_deck/guest = active_match.challenger
	if(host)
		SStgui.close_uis(host)
	if(guest)
		SStgui.close_uis(guest)
	if(host)
		host.match = null
		host.match_host = null
		host.clear_invitation()
	if(guest)
		guest.match = null
		guest.match_host = null
		guest.clear_invitation()
	var/list/spectator_ckeys = active_match.spectator_ckeys.Copy()
	for(var/spectator_ckey in spectator_ckeys)
		var/mob/spectator = ccg_find_mob_by_ckey(spectator_ckey)
		if(spectator)
			SStgui.close_user_uis(spectator, host)
			SStgui.close_user_uis(spectator, guest)
	qdel(active_match)
	return TRUE

/obj/item/ccg_deck/proc/return_to_match_player(obj/item/ccg_deck/deck, ckey)
	if(!deck || !ckey)
		return FALSE
	var/mob/living/player = ccg_find_mob_by_ckey(ckey)
	if(!player)
		return FALSE
	if(player.put_in_hands(deck))
		return TRUE
	deck.forceMove(get_turf(player))
	return TRUE

/obj/item/ccg_deck/proc/end_match_session(datum/ccg_match/active_match)
	if(!active_match)
		return FALSE
	var/obj/item/ccg_deck/host_deck = active_match.owner
	var/obj/item/ccg_deck/guest_deck = active_match.challenger
	var/host_ckey = active_match.player_ckeys["one"]
	var/guest_ckey = active_match.player_ckeys["two"]
	if(!clear_match(active_match))
		return FALSE
	return_to_match_player(host_deck, host_ckey)
	return_to_match_player(guest_deck, guest_ckey)
	return TRUE

/obj/item/ccg_deck/proc/add_single_card(mob/user, obj/item/ccg_card_single/single)
	if(!user || !single)
		return FALSE
	if(in_active_match())
		to_chat(user, span_warning("请先结束对战，再修改牌组。"))
		return FALSE
	var/datum/ccg_card/card = ccg_card(single.card_id)
	if(!card)
		to_chat(user, span_warning("这张卡牌无法加入牌组。"))
		return FALSE
	if(!ccg_card_allowed_for_faction(single.card_id, faction_id))
		var/datum/ccg_faction/card_faction = ccg_faction(card.faction)
		to_chat(user, span_warning("[card.name]属于[card_faction ? card_faction.name : "其他阵营"]，与此牌组阵营不符。"))
		return FALSE
	if(card_ids.len >= CCG_DECK_SIZE)
		to_chat(user, span_warning("牌组已满（[CCG_DECK_SIZE]张）。"))
		return FALSE
	var/limit = ccg_card_deck_limit(card)
	if(ccg_card_count_in_list(card_ids, single.card_id) >= limit)
		to_chat(user, span_warning("一副牌组最多只能放入[limit]张[card.name]。"))
		return FALSE
	if(user.is_holding(single) && !user.temporarilyRemoveItemFromInventory(single))
		return FALSE
	card_ids += single.card_id
	to_chat(user, span_notice("我将[card.name]加入牌组（[card_ids.len]/[CCG_DECK_SIZE]）。"))
	qdel(single)
	return TRUE

/obj/item/ccg_deck/proc/try_start_match(mob/user, obj/item/ccg_deck/challenger_deck)
	if(!user || !challenger_deck || challenger_deck == src)
		return FALSE
	if(get_active_match() || challenger_deck.get_active_match())
		to_chat(user, span_warning("其中一副牌组已经在对战中。"))
		return FALSE
	if(!inviter_ckey)
		to_chat(user, span_warning("这副牌组尚未发出对战邀请。"))
		return FALSE
	if(inviter_ckey == user.ckey)
		to_chat(user, span_warning("需要另一位玩家才能进行对战。"))
		return FALSE
	if(card_ids.len < CCG_MIN_DECK_SIZE || challenger_deck.card_ids.len < CCG_MIN_DECK_SIZE)
		to_chat(user, span_warning("双方牌组都至少需要[CCG_MIN_DECK_SIZE]张牌才能对战。"))
		return FALSE
	var/mob/player_one = ccg_find_mob_by_ckey(inviter_ckey)
	if(!player_one)
		to_chat(user, span_warning("发出对战邀请的玩家不在这里。"))
		return FALSE
	if(!user.dropItemToGround(challenger_deck))
		return FALSE
	challenger_deck.forceMove(get_turf(src))
	clear_invitation()
	challenger_deck.clear_invitation()
	match = new(src, player_one, src, user, challenger_deck)
	challenger_deck.match_host = src
	challenger_deck.match = match
	ui_interact(player_one)
	challenger_deck.ui_interact(user)
	return TRUE

/obj/item/ccg_deck/ui_state(mob/user)
	return GLOB.always_state

/obj/item/ccg_deck/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/simple/ccg_cards))

/obj/item/ccg_deck/ui_interact(mob/user, datum/tgui/ui)
	var/datum/ccg_match/active_match = get_active_match()
	if(!active_match)
		return
	active_match.add_spectator(user)
	active_match.sync_soundtrack_for(user)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GwyntTable", name)
		ui.open()

/obj/item/ccg_deck/ui_close(mob/user)
	var/datum/ccg_match/active_match = get_active_match()
	active_match?.remove_spectator(user)
	active_match?.stop_soundtrack_for(user)

/obj/item/ccg_deck/ui_data(mob/user)
	var/datum/ccg_match/active_match = get_active_match()
	if(!active_match)
		return list("waiting" = !!inviter_ckey, "offeredName" = inviter_name)
	return active_match.ui_data_for(user, src)

/obj/item/ccg_deck/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/datum/ccg_match/active_match = get_active_match()
	if(!active_match)
		return FALSE
	var/mob/user = ui.user
	switch(action)
		if("leave_spectator")
			if(active_match.remove_spectator(user))
				active_match.stop_soundtrack_for(user)
				SStgui.close_user_uis(user, src)
				return TRUE
			return FALSE
		if("toggle_soundtrack")
			if(user?.client?.prefs)
				user.client.prefs.ccg_soundtrack_enabled = !user.client.prefs.ccg_soundtrack_enabled
				active_match.sync_soundtrack_for(user)
				active_match.update_deck_uis()
				return TRUE
		if("collect")
			if(!active_match.side_for_user(user, src))
				return FALSE
			if(end_match_session(active_match))
				return TRUE
		if("play")
			if(active_match.play_card(user, params["card"], src, params))
				active_match.update_deck_uis()
				return TRUE
		if("mulligan")
			if(active_match.mulligan_card(user, params["card"], src))
				active_match.update_deck_uis()
				return TRUE
		if("ready_mulligan")
			if(active_match.ready_mulligan(user, src))
				active_match.update_deck_uis()
				return TRUE
		if("leader")
			if(active_match.use_leader(user, src))
				active_match.update_deck_uis()
				return TRUE
		if("pass")
			if(active_match.pass(user, src))
				active_match.update_deck_uis()
				return TRUE
	return FALSE

/obj/item/ccg_deck/starter
	name = "阿莱特起始套牌"

/obj/item/ccg_deck/starter/random
	name = "阿莱特起始套牌"
	desc = "用于回合制阿莱特卡牌游戏的未拆封起始套牌。里面属于哪个阵营，全凭运气。"

/obj/item/ccg_deck/starter/random/Initialize(mapload)
	var/static/list/faction_names = list(
		CCG_FACTION_AZURIA = "Rockhill",
		CCG_FACTION_ENIGMA = "Enigma",
		CCG_FACTION_NALEDI = "Naledi",
		CCG_FACTION_GRENZELHOFT = "Grenzelhoft",
		CCG_FACTION_RANESHI = "Raneshi",
		CCG_FACTION_GRONN = "Gronn",
		CCG_FACTION_KAZENGUN = "Kazengun",
	)
	starter_faction = pick(faction_names)
	name = "阿莱特起始套牌（[ccg_faction(starter_faction)?.name || faction_names[starter_faction]]）"
	return ..()

/obj/item/ccg_deck/starter/azuria
	name = "阿莱特起始套牌（岩丘）"
	starter_faction = CCG_FACTION_AZURIA

/obj/item/ccg_deck/starter/enigma
	name = "阿莱特起始套牌（恩尼格玛）"
	starter_faction = CCG_FACTION_ENIGMA

/obj/item/ccg_deck/starter/naledi
	name = "阿莱特起始套牌（纳莱迪）"
	starter_faction = CCG_FACTION_NALEDI

/obj/item/ccg_deck/starter/grenzelhoft
	name = "阿莱特起始套牌（格伦泽尔霍夫特）"
	starter_faction = CCG_FACTION_GRENZELHOFT

/obj/item/ccg_deck/starter/raneshi
	name = "阿莱特起始套牌（拉涅申）"
	starter_faction = CCG_FACTION_RANESHI

/obj/item/ccg_deck/starter/gronn
	name = "阿莱特起始套牌（格隆恩）"
	starter_faction = CCG_FACTION_GRONN

/obj/item/ccg_deck/starter/kazengun
	name = "阿莱特起始套牌（风郡）"
	starter_faction = CCG_FACTION_KAZENGUN

/obj/item/ccg_card_single
	name = "收藏卡牌"
	desc = "一张可收藏的卡牌。"
	icon = 'modular_twilight_axis/icons/obj/gwynt_objs.dmi'
	icon_state = "gwint_card"
	w_class = WEIGHT_CLASS_TINY
	grid_width = 32
	grid_height = 32
	var/card_id

/obj/item/ccg_card_single/proc/set_card(new_card_id)
	card_id = new_card_id
	var/datum/ccg_card/card = ccg_card(card_id)
	if(card)
		name = card.name
		desc = card.desc

/obj/item/ccg_card_single/Initialize(mapload)
	. = ..()
	if(card_id)
		set_card(card_id)

/obj/item/ccg_card_single/examine(mob/user)
	. = ..()
	var/datum/ccg_card/card = ccg_card(card_id)
	if(!card)
		return
	var/datum/ccg_faction/faction = ccg_faction(card.faction)
	var/power_text = (card.row == CCG_ROW_WEATHER || card.row == CCG_ROW_SPECIAL) ? "" : "，战力[card.power]"
	. += span_info("[ccg_rarity_label(card.rarity)]卡牌，阵营：[faction ? faction.name : "中立"]。[ccg_row_label(card.row)][power_text][card.hero ? "，英雄" : ""]。")
	. += span_info("用此卡点击阿莱特牌组即可将其加入。一副牌组最多可放入[ccg_card_deck_limit(card)]张此卡。")

/obj/item/ccg_card_single/attack_self(mob/user)
	user.examinate(src)

/obj/item/ccg_card_single/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/ccg_deck))
		var/obj/item/ccg_deck/deck = I
		deck.add_single_card(user, src)
		return TRUE
	return ..()

/obj/item/ccg_card_generator
	name = "密封卡包"
	desc = "内含一张随机收藏卡牌的密封卡包。"
	icon = 'modular_twilight_axis/icons/obj/gwynt_objs.dmi'
	icon_state = "gwint_card"
	w_class = WEIGHT_CLASS_TINY
	grid_width = 32
	grid_height = 32
	var/card_rarity = CCG_RARITY_RARE
	var/limited_only = FALSE

/obj/item/ccg_card_generator/Initialize(mapload)
	. = ..()
	var/card_id = pick_random_card()
	if(!card_id)
		return
	var/obj/item/ccg_card_single/single = new(loc)
	single.set_card(card_id)
	return INITIALIZE_HINT_QDEL

/obj/item/ccg_card_generator/proc/pick_random_card()
	if(!length(GLOB.ccg_cards_by_id))
		ccg_build_card_registry()
	var/list/candidates = list()
	for(var/card_id in GLOB.ccg_cards_by_id)
		var/datum/ccg_card/card = ccg_card(card_id)
		if(card?.rarity == card_rarity && (!limited_only || card.limited))
			candidates += card_id
	if(!length(candidates))
		return null
	return pick(candidates)

/obj/item/ccg_card_generator/common
	name = "皱褶普通卡包"
	desc = "破旧的卡包，内含一张随机普通收藏卡牌。"
	card_rarity = CCG_RARITY_BASE

/obj/item/ccg_card_generator/rare
	name = "密封稀有卡包"
	desc = "内含一张随机稀有收藏卡牌的密封卡包。"
	card_rarity = CCG_RARITY_RARE

/obj/item/ccg_card_generator/unique
	name = "密封独特卡包"
	desc = "内含一张随机独特收藏卡牌的密封卡包。"
	card_rarity = CCG_RARITY_UNIQUE

/obj/item/ccg_card_booster
	name = "密封卡牌补充包"
	desc = "内含五张随机收藏卡牌的密封补充包。"
	icon = 'modular_twilight_axis/icons/obj/gwynt_objs.dmi'
	icon_state = "gwint_card"
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32
	var/list/card_weights = list(
		"common_repeatable" = 8,
		"common_limited" = 5,
		"rare" = 2,
		"unique" = 1,
	)

/obj/item/ccg_card_booster/attack_self(mob/user)
	var/turf/drop_turf = get_turf(user)
	if(!drop_turf)
		return
	for(var/i in 1 to 5)
		var/card_id = pick_random_card()
		if(!card_id)
			continue
		var/obj/item/ccg_card_single/single = new(drop_turf)
		single.set_card(card_id)
		to_chat(user, span_notice("一张[single.name]从[src]中滑出。"))
	qdel(src)

/obj/item/ccg_card_booster/proc/pick_random_card()
	if(!length(GLOB.ccg_cards_by_id))
		ccg_build_card_registry()
	var/list/category_candidates = list()
	var/list/available_weights = list()
	for(var/category_key in card_weights)
		var/list/candidates = list()
		for(var/card_id in GLOB.ccg_cards_by_id)
			var/datum/ccg_card/card = ccg_card(card_id)
			if(!card)
				continue
			if(card_matches_category(card, category_key))
				candidates += card_id
		if(length(candidates))
			category_candidates[category_key] = candidates
			available_weights[category_key] = card_weights[category_key]
	if(!length(available_weights))
		return null
	var/selected_category = pickweight(available_weights)
	var/list/candidates = category_candidates[selected_category]
	return pick(candidates)

/obj/item/ccg_card_booster/proc/card_matches_category(datum/ccg_card/card, category)
	switch(category)
		if("common_repeatable")
			return card.rarity == CCG_RARITY_BASE && !card.limited && card.row != CCG_ROW_WEATHER && card.row != CCG_ROW_SPECIAL
		if("common_limited")
			return card.rarity == CCG_RARITY_BASE && card.limited && card.row != CCG_ROW_WEATHER && card.row != CCG_ROW_SPECIAL
		if("rare")
			return card.rarity == CCG_RARITY_RARE
		if("unique")
			return card.rarity == CCG_RARITY_UNIQUE
	return FALSE

/obj/item/ccg_card_booster/premium
	name = "高级密封卡牌补充包"
	desc = "内含五张随机收藏卡牌的高级密封补充包。"
	card_weights = list(
		"common_repeatable" = 5,
		"common_limited" = 8,
		"rare" = 3,
		"unique" = 2,
	)

/obj/item/ccg_card_single/rare_captain
	card_id = "rare_captain"

/obj/item/ccg_card_single/rare_saboteur
	card_id = "rare_saboteur"

/obj/item/ccg_card_single/unique_spy
	card_id = "unique_spy"
