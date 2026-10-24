/datum/advclass/mage
	name = "术士"
	tutorial = "你是一名博学的法师与学者，毕生都在钻研奥术及其门径。"
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/adventurer/mage
	class_select_category = CLASS_CAT_MAGE
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE
	traits_applied = list(TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT, TRAIT_MAGEDEXTERITY)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
	)
	age_mod = /datum/class_age_mod/adv_mage
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 2, "utilities" = 6, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/mage/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一名博学的法师与学者，毕生都在钻研奥术及其门径。"))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mage
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/magebag
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/huntingknife
	backl = /obj/item/storage/backpack/rogue/satchel
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	if(H.mind)
		backr = choose_implement(H, "lesser")
		backpack_contents = list(
			/obj/item/rogueweapon/spellbook = 1,
			/obj/item/chalk = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/manapot = 1
			)
	backpack_contents |= list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)
	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander4.ogg'
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/mage/spellblade
	name = "魔剑士"
	tutorial = "你同时擅长奥术与剑技，但无论哪一门都算不上宗师，更无法穿着甲胄引导魔力。"
	outfit = /datum/outfit/job/roguetown/adventurer/spellblade
	traits_applied = list(TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/spellblade/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/bucklehat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/chalk = 1, /obj/item/rogueweapon/spellbook = 1)

	to_chat(H, span_warning("你初始拥有武器绑定。记得绑定武器，才能使用你的能力并积累奥术动量。"))

	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "conventional")
	H << browse(selection_html, "window=spellblade_chant;size=1100x900")
	onclose(H, "spellblade_chant", src)

	var/open_time = world.time
	while(!subclass_selected && world.time - open_time < 5 MINUTES)
		stoplag(1)
	H << browse(null, "window=spellblade_chant")

	if(!subclass_selected)
		subclass_selected = "blade"

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.chant = subclass_selected

	if(H.mind)
		switch(subclass_selected)
			if("blade")
				H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
				H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
				H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/blade_storm)
			if("phalangite")
				H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
				H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
				H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
			if("macebearer")
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter)
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
				H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)

		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	backr = /obj/item/rogueweapon/shield/wood

	switch(subclass_selected)
		if("blade")
			var/weapons = list("长剑", "细剑", "军刀", "铁制武装剑", "短剑", "环刀", "钢匕首")
			var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
			beltr = /obj/item/rogueweapon/scabbard/sword
			switch(weapon_choice)
				if("长剑")
					r_hand = /obj/item/rogueweapon/sword/long
				if("细剑")
					r_hand = /obj/item/rogueweapon/sword/rapier
				if("军刀")
					r_hand = /obj/item/rogueweapon/sword/sabre
				if("铁制武装剑")
					r_hand = /obj/item/rogueweapon/sword/iron
				if("短剑")
					r_hand = /obj/item/rogueweapon/sword/short
				if("环刀")
					r_hand = /obj/item/rogueweapon/sword/sabre/mulyeog
					armor = /obj/item/clothing/suit/roguetown/armor/basiceast
					gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
					pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
					head = /obj/item/clothing/head/roguetown/mentorhat
					backr = null
					beltr = /obj/item/rogueweapon/scabbard/sword/kazengun
				if("钢匕首")
					beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
			if(weapon_choice == "钢匕首")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("phalangite")
			var/spear_weapons = list("长矛", "多利短矛", "薙刀")
			var/spear_choice = input(H, "选择你的武器。", "拿起武器") as anything in spear_weapons
			switch(spear_choice)
				if("长矛")
					r_hand = /obj/item/rogueweapon/spear
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("多利短矛")
					r_hand = /obj/item/rogueweapon/spear/spellblade
				if("薙刀")
					r_hand = /obj/item/rogueweapon/spear/naginata
					backr = /obj/item/rogueweapon/scabbard/gwstrap
					armor = /obj/item/clothing/suit/roguetown/armor/basiceast
					gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
					pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
					head = /obj/item/clothing/head/roguetown/mentorhat
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
		if("macebearer")
			var/mace_weapons = list("钉头锤", "战锤", "晨安棍", "铁斧", "巨斧")
			var/mace_choice = input(H, "选择你的武器。", "拿起武器") as anything in mace_weapons
			var/picked_axe = FALSE
			switch(mace_choice)
				if("钉头锤")
					r_hand = /obj/item/rogueweapon/mace
				if("战锤")
					r_hand = /obj/item/rogueweapon/mace/warhammer
				if("晨安棍")
					r_hand = /obj/item/rogueweapon/mace/goden
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("铁斧")
					r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
					picked_axe = TRUE
				if("巨斧")
					r_hand = /obj/item/rogueweapon/greataxe
					backr = /obj/item/rogueweapon/scabbard/gwstrap
					picked_axe = TRUE
			if(picked_axe)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)

	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/mage/spellsinger
	name = "咒歌者"
	tutorial = "你出身于一个以同时钻研奥术与艺道而闻名的吟游学派。"
	outfit = /datum/outfit/job/roguetown/adventurer/spellsinger
	traits_applied = list(TRAIT_ARCYNE, TRAIT_EMPATH, TRAIT_GOODLOVER)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
	)
	// TODO // FULL ON REWORK Bard.
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 6)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)
/datum/outfit/job/roguetown/adventurer/spellsinger/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你出身于一个以同时钻研奥术与艺道而闻名的吟游学派。"))
	head = /obj/item/clothing/head/roguetown/spellcasterhat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/sabre
	backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/chalk = 1, /obj/item/rogueweapon/spellbook = 1)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T1)
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/vicious_mockery)
		H.mind.AddSpell(new /datum/action/cooldown/spell/arcyne_forge)
		H.mind.AddSpell(new /datum/action/cooldown/spell/conjure_instrument)
		grant_poke_spell(H)

	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/mage/spellthief
	name = "奥术诡术师"
	tutorial = "你是一名奥术诡术师，一个拥有奥术天赋的盗贼与恶棍。"
	outfit = /datum/outfit/job/roguetown/adventurer/spellthief
	subclass_languages = list(/datum/language/thievescant)
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	traits_applied = list(TRAIT_ARCYNE)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 6)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/spellthief/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一名奥术诡术师，一个拥有奥术天赋的盗贼与恶棍。"))
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/scabbard/sheath
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/chalk = 1, /obj/item/rogueweapon/spellbook = 1)

	// This just changes your starting cantrips and if you wear snazzy blue or edgy black.
	var/origin = input(H, "成为奥术盗贼，还是法师恶棍？", "出身") as anything in list("奥术盗贼（以太匕首）", "法师恶棍（法师之砖）")
	if(origin == "奥术盗贼（以太匕首）")
		head = /obj/item/clothing/head/roguetown/headband/monk/barbarian
		wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/gladiator
		cloak = /obj/item/clothing/cloak/raincloak/mortus
		if(H.mind)
			H.mind.AddSpell(new /datum/action/cooldown/spell/aetherknife)
			H.mind.AddSpell(new /datum/action/cooldown/spell/lesser_knock)
	else
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
		if(H.mind)
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/waterbolt)
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/blink)

/datum/outfit/job/roguetown/adventurer/spellblade
	var/subclass_selected

/datum/outfit/job/roguetown/adventurer/spellblade/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"
