/datum/economic_event
	var/name
	var/description
	var/announcement
	var/list/affected_goods
	var/price_mod = 1.0
	var/event_type
	var/duration_days = ECON_EVENT_DURATION
	var/day_started = 0
	var/day_expires = 0
	var/datum/weakref/urgent_order_ref
	var/saturation_target = 0
	var/saturation_progress = 0
	var/relief_triggered = FALSE

/datum/economic_event/proc/on_apply()
	for(var/good_id in affected_goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(tg)
			tg.global_price_mod *= price_mod
	refresh_affected_stockpile_caches()
	if(event_type == ECON_EVENT_SHORTAGE)
		var/effective_pop = SSeconomy ? SSeconomy.get_effective_player_count() : get_active_player_count()
		var/pop_mult = min(REGION_POP_SCALE_MAX, 1.0 + (effective_pop * REGION_POP_SCALE_PER_PLAYER))
		var/demand_sum = 0
		var/demand_count = 0
		for(var/good_id in affected_goods)
			var/total_demand = 0
			for(var/region_id in GLOB.economic_regions)
				var/datum/economic_region/region = GLOB.economic_regions[region_id]
				total_demand += region.demands[good_id] || 0
			if(total_demand <= 0)
				continue
			demand_sum += total_demand * pop_mult * duration_days
			demand_count++
		saturation_target = demand_count > 0 ? clamp(round(demand_sum * ECON_EVENT_SATURATION_MULT / demand_count), ECON_EVENT_SATURATION_MIN, ECON_EVENT_SATURATION_MAX) : 1
	if(announcement && !(SSeconomy?.daily_report_diff))
		scom_announce(announcement)

/datum/economic_event/proc/on_expire()
	for(var/good_id in affected_goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(tg && price_mod != 0)
			tg.global_price_mod /= price_mod
	refresh_affected_stockpile_caches()
	if(event_type != ECON_EVENT_OVERSUPPLY)
		return
	for(var/datum/roguestock/D as anything in SStreasury.stockpile_datums)
		if(!D.automatic_price || !D.trade_good_id)
			continue
		if(!(D.trade_good_id in affected_goods))
			continue
		D.snap_auto_prices()

/datum/economic_event/proc/refresh_affected_stockpile_caches()
	for(var/datum/roguestock/D as anything in SStreasury.stockpile_datums)
		if(!D.trade_good_id || !(D.trade_good_id in affected_goods))
			continue
		var/datum/trade_good/tg = GLOB.trade_goods[D.trade_good_id]
		if(!tg)
			continue
		D.recompute_market_reference_prices(tg)
		if(D.automatic_price)
			D.compute_auto_prices(tg)
	SStreasury.dirty_market_view()

/datum/economic_event/proc/end_with_relief()
	if(relief_triggered)
		return
	relief_triggered = TRUE
	on_expire()
	GLOB.active_economic_events -= src
	if(SSeconomy)
		SSeconomy.event_path_cooldowns[type] = GLOB.dayspassed + ECON_EVENT_REROLL_COOLDOWN_DAYS
	record_round_statistic(STATS_SHORTAGES_ENDED, 1)
	var/list/diff = SSeconomy?.daily_report_diff
	if(diff)
		var/list/relieved = diff["events_relieved"]
		if(!relieved)
			relieved = list()
			diff["events_relieved"] = relieved
		relieved += name
	else
		scom_announce("<font color='#5cb85c'>缓解：[name]因赈济行动而平息。物价恢复如常。</font>")

/proc/credit_economic_event_saturation(good_id, units)
	if(!good_id || units <= 0)
		return
	var/list/relieved = list()
	for(var/datum/economic_event/E as anything in GLOB.active_economic_events)
		if(E.event_type != ECON_EVENT_SHORTAGE)
			continue
		if(E.relief_triggered)
			continue
		if(!(good_id in E.affected_goods))
			continue
		E.saturation_progress += units
		if(E.saturation_progress >= E.saturation_target)
			relieved += E
	for(var/datum/economic_event/E as anything in relieved)
		E.end_with_relief()


// ============================================================================
// SHORTAGES
// ============================================================================

/datum/economic_event/black_oak_rebellion
	name = "黑橡叛乱"
	description = "黑橡树在玫瑰林再度起事——伐木工被钉死在树上，樵夫若无王权护卫便拒绝深入密林。"
	announcement = "<font color='#c44'>黑橡叛乱：玫瑰林的伐木营地尽数荒废。木材价格飙升。</font>"
	affected_goods = list(TRADE_GOOD_WOOD)
	price_mod = ECON_SHORTAGE_MAJOR
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/ironmongers_strike
	name = "铁商罢工"
	description = "铁商行会因拖欠佣金而集体罢工——熔炉冷落无人问津。"
	announcement = "<font color='#c44'>铁商罢工：铁矿供应受阻。冶炼存货奇货可居。</font>"
	affected_goods = list(TRADE_GOOD_IRON_ORE, TRADE_GOOD_IRON_INGOT, TRADE_GOOD_STEEL_INGOT)
	price_mod = ECON_SHORTAGE_SEVERE
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/daftsmarch_cavein
	name = "愚沼塌方"
	description = "愚沼一处深井坍塌，三条矿脉的采掘作业尽数停摆。"
	announcement = "<font color='#c44'>愚沼塌方：矿场关闭。铁、煤、石料与冶炼存货皆告紧缺。</font>"
	affected_goods = list(TRADE_GOOD_IRON_ORE, TRADE_GOOD_COAL, TRADE_GOOD_STONE, TRADE_GOOD_IRON_INGOT, TRADE_GOOD_STEEL_INGOT)
	price_mod = ECON_SHORTAGE_NORMAL
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/wheat_blight
	name = "小麦枯萎病"
	description = "一种黑色腐病已蔓延至新王田各农庄的粮仓。"
	announcement = "<font color='#c44'>小麦枯萎病：谷物与燕麦在筒仓中腐烂。面包价格飞涨。</font>"
	affected_goods = list(TRADE_GOOD_GRAIN, TRADE_GOOD_OATS)
	price_mod = ECON_SHORTAGE_SEVERE
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/saltwick_storm
	name = "盐镇风暴"
	description = "一场狂暴的飓风袭击了盐镇码头——渔船队数日无法出海。"
	announcement = "<font color='#c44'>盐镇风暴：渔船队搁浅。鲜鱼与干鱼皆价高难求。</font>"
	affected_goods = list(TRADE_GOOD_FISH_FILET, TRADE_GOOD_DRIED_FISH, TRADE_GOOD_FISH_MINCE)
	price_mod = ECON_SHORTAGE_MAJOR
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/fur_trapping_frost
	name = "猎户霜冻"
	description = "一场不合时节的严霜将猎物逼入荒野深处——猎户们空手而归。"
	announcement = "<font color='#c44'>猎户霜冻：毛皮、兽皮与鞣制皮革供应枯竭。制革匠们惊慌失措。</font>"
	affected_goods = list(TRADE_GOOD_FUR, TRADE_GOOD_HIDE, TRADE_GOOD_CURED_LEATHER)
	price_mod = ECON_SHORTAGE_NORMAL
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/cloth_smuggler_purge
	name = "布料走私清剿"
	description = "王权对黑市布料的一场打击，同时也掐断了合法供应。"
	announcement = "<font color='#c44'>布料走私清剿：马车上的布料与纤维被查没。裁缝们陷入绝望。</font>"
	affected_goods = list(TRADE_GOOD_CLOTH, TRADE_GOOD_FIBERS)
	price_mod = ECON_SHORTAGE_MAJOR
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/essence_scarcity
	name = "精华匮乏"
	description = "恐沼中的精华采集已然失收——奥术试剂价格高涨。"
	announcement = "<font color='#c44'>精华匮乏：登多尔的精华与内脏告急。巫师们怒火中烧。</font>"
	affected_goods = list(TRADE_GOOD_DENDOR_ESSENCE, TRADE_GOOD_VISCERA)
	price_mod = ECON_SHORTAGE_CRISIS
	event_type = ECON_EVENT_SHORTAGE


// ============================================================================
// OVERSUPPLIES
// ============================================================================

/datum/economic_event/bumper_harvest
	name = "丰收之年"
	description = "新王田报称迎来历年最好的谷物收成——粮仓满溢。"
	announcement = "<font color='#5cb85c'>丰收之年：谷物与燕麦涌入市场。价格崩塌。</font>"
	affected_goods = list(TRADE_GOOD_GRAIN, TRADE_GOOD_OATS)
	price_mod = ECON_OVERSUPPLY_SEVERE
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/rosawood_overcut
	name = "玫瑰林滥伐"
	description = "玫瑰林的伐木营地超额完成配额——驳船满载木料堵塞河道。"
	announcement = "<font color='#5cb85c'>玫瑰林滥伐：河上木料泛滥。木材价格暴跌。</font>"
	affected_goods = list(TRADE_GOOD_WOOD)
	price_mod = ECON_OVERSUPPLY_MAJOR
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/herring_swarm
	name = "鲱鱼鱼汛"
	description = "一支庞大的鱼群游入盐镇海域——渔网拉起，满舱皆是。"
	announcement = "<font color='#5cb85c'>鲱鱼鱼汛：盐镇渔网撑爆。鲜鱼与干鱼皆贱价出售。</font>"
	affected_goods = list(TRADE_GOOD_FISH_FILET, TRADE_GOOD_DRIED_FISH, TRADE_GOOD_FISH_MINCE)
	price_mod = ECON_OVERSUPPLY_GLUT
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/unseasonal_fur
	name = "反季毛皮"
	description = "猎户们报告大批兽群正迁徙穿越边境——毛皮在仓库中堆积如山。"
	announcement = "<font color='#5cb85c'>反季毛皮：仓库里毛皮堆积如山。皮货价格一落千丈。</font>"
	affected_goods = list(TRADE_GOOD_FUR)
	price_mod = ECON_OVERSUPPLY_NORMAL
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/quarry_windfall
	name = "采石场横财"
	description = "断头山地采石场凿出一条富矿脉——板车从早到晚川流不息。"
	announcement = "<font color='#5cb85c'>采石场横财：石料与煤涌入料场。建造者欢呼，采石工嘟囔。</font>"
	affected_goods = list(TRADE_GOOD_STONE, TRADE_GOOD_COAL)
	price_mod = ECON_OVERSUPPLY_MINOR
	event_type = ECON_EVENT_OVERSUPPLY


// ============================================================================
// SHORTAGES - additional
// ============================================================================

/datum/economic_event/murrain
	name = "牛瘟"
	description = "一种消耗性疾病席卷了新王田牧场的牛群。肉类、乳品与腌制香肠皆告紧缺。"
	announcement = "<font color='#c44'>牛瘟：牧场牛群染病。肉类、乳品与腌制香肠皆价高难求。</font>"
	affected_goods = list(TRADE_GOOD_MEAT, TRADE_GOOD_BUTTER, TRADE_GOOD_CHEESE, TRADE_GOOD_SAUSAGE)
	price_mod = ECON_SHORTAGE_MAJOR
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/saltmine_flooding
	name = "盐矿水淹"
	description = "地下水冲破了愚沼盐场的作业面，淹没了下层巷道。"
	announcement = "<font color='#c44'>盐矿水淹：愚沼的矿井被淹。盐变得珍贵。</font>"
	affected_goods = list(TRADE_GOOD_SALT)
	price_mod = ECON_SHORTAGE_SEVERE
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/copper_tin_embargo
	name = "铜锡禁运"
	description = "一个外国王权禁止其铜与锡的出口。青铜匠们手忙脚乱。"
	announcement = "<font color='#c44'>铜锡禁运：外国船运中断。矿石与冶炼铸锭皆告紧缺。</font>"
	affected_goods = list(TRADE_GOOD_COPPER_ORE, TRADE_GOOD_TIN_ORE, TRADE_GOOD_COPPER_INGOT, TRADE_GOOD_TIN_INGOT)
	price_mod = ECON_SHORTAGE_MAJOR
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/tanners_plague
	name = "制革匠疫病"
	description = "一种腐皮之疾迫使制革坊将半鞣的兽皮成车焚毁。"
	announcement = "<font color='#c44'>制革匠疫病：兽皮成车焚毁。皮革价格高涨。</font>"
	affected_goods = list(TRADE_GOOD_CURED_LEATHER, TRADE_GOOD_HIDE)
	price_mod = ECON_SHORTAGE_SEVERE
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/glass_furnace_failure
	name = "玻璃熔炉损毁"
	description = "玻璃工坊的大熔炉已经开裂。在重建之前，这门手艺只能停摆。"
	announcement = "<font color='#c44'>玻璃熔炉损毁：大玻璃工坊陷入黑暗。玻璃原料变得稀有。</font>"
	affected_goods = list(TRADE_GOOD_GLASS_BATCH)
	price_mod = ECON_SHORTAGE_SEVERE
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/orchard_locusts
	name = "果园蝗灾"
	description = "一群蝗虫将岩丘的果园啃得精光。所剩无几的果品被以天价出售。"
	announcement = "<font color='#c44'>果园蝗灾：果园被啃食一空。苹果、梨与浆果价格高企。</font>"
	affected_goods = list(TRADE_GOOD_APPLE, TRADE_GOOD_PEAR, TRADE_GOOD_JACKSBERRY)
	price_mod = ECON_SHORTAGE_MAJOR
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/silk_moth_collapse
	name = "蚕蛾绝产"
	description = "黑林的蛛丝收成已然绝产。秘会称，这是蛛形纲的不幸。"
	announcement = "<font color='#c44'>蚕蛾绝产：黑林的蛛丝收成失败。裁缝们咬牙切齿。</font>"
	affected_goods = list(TRADE_GOOD_SILK)
	price_mod = ECON_SHORTAGE_CRISIS
	event_type = ECON_EVENT_SHORTAGE

/datum/economic_event/clay_pit_collapse
	name = "黏土坑塌陷"
	description = "黑林的黏土坑已然坍塌，马车与挖掘工一同被吞没。陶工们空手而归。"
	announcement = "<font color='#c44'>黏土坑塌陷：黑林的黏土坑塌陷。陶工与制砖匠们呼喊缺料。</font>"
	affected_goods = list(TRADE_GOOD_CLAY)
	price_mod = ECON_SHORTAGE_MINOR
	event_type = ECON_EVENT_SHORTAGE


// ============================================================================
// OVERSUPPLIES - additional
// ============================================================================

/datum/economic_event/dairy_surplus
	name = "乳品过剩"
	description = "一个温和的季节让新王田的乳坊充斥着黄油与奶酪。"
	announcement = "<font color='#5cb85c'>乳品过剩：黄油与奶酪溢出奶桶。价格暴跌。</font>"
	affected_goods = list(TRADE_GOOD_BUTTER, TRADE_GOOD_CHEESE)
	price_mod = ECON_OVERSUPPLY_MAJOR
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/foreign_pig_iron_glut
	name = "外国生铁倾销"
	description = "一个外国王权将其过剩矿石倾泻到公开市场上。成车的生铁、铜与锡以低于成本的价格涌入。"
	announcement = "<font color='#5cb85c'>外国生铁倾销：外国矿石涌入料场。愚沼矿工嘟囔抱怨；铁匠低价囤货。</font>"
	affected_goods = list(TRADE_GOOD_IRON_ORE, TRADE_GOOD_COPPER_ORE, TRADE_GOOD_TIN_ORE)
	price_mod = ECON_OVERSUPPLY_MAJOR
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/salt_caravan
	name = "盐队抵达"
	description = "一支远方的商队载着成车盐货滚滚而来——直到储备清空为止，价格一路走低。"
	announcement = "<font color='#5cb85c'>盐队抵达：成车盐货运抵市场。腌制匠们欢呼。</font>"
	affected_goods = list(TRADE_GOOD_SALT)
	price_mod = ECON_OVERSUPPLY_SEVERE
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/cloth_fair
	name = "布料集市"
	description = "当季的布料集市以割喉价格向市场倾泻了生纤维与成匹的布。"
	announcement = "<font color='#5cb85c'>布料集市：生纤维与成匹布料涌入市场。裁缝们欢欣鼓舞。</font>"
	affected_goods = list(TRADE_GOOD_CLOTH, TRADE_GOOD_FIBERS)
	price_mod = ECON_OVERSUPPLY_MAJOR
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/fat_hog_season
	name = "肥猪时节"
	description = "养猪户们提前宰杀——这周猪肉与油脂都格外便宜。"
	announcement = "<font color='#5cb85c'>肥猪时节：猪肉、油脂与腌制猪肉皆贱价。屠夫们彻夜忙碌。</font>"
	affected_goods = list(TRADE_GOOD_PORK, TRADE_GOOD_FAT, TRADE_GOOD_TALLOW, TRADE_GOOD_SAUSAGE, TRADE_GOOD_SALUMOI)
	price_mod = ECON_OVERSUPPLY_MAJOR
	event_type = ECON_EVENT_OVERSUPPLY

/datum/economic_event/cidering_season
	name = "榨汁季节"
	description = "岩丘的压榨坊在水果的洪流下呻吟。商贩们不计价格地抛售过剩的果子。"
	announcement = "<font color='#5cb85c'>榨汁季节：水果堆积在压榨坊外。果园货物贱价出售。</font>"
	affected_goods = list(TRADE_GOOD_APPLE, TRADE_GOOD_PEAR, TRADE_GOOD_JACKSBERRY)
	price_mod = ECON_OVERSUPPLY_SEVERE
	event_type = ECON_EVENT_OVERSUPPLY
