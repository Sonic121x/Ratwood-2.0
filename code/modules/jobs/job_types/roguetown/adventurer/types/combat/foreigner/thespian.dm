/datum/advclass/foreigner/bronzeclad
	name = "游历武伶"
	tutorial = "来自兹班图与伊特鲁斯卡竞技场的角斗士，来自奥塔瓦与格伦泽尔霍夫华丽宫廷的扮演者，以及 \
	来自普赛多尼亚遥远边疆的持盾者；他们都在不自觉地追求同一件事：取悦某种凌驾于自身之上的 \
	存在。你是一名来自费伦提亚之外的熟练战士，因某种缘故，极为擅长使用古老装备战斗。"

	outfit = /datum/outfit/job/roguetown/adventurer/bronzeclad
	cmode_music = 'sound/music/combat_thespian.ogg'
	allowed_races = RACES_ALL_KINDS
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)//vampires aren't allowed to gladiator larp, sire
	maximum_possible_slots = 3 //Should be categorically rarer to see than Iron- and Steel-clad adventurers. Tickles the powerscale ala the Exorcist, albeit to a wider extent with its potential combinations.
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_BLOOD_RESISTANCE)//may work on a lesser TRAIT_STRONGKICK so the leonidus wannabes can do the spartan kick.
	subclass_languages = list(/datum/language/etruscan)
	subclass_stats = list(
		STATKEY_STR = 2, //+2(4)/+3/+2/-2(-4)=weighted 5 point total. +2 strength mostly for greatshield requirement. Slightly below other adv weights but they get crit resistnace and limited slots so whatever.
		STATKEY_WIL = 3,
		STATKEY_CON = 2,
		STATKEY_SPD = -2,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

	extra_context = "该子职业可从多种青铜武器、护甲和出身中选择自己的专精。青铜护甲虽然容易被刺穿，却格外耐用，且能抵御重创。共有四种专精可选，各自提供不同的特质与护甲等级。"

/datum/outfit/job/roguetown/adventurer/bronzeclad/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	to_chat(H, span_warning("帷幕拉开，盾阵集结，千重暗影的目光落在你身上。咆哮的角斗士、狂热的持盾者、盛装的武伶；准备迎接下一场较量吧。"))
	if(H.mind)
		var/bronzeweapon = list("斯帕塔长剑与徒手技能 +1","三叉戟与徒手技能 +1","巨斧与徒手技能 +1","多拉布拉鹤嘴锄与徒手技能 +1","翼矛与大盾","阿波菲斯巨镰剑与大盾","短剑与盾牌","科庇斯弯刀与盾牌","马凯拉弯刀与盾牌","镰形剑与盾牌","斧头与盾牌","战棍与盾牌","连枷与盾牌","长矛与盾牌","弧刃拳套与短剑","赤手空拳 - 熟练拳师，力量/意志 +I，智力 -1")
		var/bronzeweapon_choice = input(H, "选择你的武器。", "为观众献上好戏") as anything in bronzeweapon
		switch(bronzeweapon_choice)
			if("斯帕塔长剑与徒手技能 +1")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/broadsword/bronze
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("三叉戟与徒手技能 +1")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/trident
				beltr = /obj/item/net
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("巨斧与徒手技能 +1")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe/bronze
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("多拉布拉鹤嘴锄与徒手技能 +1")
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/pick/bronze
			if("翼矛与大盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/bronze/winged/strapless
				backr = /obj/item/rogueweapon/shield/bronze/great
			if("阿波菲斯巨镰剑与大盾")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/greatkhopesh
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/bronze/great
			if("短剑与盾牌")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/short/gladius
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/bronze
			if("马凯拉弯刀与盾牌")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/short/messer/bronze
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/bronze
			if("科庇斯弯刀与盾牌")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/falchion/militia/bronze
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/bronze
			if("镰形剑与盾牌")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/bronze
			if("斧头与盾牌")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/bronzebattleaxe
				backr = /obj/item/rogueweapon/shield/bronze
			if("战棍与盾牌")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/mace/warhammer/bronze
				backr = /obj/item/rogueweapon/shield/bronze
			if("连枷与盾牌")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/bronze
				backr = /obj/item/rogueweapon/shield/bronze
			if("长矛与盾牌")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/rogueweapon/shield/bronze
				r_hand = /obj/item/rogueweapon/spear/bronze/strapless
			if("弧刃拳套与短剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/sword/short/gladius
				r_hand = /obj/item/rogueweapon/katar/bronze/gladiator
				backr = /obj/item/rogueweapon/scabbard/sword
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("赤手空拳 - 熟练拳师，力量/意志 +I，智力 -1")//weighted 7. If disciple weaponless trait gets merged ill add it here to force unarmed only
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_INT, -1)

		var/bronzesidearm = list("一袋标枪", "投石索与青铜弹丸", "弓与青铜箭矢", "另一把短剑与双持技艺", "另一把马凯拉弯刀与双持技艺", "另一把镰形剑与双持技艺", "另一把斧头与双持技艺")
		var/bronzesidearm_choice = input(H, "选择你的附加装备。", "准备你的开场演出") as anything in bronzesidearm
		switch(bronzesidearm_choice)
			if("一袋标枪")
				beltl = /obj/item/quiver/javelin/bronze
			if("投石索与青铜弹丸")
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
				beltl = /obj/item/quiver/sling/bronze
			if("弓与青铜箭矢")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/classic
				beltl = /obj/item/quiver/bronzearrows
			if("另一把短剑与双持技艺")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/sword/short/gladius
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword
			if("另一把马凯拉弯刀与双持技艺")//these names may confuse people, but its soulful to display their actual titles rather than "messer"
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/sword/short/messer/bronze
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword
			if("另一把镰形剑与双持技艺")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword
			if("另一把斧头与双持技艺")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_APPRENTICE, TRUE)
				l_hand = /obj/item/rogueweapon/stoneaxe/woodcut/bronzebattleaxe//i hate this objs naming path, just terrible
		var/bronzediscipline = list("武伶 - 闪避专家，体质/力量 -I，速度 +III","角斗士 - 皮肤护甲与疼痛耐受","持盾者 - 精良护甲与中甲训练","壁垒 - 全身护甲与重甲训练")
		var/bronzediscipline_choice = input(H, "选择你的专精。", "拥抱荣耀与死亡") as anything in bronzediscipline
		switch(bronzediscipline_choice)
			if("武伶 - 闪避专家，体质/力量 -I，速度 +III")
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				H.change_stat(STATKEY_SPD, 3)
				H.change_stat(STATKEY_INT, 1)
				H.change_stat(STATKEY_STR, -1)
				H.change_stat(STATKEY_CON, -1)
				head = /obj/item/clothing/head/roguetown/headband/red
				mask = /obj/item/clothing/mask/rogue/facemask/bronze
				armor = /obj/item/clothing/suit/roguetown/armor/plate/bronze/light
				pants = /obj/item/clothing/under/roguetown/skirt/red
				wrists = /obj/item/clothing/wrists/roguetown/bracers/bronze
				belt = /obj/item/storage/belt/rogue/leather
			if("角斗士 - 皮肤护甲与疼痛耐受")
				ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC) //Lite!Barbarian.
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)//effectively gives them old crit resistance with the 0.5x bleed rate
				head = /obj/item/clothing/head/roguetown/helmet/bronzegladiator
				wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/gladiator
				armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/chest/gladiator //a leather armor
				shirt = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/body/gladiator //a gambeson
				pants = /obj/item/clothing/under/roguetown/loincloth/brown
				belt = /obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/red
				//shirt = /obj/item/clothing/suit/roguetown/shirt/tribalrag/gladiator //no empty hands to put this in, and cannot seem to 'pre-load' the cosmetic slot of a skin armor. Can hang in limbo untill someone figures out how to grant it.
			if("持盾者 - 精良护甲与中甲训练")
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				head = /obj/item/clothing/head/roguetown/helmet/heavy/bronze
				neck = /obj/item/clothing/neck/roguetown/gorget/bronze
				wrists = /obj/item/clothing/wrists/roguetown/bracers/bronze
				armor = /obj/item/clothing/suit/roguetown/armor/plate/bronze
				cloak = /obj/item/clothing/cloak/cape/red
				pants = /obj/item/clothing/under/roguetown/skirt/red
				belt = /obj/item/storage/belt/rogue/leather
			if("壁垒 - 全身护甲与重甲训练")
				ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
				head = /obj/item/clothing/head/roguetown/helmet/bronze
				neck = /obj/item/clothing/neck/roguetown/bevor/bronze
				wrists = /obj/item/clothing/wrists/roguetown/bracers/bronze
				armor = /obj/item/clothing/suit/roguetown/armor/plate/full/bronze
				pants = /obj/item/clothing/under/roguetown/loincloth/brown
				cloak = /obj/item/clothing/cloak/cape/red
				belt = /obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/red
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/bronze
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/combat/bronze = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.set_blindness(0)
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			id = /obj/item/clothing/neck/roguetown/psicross/bronze
		if(/datum/patron/inhumen/zizo)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/bronze
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/bronze
		if(/datum/patron/divine/ravox)
			id = /obj/item/clothing/neck/roguetown/psicross/ravox/bronze
		if(/datum/patron/divine/astrata)
			id = /obj/item/clothing/neck/roguetown/psicross/astrata/bronze
		if(/datum/patron/divine/malum)
			id = /obj/item/clothing/neck/roguetown/psicross/malum/bronze
		if(/datum/patron/divine/noc)
			id = /obj/item/clothing/neck/roguetown/psicross/noc/bronze
		else
			id = /obj/item/clothing/ring/bronze
