// WOE: SPELLBLADE DODGE EXPERT POLEARM BUILD UPON YE.
/datum/advclass/wretch/blackoakwyrm
	name = "黑橡弃徒"
	tutorial = "你的信念激进到连黑橡也无法容忍，于是你决定脱离组织，也远离所有人。这片土地曾经伟大……如今却任由一波又一波的怪物和外来者践踏家园。你的族人才是最早定居这里的人，可那受异邦扶持、虚伪傲慢的王室却剥夺了你们应得的回报！黑橡的长期训练让你兼通剑术与魔法。你早已做出足以被组织公开谴责的事，王室的悬赏也随之而来——那些同伴受金钱诱惑，根本不愿为事业献身。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/human/halfelf,
		/datum/species/elf/wood,
		/datum/species/elf/dark,
	)
	outfit = /datum/outfit/job/roguetown/wretch/blackoak
	cmode_music = 'sound/music/combat_blackoak.ogg'
	maximum_possible_slots = 1
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_BLACKOAK, TRAIT_DODGEEXPERT, TRAIT_ARCYNE, TRAIT_WOODWALKER, TRAIT_EXPERT_HUNTER)
	//lower-than-avg stats for wretch but their traits are insanely good
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = 2, // 7 Weight instead of 9 full weight
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT, //Why the fuck did the treeclimber role have worse skills than THE KNIGHTS?
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
		"缝纫套件" =	/obj/item/repair_kit,
		"藏匿的资金" = /obj/item/roguecoin/silver/pile/wretchpile,
	)
	extra_context = "该子职业的种族限制为：半精灵、精灵、黑暗精灵。"


/datum/outfit/job/roguetown/wretch/blackoak
	var/subclass_selected

/datum/outfit/job/roguetown/wretch/blackoak/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/wretch/blackoak/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/elven
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel/black
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hatanga
	pants = /obj/item/clothing/under/roguetown/trou/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/elvish
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
		)

	to_chat(H, span_warning("你初始拥有武器绑定。记得绑定武器，才能使用你的能力并积累奥术动量。"))

	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "blackoak")
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

	var/helmets = list(
		"林纹精灵巴尔布特盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/light,
		"精灵巴尔布特盔"				= /obj/item/clothing/head/roguetown/helmet/elvenbarbute/blackoak,
		"翼饰精灵巴尔布特盔"		= /obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged/blackoak,
	)
	var/helmchoice = input(H, "选择你的头盔。", "绿叶胜过钢铁。") as anything in helmets
	head = helmets[helmchoice]

	switch(subclass_selected)
		if("blade")
			var/weapons = list("精灵长剑", "精灵军刀", "精灵曲刃剑", "精灵短刃")
			var/weapon_choice = input(H, "选择你的武器。", "为了橡木与群峰。") as anything in weapons
			switch(weapon_choice)
				if("精灵长剑")
					r_hand = /obj/item/rogueweapon/sword/long/elf
					beltr = /obj/item/rogueweapon/scabbard/sword
					backr = /obj/item/rogueweapon/shield/wood
				if("精灵军刀")
					r_hand = /obj/item/rogueweapon/sword/sabre/elf
					beltr = /obj/item/rogueweapon/scabbard/sword
					backr = /obj/item/rogueweapon/shield/wood
				if("精灵曲刃剑")
					r_hand = /obj/item/rogueweapon/greatsword/elvish
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("精灵短刃")
					r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/elvish
					backr = /obj/item/rogueweapon/shield/wood
			if(weapon_choice == "精灵短刃")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("phalangite")
			r_hand = /obj/item/rogueweapon/spear/naginata/elf
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("macebearer")
			backr = /obj/item/rogueweapon/shield/wood
			var/mace_weapons = list("钢钉头锤", "钢战锤", "巨型钉头锤", "战斧", "钢巨斧")
			var/mace_choice = input(H, "选择你的武器。", "为了橡木与群峰。") as anything in mace_weapons
			var/picked_axe = FALSE
			switch(mace_choice)
				if("钢钉头锤")
					r_hand = /obj/item/rogueweapon/mace/steel
				if("钢战锤")
					r_hand = /obj/item/rogueweapon/mace/warhammer/steel
				if("巨型钉头锤")
					r_hand = /obj/item/rogueweapon/mace/goden/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("战斧")
					r_hand = /obj/item/rogueweapon/stoneaxe/battle
					picked_axe = TRUE
				if("钢巨斧")
					r_hand = /obj/item/rogueweapon/greataxe/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
					picked_axe = TRUE
			if(picked_axe)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)

	wretch_select_bounty(H)
