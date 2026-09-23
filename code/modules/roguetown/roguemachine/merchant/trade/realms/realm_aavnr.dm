/datum/foreign_realm/aavnr
	id = REALM_AAVNR
	name = "阿瓦尔"
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_LIGHT, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_POTTERY, NAVIGATOR_BUCKET_VALUABLES_LOOTED, NAVIGATOR_BUCKET_MISCELLANEOUS)
	ship_name_words = list(
		"Yarlsnik", "Koprivka", "Diethelm", "Tomorzh", "Khairin",
		"Wardenpact", "Hetman", "Saiga", "Bloodaxe", "Ironmask",
		"Potentate", "Astrava", "Ravox", "Zogiin", "Hussar",
	)
	captain_first_names = list(
		"Bjorn", "Yakiv", "Tomasz", "Lubomir", "Radek",
		"Szabolcs", "Aleksy", "Miron", "Branislav", "Kazimir",
		"Yelena", "Magda", "Zofia", "Liliana", "Vasylyna",
	)
	captain_last_names = list(
		"Yakivin", "Trunfelov", "Koprivchak", "Astravich", "Drogomir",
		"Hetmanov", "Szabrik", "Ironwald", "Bloodgrip", "Khairov",
	)
	ship_types = list(
		list("name" = "抗冰帆船", "tonnage" = 50, "weight" = 25),
		list("name" = "洛迪亚帆船", "tonnage" = 120, "weight" = 35),
		list("name" = "阿夫尼克桨帆船", "tonnage" = 250, "weight" = 25),
		list("name" = "权贵霍尔克船", "tonnage" = 500, "weight" = 15),
	)
	name_prefixes = list(
		list("text" = "Hetman ", "chance" = 10),
		list("text" = "Free ", "chance" = 5),
	)
	city_tags = list(
		"Tomorzurkh", "Dalainkhair", "Enkhjarlgal", "Koprivkolov", "Free Szöréndnížina",
	)
	city_tag_chance = 35
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_DRIED_FISH, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_MEAT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_CLAM, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR, "always" = TRUE),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GLASS_BATCH, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/cod, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/alecod, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pepperlobsta, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bread, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/mead),
		list("recipe" = /datum/brewing_recipe/jack_wine),
		list("recipe" = /datum/brewing_recipe/voddena),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/aavnr/shashka,
		/datum/supply_pack/rogue/aavnr/recurve_bow,
		/datum/supply_pack/rogue/aavnr/steppe_axe,
		/datum/supply_pack/rogue/aavnr/nagaika,
		/datum/supply_pack/rogue/aavnr/steppe_shield,
		/datum/supply_pack/rogue/aavnr/shishak,
		/datum/supply_pack/rogue/aavnr/papakha,
		/datum/supply_pack/rogue/aavnr/ironmask,
		/datum/supply_pack/rogue/aavnr/chargah,
		/datum/supply_pack/rogue/aavnr/hatanga,
		/datum/supply_pack/rogue/aavnr/steppe_scale,
		/datum/supply_pack/rogue/aavnr/szabrista_kit,
		/datum/supply_pack/rogue/aavnr/druzhina_kit,
		/datum/supply_pack/rogue/aavnr/freifechter_kit,
		/datum/supply_pack/rogue/aavnr/saiga_sausage,
		/datum/supply_pack/rogue/aavnr/coppiette,
		/datum/supply_pack/rogue/alcohol/avarmead,
		/datum/supply_pack/rogue/alcohol/avarrice,
		/datum/supply_pack/rogue/alcohol/saigamilk,
	)
	hail_lines = list(
		"你好，商行管事。兽皮、谷物、鱼和毛皮，都是阿瓦尔草原最上等的货色。给我带来丝绸和翠晶，否则什么也别带。",
		"托莫尔祖尔赫的首领捎来了问候，还要求运去柠檬。后一件事可由不得你选。",
		"这次渡海很太平。之前四次可不是。我想跟你们荒凉群岛的守卫谈谈这件事。",
		"快些交易，朋友。草原不会等人，我归乡路上的狼也不会。",
		"一位达兰海尔的赛加羚羊祭司正在货舱里为货物祈福。他不肯出来，已经待了三天。货物似乎很满意。",
		"赛加羚羊奶是拿来卖的，不是让人当值时喝的。告诉你们的码头工人，我已经提醒过我的人了。",
		"君王的重担压着龙骨，更压着我的钱袋。减轻一边，另一边也会轻松。",
		"一位阿斯特拉瓦传承的赛加羚羊驯师与我同行，他是这一传承的最后一人。只要两枚泽尼，他便会将手按在雾兽身上，不用任何人告知，那生灵就会知道你的名字。他出海，是因为儿子们学不会他的本领；这门传承将在这次或下次航程中随他而逝。趁来得及，付钱请他帮忙吧。",
		"给草原的儿女们来些腌鲱鱼。马奶和赛加羚羊香肠固然不错，可我们的战士也喜欢在行军时嚼点异国吃食。"
	)
