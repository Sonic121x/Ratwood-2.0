#define TAB_MAIN 1
#define TAB_BANK 2
#define TAB_IMPORT 4
#define TAB_DEBT 5
#define TAB_FISCAL 6
#define TAB_PAYDAY 8
#define TAB_SALTMINE 9

/obj/structure/roguemachine/steward
	name = "总务中枢"
	desc = "总管最可靠的伙伴。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "steward_machine"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	locked = FALSE
	var/keycontrol = "steward"
	var/current_tab = TAB_MAIN
	var/compact = TRUE
	var/total_deposit = 0
	var/list/excluded_jobs = list("Wretch","Vagabond","Adventurer")
	var/list/daily_payments = list() // Associative list: job name -> payment amount
	// Last trade-modal quote keyed by ckey. Read by ui_data to round-trip per-user. (Step 15)
	var/list/last_trade_quote = list()
	// Per-user ledger view state keyed by ckey: list("open", "page", "filter"). Only populated
	// into ui_static_data while a user has the Ledger tab open, so the full ledger never rides
	// the per-tick Market Scroll payload.
	var/list/ledger_view = list()
	// Item 6 decrees: anti-spam gate on Letter of Citizenry printing.
	var/residency_print_cooldown = 0
	COOLDOWN_DECLARE(fulfill_retry_cooldown)

/obj/structure/roguemachine/steward/Initialize(mapload)
	. = ..()
	if(SStreasury.steward_machine == null) //The "only one" mapped in Nerve Master at map start
		SStreasury.steward_machine = src
	setup_default_payments()

//	For competence of life I will allow you,
//	That lack of means enforce you not to evil:
/obj/structure/roguemachine/steward/proc/setup_default_payments()
	daily_payments["Knight Captain"] = 40
	if(SSmapping.current_map.map_name == "Dun World")
		daily_payments["Sergeant"] = 40 //Garrison
	if(SSmapping.current_map.map_name == "Desert Town")
		daily_payments["Slave Master"] = 50
		daily_payments["Cataphract"] = 40
		daily_payments["Janissary Sergeant"] = 40 //Garrison
		daily_payments["Janissary"] = 30
		daily_payments["Azeb Agha"] = 35
		daily_payments["Azeb"] = 20
	else
		daily_payments["Knight"] = 40
		daily_payments["Man at Arms"] = 30
		daily_payments["Warden"] = 20
		daily_payments["Dungeoneer"] = 25
	if(SSmapping.current_map.map_name == "Rockhill")
		daily_payments["Watch Captain"] = 35 //Don't get to live in a fancy keep with servants. More expenses.
		daily_payments["Master Warden"] = 35 //Garrison
		daily_payments["Sergeant"] = 40 //Garrison
		daily_payments["City Guard"] = 30
		daily_payments["Vanguard"] = 10
	daily_payments["Rookie"] = 15//paid more than squires because they don't get to live in a castle with maids cooking them dinner
	daily_payments["Veteran"] = 20
	daily_payments["Squire"] = 10
//courtiers
	daily_payments["Head Physician"] = 40 //Doctors
	daily_payments["Apothecary"] = 15 //paid by the keep to heal people, would make sense.
	daily_payments["Court Magician"] = 40 //University
	if(SSmapping.current_map.map_name == "Desert Town")
		daily_payments["Palace Chaplain"] = 20
		daily_payments["Headslave"] = 20 //Manor-House
	else
		daily_payments["Court Chaplain"] = 30
		daily_payments["Seneschal"] = 40 //Manor-House
		daily_payments["Servant"] = 20
	daily_payments["Archivist"] = 10
	daily_payments["Magicians Associate"] = 10
	daily_payments["Jester"] = 6

	if(SSmapping.current_map.map_name == "Roguetest")
		daily_payments["Shophand"] = 999
	// Item 6 decrees: bump defaults up to any roundstart-active charter's mandated floor.
	enforce_wage_floors()

/proc/has_fiscal_authority(mob/user)
	if(!user)
		return FALSE
	if(user.job == "Steward" || user.job == "Clerk" || user.job == "Grand Duke")
		return TRUE
	if(SSticker.regentmob && user == SSticker.regentmob)
		return TRUE
	return FALSE


/obj/structure/roguemachine/steward/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == keycontrol || istype(K, /obj/item/roguekey/lord)) //Master key
			locked = !locked
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			(locked) ? (icon_state = "steward_machine_off") : (icon_state = "steward_machine")
			update_icon()
			return
		else
			to_chat(user, span_warning("钥匙不对。"))
			return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/K = P
		if(!K.contents.len)
			return
		var/list/keysy = K.contents.Copy()
		for(var/obj/item/roguekey/KE in keysy)
			if(KE.lockid == keycontrol)
				locked = !locked
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
				(locked) ? (icon_state = "steward_machine_off") : (icon_state = "steward_machine")
				update_icon()
				return
		to_chat(user, span_warning("钥匙不对。"))
		return
	if(istype(P, /obj/item/roguecoin/gilbranze))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		record_round_statistic(STATS_MAMMONS_DEPOSITED, P.get_real_price())
		SStreasury.mint(SStreasury.discretionary_fund, P.get_real_price(), "NERVE MASTER deposit")
		qdel(P)
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		return
	return ..()


/obj/structure/roguemachine/steward/Topic(href, href_list)
	. = ..()
	var/realmname = SSmapping.map_adjustment.realm_name
	if(!usr.canUseTopic(src, BE_CLOSE) || locked)
		return
	if(href_list["switchtab"])
		current_tab = text2num(href_list["switchtab"])
	if(href_list["import"])
		// Step 15: crown imports (GLOB.crown_imports) replaced the legacy roguestock imports.
		var/datum/crown_import/D = locate(href_list["import"]) in GLOB.crown_imports
		if(!D)
			return
		var/amt = D.get_import_price()
		if(!SStreasury.burn(SStreasury.discretionary_fund, amt, "Import: [D.name]"))
			say("玛门不足。")
			return
		SStreasury.total_import += amt
		record_treasury_expense(TREASURY_FLOW_IMPORT, treasury_role_of(usr), amt)
		record_round_statistic(STATS_STOCKPILE_IMPORTS_VALUE, amt)
		if(amt >= 100) //Only announce big spending.
			scom_announce("[realmname] 以 [amt] 枚 玛门 的价格进口了 [D.name]。", )
		D.raise_demand()
		addtimer(CALLBACK(src, PROC_REF(do_import), D.type), 10 SECONDS)
	if(href_list["export"])
		var/datum/roguestock/D = locate(href_list["export"]) in SStreasury.stockpile_datums
		if(!D)
			return
		// Trade-good entries must export through the StewardTrade TGUI (manual_export), which
		// enforces and decrements regional demand. This legacy handler has no UI link anymore;
		// without this guard a crafted href could mint at best-region prices with no demand cap.
		if(D.trade_good_id)
			return
		if(!SStreasury.do_export(D))
			say("库存不足。")
			return
	if(href_list["setpurchasefloor"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/current_floor = SStreasury.stockpile_purchase_floor
		var/new_floor = input(usr, "设置王权采购下限。当余额低于此数值时，库存将拒绝收购——货物仍留在卖方手中。（0-10000 玛门）", src, current_floor) as null|num
		if(isnull(new_floor))
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		new_floor = CLAMP(round(new_floor), 0, 10000)
		SStreasury.stockpile_purchase_floor = new_floor
		say("王权采购下限已设为 [new_floor]m。")
		log_game("PURCHASE FLOOR: [key_name(usr)] set stockpile purchase floor to [new_floor]m")
	if(href_list["clearloandebtor"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/list/debtors = list()
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(HAS_TRAIT(H, TRAIT_DEBTOR))
				debtors["[H.real_name]"] = H
		if(!length(debtors))
			say("目前没有标记的债务人。")
			return
		var/pick = input(usr, "要清除哪位债务人的违约标记？", src) as null|anything in debtors
		if(!pick)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/mob/living/carbon/human/target = debtors[pick]
		if(!target || !HAS_TRAIT(target, TRAIT_DEBTOR))
			return
		REMOVE_TRAIT(target, TRAIT_DEBTOR, TRAIT_GENERIC)
		var/datum/loan/forgiven = SStreasury.get_loan_for(target)
		var/loan_amt = forgiven ? forgiven.get_remaining_due() : 0
		if(forgiven)
			SStreasury.loans -= forgiven
			qdel(forgiven)
		SStreasury.clear_poll_tax_debt(target)
		say("[target.real_name] 的债务人标记已清除；所有王权债务一笔勾销。")
		log_game("DEBT FORGIVEN: [key_name(usr)] cleared debtor mark on [key_name(target)][loan_amt ? " (wrote off [loan_amt]m loan)" : ""]")
		to_chat(target, span_notice("总管府已从我名下清除了违约标记。我欠王权的债务已获宽免。"))
	if(href_list["clearpolltax"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/list/in_arrears = list()
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(SStreasury.poll_tax_owed[H] || SStreasury.poll_tax_debt_days[H] || HAS_TRAIT(H, TRAIT_ARREARS))
				in_arrears["[H.real_name]"] = H
		if(!length(in_arrears))
			say("账册上没有拖欠人头税的人。")
			return
		var/pick = input(usr, "要清除哪位臣民拖欠的人头税？", src) as null|anything in in_arrears
		if(!pick)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/mob/living/carbon/human/target = in_arrears[pick]
		if(!target)
			return
		var/was_owed = SStreasury.poll_tax_owed[target] || 0
		var/was_overdue = SStreasury.poll_tax_debt_days[target] || 0
		SStreasury.clear_poll_tax_debt(target)
		say("[target.real_name] 拖欠的人头税已清除。")
		log_game("POLL TAX CLEARED: [key_name(usr)] cleared [was_owed]m poll tax arrears on [key_name(target)] ([was_overdue] day\s overdue)")
		to_chat(target, span_notice("总管府已清除我拖欠的人头税。王权记在我头上的账已一笔勾销。"))
	// Step 15: stockpile price/limit/withdraw management moved to the StewardTrade TGUI
	// (setprice/setlimit/togglewithdraw Topic handlers removed). Ratwood keeps the passive
	// import rate handler; that system is not covered by the TGUI.
	if(href_list["setrate"])
		var/datum/roguestock/D = locate(href_list["setrate"]) in SStreasury.stockpile_datums
		if(!D)
			return              //Cheaper prices, no taxes, the price? Commitment. You can only change the rates at day. I'd like to make the window shorter,
		if(GLOB.tod == "night") //less chance to micromanage, incentivize doing other things at later hours, make it unable to be changed at dusk too, but this needs testing first
			say("只有在 阿斯特拉塔 照耀之时，供应商才愿意修改交易。")
			return
		var/newrate = input(usr, "为 [D.name] 设置新的远程进口速率", src, D.passive_generation) as null|num
		if(!isnull(newrate))
			if(!usr.canUseTopic(src, BE_CLOSE) || locked)
				return
			if(findtext(num2text(newrate), "."))
				return
			newrate = CLAMP(newrate, 0, D.generation_max)
			scom_announce("[realmname] 将[newrate ? "每 5 小时进口 [newrate] 个 [D.name]。" : "不再定期进口 [D.name]。"]")
			D.passive_generation = newrate
	if(href_list["givemoney"])
		var/X = locate(href_list["givemoney"])
		if(!X)
			return
		for(var/mob/living/A in SStreasury.bank_accounts)
			if(A == X)
				var/newtax = input(usr, "要给 [X] 多少？", src) as null|num
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				if(!newtax)
					return
				if(newtax < 1)
					return
				SStreasury.give_money_account(newtax, A, "NERVE MASTER")
				break
	if(href_list["fineaccount"])
		var/X = locate(href_list["fineaccount"])
		if(!X)
			return
		if(!has_fiscal_authority(usr))
			say("只有总管、书记官或统治者才能征收罚款。")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		for(var/mob/living/A in SStreasury.bank_accounts)
			if(A == X)
				var/max_fine = SStreasury.get_max_fine_for(A)
				if(max_fine <= 0)
					say("[A]目前无法被王权处以罚款。")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				var/newtax = input(usr, "要罚 [A] 多少钱？（上限 [max_fine]m）", src, max_fine) as null|num
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(findtext(num2text(newtax), "."))
					return
				if(!newtax)
					return
				if(newtax < 1)
					return
				if(newtax > max_fine)
					newtax = max_fine
					say("账册最多只能接受来自 [A] 的 [max_fine]m。金额已调整。")
				SStreasury.give_money_account(-newtax, A, "NERVE MASTER")
				break
	if(href_list["printresidency"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(world.time < residency_print_cooldown)
			say("机器仍在暖它的羽毛笔。")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		var/mob/living/carbon/human/H = usr
		var/obj/item/citizenry_letter/letter = new(get_turf(src))
		letter.issuer_name = H.real_name
		letter.issuer_year = CALENDAR_EPOCH_YEAR
		residency_print_cooldown = world.time + 1 MINUTES
		playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
		say("公民身份书已签发，由 [H.real_name] 签署。")
	if(href_list["payroll"])
		var/list/L = list(GLOB.noble_positions) + list(GLOB.garrison_positions) + list(GLOB.courtier_positions) + list(GLOB.church_positions) + list(GLOB.yeoman_positions) + list(GLOB.peasant_positions) + list(GLOB.youngfolk_positions) + list(GLOB.inquisition_positions)
		var/list/things = list()
		for(var/list/category in L)
			for(var/A in category)
				things += A
		var/job_to_pay = input(usr, "选择一个职业", src) as null|anything in things
		if(!job_to_pay)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/amount_to_pay = input(usr, "每位 [job_to_pay] 发多少？", src) as null|num
		if(!amount_to_pay)
			return
		if(amount_to_pay<1)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(findtext(num2text(amount_to_pay), "."))
			return
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.job == job_to_pay)
				if(SStreasury.give_money_account(amount_to_pay, H, "NERVE MASTER"))
					record_round_statistic(STATS_WAGES_PAID, amount_to_pay)
	if(href_list["setdailypay"])
		var/list/L = list(GLOB.noble_positions) + list(GLOB.garrison_positions) + list(GLOB.courtier_positions) + list(GLOB.church_positions) + list(GLOB.yeoman_positions) + list(GLOB.peasant_positions) + list(GLOB.youngfolk_positions) + list(GLOB.inquisition_positions)
		var/list/things = list()
		for(var/list/category in L)
			for(var/A in category)
				things += A
		var/job_to_pay = input(usr, "选择一个职业", src) as null|anything in things
		if(!job_to_pay)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		// Item 6 decrees: active charters (Indenture of War, Covenant of Noc & Pestra) floor
		// certain wages - the Nerve Master refuses to set covered jobs below the floor.
		var/wage_floor = SStreasury.get_wage_floor(job_to_pay)
		var/payprompt = wage_floor > 0 ? "设置 [job_to_pay] 的每日薪资（依特许状下限：[wage_floor]m；不允许设为 0）" : "设置 [job_to_pay] 的每日薪资（0 为移除）"
		var/amount_to_pay = input(usr, payprompt, src, daily_payments[job_to_pay] ? daily_payments[job_to_pay] : wage_floor) as null|num
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(findtext(num2text(amount_to_pay), "."))
			return
		if(isnull(amount_to_pay))
			return
		amount_to_pay = CLAMP(amount_to_pay, 0, 999)
		if(wage_floor > 0 && amount_to_pay < wage_floor)
			amount_to_pay = wage_floor
			say("依特许状，[job_to_pay] 的薪资不得低于 [wage_floor]m。薪资已设为下限。")
		if(amount_to_pay == 0)
			daily_payments -= job_to_pay
			say("[job_to_pay] 的每日薪资已移除。")
		else
			daily_payments[job_to_pay] = amount_to_pay
			say("[job_to_pay] 的每日薪资已设为 [amount_to_pay]m。")
	if(href_list["removedailypay"])
		var/job_to_remove = href_list["removedailypay"]
		var/removal_floor = SStreasury.get_wage_floor(job_to_remove)
		if(removal_floor > 0)
			daily_payments[job_to_remove] = removal_floor
			say("依特许状，[job_to_remove] 的薪资无法移除。薪资保持在 [removal_floor]m 的下限。")
		else
			daily_payments -= job_to_remove
			say("[job_to_remove] 的每日薪资已移除。")
	if(href_list["togglewages"])
		var/X = locate(href_list["togglewages"])
		if(!X)
			return
		for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
			if(A == X)
				// Check if user has permission (Steward, Clerk, Grand Duke, or Regent)
				var/is_authorized = FALSE
				if(usr.job == "Steward" || usr.job == "Clerk" || usr.job == "Grand Duke")
					is_authorized = TRUE
				if(SSticker.regentmob && usr == SSticker.regentmob)
					is_authorized = TRUE

				if(!is_authorized)
					say("只有 Steward、Clerk 或 Ruler 可以停发工资。")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return

				if(HAS_TRAIT(A, TRAIT_WAGES_SUSPENDED))
					REMOVE_TRAIT(A, TRAIT_WAGES_SUSPENDED, TRAIT_GENERIC)
					say("[A.real_name] 的工资已恢复。")
					to_chat(A, span_notice("总务处已恢复我的工资。"))
				else
					ADD_TRAIT(A, TRAIT_WAGES_SUSPENDED, TRAIT_GENERIC)
					say("[A.real_name] 的工资已被停发。")
					to_chat(A, span_danger("总务处已停发我的工资！"))
				break
	if(href_list["compact"])
		compact = !compact
	if(href_list["trade_tgui"])
		open_trade_tgui(usr)
		return

	return attack_hand(usr)

/obj/structure/roguemachine/steward/proc/quote_trade(mob/user, side, region_id, good_id, quantity)
	. = list(
		"ok" = FALSE,
		"reason" = "",
		"side" = side,
		"region_id" = region_id,
		"good_id" = good_id,
	)
	if(!user_can_act(user))
		.["reason"] = "out of reach"
		return
	var/is_alderman_acting = alderman_has_access(user)
	if(locked && !is_alderman_acting)
		.["reason"] = "machine locked"
		return
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!region || !tg)
		.["reason"] = "unknown region or good"
		return
	quantity = clamp(round(quantity), 1, TRADE_MAX_BULK_UNITS)
	var/daily_pace
	var/used_today
	if(side == "import")
		daily_pace = region.produces[good_id] || 0
		used_today = daily_pace - (region.produces_today[good_id] || 0)
	else
		daily_pace = region.demands[good_id] || 0
		used_today = daily_pace - (region.demands_today[good_id] || 0)
	if(daily_pace <= 0)
		.["reason"] = side == "import" ? "region does not produce this" : "region does not demand this"
		return
	var/starting_index = max(0, used_today)
	// Base portion = units priced inside daily capacity (overshoot = 0).
	// Escalation portion = units priced past capacity.
	var/base_unit_price = side == "import" \
		? SSeconomy.compute_import_unit_price(good_id, region, 1) \
		: SSeconomy.compute_export_unit_price(good_id, region, 1)
	var/base_subtotal = 0
	var/escalation_subtotal = 0
	for(var/i in 1 to quantity)
		var/idx = starting_index + i
		var/unit
		if(side == "import")
			unit = SSeconomy.compute_import_unit_price(good_id, region, idx)
		else
			unit = SSeconomy.compute_export_unit_price(good_id, region, idx)
		if(idx <= daily_pace)
			base_subtotal += unit
		else
			// Per overshoot unit: import surcharge (unit > base) or export shortfall (unit < base).
			// Server ships escalation_subtotal as a positive magnitude; the client adds + or −
			// based on side. total uses the signed delta directly.
			escalation_subtotal += abs(unit - base_unit_price)
			base_subtotal += base_unit_price
	var/total
	if(side == "import")
		total = base_subtotal + escalation_subtotal
	else
		total = base_subtotal - escalation_subtotal
	var/balance = SStreasury.discretionary_fund.balance
	var/can_afford = side == "import" ? (balance >= total) : TRUE
	var/warrant_remaining = -1
	var/warrant_ok = TRUE
	if(is_alderman_acting && SScity_assembly?.current_warrant)
		warrant_remaining = SScity_assembly.current_warrant.trade_remaining
		warrant_ok = SScity_assembly.can_consume_trade(total)
	var/datum/roguestock/stockpile_entry = SSeconomy.find_stockpile_by_trade_good(good_id)
	var/stockpile_amount = stockpile_entry?.stockpile_amount || 0
	. = list(
		"ok" = TRUE,
		"reason" = "",
		"side" = side,
		"region_id" = region_id,
		"good_id" = good_id,
		"region_name" = region.name,
		"good_name" = tg.name,
		"quantity" = quantity,
		"max_units" = TRADE_MAX_BULK_UNITS,
		"daily_pace" = daily_pace,
		"batch_capacity" = region.get_batch_capacity(good_id, side == "import"),
		"capacity_today" = region.get_day_capacity(good_id, side == "import"),
		"capacity_total" = region.get_day_capacity_total(good_id, side == "import"),
		"base_unit_price" = base_unit_price,
		"base_subtotal" = base_subtotal,
		"escalation_subtotal" = escalation_subtotal,
		"total" = total,
		"balance" = balance,
		"balance_after" = side == "import" ? balance - total : balance + total,
		"is_blockaded" = region.is_region_blockaded ? 1 : 0,
		"is_alderman_acting" = is_alderman_acting ? 1 : 0,
		"warrant_remaining" = warrant_remaining,
		"warrant_ok" = warrant_ok ? 1 : 0,
		"can_afford" = can_afford ? 1 : 0,
		"stockpile_amount" = stockpile_amount,
		"stockpile_after" = side == "import" ? stockpile_amount + quantity : max(0, stockpile_amount - quantity),
	)

/obj/structure/roguemachine/steward/proc/handle_trade_import(mob/user, region_id, good_id, quantity)
	if(!user_can_act(user))
		return
	var/is_alderman_acting = alderman_has_access(user)
	if(locked && !is_alderman_acting)
		return
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!region || !tg)
		return
	quantity = clamp(round(quantity), 1, TRADE_MAX_BULK_UNITS)
	if(quantity < 1)
		return
	var/daily_pace = region.produces[good_id] || 0
	if(daily_pace <= 0)
		to_chat(user, span_warning("[region.name] does not produce [tg.name]."))
		return
	var/produces_today = region.produces_today[good_id] || 0
	var/starting_index = max(0, daily_pace - produces_today)
	var/total = 0
	for(var/i in 1 to quantity)
		total += SSeconomy.compute_import_unit_price(good_id, region, starting_index + i)
	if(is_alderman_acting && !SScity_assembly.can_consume_trade(total))
		to_chat(user, span_warning("Your warrant cannot cover this trade. Remaining: [SScity_assembly.current_warrant.trade_remaining]m."))
		return
	var/spent = SSeconomy.manual_import(user, region_id, good_id, quantity)
	if(spent > 0)
		if(is_alderman_acting)
			SScity_assembly.consume_trade(spent, user, "import [quantity] [tg.name] from [region.name]")
		say("[SSmapping.map_adjustment.realm_name] imports [quantity] [tg.name] from [region.name] for [spent] mammon.")
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
	SStgui.update_uis(src)

/obj/structure/roguemachine/steward/proc/handle_trade_export(mob/user, region_id, good_id, quantity)
	if(!user_can_act(user))
		return
	var/is_alderman_acting = alderman_has_access(user)
	if(locked && !is_alderman_acting)
		return
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	if(!region || !tg)
		return
	quantity = clamp(round(quantity), 1, TRADE_MAX_BULK_UNITS)
	if(quantity < 1)
		return
	var/daily_pace = region.demands[good_id] || 0
	if(daily_pace <= 0)
		to_chat(user, span_warning("[region.name] does not demand [tg.name]."))
		return
	var/datum/roguestock/entry = SSeconomy.find_stockpile_by_trade_good(good_id)
	if(!entry || entry.stockpile_amount < quantity)
		to_chat(user, span_warning("Insufficient [tg.name] in stockpile: have [entry?.stockpile_amount || 0], need [quantity]."))
		return
	var/demands_today = region.demands_today[good_id] || 0
	var/starting_index = max(0, daily_pace - demands_today)
	var/total = 0
	for(var/i in 1 to quantity)
		total += SSeconomy.compute_export_unit_price(good_id, region, starting_index + i)
	if(is_alderman_acting && !SScity_assembly.can_consume_trade(total))
		to_chat(user, span_warning("Your warrant cannot cover this trade. Remaining: [SScity_assembly.current_warrant.trade_remaining]m."))
		return
	var/gained = SSeconomy.manual_export(user, region_id, good_id, quantity)
	if(gained > 0)
		if(is_alderman_acting)
			SScity_assembly.consume_trade(gained, user, "export [quantity] [tg.name] to [region.name]")
		say("[SSmapping.map_adjustment.realm_name] exports [quantity] [tg.name] to [region.name] for [gained] mammon.")
		playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	SStgui.update_uis(src)

/obj/structure/roguemachine/steward/proc/handle_trade_region_import(mob/user, region_id)
	if(!user_can_act(user))
		return
	if(locked && !alderman_has_access(user))
		return
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!region)
		return
	var/list/options = list()
	for(var/good_id in region.produces)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg || !tg.importable)
			continue
		options["[tg.name]"] = good_id
	if(!length(options))
		to_chat(user, span_warning("[region.name] has no importable goods."))
		return
	var/pick_name = input(user, "Import what from [region.name]?", src) as null|anything in options
	if(!pick_name)
		return
	var/good_id = options[pick_name]
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	var/quantity = input(user, "How many [tg.name] to import from [region.name]? (max [TRADE_MAX_BULK_UNITS])", src, 1) as null|num
	if(!quantity || quantity < 1)
		return
	handle_trade_import(user, region_id, good_id, quantity)

/obj/structure/roguemachine/steward/proc/handle_trade_region_export(mob/user, region_id)
	if(!user_can_act(user))
		return
	if(locked && !alderman_has_access(user))
		return
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!region)
		return
	var/list/options = list()
	for(var/good_id in region.demands)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(!tg)
			continue
		options["[tg.name]"] = good_id
	if(!length(options))
		to_chat(user, span_warning("[region.name] has no demanded goods."))
		return
	var/pick_name = input(user, "Export what to [region.name]?", src) as null|anything in options
	if(!pick_name)
		return
	var/good_id = options[pick_name]
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	var/quantity = input(user, "How many [tg.name] to export to [region.name]? (max [TRADE_MAX_BULK_UNITS])", src, 1) as null|num
	if(!quantity || quantity < 1)
		return
	handle_trade_export(user, region_id, good_id, quantity)

/obj/structure/roguemachine/steward/proc/do_import(datum/crown_import/D, number)
	if(!D)
		return
	D = new D
	if(number > D.import_amt)
		return

	if(!number)
		number = 1
	var/area/A = GLOB.areas_by_type[/area/rogue/indoors/town/warehouse]
	if(!A)
		return
	var/obj/item/I = new D.item_type()
	var/list/turfs = list()
	for(var/turf/T in A)
		turfs += T
	var/turf/T = pick(turfs)
	I.forceMove(T)
	playsound(T, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	number += 1

	addtimer(CALLBACK(src, PROC_REF(do_import), D.type, number), 3 SECONDS)

/obj/structure/roguemachine/steward/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(locked && alderman_has_access(user))
		open_trade_tgui(user)
		return
	if(locked)
		to_chat(user, span_warning("它被锁住了。果然。"))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	switch(current_tab)
		if(TAB_MAIN)
			contents += "<center>总务中枢<BR>"
			contents += "--------------<BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_BANK]'>\[银行\]</a><BR>"
			contents += "<a href='?src=\ref[src];trade_tgui=1'>\[贸易与库存\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_IMPORT]'>\[进口\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_PAYDAY]'>\[每日薪资\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_FISCAL]'>\[财政账册\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_DEBT]'>\[债务与欠款\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_SALTMINE]'>\[盐矿报告\]</a><BR>"
			contents += "<a href='?src=\ref[src];printresidency=1'>\[打印公民身份书\]</a><BR>"
			contents += "<a href='?src=\ref[src];setpurchasefloor=1'>\[采购下限：[SStreasury.stockpile_purchase_floor]m\]</a><BR>"
			contents += "</center>"
		if(TAB_BANK)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[返回\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[紧凑：[compact? "启用" : "关闭"]\]</a><BR>"
			contents += "<center>银行<BR>"
			contents += "--------------<BR>"
			contents += "国库：[SStreasury.discretionary_fund.balance]m</center><BR>"
			contents += "<a href='?src=\ref[src];payroll=1'>\[按职业发放\]</a><BR><BR>"
			// Collect all accounts, sort debtors/arrears first, then rest.
			var/list/priority_accounts = list() // debtors or in arrears
			var/list/normal_accounts = list()
			for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
				var/owed = SStreasury.poll_tax_owed[A] || 0
				var/is_debtor = HAS_TRAIT(A, TRAIT_DEBTOR)
				if(is_debtor || owed > 0)
					priority_accounts += A
				else
					normal_accounts += A
			var/show_fiscal_actions = has_fiscal_authority(user)
			for(var/mob/living/carbon/human/A in priority_accounts + normal_accounts)
				var/balance = SStreasury.get_balance(A)
				var/max_fine = SStreasury.get_max_fine_for(A)
				var/datum/fund/A_account = SStreasury.bank_accounts[A]
				var/A_suspended = A_account?.wages_suspended ? TRUE : FALSE
				var/wage_status_short = A_suspended ? "恢复薪资" : "停发薪资"
				var/wage_status_long = A_suspended ? "恢复薪资" : "停发薪资"
				var/fine_label = max_fine > 0 ? "罚款（上限 [max_fine]m）" : "罚款（豁免）"
				var/fine_long_label = max_fine > 0 ? "账户罚款（上限 [max_fine]m）" : "账户罚款（豁免）"
				var/poll_owed = SStreasury.poll_tax_owed[A] || 0
				var/overdue_days = SStreasury.poll_tax_debt_days[A] || 0
				var/a_is_debtor = HAS_TRAIT(A, TRAIT_DEBTOR)
				var/debt_tag = ""
				if(a_is_debtor)
					var/owed_str = poll_owed > 0 ? "，欠 [poll_owed]m" : ""
					debt_tag = " <font color='#d9534f'>\[债务人[owed_str]\]</font>"
				else if(poll_owed > 0)
					debt_tag = " <font color='#e07b39'>\[欠款：[poll_owed]m，逾期 [overdue_days] 天\]</font>"
				if(compact)
					if(ishuman(A))
						var/mob/living/carbon/human/tmp = A
						contents += "[tmp.real_name] ([job_filter(tmp.advjob, tmp.job, compact)]) - [balance]m[debt_tag]"
					else
						contents += "[A.real_name] - [balance]m[debt_tag]"
					contents += " / <a href='?src=\ref[src];givemoney=\ref[A]'>\[发放\]</a>"
					if(show_fiscal_actions)
						contents += " <a href='?src=\ref[src];fineaccount=\ref[A]'>\[[fine_label]\]</a> <a href='?src=\ref[src];togglewages=\ref[A]'>\[[wage_status_short]\]</a>"
					contents += "<BR><BR>"
				else
					if(ishuman(A))
						var/mob/living/carbon/human/tmp = A
						contents += "[tmp.real_name] ([job_filter(tmp.advjob, tmp.job, compact)]) - [balance]m[debt_tag]<BR>"
					else
						contents += "[A.real_name] - [balance]m[debt_tag]<BR>"
					contents += "<a href='?src=\ref[src];givemoney=\ref[A]'>\[发放资金\]</a>"
					if(show_fiscal_actions)
						contents += " <a href='?src=\ref[src];fineaccount=\ref[A]'>\[[fine_long_label]\]</a> <a href='?src=\ref[src];togglewages=\ref[A]'>\[[wage_status_long]\]</a>"
					contents += "<BR><BR>"
		if(TAB_IMPORT)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[返回\]</a>"
			contents += " <a href='?src=\ref[src];compact=1'>\[紧凑：[compact? "启用" : "关闭"]\]</a><BR>"
			contents += "<center>进口<BR>"
			contents += "--------------<BR>"
			if(compact)
				contents += "国库：[SStreasury.discretionary_fund.balance]m</center><BR>"
				for(var/datum/crown_import/A in GLOB.crown_imports)
					var/blockade_tag = A.is_blockaded() ? " <font color='#c44'>（封锁中）</font>" : ""
					contents += "<b>[A.name][blockade_tag]:</b>"
					contents += " <a href='?src=\ref[src];import=\ref[A]'>\[进口 [A.import_amt] ([A.get_import_price()])\]</a><BR>"
			else
				contents += "国库：[SStreasury.discretionary_fund.balance]m</center><BR>"
				for(var/datum/crown_import/A in GLOB.crown_imports)
					var/blockade_tag_full = A.is_blockaded() ? " <font color='#c44'>（封锁中 - 双倍费用）</font>" : ""
					contents += "<b>[A.name][blockade_tag_full]</b> - <i>[A.desc]</i> "
					contents += "<a href='?src=\ref[src];import=\ref[A]'>\[进口 [A.import_amt] ([A.get_import_price()])\]</a><BR>"
		if(TAB_DEBT)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[返回\]</a><BR>"
			contents += "<center>债务与欠款<BR>"
			contents += "--------------<BR>"
			contents += "国库：[SStreasury.discretionary_fund.balance]m</center><BR>"
			var/crown_loans = 0
			var/crown_loan_content = ""
			for(var/datum/loan/L in SStreasury.loans)
				if(L.source_fund != SStreasury.discretionary_fund)
					continue
				crown_loans++
				var/loan_color = L.defaulted ? "#d9534f" : "#e07b39"
				crown_loan_content += "<font color='[loan_color]'>[L.format()]</font><BR>"
			if(crown_loans)
				contents += "<b>王权在贷贷款（[crown_loans]）：</b><BR>"
				contents += crown_loan_content
				contents += "<BR>"
			else
				contents += "<i>没有在贷贷款。</i><BR><BR>"
			var/list/debt_rows = list()
			for(var/mob/living/carbon/human/A in SStreasury.bank_accounts)
				var/poll_owed = SStreasury.poll_tax_owed[A] || 0
				if(poll_owed > 0 || HAS_TRAIT(A, TRAIT_DEBTOR))
					debt_rows += A
			if(length(debt_rows))
				contents += "<b>人头税债务人／欠款者（[length(debt_rows)]）：</b><BR>"
				for(var/mob/living/carbon/human/A in debt_rows)
					var/poll_owed = SStreasury.poll_tax_owed[A] || 0
					var/overdue_days = SStreasury.poll_tax_debt_days[A] || 0
					var/balance = SStreasury.get_balance(A)
					if(HAS_TRAIT(A, TRAIT_DEBTOR_CROWN))
						var/owed_str = poll_owed > 0 ? "，欠 [poll_owed]m" : ""
						contents += "<font color='#d9534f'><b>[A.real_name]</b> \[债务人[owed_str]\]</font> - 余额：[balance]m"
					else
						contents += "<font color='#e07b39'><b>[A.real_name]</b> \[欠款：[poll_owed]m，逾期 [overdue_days] 天\]</font> - 余额：[balance]m"
					contents += "<BR>"
				contents += "<BR>"
			else
				contents += "<i>没有人头税欠款。</i><BR><BR>"
			contents += "<a href='?src=\ref[src];clearloandebtor=1'>\[清除违约者标记\]</a><BR>"
			contents += "<font color='gray'><i>（完全豁免未偿贷款，并撤销违约者标记。）</i></font><BR>"
			contents += "<a href='?src=\ref[src];clearpolltax=1'>\[清除人头税欠款\]</a><BR>"
			contents += "<font color='gray'><i>（抹除臣民拖欠的人头税。）</i></font><BR>"
		if(TAB_FISCAL)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[返回\]</a><BR>"
			var/list/snap = SStreasury.compute_fiscal_snapshot()
			var/list/charters = SStreasury.compute_charter_states()
			contents += "<center><b>财政账册 &mdash; 第 [GLOB.dayspassed] 天</b></center>"
			contents += "<hr>"

			// Balances (two-column)
			contents += "<b><font color='#e6b327'>余额</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>王权的钱袋</td><td align='right'><font color='#e6b327'>[snap["discretionary"]]m</font></td>"
			contents += "<td>市民认捐</td><td align='right'><font color='#e6b327'>[snap["burgher_pledge"]]m</font></td></tr>"
			contents += "<tr><td>银行钱币总额</td><td align='right'>[snap["total_bank"]]m</td>"
			contents += "<td>持有账户</td><td align='right'>[snap["held_accounts"]]</td></tr>"
			contents += "<tr><td>平均余额</td><td align='right'>[snap["avg_balance"]]m</td>"
			contents += "<td>低于 50m</td><td align='right'><font color='#e07b39'>[snap["under_50m"]]</font></td></tr>"
			contents += "</table><br>"

			// Revenue (two-column, green) - only mammon that lands in Crown's Purse
			contents += "<b><font color='#5cb85c'>本周王权收入</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>乡村税</td><td align='right'><font color='#5cb85c'>[SStreasury.total_rural_tax]m</font></td>"
			contents += "<td>罚款</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_FINES_INCOME]]m</font></td></tr>"
			contents += "<tr><td>人头税</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_POLL_TAX_COLLECTED]]m</font></td>"
			contents += "<td>存款税</td><td align='right'><font color='#5cb85c'>[SStreasury.total_deposit_tax]m</font></td></tr>"
			contents += "<tr><td>契约税</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_REVENUE_CONTRACT_LEVY]]m</font></td>"
			contents += "<td>食首税</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_REVENUE_HEADEATER_LEVY]]m</font></td></tr>"
			contents += "<tr><td>进口税</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_REVENUE_IMPORT_TARIFF]]m</font></td>"
			contents += "<td>出口税</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_REVENUE_EXPORT_DUTY]]m</font></td></tr>"
			contents += "<tr><td>追回赃款</td><td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_REVENUE_RECOVERED_SPOILS] || 0]m</font></td>"
			contents += "<td></td><td></td></tr>"
			contents += "</table><br>"

			// Forgone Revenue (two-column, muted - what the Crown *could* have collected)
			var/exempt_contract = GLOB.azure_round_stats[STATS_EXEMPTED_CONTRACT_LEVY]
			var/exempt_headeater = GLOB.azure_round_stats[STATS_EXEMPTED_HEADEATER_LEVY]
			var/exempt_import = GLOB.azure_round_stats[STATS_EXEMPTED_IMPORT_TARIFF]
			var/exempt_export = GLOB.azure_round_stats[STATS_EXEMPTED_EXPORT_DUTY]
			var/exempt_fine = GLOB.azure_round_stats[STATS_EXEMPTED_FINE]
			var/exempt_poll = GLOB.azure_round_stats[STATS_EXEMPTED_POLL_TAX]
			var/exempt_total = exempt_contract + exempt_headeater + exempt_import + exempt_export + exempt_fine + exempt_poll
			contents += "<b><font color='#8f7a5a'>豁免收入（已免税）</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>契约税</td><td align='right'><font color='#8f7a5a'>[exempt_contract]m</font></td>"
			contents += "<td>食首税</td><td align='right'><font color='#8f7a5a'>[exempt_headeater]m</font></td></tr>"
			contents += "<tr><td>进口税</td><td align='right'><font color='#8f7a5a'>[exempt_import]m</font></td>"
			contents += "<td>出口税</td><td align='right'><font color='#8f7a5a'>[exempt_export]m</font></td></tr>"
			contents += "<tr><td>免除罚款</td><td align='right'><font color='#8f7a5a'>[exempt_fine]m</font></td>"
			contents += "<td>人头税</td><td align='right'><font color='#8f7a5a'>[exempt_poll]m</font></td></tr>"
			contents += "<tr><td><b>豁免总额</b></td><td align='right'><b><font color='#8f7a5a'>[exempt_total]m</font></b></td>"
			contents += "<td></td><td></td></tr>"
			contents += "</table>"
			contents += "<font size='1'><i>特许状豁免、免税印花与利率上限差额。即若未适用任何豁免，王权本应征收的玛门。</i></font><br><br>"

			// Trade (two-column, mixed)
			contents += "<b><font color='#c0b283'>贸易</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>库存出口</td><td align='right'><font color='#5cb85c'>[SStreasury.total_export]m</font></td>"
			contents += "<td>库存进口</td><td align='right'><font color='#d9534f'>-[SStreasury.total_import]m</font></td></tr>"
			var/trade_bal = SStreasury.total_export - SStreasury.total_import
			var/trade_col = trade_bal >= 0 ? "#5cb85c" : "#d9534f"
			contents += "<tr><td>贸易差额</td><td align='right'><font color='[trade_col]'>[trade_bal]m</font></td>"
			contents += "<td>经济产出</td><td align='right'>[SStreasury.economic_output]m</td></tr>"
			contents += "</table><br>"

			// Expenses (two-column, red)
			contents += "<b><font color='#d9534f'>本周支出</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>已付薪资</td><td align='right'><font color='#d9534f'>-[GLOB.azure_round_stats[STATS_WAGES_PAID]]m</font></td>"
			contents += "<td>国库转账</td><td align='right'><font color='#d9534f'>-[GLOB.azure_round_stats[STATS_DIRECT_TREASURY_TRANSFERS]]m</font></td></tr>"
			contents += "<tr><td>库存进口 <font size='1'><i>（见贸易）</i></font></td><td align='right'><font color='#d9534f'>-[SStreasury.total_import]m</font></td>"
			contents += "<td></td><td></td></tr>"
			contents += "</table><br>"

			// Tax Rates (two columns: rate name | percentage)
			contents += "<b>税率</b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			var/list/rate_entries = list()
			for(var/cat in SStreasury.tax_rates)
				if(cat == TAX_CATEGORY_FINE)
					continue
				rate_entries += "<td>[SStreasury.get_tax_category_pretty_name(cat)]</td><td align='right'>[round(SStreasury.tax_rates[cat] * 100)]%</td>"
			for(var/i = 1, i <= length(rate_entries), i += 2)
				contents += "<tr>"
				contents += rate_entries[i]
				if(i + 1 <= length(rate_entries))
					contents += rate_entries[i + 1]
				else
					contents += "<td></td><td></td>"
				contents += "</tr>"
			contents += "</table><br>"

			// Poll Tax Rates (two columns: category | m/day)
			contents += "<b>人头税率（每日）</b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			var/datum/decree/golden = SStreasury.get_decree(DECREE_GOLDEN_BULL)
			var/golden_active = golden?.active
			var/datum/decree/covenant = SStreasury.get_decree(DECREE_NOC_PESTRA_COVENANT)
			var/covenant_active = covenant?.active
			var/datum/decree/merc_charter = SStreasury.get_decree(DECREE_GUILD_CHARTER_OF_ARMS)
			var/merc_charter_active = merc_charter?.active
			var/list/poll_entries = list()
			for(var/pcat in SStreasury.poll_tax_rates)
				var/rate = SStreasury.poll_tax_rates[pcat]
				var/pretty = SStreasury.get_poll_tax_category_pretty_name(pcat)
				var/rate_display = "[rate]m"
				if(pcat == POLL_TAX_CAT_BURGHER && golden_active && rate > GOLDEN_BULL_POLL_CAP)
					rate_display = "<font color='#e07b39'>[GOLDEN_BULL_POLL_CAP]m</font>（原始 [rate]m，已封顶）"
				else if(pcat == POLL_TAX_CAT_MERCENARY && merc_charter_active && rate > GUILD_CHARTER_OF_ARMS_POLL_CAP)
					rate_display = "<font color='#e07b39'>[GUILD_CHARTER_OF_ARMS_POLL_CAP]m</font>（原始 [rate]m，已封顶）"
				poll_entries += "<td>[pretty]</td><td align='right'>[rate_display]</td>"
			for(var/i = 1, i <= length(poll_entries), i += 2)
				contents += "<tr>"
				contents += poll_entries[i]
				if(i + 1 <= length(poll_entries))
					contents += poll_entries[i + 1]
				else
					contents += "<td></td><td></td>"
				contents += "</tr>"
			contents += "</table>"
			if(covenant_active)
				contents += "<i><font color='#e07b39'>《诺克与佩斯特拉盟约》生效中：无论类别税率为何，大学与药剂行每日缴纳的人头税不超过 [NOC_PESTRA_POLL_CAP]m。</font></i><br>"
			contents += "<br>"

			// Charters (two-column)
			contents += "<b>特许状</b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			var/list/charter_rows = list()
			for(var/entry in charters)
				var/cooldown_left = entry["cooldown_remaining"]
				var/cd_text = cooldown_left > 0 ? " <i>（冷却：[round(cooldown_left / 600, 0.1)]m）</i>" : ""
				var/status_color = entry["active"] ? "#5cb85c" : "#d9534f"
				var/status_text = entry["active"] ? "生效" : "中止"
				charter_rows += "<td>[entry["name"]]</td><td align='right'><font color='[status_color]'>[status_text]</font>[cd_text]</td>"
			for(var/i = 1, i <= length(charter_rows), i += 2)
				contents += "<tr>"
				contents += charter_rows[i]
				if(i + 1 <= length(charter_rows))
					contents += charter_rows[i + 1]
				else
					contents += "<td></td><td></td>"
				contents += "</tr>"
			contents += "</table><br>"

			// Debt & Loans (two-column, orange for warnings)
			contents += "<b><font color='#e07b39'>债务与贷款</font></b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td>欠款账户</td><td align='right'><font color='#e07b39'>[snap["in_arrears"]]</font></td>"
			contents += "<td>预存账户</td><td align='right'>[snap["in_advance"]]</td></tr>"
			contents += "<tr><td>违约债务人</td><td align='right'><font color='#d9534f'>[snap["debtor_count"]]</font></td>"
			contents += "<td>未偿贷款</td><td align='right'>[snap["loans_outstanding"]]（[snap["loan_exposure"]]m）</td></tr>"
			contents += "</table><br>"

			// Contracts (three-column: Issued / Taken / Completed, by issuing authority)
			contents += "<b>本周契约</b>"
			contents += "<table width='100%' cellspacing='0' cellpadding='2'>"
			contents += "<tr><td></td><td align='right'><b>发布</b></td><td align='right'><b>承接</b></td><td align='right'><b>完成</b></td></tr>"
			contents += "<tr><td>行会</td>"
			contents += "<td align='right'>[GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED_POOL]]</td>"
			contents += "<td align='right'>[GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN_POOL]]</td>"
			contents += "<td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED_POOL]]</font></td></tr>"
			contents += "<tr><td>酒馆</td>"
			contents += "<td align='right'>[GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED_RUMOR]]</td>"
			contents += "<td align='right'>[GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN_RUMOR]]</td>"
			contents += "<td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED_RUMOR]]</font></td></tr>"
			contents += "<tr><td>王权</td>"
			contents += "<td align='right'>[GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED_DEFENSE]]</td>"
			contents += "<td align='right'>[GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN_DEFENSE]]</td>"
			contents += "<td align='right'><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED_DEFENSE]]</font></td></tr>"
			contents += "<tr><td><b>总计</b></td>"
			contents += "<td align='right'><b>[GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED]]</b></td>"
			contents += "<td align='right'><b>[GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN]]</b></td>"
			contents += "<td align='right'><b><font color='#5cb85c'>[GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED]]</font></b></td></tr>"
			contents += "</table>"
		if(TAB_PAYDAY)
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[返回\]</a><BR>"
			contents += "<center>每日薪资<BR>"
			contents += "--------------<BR>"
			contents += "国库：[SStreasury.discretionary_fund.balance]m</center><BR>"
			contents += "<a href='?src=\ref[src];setdailypay=1'>\[添加/修改职业薪资\]</a><BR><BR>"
			if(daily_payments.len)
				contents += "<center>已配置薪资：</center><BR>"
				for(var/job_name in daily_payments)
					var/amt = daily_payments[job_name]
					var/count = 0
					for(var/mob/living/carbon/human/H in GLOB.human_list)
						if(H.job == job_name && !HAS_TRAIT(H, TRAIT_WAGES_SUSPENDED))
							count++
					contents += "<b>[job_name]:</b> [amt]m/日"
					if(count > 0)
						contents += "（[count] 在职，每日总计 [amt * count]m）"
					contents += " <a href='?src=\ref[src];removedailypay=[job_name]'>\[移除\]</a><BR>"
			else
				contents += "<center>未配置每日薪资。</center><BR>"
		if(TAB_SALTMINE)
			var/obj/structure/roguemachine/stockpile_saltcamp/stockpile = null
			stockpile = locate(/obj/structure/roguemachine/stockpile_saltcamp) in GLOB.saltminestockpilemachines // we're assuming there is only ever one of these machines in the world
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MAIN]'>\[Return\]</a><BR>"
			if(!isnull(stockpile))
				var/gambled_salt = round(stockpile.salt_spent_on_gambling, 1)
				var/total_accounts = length(stockpile.salt_accounts)
				contents += "<center>特罗伊特盐矿报告:<BR>"
				contents += "总赌博盐量: [gambled_salt] 堆盐</center><BR>"
				if(total_accounts > 0)
					contents += "--------------<BR>"
					contents += "<table><tr><th>囚犯姓名</th><th>已采盐量</th><th>利率</th></tr>"
					for(var/i = 1; i <= total_accounts; i++)
						var/name = stockpile.salt_accounts[i]
						var/salt = stockpile.salt_accounts[name]
						var/salt_max = stockpile.salt_accounts_max[name]
						var/interest = stockpile.salt_accounts_interest_max[name] * 100
						if(salt == 0 && stockpile.salt_ticket_win[name] > 0) // don't show ticket winners who have left the mines
							continue
						contents += "<tr><td>[name]</td><td>[salt] 盐 / [salt_max] 上限</td><td>[interest]%</td></tr>"
					contents += "</table>"

	if(!canread)
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 700, 800)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/steward/proc/job_filter(advj, j, compact = FALSE)
	if(advj in excluded_jobs)
		return "Adventurer"
	if(j in excluded_jobs)
		return "Adventurer"
	if(compact && j)
		return j
	else if(!compact && advj && j)
		return "[j] ([advj])"
	else if(j)
		return j
	else if(advj)
		return advj

#undef TAB_MAIN
#undef TAB_BANK
#undef TAB_IMPORT
#undef TAB_DEBT
#undef TAB_PAYDAY
#undef TAB_SALTMINE
#undef TAB_FISCAL
// Item 6 (decrees): bump configured wages up to any active charter's mandated floor, and
// ensure floored jobs missing from the payments list get an entry at the floor.
/obj/structure/roguemachine/steward/proc/enforce_wage_floors()
	for(var/job in daily_payments)
		var/floor = SStreasury.get_wage_floor(job)
		if(floor > 0 && (daily_payments[job] || 0) < floor)
			daily_payments[job] = floor
	for(var/job in SStreasury.enumerate_wage_floored_jobs())
		if(isnull(daily_payments[job]))
			daily_payments[job] = SStreasury.get_wage_floor(job)
