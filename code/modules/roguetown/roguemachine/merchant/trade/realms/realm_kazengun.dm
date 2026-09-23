/datum/foreign_realm/kazengun
	id = REALM_KAZENGUN
	name = "风郡"
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_INSTRUMENTS, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_MISCELLANEOUS)
	single_word_base = TRUE
	ship_name_words = list(
		"Tsuru", "Hayabusa", "Akatsuki", "Tsuki", "Ame",
		"Sora", "Kaze", "Yume", "Hoshi", "Suzu",
		"Sakura", "Take", "Yuki", "Nami",
	)
	captain_first_names = list(
		"Masakatsu", "Yoshitaka", "Kagetora", "Tadanaga", "Hidemori",
		"Naomasa", "Tomoe", "Kaoruko", "Chiyo", "Sen",
		"Kikyō", "Tsuneyori", "Sadanobu", "Harukage", "Yorinaga",
	)
	captain_last_names = list(
		"Niwa", "Sakuma", "Kasai", "Asakura", "Andō",
		"Kurogane", "Yamashiro", "Tsukinami", "Koganei", "Akizuki",
	)
	ship_types = list(
		list("name" = "关船", "tonnage" = 90, "weight" = 35),
		list("name" = "弁才船", "tonnage" = 120, "weight" = 40),
		list("name" = "朱印船", "tonnage" = 400, "weight" = 15),
		list("name" = "安宅船", "tonnage" = 600, "weight" = 10),
	)
	name_suffixes = list(
		list("text" = "-Maru", "chance" = 75),
	)
	city_tags = list(
		"Iwoto", "Tamiro", "Kukui", "Matsuhama", "Aisataiji",
		"Bijai", "Mitihara", "Tatseshira",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COFFEE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_CINNABAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_CLAY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_POPPY, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_POTATO, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_ONION, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_TURNIP, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/riceshrimp, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/riceshrimpcar, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/riceegg, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/ricebird, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/cod, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/plum_wine),
		list("recipe" = /datum/brewing_recipe/liquor/ricespirit),
		list("recipe" = /datum/brewing_recipe/jack_wine),
		list("recipe" = /datum/brewing_recipe/brandy),
		list("recipe" = /datum/brewing_recipe/liquor),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/jade,
		/datum/supply_pack/rogue/merc_weapons/naginata,
		/datum/supply_pack/rogue/merc_weapons/katana,

		/datum/supply_pack/rogue/kazengun/kanabo,
		/datum/supply_pack/rogue/kazengun/ssangsudo,
		/datum/supply_pack/rogue/kazengun/haraate,
		/datum/supply_pack/rogue/kazengun/mentorhat,
		/datum/supply_pack/rogue/kazengun/mask_full,
		/datum/supply_pack/rogue/kazengun/mask_half,
		/datum/supply_pack/rogue/kazengun/cloak,
		/datum/supply_pack/rogue/kazengun/captainrobe,
		/datum/supply_pack/rogue/kazengun/kote,
		/datum/supply_pack/rogue/kazengun/boots,
		/datum/supply_pack/rogue/kazengun/trousers,
		/datum/supply_pack/rogue/kazengun/kazenpants,
		/datum/supply_pack/rogue/kazengun/chonin_kit,
		/datum/supply_pack/rogue/kazengun/kouken_kit,
		/datum/supply_pack/rogue/luxury/fancyteaset,
		/datum/supply_pack/rogue/alcohol/kgunplum,
		/datum/supply_pack/rogue/alcohol/kgunsake,
	)
	hail_lines = list(
		"风郡向商行管事致意。货舱里有茶叶、丝绸和稻米。交易条件简单，礼数却不可简慢。",
		"我的船获准于塔米罗的米塔氏族。先看印章，再看货单——顺序不得颠倒。",
		"塔特希拉的町人不会像西方人那样在街头讨价还价。恭敬地报一次价，我们便能体面地成交。",
		"依艾萨塔的秩序，我的秤绝无虚假。若有必要，尽管查验。未经查验便指责，可就是另一回事了。",
		"我们渡过阿瑟迈时，海面如谚语所说般平静。你们西方的海域却没那么安宁。费用理应体现这份差别。",
		"我已告诉船员，异国的混乱与他们无关。让他们留在码头，他们就会让你们的码头工人继续喘气。",
		"船上有一名在海外服役后归来的寇肯。自驶离库奎，他就一言不发。别跟他搭话——他是我的客人，不是你家的客人。",
		"艾萨塔从东方升起，落于你们奥塔瓦的海角之外。我追随她的道路，去程一月，归程一月，两程都得有所值。",
		"去程时，我们在米提原外海遭遇台风——距上次台风已有十年，那座城仍在重建。我们带来了抢救下来的货物，请给个公道价。",
		"玛穆克的铁，玛托科的钱币。这场交易已受祝福，别让拖延给它招来诅咒。",
		"我那位来自艾萨太寺的乘客持着寺院的印信。他会上岸，缴清港口费，在钟响前离去。你就当从未见过他。",
		"货舱里有一只由月田氏族封印的漆箱。不卖，不接受检查，也不供你们的治安官满足好奇。交易公开的货物，其他的别管。",
		"我祖父十八岁时与你们的管事签下第一份盟约。我今年四十三，来此履约。莫要辜负我们两代人的岁月。",
		"听说南方领地有个背负耻辱的叛逆在你们街上卖剑为生。管事，若见到他，别给他吃的——蒙羞者该以耻辱为食，而非你们的面包。",
		"我的丝绸出自塔米罗本土的织机，不是大陆仿品。付清差价，手一摸你就知道值不值。",
		"家乡的关税没有商量余地。我相信你们的更讲情面，证明给我看吧。",
		"我的茶师来自艾萨太寺，在山麓的寺院受艺。只要一枚泽尼，他便会演示静若阿瑟迈的茶仪：三个小时，全程无声，用上群岛的七种茶叶。他曾拒绝比你们富裕的氏族，随我出海，只为传授我们的古老技艺。帮一位老人、老艺师一个忙，付钱请他演示，并将他的技艺记入日志。",
		"交易前问一句：阿洛西俄斯是谁，你们的人为何总去盗他的墓？",
		"久闻此地鱼鲜盛名。又大！又长！肥美多汁，鲜味十足。我们有信义符文箱，足以保鲜运回家。叫来最好的渔夫，给鳕鱼、鲑鱼和螃蟹报个最好的价。我要贵的、真正上等的货，不要廉价货，它们不配占我的船舱。请别像上一个管事那样，拿便宜鱼来以次充好。我们风郡人识货，休想骗我。",
	)
