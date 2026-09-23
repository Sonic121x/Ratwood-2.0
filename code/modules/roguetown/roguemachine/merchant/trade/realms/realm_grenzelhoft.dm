/datum/foreign_realm/grenzelhoft
	id = REALM_GRENZELHOFT
	name = "格伦泽尔霍夫特"
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	demanded_categories = list(NAVIGATOR_BUCKET_POTIONS_REAGENTS, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_CARVED, NAVIGATOR_BUCKET_POTTERY, NAVIGATOR_BUCKET_MISCELLANEOUS)
	ship_name_words = list(
		"Eisernen", "Sturm", "Adler", "Wolf", "Drache",
		"Schwert", "Bruder", "Krone", "Burg", "Wappen",
		"Hammer", "Nordlicht", "Falken", "Reiter", "Greif",
	)
	captain_first_names = list(
		"Heinrich", "Konrad", "Dietrich", "Ulrich", "Gerhard",
		"Hartmann", "Albrecht", "Reinhart", "Hermann", "Sigmund",
		"Adelheid", "Mechthild", "Hedwig", "Irmgard", "Kunigunde",
	)
	captain_last_names = list(
		"Faber", "Krummhorn", "Wolfsbein", "Hartwald", "von Apfelweinheim",
		"Eisenberg", "Falkenried", "Sturmwacht", "von Zenitstadt", "von Hochburg",
	)
	ship_types = list(
		list("name" = "沿岸货船", "tonnage" = 30, "weight" = 15),
		list("name" = "柯克帆船", "tonnage" = 120, "weight" = 50),
		list("name" = "霍尔克货船", "tonnage" = 250, "weight" = 25),
		list("name" = "卡拉克帆船", "tonnage" = 500, "weight" = 10),
	)
	city_tags = list(
		"Apfelweinheim", "Zenitstadt", "Eisenhafen", "Silbergrund",
		"Hochburg", "Sterneberg", "Sankt Averial",
	)
	city_tag_chance = 35
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR, "always" = TRUE),
		list("good" = TRADE_GOOD_CHEESE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_BUTTER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR, "always" = TRUE),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_CLAY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bun_grenz, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/cheesebun, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/sandwich/salami, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/sandwich/cheese, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/raisinbread, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bread, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/beer),
		list("recipe" = /datum/brewing_recipe/jack_wine),
		list("recipe" = /datum/brewing_recipe/cider),
		list("recipe" = /datum/brewing_recipe/aqua_vitae),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/grenzelhoft/zweihander,
		/datum/supply_pack/rogue/grenzelhoft/kriegmesser,
		/datum/supply_pack/rogue/grenzelhoft/halberd,
		/datum/supply_pack/rogue/grenzelhoft/partizan,
		/datum/supply_pack/rogue/grenzelhoft/seax,
		/datum/supply_pack/rogue/grenzelhoft/kampfmesser,
		/datum/supply_pack/rogue/grenzelhoft/blacksteel_cuirass,
		/datum/supply_pack/rogue/grenzelhoft/heavy_gambeson,
		/datum/supply_pack/rogue/grenzelhoft/plumed_hat,
		/datum/supply_pack/rogue/grenzelhoft/boots,
		/datum/supply_pack/rogue/grenzelhoft/gloves,
		/datum/supply_pack/rogue/grenzelhoft/pants,
		/datum/supply_pack/rogue/grenzelhoft/merc_tabard,
		/datum/supply_pack/rogue/grenzelhoft/crossbow,
		/datum/supply_pack/rogue/grenzelhoft/fyrebolts,
		/datum/supply_pack/rogue/grenzelhoft/almain_rivet,
		/datum/supply_pack/rogue/grenzelhoft/coppiette,
		/datum/supply_pack/rogue/grenzelhoft/salami,
		/datum/supply_pack/rogue/grenzelhoft/hardybread,
		/datum/supply_pack/rogue/alcohol/grenzelbeer,
		/datum/supply_pack/rogue/alcohol/winegrenzel,
		/datum/supply_pack/rogue/alcohol/apfelweinheim,
		/datum/supply_pack/rogue/alcohol/jagdtrunk,
		/datum/supply_pack/rogue/alcohol/beer,
		/datum/supply_pack/rogue/alcohol/blackgoat,
		/datum/supply_pack/rogue/alcohol/zagul,
		/datum/supply_pack/rogue/alcohol/onin,
	)
	hail_lines = list(
		"商行管事！用白银付清我的货款，别拿承诺搪塞。第一次退潮我就起航，不管你准没准备好。",
		"阿普费尔韦因海姆的谷物，新塞莱斯蒂亚铸造厂的金属锭。带买家来，别带闲逛的人。",
		"以十一座大教堂起誓，我的账簿清清白白。你的也最好如此——教廷厌恶骗子，我也一样。",
		"渡海途中，每个太阳日我的船员都会举行弥撒。我们虔诚、吃得饱、耐心好。这三样我带来了两样，第三样我可不保证。",
		"我要黏土、丝绸和橘子。有货的人叫到舷梯来，其他人免了。",
		"王室关税就是披着阿斯特拉塔外衣的窃贼，不过我交过更糟的。给文书盖章，让我们赶紧办完。",
		"天界学院一位登记在册的法师住在我的船尾舱。他的文书齐全，津贴已付。别扣留他，皇帝的法师团会把这当作冒犯。",
		"我的双手巨剑在南方很值钱。谁买我都不在乎，只要不是铁锤堡或格隆恩的领主。看清钱袋，也看清旗帜。",
		"我持有三支佣兵团赴海外服役的雇佣契约。他们的军饷封着教会火漆。别动封印，随军祭司看着呢。",
		"这趟船上有个来自泽尼特施塔特的市民，一路在桅杆顶上哭个不停、吐个不停。他付过船费，我不会替他道歉。",
		"你会发现我的价格公道，脾气却不好。别为了前者试探后者。",
		"这一路，我把一名从格隆恩海岸俘获的劫掠者锁在甲板下。按盟约要求，他已活着交给你们的治安官了。现在说说我真正的货物——谷物。",
		"给我整桶的熏鳗鱼。请别做成冻，那玩意简直是对人类的亵渎。听说天界学院的学生已经吃腻了天天上桌的鲑鱼，你们河里的鳗鱼正好能换换口味。"
	)
