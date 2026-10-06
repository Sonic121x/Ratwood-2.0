/datum/chimeric_tech_node
	// Make sure this identifier is unique
	var/name = "基础节点"
	var/description = "这是默认描述。"
	var/tech_path // The path of the actual implementation datum/object
	var/string_id = "BASE_NODE" // Used to find the datums in the tech subsytem

	var/unlocked = FALSE
	var/is_recipe_node = FALSE

	var/required_tier = 1        	// Heartbeast Language Tier requirement
	var/cost = 50                	// Tech Points cost
	var/list/prerequisites = list() // List of required node paths
	var/recipe_override = null

	var/selection_weight = 10    // Higher number = more likely to appear

/// HEALING MIRACLE TECHS
/datum/chimeric_tech_node/awaken_healing
	name = "唤醒神圣再生"
	description = "显著提升大多数治疗神迹的治疗效果。"
	string_id = "HEAL_TIER1"
	required_tier = 1
	cost = 15
	selection_weight = 15

/datum/chimeric_tech_node/enhanced_healing
	name = "强化神圣再生"
	description = "小幅提升大多数治疗神迹的治疗效果。"
	string_id = "HEAL_TIER2"
	required_tier = 3
	cost = 85
	selection_weight = 15
	prerequisites = list("HEAL_TIER1")

/datum/chimeric_tech_node/awaken_resurrection
	name = "唤醒神圣复生"
	description = "显著缩短复生类神迹的冷却时间。"
	string_id = "REVIVE_TIER1"
	required_tier = 2
	cost = 40
	selection_weight = 50
	prerequisites = list("HEAL_TIER1")

/datum/chimeric_tech_node/enhanced_resurrection
	name = "强化神圣复生"
	description = "显著降低复生类神迹的消耗。"
	string_id = "REVIVE_TIER2"
	required_tier = 3
	cost = 120
	selection_weight = 50
	prerequisites = list("REVIVE_TIER1")

// CRAFTING RECIPE TECHS
/datum/chimeric_tech_node/residual_frankenbrew
	name = "不纯灵辉过滤"
	description = "允许从不纯灵辉中提炼出少量供富尔门诺椅使用的复生药剂。"
	string_id = "LUX_FILTRATION"
	required_tier = 1
	cost = 5
	selection_weight = 5
	is_recipe_node = TRUE

/datum/chimeric_tech_node/meat_decoy
	name = "肉诱饵"
	description = "允许用新鲜肉块制作血肉诱饵，以分散敌对、低智怪物的注意力。"
	string_id = "FLESH_DECOYS"
	required_tier = 1
	cost = 5
	selection_weight = 5
	is_recipe_node = TRUE

/datum/chimeric_tech_node/viscera_decoy
	name = "脏器诱饵"
	description = "允许用内脏而非新鲜肉块制作血肉诱饵。"
	string_id = "VISCERA_DECOYS"
	required_tier = 1
	cost = 5
	selection_weight = 1
	is_recipe_node = TRUE
	prerequisites = list("FLESH_DECOYS")

/datum/chimeric_tech_node/black_rose
	name = "黑玫瑰合成"
	description = "允许用腐化血肉与兽血制作黑玫瑰。人们相信，心兽某种程度上正是由佩斯特拉亲手塑造，以压制这些玫瑰中潜伏的黑腐。"
	string_id = "BLACK_ROSE"
	required_tier = 4
	cost = 100
	selection_weight = 2
	prerequisites = list("INFESTATION_TIER3")
	is_recipe_node = TRUE

/datum/chimeric_tech_node/corpse_ticks
	name = "尸蜱"
	description = "允许水蛭蜱附着在尸体上，抽取其中的灵辉。"
	string_id = "CORPSE_TICKS"
	required_tier = 1
	cost = 5
	selection_weight = 1

/// INFESTATION CHARGE CAPACITY TECHS
/datum/chimeric_tech_node/infestation_capacity_1
	name = "强化感染容量"
	description = "将感染的最大充能提升至 5。"
	string_id = "INFESTATION_TIER1"
	required_tier = 1
	cost = 20
	selection_weight = 10

/datum/chimeric_tech_node/infestation_capacity_2
	name = "卓越感染容量"
	description = "将感染的最大充能提升至 9。"
	string_id = "INFESTATION_TIER2"
	required_tier = 2
	cost = 30
	selection_weight = 8
	prerequisites = list("INFESTATION_TIER1")

/datum/chimeric_tech_node/infestation_capacity_3
	name = "揭示佩斯特拉的神赐"
	description = "将感染的最大充能提升至 10。达到 10 层充能时，高阶佩斯特拉信徒可获得神圣重生。"
	string_id = "INFESTATION_TIER3"
	required_tier = 3
	cost = 50
	selection_weight = 6
	prerequisites = list("INFESTATION_TIER2")

/datum/chimeric_tech_node/infestation_rot_snacks
	name = "食物污染"
	description = "允许对食物施加感染，使其腐烂，并获得半层充能。"
	string_id = "INFESTATION_ROT_SNACKS"
	required_tier = 1
	cost = 8
	selection_weight = 4

/datum/chimeric_tech_node/infestation_rot_multiple_1
	name = "扩散污染"
	description = "对食物施加感染时，处理数量上限提升至 2，最多额外影响附近 1 个食物。"
	string_id = "INFESTATION_ROT_MULTIPLE_1"
	required_tier = 2
	cost = 25
	selection_weight = 10
	prerequisites = list("INFESTATION_ROT_SNACKS")

/datum/chimeric_tech_node/infestation_rot_multiple_2
	name = "群体污染"
	description = "对食物施加感染时，处理数量上限提升至 4，最多额外影响附近 3 个食物。"
	string_id = "INFESTATION_ROT_MULTIPLE_2"
	required_tier = 3
	cost = 40
	selection_weight = 8
	prerequisites = list("INFESTATION_ROT_MULTIPLE_1")

/datum/chimeric_tech_node/infestation_attack_vector
	name = "毒烈之刃"
	description = "疫刃附魔成功命中尚未感染的目标时，有 20% 的概率触发瘟疫效果。"
	string_id = "INFESTATION_ATTACK_VECTOR"
	required_tier = 1
	cost = 5
	selection_weight = 2
