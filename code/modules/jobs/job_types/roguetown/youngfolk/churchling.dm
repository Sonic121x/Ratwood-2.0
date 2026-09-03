/datum/job/roguetown/churchling
	title = "Churchling"
	display_title = "教会学徒"
	flag = CHURCHLING
	department_flag = YOUNGFOLK
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_races = ACCEPTED_RACES
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)

	tutorial = "你的家人都是狂热信徒。不下地干活的每一个清醒时辰，他们都像罪人般不停祈祷，还会拿钉饰皮带抽打你训诫。你靠着成为教会学徒才逃离了他们，而有份稳妥的教育，其实也不算坏。"

	outfit = /datum/outfit/job/roguetown/churchling
	display_order = JDO_CHURCHLING
	give_bank_account = TRUE
	min_pq = -10
	max_pq = null
	round_contrib_points = 2
	advjob_examine = TRUE
	social_rank = SOCIAL_RANK_PEASANT

	//You've given up your life for the Church. Why would you be noble?
	virtue_restrictions = list(/datum/virtue/utility/noble)

	advclass_cat_rolls = list(CTAG_CHURCHLING = 20)
	job_subclasses = list(
		/datum/advclass/churchling,
		/datum/advclass/churchling/neophyte,
	)

/datum/advclass/churchling
	name = "教会学徒"
	tutorial = "你的家人都是狂热信徒。不下地干活的每一个清醒时辰，他们都像罪人般不停祈祷，还会拿钉饰皮带抽打你训诫。你靠着成为教会学徒才逃离了他们，而有份稳妥的教育，其实也不算坏。"
	outfit = /datum/outfit/job/roguetown/churchling/basic
	cmode_music = 'sound/music/combat_holy.ogg'
	category_tags = list(CTAG_CHURCHLING)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/churchling/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	neck = /obj/item/clothing/neck/roguetown/psicross
	if(should_wear_femme_clothes(H))
		head = /obj/item/clothing/head/roguetown/armingcap
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/robe
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights
	belt = /obj/item/storage/belt/rogue/leather/rope
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	beltl = /obj/item/storage/keyring/churchie

/datum/outfit/job/roguetown/churchling/basic/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if (H && H.mind)
		_delayed_path_choice(H)

/datum/outfit/job/roguetown/churchling/basic/proc/_delayed_path_choice(mob/living/carbon/human/H)
	if(!H || !H.client || !H.mind)
		return

	var/choice = alert(H, "选择你的道路。", "学徒教义", "守旧派", "激进派")

	if(choice == "激进派")
		grant_radical_path(H)
	else
		grant_old_path(H)

/datum/outfit/job/roguetown/churchling/basic/proc/grant_old_path(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.patron)
		return

	REMOVE_TRAIT(H, TRAIT_CLERGYRADICAL, "job")
	H.reset_clergy_devotion(CLERIC_T2, CLERIC_REGEN_DEVOTEE, FALSE, CLERIC_REQ_2)
	to_chat(H, span_notice("我仍旧走在旧日的虔信之路上。"))

/datum/outfit/job/roguetown/churchling/basic/proc/grant_radical_path(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.patron)
		return

	ADD_TRAIT(H, TRAIT_CLERGYRADICAL, "job")
	H.church_favor += 1200
	H.reset_clergy_devotion(CLERIC_T2, CLERIC_REGEN_DEVOTEE, FALSE, CLERIC_REQ_2)
	to_chat(H, span_notice("我拥抱激进之路。"))

/datum/advclass/churchling/neophyte
	name = "初信者"
	tutorial = "你是一名受训中的圣殿骑士，是教会未来的圣战士——你要学的还有很多，要证明的则更多。你得到了一些教会武库传下来的旧装备，以及所选神祇最基本的祝福。"
	outfit = /datum/outfit/job/roguetown/churchling/neophyte
	category_tags = list(CTAG_CHURCHLING)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_SQUIRE_REPAIR)
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
	)
	allowed_patrons = list(
		/datum/patron/divine/astrata,
		/datum/patron/divine/noc,
		/datum/patron/divine/abyssor,
		/datum/patron/divine/dendor,
		/datum/patron/divine/necra,
		/datum/patron/divine/malum,
		/datum/patron/divine/eora,
		/datum/patron/divine/ravox,
		/datum/patron/divine/xylix,
		/datum/patron/divine/pestra
	)
	extra_context = "仅限十神信徒，且没有圣殿骑士通常获得的神祇专属加成。拥有你所选主神的一阶神迹（仅限忠诚派），并在以下一项中获得熟练级战斗技能：剑（及盾）、锤、鞭/链枷、长柄武器和斧。"

/datum/outfit/job/roguetown/churchling/neophyte/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_blindness(-3)
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/keyring/churchie
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	head = /obj/item/clothing/head/roguetown/helmet/leather/armorhood
	backpack_contents = list(
		/obj/item/rogueweapon/hammer/wood = 1,
		/obj/item/needle = 1

	)
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			cloak = /obj/item/clothing/cloak/templar/astrata
			wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
		if(/datum/patron/divine/noc)
			cloak = /obj/item/clothing/cloak/templar/noc
			wrists = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			cloak = /obj/item/clothing/cloak/abyssortabard
			wrists = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			cloak = /obj/item/clothing/cloak/templar/dendor
			wrists = /obj/item/clothing/neck/roguetown/psicross/dendor
		if(/datum/patron/divine/necra)
			cloak = /obj/item/clothing/cloak/templar/necra
			wrists = /obj/item/clothing/neck/roguetown/psicross/necra
		if (/datum/patron/divine/malum)
			cloak = /obj/item/clothing/cloak/templar/malum
			wrists = /obj/item/clothing/neck/roguetown/psicross/malum
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/cloak/templar/eora
			wrists = /obj/item/clothing/neck/roguetown/psicross/eora
		if (/datum/patron/divine/ravox)
			cloak = /obj/item/clothing/cloak/cleric/ravox
			wrists = /obj/item/clothing/neck/roguetown/psicross/ravox
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/templar/xylix
			wrists = /obj/item/clothing/neck/roguetown/psicross/xylix
		if (/datum/patron/divine/pestra)
			cloak = /obj/item/clothing/cloak/templar/pestra
			wrists = /obj/item/clothing/neck/roguetown/psicross/pestra

	var/weapons = list("长剑","锤","链枷","鞭","矛","斧")
	var/weapon_choice = input(H, "选择你的武器。", "执起你神祇的兵刃。") as anything in weapons
	switch(weapon_choice)
		if("长剑")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			beltr = /obj/item/rogueweapon/sword/long
			r_hand = /obj/item/rogueweapon/scabbard/sword
		if("锤")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
			beltr = /obj/item/rogueweapon/mace
		if("链枷")
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
			beltr = /obj/item/rogueweapon/flail
		if("鞭")
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
			beltr = /obj/item/rogueweapon/whip
		if("矛")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			r_hand = /obj/item/rogueweapon/spear
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			beltr = /obj/item/rogueweapon/shield/buckler
		if("斧")
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
	H.set_blindness(0)

/datum/outfit/job/roguetown/churchling/neophyte/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.reset_clergy_devotion(CLERIC_T1, CLERIC_REGEN_DEVOTEE, FALSE, CLERIC_REQ_1)
