GLOBAL_LIST_INIT(petition_categories, build_petition_categories())

/proc/build_petition_categories()
	var/list/cats = list()
	cats[PETITION_CATEGORY_PROVISIONS] = list(
		"label" = "补给",
		"description" = "大宗主食——口粮、鱼获、果园水果、盐、军粮。",
		"cost" = PETITION_COST_PROVISIONS,
		"templates" = list(
			/datum/standing_order/demand_rations,
			/datum/standing_order/demand_fishery,
			/datum/standing_order/demand_orchard,
			/datum/standing_order/demand_salt,
			/datum/standing_order/demand_victualling_fleet,
			/datum/standing_order/demand_victualling_garrison,
			/datum/standing_order/demand_victualling_mines,
		),
	)
	cats[PETITION_CATEGORY_MATERIALS] = list(
		"label" = "材料",
		"description" = "原材料——锻造用材、建筑用材、纺织、细木工、机关术。",
		"cost" = PETITION_COST_MATERIALS,
		"templates" = list(
			/datum/standing_order/demand_smithing,
			/datum/standing_order/demand_construction_bulk,
			/datum/standing_order/demand_textile,
			/datum/standing_order/demand_artificery,
			/datum/standing_order/demand_fine_joinery,
		),
	)
	cats[PETITION_CATEGORY_ARMS] = list(
		"label" = "武器与甲胄",
		"description" = "成品武器与护甲——驻军装备、边境征集、甲胄订单。",
		"cost" = PETITION_COST_ARMS,
		"templates" = list(
			/datum/standing_order/demand_armaments,
			/datum/standing_order/demand_equipment_armaments,
			/datum/standing_order/demand_equipment_armor_heavy,
			/datum/standing_order/demand_equipment_armor_light,
			/datum/standing_order/demand_frontier_gear,
		),
	)
	cats[PETITION_CATEGORY_LUXURIES] = list(
		"label" = "奢侈品",
		"description" = "宫廷华服、珠宝、命名日贡礼与盛大宴席。",
		"cost" = PETITION_COST_LUXURIES,
		"templates" = list(
			/datum/standing_order/demand_court_finery,
			/datum/standing_order/demand_jewelry,
			/datum/standing_order/demand_curio_collection,
			/datum/standing_order/demand_birthday_gift,
			/datum/standing_order/demand_great_feast_proteins,
		),
	)
	cats[PETITION_CATEGORY_ALCHEMY] = list(
		"label" = "炼金与护理",
		"description" = "成品药水、义肢、异域试剂。",
		"cost" = PETITION_COST_ALCHEMY,
		"templates" = list(
			/datum/standing_order/demand_alchemical,
			/datum/standing_order/demand_alchemical_warband,
			/datum/standing_order/demand_prosthetic_run,
			/datum/standing_order/demand_exotic,
		),
	)
	cats[PETITION_CATEGORY_MASTERWORK] = list(
		"label" = "杰作",
		"description" = "陈列级委托——机关甲胄、比武装备、狩猎战利品。",
		"cost" = PETITION_COST_MASTERWORK,
		"templates" = list(
			/datum/standing_order/demand_artificed_panoply,
			/datum/standing_order/demand_tournament_arms,
			/datum/standing_order/demand_trophy_heads,
		),
	)
	return cats

/datum/controller/subsystem/economy/proc/petitions_remaining_today()
	if(last_petition_day != GLOB.dayspassed)
		return PETITIONS_PER_DAY
	return max(0, PETITIONS_PER_DAY - petitions_today)

/// Returns null if the petition can proceed, otherwise a human-readable reason string.
/// Single source of truth for both the DM action and the TGUI eligibility matrix.
/datum/controller/subsystem/economy/proc/petition_blocker(region_id, category_id)
	if(petitions_remaining_today() <= 0)
		return "贸易厅今日已经受理过一份请愿了"
	var/list/cat = GLOB.petition_categories[category_id]
	if(!cat)
		return "未知的请愿类别"
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	if(!region)
		return "未知地区"
	if(region.is_region_blockaded)
		return "[region.name] 正被封锁——道路对使节关闭"
	if(region.day_last_cleared >= 0)
		var/since = GLOB.dayspassed - region.day_last_cleared
		if(since < PETITION_BLOCKADE_RECOVERY_DAYS)
			var/wait_days = PETITION_BLOCKADE_RECOVERY_DAYS - since
			return "[region.name] 的联络人仍四散未归——请再等 [wait_days] 天"
	if(GLOB.standing_order_pool.len >= STANDING_ORDERS_POOL_CAP)
		return "仓库清单已满——请先完成现有订单"
	var/active_in_region = 0
	var/list/seen_pairs = list()
	for(var/datum/standing_order/O as anything in GLOB.standing_order_pool)
		if(O.region_id != region_id)
			continue
		if(O.pair_id)
			if(seen_pairs[O.pair_id])
				continue
			seen_pairs[O.pair_id] = TRUE
		active_in_region++
	if(active_in_region >= STANDING_ORDERS_MAX_PER_REGION)
		return "[region.name] 已有 [active_in_region] 份进行中的订单"
	var/list/eligible = list()
	for(var/template_path in cat["templates"])
		if(template_path in region.possible_standing_order_types)
			eligible += template_path
	if(!length(eligible))
		return "[region.name] 的贸易厅不做 [cat["label"]] 的买卖"
	if(!SStreasury.burgher_pledge_fund)
		return "市民认捐基金尚未设立"
	var/cost = cat["cost"]
	if(SStreasury.burgher_pledge_fund.balance < cost)
		return "市民认捐基金无法承担 [cost]m"
	return null

/datum/controller/subsystem/economy/proc/petition_for_order(mob/user, region_id, category_id)
	var/blocker = petition_blocker(region_id, category_id)
	if(blocker)
		if(user)
			to_chat(user, span_warning("请愿被拒：[blocker]。"))
		return FALSE
	var/list/cat = GLOB.petition_categories[category_id]
	var/cost = cat["cost"]
	if(!SStreasury.burn(SStreasury.burgher_pledge_fund, cost, "Steward petition - [cat["label"]] in [region_id]"))
		if(user)
			to_chat(user, span_warning("请愿被拒：无法从认捐基金中支取。"))
		return FALSE
	record_round_statistic(STATS_PLEDGE_CONSUMED, cost)
	record_round_statistic(STATS_PETITION_PLEDGE_SPENT, cost)
	if(last_petition_day != GLOB.dayspassed)
		petitions_today = 0
		last_petition_day = GLOB.dayspassed
	petitions_today++
	var/datum/economic_region/region = GLOB.economic_regions[region_id]
	// Weighted like the daily roller, so a template's roll_weight matters for petitions too.
	var/list/eligible = list()
	for(var/template_path in cat["templates"])
		if(template_path in region.possible_standing_order_types)
			eligible[template_path] = region.possible_standing_order_types[template_path]
	var/template = pickweight(eligible)
	var/order_size_mult = min(STANDING_ORDER_POP_SCALE_MAX, 1.0 + (get_effective_player_count() * STANDING_ORDER_POP_SCALE_PER_PLAYER))
	var/datum/standing_order/probe = template
	var/datum/standing_order/O
	if(initial(probe.pair_sibling_type))
		O = instantiate_standing_order_pair(template, initial(probe.pair_sibling_type), region, order_size_mult, petitioned = TRUE)
	else
		O = instantiate_standing_order(template, region, order_size_mult, petitioned = TRUE)
	if(!O)
		SStreasury.mint(SStreasury.burgher_pledge_fund, cost, "Steward petition refund - empty roll")
		record_round_statistic(STATS_PLEDGE_CONSUMED, -cost)
		record_round_statistic(STATS_PETITION_PLEDGE_SPENT, -cost)
		petitions_today--
		if(user)
			to_chat(user, span_warning("请愿抽空——贸易厅已将认捐退还给你。"))
		return FALSE
	record_round_statistic(STATS_STANDING_ORDERS_PETITIONED, 1)
	log_game("PETITION: [user ? key_name(user) : "system"] petitioned [cat["label"]] in [region.name]: rolled [O.name] (+[O.total_payout]m, -[cost]p)")
	if(user)
		to_chat(user, span_notice("请愿获准：[O.name] 已以 [O.total_payout]m 张贴于仓库。"))
	return TRUE
