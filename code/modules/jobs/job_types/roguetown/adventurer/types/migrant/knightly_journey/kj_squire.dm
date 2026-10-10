// SQUIRE-AT-ARMS - medium armor, a melee weapon and usually a shield

/datum/advclass/kj_squire
	name = "武装侍从"
	tutorial = "你举盾步战，守在骑士身旁，也负责维护他的甲胄。只要尽心侍奉足够久，你也有望获封骑士。"
	outfit = /datum/outfit/job/roguetown/adventurer/kj_squire
	category_tags = list(CTAG_KJ_SQUIRE)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_SQUIRE_REPAIR, TRAIT_MEDIUMARMOR, TRAIT_OUTLANDER)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 2,
		STATKEY_INT = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/kj_squire
	has_loadout = TRUE

/datum/outfit/job/roguetown/adventurer/kj_squire/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/hammer/iron = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/polishing_cream = 1,
		/obj/item/armor_brush = 1,
		/obj/item/repair_kit/metal = 1,
		/obj/item/repair_kit = 1,
		/obj/item/folding_table_stored = 1,
	)

/datum/outfit/job/roguetown/adventurer/kj_squire/choose_loadout(mob/living/carbon/human/H)
	. = ..()

	var/helmets = list(
		"简易头盔" 	= /obj/item/clothing/head/roguetown/helmet,
		"锅盔" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"盆盔"		= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"萨雷特盔"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"无"
	)
	var/helmchoice = input(H, "选择你的头盔。", "戴盔备战") as anything in helmets
	var/helm = helmets[helmchoice]
	if(helm)
		H.equip_to_slot_or_del(new helm(H), SLOT_HEAD, TRUE)

	var/cloaks = list("战袍", "罩袍", "朱蓬")
	var/cloaks_choice = input(H, "选择你的披风。", "披上主人的纹章") as anything in cloaks
	switch(cloaks_choice)
		if("战袍")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard(H), SLOT_CLOAK, TRUE)
		if("罩袍")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard(H), SLOT_CLOAK, TRUE)
		if("朱蓬")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard/surcoat(H), SLOT_CLOAK, TRUE)

	var/arms_choice = input(H, "骑士精神尚未消亡。选择你的武器。", "执兵而起") as anything in list("武装剑与盾牌", "钉头锤", "连枷与盾牌", "梅塞尔刀与小圆盾", "战斧")
	switch(arms_choice)
		if("武装剑与盾牌")
			H.put_in_hands(new /obj/item/rogueweapon/sword(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/shield/heater(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("钉头锤")
			H.put_in_hands(new /obj/item/rogueweapon/mace/steel(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
		if("连枷与盾牌")
			H.put_in_hands(new /obj/item/rogueweapon/flail(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/shield/heater(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("梅塞尔刀与小圆盾")
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/messer(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/shield/buckler(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("战斧")
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)

// HOBELAR - medium armor, a polearm and a horse

/datum/advclass/kj_squire_hobelar
	name = "轻骑侍从"
	tutorial = "你在马背上以长柄兵器作战，待一天结束后照料自己的坐骑。无论你的骑士策马还是步行，你的骑术都颇为娴熟。"
	outfit = /datum/outfit/job/roguetown/adventurer/kj_squire_hobelar
	category_tags = list(CTAG_KJ_SQUIRE)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_SQUIRE_REPAIR, TRAIT_MEDIUMARMOR, TRAIT_OUTLANDER)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/adventurer/kj_squire_hobelar
	has_loadout = TRUE

/datum/outfit/job/roguetown/adventurer/kj_squire_hobelar/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/hammer/iron = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/polishing_cream = 1,
		/obj/item/armor_brush = 1,
		/obj/item/repair_kit/metal = 1,
		/obj/item/repair_kit = 1,
		/obj/item/folding_table_stored = 1,
	)

/datum/outfit/job/roguetown/adventurer/kj_squire_hobelar/choose_loadout(mob/living/carbon/human/H)
	. = ..()

	var/helmets = list(
		"简易头盔" 	= /obj/item/clothing/head/roguetown/helmet,
		"锅盔" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"盆盔"		= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"萨雷特盔"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"无"
	)
	var/helmchoice = input(H, "选择你的头盔。", "戴盔备战") as anything in helmets
	var/helm = helmets[helmchoice]
	if(helm)
		H.equip_to_slot_or_del(new helm(H), SLOT_HEAD, TRUE)

	var/cloaks = list("战袍", "罩袍", "朱蓬")
	var/cloaks_choice = input(H, "选择你的披风。", "披上主人的纹章") as anything in cloaks
	switch(cloaks_choice)
		if("战袍")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard(H), SLOT_CLOAK, TRUE)
		if("罩袍")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard(H), SLOT_CLOAK, TRUE)
		if("朱蓬")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard/surcoat(H), SLOT_CLOAK, TRUE)

	var/arms_choice = input(H, "骑士精神尚未消亡。选择你的武器。", "执兵而起") as anything in list("长戟", "钩镰", "长矛与标枪", "骑枪与小圆盾")
	switch(arms_choice)
		if("长戟")
			H.put_in_hands(new /obj/item/rogueweapon/halberd(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("钩镰")
			H.put_in_hands(new /obj/item/rogueweapon/spear/billhook(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("长矛与标枪")
			H.put_in_hands(new /obj/item/rogueweapon/spear(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/javelin/iron(H), SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("骑枪与小圆盾")
			H.put_in_hands(new /obj/item/rogueweapon/spear/lance(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/buckler(H), SLOT_BACK_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)

// BIDOWER - light armor, a bow and quick feet

/datum/advclass/kj_squire_bidower
	name = "射手侍从"
	tutorial = "你轻装旅行，在后方以弓、弩或投石索作战，在骑士冲锋之前削减敌军。"
	outfit = /datum/outfit/job/roguetown/adventurer/kj_squire_bidower
	category_tags = list(CTAG_KJ_SQUIRE)
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_SQUIRE_REPAIR, TRAIT_DODGEEXPERT, TRAIT_OUTLANDER)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/kj_squire_bidower
	has_loadout = TRUE

/datum/outfit/job/roguetown/adventurer/kj_squire_bidower/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/hammer/iron = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/polishing_cream = 1,
		/obj/item/armor_brush = 1,
		/obj/item/repair_kit/metal = 1,
		/obj/item/repair_kit = 1,
		/obj/item/folding_table_stored = 1,
	)

/datum/outfit/job/roguetown/adventurer/kj_squire_bidower/choose_loadout(mob/living/carbon/human/H)
	. = ..()

	var/helmets = list(
		"简易头盔" 	= /obj/item/clothing/head/roguetown/helmet,
		"锅盔" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"盆盔"		= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"萨雷特盔"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"无"
	)
	var/helmchoice = input(H, "选择你的头盔。", "戴盔备战") as anything in helmets
	var/helm = helmets[helmchoice]
	if(helm)
		H.equip_to_slot_or_del(new helm(H), SLOT_HEAD, TRUE)

	var/cloaks = list("战袍", "罩袍", "朱蓬")
	var/cloaks_choice = input(H, "选择你的披风。", "披上主人的纹章") as anything in cloaks
	switch(cloaks_choice)
		if("战袍")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard(H), SLOT_CLOAK, TRUE)
		if("罩袍")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard(H), SLOT_CLOAK, TRUE)
		if("朱蓬")
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard/surcoat(H), SLOT_CLOAK, TRUE)

	var/arms_choice = input(H, "骑士精神尚未消亡。选择你的武器。", "执兵而起") as anything in list("弩", "弓", "投石索", "标枪与匕首")
	switch(arms_choice)
		if("弩")
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/bolts(H), SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
		if("弓")
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve(H), SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/bodkin(H), SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
		if("投石索")
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/sling(H), SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/sling/iron(H), SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/huntingknife(H), SLOT_IN_BACKPACK, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_EXPERT, TRUE)
		if("标枪与匕首")
			H.equip_to_slot_or_del(new /obj/item/quiver/javelin/iron(H), SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
