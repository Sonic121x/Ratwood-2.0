GLOBAL_LIST_INIT(towner_orevein_regions, list(
	THREAT_REGION_AZUREAN_COAST,
	THREAT_REGION_UNDERDARK,
))

GLOBAL_LIST_INIT(towner_orevein_gem_types, list(
	/obj/item/roguegem/green,
	/obj/item/roguegem/blue,
	/obj/item/roguegem/yellow,
	/obj/item/roguegem/violet,
	/obj/item/roguegem/ruby,
	/obj/item/roguegem/diamond,
	/obj/item/roguegem/jade,
))

GLOBAL_LIST_INIT(towner_orevein_tier_tp, list(
	TOWNER_POSTING_TIER_MEDIUM = TOWNER_OREVEIN_TP_BUDGET_MEDIUM,
	TOWNER_POSTING_TIER_HARD = TOWNER_OREVEIN_TP_BUDGET_HARD,
))

GLOBAL_LIST_INIT(towner_orevein_varieties, list(
	OREVEIN_VARIETY_IRON = list(
		"label" = "铁矿脉",
		"blurb" = "铁与煤，另有些许朱砂与零星宝石。",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/rogueore/iron, "min" = 14, "max" = 18, "noun" = "铁矿石"),
				list("path" = /obj/item/rogueore/coal, "min" = 8, "max" = 12, "noun" = "煤"),
				list("path" = /obj/item/rogueore/cinnabar, "min" = 2, "max" = 3, "noun" = "朱砂矿石"),
				list("pool" = "orevein_gems", "min" = 1, "max" = 1, "noun" = "宝石", "prob" = 40),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/rogueore/iron, "min" = 26, "max" = 32, "noun" = "铁矿石"),
				list("path" = /obj/item/rogueore/coal, "min" = 12, "max" = 16, "noun" = "煤"),
				list("path" = /obj/item/rogueore/cinnabar, "min" = 3, "max" = 4, "noun" = "朱砂矿石"),
				list("pool" = "orevein_gems", "min" = 1, "max" = 1, "noun" = "宝石", "prob" = 80),
			),
		),
	),
	OREVEIN_VARIETY_CUPROSTANNIC = list(
		"label" = "铜矿脉",
		"blurb" = "铜与锡，另有些许奢侈品。",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/rogueore/copper, "min" = 20, "max" = 26, "noun" = "铜矿石"),
				list("path" = /obj/item/rogueore/tin, "min" = 6, "max" = 9, "noun" = "锡矿石"),
				list("path" = /obj/item/rogueore/cinnabar, "min" = 1, "max" = 2, "noun" = "朱砂矿石"),
				list("pool" = "orevein_gems", "min" = 1, "max" = 1, "noun" = "宝石", "prob" = 20),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/rogueore/copper, "min" = 32, "max" = 40, "noun" = "铜矿石"),
				list("path" = /obj/item/rogueore/tin, "min" = 10, "max" = 14, "noun" = "锡矿石"),
				list("path" = /obj/item/rogueore/cinnabar, "min" = 3, "max" = 4, "noun" = "朱砂矿石"),
				list("pool" = "orevein_gems", "min" = 1, "max" = 1, "noun" = "宝石", "prob" = 60),
			),
		),
	),
	OREVEIN_VARIETY_GEMMIFEROUS = list(
		"label" = "宝石矿脉",
		"blurb" = "切磨好的宝石与生金，没有贱金属。",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/rogueore/gold, "min" = 1, "max" = 2, "noun" = "金矿石"),
				list("pool" = "orevein_gems", "min" = 2, "max" = 2, "noun" = "宝石"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/rogueore/gold, "min" = 2, "max" = 3, "noun" = "金矿石"),
				list("pool" = "orevein_gems", "min" = 3, "max" = 4, "noun" = "宝石"),
			),
		),
	),
	OREVEIN_VARIETY_AURICINNABAR = list(
		"label" = "朱砂矿脉",
		"blurb" = "与金共生的朱砂，为炼金术士所珍视。",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/rogueore/gold, "min" = 2, "max" = 3, "noun" = "金矿石"),
				list("path" = /obj/item/rogueore/cinnabar, "min" = 9, "max" = 11, "noun" = "朱砂矿石"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/rogueore/gold, "min" = 4, "max" = 5, "noun" = "金矿石"),
				list("path" = /obj/item/rogueore/cinnabar, "min" = 14, "max" = 17, "noun" = "朱砂矿石"),
			),
		),
	),
))

/datum/quest/kill/recovery/towner/miner_orevein
	quest_type = QUEST_TOWNER_MINER_OREVEIN
	parcel_label = "矿石"
	sealed_noun = "矿石板条箱"

/datum/quest/kill/recovery/towner/miner_orevein/get_eligible_regions()
	return GLOB.towner_orevein_regions

/datum/quest/kill/recovery/towner/miner_orevein/get_varieties()
	return GLOB.towner_orevein_varieties

/datum/quest/kill/recovery/towner/miner_orevein/get_tier_tp_budget()
	return GLOB.towner_orevein_tier_tp[posting_tier] || TOWNER_OREVEIN_TP_BUDGET_MEDIUM

/datum/quest/kill/recovery/towner/miner_orevein/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]的线索"
	return "矿工的线索"

/datum/quest/kill/recovery/towner/miner_orevein/get_objective_text()
	return "击破矿脉上的元素守卫，并把矿石板条箱运回给[quest_giver_name || "矿工"]。"

/datum/quest/kill/recovery/towner/miner_orevein/get_parcel_name()
	return "[quest_giver_name]的矿石板条箱"

/datum/quest/kill/recovery/towner/miner_orevein/get_parcel_desc()
	return "一只板条箱，装满了[quest_giver_name]在元素生物逼近前采得的矿石，以魔法封存，唯其本人可开启。"

/datum/quest/kill/recovery/towner/miner_orevein/get_writ_intro()
	var/region = target_spawn_area || "地底深处"
	return "[quest_giver_name || "矿工"]在[region]探得一处矿脉，由一大群土元素看守。他们采得了丰厚的一批，随后被这群守卫赶了回来，如今呼唤人手去击破守卫并把板条箱拖出来。"

/datum/quest/kill/recovery/towner/miner_orevein/pick_region_faction_for(datum/threat_region/TR)
	return get_quest_faction(QUEST_FACTION_EARTH_ELEMENTAL)

/datum/quest/kill/recovery/towner/miner_orevein/roll_circumstance()
	return ""

/datum/quest/kill/recovery/towner/miner_orevein/compose_warband()
	if(posting_tier != TOWNER_POSTING_TIER_HARD)
		return ..()
	var/behemoth = /mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth
	var/saved_budget = tp_budget
	tp_budget = max(0, tp_budget - initial_threat_point(behemoth))
	. = ..()
	tp_budget = saved_budget
	if(!(behemoth in .))
		. += behemoth

/datum/quest/kill/recovery/towner/miner_orevein/build_bundle()
	var/list/meta = GLOB.towner_orevein_varieties[effective_variety()]
	var/list/tiers = meta?["tiers"]
	if(!tiers)
		return list()
	return resolve_bundle_spec(tiers[posting_tier] || tiers[TOWNER_POSTING_TIER_MEDIUM])
