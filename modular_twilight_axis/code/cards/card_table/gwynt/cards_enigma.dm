// Faction cards: enigma.

/datum/ccg_card/rare_saboteur
	id = "rare_saboteur"
	name = "破坏者"
	desc = "摧毁敌方最强的单位。"
	row = CCG_ROW_ARCHERS
	power = 2
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/enigma_saboteur.png"

/datum/ccg_card/unique_avenger
	id = "unique_avenger"
	name = "复仇者"
	desc = "小局结束时，在离场前召来更强的战士。"
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_AVENGER
	avenger_card = "unique_enigma_revenant"
	art = "ccg_cards/enigma_avenger.png"
	hero = TRUE

/datum/ccg_card/unique_enigma_revenant
	id = "unique_enigma_revenant"
	name = "复仇亡魂"
	desc = "应召而来的恩尼格玛勇士。"
	row = CCG_ROW_INFANTRY
	power = 10
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_ENIGMA
	art = "ccg_cards/enigma_revenant.png"
	hero = TRUE

/datum/ccg_card/rare_enigma_royal_guard
	id = "rare_enigma_royal_guard"
	name = "王家卫士"
	desc = "纪律严明的恩尼格玛扈从步兵。与其他王家卫士建立连结。"
	row = CCG_ROW_INFANTRY
	power = 3
	rarity = CCG_RARITY_BASE
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_BOND
	limited = TRUE
	art = "ccg_cards/enigma_royal_guard.png"

/datum/ccg_card/rare_enigma_vanguard_archer
	id = "rare_enigma_vanguard_archer"
	name = "先锋弓手"
	desc = "受训阻击敌军攻势的边境弓手。"
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_SCORCH_INFANTRY
	art = "ccg_cards/enigma_vanguard_archer.png"

/datum/ccg_card/rare_enigma_standard_bearer
	id = "rare_enigma_standard_bearer"
	name = "先锋旗手"
	desc = "使步兵列战力翻倍的旗手。"
	row = CCG_ROW_INFANTRY
	power = 0
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_INFANTRY
	art = "ccg_cards/enigma_standard_bearer.png"

/datum/ccg_card/unique_enigma_overseer
	id = "unique_enigma_overseer"
	name = "督军"
	desc = "英雄。以铁一般的纪律维持秩序的恩尼格玛战地指挥官。"
	row = CCG_ROW_INFANTRY
	power = 7
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/enigma_overseer.png"
	hero = TRUE

/datum/ccg_card/unique_enigma_court_physician
	id = "unique_enigma_court_physician"
	name = "宫廷医师"
	desc = "英雄。从弃牌堆中复活一个阵亡单位。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_ENIGMA
	effect = CCG_EFFECT_MEDIC
	art = "ccg_cards/enigma_court_physician.png"
	hero = TRUE
