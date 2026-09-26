//Generic Grenzel mean-merc. But adventurer.
//Big sword. Lack of armour. Tear that guy in half and toss him across the room!!!!
//Before you complain, go look at Battlemaster.
/datum/advclass/foreigner/bluthund
	name = "格伦泽尔霍夫特 血犬"
	tutorial = "格伦泽尔霍夫特 的佣兵自成一格。 \
	在这充满欺诈、无赖与背誓者的世道里，他们仍会站稳脚跟。 \
	那是一个由个体组成的行会，一旦签下契约，便会逐字逐句履行到底。 \
	可不知是出于荣耀还是疯狂，你偏偏违逆了这一切，于是被烙成弃徒, 一条“血犬”。 \
	不过他们终究没能夺走你的装备，只夺走了你的头衔。"
	allowed_races = RACES_ALL_KINDS
	traits_applied = list(TRAIT_STEELHEARTED)
	outfit = /datum/outfit/job/roguetown/adventurer/bluthund
	cmode_music = 'sound/music/combat_grenzelhoft.ogg'
	subclass_languages = list(/datum/language/grenzelhoftian)
	subclass_stats = list(//7 points total.
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/bluthund/pre_equip(mob/living/carbon/human/H)
	..()
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	wrists = wrists = /obj/item/clothing/wrists/roguetown/splintarms/iron
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	head = /obj/item/clothing/head/roguetown/grenzelhofthat
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	if(H.mind)
		var/grenzel_purpose = list("双手剑士","戟兵（长戟）","弩手（十字弩 + 单刃刀）", "鹰嘴锤")
		var/weapon_choice = input(H, "选择你的惯用兵器。", "契约既毁，祸亦随之") as anything in grenzel_purpose
		switch(weapon_choice)
			if("双手剑士")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
				r_hand = /obj/item/rogueweapon/greatsword/grenz
			if("戟兵（长戟）")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				r_hand = /obj/item/rogueweapon/halberd
			if("弩手（十字弩 + 单刃刀）")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/tracking, 3, TRUE)
				l_hand = /obj/item/rogueweapon/sword/long/kriegmesser
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/quiver/bolts
				beltr = /obj/item/rogueweapon/scabbard
				H.change_stat(STATKEY_STR, -1)
				H.change_stat(STATKEY_PER, 2) // so the boy can aim his crossbow and see further, maintain +7 stats total.
			if("鹰嘴锤")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				r_hand = /obj/item/rogueweapon/eaglebeak
/datum/advclass/foreigner/fencerguy
	name = "异乡剑客"
	tutorial = "你是一位四处游历的武器行家，曾在格伦泽尔霍夫的剑术学校受训。你随身带着武器、本领和自尊……坦白说，除此之外也没多少东西了。"
	extra_context = "这是一个玩法自由的职业，体验类似自由剑士。与其他职业相比，你的装备和技能较为有限，这是有意为之的设计；不过，你开局就有出色的武器。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/fencerguy
	subclass_languages = list(/datum/language/grenzelhoftian)
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	traits_applied = list(TRAIT_INTELLECTUAL, TRAIT_FENCERDEXTERITY)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 3,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE
	)

/datum/outfit/job/roguetown/adventurer/fencerguy/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是一位四处游历的武器行家，曾在格伦泽尔霍夫的剑术学校受训，随身带着武器、本领和自尊。"))
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("平衡长剑","长矛与拳刃","军刀")
		var/weapon_choice = input(H, "选择你擅长的武器。", "拿起武器") as anything in weapons
		switch(weapon_choice)
			if("平衡长剑")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/long/fencerguy
				r_hand = /obj/item/rogueweapon/huntingknife/combat
				backr = /obj/item/rogueweapon/scabbard/sword
			if("长矛与拳刃")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/rogueweapon/spear/boar
				r_hand = /obj/item/rogueweapon/katar/punchdagger
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("军刀")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/sabre
				r_hand = /obj/item/rogueweapon/huntingknife/idagger
				beltr = /obj/item/rogueweapon/scabbard/sword
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	neck = /obj/item/clothing/neck/roguetown/fencerguard/generic
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
		)
