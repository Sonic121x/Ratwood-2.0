/datum/job/roguetown/lady
	title = "Consort"
	display_title = "王配"
	f_title = "王妃"
	flag = LADY
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	advclass_cat_rolls = list(CTAG_CONSORT = 20)

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	tutorial = "无论是出于爱情、权谋还是机巧，通过这场婚姻，你成了大公最信任的知己——也许甚至还是朋友。今日，你的忠诚，乃至你的爱意，都将遭受考验……因为那些指向你所爱之人的匕首，同样也正抵在你的喉头。"

	spells = list(/obj/effect/proc_holder/spell/self/convertrole/servant,
	/obj/effect/proc_holder/spell/self/grant_nobility)
	outfit = /datum/outfit/job/roguetown/lady

	display_order = JDO_LADY
	give_bank_account = 50
	noble_income = 22
	min_pq = 5
	max_pq = null
	round_contrib_points = 3
	social_rank = SOCIAL_RANK_NOBLE
	advjob_examine = TRUE
	job_subclasses = list(
		/datum/advclass/lady/heartthrob,
		/datum/advclass/lady/housespouse,
		/datum/advclass/lady/trophy
	)

/datum/advclass/lady/heartthrob
// swords-themed consort. since there's only one of them, it's better than suitor and prince. this will be a running theme.
	name = "意中人"
	tutorial = "你曾是一名剑士。无论是凭战场上的功勋，还是凭一身胆气，你都赢得了大公的心。\
	你的剑技或许已随时间生疏，但你依然足以让任何胆敢行刺之人明白，何为「至死不渝」。"
	outfit = /datum/outfit/job/roguetown/lady/heartthrob
	category_tags = list(CTAG_CONSORT)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_KEENEARS, TRAIT_DECEIVING_MEEKNESS, TRAIT_NOBLE)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_WIL = 2,
		STATKEY_SPD = 3,
		STATKEY_STR = -1,
		STATKEY_LCK = 3,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/lady/heartthrob/pre_equip(mob/living/carbon/human/H) //tbd - ideally i don't want them to start with fantastic armor, but there's very little choice in medium armors. maybe i'll switch them to light instead?
	..()
	head = /obj/item/clothing/head/roguetown/nyle/consortcrown
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/storage/keyring/royal
	beltr = /obj/item/rogueweapon/scabbard/sword/noble
	backr = /obj/item/storage/backpack/rogue/satchel
	l_hand = /obj/item/rogueweapon/sword/rapier/dec
	id = /obj/item/scomstone/garrison
	if(should_wear_femme_clothes(H))
		cloak = /obj/item/clothing/cloak/lordcloak/ladycloak
		armor = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
	else if(should_wear_masc_clothes(H))
		cloak = /obj/item/clothing/cloak/darkcloak/bear
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
//		SSticker.rulermob = H

/datum/advclass/lady/trophy
// This is just the regular Consort as it is right now, along with the ridiculous 15 points of extra stats.
	name = "战利品"
	tutorial = "你曾是有头有脸的人物——贵族、使节、求亲者。而今，或为政治，或为利益，\
	或仅仅为了保住你自己——或是你爱人的——性命，你不过是挂在大公臂弯上的门面。\
	对民众微笑，对人群挥手，于暗处谋划。"
	outfit = /datum/outfit/job/roguetown/lady/trophy
	category_tags = list(CTAG_CONSORT)
	traits_applied = list(TRAIT_SEEPRICES, TRAIT_KEENEARS, TRAIT_LIGHT_STEP, TRAIT_NUTCRACKER, TRAIT_NOBLE)
	subclass_stats = list( // 10 stats total, 7 without the carrot. based on consort's current stat block.
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 2,
		STATKEY_LCK = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/lady/trophy/pre_equip(mob/living/carbon/human/H) //tbd - though this might just be fine as is, considering it's base consort
	..()
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	head = /obj/item/clothing/head/roguetown/nyle/consortcrown
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	beltl = /obj/item/storage/keyring/royal
	beltr = /obj/item/rogueweapon/scabbard/sheath
	id = /obj/item/scomstone/garrison
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
		pants = /obj/item/clothing/under/roguetown/trou/formal/shorts
		cloak = /obj/item/clothing/cloak/lordcloak/ladycloak
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
		cloak = /obj/item/clothing/cloak/darkcloak/bear
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/medicine,
		/obj/item/lockpick/goldpin,
	)
//		SSticker.rulermob = H

/datum/advclass/lady/housespouse
// Housewife RP class. 15 points of stats along with trophy because why not, honestly.
	name = "持家者"
	tutorial = "凭借你体贴的性情与尽责的天性，你以自己最擅长的方式照料着你的爱人与孩子。你很清楚，你爱人的宅邸里仆从众多，做饭打扫都不缺人手，但你并不在意。毕竟，用爱做出来的食物，味道要好得多。"
	outfit = /datum/outfit/job/roguetown/lady/housespouse
	category_tags = list(CTAG_CONSORT)
	traits_applied = list(TRAIT_CICERONE, TRAIT_SEEDKNOW, TRAIT_KEENEARS, TRAIT_GOODLOVER, TRAIT_HOMESTEAD_EXPERT, TRAIT_SEWING_EXPERT, TRAIT_NOBLE)
	subclass_stats = list( //10 stats total, 7 without carrot. based on senechal. high int for skill progression and crafting %
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
		STATKEY_STR = 1,
		STATKEY_LCK = 3,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN, //so they can tend to their lovely garden ofc
	)

/datum/outfit/job/roguetown/lady/housespouse/pre_equip(mob/living/carbon/human/H) //tbd - something cute and homely but still noble.
	..()
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	head = /obj/item/clothing/head/roguetown/nyle/consortcrown
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	beltl = /obj/item/storage/keyring/royal
	id = /obj/item/scomstone/garrison
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/cooking/pan
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
		pants = /obj/item/clothing/under/roguetown/trou/formal/shorts
		cloak = /obj/item/clothing/cloak/lordcloak/ladycloak
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
		cloak = /obj/item/clothing/cloak/darkcloak/bear
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/scissors/steel,
		/obj/item/needle,
		/obj/item/kitchen/rollingpin,
		/obj/item/rogueweapon/huntingknife/cleaver,
	)
//		SSticker.rulermob = H

/datum/job/roguetown/exlady
	title = "Consort Dowager"
	flag = LADY
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	display_order = JDO_LADY
	give_bank_account = TRUE
	social_rank = SOCIAL_RANK_NOBLE // I mean I guess

/datum/outfit/job/roguetown/lady
	job_bitflag = BITFLAG_ROYALTY

/obj/effect/proc_holder/spell/self/convertrole/servant
	name = "征募仆役"
	new_role = "Servant"
	overlay_state = "recruit_servant"
	recruitment_faction = "Servants"
	recruitment_message = "为王冠效命吧，%RECRUIT！"
	accept_message = "为了王冠！"
	refuse_message = "我拒绝。"
	recharge_time = 100

