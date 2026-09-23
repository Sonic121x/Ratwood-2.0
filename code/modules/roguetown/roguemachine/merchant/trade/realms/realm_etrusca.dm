/datum/foreign_realm/etrusca
	id = REALM_ETRUSCA
	name = "伊特鲁斯卡"
	roll_weight = TRADE_REALM_WEIGHT_NEIGHBOR
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_HEAVY, NAVIGATOR_BUCKET_GARMENT_FINELUX, NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_VALUABLES_LOOTED, NAVIGATOR_BUCKET_CARVED, NAVIGATOR_BUCKET_TROPHIES, NAVIGATOR_BUCKET_INSTRUMENTS, NAVIGATOR_BUCKET_MISCELLANEOUS)
	ship_name_words = list(
		"Aurelia", "Mirella", "Esperanza", "Fortuna", "Vittoria",
		"Stella", "Corona", "Leone", "Tormenta", "Onore",
		"Armada", "Caravelle", "Sirena", "Falco", "Orso",
	)
	captain_first_names = list(
		"Rodrigo", "Esteban", "Lorenzo", "Diego", "Matteo",
		"Cesare", "Alvaro", "Hernando", "Salvatore", "Vincenzo",
		"Isabela", "Catalina", "Bianca", "Elena", "Lucrezia",
	)
	captain_last_names = list(
		"Zaragoza", "del Mar", "Velasquez", "Aldobrandi", "Cortes",
		"di Montecarina", "de Navarno", "Vellano", "Castellanos", "Lazaretto",
	)
	ship_types = list(
		list("name" = "卡拉维尔帆船", "tonnage" = 70, "weight" = 25),
		list("name" = "大型远洋帆船", "tonnage" = 200, "weight" = 35),
		list("name" = "卡拉克帆船", "tonnage" = 400, "weight" = 25),
		list("name" = "舰队远洋帆船", "tonnage" = 700, "weight" = 15),
	)
	name_prefixes = list(
		list("text" = "Don ", "chance" = 5, "requires_proper_name" = FALSE),
		list("text" = "Santa ", "chance" = 10),
	)
	city_tags = list(
		"Gran Zafiro", "Porto del Re", "Portosegreto", "San Vellano",
		"Santa Mirella", "Marenova", "Velasca", "Portavigna",
		"San Rodrigo", "Santa Aurelia", "Puerto Leon", "Miralago",
		"Montejaral", "Alcazora",
	)
	city_tag_chance = 35
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_FISH_FILET, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_DRIED_FISH, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_LIME, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_GARLICK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_TOMATO, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_EGGPLANT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_APPLE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_BLACKBERRY, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/tomatoplate, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meattomatoplate, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/fishtomatoplate, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/crab, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffedcheese, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/ccake, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/cheesebun, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_SIMPLE),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/applebread, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/beer, "keg_mult" = 2),
		list("recipe" = /datum/brewing_recipe/brandy/plum),
		list("recipe" = /datum/brewing_recipe/brandy),
		list("recipe" = /datum/brewing_recipe/rum),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/coral,
		/datum/supply_pack/rogue/gems/rose,
		/datum/supply_pack/rogue/merc_weapons/erapier,
		/datum/supply_pack/rogue/merc_weapons/navaja,
		/datum/supply_pack/rogue/merc_weapons/saildagger,
		/datum/supply_pack/rogue/etrusca/falchion,
		/datum/supply_pack/rogue/etrusca/crossbow,
		/datum/supply_pack/rogue/etrusca/heavy_bolts,
		/datum/supply_pack/rogue/etrusca/pike,
		/datum/supply_pack/rogue/etrusca/etruscan_bascinet,
		/datum/supply_pack/rogue/etrusca/condottieri_kit,
		/datum/supply_pack/rogue/etrusca/vaquero_kit,
		/datum/supply_pack/rogue/etrusca/jamon,
		/datum/supply_pack/rogue/etrusca/coppiette,
		/datum/supply_pack/rogue/etrusca/salami,
		/datum/supply_pack/rogue/etrusca/cheese,
		/datum/supply_pack/rogue/etrusca/vaquero_ring,
		/datum/supply_pack/rogue/alcohol/winevalorred,
		/datum/supply_pack/rogue/alcohol/winevalorwhite,
		/datum/supply_pack/rogue/alcohol/beer,
	)
	hail_lines = list(
		"啊，终于到了这传说中的海岸！劳驾，叫税吏们准备好——日头一高，我可就没什么耐心了。",
		"以阿比索尔之名，我们闯过两场风暴才到这个码头。希望你的钱袋和我的货舱一样宽敞。",
		"先生，向你问好。我的酒是普赛多尼亚最好的，我也吩咐过船员别往你们的石板上吐痰。可别给他们找理由。",
		"自离开王港，随船祭司每个太阳日都讲道。拉沃克斯在这舷梯旁看顾公平的秤——记住这点。",
		"大萨菲罗带着萨拉戈萨家族的印信送来问候，我的货舱则送来柠檬。两样都请恭敬收下。",
		"先生，我从南方岛屿来——生在蒙特卡里纳，受训于海军，可不是走私犯。若有纳瓦诺的亲戚靠港后胡说，别信他们。",
		"打开拦港链，让公证人到舷梯来。我拿钱币交易，不收承诺——异教的诱惑毁掉过比你们更清白的财务官。",
		"你好。我有足够多的柠檬压下你们的热病，也有足够多的盐埋掉你们的死者——先要哪一样？",
		"我表亲去年春天跑这条航线，收的却是被剪过边的钱币。我会逐枚称重。",
		"蒙特哈拉尔山地的一位牧牛骑手与我们同行，他刚完成海外雇约归来。王室叫他亡命徒，我祖父叫他亲人。按后者待他，我们便相安无事。",
		"我载着一位佣兵队长，他要去奥塔瓦卖剑效力。他的武器已收好，弩已上油；到港之前，军饷不关我们的事。",
		"渡海很顺遂，听说商行管事却不怎么和善。来看看这两句话是否都属实。",
		"船上一位祭司坚称，我们驶过荒凉海岸时船首像流下了血泪。我把他锁在货舱了。赶紧买，好让我在其他船员胡思乱想前起航。",
		"我的远房表弟费德里科随货而来。怎么说呢，他认识一些人，正规渠道不方便时，能在王港和你们的金面之间又快又悄悄地搬运货物。他收费不高，记性更短。先生，找他时叫名字，别提行当。",
	)
