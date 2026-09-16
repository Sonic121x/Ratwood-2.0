GLOBAL_LIST_INIT(towner_posting_tier_costs, list(
	TOWNER_POSTING_TIER_MEDIUM = TOWNER_POSTING_COST_MEDIUM,
	TOWNER_POSTING_TIER_HARD = TOWNER_POSTING_COST_HARD,
))

GLOBAL_LIST_INIT(towner_posting_descriptors, list(
	QUEST_TOWNER_SMITH_CARAVAN = list(
		"label" = "失踪的商队",
		"blurb" = "你的一辆货车在途中失踪了。雇人手去守住残骸，并把保险箱带回家。",
		"rules" = list(
			"保险箱对你施加了魔法封印——唯有你能打开它。",
			"你无须亲自跋涉；持令人会把保险箱带给你。",
		),
		"postable_advclasses" = list(
			/datum/advclass/blacksmith,
			/datum/advclass/guildsman/blacksmith,
			/datum/advclass/guildsman/artificer,
			/datum/advclass/guildmaster,
		),
	),
	QUEST_TOWNER_MINER_OREVEIN = list(
		"label" = "矿工的线索",
		"blurb" = "你探得一处有元素生物看守的矿脉，采得满满一载，却被守卫赶了回来。雇人手去斩杀元素生物，把板条箱运出来。",
		"rules" = list(
			"板条箱对你施加了魔法封印——唯有你能打开它。",
			"你无须亲自跋涉；持令人会把板条箱带给你。",
		),
		"postable_advclasses" = list(
			/datum/advclass/miner,
			/datum/advclass/builder,
			/datum/advclass/guildmaster,
		),
	),
))

/proc/get_user_advclass_path(mob/user)
	if(!ishuman(user))
		return null
	// Ratwood deviation: ES has no mind.picked_advclass; the chosen advclass NAME is stored on H.advjob.
	var/mob/living/carbon/human/H = user
	if(!H.advjob)
		return null
	var/datum/advclass/AC = SSrole_class_handler.get_advclass_by_name(H.advjob)
	return AC?.type

/proc/towner_trade_can_post(mob/user, posting_type)
	var/list/desc = GLOB.towner_posting_descriptors[posting_type]
	if(!desc)
		return FALSE
	var/path = get_user_advclass_path(user)
	if(!path)
		return FALSE
	return (path in desc["postable_advclasses"])

/proc/user_can_post_crown_towner(mob/user)
	if(!user)
		return FALSE
	if(user.job in GLOB.crown_authority_roles)
		return TRUE
	if(SSticker?.regentmob == user)
		return TRUE
	return FALSE

/proc/towner_posting_is_crown_funded(mob/user, posting_type)
	if(towner_trade_can_post(user, posting_type))
		return FALSE
	return user_can_post_crown_towner(user)

/proc/user_can_post_towner_type(mob/user, posting_type)
	if(!GLOB.towner_posting_descriptors[posting_type])
		return FALSE
	if(towner_trade_can_post(user, posting_type))
		return TRUE
	return user_can_post_crown_towner(user)

/proc/user_can_post_any_towner(mob/user)
	for(var/posting_type in GLOB.towner_posting_descriptors)
		if(user_can_post_towner_type(user, posting_type))
			return TRUE
	return FALSE

/proc/towner_advclass_names(list/paths)
	var/list/out = list()
	for(var/path in paths)
		var/datum/advclass/AC = path
		var/n = initial(AC.name)
		if(n)
			out += n
	return out

/proc/towner_bearer_summary(tier)
	var/bonus = GLOB.towner_tier_flat_bonus[tier] || 0
	if(bonus > 0)
		return "战斗与路程报酬 + [bonus]m 额外补贴"
	return "战斗与路程报酬"

/proc/towner_variety_table(posting_type)
	switch(posting_type)
		if(QUEST_TOWNER_SMITH_CARAVAN)
			return GLOB.towner_smith_caravan_varieties
		if(QUEST_TOWNER_MINER_OREVEIN)
			return GLOB.towner_orevein_varieties
	return null

/proc/towner_default_variety(posting_type)
	var/list/vtable = towner_variety_table(posting_type)
	if(!length(vtable))
		return null
	return vtable[1]

/proc/towner_spec_summary(list/spec)
	if(!length(spec))
		return "一份不多的收获"
	var/list/parts = list()
	for(var/list/entry in spec)
		var/noun = entry["noun"] || "货物"
		var/lo = entry["min"]
		var/hi = entry["max"]
		if(entry["prob"] != null && entry["prob"] < 100)
			parts += "可能获得 [noun]"
		else if(lo == hi)
			parts += "[lo] [noun]"
		else
			parts += "[lo]-[hi] [noun]"
	return english_list(parts)

/proc/towner_variety_listing(posting_type)
	var/list/vtable = towner_variety_table(posting_type)
	if(!length(vtable))
		return list()
	var/list/out = list()
	for(var/key in vtable)
		var/list/meta = vtable[key]
		var/list/poster_summaries = list()
		var/list/meta_tiers = meta["tiers"]
		for(var/tier in GLOB.towner_posting_tier_costs)
			poster_summaries[tier] = towner_spec_summary(meta_tiers?[tier])
		out += list(list(
			"key" = key,
			"label" = meta["label"],
			"blurb" = meta["blurb"],
			"poster_summaries" = poster_summaries,
		))
	return out

/proc/build_towner_posting_listing(mob/user)
	var/list/out = list()
	for(var/posting_type in GLOB.towner_posting_descriptors)
		var/list/desc = GLOB.towner_posting_descriptors[posting_type]
		var/crown_funded = towner_posting_is_crown_funded(user, posting_type)
		var/cost_mult = crown_funded ? TOWNER_POSTING_CROWN_COST_MULT : 1
		var/list/tiers = list()
		for(var/tier in GLOB.towner_posting_tier_costs)
			tiers[tier] = list(
				"cost" = GLOB.towner_posting_tier_costs[tier] * cost_mult,
				"bearer_summary" = towner_bearer_summary(tier),
			)
		out += list(list(
			"type" = posting_type,
			"label" = desc["label"],
			"blurb" = desc["blurb"],
			"rules" = desc["rules"] || list(),
			"eligible" = user_can_post_towner_type(user, posting_type) ? TRUE : FALSE,
			"eligible_jobs" = towner_advclass_names(desc["postable_advclasses"]),
			"crown_funded" = crown_funded ? TRUE : FALSE,
			"tiers" = tiers,
			"varieties" = towner_variety_listing(posting_type),
		))
	return out

/obj/structure/roguemachine/contractledger/proc/compose_towner_from_tgui(mob/user, list/params)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/poster = user
	if(!poster.Adjacent(src))
		return
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(poster, span_warning("台账尚未开启。"))
		return

	var/chosen_type = params["type"]
	if(!(chosen_type in GLOB.towner_posting_descriptors))
		to_chat(poster, span_warning("行会并不接受这种发布类型。"))
		return

	if(!user_can_post_towner_type(poster, chosen_type))
		to_chat(poster, span_warning("你的行当不能发布这种契约。"))
		return

	var/tier = params["tier"]
	if(!(tier in GLOB.towner_posting_tier_costs))
		to_chat(poster, span_warning("无法识别该发布档位。"))
		return

	var/variety = params["variety"]
	var/list/vtable = towner_variety_table(chosen_type)
	if(length(vtable))
		if(!variety || !(variety in vtable))
			variety = vtable[1]
	else
		variety = null
	var/crown_funded = towner_posting_is_crown_funded(poster, chosen_type)
	var/cost = GLOB.towner_posting_tier_costs[tier] * (crown_funded ? TOWNER_POSTING_CROWN_COST_MULT : 1)
	if(!cost)
		return

	if(crown_funded)
		if(!SStreasury.discretionary_fund)
			to_chat(poster, span_warning("王室金库尚未设立。"))
			return
		if(SStreasury.discretionary_fund.balance < cost)
			to_chat(poster, span_warning("王室金库余额不足。需要 [cost]m，现有 [SStreasury.discretionary_fund.balance]m。"))
			return
		if(!SStreasury.burn(SStreasury.discretionary_fund, cost, "王室镇民委托([chosen_type])"))
			to_chat(poster, span_warning("王室金库拒付这笔支取。"))
			return
	else
		if(!SStreasury.has_account(poster))
			to_chat(poster, span_warning("你名下并无账户记录。"))
			return
		if(SStreasury.get_balance(poster) < cost)
			to_chat(poster, span_warning("余额不足。发布此项需要 [cost] 枚玛门。"))
			return
		// Ratwood deviation: integer player ledger, not AP's fund accounts. Debit the poster
		// and mint the fee into the Crown's Purse; the refund below mirrors this.
		SStreasury.bank_accounts[poster] -= cost
		SStreasury.mint(SStreasury.discretionary_fund, cost, "镇民契约发布([chosen_type])")

	var/to_hand = (params["delivery"] == "hand")
	var/datum/quest/dispatched = SSquestpool.issue_towner_quest(chosen_type, poster, tier, to_hand, variety)
	if(!dispatched)
		if(crown_funded)
			SStreasury.mint(SStreasury.discretionary_fund, cost, "王室镇民委托退款(签发失败)")
		else
			SStreasury.bank_accounts[poster] += cost
			SStreasury.burn(SStreasury.discretionary_fund, cost, "镇民契约发布退款(签发失败)")
		to_chat(poster, span_warning("没有地标能够承载该契约。款项已退还。"))
		return

	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	var/purse_note = crown_funded ? " 由王室金库支取。" : ""
	if(to_hand)
		to_chat(poster, span_notice("契约已拟就：<b>[dispatched.title || dispatched.quest_type]</b> ([tier], [cost]m)。[purse_note] 把它交给你想雇用的任何人。"))
	else
		to_chat(poster, span_notice("契约已张贴：<b>[dispatched.title || dispatched.quest_type]</b> ([tier], [cost]m)。[purse_note] 追回的货物必须由你本人开启。"))
	log_game("[key_name(poster)] posted towner contract \"[dispatched.title || dispatched.quest_type]\" ([tier], [cost]m, [crown_funded ? "crown purse" : "personal"], [to_hand ? "in hand" : "board"]).")
