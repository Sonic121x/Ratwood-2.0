// MISSIONARY - big miracles and a staff

/datum/advclass/kj_chaplain
	name = "誓约传教士"
	tutorial = "多年来，你一直照看骑士的灵魂，沿途传道。路上总有人需要聆听你的教诲。布道者专注于营生与建设，而牧者则以身作则，保护那些可能成为信众的人。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/kj_chaplain
	category_tags = list(CTAG_KJ_CHAPLAIN)
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	traits_applied = list(TRAIT_EMPATH, TRAIT_RITUALIST, TRAIT_OUTLANDER)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,//just enough to reattach limbs, same as acolytes
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
		"十圣诗篇与圣行" = /obj/item/book/rogue/bibble,
		"普赛顿圣典" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "此子职业可施展费伦提亚境内最强大的神迹，代价是其他方面的能力有所欠缺。"

/datum/outfit/job/roguetown/adventurer/kj_chaplain
	allowed_patrons = ALL_PALADIN_PATRONS

/datum/outfit/job/roguetown/adventurer/kj_chaplain/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind?.current)
		H.mind.current.faction += "[H.name]_faction"
	// Grant bardic inspiration if Xylix is patron
	if(istype(H.patron, /datum/patron/divine/xylix))
		var/datum/inspiration/I = new /datum/inspiration(H)
		I.grant_inspiration(H, bard_tier = BARD_T2)
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/ritechalk = 1,
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			cloak = /obj/item/clothing/cloak/psydontabard
			head = /obj/item/clothing/head/roguetown/roguehood/psydon
		if(/datum/patron/divine/astrata)
			head = /obj/item/clothing/head/roguetown/roguehood/astrata
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
		if(/datum/patron/divine/noc)
			head =  /obj/item/clothing/head/roguetown/nochood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/noc
		if(/datum/patron/divine/abyssor)
			head = /obj/item/clothing/head/roguetown/roguehood/abyssor
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor
		if(/datum/patron/divine/dendor)
			head = /obj/item/clothing/head/roguetown/dendormask
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
		if(/datum/patron/divine/necra)
			head = /obj/item/clothing/head/roguetown/necrahood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/necra
		if (/datum/patron/divine/malum)
			head = /obj/item/clothing/head/roguetown/roguehood //placeholder
			cloak = /obj/item/clothing/cloak/templar/malumite
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/eora
			head = /obj/item/clothing/head/roguetown/eoramask
			beltl = /obj/item/rogueweapon/huntingknife/scissors
			backpack_contents[/obj/item/reagent_containers/eoran_seed] = 1
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		if (/datum/patron/divine/ravox)
			cloak = /obj/item/clothing/cloak/templar/ravox
			head = /obj/item/clothing/head/roguetown/roguehood
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/templar/xylix
			mask = /obj/item/clothing/mask/rogue/xylixmask
			if(HAS_TRAIT(H, TRAIT_PERMAMUTE))
				H.mind?.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall)
				H.mind?.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_chair)
		if (/datum/patron/divine/pestra)
			cloak = /obj/item/clothing/cloak/templar/pestra
			head = /obj/item/clothing/head/roguetown/roguehood
		else
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe //placeholder, anyone who doesn't have cool patron drip sprites just gets generic robes
			head = /obj/item/clothing/head/roguetown/roguehood
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3)//Only T4 NOT to start maxed, with a devotion cap.
	C.update_devotion(C.max_devotion / 4 - 50, C.max_devotion / 4 - 50, silent = TRUE) // Start at ~25% of devotion cap
	if(H.mind)
		var/weapons = list("布道者之路", "牧者之路")
		var/weapon_choice = input(H, "选择你的道路。", "选择你的修行") as anything in weapons
		switch(weapon_choice)
			if("布道者之路")//Discount homesteader. No trait so you can't level these skills up, nor do you have starting tools.
				r_hand = /obj/item/rogueweapon/woodstaff
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, 1, TRUE)//just so you can make pretty floors easier
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, 3, TRUE)
			if("牧者之路")//The "combat" variant. The core stat spread should keep this class from ever overshadowing the others, but it's worth keeping an eye out anyway.
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 3, TRUE)//Good luck fighting like a monk without monk stats or Dodge Expert.

	if(istype(H.patron, /datum/patron/divine))
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast)

	switch(H.patron?.type)
		if(/datum/patron/old_god)
			neck = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/psicross/xylix
			H.cmode_music = 'sound/music/combat_jester.ogg'

// STIGMATA - a psydonite pacifist who takes on wounds

/datum/advclass/kj_chaplain_stigmata
	name = "誓约圣痕者"
	tutorial = "普赛顿在哭泣。你的骑士替他人承受打击，而你替骑士承受伤痛。你不会因愤怒而举手伤人。你将受苦。你将坚忍。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/adventurer/kj_chaplain_stigmata
	category_tags = list(CTAG_KJ_CHAPLAIN)
	subclass_social_rank = SOCIAL_RANK_YEOMAN
	traits_applied = list(
		TRAIT_PACIFISM,
		TRAIT_EMPATH,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_BLOOD_RESISTANCE,
		TRAIT_STEELHEARTED,
		TRAIT_SELF_AWARE,
		TRAIT_OUTLANDER
	)
	subclass_stats = list(
		STATKEY_CON = 5,
		STATKEY_WIL = 3,
		STATKEY_SPD = 1,
		STATKEY_STR = -2,
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"普赛顿圣典" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "此子职业仅限普赛顿信徒；若尚未选择该信仰，将自动改信普赛顿。你将成为和平主义者，并能使用普赛顿赦罪师所掌握能力的较弱版本。"

/datum/outfit/job/roguetown/adventurer/kj_chaplain_stigmata
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/adventurer/kj_chaplain_stigmata/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_blindness(-3)
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	cloak = /obj/item/clothing/cloak/psydontabard
	head = /obj/item/clothing/head/roguetown/roguehood/psydon
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/storage/belt/rogue/pouch/medicine = 1
		)

	if (H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/psydonlux_tamper) // absolver's bleed transfer
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/psydonamend) // nerfed no-rez version of absolver's absolve

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = (CLERIC_REGEN_ABSOLVER / 2), start_maxed = TRUE)
