/// Maps a bonus-pay level (0=NONE, 1=LIGHT, 2=FULL) to its multiplier. Levels outside
/// the range collapse to 1.0x so a stray input can't accidentally inflate payouts.
/proc/get_commission_bonus_pay_mult(level)
	switch(level)
		if(COMMISSION_BONUS_PAY_LIGHT)
			return COMMISSION_BONUS_PAY_LIGHT_MULT
		if(COMMISSION_BONUS_PAY_FULL)
			return COMMISSION_BONUS_PAY_MULT
	return 1.0

/// Human-readable label for log lines and on-scroll annotations.
/proc/get_commission_bonus_pay_label(level)
	switch(level)
		if(COMMISSION_BONUS_PAY_LIGHT)
			return "轻量额外报酬"
		if(COMMISSION_BONUS_PAY_FULL)
			return "额外报酬"
	return ""

/// Snapshot of each blockade that currently has a writ in circulation, with recall eligibility.
/// Used by ContractLedgerSteward.tsx to show a "Recall Writ" button when the Steward picks
/// a blockaded region that still has an armed, pre-wave writ within the recall window.
/obj/structure/roguemachine/contractledger/proc/build_blockade_recall_list()
	var/list/out = list()
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		var/datum/quest/kill/blockade_defense/Q = B.active_quest_ref?.resolve()
		if(!istype(Q) || QDELETED(Q))
			continue
		var/datum/economic_region/ER = B.get_region()
		out += list(build_writ_recall_entry(Q, ER ? ER.name : B.region_id))
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		var/datum/quest/kill/blockade_defense/Q = TR.active_hoard_recovery_ref?.resolve()
		if(!istype(Q) || QDELETED(Q) || Q.failed || Q.complete)
			continue
		out += list(build_writ_recall_entry(Q, TR.region_name))
	return out

/obj/structure/roguemachine/contractledger/proc/build_writ_recall_entry(datum/quest/kill/blockade_defense/Q, region_label)
	var/reason = Q.recall_blocker()
	var/recall_eligible = isnull(reason) ? TRUE : FALSE
	var/seconds_until_recallable = 0
	if(Q.current_wave == 0 && !Q.failed && !Q.complete && Q.issued_at)
		var/elapsed = world.time - Q.issued_at
		var/until_open = BLOCKADE_RECALL_WINDOW_DS - elapsed
		if(until_open > 0)
			seconds_until_recallable = round(until_open / 10)
	return list(
		"region" = region_label,
		"recall_eligible" = recall_eligible,
		"recall_blocker" = reason,
		"seconds_until_recallable" = seconds_until_recallable,
		"refund" = Q.funding_cost,
		"refund_fund" = Q.funding_fund ? Q.funding_fund.name : null,
	)

/// Per-region TP budget multiplier, exposed so the Steward's UI can surface "this region
/// yields bigger payouts for the same draft cost" - kill/bounty rewards scale with
/// spawned TP, so a 1.5x region returns roughly 50% more reward than a 1.0x one on an
/// identical commission cost.
/obj/structure/roguemachine/contractledger/proc/build_region_tp_multipliers()
	var/list/out = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		out[TR.region_name] = TR.tp_budget_multiplier
	return out

/obj/structure/roguemachine/contractledger/proc/build_region_delivery_multipliers()
	var/list/out = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		out[TR.region_name] = TR.delivery_reward_multiplier
	return out

/obj/structure/roguemachine/contractledger/proc/build_defense_regions_by_type()
	var/list/out = list()
	for(var/qtype in GLOB.defense_quest_tier_costs)
		var/list/regions = list()
		if(qtype == QUEST_BLOCKADE_DEFENSE)
			// All active blockades are listed regardless of scroll state. Regions with a
			// writ already out are still shown so the Steward can pick them to recall.
			// The UI decides whether the primary button says "Print Writ" or "Recall Writ"
			// based on the blockade_recall_list entry for that region.
			for(var/datum/blockade/B as anything in GLOB.active_blockades)
				var/datum/economic_region/ER = B.get_region()
				if(ER)
					regions += ER.name
		else if(qtype == QUEST_HOARD_RECOVERY)
			for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
				if(TR.banditry_hoard < HOARD_RECOVERY_HOARD_MINIMUM)
					continue
				// A true blockade takes precedence
				if(TR.has_active_blockade())
					continue
				regions += TR.region_name
		else
			for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
				if(!TR.allows_quest_type(qtype))
					continue
				regions += TR.region_name
		out[qtype] = regions
	return out

/obj/structure/roguemachine/contractledger/proc/build_blockade_region_labels()
	var/list/out = list()
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		var/datum/economic_region/ER = B.get_region()
		if(!ER)
			continue
		var/datum/threat_region/TR = B.get_threat_region()
		out[ER.name] = TR ? "[ER.name] ([TR.region_name])" : ER.name
	return out

/obj/structure/roguemachine/contractledger/proc/commission_defense_from_tgui(mob/user, list/params)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/steward = user
	if(!can_commission(steward))
		return
	if(!steward.Adjacent(src))
		return
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(steward, span_warning("台账尚未开启。"))
		return

	var/chosen_type = params["type"]
	if(!(chosen_type in GLOB.defense_quest_tier_costs))
		to_chat(steward, span_warning("王室不会委托这种任务类型。"))
		return

	// Alderman status is computed up front so funding and levy-exempt gates can reference it.
	// Stewards who happen to also be the Alderman act as Steward for the purposes of these gates -
	// the Steward's own authority is strictly broader.
	var/is_alderman_acting = SScity_assembly?.is_alderman(steward)
	if(is_alderman_acting && steward.job == "Steward")
		is_alderman_acting = FALSE

	// funding source: "pledge" (default), "crown" (discretionary fund), "directive" (free, capped).
	// Aldermen are restricted to "pledge" - they cannot draw Crown's Purse (the Assembly's warrant
	// is denominated in Pledge authority, and letting them also drain the Crown's coin double-dips
	// the realm's budget against the Commons' allowance) and cannot issue Requests (directive is
	// the Steward's administrative prerogative, a Crown officer commanding the staff it pays).
	var/funding = params["funding"] || "pledge"
	if(is_alderman_acting && funding != "pledge")
		to_chat(steward, span_warning("议员的委托只能由议事会的认捐授权支付。王室金库与总管请令皆非你所能支配。"))
		return

	var/cost = GLOB.defense_quest_tier_costs[chosen_type]
	// Bonus Pay: tri-state sweetener (NONE/LIGHT/FULL). Multiplies cost and reward by the
	// level's multiplier. Not permitted on Requests (no reward to sweeten, no coin to burn).
	var/bonus_pay_level = CLAMP(text2num("[params["bonus_pay_level"]]") || COMMISSION_BONUS_PAY_NONE, COMMISSION_BONUS_PAY_NONE, COMMISSION_BONUS_PAY_FULL)
	if(funding == "directive")
		bonus_pay_level = COMMISSION_BONUS_PAY_NONE
	var/bonus_mult = get_commission_bonus_pay_mult(bonus_pay_level)
	if(bonus_mult != 1.0)
		cost = round(cost * bonus_mult)
	var/datum/fund/source_fund
	var/is_directive = FALSE
	switch(funding)
		if("pledge")
			if(!SStreasury.burgher_pledge_fund)
				to_chat(steward, span_warning("市民认捐尚未设立。请改用王室金库或请令。"))
				return
			source_fund = SStreasury.burgher_pledge_fund
		if("crown")
			if(!SStreasury.discretionary_fund)
				to_chat(steward, span_warning("王室金库尚未设立。"))
				return
			source_fund = SStreasury.discretionary_fund
		if("directive")
			refresh_directive_quota()
			if(directives_issued_today >= COMMISSION_REQUESTS_PER_DAY)
				to_chat(steward, span_warning("你今日的请令额度已用尽(每日 [COMMISSION_REQUESTS_PER_DAY] 次)。"))
				return
			is_directive = TRUE
			cost = 0
		else
			to_chat(steward, span_warning("未知的资金来源。"))
			return

	if(source_fund && source_fund.balance < cost)
		to_chat(steward, span_warning("[source_fund.name]余额不足。需要 [cost]m，现有 [source_fund.balance]m。"))
		return

	if(is_alderman_acting)
		if(!SScity_assembly.can_consume_defense(cost))
			to_chat(steward, span_warning("你的防御授权不足以覆盖这次委托。剩余：[SScity_assembly.current_warrant.defense_remaining]p。"))
			return

	if(chosen_type == QUEST_BLOCKADE_DEFENSE)
		commission_blockade_defense(steward, params, cost, source_fund, is_directive, bonus_pay_level, is_alderman_acting)
		return

	if(chosen_type == QUEST_HOARD_RECOVERY)
		commission_hoard_recovery(steward, params, cost, source_fund, is_directive, bonus_pay_level, is_alderman_acting)
		return

	var/region_name = params["region"]
	var/datum/threat_region/chosen_region
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		if(TR.region_name == region_name && TR.allows_quest_type(chosen_type))
			chosen_region = TR
			break
	if(!chosen_region)
		to_chat(steward, span_warning("该地区并不会出现这类任务。"))
		return

	// Recovery is not commissionable by the Steward - it only enters the pool via
	// SSquestpool.regen_kill_targets or via the Innkeeper's rumor flow, so we no longer
	// need a destination picker here.
	var/area/chosen_destination

	if(source_fund && cost > 0 && !SStreasury.burn(source_fund, cost, "防御委托([chosen_type] 位于 [chosen_region.region_name])"))
		to_chat(steward, span_warning("[source_fund.name]拒付这笔支取。"))
		return
	if(source_fund == SStreasury.burgher_pledge_fund && cost > 0)
		record_round_statistic(STATS_PLEDGE_CONSUMED, cost)
	if(is_alderman_acting && cost > 0)
		SScity_assembly.consume_defense(cost, steward, "[chosen_type] defense commission in [chosen_region.region_name]")
	var/in_hands = params["in_hands"] ? TRUE : FALSE
	// Directives are always drafted to the Steward's hand - they don't get posted publicly
	// because they carry no reward and nobody signs free work off a board.
	if(is_directive)
		in_hands = TRUE
	// Levy exemption is the Steward's sole prerogative - a Crown officer can waive the Crown's
	// tax revenue. The Alderman speaks for the Commons, not the Crown, and has no such authority.
	var/levy_exempt = (!is_alderman_acting && params["levy_exempt"]) ? TRUE : FALSE
	var/datum/quest/dispatched = SSquestpool.issue_defense_quest(chosen_type, chosen_region, chosen_destination, in_hands, steward)
	if(!dispatched)
		if(source_fund && cost > 0)
			SStreasury.mint(source_fund, cost, "防御委托退款(地标失败)")
			if(source_fund == SStreasury.burgher_pledge_fund)
				record_round_statistic(STATS_PLEDGE_CONSUMED, -cost)
		if(is_alderman_acting && cost > 0)
			SScity_assembly.restore_defense(cost, steward, "[chosen_type] defense commission refund in [chosen_region.region_name]")
		SSquestpool.log_event("defense_refund", "landmark failure [chosen_type] in [chosen_region.region_name] refunded [cost]m")
		to_chat(steward, span_warning("没有地标能够承载该委托。款项已退还。"))
		return
	if(levy_exempt)
		dispatched.levy_exempt = TRUE
	if(bonus_mult != 1.0)
		dispatched.reward_amount = round(dispatched.reward_amount * bonus_mult)
	if(is_directive)
		// Zero out the reward. The quest datum was built assuming a funded commission;
		// we strip the payout so the scroll promises nothing but duty.
		dispatched.reward_amount = 0
		dispatched.is_directive = TRUE
		directives_issued_today++
	var/bonus_label_text = get_commission_bonus_pay_label(bonus_pay_level)
	SStreasury.defense_log += list(list(
		"title" = dispatched.title || dispatched.quest_type,
		"type" = dispatched.quest_type,
		"region" = chosen_region.region_name,
		"cost" = cost,
		"in_hands" = in_hands,
		"levy_exempt" = levy_exempt,
		"bonus_pay_level" = bonus_pay_level,
		"funding" = funding,
		"day" = GLOB.dayspassed,
	))
	SSquestpool.log_event("defense_issue", "[steward.real_name] commissioned [dispatched.quest_difficulty] [chosen_type] in [chosen_region.region_name] for [cost]m ([funding])[levy_exempt ? " (levy-exempt)" : ""][bonus_label_text ? " ([bonus_label_text])" : ""][in_hands ? " (in hand)" : ""]")
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	var/source_label = is_directive ? "以请令" : (funding == "crown" ? "由王室金库" : "由市民认捐")
	var/bonus_label = bonus_label_text ? " - <i>[bonus_label_text]</i>" : ""
	if(in_hands)
		to_chat(steward, span_notice("委托[source_label]拟就，交入你手：<b>[dispatched.title || dispatched.quest_type]</b>，位于 [chosen_region.region_name][levy_exempt ? " - <i>免征关税</i>" : ""][bonus_label]。"))
	else
		to_chat(steward, span_notice("委托[source_label]张贴：<b>[dispatched.title || dispatched.quest_type]</b>，位于 [chosen_region.region_name][levy_exempt ? " - <i>免征关税</i>" : ""][bonus_label]。"))

/// Blockade commissions bypass the threat-region picker entirely — region param is the
/// economic region name, resolved to a live /datum/blockade. Multiple writs may be in
/// circulation concurrently, one per blockaded region.
/obj/structure/roguemachine/contractledger/proc/commission_blockade_defense(mob/living/carbon/human/steward, list/params, cost, datum/fund/source_fund, is_directive, bonus_pay_level = COMMISSION_BONUS_PAY_NONE, is_alderman_acting = FALSE)
	var/region_name = params["region"]
	var/datum/blockade/chosen
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		var/datum/economic_region/ER = B.get_region()
		if(ER?.name == region_name)
			chosen = B
			break
	if(!chosen)
		to_chat(steward, span_warning("该地区目前并未遭受封锁。"))
		return FALSE
	if(chosen.has_active_scroll())
		to_chat(steward, span_warning("该封锁已有令状在外流传。"))
		return FALSE
	if(source_fund && cost > 0 && !SStreasury.burn(source_fund, cost, "封锁防御令状([region_name])"))
		to_chat(steward, span_warning("[source_fund.name]拒付这笔支取。"))
		return FALSE
	if(source_fund == SStreasury.burgher_pledge_fund && cost > 0)
		record_round_statistic(STATS_PLEDGE_CONSUMED, cost)
	var/datum/quest/kill/blockade_defense/Q = SSquestpool.issue_blockade_defense_quest(chosen, steward, is_directive ? null : source_fund, is_directive ? 0 : cost)
	if(!Q)
		if(source_fund && cost > 0)
			SStreasury.mint(source_fund, cost, "封锁防御令状退款(签发失败)")
			if(source_fund == SStreasury.burgher_pledge_fund)
				record_round_statistic(STATS_PLEDGE_CONSUMED, -cost)
		SSquestpool.log_event("defense_refund", "landmark failure blockade [region_name] refunded [cost]m")
		to_chat(steward, span_warning("没有地标能够承载该令状。款项已退还。"))
		return FALSE
	// Writ issued: only now dock the Alderman warrant, and record it on the quest so a recall
	// can hand it back. Pre-checked via can_consume_defense in the caller, so this should hold.
	if(is_alderman_acting && cost > 0 && SScity_assembly.consume_defense(cost, steward, "blockade defense commission ([region_name])"))
		Q.warrant_consumed = cost
	// Levy exemption is the Steward's prerogative alone, and never rides a free Request.
	var/levy_exempt = (!is_directive && !is_alderman_acting && params["levy_exempt"]) ? TRUE : FALSE
	if(levy_exempt)
		Q.levy_exempt = TRUE
	var/bonus_mult = get_commission_bonus_pay_mult(bonus_pay_level)
	if(bonus_mult != 1.0)
		Q.reward_amount = round(Q.reward_amount * bonus_mult)
	if(is_directive)
		Q.reward_amount = 0
		Q.is_directive = TRUE
		directives_issued_today++
	var/funding = is_directive ? "directive" : (source_fund == SStreasury.discretionary_fund ? "crown" : "pledge")
	var/bonus_label_text = get_commission_bonus_pay_label(bonus_pay_level)
	SStreasury.defense_log += list(list(
		"title" = Q.get_title(),
		"type" = QUEST_BLOCKADE_DEFENSE,
		"region" = region_name,
		"cost" = cost,
		"in_hands" = TRUE,
		"levy_exempt" = levy_exempt,
		"bonus_pay_level" = bonus_pay_level,
		"funding" = funding,
		"day" = GLOB.dayspassed,
	))
	SSquestpool.log_event("defense_issue", "[steward.real_name] commissioned blockade defense on [region_name] (faction [Q.faction_id]) for [cost]m ([funding])[levy_exempt ? " (levy-exempt)" : ""][bonus_label_text ? " ([bonus_label_text])" : ""]")
	scom_announce("已为 [region_name] 签发封锁防御令状[bonus_label_text ? " - 附有 [bonus_label_text]" : ""]。")
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	var/source_label = is_directive ? "以请令" : (funding == "crown" ? "由王室金库" : "由市民认捐")
	to_chat(steward, span_notice("封锁令状[source_label]拟就，交入你手：<b>[Q.get_title()]</b>[levy_exempt ? " - <i>免征关税</i>" : ""][bonus_label_text ? " - <i>[bonus_label_text]</i>" : ""]。"))
	return TRUE

/obj/structure/roguemachine/contractledger/proc/commission_hoard_recovery(mob/living/carbon/human/steward, list/params, cost, datum/fund/source_fund, is_directive, bonus_pay_level = COMMISSION_BONUS_PAY_NONE, is_alderman_acting = FALSE)
	var/region_name = params["region"]
	var/datum/threat_region/TR = SSregionthreat.get_region(region_name)
	if(!TR || TR.banditry_hoard < HOARD_RECOVERY_HOARD_MINIMUM)
		to_chat(steward, span_warning("该地区的宝藏太过微不足道，不足以发起寻宝令状——至少需要 [HOARD_RECOVERY_HOARD_MINIMUM] 枚玛门。"))
		return
	if(TR.has_active_blockade())
		to_chat(steward, span_warning("[TR.region_name]正处于封锁之中——请改为委托封锁防御令状。"))
		return
	var/datum/quest/kill/blockade_defense/existing = TR.active_hoard_recovery_ref?.resolve()
	if(existing && !QDELETED(existing) && !existing.failed && !existing.complete)
		to_chat(steward, span_warning("该地区已有一份寻宝令状在外流传。"))
		return
	if(source_fund && cost > 0 && !SStreasury.burn(source_fund, cost, "寻宝令状([region_name])"))
		to_chat(steward, span_warning("[source_fund.name]拒付这笔支取。"))
		return
	if(source_fund == SStreasury.burgher_pledge_fund && cost > 0)
		record_round_statistic(STATS_PLEDGE_CONSUMED, cost)
	var/datum/quest/kill/blockade_defense/Q = SSquestpool.issue_hoard_recovery_request(TR, steward, is_directive ? null : source_fund, is_directive ? 0 : cost, TRUE)
	if(!Q)
		if(source_fund && cost > 0)
			SStreasury.mint(source_fund, cost, "寻宝令状退款(签发失败)")
			if(source_fund == SStreasury.burgher_pledge_fund)
				record_round_statistic(STATS_PLEDGE_CONSUMED, -cost)
		SSquestpool.log_event("defense_refund", "landmark failure hoard recovery [region_name] refunded [cost]m")
		to_chat(steward, span_warning("没有地标能够承载该令状。款项已退还。"))
		return
	if(is_alderman_acting && cost > 0 && SScity_assembly.consume_defense(cost, steward, "hoard recovery commission ([region_name])"))
		Q.warrant_consumed = cost
	var/bonus_mult = get_commission_bonus_pay_mult(bonus_pay_level)
	if(bonus_mult != 1.0)
		Q.reward_amount = round(Q.reward_amount * bonus_mult)
	if(is_directive)
		Q.reward_amount = 0
		Q.is_directive = TRUE
		directives_issued_today++
	var/levy_exempt = (!is_directive && !is_alderman_acting && params["levy_exempt"]) ? TRUE : FALSE
	if(levy_exempt)
		Q.levy_exempt = TRUE
	var/funding = is_directive ? "directive" : (source_fund == SStreasury.discretionary_fund ? "crown" : "pledge")
	var/bonus_label_text = get_commission_bonus_pay_label(bonus_pay_level)
	SStreasury.defense_log += list(list(
		"title" = Q.get_title(),
		"type" = QUEST_HOARD_RECOVERY,
		"region" = region_name,
		"cost" = cost,
		"in_hands" = TRUE,
		"levy_exempt" = levy_exempt,
		"bonus_pay_level" = bonus_pay_level,
		"funding" = funding,
		"day" = GLOB.dayspassed,
	))
	SSquestpool.log_event("defense_issue", "[steward.real_name] commissioned hoard recovery on [region_name] (faction [Q.faction_id], hoard [TR.banditry_hoard]) for [cost]m ([funding])[levy_exempt ? " (levy-exempt)" : ""][bonus_label_text ? " ([bonus_label_text])" : ""]")
	scom_announce("已为 [region_name] 签发寻宝令状[bonus_label_text ? " - 附有 [bonus_label_text]" : ""]。")
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	var/source_label = is_directive ? "以请令" : (funding == "crown" ? "由王室金库" : "由市民认捐")
	to_chat(steward, span_notice("寻宝令状[source_label]拟就，交入你手：<b>[Q.get_title()]</b>[levy_exempt ? " - <i>免征关税</i>" : ""][bonus_label_text ? " - <i>[bonus_label_text]</i>" : ""]。"))

/// Steward recall: cancels a still-armed writ within the recall window and refunds the draft.
/// Region param is the economic region name — same selector used for issuance.
/obj/structure/roguemachine/contractledger/proc/recall_blockade_writ_from_tgui(mob/user, list/params)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/steward = user
	if(!can_commission(steward))
		return
	if(!steward.Adjacent(src))
		return
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(steward, span_warning("台账尚未开启。"))
		return
	var/region_name = params["region"]
	if(!region_name)
		return
	var/datum/quest/kill/blockade_defense/Q
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		var/datum/economic_region/ER = B.get_region()
		if(ER?.name == region_name)
			Q = B.active_quest_ref?.resolve()
			break
	if(!Q)
		var/datum/threat_region/TR = SSregionthreat.get_region(region_name)
		Q = TR?.active_hoard_recovery_ref?.resolve()
	if(!istype(Q) || QDELETED(Q))
		to_chat(steward, span_warning("该地区并无令状在外流传。"))
		return
	var/blocker = Q.recall_blocker()
	if(blocker)
		to_chat(steward, span_warning("该令状无法撤回：[blocker]。"))
		return
	var/refund = Q.funding_cost
	var/datum/fund/refund_fund = Q.funding_fund
	if(!Q.recall(steward))
		to_chat(steward, span_warning("该令状无法撤回。"))
		return
	SSquestpool.log_event("defense_recall", "[steward.real_name] recalled blockade writ on [region_name][refund > 0 && refund_fund ? " (refunded [refund]m to [refund_fund.name])" : ""]")
	scom_announce("针对 [region_name] 的封锁令状已被撤回。")
	playsound(src, 'sound/items/inqslip_sealed.ogg', 50, FALSE, -1)
	if(refund > 0 && refund_fund)
		to_chat(steward, span_notice("令状已撤回。[refund]m 已退还给[refund_fund.name]。"))
	else
		to_chat(steward, span_notice("令状已撤回。"))
