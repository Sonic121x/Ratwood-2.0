
/obj/structure/roguemachine/stockpile
	name = "仓储机"
	desc = "一种连接贸易网络的魔导装置。使用者可以从这些设备上以一定价格购买基础货物、制作材料与食物，也可以在此出售它们换钱。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "stockpile_vendor"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/current_category = "Raw Materials"
	var/list/categories = list("Raw Materials", "Refined", "Alchemy", "Fruit", "Vegetable", "Animal", "Seafood")
	var/datum/withdraw_tab/withdraw_tab = null

/obj/structure/roguemachine/stockpile/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("空手左键点击，可查看呕食厅的仓储。储存的玛门可用于购买种类繁多的材料，这些材料随后会被售卖出来供人使用。")
	. += span_info("手持物品左键点击机器，会将其存入仓储，并给予你相应的钱币作为回报。请务必先在神经锁上注册账户，否则你将收不到任何钱币。")
	. += span_info("右键点击机器，会自动将周围所有物品一次性存入仓储。")
	. += span_info("呕食厅的仓储会随时间自然补货。存入的物品会累加进仓储数量，之后可供他人购买，或由总管出口以赚取利润。")

/obj/structure/roguemachine/stockpile/Initialize(mapload)
	. = ..()
	SSroguemachine.stock_machines += src
	withdraw_tab = new(src)


/obj/structure/roguemachine/stockpile/Destroy()
	SSroguemachine.stock_machines -= src
	QDEL_NULL(withdraw_tab)
	return ..()

/obj/structure/roguemachine/stockpile/examine(mob/user)
	. = ..()
	. += span_info("右键可出售仓储机前方的全部物品。")
	if(SStreasury.royal_custom_unlocked)
		. += span_info(SStreasury.royal_custom_active ? "王权关税正在施行；直接进口需向王权缴纳税款。" : "王权关税已获特许，但目前中止。")
	else
		var/v = SStreasury.economic_output || 0
		. += span_info("王权关税特许状将在仓储贸易额达到 [SStreasury.royal_custom_threshold] 玛门时解锁（目前为 [v]）。")

/obj/structure/roguemachine/stockpile/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/stockpile/ui_status(mob/user, datum/ui_state/state)
	if(!isliving(user) || user.stat == DEAD)
		return UI_CLOSE
	return ..()

/obj/structure/roguemachine/stockpile/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	ui_interact(user)

/obj/structure/roguemachine/stockpile/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Stockpile", name)
		ui.open()

/obj/structure/roguemachine/stockpile/ui_data(mob/user)
	check_charter_unlock()
	var/list/data = list()
	data["budget"] = withdraw_tab.budget
	data["compact"] = withdraw_tab.compact ? TRUE : FALSE
	data["categories"] = categories
	data["category"] = withdraw_tab.current_category
	data["food_stipend"] = (ishuman(user) && HAS_TRAIT(user, TRAIT_ROYAL_SUBSIDY)) ? TRUE : FALSE
	data["fiscal_authority"] = has_fiscal_authority(user) ? TRUE : FALSE
	var/treasury_balance = SStreasury.discretionary_fund?.balance || 0
	data["treasury_floor"] = SStreasury.stockpile_purchase_floor
	data["below_floor"] = treasury_balance < SStreasury.stockpile_purchase_floor
	data["charter_unlocked"] = SStreasury.royal_custom_unlocked ? TRUE : FALSE
	data["charter_active"] = SStreasury.royal_custom_active ? TRUE : FALSE
	data["charter_margin"] = SStreasury.royal_custom_margin
	data["charter_volume"] = SStreasury.economic_output || 0
	data["charter_threshold"] = SStreasury.royal_custom_threshold
	data["no_deposit"] = FALSE
	data["title"] = ""
	data["subtitle"] = ""
	data["community_progress"] = 0
	data["community_target"] = STOCKPILE_COMMUNITY_CONTRIBUTION_THRESHOLD
	data["community_points"] = 0
	data["community_visible"] = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/Humanuser = user
		if(is_community_contribution_eligible(Humanuser))
			data["community_visible"] = TRUE
			var/datum/sleep_adv/Sleepadvance = Humanuser.mind?.sleep_adv
			if(Sleepadvance)
				data["community_progress"] = Sleepadvance.community_contribution_count
				data["community_points"] = Sleepadvance.community_status_points

	var/list/rows = list()
	for(var/datum/roguestock/stockpile/R in SStreasury.stockpile_datums)
		R.refresh_auto_price()
		var/list/shortage = R.get_shortage_progress()
		var/export_unit_price = 0
		if(R.importexport_amt > 0)
			export_unit_price = round(R.get_export_price() / R.importexport_amt)
		rows += list(list(
			"ref" = "\ref[R]",
			"name" = R.name,
			"desc" = R.desc,
			"category" = R.category,
			"amount" = R.stockpile_amount,
			"limit" = R.stockpile_limit,
			"withdraw_price" = R.withdraw_price,
			"deposit_price" = R.payout_price,
			"export_price" = export_unit_price,
			"import_price" = withdraw_tab.direct_import_price(R),
			"withdraw_disabled" = R.withdraw_disabled ? TRUE : FALSE,
			"accept_enabled" = R.accept_toggle_enabled ? TRUE : FALSE,
			"event_tag" = R.get_event_label(),
			"shortage_progress" = shortage ? shortage["progress"] : 0,
			"shortage_target" = shortage ? shortage["target"] : 0,
			"shortage_affected" = shortage ? shortage["affected"] : "",
		))
	data["stocks"] = rows

	// The treasure-mint bounty was removed; no bounty datums remain. Keep the key so the
	// Stockpile TGUI's bounty section simply stays hidden (it gates on bounties.length).
	data["bounties"] = list()
	return data

/obj/structure/roguemachine/stockpile/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("withdraw")
			var/datum/roguestock/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D)
				return TRUE
			withdraw_tab.do_withdraw(D, usr)
			return TRUE
		if("set_category")
			var/cat = params["category"]
			if(cat == "__conditions__" || (cat in categories))
				withdraw_tab.current_category = cat
				current_category = cat
			return TRUE
		if("toggle_compact")
			withdraw_tab.compact = !withdraw_tab.compact
			return TRUE
		if("refund_budget")
			if(withdraw_tab.budget > 0)
				budget2change(withdraw_tab.budget, usr)
				withdraw_tab.budget = 0
				playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
			return TRUE
		if("direct_import")
			var/datum/roguestock/D = locate(params["ref"]) in SStreasury.stockpile_datums
			if(!D)
				return TRUE
			withdraw_tab.do_direct_import(D, usr)
			return TRUE

/obj/structure/roguemachine/stockpile/proc/check_charter_unlock()
	if(SStreasury.royal_custom_unlocked)
		return
	var/volume = SStreasury.economic_output || 0
	if(volume < SStreasury.royal_custom_threshold)
		return
	SStreasury.royal_custom_unlocked = TRUE
	SStreasury.royal_custom_active = TRUE
	scom_announce("The Stewardry has tallied [SStreasury.royal_custom_threshold] mammons of trade. By ancient charter, the Crown's Right of Customs in Excess is invoked - duties that once paid for the middleman's cut now flow into the Crown's purse instead. The Steward may set the rate at the Stewardry.")
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.client || !H.mind)
			continue
		if(H.mind.assigned_role == "Steward")
			send_ooc_note("<b>Royal Custom unlocked.</b> Import surcharges at every stockpile now flow to the Crown's purse. Adjust the margin at your Trading Interface.", name = H.real_name)

/obj/structure/roguemachine/stockpile/proc/try_auto_export_units(datum/roguestock/D, units)
	if(!D || !D.trade_good_id || units <= 0)
		return 0
	if(D.autoexport_disabled)
		return 0
	if(D.stockpile_amount < units)
		return 0
	var/list/best = SSeconomy.get_best_export_region(D.trade_good_id)
	if(!best || !best["region_id"])
		return 0
	var/datum/economic_region/region = GLOB.economic_regions[best["region_id"]]
	if(!region)
		return 0
	var/remaining = region.demands_today[D.trade_good_id] || 0
	if(remaining < units)
		return 0
	return SSeconomy.manual_export(null, best["region_id"], D.trade_good_id, units)

/obj/structure/roguemachine/stockpile/proc/attemptsell(obj/item/I, mob/H, message = TRUE, sound = TRUE)
	if(istype(I, /obj/structure/handcart)) // Handle carts specially - sell their contents, leave the empty cart
		var/obj/structure/handcart/cart = I
		var/turf/cart_location = get_turf(cart)
		var/list/cart_contents = cart.stuff_shit.Copy()
		for(var/atom/movable/cart_content in cart_contents) // Process all items inside the cart first
			if(isitem(cart_content))
				attemptsell(cart_content, H, message, FALSE)

		for(var/atom/movable/remaining_item in cart_contents) // Any items that weren't sold (still exist) go to the ground
			if(!QDELETED(remaining_item))
				remaining_item.forceMove(cart_location)
		// Setting cart back to square 1
		cart.stuff_shit = list()
		cart.current_capacity = 0
		cart.update_icon()
		if(sound == TRUE)
			playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		return

	if(istype(I, /obj/item/roguebin)) // Handle roguebins specially - sell their contents, leave the empty bin
		var/obj/item/roguebin/bin = I
		var/turf/bin_location = get_turf(bin)
		var/datum/component/storage/STR = bin.GetComponent(/datum/component/storage)
		if(STR)
			var/list/bin_contents = STR.contents()
			for(var/obj/item/bin_item in bin_contents) // Process all items inside the bin first
				attemptsell(bin_item, H, message, FALSE)

			for(var/obj/item/remaining_item in bin_contents) // Any items that weren't sold (still exist) go to the ground
				if(!QDELETED(remaining_item))
					STR.remove_from_storage(remaining_item, bin_location)
		if(sound == TRUE)
			playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		return

	// Pre-check: farmer must have a Nervelock account. Otherwise the stockpile would silently
	// eat their goods for no payment - do not scam walk-ins.
	var/has_account = SStreasury.has_account(H)
	if(!has_account)
		if(message)
			say("No account found for [H]. Submit your fingers to a Nervelock for inspection.")
		return

	// Pre-check: Crown's Purse must be solvent enough to pay. Below the Steward-set floor,
	// the Crown refuses purchases entirely - goods stay in the farmer's hands.
	var/treasury_balance = SStreasury.discretionary_fund?.balance || 0
	var/below_floor = treasury_balance < SStreasury.stockpile_purchase_floor

	for(var/datum/roguestock/R in SStreasury.stockpile_datums)
		if(istype(I, /obj/item/natural/bundle))
			var/obj/item/natural/bundle/B = I
			if(B.stacktype == R.item_type)
				if(!R.accept_toggle_enabled)
					if(message)
						say("The Crown has no interest in [R.name] at this time.")
					return
				if(below_floor)
					if(message)
						say("The Crown's ledger is thin. No purchases today.")
					return
				var/bundle_amt = B.amount
				var/full_on_arrival = (R.stockpile_amount >= R.stockpile_limit)
				R.stockpile_amount += bundle_amt
				var/auto_exported = FALSE
				if(full_on_arrival)
					if(try_auto_export_units(R, bundle_amt) <= 0)
						R.stockpile_amount -= bundle_amt
						if(message)
							if(R.autoexport_disabled)
								say("The Crown's [R.name] stockpile is full, autoexport disabled, take it elsewhere.")
							else
								say("The Crown's [R.name] stockpile is full and no region demands can absorb your load. Try smaller bundles or take it elsewhere.")
						return
					auto_exported = TRUE
				SStreasury.dirty_market_view()
				if(message == TRUE)
					stock_announce("[bundle_amt] units of [R.name] has been stockpiled.")
				qdel(B)
				if(sound == TRUE)
					playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				R.refresh_auto_price()
				if(ishuman(H) && !I.stockpile_withdrawn && is_community_contribution_eligible(H))// Can not withdraw from stockpile for points, can't be a combat role
					var/mob/living/carbon/human/HC = H
					HC.mind?.sleep_adv?.add_community_contribution(bundle_amt)
				var/amt = R.payout_price * bundle_amt
				if(HAS_TRAIT(H, TRAIT_ROYAL_SUBSIDY))
					SStreasury.log_fund_entry(new /datum/treasury_entry(null, SStreasury.discretionary_fund, SStreasury.discretionary_fund, 0, "补贴存入：[H.real_name] 的 [R.name]"))
					record_round_statistic(STATS_DIRECT_TREASURY_TRANSFERS, amt)
					send_ooc_note("<b>神经锁：</b>补贴从 [R.name] 支取 [amt]m。感谢你的勤勉效劳。", name = H.real_name)
					return
				if(!I.stockpile_withdrawn)
					SStreasury.economic_output += amt
				SStreasury.give_money_account(amt, H, "+[amt]，来自 [R.name] 赏金")
				if(auto_exported && message)
					say("王权的 [R.name] 仓储已满——已代你运往外地。")
				record_round_statistic(STATS_STOCKPILE_EXPANSES, amt)
				return
			continue
		// Bloc to replace old vault mechanics
		else if(istype(I,R.item_type))
			if(!R.check_item(I))
				continue
			// Steward-controlled accept toggle. Refuses with a message; item stays in hand.
			if(!R.accept_toggle_enabled)
				if(message)
					say("王权目前对 [R.name] 不感兴趣。")
				return
			if(below_floor)
				if(message)
					say("王权的账册吃紧。今日不再收购。")
				return
			var/auto_exported = FALSE
			var/full_on_arrival = (R.stockpile_amount >= R.stockpile_limit)
			if(full_on_arrival)
				R.stockpile_amount += 1
				if(try_auto_export_units(R, 1) <= 0)
					R.stockpile_amount -= 1
					if(message)
						if(R.autoexport_disabled)
							say("王权的 [R.name] 仓储已满，自动出口已禁用，请另寻他处。")
						else
							say("王权的 [R.name] 仓储已满，且没有任何地区的需求能消化你这批货。试试更小的批量，或另寻他处。")
					return
				auto_exported = TRUE
			R.refresh_auto_price()
			var/list/settlement = R.get_quality_settlement(I)
			var/amt = settlement["seller_payout"]
			var/crown_delta = settlement["crown_delta"]
			var/quality_baseline = settlement["baseline"]
			var/true_value = I.get_real_price()
			if(message && I.has_item_quality && I.item_quality != ITEM_QUALITY_STANDARD)
				var/flavor = quality_delta_flavor(I.item_quality)
				if(flavor)
					say(flavor)
					to_chat(H, span_info("[src] 说道：“[flavor]”"))
			if(crown_delta > 0)
				SStreasury.mint(SStreasury.discretionary_fund, crown_delta, "品质溢价：[I.name]（+[crown_delta]m）")
			else if(crown_delta < 0)
				SStreasury.burn(SStreasury.discretionary_fund, -crown_delta, "品质罚金：[I.name]（[crown_delta]m）")
				record_treasury_expense(TREASURY_FLOW_MISC, "Quality Penalty", -crown_delta)
			if(!full_on_arrival)
				R.stockpile_amount += 1
			SStreasury.dirty_market_view()
			qdel(I)
			if(message == TRUE)
				stock_announce("[R.name] 已入库。")
			if(sound == TRUE)
				playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
			if(ishuman(H) && !I.stockpile_withdrawn && is_community_contribution_eligible(H))// Can not withdraw from stockpile for points, can't be a combat role
				var/mob/living/carbon/human/HC = H
				HC.mind?.sleep_adv?.add_community_contribution(1)
			if(amt)
				if(HAS_TRAIT(H, TRAIT_ROYAL_SUBSIDY))
					SStreasury.log_fund_entry(new /datum/treasury_entry(null, SStreasury.discretionary_fund, SStreasury.discretionary_fund, 0, "补贴存入：[H.real_name] 的 [R.name]"))
					record_round_statistic(STATS_DIRECT_TREASURY_TRANSFERS, amt)
					send_ooc_note("<b>神经锁：</b>补贴从 [R.name] 支取 [amt]m。感谢你的勤勉效劳。", name = H.real_name)
					return
				if(!I.stockpile_withdrawn)
					SStreasury.economic_output += true_value
				var/bounty_msg = "+[amt]，来自 [R.name] 赏金"
				if(crown_delta != 0)
					var/seller_delta = amt - quality_baseline
					var/seller_sign = seller_delta > 0 ? "+" : ""
					var/crown_sign = crown_delta > 0 ? "+" : ""
					bounty_msg = "+[amt]，来自 [R.name] 赏金（品质：你 [seller_sign][seller_delta]m，王权 [crown_sign][crown_delta]m，基准 [quality_baseline]m）"
				SStreasury.give_money_account(amt, H, bounty_msg)
				if(auto_exported && message)
					say("王权的 [R.name] 仓储已满——已代你运往外地。")
			record_round_statistic(STATS_STOCKPILE_EXPANSES, amt)
			record_round_statistic(STATS_STOCKPILE_REVENUE, true_value)
			return

	// Nothing in the stockpile accepted this item
	if(message)
		say("[I.name] is not accepted here.")

/obj/structure/roguemachine/stockpile/attackby(obj/item/P, mob/user, params)
	if(ishuman(user))
		if(istype(P, /obj/item/roguecoin/gilbranze))
			return

	if(istype(P, /obj/item/roguecoin/inqcoin))
		return

	if(istype(P, /obj/item/roguecoin))
		withdraw_tab.insert_coins(P)
		return attack_hand(user)
	else if (ishuman(user))
		attemptsell(P, user, TRUE, TRUE)

// Ratwood deviation: dragging a handcart onto the machine sells its contents - without this
// (and the user-tile scan below) nothing ever routes a cart into attemptsell()'s cart branch
/obj/structure/roguemachine/stockpile/MouseDrop_T(atom/dropped, mob/living/user)
	if(!ishuman(user))
		return ..()
	if(!istype(dropped, /obj/structure/handcart))
		return ..()
	if(!user.Adjacent(src) || !user.Adjacent(dropped))
		return
	attemptsell(dropped, user, TRUE, TRUE)

/obj/structure/roguemachine/stockpile/attack_right(mob/user)
	if(ishuman(user))
		// Ratwood deviation: AP only scans the machine's own tile; scan the user's tile too so
		// a cart (or goods) parked underfoot sells without shoving it onto the machine
		var/list/scan_turfs = list(get_turf(src))
		var/turf/user_turf = get_turf(user)
		if(!(user_turf in scan_turfs))
			scan_turfs += user_turf
		for(var/turf/T as anything in scan_turfs)
			for(var/obj/I in T)
				attemptsell(I, user, FALSE, FALSE)
		say("批量出售进行中...")
		playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
