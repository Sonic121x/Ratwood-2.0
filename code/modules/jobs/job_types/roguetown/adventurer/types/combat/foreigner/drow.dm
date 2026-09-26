/datum/advclass/foreigner/drow
	name = "蛛牙杂草"//idea is these guys are important enough to be considered to join, but not important enough to get the badges of office like the spider mount, the unique mask, etc. They get most but not all.
	tutorial = "蛛牙，字面意思即为\"蜘蛛之牙\"，是一支赫赫有名的雇佣团体，擅使刀剑、 \
	长鞭与坐骑，常受雇于庞大的卓尔地下城群，偶尔也会在地表活动。 \
	你在这个傲慢而残虐的姐妹会中地位最低。像你这样的候补成员，必须在地下城的公会主母面前证明自己，才能正式入会。 \
	虽然正式称呼是辅兵，但你们更常被蔑称为\"杂草\"， \
	毕竟，在那段严酷的选拔期中，能活下来的人都寥寥无几，更别提成功入会了。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/elf/dark,
		/datum/species/human/halfelf, // Because half-drows are half-elves, guh.
	)
	outfit = /datum/outfit/job/roguetown/adventurer/drow
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	cmode_music = 'sound/music/combat_delf.ogg'
	traits_applied = list(TRAIT_DARKVISION)
	subclass_languages = list(/datum/language/otavan)
	subclass_stats = list(
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,//you learn to backstab early
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,

	)
	extra_context = "该子职业可选种族为黑暗精灵和半精灵。 \
	可选择闪避专家，总计获得 2 速度、2 意志与 1 感知， \
	或选择中甲训练，总计获得 2 力量、2 体质与 1 意志。 \
	女性卓尔获得碎卵者与破床者特质。男性卓尔 \
	力量与幸运各降低 1，速度与意志各提高 1。"

/datum/outfit/job/roguetown/adventurer/drow/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)	
		var/specialization = list("弩手", "剑士", "鞭手")
		var/specialization_choice = input(H, "你追求哪种技艺？", "选择你的专精") as anything in specialization
		switch(specialization_choice)
			if("弩手")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow/stalker/lesser//1:1 with regular slurbow, still good, just not as fancy
				beltr =  /obj/item/quiver/bolts/
			if("剑士")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				var/swords = list("镰剑", "军刀", "大军刀", "肖特尔弯剑", "刺击长剑")
				var/sword_choice = input(H, "选择你的武器。", "拿起武器") as anything in swords
				switch(sword_choice)
					if("镰剑")
						beltr = /obj/item/rogueweapon/scabbard/sword
						r_hand = /obj/item/rogueweapon/sword/falx/stalker
					if("军刀")
						beltr = /obj/item/rogueweapon/scabbard/sword
						r_hand = /obj/item/rogueweapon/sword/sabre/stalker
					if("大军刀")
						beltr = /obj/item/rogueweapon/scabbard/sword
						r_hand = /obj/item/rogueweapon/sword/long/elf/stalker
					if("肖特尔弯剑")
						beltr = /obj/item/rogueweapon/scabbard/sword
						r_hand = /obj/item/rogueweapon/sword/long/shotel/stalker
					if("刺击长剑")
						beltr = /obj/item/rogueweapon/scabbard/sword
						r_hand = /obj/item/rogueweapon/sword/long/stalker
			if("鞭手")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				var/whips = list("长鞭 - 最低力量 10", "软剑 - 最低力量 10", "巨型连枷 - 最低力量 12")
				var/whip_choice = input(H, "选择你的武器。", "拿起武器") as anything in whips
				switch(whip_choice)
					if("长鞭 - 最低力量 10")
						r_hand = /obj/item/rogueweapon/whip/spiderwhip
					if("软剑 - 最低力量 10")
						r_hand = /obj/item/rogueweapon/whip/urumi/spider
					if("巨型连枷 - 最低力量 12")
						r_hand = /obj/item/rogueweapon/flail/peasantwarflail/stalker

		var/armors = list("闪避专家", "中甲训练")
		var/armorchoice = input(H, "选择你的护甲。", "披上护甲") as anything in armors
		switch(armorchoice)
			if("闪避专家")
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_SPD, 2)
				H.change_stat(STATKEY_PER, 1)
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/shadowvest
				cloak = /obj/item/clothing/cloak/shadowcloak
				gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask/delf
				neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
				backl = /obj/item/storage/backpack/rogue/satchel/black
				backpack_contents = list( 
					/obj/item/storage/belt/rogue/pouch/coins/poor = 1, 
					/obj/item/rogueweapon/huntingknife/idagger/steel/dirk = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					)
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				belt = /obj/item/storage/belt/rogue/leather/black
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants
			if("中甲训练")
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_CON, 2)
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				belt = /obj/item/storage/belt/rogue/leather/black
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/maille
				backl = /obj/item/storage/backpack/rogue/satchel/black
				backpack_contents = list(
					/obj/item/storage/belt/rogue/pouch/coins/poor = 1, 
					/obj/item/rogueweapon/huntingknife/idagger/steel/dirk = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1
					)
				armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
				gloves = /obj/item/clothing/gloves/roguetown/plate/shadowgauntlets
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				mask = /obj/item/clothing/mask/rogue/facemask
				neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
				backr = /obj/item/rogueweapon/shield/tower
		var/helmets = list("全覆式链甲头罩", "微笑面罩盔", "面罩萨莱特盔", "铁笠盔", "精灵巴布特盔", "翼饰精灵巴布特盔")
		var/helmet_choice = input(H, "你要佩戴哪种头盔？", "穿戴装备") as anything in helmets
		switch(helmet_choice)
			if("全覆式链甲头罩")
				head = /obj/item/clothing/neck/roguetown/chaincoif/full/black
			if("微笑面罩盔")
				head = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/shadowplate
			if("面罩萨莱特盔")
				head = /obj/item/clothing/head/roguetown/helmet/sallet/visored/shadow
			if("铁笠盔")
				head = /obj/item/clothing/head/roguetown/helmet/kettle/shadow
			if("精灵巴布特盔")
				head = /obj/item/clothing/head/roguetown/helmet/elvenbarbute/shadow
			if("翼饰精灵巴布特盔")
				head = /obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged/shadow

	if(H.gender == FEMALE)
		ADD_TRAIT(H, TRAIT_DEATHBYSNUSNU, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC) // female drow have a certain stereotype
	
	if(H.gender == MALE)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_LCK, -1)//you dont want to be a male underdwelling drow
		H.change_stat(STATKEY_WIL, 1)//more likely to have been beaten = more pain tolerance
		H.change_stat(STATKEY_SPD, 1)

	if(H.age == AGE_MIDDLEAGED)
		ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC) // YEARS of experience

	if(H.age == AGE_OLD)//since these guys just get journeyman save for crossbows, they get the old age skill buff like exorcist. We want drow hags, sire.
		ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC) // YEARS & YEARS of experience
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC) // no comment
		H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)//sex joke
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
