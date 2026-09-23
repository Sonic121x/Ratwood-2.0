//ships from the underdark- made their from the caverns through natural rivers and sluices. Trade from Mercuriam, kobolds and drow in the caverns
/datum/foreign_realm/underdark
	id = REALM_UNDERDARK
	name = "幽暗地域"
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_LIGHT, NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_POTIONS_REAGENTS, NAVIGATOR_BUCKET_ENCHANTMENTS, NAVIGATOR_BUCKET_INSTRUMENTS, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_MISCELLANEOUS)
	single_word_base = TRUE
	ship_name_words = list(
		"Duskfang", "Gloomroot", "Emberweb", "Nightspire", "Chitinfall",
		"Voidcarve", "Ashwick", "Hollowfen", "Cinderweb", "Grimtide",
		"Bonelight", "Shadowspur", "Fungalreach", "Mirewake", "Deepglass",
	)
	captain_first_names = list(
		"Xylvaeth", "Serathil", "Nyxandra", "Veshtal", "Ilyndra",
		"Threnos", "Saevrin", "Mordeth", "Quilara", "Zyrenne",
		"Orruth", "Kaelith", "Vantrys", "Aelune", "Draskiel",
	)
	captain_last_names = list(
		"Ixar", "Sevari", "Naxir", "Ghaun", "Ssarn",
		"Draeth", "Kaelis", "Orryn", "Vhoral", "Myrren",
	)
	ship_types = list(
		list("name" = "甲壳轻舟", "tonnage" = 80, "weight" = 20),
		list("name" = "黑曜石桨帆船", "tonnage" = 200, "weight" = 30),
		list("name" = "骸骨无畏舰", "tonnage" = 800, "weight" = 30),
	)
	city_tags = list()
	city_tag_chance = 0
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_HONEY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_ANTIDOTE_POTION, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_MUSHROOM,"qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_MEAT_EXOTIC, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_HEALTH_POTION, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_DENDOR_ESSENCE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CLAY, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_ENCHSCROLL_BASIC, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_BRONZE_PROSTHETIC, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_ONYXA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_ROCKNUT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/ricepork, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/cookieslicer, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/cookieslicec, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/spider, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/plum_wine),
		list("recipe" = /datum/brewing_recipe/liquor),
		list("recipe" = /datum/brewing_recipe/luxintenebre),
		list("recipe" = /datum/brewing_recipe/rum),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/onyxa,
		/datum/supply_pack/rogue/food/pepper,
		/datum/supply_pack/rogue/underdark/saber,
		/datum/supply_pack/rogue/underdark/dagger,
		/datum/supply_pack/rogue/underdark/slurbow,
		/datum/supply_pack/rogue/underdark/fangeddagger,
		/datum/supply_pack/rogue/underdark/poisondagger,
		/datum/supply_pack/rogue/underdark/restrainpoison,
		/datum/supply_pack/rogue/underdark/killerpoison,
		/datum/supply_pack/rogue/underdark/antidote,
		/datum/supply_pack/rogue/underdark/crocs,
		/datum/supply_pack/rogue/luxury/fancyteaset,
		/datum/supply_pack/rogue/alcohol/elfblue,
	)
	hail_lines = list(
		"深廷的伊克萨尔家族向你问好。我的货单以甲壳蜡封缄。尊重封印，我们便能体面成交，日光下的居民。",
		"蛛丝、洞穴菌菇和蛛蜜，分量合法；另有少量黑曜石和精炼矿石。该检查的尽管查——我的记账奴所记皆实。",
		"船壳上刻着深廷的印记。船员中还能见到一些次等徽记，狗头人氏族喜欢我们承认他们的地位。先承认我的。",
		"离地表出口还有三条隧道时，我们遇上酸河暴涨，据说吞掉下层市场的也是这场洪水。普赛顿赐的好运在下面可不多。给这些运到你面前的货物一个公道价。",
		"凭血统与刀剑之权，我代表塞瓦里家族。九位主母签署了我的特许状。我既没时间，也没兴趣奉陪你们地表人的讨价还价。",
		"我的附魔卷轴锁在三把锁和一道咒符之下。买不买随你，但别要求验货。普赛顿看着呢。",
		"我的乘客是践行伊欧拉普世慈悲的游魂。他以善行与功德抵船费，不用钱币。像对待任何神圣乞者那样关照他，我就是如此。",
		"记住，我流着伊克萨尔的血。这名字在地下仍能约束各家族，即便东部巢穴想让人们忘记它。与我的家族交易，别与牵着它缰绳的东西交易。",
		"尚未浮出地表时，货舱中的一名记账奴便梦见了这座港口。她喊出了港务长出生时的名字。深廷会记录每一句话——我想尽快办完。",
		"有位乘客穿着骨白丝衣，以黑曜石原矿付账，不吃也不睡。船员觉得她是内克拉的众多化身之一。先收她的钱。",
		"日光下的居民，盘在我船首的洞穴蝰蛇可不是宠物。她自食其力，也守口如瓶。别让你们的祭司盯太久，她一个都不喜欢。",
		"我的主母的主母，在大分裂前便侍奉旧深廷。我们熬过了三次崩塌和一次洪灾。你们地表的公国，还不足以让我惊叹。",,
		"我载着一位来自墨丘利安的弗卢维安掮客，满身鳃裂，彬彬有礼，买卖的却是不该越过流水的东西。付钱，别问问题——河流会记住那些问题。",	)
