/obj/structure/roguemachine/contractledger/proc/build_rumor_regions_by_type()
	var/list/out = list()
	for(var/qtype in GLOB.rumor_point_costs)
		var/list/regions = list()
		for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
			if(!TR.allows_quest_type(qtype))
				continue
			if(!rumor_region_passes_threat_gate(TR, qtype))
				continue
			regions += TR.region_name
		out[qtype] = regions
	return out

/obj/structure/roguemachine/contractledger/proc/rumor_region_passes_threat_gate(datum/threat_region/TR, quest_type)
	if(!(quest_type in GLOB.rumor_threat_gated_types))
		return TRUE
	return TR.get_threat_weight() >= RUMOR_THREAT_GATE_MIN

/obj/structure/roguemachine/contractledger/proc/build_rumor_destinations()
	var/list/out = list()
	for(var/area/A as anything in GLOB.quest_recovery_shipments)
		out += initial(A.name)
	return out

/obj/structure/roguemachine/contractledger/proc/compose_rumor_from_tgui(mob/user, list/params)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/innkeeper = user
	if(!(innkeeper.job in GLOB.tavern_positions))
		return
	if(!innkeeper.Adjacent(src))
		return

	var/chosen_type = params["type"]
	if(!(chosen_type in GLOB.rumor_point_costs))
		to_chat(innkeeper, span_warning("行会并不接受这种流言类型。"))
		return
	var/lucrative = params["lucrative"] ? TRUE : FALSE
	var/base_cost = GLOB.rumor_point_costs[chosen_type]
	var/cost = lucrative ? round(base_cost * RUMOR_LUCRATIVE_MULT) : base_cost
	if(SStreasury.rumor_points < cost)
		to_chat(innkeeper, span_warning("流言点数不足。需要 [cost]，现有 [round(SStreasury.rumor_points, 0.1)]。"))
		return

	var/region_name = params["region"]
	var/datum/threat_region/chosen_region
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		if(TR.region_name == region_name && TR.allows_quest_type(chosen_type))
			chosen_region = TR
			break
	if(!chosen_region)
		to_chat(innkeeper, span_warning("该地区并不会流传这类流言。"))
		return
	if(!rumor_region_passes_threat_gate(chosen_region, chosen_type))
		to_chat(innkeeper, span_warning("据你所知，那片地区还不够凶险，不足以流传此等流言。"))
		return

	var/area/chosen_destination
	var/dest_name
	if(chosen_type == QUEST_RECOVERY)
		dest_name = params["destination"]
		for(var/area/A as anything in GLOB.quest_recovery_shipments)
			if(initial(A.name) == dest_name)
				chosen_destination = A
				break
		if(!chosen_destination)
			to_chat(innkeeper, span_warning("并无此等货运目的地。"))
			return

	var/dup_key = "[chosen_type]|[chosen_region.region_name]|[dest_name || ""]"
	if(SStreasury.rumor_issued_today[dup_key] == GLOB.dayspassed)
		to_chat(innkeeper, span_warning("据你所知，今日早些时候并未听过与它如此相近的流言。"))
		return

	SStreasury.rumor_points -= cost
	record_round_statistic(STATS_RUMOR_POINTS_CONSUMED, cost)
	var/in_hands = params["in_hands"] ? TRUE : FALSE
	var/datum/quest/dispatched = SSquestpool.issue_rumor_quest(chosen_type, chosen_region, chosen_destination, in_hands, innkeeper)
	if(!dispatched)
		SStreasury.rumor_points += cost
		record_round_statistic(STATS_RUMOR_POINTS_CONSUMED, -cost)
		to_chat(innkeeper, span_warning("没有地标能够承载这道流言。请换个地区或类型。"))
		return
	if(lucrative)
		dispatched.reward_amount = round(dispatched.reward_amount * RUMOR_LUCRATIVE_MULT)
	SStreasury.rumor_issued_today[dup_key] = GLOB.dayspassed
	SStreasury.rumor_log += list(list(
		"title" = dispatched.title || dispatched.quest_type,
		"type" = dispatched.quest_type,
		"region" = chosen_region.region_name,
		"in_hands" = in_hands,
		"lucrative" = lucrative,
		"day" = GLOB.dayspassed,
	))
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	var/lucrative_tail = lucrative ? " - <i>有利可图</i>" : ""
	if(in_hands)
		to_chat(innkeeper, span_notice("一份流言卷轴已置于你手中：<b>[dispatched.title || dispatched.quest_type]</b>[lucrative_tail]。把它交给你认为合适的人。"))
	else
		say("“我有所耳闻……”一道流言被低语进行会的台账之中。")
		to_chat(innkeeper, span_notice("流言已张贴上板：<b>[dispatched.title || dispatched.quest_type]</b>[lucrative_tail]。"))

/obj/structure/roguemachine/contractledger/proc/pay_innkeeper_referral_fees(mob/user, datum/quest/completed_quest, gross_reward)
	if(gross_reward <= 0)
		return 0
	var/datum/fund/tavern_fund = SStreasury.innkeeper_fund
	var/guild_paid = 0
	if(completed_quest.source != QUEST_SOURCE_DEFENSE && !completed_quest.guild_cut_exempt)
		var/guild_fee = round(gross_reward * GUILD_REFERRAL_FEE_PCT)
		// Ratwood deviation: integer ledger, so the guild cut is debited off the bearer and minted into the tavern fund.
		if(guild_fee > 0 && tavern_fund && SStreasury.bank_accounts[user] >= guild_fee)
			SStreasury.bank_accounts[user] -= guild_fee
			SStreasury.mint(tavern_fund, guild_fee, "行会抽成 - [completed_quest.quest_type]")
			guild_paid = guild_fee
	if(completed_quest.source == QUEST_SOURCE_RUMOR && tavern_fund)
		var/rumor_fee = round(gross_reward * RUMOR_CONTACT_FEE_PCT)
		if(rumor_fee > 0)
			SStreasury.mint(tavern_fund, rumor_fee, "牵线引荐费 - [completed_quest.quest_type]")
	return guild_paid
