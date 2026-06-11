/datum/advclass/foreigner/refugee
	name = "纳莱迪难民"
	tutorial = "来自纳莱迪战火废墟的寻求庇护者或其后代。纳莱迪的陨落夺走了你的未来，尽管纳莱迪的碎片仍残留在你所受的那点训练之中。"
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/refugee
	subclass_languages = list(/datum/language/celestial)
	cmode_music = 'sound/music/warscholar.ogg'
	traits_applied = list(TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/refugee/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/paths = list("难民（默认）", "秘会辍学者（大祭司）", "沙漠苦修者（大主教）", "遗弃占卜师（维齐尔）")
	var/list/hmm = list("我离开是有原因的……（默认）", "灯灵可能在任何地方！（纳莱迪情结）")
	var/path = input(H, "选择你的过往。", "战争夺走了你什么？") as anything in paths
	var/complex = input(H, "你有多紧密地遵循传统？", "我恨灯灵！") as anything in hmm

	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/clothing/neck/roguetown/psicross/naledi
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	shoes = /obj/item/clothing/shoes/roguetown/boots/footwraps/padded
	pants = /obj/item/clothing/under/roguetown/skirt/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black
	beltr = /obj/item/flashlight/flare/torch/lantern

	switch(complex)
		if("The Djinn could be anywhere! (Naledi Complex)")
			ADD_TRAIT(H, TRAIT_NALEDI, TRAIT_GENERIC)
			mask = /obj/item/clothing/mask/rogue/lordmask/naledi
		else
			mask = /obj/item/clothing/mask/rogue/lordmask/tarnished

	switch(path)

		if("难民（默认）")//dodgeexpert, quarter staff standard refugee
			H.set_patron(/datum/patron/old_god)
			to_chat(H, span_warning("An asylum-seeker from the war-torn deserts of Naledi, \
			the ruins of your great city are as unsafe as the deserts being ravaged by the Djinn."))
			r_hand = /obj/item/rogueweapon/spear/assegai
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			backpack_contents = list(/obj/item/rogueweapon/huntingknife = 1)

		if("秘会辍学者（大祭司）")//on par with sorcerer mage, but worse stats and skills. given leylines however
			H.set_patron(/datum/patron/old_god)
			to_chat(H, span_warning("A would be promising Magos in the Hierophant halls, during a better era. The Fall of Naledi a hundred yils ago leaves whatever arcyne teachings of the hireophants you have managed to gather incomplete."))
			r_hand = /obj/item/rogueweapon/woodstaff
			head = /obj/item/clothing/head/roguetown/roguehood/hierophant
			cloak = /obj/item/clothing/cloak/hierophant
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian
			backpack_contents += list(/obj/item/book/spellbook = 1, /obj/item/chalk = 1, /obj/item/rogueweapon/huntingknife = 1)
			H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_NOVICE, TRUE)

			H.change_stat(STATKEY_INT, 3)
			H.change_stat(STATKEY_PER, -1)
			H.change_stat(STATKEY_SPD, -1)
			H.change_stat(STATKEY_CON, -1)

			ADD_TRAIT(H, TRAIT_ARCYNE_T3, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)

			if(H.mind)
				H.mind?.adjust_spellpoints(20)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/ley_lines)

		if("沙漠苦修者（大主教）")//reduced spellpoints, stats, no dodge expert. Toughened up refugee.
			H.set_patron(/datum/patron/old_god)
			to_chat(H, span_warning("You were being being taught the ways of a Pontifex, training in body and will. The Fall of Naledi a hundred yils ago left whatever your training incomplete, whatever it's source. Shunned for your survival and left without a master, you wandered the deserts with unfinished discipline."))
			r_hand = /obj/item/rogueweapon/katar
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex
			backpack_contents += list(/obj/item/book/spellbook = 1, /obj/item/rogueweapon/huntingknife = 1)

			H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_NOVICE, TRUE)

			H.change_stat(STATKEY_CON, 2)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_PER, -1)
			H.change_stat(STATKEY_WIL, -1)
			H.change_stat(STATKEY_SPD, -1)

			ADD_TRAIT(H, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)

			if(H.mind)
				var/weapons = list("战争之道","控制之道","暗影之道", "生存之道")
				var/weapon_choice = input(H, "选择你的道路。", "你正行走于哪条未竟之道？") as anything in weapons
				switch(weapon_choice)
					if("战争之道")//Weak combat stuff only
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/frostbolt) // Standard Naledi Magic spell- Ice is more effective against djinn
					if("控制之道")//Battlefield control, minimal damage dealing
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/ensnare)
					if("暗影之道")//Sneaky trickster punchmage
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/invisibility)
					if("生存之道")//Trade magic for skills
						H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_JOURNEYMAN, TRUE)
						H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
						H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
						H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
						H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)//as a bodyguard it can be REALLY important to find where the bleed is.

				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/shadowstep)//All paths get shadowstep as a minimum
				H.mind?.adjust_spellpoints(2)
		if("遗弃占卜师（维齐尔）")	//reduced stats/skills/spellpoints from Vizier, Not given Stasis
			H.set_patron(/datum/patron/old_god)
			to_chat(H, span_warning("A Vizier healer in training, your studies revolved around the esoteric Origin Magyck - The drawing of Psydon power as the origin of creation. The Fall of Naledi a hundred yils ago ensures that you are wandering in exile with only fragments of the art."))
			r_hand = /obj/item/rogueweapon/woodstaff
			cloak = /obj/item/clothing/cloak/hierophant
			head = /obj/item/clothing/head/roguetown/roguehood/hierophant
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian
			backpack_contents += list(/obj/item/rogueweapon/huntingknife = 1)

			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_APPRENTICE, TRUE)//merc gets journeyman
			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_NOVICE, TRUE)//merc gets apprentice
			H.adjust_skillrank_up_to(/datum/skill/magic/holy, SKILL_LEVEL_JOURNEYMAN, TRUE)//merc gets expert
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_NOVICE, TRUE)

			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_LCK, 1)
			H.change_stat(STATKEY_CON, -2)
			H.change_stat(STATKEY_WIL, -1)

			ADD_TRAIT(H, TRAIT_ARCYNE_T3, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_MEDICINE_EXPERT, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)


			var/datum/devotion/C = new /datum/devotion(H, H.patron)
			C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.
			if(H.mind)
				H.mind?.adjust_spellpoints(6)	//reduced from 9 the merc gets
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/frostbolt) // Standard Naledi Magic spell- Ice is more effective against djinn
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/regression)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convergence)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/divergence)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/acceleration)
				H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/psydonrespite)
				H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/check_boot)
				H.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/psydonendure)

