// Faction cards: gronn.

/datum/ccg_card/rare_berserker
	id = "rare_berserker"
	name = "狂战士"
	desc = "受到狂战蘑菇影响时变成熊。"
	row = CCG_ROW_INFANTRY
	power = 4
	rarity = CCG_RARITY_BASE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_BERSERK
	limited = TRUE
	art = "ccg_cards/gronn_berserker.png"

/datum/ccg_card/unique_gronn_war_bear
	id = "unique_gronn_war_bear"
	name = "战熊"
	desc = "英雄。被狂战仪式唤醒的格隆恩战兽。"
	row = CCG_ROW_INFANTRY
	power = 10
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_GRONN
	art = "ccg_cards/gronn_war_bear.png"
	hero = TRUE

/datum/ccg_card/rare_gronn_privateer
	id = "rare_gronn_privateer"
	name = "格隆恩私掠者"
	desc = "在艰苦磨炼中养成纪律的北方劫掠者。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_BOND
	art = "ccg_cards/gronn_privateer.png"

/datum/ccg_card/rare_gronn_heavy
	id = "rare_gronn_heavy"
	name = "菲亚尔铁甲兵"
	desc = "披铁甲、裹毛皮的格隆恩重步兵。"
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_BERSERK
	art = "ccg_cards/gronn_heavy.png"

/datum/ccg_card/rare_gronn_bone_shaman
	id = "rare_gronn_bone_shaman"
	name = "格隆恩骨萨满"
	desc = "主持仪式的萨满，借狂战蘑菇将怒火化为战熊。"
	row = CCG_ROW_INFANTRY
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_MARDROEME
	target_row = CCG_ROW_INFANTRY
	art = "ccg_cards/gronn_bone_shaman.png"

/datum/ccg_card/rare_gronn_atgervi
	id = "rare_gronn_atgervi"
	name = "阿特格维"
	desc = "兼营贸易的格隆恩瓦兰吉战士，在远征中饱经磨炼。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_BOND
	art = "ccg_cards/gronn_atgervi.png"

/datum/ccg_card/rare_gronn_atgervi_shaman
	id = "rare_gronn_atgervi_shaman"
	name = "阿特格维萨满"
	desc = "唤醒狂战士的北方仪式主持者。"
	row = CCG_ROW_INFANTRY
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_MARDROEME
	target_row = CCG_ROW_INFANTRY
	art = "ccg_cards/gronn_atgervi_shaman.png"

/datum/ccg_card/unique_gronn_trollslayer
	id = "unique_gronn_trollslayer"
	name = "巨魔屠夫"
	desc = "英雄。赤身持斧立下誓言，从此再无退路。"
	row = CCG_ROW_INFANTRY
	power = 7
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_BERSERK
	art = "ccg_cards/gronn_trollslayer.png"
	hero = TRUE

/datum/ccg_card/unique_gronn_guds_klor
	id = "unique_gronn_guds_klor"
	name = "神之爪"
	desc = "英雄。利爪承载古老仪式的北方萨满。"
	row = CCG_ROW_INFANTRY
	power = 8
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/gronn_guds_klor.png"
	hero = TRUE

/datum/ccg_card/unique_gronn_norsian_griddar
	id = "unique_gronn_norsian_griddar"
	name = "诺尔西近卫"
	desc = "英雄。寻求新家园或光荣战死的异乡战士。"
	row = CCG_ROW_INFANTRY
	power = 7
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_GRONN
	effect = CCG_EFFECT_SCORCH_INFANTRY
	art = "ccg_cards/gronn_norsian_griddar.png"
	hero = TRUE
