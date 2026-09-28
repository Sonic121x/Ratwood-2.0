// 自定义冒险者子职业：临战女仆，归入战士分类。
/datum/advclass/z121_battle_maid
	name = "临战女仆"
	tutorial = "你曾经被主人训练成暗中保护少爷的棋子，你的存在意义就是即便面对十多人的时候也要牺牲自己换取少爷的安全，但那天真到来时，你不知何种缘由并未那样做，少爷死了，而你本该也死掉，却因一瞬间的贪生念头逃离地方，不管你曾经属于谁，至少现在你都自由了……"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/z121_battle_maid
	category_tags = list(CTAG_ADVENTURER)
	class_select_category = CLASS_CAT_WARRIOR
	subclass_social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_BREADY, TRAIT_OUTLANDER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "入局时可选择剑、锤、匕、斧、盾或长柄女仆，获得对应武器，并将对应技能提升至熟练（三级）；匕女仆额外获得双持者。"

/datum/outfit/job/roguetown/adventurer/z121_battle_maid
	head = /obj/item/clothing/head/roguetown/maidband
	neck = /obj/item/clothing/neck/roguetown/gorget
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	cloak = /obj/item/clothing/cloak/apron/maid
	armor = /obj/item/clothing/suit/roguetown/shirt/dress/maid
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	gloves = null
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/z121_battle_maid
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch = 1,
	)

/datum/outfit/job/roguetown/adventurer/z121_battle_maid/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	// 预览使用剑女仆装备，不弹出选择框或授予技能与特性。
	l_hand = /obj/item/rogueweapon/sword/long
	backl = /obj/item/rogueweapon/scabbard/sword
	if(visualsOnly || !H.mind)
		return

	var/list/maid_choices = list("剑女仆", "锤女仆", "匕女仆", "斧女仆", "盾女仆", "长柄女仆")
	var/maid_choice = input(H, "选择你曾受训的战斗专长。", "临战女仆") as anything in maid_choices
	if(QDELETED(H))
		return

	// 专长提供三级技能下限，不在基础等级上累加三级，也不降低已有技能。
	var/chosen_skill = /datum/skill/combat/swords
	switch(maid_choice)
		if("锤女仆")
			chosen_skill = /datum/skill/combat/maces
			l_hand = /obj/item/rogueweapon/mace/maul/grand
			backl = /obj/item/rogueweapon/scabbard/gwstrap
		if("匕女仆")
			chosen_skill = /datum/skill/combat/knives
			l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
			backl = /obj/item/rogueweapon/scabbard/sheath
			ADD_TRAIT(H, TRAIT_DUALWIELDER, ADVENTURER_TRAIT)
		if("斧女仆")
			chosen_skill = /datum/skill/combat/axes
			l_hand = /obj/item/rogueweapon/greataxe
			backl = /obj/item/rogueweapon/scabbard/gwstrap
		if("盾女仆")
			chosen_skill = /datum/skill/combat/shields
			l_hand = /obj/item/rogueweapon/shield/tower/metal
			// 盾牌没有配套刀鞘，左背位保持空置。
			backl = null
		if("长柄女仆")
			chosen_skill = /datum/skill/combat/polearms
			l_hand = /obj/item/rogueweapon/spear/trident
			backl = /obj/item/rogueweapon/scabbard/gwstrap
	H.adjust_skillrank_up_to(chosen_skill, SKILL_LEVEL_JOURNEYMAN, TRUE)

// 使用独立钱袋，确保初始金额为五至二十马蒙，不受普通穷人钱袋的双堆随机影响。
/obj/item/storage/belt/rogue/pouch/z121_battle_maid/Initialize(mapload)
	. = ..()
	var/obj/item/roguecoin/copper/coins = new(loc)
	coins.set_quantity(rand(5, 20))
	if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, coins, null, TRUE, TRUE))
		qdel(coins)
