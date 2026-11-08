#define CCG_ROW_INFANTRY "infantry"
#define CCG_ROW_ARCHERS "archers"
#define CCG_ROW_SIEGE "siege"
#define CCG_ROW_WEATHER "weather"
#define CCG_ROW_SPECIAL "special"

#define CCG_RARITY_BASE "base"
#define CCG_RARITY_RARE "rare"
#define CCG_RARITY_UNIQUE "unique"

#define CCG_EFFECT_NONE "none"
#define CCG_EFFECT_MORALE "morale"
#define CCG_EFFECT_SCORCH "scorch"
#define CCG_EFFECT_SCORCH_INFANTRY "scorch_infantry"
#define CCG_EFFECT_SCORCH_GLOBAL "scorch_global"
#define CCG_EFFECT_SPY "spy"
#define CCG_EFFECT_MEDIC "medic"
#define CCG_EFFECT_BOND "bond"
#define CCG_EFFECT_AGILE "agile"
#define CCG_EFFECT_MUSTER "muster"
#define CCG_EFFECT_HORN "horn"
#define CCG_EFFECT_DECOY "decoy"
#define CCG_EFFECT_BERSERK "berserk"
#define CCG_EFFECT_MARDROEME "mardroeme"
#define CCG_EFFECT_AVENGER "avenger"
#define CCG_EFFECT_CLEAR_WEATHER "clear_weather"
#define CCG_EFFECT_FROST "frost"
#define CCG_EFFECT_FOG "fog"
#define CCG_EFFECT_RAIN "rain"

#define CCG_FACTION_NEUTRAL "neutral"
#define CCG_FACTION_AZURIA "azuria"
#define CCG_FACTION_ENIGMA "enigma"
#define CCG_FACTION_NALEDI "naledi"
#define CCG_FACTION_GRENZELHOFT "grenzelhoft"
#define CCG_FACTION_RANESHI "raneshi"
#define CCG_FACTION_GRONN "gronn"
#define CCG_FACTION_KAZENGUN "kazengun"

#define CCG_FACTION_EFFECT_ROUND_WIN_DRAW "round_win_draw"
#define CCG_FACTION_EFFECT_KEEP_UNIT "keep_unit"
#define CCG_FACTION_EFFECT_WIN_DRAWS "win_draws"
#define CCG_FACTION_EFFECT_ROUND_LOSS_DRAW "round_loss_draw"
#define CCG_FACTION_EFFECT_REVIVE_UNIT "revive_unit"
#define CCG_FACTION_EFFECT_EXTRA_MULLIGAN "extra_mulligan"
#define CCG_FACTION_EFFECT_OPENING_DRAW "opening_draw"

#define CCG_LEADER_EFFECT_DRAW "draw"

#define CCG_COMBO_NONE "none"

GLOBAL_LIST_EMPTY(ccg_cards_by_id)
GLOBAL_LIST_EMPTY(ccg_base_card_ids)
GLOBAL_LIST_EMPTY(ccg_factions_by_id)
GLOBAL_LIST_EMPTY(ccg_leaders_by_id)

/proc/ccg_build_card_registry()
	GLOB.ccg_cards_by_id = list()
	GLOB.ccg_base_card_ids = list()
	for(var/path in subtypesof(/datum/ccg_card))
		var/datum/ccg_card/card = new path()
		if(!card.id)
			qdel(card)
			continue
		if(GLOB.ccg_cards_by_id[card.id])
			qdel(card)
			continue
		GLOB.ccg_cards_by_id[card.id] = card
		if(card.rarity == CCG_RARITY_BASE)
			GLOB.ccg_base_card_ids += card.id

/proc/ccg_card(card_id)
	if(!length(GLOB.ccg_cards_by_id))
		ccg_build_card_registry()
	return GLOB.ccg_cards_by_id[card_id]

/proc/ccg_card_allowed_for_faction(card_id, faction_id)
	var/datum/ccg_card/card = ccg_card(card_id)
	if(!card)
		return FALSE
	return card.faction == CCG_FACTION_NEUTRAL || card.faction == faction_id

/proc/ccg_base_cards_for_faction(faction_id)
	if(!length(GLOB.ccg_base_card_ids))
		ccg_build_card_registry()
	var/list/card_ids = list()
	for(var/card_id in GLOB.ccg_base_card_ids)
		var/datum/ccg_card/card = ccg_card(card_id)
		if(card && !card.limited && ccg_card_allowed_for_faction(card_id, faction_id))
			card_ids += card_id
	return card_ids

/proc/ccg_build_faction_registry()
	GLOB.ccg_factions_by_id = list()
	for(var/path in subtypesof(/datum/ccg_faction))
		var/datum/ccg_faction/faction = new path()
		if(!faction.id)
			qdel(faction)
			continue
		if(GLOB.ccg_factions_by_id[faction.id])
			qdel(faction)
			continue
		GLOB.ccg_factions_by_id[faction.id] = faction

/proc/ccg_faction(faction_id)
	if(!length(GLOB.ccg_factions_by_id))
		ccg_build_faction_registry()
	return GLOB.ccg_factions_by_id[faction_id]

/proc/ccg_build_leader_registry()
	GLOB.ccg_leaders_by_id = list()
	for(var/path in subtypesof(/datum/ccg_leader))
		var/datum/ccg_leader/leader = new path()
		if(!leader.id)
			qdel(leader)
			continue
		if(GLOB.ccg_leaders_by_id[leader.id])
			qdel(leader)
			continue
		GLOB.ccg_leaders_by_id[leader.id] = leader

/proc/ccg_leader(leader_id)
	if(!length(GLOB.ccg_leaders_by_id))
		ccg_build_leader_registry()
	return GLOB.ccg_leaders_by_id[leader_id]

/datum/ccg_card
	var/id
	var/name = "未命名卡牌"
	var/desc = ""
	var/row = CCG_ROW_INFANTRY
	var/power = 1
	var/rarity = CCG_RARITY_BASE
	var/faction = CCG_FACTION_NEUTRAL
	var/effect = CCG_EFFECT_NONE
	var/combo = CCG_COMBO_NONE
	var/list/combo_with = list()
	var/combo_effect = CCG_EFFECT_NONE
	var/target_row = ""
	var/bear_power = 8
	var/avenger_card = ""
	var/art = ""
	var/hero = FALSE
	var/limited = FALSE

/datum/ccg_card/proc/as_ui_data(known = TRUE, selected = FALSE)
	return list(
		"id" = id,
		"name" = name,
		"desc" = desc,
		"row" = row,
		"power" = power,
		"rarity" = rarity,
		"faction" = faction,
		"effect" = effect,
		"combo" = combo,
		"comboEffect" = combo_effect,
		"comboWith" = combo_with,
		"targetRow" = target_row,
		"art" = art,
		"artAtlas" = ccg_card_art_atlas_position(art),
		"hero" = hero,
		"limited" = limited,
		"known" = known,
		"selected" = selected
	)

/datum/ccg_leader
	var/id
	var/name = "未命名领袖"
	var/desc = ""
	var/faction = CCG_FACTION_AZURIA
	var/effect = CCG_EFFECT_NONE
	var/target_row = ""

/datum/ccg_leader/proc/as_ui_data(used = FALSE)
	return list(
		"id" = id,
		"name" = name,
		"desc" = desc,
		"faction" = faction,
		"effect" = effect,
		"targetRow" = target_row,
		"used" = used
	)

/datum/ccg_faction
	var/id
	var/name = "未命名阵营"
	var/desc = ""
	var/effect = CCG_EFFECT_NONE
	var/default_leader = ""

/datum/ccg_faction/proc/as_ui_data()
	return list(
		"id" = id,
		"name" = name,
		"desc" = desc,
		"effect" = effect,
		"defaultLeader" = default_leader
	)

/datum/ccg_faction/azuria
	id = CCG_FACTION_AZURIA
	name = "岩丘"
	desc = "秩序井然的封建军阵。赢得一局后抽一张牌。"
	effect = CCG_FACTION_EFFECT_ROUND_WIN_DRAW
	default_leader = "azuria_ducal_marshal"

/datum/ccg_faction/enigma
	id = CCG_FACTION_ENIGMA
	name = "恩尼格玛"
	desc = "暗藏手段，储备充足。对战开始时额外获得一张牌。"
	effect = CCG_FACTION_EFFECT_OPENING_DRAW
	default_leader = "enigma_vanguard_overseer"

/datum/ccg_faction/naledi
	id = CCG_FACTION_NALEDI
	name = "纳莱迪"
	desc = "兹班图仪式与沙漠学识。首局之后，每局开始时复活一个非英雄单位。"
	effect = CCG_FACTION_EFFECT_REVIVE_UNIT
	default_leader = "naledi_star_emir"

/datum/ccg_faction/grenzelhoft
	id = CCG_FACTION_GRENZELHOFT
	name = "格伦泽尔霍夫特"
	desc = "黑色帝国的严明军纪。平局时判为获胜，除非对手拥有相同能力。"
	effect = CCG_FACTION_EFFECT_WIN_DRAWS
	default_leader = "grenzelhoft_line_breaker"

/datum/ccg_faction/raneshi
	id = CCG_FACTION_RANESHI
	name = "拉涅申"
	desc = "兹班图的黄沙、商队与伏击。输掉一局后抽一张牌。"
	effect = CCG_FACTION_EFFECT_ROUND_LOSS_DRAW
	default_leader = "raneshi_court_veil"

/datum/ccg_faction/gronn
	id = CCG_FACTION_GRONN
	name = "格隆恩"
	desc = "北方的狂战士与劫掠者。每局结束后随机保留一个非英雄单位在场上。"
	effect = CCG_FACTION_EFFECT_KEEP_UNIT
	default_leader = "gronn_war_chief"

/datum/ccg_faction/kazengun
	id = CCG_FACTION_KAZENGUN
	name = "风郡"
	desc = "浪人、忍者与纪律严明的剑术流派。额外获得一次起手换牌机会。"
	effect = CCG_FACTION_EFFECT_EXTRA_MULLIGAN
	default_leader = "kazengun_shadow_daimyo"

/datum/ccg_leader/azuria/ducal_marshal
	id = "azuria_ducal_marshal"
	name = "公爵元帅"
	desc = "每场对战可清除一次所有天气。"
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_CLEAR_WEATHER

/datum/ccg_leader/azuria/kingsfield_captain
	id = "azuria_kingsfield_captain"
	name = "王田队长"
	desc = "每场对战可在己方步兵列放置一次指挥号角。"
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_INFANTRY

/datum/ccg_leader/enigma/vanguard_overseer
	id = "enigma_vanguard_overseer"
	name = "先锋督军"
	desc = "每场对战可摧毁一次战力最高的单位；并列时全部摧毁。"
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_SCORCH_GLOBAL

/datum/ccg_leader/enigma/redoubt_keeper
	id = "enigma_redoubt_keeper"
	name = "堡垒守护者"
	desc = "每场对战可清除一次所有天气。"
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_CLEAR_WEATHER

/datum/ccg_leader/naledi/star_emir
	id = "naledi_star_emir"
	name = "星辰埃米尔"
	desc = "每场对战可额外抽一张牌。"
	faction = CCG_FACTION_NALEDI
	effect = CCG_LEADER_EFFECT_DRAW

/datum/ccg_leader/naledi/sand_oracle
	id = "naledi_sand_oracle"
	name = "沙漠先知"
	desc = "每场对战可清除一次所有天气。"
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_CLEAR_WEATHER

/datum/ccg_leader/grenzelhoft/line_breaker
	id = "grenzelhoft_line_breaker"
	name = "破阵者"
	desc = "每场对战可在己方攻城列放置一次指挥号角。"
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_SIEGE

/datum/ccg_leader/grenzelhoft/iron_commissar
	id = "grenzelhoft_iron_commissar"
	name = "铁血督军"
	desc = "每场对战可摧毁一次战力最高的单位；并列时全部摧毁。"
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_SCORCH_GLOBAL

/datum/ccg_leader/raneshi/court_veil
	id = "raneshi_court_veil"
	name = "宫廷面纱"
	desc = "每场对战可清除一次所有天气。"
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_CLEAR_WEATHER

/datum/ccg_leader/raneshi/spice_broker
	id = "raneshi_spice_broker"
	name = "香料掮客"
	desc = "每场对战可额外抽一张牌。"
	faction = CCG_FACTION_RANESHI
	effect = CCG_LEADER_EFFECT_DRAW

/datum/ccg_leader/gronn/war_chief
	id = "gronn_war_chief"
	name = "战争酋长"
	desc = "每场对战可在己方步兵列放置一次指挥号角。"
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_INFANTRY

/datum/ccg_leader/gronn/bone_reader
	id = "gronn_bone_reader"
	name = "骨卜者"
	desc = "每场对战可清除一次所有天气。"
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_CLEAR_WEATHER

/datum/ccg_leader/kazengun/shadow_daimyo
	id = "kazengun_shadow_daimyo"
	name = "暗影大名"
	desc = "每场对战可额外抽一张牌。"
	faction = CCG_FACTION_KAZENGUN
	effect = CCG_LEADER_EFFECT_DRAW

/datum/ccg_leader/kazengun/ronin_master
	id = "kazengun_ronin_master"
	name = "浪人大师"
	desc = "每场对战可摧毁一次战力最高的单位；并列时全部摧毁。"
	faction = CCG_FACTION_KAZENGUN
	effect = CCG_EFFECT_SCORCH_GLOBAL

// Card definitions live in cards_common.dm and cards_<faction>.dm.
