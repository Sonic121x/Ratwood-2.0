GLOBAL_LIST_EMPTY(standing_order_pool)

/datum/standing_order
	var/name
	var/description
	var/region_id
	var/list/required_items = list()
	var/total_payout = 0
	var/day_issued = 0
	var/day_expires = 0
	var/is_fulfilled = FALSE
	/// Relative weight when the daily roller picks a template from a region's pool.
	var/roll_weight = 1
	/// Spawned by a Steward petition. Payout is shaved by PETITION_TAX_MULT and the UI tags it.
	var/petitioned = FALSE
	var/pair_id
	var/pair_label
	var/pair_sibling_type

/// Returns assoc list of trade_good_id -> quantity. Randomized mix.
/datum/standing_order/proc/generate_item_mix()
	return list()

/// Called after region_id is set. Return the order's display name.
/datum/standing_order/proc/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 常备订单"

/// Called after region_id is set. Return a flavor paragraph.
/datum/standing_order/proc/generate_description(datum/economic_region/region)
	return "[region.name] 张贴了一份常备订单。"


// ============================================================================
// demand_rations - garrison/feast food demand
// ============================================================================
/datum/standing_order/demand_rations
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKCOAST = list("一船水手的给养", "一名私掠者的船员", "港口的守望队"),
		TRADE_REGION_NORTHFORT = list("一处边境驻军", "一名补充物资的守望军士", "一次民兵集结"),
		TRADE_REGION_HEARTFELT = list("伯爵的随从", "一支巡游守林队", "一支本地冒险团"),
		TRADE_REGION_KINGSFIELD = list("一座集镇", "一个村庄宴席委员会", "一名粮仓看守"),
	)

/datum/standing_order/demand_rations/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_GRAIN] = rand(25, 40)
	if(prob(60))
		mix[TRADE_GOOD_MEAT] = rand(6, 12)
	if(prob(60))
		mix[TRADE_GOOD_CHEESE] = rand(4, 10)
	return mix

/datum/standing_order/demand_rations/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 口粮征调"

/datum/standing_order/demand_rations/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]紧急征调补给。"
	return "[region.name] 的军需官需要口粮来供养部众。"


// ============================================================================
// demand_armaments - garrison weapons + armor
// ============================================================================
/datum/standing_order/demand_armaments
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKCOAST = list("一艘桨帆船的战士", "一支海盗团的装备", "港口的守望队"),
		TRADE_REGION_NORTHFORT = list("一处边境驻军", "一伙边境游兵", "一名守望军士"),
		TRADE_REGION_HEARTFELT = list("伯爵的随从", "一支本地的雇佣团", "一支巡游守林队"),
	)

/datum/standing_order/demand_armaments/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_IRON_INGOT] = rand(8, 14)
	if(prob(60))
		mix[TRADE_GOOD_STEEL_INGOT] = rand(3, 7)
	if(prob(60))
		mix[TRADE_GOOD_CURED_LEATHER] = rand(5, 10)
	return mix

/datum/standing_order/demand_armaments/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 军备征调"

/datum/standing_order/demand_armaments/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]必须在下一个战季来临前重新武装。"
	return "[region.name] 的军械官需要铸锭与兽皮来装备士兵。"


// ============================================================================
// demand_textile - tailors guild cloth + fiber
// ============================================================================
/datum/standing_order/demand_textile
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("一位本地裁缝", "一个集市摊位", "一名行商"),
		TRADE_REGION_HEARTFELT = list("一份制旗委托", "一名为随从制衣的纹章裁缝", "一份命名日衣装订单"),
	)

/datum/standing_order/demand_textile/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_CLOTH] = rand(30, 50)
	if(prob(75))
		mix[TRADE_GOOD_FIBERS] = rand(15, 30)
	return mix

/datum/standing_order/demand_textile/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 裁缝征调"

/datum/standing_order/demand_textile/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]需要成匹的布料与纤维。"
	return "[region.name] 的裁缝行会正在接受布料与纤维的委托。"


// ============================================================================
// demand_smithing - smithy guild ingots
// ============================================================================
/datum/standing_order/demand_smithing
	var/list/project_by_region = list(
		TRADE_REGION_DAFTSMARCH = list("铁匠行会", "铸造工坊", "一位订单积压的匠师"),
		TRADE_REGION_KINGSFIELD = list("一座村庄铁匠铺", "一名农具匠", "一位本地蹄铁匠"),
	)

/datum/standing_order/demand_smithing/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_IRON_INGOT] = rand(8, 14)
	if(prob(70))
		mix[TRADE_GOOD_COPPER_INGOT] = rand(5, 10)
	return mix

/datum/standing_order/demand_smithing/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 铁匠铺补给"

/datum/standing_order/demand_smithing/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]为本月的活计征购铸锭。"
	return "[region.name] 的一座铁匠铺为本月的活计订购铸锭。"


// ============================================================================
// demand_construction
// ============================================================================
/datum/standing_order/demand_construction_bulk
	pair_label = "建造"
	pair_sibling_type = /datum/standing_order/demand_construction_smithy
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKCOAST = list("一段港口护墙的加固", "一处海岸驻军的修缮"),
		TRADE_REGION_NORTHFORT = list("一处扩建堡垒的边境驻军", "一座瞭望塔的重建"),
		TRADE_REGION_HEARTFELT = list("一座大教堂的翻新", "伯爵厅堂的扩建"),
		TRADE_REGION_KINGSFIELD = list("一座集镇的道路工程", "一座粮仓的扩建"),
		TRADE_REGION_DAFTSMARCH = list("一处矿井巷道的加固", "铸造厂的扩建"),
		TRADE_REGION_ROSAWOOD = list("一座锯木厂的重建", "一条商道的修复"),
		TRADE_REGION_ROCKHILL = list("一段梯田墙的重建", "一座压榨坊的扩建"),
		TRADE_REGION_BLACKHOLT = list("一次事故后高塔的重建", "外圣所的 rebuild"),
		TRADE_REGION_SALTWICK = list("一座盐屋的重建", "码头的加固"),
	)

/datum/standing_order/demand_construction_bulk/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_STONE] = rand(40, 70)
	if(prob(70))
		mix[TRADE_GOOD_WOOD] = rand(12, 25)
	return mix

/datum/standing_order/demand_construction_bulk/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 建造：石作"

/datum/standing_order/demand_construction_bulk/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]需要从料场调运石料与木料。"
	return "[region.name] 的建造者需要从料场调运石料与木料。"

/datum/standing_order/demand_construction_smithy
	pair_label = "建造"
	pair_sibling_type = /datum/standing_order/demand_construction_bulk

/datum/standing_order/demand_construction_smithy/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_IRON_INGOT] = rand(4, 8)
	return mix

/datum/standing_order/demand_construction_smithy/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 建造：金属"

/datum/standing_order/demand_construction_smithy/generate_description(datum/economic_region/region)
	return "[region.name] 的同一批工程还需要铁匠铺提供铁件。"


// ============================================================================
// demand_exotic - wizards / alchemists
// ============================================================================
/datum/standing_order/demand_exotic
	var/list/project_by_region = list(
		TRADE_REGION_BLACKHOLT = list("一个巫师结社", "一位隐居的试剂买家", "一位肤色苍白得古怪、醉心学术的贵族"),
		TRADE_REGION_ROSAWOOD = list("一个德鲁伊圈社", "一位林中隐士", "一位流浪的草药巫"),
	)

/datum/standing_order/demand_exotic/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_DENDOR_ESSENCE] = rand(3, 6)
	if(prob(60))
		mix[TRADE_GOOD_SILK] = rand(8, 15)
	if(prob(60))
		mix[TRADE_GOOD_VISCERA] = rand(8, 15)
	return mix

/datum/standing_order/demand_exotic/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 巫师征调"

/datum/standing_order/demand_exotic/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]急需异域试剂。"
	return "[region.name] 的一个奥术团体为异域试剂出价不菲。"


// ============================================================================
// demand_fishery - fishmongers, salting houses
// ============================================================================
/datum/standing_order/demand_fishery
	var/list/project_by_region = list(
		TRADE_REGION_SALTWICK = list("鱼贩行会", "一位订单积压的盐渍匠", "一位码头旁的腌制作坊主"),
		TRADE_REGION_BLEAKCOAST = list("一船水手的给养", "一名私掠者的船员", "港口的守望队"),
		TRADE_REGION_KINGSFIELD = list("一名集市鱼贩", "一位村中腌制匠", "一名鱼货行商"),
	)

/datum/standing_order/demand_fishery/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_FISH_FILET] = rand(15, 25)
	mix[TRADE_GOOD_SALT] = rand(8, 15)
	return mix

/datum/standing_order/demand_fishery/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 鱼贩订单"

/datum/standing_order/demand_fishery/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]已下单订购鱼与盐。"
	return "[region.name] 的一家鱼铺正在接受鱼与盐的订单。"


// ============================================================================
// demand_orchard - chefs, apothecaries
// ============================================================================
/datum/standing_order/demand_orchard
	var/list/project_by_region = list(
		TRADE_REGION_ROCKHILL = list("一位果园主的收成", "一位山谷药剂师", "一座苹果酒压榨坊"),
		TRADE_REGION_KINGSFIELD = list("一位集市腌制匠", "一位村中药剂师", "一名草药行商"),
		TRADE_REGION_HEARTFELT = list("一次教堂施粥", "一位驻军药剂师", "一位为路途采买的济贫院修士"),
	)

/datum/standing_order/demand_orchard/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_APPLE] = rand(25, 45)
	if(prob(70))
		mix[TRADE_GOOD_JACKSBERRY] = rand(15, 28)
	if(prob(60))
		mix[TRADE_GOOD_CALENDULA] = rand(5, 12)
	return mix

/datum/standing_order/demand_orchard/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 果园需求"

/datum/standing_order/demand_orchard/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]需要果园产物与疗伤用的金盏花。"
	return "[region.name] 的一位腌制匠或药剂师正在收购果园货物。"


// ============================================================================
// urgent - emergency requisition spawned by a shortage economic event.
// ============================================================================
/datum/standing_order/urgent
	var/datum/weakref/source_event_ref

/datum/standing_order/urgent/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 紧急征调"

/datum/standing_order/urgent/generate_description(datum/economic_region/region)
	var/list/buyers = list("本地权贵", "一个商人联合体", "行会长老", "一位走投无路的市民", "本地豪绅")
	var/buyer = pick(buyers)
	var/datum/economic_event/E = source_event_ref?.resolve()
	if(E)
		return "[region.name] 正深受[E.name]之苦。[buyer]愿出高价化解这场危机。"
	return "[region.name] 的[buyer]已宣布紧急征调。"


// ============================================================================
// demand_equipment_armaments - finished weapons for a garrison
// ============================================================================
/datum/standing_order/demand_equipment_armaments
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKCOAST = list("一位整装待发的私掠船长", "一支海盗团", "一位港口守望队的军械长"),
		TRADE_REGION_NORTHFORT = list("一处边境驻军", "一位正在装备的守望军士", "一伙边境游兵"),
		TRADE_REGION_HEARTFELT = list("伯爵的随从", "一支本地的雇佣团", "一支为远征整装的战团"),
		TRADE_REGION_KINGSFIELD = list("一位集市军械长", "一位整装待发的游侠骑士", "一名暗巷军火掮客"),
	)
	var/list/one_ingot_pool = list(
		TRADE_GOOD_STEEL_ARMING_SWORD,
		TRADE_GOOD_STEEL_SHORTSWORD,
		TRADE_GOOD_STEEL_FALCHION,
		TRADE_GOOD_STEEL_MESSER,
		TRADE_GOOD_STEEL_SABRE,
		TRADE_GOOD_STEEL_MACE,
		TRADE_GOOD_STEEL_FLAIL,
	)
	var/list/two_ingot_pool = list(
		TRADE_GOOD_STEEL_LONGSWORD,
		TRADE_GOOD_STEEL_WARHAMMER,
		TRADE_GOOD_STEEL_BATTLEAXE,
	)

/datum/standing_order/demand_equipment_armaments/generate_item_mix()
	var/list/mix = list()
	var/primary_one = pick(one_ingot_pool)
	mix[primary_one] = rand(3, 5)
	if(prob(55))
		var/secondary_two = pick(two_ingot_pool)
		mix[secondary_two] = rand(1, 2)
	if(prob(55))
		mix[TRADE_GOOD_RECURVE_BOW] = rand(3, 6)
	return mix

/datum/standing_order/demand_equipment_armaments/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 武器订单"

/datum/standing_order/demand_equipment_armaments/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]需要成品武器，请送至仓库。"
	return "[region.name] 的一处驻军需要成品武器，请送至仓库。"


// ============================================================================
// demand_equipment_armor_heavy - finished metallic harness for a garrison
// ============================================================================
/datum/standing_order/demand_equipment_armor_heavy
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKCOAST = list("一艘桨帆船的战士", "一位整装待发的私掠船长", "一位港口守望队的军械长"),
		TRADE_REGION_NORTHFORT = list("一处边境驻军", "一位正在装备的守望军士", "一支换防归来的连队"),
		TRADE_REGION_HEARTFELT = list("伯爵的随从", "一支本地的雇佣团", "一个正在整装的骑士家族"),
		TRADE_REGION_KINGSFIELD = list("一位集市军械长", "一个骑士家族", "一位将赴比武的骑士"),
	)
	var/list/chain_pool = list(
		TRADE_GOOD_STEEL_CHAINMAIL,
		TRADE_GOOD_STEEL_HAUBERK,
		TRADE_GOOD_BRIGANDINE,
		TRADE_GOOD_BRIGANDINE_HEAVY,
	)
	var/list/plate_pool = list(
		TRADE_GOOD_STEEL_COATPLATES,
		TRADE_GOOD_STEEL_HALFPLATE,
		TRADE_GOOD_STEEL_FULLPLATE,
	)
	var/list/helm_pool = list(
		TRADE_GOOD_STEEL_HELM_KNIGHT,
		TRADE_GOOD_STEEL_HELM_BASCINET,
		TRADE_GOOD_STEEL_HELM_KETTLE,
	)
	var/list/extremity_pool = list(
		TRADE_GOOD_STEEL_MASK,
		TRADE_GOOD_CHAIN_GLOVES,
		TRADE_GOOD_PLATE_GAUNTLETS,
		TRADE_GOOD_STEEL_PLATE_LEGS,
	)

/datum/standing_order/demand_equipment_armor_heavy/generate_item_mix()
	var/list/mix = list()
	var/chain_or_plate = prob(60) ? chain_pool : plate_pool
	var/core = pick(chain_or_plate)
	mix[core] = rand(1, 2)
	if(prob(65))
		var/helm = pick(helm_pool)
		mix[helm] = rand(1, 2)
	if(prob(50))
		var/extremity = pick(extremity_pool)
		mix[extremity] = rand(1, 3)
	return mix

/datum/standing_order/demand_equipment_armor_heavy/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 甲胄订单"

/datum/standing_order/demand_equipment_armor_heavy/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]需要成品板甲，请送至仓库。"
	return "[region.name] 的一处驻军需要成品板甲，请送至仓库。"


// ============================================================================
// demand_equipment_armor_light - finished light/leather kit for a company
// ============================================================================
/datum/standing_order/demand_equipment_armor_light
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_BLEAKCOAST = list("港口守望队", "一支正在集结的海岸民兵", "一支正在整装的海盗团"),
		TRADE_REGION_NORTHFORT = list("一位正在装备的守望军士", "一伙边境游兵", "一次边境后备征召"),
		TRADE_REGION_HEARTFELT = list("一支巡游守林队", "伯爵的步兵军士", "一支本地冒险团"),
		TRADE_REGION_KINGSFIELD = list("一次乡村集结", "一支集镇连队", "一位正在整装的自耕农上尉"),
	)
	var/list/body_pool = list(
		TRADE_GOOD_PADDED_GAMBESON,
		TRADE_GOOD_HEAVY_LEATHER_COAT,
	)

/datum/standing_order/demand_equipment_armor_light/generate_item_mix()
	var/list/mix = list()
	var/primary_body = pick(body_pool)
	mix[primary_body] = rand(2, 3)
	if(prob(55))
		var/list/secondary_pool = body_pool - primary_body
		if(length(secondary_pool))
			mix[pick(secondary_pool)] = rand(1, 2)
	if(prob(65))
		mix[TRADE_GOOD_HARDENED_LEATHER_HELMET] = rand(1, 2)
	if(prob(50))
		mix[TRADE_GOOD_HARDENED_LEATHER_GORGET] = rand(1, 2)
	if(prob(45))
		mix[TRADE_GOOD_HEAVY_LEATHER_GLOVES] = rand(1, 3)
	if(prob(50))
		mix[TRADE_GOOD_CURED_LEATHER] = rand(4, 8)
	if(prob(40))
		mix[TRADE_GOOD_CLOTH] = rand(4, 8)
	return mix

/datum/standing_order/demand_equipment_armor_light/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 连队战袍"

/datum/standing_order/demand_equipment_armor_light/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]需要缝制装备与煮革装备，请送至仓库。"
	return "[region.name] 的一支连队需要缝制装备与煮革装备，请送至仓库。"


// ============================================================================
// demand_salt - bulk salt requisition
// ============================================================================
/datum/standing_order/demand_salt
	var/list/project_by_region = list(
		TRADE_REGION_SALTWICK = list("一位盐渍匠的大宗订单", "一次腌制棚的扩建", "腌制匠行会"),
		TRADE_REGION_KINGSFIELD = list("一位集市腌制匠", "一座村中熏制房", "一名补货的路边商贩"),
	)

/datum/standing_order/demand_salt/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_SALT] = rand(30, 55)
	return mix

/datum/standing_order/demand_salt/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 盐业征调"

/datum/standing_order/demand_salt/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]需要大宗盐货以腌制肉与鱼。"
	return "[region.name] 的腌制匠们需要大宗盐货。"


// ============================================================================
// demand_victualling_fleet - Saltwick fishing fleet's ration stores
// ============================================================================
/datum/standing_order/demand_victualling_fleet
	roll_weight = 2

/datum/standing_order/demand_victualling_fleet/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_GRAIN] = rand(20, 35)
	mix[TRADE_GOOD_DRIED_FISH] = rand(4, 7)
	if(prob(70))
		mix[TRADE_GOOD_MEAT] = rand(5, 10)
	if(prob(60))
		mix[TRADE_GOOD_CHEESE] = rand(4, 8)
	return mix

/datum/standing_order/demand_victualling_fleet/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 舰队给养"

/datum/standing_order/demand_victualling_fleet/generate_description(datum/economic_region/region)
	var/list/flavors = list(
		"[region.name] 的渔船队正为当季的出海储备物资。",
		"[region.name] 的码头工需要够海上吃用一个月的给养。",
		"[region.name] 的一位船长在船只启航前装载给养。",
	)
	return pick(flavors)


// ============================================================================
// demand_victualling_garrison - preserved rations for the garrisons
// ============================================================================
/datum/standing_order/demand_victualling_garrison
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_NORTHFORT = list("一处边境驻军", "一位补充物资的守望军士", "一座堡垒的军需官"),
		TRADE_REGION_BLEAKCOAST = list("一船水手的给养", "一处海岸驻军的储藏室", "一名私掠者的船员"),
		TRADE_REGION_HEARTFELT = list("伯爵的随从", "一支巡游守林队", "一支本地冒险团"),
	)

/datum/standing_order/demand_victualling_garrison/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_SALUMOI] = rand(4, 7)
	if(prob(70))
		mix[TRADE_GOOD_SAUSAGE] = rand(4, 7)
	if(prob(70))
		mix[TRADE_GOOD_GRAIN] = rand(15, 25)
	if(prob(50))
		mix[TRADE_GOOD_CHEESE] = rand(4, 8)
	return mix

/datum/standing_order/demand_victualling_garrison/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 驻军给养"

/datum/standing_order/demand_victualling_garrison/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]征调足以支撑驻军的耐储口粮。"
	return "[region.name] 的一处驻军正为下一轮换防储备耐储口粮。"


// ============================================================================
// demand_victualling_mines - Daftsmarch miners' long-shift provisions
// ============================================================================
/datum/standing_order/demand_victualling_mines
	roll_weight = 2

/datum/standing_order/demand_victualling_mines/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_SALUMOI] = rand(4, 7)
	if(prob(70))
		mix[TRADE_GOOD_OATS] = rand(15, 25)
	if(prob(55))
		mix[TRADE_GOOD_SAUSAGE] = rand(4, 7)
	if(prob(45))
		mix[TRADE_GOOD_BUTTER] = rand(2, 4)
	return mix

/datum/standing_order/demand_victualling_mines/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 矿工给养"

/datum/standing_order/demand_victualling_mines/generate_description(datum/economic_region/region)
	var/list/flavors = list(
		"[region.name] 的工头们要在地下漫长的夜班中喂养矿工。",
		"[region.name] 的矿场需要扎实的口粮让工队撑过这一周。",
		"[region.name] 的一位班头在储备不会在矿井里腐坏的干粮。",
	)
	return pick(flavors)


// ============================================================================
// demand_alchemical - finished potions for a chapel infirmary, conclave, or watch
// ============================================================================
/datum/standing_order/demand_alchemical
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_HEARTFELT = list("一间教堂医务室", "一位为路途采买的济贫院修士", "一位驻军军医"),
		TRADE_REGION_BLACKHOLT = list("一个巫师结社", "一位隐居的试剂买家", "一位眼睛红得古怪的贵族"),
		TRADE_REGION_BLEAKCOAST = list("一位桨帆船上的军医", "一名正在储备物资的私掠者船员", "一位海岸驻军的药剂师"),
		TRADE_REGION_NORTHFORT = list("一位边境军医", "一位补充物资的守望军士", "一伙边境游兵"),
		TRADE_REGION_KINGSFIELD = list("一位集市药剂师", "一位村中治疗者", "一名草药行商"),
	)
	var/list/medicinal_pool = list(
		TRADE_GOOD_HEALTH_POTION,
		TRADE_GOOD_STAM_POTION,
		TRADE_GOOD_ANTIDOTE_POTION,
	)
	var/list/premium_pool = list(
		TRADE_GOOD_STRONG_HEALTH_POTION,
		TRADE_GOOD_STRONG_MANA_POTION,
		TRADE_GOOD_STRONG_STAM_POTION,
		TRADE_GOOD_STRONG_ANTIDOTE_POTION,
		TRADE_GOOD_MANA_POTION,
	)

/datum/standing_order/demand_alchemical/generate_item_mix()
	var/list/mix = list()
	var/primary = pick(medicinal_pool)
	mix[primary] = rand(4, 8)
	if(prob(60))
		var/premium = pick(premium_pool)
		mix[premium] = max(mix[premium] || 0, rand(3, 6))
	return mix

/datum/standing_order/demand_alchemical/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 药剂订单"

/datum/standing_order/demand_alchemical/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]需要成品药水，请送至仓库。"
	return "[region.name] 的一位药剂师愿为送至仓库的成品药水付出厚酬。"


// ============================================================================
// demand_alchemical_warband - elite buff-potion order
// ============================================================================
/datum/standing_order/demand_alchemical_warband
	roll_weight = 1
	var/list/project_by_region = list(
		TRADE_REGION_BLACKHOLT = list("一个巫师结社", "一支战斗法师的雇佣队伍", "一位久不见阳光的贵族的狩猎团"),
		TRADE_REGION_HEARTFELT = list("伯爵的精锐随从", "神殿的勇士", "一支巡游守林队"),
		TRADE_REGION_KINGSFIELD = list("一次游侠骑士集会", "一位雇佣兵队长的战团", "一位贵族的狩猎团"),
		TRADE_REGION_NORTHFORT = list("一支边境突击队", "守望军士的精锐", "一支本地冒险团"),
	)
	var/list/buff_pool = list(
		// TRADE_GOOD_TRANSIS_DUST removed: no transis dust trade good defined in ES
		TRADE_GOOD_PERCEPTION_POTION,
		TRADE_GOOD_INTELLIGENCE_POTION,
		TRADE_GOOD_SPEED_POTION,
	)
	var/list/support_pool = list(
		TRADE_GOOD_STRONG_HEALTH_POTION,
		TRADE_GOOD_STRONG_MANA_POTION,
		TRADE_GOOD_STRONG_STAM_POTION,
		TRADE_GOOD_STRONG_ANTIDOTE_POTION,
	)

/datum/standing_order/demand_alchemical_warband/generate_item_mix()
	var/list/mix = list()
	var/buff_primary = pick(buff_pool)
	mix[buff_primary] = rand(2, 3)
	if(prob(55))
		var/buff_secondary = pick(buff_pool)
		mix[buff_secondary] = max(mix[buff_secondary] || 0, rand(2, 3))
	var/support = pick(support_pool)
	mix[support] = max(mix[support] || 0, rand(2, 3))
	return mix

/datum/standing_order/demand_alchemical_warband/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 战团药剂"

/datum/standing_order/demand_alchemical_warband/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]委托一批属性药剂与强效药剂。"
	return "[region.name] 的一支精锐队伍委托一批属性药剂与强效药剂。"


// ============================================================================
// demand_birthday_gift - a named noble's name-day gift basket
// ============================================================================
/datum/standing_order/demand_birthday_gift
	roll_weight = 1 // was 2 - it's in 7 of 9 regions, so its always-silk+jacksberries mix dominated the pool
	var/list/jewelry_pool = list(
		TRADE_GOOD_AMBER_RING,
		TRADE_GOOD_GOLD_RING,
		TRADE_GOOD_JADE_RING,
		TRADE_GOOD_OPAL_RING,
		TRADE_GOOD_AMBER_AMULET,
		TRADE_GOOD_JADE_AMULET,
		TRADE_GOOD_TURQ_AMULET,
		TRADE_GOOD_ROSE_BRACELETS,
		TRADE_GOOD_SHELL_BRACELETS,
	)
	var/list/garment_pool = list(
		TRADE_GOOD_NOBLECOAT,
		TRADE_GOOD_SILK_TUNIC,
		TRADE_GOOD_SEASONAL_GOWN,
	)

/datum/standing_order/demand_birthday_gift/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_SILK] = rand(3, 6)
	mix[TRADE_GOOD_JACKSBERRY] = rand(8, 14)
	if(prob(70))
		var/exotic = pick(TRADE_GOOD_LEMON, TRADE_GOOD_LIME, TRADE_GOOD_TANGERINE, TRADE_GOOD_PLUM)
		mix[exotic] = rand(3, 6)
	if(prob(70))
		var/jewel = pick(jewelry_pool)
		mix[jewel] = 1
	if(prob(60))
		var/garment = pick(garment_pool)
		mix[garment] = 1
	return mix

/datum/standing_order/demand_birthday_gift/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 寿辰贡礼"

/datum/standing_order/demand_birthday_gift/generate_description(datum/economic_region/region)
	var/list/celebrants = region.order_celebrants
	if(length(celebrants))
		return "[region.name] 的[pick(celebrants)]寿辰将至。其家族委托备办一份相称的贺礼。"
	return "[region.name] 的一位贵族即将过寿辰。其家族委托备办一份相称的贺礼。"


// ============================================================================
// demand_great_feast
// ============================================================================
/datum/standing_order/demand_great_feast_proteins
	roll_weight = 2
	pair_label = "盛宴"
	pair_sibling_type = /datum/standing_order/demand_great_feast_carbs
	var/list/feast_for_by_region = list(
		TRADE_REGION_KINGSFIELD = list("一座集镇的丰收宴", "一位乡绅的庄园", "一场婚宴"),
		TRADE_REGION_HEARTFELT = list("伯爵的高桌", "边地卫队的会堂宴"),
		TRADE_REGION_BLEAKCOAST = list("一位海主的高桌", "一场旗舰上的船长宴", "一次私掠者的归乡宴"),
		TRADE_REGION_NORTHFORT = list("驻军的冬至宴", "一位守望统领的餐桌"),
		TRADE_REGION_ROCKHILL = list("果园主的丰收厅", "一次压榨坊的庆典"),
	)

/datum/standing_order/demand_great_feast_proteins/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_BUTTER] = rand(8, 15)
	mix[TRADE_GOOD_MEAT] = rand(15, 25)
	if(prob(50))
		mix[TRADE_GOOD_POULTRY] = rand(5, 10)
	if(prob(40))
		mix[TRADE_GOOD_PORK] = rand(5, 10)
	return mix

/datum/standing_order/demand_great_feast_proteins/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 盛宴：肉铺"

/datum/standing_order/demand_great_feast_proteins/generate_description(datum/economic_region/region)
	if(prob(33))
		return "哈劳斯领主在[region.name]设下餐桌。其家族向肉铺征调黄油与牛肉。"
	var/list/feasts = feast_for_by_region[region.region_id]
	if(length(feasts))
		return "[region.name] 的[capitalize(pick(feasts))]向肉铺征调黄油与牛肉。"
	return "[region.name] 的一场盛宴向肉铺征调黄油与牛肉。"

/datum/standing_order/demand_great_feast_carbs
	roll_weight = 2
	pair_label = "盛宴"
	pair_sibling_type = /datum/standing_order/demand_great_feast_proteins

/datum/standing_order/demand_great_feast_carbs/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_GRAIN] = rand(30, 50)
	mix[TRADE_GOOD_CHEESE] = rand(8, 15)
	if(prob(70))
		var/fruit = pick(TRADE_GOOD_APPLE, TRADE_GOOD_PEAR, TRADE_GOOD_JACKSBERRY)
		mix[fruit] = rand(8, 14)
	return mix

/datum/standing_order/demand_great_feast_carbs/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 盛宴：膳房"

/datum/standing_order/demand_great_feast_carbs/generate_description(datum/economic_region/region)
	return "[region.name] 的同一场盛宴还需要膳房提供面包、奶酪与果园水果。"


// ============================================================================
// demand_frontier_gear - finished light/medium kit for the wardens and watch
// ============================================================================
/datum/standing_order/demand_frontier_gear
	roll_weight = 3
	var/list/project_by_region = list(
		TRADE_REGION_NORTHFORT = list("一位正在装备的守望军士", "一伙边境游兵", "一次边境后备征召"),
		TRADE_REGION_BLEAKCOAST = list("港口守望队", "一支正在集结的海岸巡队", "一支正在整装的海盗团"),
		TRADE_REGION_HEARTFELT = list("一支巡游守林队", "神殿的守卫", "一支本地冒险团"),
		TRADE_REGION_KINGSFIELD = list("一队乡村治安官", "一次本地集结", "一位正在整装的自耕农上尉"),
	)
	var/list/body_pool = list(
		TRADE_GOOD_PADDED_GAMBESON,
		TRADE_GOOD_HEAVY_LEATHER_COAT,
	)

/datum/standing_order/demand_frontier_gear/generate_item_mix()
	var/list/mix = list()
	mix[pick(body_pool)] = rand(2, 4)
	if(prob(70))
		mix[TRADE_GOOD_HARDENED_LEATHER_HELMET] = rand(2, 4)
	if(prob(55))
		mix[TRADE_GOOD_HEAVY_LEATHER_GLOVES] = rand(2, 4)
	if(prob(45))
		mix[TRADE_GOOD_RECURVE_BOW] = rand(3, 6)
	return mix

/datum/standing_order/demand_frontier_gear/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 边境驻军装备"

/datum/standing_order/demand_frontier_gear/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]需要适合游兵勤务的轻型装备。"
	return "[region.name] 的一次边境集结需要供守望队使用的轻型装备。"


// ============================================================================
// demand_court_finery - finished tailoring for the court and its lesser houses
// ============================================================================
/datum/standing_order/demand_court_finery
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("一个贵族家族的衣橱", "一份宫廷裁缝委托", "一位集市裁缝"),
		TRADE_REGION_HEARTFELT = list("伯爵的衣橱", "一次贵族授职典礼", "一个即将迎亲的家族"),
		TRADE_REGION_ROCKHILL = list("一处乡间庄园的春季衣橱", "一位贵族的寿辰华服", "一位怕晒的贵族当季试装"),
	)
	var/list/finery_pool = list(
		TRADE_GOOD_NOBLECOAT,
		TRADE_GOOD_SILK_TUNIC,
		TRADE_GOOD_SEASONAL_GOWN,
		TRADE_GOOD_MAID_DRESS,
		TRADE_GOOD_NOBLE_DRESS,
		TRADE_GOOD_VELVET_DRESS,
		TRADE_GOOD_ORNATE_SILK_DRESS,
		TRADE_GOOD_SILKY_DRESS,
		TRADE_GOOD_SPRING_GOWN,
		TRADE_GOOD_FALL_GOWN,
		TRADE_GOOD_WINTER_GOWN,
	)
	var/list/accessory_pool = list(
		TRADE_GOOD_LORDLY_CLOAK,
		TRADE_GOOD_LADY_SHORTCLOAK,
		TRADE_GOOD_FUR_OVERCOAT,
		TRADE_GOOD_FANCY_HAT,
		TRADE_GOOD_NOBLE_CHAPERON,
	)
	// Rare capstone piece - royal wardrobe tier.
	var/list/royal_pool = list(
		TRADE_GOOD_ROYAL_DRESS,
		TRADE_GOOD_PRISTINE_DRESS,
		TRADE_GOOD_GILDED_DRESS_SHIRT,
	)

/datum/standing_order/demand_court_finery/generate_item_mix()
	var/list/mix = list()
	mix[pick(finery_pool)] = rand(2, 4)
	if(prob(50))
		var/second = pick(finery_pool)
		mix[second] = rand(1, 3)
	if(prob(45))
		mix[pick(accessory_pool)] = rand(1, 2)
	if(prob(20))
		mix[pick(royal_pool)] = 1
	return mix

/datum/standing_order/demand_court_finery/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 宫廷华服订单"

/datum/standing_order/demand_court_finery/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]委托制作当季的成品衣装。"
	return "[region.name] 的一个贵族家族委托制作成品衣装。"


// ============================================================================
// demand_fine_joinery - wood + leather + iron + cloth, joiner's commission
// ============================================================================
/datum/standing_order/demand_fine_joinery
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("一位乡间庄园的木匠", "一处庄园的家具翻新", "一份神殿陈设订单"),
		TRADE_REGION_ROSAWOOD = list("一位木作大师的工坊", "一位路边家具匠"),
		TRADE_REGION_ROCKHILL = list("一处果园庄园的木匠", "一次压榨坊的整修"),
		TRADE_REGION_HEARTFELT = list("伯爵厅堂的陈设", "一处驻军厅堂的整修"),
	)

/datum/standing_order/demand_fine_joinery/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_WOOD] = rand(15, 28)
	mix[TRADE_GOOD_CLOTH] = rand(6, 12)
	if(prob(70))
		mix[TRADE_GOOD_IRON_INGOT] = rand(3, 6)
	if(prob(55))
		mix[TRADE_GOOD_CURED_LEATHER] = rand(4, 8)
	return mix

/datum/standing_order/demand_fine_joinery/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 木作委托"

/datum/standing_order/demand_fine_joinery/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]需要木作材料——木料、布料与铁。"
	return "[region.name] 的一位木匠需要制作精致家具的材料。"


// ============================================================================
// demand_artificery - mixed engineering bundle
// ============================================================================
/datum/standing_order/demand_artificery
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_DAFTSMARCH = list("机关师行会", "一位匠师的工作坊", "一份铸造师傅的委托"),
		TRADE_REGION_KINGSFIELD = list("一位宫廷机关师的工坊", "一位行会工程师的工坊", "一位暗巷机关匠"),
		TRADE_REGION_BLACKHOLT = list("一家结社的机关铺", "一位奥术工程师的工坊", "一位隐士工匠的大宗订单"),
		TRADE_REGION_NORTHFORT = list("一位驻军的工程师", "一位堡垒里的攻城工程师", "一支正在整装的边境工兵"),
	)

/datum/standing_order/demand_artificery/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_COPPER_INGOT] = rand(6, 12)
	mix[TRADE_GOOD_TIN_INGOT] = rand(4, 8)
	mix[TRADE_GOOD_COAL] = rand(8, 14)
	if(prob(70))
		mix[TRADE_GOOD_GLASS_BATCH] = rand(3, 6)
	if(prob(45))
		mix[TRADE_GOOD_MESS_KIT] = rand(2, 4)
	return mix

/datum/standing_order/demand_artificery/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 机关师工坊"

/datum/standing_order/demand_artificery/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]为下一批产品需要青铜料与锡。"
	return "[region.name] 的一位机关师正在收购青铜料与锡。"


// ============================================================================
// demand_jewelry - jeweler's stocking order
// ============================================================================
/datum/standing_order/demand_jewelry
	roll_weight = 3 // was 2 - players report jewelry commissions almost never appear
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("一位宫廷珠宝匠", "一位金匠大师", "一个贵族家族的衣橱"),
		TRADE_REGION_HEARTFELT = list("伯爵的珠宝匠", "一份神殿圣物匣的委托", "一个即将迎亲的家族"),
		TRADE_REGION_ROCKHILL = list("一位乡间庄园的珠宝匠", "一份寿辰华服的委托", "一位怕晒的贵族重镶传家宝"),
	)
	var/list/ring_pool = list(
		TRADE_GOOD_GOLD_RING,
		TRADE_GOOD_EMERALD_RING,
		TRADE_GOOD_AMBER_RING,
		TRADE_GOOD_JADE_RING,
		TRADE_GOOD_SHELL_RING,
		TRADE_GOOD_ROSE_RING,
		TRADE_GOOD_ONYXA_RING,
		TRADE_GOOD_TURQ_RING,
		TRADE_GOOD_CORAL_RING,
		TRADE_GOOD_OPAL_RING,
	)
	var/list/amulet_pool = list(
		TRADE_GOOD_AMBER_AMULET,
		TRADE_GOOD_JADE_AMULET,
		TRADE_GOOD_SHELL_AMULET,
		TRADE_GOOD_ROSE_AMULET,
		TRADE_GOOD_ONYXA_AMULET,
		TRADE_GOOD_TURQ_AMULET,
		TRADE_GOOD_CORAL_AMULET,
		TRADE_GOOD_OPAL_AMULET,
	)
	var/list/bracelet_pool = list(
		TRADE_GOOD_AMBER_BRACELETS,
		TRADE_GOOD_JADE_BRACELETS,
		TRADE_GOOD_SHELL_BRACELETS,
		TRADE_GOOD_ROSE_BRACELETS,
		TRADE_GOOD_ONYXA_BRACELETS,
		TRADE_GOOD_TURQ_BRACELETS,
		TRADE_GOOD_CORAL_BRACELETS,
		TRADE_GOOD_OPAL_BRACELETS,
	)
	var/list/circlet_pool = list(
		TRADE_GOOD_AMBER_CIRCLET,
		TRADE_GOOD_JADE_CIRCLET,
		TRADE_GOOD_SHELL_CIRCLET,
		TRADE_GOOD_ROSE_CIRCLET,
		TRADE_GOOD_ONYXA_CIRCLET,
		TRADE_GOOD_TURQ_CIRCLET,
		TRADE_GOOD_CORAL_CIRCLET,
		TRADE_GOOD_OPAL_CIRCLET,
	)

/datum/standing_order/demand_jewelry/generate_item_mix()
	var/list/mix = list()
	mix[pick(ring_pool)] = rand(2, 4)
	if(prob(60))
		mix[pick(amulet_pool)] = rand(1, 3)
	if(prob(45))
		mix[pick(bracelet_pool)] = rand(1, 3)
	if(prob(30))
		mix[pick(circlet_pool)] = 1 // showpiece
	if(prob(15))
		mix[TRADE_GOOD_DIAMOND_RING] = 1
	return mix

/datum/standing_order/demand_jewelry/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 珠宝匠委托"

/datum/standing_order/demand_jewelry/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]需要成品珠宝——戒指、护符、手镯与额饰——以充实存货。"
	return "[region.name] 的一位珠宝匠正在收购成品珠宝——戒指、护符、手镯与额饰。"


// ============================================================================
// demand_curio_collection - a collector buys the gemcarver's decorative work
// ============================================================================
/datum/standing_order/demand_curio_collection
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("一位宫廷古玩收藏家", "一份行会大厅的陈列委托", "一位商界巨子的会客厅"),
		TRADE_REGION_ROCKHILL = list("一位大亨的战利品室", "一处乡间庄园的会客厅", "一位肤色苍白得古怪的贵族的画廊"),
		TRADE_REGION_HEARTFELT = list("伯爵的庄园大厅", "一份神殿圣物匣的委托", "一个即将迎亲的家族"),
		TRADE_REGION_ROSAWOOD = list("一份林中神龛的供品", "一位隐居收藏家的代理人"),
	)
	var/list/small_curio_pool = list(
		TRADE_GOOD_CARVED_CAMEO,
		TRADE_GOOD_CARVED_FIGURINE,
		TRADE_GOOD_CARVED_VASE,
	)
	var/list/showpiece_pool = list(
		TRADE_GOOD_CARVED_FANCY_VASE,
		TRADE_GOOD_CARVED_BUST,
		TRADE_GOOD_CARVED_STATUE,
	)

/datum/standing_order/demand_curio_collection/generate_item_mix()
	var/list/mix = list()
	mix[pick(small_curio_pool)] = rand(2, 4)
	if(prob(50))
		mix[pick(small_curio_pool)] = rand(1, 3)
	if(prob(40))
		mix[pick(showpiece_pool)] = 1
	return mix

/datum/standing_order/demand_curio_collection/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 收藏家委托"

/datum/standing_order/demand_curio_collection/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]委托制作宝石雕刻古玩——任何石料皆可。"
	return "[region.name] 的一位收藏家委托制作宝石雕刻古玩——任何石料皆可。"


// ============================================================================
// demand_prosthetic_run - chapel/infirmary order: prosthetics + healing potions
// ============================================================================
/datum/standing_order/demand_prosthetic_run
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_HEARTFELT = list("一间教堂医务室", "一处济贫院的伤兵所", "一位战地军医的大宗订单"),
		TRADE_REGION_NORTHFORT = list("一位边境军医", "一处驻军医务室", "一伙伤退回乡的边境游兵"),
		TRADE_REGION_BLEAKCOAST = list("一位桨帆船上的军医", "一处港口伤兵所", "一名蹒跚归港的私掠者船员"),
	)

/datum/standing_order/demand_prosthetic_run/generate_item_mix()
	var/list/mix = list()
	var/primary_prosthetic = pick(TRADE_GOOD_BRONZE_PROSTHETIC, TRADE_GOOD_IRON_PROSTHETIC)
	mix[primary_prosthetic] = rand(2, 3)
	mix[TRADE_GOOD_HEALTH_POTION] = rand(4, 7)
	if(prob(60))
		mix[TRADE_GOOD_CURED_LEATHER] = rand(4, 8)
	return mix

/datum/standing_order/demand_prosthetic_run/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 医务室订单"

/datum/standing_order/demand_prosthetic_run/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]照料着大批伤员——急需义肢与药剂。"
	return "[region.name] 的一间医务室正在照料受伤的士兵与朝圣者。"


// ============================================================================
// demand_artificed_panoply - rare premium order: artificed plate + voltic gauntlets
// ============================================================================
/datum/standing_order/demand_artificed_panoply
	roll_weight = 1
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("一位公爵的军械总管", "一位骑士机关师的委托", "一位将赴比武的冠军"),
		TRADE_REGION_DAFTSMARCH = list("一份匠师的署名契约", "一份铸造师傅的杰作", "一件行会的展出作品"),
		TRADE_REGION_HEARTFELT = list("伯爵选定的冠军", "一次骑士授职典礼", "一位巡游守林队长"),
	)

/datum/standing_order/demand_artificed_panoply/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_STEEL_FULLPLATE] = 1
	if(prob(55))
		mix[TRADE_GOOD_VOLTIC_GAUNTLETS] = 1
	mix[TRADE_GOOD_STEEL_INGOT] = rand(8, 14)
	if(prob(50))
		mix[TRADE_GOOD_GOLD_INGOT] = rand(2, 4)
	return mix

/datum/standing_order/demand_artificed_panoply/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 机关甲胄"

/datum/standing_order/demand_artificed_panoply/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]委托一套机关板甲。杰作自有杰作的价钱。"
	return "[region.name] 的一位赞助人委托一套机关板甲。"


// ============================================================================
// demand_tournament
// ============================================================================
/datum/standing_order/demand_tournament_arms
	roll_weight = 2
	pair_label = "比武大会"
	pair_sibling_type = /datum/standing_order/demand_tournament_provisions
	var/list/project_by_region = list(
		TRADE_REGION_KINGSFIELD = list("三山比武大会", "樱溪比武场", "一次游侠骑士集会"),
		TRADE_REGION_HEARTFELT = list("边地比武大会", "伯爵在赤心城的比武场"),
		TRADE_REGION_ROCKHILL = list("果园比武大会", "县治的仲夏比武"),
	)
	var/list/weapon_pool = list(
		TRADE_GOOD_STEEL_ARMING_SWORD,
		TRADE_GOOD_STEEL_LONGSWORD,
		TRADE_GOOD_STEEL_MACE,
		TRADE_GOOD_STEEL_SABRE,
	)
	var/list/armor_pool = list(
		TRADE_GOOD_STEEL_CHAINMAIL,
		TRADE_GOOD_STEEL_HAUBERK,
		TRADE_GOOD_BRIGANDINE,
	)

/datum/standing_order/demand_tournament_arms/generate_item_mix()
	var/list/mix = list()
	mix[pick(weapon_pool)] = rand(3, 5)
	mix[pick(armor_pool)] = rand(2, 3)
	if(prob(50))
		mix[TRADE_GOOD_RECURVE_BOW] = rand(3, 5)
	return mix

/datum/standing_order/demand_tournament_arms/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 比武：兵装"

/datum/standing_order/demand_tournament_arms/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	if(length(projects))
		return "[region.name] 的[capitalize(pick(projects))]需要比武用的武器与护甲。主办者自会按价付酬。"
	return "[region.name] 的一场比武大会需要比武用的武器与护甲。主办者自会按价付酬。"

/datum/standing_order/demand_tournament_provisions
	roll_weight = 2
	pair_label = "比武大会"
	pair_sibling_type = /datum/standing_order/demand_tournament_arms

/datum/standing_order/demand_tournament_provisions/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_HEALTH_POTION] = rand(6, 10)
	mix[TRADE_GOOD_MANA_POTION] = rand(3, 5)
	mix[TRADE_GOOD_GRAIN] = rand(20, 35)
	mix[TRADE_GOOD_MEAT] = rand(10, 18)
	mix[TRADE_GOOD_BUTTER] = rand(5, 10)
	if(prob(60))
		mix[TRADE_GOOD_NOBLECOAT] = rand(1, 2)
	return mix

/datum/standing_order/demand_tournament_provisions/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - 比武：给养"

/datum/standing_order/demand_tournament_provisions/generate_description(datum/economic_region/region)
	return "[region.name] 的同一场比武大会还需要为冠军们备好药剂、宴席膳食与华服。"


// ============================================================================
// demand_arcane_commission - enchantment scrolls
// ============================================================================
/datum/standing_order/demand_arcane_commission
	roll_weight = 2
	var/list/project_by_region = list(
		TRADE_REGION_HEARTFELT = list("一位神殿的装帧师", "一个正在整装的骑士家族", "一位为路途采买的济贫院修士"),
		TRADE_REGION_ROCKHILL = list("一位大亨的书房", "一位乡间庄园的古玩收藏家", "一位肤色苍白得古怪、醉心学术的贵族"),
		TRADE_REGION_KINGSFIELD = list("一位为路途整装的游侠骑士", "一份行会的大宗订单", "一位集市法杖商"),
		TRADE_REGION_NORTHFORT = list("一位边境斥候队长", "一伙边境游兵", "一支本地冒险团"),
	)
	var/rolled_tier = "basic"

/datum/standing_order/demand_arcane_commission/generate_item_mix()
	var/list/mix = list()
	var/roll = rand(1, 100)
	if(roll <= 55)
		rolled_tier = "basic"
		mix[TRADE_GOOD_ENCHSCROLL_BASIC] = rand(3, 6)
	else if(roll <= 85)
		rolled_tier = "superior"
		mix[TRADE_GOOD_ENCHSCROLL_SUPERIOR] = rand(2, 4)
	else
		rolled_tier = "greater"
		mix[TRADE_GOOD_ENCHSCROLL_GREATER] = rand(1, 3)
	return mix

/datum/standing_order/demand_arcane_commission/generate_name(datum/economic_region/region)
	switch(rolled_tier)
		if("superior")
			return "[uppertext(region.name)] - 高阶奥术"
		if("greater")
			return "[uppertext(region.name)] - 至臻奥术"
		else
			return "[uppertext(region.name)] - 奥术委托"

/datum/standing_order/demand_arcane_commission/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	var/patron = length(projects) ? capitalize(pick(projects)) : "一位赞助人"
	switch(rolled_tier)
		if("superior")
			return "[region.name] 的[patron]委托高阶附魔卷轴——送至仓库即可，任何卷轴皆可。"
		if("greater")
			return "[region.name] 的[patron]委托至臻附魔卷轴——送至仓库即可，任何种类皆可。"
		else
			return "[region.name] 的[patron]委托基础附魔卷轴——任何法术流派皆可，送至仓库封存。"


// ============================================================================
// demand_trophy_heads
// ============================================================================
/datum/standing_order/demand_trophy_heads
	roll_weight = 1
	var/list/project_by_region = list(
		TRADE_REGION_HEARTFELT = list("伯爵的庄园大厅", "一位边地领主的画廊", "一座纹章官会所"),
		TRADE_REGION_ROCKHILL = list("一位猎主的战利品厅", "大猎场里的猎犬总管", "一位大亨的战利品室"),
	)
	var/rolled_variant = "minotaur"

/datum/standing_order/demand_trophy_heads/generate_item_mix()
	var/list/mix = list()
	var/roll = rand(1, 100)
	if(roll <= 50) // white stag heads don't exist in ES - its old 30% share folds into the others
		rolled_variant = "minotaur"
		mix[TRADE_GOOD_TROPHY_MINOTAUR] = rand(3, 6)
		if(prob(60))
			mix[TRADE_GOOD_TROPHY_DIREBEAR] = rand(1, 2)
	else
		rolled_variant = "troll"
		mix[TRADE_GOOD_TROPHY_TROLL] = rand(5, 6)
	return mix

/datum/standing_order/demand_trophy_heads/generate_name(datum/economic_region/region)
	switch(rolled_variant)
		if("troll")
			return "[uppertext(region.name)] - 巨魔首级"
		else
			return "[uppertext(region.name)] - 庄园战利品"

/datum/standing_order/demand_trophy_heads/generate_description(datum/economic_region/region)
	var/list/projects = project_by_region[region.region_id]
	var/patron = length(projects) ? capitalize(pick(projects)) : "一个贵族家族"
	switch(rolled_variant)
		if("troll")
			return "[region.name] 的[patron]想用巨魔首级装点厅堂——以儆效尤，警示任何胆敢试探边地之人。"
		else
			return "[region.name] 的[patron]为画廊委托战利品——将荒野的兽首驯服陈列。"
