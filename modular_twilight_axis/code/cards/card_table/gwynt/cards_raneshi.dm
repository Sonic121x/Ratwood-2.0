// Faction cards: raneshi.

/datum/ccg_card/rare_raneshi_desert_janissary
	id = "rare_raneshi_desert_janissary"
	name = "沙海骑手耶尼切里"
	desc = "具有奇幻昆特牌风格的拉涅申沙漠城骑兵。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/raneshi_desert_janissary.png"

/datum/ccg_card/rare_raneshi_zeybek
	id = "rare_raneshi_zeybek"
	name = "沙海骑手泽贝克"
	desc = "迅捷的拉涅申散兵，可加入任一战线。"
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/raneshi_zeybek.png"

/datum/ccg_card/rare_raneshi_sahir
	id = "rare_raneshi_sahir"
	name = "沙海骑手幻术师"
	desc = "施展蜃景幻术、驱散场上天气的法师。"
	row = CCG_ROW_ARCHERS
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/raneshi_sahir.png"

/datum/ccg_card/rare_raneshi_miragefen_rogue
	id = "rare_raneshi_miragefen_rogue"
	name = "蜃沼游荡者"
	desc = "蒙面的拉涅申游荡者；作为间谍出牌并抽两张牌。"
	row = CCG_ROW_INFANTRY
	power = 2
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_SPY
	art = "ccg_cards/raneshi_miragefen_rogue.png"

/datum/ccg_card/rare_raneshi_azeb_guard
	id = "rare_raneshi_azeb_guard"
	name = "拉涅申阿塞卜卫士"
	desc = "为苏丹国守住战线的地方沙漠步兵。"
	row = CCG_ROW_INFANTRY
	power = 2
	rarity = CCG_RARITY_BASE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_BOND
	limited = TRUE
	art = "ccg_cards/raneshi_azeb_guard.png"

/datum/ccg_card/rare_raneshi_slaver
	id = "rare_raneshi_slaver"
	name = "拉涅申奴贩"
	desc = "残忍的捕奴者，移除场上最强的单位。"
	row = CCG_ROW_INFANTRY
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/raneshi_slaver.png"

/datum/ccg_card/rare_raneshi_forlorn_hope
	id = "rare_raneshi_forlorn_hope"
	name = "绝望先锋"
	desc = "出身拉涅申奴隶起义、以苦痛换取自由的佣兵。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_SCORCH_INFANTRY
	art = "ccg_cards/raneshi_forlorn_hope.png"

/datum/ccg_card/rare_raneshi_bronzeclad
	id = "rare_raneshi_bronzeclad"
	name = "拉涅申青铜甲士"
	desc = "来自帷幕宫廷、从竞技场中崛起的青铜战士。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/raneshi_bronzeclad.png"

/datum/ccg_card/rare_raneshi_thespian_errant
	id = "rare_raneshi_thespian_errant"
	name = "巡游演员"
	desc = "巡游拉涅申的竞技场历史表演者与帷幕宫廷旅人。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/raneshi_thespian_errant.png"

/datum/ccg_card/rare_raneshi_mushir
	id = "rare_raneshi_mushir"
	name = "元帅"
	desc = "沙漠城的元帅军衔。以严明号令使攻城列战力翻倍。"
	row = CCG_ROW_SIEGE
	power = 3
	rarity = CCG_RARITY_RARE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_SIEGE
	art = "ccg_cards/raneshi_mushir.png"

/datum/ccg_card/unique_raneshi_almah
	id = "unique_raneshi_almah"
	name = "沙海骑手阿尔玛"
	desc = "英雄。沙漠城传说中的拉涅申精锐骑手。"
	row = CCG_ROW_INFANTRY
	power = 8
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/raneshi_almah.png"
	hero = TRUE

/datum/ccg_card/unique_raneshi_amir
	id = "unique_raneshi_amir"
	name = "沙漠城埃米尔"
	desc = "英雄。沙漠宫廷至高权力的化身与旗帜。"
	row = CCG_ROW_INFANTRY
	power = 8
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/raneshi_amir.png"
	hero = TRUE

/datum/ccg_card/unique_raneshi_spice_prince
	id = "unique_raneshi_spice_prince"
	name = "香料亲王"
	desc = "英雄。以丝绸蒙面、凭财富调动军队的资助者。"
	row = CCG_ROW_ARCHERS
	power = 7
	rarity = CCG_RARITY_UNIQUE
	faction = CCG_FACTION_RANESHI
	effect = CCG_EFFECT_MEDIC
	art = "ccg_cards/raneshi_spice_prince.png"
	hero = TRUE
