/datum/advclass/mercenary/freelancer
	name = "自由斗剑团剑客"
	tutorial = "你毕业于兹瓦尔特基的自由斗剑团——也就是「自由佣兵」——一个享有盛名的武斗行会，坐落于独立城邦瑟伦迪尼日纳，即兹瓦尔特基的首府，被教廷公认为献给拉沃克斯的颂礼。它建立不过三十来年，可访客却来自西格里莫里亚各处。你将同一件兵器挥练过上万次，而非样样浅尝辄止。这个职业属于真正有经验的战士，懂得步法与体力调配的人；光靠大师级技能，还救不了你的命。"
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/mercenary/freelancer
	subclass_languages = list(/datum/language/aavnic)//Your character could not have possibly "graduated" without atleast some basic knowledge of Aavnic.
	allowed_patrons = list(/datum/patron/old_god)
	class_select_category = CLASS_CAT_AAVNR
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_fencer.ogg'
	traits_applied = list(TRAIT_BADTRAINER, TRAIT_INTELLECTUAL, TRAIT_LONGSWORDSMAN, TRAIT_FENCERDEXTERITY)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 3,
		STATKEY_WIL = 3
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE
	)
	virtue_restrictions = list(/datum/virtue/combat/dualwielder)
	adv_stat_ceiling = list(STAT_STRENGTH = 12, STAT_SPEED = 12, STAT_CONSTITUTION = 12)

/datum/outfit/job/roguetown/mercenary/freelancer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是长剑技艺的大师，是普赛多尼亚最百搭、最高贵之兵器的持用者，除此之外你无需他物。你那柄出自专业匠人之手的长剑，能让你施展诸如《伊特鲁斯卡之花》与格伦泽尔霍夫特《维登豪尔》等剑术谱中的招式。"))
	l_hand = /obj/item/rogueweapon/scabbard/sword
	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/huntingknife/idagger/navaja/freifechter
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft/freifechter
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/freifechter
	backr = /obj/item/storage/backpack/rogue/satchel/short
	neck = /obj/item/clothing/neck/roguetown/psicross/reform
	mask = /obj/item/clothing/mask/rogue/spectacles/duelist
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)
	if(H.mind)
		var/weapons = list(
			"伊特鲁斯卡长剑"	= /obj/item/rogueweapon/sword/long/etruscan,
			"改革派长剑"	= /obj/item/rogueweapon/sword/long/etruscan/freifechter
		)
		var/weaponchoice = input(H, "拔出一柄剑。", "由奥克塔维乌什大师呈交于我……") as anything in weapons
		r_hand = weapons[weaponchoice]
		var/armors = list(
			"击剑胸甲"	= /obj/item/clothing/suit/roguetown/armor/plate/half/fencer,
			"击剑外套"	= /obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter
		)
		var/armorchoice = input(H, "披上你的甲胄。", "要安全，还是要灵活？") as anything in armors
		armor = armors[armorchoice]
	H.merctype = 6

/datum/advclass/mercenary/freelancer_lancer
	name = "自由斗剑团长枪手"
	tutorial = "你毕业于兹瓦尔特基的自由斗剑团——也就是「自由佣兵」——一个享有盛名的武斗行会，坐落于独立城邦瑟伦迪尼日纳，即兹瓦尔特基的首府。它建立不过三十来年，可访客却来自西格里莫里亚各处。你将同一件兵器挥练过上万次，而非样样浅尝辄止。长枪手与他的长枪不可分割，是进攻的第一线。你可以选择展示改革派修会的旗帜，或你自己城邦的旗帜。"
	extra_context = "这个职业属于真正有经验的玩家，懂得步法与体力调配的人；光靠大师级技能，还救不了你的命。你以独特的高耐久兵器，来弥补自身固有的弱点与局限。"
	allowed_sexes = list(MALE, FEMALE)

	cmode_music = 'sound/music/frei_lancer.ogg'
	outfit = /datum/outfit/job/roguetown/mercenary/freelancer_lancer
	subclass_languages = list(/datum/language/aavnic)//Your character could not have possibly "graduated" without atleast some basic knowledge of Aavnic.
	allowed_patrons = list(/datum/patron/old_god)
	class_select_category = CLASS_CAT_AAVNR
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/frei_fencer.ogg'
	traits_applied = list(TRAIT_BADTRAINER, TRAIT_FENCERDEXTERITY, TRAIT_INTELLECTUAL)
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_PER = 3,
		STATKEY_STR = 1,
		STATKEY_WIL = 2
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,	//This is the danger zone. Ultimately, the class won't be picked without this. I took the liberty of adjusting everything around to make this somewhat inoffensive, but we'll see if it sticks.
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,	//Wrestling is a swordsman's luxury.
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,	//I got told that having zero climbing is a PITA. Bare minimum for a combat class.
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)
	adv_stat_ceiling = list(STAT_STRENGTH = 12, STAT_SPEED = 12, STAT_WILLPOWER = 14, STAT_CONSTITUTION = 12)	//Prevent climbing to 14 by picking a +1 STR race.

/datum/outfit/job/roguetown/mercenary/freelancer_lancer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你将全部信任都交给了长柄兵器，这种世上最高效的武器。既然敌人根本碰不到你，为何还要穿甲？你可以选择展示改革派修会的旗帜，或你自己城邦的旗帜。"))
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft/freifechter
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/freifechter
	backr = /obj/item/storage/backpack/rogue/satchel/short
	neck = /obj/item/clothing/neck/roguetown/psicross/reform
	mask = /obj/item/clothing/mask/rogue/spectacles/duelist
	id = /obj/item/rogueweapon/katar/punchdagger/frei
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)
	if(H.mind)
		var/weapons = list(
			"毕业长枪"				= /obj/item/rogueweapon/spear/boar/frei,
			"瑟伦迪尼日纳的旗帜"		= /obj/item/rogueweapon/spear/boar/frei/pike,
			"普赛顿改革派的旗帜"	= /obj/item/rogueweapon/spear/boar/frei/pike/reformist
		)
		var/weaponchoice = input(H, "要长矛，还是要旗枪？", "由长枪教头瑟伦斯瓦夫呈交于我……") as anything in weapons
		r_hand = weapons[weaponchoice]
	H.merctype = 6

/datum/advclass/mercenary/freelancer_sabrist
	name = "自由斗剑团军刀手"
	tutorial = "你毕业于兹瓦尔特基的自由斗剑团——也就是「自由佣兵」——一个享有盛名的武斗行会，坐落于独立城邦瑟伦迪尼日纳，即兹瓦尔特基的首府。它建立不过三十来年，可访客却来自西格里莫里亚各处。你将同一件兵器挥练过上万次，而非样样浅尝辄止。你对普赛顿改革派的教义笃信不渝，也成了某种意义上的战士诗人——向乡民传授「新道」的教法，因而惹恼了正统派。你离开故土，四处寻求财富，以资助你族人的军队。军刀手以灵巧与迅捷闻名，却缺少长剑手那般的应变之力。"
	extra_context = "这个职业属于真正有经验的玩家，懂得步法与体力调配的人；光靠大师级技能，还救不了你的命。你以「大师剑招」的机制，来弥补自身固有的弱点与局限。"
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/mercenary/freelancer_sabrist
	subclass_languages = list(/datum/language/aavnic)//Your character could not have possibly "graduated" without atleast some basic knowledge of Aavnic.
	allowed_patrons = list(/datum/patron/old_god)
	class_select_category = CLASS_CAT_AAVNR
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/frei_sabre.ogg'
	traits_applied = list(TRAIT_BADTRAINER, TRAIT_INTELLECTUAL, TRAIT_FENCERDEXTERITY, TRAIT_SABRIST)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 3,
		STATKEY_SPD = 2
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE
	)
	virtue_restrictions = list(/datum/virtue/combat/dualwielder)
	adv_stat_ceiling = list(STAT_STRENGTH = 12, STAT_CONSTITUTION = 12, STAT_WILLPOWER = 12, STAT_SPEED = 12)

/datum/outfit/job/roguetown/mercenary/freelancer_sabrist/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是军刀技艺的大师，是阿夫尼克最卓越之剑的持用者，除此之外你无需他物。你那柄出自专业匠人之手的军刀，能让你施展阿夫尼克传统击剑论著中的招式。"))
	l_hand = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/sabre/freifechter
	beltr = /obj/item/rogueweapon/huntingknife/idagger/navaja/freifechter
	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft/freifechter
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/freifechter
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain	//Obsessed with arms-hands. Keeping them protected on-spawn.
	backr = /obj/item/storage/backpack/rogue/satchel/short
	neck = /obj/item/clothing/neck/roguetown/psicross/reform
	mask = /obj/item/clothing/mask/rogue/spectacles/duelist
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)
	if(H.mind)
		var/armors = list(
			"击剑胸甲"	= /obj/item/clothing/suit/roguetown/armor/plate/half/fencer,
			"击剑外套"	= /obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter
		)
		var/armorchoice = input(H, "披上你的甲胄。", "要安全，还是要灵活？") as anything in armors
		armor = armors[armorchoice]
	H.merctype = 6
