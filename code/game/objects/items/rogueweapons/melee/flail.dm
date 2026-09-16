/obj/item/rogueweapon/flail
	force = 25
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/mace/smash/flail)
	name = "铁连枷"
	desc = "一柄灵巧的铁制连枷，打得又狠又远。"
	icon_state = "iflail"
	icon = 'icons/roguetown/weapons/blunt32.dmi'
	sharpness = IS_BLUNT
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	//dropshrink = 0.75
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	associated_skill = /datum/skill/combat/whipsflails
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED
	throwforce = 5
	wdefense = 0
	minstr = 4
	grid_width = 32
	grid_height = 96
	special = /datum/special_intent/flail_sweep

/datum/intent/flail/strike
	name = "打击"
	blade_class = BCLASS_BLUNT
	attack_verb = list("打击", "击打")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	//We want chipping, m'lord.
	blunt_chipping = TRUE
	blunt_chip_strength = BLUNT_CHIP_WEAK

/datum/intent/flail/strike/matthiosflail
	reach = 2
	damfactor = 1.3 // More damage than peasant flail, not sure why the gilded one had worse intents before, but here we are!


/datum/intent/flail/strikerange
	name = "远距打击"
	blade_class = BCLASS_BLUNT
	attack_verb = list("打击", "击打")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 15
	damfactor = 1.2 // Extra damage. Flail babe flail.
	penfactor = BLUNT_DEFAULT_PENFACTOR
	clickcd = CLICK_CD_CHARGED // Higher delay for a powerful ranged attack
	reach = 2
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	//We want chipping, m'lord.
	blunt_chipping = TRUE
	blunt_chip_strength = BLUNT_CHIP_WEAK

/datum/intent/mace/smash/flail
	name = "连枷猛砸"
	chargetime = 0.8 SECONDS
	damfactor = 1.4 // Flail smash has higher damage due to a longer charge.
	chargedloop = /datum/looping_sound/flailswing
	keep_looping = TRUE
	icon_state = "insmash"
	blade_class = BCLASS_SMASH
	attack_verb = list("猛砸")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	item_d_type = "blunt"

/datum/intent/mace/smash/flail/matthiosflail
	reach = 2
	damfactor = 1.6 // so it's better than the militia counterpart.

/datum/intent/mace/smash/flail/militia
	damfactor = 0.9

/datum/intent/mace/smash/flail/golgotha
	hitsound = list('sound/items/beartrap2.ogg')

/datum/intent/mace/smash/flailrange
	name = "远距猛砸"
	chargetime = 1.2 SECONDS
	chargedrain = 1
	recovery = 30
	damfactor = 1.5
	reach = 2
	chargedloop = /datum/looping_sound/flailswing
	keep_looping = TRUE
	attack_verb = list("猛砸")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	item_d_type = "blunt"

/datum/intent/mace/smash/flailchop
	name = "pendulous chop"
	icon_state = "inchop"
	attack_verb = list("chops", "hacks")
	chargetime = 1.2 SECONDS
	recovery = 40
	damfactor = 1.3
	reach = 2
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = 35
	chargedloop = /datum/looping_sound/flailswing
	keep_looping = TRUE
	blade_class = BCLASS_CHOP
	item_d_type = "slash"
	blunt_chipping = FALSE

/datum/intent/flail/sweep
	name = "sweeping strike"
	icon_state = "insweep"
	blade_class = BCLASS_BLUNT
	chargetime = 1.2 SECONDS
	chargedrain = 1
	chargedloop = /datum/looping_sound/flailswing
	attack_verb = list("横扫", "横抽")
	animname = "strike"
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR
	damfactor = 1.5
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	cleave = /datum/cleave_pattern/horizontal_sweep
	desc = "A charged sweep that smashes through targets to the front."

/obj/item/rogueweapon/flail/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -3,"nx" = 11,"ny" = -2,"wx" = -7,"wy" = -3,"ex" = 3,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 22,"sturn" = -23,"wturn" = -23,"eturn" = 29,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/flail/bronze
	force = 27
	throwforce = 20
	max_integrity = 125
	icon_state = "bronzeflail"
	name = "bronze flail"
	desc = "A studded weight and a whittled handle, linked together with a length of bronze chain. It can be spun around to smash armored opponents with tremendous force, cracking plate and bone alike with unflinching impunity."
	smeltresult = /obj/item/ingot/bronze
	minstr = 7

/obj/item/rogueweapon/flail/sflail
	force = 30
	icon_state = "flail"
	desc = "一柄灵巧的钢制连枷，打得又狠又远。"
	smeltresult = /obj/item/ingot/steel
	minstr = 5

/obj/item/rogueweapon/flail/sflail/ancient
	name = "远古连枷"
	desc = "一颗抛光吉尔布兰泽钉球，以锁链连在加固手柄之上。人们说祂的子民曾将连枷奉若至宝，因为它旋舞时的轨迹仿佛重现了西翁彗星炽烈的飞行。"
	icon_state = "aflail"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/flail/sflail/ancient/decrepit
	name = "破旧连枷"
	desc = "一颗锻造青铜钉球，以锁链连在朽木握柄之上。每一次挥转，锁链都会发出呻吟，承受着千年来未曾再遇的力量；若挥得太狠，枷头甚至可能整颗甩飞出去。"
	force = 22
	max_integrity = 175
	color = "#bb9696"
	anvilrepair = null

/obj/item/rogueweapon/flail/sflail/silver
	force = 35
	icon_state = "silverflail"
	name = "白银晨星连枷"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/mace/smash/flailrange)
	desc = "一柄沉重的白银连枷。它采用格伦泽霍夫式的“晨星”设计，以更长的链条延展攻击距离。虽然它比钢连枷更强，但也需要更大的力气才能挥得得心应手。"
	smeltresult = /obj/item/ingot/silver
	minstr = 12
	is_silver = TRUE

/obj/item/rogueweapon/flail/sflail/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/flail/sflail/necraflail
	name = "“迅捷旅途”"
	desc = "这颗打击头上嵌满牙齿，每一次击中、每一次旋转都会发出凶恶的咯响。每一副牙都来自被持用者亲手送去安息之人，而将它们随身携带，正是最高形式的敬意。"
	icon_state = "necraflail"
	force = 35
	is_silver = TRUE

/obj/item/rogueweapon/flail/sflail/necraflail/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/flail/sflail/psyflail
	name = "普赛顿连枷"
	desc = "一柄装饰华丽的连枷，表面覆有礼仪性的银层薄镀。它的翼棱枷头足以砸瘪最坚韧的黑钢锁甲。"
	icon_state = "psyflail"
	force = 35
	minstr = 10
	wdefense = 0
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/flail/sflail/psyflail/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/flail/sflail/psyflail/old
	name = "耐战连枷"
	desc = "一柄装饰华丽的连枷，只是表面的白银因疏于保养而失去光泽。让彗星坠向那些不洁之物吧。"
	icon_state = "psyflail"
	force = 30
	minstr = 5
	wdefense = 0
	is_silver = FALSE
	smeltresult = /obj/item/ingot/steel
	color = COLOR_FLOORTILE_GRAY

/obj/item/rogueweapon/flail/sflail/psyflail/old/ComponentInitialize()
	return

/obj/item/rogueweapon/flail/sflail/psyflail/relic
	name = "“圣誓”"
	desc = "祂的悲恸、祂的痛苦、祂的希望，以及祂对人类的爱，尽皆悬于这条臂链末端那颗装饰华美的银钢枷头之上。 <br><br>它是献给普赛顿所珍视一切的爱之宣言，也是对宿敌的一记沉重警告：只要祂仍存世，他们便永无胜机。"
	icon_state = "psymorningstar"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/mace/smash/flailrange)

/obj/item/rogueweapon/flail/sflail/psyflail/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 0,\
	)

/obj/item/rogueweapon/flail/peasantwarflail
	force = 10
	force_wielded = 35
	possible_item_intents = list(/datum/intent/flail/strike)
	gripped_intents = list(/datum/intent/flail/strikerange, /datum/intent/mace/smash/flailrange, /datum/intent/flail/sweep)
	name = "民兵长连枷"
	desc = "正如投石索的弹丸也能击倒巨人，这柄大连枷同样遵循着将“动量”转化为“裂甲之力”的原则。"
	icon_state = "peasantwarflail"
	icon = 'icons/roguetown/weapons/blunt64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = null
	minstr = 9
	wbalance = WBALANCE_HEAVY
	smeltresult = /obj/item/ingot/iron
	associated_skill = /datum/skill/combat/polearms
	anvilrepair = /datum/skill/craft/carpentry
	dropshrink = 0.9
	wdefense = 4
	resistance_flags = FLAMMABLE

/obj/item/rogueweapon/flail/peasantwarflail/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/flail/peasantwarflail/steel
	name = "greatflail"
	desc = "The lucerne's ungaitly cousin, favoring a 'ball-and-chain' design that - once spun - can devastate anything caught in its way; a trait that makes it dearly beloved by both peasantry and knights alike."
	icon_state = "greatflail"
	wdefense = 6
	minstr = 12
	resistance_flags = FIRE_PROOF// weapon of war, not a thresher
	max_integrity = 300//+50 over iron warflail
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/flail/peasantwarflail/silver
	name = "silver greatflail"
	desc = "PSLM 81:59... AND HE COMMANDED; \"SHATTER THEM APART, LIKE A POTTER'S VESSEL AGAINST THE STONES!\" AND SO, WE STRUCK!"
	icon_state = "silver_greatflail"
	wdefense = 6
	minstr = 13
	max_integrity = 300
	resistance_flags = FIRE_PROOF// weapon of war, not a thresher
	is_silver = TRUE
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/flail/peasantwarflail/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/flail/peasantwarflail/blacksteel
	name = "blacksteel greatflail"
	desc = "An elegant flail of blacksteel that - once spun - can devastate anything caught in its way."
	icon_state = "bs_greatflail"
	wdefense = 7
	minstr = 12
	possible_item_intents = list(/datum/intent/flail/strike/matthiosflail)//this having the better intents is a smaller buff than just increasing the base force, on par with things like blacksteel greataxe and flamberg being on par with antag options
	gripped_intents = list(/datum/intent/flail/strike/matthiosflail, /datum/intent/mace/smash/flail/matthiosflail, /datum/intent/flail/sweep)
	max_integrity = 500
	resistance_flags = FIRE_PROOF// weapon of war, not a thresher
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/blacksteel
	special = /datum/special_intent/greatflail_swing//snowflake version of greatsword special that does blunt

/obj/item/rogueweapon/flail/peasantwarflail/matthios
	no_loot_taint = TRUE
	name = "鎏金连枷"
	desc = "将财富的分量，铸进这致命的一击末端。"
	icon_state = "matthiosflail"
	sellprice = 250
	smeltresult = /obj/item/ingot/gold
	possible_item_intents = list(/datum/intent/flail/strike/matthiosflail)
	gripped_intents = list(/datum/intent/flail/strike/matthiosflail, /datum/intent/mace/smash/flail/matthiosflail, /datum/intent/flail/sweep)
	associated_skill = /datum/skill/combat/whipsflails
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF// weapon of war, not a thresher
	anvilrepair = /datum/skill/craft/weaponsmithing
	wdefense = 7 //on par with blacksteel version, i've seen this thing get broken far to often
	max_integrity = 350 // 50+ compared to steel, on par with silver blessed
	special = /datum/special_intent/greatflail_swing//snowflake version of greatsword special that does blunt

/obj/item/rogueweapon/flail/peasantwarflail/matthios/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_COMMIE, "FLAIL")

/obj/item/rogueweapon/flail/peasantwarflail/stalker
	name = "spined drow greatflail"
	desc = "A pendulous, bladed, and spined orb of dark mithril hung from a thorned link of chains. For more robustly built drow caviliers, there is \
	nothing quite as potent as these fearsome greatflails. The spikes have a nasty habit of gumming up with gore; this is intentional."
	icon = 'icons/roguetown/weapons/blunt64.dmi'
	icon_state = "drowgreatflail"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/dagger/sucker_punch)//always be punching
	gripped_intents = list(/datum/intent/flail/strikerange, /datum/intent/mace/smash/flailrange, /datum/intent/mace/smash/flailchop, /datum/intent/flail/sweep)
	associated_skill = /datum/skill/combat/whipsflails
	resistance_flags = FIRE_PROOF// weapon of war, not a thresher
	minstr = 12
	wdefense = 5
	max_integrity = 300
	anvilrepair = /datum/skill/craft/weaponsmithing
	special = /datum/special_intent/greatsword_swing// put that blade to use
	bigboy = TRUE

/obj/item/rogueweapon/flail/peasantwarflail/stalker/alt
	name = "drow greatflail"
	desc = "A pendulous orb of dark mithril hung from a thorned link of chains. For more robustly built drow caviliers, there is \
	nothing quite as potent as these fearsome greatflails."
	icon_state = "drowgreatflailb"
	possible_item_intents = list(/datum/intent/flail/strike/matthiosflail, /datum/intent/dagger/sucker_punch)//we use the better intents here since it's fully focused on blunt damage
	gripped_intents = list(/datum/intent/flail/strike/matthiosflail, /datum/intent/mace/smash/flail/matthiosflail, /datum/intent/flail/sweep)
	minstr = 13// no jaluck twinks allowed!
	wdefense = 4// not as scary looking so worse defense idk
	special = /datum/special_intent/greatflail_swing// greatflail special tho!
	bigboy = TRUE

/obj/item/rogueweapon/flail/militia
	name = "民兵连枷"
	desc = "若是在另一种人生里，这柄朴素的打谷连枷原本只是拿来把麦穗敲成谷粒的工具。但落入民兵手中后，它也找到了新的使命：用伤筋断骨的重击教训那些自负过头的强盗。"
	icon_state = "milflail"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/mace/smash/flail/militia)
	force = 27
	wdefense = 3
	wbalance = WBALANCE_HEAVY

/obj/item/rogueweapon/flail/blacksteel
	name = "黑钢连枷"
	icon_state = "bs_flail"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/mace/smash/flailrange, /datum/intent/flail/sweep)
	desc = "一柄优雅的黑钢连枷。其沉重分量使其在击退板甲对手方面无可匹敌，只要使用者 \
	有足够的耐力挥动其合金链身。"
	smeltresult = /obj/item/ingot/blacksteel
	max_integrity = 250
	minstr = 12
	force = 35
