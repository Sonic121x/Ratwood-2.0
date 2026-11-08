// Faction cards: grenzelhoft.

/datum/ccg_card/rare_grenzelhoft_doppelsoldner
	id = "rare_grenzelhoft_doppelsoldner"
	name = "双饷佣兵"
	desc = "受雇突破敌阵的格伦泽尔霍夫特突击步兵。"
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_BOND
	art = "ccg_cards/grenzelhoft_doppelsoldner.png"

/datum/ccg_card/rare_grenzelhoft_halberdier
	id = "rare_grenzelhoft_halberdier"
	name = "戟兵"
	desc = "佣兵公会核心部队中的长柄武器步兵。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_BASE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_MORALE
	limited = TRUE
	art = "ccg_cards/grenzelhoft_halberdier.png"

/datum/ccg_card/rare_grenzelhoft_crossbowman
	id = "rare_grenzelhoft_crossbowman"
	name = "格伦泽尔霍夫特弩手"
	desc = "纪律严明的弩手。与其他格伦泽尔霍夫特弩手建立连结。"
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_BOND
	art = "ccg_cards/grenzelhoft_crossbowman.png"

/datum/ccg_card/rare_grenzelhoft_jager
	id = "rare_grenzelhoft_jager"
	name = "格伦泽尔霍夫特猎兵"
	desc = "隶属黑色佣兵团的帝国林地猎手与神射手。"
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_SCORCH_INFANTRY
	art = "ccg_cards/grenzelhoft_jager.png"

/datum/ccg_card/rare_grenzelhoft_freifechter
	id = "rare_grenzelhoft_freifechter"
	name = "自由剑士"
	desc = "出身格伦泽尔霍夫特边境剑术流派的自由剑士。"
	row = CCG_ROW_INFANTRY
	power = 4
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/grenzelhoft_freifechter.png"

/datum/ccg_card/rare_grenzelhoft_foreign_fencer
	id = "rare_grenzelhoft_foreign_fencer"
	name = "异乡剑客"
	desc = "受训于格伦泽尔霍夫特剑术流派的游历武器大师。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/grenzelhoft_foreign_fencer.png"

/datum/ccg_card/rare_grenzelhoft_condottiero
	id = "rare_grenzelhoft_condottiero"
	name = "佣兵首领"
	desc = "以金钱统合弩手与长枪兵的受雇队长。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/grenzelhoft_condottiero.png"

/datum/ccg_card/rare_grenzelhoft_siege_mage
	id = "rare_grenzelhoft_siege_mage"
	name = "战阵学者"
	desc = "负责攻城工事的格伦泽尔霍夫特战阵学者。"
	row = CCG_ROW_SIEGE
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_SIEGE
	art = "ccg_cards/grenzelhoft_siege_mage.png"

/datum/ccg_card/unique_grenzelhoft_iron_captain
	id = "unique_grenzelhoft_iron_captain"
	name = "铁血队长"
	desc = "英雄。深谙焚毁最强单位时机的佣兵指挥官。"
	row = CCG_ROW_INFANTRY
	power = 7
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_GRENZELHOFT
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/grenzelhoft_iron_captain.png"
	hero = TRUE
