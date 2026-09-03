/datum/job/roguetown/baron_retainer
	title = "Retainer"
	display_title = "家臣"
	flag = RETAINER
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_SOLDIER
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	always_show_on_latechoices = TRUE
	tutorial = "你肩负着男爵最亲近心腹的信任与责任。你的任务是保护男爵，并就他认为必要的任何事项提供建议。你享有相对奢华的生活待遇和职位带来的地位，尽管城堡中更高阶的贵族会将你视为卑微的办事员而瞧不起你。"
	display_order = JDO_RETAINER
	whitelist_req = FALSE
	outfit = /datum/outfit/job/roguetown/baron_retainer
	advclass_cat_rolls = list(CTAG_RETAINER = 20)
	give_bank_account = 30
	min_pq = 15
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_ManAtArms.ogg'
	social_rank = SOCIAL_RANK_YEOMAN
	job_subclasses = list(/datum/advclass/baron_retainer/henchman, /datum/advclass/baron_retainer/duelist, /datum/advclass/baron_retainer/greyleaf)

/datum/outfit/job/roguetown/baron_retainer
	job_bitflag = BITFLAG_GARRISON
	belt = /obj/item/storage/belt/rogue/leather/black
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison

/datum/advclass/baron_retainer/henchman
	name = "打手"
	tutorial = "你是一个在需要时随时支援男爵的莽夫。行动胜于言语，而你正是这句俗语的化身。"
	outfit = /datum/outfit/job/roguetown/baron_retainer/henchman
	category_tags = list(CTAG_RETAINER)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	subclass_stats = list(STATKEY_STR = 2, STATKEY_CON = 2, STATKEY_WIL = 3, STATKEY_PER = 2)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/baron_retainer/henchman/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	cloak = /obj/item/clothing/cloak/tabard/retinue/baronycloak
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	neck = /obj/item/clothing/neck/roguetown/bevor
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backpack_contents = list(/obj/item/roguekey/baron = 1, /obj/item/storage/keyring/baronretainer = 1, /obj/item/flashlight/flare/torch/lantern = 1, /obj/item/rogueweapon/huntingknife/idagger/steel = 1, /obj/item/rogueweapon/scabbard/sheath = 1, /obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,)
	H.verbs |= list(/mob/proc/haltyell)
	if(H.mind)
		var/weapons = list("长柄武器", "钝器", "大钉锤", "剑盾", "链枷与盾", "双手大剑")
		var/weapon_choice = input(H, "选择你的武器。", "披甲执兵") as anything in weapons
		switch(weapon_choice)
			if("长柄武器")
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			if("钝器")
				r_hand = /obj/item/rogueweapon/mace/maul
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			if("大钉锤")
				r_hand = /obj/item/rogueweapon/mace/goden/steel
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			if("剑盾")
				r_hand = /obj/item/rogueweapon/sword
				l_hand = /obj/item/rogueweapon/shield/iron
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			if("链枷与盾")
				r_hand = /obj/item/rogueweapon/flail/sflail
				l_hand = /obj/item/rogueweapon/shield/iron
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
			if("双手大剑")
				r_hand = /obj/item/rogueweapon/greatsword/grenz
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)

/datum/advclass/baron_retainer/duelist
	name = "退役决斗家"
	tutorial = "你曾挥剑、虚晃、旋身、出击——剑锋之上，尽显刀剑精熟。然而火器时代来临，一发致残的枪弹击碎膝盖，终结了你的生涯。\
	男爵给了你一个在他麾下效力的位置——也许，假以时日，你还能重温昔日的荣光。"
	outfit = /datum/outfit/job/roguetown/baron_retainer/duelist
	category_tags = list(CTAG_RETAINER)
	traits_applied = list(TRAIT_DECEIVING_MEEKNESS, TRAIT_COMBAT_AWARE, TRAIT_INTELLECTUAL, TRAIT_STEELHEARTED) //That musket round really did a number on your dodging reflexes, but you can still strike true with the blade.
	subclass_stats = list(STATKEY_INT = 2, STATKEY_PER = 2, STATKEY_SPD = 3, STATKEY_WIL = 2, STATKEY_CON = -1) //4 speed was the most ridiculous thing anyone's ever added
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT, //So-called "Grapplebait" by my peer group session. Ok bro
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/baron_retainer/duelist/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fencer
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	shoes = /obj/item/clothing/shoes/roguetown/boots/maille
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	gloves = /obj/item/clothing/gloves/roguetown/plate
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/rondel //ANTI-GRAPPLER DAGGER, ACTIVATE!!
	beltr = /obj/item/rogueweapon/scabbard/sheath/noble
	backl = /obj/item/rogueweapon/scabbard/sword/noble
	backpack_contents = list(/obj/item/roguekey/baron = 1, /obj/item/storage/keyring/baronretainer = 1, /obj/item/flashlight/flare/torch/lantern = 1)

/datum/outfit/job/roguetown/baron_retainer/duelist/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("野兽（行刑剑）", "费伦提亚长剑", "狐狸（刺剑）", "阿夫尼克（什什卡军刀）", "穆巴里尊（沙拉尔）", "剑士（战刀）", "流浪者（环刀）")
	var/weapon_choice = input(H, "选择你的武器。", "执兵而起") as anything in weapons
	switch(weapon_choice)
		if("野兽（行刑剑）")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/exe, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/sack, SLOT_WEAR_MASK, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/longcoat, SLOT_CLOAK, TRUE)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_SPD, -2)
		if("费伦提亚长剑")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/duelistcape, SLOT_CLOAK, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/duelisthat, SLOT_HEAD, TRUE)
		if("狐狸（刺剑）")
			H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/vaquero, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/duelmask, SLOT_WEAR_MASK, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/duelistcape, SLOT_CLOAK, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/duelisthat, SLOT_HEAD, TRUE)
		if("阿夫尼克（什什卡军刀）")
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/steppesman, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/shield/buckler, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/steppesman, SLOT_WEAR_MASK, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/papakha, SLOT_HEAD, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/raincloak/furcloak, SLOT_CLOAK, TRUE)
		if("穆巴里尊（沙拉尔）")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/marlin, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/cape/red, SLOT_CLOAK, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/zyb, SLOT_HEAD, TRUE)
		if("剑士（战刀）")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/kriegmesser, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/caplessgrenzelhofthat, SLOT_HEAD, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/stabard/grenzelhoft, SLOT_CLOAK, TRUE)
		if("流浪者（环刀）")
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/mulyeog, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/sword/kazengun, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/mentorhat, SLOT_HEAD, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/eastcloak2, SLOT_CLOAK, TRUE)

/datum/advclass/baron_retainer/greyleaf
	name = "灰叶"
	tutorial = "你从守林人队伍中光荣退役，如今找到了新的使命——在暗处保护男爵，并作为曾为保护低镇流过血的人，就低镇事务向他提供建议。"
	outfit = /datum/outfit/job/roguetown/baron_retainer/greyleaf
	category_tags = list(CTAG_RETAINER)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_SURVIVAL_EXPERT, TRAIT_WOODWALKER, TRAIT_PERFECT_TRACKER, TRAIT_STEELHEARTED)
	subclass_stats = list(STATKEY_STR = 1, STATKEY_SPD = 3, STATKEY_PER = 4)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/baron_retainer/greyleaf/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	beltl = /obj/item/rogueweapon/huntingknife/idagger/warden_machete
	backpack_contents = list(/obj/item/roguekey/baron = 1, /obj/item/storage/keyring/baronretainer = 1, /obj/item/flashlight/flare/torch/lantern = 1, /obj/item/rogueweapon/scabbard/sheath = 1)
	if(H.mind)
		var/helmets = list("守林人熊首骨盔", "守林人羊首骨盔", "守林人狼首骨盔", "钉皮兜帽与猎犬面具")
		var/helmet_choice = input(H, "选择你的装束", "披挂上阵") as anything in helmets
		switch(helmet_choice)
			if("守林人熊首骨盔")
				head = /obj/item/clothing/head/roguetown/helmet/sallet/warden/bear
				mask = /obj/item/clothing/head/roguetown/roguehood/warden
				cloak = /obj/item/clothing/cloak/wardencloak
			if("守林人羊首骨盔")
				head = /obj/item/clothing/head/roguetown/helmet/sallet/warden/goat
				mask = /obj/item/clothing/head/roguetown/roguehood/warden
				cloak = /obj/item/clothing/cloak/wardencloak
			if("守林人狼首骨盔")
				head = /obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf
				mask = /obj/item/clothing/head/roguetown/roguehood/warden
				cloak = /obj/item/clothing/cloak/wardencloak
			if("钉皮兜帽与猎犬面具")
				head = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
				mask = /obj/item/clothing/mask/rogue/facemask/steel/hound
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
			
		var/weapons = list("十字弩", "黑角长弓", "反曲弓", "速射弩")
		var/weapon_choice = input(H, "选择你的武器", "披甲执兵") as anything in weapons
		switch(weapon_choice)
			if("十字弩")
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltr = /obj/item/quiver/poisonarrows
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
			if("黑角长弓")
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/warden
				beltr = /obj/item/quiver/poisonarrows
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
			if("反曲弓")
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/warden
				beltr = /obj/item/quiver/poisonarrows
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
			if("速射弩")
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
				beltr = /obj/item/quiver/bolts
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
