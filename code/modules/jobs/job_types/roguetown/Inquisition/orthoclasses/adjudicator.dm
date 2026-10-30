//Psydonian templars with decent devotion regen.
//Counting as minor nobles, as 'knights' of the See.
//They get combination setups. The backbone of the Inquisitor's sect.
/datum/advclass/psydoniantemplar // A templar, but for the Inquisition
	name = "裁律骑士"
	tutorial = "你是 普赛顿 的骑士，身披纵棱锁甲，并被赐予施行低阶神迹的能力。\
	虽然无缘更高阶的奇迹与仪式，但你以严整武艺与受祝兵装弥补了这一切。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/psydoniantemplar
	category_tags = list(CTAG_INQUISITION)
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/templarofpsydonia.ogg'
	subclass_social_rank = SOCIAL_RANK_MINOR_NOBLE
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(

		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_STR = 2,
		STATKEY_SPD = -1
	)
	
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"《普赛顿圣典》" = /obj/item/book/rogue/bibble/psy
	)
	vice_restrictions = list(/datum/charflaw/hemophage, /datum/charflaw/silverweakness)

/datum/outfit/job/roguetown/psydoniantemplar
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/psydoniantemplar/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	cloak = /obj/item/clothing/cloak/psydontabard
	gloves = /obj/item/clothing/gloves/roguetown/chain/psydon
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	belt = /obj/item/storage/belt/rogue/leather/black
	id = /obj/item/clothing/neck/roguetown/psicross/silver
	backpack_contents = list(/obj/item/roguekey/inquisition = 1,
	/obj/item/paper/inqslip/arrival/adju = 1,
	/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
	/obj/item/clothing/ring/signet/silver/inqscomm = 1)

	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2) //Higher limit compared to others.
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_retribution)//Rebuke, but blood cost and worse.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_sacrosanctity)//To get your blood back, m'lord.

/datum/outfit/job/roguetown/psydoniantemplar/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/helmets = list("普赛顿式巴尔布特盔", "普赛顿式萨雷特盔", "普赛顿式阿米特盔", "普赛顿式桶盔", "带大羽饰的普赛顿式阿米特盔", "普赛顿式沃尔夫头骨盆盔")
	var/helmet_choice = input(H,"选择你的头盔。", "戴上普赛顿的圣盔。") as anything in helmets
	switch(helmet_choice)
		if("普赛顿式巴尔布特盔")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute, SLOT_HEAD, TRUE)
		if("普赛顿式萨雷特盔")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psysallet, SLOT_HEAD, TRUE)
		if("普赛顿式阿米特盔")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm, SLOT_HEAD, TRUE)
		if("普赛顿式桶盔")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/psybucket, SLOT_HEAD, TRUE)
		if("带大羽饰的普赛顿式阿米特盔")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/knight/psy/greatplume, SLOT_HEAD, TRUE)
		if("普赛顿式沃尔夫头骨盆盔")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/psydonic, SLOT_HEAD, TRUE)

	var/armors = list("审判官 - 普赛顿锁子甲，+2 体质 / +2 意志", "裁决者 - 普赛顿胸甲，+2 智力 / +2 感知")
	var/armor_choice = input(H, "选择你的护甲。", "披上普赛顿的圣衣。") as anything in armors
	switch(armor_choice)
		if("审判官 - 普赛顿锁子甲，+2 体质 / +2 意志")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate, SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq, SLOT_SHIRT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/wrists/roguetown/bracers/chain, SLOT_WRISTS, TRUE)
		if("裁决者 - 普赛顿胸甲，+2 智力 / +2 感知")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/half/fluted/ornate, SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli, SLOT_SHIRT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/wrists/roguetown/bracers, SLOT_WRISTS, TRUE)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_PER, 2)
			H.change_stat(STATKEY_CON, -2)
			H.change_stat(STATKEY_WIL, -2)

	var/weapons = list("普赛顿长剑 + 鸢盾", "普赛顿行刑剑 + 鸢盾", "普赛顿战斧 + 鸢盾", "普赛顿长鞭 + 鸢盾",
		"普赛顿软剑 + 鸢盾","普赛顿连枷 + 鸢盾", "普赛顿巨型钉头锤 + 普赛顿短剑", "普赛顿银矛 + 普赛顿手锤", "普赛顿长柄斧 + 普赛顿短剑",
		"普赛顿戟斧 + 普赛顿短剑", "普赛顿大剑 + 普赛顿手锤")
	var/weapon_choice = input(H,"选择你的武器。", "执起普赛顿的兵刃。") as anything in weapons
	switch(weapon_choice)
		//Typical arms and such.
		if("普赛顿长剑 + 鸢盾")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/psysword(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("普赛顿行刑剑 + 鸢盾")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/exe/psy(H))
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("普赛顿战斧 + 鸢盾")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle/psyaxe(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
		if("普赛顿长鞭 + 鸢盾")
			H.put_in_hands(new /obj/item/rogueweapon/whip/psywhip_lesser(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
		if("普赛顿软剑 + 鸢盾")
			H.put_in_hands(new /obj/item/rogueweapon/whip/urumi/silver/psydonic(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
		if("普赛顿连枷 + 鸢盾")
			H.put_in_hands(new /obj/item/rogueweapon/flail/sflail/psyflail(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal, SLOT_BACK_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
		//Polearms and the like.
		if("普赛顿巨型钉头锤 + 普赛顿短剑")
			H.put_in_hands(new /obj/item/rogueweapon/mace/goden/psy(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/psy(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
		if("普赛顿银矛 + 普赛顿手锤")
			H.put_in_hands(new /obj/item/rogueweapon/spear/psyspear(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/mace/cudgel/psy(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("普赛顿长柄斧 + 普赛顿短剑")
			H.put_in_hands(new /obj/item/rogueweapon/greataxe/psy(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/psy(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("普赛顿戟斧 + 普赛顿短剑")
			H.put_in_hands(new /obj/item/rogueweapon/halberd/psyhalberd(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/psy(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("普赛顿大剑 + 普赛顿手锤")
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/psygsword(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/mace/cudgel/psy(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
