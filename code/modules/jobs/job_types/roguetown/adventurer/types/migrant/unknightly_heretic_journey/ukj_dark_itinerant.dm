// FORSWORN KNIGHT - heavy plate and a big weapon

/datum/advclass/ukj_dark_itinerant
	name = "叛誓骑士"
	tutorial = "你曾是某个被遗忘家族的骑士，直到你背弃旧誓，转而向一位飞升者立下新誓。扈从追随在你身旁，而你仍身披普通钢甲，等待神明认定你配得上更好的恩赐。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/ukj_dark_itinerant
	category_tags = list(CTAG_UKJ_DARK_ITINERANT)
	subclass_social_rank = SOCIAL_RANK_MINOR_NOBLE
	traits_applied = list(TRAIT_DISGRACED_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/ukj_dark_itinerant
	has_loadout = TRUE

/datum/outfit/job/roguetown/ukj_dark_itinerant/pre_equip(mob/living/carbon/human/H)
	..()
	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 3,
		/obj/item/needle = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/recipe_book/survival = 1,
	)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
	//give minion orders if they're a zizite
	if (istype (H.patron, /datum/patron/inhumen/zizo))
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
			H.mind.current.faction += "[H.name]_faction"
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			backpack_contents[/obj/item/book/rogue/bibble/zizo] = 1
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen
			backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/kris/zizo] = 1
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
			backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/matthios] = 1
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
			backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/rondel/baotha] = 1
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
			backpack_contents[/obj/item/rogueweapon/huntingknife/combat/messer/graggar] = 1
	if(H.mind)
		wretch_select_bounty(H)

/datum/outfit/job/roguetown/ukj_dark_itinerant/choose_loadout(mob/living/carbon/human/H)
	. = ..()

	var/helmets = list(
		"猪面盆盔" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
		"钢萨伏依盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
		"栅栏头盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
		"桶盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
		"骑士头盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
		"带面罩萨勒盔"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
		"带吻部面罩萨雷特盔"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted,
		"阿米特盔"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
		"带吻部阿米特盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/snouted,
		"犬首盆盔" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
		"圆面盆盔"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface,
		"带吻部圆面盆盔"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/snouted,
		"伊特鲁斯卡盆盔" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
		"开缝锅盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
		"蛙嘴盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth,
		"沃尔夫面甲头盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
		"无"
	)
	var/helmchoice = input(H, "选择你的头盔。", "戴盔备战") as anything in helmets
	var/helm = helmets[helmchoice]
	if(helm)
		H.equip_to_slot_or_del(new helm(H), SLOT_HEAD, TRUE)

	var/armors = list(
		"板甲衣"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
		"板片外衣"	= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
		"钢胸甲"		= /obj/item/clothing/suit/roguetown/armor/plate/half,
		"沟槽胸甲"	= /obj/item/clothing/suit/roguetown/armor/plate/half/fluted,
	)
	var/armorchoice = input(H, "选择你的护甲。", "披甲备战") as anything in armors
	var/picked_armor = armors[armorchoice]
	if(picked_armor)
		H.equip_to_slot_or_del(new picked_armor(H), SLOT_ARMOR, TRUE)

	var/cloaks = list("战袍", "罩袍", "朱蓬")
	var/cloaks_choice = input(H, "选择你的披风。", "披上神明的色彩") as anything in cloaks
	switch(cloaks_choice)
		if("战袍")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard(H), SLOT_CLOAK, TRUE)
		if("罩袍")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard(H), SLOT_CLOAK, TRUE)
		if("朱蓬")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard/surcoat(H), SLOT_CLOAK, TRUE)

	var/weapons = list("巨剑", "焰形剑", "双手剑", "双手大刀", "巨型钉头锤", "阔刃矛", "长柄刃", "钉头锤", "长剑 + 盾牌", "巨斧", "战锤 + 盾牌", "战斧")
	var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
	switch(weapon_choice)
		if("巨剑")
			H.put_in_hands(new /obj/item/rogueweapon/greatsword(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("焰形剑")
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/grenz/flamberge(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("双手剑")
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/grenz(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("双手大刀")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/kriegmesser(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("巨型钉头锤")
			H.put_in_hands(new /obj/item/rogueweapon/mace/goden/steel(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
		if("阔刃矛")
			H.put_in_hands(new /obj/item/rogueweapon/spear/partizan(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
		if("长柄刃")
			H.put_in_hands(new /obj/item/rogueweapon/halberd/glaive(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
		if("钉头锤")
			H.put_in_hands(new /obj/item/rogueweapon/mace/steel(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
		if("长剑 + 盾牌")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/noble(H), SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
		if("巨斧")
			H.put_in_hands(new /obj/item/rogueweapon/greataxe/steel(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
		if("战锤 + 盾牌")
			H.put_in_hands(new /obj/item/rogueweapon/mace/warhammer/steel(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
		if("战斧")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)

// HARBINGER - medium armor, a horse and a bow

/datum/advclass/ukj_dark_itinerant_harbinger
	name = "先兆骑士"
	tutorial = "若旧日的领主抓到你，定会将你送上绞架。如今你作为神明的先驱策马奔行，从马背上发动袭击，在任何人追上之前远去。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/ukj_dark_itinerant_harbinger
	category_tags = list(CTAG_UKJ_DARK_ITINERANT)
	subclass_social_rank = SOCIAL_RANK_MINOR_NOBLE
	traits_applied = list(TRAIT_DISGRACED_NOBLE, TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_INT = 3,
		STATKEY_WIL = 1,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/ukj_dark_itinerant_harbinger
	has_loadout = TRUE

/datum/outfit/job/roguetown/ukj_dark_itinerant_harbinger/pre_equip(mob/living/carbon/human/H)
	..()
	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 3,
		/obj/item/needle = 1,
		/obj/item/recipe_book/survival = 1,
	)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
	if (istype (H.patron, /datum/patron/inhumen/zizo))
		if(H.mind)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
			H.mind.current.faction += "[H.name]_faction"
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			backpack_contents[/obj/item/book/rogue/bibble/zizo] = 1
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen
			backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/kris/zizo] = 1
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
			backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/matthios] = 1
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
			backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/rondel/baotha] = 1
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
			backpack_contents[/obj/item/rogueweapon/huntingknife/combat/messer/graggar] = 1
	if(H.mind)
		wretch_select_bounty(H)

/datum/outfit/job/roguetown/ukj_dark_itinerant_harbinger/choose_loadout(mob/living/carbon/human/H)
	. = ..()

	var/helmets = list(
		"猪面盆盔" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
		"钢萨伏依盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
		"栅栏头盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
		"桶盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
		"骑士头盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
		"带面罩萨勒盔"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
		"带吻部面罩萨雷特盔"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted,
		"阿米特盔"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
		"带吻部阿米特盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/snouted,
		"犬首盆盔" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
		"圆面盆盔"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface,
		"带吻部圆面盆盔"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/snouted,
		"伊特鲁斯卡盆盔" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
		"开缝锅盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
		"蛙嘴盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth,
		"沃尔夫面甲头盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
		"无"
	)
	var/helmchoice = input(H, "选择你的头盔。", "戴盔备战") as anything in helmets
	var/helm = helmets[helmchoice]
	if(helm)
		H.equip_to_slot_or_del(new helm(H), SLOT_HEAD, TRUE)

	var/armors = list(
		"板甲衣"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
		"钢胸甲"		= /obj/item/clothing/suit/roguetown/armor/plate/half,
		"沟槽胸甲"	= /obj/item/clothing/suit/roguetown/armor/plate/half/fluted,
		"鳞甲"			= /obj/item/clothing/suit/roguetown/armor/plate/scale,
	)
	var/armorchoice = input(H, "选择你的护甲。", "披甲备战") as anything in armors
	var/picked_armor = armors[armorchoice]
	if(picked_armor)
		H.equip_to_slot_or_del(new picked_armor(H), SLOT_ARMOR, TRUE)

	var/cloaks = list("战袍", "罩袍", "朱蓬")
	var/cloaks_choice = input(H, "选择你的披风。", "披上神明的色彩") as anything in cloaks
	switch(cloaks_choice)
		if("战袍")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard(H), SLOT_CLOAK, TRUE)
		if("罩袍")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard(H), SLOT_CLOAK, TRUE)
		if("朱蓬")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard/surcoat(H), SLOT_CLOAK, TRUE)

	var/weapons = list("长剑 + 弩", "钩镰 + 反曲弓", "军刀 + 反曲弓", "骑枪 + 鸢盾", "刺剑 + 长弓", "刺击剑 + 反曲弓", "军刀 + 小圆盾", "鞭子 + 弩", "软剑 + 小圆盾")
	var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
	switch(weapon_choice)
		if("长剑 + 弩")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/noble(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/bolts(H), SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("钩镰 + 反曲弓")
			H.put_in_hands(new /obj/item/rogueweapon/spear/billhook(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/arrows(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
		if("军刀 + 反曲弓")
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/noble(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/arrows(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("骑枪 + 鸢盾")
			H.put_in_hands(new /obj/item/rogueweapon/spear/lance(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
		if("刺剑 + 长弓")
			H.put_in_hands(new /obj/item/rogueweapon/sword/rapier(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/noble(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/arrows(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("刺击剑 + 反曲弓")
			H.put_in_hands(new /obj/item/rogueweapon/estoc(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/arrows(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("军刀 + 小圆盾")
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/noble(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/buckler(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
		if("鞭子 + 弩")
			H.put_in_hands(new /obj/item/rogueweapon/whip(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/bolts(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)
		if("软剑 + 小圆盾")
			H.put_in_hands(new /obj/item/rogueweapon/whip/urumi(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/buckler(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
