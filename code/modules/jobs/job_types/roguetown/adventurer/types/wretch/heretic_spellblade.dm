// Heretic Spellblade — wretch spellblade variant open to Noc and Zizo.
// Medium armor + T1 caster (healing/profane) instead of dodge expert.
// Your miracle is MEANT to suck - your main ability is having
// Medium armor + better stats than regular Slade + Spellblade abilities
// And lesser heal is a bonus on top
// Keep it thematically consistent - Only Patron lock Noc / Zizo
// Don't let any other patrons have it
/datum/advclass/wretch/heretic_spellblade
	name = "异端战法师"
	tutorial = "你因非正统的信仰被打上异端烙印，转而钻研一门战斗法师固有的古老技艺。你将守护神的恩赐与武艺修行融为一体，把自己锻造成前所未有的战士兼法师。与其他战法师不同，你懂得如何将这股可怖的力量与护甲并用。教会称你为异端，死灵法师骂你蠢货，黑橡只看见离经叛道。随他们去。一刀又一刀，你终将在这个世界上刻下自己的印记。"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/wretch/heretic_spellblade
	maximum_possible_slots = 2 // Team rocket!!!
	class_select_category = CLASS_CAT_MAGE
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 1, // Weighted 7. But a very nice statblock
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 2, // With 2 Wil they should not be struggling
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 8) // Mama Zizo said you get 2 more points on Utility!!!
	subclass_skills = list(
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE, // Welcome to bad holy skills scaling
	)
	subclass_stashed_items = list(
		"护甲板" = /obj/item/repair_kit/metal,
	)

/datum/outfit/job/roguetown/wretch/heretic_spellblade
	var/tmp/eastern = FALSE // alt outfit for naginata + discretion
	var/tmp/subclass_selected = null

// Catch the UI button click to set the chosen stance
/datum/outfit/job/roguetown/wretch/heretic_spellblade/Topic(href, href_list)
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
		return TRUE
	return ..()

/datum/outfit/job/roguetown/wretch/heretic_spellblade/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/roguehood
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/chain
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	backpack_contents = list(/obj/item/flashlight/flare/torch = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/chalk = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
	)

	to_chat(H, span_warning("你已掌握束缚武器。记得束缚你的武器，这样才能使用你的能力并积攒奥术动量。"))

	// Determine faction and patron-specific weapon for chant display
	var/chant_faction = "zizite"
	var/extra_blade_weapon
	if(istype(H.patron, /datum/patron/inhumen/zizo))
		extra_blade_weapon = "阿凡泰因单手剑"
	else if(istype(H.patron, /datum/patron/divine/noc))
		chant_faction = "noccite"

	// Trigger the UI window and wait for the player to select a stance
	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, chant_faction, extra_blade_weapon)
	H << browse(selection_html, "window=spellblade_chant;size=1100x900")
	onclose(H, "spellblade_chant", src)

	var/open_time = world.time
	while(!subclass_selected && world.time - open_time < 5 MINUTES)
		stoplag(1)
	H << browse(null, "window=spellblade_chant")

	if(!subclass_selected)
		subclass_selected = "blade" // Default if they go AFK

	var/spellblade_chant_selected = subclass_selected

	// Apply Arcyne Momentum buff and assign subclass abilities
	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.chant = spellblade_chant_selected

	if(H.mind)
		switch(spellblade_chant_selected)
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

	// used to handle skill assignment automatically
	var/obj/item/rogueweapon/granted_weapon = null
	backr = /obj/item/rogueweapon/shield/heater
	switch(spellblade_chant_selected)
		if("blade")
			var/list/weapons = list("战刀", "长剑", "刺剑", "军刀", "钢制单手剑", "钢制巨剑", "钢匕首")
			// Inject patron-specific weapon
			if(istype(H.patron, /datum/patron/inhumen/zizo))
				weapons.Insert(1, "阿凡泰因单手剑")
			var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
			beltr = /obj/item/rogueweapon/scabbard/sword
			switch(weapon_choice)
				if("阿凡泰因单手剑")
					r_hand = granted_weapon = /obj/item/rogueweapon/sword/arming/zizo
				if("战刀")
					r_hand = granted_weapon = /obj/item/rogueweapon/sword/long/kriegmesser
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("长剑")
					r_hand = granted_weapon = /obj/item/rogueweapon/sword/long
				if("刺剑")
					r_hand = granted_weapon = /obj/item/rogueweapon/sword/rapier
				if("军刀")
					r_hand = granted_weapon = /obj/item/rogueweapon/sword/sabre
				if("钢制单手剑")
					r_hand = granted_weapon = /obj/item/rogueweapon/sword
				if("钢制巨剑")
					r_hand = granted_weapon = /obj/item/rogueweapon/greatsword
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("钢匕首")
					beltr = granted_weapon = /obj/item/rogueweapon/huntingknife/idagger/steel
		if("phalangite")
			var/polearm_weapons = list("长戟", "长柄战斧", "猎猪矛", "多利短矛", "薙刀", "阿凡泰因钩镰")
			var/polearm_choice = input(H, "选择你的武器。", "执兵而起") as anything in polearm_weapons
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			switch(polearm_choice)
				if("长戟")
					r_hand = granted_weapon = /obj/item/rogueweapon/halberd
				if("长柄战斧")
					r_hand = granted_weapon = /obj/item/rogueweapon/halberd/bardiche
				if("猎猪矛")
					r_hand = granted_weapon = /obj/item/rogueweapon/spear/boar
				if("多利短矛")
					r_hand = granted_weapon = /obj/item/rogueweapon/spear/spellblade
					backr = /obj/item/rogueweapon/shield/heater
				if("薙刀")
					r_hand = granted_weapon = /obj/item/rogueweapon/spear/naginata
					eastern = TRUE
				if("阿凡泰因钩镰")
					r_hand = granted_weapon = /obj/item/rogueweapon/spear/billhook/zizo
		if("macebearer")
			var/mace_weapons = list("钢钉头锤", "钢战锤", "巨型钉头锤", "战斧", "钢巨斧")
			var/mace_choice = input(H, "选择你的武器。", "执兵而起") as anything in mace_weapons
			switch(mace_choice)
				if("钢钉头锤")
					r_hand = granted_weapon = /obj/item/rogueweapon/mace/steel
				if("钢战锤")
					r_hand = granted_weapon = /obj/item/rogueweapon/mace/warhammer/steel
				if("巨型钉头锤")
					r_hand = granted_weapon = /obj/item/rogueweapon/mace/goden/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("战斧")
					r_hand = granted_weapon = /obj/item/rogueweapon/stoneaxe/battle
				if("钢巨斧")
					r_hand = granted_weapon = /obj/item/rogueweapon/greataxe/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
	if(granted_weapon)
		H.adjust_skillrank_up_to(granted_weapon::associated_skill, SKILL_LEVEL_EXPERT, TRUE)

	// Armor choice: Discretion (light, like adventurer) vs Progress (medium armor set with helmet)
	var/armor_style = list("隐匿（战法师伪装）", "对抗（中甲）")
	var/armor_choice = input(H, "选择你的军备理念。", "光明自会照透") as anything in armor_style
	switch(armor_choice)
		if("隐匿（战法师伪装）")
			head = /obj/item/clothing/head/roguetown/roguehood
			if(eastern)
				armor = /obj/item/clothing/suit/roguetown/armor/basiceast
			else
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
		if("对抗（中甲）")
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
			pants = /obj/item/clothing/under/roguetown/chainlegs
			shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron

			var/helmets = list(
				"猪面盔"              = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
				"守卫盔"              = /obj/item/clothing/head/roguetown/helmet/heavy/guard,
				"桶盔"                = /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
				"骑士盔"              = /obj/item/clothing/head/roguetown/helmet/heavy/knight,
				"阿梅特盔"            = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
				"尖吻阿梅特盔"        = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/snouted,
				"带面甲轻盔"          = /obj/item/clothing/head/roguetown/helmet/sallet/visored,
				"尖吻带面甲轻盔"      = /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted,
				"翻面甲巴尔布特盔"    = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
				"猎犬头骨巴尔布特盔"  = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
				"开缝锅盔"            = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
				"沃尔夫头骨盆盔"      = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
				"无"
			)
			var/helmchoice = input(H, "选择你的头盔。", "光明自会照透") as anything in helmets
			if(helmchoice != "无")
				head = helmets[helmchoice]

	// Patron-specific bonuses
	H.cmode_music = 'sound/music/combat_heretic.ogg'
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.grant_language(/datum/language/undead)
			ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
			H.equip_to_slot_or_del(new /obj/item/book/rogue/bibble/zizo,SLOT_IN_BACKPACK, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen, SLOT_RING, TRUE)
		if(/datum/patron/divine/noc)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/noc(H), SLOT_RING, TRUE)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1, start_maxed = TRUE)
	//Minor regen, T1 only. Cannot progress beyond that (hah). Mostly for self healing.
	wretch_select_bounty(H)
