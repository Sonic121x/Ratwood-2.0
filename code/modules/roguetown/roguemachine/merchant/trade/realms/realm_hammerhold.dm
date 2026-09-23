/datum/foreign_realm/hammerhold
	id = REALM_HAMMERHOLD
	name = "铁锤堡"
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	demanded_categories = list(NAVIGATOR_BUCKET_GARMENT_COMMON, NAVIGATOR_BUCKET_ARMOR_HEAVY, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_POTTERY, NAVIGATOR_BUCKET_MISCELLANEOUS)
	single_word_base = TRUE
	ship_name_words = list(
		"Æthel", "Beorht", "Hammer", "Anvil", "Grim",
		"Wulf", "Stan", "Hild", "Mæst",
		"Fyr", "Dæg", "Gold",
	)
	captain_first_names = list(
		"Wulfstan", "Godric", "Leofric", "Beorn", "Cuthwine",
		"Oswin", "Eadwulf", "Cynehelm", "Beornræd", "Deorwine",
		"Wynflæd", "Eadgyth", "Mildþryth", "Beorhtflæd", "Cyneburg",
	)
	captain_last_names = list(
		"Hammerson", "Stanforge", "Grimaxe", "Coldhammer", "Ironbeard",
		"Ætheling", "Wulfing", "se Reada", "Eorling", "Stoneward",
	)
	ship_types = list(
		list("name" = "克纳尔货船", "tonnage" = 25, "weight" = 10),
		list("name" = "巴林格轻帆船", "tonnage" = 50, "weight" = 25),
		list("name" = "柯克帆船", "tonnage" = 120, "weight" = 35),
		list("name" = "霍尔克货船", "tonnage" = 250, "weight" = 20),
		list("name" = "巨型帆船", "tonnage" = 700, "weight" = 10),
	)
	name_prefixes = list(
		list("text" = "Eorl ", "chance" = 4),
		list("text" = "Cyne ", "chance" = 3),
		list("text" = "the ", "chance" = 60),
	)
	city_tags = list(
		"Norwardine", "Quicksilver Hold", "Granite Fort", "Walnut Grove",
		"the Bán", "the Mountainhomes",
	)
	city_tag_chance = 30
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_COPPER_ORE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COPPER_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_STONE, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_ORE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_TOPER, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_STAPLE_EAGER, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CHEESE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_SALUMOI, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/pot, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_STEAK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/sandwich/ham, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/cheesebun, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/beer, "keg_mult" = 2),
		list("recipe" = /datum/brewing_recipe/beer/oat),
		list("recipe" = /datum/brewing_recipe/mead),
		list("recipe" = /datum/brewing_recipe/cider),
		list("recipe" = /datum/brewing_recipe/voddena),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/hammerhold/dwarven_maul,
		/datum/supply_pack/rogue/hammerhold/spiked_maul,
		/datum/supply_pack/rogue/hammerhold/longbow,
		/datum/supply_pack/rogue/hammerhold/iron_fullplate,
		/datum/supply_pack/rogue/hammerhold/snow_cloak,
		/datum/supply_pack/rogue/hammerhold/ironclad_kit,
		/datum/supply_pack/rogue/hammerhold/smoked_sausage,
		/datum/supply_pack/rogue/hammerhold/bacon,
		/datum/supply_pack/rogue/hammerhold/slayer_axe,
		/datum/supply_pack/rogue/hammerhold/slayer_greataxe,
		/datum/supply_pack/rogue/hammerhold/slayer_belt,
		/datum/supply_pack/rogue/hammerhold/dwarven_warpick,
		/datum/supply_pack/rogue/hammerhold/grudgebearer_smith_kit,
		/datum/supply_pack/rogue/hammerhold/grudgebearer_soldier_kit,
		/datum/supply_pack/rogue/alcohol/voddena,
		/datum/supply_pack/rogue/alcohol/sazdistal,
		/datum/supply_pack/rogue/alcohol/nred,
		/datum/supply_pack/rogue/alcohol/butterhair,
		/datum/supply_pack/rogue/alcohol/stonebeard,
	)
	hail_lines = list(
		"你好，商行管事。山中家园的铜，班地的石料。带来谷物、布匹和奶酪，否则别耽误我的潮汐。",
		"从诺瓦丁出发已经六个月了。六个月，商行管事。少跟我讨价还价，我也就少发脾气。",
		"你绝想不到格伦泽尔人在艾森哈芬的河闸如今收多少税。简直是拦路抢劫，只不过路在河上。我们改走海角绕行了，那样反而更便宜，半点不夸张。",
		"要么绕大陆走远路，要么交格伦泽尔霍夫特的过河费。两条路都比过去难走。我选了不用每到一处拦河链就见到他们祭司的那条。",
		"我的盐货已经腌了两个月，船员的耐心三周前就用完了。还请好好交易。",
		"两周前，我们在艾森哈芬岸边甩掉了一支格伦泽尔巡逻队。帝国称我们为强盗领主；到了这里，我们自称商人。也让你们的治安官这样称呼我们。",
		"这次航行的龙骨中回荡着水银堡的锤声——堡垒子民与人类齐心打造。靠码头时待她温柔些。",
		"听说你们的税吏称重时少算，收税时多收。咱们走着瞧。",
		"我的舵手是一位领主的指定继承人，要完成一年的历练和十次劫掠才能继承。别招惹他——阿特格维人不挑起争斗，但一定会了结争斗。",
		"感谢沉眠而将醒的普赛顿，顺风一直送我们驶过奥塔瓦的海角。我会给随船祭司赏钱，你则给我个公道价。愿今日顺遂。",
		"我带来了花岗岩堡一位灰衣守卫的消息：矮人诸王恪守旧约，今季地下深处很平静。像当年哈隆德与他们交易那样，与我们交易吧。",
		"看看我货舱的吉尔青铜配件，再说我的工匠是不是在吹牛。每块板都是诺瓦丁公会的手艺，值得我千里迢迢运到南方。",
		"港口还没疏浚的时候，我祖父就在跑这条航线了。你们的治安官打掉了他两颗牙。我是来拿回他剩下的钱的。",
		"一位班地朝圣者与我们同行。自从离开核桃林，他便一言不发。那里的森林对沉默寡言的人自有办法——别打听他的事。",
		"山中家园的路上传着一个故事：一位身披拉沃克斯板甲的人独自作战，从自己的坟墓里走了出来。船员觉得是胡说，我却没那么肯定。快付钱让我起航，免得我再胡思乱想。",
		"我的三个水手眼下烙着公牛印记，按炉火的传统，他们已获赦免。他们搬货，不偷钱。管好你们的码头工人。",
		"我在诺瓦丁的商行管事警告我，南方市场不景气。我还是来了。看看谁说得对。",
		"船上有一位阿特格维老兵，这是修道院收走他的剑之前的最后一次航行。给他三枚泽尼，他便会坐下来，为你讲述铜牛、灰衣战争，以及花岗岩堡的大门首次向人类敞开的那个夜晚的真相。他喝得比吃得多。付钱，好好听——在诺瓦丁，歌谣活在唱歌的人身上，而记得早年岁月的老人已经不多了。",
		"商行管事！给我装上满满一大桶鲟鱼和鱼子酱，要比我见过的都大！我拿最好的吉尔青铜与钢制铠甲来换！真正的铁锤堡矮人工艺，胸口能挨三发攻城弩箭。铠甲有标记，也经过检验，内侧还看得见凹痕和工匠印记。为答谢你，我再送上四瓶最好的沃德娜酒和金属锭。我的堡垒渴望最上等的南方佳肴，请尽快送来。我想起航前先尝尝。"
	)
