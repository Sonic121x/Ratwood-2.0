/datum/realm_condition/aavnr_border_skirmish
	id = "aavnr_border_skirmish"
	name = "边境冲突"
	description = "阿瓦尔边境附近的一个行省发生了小规模冲突。虽尚未升级为全面战争，粮食贸易却已受阻，牲畜被宰杀以供应军需。兽皮价格低廉，铁锭价格则不断上涨。"
	weight = 10
	affected_realms = list(REALM_AAVNR)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_HIDE, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GRAIN, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/aavnr_steppe_drought
	id = "aavnr_steppe_drought"
	name = "草原旱灾"
	description = "草原化为尘土，粮田绝收，牧群被宰杀以榨取最后的价值。君王的使者向外国商队乞求每一袋谷物或燕麦，宰杀所得的兽皮则被廉价抛售。"
	weight = 8
	affected_realms = list(REALM_AAVNR)
	supply_modifiers = list(
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_GRAIN),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_HIDE, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/aavnr_trade_fair
	id = "aavnr_trade_fair"
	name = "贸易盛会"
	description = "阿瓦尔腹地正在举办盛大的贸易集市。全国商人汇聚于此，展示最好的商品，吸引买家与卖家纷至沓来。兽皮价格下降，市场上还出现了独特商品。"
	weight = 6
	affected_realms = list(REALM_AAVNR)
	// TODO(cultural stock step): cultural_modifiers deferred - referenced /datum/supply_pack/rogue/aavnr/* typepaths not yet ported.
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_HIDE, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SUGAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/etrusca_civil_war
	id = "etrusca_civil_war"
	name = "内战"
	description = "两个贵族家族为争夺伊特鲁斯卡的控制权，陷入惨烈内战。冲突破坏贸易，引发广泛动荡，使基础金属需求激增，而当地著名水果与盐等奢侈品的行情下滑。"
	weight = 8
	affected_realms = list(REALM_ETRUSCA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SALT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_LEMON, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TANGERINE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_STEEL_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)
	// TODO(cultural stock step): cultural_modifiers deferred - referenced /datum/supply_pack/rogue/etrusca/vaquero_kit not yet ported.

/datum/realm_condition/etrusca_gronnic_raid
	id = "etrusca_gronnic_raid"
	name = "征讨格隆恩"
	description = "伊特鲁斯卡人民再也无法忍受无休止的劫掠，其传奇舰队已奉命袭击并焚毁格隆恩的沿海城市。食物与水果日渐稀缺，随着战事扩大，木材、兽皮和铁的需求猛增。"
	weight = 8
	affected_realms = list(REALM_ETRUSCA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_LEMON, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TANGERINE, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_FISH_FILET, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/etrusca_harvest_festival
	id = "etrusca_harvest_festival"
	name = "丰收庆典"
	description = "纪念阿斯特拉塔、登多尔和伊欧拉的丰收庆典正在举行。大量水果与酒类出口，用于节庆服装、装扮及传统赠礼的丝绸和毛皮则需求旺盛。"
	weight = 10
	affected_realms = list(REALM_ETRUSCA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TOMATO, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GARLICK, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_EGGPLANT, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	// TODO(cultural stock step): cultural_modifiers deferred - referenced /datum/supply_pack/rogue/{alcohol/limoncello,etrusca/jamon,etrusca/cheese} not yet ported.
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/grenzelhoft_mage_purge
	id = "grenzelhoft_mage_purge"
	name = "法师清洗"
	description = "皇帝的法师团要求扫除未登记的施法者，教廷以烈火回应。没收的法杖和法师斗篷涌入市场，宫廷则减少丝绸装饰以显得朴素。皮革供不应求，价格高昂。"
	weight = 8
	affected_realms = list(REALM_GRENZELHOFT)
	// TODO(cultural stock step): cultural_modifiers deferred - referenced /datum/supply_pack/rogue/{merc_weapons/grenzelstaff,grenzelhoft/magos_mantle,grenzelhoft/blacksteel_cuirass} not yet ported.
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/grenzelhoft_grain_boom
	id = "grenzelhoft_grain_boom"
	name = "粮食丰产"
	description = "格伦泽尔霍夫特喜获丰收，谷物和燕麦供过于求，主粮价格暴跌。民众趁着农业丰裕，纷纷缝制、购买新衣，纤维需求因此激增。"
	weight = 10
	affected_realms = list(REALM_GRENZELHOFT)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GRAIN, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_OATS, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/grenzelhoft_holy_pilgrimage
	id = "grenzelhoft_holy_pilgrimage"
	name = "神圣朝圣"
	description = "来自十一座大教堂的盛大队伍蜿蜒穿过内陆诸省。朝圣者需要橘子与糖作为供品，还需要蓝晶，装饰教廷为此次盛事镀金的圣物匣。"
	weight = 6
	affected_realms = list(REALM_GRENZELHOFT)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TANGERINE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SUGAR, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DESPERATE),
	)

/datum/realm_condition/gronn_raid_season
	id = "gronn_raid_season"
	name = "劫掠季"
	description = "长船从南方海岸满载战利品归来。铁、毛皮和劫来的奢侈品在沃尔夫斯港码头廉价出售。为下一次航行备货的船员愿出高价购买盐与熟皮。"
	weight = 12
	affected_realms = list(REALM_GRONN)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_FUR, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DISCOUNT),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SALT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/gronn_long_winter
	id = "gronn_long_winter"
	name = "漫长寒冬"
	description = "群山已被大雪覆盖三个月，海峡也提早封冻。人们囤积兽皮御寒，各堡垒不惜任何价格求购粮食，煤炭则贵如同重的白银。"
	weight = 8
	affected_realms = list(REALM_GRONN)
	supply_modifiers = list(
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_HIDE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_COAL, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
	)

/datum/realm_condition/gronn_great_hunt
	id = "gronn_great_hunt"
	name = "大狩猎"
	description = "大批猎物从北方迁来。伊斯卡恩猎人带回的兽皮与肉，多到全国的盐都不够腌制。氏族首领为宴会求购南方丝绸。"
	weight = 6
	affected_realms = list(REALM_GRONN)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_HIDE, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_MEAT, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_FUR, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/hammerhold_dwarf_strike
	id = "hammerhold_dwarf_strike"
	name = "矮人罢工"
	description = "山中家园因一场祖辈纷争关闭了大门。地表的铜、石料与锻造品供应告急。诺瓦丁的铁匠愿高价收购成品钢材与南方木材，以弥补缺口。"
	weight = 8
	affected_realms = list(REALM_HAMMERHOLD)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_COPPER_ORE, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_VERY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_COPPER_INGOT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_VERY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_STONE, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)

/datum/realm_condition/hammerhold_brigand_uprising
	id = "hammerhold_brigand_uprising"
	name = "匪徒暴乱"
	description = "巴纳的边境领主未尽守土之责，匪帮从花岗岩山口南下。毛皮难觅，诺瓦丁正高价收购布匹、谷物与熟皮，为清剿行动备足物资。"
	weight = 8
	affected_realms = list(REALM_HAMMERHOLD)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_FUR, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CLOTH, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GRAIN, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/hammerhold_royal_wedding
	id = "hammerhold_royal_wedding"
	name = "王室婚礼"
	description = "哈隆德的一位继承人即将成婚，诺瓦丁筹备着足以让一代人铭记的盛宴。熏香肠与培根充斥市场，丝绸、柑橘和蓝晶则因赠礼需求而热销。"
	weight = 5
	affected_realms = list(REALM_HAMMERHOLD)
	// TODO(cultural stock step): cultural_modifiers deferred - referenced /datum/supply_pack/rogue/hammerhold/{smoked_sausage,bacon} not yet ported.
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TANGERINE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_LEMON, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/kazengun_rebellion
	id = "kazengun_rebellion"
	name = "叛逆起兵"
	description = "一名叛逆头领在南方本土岛屿举旗起兵。稻米停止出口，丝绸贸易受限。朝廷不惜代价订购铁、煤炭与熟皮，为效忠的大名配备军资。"
	weight = 8
	affected_realms = list(REALM_KAZENGUN)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_RICE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_COAL, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/kazengun_mainland_expedition
	id = "kazengun_mainland_expedition"
	name = "大陆远征"
	description = "各氏族已向大陆派兵。军队装备急需熟皮与布匹，收购价高昂；南方航路被征用，茶叶出口也因此放缓。"
	weight = 8
	affected_realms = list(REALM_KAZENGUN)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CURED_LEATHER, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CLOTH, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TEA, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)

/datum/realm_condition/kazengun_imperial_gala
	id = "kazengun_imperial_gala"
	name = "皇都盛宴"
	description = "都城举办持续七夜的盛宴。茶商与丝商降价讨好来访大名，月田氏族也向市场开放衣库。朝廷为蓝晶和上等北方毛皮备下了丰厚款项。"
	weight = 5
	affected_realms = list(REALM_KAZENGUN)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TEA, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	// TODO(cultural stock step): cultural_modifiers deferred - referenced /datum/supply_pack/rogue/{luxury/fancyteaset,kazengun/captainrobe,kazengun/chonin_kit} not yet ported.
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_FUR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/pui_maen_uprising
	id = "pui-maen_uprising"
	name = "普伊-梅恩起义"
	description = "普伊-梅恩叛军渡过了炎蛇河，信义腹地燃起战火。信义朝廷动员反击，宗主风郡则从群岛向大陆军队增援；两国都为筹集军需而搜尽市场物资。"
	weight = 12
	cross_realm = TRUE
	affected_realms = list(REALM_KAZENGUN)
	per_realm_modifiers = list(
		REALM_KAZENGUN = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TEA, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
			),
			"demand" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CURED_LEATHER, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_RICE, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
		),
	)

/datum/realm_condition/underdark_enchanting
	id = "underdark_enchanting"
	name = "至耀之光附魔"
	description = "神秘的弗卢维安城邦墨丘利安正在招募附魔师，为其人造太阳更新附魔。成千上万心怀抱负的异国附魔师与法师涌入城中。附魔卷轴和纸张价格飞涨，周边洞穴的茶叶与布匹则廉价流入。"
	weight = 6
	affected_realms = list(REALM_UNDERDARK)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_ENCHSCROLL_BASIC, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
	)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TEA, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CLOTH, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)

/datum/realm_condition/underdark_quake
	id = "underdark_quake"
	name = "地下震灾"
	description = "幽暗地域发生强烈地震，数座洞穴坍塌，大量采集蛛蜜的狗头人聚落与外界失联。当地急需木材加固洞壁。"
	weight = 8
	affected_realms = list(REALM_UNDERDARK)
	supply_modifiers = list(
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_HONEY),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),	)

/datum/realm_condition/vakra_scortched_grimoria
	id = "vakra_debt_collection"
	name = "格里莫里亚焦土"
	description = "数支卢皮安狼群在失去关键据点后焚毁自己的土地。守军的积蓄遭到掠夺，贵重物品廉价流出，被没收的宝石也折价抛售。粮食收购价高昂——焦土上没有收成。"
	weight = 8
	affected_realms = list(REALM_VAKRA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GOLD_INGOT, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GOLD_ORE, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/vakra_famine
	id = "vakra_famine"
	name = "饥荒"
	description = "瓦克兰连续三季歉收，交战军队与平民同受饥饿折磨。掠来的贵重物品如流水般涌出，宝石和金矿石只要能换到外国粮食便卖。纤维与燕麦需求极大。"
	weight = 10
	affected_realms = list(REALM_VAKRA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GEMERALD, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SAFFIRA, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GOLD_ORE, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/naledi_djinn_resurgence
	id = "naledi_djinn_resurgence"
	name = "灯灵再起"
	description = "散布各地的战学士报告，灯灵再次在沙丘间肆虐。处境危急的战学士急需钢铁；商队躲入困顿的聚落避难，丝绸贸易几近停滞。"
	weight = 10
	affected_realms = list(REALM_NALEDI)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_STEEL_INGOT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
	)

/datum/realm_condition/naledi_sandstorm_season
	id = "naledi_sandstorm_season"
	name = "沙暴季"
	description = "阿里索尔的风暴提早来临，久久不散。沙尘阻断了玻璃与金沙的生产。封闭的沙漠聚落需要布匹和熟皮，修补商队车辆，并在风暴中遮护普赛顿的圣像。"
	weight = 10
	affected_realms = list(REALM_NALEDI)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GLASS_BATCH, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GOLD_ORE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CLOTH, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/naledi_warscholar_council
	id = "naledi_warscholar_council"
	name = "战学士议会"
	description = "战学士残存的领袖召集了议会。为来访的新入门者，大祭司套装和论著以更低成本生产；议会则高价收购附魔卷轴、纸张和丝绸，用作仪式赠礼。"
	weight = 5
	affected_realms = list(REALM_NALEDI)
	// TODO(cultural stock step): cultural_modifiers deferred - referenced /datum/supply_pack/rogue/naledi/{hierophant_kit,treatise} not yet ported.
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_ENCHSCROLL_BASIC, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/otava_inquisition_writ
	id = "otava_inquisition_writ"
	name = "审判庭令状"
	description = "神圣法庭对滨海瓦卢伊兹的码头颁下令状。告解师分队高价求购熟皮与铁，从异端家族没收的丝绸和宝石则在埃斯佩朗斯的拍卖台上廉价出售。兽脂价格高昂，审判庭要烧的东西很多。"
	weight = 8
	affected_realms = list(REALM_OTAVA)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CURED_LEATHER, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TALLOW, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
	)

/datum/realm_condition/otava_wine_glut
	id = "otava_wine_glut"
	name = "酒品过剩"
	description = "湖谷葡萄园迎来非凡丰收，李子和草莓充斥奥克西塔尼地区。酿酒师一心专注酿酒，导致国内粮食与盐短缺，两者都在高价求购。"
	weight = 8
	affected_realms = list(REALM_OTAVA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_PLUM, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_STRAWBERRY, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)

/datum/realm_condition/otava_feast_of_saints
	id = "otava_feast_of_saints"
	name = "诸圣盛宴"
	description = "诸圣盛宴吸引各地民众来到埃斯佩朗斯的教堂，举行一周的礼拜与宴饮。红崖的炉坊大量供应奶酪，盟约地区的酒商降价，为节庆酒杯添满美酒。用于圣物匣赠礼的蓝晶与宝石需求极为迫切。"
	weight = 6
	affected_realms = list(REALM_OTAVA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CHEESE, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
	)
	// TODO(cultural stock step): cultural_modifiers deferred - referenced /datum/supply_pack/rogue/alcohol/{winevalorred,winevalorwhite} not yet ported.
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SAFFIRA, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/zybantium_caravan_raids
	id = "zybantium_caravan_raids"
	name = "商队遇袭"
	description = "匪徒盘踞恩什科姆与弗尔达克南之间的东部山口。运糖和咖啡的商队姗姗来迟，货物也大为减少。受影响地区的谢赫正高价求购铁与熟皮，为反击配备军资。"
	weight = 8
	affected_realms = list(REALM_ZYBANTIUM)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SUGAR, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_COFFEE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/zybantium_silk_boom
	id = "zybantium_silk_boom"
	name = "丝绸丰产"
	description = "科罗迪亚基的丝绸作坊迎来创纪录的丰产季。成匹丝绸低价涌入市场，织坊则高价求购染料，尤其是朱砂。"
	weight = 8
	affected_realms = list(REALM_ZYBANTIUM)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_VERY_CHEAP, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CLOTH, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CINNABAR, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_FIBERS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_PREMIUM),
	)

/datum/realm_condition/zybantium_philosopher_gathering
	id = "zybantium_philosopher_gathering"
	name = "哲人雅集"
	description = "四个成员邦的几何师与苦修士齐聚穆杰夫卡赫尔，展开一季论辩。为这些座谈与漫漫长夜，附魔卷轴、纸张和最上等的茶叶需求旺盛。"
	weight = 5
	affected_realms = list(REALM_ZYBANTIUM)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_ENCHSCROLL_BASIC, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_PAPER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_TEA, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/cross_continental_war
	id = "cross_continental_war"
	name = "大陆战争"
	description = "格伦泽尔霍夫特与奥塔瓦正式宣战。两国均将粮食移出出口清单，钢铁需求猛烈攀升，赃物市场则悄悄折价出售外国丝绸与宝石。"
	weight = 6
	cross_realm = TRUE
	affected_realms = list(REALM_GRENZELHOFT, REALM_OTAVA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_GRAIN),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GEMERALD, "qty_min" = BULK_QTY_TINY_MIN, "qty_max" = BULK_QTY_TINY_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SILK, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_STEEL_INGOT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_HEAVY),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/cross_northern_raids
	id = "cross_northern_raids"
	name = "北方劫掠"
	description = "格隆恩长船袭扰格伦泽尔霍夫特海岸。劫掠者满载战利品返回沃尔夫斯港；格伦泽尔各港不惜代价重整军备，并为赎回亲属低价拿出黄金。"
	weight = 8
	cross_realm = TRUE
	affected_realms = list(REALM_GRONN, REALM_GRENZELHOFT)
	per_realm_modifiers = list(
		REALM_GRONN = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_FUR, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_COPPER_INGOT, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
			),
			"demand" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SALT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_MODERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
		),
		REALM_GRENZELHOFT = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GRAIN, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_CURED_LEATHER, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
			),
			"demand" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
		),
	)

/datum/realm_condition/cross_eastern_unrest
	id = "cross_eastern_unrest"
	name = "东方动乱"
	description = "动乱席卷幕府。风郡运来的丝绸与茶叶量少价高，这个东方国家则急需铁与煤炭，以平定乱局。"
	weight = 6
	cross_realm = TRUE
	affected_realms = list(REALM_KAZENGUN)
	supply_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_TEA, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_COAL, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_MODERATE),
	)

/datum/realm_condition/cross_zybantium_drought
	id = "cross_zybantium_drought"
	name = "兹班图旱灾"
	description = "兹班图大陆收成惨败。兹班图腹地今季不再出口稻米与大蒜，瓦克兰属地的农田也同时枯萎。两国都在迫切求购外国谷物与燕麦。"
	weight = 6
	cross_realm = TRUE
	affected_realms = list(REALM_ZYBANTIUM, REALM_VAKRA)
	supply_modifiers = list(
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_RICE),
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_GARLICK),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)

/datum/realm_condition/cross_aavnr_naledi_drought
	id = "cross_aavnr_naledi_drought"
	name = "南方旱灾"
	description = "酷热的一季让阿瓦尔草原与沙丘一同干涸。阿瓦尔的粮田化为尘土，纳莱迪的采盐也因炎热而困难重重。"
	weight = 6
	cross_realm = TRUE
	affected_realms = list(REALM_AAVNR, REALM_NALEDI)
	supply_modifiers = list(
		list("op" = CONDITION_OP_REMOVE, "good" = TRADE_GOOD_GRAIN),
		list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SALT, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
	)
	demand_modifiers = list(
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_GRAIN, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
		list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_OATS, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
	)
/datum/realm_condition/cross_gronn_etrusca_raids
	id = "cross_gronn_etrusca_raids"
	name = "南方劫掠"
	description = "格隆恩长船南下至安息洋，袭击了纳瓦诺的沿海城市。格隆恩劫掠者满载柑橘和伊特鲁斯卡奢侈品归来；大萨菲罗动员舰队，红崖则为受损的盐滩哀叹。"
	weight = 5
	cross_realm = TRUE
	affected_realms = list(REALM_GRONN, REALM_ETRUSCA)
	per_realm_modifiers = list(
		REALM_GRONN = list(
			"supply" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_LEMON, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_TANGERINE, "qty_min" = BULK_QTY_SMALL_MIN, "qty_max" = BULK_QTY_SMALL_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_SALT, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_DEEP_DISCOUNT),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_IRON_INGOT, "price_mod" = CONDITION_PRICE_CHEAP, "qty_mod" = CONDITION_QTY_MODERATE),
			),
			"demand" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_MEDIUM_MIN, "qty_max" = BULK_QTY_MEDIUM_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
		),
		REALM_ETRUSCA = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SALT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_FISH_FILET, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
			),
			"demand" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
			// TODO(cultural stock step): "cultural" deferred - referenced /datum/supply_pack/rogue/etrusca/vaquero_kit not yet ported.
		),
	)

/datum/realm_condition/cross_etrusca_zybantium_war
	id = "cross_etrusca_zybantium_war"
	name = "伊特鲁斯卡攻势"
	description = "萨拉戈萨家族以刀剑回应旧怨。伊特鲁斯卡舰队东进；兹班图沿海地区的谢赫征召军队，苦修士诸家的烛火也暗了下来。"
	weight = 5
	cross_realm = TRUE
	affected_realms = list(REALM_ETRUSCA, REALM_ZYBANTIUM)
	per_realm_modifiers = list(
		REALM_ETRUSCA = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_LEMON, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
			),
			"demand" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_HUGE_MIN, "qty_max" = BULK_QTY_HUGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
			// TODO(cultural stock step): "cultural" deferred - referenced /datum/supply_pack/rogue/etrusca/{condottieri_kit,crossbow} not yet ported.
		),
		REALM_ZYBANTIUM = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_COFFEE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_GLASS_BATCH, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
			),
			"demand" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
		),
	)

/datum/realm_condition/cross_zybantium_etrusca_war
	id = "cross_zybantium_etrusca_war"
	name = "兹班图攻势"
	description = "至尊下令征兵。兹班图桨帆船横渡安息洋，进攻纳瓦诺海岸，牧牛骑手再次驰骋于丘陵。大萨菲罗将所有船只召至拦港链前，弗尔达克南的谢赫则倾尽仓储支援战役。"
	weight = 5
	cross_realm = TRUE
	affected_realms = list(REALM_ZYBANTIUM, REALM_ETRUSCA)
	per_realm_modifiers = list(
		REALM_ZYBANTIUM = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SILK, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_COFFEE, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
			),
			"demand" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_DESPERATE),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_CURED_LEATHER, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_WOOD, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
		),
		REALM_ETRUSCA = list(
			"supply" = list(
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_SALT, "price_mod" = CONDITION_PRICE_HEAVY, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_LEMON, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
				list("op" = CONDITION_OP_MODIFY, "good" = TRADE_GOOD_FISH_FILET, "price_mod" = CONDITION_PRICE_MODERATE, "qty_mod" = CONDITION_QTY_LOW),
			),
			"demand" = list(
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_IRON_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
				list("op" = CONDITION_OP_ADD, "good" = TRADE_GOOD_STEEL_INGOT, "qty_min" = BULK_QTY_LARGE_MIN, "qty_max" = BULK_QTY_LARGE_MAX, "price_mod" = BULK_PRICE_EAGER_PREMIUM),
			),
			// TODO(cultural stock step): "cultural" deferred - referenced /datum/supply_pack/rogue/etrusca/vaquero_kit not yet ported.
		),
	)
