GLOBAL_LIST_INIT(towner_smith_caravan_regions, list(
	THREAT_REGION_AZURE_GROVE,
	THREAT_REGION_AZUREAN_COAST,
))

GLOBAL_LIST_INIT(towner_smith_caravan_factions, list(
	QUEST_FACTION_HIGHWAYMAN,
	QUEST_FACTION_MOUNT_REAVER,
	QUEST_FACTION_BLEAKISLE_REAVER,
))

GLOBAL_LIST_INIT(towner_smith_caravan_varieties, list(
	CARAVAN_VARIETY_IRON = list(
		"label" = "铁与钢",
		"blurb" = "铁锭与钢锭。",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/ingot/iron, "min" = 11, "max" = 15, "noun" = "铁锭"),
				list("path" = /obj/item/ingot/steel, "min" = 5, "max" = 8, "noun" = "钢锭"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/ingot/iron, "min" = 18, "max" = 24, "noun" = "铁锭"),
				list("path" = /obj/item/ingot/steel, "min" = 10, "max" = 14, "noun" = "钢锭"),
			),
		),
	),
	CARAVAN_VARIETY_BRONZE = list(
		"label" = "青铜",
		"blurb" = "铸造的青铜锭。",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/ingot/bronze, "min" = 8, "max" = 10, "noun" = "青铜锭"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/ingot/bronze, "min" = 14, "max" = 16, "noun" = "青铜锭"),
			),
		),
	),
	CARAVAN_VARIETY_BULLION = list(
		"label" = "金锭",
		"blurb" = "装满一保险箱的金锭。",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/ingot/gold, "min" = 3, "max" = 4, "noun" = "金锭"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/ingot/gold, "min" = 6, "max" = 7, "noun" = "金锭"),
			),
		),
	),
))

GLOBAL_LIST_INIT(towner_caravan_tier_tp, list(
	TOWNER_POSTING_TIER_MEDIUM = TOWNER_CARAVAN_TP_BUDGET_MEDIUM,
	TOWNER_POSTING_TIER_HARD = TOWNER_CARAVAN_TP_BUDGET_HARD,
))

/datum/quest/kill/recovery/towner/smith_caravan
	quest_type = QUEST_TOWNER_SMITH_CARAVAN
	parcel_label = "失落的锭块"

/datum/quest/kill/recovery/towner/smith_caravan/get_eligible_regions()
	return GLOB.towner_smith_caravan_regions

/datum/quest/kill/recovery/towner/smith_caravan/get_varieties()
	return GLOB.towner_smith_caravan_varieties

/datum/quest/kill/recovery/towner/smith_caravan/get_tier_tp_budget()
	return GLOB.towner_caravan_tier_tp[posting_tier] || TOWNER_CARAVAN_TP_BUDGET_MEDIUM

/datum/quest/kill/recovery/towner/smith_caravan/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]的商队"
	return "失踪的商队"

/datum/quest/kill/recovery/towner/smith_caravan/get_objective_text()
	return "清理残骸，并把保险箱带回给[quest_giver_name || "铁匠"]。"

/datum/quest/kill/recovery/towner/smith_caravan/get_writ_intro()
	var/region = target_spawn_area || "荒野"
	var/raiders = faction ? faction.name_plural : "匪帮"
	return "[quest_giver_name || "铁匠"]的货车在[region]的路上失踪，被[raiders]夺去。他们呼唤人手去清理残骸，并把保险箱带回家。"

/datum/quest/kill/recovery/towner/smith_caravan/get_parcel_desc()
	return "为[quest_giver_name]以魔法封存的包裹——唯其本人可开启。"

/datum/quest/kill/recovery/towner/smith_caravan/pick_region_faction_for(datum/threat_region/TR)
	var/list/weights = list()
	for(var/id in TR.faction_weights)
		if(!(id in GLOB.towner_smith_caravan_factions))
			continue
		var/datum/quest_faction/F = get_quest_faction(id)
		if(!F)
			continue
		weights[id] = TR.faction_weights[id]
	if(!length(weights))
		return null
	var/picked_id = pickweight(weights)
	return get_quest_faction(picked_id)

/datum/quest/kill/recovery/towner/smith_caravan/build_bundle()
	var/list/meta = GLOB.towner_smith_caravan_varieties[effective_variety()]
	var/list/tiers = meta?["tiers"]
	if(!tiers)
		return list()
	return resolve_bundle_spec(tiers[posting_tier] || tiers[TOWNER_POSTING_TIER_MEDIUM])
