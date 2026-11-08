// Common and neutral cards.

/datum/ccg_card/base_swordsman
	id = "base_swordsman"
	name = "剑士"
	desc = "可靠的步兵。"
	row = CCG_ROW_INFANTRY
	power = 4
	limited = TRUE
	combo_with = list("base_shieldman")
	combo_effect = CCG_EFFECT_MORALE
	art = "ccg_cards/swordsman.png"

/datum/ccg_card/base_spearman
	id = "base_spearman"
	name = "矛兵"
	desc = "与其他矛兵同列时战力翻倍。"
	row = CCG_ROW_INFANTRY
	power = 2
	effect = CCG_EFFECT_BOND
	limited = TRUE
	art = "ccg_cards/spearman.png"

/datum/ccg_card/base_archer
	id = "base_archer"
	name = "弓手"
	desc = "可靠的远程卡牌。"
	row = CCG_ROW_ARCHERS
	power = 2
	effect = CCG_EFFECT_AGILE
	limited = TRUE
	combo_with = list("base_longbowman")
	combo_effect = CCG_EFFECT_SCORCH
	art = "ccg_cards/young_archer.png"

/datum/ccg_card/base_crossbow
	id = "base_crossbow"
	name = "弩手"
	desc = "为远程部队提供士气支援。"
	row = CCG_ROW_ARCHERS
	power = 3
	effect = CCG_EFFECT_MORALE
	limited = TRUE
	art = "ccg_cards/crossbowman.png"

/datum/ccg_card/base_catapult
	id = "base_catapult"
	name = "投石车"
	desc = "与其他投石车同列时战力翻倍。"
	row = CCG_ROW_SIEGE
	power = 3
	effect = CCG_EFFECT_BOND
	limited = TRUE
	combo_with = list("base_ballista")
	combo_effect = CCG_EFFECT_SCORCH
	art = "ccg_cards/trebuchet.png"

/datum/ccg_card/base_ballista
	id = "base_ballista"
	name = "弩炮"
	desc = "攻城器械。"
	row = CCG_ROW_SIEGE
	power = 3
	effect = CCG_EFFECT_SCORCH_INFANTRY
	limited = TRUE
	combo_with = list("base_catapult")
	combo_effect = CCG_EFFECT_SCORCH
	art = "ccg_cards/ballista.png"

/datum/ccg_card/base_frost
	id = "base_frost"
	name = "刺骨冰霜"
	desc = "将步兵战力降为1。"
	row = CCG_ROW_WEATHER
	power = 0
	effect = CCG_EFFECT_FROST
	art = "ccg_cards/frost.png"

/datum/ccg_card/base_fog
	id = "base_fog"
	name = "蔽日浓雾"
	desc = "将弓手战力降为1。"
	row = CCG_ROW_WEATHER
	power = 0
	effect = CCG_EFFECT_FOG
	art = "ccg_cards/fog.png"

/datum/ccg_card/base_rain
	id = "base_rain"
	name = "倾盆大雨"
	desc = "将攻城单位战力降为1。"
	row = CCG_ROW_WEATHER
	power = 0
	effect = CCG_EFFECT_RAIN
	art = "ccg_cards/rain.png"

/datum/ccg_card/base_clear
	id = "base_clear"
	name = "晴空"
	desc = "清除所有天气效果。"
	row = CCG_ROW_WEATHER
	power = 0
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/clear_weather.png"

/datum/ccg_card/base_shieldman
	id = "base_shieldman"
	name = "盾兵"
	desc = "稳健的前线步兵。"
	row = CCG_ROW_INFANTRY
	power = 5
	limited = TRUE
	combo_with = list("base_swordsman")
	combo_effect = CCG_EFFECT_MORALE
	art = "ccg_cards/shield_swordsman.png"

/datum/ccg_card/base_banner_bearer
	id = "base_banner_bearer"
	name = "旗手"
	desc = "提升步兵士气。"
	row = CCG_ROW_INFANTRY
	power = 2
	effect = CCG_EFFECT_MORALE
	limited = TRUE
	art = "ccg_cards/banner_bearer.png"

/datum/ccg_card/base_guard
	id = "base_guard"
	name = "卫士"
	desc = "披甲步兵。"
	row = CCG_ROW_INFANTRY
	power = 4
	effect = CCG_EFFECT_MUSTER
	limited = TRUE
	art = "ccg_cards/shield_guard.png"

/datum/ccg_card/base_longbowman
	id = "base_longbowman"
	name = "长弓手"
	desc = "与其他长弓手同列时战力翻倍。"
	row = CCG_ROW_ARCHERS
	power = 2
	effect = CCG_EFFECT_BOND
	limited = TRUE
	combo_with = list("base_archer")
	combo_effect = CCG_EFFECT_SCORCH
	art = "ccg_cards/hood_archer.png"

/datum/ccg_card/base_blacksmith
	id = "base_blacksmith"
	name = "铁匠"
	desc = "为攻城部队提供士气支援。"
	row = CCG_ROW_SIEGE
	power = 2
	effect = CCG_EFFECT_MORALE
	limited = TRUE
	combo_with = list("base_supply_cart")
	combo_effect = CCG_EFFECT_MORALE
	art = "ccg_cards/blacksmith.png"

/datum/ccg_card/base_supply_cart
	id = "base_supply_cart"
	name = "补给车"
	desc = "攻城支援。"
	row = CCG_ROW_SIEGE
	power = 8
	limited = TRUE
	combo_with = list("base_blacksmith")
	combo_effect = CCG_EFFECT_MORALE
	art = "ccg_cards/supply_cart.png"

/datum/ccg_card/base_scout
	id = "base_scout"
	name = "斥候"
	desc = "轻型远程单位。"
	row = CCG_ROW_ARCHERS
	power = 4
	art = "ccg_cards/scout.png"

/datum/ccg_card/base_militia
	id = "base_militia"
	name = "民兵"
	desc = "提升步兵士气。"
	row = CCG_ROW_INFANTRY
	power = 2
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/militia.png"

/datum/ccg_card/base_mangonel
	id = "base_mangonel"
	name = "牵引投石机"
	desc = "基础攻城器械。"
	row = CCG_ROW_SIEGE
	power = 6
	art = "ccg_cards/mangonel.png"

/datum/ccg_card/base_field_medic
	id = "base_field_medic"
	name = "战地医师"
	desc = "维系战线。"
	row = CCG_ROW_INFANTRY
	power = 3
	effect = CCG_EFFECT_MEDIC
	art = "ccg_cards/field_medic.png"

/datum/ccg_card/base_decoy
	id = "base_decoy"
	name = "诱饵"
	desc = "将己方最强单位收回手牌。"
	row = CCG_ROW_SPECIAL
	power = 0
	effect = CCG_EFFECT_DECOY
	art = "ccg_cards/decoy.png"

/datum/ccg_card/base_horn_infantry
	id = "base_horn_infantry"
	name = "步兵号角"
	desc = "使己方步兵列所有单位战力翻倍。"
	row = CCG_ROW_SPECIAL
	power = 0
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_INFANTRY
	art = "ccg_cards/infantry_horn.png"

/datum/ccg_card/base_horn_archers
	id = "base_horn_archers"
	name = "弓手号角"
	desc = "使己方弓手列所有单位战力翻倍。"
	row = CCG_ROW_SPECIAL
	power = 0
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_ARCHERS
	art = "ccg_cards/archers_horn.png"

/datum/ccg_card/base_horn_siege
	id = "base_horn_siege"
	name = "攻城号角"
	desc = "使己方攻城列所有单位战力翻倍。"
	row = CCG_ROW_SPECIAL
	power = 0
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_SIEGE
	art = "ccg_cards/siege_horn.png"

/datum/ccg_card/base_scorch
	id = "base_scorch"
	name = "焦土"
	desc = "摧毁战场上战力最高的所有单位。"
	row = CCG_ROW_SPECIAL
	power = 0
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/scorch.png"

/datum/ccg_card/base_mardroeme
	id = "base_mardroeme"
	name = "狂战蘑菇"
	desc = "将己方步兵列的狂战士变为熊。"
	row = CCG_ROW_WEATHER
	power = 0
	effect = CCG_EFFECT_MARDROEME
	target_row = CCG_ROW_INFANTRY
	art = "ccg_cards/mardroeme.png"

/datum/ccg_card/rare_neutral_hedge_knight
	id = "rare_neutral_hedge_knight"
	name = "流浪骑士"
	desc = "中立冒险者。可加入任何牌组的流浪剑客。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/hedge_knight.png"

/datum/ccg_card/rare_neutral_witch
	id = "rare_neutral_witch"
	name = "女巫"
	desc = "中立冒险者。以奇异仪式驱散异常天气。"
	row = CCG_ROW_ARCHERS
	power = 3
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/witch.png"

/datum/ccg_card/rare_neutral_treasure_hunter
	id = "rare_neutral_treasure_hunter"
	name = "寻宝客"
	desc = "中立冒险者。以冒险换取手牌的间谍。"
	row = CCG_ROW_ARCHERS
	power = 1
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_SPY
	art = "ccg_cards/treasure_hunter.png"

/datum/ccg_card/rare_neutral_barber_surgeon
	id = "rare_neutral_barber_surgeon"
	name = "理发外科医师"
	desc = "中立冒险者。使一个阵亡单位重返战场。"
	row = CCG_ROW_INFANTRY
	power = 4
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_MEDIC
	art = "ccg_cards/barber_surgeon.png"

/datum/ccg_card/rare_neutral_battlemaster
	id = "rare_neutral_battlemaster"
	name = "战阵大师"
	desc = "中立冒险者。经验丰富的武器专家，能稳固步兵战线。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/battlemaster.png"

/datum/ccg_card/rare_neutral_duelist
	id = "rare_neutral_duelist"
	name = "决斗家"
	desc = "中立冒险者。身手敏捷的剑士，可应对两处战线。"
	row = CCG_ROW_INFANTRY
	power = 4
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/duelist.png"

/datum/ccg_card/rare_neutral_barbarian
	id = "rare_neutral_barbarian"
	name = "蛮战士"
	desc = "中立冒险者。凶猛的战士，能受激发起狂暴冲锋。"
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_BERSERK
	art = "ccg_cards/barbarian.png"

/datum/ccg_card/rare_neutral_ironclad
	id = "rare_neutral_ironclad"
	name = "铁甲战士"
	desc = "中立冒险者。以重甲和纪律筑成坚固战线。"
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_BOND
	art = "ccg_cards/ironclad.png"

/datum/ccg_card/rare_neutral_exorcist
	id = "rare_neutral_exorcist"
	name = "驱魔人"
	desc = "中立冒险者。以银制武器斩除最强威胁的猎魔人。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/exorcist.png"

/datum/ccg_card/rare_neutral_deprived
	id = "rare_neutral_deprived"
	name = "一无所有者"
	desc = "中立冒险者。一无所有的幸存者，召来更多绝望者加入战场。"
	row = CCG_ROW_INFANTRY
	power = 2
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_MUSTER
	art = "ccg_cards/deprived.png"

/datum/ccg_card/rare_neutral_sentinel
	id = "rare_neutral_sentinel"
	name = "守望者"
	desc = "中立冒险者。看守险路的游侠护卫。"
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/sentinel.png"

/datum/ccg_card/rare_neutral_wayfarer
	id = "rare_neutral_wayfarer"
	name = "远行客"
	desc = "中立冒险者。擅长追踪和追捕的猎手，作为间谍部署于敌方。"
	row = CCG_ROW_ARCHERS
	power = 2
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_SPY
	art = "ccg_cards/wayfarer.png"

/datum/ccg_card/rare_neutral_bombadier
	id = "rare_neutral_bombadier"
	name = "掷弹手"
	desc = "中立冒险者。以炸弹与炼金术击破最强的密集阵列。"
	row = CCG_ROW_SIEGE
	power = 4
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/bombardier.png"

/datum/ccg_card/rare_neutral_biome_wanderer
	id = "rare_neutral_biome_wanderer"
	name = "地貌行者"
	desc = "中立冒险者。驱散恶劣天气的荒野专家。"
	row = CCG_ROW_ARCHERS
	power = 3
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/biome_wanderer.png"

/datum/ccg_card/rare_neutral_aristocrat
	id = "rare_neutral_aristocrat"
	name = "贵族"
	desc = "中立冒险者。金钱、传闻和宫廷人脉换来两张牌。"
	row = CCG_ROW_INFANTRY
	power = 2
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_SPY
	art = "ccg_cards/aristocrat.png"

/datum/ccg_card/rare_neutral_knight_errant
	id = "rare_neutral_knight_errant"
	name = "游方骑士"
	desc = "中立冒险者。四处游历的骑士，其旗帜鼓舞整条战线。"
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/knight_errant.png"

/datum/ccg_card/rare_neutral_squire_errant
	id = "rare_neutral_squire_errant"
	name = "游方侍从"
	desc = "中立冒险者。能与另一名侍从建立连结的年轻扈从。"
	row = CCG_ROW_INFANTRY
	power = 3
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_BOND
	art = "ccg_cards/squire_errant.png"

/datum/ccg_card/rare_neutral_monk
	id = "rare_neutral_monk"
	name = "武僧"
	desc = "中立冒险者。研习奇迹与徒手武艺的云游侍僧。"
	row = CCG_ROW_INFANTRY
	power = 3
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_MEDIC
	art = "ccg_cards/monk.png"

/datum/ccg_card/rare_neutral_paladin
	id = "rare_neutral_paladin"
	name = "圣骑士"
	desc = "中立冒险者。稳住步兵列的神圣骑士。"
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/paladin.png"

/datum/ccg_card/rare_neutral_cantor
	id = "rare_neutral_cantor"
	name = "颂唱者"
	desc = "中立冒险者。使弓手列战力翻倍的圣歌歌者。"
	row = CCG_ROW_ARCHERS
	power = 2
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_ARCHERS
	art = "ccg_cards/cantor.png"

/datum/ccg_card/rare_neutral_missionary
	id = "rare_neutral_missionary"
	name = "传教士"
	desc = "中立冒险者。驱散恶劣天气的巡游传道者。"
	row = CCG_ROW_ARCHERS
	power = 2
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/missionary.png"

/datum/ccg_card/rare_neutral_nightblade
	id = "rare_neutral_nightblade"
	name = "夜刃"
	desc = "中立冒险者。黑暗中的虔诚利刃，作为间谍部署于敌方。"
	row = CCG_ROW_INFANTRY
	power = 2
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_SPY
	art = "ccg_cards/nightblade.png"

/datum/ccg_card/rare_neutral_aavnic_hussar
	id = "rare_neutral_aavnic_hussar"
	name = "阿夫尼克翼骑兵"
	desc = "中立佣兵。蒙受耻辱却仍追求荣誉的翼骑兵。"
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/aavnic_hussar.png"

/datum/ccg_card/rare_neutral_twilight_gunslinger
	id = "rare_neutral_twilight_gunslinger"
	name = "暮光枪手"
	desc = "中立佣兵。手握雷霆的奇异决斗者。"
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_SCORCH_INFANTRY
	art = "ccg_cards/twilight_gunslinger.png"

/datum/ccg_card/rare_neutral_vaquero
	id = "rare_neutral_vaquero"
	name = "牧侠"
	desc = "来自遥远牧场的中立佣兵骑手。"
	row = CCG_ROW_ARCHERS
	power = 3
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/vaquero.png"

/datum/ccg_card/rare_neutral_thief
	id = "rare_neutral_thief"
	name = "盗贼"
	desc = "中立冒险者。作为间谍出牌并抽两张牌的恶棍。"
	row = CCG_ROW_INFANTRY
	power = 1
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_SPY
	art = "ccg_cards/thief.png"

/datum/ccg_card/rare_neutral_bard
	id = "rare_neutral_bard"
	name = "吟游诗人"
	desc = "中立冒险者。以歌声与谎言鼓舞整条战线。"
	row = CCG_ROW_ARCHERS
	power = 3
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/bard.png"

/datum/ccg_card/rare_neutral_soundbreaker
	id = "rare_neutral_soundbreaker"
	name = "破音者"
	desc = "中立冒险者。好斗的吟游诗人，以节奏击溃敌军士气。"
	row = CCG_ROW_INFANTRY
	power = 4
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_SCORCH_INFANTRY
	art = "ccg_cards/soundbreaker.png"

/datum/ccg_card/rare_neutral_swashbuckler
	id = "rare_neutral_swashbuckler"
	name = "海上浪客"
	desc = "中立冒险者。灵巧剑术搭配阴损伎俩。"
	row = CCG_ROW_INFANTRY
	power = 4
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/swashbuckler.png"

/datum/ccg_card/rare_neutral_mystic
	id = "rare_neutral_mystic"
	name = "秘术师"
	desc = "中立冒险者。受信仰感召的奥术学徒，能令天空放晴。"
	row = CCG_ROW_ARCHERS
	power = 3
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/mystic.png"

/datum/ccg_card/rare_neutral_sage
	id = "rare_neutral_sage"
	name = "贤者"
	desc = "中立冒险者。持盾的治疗者，能复活一个阵亡单位。"
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_MEDIC
	art = "ccg_cards/sage.png"

/datum/ccg_card/rare_neutral_luminary
	id = "rare_neutral_luminary"
	name = "明光师"
	desc = "中立冒险者。只需现身便能增强战线的神圣剑士。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/luminary.png"

/datum/ccg_card/rare_neutral_sorcerer
	id = "rare_neutral_sorcerer"
	name = "术士"
	desc = "中立冒险者。精研奥术，以烈焰摧毁战场上最强的单位。"
	row = CCG_ROW_ARCHERS
	power = 5
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/sorcerer.png"

/datum/ccg_card/rare_neutral_spellsinger
	id = "rare_neutral_spellsinger"
	name = "咒歌者"
	desc = "中立冒险者。以奥术歌谣使弓手列战力翻倍。"
	row = CCG_ROW_ARCHERS
	power = 3
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_ARCHERS
	art = "ccg_cards/spellsinger.png"

/datum/ccg_card/rare_neutral_spellfist
	id = "rare_neutral_spellfist"
	name = "魔拳师"
	desc = "中立冒险者。灵活应对两处战线的奥术武者。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/spellfist.png"

/datum/ccg_card/rare_neutral_arcyne_trickster
	id = "rare_neutral_arcyne_trickster"
	name = "奥术诡术师"
	desc = "中立冒险者。施展障眼法抽取两张牌的法术窃贼。"
	row = CCG_ROW_ARCHERS
	power = 2
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_SPY
	art = "ccg_cards/arcyne_trickster.png"

/datum/ccg_card/rare_neutral_antiquarian
	id = "rare_neutral_antiquarian"
	name = "古物学者"
	desc = "中立冒险者。凭借学识与人脉找回一个阵亡单位。"
	row = CCG_ROW_ARCHERS
	power = 2
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_MEDIC
	art = "ccg_cards/antiquarian.png"

/datum/ccg_card/rare_neutral_forlorn_hope
	id = "rare_neutral_forlorn_hope"
	name = "绝望先锋佣兵"
	desc = "中立佣兵。凶狠搏命的先锋卡牌。"
	row = CCG_ROW_INFANTRY
	power = 4
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_SCORCH_INFANTRY
	art = "ccg_cards/forlorn_hope.png"

/datum/ccg_card/rare_neutral_confessor
	id = "rare_neutral_confessor"
	name = "告解师"
	desc = "中立审判庭猎手。以诡计揭露敌方步兵的弱点。"
	row = CCG_ROW_ARCHERS
	power = 4
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_SCORCH_INFANTRY
	art = "ccg_cards/confessor.png"

/datum/ccg_card/rare_neutral_disciple
	id = "rare_neutral_disciple"
	name = "门徒"
	desc = "中立审判庭武僧。以严厉教诲稳固战线。"
	row = CCG_ROW_INFANTRY
	power = 4
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/disciple.png"

/datum/ccg_card/rare_neutral_absolver
	id = "rare_neutral_absolver"
	name = "赦罪师"
	desc = "中立审判庭特使。以严苛仪式驱散场上的恶劣天气。"
	row = CCG_ROW_INFANTRY
	power = 5
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_CLEAR_WEATHER
	art = "ccg_cards/absolver.png"

/datum/ccg_card/rare_neutral_inquisitor
	id = "rare_neutral_inquisitor"
	name = "审判官"
	desc = "中立审判庭猎手。以裁决摧毁敌方最强的前线单位。"
	row = CCG_ROW_INFANTRY
	power = 6
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_SCORCH_INFANTRY
	art = "ccg_cards/inquisitor.png"

/datum/ccg_card/rare_neutral_psyaltrist
	id = "rare_neutral_psyaltrist"
	name = "圣咏师"
	desc = "中立审判庭颂唱者。以歌艺使步兵列战力翻倍。"
	row = CCG_ROW_INFANTRY
	power = 2
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_HORN
	target_row = CCG_ROW_INFANTRY
	art = "ccg_cards/psyaltrist.png"

/datum/ccg_card/unique_neutral_adjudicator
	id = "unique_neutral_adjudicator"
	name = "裁决者"
	desc = "中立英雄。获授初阶祈咒的普赛顿骑士。"
	row = CCG_ROW_INFANTRY
	power = 7
	rarity = CCG_RARITY_UNIQUE
	effect = CCG_EFFECT_MORALE
	art = "ccg_cards/adjudicator.png"
	hero = TRUE

/datum/ccg_card/unique_neutral_ordinator
	id = "unique_neutral_ordinator"
	name = "律令官"
	desc = "中立英雄。摧毁最强单位的重甲审判庭法官。"
	row = CCG_ROW_INFANTRY
	power = 8
	rarity = CCG_RARITY_UNIQUE
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/ordinator.png"
	hero = TRUE

/datum/ccg_card/unique_neutral_hag
	id = "unique_neutral_hag"
	name = "巫婆"
	desc = "中立英雄。来自荒野边陲、充满奇幻色彩的诅咒施术者。"
	row = CCG_ROW_WEATHER
	power = 0
	rarity = CCG_RARITY_UNIQUE
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/hag.png"
	hero = TRUE

/datum/ccg_card/unique_neutral_otavan_repentant
	id = "unique_neutral_otavan_repentant"
	name = "奥塔瓦忏悔者"
	desc = "中立英雄。被放逐的忏悔者，以异端之术猎杀最强单位。"
	row = CCG_ROW_ARCHERS
	power = 7
	rarity = CCG_RARITY_UNIQUE
	effect = CCG_EFFECT_SCORCH_GLOBAL
	art = "ccg_cards/otavan_repentant.png"
	hero = TRUE

/datum/ccg_card/rare_neutral_szorendnizine_shepherd
	id = "rare_neutral_szorendnizine_shepherd"
	name = "瑟伦德尼日内牧羊人"
	desc = "中立冒险者。在荒野与斧战中饱经磨炼的自由城牧羊人。"
	row = CCG_ROW_INFANTRY
	power = 4
	rarity = CCG_RARITY_RARE
	effect = CCG_EFFECT_AGILE
	art = "ccg_cards/szorendnizine_shepherd.png"
