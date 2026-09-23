/datum/foreign_realm/vakra
	id = REALM_VAKRA
	name = "瓦克兰"
	roll_weight = TRADE_REALM_WEIGHT_RARE
	demanded_categories = list(NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_LIGHT, NAVIGATOR_BUCKET_ARMOR_HEAVY, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_MISCELLANEOUS)
	ship_name_words = list(
		"Otter", "Noc-lit", "Vakran", "Packlord", "Lupianowy",
		"Seavolf", "Toothy", "Fanged", "Claw", "Forder",
		"Paddler", "Noc-bounty",
	)
	captain_first_names = list(
		"Larai", "Jaromir", "Marek", "Slazri", "Dobromir",
		"Kasim", "Rudai", "Valmir", "Borai", "Jarek",
		"Razmir", "Velar", "Brazir", "Varik", "Lazmir",
	)
	captain_last_names = list(
		"Sturmvolf", "the Sockeye", "Torn-Ear", "Swiftwoda", "the Kundlu",
		"Noclicht", "the Kunda", "Long-Tooth", "the lupianowy",
	)
//Grenzelhoftian ship- Vakra's a clientstate/loosely 'governed' even before the civilwar
	ship_types = list(
		list("name" = "沿岸货船", "tonnage" = 30, "weight" = 15),
		list("name" = "柯克帆船", "tonnage" = 120, "weight" = 50),
		list("name" = "霍尔克货船", "tonnage" = 250, "weight" = 25),
		list("name" = "卡拉克帆船", "tonnage" = 500, "weight" = 10),
	)
	city_tags = list()
	city_tag_chance = 0
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_TOPER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_BLORTZ, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_DORPEL, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_JADE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_OPAL, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_ONYXA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_CERULITE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_HEARTSTONE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_AMBER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_ROSESTONE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GOLD_ORE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_STAPLE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_EAGER, "always" = TRUE),
		list("good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SILVER_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FAT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_POPPY, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CARROT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_HEALTH_POTION, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_STAPLE_DESPERATE, "always" = TRUE),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/hcake, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins/cooked/sauced, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FEAST),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pepperfish, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/peppersteak, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/menthacake, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/raisinbread, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bun_jamtallow, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/brandy),
		list("recipe" = /datum/brewing_recipe/voddena),
		list("recipe" = /datum/brewing_recipe/beer),
		list("recipe" = /datum/brewing_recipe/blackberry_wine),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/vakra/vreccale,
		/datum/supply_pack/rogue/vakra/helmet,
		/datum/supply_pack/rogue/vakra/warhammer,
		/datum/supply_pack/rogue/vakra/forlorn_hope_regalia,
		/datum/supply_pack/rogue/vakra/shield,
		/datum/supply_pack/rogue/vakra/siegebow,
		/datum/supply_pack/rogue/vakra/siegebolts,
		/datum/supply_pack/rogue/alcohol/rtoper,
	)
	hail_lines = list(
		"瓦克兰的战线时刻都在变。等我们返航，谁会占着港口根本说不准。不管是谁，都得要这些补给。",
		"战前，瓦克兰人从来看不起跑船的，叫我们水獭，对着我们的河船嗤笑、翘鼻子。现在？每次我们带着新装备返港，你绝没见过那么高兴的卢皮安。" ,
		"这里大部分货都是从某个狼群领主的地盘抢来的。他们互相劫掠，把战利品卖给我们，再买我们的补给。再过几年，瓦克兰就剩不下什么亮闪闪的东西了。",
		"打仗还买华丽裙装和花边衣服，很奇怪吧？告诉你个秘密：没人穿这些。毛皮制品会拆掉，做成盔甲的保温内衬；其他衣物改成棉甲。农民的衣服不够结实。" ,
		"有鱼吗？鱼肉当然能做干粮，可真正值钱的是鱼油，能让卢皮安的毛发浓密发亮。在瓦克兰，这是大多数人仍负担得起的少数奢侈品之一。",
		"瓦克兰的消息？每天的地盘都不一样。我能告诉你的事，离港时就过时了。想知道狼群领地发生了什么，就上船亲自看看……我是说，别真上来，我们没空位载客，不过你懂我的意思。",
		"买？卖？行不行？拿定主意，我们还得赶回战场呢。",
		"咖啡是给船员的。我们睡不了多久，干活的时辰长，航程没有哪一段真正安全。再说，鲁弗斯打鼾就像阿比索尔在做春梦……",
		"普鲁萨克人也不全坏，尽管帽子滑稽得很。至少他们让我们走他们的水道，在他们的港口卸货。可我还是怕战火蔓延到他们的地盘，到时候未必还这么欢迎我们。",
		"你好啊！今天这位沾了点海盐的老卢皮安能为你做些什么？",
		)
