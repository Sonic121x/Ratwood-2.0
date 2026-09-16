/datum/advclass/foreigner/refugee
	name = "纳莱迪难民"
	tutorial = "来自纳莱迪战火废墟的寻求庇护者或其后代。纳莱迪的陨落夺走了你的未来，尽管纳莱迪的碎片仍残留在你所受的那点训练之中。"
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/refugee
	subclass_languages = list(/datum/language/celestial)
	cmode_music = 'sound/music/warscholar.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_NALEDI)
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
	var/path = input(H, "选择你的过往。", "战争夺走了你什么？") as anything in paths

	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/clothing/neck/roguetown/psicross/naledi
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	shoes = /obj/item/clothing/shoes/roguetown/boots/footwraps/padded
	pants = /obj/item/clothing/under/roguetown/skirt/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black
	beltr = /obj/item/flashlight/flare/torch/lantern
	mask = /obj/item/clothing/mask/rogue/lordmask/naledi

	switch(path)

		if("难民（默认）")//dodgeexpert, quarter staff standard refugee
			H.set_patron(/datum/patron/old_god)
			to_chat(H, span_warning("一名来自纳莱迪战乱沙漠的避难者，\
			你那座伟大城市的废墟，与被灯灵蹂躏的沙漠一样危险。"))
			r_hand = /obj/item/rogueweapon/spear/assegai
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			backpack_contents = list(/obj/item/rogueweapon/huntingknife = 1)

		if("秘会辍学者（大祭司）")//on par with sorcerer mage, but worse stats and skills. given leylines however
			H.set_patron(/datum/patron/old_god)
			to_chat(H, span_warning("在更好的年代里，你本会是祭司长殿堂中一名前途无量的法师。百年前纳莱迪的陨落，令你费尽心力搜集到的祭司长奥术教导，无论如何都残缺不全。"))
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
			to_chat(H, span_warning("你曾受教于大主教之道，锤炼肉身与意志。百年前纳莱迪的陨落，令你的修行无论源自何处，都就此中断。你因活下来而遭人唾弃，又失去了师长，只得带着未竟的戒律在沙漠中漂泊。"))
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
			to_chat(H, span_warning("身为一名尚在受训的维齐尔医者，你的研习围绕着秘传的起源魔法——将普赛顿之力视作创世之源而加以引取。百年前纳莱迪的陨落，使你只能带着这门技艺的残篇流亡漂泊。"))
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

