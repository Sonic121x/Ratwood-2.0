/datum/foreign_realm/naledi
	id = REALM_NALEDI
	name = "纳莱迪"
	roll_weight = TRADE_REALM_WEIGHT_DISTANT
	demanded_categories = list(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_LIGHT, NAVIGATOR_BUCKET_GARMENT_COMMON, NAVIGATOR_BUCKET_ENCHANTMENTS, NAVIGATOR_BUCKET_SEAFOOD, NAVIGATOR_BUCKET_TROPHIES, NAVIGATOR_BUCKET_VALUABLES_LOOTED, NAVIGATOR_BUCKET_MISCELLANEOUS)
	ship_name_words = list(
		"Psydon", "Bilomari", "Veralun", "Olindar", "Veranda",
		"Repentance", "Mercy", "Vigil", "Pilgrim", "Endurance",
		"Bluebell", "Ocotillo", "Lily", "Ember", "Lantern",
	)
	captain_first_names = list(
		"Arindele", "Nasir", "Tariq", "Yusuf", "Kamau",
		"Jelani", "Hamadi", "Bashir", "Faraj", "Idris",
		"Amalara", "Selima", "Yusra", "Amara", "Nadira",
	)
	captain_last_names = list(
		"Arivale", "Ndalasi", "al-Veranda", "Bilomari", "Olindari",
		"Kamenji", "Ravalan", "Tessanda", "ibn-Asari", "Veshani",
	)
	ship_types = list(
		list("name" = "三角帆船", "tonnage" = 60, "weight" = 30),
		list("name" = "巴格拉商船", "tonnage" = 180, "weight" = 35),
		list("name" = "沙海桨帆船", "tonnage" = 350, "weight" = 20),
		list("name" = "镀金卡拉克帆船", "tonnage" = 600, "weight" = 15),
	)
	name_prefixes = list(
		list("text" = "Shah ", "chance" = 8),
		list("text" = "the ", "chance" = 10),
	)
	city_tags = list(
		"Veralun", "Olindar", "Veranda", "the Glass Dunes",
	)
	city_tag_chance = 35
	cultural_goods = list()
	bulk_supply_pool_base = list(
		list("good" = TRADE_GOOD_GOLD_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_GLASS_BATCH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_GOLD_ORE, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_CINNABAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DISCOUNT, "always" = TRUE),
		list("good" = TRADE_GOOD_TOPER, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
		list("good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_BLORTZ, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_FAIR),
	)
	bulk_demand_pool_base = list(
		list("good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE, "always" = TRUE),
		list("good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_STONE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_TIN_ORE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_COPPER_ORE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_TALLOW, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM),
		list("good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_STAPLE_PREMIUM),
		list("good" = TRADE_GOOD_SALUMOI, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_HIDE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("good" = TRADE_GOOD_CALENDULA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_PREMIUM, "always" = TRUE),
		list("good" = TRADE_GOOD_TURNIP, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_FAIR),
		list("good" = TRADE_GOOD_PEAR, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
		list("good" = TRADE_GOOD_RASPBERRY, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)
	victualling_fresh_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_LUXURY),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/pepperfish, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/wienercabbage, "qty_min" = VICTUALLING_QTY_MEDIUM_MIN, "qty_max" = VICTUALLING_QTY_MEDIUM_MAX, "price" = VICTUALLING_PRICE_FISH),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/frybread, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/preserved/eggplantstuffed, "qty_min" = VICTUALLING_QTY_SMALL_MIN, "qty_max" = VICTUALLING_QTY_SMALL_MAX, "price" = VICTUALLING_PRICE_FISH),
	)
	victualling_preserved_pool = list(
		list("typepath" = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked, "qty_min" = VICTUALLING_QTY_HUGE_MIN, "qty_max" = VICTUALLING_QTY_HUGE_MAX, "price" = VICTUALLING_PRICE_HARDTACK),
		list("typepath" = /obj/item/reagent_containers/food/snacks/roastseeds, "qty_min" = VICTUALLING_QTY_LARGE_MIN, "qty_max" = VICTUALLING_QTY_LARGE_MAX, "price" = VICTUALLING_PRICE_BREAD),
	)
	victualling_drinks_pool = list(
		list("recipe" = /datum/brewing_recipe/tangerine_wine),
		list("recipe" = /datum/brewing_recipe/golden_calendula_tea),
		list("recipe" = /datum/brewing_recipe/soothing_valerian_tea),
	)
	cultural_stock_pool = list(
		/datum/supply_pack/rogue/gems/turq,
		/datum/supply_pack/rogue/gems/amethyst,
		/datum/supply_pack/rogue/food/pepper,
		/datum/supply_pack/rogue/merc_weapons/shamshir,
		/datum/supply_pack/rogue/merc_weapons/naledistaff,
		/datum/supply_pack/rogue/steel_weapons/katar,
		/datum/supply_pack/rogue/naledi/hierophant_kit,
		/datum/supply_pack/rogue/naledi/pontifex_kit,
		/datum/supply_pack/rogue/naledi/psicross,
		/datum/supply_pack/rogue/naledi/lordmask,
		/datum/supply_pack/rogue/naledi/pashmina,
		/datum/supply_pack/rogue/naledi/hierophantshawl,
		/datum/supply_pack/rogue/naledi/naleditrou,
		/datum/supply_pack/rogue/naledi/naledigamba,
		/datum/supply_pack/rogue/naledi/sandals,
		/datum/supply_pack/rogue/naledi/treatise,
		/datum/supply_pack/rogue/naledi/glassen_decanters,
		/datum/supply_pack/rogue/naledi/glass_statue,
		/datum/supply_pack/rogue/naledi/gold_finery,
	)
	hail_lines = list(
		"愿公司平安。纳莱迪以普赛顿之名，向商行管事致以诚信商家之间应有的敬意。",
		"我带来了沙丘的玻璃、维兰达的黄金，以及普赛多尼亚最好的咖啡和茶叶。我们对铁的渴求，任何商队都无法满足。",
		"每次卖给你们普赛多尼亚最好的咖啡和茶叶，总有个码头工人请我们喝酒。须知我们纳莱迪人不沉迷烈酒，也不将它带入宫廷，此戒恪守不渝。说起来，你手头可巧有些风郡梅酒？",
		"我们知道，你们容许提夫林和哥布林混居在人群中，却又每天与他们厮杀，杀掉成百上千。别带他们靠近码头——我的船员可能会突然想起战学士的传承。",
		"管事，与我的船员说话时，别指着他们。那很无礼，而灯灵侵蚀一个人的举止，总是先从无礼开始。",
		"别拿黄金作礼物，我们挖出的黄金连大名们都吞不下。带来异域香料、沙丘里没有的矿石，否则就什么也别带。",
		"阿斯特拉塔注视之下，我的秤绝无虚假——你们称她为女神，我们视她为祂的一种化身。尽管检查，愿意的话再检查一次。",
		"我持阿玛拉女王亲授的王室许可出航。船首上的印记就是她的，请像尊重你们自己的女公爵一样尊重它。",
		"我的两位乘客从头到脚都罩着面纱，他们是从奥塔瓦各家族归来的战学士。别搭话，别盯着看。他们每人杀过三十多个灯灵，即便在友善的码头，也不会放下警戒。",
		"我的货舱散发着沙子与木槿的味道，这两样我都不打算道歉。价钱公道，我离港前可以请你喝一杯后者。",
		"我的甲板上不会有十神祭司布道。若你想带他们的徽记上船，请留在舷梯处——船员不会准许，我也不会。",
		"我的舵手是效忠王室的比拉马克，海外服役后正要归乡。他的弯刀裹在镀金丝绸中，别逼他拔刀。我保证，他的刀舞得比你的眼睛还快。",
		"阿里索尔的沙暴封住了南方三个关口。我的航路比上季多花了三十天。费用应当反映沙丘的脾气，而不是我的。",
		"管事，我们是好客的民族。诚心求取的人，我们愿与之分享面包和茶。但我们不会与前来改变我们信仰的人共处一廷。敞开做生意，敞开喝茶，安静祈祷。",
		"一位游学的维齐尔学者与我同行，要到你们的公报板研究异国如何记载司法。她以知识而非钱币付账。问路时好好指引她，她会在日志里美言你们的治安官。",
		"我的祖母见过奥塔瓦远征军从沙丘归来，马鞍上挂着教宗的忏悔书。她活到一百零七岁，此后再也不信任十神祭司。这点我随她。",
		"一位奥林达家族的维齐尔学者与我同行，她刚结束在奥塔瓦修道院的授课。只需一枚泽尼，她便会诵读《忍耐论》的一段，并讲解到你听够为止。她曾在大祭司家中连续讲了九小时。付钱请教，你便会明白，为何弱者跪倒之处，战学士仍能坚持。",
		"近两个月的沙丘美不胜收，我们的建筑也壮观非凡。我想邀你游览，再把战学士的护卫服务卖给你，保护你免受沙中灯灵侵害，顺便赚上一大笔。意下如何，管事？想亲眼看看沙丘吗？",
		"奥林达又要召开战学士密会。我们纳莱迪人懂得适度享受世间欢愉，这在普赛顿的注视下也是正道。所以，给我最好的酒、最肥美多汁的海虾、龙虾和螃蟹，再来一盘最上等的奶酪。香料？不必费心，我们的举世无双，货舱里有些留给你。",
		"第二次穿越沙丘时，船医的生命之水就用完了——战学士用它灼洗伤口，而沙漠伤起人来从不手软。若你们的蒸馏师有余货，女王的医师将以洁净的缝合与安稳的康复回报你们。我们不喝它，而是将它倒在不该裂开的地方。",
	)
