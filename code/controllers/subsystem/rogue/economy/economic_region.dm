GLOBAL_LIST_INIT(economic_regions, init_economic_regions())

/proc/init_economic_regions()
	var/list/result = list()
	for(var/datum/economic_region/er as anything in subtypesof(/datum/economic_region))
		var/datum/economic_region/instance = new er()
		if(!instance.region_id)
			continue
		if(instance.map_swap_only)
			continue
		result[instance.region_id] = instance
	return result

/datum/economic_region
	var/region_id
	var/name
	/// Italicized one-liner shown beneath the region name in the Lore Primer's
	/// realm regions section. The steward UI ignores it; only `description` shows there.
	var/subtitle = ""
	var/description = ""
	var/list/produces = list()
	var/list/demands = list()
	var/list/possible_standing_order_types = list()
	var/associated_marker_id
	var/is_region_blockaded = FALSE
	/// Null = this region cannot be blockaded.
	var/threat_region_id
	/// Name-day celebrants for the birthday-tribute standing order. Lives on the region so
	/// per-map identity swaps carry their own names; empty list falls back to generic text.
	var/list/order_celebrants = list()
	/// Alternate that exists only to take another region's slot on a specific map, via
	/// map_adjustment.trade_region_swaps. Skipped by init_economic_regions() so it never
	/// appears alongside the region it replaces.
	var/map_swap_only = FALSE
	// Ensure this region won't replenish blockade. Used only for Kingsfield because Kingsfield blockade is devastating and shouldn't repeat mid round.
	var/blockade_replenish_eligible = TRUE

	var/list/produces_today = list()
	var/list/demands_today = list()

	var/list/produces_day_start = list()
	var/list/demands_day_start = list()

	/// -1 = never cleared. Otherwise the cooldown window runs from this day.
	var/day_last_cleared = -1

/datum/economic_region/New()
	. = ..()
	produces_today = produces.Copy()
	demands_today = demands.Copy()
	produces_day_start = produces.Copy()
	demands_day_start = demands.Copy()
	if(!associated_marker_id)
		associated_marker_id = "[region_id]_blockade"

/datum/economic_region/proc/get_day_capacity(good_id, importing)
	var/list/today = importing ? produces_today : demands_today
	return max(0, today[good_id] || 0)

/datum/economic_region/proc/get_day_capacity_total(good_id, importing)
	var/list/day_start = importing ? produces_day_start : demands_day_start
	return max(0, day_start[good_id] || 0)

/datum/economic_region/proc/get_batch_capacity(good_id, importing)
	var/pace = (importing ? produces[good_id] : demands[good_id]) || 0
	if(pace <= 0)
		return 0
	return clamp((importing ? produces_today[good_id] : demands_today[good_id]) || 0, 0, pace)

/datum/economic_region/kingsfield
	region_id = TRADE_REGION_KINGSFIELD
	name = "王田"
	subtitle = "王室领地, 费伦提亚的腹地"
	blockade_replenish_eligible = FALSE
	order_celebrants = list("樱溪的玛丽索尔夫人", "小贝伦格勋爵", "维萨莉娅 裂境女爵", "奥伯林的奥尔德温爵士")
	description = "费伦提亚女王的王室领地, 也是她最珍贵的产业. 这片土地沿大河南岸延伸约十英里, 坐落着数十处农业聚落, 村庄, 小型集镇以及王田城本身. 土地肥沃, 人口众多. 作为费伦提亚的农业腹地, 这里供应了全国大部分谷物, 肉类, 和乳制品, 每日运入本领地并转口出售获利. 本领地的许多居民在这里拥有庄园. 女王, 直接拥有大部分土地, 向当地全部出产征收一成什一税, 而王权直属土地的税率至少为四分之一, 此乃王室特权, 因而这里对王权的财库至关重要."
	threat_region_id = THREAT_REGION_AZURE_GROVE
	produces = list(
		TRADE_GOOD_GRAIN = TG_SUPPLY_LOCAL_GRAIN,
		TRADE_GOOD_OATS = TG_SUPPLY_FOREIGN_GRAIN,
		TRADE_GOOD_RICE = TG_SUPPLY_FOREIGN_GRAIN,
		TRADE_GOOD_MEAT = TG_SUPPLY_MEAT_BULK,
		TRADE_GOOD_PORK = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_HAM = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_PORK_BELLY = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_POULTRY = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_RABBIT = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_EGG = TG_SUPPLY_MEAT_BULK,
		TRADE_GOOD_BUTTER = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_CHEESE = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_FAT = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_TALLOW = TG_SUPPLY_MEAT_STAPLE,
		TRADE_GOOD_CABBAGE = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_TOMATO = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_EGGPLANT = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_CUCUMBER = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_GARLICK = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_POTATO = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_ONION = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_CARROT = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_TURNIP = TG_SUPPLY_COMMON_VEG,
		TRADE_GOOD_PUMPKIN = 2, // literal: trickle supply, not a staple
	)
	demands = list(
		TRADE_GOOD_PUMPKIN = 2, // literal: small local appetite for eating
		TRADE_GOOD_SUGAR = TG_DEMAND_RARE_FRUIT,
		TRADE_GOOD_COFFEE = TG_DEMAND_RARE_FRUIT,
		TRADE_GOOD_TEA = TG_DEMAND_RARE_FRUIT,
		TRADE_GOOD_HONEY = TG_DEMAND_RARE_FRUIT,
		TRADE_GOOD_ROCKNUT = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_BLACKBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_RASPBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_STRAWBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_LEMON = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_LIME = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_TANGERINE = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_PLUM = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_SALT = TG_DEMAND_SALT,
		TRADE_GOOD_IRON_ORE = TG_DEMAND_IRON,
		TRADE_GOOD_COPPER_ORE = TG_DEMAND_TIN_BRONZE,
		TRADE_GOOD_TIN_ORE = TG_DEMAND_TIN_BRONZE,
		TRADE_GOOD_COAL = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_STONE = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_CLAY = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_CINNABAR = TG_DEMAND_IRON,
		TRADE_GOOD_SILVER_INGOT = TG_DEMAND_PRECIOUS_METAL,
		TRADE_GOOD_GOLD_ORE = TG_DEMAND_PRECIOUS_METAL,
		TRADE_GOOD_SILK = TG_DEMAND_SILK,
		TRADE_GOOD_CALENDULA = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_POPPY = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_DENDOR_ESSENCE = 3, // literal: deliberately scarce, not category-bound
		TRADE_GOOD_VISCERA = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_SINEW = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_HIDE = TG_DEMAND_LEATHER,
		TRADE_GOOD_FUR = TG_DEMAND_LEATHER,
		TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
		TRADE_GOOD_WOOD = TG_DEMAND_CHEAP_RAW_MAT * 2,
		TRADE_GOOD_FIBERS = TG_DEMAND_CLOTH,
		TRADE_GOOD_GLASS_BATCH = TG_DEMAND_GLASS,
		TRADE_GOOD_FISH_FILET = TG_DEMAND_FISH_BULK,
		TRADE_GOOD_FISH_MINCE = TG_DEMAND_FISH_BULK,
		TRADE_GOOD_SALMON = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_COD = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_CRAB = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_BASS = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_CARP = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_SOLE = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_CLAM = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_LOBSTER = TG_DEMAND_FISH_SPECIALTY,
		TRADE_GOOD_SHRIMP = TG_DEMAND_FISH_SPECIALTY,
	)

/datum/economic_region/rosawood
	region_id = TRADE_REGION_ROSAWOOD
	name = "玫瑰林"
	subtitle = "精灵飞地, 寒冷海岸的木材产地"
	order_celebrants = list("希尔瓦琳 荆苔夫人")
	description = "费伦提亚最后一处仍由精灵领主统治且以精灵为主要人口的附庸领地. 这片精灵飞地位于本领地以北伸出的半岛上, 旁边是一条被称作南玫瑰林的狭长贫瘠海岸林地. 出入主要依靠海路. 木材从南缘出口. 这个郡异常寒冷, 几乎像是魔法所致, 每年的生长季节仅有三个月. 居民靠这三个月的收成糊口, 再以北海的鱼获补充, 但其产量与出口量始终不足以供应  本领地. 穿过群山下隘口的陆路尚可通行, 却十分缓慢, 还有横行的黑橡树佣兵. 精灵们倒乐见其成. 有人声称, 玫瑰林伯爵那美丽的白色披风, 与黑橡树佣兵的披风采用相同织法, 那是一群王权勉强容忍的恶名昭著的佣兵. 至于勾结的指控, 玫瑰林伯爵向来迅速否认, 而王权也从未找到反证."
	threat_region_id = THREAT_REGION_AZURE_GROVE
	produces = list(
		TRADE_GOOD_WOOD = TG_SUPPLY_CHEAP_RAW_MAT,
		TRADE_GOOD_FIBERS = TG_SUPPLY_FIBERS,
		TRADE_GOOD_CLOTH = TG_SUPPLY_LEATHER,
		TRADE_GOOD_HIDE = TG_SUPPLY_LEATHER,
		TRADE_GOOD_FUR = TG_SUPPLY_LEATHER,
		TRADE_GOOD_CURED_LEATHER = TG_SUPPLY_LEATHER,
		TRADE_GOOD_LUMBER_ESSENCE = TG_SUPPLY_SPECIALTY_HERB,
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_SALT = TG_DEMAND_SALT,
		TRADE_GOOD_ROCKNUT = TG_DEMAND_SPECIALTY_HERB,
	)

/datum/economic_region/rockhill
	region_id = TRADE_REGION_ROCKHILL
	name = "岩丘"
	subtitle = "山脊的果园, 酒商与草药师"
	order_celebrants = list("哈德里乌斯 暮溪磨坊勋爵", "奥琳德 绿山墙夫人")
	description = "本领地以北的一片果园与药圃, 受山脊庇护而拥有出奇温和的气候. 郡内丘陵起伏不适合种谷物却很适合果园. 岩丘的葡萄酒与烈酒闻名费伦提亚, 部分还出口海外. 这是一个宁静, 古朴, 以农业为生的郡, 贵族庄园星罗棋布. 岩丘苹果白兰地是领地内最常被仿冒的酒. 从荒凉海岸到赤心几乎每隔一家旅店便声称供应此酒, 但真正供应的或许只有三分之一. 这里也以众多乡间庄园闻名, 领地中约四分之三的贵族家族在岩丘至少拥有一座庄园."
	threat_region_id = THREAT_REGION_AZUREAN_COAST
	produces = list(
		TRADE_GOOD_APPLE = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_PEAR = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_JACKSBERRY = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_CALENDULA = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_POPPY = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_BLACKBERRY = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_RASPBERRY = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_STRAWBERRY = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_LEMON = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_LIME = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_TANGERINE = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_PLUM = TG_SUPPLY_LOCAL_FRUIT,
	)
	demands = list(
		TRADE_GOOD_GLASS_BATCH = TG_DEMAND_GLASS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_SILK = TG_DEMAND_SILK,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_CLAY = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_GARLICK = TG_DEMAND_COMMON_VEG,
	)

// Swapped in for Rockhill on the Rockhill map, where the realm is itself called Rockhill and
// a trade road to a county of the same name reads as nonsense. Vespermill was already the
// region's noble seat in standing_order.dm ("Lord Hadrius Vespermill", the midsummer tourney,
// the master-of-hounds), so promoting it to the county name costs no new lore. Keeps
// TRADE_REGION_ROCKHILL and the orchard profile so trade goods, crown imports and every
// standing order keyed to the region continue to resolve.
/datum/economic_region/vespermill
	map_swap_only = TRUE
	region_id = TRADE_REGION_ROCKHILL
	name = "暮溪磨坊"
	subtitle = "丘原的果园, 酒商与草药师"
	description = "起伏丘原上的一片果园与药圃, 受长山脊庇护而拥有出奇温和的气候. 丘陵不适合种谷物却很适合果园, 当地已经以此为业六代. 暮溪磨坊的葡萄酒与烈酒闻名费伦提亚, 部分还出口海外. 这是一个宁静, 古朴, 以农业为生的郡, 贵族庄园星罗棋布且郡名源自暮色溪流上方的磨坊而首任暮溪磨坊领主便在磨坊周围建起宅邸. 暮溪磨坊苹果白兰地是领地内最常被仿冒的酒. 从荒凉海岸到赤心几乎每隔一家旅店便声称供应此酒, 但真正供应的或许只有三分之一. 这里也以众多乡间庄园闻名, 领地中约四分之三的贵族家族在这些果园中至少拥有一座庄园."
	threat_region_id = THREAT_REGION_AZUREAN_COAST
	produces = list(
		TRADE_GOOD_APPLE = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_PEAR = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_JACKSBERRY = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_CALENDULA = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_POPPY = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_BLACKBERRY = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_RASPBERRY = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_STRAWBERRY = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_LEMON = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_LIME = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_TANGERINE = TG_SUPPLY_LOCAL_FRUIT,
		TRADE_GOOD_PLUM = TG_SUPPLY_LOCAL_FRUIT,
	)
	demands = list(
		TRADE_GOOD_GLASS_BATCH = TG_DEMAND_GLASS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_SILK = TG_DEMAND_SILK,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_CLAY = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_GARLICK = TG_DEMAND_COMMON_VEG,
	)

/datum/economic_region/daftsmarch
	region_id = TRADE_REGION_DAFTSMARCH
	name = "愚沼"
	subtitle = "采矿边区, 群山的矿石产地"
	order_celebrants = list("腌岭的科格拉德勋爵")
	description = "愚沼郡是费伦提亚采矿业的中心, 这片狭长的土地紧贴西部山脉. 费伦提亚赖以生存的大部分原矿和盐都产自这里. 工作报酬丰厚, 矿脉也十分丰富. 但愚沼与群山下的古代遗迹近得令人不安, 也紧邻幽暗地域的各类居民. 卓尔及其同类始终构成威胁 - 其中许多将愚沼视为便利的奴隶来源. 然而矿脉愈发丰厚 - 王权不愿让它们闲置 - 于是派出冒险者, 佣兵与驻军一同对抗幽暗地域的居民并将其阻挡在外."
	threat_region_id = THREAT_REGION_UNDERDARK
	produces = list(
		TRADE_GOOD_IRON_ORE = TG_SUPPLY_IRON,
		TRADE_GOOD_COPPER_ORE = TG_SUPPLY_TIN_BRONZE,
		TRADE_GOOD_TIN_ORE = TG_SUPPLY_TIN_BRONZE,
		TRADE_GOOD_STONE = TG_SUPPLY_CHEAP_RAW_MAT,
		TRADE_GOOD_COAL = TG_SUPPLY_IRON,
		TRADE_GOOD_CINNABAR = TG_SUPPLY_PRECIOUS_METAL,
		TRADE_GOOD_GOLD_ORE = TG_SUPPLY_PRECIOUS_METAL,
		TRADE_GOOD_SALT = TG_SUPPLY_SALT,
		TRADE_GOOD_GLASS_BATCH = TG_SUPPLY_GLASS,
		TRADE_GOOD_ROCKNUT = TG_SUPPLY_SPECIALTY_HERB,
	)
	demands = list(
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
	)

/datum/economic_region/blackholt
	region_id = TRADE_REGION_BLACKHOLT
	name = "黑林"
	subtitle = "沼泽边缘, 狩猎总管的领地"
	order_celebrants = list("狩猎总管奥斯特兰")
	description = "恐惧沼泽南缘的一处聚落, 属于公爵领地, 也是公爵唯一从不巡访或直接管理的地方. 相反, 管理权交给了一位特殊廷臣, 即黑林狩猎总管. 这里横跨沼泽本体和边缘尚未排干的湿地. 当地人学会了靠沼泽的奇异产物谋生, 有人称它们受普赛顿祝福: 蚕蛾的丝, 沼泽生物的内脏, 以及草药师和法师愿意重金收购的稀有登多尔精华. 黑林本身阴沉, 一切以实用为先. 没有人主动迁往那里. 人们只是最终沦落至此."
	threat_region_id = THREAT_REGION_AZURE_GROVE
	produces = list(
		TRADE_GOOD_SILK = TG_SUPPLY_SILK,
		TRADE_GOOD_VISCERA = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_SINEW = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_DENDOR_ESSENCE = 1, // literal: deliberately scarce, not category-bound
		TRADE_GOOD_CALENDULA = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_CLAY = TG_SUPPLY_CHEAP_RAW_MAT,
		TRADE_GOOD_HIDE = 2, // literal: bog-game byproduct, backup supply if Rosawood is blockaded
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_BLACKBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_RASPBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_STRAWBERRY = TG_DEMAND_LOCAL_FRUIT,
	)

/datum/economic_region/saltwick
	region_id = TRADE_REGION_SALTWICK
	name = "盐镇"
	subtitle = "滨海小镇, 领地的渔业产地"
	description = "本领地东南的一处聚落, 距离约一日骑程, 坐落在王田海岸. 最初由铁锤堡移民定居而后又迎来格隆恩南部的移民. 小镇泾渭分明地分为两部分: 腌制工坊和盐场大多属于镇上的矮人与铁锤堡移民, 而渔民和水手则多为格隆恩后裔. 两个群体鲜少通婚且经常争吵 - 不过仍算和谐地共居一镇. 当然, 铁锤堡人与格隆人并非仅有的居民 - 许多时运不济或寻找工作的人也住在这里. 盐从愚沼进口, 用于保存本地渔民捕获的鱼, 然后出口到费伦提亚和普赛多尼亚各地."
	threat_region_id = THREAT_REGION_AZUREAN_COAST
	produces = list(
		TRADE_GOOD_FISH_FILET = TG_SUPPLY_FISH_BULK,
		TRADE_GOOD_FISH_MINCE = TG_SUPPLY_FISH_MINCE,
		TRADE_GOOD_SALMON = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_COD = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_CRAB = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_BASS = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_CARP = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_SOLE = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_CLAM = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_LOBSTER = TG_SUPPLY_FISH_SPECIALTY,
		TRADE_GOOD_SHRIMP = TG_SUPPLY_FISH_SPECIALTY,
	)
	demands = list(
		TRADE_GOOD_SALT = TG_DEMAND_SALT,
		TRADE_GOOD_FIBERS = TG_DEMAND_CLOTH,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_WOOD = TG_DEMAND_CHEAP_RAW_MAT * 2, // wood draws 2x raw-mat baseline: building, firewood, charring
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_PUMPKIN = 2, // literal: small local appetite for eating
	)

/datum/economic_region/bleakcoast
	region_id = TRADE_REGION_BLEAKCOAST
	name = "荒凉海岸"
	subtitle = "荒凉群岛海疆, 海盗群岛"
	order_celebrants = list("盐礁的维萨里昂船长勋爵")
	description = "亦称荒凉群岛海疆. 据说这些岩礁诞生于古代精灵城邦之间的战争并由强大魔法造就. 群岛数量达数百座令费伦提亚沿岸除一条狭窄航道外处处凶险. 土地虽不肥沃但海产极为丰饶. 鱼群聚集于浅水, 岩石密布的海底并游至费伦提亚海岸, 养活数千人. 但荒凉群岛居民无福享用这些馈赠. 群岛海盗猖獗, 尤以荒岛劫掠者臭名昭著, 他们袭击任何远离海岸的商人或渔夫. 公国维持数处驻军以牵制他们, 而且, 每隔两代人, 便会扫荡群岛, 焚毁每处非军事聚落并向土地撒盐使其荒芜. 但一切徒劳. 不出一代人, 海盗总会卷土重来, 因为贸易利润丰厚, 劫掠则更胜一筹."
	threat_region_id = THREAT_REGION_AZUREAN_COAST
	produces = list()
	demands = list(
		TRADE_GOOD_STEEL_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_COPPER_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_TIN_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_PORK = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_HAM = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_PORK_BELLY = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_POULTRY = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_EGG = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_FAT = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_TALLOW = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_OATS = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_RICE = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_POTATO = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_ONION = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_CARROT = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_TURNIP = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_CABBAGE = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_CUCUMBER = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_TOMATO = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_EGGPLANT = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_GARLICK = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_ROCKNUT = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_APPLE = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_PEAR = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_JACKSBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_BLACKBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_RASPBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_STRAWBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_LEMON = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_LIME = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_TANGERINE = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_PLUM = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
		TRADE_GOOD_HIDE = TG_DEMAND_LEATHER,
	)

/datum/economic_region/northfort
	region_id = TRADE_REGION_NORTHFORT
	name = "北堡"
	subtitle = "边境要塞, 守望北方门户"
	description = "位于本领地北方入口的坚固城堡, 扼守从北方进入的唯一直接陆路. 其经济产出一如要塞应有的水平, 几乎没有. 王权供养它是因为若失去此地, 费伦提亚便容易遭受外敌入侵."
	threat_region_id = THREAT_REGION_MOUNT_DECAP
	produces = list()
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_STEEL_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_COPPER_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_TIN_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_FUR = TG_DEMAND_LEATHER,
		TRADE_GOOD_HIDE = TG_DEMAND_LEATHER,
		TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_OATS = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_PORK = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_HAM = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_PORK_BELLY = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_POULTRY = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_BUTTER = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_CHEESE = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_FAT = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_TALLOW = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_EGG = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_POTATO = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_TURNIP = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_CARROT = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_CABBAGE = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_ROCKNUT = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_LEMON = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_LIME = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_TANGERINE = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_PLUM = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_ONION = TG_DEMAND_COMMON_VEG,
		TRADE_GOOD_SALT = TG_DEMAND_SALT,
		TRADE_GOOD_COAL = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_CLAY = TG_DEMAND_CHEAP_RAW_MAT,
		TRADE_GOOD_SUGAR = TG_DEMAND_RARE_FRUIT,
		TRADE_GOOD_COFFEE = TG_DEMAND_RARE_FRUIT,
		TRADE_GOOD_TEA = TG_DEMAND_RARE_FRUIT,
	)

/datum/economic_region/heartfelt
	region_id = TRADE_REGION_HEARTFELT
	name = "赤心"
	subtitle = "机关术的发源地, 费伦提亚昔日伟大的工艺殿堂"
	order_celebrants = list("议员爱德华 哈劳斯", "边区的阿尔登特爵士")
	description = "赤心男爵领曾是费伦提亚最富创造力且最具影响力的领地之一. 这里孕育了机关术的发明, 令无数目光嫉妒地投向赤心. 男爵领遭逢诸多挫折, 使曾经繁荣的土地陷入困境并令其出口仅剩稀有货物, 急需大量进口来维持自身的生计."
	threat_region_id = THREAT_REGION_AZURE_GROVE
	produces = list(//Items produced from the Heartfelt region come from outside the realm, coffee from zyb, honey from gron etc
		TRADE_GOOD_SUGAR = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_COFFEE = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_TEA = TG_SUPPLY_SPECIALTY_HERB,
		TRADE_GOOD_HONEY = TG_SUPPLY_SPECIALTY_HERB,
	)
	demands = list(
		TRADE_GOOD_STEEL_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
		TRADE_GOOD_SILVER_INGOT = TG_DEMAND_PRECIOUS_METAL,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_POULTRY = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_RABBIT = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_CHEESE = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_BUTTER = TG_DEMAND_MEAT_STAPLE,
		TRADE_GOOD_EGG = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_RICE = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_APPLE = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_PEAR = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_JACKSBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_BLACKBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_RASPBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_STRAWBERRY = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_LEMON = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_LIME = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_TANGERINE = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_PLUM = TG_DEMAND_LOCAL_FRUIT,
		TRADE_GOOD_CALENDULA = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_POPPY = TG_DEMAND_SPECIALTY_HERB,
		TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
		TRADE_GOOD_FIBERS = TG_DEMAND_CLOTH,
		TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
		TRADE_GOOD_HIDE = TG_DEMAND_LEATHER,
		TRADE_GOOD_CLAY = TG_DEMAND_CHEAP_RAW_MAT,
	)

/datum/economic_region/hagenwald
	region_id = TRADE_REGION_HAGENWALD
	name = "篱林"
	subtitle = "工业腹地, 萌生林中的锻炉"
	description = "费伦提亚的工业腹地, 位于费伦提亚群山北麓, 愚沼的矿石由骡队运来冶炼, 提纯, 再锻造成材. 篱林几乎供应了王国使用的全部铁, 钢, 铜, 和锡锭 - 若没有这里的熔炉, 费伦提亚的铁匠就只能摆弄废料. 小镇的财富建立在三面环绕的萌生林上, 世代轮伐并反复砍伐使炉火永不熄灭. 半数工人为格伦泽尔霍夫特后裔, 数百年来被薪酬吸引而来, 街道常年被烟灰染成灰色. 王权悄然在此驻军."
	threat_region_id = THREAT_REGION_MOUNT_DECAP
	produces = list(
		TRADE_GOOD_IRON_INGOT = TG_SUPPLY_REFINED_INGOTS,
		TRADE_GOOD_STEEL_INGOT = TG_SUPPLY_REFINED_INGOTS,
		TRADE_GOOD_COPPER_INGOT = TG_SUPPLY_REFINED_INGOTS,
		TRADE_GOOD_TIN_INGOT = TG_SUPPLY_REFINED_INGOTS,
		TRADE_GOOD_COAL = TG_SUPPLY_IRON,
	)
	demands = list(
		TRADE_GOOD_IRON_ORE = TG_DEMAND_IRON,
		TRADE_GOOD_COPPER_ORE = TG_DEMAND_TIN_BRONZE,
		TRADE_GOOD_TIN_ORE = TG_DEMAND_TIN_BRONZE,
		TRADE_GOOD_SILVER_ORE = TG_DEMAND_PRECIOUS_METAL,
		TRADE_GOOD_CINNABAR = TG_DEMAND_IRON,
		TRADE_GOOD_WOOD = TG_DEMAND_CHEAP_RAW_MAT * 2, // wood draws 2x raw-mat baseline: building, firewood, charring
		TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
		TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
		TRADE_GOOD_SILK = TG_DEMAND_SILK,
	)

/// Builds the realm regions section of the Lore Primer from the economic_region datums,
/// so steward UI prose and primer prose stay in sync from a single source.
/proc/build_regions_primer_html()
	var/list/parts = list()
	parts += "<details>"
	parts += "<summary><strong><span style='font-size:130%'> REGIONS OF [uppertext(SSmapping.map_adjustment.realm_name)] </span></strong></summary>"
	parts += "<strong><span style='font-size:115%'> THE INTERNAL VASSALS AND DEMESNES </span></strong>"
	parts += "<br><br>"
	for(var/region_id in GLOB.economic_regions)
		var/datum/economic_region/region = GLOB.economic_regions[region_id]
		if(!region)
			continue
		parts += "<details>"
		parts += "<summary><strong> [uppertext(region.name)] </strong></summary>"
		parts += "<br>"
		if(region.subtitle)
			parts += "<em>[region.subtitle]</em>"
			parts += "<br><br>"
		parts += region.description
		parts += "<br>"
		parts += "</details>"
	parts += "<br><br>"
	parts += "</details>"
	return jointext(parts, "\n")



// Al-Ashur trade region identities, swapped in on the Desert Town map via
// map_adjustment.trade_region_swaps. Each name derives visibly from the Vale original
// (Kingsfield becomes Shahfield, Daftsmarch becomes Daftsmarz) and each is a child of the
// region it replaces, inheriting region_id, produces/demands and the blockade wiring. The
// economy is identical; only the identity changes.

/datum/economic_region/kingsfield/alashar
	map_swap_only = TRUE
	name = "沙赫田"
	subtitle = "沙阿的领地, 阿尔-阿舒尔的粮仓"
	order_celebrants = list("河门的罗珊娜克夫人", "小卡武斯勋爵", "雅丝敏 撒金女爵", "坎儿井的巴赫曼爵士")
	description = "王室行省, 由比历代统治王朝更古老的坎儿井水道灌溉. 沿着河流两岸绿带的一百座村庄种植谷物, 放牧牲畜, 并压制奶酪以供养阿尔-阿舒尔, 自第一位沙阿升起第一道水闸以来王权便从每季收成中征收什一税. 城中的许多大家族在这里拥有避暑庄园, 往来的道路上运粮车从未断绝."

/datum/economic_region/rosawood/alashar
	map_swap_only = TRUE
	name = "罗萨巴格"
	subtitle = "龙裔飞地, 寒冷海岸的柏木产地"
	order_celebrants = list("柏林的希尔瓦琳夫人")
	description = "最后一处仍由龙裔领主统治的附庸领地: 寒冷北岸的一片黑柏林之乡, 从海路抵达比穿越隘口更容易. 当地木材是梁柱和船龙骨的上佳用料, 沉默寡言的木匠伐多少树就栽多少树. 罗萨巴格总督仿照誓印者的方式编织红披风, 面对有关那个兄弟会的提问便如柏树面对风一般沉默."

/datum/economic_region/rockhill/alashar
	map_swap_only = TRUE
	name = "罗克泰佩"
	subtitle = "黄金花园, 绿洲梯田的酒商与草药师"
	order_celebrants = list("梯田的巴赫拉姆勋爵", "阿娜希塔 绿山墙夫人")
	description = "一阶阶围墙花园梯田从尘土中升起, 古帝国开凿的水渠使它们绿意盎然得近乎不可思议. 罗克泰佩的果园与罂粟花田同时供应领地的餐桌和药剂行, 其枣白兰地是两海之间最常被仿冒的酒. 从萨尔塔巴德到哈特坎德的每座商旅驿站都声称供应此酒, 真货或许只有三分之一. 贵族们在此修建游乐花园, 捍卫水权时比守护女儿还要严防死守."

/datum/economic_region/daftsmarch/alashar
	map_swap_only = TRUE
	name = "达夫特斯马兹"
	subtitle = "采矿行省, 赤色群山的矿石产地"
	order_celebrants = list("赤色矿道的科格拉德矿主")
	description = "赤色群山中遍布坑道与尾矿的行省, 矿脉深得足以让人致富而更深处则足以让人发疯. 矿主们向王权缴纳铸锭并只求无人追问最新的矿道究竟挖得多深, 也不追问底下的深地居民拿什么来交易."

/datum/economic_region/blackholt/alashar
	map_swap_only = TRUE
	name = "卡拉霍尔特"
	subtitle = "狩猎场, 狩猎总管的禁苑"
	order_celebrants = list("狩猎总管阿拉什")
	description = "王权的狩猎禁苑位于沙丘与芦苇沼泽交接的湿地边缘: 狮子和野猪供宫廷狩猎娱乐, 兽皮毛皮及腌制野味则充实财库. 狩猎总管将这里作为由猎皮与猎犬组成的私人王国统治, 而能赶在其骑手前抵达城市的偷猎者, 按照传统, 可以保留一切能吞下肚的东西."

/datum/economic_region/saltwick/alashar
	map_swap_only = TRUE
	name = "萨尔塔巴德"
	subtitle = "盐滩, 海湾的渔业产地"
	description = "一片洁白的土地: 盐田闪耀着延伸至地平线, 再往外便是渔船成群的海湾. 萨尔塔巴德的盐卤师傅和渔船长供养领地并腌制所供应的食物, 港口集市上有六种语言参与银钱交易. 据说这是阿尔-阿舒尔唯一一处税吏乘船抵达的城镇."

/datum/economic_region/bleakcoast/alashar
	map_swap_only = TRUE
	name = "布利克塔拉萨"
	subtitle = "海盗群岛, 东海之患"
	order_celebrants = list("岩礁群的尼基弗罗斯船长勋爵")
	description = "这片海盗港口林立的群岛被王权宣称为行省而海盗只当那是盖着税印的笑话. 塔拉萨船长们劫掠到每幅地图的边缘之外, 带回的毛皮, 琥珀, 以及更加奇异的物品运到大陆集市时还沾着海盐. 王权的保护范围恰好只到最后一支桨帆巡逻队所及之处, 岛民们对此总是津津乐道."

/datum/economic_region/northfort/alashar
	map_swap_only = TRUE
	name = "诺斯德兹"
	subtitle = "边境隘口, 山路上的守望者"
	description = "北方道路上的设防隘口, 其驻军名册比他们警戒的某些国家还要古老. 诺斯德兹产出很少而需求甚多: 铁, 粮食, 以及人手. 王权乐于支付, 因为算下来每年消耗十车补给的行省比一场战争便宜."

/datum/economic_region/heartfelt/alashar
	map_swap_only = TRUE
	name = "哈特坎德"
	subtitle = "大军区, 阿尔-阿舒尔最强的附庸"
	order_celebrants = list("阿莱克修斯 哈劳斯将军", "边区的阿尔达万爵士")
	description = "东方大军区, 领地最大且最骄傲的附庸, 由一位对王权礼数周全而忠诚薄如羊皮纸的将军统治. 其庄园和牧马场足以供养第二座首都, 征召兵行军时首先效忠自己的旗帜. 每一代, 都有大臣提议提醒哈特坎德谁才是统治者; 每一代, 更明智的大臣则提议先吃午饭."

/datum/economic_region/hagenwald/alashar
	map_swap_only = TRUE
	name = "篱山炉乡"
	subtitle = "锻炉之乡, 萌生林山丘中的铁匠"
	description = "萌生林山丘中炭烟与锤声交织的国度, 篱山炉乡的铁匠氏族遵照祖母定下并将由孙女延续的周期烧林制炭. 锻炉吞下领地的矿石并产出工具, 刀剑, 以及群山以南最好的锁甲. 王权对这里课以轻税, 道理是不该惹恼为自己制造武器的人."
