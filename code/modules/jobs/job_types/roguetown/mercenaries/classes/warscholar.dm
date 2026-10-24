/datum/advclass/mercenary/warscholar
	name = "纳莱迪 大司教"
	tutorial = "你是一名纳莱迪大祭司，在外人眼中是最正统的纳莱迪法师。你研习外导魔法，将魔力向外引导，用于毁灭或创造。许多同道坚信人类肉身的优越与潜能，倾向于从后方增强队友。也有人对如何击倒普赛顿之敌给出更直接的答案：焚烧与湮灭。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS

	outfit = /datum/outfit/job/roguetown/mercenary/warscholar
	subclass_languages = list(/datum/language/celestial)
	class_select_category = CLASS_CAT_NALEDI
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_WARMAGE)
	cmode_music = 'sound/music/warscholar.ogg'
	traits_applied = list(TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT, TRAIT_NALEDI, TRAIT_MAGEDEXTERITY)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_CON = -1
	)
	age_mod = /datum/class_age_mod/war_scholar
	virtue_restrictions = list(/datum/virtue/combat/tough_hide)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 2, "utilities" = 6, "post_aspect_spells" = list(/datum/action/cooldown/spell/mindlink, /datum/action/cooldown/spell/mending), "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/arcyne = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/warscholar
	var/detailcolor
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/mercenary/warscholar/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/naledicolors = sortList(list(
		"金色" = "#C8BE6D",
		"淡紫色" = "#9E93FF",
		"蓝色" = "#A7B4F6",
		"砖褐色" = "#773626",
		"紫色" = "#B542AC",
		"绿色" = "#62a85f",
		"浅蓝色" = "#A9BFE0",
		"红色" = "#ED6762",
		"橙色" = "#EDAF6D",
		"粉色" = "#EDC1D5",
		"栗色" = "#5F1F34",
		"黑色" = "#242526"
	))
	if(H.mind)
		detailcolor = input(H, "选择一种颜色。", "纳莱迪 配色") as anything in naledicolors
		detailcolor = naledicolors[detailcolor]
		H.mind.AddSpell(new /datum/action/cooldown/spell/ley_lines)
	r_hand = /obj/item/rogueweapon/woodstaff/implement/grand/naledi
	head = /obj/item/clothing/head/roguetown/roguehood/hierophant
	cloak = /obj/item/clothing/cloak/hierophant
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
	pants = /obj/item/clothing/under/roguetown/trou/leather
	mask = /obj/item/clothing/mask/rogue/lordmask/naledi
	wrists = /obj/item/clothing/neck/roguetown/psicross/naledi
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/flashlight/flare/torch
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backr = /obj/item/storage/backpack/rogue/satchel/black
	var/naledi_book = pick(/obj/item/book/rogue/naledi1, /obj/item/book/rogue/naledi2, /obj/item/book/rogue/naledi3, /obj/item/book/rogue/naledi4)
	backpack_contents = list(
		/obj/item/chalk = 1,
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/rogueweapon/spellbook/greater = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		(naledi_book) = 1
		)
	H.merctype = 14


/datum/advclass/mercenary/warscholar/pontifex
	name = "纳莱迪·教长"
	age_mod = /datum/class_age_mod/pontifex
	tutorial = "一位纳莱迪教宗，研习以内导奥术强化自身肉体的技艺。\
		拳头与意志是他人无法夺走的东西，在家乡遍布狡诈精怪与人类时格外有用。\
		拳头无法企及之处，由才智取胜；魔法力有不逮之时，以拳头回应。\
		若两者皆不足，纳莱迪的召刃术会赐你一柄拳剑，将恶魔与人类一并切成碎片。"
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/mercenary/warscholar_pontifex
	subclass_languages = list(/datum/language/celestial, /datum/language/thievescant)
	class_select_category = CLASS_CAT_NALEDI
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_WARMAGE)
	cmode_music = 'sound/music/warscholar.ogg'
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN, TRAIT_ARCYNE, TRAIT_NALEDI)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 3
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/arcyne = SKILL_LEVEL_EXPERT, // Bare-handed abilities no weapon and read AA. Match unarmed.
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 4, ward = TRUE, "locked_aspects" = list(/datum/magic_aspect/autowardry))

/datum/outfit/job/roguetown/mercenary/warscholar_pontifex
	var/detailcolor
	var/sidearm_selected
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/mercenary/warscholar_pontifex/Topic(href, href_list)
	. = ..()
	if(href_list["sidearm"])
		sidearm_selected = href_list["sidearm"]

/datum/outfit/job/roguetown/mercenary/warscholar_pontifex/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/naledicolors = sortList(list(
		"金色" = "#C8BE6D",
		"淡紫色" = "#9E93FF",
		"蓝色" = "#A7B4F6",
		"砖褐色" = "#773626",
		"紫色" = "#B542AC",
		"绿色" = "#62a85f",
		"浅蓝色" = "#A9BFE0",
		"红色" = "#ED6762",
		"橙色" = "#EDAF6D",
		"粉色" = "#EDC1D5",
		"栗色" = "#5F1F34",
		"黑色" = "#242526"
	))
	if(H.mind)
		detailcolor = input(H, "选择一种颜色。", "纳莱迪 配色") as anything in naledicolors
		detailcolor = naledicolors[detailcolor]
		H.mind.AddSpell(new /datum/action/cooldown/spell/fist_of_psydon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/grasp_of_psydon())
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/shadowstep)
		H.mind.AddSpell(new /datum/action/cooldown/spell/storm_of_psydon())
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/blade_of_psydon())
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.set_chant("unarmed")

	sidearm_selected = null
	var/chant_html = get_spellfist_chant_html(src, H)
	H << browse(chant_html, "window=spellfist_tutorial;size=650x700")
	onclose(H, "spellfist_tutorial", src)

	var/open_time = world.time
	while(!sidearm_selected && world.time - open_time < 5 MINUTES)
		stoplag(1)
	H << browse(null, "window=spellfist_tutorial")

	if(!sidearm_selected)
		sidearm_selected = "katar"

	switch(sidearm_selected)
		if("katar")
			H.put_in_hands(new /obj/item/rogueweapon/katar(H))
		if("knuckledusters")
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/knuckles(H))

	head = /obj/item/clothing/head/roguetown/roguehood/pontifex
	gloves = /obj/item/clothing/gloves/roguetown/angle/pontifex
	head = /obj/item/clothing/head/roguetown/roguehood/pontifex
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/pointfex
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex
	mask = /obj/item/clothing/mask/rogue/lordmask/naledi
	wrists = /obj/item/clothing/neck/roguetown/psicross/naledi
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/flashlight/flare/torch
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backr = /obj/item/storage/backpack/rogue/satchel/black
	var/naledi_book = pick(/obj/item/book/rogue/naledi1, /obj/item/book/rogue/naledi2, /obj/item/book/rogue/naledi3, /obj/item/book/rogue/naledi4)
	backpack_contents = list(
		/obj/item/chalk = 1,
		/obj/item/roguekey/mercenary = 1,
		/obj/item/lockpick = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		(naledi_book) = 1,
		/obj/item/rogueweapon/spellbook/greater = 1,
		)
	H.merctype = 14

/datum/advclass/mercenary/warscholar/vizier
	name = "纳莱迪维齐尔"
	tutorial = "你是一名纳莱迪维齐尔。对奇迹与神圣咒文的研究引你走入深奥魔法。普赛顿信徒长久以来都难以引导天父的神力，而纳莱迪大城凭借本源魔法，最接近这一目标。"
	outfit = /datum/outfit/job/roguetown/mercenary/warscholar_vizier
	traits_applied = list(TRAIT_ALCHEMY_EXPERT, TRAIT_NALEDI, TRAIT_MEDICINE_EXPERT, TRAIT_MAGEDEXTERITY, TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
	)
	virtue_restrictions = list(/datum/virtue/combat/tough_hide)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 6, "locked_aspects" = list(/datum/magic_aspect/lesser_augmentation), "ward" = TRUE)

/datum/outfit/job/roguetown/mercenary/warscholar_vizier
	var/detailcolor
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/mercenary/warscholar_vizier/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/naledicolors = sortList(list(
		"金色" = "#C8BE6D",
		"淡紫色" = "#9E93FF",
		"蓝色" = "#A7B4F6",
		"砖褐色" = "#773626",
		"紫色" = "#B542AC",
		"绿色" = "#62a85f",
		"浅蓝色" = "#A9BFE0",
		"红色" = "#ED6762",
		"橙色" = "#EDAF6D",
		"粉色" = "#EDC1D5",
		"栗色" = "#5F1F34",
		"黑色" = "#242526"
	))
	to_chat(H, span_warning("你是一名纳莱迪维齐尔。你对神迹与圣咒的研究将你引向了深奥的秘法。尽管普赛顿信徒长期以来难以引导其众父的神性，但纳莱迪大城凭借其原初魔法最接近达成这一成就。"))
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 3, TRUE)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)
	r_hand = /obj/item/rogueweapon/woodstaff/implement/grand/naledi
	//Since we lack unique Vizier clothing, we're mixing hierophant and pontifex for Vizier
	head = /obj/item/clothing/head/roguetown/roguehood/hierophant	//Keep this hood. It's middling armor, but the robe/gambeson combination is exceedingly good armor for the class. The vizier's head is a weak point.
	cloak = /obj/item/clothing/cloak/hierophant
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
	pants = /obj/item/clothing/under/roguetown/trou/leather
	mask = /obj/item/clothing/mask/rogue/lordmask/naledi
	wrists = /obj/item/clothing/neck/roguetown/psicross/naledi
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/flashlight/flare/torch
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backr = /obj/item/storage/backpack/rogue/satchel/black

	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.
	if(H.mind)
		detailcolor = input(H, "选择一种颜色。", "纳莱迪 配色") as anything in naledicolors
		detailcolor = naledicolors[detailcolor]
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/rimecast)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/regression)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convergence)	//increases heal effect,
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stasis)		//wound/injurying reversion, revive capable at a cost
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/acceleration)	//speedup with a cost
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/divergence)	//potential to heal and injure targets
		H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/psydonrespite)//Naledi Vizier spells functionally replace psydonite ones
		H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/check_boot)
		H.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/psydonendure)
	H.merctype = 14

/datum/outfit/job/roguetown/mercenary/warscholar/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	for(var/obj/item/clothing/V in H.get_equipped_items(FALSE))
		if(V.naledicolor)
			V.color = detailcolor
			V.update_icon()
	H.regenerate_icons()

/datum/outfit/job/roguetown/mercenary/warscholar_pontifex/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	for(var/obj/item/clothing/V in H.get_equipped_items(FALSE))
		if(V.naledicolor)
			V.color = detailcolor
			V.update_icon()
	H.regenerate_icons()

/datum/outfit/job/roguetown/mercenary/warscholar_vizier/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	for(var/obj/item/clothing/V in H.get_equipped_items(FALSE))
		if(V.naledicolor)
			V.color = detailcolor
			V.update_icon()
	H.regenerate_icons()
