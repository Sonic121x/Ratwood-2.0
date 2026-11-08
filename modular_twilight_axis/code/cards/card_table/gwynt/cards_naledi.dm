// Faction cards: naledi.

/datum/ccg_card/rare_naledi_hierophant
	id = "rare_naledi_hierophant"
	name = "纳莱迪大祭司"
	desc = "以仪式驱散场上天气的学者祭司。"
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/naledi_hierophant.png"

/datum/ccg_card/rare_naledi_vizier
	id = "rare_naledi_vizier"
	name = "纳莱迪维齐尔"
	desc = "兼任间谍的宫廷法师，部署到敌方场上并抽两张牌。"
	row = CCG_ROW_ARCHERS
	power = 2
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_SPY
	art = "ccg_cards/naledi_vizier.png"

/datum/ccg_card/rare_naledi_sojourner
	id = "rare_naledi_sojourner"
	name = "旅居者"
	desc = "游荡于沙漠的秘术师，可灵活选择部署位置。"
	row = CCG_ROW_ARCHERS
	power = 5
	rarity = CCG_RARITY_BASE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_AGILE
	limited = TRUE
	art = "ccg_cards/naledi_sojourner.png"

/datum/ccg_card/rare_naledi_zybantu_envoy
	id = "rare_naledi_zybantu_envoy"
	name = "兹班图使节"
	desc = "将纳莱迪仪式与沙漠律法融为一体的兹班图地方使节。"
	row = CCG_ROW_ARCHERS
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_MEDIC
	art = "ccg_cards/naledi_zybantu_envoy.png"

/datum/ccg_card/rare_naledi_yogi
	id = "rare_naledi_yogi"
	name = "云游苦修士"
	desc = "以仪式驱散场上天气的沙漠苦修士。"
	row = CCG_ROW_ARCHERS
	power = 2
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/naledi_yogi.png"

/datum/ccg_card/rare_naledi_refugee
	id = "rare_naledi_refugee"
	name = "纳莱迪难民"
	desc = "从饱受战火摧残的神学院逃出的幸存者，传承着残存的沙漠教义。"
	row = CCG_ROW_ARCHERS
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_MEDIC
	art = "ccg_cards/naledi_refugee.png"

/datum/ccg_card/unique_naledi_pontifex
	id = "unique_naledi_pontifex"
	name = "纳莱迪教宗"
	desc = "英雄。精研仪式与星辰、充满奇幻色彩的学者。"
	row = CCG_ROW_ARCHERS
	power = 8
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/naledi_pontifex.png"
	hero = TRUE

/datum/ccg_card/unique_naledian_psydon_mage
	id = "unique_naledian_psydon_mage"
	name = "纳莱迪普赛顿法师"
	desc = "英雄。受教会教义约束的元素奥术。"
	row = CCG_ROW_ARCHERS
	power = 7
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_NALEDI
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/naledian_psydon_mage.png"
	hero = TRUE
