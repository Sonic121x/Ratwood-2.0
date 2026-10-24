#define TRAIT_Z121_GUNSMITH "枪匠"

// 以工会工匠为基础调整枪匠的特质、技能和装备，出生配置独立以免授予工匠法术。
/datum/advclass/guildsman/artificer/z121_gunsmith
	name = "工会枪匠"
	maximum_possible_slots = 1
	outfit = /datum/outfit/job/roguetown/guildsman/z121_gunsmith
	tutorial = "你曾跟随经验丰富的枪匠学习锻造枪管、修整机匣与校准机括。后来，漂泊的生活将你带到了这里。此地的枪械技艺早已凋零，尚存的火器多靠修补勉强维持，能够制造它们的人更是寥寥无几。为了谋生，也为了不让这门手艺失传，你加入工会，重新拿起工具，让炉火与敲击声再次唤醒那些几乎被遗忘的技艺。"

/datum/advclass/guildsman/artificer/z121_gunsmith/New()
	. = ..()
	// 复制继承的列表，仅调整枪匠，不改动原工会工匠的特质和技能。
	traits_applied = traits_applied.Copy()
	traits_applied -= list(TRAIT_ARCYNE, TRAIT_MASTER_CARPENTER, TRAIT_MASTER_MASON)
	traits_applied |= TRAIT_Z121_GUNSMITH
	subclass_skills = subclass_skills.Copy()
	subclass_skills[/datum/skill/craft/masonry] = SKILL_LEVEL_JOURNEYMAN
	subclass_skills[/datum/skill/craft/carpentry] = SKILL_LEVEL_JOURNEYMAN
	subclass_skills[/datum/skill/craft/ceramics] = SKILL_LEVEL_JOURNEYMAN

// 与工会工匠配置并列，沿用基础出生处理，不调用会授予四项法术的工匠配置。
/datum/outfit/job/roguetown/guildsman/z121_gunsmith/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/articap
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	cloak = /obj/item/clothing/cloak/apron/waist/brown
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	pants = /obj/item/clothing/under/roguetown/trou/artipants
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/pick/steel
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter
	// 保留工匠的其他随身物品，移除染色刷、吹玻璃杆和陶艺配方书。
	backpack_contents = list(
		/obj/item/rogueweapon/hammer/steel = 1,
		/obj/item/rogueweapon/chisel = 1,
		/obj/item/rogueweapon/handsaw = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/recipe_book/blacksmithing = 1,
		/obj/item/recipe_book/engineering = 1,
		/obj/item/recipe_book/builder = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/contraption/linker = 1,
		/obj/item/mini_flagpole/artificer = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/mini_flagpole/blacksmith = 1,
		/obj/item/roguekey/crafterguild = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/flint = 1,
	)
	if(SSmapping.current_map.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/sandals

/datum/job/roguetown/guildsman/New()
	. = ..()
	job_subclasses = job_subclasses.Copy()
	job_subclasses |= /datum/advclass/guildsman/artificer/z121_gunsmith

/proc/register_z121_gunsmith_trait()
	GLOB.roguetraits[TRAIT_Z121_GUNSMITH] = span_info("我掌握枪械制造技艺，能够辨识并制作精密的枪械零件，理解各种枪械机括的结构与装配原理。")
