/datum/advclass/wretch/deserter_knight
	name = "失节骑士"
	tutorial = "你曾是受人尊崇与敬畏的骑士，如今却成了背弃君主的叛徒。你过着亡命之徒的日子，被世人唾弃，也被整个社会轻蔑地看待。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/wretch/deserter
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_EQUESTRIAN, TRAIT_DISGRACED_NOBLE, TRAIT_BOGWALKER)
	maximum_possible_slots = 2 //Ideal role for fraggers. Better to limit it.

	cmode_music = 'sound/music/cmode/antag/combat_disgraced.ogg' // New music since I had some unused oggs around anyway.
	class_select_category = CLASS_CAT_WARRIOR
	// Deserter are the knight-equivalence. They get a balanced, straightforward 11 weighted balance to endure and overcome.
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_STR = 2,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, //no miracles to deal w/ stabs through plate armor
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"护甲片" =  /obj/item/repair_kit/metal,
	)
	extra_context = "该职业不能选择“骑术娴熟”美德。"

	virtue_restrictions = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/wretch/deserter/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你曾是受人尊崇与敬畏的骑士，如今却成了背弃君主的叛徒。你过着亡命之徒的日子，被世人唾弃，也被整个社会轻蔑地看待。"))
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.verbs |= list(/mob/living/carbon/human/mind/proc/setorderswretch)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/brotherhood)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)

		var/weapons = list(
			"穿甲刺剑",
			"阔剑",
			"钢钉头锤加鸢盾",
			"铁连枷加鸢盾",
			"长剑加鸢盾",
			"卢塞恩锤",
			"战斧加鸢盾",
			"骑枪加鸢盾",
			"沙姆希尔弯刀",
			"双刃长刀",
			"恰西克弯刀加鸢盾",
			"钢制焰形剑",
			"巨锤",
			"长柄战锤"
		)
		var/weapon_choice = input(H, "选择你的武器。", "披甲执兵") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("穿甲刺剑")
				r_hand = /obj/item/rogueweapon/estoc
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("阔剑")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long/broadsword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("长剑加鸢盾")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long
				backr = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("钢钉头锤加鸢盾")
				beltr = /obj/item/rogueweapon/mace/steel
				backr = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			if("铁连枷加鸢盾")
				beltr = /obj/item/rogueweapon/flail/sflail
				backr = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)
			if("卢塞恩锤")
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
			if("战斧加鸢盾")
				r_hand = /obj/item/rogueweapon/stoneaxe/battle
				backr = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
			if("骑枪加鸢盾")
				r_hand = /obj/item/rogueweapon/spear/lance
				backr = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
			if("沙姆希尔弯刀")
				r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
				beltr = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("双刃长刀")
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/noparry
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("恰西克弯刀加鸢盾")
				r_hand = /obj/item/rogueweapon/sword/sabre/steppesman
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/iron/steppesman
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("钢制焰形剑")
				r_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
			if("巨锤")
				r_hand = /obj/item/rogueweapon/mace/goden/steel
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
			if("长柄战锤")
				r_hand = /obj/item/rogueweapon/eaglebeak
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)

		var/helmets = list(
			"猪面盆盔"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"护卫盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"栅条盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"桶盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"骑士阿梅特盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"带面罩萨雷特盔"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"带吻部面罩萨雷特盔"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted,
			"阿梅特盔"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"带吻部阿梅特盔"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/snouted,
			"犬首盆盔"		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"伊特鲁里亚盆盔"		= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"开缝锅盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"库拉赫盔"	= /obj/item/clothing/head/roguetown/helmet/sallet/zyb,
			"兜盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/kabuto, //No mask, fuck you
			"希沙克盔"	= /obj/item/clothing/head/roguetown/helmet/sallet/shishak,
			"狼颅盆盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
			"圆面盆盔"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface,
			"带吻部圆面盆盔"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/snouted,
			"蛙口盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth,
			"带大羽饰蛙口盔" = /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth/greatplume,
			"带面罩巴布特盔" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor,
			"大巴布特盔" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/great,
			"奥塔瓦盔" = /obj/item/clothing/head/roguetown/helmet/otavan,
			"具装骑兵盔" = /obj/item/clothing/head/roguetown/helmet/heavy/cataphract,
			"喙盔" = /obj/item/clothing/head/roguetown/helmet/heavy/beakhelm,
			"无"
		)
		var/helmchoice = input(H, "选择你的头盔。", "披挂头盔") as anything in helmets
		if(helmchoice != "无")
			head = helmets[helmchoice]

		var/armors = list(
			"全身板甲"			= /obj/item/clothing/suit/roguetown/armor/plate/full,
			"沟槽全身板甲"		= /obj/item/clothing/suit/roguetown/armor/plate/full/fluted,
			"沟槽胸甲"	= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted,
			"钢制胸甲"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			"板甲衣"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
			"板片外衣"		= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
			"半身板甲"		= /obj/item/clothing/suit/roguetown/armor/plate,
			"草原札甲鳞铠"		= /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe,
			"哈拉特板甲衣"		= /obj/item/clothing/suit/roguetown/armor/brigandine/haraate,
			"具装骑兵甲"	= /obj/item/clothing/suit/roguetown/armor/plate/cataphract,
		)
		var/armorchoice = input(H, "选择你的护甲。", "披挂甲胄") as anything in armors
		armor = armors[armorchoice]
		wretch_select_bounty(H)
	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/platelegs
	neck = /obj/item/clothing/neck/roguetown/bevor
	cloak = /obj/item/clothing/cloak/tabard/black
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset //less meta
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel //gwstraps landing on backr asyncs with backpack_contents
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/combat/messer = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	if(H.age == AGE_OLD) // To discourage old strugglers
		H.change_stat(STATKEY_PER, 2)
		H.change_stat(STATKEY_CON, 2)
		H.change_stat(STATKEY_SPD, -2) //We're crippling you little buddy
		H.change_stat(STATKEY_LCK, -1) 
	if (H.mind)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)

/datum/advclass/wretch/deserter/maa
	name = "逃兵"
	tutorial = "你曾有岗位，曾有职责。或许是不满，或许是士气消沉，又或许只是自认高过这一切——你决定一走了之。如今，这份过往如影随形，无论你去往何处。"
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/wretch/deserter_maa

	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_WRETCH)
	//frankly, this is probably not going to happen consistantly with a massive tide of bogmen. If it does uhh, honestly. hilarious.
	//Worst case nuke this to 5 slots, or 4. If it becomes a problem.

	subclass_stashed_items = list(
		"护甲板片" =	/obj/item/repair_kit/metal,
	)

	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg' // same as regular bandits
	// Slightly more rounded. These can be nudged as needed.
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_BOGWALKER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 2,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN, //Unique only case here, pick crossbow if you want to exceed in crossbows. Otherwise you're decently okay at it.
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT, // Better at climbing away than your average MaA. Only slightly.
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN, // Worse at swimming than the above class.
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, //No miracles to deal w/ stabs through plate/maile armor
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE, //So you can repair your heater shield + build in the bogs
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE, //So you can build additional walls and misc decorations
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE, //Ditto
	)

/datum/outfit/job/roguetown/wretch/deserter_maa/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/weapons = list("战锤加盾","军刀加盾","斧加盾","钩镰","巨斧","长戟","弩")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("战锤加盾")
				beltr = /obj/item/rogueweapon/mace/warhammer/steel
				backl = /obj/item/rogueweapon/shield/heater
			if("军刀加盾")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/heater
			if("斧加盾")
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
				backl = /obj/item/rogueweapon/shield/heater
			if("钩镰")
				r_hand = /obj/item/rogueweapon/spear/billhook
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("长戟")
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("巨斧")
				r_hand = /obj/item/rogueweapon/greataxe
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("弩")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltr = /obj/item/quiver/heavybluntbolts

	H.verbs += /mob/proc/haltyell //Ex-Garrisoner
	H.verbs += /mob/living/carbon/human/mind/proc/setorders //Kill if problematic
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/brotherhood)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)

		/*
		meant to be less knightly-helmets and more in-line with banditry, brigand loadouts and such so, so no armlets

		we limit this so you have to look moderately evil or suspiciously wearing old-style helmets
		*/
		var/helmets = list(
			"猪面盆盔"		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"犬首盆盔"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"克氏面甲盆盔"	= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"狼颅盆盔"		= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
			"带面罩萨雷特盔"		= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"带吻部面罩萨雷特盔"		= /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted,
			"带面罩锅盔"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
		)
		var/helmchoice = input(H, "选择你的头盔。", "选择头盔") as anything in helmets
		head = helmets[helmchoice]

		var/armors = list(
			"胸甲"			= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			"板甲衣"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
			"沟槽胸甲"		= /obj/item/clothing/suit/roguetown/armor/plate/half/fluted,
			"鳞甲"			= /obj/item/clothing/suit/roguetown/armor/plate/scale,
		)
		var/armorchoice = input(H, "选择你的护甲。", "披甲执兵") as anything in armors
		armor = armors[armorchoice]

		var/cloaks = list("沼泽绿","黑色","棕色长风衣")
		var/cloak_choice = input(H, "选择你的斗篷。", "为了沼泽") as anything in cloaks
		switch(cloak_choice)
			if("沼泽绿")
				cloak = /obj/item/clothing/cloak/stabard/bog
				mask = /obj/item/clothing/head/roguetown/roguehood/bogman
			if("黑色")
				cloak = /obj/item/clothing/cloak/stabard/dungeon
				mask = /obj/item/clothing/head/roguetown/roguehood/bogman/black
			if("棕色长风衣")
				cloak = /obj/item/clothing/suit/roguetown/armor/longcoat/brown
				mask = /obj/item/clothing/head/roguetown/roguehood/bogman/brown

		wretch_select_bounty(H)

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/bevor
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/chain
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	beltl = /obj/item/rogueweapon/mace/cudgel
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel

	backpack_contents = list(/obj/item/natural/cloth = 1, /obj/item/rogueweapon/huntingknife/combat/messer = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/flashlight/flare/torch/lantern/prelit = 1, /obj/item/rogueweapon/scabbard/sheath = 1)


/obj/effect/proc_holder/spell/invoked/order
	name = ""
	overlay_icon = 'icons/mob/actions/orders.dmi'
	action_icon = 'icons/mob/actions/orders.dmi'
	sound = 'sound/magic/inspire_02.ogg'
	range = 5
	associated_skill = /datum/skill/misc/athletics
	devotion_cost = 0
	chargedrain = 0
	chargetime = 0
	releasedrain = 80
	recharge_time = 2 MINUTES
	miracle = FALSE

/obj/effect/proc_holder/spell/invoked/order/retreat
	name = "战术后撤！"
	chargedrain = 0
	chargetime = 0
	desc = "让你的弟兄们获得 3 点速度！"
	overlay_state = "move"

/obj/effect/proc_holder/spell/invoked/order/retreat/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.retreattext
		if(!msg)
			to_chat(user, span_alert("我必须先说些什么，才能下达命令！"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("我不能命令不属于兄弟会事业的人！"))
				return
		if(target == user)
			to_chat(user, span_alert("我不能命令我自己！"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/retreat)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/order/retreat/nextmove_modifier()
	return 0.85

/datum/status_effect/buff/order/retreat
	id = "movemovemove"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/retreat
	effectedstats = list(STATKEY_SPD = 3)
	duration = 0.5 / 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/retreat
	name = "战术后撤！！"
	desc = "我的指挥官命令我后撤！"
	icon_state = "buff"

/datum/status_effect/buff/order/retreat/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的指挥官命令我后撤！"))

/obj/effect/proc_holder/spell/invoked/order/bolster
	name = "稳住战线！"
	desc = "让你的弟兄们获得 2 点体质和 3 点意志！"
	overlay_state = "hold"
	chargedrain = 0
	chargetime = 0

/datum/status_effect/buff/order/bolster
	id = "takeaim"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/bolster
	effectedstats = list(STATKEY_CON = 2, STATKEY_WIL = 3)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/bolster
	name = "稳住战线！"
	desc = "我的指挥官鼓舞我坚持下去，再多撑一会儿！"
	icon_state = "buff"

/datum/status_effect/buff/order/bolster/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的指挥官命令我稳住战线！"))

/obj/effect/proc_holder/spell/invoked/order/bolster/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.bolstertext
		if(!msg)
			to_chat(user, span_alert("我必须先说些什么，才能下达命令！"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("我不能命令不属于兄弟会事业的人！"))
				return
		if(target == user)
			to_chat(user, span_alert("我不能命令我自己！"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/bolster)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/order/brotherhood
	name = "为了兄弟会！"
	desc = "命令部下挺身战斗，无惧恐惧与痛楚。"
	overlay_state = "onfeet"
	chargedrain = 0
	chargetime = 0
/obj/effect/proc_holder/spell/invoked/order/brotherhood/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.brotherhoodtext
		if(!msg)
			to_chat(user, span_alert("我必须先说些什么，才能下达命令！"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("我不能命令不属于兄弟会事业的人！"))
				return
		if(target == user)
			to_chat(user, span_alert("我不能命令我自己！"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/brotherhood)
		if(!(target.mobility_flags & MOBILITY_STAND))
			target.SetUnconscious(0)
			target.SetSleeping(0)
			target.SetParalyzed(0)
			target.SetImmobilized(0)
			target.SetStun(0)
			target.SetKnockdown(0)
			target.set_resting(FALSE)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/order/brotherhood
	id = "onfeet"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/brotherhood
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/buff/order/brotherhood
	name = "坚守阵地！"
	desc = "我的指挥官命令我为兄弟会骄傲地站稳脚跟！"
	icon_state = "buff"

/datum/status_effect/buff/order/brotherhood/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的指挥官命令我为兄弟会骄傲地站稳脚跟！"))
	ADD_TRAIT(owner, TRAIT_NOPAIN, MAGIC_TRAIT)

/datum/status_effect/buff/order/brotherhood/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, MAGIC_TRAIT)
	. = ..()


/obj/effect/proc_holder/spell/invoked/order/charge
	name = "冲锋！"
	desc = "让你的弟兄们获得 2 点力量和 2 点感知！"
	overlay_state = "hold"
	chargedrain = 0
	chargetime = 0

/obj/effect/proc_holder/spell/invoked/order/charge/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.holdtext
		if(!msg)
			to_chat(user, span_alert("我必须先说些什么，才能下达命令！"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("我不能命令不属于兄弟会事业的人！"))
				return
		if(target == user)
			to_chat(user, span_alert("我不能命令我自己！"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/charge)
		return TRUE
	revert_cast()
	return FALSE


/datum/status_effect/buff/order/charge
	id = "hold"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/charge
	effectedstats = list(STATKEY_STR = 2, STATKEY_PER = 2)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/charge
	name = "冲锋！"
	desc = "我的指挥官意志已下，现在正是冲锋之时！"
	icon_state = "buff"

/datum/status_effect/buff/order/charge/on_apply()
	. = ..()
	to_chat(owner, span_blue("我的指挥官命令我冲锋！为了兄弟会！"))



/mob/living/carbon/human/mind/proc/setorderswretch()
	set name = "预设军令"
	set category = "统御之声"
	mind.retreattext = input("输入一段话。", "战术后撤！！") as text|null
	if(!mind.retreattext)
		to_chat(src, "我必须先为这道命令预备一句话……")
		return
	mind.chargetext = input("输入一段话。", "冲啊啊啊啊！！") as text|null
	if(!mind.chargetext)
		to_chat(src, "我必须先为这道命令预备一句话……")
		return
	mind.bolstertext = input("输入一段话。", "稳住战线！！") as text|null
	if(!mind.bolstertext)
		to_chat(src, "我必须先为这道命令预备一句话……")
		return
	mind.brotherhoodtext = input("输入一段话。", "为了兄弟会，昂首站稳！！") as text|null
	if(!mind.brotherhoodtext)
		to_chat(src, "我必须先为这道命令预备一句话……")
		return



/obj/effect/proc_holder/spell/self/convertrole/brotherhood
	name = "招募兄弟会民兵"
	new_role = "Brother"
	overlay_state = "recruit_brotherhood"
	recruitment_faction = "Brother"
	recruitment_message = "从现在起，我们同进共退，%RECRUIT！"
	accept_message = "为了兄弟会！"
	refuse_message = "我拒绝。"

