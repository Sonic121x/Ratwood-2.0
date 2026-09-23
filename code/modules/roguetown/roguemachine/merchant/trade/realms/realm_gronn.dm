/datum/foreign_realm/gronn
	id = REALM_GRONN
	name = "格隆恩"
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_HEAVY, NAVIGATOR_BUCKET_POTTERY, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_MISCELLANEOUS)
	ship_name_words = list(
		"Fjord", "Iskarn", "Volf", "Beorn", "Ravn",
		"Skuld", "Storm", "Aurora", "Glacier", "Ulfr",
		"Drage", "Frosti", "Hrim", "Norn", "Saiga",
	)
	captain_first_names = list(
		"Oarri", "Niillas", "Aslak", "Mikkel", "Ánte",
		"Heaika", "Sammol", "Ivvár", "Biera", "Hánsa",
		"Risten", "Máret", "Elle", "Sárá", "Inga",
	)
	captain_last_names = list(
		"Iskarn", "Volfsson", "Saigahorn", "Glacierborn", "Stormbringer",
		"Ravnstrid", "Frostbearer", "Drageaette", "Norrsker", "Hrimskogr",
	)
	ship_types = list(
		list("name" = "克纳尔货船", "tonnage" = 30, "weight" = 15),
		list("name" = "长船", "tonnage" = 80, "weight" = 30),
		list("name" = "破冰霍尔克船", "tonnage" = 200, "weight" = 30),
		list("name" = "巨型龙首船", "tonnage" = 400, "weight" = 20),
		list("name" = "芬里尔", "tonnage" = 700, "weight" = 5),
	)
	city_tags = list(
		"the Fjall", "Iskarn-By", "Volfshaven", "Saigahold",
		"Ravnskar",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_IRON_ORE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_MEAT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_PORK, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_VISCERA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_GARLICK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CALENDULA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_POPPY, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM),
		list("good" = TRADE_GOOD_BUTTER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CABBAGE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_ROCKNUT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FEAST),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/mead, "keg_mult" = 3),
		list("recipe" = /datum/brewing_recipe/spidermead),
		list("recipe" = /datum/brewing_recipe/voddena),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/food/honey,
		/datum/supply_pack/rogue/merc_weapons/beardedaxe,
		/datum/supply_pack/rogue/merc_weapons/handclaw_iron,
		/datum/supply_pack/rogue/merc_weapons/handclaw_steel,
		/datum/supply_pack/rogue/gronn/battleaxe,
		/datum/supply_pack/rogue/gronn/gronnarmor,
		/datum/supply_pack/rogue/gronn/gronnpants,
		/datum/supply_pack/rogue/gronn/gronnpantsalt,
		/datum/supply_pack/rogue/gronn/gronnglovesleather,
		/datum/supply_pack/rogue/gronn/owl_helmet,
		/datum/supply_pack/rogue/gronn/moose_hood,
		/datum/supply_pack/rogue/gronn/varangian_hauberk,
		/datum/supply_pack/rogue/gronn/shamanic_coat,
		/datum/supply_pack/rogue/gronn/kite_shield,
		/datum/supply_pack/rogue/gronn/fur_gloves,
		/datum/supply_pack/rogue/gronn/bone_gloves,
		/datum/supply_pack/rogue/gronn/beast_claws,
		/datum/supply_pack/rogue/gronn/fur_pants,
		/datum/supply_pack/rogue/gronn/leather_boots,
		/datum/supply_pack/rogue/gronn/atgervi_kit,
		/datum/supply_pack/rogue/gronn/iskarn_kit,
		/datum/supply_pack/rogue/gronn/spider_honey,
		/datum/supply_pack/rogue/gronn/cured_megafauna,
		/datum/supply_pack/rogue/gronn/gronnic_norsii_plate,
		/datum/supply_pack/rogue/gronn/gronnic_norsii_helm,
		/datum/supply_pack/rogue/gronn/gronnic_brigandine,
		/datum/supply_pack/rogue/gronn/norsii_kit,
		/datum/supply_pack/rogue/alcohol/gronnmead,
	)
	hail_lines = list(
		"南方人。兽皮、铁、毛皮。盐、煤、钢。交易很简单，别把它弄复杂。",
		"群山已经被大雪覆盖两个月了。我想在第三个月之前回家。",
		"我的船员半个月没见过太阳了。让他们待在码头，别邀请他们去内陆。",
		"兽皮我会公道地卖，狗可不卖。你们已有三个码头工人问过了。",
		"赛加堡送来了最好的铁。恭敬地收下吧。",
		"上次航行，我的货舱载着你们六个同胞回家。他们在沃尔夫斯港自由下船，还请我的船员喝了酒。这次运的是兽皮。别让你们的祭司上我的甲板，我们就能谈价钱。",
		"听说这些角在南方能卖个好价钱。你们的祭司对长这角的野兽有个特别的称呼，我们不用那个名字。买不买随你，别传教。",
		"一位伊斯卡恩萨满随我们从雪地而来。他不与人说话，也不吃东西。别靠近他——他守护的东西不喜欢南方人的目光。",
		"今季群山上空云层散开，海峡提早解冻。赶快买吧。等海峡再次封冻，我们下一艘来船就不是商船了。",
		"我的帆布下面有一尊图腾，不卖，也不给你们的教会看。若你们的治安官称之为偶像崇拜，那他一定没见过真正的寒冬。",
		"极光一路追随我们南下，船员称它为见证者。这与你们的十神无关，别带祭司来争辩。",
		"今季我们不劫掠，盟约依然有效。祈祷下一个从我们海岸来的船长也会这么说吧。",
		"我带来的蜜酒足以淹没寒冬。像个汉子一样喝，别学你们南方人那样，把它当肉汤小口抿。",
		"我的族人做梦都想吃黄油煎鲽鱼，再加点薄荷。你们叫它圣登多尔鲑鱼，听说是道奥塔瓦菜。卖给我南方的黄油、薄荷和冰镇鲽鱼，我们出价优厚。"
	)
