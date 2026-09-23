/datum/foreign_realm/otava
	id = REALM_OTAVA
	name = "奥塔瓦"
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	demanded_categories = list(NAVIGATOR_BUCKET_POTIONS_REAGENTS, NAVIGATOR_BUCKET_INSTRUMENTS, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_VALUABLES_LOOTED, NAVIGATOR_BUCKET_CARVED, NAVIGATOR_BUCKET_TROPHIES, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_MISCELLANEOUS)
	single_word_base = TRUE
	ship_name_words = list(
		"Belle", "Coeur", "Lis", "Rose", "Etoile",
		"Faucon", "Lion", "Couronne", "Dame", "Chevalier",
		"Aurore", "Soleil", "Fleur", "Vent", "Vague",
	)
	proper_names = list(
		list("name" = "Astrata", "gender" = "f"),
		list("name" = "Eora", "gender" = "f"),
		list("name" = "Necra", "gender" = "f"),
		list("name" = "Pestra", "gender" = "f"),
		list("name" = "Noc", "gender" = "m"),
		list("name" = "Abyssor", "gender" = "m"),
		list("name" = "Ravox", "gender" = "m"),
		list("name" = "Malum", "gender" = "m"),
	)
	captain_first_names = list(
		"Henri", "Guillaume", "Charles", "Robert", "Aimery",
		"Jehan", "Thibault", "Gace", "Hugues", "Renaud",
		"Mahaut", "Jehanne", "Alix", "Aelis", "Sybille",
	)
	captain_last_names = list(
		"Lefèvre", "Fournier", "Mercier", "Tisserand", "Chevalier",
		"d'Esperance", "Bouchard", "Chastain", "Marchand", "le Vallouisard",
	)
	ship_types = list(
		list("name" = "卡拉维尔帆船", "tonnage" = 70, "weight" = 20),
		list("name" = "桨帆船", "tonnage" = 100, "weight" = 15),
		list("name" = "内夫帆船", "tonnage" = 130, "weight" = 35),
		list("name" = "大型桨帆船", "tonnage" = 300, "weight" = 20),
		list("name" = "大型远洋帆船", "tonnage" = 600, "weight" = 10),
	)
	name_prefixes = list(
		list(
			"text_male" = "Saint-",
			"text_female" = "Sainte-",
			"chance" = 55,
			"requires_proper_name" = TRUE,
		),
		list("text_female" = "Notre-Dame de ", "chance" = 10, "requires_proper_name" = TRUE),
	)
	city_tags = list(
		"Esperance-Capitale", "Vallouise-sur-Mer", "Falaises-Rouges", "Verquent", "Noireau",
		"Vates", "Atagne", "Pais-Occitanie", "Lasquennes",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_CHEESE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_DRIED_FISH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_COD, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_STRAWBERRY, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_PLUM, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_FAIR, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CABBAGE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_PEAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_BUTTER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/peppersteak, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FEAST),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FEAST),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/apple, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/buttersole, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/applecake, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/bun_raston, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/jack_wine),
		list("recipe" = /datum/brewing_recipe/cider),
		list("recipe" = /datum/brewing_recipe/aqua_vitae),
		list("recipe" = /datum/brewing_recipe/brandy/pear),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/amber,
		/datum/supply_pack/rogue/gems/rose,
		/datum/supply_pack/rogue/food/rosa,
		/datum/supply_pack/rogue/otava/morningstar,
		/datum/supply_pack/rogue/otava/lance,
		/datum/supply_pack/rogue/otava/falchion,
		/datum/supply_pack/rogue/otava/lucerne,
		/datum/supply_pack/rogue/otava/half_plate,
		/datum/supply_pack/rogue/otava/full_plate,
		/datum/supply_pack/rogue/otava/heavy_gambeson,
		/datum/supply_pack/rogue/otava/klappvisier,
		/datum/supply_pack/rogue/otava/gloves,
		/datum/supply_pack/rogue/otava/boots,
		/datum/supply_pack/rogue/otava/trousers,
		/datum/supply_pack/rogue/otava/satchel,
		/datum/supply_pack/rogue/otava/chevalier_kit,
		/datum/supply_pack/rogue/otava/sergent_kit,
		/datum/supply_pack/rogue/otava/cheese,
		/datum/supply_pack/rogue/alcohol/winevalorred,
		/datum/supply_pack/rogue/alcohol/winevalorwhite,
	)
	hail_lines = list(
		"向你致意，商行管事。诚实的秤由圣阿斯特拉塔看顾，弄虚作假的则归圣内克拉——选择权在你。",
		"我们在天上的神啊，请拯救他们。渡海顺利，风也虔诚，随船祭司晕船都比平时轻了些。阿亚特。",
		"以十神之名，凭埃斯佩朗斯首都最高议会的文书，我来此交易。我的酒出自奥克西塔尼地区，别用低价侮辱它。",
		"先生，我不是海盗。我有文书、有随船祭司，在韦尔康还有配偶——这三样里最后一样最费钱。",
		"红崖的奶酪、湖谷的美酒、滨海瓦卢伊兹的熏鱼。协议赋予我让这三样货物都卖出公道价的权利，请照价付款。",
		"把铁和兽皮拿出来。我的货舱有空，我的钱袋有钱，而潮汐可不会等我们客套。",
		"出发时，夕阳将红崖染得通红。随船祭司说那是征兆，却不肯解读。我没再问。",
		"两年前的夏天，我表亲的船毁在你们的暗礁上。我带了圣内克拉的信物，要在系缆前投入港中。别介意，这是习俗。",
		"感谢圣阿比索尔，风是仁慈的。看看你们的王室关税是否也一样。",
		"我的舵手在地方军服役三年，才转行做正经买卖。他有圣人的耐心，也有赛加羚羊骑枪兵的脾气——只管试探前者就好。",
		"管事，审判庭在王田城外设有办事处。我不属于他们的分队，但他们的审判官认识我。公平交易吧，消息传回奥塔瓦，和我的船一样快。",
		"我驶过从瓦特斯通往兹班图沙丘的朝圣之路。三位祭司在韦尔康上船，又在穆杰夫卡赫尔下船，没一个跟我说话。圣职者就是这样。",
		"只需三枚泽尼，我的佣兵下士就能护送你的货物从舷梯到仓库，有文书担保，也有努瓦罗红衣祭司的祝福。他是连队最后的幸存者，其余人都倒在奥克西塔尼的战火中。趁他还没到韦尔康领退休金、把剑挂上修道院墙壁再不使用，雇下他吧。",
		"有位奥克西塔尼来的乘客，自看见你们的悬崖起便一直盯着同一片水面。快带他上岸，我可不想让他死在我的船舱里。",
		"一位戴面具的告解师从瓦卢伊兹与我同行。我什么也没问；他付清船费，天刚亮便一言不发地下了船。我把这笔船费记为‘未指明货物’，相信你也会这样登记他的行程。",
		"给奥塔瓦审判庭和王室准备白葡萄酒烩鳎鱼。别讨价还价，管事。"
	)
