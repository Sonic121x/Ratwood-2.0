// WOE: SPELLBLADE DODGE EXPERT POLEARM BUILD UPON YE.
/datum/advclass/wretch/blackoakwyrm
	name = "黑橡 弃徒"
	tutorial = "你怀抱着连 黑橡 都无法容忍的极端信念，于是决定背离这个团体，也背离所有其他人。这片土地曾经伟大……而如今，一波又一波的怪物与外来者正践踏着你的家园。最初在这片土地上定居的是你们的族人，可那个受外邦支持、虚伪又傲慢的王冠却拒绝给予你们应得的报偿！你在 黑橡 中接受过广泛训练，精通长柄武器与魔法。王冠的悬赏一路跟随着你，因为你早已做下足够多的事，正式被那些受金钱诱惑、对大业不够忠诚的人判为有罪。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/human/halfelf,
		/datum/species/elf/wood,
		/datum/species/elf/dark,
	)
	outfit = /datum/outfit/job/roguetown/wretch/blackoak
	cmode_music = 'sound/music/combat_blackoak.ogg'
	class_select_category = CLASS_CAT_RACIAL
	maximum_possible_slots = 1
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_BLACKOAK, TRAIT_DODGEEXPERT, TRAIT_ARCYNE_T2, TRAIT_WOODWALKER)
	//lower-than-avg stats for wretch but their traits are insanely good
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_spellpoints = 10
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"针线包" = /obj/item/repair_kit,
	)
	extra_context = "该子职业的种族限制为：半精灵、精灵、黑暗精灵。"

/datum/outfit/job/roguetown/wretch/blackoak/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(-3)
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel/black
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hatanga
	pants = /obj/item/clothing/under/roguetown/trou/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/elven
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/elvish
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
				/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1,
				/obj/item/flashlight/flare/torch
				)

	if(H.mind)
		wretch_select_bounty(H)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/darkvision)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/conjure_weapon)

		var/weapons = list("精灵剑矛", "精灵弯刃",)
		var/weapon_choice = input(H, "选择你的武器。", "可见的威胁") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("精灵剑矛")
				r_hand = /obj/item/rogueweapon/spear/naginata/elf
			if("精灵弯刃")
				r_hand = /obj/item/rogueweapon/greatsword/elf

		var/sidearm = list("精灵长剑", "精灵短剑", "精灵军刀", "精灵匕首")
		var/sidearm_choice = input(H, "选择你的副手武器。", "隐藏之刺") as anything in sidearm
		switch(sidearm_choice)
			if("精灵长剑") // It's a sharper longsword.
				l_hand = /obj/item/rogueweapon/sword/long/elf
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
			if("精灵短剑") // Lower damage but better at parrying than saber. High sharpness & integrity for parrying without as much damage decay.
				l_hand = /obj/item/rogueweapon/sword/short/elf
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
			if("精灵军刀") // The damage & dodge option.
				l_hand = /obj/item/rogueweapon/sword/sabre/elf
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
			if("精灵匕首") // Doesn't function as silver unless blessed. Shouldn't be too bad to give 'em.
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath, SLOT_BELT_R, TRUE)

		var/helmets = list(
			"靛纹精灵巴布塔盔" = /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/light,
			"精灵巴布塔盔"	= /obj/item/clothing/head/roguetown/helmet/elvenbarbute/blackoak,
			"翼纹精灵巴布塔盔" = /obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged/blackoak,
		)
		var/helmchoice = input(H, "选择你的头盔。", "执盔") as anything in helmets
		head = helmets[helmchoice]

