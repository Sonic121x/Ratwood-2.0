//Unarmed central, with a singular exception.
//These guys get some absurd power.
/datum/advclass/disciple
	name = "门徒"
	tutorial = "你是 普赛顿 的修士，既通武艺，也习经文。神职者将圣地流血视作一种“罪”，但若只是把人打得不省人事，他们可不会有半点顾忌。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/disciple
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/psydonite.ogg'
	category_tags = list(CTAG_INQUISITION)
	traits_applied = list(
		TRAIT_CIVILIZEDBARBARIAN,
		TRAIT_CICERONE,//brewer monks and such, lets them see the booze they make.
	)
	subclass_stats = list(//(str 3(weighted 6) + wil 3 + con 3) = 12 - (INT -1 + SPD -1 (weighted -2) = 9 weighted stats. Old statblock was weighted 6 because morons dont know the stat weight rules for spd and str.
		STATKEY_STR = 3,
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_INT = -1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,//lets them brew booze like a trappist monk, soulful.
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"《Psydon 圣典》" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "该子职业可从多种修行路数中择一。你所选的路数离徒手格斗越远，你在拳斗与摔跤上的造诣就会萎缩得越厉害。若选择四分杖，则会小幅提升感知与智力，但会失去“重创抗性”特质。"

/datum/outfit/job/roguetown/disciple
	job_bitflag = BITFLAG_HOLY_WARRIOR

/obj/item/storage/belt/rogue/leather/rope/dark
	color = "#505050"

/datum/outfit/job/roguetown/disciple/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	var/devotion_gain = CLERIC_REGEN_WEAK
	var/devotion_limit = CLERIC_REQ_1
	if(H.has_flaw(/datum/charflaw/addiction/alcoholic))//THE LEADER OF THE EIGHT ENDURING FISTS SWAYED BACK AND FORTH TO TRICK THE HERETICS, DRUNK WITH INTERNAL FIRE. THEY WERE BUT FROGS IN A WELL LOOKING UP AT THE NIGHT SKY THINKING THEY HAD REACHED THE HEAVENS.
		ADD_TRAIT(H, TRAIT_DRUNK_HEALING, TRAIT_GENERIC)
	if(H.mind)
		var/weapons = list("护教者 - 精通拳斗，戒武誓约且无减值", "拳斗士 - 精通运动，痛苦抵抗", "四分杖 - 专家长柄，+1感知/+1智力")
		var/weapon_choice = input(H,"选择你的武器。", "执起普赛顿的兵刃。") as anything in weapons
		switch(weapon_choice)
			if("护教者 - 精通拳斗，戒武誓约且无减值")//the enduringest psychud. Weighted 12 stats but no weapons, period.
				devotion_gain = CLERIC_REGEN_MINOR
				devotion_limit = CLERIC_REQ_2
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)//dreamwalkers HATE the aquatic punch monk.
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/magic/holy, SKILL_LEVEL_JOURNEYMAN, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
				ADD_TRAIT(H, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_WEAPONLESS, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_STRONGBITE, TRAIT_GENERIC)//bite the necromancer's nose and ears off for Psydon.
				H.change_stat(STATKEY_INT, 1)
				H.change_stat(STATKEY_SPD, 1)
			if("拳斗士 - 精通运动，痛苦抵抗")//classic disciple but with the weapon choices not being a noob trap that debuffs you for grabbing a weapon you can make with 1 bullion roundstart.
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
				ADD_TRAIT(H, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
				var/pugtype = list("拳刃", "指虎")
				var/pug_choice = input(H,"选择你的拳斗武器。", "执起普赛顿的兵刃。") as anything in pugtype
				switch(pug_choice)
					if("拳刃")
						r_hand = /obj/item/rogueweapon/katar/psydon
					if("指虎")
						r_hand = /obj/item/rogueweapon/knuckles/psydon
			if("四分杖 - 专家长柄，+1感知/+1智力")//stave user but with no int and per malus so they dont get folded.
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/psy
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted//no pugulist gloves for you sire, you have a staff.
				H.change_stat(STATKEY_PER, 1)
				H.change_stat(STATKEY_INT, 1)

	head = /obj/item/clothing/head/roguetown/roguehood/psydon
	mask = /obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns
	wrists = /obj/item/clothing/wrists/roguetown/bracers/psythorns
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	id = /obj/item/clothing/ring/signet/silver
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	backpack_contents = list(/obj/item/roguekey/inquisition = 1,
	/obj/item/paper/inqslip/arrival/ortho = 1)
	belt = /obj/item/storage/belt/rogue/leather/rope/dark
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	cloak = /obj/item/clothing/cloak/psydontabard/alt

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(
		H,
		cleric_tier = CLERIC_T2,//locked tier 2, but can have variable devotion gain and limit based on weapon choice.
		passive_gain = devotion_gain,
		devotion_limit = devotion_limit,
	)
