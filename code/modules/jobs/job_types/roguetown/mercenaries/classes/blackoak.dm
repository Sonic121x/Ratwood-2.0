// Elven unique mercenary type; should be scary in a way solo but easy to kill with a group or bow.
/datum/advclass/mercenary/blackoak
	name = "黑橡 守卫"
	tutorial = "你是 黑橡 阵营中一名潜行的守卫者。这支人马一半是佣兵团，一半是为争夺群峰间祖传精灵故土而战的非正规民兵。所幸，你今天来这里并不是为了屠戮公爵麾下的人马，除非……有人出钱让你这么做。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/human/halfelf,
		/datum/species/elf/wood,
		/datum/species/elf/dark,
	)
	outfit = /datum/outfit/job/roguetown/mercenary/blackoak
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_blackoak.ogg'
	extra_context = "该分支仅限半精灵、精灵与黑暗精灵选择。"
	traits_applied = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_BLACKOAK, TRAIT_MEDIUMARMOR, TRAIT_WOODWALKER)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_PER = 1,
		STATKEY_INT = -1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/blackoak/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm
	armor = /obj/item/clothing/suit/roguetown/armor/plate/elven_plate
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	beltl = /obj/item/rogueweapon/scabbard/sheath
	beltr = /obj/item/rogueweapon/scabbard/sword
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel/black
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hatanga
	pants = /obj/item/clothing/under/roguetown/trou/leather
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/elvish = 1,
		/obj/item/flashlight/flare/torch
		)

	if(H.mind)
		var/weapons = list("精灵剑矛", "精灵弯刃",)
		var/weapon_choice = input(H, "选择你的武器。", "可见的威胁") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("精灵剑矛")
				r_hand = /obj/item/rogueweapon/spear/naginata/elf
			if("精灵弯刃")
				r_hand = /obj/item/rogueweapon/greatsword/elf

		var/sidearm = list("精灵长剑", "精灵短剑")
		var/sidearm_choice = input(H, "选择你的副手武器。", "隐藏之刺") as anything in sidearm
		switch(sidearm_choice)
			if("精灵长剑") // Longsword but sharper.
				l_hand = /obj/item/rogueweapon/sword/long/elf
			if("精灵短剑")
				l_hand = /obj/item/rogueweapon/sword/short/elf

	H.merctype = 2
/datum/advclass/mercenary/blackoak/ranger
	name = "黑橡 游侠"
	tutorial = "你是 黑橡 阵营中一名潜行的守卫者。这支人马一半是佣兵团，一半是为争夺群峰间祖传精灵故土而战的非正规民兵。所幸，你今天来这里并不是为了屠戮公爵麾下的人马，除非……有人出钱让你这么做。"
	outfit = /datum/outfit/job/roguetown/mercenary/blackoak_ranger
	traits_applied = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_BLACKOAK, TRAIT_DODGEEXPERT, TRAIT_WOODWALKER)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/blackoak_ranger/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/elven
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	beltl = /obj/item/quiver/arrows
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/blackoak
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel/black
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hatanga
	pants = /obj/item/clothing/under/roguetown/trou/leather
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/elvish = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch = 1
		)
	H.merctype = 2

/datum/outfit/job/roguetown/mercenary/blackoak_ranger/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("精灵匕首", "精灵军刀", "精灵短剑")
	var/weapon_choice = input(H, "选择你的武器。", "为了橡林与谷地") as anything in weapons
	switch(weapon_choice)
		if("精灵匕首") // The classic dagger option.
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/silver/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath, SLOT_BELT_R, TRUE)
		if("精灵军刀") // Dodge option for doing good damage at the cost of your poor stamina.
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/elf)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
		if("精灵短剑") // Parry option for regular shortsword damage but high sharpness & integrity equals less damage decay.
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/elf)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)

	var/armors = list("靛蓝精灵锁甲", "毛皮衬里战利品长袍")
	var/armor_choice = input(H, "选择你的护甲。", "森林庇护着你") as anything in armors
	switch(armor_choice)
		if("靛蓝精灵锁甲")
			REMOVE_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/elven_plate/light, SLOT_ARMOR, TRUE)
		if("毛皮衬里战利品长袍")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/elven, SLOT_ARMOR, TRUE)
	var/helmets = list("靛蓝精灵巴布特盔", "精灵巴布特盔", "翼饰精灵巴布特盔")
	var/helmet_choice = input(H, "选择你的头盔。", "绿叶覆于钢铁之上") as anything in helmets
	switch(helmet_choice)
		if("靛蓝精灵巴布特盔")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/light, SLOT_HEAD, TRUE)
		if("精灵巴布特盔")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/elvenbarbute/blackoak, SLOT_HEAD, TRUE)
		if("翼饰精灵巴布特盔")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged/blackoak, SLOT_HEAD, TRUE)
