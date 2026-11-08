// Faction cards: azuria (shown in-game as Rockhill).

/datum/ccg_card/rare_captain
	id = "rare_captain"
	name = "野战队长"
	desc = "提升本列士气。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/azuria_field_captain.png"

/datum/ccg_card/unique_spy
	id = "unique_spy"
	name = "宫廷间谍"
	desc = "部署到敌方场上，并抽两张牌。"
	row = CCG_ROW_INFANTRY
	power = 1
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_SPY
	art = "ccg_cards/azuria_court_spy.png"

/datum/ccg_card/rare_azuria_knight
	id = "rare_azuria_knight"
	name = "公爵骑士"
	desc = "具有奇幻昆特牌风格的岩丘重骑兵。与其他公爵骑士建立连结。"
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_BOND
	art = "ccg_cards/azuria_knight.png"

/datum/ccg_card/rare_azuria_squire
	id = "rare_azuria_squire"
	name = "武装侍从"
	desc = "为宫廷守住战线的年轻扈从。"
	row = CCG_ROW_INFANTRY
	power = 4
	rarity = CCG_RARITY_BASE
	faction = CCG_FACTION_AZURIA
	limited = TRUE
	art = "ccg_cards/azuria_squire.png"

/datum/ccg_card/rare_azuria_court_magician
	id = "rare_azuria_court_magician"
	name = "宫廷法师"
	desc = "以奥术支援大军、驱散阴霾的岩丘法师。"
	row = CCG_ROW_ARCHERS
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/azuria_court_magician.png"

/datum/ccg_card/rare_azuria_azurcaephan
	id = "rare_azuria_azurcaephan"
	name = "岩丘魔剑士"
	desc = "传承岩丘魔剑技艺，在近战中引导奥术之力。"
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/azuria_azurcaephan.png"

/datum/ccg_card/rare_azuria_grovewalker
	id = "rare_azuria_grovewalker"
	name = "岩丘林间行者"
	desc = "黑橡的游历守护者，带着秋日的优雅穿行于荒野。"
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/azuria_grovewalker.png"

/datum/ccg_card/unique_azuria_grand_duke
	id = "unique_azuria_grand_duke"
	name = "大公"
	desc = "英雄。公爵的旗帜凝聚起步兵战线。"
	row = CCG_ROW_INFANTRY
	power = 8
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/azuria_grand_duke.png"
	hero = TRUE

/datum/ccg_card/unique_azuria_imperial_spellblade
	id = "unique_azuria_imperial_spellblade"
	name = "帝国魔剑士"
	desc = "英雄。传承岩丘技艺、充满奇幻色彩的施法剑士。"
	row = CCG_ROW_INFANTRY
	power = 7
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_AZURIA
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/azuria_imperial_spellblade.png"
	hero = TRUE
