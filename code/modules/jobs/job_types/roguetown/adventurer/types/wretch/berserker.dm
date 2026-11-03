/datum/advclass/wretch/berserker
	name = "狂战士"
	tutorial = "你是因残暴而令人畏惧的战士，执意将自己的力量用于满足私欲。强权即公理，而你便是这句老话的活生生写照。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_BUT_BLOODLESS
	outfit = /datum/outfit/job/roguetown/wretch/berserker
	cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_STRONGBITE, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_NOPAINSTUN, TRAIT_RAGE)
	maximum_possible_slots = 2 //Obligatory people-pleasing slot limitation. Master skills is scawwy. 
	// Literally same stat spread as Atgervi Shaman
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_INT = -2,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
		"缝纫工具包" = /obj/item/repair_kit,
	)
	virtue_restrictions = list(
		/datum/virtue/combat/tough_hide,
	)
/datum/outfit/job/roguetown/wretch/berserker/pre_equip(mob/living/carbon/human/H)
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/combat = 1, //Steel variant of the hunting knife. Pseudoantagonist-tier, plus an avenue to hack limbs with.
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	if(H.mind)
		H.set_blindness(0)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/rage)
		var/list/armor_choices = list("轻甲", "不摧之肤")
		var/armor_choice = input(H,"选择你的防御。", "我扛得住！！") as anything in armor_choices
		switch(armor_choice)
			if("轻甲")
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
				ADD_TRAIT(H, TRAIT_BLOOD_RESISTANCE, TRAIT_GENERIC)
			if("不摧之肤")
				armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/chest/berzerker
				shirt = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/berzerker
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
		var/list/main_choices = list("徒手大师", "武艺专家") // Unarmed focuses on master punching and wrestling moves, Martial gives you two expert weapon skills to be flexible
		var/category_choice = input(H, "选择你的施暴手段。", "砸碎还是劈开！！") as anything in main_choices
		switch(category_choice)
			if("徒手大师")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist // apperantly normal barb gets em so for consistency sake
				var/list/unarmed_options = list("拳刃", "指虎", "拳刺", "只用拳头，永不用武器")
				var/weapon_choice = input(H, "选择你的出拳方式！", "打断他们的骨头。") as anything in unarmed_options
				switch(weapon_choice)
					if("拳刃")
						beltr = /obj/item/rogueweapon/katar
					if("指虎")
						beltr = /obj/item/clothing/gloves/roguetown/knuckles
					if("拳刺")
						beltr = /obj/item/rogueweapon/katar/punchdagger
					if("只用拳头，永不用武器")
						H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_MASTER, TRUE)
						ADD_TRAIT(H, TRAIT_WEAPONLESS, TRAIT_GENERIC)
						H.change_stat(STATKEY_INT, 2)//no stat malus for pure unarmed
						H.change_stat(STATKEY_WIL, 1)//nice little bonus for our fist only chuds
						H.change_stat(STATKEY_CON, 1)
						if(armor_choice == "不摧之肤")
							ADD_TRAIT(H, TRAIT_BLOOD_RESISTANCE, TRAIT_GENERIC)//you'll need it if you're going pure unarmed.
				var/techniques = list("腾空飞踢 - 击退与额外伤害", "锁喉摔 - 体力伤害", "碎颚摔 - 眩晕减益", "头槌 - 易伤减益") // cool wrestling moves
				var/technique_choice = input(H,"选择你的技法。", "把他们摔出去。") as anything in techniques
				switch(technique_choice)
					if("腾空飞踢 - 击退与额外伤害")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
					if("锁喉摔 - 体力伤害")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
					if("碎颚摔 - 眩晕减益")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
					if("头槌 - 易伤减益")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)
			if("武艺专家") // designed to compete with unarmed by giving you alternatives to approaching fights- only expert
				var/list/martial_options = list("巨剑", "铁块", "战斧", "巨型钉锤", "巨型重槌，需 15 力量", "阔剑")
				var/weapon_choice = input(H, "选择你的战争武器！", "让他们的肠子流出来。") as anything in martial_options
				switch(weapon_choice)
					if("巨剑")
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
						r_hand = /obj/item/rogueweapon/greatsword/ancient
						backl = /obj/item/rogueweapon/scabbard/gwstrap
					if("铁块") //Actually not a meme anymore
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
						r_hand = /obj/item/rogueweapon/sword/long/exe/berserk //not as strong as people think
					if("战斧")
						H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
						beltr = /obj/item/rogueweapon/stoneaxe/battle
					if("巨型钉锤")
						H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
						r_hand = /obj/item/rogueweapon/mace/goden/steel
						backl = /obj/item/rogueweapon/scabbard/gwstrap
					if("巨型重槌，需 15 力量")
						H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
						r_hand = /obj/item/rogueweapon/mace/maul/grand
						backl = /obj/item/rogueweapon/scabbard/gwstrap
					if("阔剑") //Swapped out the falx for this, it's a primary weapon afterall
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
						beltr = /obj/item/rogueweapon/scabbard/sword
						r_hand = /obj/item/rogueweapon/sword/long/broadsword/steel
				var/list/sidearm_options = list("一把武装剑", "一把斧", "钉锤")
				var/sidearm_choice = input(H, "选择你的副手武器！", "让他们的肠子流出来。") as anything in sidearm_options
				switch(sidearm_choice)
					if("一把武装剑")
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
						beltl = /obj/item/rogueweapon/sword/iron
					if("一把斧")
						H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
						if(weapon_choice == "战斧")
							ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
							beltl = /obj/item/rogueweapon/stoneaxe/battle
						else
							beltl = /obj/item/rogueweapon/stoneaxe/woodcut
					if("钉锤")
						H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
						beltl = /obj/item/rogueweapon/mace
		var/helmets = list("沃尔夫头骨盆盔","锅盔加荒野守卫")
		var/helmet_choice = input(H, "选择你的头盔。", "坚定自身。") as anything in helmets
		switch(helmet_choice)
			if("沃尔夫头骨盆盔")
				head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker //Pseudoantagonistic-exclusive. Light AC with an on-wear trait for HELMBITING.
			if("锅盔加荒野守卫")
				head = /obj/item/clothing/head/roguetown/helmet/kettle
				mask = /obj/item/clothing/mask/rogue/wildguard
		wretch_select_bounty(H)
