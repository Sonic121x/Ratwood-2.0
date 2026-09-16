// spellblades spell.. archers and elves oh my
/datum/advclass/wretch/blackoakwyrm
	name = "黑橡弃徒"
	tutorial = "你怀抱着连黑橡都无法容忍的极端信念，因而与这个团体决裂。他们一波波地袭来。你的族人本是最初定居这片土地的人，如今你却眼见他们被怪物与外来者一同践踏。那个受外邦支持、虚伪而傲慢的王冠，拒绝给予你的族人理应辛勤收获的成果。你在黑橡所受的广泛训练，赋予了你精灵兵刃的技艺与奥术的敏锐。无论你是持刀明战，还是隐于树上以弓潜猎，王冠的悬赏都紧随于你，而那些曾是你同伴之人，也对你投以鄙弃的诅咒。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/human/halfelf,
		/datum/species/elf/wood,
		/datum/species/elf/dark,
	)
	outfit = /datum/outfit/job/roguetown/wretch/blackoak
	cmode_music = 'sound/music/combat_blackoak.ogg'
	class_select_category = CLASS_CAT_RACIAL
	maximum_possible_slots = 2
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
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
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

		var/weapons = list("精灵剑矛", "精灵弯刃", "精灵反曲弓")
		var/weapon_choice = input(H, "选择你的武器。", "可见的威胁") as anything in weapons
		H.set_blindness(0)
		if(weapon_choice == "精灵剑矛" || weapon_choice == "精灵弯刃") //stuff to be shared on the non ranger variants
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/conjure_weapon)
		switch(weapon_choice)
			if("精灵剑矛")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/spear/naginata/elf
			if("精灵弯刃")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/greatsword/elf
			if("精灵反曲弓")
				H.change_stat(STATKEY_PER, 2)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/longstrider)
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/blackoak
				beltl = /obj/item/quiver/arrows
				backpack_contents[/obj/item/rogueweapon/huntingknife/idagger/steel/elvish] = 1

		var/sidearm = list("精灵长剑", "精灵短剑", "精灵军刀", "精灵匕首")
		if(weapon_choice == "精灵反曲弓") //nuh uh uh
			sidearm -= "精灵长剑"
			sidearm -= "精灵短剑"
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
