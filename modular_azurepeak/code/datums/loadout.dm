GLOBAL_LIST_INIT(loadout_items, init_subtypes(/datum/loadout_item))

/datum/loadout_item
	var/name = "父级负载数据"
	var/desc
	var/path
	var/donoritem			//autoset on new if null
	var/list/ckeywhitelist
	var/triumph_cost
	var/keep_loadout_stats = FALSE	// If TRUE, item keeps default values (not nerfed)
	var/requires_nobility = FALSE	// If TRUE, it will check whether the player has the nobility quirk or noble job preference on high

/datum/loadout_item/New()
	if(isnull(donoritem))
		if(ckeywhitelist)
			donoritem = TRUE
	if (triumph_cost)
		desc += "消耗[triumph_cost]点凯旋点数。"

/datum/loadout_item/proc/donator_ckey_check(key)
	if(ckeywhitelist && ckeywhitelist.Find(key))
		return TRUE
	return

/datum/loadout_item/proc/nobility_check(client/character)
	if(!requires_nobility)
		return TRUE
	var/datum/preferences/player = character.prefs
	if(!player)
		return FALSE
	// Check if user has the Nobility quirk
	if(player.has_quirk(/datum/quirk/noble))
		return TRUE
	// Check if user has high priority for any noble, courtier, or yeoman job
	for(var/job_title in GLOB.noble_positions)
		if(player.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.courtier_positions)
		if(player.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.yeoman_positions)
		if(player.job_preferences[job_title] == JP_HIGH)
			return TRUE
	return FALSE

//Miscellaneous

/datum/loadout_item/card_deck
	name = "纸牌组"
	path = /obj/item/toy/cards/deck

/datum/loadout_item/farkle_dice
	name = "法克尔骰子容器"
	path = /obj/item/storage/pill_bottle/dice/farkle

/datum/loadout_item/gaming_dice
	name = "游戏骰子容器"
	path = /obj/item/storage/pill_bottle/dice

/datum/loadout_item/dwarven_dice
	name = "矮人骰子容器"
	path = /obj/item/storage/pill_bottle/dice/dwarven

/datum/loadout_item/bakers_dozen_dice
	name = "面包师十三骰子容器"
	path = /obj/item/storage/pill_bottle/dice/bakers_dozen

/datum/loadout_item/threes_away_dice
	name = "三去无踪骰子容器"
	path = /obj/item/storage/pill_bottle/dice/threes_away

/datum/loadout_item/dice_war_dice
	name = "骰战容器"
	path = /obj/item/storage/pill_bottle/dice/dice_war

/datum/loadout_item/liars_dice
	name = "吹牛骰子容器"
	path = /obj/item/storage/pill_bottle/dice/liars_dice

/datum/loadout_item/dice_poker
	name = "扑克骰子容器"
	path = /obj/item/storage/pill_bottle/dice/dice_poker

/datum/loadout_item/chess
	name = "Foldable Chessboard"
	path = /obj/item/chessboard_folded

/datum/loadout_item/arlette_azuria
	name = "Arlette Starter Deck (Rockhill)"
	path = /obj/item/ccg_deck/starter/azuria

/datum/loadout_item/arlette_enigma
	name = "Arlette Starter Deck (Enigma)"
	path = /obj/item/ccg_deck/starter/enigma

/datum/loadout_item/arlette_naledi
	name = "Arlette Starter Deck (Naledi)"
	path = /obj/item/ccg_deck/starter/naledi

/datum/loadout_item/arlette_grenzelhoft
	name = "Arlette Starter Deck (Grenzelhoft)"
	path = /obj/item/ccg_deck/starter/grenzelhoft

/datum/loadout_item/arlette_raneshi
	name = "Arlette Starter Deck (Raneshi)"
	path = /obj/item/ccg_deck/starter/raneshi

/datum/loadout_item/arlette_gronn
	name = "Arlette Starter Deck (Gronn)"
	path = /obj/item/ccg_deck/starter/gronn

/datum/loadout_item/arlette_kazengun
	name = "Arlette Starter Deck (Kazengun)"
	path = /obj/item/ccg_deck/starter/kazengun

/datum/loadout_item/tarot_deck
	name = "塔罗牌组"
	path = /obj/item/toy/cards/deck/tarot

/datum/loadout_item/tarot_deck_majorarcana
	name = "大阿卡那塔罗牌组"
	path = /obj/item/toy/cards/deck/tarot/majorarcana

/datum/loadout_item/custom_book
	name = "自定义书籍"
	path = /obj/item/paper/scroll/custom

/datum/loadout_item/hand_mirror
	name = "手镜"
	path = /obj/item/handmirror

//TOOLS

/datum/loadout_item/bauernwehr
	name = "农夫短剑"
	path = /obj/item/rogueweapon/huntingknife/throwingknife/bauernwehr
	triumph_cost = 3

/datum/loadout_item/broom
	name = "扫帚"
	path = /obj/item/broom
	triumph_cost = 1

/datum/loadout_item/soap
	name = "肥皂"
	path = /obj/item/soap
	triumph_cost = 3

/datum/loadout_item/candle
	name = "蜡烛"
	path = /obj/item/candle/yellow
	triumph_cost = 1

/datum/loadout_item/keyring
	name = "钥匙环"
	path = /obj/item/storage/keyring
	triumph_cost = 3

/datum/loadout_item/wooden_bowl
	name = "碗"
	path = /obj/item/reagent_containers/glass/bowl
	triumph_cost = 1

/datum/loadout_item/wooden_cup
	name = "杯子"
	path = /obj/item/reagent_containers/glass/cup/wooden
	triumph_cost = 1

/datum/loadout_item/bottle
	name = "瓶子"
	path = /obj/item/reagent_containers/glass/bottle/rogue
	triumph_cost = 1

/datum/loadout_item/waterskin
	name = "水袋"
	path = /obj/item/reagent_containers/glass/bottle/waterskin
	triumph_cost = 2

/datum/loadout_item/flint
	name = "燧石"
	path = /obj/item/flint
	triumph_cost = 2

/datum/loadout_item/aaneedle
	name = "刺针"
	path = /obj/item/needle/thorn
	triumph_cost = 2

/datum/loadout_item/bandage_roll
	name = "一卷绷带"
	path = /obj/item/natural/bundle/cloth/bandage/full
	triumph_cost = 3

/datum/loadout_item/sack
	name = "麻袋"
	path = /obj/item/storage/roguebag
	triumph_cost = 2

/datum/loadout_item/bedroll
	name = "Bedroll"
	path = /obj/item/bedroll
	triumph_cost = 3

/datum/loadout_item/tent_kit
	name = "Small Tent Kit"
	path = /obj/item/tent_kit
	triumph_cost = 5

/datum/loadout_item/mallet
	name = "木槌"
	path = /obj/item/rogueweapon/hammer/wood
	triumph_cost = 3

//ANCIENT TOOLS (Ancient Alloy)

/datum/loadout_item/ancient_hammer
	name = "古代锤"
	path = /obj/item/rogueweapon/hammer/ancient/decrepit
	triumph_cost = 3

/datum/loadout_item/ancient_tongs
	name = "古代钳子"
	path = /obj/item/rogueweapon/tongs/ancient
	triumph_cost = 3

/datum/loadout_item/ancient_pick
	name = "古代镐"
	path = /obj/item/rogueweapon/pick/decrepit
	triumph_cost = 3

/datum/loadout_item/ancient_shovel
	name = "古代铲"
	path = /obj/item/rogueweapon/shovel/decrepit
	triumph_cost = 3

/datum/loadout_item/ancient_hoe
	name = "古代锄"
	path = /obj/item/rogueweapon/hoe/decrepit
	triumph_cost = 3

/datum/loadout_item/ancient_sickle
	name = "古代镰刀"
	path = /obj/item/rogueweapon/sickle/decrepit
	triumph_cost = 3

/datum/loadout_item/ancient_thresher
	name = "古代连枷"
	path = /obj/item/rogueweapon/thresher/decrepit
	triumph_cost = 3

/datum/loadout_item/ancient_pitchfork
	name = "古代干草叉"
	path = /obj/item/rogueweapon/pitchfork/decrepit
	triumph_cost = 3

//COOKWARE
/datum/loadout_item/ancient_pan
	name = "古代平底锅"
	path = /obj/item/cooking/pan/decrepit
	triumph_cost = 2

/datum/loadout_item/ancient_pot
	name = "古代锅"
	path = /obj/item/reagent_containers/glass/bucket/pot/decrepit
	triumph_cost = 2

/datum/loadout_item/ancient_platter
	name = "古代大盘"
	path = /obj/item/cooking/platter/decrepit
	triumph_cost = 2

/datum/loadout_item/ancient_bowl
	name = "古代碗"
	path = /obj/item/reagent_containers/glass/bowl/decrepit
	triumph_cost = 2

/datum/loadout_item/ancient_mug
	name = "古代杯"
	path = /obj/item/reagent_containers/glass/cup/decrepitmug
	triumph_cost = 2

/datum/loadout_item/ancient_goblet
	name = "古代高脚杯"
	path = /obj/item/reagent_containers/glass/cup/decrepitgob
	triumph_cost = 2

/datum/loadout_item/ancient_spoon
	name = "古代勺"
	path = /obj/item/kitchen/spoon/decrepit
	triumph_cost = 2

/datum/loadout_item/ancient_fork
	name = "古代叉"
	path = /obj/item/kitchen/fork/decrepit
	triumph_cost = 2

// TENT KITS

/datum/loadout_item/small_tent
    name = "小帐篷"
    path = /obj/item/tent_kit
    triumph_cost = 4

/datum/loadout_item/ger_kit
    name = "毡帐"
    path = /obj/item/tent_kit/ger
    triumph_cost = 6

/datum/loadout_item/yurt_tent
     name = "圆顶毡帐"
     path = /obj/item/tent_kit/yurt
     triumph_cost = 8

/datum/loadout_item/bedroll
     name = "卷起的铺盖卷"
     path = /obj/item/bedroll
     triumph_cost = 2

//HATS
/datum/loadout_item/shalal
	name = "库菲耶头巾"
	path = /obj/item/clothing/head/roguetown/roguehood/shalal

/datum/loadout_item/tricorn
	name = "三角帽"
	path = /obj/item/clothing/head/roguetown/helmet/tricorn

/datum/loadout_item/maidband
	name = "女仆发带"
	path = /obj/item/clothing/head/roguetown/maidband

/datum/loadout_item/nurseveil
	name = "护士面纱"
	path = /obj/item/clothing/head/roguetown/veiled

/datum/loadout_item/archercap
	name = "弓手帽"
	path = /obj/item/clothing/head/roguetown/archercap

/datum/loadout_item/articap
	name = "工匠帽"
	path = /obj/item/clothing/head/roguetown/articap

/datum/loadout_item/strawhat
	name = "草帽"
	path = /obj/item/clothing/head/roguetown/strawhat

/datum/loadout_item/witchhat
	name = "女巫帽"
	path = /obj/item/clothing/head/roguetown/witchhat

/datum/loadout_item/witchhat/old
	name = "破旧女巫帽子"
	path = /obj/item/clothing/head/roguetown/witchhat/old

/datum/loadout_item/bardhat
	name = "诗人帽"
	path = /obj/item/clothing/head/roguetown/bardhat

/datum/loadout_item/duelhat
	name = "决斗帽"
	path = /obj/item/clothing/head/roguetown/duelisthat

/datum/loadout_item/fancyhat
	name = "华丽帽"
	path = /obj/item/clothing/head/roguetown/fancyhat

/datum/loadout_item/furhat
	name = "毛皮帽"
	path = /obj/item/clothing/head/roguetown/hatfur

/datum/loadout_item/bluehat
	name = "蓝色帽子"
	path = /obj/item/clothing/head/roguetown/hatblu

/datum/loadout_item/smokingcap
	name = "便帽"
	path = /obj/item/clothing/head/roguetown/smokingcap

/datum/loadout_item/headband
	name = "发带"
	path = /obj/item/clothing/head/roguetown/headband

/datum/loadout_item/buckled_hat
	name = "搭扣帽"
	path = /obj/item/clothing/head/roguetown/puritan

/datum/loadout_item/folded_hat
	name = "折帽"
	path = /obj/item/clothing/head/roguetown/bucklehat

/datum/loadout_item/duelist_hat
	name = "决斗者之帽"
	path = /obj/item/clothing/head/roguetown/duelhat

/datum/loadout_item/hood
	name = "兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood

/datum/loadout_item/necromhood
    name = "死灵法师兜帽"
    path = /obj/item/clothing/head/roguetown/necromhood

/datum/loadout_item/turban
	name = "头巾"
	path = /obj/item/clothing/head/roguetown/turban

/datum/loadout_item/fancypurple
	name = "华丽紫色头巾"
	path = /obj/item/clothing/head/roguetown/turban/fancypurple

/datum/loadout_item/hijab
	name = "头巾"
	path = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab

/datum/loadout_item/heavyhood
	name = "厚兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood

/datum/loadout_item/nunveil
	name = "修女面纱"
	path = /obj/item/clothing/head/roguetown/nun

/datum/loadout_item/papakha
	name = "高筒毛皮帽"
	path = /obj/item/clothing/head/roguetown/papakha

/datum/loadout_item/rosa_crown
	name = "玫瑰花冠"
	path = /obj/item/flowercrown/rosa

/datum/loadout_item/thorn_rosa_crown
	name = "带刺玫瑰花冠"
	path = /obj/item/flowercrown/rosa/thorns

/datum/loadout_item/dyeable_crown
	name = "灰色花冠"
	path = /obj/item/flowercrown/rosa/dyecrown

/datum/loadout_item/salvia_crown
	name = "鼠尾草花冠"
	path = /obj/item/flowercrown/salvia

/datum/loadout_item/matricaria_crown
	name = "洋甘菊花冠"
	path = /obj/item/flowercrown/matricaria

/datum/loadout_item/calendula_crown
	name = "金盏花花冠"
	path = /obj/item/flowercrown/calendula

/datum/loadout_item/manabloom_crown
	name = "魔力花花冠"
	path = /obj/item/flowercrown/manabloom

/datum/loadout_item/tri_grenzelhoft_hat_capless
	name = "无顶格伦泽尔霍夫特帽"
	path = /obj/item/clothing/head/roguetown/caplessgrenzelhofthat

/datum/loadout_item/loadoutpapakha
	name = "软边高加索毛帽"
	path = /obj/item/clothing/head/roguetown/loadoutpapakha

//CLOAKS
/datum/loadout_item/tabard
	name = "战袍"
	path = /obj/item/clothing/cloak/tabard

/datum/loadout_item/tabard/astrata
	name = "阿斯特拉塔战袍"
	path = /obj/item/clothing/cloak/templar/astrata

/datum/loadout_item/tabard/noc
	name = "诺克战袍"
	path = /obj/item/clothing/cloak/templar/noc

/datum/loadout_item/tabard/dendor
	name = "登多尔战袍"
	path = /obj/item/clothing/cloak/templar/dendor

/datum/loadout_item/tabard/malum
	name = "玛勒姆战袍"
	path = /obj/item/clothing/cloak/templar/malum

/datum/loadout_item/tabard/eora
	name = "伊欧拉战袍"
	path = /obj/item/clothing/cloak/templar/eora

/datum/loadout_item/tabard/pestra
	name = "佩斯特拉战袍"
	path = /obj/item/clothing/cloak/templar/pestra

/datum/loadout_item/tabard/ravox
	name = "拉沃克斯战袍"
	path = /obj/item/clothing/cloak/cleric/ravox

/datum/loadout_item/tabard/abyssor
	name = "阿比索尔战袍"
	path = /obj/item/clothing/cloak/templar/abyssor

/datum/loadout_item/tabard/necra
	name = "内克拉战袍"
	path = /obj/item/clothing/cloak/templar/necra

/datum/loadout_item/tabard/psydon
	name = "普赛顿战袍"
	path = /obj/item/clothing/cloak/templar/psydon

/datum/loadout_item/surcoat
	name = "外罩战袍"
	path = /obj/item/clothing/cloak/stabard

/datum/loadout_item/jupon
	name = "罩袍"
	path = /obj/item/clothing/cloak/stabard/surcoat

/datum/loadout_item/cape
	name = "披肩"
	path = /obj/item/clothing/cloak/cape

/datum/loadout_item/halfcloak
	name = "半披风"
	path = /obj/item/clothing/cloak/half

/datum/loadout_item/duelcape
	name = "决斗者披风"
	path = /obj/item/clothing/cloak/duelistcape

/datum/loadout_item/ridercloak
	name = "骑手斗篷"
	path = /obj/item/clothing/cloak/half/rider

/datum/loadout_item/raincloak
	name = "雨披"
	path = /obj/item/clothing/cloak/raincloak

/datum/loadout_item/furcloak
	name = "毛皮斗篷"
	path = /obj/item/clothing/cloak/raincloak/furcloak

/datum/loadout_item/direcloak
	name = "恐熊斗篷"
	path = /obj/item/clothing/cloak/darkcloak/bear

/datum/loadout_item/lightdirecloak
	name = "轻型恐熊斗篷"
	path = /obj/item/clothing/cloak/darkcloak/bear/light

/datum/loadout_item/volfmantle
	name = "沃尔夫披肩"
	path = /obj/item/clothing/cloak/volfmantle

/datum/loadout_item/eastcloak2
	name = "皮斗篷"
	path = /obj/item/clothing/cloak/eastcloak2

/datum/loadout_item/thief_cloak
	name = "无赖披巾"
	path = /obj/item/clothing/cloak/thief_cloak

/datum/loadout_item/wicker_cloak
	name = "柳编斗篷"
	path = /obj/item/clothing/cloak/wickercloak
/datum/loadout_item/tabardscarlet
	name = "绯红战袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/tabardscarlet

/datum/loadout_item/shroudscarlet
	name = "绯红战袍披巾"
	path = /obj/item/clothing/head/roguetown/roguehood/shroudscarlet

/datum/loadout_item/tabardblack
	name = "黑色战袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/tabardblack

/datum/loadout_item/shroudblack
	name = "黑色战袍披巾"
	path = /obj/item/clothing/head/roguetown/roguehood/shroudblack

/datum/loadout_item/tabardwhite
	name = "白色战袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/tabardwhite

/datum/loadout_item/shroudwhite
	name = "白色战袍披巾"
	path = /obj/item/clothing/head/roguetown/roguehood/shroudwhite

/datum/loadout_item/poncho
	name = "披毯"
	path = /obj/item/clothing/cloak/poncho

/datum/loadout_item/guardhood
	name = "守卫兜帽"
	path = /obj/item/clothing/cloak/stabard/guardhood

//SHOES
/datum/loadout_item/darkboots
	name = "深色靴"
	path = /obj/item/clothing/shoes/roguetown/boots

/datum/loadout_item/babouche
	name = "软皮拖鞋"
	path = /obj/item/clothing/shoes/roguetown/shalal

/datum/loadout_item/nobleboots
	name = "贵族靴"
	path = /obj/item/clothing/shoes/roguetown/boots/nobleboot

/datum/loadout_item/sandals
	name = "凉鞋"
	path = /obj/item/clothing/shoes/roguetown/sandals

/datum/loadout_item/toga_sandals
	name = "华丽凉鞋"
	path = /obj/item/clothing/shoes/roguetown/sandals/toga_sandals

/datum/loadout_item/shortboots
	name = "短靴"
	path = /obj/item/clothing/shoes/roguetown/shortboots

/datum/loadout_item/gladsandals
	name = "角斗士凉鞋"
	path = /obj/item/clothing/shoes/roguetown/gladiator

/datum/loadout_item/ridingboots
	name = "骑靴"
	path = /obj/item/clothing/shoes/roguetown/ridingboots

/datum/loadout_item/ankletscloth
	name = "布踝带"
	path = /obj/item/clothing/shoes/roguetown/boots/clothlinedanklets

/datum/loadout_item/ankletsfur
	name = "毛皮踝带"
	path = /obj/item/clothing/shoes/roguetown/boots/furlinedanklets

/datum/loadout_item/exoticanklets
	name = "异域踝带"
	path = /obj/item/clothing/shoes/roguetown/anklets

/datum/loadout_item/rumaclanshoes
	name = "高底凉鞋"
	path = /obj/item/clothing/shoes/roguetown/armor/rumaclan

/datum/loadout_item/simpleshoes
	name = "简易鞋"
	path = /obj/item/clothing/shoes/roguetown/simpleshoes

/datum/loadout_item/paddedfootwraps
	name = "衬垫裹脚布"
	path = /obj/item/clothing/shoes/roguetown/boots/footwraps/padded
	triumph_cost = 2

/datum/loadout_item/heleatherfootwraps
	name = "硬化皮革裹脚布"
	path = /obj/item/clothing/shoes/roguetown/boots/footwraps/hleather
	triumph_cost = 2

//SHIRTS
/datum/loadout_item/longcoat
	name = "长外套"
	path = /obj/item/clothing/suit/roguetown/armor/longcoat

/datum/loadout_item/robe
	name = "长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe

/datum/loadout_item/Necromrobe
    name = "死灵法师长袍"
    path = /obj/item/clothing/suit/roguetown/shirt/robe/necromancer

/datum/loadout_item/guilder_jacket
	name = "行会夹克"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/merchant

/datum/loadout_item/phys_robe
	name = "医者长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/phys

/datum/loadout_item/feld_robe
	name = "军医长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/feld

/datum/loadout_item/formalsilks
	name = "礼服丝衣"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan

/datum/loadout_item/longshirt
	name = "衬衣"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/black

/datum/loadout_item/shortshirt
	name = "短袖衬衣"
	path = /obj/item/clothing/suit/roguetown/shirt/shortshirt

/datum/loadout_item/sailorshirt
	name = "条纹衬衣"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor

/datum/loadout_item/sailorshirt_colorable
	name = "可染色条纹衬衣"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/colored

/datum/loadout_item/sailorjacket
	name = "皮夹克"
	path = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor

/datum/loadout_item/artijacket
	name = "工匠夹克"
	path = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket

/datum/loadout_item/priestrobe
	name = "内衬衣物"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest

/datum/loadout_item/exoticsilkbra
	name = "异域丝胸衣"
	path = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra

/datum/loadout_item/greenbra
	name = "绿色异域丝绸胸罩"
	path = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/green

/datum/loadout_item/redbra
	name = "红色异域丝绸胸罩"
	path = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra/red

/datum/loadout_item/bisht
	name = "比什特长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/bisht

/datum/loadout_item/bishtpurple
	name = "紫色比什特长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/purple

/datum/loadout_item/thawb
	name = "索布长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/thawb

/datum/loadout_item/thawbgold
	name = "金边索布长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
	triumph_cost = 1

/datum/loadout_item/bottomtunic
	name = "低领束腰衫"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut

/datum/loadout_item/tribalrag
	name = "部族布衣"
	path = /obj/item/clothing/suit/roguetown/shirt/tribalrag

/datum/loadout_item/tunic
	name = "束腰衫"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic

/datum/loadout_item/stripedtunic
	name = "条纹束腰衫"
	path = /obj/item/clothing/suit/roguetown/armor/workervest

/datum/loadout_item/formalshirt
	name = "礼服衬衣"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal

/datum/loadout_item/servantdress
	name = "仆役长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/maid/servant

/datum/loadout_item/maiddress
	name = "女仆长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/maid

/datum/loadout_item/dress
	name = "长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen

/datum/loadout_item/dress/bardress
	name = "酒馆女侍长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress

/datum/loadout_item/dress/chemise
	name = "衬裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress

/datum/loadout_item/dress/sexydress
	name = "轻薄长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy

/datum/loadout_item/dress/straplessdress
	name = "抹胸长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless

/datum/loadout_item/dress/straplessdress/alt
	name = "抹胸连衣裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/alt

/datum/loadout_item/dress/silkydress
	name = "丝质长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress

/datum/loadout_item/dress/nobledress
	name = "贵族长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/noble

/datum/loadout_item/dress/velvetdress
	name = "天鹅绒长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/velvet

/datum/loadout_item/dress/winterdress_light
	name = "寒地长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/winterdress_light

/datum/loadout_item/gown
	name = "春装礼裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown

/datum/loadout_item/gown/summer
	name = "夏装礼裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown/summergown

/datum/loadout_item/gown/fall
	name = "秋装礼裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown/fallgown

/datum/loadout_item/gown/winter
	name = "冬装礼裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown

/datum/loadout_item/gown/silkydress
	name = "丝裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress

/datum/loadout_item/noblecoat
	name = "华丽外套"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat

/datum/loadout_item/tailcoat
	name = "燕尾服"
	path = /obj/item/clothing/armor/gambeson/tailcoat

/datum/loadout_item/leathervest
	name = "皮背心"
	path = /obj/item/clothing/suit/roguetown/armor/leather/vest

/datum/loadout_item/nun_habit
	name = "修女服"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/nun

/datum/loadout_item/eastshirt1
	name = "黑色异邦衬衣"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1

/datum/loadout_item/eastshirt2
	name = "白色异邦衬衣"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
//PANTS
/datum/loadout_item/loincloth
	name = "兜裆布"
	path = /obj/item/clothing/under/roguetown/loincloth

/datum/loadout_item/tights
	name = "布紧身裤"
	path = /obj/item/clothing/under/roguetown/tights/black

/datum/loadout_item/leathertights
	name = "皮紧身裤"
	path = /obj/item/clothing/under/roguetown/trou/leathertights

/datum/loadout_item/formalshorts
	name = "礼服短裤"
	path = /obj/item/clothing/under/roguetown/trou/formal/shorts

/datum/loadout_item/formaltrousers
	name = "礼服长裤"
	path = /obj/item/clothing/under/roguetown/trou/formal

/datum/loadout_item/trou
	name = "工作长裤"
	path = /obj/item/clothing/under/roguetown/trou

/datum/loadout_item/leathertrou
	name = "皮长裤"
	path = /obj/item/clothing/under/roguetown/trou/leather

/datum/loadout_item/leathershorts
	name = "皮短裤"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts

/datum/loadout_item/sailorpants
	name = "航海裤"
	path = /obj/item/clothing/under/roguetown/tights/sailor

/datum/loadout_item/skirt
	name = "裙子"
	path = /obj/item/clothing/under/roguetown/skirt

/datum/loadout_item/sirwal
	name = "宽松灯笼裤"
	path = /obj/item/clothing/under/roguetown/sirwal

/datum/loadout_item/thong
	name = "丁字裤"
	path = /obj/item/clothing/under/roguetown/thong

//ACCESSORIES
/datum/loadout_item/wrappings
	name = "手缠布"
	path = /obj/item/clothing/wrists/roguetown/wrappings


/datum/loadout_item/bronze_duelist_goggles
	name = "青铜决斗者护目镜"
	path = /obj/item/clothing/mask/rogue/spectacles/duelist/bronze

/datum/loadout_item/golden_spectacles
	name = "金框眼镜"
	path = /obj/item/clothing/mask/rogue/spectacles/golden

/datum/loadout_item/fingerless_leather_gloves
	name = "露指皮手套"
	path = /obj/item/clothing/gloves/roguetown/fingerless_leather

/datum/loadout_item/allwrappings
	name = "布缠带"
	path = /obj/item/clothing/wrists/roguetown/allwrappings

/datum/loadout_item/spectacles
	name = "眼镜"
	path = /obj/item/clothing/mask/rogue/spectacles

/datum/loadout_item/gloves
	name = "皮手套"
	path = /obj/item/clothing/gloves/roguetown/leather

/datum/loadout_item/fingerless
	name = "露指手套"
	path = /obj/item/clothing/gloves/roguetown/fingerless

/datum/loadout_item/bandages
	name = "绷带手套"
	path = /obj/item/clothing/gloves/roguetown/bandages

/datum/loadout_item/exoticsilkbelt
	name = "异域丝腰带"
	path = /obj/item/storage/belt/rogue/leather/exoticsilkbelt

/datum/loadout_item/greenskirt
	name = "绿色异域丝绸腰带"
	path = /obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtgreen

/datum/loadout_item/redskirt
	name = "红色异域丝绸腰带"
	path = /obj/item/storage/belt/rogue/leather/exoticsilkbelt/skirtred

/datum/loadout_item/butlersuspenders
	name = "吊带"
	path = /obj/item/storage/belt/rogue/leather/suspenders/butler

/datum/loadout_item/butlersuspenders_colorable
	name = "可染色背带"
	path = /obj/item/storage/belt/rogue/leather/suspenders/butler/colored

/datum/loadout_item/ragmask
	name = "布面罩"
	path = /obj/item/clothing/mask/rogue/ragmask

/datum/loadout_item/halfmask
	name = "半面罩"
	path = /obj/item/clothing/mask/rogue/shepherd

/datum/loadout_item/golden_half_mask
	name = "金色半面罩"
	path = /obj/item/clothing/mask/rogue/lordmask

/datum/loadout_item/exoticsilkmask
	name = "异域丝面罩"
	path = /obj/item/clothing/mask/rogue/exoticsilkmask

/datum/loadout_item/maskgreen
	name = "绿色异域丝绸面罩"
	path = /obj/item/clothing/mask/rogue/exoticsilkmask/green

/datum/loadout_item/maskred
	name = "红色异域丝绸面罩"
	path = /obj/item/clothing/mask/rogue/exoticsilkmask/red

/datum/loadout_item/duelmask
	name = "决斗者面罩"
	path = /obj/item/clothing/mask/rogue/duelmask

/datum/loadout_item/pipe
	name = "烟斗"
	path = /obj/item/clothing/mask/cigarette/pipe

/datum/loadout_item/pipewestman
	name = "西地烟斗"
	path = /obj/item/clothing/mask/cigarette/pipe/westman

/datum/loadout_item/feather
	name = "羽饰"
	path = /obj/item/natural/feather

/datum/loadout_item/cursed_collar
	name = "诅咒项圈"
	path = /obj/item/clothing/neck/roguetown/cursed_collar

/datum/loadout_item/chastity_belt
	name = "贞操带"
	path = /obj/item/chastity

/datum/loadout_item/chastity_cage
	name = "贞操笼"
	path = /obj/item/chastity/chastity_cage

/datum/loadout_item/chastity_cage_anal
	name = "带后庭护板的贞操笼"
	path = /obj/item/chastity/chastity_cage/anal

/datum/loadout_item/chastity_cage_spiked
	name = "带刺贞操笼"
	path = /obj/item/chastity/chastity_cage/spiked

/datum/loadout_item/chastity_cage_spiked_anal
	name = "带后庭护板的带刺贞操笼"
	path = /obj/item/chastity/chastity_cage/spiked_anal

/datum/loadout_item/chastity_cage_flat
	name = "平板贞操笼"
	path = /obj/item/chastity/chastity_cage/flat

/datum/loadout_item/chastity_cage_flat_anal
	name = "带后庭护板的平板贞操笼"
	path = /obj/item/chastity/chastity_cage/flat/anal

/datum/loadout_item/chastity_cage_flat_spiked
	name = "带刺平板贞操笼"
	path = /obj/item/chastity/chastity_cage/flat/spiked

/datum/loadout_item/chastity_cage_flat_spiked_anal
	name = "带后庭护板的带刺平板贞操笼"
	path = /obj/item/chastity/chastity_cage/flat/spiked_anal

/datum/loadout_item/chastity_insertable
	name = "可插入式贞操具"
	path = /obj/item/chastity/chastity_belt

/datum/loadout_item/chastity_insertable_anal
	name = "带后庭护板的可插入式贞操具"
	path = /obj/item/chastity/chastity_belt/anal

/datum/loadout_item/chastity_insertable_spiked
	name = "带刺可插入式贞操具"
	path = /obj/item/chastity/chastity_belt/spiked

/datum/loadout_item/chastity_insertable_spiked_anal
	name = "带后庭护板的带刺可插入式贞操具"
	path = /obj/item/chastity/chastity_belt/spiked_anal

/datum/loadout_item/chastity_combination
	name = "组合式贞操装置"
	path = /obj/item/chastity/intersex

/datum/loadout_item/chastity_combination_spiked
	name = "带刺组合式贞操装置"
	path = /obj/item/chastity/intersex/spiked

/datum/loadout_item/chastity_cursed
	name = "诅咒贞操装置"
	path = /obj/item/chastity/cursed

/datum/loadout_item/wooddildo
	name = "木制假阳具"
	path = /obj/item/dildo/wood

/datum/loadout_item/irondildo
	name = "铁制假阳具"
	path = /obj/item/dildo/iron

/datum/loadout_item/copperdildo
	name = "铜制假阳具"
	path = /obj/item/dildo/copper

/datum/loadout_item/cloth_blindfold
	name = "布眼罩"
	path = /obj/item/clothing/mask/rogue/blindfold

/datum/loadout_item/fake_blindfold
	name = "假眼罩"
	path = /obj/item/clothing/mask/rogue/blindfold/fake

/datum/loadout_item/bases
	name = "布制军裙"
	path = /obj/item/storage/belt/rogue/leather/battleskirt

/datum/loadout_item/fauldedbelt
	name = "带垂甲腰带"
	path = /obj/item/storage/belt/rogue/leather/battleskirt/faulds

/datum/loadout_item/breechskirt
	name = "兜裆布腰带"
	path = /obj/item/storage/belt/rogue/leather/battleskirt/breechcloth

/datum/loadout_item/tri_cloth_belt
	name = "布腰带"
	path = /obj/item/storage/belt/rogue/leather/cloth

/datum/loadout_item/tri_kazengun_scabbard
	name = "风郡礼仪鞘"
	path = /obj/item/rogueweapon/scabbard/sword/kazengun/noparry/loadout
	triumph_cost = 3
	requires_nobility = TRUE

/datum/loadout_item/tri_shalal_belt
	name = "沙拉尔腰带"
	path = /obj/item/storage/belt/rogue/leather/shalal

// BELTS
/datum/loadout_item/leather
	name = "皮腰带"
	path = /obj/item/storage/belt/rogue/leather

/datum/loadout_item/leather_black
	name = "黑色皮腰带"
	path = /obj/item/storage/belt/rogue/leather/black

/datum/loadout_item/doublebelt
	name = "成对细腰带"
	path = /obj/item/storage/belt/rogue/leather/double

/datum/loadout_item/belt_cloth
	name = "布绶带"
	path = /obj/item/storage/belt/rogue/leather/sash

/datum/loadout_item/jafar
	name = "兹班图大腰带"
	path = /obj/item/storage/belt/rogue/leather/jafar

/datum/loadout_item/belt_rope
	name = "绳腰带"
	path = /obj/item/storage/belt/rogue/leather/rope

// Religious Amulets.

/datum/loadout_item/psicross
	name = "普赛顿十字"
	path = /obj/item/clothing/neck/roguetown/psicross

/datum/loadout_item/psicross_reform
	name = "改革派普赛圣十字"
	path = /obj/item/clothing/neck/roguetown/psicross/reform

/datum/loadout_item/psicross/astrata
	name = "阿斯特拉塔护符"
	path = /obj/item/clothing/neck/roguetown/psicross/astrata

/datum/loadout_item/psicross/noc
	name = "诺克护符"
	path = /obj/item/clothing/neck/roguetown/psicross/noc

/datum/loadout_item/psicross/abyssor
	name = "阿比索尔护符"
	path = /obj/item/clothing/neck/roguetown/psicross/abyssor

/datum/loadout_item/psicross/xylix
	name = "赛利克斯护符"
	path = /obj/item/clothing/neck/roguetown/psicross/xylix

/datum/loadout_item/psicross/dendor
	name = "登多尔护符"
	path = /obj/item/clothing/neck/roguetown/psicross/dendor

/datum/loadout_item/psicross/necra
	name = "内克拉护符"
	path = /obj/item/clothing/neck/roguetown/psicross/necra

/datum/loadout_item/psicross/pestra
	name = "佩斯特拉护符"
	path = /obj/item/clothing/neck/roguetown/psicross/pestra

/datum/loadout_item/psicross/ravox
	name = "拉沃克斯护符"
	path = /obj/item/clothing/neck/roguetown/psicross/ravox

/datum/loadout_item/psicross/malum
	name = "玛勒姆护符"
	path = /obj/item/clothing/neck/roguetown/psicross/malum

/datum/loadout_item/psicross/eora
	name = "伊欧拉护符"
	path = /obj/item/clothing/neck/roguetown/psicross/eora

/datum/loadout_item/psicross/zizo
	name = "远古齐佐十字"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/ancient

/datum/loadout_item/psicross/matthios
	name = "马西奥斯护符"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios

/datum/loadout_item/psicross/graggar
	name = "格拉加尔护符"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar

/datum/loadout_item/psicross/baotha
	name = "巴奥莎护符"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha

/datum/loadout_item/psicross/ten
	name = "十神护符"
	path = /obj/item/clothing/neck/roguetown/psicross/ten

/datum/loadout_item/psicross/gronngraggar
	name = "驼鹿护符"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn

/datum/loadout_item/psicross/gronnmatthios
	name = "熊护符"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn

/datum/loadout_item/psicross/gronnzizo
	name = "狼护符"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn

/datum/loadout_item/psicross/gronnmbaotha
	name = "豹护符"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/gronn

/datum/loadout_item/psicross/gronnabyssor
	name = "海怪护符"
	path = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn

/datum/loadout_item/psicross/gronndendor
	name = "狼皮人护符"
	path = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn

/datum/loadout_item/wedding_band
	name = "银质婚戒"
	path = /obj/item/clothing/ring/band

/datum/loadout_item/chaperon
	name = "普通头巾帽"
	path = /obj/item/clothing/head/roguetown/chaperon

/datum/loadout_item/chaperon/alt
	name = "可染色头巾帽"
	path = /obj/item/clothing/head/roguetown/chaperon/greyscale

/datum/loadout_item/chaperon/burgher
	name = "贵族兜帽帽冠"
	path = /obj/item/clothing/head/roguetown/chaperon/noble

/datum/loadout_item/jesterhat
	name = "弄臣帽"
	path = /obj/item/clothing/head/roguetown/jester

/datum/loadout_item/jestertunick
	name = "弄臣上衣"
	path = /obj/item/clothing/suit/roguetown/shirt/jester

/datum/loadout_item/jestershoes
	name = "弄臣鞋"
	path = /obj/item/clothing/shoes/roguetown/jester

/datum/loadout_item/jestermask
	name = "弄臣面具"
	path = /obj/item/clothing/mask/rogue/xylixmask

/datum/loadout_item/cotehardie
	name = "修身外套"
	path = /obj/item/clothing/cloak/cotehardie

/datum/loadout_item/zcross_iron
	name = "齐佐十字"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen

// NECKLACES & AMULETS
/datum/loadout_item/skull_amulet
	name = "骷髅护符"
	path = /obj/item/clothing/neck/roguetown/skullamulet

/datum/loadout_item/collar_feldcollar
	name = "军医项圈"
	path = /obj/item/clothing/neck/roguetown/collar/feldcollar

/datum/loadout_item/collar_surgcollar
	name = "外科项圈"
	path = /obj/item/clothing/neck/roguetown/collar/surgcollar

/datum/loadout_item/scarf
	name = "围巾"
	path = /obj/item/clothing/head/roguetown/scarf

// MASKS
/datum/loadout_item/skullmask
	name = "骷髅面具"
	path = /obj/item/clothing/mask/rogue/skullmask

/datum/loadout_item/physician_mask
	name = "医师面具"
	path = /obj/item/clothing/mask/rogue/physician

/datum/loadout_item/kitsune_mask
	name = "旧狐面"
	path = /obj/item/clothing/mask/rogue/facemask/yoruku_kitsune

/datum/loadout_item/oni_mask
	name = "旧鬼面"
	path = /obj/item/clothing/mask/rogue/facemask/yoruku_oni

/datum/loadout_item/naledi_lordmask
	name = "旧纳莱迪面具"
	path = /obj/item/clothing/mask/rogue/lordmask/naledi

// CLOAKS
/datum/loadout_item/darkcloak
	name = "深色斗篷"
	path = /obj/item/clothing/cloak/darkcloak

/datum/loadout_item/apron
	name = "围裙"
	path = /obj/item/clothing/cloak/apron

/datum/loadout_item/apron_blacksmith
	name = "铁匠围裙"
	path = /obj/item/clothing/cloak/apron/blacksmith

/datum/loadout_item/apron_waist
	name = "腰围裙"
	path = /obj/item/clothing/cloak/apron/waist

/datum/loadout_item/apron_cook
	name = "厨师围裙"
	path = /obj/item/clothing/cloak/apron/cook

/datum/loadout_item/black_cloak
	name = "毛皮外斗篷"
	path = /obj/item/clothing/cloak/black_cloak

/datum/loadout_item/tribal_cloak
	name = "部族斗篷"
	path = /obj/item/clothing/cloak/tribal

/datum/loadout_item/maidapron
	name = "女仆围裙"
	path = /obj/item/clothing/cloak/apron/maid

/datum/loadout_item/battlenun_cloak
	name = "修女斗篷"
	path = /obj/item/clothing/cloak/battlenun

/datum/loadout_item/hierophant_cloak
	name = "大祭司斗篷"
	path = /obj/item/clothing/cloak/hierophant

/datum/loadout_item/forrester_snow
	name = "雪林人斗篷"
	path = /obj/item/clothing/cloak/forrestercloak/snow

/datum/loadout_item/eastcloak1
	name = "东方斗篷"
	path = /obj/item/clothing/cloak/eastcloak1

/datum/loadout_item/kazengun_cloak
	name = "阵羽织"
	path = /obj/item/clothing/cloak/kazengun

/datum/loadout_item/shoulderpad_metal
	name = "板甲护肩"
	path = /obj/item/clothing/cloak/volfmantle/shoulderpad

/datum/loadout_item/shoulderpad_leatherheavy
	name = "皮革护肩"
	path = /obj/item/clothing/cloak/volfmantle/shoulderpad/leather

/datum/loadout_item/shoulderpad_leatherlight
	name = "轻型皮革护肩"
	path = /obj/item/clothing/cloak/volfmantle/shoulderpad/lightleather

// SHOES
/datum/loadout_item/sandals
	name = "凉鞋"
	path = /obj/item/clothing/shoes/roguetown/sandals

// NECK/GORGETS
/datum/loadout_item/forlorn_collar
	name = "旧失落项圈"
	path = /obj/item/clothing/neck/roguetown/gorget/forlorncollar

// EASTERN CLOTHING
/datum/loadout_item/captain_robe
	name = "东方花纹长袍"
	path = /obj/item/clothing/suit/roguetown/armor/basiceast/captainrobe

/datum/loadout_item/decorative_captain_robe
	name = "装饰花纹长袍"
	path = /obj/item/clothing/suit/roguetown/armor/basiceast/captainrobe/decorative

/datum/loadout_item/mentor_suit
	name = "东方导师服"
	path = /obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit

/datum/loadout_item/decorative_mentor_suit
	name = "装饰导师长袍"
	path = /obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit/decorative

/datum/loadout_item/crafteast
	name = "东方工艺袍"
	path = /obj/item/clothing/suit/roguetown/armor/basiceast/crafteast

/datum/loadout_item/doboeast
	name = "东方道袍"
	path = /obj/item/clothing/suit/roguetown/armor/basiceast

// HEADWEAR
/datum/loadout_item/nochood
	name = "诺克兜帽"
	path = /obj/item/clothing/head/roguetown/nochood

/datum/loadout_item/dendormask
	name = "荆棘面具"
	path = /obj/item/clothing/head/roguetown/dendormask

/datum/loadout_item/necrahood
	name = "内克拉兜帽"
	path = /obj/item/clothing/head/roguetown/necrahood

/datum/loadout_item/physhood
	name = "佩斯特拉兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood/phys

// ROBES - ASTRATA

/datum/loadout_item/eoramask
	name = "伊欧拉面具"
	path = /obj/item/clothing/head/roguetown/eoramask

/datum/loadout_item/antlerhood
	name = "鹿角兜帽"
	path = /obj/item/clothing/head/roguetown/antlerhood

/datum/loadout_item/briarthorns
	name = "荆棘头饰"
	path = /obj/item/clothing/head/roguetown/padded/briarthorns

/datum/loadout_item/mentorhat
	name = "圆锥导师帽"
	path = /obj/item/clothing/head/roguetown/mentorhat

/datum/loadout_item/decorative_mentorhat
	name = "装饰斗笠"
	path = /obj/item/clothing/head/roguetown/mentorhat/decorative

// ROBES - ASTRATA
/datum/loadout_item/robe_astrata
	name = "太阳长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/astrata

/datum/loadout_item/hood_astrata
	name = "太阳兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood/astrata

// ROBES - NOC
/datum/loadout_item/robe_noc
	name = "月亮长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/noc

// ROBES - DENDOR
/datum/loadout_item/robe_dendor
	name = "荆棘长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/dendor

// ROBES - ABYSSOR
/datum/loadout_item/robe_abyssor
	name = "深渊长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor

/datum/loadout_item/hood_abyssor
	name = "深渊兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood/abyssor

// ROBES - NECRA
/datum/loadout_item/robe_necra
	name = "哀悼长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/necra

// ROBES - RAVOX
/datum/loadout_item/hood_ravox
	name = "拉沃克斯战袍护喉"
	path = /obj/item/clothing/head/roguetown/roguehood/ravoxgorget

// ROBES - EORA
/datum/loadout_item/robe_eora
	name = "伊欧拉长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/eora

//==========================
// TRIUMPH LOADOUT ITEMS
//==========================
//
// IMPORTANT INFORMATION ABOUT LOADOUT ITEMS:
// All items selected from the loadout system receive the following automatic modifications:
// - ARMOR: Set to ARMOR_PADDED_BAD (basic padded values) and ARMOR_INT_CHEST_LIGHT_BASE max integrity
// - ARMOR CLASS: Set to LIGHT for all armor pieces
// - SELL PRICE: Set to 0 (cannot be sold for profit)
// - CRIT PREVENTION: Removed from clothing items (prevent_crits set to null)
// - WEAPON DAMAGE: Reduced by 30% (force reduced to 70% of original)
// - WEAPON DEFENSE: Reduced by 50% (wdefense halved)
// - SMELT RESULT: Set to ash (cannot be smelted for materials)
// - EXAMINATION: Items show as reproductions when examined
//
// These modifications ensure loadout items provide utility and customization
// without bypassing game progression or economy balance.
// without bypassing game progression or economy balance.
//
//─────────────────────────────────────────────────────────────
// 2 TRIUMPH - Mundane Tools & Basic Items
//─────────────────────────────────────────────────────────────

// TOOLS & OBJECTS
/datum/loadout_item/tri_shovel
	name = "铲子"
	path = /obj/item/rogueweapon/shovel
	triumph_cost = 2

/datum/loadout_item/tri_sickle
	name = "镰刀"
	path = /obj/item/rogueweapon/sickle
	triumph_cost = 2

// BLUNT WEAPONS
/datum/loadout_item/tri_woodclub
	name = "木棍"
	path = /obj/item/rogueweapon/mace/woodclub
	triumph_cost = 2
	keep_loadout_stats = TRUE

// AXES
/datum/loadout_item/tri_bone_axe
	name = "骨斧"
	path = /obj/item/rogueweapon/stoneaxe/boneaxe
	triumph_cost = 2
	keep_loadout_stats = TRUE

/datum/loadout_item/ancient_axe
	name = "古斧"
	path = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient
	triumph_cost = 4

// SWORDS
/datum/loadout_item/tri_stone_sword
	name = "石剑"
	path = /obj/item/rogueweapon/sword/stone
	triumph_cost = 2
	keep_loadout_stats = TRUE

/datum/loadout_item/ancient_gladius
	name = "古罗马短剑"
	path = /obj/item/rogueweapon/sword/short/gladius/ancient
	triumph_cost = 4

/datum/loadout_item/ancient_khopesh
	name = "古镰形剑"
	path = /obj/item/rogueweapon/sword/sabre/ancient
	triumph_cost = 4

// DAGGERS & KNIVES
/datum/loadout_item/tri_stone_knife
	name = "石刀"
	path = /obj/item/rogueweapon/huntingknife/stoneknife
	triumph_cost = 2
	keep_loadout_stats = TRUE

// MACES & BLUNT
/datum/loadout_item/ancient_mace
	name = "古钉锤"
	path = /obj/item/rogueweapon/mace/goden/steel/ancient
	triumph_cost = 4

// POLEARMS & SPEARS
/datum/loadout_item/tri_stone_spear
	name = "石矛"
	path = /obj/item/rogueweapon/spear/stone
	triumph_cost = 2
	keep_loadout_stats = TRUE

/datum/loadout_item/tri_bone_spear
	name = "骨矛"
	path = /obj/item/rogueweapon/spear/bonespear
	triumph_cost = 2
	keep_loadout_stats = TRUE

/datum/loadout_item/ancient_spear
	name = "古矛"
	path = /obj/item/rogueweapon/spear/ancient/decrepit
	triumph_cost = 4

// ARMOR & CLOTHING
/datum/loadout_item/ancient_mask
	name = "古面具"
	path = /obj/item/clothing/mask/rogue/facemask/ancient
	triumph_cost = 4

/datum/loadout_item/ancient_kilt
	name = "古褶裙"
	path = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
	triumph_cost = 4

//─────────────────────────────────────────────────────────────
// 3 TRIUMPH - Wooden Polearms & Noble Clothing
//─────────────────────────────────────────────────────────────

// POLEARMS & SPEARS
/datum/loadout_item/tri_quarterstaff
	name = "长棍"
	path = /obj/item/rogueweapon/woodstaff/quarterstaff
	triumph_cost = 3
	keep_loadout_stats = TRUE

/datum/loadout_item/tri_woodstaff
	name = "木法杖"
	path = /obj/item/rogueweapon/woodstaff
	triumph_cost = 3
	keep_loadout_stats = TRUE

/datum/loadout_item/tri_scythe
	name = "农夫镰刀"
	path = /obj/item/rogueweapon/scythe
	triumph_cost = 3
	keep_loadout_stats = TRUE

// CLOTHING - TABARDS & RELIGIOUS CLOAKS
/datum/loadout_item/tri_astrata_tabard
	name = "阿斯特拉塔罩袍"
	path = /obj/item/clothing/cloak/templar/astratan


/datum/loadout_item/tri_malum_tabard
	name = "玛勒姆罩袍"
	path = /obj/item/clothing/cloak/templar/malumite

/datum/loadout_item/tri_necra_tabard
	name = "内克拉罩袍"
	path = /obj/item/clothing/cloak/templar/necran

/datum/loadout_item/tri_pestra_tabard
	name = "佩斯特拉罩袍"
	path = /obj/item/clothing/cloak/templar/pestran

/datum/loadout_item/tri_eora_tabard
	name = "伊欧拉罩袍"
	path = /obj/item/clothing/cloak/templar/eoran

/datum/loadout_item/tri_xylix_cloak
	name = "赛利克斯披风"
	path = /obj/item/clothing/cloak/templar/xylixian

/datum/loadout_item/tri_psydon_tabard
	name = "普赛顿罩袍"
	path = /obj/item/clothing/cloak/psydontabard

/datum/loadout_item/tri_reform_tabard
	name = "改革派战袍"
	path = /obj/item/clothing/cloak/reformtabard

/datum/loadout_item/tri_abyssor_tabard
	name = "阿比索尔罩袍"
	path = /obj/item/clothing/cloak/abyssortabard

/datum/loadout_item/tri_see_tabard
	name = "教廷战袍"
	path = /obj/item/clothing/cloak/templar/undivided
	triumph_cost = 4

/datum/loadout_item/tri_see_cloak
	name = "教廷斗篷"
	path = /obj/item/clothing/cloak/undivided
	triumph_cost = 4

/datum/loadout_item/tri_justice_tabard
	name = "正义罩袍"
	path = /obj/item/clothing/cloak/templar/ravox

// CLOTHING - DRESSES & ROBES
/datum/loadout_item/tri_ornate_dress
	name = "华饰长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward
	triumph_cost = 3
	requires_nobility = TRUE

/datum/loadout_item/tri_ornate_tunic
	name = "华饰束腰衫"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/silktunic
	triumph_cost = 3
	requires_nobility = TRUE

/datum/loadout_item/tri_princess_dress
	name = "公主长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
	triumph_cost = 3
	requires_nobility = TRUE

/datum/loadout_item/tri_royal_dress
	name = "皇家长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal
	triumph_cost = 3
	requires_nobility = TRUE

/datum/loadout_item/tri_royal_sleeves
	name = "皇家袖套"
	path = /obj/item/clothing/wrists/roguetown/royalsleeves
	triumph_cost = 3
	requires_nobility = TRUE

/datum/loadout_item/tri_lady_cloak
	name = "女士斗篷"
	path = /obj/item/clothing/cloak/lordcloak/ladycloak
	triumph_cost = 3
	requires_nobility = TRUE

/datum/loadout_item/wedding_dress
	name = "婚礼丝裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/weddingdress

// CLOTHING - HEADWEAR
/datum/loadout_item/tri_circlet
	name = "额环"
	path = /obj/item/clothing/head/roguetown/circlet
	triumph_cost = 3
	requires_nobility = TRUE

/datum/loadout_item/tri_volfhelm
	name = "沃尔夫头盔"
	path = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	triumph_cost = 2

/datum/loadout_item/tri_saiga
	name = "赛加头盔"
	path = /obj/item/clothing/head/roguetown/helmet/leather/saiga
	triumph_cost = 2

// CLOTHING - JEWELRY & ACCESSORIES
/datum/loadout_item/tri_noble_amulet
	name = "贵族护符"
	path = /obj/item/clothing/neck/roguetown/ornateamulet/noble
	triumph_cost = 4

/datum/loadout_item/tri_shell_bracelet
	name = "贝壳手镯"
	path = /obj/item/clothing/neck/roguetown/psicross/shell/bracelet
	triumph_cost = 2

/datum/loadout_item/tri_shell_necklace
	name = "牡蛎壳项链"
	path = /obj/item/clothing/neck/roguetown/psicross/shell
	triumph_cost = 2

// CLOTHING - ARMOR (Alphabetically Ordered)
/datum/loadout_item/tri_desert_coat
	name = "沙地外套"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
	triumph_cost = 3

/datum/loadout_item/tri_duelist_coat
	name = "决斗者外套"
	path = /obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
	triumph_cost = 3

/datum/loadout_item/tri_fencing_gambeson
	name = "击剑绗缝护甲衣"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	triumph_cost = 6

/datum/loadout_item/tri_fencing_shirt
	name = "加垫击剑衬衣"
	path = /obj/item/clothing/suit/roguetown/shirt/freifechter
	triumph_cost = 3

/datum/loadout_item/tri_fencing_shirt_shepherd
	name = "牧羊人衬衫"
	path = /obj/item/clothing/suit/roguetown/shirt/freifechter/shepherd
	triumph_cost = 3

/datum/loadout_item/tri_fencing_vest_shepherd
	name = "牧羊人皮背心"
	path = /obj/item/clothing/suit/roguetown/armor/leather/heavy/shepherd
	triumph_cost = 3

/datum/loadout_item/tri_gambeson
	name = "棉甲"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson
	triumph_cost = 3

/datum/loadout_item/tri_gambeson_light
	name = "轻型棉甲"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	triumph_cost = 2

/datum/loadout_item/tri_gambeson_padded
	name = "衬垫棉甲"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	triumph_cost = 3

/datum/loadout_item/tri_grenzelhoft_hipshirt
	name = "格伦泽尔霍夫特胯衫"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	triumph_cost = 3

/datum/loadout_item/tri_gronn_byrine_chausses
	name = "拜林护腿"
	path = /obj/item/clothing/under/roguetown/splintlegs/iron/gronn
	triumph_cost = 4

/datum/loadout_item/tri_gronn_byrine_gloves
	name = "拜林手套"
	path = /obj/item/clothing/gloves/roguetown/chain/gronn
	triumph_cost = 4

/datum/loadout_item/tri_gronn_byrine_hauberk
	name = "拜林锁子甲"
	path = /obj/item/clothing/suit/roguetown/armor/brigandine/gronn
	triumph_cost = 6

/datum/loadout_item/tri_gronn_fur_pants
	name = "毛皮裤"
	path = /obj/item/clothing/under/roguetown/trou/leather/gronn
	triumph_cost = 4

/datum/loadout_item/tri_gronn_bone_gloves
	name = "骨手套"
	path = /obj/item/clothing/gloves/roguetown/angle/gronnfur
	triumph_cost = 4

/datum/loadout_item/tri_hierophant_gambeson
	name = "大祭司棉甲"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant
	triumph_cost = 6

/datum/loadout_item/tri_gronn_ravager_mantle
	name = "掠夺者披肩"
	path = /obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn
	triumph_cost = 6

/datum/loadout_item/tri_huus_quyaq
	name = "胡斯库亚克"
	path = /obj/item/clothing/suit/roguetown/armor/leather/Huus_quyaq
	triumph_cost = 3

/datum/loadout_item/tri_kurche
	name = "库尔切"
	path = /obj/item/clothing/suit/roguetown/armor/kurche
	triumph_cost = 6

/datum/loadout_item/tri_leather_cuirass
	name = "皮胸甲"
	path = /obj/item/clothing/suit/roguetown/armor/leather/cuirass
	triumph_cost = 3

/datum/loadout_item/tri_leather_corslet
	name = "皮短胸甲"
	path = /obj/item/clothing/suit/roguetown/armor/leather/bikini
	triumph_cost = 3

/datum/loadout_item/corset
	name = "紧身胸衣"
	path = /obj/item/clothing/suit/roguetown/armor/corset

/datum/loadout_item/tri_moose_hood
	name = "驼鹿兜帽"
	path = /obj/item/clothing/head/roguetown/helmet/leather/shaman_hood
	triumph_cost = 4

/datum/loadout_item/tri_ornate_tailcoat
	name = "华丽燕尾服"
	path = /obj/item/clothing/suit/roguetown/shirt/coat/steward
	triumph_cost = 3
	requires_nobility = TRUE

/datum/loadout_item/tri_otavan_gambeson
	name = "奥塔万棉甲"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	triumph_cost = 6

/datum/loadout_item/tri_padded_caftan
	name = "衬垫卡夫坦"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	triumph_cost = 3

/datum/loadout_item/padded_kini
	name = "软垫胸衣"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/bikini
	triumph_cost = 3

/datum/loadout_item/tri_pontifex_gambeson
	name = "大祭长棉甲"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex
	triumph_cost = 3

/datum/loadout_item/tri_psyaltrist_leather
	name = "灵医皮甲"
	path = /obj/item/clothing/suit/roguetown/armor/leather/studded/psyaltrist
	triumph_cost = 6

/datum/loadout_item/tri_zyb_coat
	name = "沙地外套"
	path = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/zyb
	triumph_cost = 3

/datum/loadout_item/tri_zyb_gambeson
	name = "沙地棉甲"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
	triumph_cost = 3

/datum/loadout_item/tri_shamanic_coat
	name = "萨满外套"
	path = /obj/item/clothing/suit/roguetown/armor/leather/heavy/atgervi
	triumph_cost = 3

/datum/loadout_item/tri_spellcaster_hat
	name = "施法者帽"
	path = /obj/item/clothing/head/roguetown/spellcasterhat
	triumph_cost = 2

/datum/loadout_item/tri_steppe_coat
	name = "草原外套"
	path = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
	triumph_cost = 3

// HELMETS AND HEADWEAR (Alphabetically Ordered)
/datum/loadout_item/tri_grenzelhoft_hat
	name = "格伦泽尔霍夫特帽"
	path = /obj/item/clothing/head/roguetown/grenzelhofthat
	triumph_cost = 2

/datum/loadout_item/tri_hierophant_hood
	name = "大祭司兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood/hierophant
	triumph_cost = 2

/datum/loadout_item/tri_armorhood_hood
	name = "铆钉皮兜帽"
	path = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
	triumph_cost = 2

/datum/loadout_item/tri_pontifex_hood
	name = "大祭长兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood/pontifex
	triumph_cost = 2

/datum/loadout_item/tri_zyb_hijab
	name = "沙地头巾"
	path = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/zyb
	triumph_cost = 2


// GLOVES (Alphabetically Ordered)
/datum/loadout_item/tri_atgervi_gloves
	name = "阿特格维手套"
	path = /obj/item/clothing/gloves/roguetown/angle/atgervi
	triumph_cost = 2

/datum/loadout_item/tri_eastern_gloves
	name = "东方手套"
	path = /obj/item/clothing/gloves/roguetown/eastgloves2
	triumph_cost = 2

/datum/loadout_item/tri_grenzelhoft_gloves
	name = "格伦泽尔霍夫特手套"
	path = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	triumph_cost = 2

/datum/loadout_item/tri_kote_gloves
	name = "胴丸护手"
	path = /obj/item/clothing/gloves/roguetown/plate/kote
	triumph_cost = 2

/datum/loadout_item/tri_otavan_gloves
	name = "奥塔万手套"
	path = /obj/item/clothing/gloves/roguetown/otavan
	triumph_cost = 4

/datum/loadout_item/tri_pontifex_gloves
	name = "大祭长手套"
	path = /obj/item/clothing/gloves/roguetown/angle/pontifex
	triumph_cost = 2

// BOOTS & SHOES (Alphabetically Ordered)
/datum/loadout_item/tri_atgervi_boots
	name = "阿特格维靴"
	path = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi


/datum/loadout_item/tri_grenzelhoft_boots
	name = "格伦泽尔霍夫特靴"
	path = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft


/datum/loadout_item/tri_kazengun_boots
	name = "风郡靴"
	path = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun


/datum/loadout_item/tri_otavan_boots
	name = "奥塔万靴"
	path = /obj/item/clothing/shoes/roguetown/boots/otavan
	triumph_cost = 3


/datum/loadout_item/tri_rumaclan_boots
	name = "鲁玛氏族靴"
	path = /obj/item/clothing/shoes/roguetown/armor/rumaclan


/datum/loadout_item/tri_shalal_boots
	name = "沙拉尔靴"
	path = /obj/item/clothing/shoes/roguetown/shalal


// PANTS (Alphabetically Ordered)
/datum/loadout_item/tri_atgervi_pants
	name = "阿特格维毛皮裤"
	path = /obj/item/clothing/under/roguetown/trou/leather/atgervi
	triumph_cost = 4

/datum/loadout_item/tri_eastern_pants_1
	name = "割喉客长裤"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
	triumph_cost = 2

/datum/loadout_item/tri_eastern_pants_2
	name = "古怪破裤"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	triumph_cost = 2

/datum/loadout_item/tri_grenzelhoft_pants
	name = "格伦泽尔霍夫特长裤"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	triumph_cost = 2

/datum/loadout_item/tri_otavan_pants
	name = "奥塔万长裤"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	triumph_cost = 4

/datum/loadout_item/tri_otavan_generic_pants
	name = "击剑马裤"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	triumph_cost = 4

/datum/loadout_item/tri_kazengun_pants
	name = "风郡长裤"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun
	triumph_cost = 2

/datum/loadout_item/tri_pontifex_pants
	name = "大祭长长裤"
	path = /obj/item/clothing/under/roguetown/trou/leather/pontifex
	triumph_cost = 2

/datum/loadout_item/tri_zyb_pants
	name = "齐班廷长裤"
	path = /obj/item/clothing/under/roguetown/trou/leather/pontifex/zyb
	triumph_cost = 2


// CLOAKS & CAPES (Alphabetically Ordered)
/datum/loadout_item/tri_eastern_cloak_1
	name = "东方斗篷"
	path = /obj/item/clothing/cloak/eastcloak1


/datum/loadout_item/tri_hierophant_cloak
	name = "大祭司斗篷"
	path = /obj/item/clothing/cloak/hierophant

/datum/loadout_item/tri_kazengun_cloak
	name = "风郡斗篷"
	path = /obj/item/clothing/cloak/kazengun



// NECK ACCESSORIES (Alphabetically Ordered)

/datum/loadout_item/tri_fencerguard
	name = "击剑护领"
	path = /obj/item/clothing/neck/roguetown/fencerguard
	triumph_cost = 4

/datum/loadout_item/tri_naledi_cross
	name = "纳莱迪普赛圣十字"
	path = /obj/item/clothing/neck/roguetown/psicross/naledi

/datum/loadout_item/woolencollar
	name = "羊毛项圈"
	path = /obj/item/clothing/neck/roguetown/collar/woolen

// MASKS (Alphabetically Ordered)

// SHIRTS & ROBES (Alphabetically Ordered)
/datum/loadout_item/tri_hierophant_robe
	name = "大祭司长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
	triumph_cost = 2

/datum/loadout_item/tri_pontifex_robe
	name = "大祭长长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/pointfex
	triumph_cost = 2

/datum/loadout_item/slitteddress
	name = "开衩长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/slit

// POLEARMS & STAVES
/datum/loadout_item/tri_naledi_staff
	name = "装饰纳莱迪法杖"
	path = /obj/item/rogueweapon/woodstaff/decorative
	triumph_cost = 3


//─────────────────────────────────────────────────────────────
// 10 TRIUMPH - Lord's Cloak
//─────────────────────────────────────────────────────────────

// CLOTHING - CLOAKS
/datum/loadout_item/tri_lord_cloak
	name = "领主斗篷"
	path = /obj/item/clothing/cloak/lordcloak
	triumph_cost = 10
	requires_nobility = TRUE

//==========================
//Donator Section
//==========================
//All these items are stored in the donator_fluff.dm in the azure modular folder for simplicity.
//All should be subtypes of existing weapons/clothes/armor/gear, whatever, to avoid balance issues I guess. Idk, I'm not your boss.

/datum/loadout_item/donator_plex
	name = "赞助者套装 - 阿利塞奥刺剑"
	path = /obj/item/enchantingkit/plexiant
	ckeywhitelist = list("plexiant")

/datum/loadout_item/donator_sru
	name = "赞助者套装 - 翡翠长裙"
	path = /obj/item/enchantingkit/srusu
	ckeywhitelist = list("cheekycrenando")

/datum/loadout_item/donator_strudel
	name = "赞助者套装 - 格伦泽尔霍夫特法师背心"
	path = /obj/item/enchantingkit/strudle
	ckeywhitelist = list("toasterstrudes")

/datum/loadout_item/donator_bat
	name = "赞助者套装 - 手工雕刻竖琴"
	path = /obj/item/enchantingkit/bat
	ckeywhitelist = list("kitchifox")

/datum/loadout_item/donator_mansa
	name = "赞助者套装 - 沃特崔格"
	path = /obj/item/enchantingkit/ryebread
	ckeywhitelist = list("pepperoniplayboy")	//Byond maybe doesn't like spaces. If a name has a space, do it as one continious name.

/datum/loadout_item/donator_rebel
	name = "赞助者套装 - 镀金面罩盔"
	path = /obj/item/enchantingkit/rebel
	ckeywhitelist = list("rebel0")

/datum/loadout_item/donator_bigfoot
	name = "赞助者套装 - 镀金骑士盔"
	path = /obj/item/enchantingkit/bigfoot
	ckeywhitelist = list("bigfoot02")

/datum/loadout_item/donator_bigfoot_axe
	name = "赞助者套装 - 镀金巨斧"
	path = /obj/item/enchantingkit/bigfoot_axe
	ckeywhitelist = list("bigfoot02")

/datum/loadout_item/donator_zydras
	name = "赞助者套装 - 衬垫丝裙"
	path = /obj/item/enchantingkit/zydras
	ckeywhitelist = list("1ceres")

/datum/loadout_item/leather_collar
	name = "皮项圈"
	path = /obj/item/clothing/neck/roguetown/collar/leather

/datum/loadout_item/cowbell_collar
	name = "牛铃项圈"
	path = /obj/item/clothing/neck/roguetown/collar/cowbell

/datum/loadout_item/catbell_collar
	name = "猫铃项圈"
	path = /obj/item/clothing/neck/roguetown/collar/catbell

/datum/loadout_item/catbell
	name = "猫铃"
	path = /obj/item/catbell

/datum/loadout_item/cowbell
	name = "牛铃"
	path = /obj/item/catbell/cow

/datum/loadout_item/rope_leash
	name = "绳牵引绳"
	path = /obj/item/leash

/datum/loadout_item/leather_leash
	name = "皮牵引绳"
	path = /obj/item/leash/leather

/datum/loadout_item/chain_leash
	name = "链牵引绳"
	path = /obj/item/leash/chain

/datum/loadout_item/magic_recipes
	name = "奥术指南"
	path = /obj/item/recipe_book/magic

/datum/loadout_item/alch_recipes
	name = "炼金指南"
	path = /obj/item/recipe_book/alchemy

/datum/loadout_item/leather_recipes
	name = "制革指南"
	path = /obj/item/recipe_book/leatherworking

/datum/loadout_item/sewing_recipes
	name = "裁缝指南"
	path = /obj/item/recipe_book/sewing

/datum/loadout_item/smith_recipes
	name = "锻造指南"
	path = /obj/item/recipe_book/blacksmithing

/datum/loadout_item/engi_recipes
	name = "工程指南"
	path = /obj/item/recipe_book/engineering

/datum/loadout_item/build_recipes
	name = "建造指南"
	path = /obj/item/recipe_book/builder

/datum/loadout_item/potter_recipes
	name = "陶艺指南"
	path = /obj/item/recipe_book/ceramics

/datum/loadout_item/survival_recipes
	name = "生存指南"
	path = /obj/item/recipe_book/survival

/datum/loadout_item/cooking_recipes
	name = "烹饪指南"
	path = /obj/item/recipe_book/cooking

/datum/loadout_item/tenbibble
	name = "《十神之诗与行》"
	path = /obj/item/book/rogue/bibble

/datum/loadout_item/psybibble
	name = "《普赛顿之书》"
	path = /obj/item/book/rogue/bibble/psy

/datum/loadout_item/zizobibble
	name = "《她之真理辞典》"
	path = /obj/item/book/rogue/bibble/zizo

//COSMETICS (Perfumes & Lipsticks)

/datum/loadout_item/perfume_lavender
	name = "薰衣草香水"
	path = /obj/item/perfume/lavender
	triumph_cost = 2

/datum/loadout_item/perfume_cherry
	name = "樱桃香水"
	path = /obj/item/perfume/cherry
	triumph_cost = 2

/datum/loadout_item/perfume_rose
	name = "玫瑰香水"
	path = /obj/item/perfume/rose
	triumph_cost = 2

/datum/loadout_item/perfume_jasmine
	name = "茉莉香水"
	path = /obj/item/perfume/jasmine
	triumph_cost = 2

/datum/loadout_item/perfume_mint
	name = "薄荷香水"
	path = /obj/item/perfume/mint
	triumph_cost = 2

/datum/loadout_item/perfume_vanilla
	name = "香草香水"
	path = /obj/item/perfume/vanilla
	triumph_cost = 2

/datum/loadout_item/perfume_pear
	name = "梨香水"
	path = /obj/item/perfume/pear
	triumph_cost = 2

/datum/loadout_item/perfume_strawberry
	name = "草莓香水"
	path = /obj/item/perfume/strawberry
	triumph_cost = 2

/datum/loadout_item/perfume_cinnamon
	name = "肉桂香水"
	path = /obj/item/perfume/cinnamon
	triumph_cost = 2

/datum/loadout_item/perfume_frankincense
	name = "乳香香水"
	path = /obj/item/perfume/frankincense
	triumph_cost = 2

/datum/loadout_item/perfume_sandalwood
	name = "檀香香水"
	path = /obj/item/perfume/sandalwood
	triumph_cost = 2

/datum/loadout_item/perfume_myrrh
	name = "没药香水"
	path = /obj/item/perfume/myrrh
	triumph_cost = 2

/datum/loadout_item/lipstick_red
	name = "红色唇膏"
	path = /obj/item/azure_lipstick
	triumph_cost = 2

/datum/loadout_item/lipstick_jade
	name = "翠玉色唇膏"
	path = /obj/item/azure_lipstick/jade
	triumph_cost = 2

/datum/loadout_item/lipstick_purple
	name = "紫色唇膏"
	path = /obj/item/azure_lipstick/purple
	triumph_cost = 2

/datum/loadout_item/lipstick_black
	name = "黑色唇膏"
	path = /obj/item/azure_lipstick/black
	triumph_cost = 2

/datum/loadout_item/hair_dye
	name = "染发膏"
	path = /obj/item/hair_dye_cream
	triumph_cost = 2

/datum/loadout_item/branding_stick
	name = "粗制烙印棒"
	path = /obj/item/rogueweapon/surgery/cautery/branding/crude
	triumph_cost = 1

//ADDITIONAL ITEMS

/datum/loadout_item/backpack
	name = "背包"
	path = /obj/item/storage/backpack/rogue/backpack
	triumph_cost = 6

/datum/loadout_item/satchel
	name = "挎包"
	path = /obj/item/storage/backpack/rogue/satchel
	triumph_cost = 5

/datum/loadout_item/otavansatchel
	name = "奥塔万挎包"
	path = /obj/item/storage/backpack/rogue/satchel/otavan
	triumph_cost = 5

/datum/loadout_item/shortsatchel
	name = "短挎包"
	path = /obj/item/storage/backpack/rogue/satchel/short
	triumph_cost = 4

/datum/loadout_item/saddle
	name = "鞍具"
	path = /obj/item/natural/saddle
	triumph_cost = 4

/datum/loadout_item/pouches
	name = "小袋"
	path = /obj/item/storage/belt/rogue/pouch
	triumph_cost = 3

/datum/loadout_item/swatchbook
	name = "裁缝色样簿"
	path = /obj/item/book/rogue/swatchbook
	triumph_cost = 3

/datum/loadout_item/parasol
	name = "纸伞"
	path = /obj/item/rogueweapon/mace/parasol
	triumph_cost = 3

/datum/loadout_item/scabbard
	name = "剑鞘"
	path = /obj/item/rogueweapon/scabbard/sword
	triumph_cost = 1

/datum/loadout_item/scabbard/noble
	name = "贵族剑鞘"
	path = /obj/item/rogueweapon/scabbard/sword/noble
	triumph_cost = 2
	requires_nobility = TRUE

/datum/loadout_item/scabbard/royal
	name = "王室剑鞘"
	path = /obj/item/rogueweapon/scabbard/sword/royal
	triumph_cost = 3
	requires_nobility = TRUE

/datum/loadout_item/scabbard/sheathe/noble
	name = "贵族刀鞘"
	path = /obj/item/rogueweapon/scabbard/sheath/noble
	triumph_cost = 1
	requires_nobility = TRUE

/datum/loadout_item/scabbard/sheathe/royal
	name = "王室刀鞘"
	path = /obj/item/rogueweapon/scabbard/sheath/royal
	triumph_cost = 1
	requires_nobility = TRUE

/datum/loadout_item/greatweaponstrap
	name = "巨型武器背带"
	path = /obj/item/rogueweapon/scabbard/gwstrap
	triumph_cost = 2

//INSTRUMENTS

/datum/loadout_item/accordion
	name = "手风琴"
	path = /obj/item/rogue/instrument/accord
	triumph_cost = 1

/datum/loadout_item/bagpipe
	name = "风笛"
	path = /obj/item/rogue/instrument/bagpipe
	triumph_cost = 1

/datum/loadout_item/banjo
	name = "班卓琴"
	path = /obj/item/rogue/instrument/banjo
	triumph_cost = 1

/datum/loadout_item/drum
	name = "鼓"
	path = /obj/item/rogue/instrument/drum
	triumph_cost = 1

/datum/loadout_item/flute
	name = "长笛"
	path = /obj/item/rogue/instrument/flute
	triumph_cost = 1

/datum/loadout_item/guitar
	name = "吉他"
	path = /obj/item/rogue/instrument/guitar
	triumph_cost = 1

/datum/loadout_item/harmonica
	name = "口琴"
	path = /obj/item/rogue/instrument/harmonica
	triumph_cost = 1

/datum/loadout_item/harp
	name = "竖琴"
	path = /obj/item/rogue/instrument/harp
	triumph_cost = 1

/datum/loadout_item/hurdygurdy
	name = "手摇风琴"
	path = /obj/item/rogue/instrument/hurdygurdy
	triumph_cost = 1

/datum/loadout_item/jawharp
	name = "口簧琴"
	path = /obj/item/rogue/instrument/jawharp
	triumph_cost = 1

/datum/loadout_item/lute
	name = "鲁特琴"
	path = /obj/item/rogue/instrument/lute
	triumph_cost = 1

/datum/loadout_item/psyaltery
	name = "普赛诗琴"
	path = /obj/item/rogue/instrument/psyaltery
	triumph_cost = 1

/datum/loadout_item/shamisen
	name = "三味线"
	path = /obj/item/rogue/instrument/shamisen
	triumph_cost = 1

/datum/loadout_item/trumpet
	name = "小号"
	path = /obj/item/rogue/instrument/trumpet
	triumph_cost = 1

/datum/loadout_item/viola
	name = "中提琴"
	path = /obj/item/rogue/instrument/viola
	triumph_cost = 1

/datum/loadout_item/vocaltalisman
	name = "歌咏护符"
	path = /obj/item/rogue/instrument/vocals
	triumph_cost = 1

// Unique stuff that doesn't quite fit anywhere else.

/datum/loadout_item/kazengunite_smithing_manual
	name = "火术传书"
	desc = "一本风钢岩锻造手册。阅读后可在铁砧解锁风钢岩护甲与武器配方，但需要懂得风郡语。"
	path = /obj/item/book/granter/trait/kazengunite_smith
	triumph_cost = 3

//CAPARISONS

/datum/loadout_item/caparison
	name = "坐骑披衣"
	path = /obj/item/caparison

/datum/loadout_item/caparison/psy
	name = "普赛顿坐骑披衣"
	path = /obj/item/caparison/psy

/datum/loadout_item/caparison/astrata
	name = "阿斯特拉塔坐骑披衣"
	path = /obj/item/caparison/astrata

/datum/loadout_item/caparison/eora
	name = "伊欧拉坐骑披衣"
	path = /obj/item/caparison/eora

/datum/loadout_item/caparison/azure
	name = "公爵坐骑披衣"
	path = /obj/item/caparison/azure

/datum/loadout_item/caparison/fogbeast
	name = "雾兽披衣"
	path = /obj/item/caparison/fogbeast

/datum/loadout_item/caparison/fogbeast/azure
	name = "雾兽用蔚蓝鞍饰毯"
	path = /obj/item/caparison/fogbeast/azure

/datum/loadout_item/cloak_absolutionistrobe_black
	name = "Blessed robe"
	path = /obj/item/clothing/cloak/absolutionistrobe/black

/datum/loadout_item/cloak_apron_waist_maid
	name = "Maid apron"
	path = /obj/item/clothing/cloak/apron/waist/maid

/datum/loadout_item/cloak_bandolier
	name = "Bandolier"
	path = /obj/item/clothing/cloak/bandolier

/datum/loadout_item/cloak_bandolier_inq
	name = "Inquisitorial bandolier"
	path = /obj/item/clothing/cloak/bandolier/inq

/datum/loadout_item/cloak_bishop
	name = "Bishop cape"
	path = /obj/item/clothing/cloak/bishop

/datum/loadout_item/cloak_cape_inquisitorgold
	name = "Golden order cloak"
	path = /obj/item/clothing/cloak/cape/inquisitorgold

/datum/loadout_item/cloak_cape_inquisitorsilver
	name = "Silver order cloak"
	path = /obj/item/clothing/cloak/cape/inquisitorsilver

/datum/loadout_item/cloak_etrcape
	name = "Wanderer's cape"
	path = /obj/item/clothing/cloak/etrcape

/datum/loadout_item/cloak_half_duelcape
	name = "Duelist cape (duelcape)"
	path = /obj/item/clothing/cloak/half/duelcape

/datum/loadout_item/cloak_half_shadowcloak_spymaster
	name = "Hand's cloak"
	path = /obj/item/clothing/cloak/half/shadowcloak/spymaster

/datum/loadout_item/cloak_poncho_fancycoat
	name = "Fancy coat (fancycoat)"
	path = /obj/item/clothing/cloak/poncho/fancycoat

/datum/loadout_item/cloak_poncho_fancycoat_trimmed
	name = "Trimmed fancy coat"
	path = /obj/item/clothing/cloak/poncho/fancycoat/trimmed

/datum/loadout_item/cloak_rangercloak
	name = "Ranger cloak"
	path = /obj/item/clothing/cloak/rangercloak

/datum/loadout_item/cloak_rosa
	name = "Regal cloak"
	path = /obj/item/clothing/cloak/rosa

/datum/loadout_item/cloak_rosa_two
	name = "Courtly cloak"
	path = /obj/item/clothing/cloak/rosa/two

/datum/loadout_item/cloak_sash
	name = "Sash"
	path = /obj/item/clothing/cloak/sash

/datum/loadout_item/cloak_sash_dupatta
	name = "Dupatta"
	path = /obj/item/clothing/cloak/sash/dupatta

/datum/loadout_item/cloak_scaledcloak
	name = "Scaled cloak"
	path = /obj/item/clothing/cloak/scaledcloak

/datum/loadout_item/cloak_scout
	name = "Scout cloak"
	path = /obj/item/clothing/cloak/scout

/datum/loadout_item/cloak_sheriff
	name = "Sheriff's cloak"
	path = /obj/item/clothing/cloak/sheriff

/datum/loadout_item/cloak_sleevedtabard
	name = "Sleeved tabard"
	path = /obj/item/clothing/cloak/sleevedtabard

/datum/loadout_item/cloak_tabard_psydontabard_black
	name = "Blessed tabard"
	path = /obj/item/clothing/cloak/tabard/psydontabard/black

/datum/loadout_item/cloak_tabard_psydontabard_white
	name = "Traditional tabard"
	path = /obj/item/clothing/cloak/tabard/psydontabard/white

/datum/loadout_item/cloak_tabard_psydontabard_white_alt
	name = "Opened traditional tabard"
	path = /obj/item/clothing/cloak/tabard/psydontabard/white/alt

/datum/loadout_item/cloak_tabard_stabard_crusader
	name = "Surcoat of the golden order"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader

/datum/loadout_item/cloak_tabard_stabard_crusader_astrata
	name = "Surcoat of the golden order (astrata)"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/astrata

/datum/loadout_item/cloak_tabard_stabard_crusader_bsteel
	name = "Surcoat of the blacksteel order"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/bsteel

/datum/loadout_item/cloak_tabard_stabard_crusader_heavy
	name = "Overvestments"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/heavy

/datum/loadout_item/cloak_tabard_stabard_crusader_t
	name = "Surcoat of the silver order"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/t

/datum/loadout_item/cloak_tabard_stabard_crusader_t_astrata
	name = "Surcoat of the silver order (astrata)"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/t/astrata

/datum/loadout_item/cloak_tabard_stabard_crusader_t_see
	name = "Surcoat of the silver order (see)"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/t/see

/datum/loadout_item/cloak_tabard_stabard_crusader_see
	name = "Surcoat of the golden order (see)"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/see

/datum/loadout_item/cloak_tabard_stabard_surcoat_short
	name = "Short jupon"
	path = /obj/item/clothing/cloak/tabard/stabard/surcoat/short

/datum/loadout_item/cloak_tabard_toga
	name = "Toga (toga)"
	path = /obj/item/clothing/cloak/tabard/toga

/datum/loadout_item/cloak_tabard_toga_alt
	name = "Bared toga"
	path = /obj/item/clothing/cloak/tabard/toga/alt

/datum/loadout_item/cloak_tabard_toga_dress
	name = "Toga (dress)"
	path = /obj/item/clothing/cloak/tabard/toga/dress

/datum/loadout_item/cloak_tabard_toga_dress_alt
	name = "Bared toga (alt)"
	path = /obj/item/clothing/cloak/tabard/toga/dress/alt

/datum/loadout_item/cloak_templar_astratancleric
	name = "Astratan cloak"
	path = /obj/item/clothing/cloak/templar/astratancleric

/datum/loadout_item/cloak_templar_astratancleric_grey
	name = "Frayed cloak"
	path = /obj/item/clothing/cloak/templar/astratancleric/grey

/datum/loadout_item/cloak_templar_eoran_alt
	name = "Eoran tabard (alt)"
	path = /obj/item/clothing/cloak/templar/eoran/alt

/datum/loadout_item/cloak_templar_necrancleric
	name = "Necran cloak"
	path = /obj/item/clothing/cloak/templar/necrancleric

/datum/loadout_item/cloak_templar_ravoxcleric
	name = "Justice cloak"
	path = /obj/item/clothing/cloak/templar/ravoxcleric

/datum/loadout_item/cloak_templar_see_alt
	name = "See templar tabard"
	path = /obj/item/clothing/cloak/templar/see_alt

/datum/loadout_item/cloak_templar_seecleric
	name = "See devotee tabard"
	path = /obj/item/clothing/cloak/templar/seecleric

/datum/loadout_item/cloak_desert
	name = "Desert cloak"
	path = /obj/item/clothing/cloak/desert

/datum/loadout_item/cloak_elven
	name = "Elven cloak"
	path = /obj/item/clothing/cloak/elven

/datum/loadout_item/cloak_elven_short
	name = "Elven shortcloak"
	path = /obj/item/clothing/cloak/elven/short

/datum/loadout_item/cloak_scarf
	name = "Scarf (elven)"
	path = /obj/item/clothing/cloak/scarf

/datum/loadout_item/gloves_roguetown_fingerless_shadowgloves_spymaster
	name = "Hand's gloves"
	path = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/spymaster

/datum/loadout_item/gloves_roguetown_rosa
	name = "Ivory gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa

/datum/loadout_item/gloves_roguetown_rosa_eight
	name = "Courtly gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/eight

/datum/loadout_item/gloves_roguetown_rosa_five
	name = "Sable gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/five

/datum/loadout_item/gloves_roguetown_rosa_four
	name = "Obsidian gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/four

/datum/loadout_item/gloves_roguetown_rosa_nine
	name = "Royal gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/nine

/datum/loadout_item/gloves_roguetown_rosa_seven
	name = "Regal gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/seven

/datum/loadout_item/gloves_roguetown_rosa_six
	name = "Maroon gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/six

/datum/loadout_item/gloves_roguetown_rosa_ten
	name = "Stately gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/ten

/datum/loadout_item/gloves_roguetown_rosa_three
	name = "Silvered gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/three

/datum/loadout_item/head_roguetown_antlers
	name = "Old antlers"
	path = /obj/item/clothing/head/roguetown/antlers

/datum/loadout_item/head_roguetown_circlet_carvedgem_porcelain
	name = "Porcelain circlet"
	path = /obj/item/clothing/head/roguetown/circlet/carvedgem/porcelain

/datum/loadout_item/head_roguetown_courtphysician
	name = "Sanguine hat"
	path = /obj/item/clothing/head/roguetown/courtphysician

/datum/loadout_item/head_roguetown_courtphysician_female
	name = "Sanguine cap"
	path = /obj/item/clothing/head/roguetown/courtphysician/female

/datum/loadout_item/head_roguetown_deserthood
	name = "Desert hood"
	path = /obj/item/clothing/head/roguetown/deserthood

/datum/loadout_item/head_roguetown_doublehennin
	name = "Dual hennin"
	path = /obj/item/clothing/head/roguetown/doublehennin

/datum/loadout_item/head_roguetown_duelhat_etrhat
	name = "Wanderer's hat"
	path = /obj/item/clothing/head/roguetown/duelhat/etrhat

/datum/loadout_item/head_roguetown_duelhat_etrusca
	name = "Etruscan duelist hat"
	path = /obj/item/clothing/head/roguetown/duelhat/etrusca

/datum/loadout_item/head_roguetown_durag
	name = "Durag"
	path = /obj/item/clothing/head/roguetown/durag

/datum/loadout_item/head_roguetown_eaststrawhat
	name = "Worn rice hat"
	path = /obj/item/clothing/head/roguetown/eaststrawhat

/datum/loadout_item/head_roguetown_explorerhat
	name = "Explorer's hat (explorerhat)"
	path = /obj/item/clothing/head/roguetown/explorerhat

/datum/loadout_item/head_roguetown_flamboyant
	name = "Flamboyant hat"
	path = /obj/item/clothing/head/roguetown/flamboyant

/datum/loadout_item/head_roguetown_flotsam
	name = "Flotsam bonnet"
	path = /obj/item/clothing/head/roguetown/flotsam

/datum/loadout_item/head_roguetown_gasa
	name = "Gasa"
	path = /obj/item/clothing/head/roguetown/gasa

/datum/loadout_item/head_roguetown_headband_fur
	name = "Fur headband"
	path = /obj/item/clothing/head/roguetown/headband/fur

/datum/loadout_item/head_roguetown_hscarf
	name = "Head scarf"
	path = /obj/item/clothing/head/roguetown/hscarf

/datum/loadout_item/head_roguetown_longveil
	name = "Long veil"
	path = /obj/item/clothing/head/roguetown/longveil

/datum/loadout_item/head_roguetown_maidhead
	name = "Maid headdress"
	path = /obj/item/clothing/head/roguetown/maidhead

/datum/loadout_item/head_roguetown_menacing_executioner
	name = "Executioners hood"
	path = /obj/item/clothing/head/roguetown/menacing/executioner

/datum/loadout_item/head_roguetown_nightcap
	name = "Nitecap"
	path = /obj/item/clothing/head/roguetown/nightcap

/datum/loadout_item/head_roguetown_nun_hood
	name = "Nun hood"
	path = /obj/item/clothing/head/roguetown/nun_hood

/datum/loadout_item/head_roguetown_onhelm_tw_d_basic
	name = "Helm's chaperon"
	path = /obj/item/clothing/head/roguetown/onhelm/tw_d_basic

/datum/loadout_item/head_roguetown_onhelm_tw_d_horns
	name = "Horns helmkleinod"
	path = /obj/item/clothing/head/roguetown/onhelm/tw_d_horns

/datum/loadout_item/head_roguetown_roguehood_bishop
	name = "Bishop hood"
	path = /obj/item/clothing/head/roguetown/roguehood/bishop

/datum/loadout_item/head_roguetown_roguehood_burgerhood
	name = "Noble hood"
	path = /obj/item/clothing/head/roguetown/roguehood/burgerhood

/datum/loadout_item/head_roguetown_roguehood_eorahood
	name = "Opera hood"
	path = /obj/item/clothing/head/roguetown/roguehood/eorahood

/datum/loadout_item/head_roguetown_roguehood_ravox
	name = "Ravox hood"
	path = /obj/item/clothing/head/roguetown/roguehood/ravox

/datum/loadout_item/head_roguetown_roguehood_see
	name = "See hood"
	path = /obj/item/clothing/head/roguetown/roguehood/see

/datum/loadout_item/head_roguetown_roningasa
	name = "Roningasa"
	path = /obj/item/clothing/head/roguetown/roningasa

/datum/loadout_item/head_roguetown_sandogasa
	name = "Sandogasa"
	path = /obj/item/clothing/head/roguetown/sandogasa

/datum/loadout_item/head_roguetown_stewardtophat
	name = "Top hat"
	path = /obj/item/clothing/head/roguetown/stewardtophat

/datum/loadout_item/head_roguetown_tiyon
	name = "Tiyon"
	path = /obj/item/clothing/head/roguetown/tiyon

/datum/loadout_item/head_roguetown_torioigasa
	name = "Torioigasa"
	path = /obj/item/clothing/head/roguetown/torioigasa

/datum/loadout_item/head_roguetown_elven_hat
	name = "Elven burka"
	path = /obj/item/clothing/head/roguetown/elven_hat

/datum/loadout_item/head_roguetown_hammerhold_hat
	name = "Kokoshnik"
	path = /obj/item/clothing/head/roguetown/hammerhold_hat

/datum/loadout_item/head_roguetown_hammerhold_hat_peasant
	name = "Hammerhold hat"
	path = /obj/item/clothing/head/roguetown/hammerhold_hat/peasant

/datum/loadout_item/head_roguetown_veiledhat
	name = "Veiled hat"
	path = /obj/item/clothing/head/roguetown/veiledhat

/datum/loadout_item/mask_rogue_blindfold_psydon
	name = "Blessed blindfold"
	path = /obj/item/clothing/mask/rogue/blindfold/psydon

/datum/loadout_item/mask_rogue_eyepatch_fake
	name = "Eyepatch"
	path = /obj/item/clothing/mask/rogue/eyepatch/fake

/datum/loadout_item/mask_rogue_eyepatch_left_fake
	name = "Eyepatch (fake)"
	path = /obj/item/clothing/mask/rogue/eyepatch/left/fake

/datum/loadout_item/mask_rogue_facemask_xylixmask
	name = "Xylixian mask"
	path = /obj/item/clothing/mask/rogue/facemask/xylixmask

/datum/loadout_item/mask_rogue_faceveil
	name = "Simple veil"
	path = /obj/item/clothing/mask/rogue/faceveil

/datum/loadout_item/mask_rogue_physician_feld
	name = "Feldsher's mask"
	path = /obj/item/clothing/mask/rogue/physician/feld

/datum/loadout_item/mask_rogue_physician_phys
	name = "Physicker's mask"
	path = /obj/item/clothing/mask/rogue/physician/phys

/datum/loadout_item/mask_rogue_shepherd_shadowmask_spymaster
	name = "Hand's halfmask"
	path = /obj/item/clothing/mask/rogue/shepherd/shadowmask/spymaster

/datum/loadout_item/mask_rogue_spectacles_sglasses
	name = "Smokey onyxa spectacles"
	path = /obj/item/clothing/mask/rogue/spectacles/sglasses

/datum/loadout_item/mask_rogue_spectacles_thin
	name = "Thin-lensed spectacles"
	path = /obj/item/clothing/mask/rogue/spectacles/thin

/datum/loadout_item/mask_rogue_xylixmask_ceramic
	name = "Ceramic mask"
	path = /obj/item/clothing/mask/rogue/xylixmask/ceramic

/datum/loadout_item/mask_rogue_xylixmask_weathered
	name = "Weathered mask"
	path = /obj/item/clothing/mask/rogue/xylixmask/weathered

/datum/loadout_item/neck_roguetown_collar_fur
	name = "Fur collar"
	path = /obj/item/clothing/neck/roguetown/collar/fur

/datum/loadout_item/neck_roguetown_cravat
	name = "Cravat"
	path = /obj/item/clothing/neck/roguetown/cravat

/datum/loadout_item/neck_roguetown_ruffle
	name = "Ruffled collar"
	path = /obj/item/clothing/neck/roguetown/ruffle

/datum/loadout_item/shoes_roguetown_boots_hammerhold_boots
	name = "Hammerhold boots"
	path = /obj/item/clothing/shoes/roguetown/boots/hammerhold_boots

/datum/loadout_item/shoes_roguetown_courtphysician
	name = "Sanguine shoes"
	path = /obj/item/clothing/shoes/roguetown/courtphysician

/datum/loadout_item/shoes_roguetown_courtphysician_female
	name = "Sanguine heels"
	path = /obj/item/clothing/shoes/roguetown/courtphysician/female

/datum/loadout_item/shoes_roguetown_hammerhold_shoes
	name = "Hammerhold shoes"
	path = /obj/item/clothing/shoes/roguetown/hammerhold_shoes

/datum/loadout_item/shoes_roguetown_rosa
	name = "Ivory shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa

/datum/loadout_item/shoes_roguetown_rosa_eight
	name = "Courtly shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa/eight

/datum/loadout_item/shoes_roguetown_rosa_five
	name = "Sable shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa/five

/datum/loadout_item/shoes_roguetown_rosa_four
	name = "Obsidian shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa/four

/datum/loadout_item/shoes_roguetown_rosa_nine
	name = "Royal shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa/nine

/datum/loadout_item/shoes_roguetown_rosa_seven
	name = "Regal shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa/seven

/datum/loadout_item/shoes_roguetown_rosa_ten
	name = "Stately shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa/ten

/datum/loadout_item/shoes_roguetown_rosa_three
	name = "Silvered shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa/three

/datum/loadout_item/suit_roguetown_shirt_courtphysician
	name = "Sanguine vest"
	path = /obj/item/clothing/suit/roguetown/shirt/courtphysician

/datum/loadout_item/suit_roguetown_shirt_courtphysician_female
	name = "Sanguine blouse"
	path = /obj/item/clothing/suit/roguetown/shirt/courtphysician/female

/datum/loadout_item/suit_roguetown_shirt_desertbra
	name = "Desert bra"
	path = /obj/item/clothing/suit/roguetown/shirt/desertbra

/datum/loadout_item/suit_roguetown_shirt_dress_blue
	name = "Light blue dress (blue)"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/blue

/datum/loadout_item/suit_roguetown_shirt_dress_etrdress
	name = "Low-cut dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/etrdress

/datum/loadout_item/suit_roguetown_shirt_dress_etrdress2
	name = "Embroidered dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/etrdress2

/datum/loadout_item/suit_roguetown_shirt_dress_etrdress3
	name = "Strapless gown"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/etrdress3

/datum/loadout_item/suit_roguetown_shirt_dress_green
	name = "Light green dress (green)"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/green

/datum/loadout_item/suit_roguetown_shirt_dress_maidfancy
	name = "Valorian maid dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/maidfancy

/datum/loadout_item/suit_roguetown_shirt_dress_nightgown
	name = "Nightgown (nightgown)"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/nightgown

/datum/loadout_item/suit_roguetown_shirt_dress_saree
	name = "Saree"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/saree

/datum/loadout_item/suit_roguetown_shirt_dress_silkdress_bishop
	name = "Bishop's cassock"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/bishop

/datum/loadout_item/suit_roguetown_shirt_dress_tavern
	name = "Tavern dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/tavern

/datum/loadout_item/suit_roguetown_shirt_explorer
	name = "Explorer's vest (explorer)"
	path = /obj/item/clothing/suit/roguetown/shirt/explorer

/datum/loadout_item/suit_roguetown_shirt_fancyjacket
	name = "Fancy jacket"
	path = /obj/item/clothing/suit/roguetown/shirt/fancyjacket

/datum/loadout_item/suit_roguetown_shirt_fancyjacket_triumph_padded
	name = "Dark jacket"
	path = /obj/item/clothing/suit/roguetown/shirt/fancyjacket/triumph_padded

/datum/loadout_item/suit_roguetown_shirt_haori
	name = "Haori"
	path = /obj/item/clothing/suit/roguetown/shirt/haori

/datum/loadout_item/suit_roguetown_shirt_kamishimo
	name = "Kamishimo"
	path = /obj/item/clothing/suit/roguetown/shirt/kamishimo

/datum/loadout_item/suit_roguetown_shirt_kazengun_jacket
	name = "Kazengun jacket"
	path = /obj/item/clothing/suit/roguetown/shirt/kazengun_jacket

/datum/loadout_item/suit_roguetown_shirt_kimono
	name = "Kimono"
	path = /obj/item/clothing/suit/roguetown/shirt/kimono

/datum/loadout_item/suit_roguetown_shirt_kimono2
	name = "Long sleeved kimono"
	path = /obj/item/clothing/suit/roguetown/shirt/kimono2

/datum/loadout_item/suit_roguetown_shirt_robe_abyssor_leader
	name = "Sylveric robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_leader

/datum/loadout_item/suit_roguetown_shirt_robe_abyssor_painter
	name = "Rainfall robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter

/datum/loadout_item/suit_roguetown_shirt_robe_abyssor_painter_sea
	name = "Sea robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter_sea

/datum/loadout_item/suit_roguetown_shirt_robe_bared
	name = "Bared robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/bared

/datum/loadout_item/suit_roguetown_shirt_robe_eora_resprite
	name = "Eoran robe (resprite)"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/eora/resprite

/datum/loadout_item/suit_roguetown_shirt_robe_eora_resprite_pink
	name = "Eoran robe (pink)"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/eora/resprite/pink

/datum/loadout_item/suit_roguetown_shirt_robe_hag
	name = "Hedge robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/hag

/datum/loadout_item/suit_roguetown_shirt_robe_leopard
	name = "Leopard robe (leopard)"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/leopard

/datum/loadout_item/suit_roguetown_shirt_robe_leopard_alt
	name = "Open leopard robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/leopard/alt

/datum/loadout_item/suit_roguetown_shirt_robe_nun_dress
	name = "Nun dress"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/nun_dress

/datum/loadout_item/suit_roguetown_shirt_robe_ravox
	name = "Ravox robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/ravox

/datum/loadout_item/suit_roguetown_shirt_robe_see
	name = "See robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/see

/datum/loadout_item/suit_roguetown_shirt_robe_seecleric
	name = "See clerical robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/seecleric

/datum/loadout_item/suit_roguetown_shirt_silkbra
	name = "Giltsilk bra"
	path = /obj/item/clothing/suit/roguetown/shirt/silkbra

/datum/loadout_item/suit_roguetown_shirt_tunic_rosa
	name = "Ivory dress"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa

/datum/loadout_item/suit_roguetown_shirt_tunic_rosa_five
	name = "Sable dress"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/five

/datum/loadout_item/suit_roguetown_shirt_tunic_rosa_four
	name = "Obsidian dress"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/four

/datum/loadout_item/suit_roguetown_shirt_tunic_rosa_six
	name = "Maroon dress"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/six

/datum/loadout_item/suit_roguetown_shirt_tunic_rosa_three
	name = "Velvet dress"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/three

/datum/loadout_item/suit_roguetown_shirt_tunic_rosacoat
	name = "Regal coat"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat

/datum/loadout_item/suit_roguetown_shirt_tunic_rosacoat_four
	name = "Stately coat"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/four

/datum/loadout_item/suit_roguetown_shirt_tunic_rosacoat_two
	name = "Courtly coat"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/two

/datum/loadout_item/suit_roguetown_shirt_elven
	name = "Elven suit"
	path = /obj/item/clothing/suit/roguetown/shirt/elven

/datum/loadout_item/suit_roguetown_shirt_elven_coat
	name = "Elven coat"
	path = /obj/item/clothing/suit/roguetown/shirt/elven/coat

/datum/loadout_item/suit_roguetown_shirt_elven_coat_alt
	name = "Elven furcoat"
	path = /obj/item/clothing/suit/roguetown/shirt/elven/coat/alt

/datum/loadout_item/suit_roguetown_shirt_hammerhold
	name = "Hammerhold shirt"
	path = /obj/item/clothing/suit/roguetown/shirt/hammerhold

/datum/loadout_item/suit_roguetown_shirt_hammerhold_coat
	name = "Noble coat"
	path = /obj/item/clothing/suit/roguetown/shirt/hammerhold/coat

/datum/loadout_item/suit_roguetown_shirt_undershirt_etrdoublet
	name = "Doublet"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/etrdoublet

/datum/loadout_item/suit_roguetown_shirt_yoroihitatare
	name = "Yoroihitatare"
	path = /obj/item/clothing/suit/roguetown/shirt/yoroihitatare

/datum/loadout_item/under_roguetown_loincloth_deprived
	name = "Large loincloth"
	path = /obj/item/clothing/under/roguetown/loincloth/deprived

/datum/loadout_item/under_roguetown_skirt_courtphysician
	name = "Sanguine skirt"
	path = /obj/item/clothing/under/roguetown/skirt/courtphysician

/datum/loadout_item/under_roguetown_skirt_desert
	name = "Desert skirt"
	path = /obj/item/clothing/under/roguetown/skirt/desert

/datum/loadout_item/under_roguetown_skirt_formal
	name = "Knee-high skirt (formal)"
	path = /obj/item/clothing/under/roguetown/skirt/formal

/datum/loadout_item/under_roguetown_skirt_short
	name = "Short skirt"
	path = /obj/item/clothing/under/roguetown/skirt/short

/datum/loadout_item/under_roguetown_tights_dhoti
	name = "Dhoti"
	path = /obj/item/clothing/under/roguetown/tights/dhoti

/datum/loadout_item/under_roguetown_tights_hose
	name = "Cloth hosen"
	path = /obj/item/clothing/under/roguetown/tights/hose

/datum/loadout_item/backpack_rogue_backpack_trader
	name = "Trader's pack"
	path = /obj/item/storage/backpack/rogue/backpack/trader
	triumph_cost = 6

/datum/loadout_item/belt_rogue_leather_battleskirt_loincloth
	name = "Cloth loincloth"
	path = /obj/item/storage/belt/rogue/leather/battleskirt/loincloth

/datum/loadout_item/belt_rogue_leather_belthooks
	name = "Belt hooks"
	path = /obj/item/storage/belt/rogue/leather/belthooks

/datum/loadout_item/belt_rogue_leather_beltshawl
	name = "Belt shawl"
	path = /obj/item/storage/belt/rogue/leather/beltshawl

/datum/loadout_item/belt_rogue_leather_hammerhold_sash
	name = "Hammerhold sash"
	path = /obj/item/storage/belt/rogue/leather/hammerhold_sash

/datum/loadout_item/belt_rogue_leather_iron
	name = "Iron belt"
	path = /obj/item/storage/belt/rogue/leather/iron

/datum/loadout_item/belt_rogue_leather_sash_maid
	name = "Cloth sash (maid)"
	path = /obj/item/storage/belt/rogue/leather/sash/maid
