// 自定义佣兵子职业：魔弓手。
// 通过佣兵标签注册，保留法师分栏，不改动主线职业定义。

/datum/advclass/z121_arcane_archer
	name = "魔弓手"
	tutorial = "家族盼你埋首于书页，你却总惦记着窗外的靶场。许多年里，指尖的墨迹与弓弦留下的薄茧相伴而生。如今，当你再次搭上弓弦，那些曾经拗口的咒文终于有了自己的去处。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/z121_arcane_archer
	category_tags = list(CTAG_MERCENARY)
	class_select_category = CLASS_CAT_MAGE
	subclass_social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(
		TRAIT_MAGEARMOR,
		TRAIT_DODGEEXPERT,
		TRAIT_ARCYNE_T2,
	)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
	)
	// 保留学徒奥术的学习点，三种专属箭术由职业直接授予。
	subclass_spellpoints = 10
	extra_context = "略通家传奥术，也熟悉林间的步伐。随身的黑角弓罕见箭羽，弦上却总有微光未散；至于那道最深的咒式，你向来不轻易念起。"

/datum/outfit/job/roguetown/adventurer/z121_arcane_archer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("离家时，你带走了那张黑角弓，也带走了几句没有写在书上的咒文。如今书房与靶场都已远去，唯有指尖的薄茧还记得弓弦该停在何处。"))
	for(var/spell_type in list(/obj/effect/proc_holder/spell/self/z121_arcane_archery/empower, /obj/effect/proc_holder/spell/self/z121_arcane_archery/tracking, /obj/effect/proc_holder/spell/self/z121_arcane_archery/heartpiercing))
		if(H.mind && !H.mind.has_spell(spell_type, TRUE))
			H.mind.AddSpell(new spell_type, H)

	// 按需求固定发放轻装弓术与学徒奥术混合配置。
	head = /obj/item/clothing/head/roguetown/roguehood/random
	cloak = /obj/item/clothing/cloak/raincloak/blue
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic
	backr = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/huntingknife/idagger
	beltr = null
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots

	// 挎包内只放题述指定的小件，避免超出用户给定的开局内容。
	backpack_contents = list(
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/chalk = 1,
		/obj/item/flashlight/flare/torch = 1,
	)
