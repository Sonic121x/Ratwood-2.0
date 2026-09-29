// 职业选项和服装数据的模块内适配；准备过程只写入草案，不改变角色。
// 由同目录维护脚本提取，更新上游职业后需重新核对这些适配。

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/artificer.dm
/datum/outfit/job/roguetown/adventurer/artificer/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	head = /obj/item/clothing/head/roguetown/articap
	armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/rogueweapon/hammer/steel = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/recipe_book/blacksmithing = 1,
		/obj/item/recipe_book/engineering = 1,
		/obj/item/recipe_book/ceramics = 1,
		/obj/item/recipe_book/builder = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/clothing/mask/rogue/spectacles/golden = 1,
		/obj/item/contraption/linker = 1,
		/obj/item/rogueweapon/chisel = 1,
		/obj/item/rogueweapon/handsaw = 1,
	)

	if(H.mind)
		P.add_spell(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		P.add_spell(/obj/effect/proc_holder/spell/invoked/enchant_weapon)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/barbersurgeon.dm
/datum/outfit/job/roguetown/adventurer/doctor/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	mask = /obj/item/clothing/mask/rogue/spectacles
	head = /obj/item/clothing/head/roguetown/nightman
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/physician
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/surgery_bag/full
	beltr = /obj/item/rogueweapon/huntingknife/cleaver
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	backl = /obj/item/storage/backpack/rogue/backpack
	if(SSmapping.current_map.map_name == "Desert Town")
		head = /obj/item/clothing/head/roguetown/turban
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb

	backpack_contents = list(
						/obj/item/natural/worms/leech/cheele = 1,
						/obj/item/natural/cloth = 2,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/huntingknife/scissors/steel = 1,
						/obj/item/hair_dye_cream = 3,
						/obj/item/heart_blood_canister/filled = 2,
						/obj/item/bait/leech = 4
						)
	if(H.age == AGE_OLD)
		P.add_stat(STATKEY_SPD, -1)
		P.add_stat(STATKEY_INT, 1)
		P.add_stat(STATKEY_PER, 1)
		P.skill_floor(/datum/skill/misc/medicine, 6, TRUE)
		P.skill_floor(/datum/skill/craft/alchemy, 4, TRUE)
	if(H.mind)
		P.add_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/blacksmith.dm
/datum/outfit/job/roguetown/adventurer/blacksmith/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/hammer/iron
	beltl = /obj/item/rogueweapon/tongs
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	cloak = /obj/item/clothing/cloak/apron/blacksmith
	mouth = /obj/item/rogueweapon/huntingknife
	pants = /obj/item/clothing/under/roguetown/trou
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/scabbard/sheath
	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/rogueore/coal = 4,
		/obj/item/rogueore/iron = 5,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/blacksmithing = 1,
		/obj/item/armor_brush = 1,
		/obj/item/polishing_cream = 1
		)

	if(H.mind)
		var/molds = list(
			"铁剑模具" = /obj/item/mold/sword,
			"铁斧模具" = /obj/item/mold/axe,
			"铁锤模具" = /obj/item/mold/mace,
			"铁刀模具" = /obj/item/mold/knife,
			"铁制长柄武器模具" = /obj/item/mold/polearm,
			"铁板模具" = /obj/item/mold/plate
		)
		var/mold_names = list()
		for (var/name in molds)
			mold_names += name
		for (var/i = 1 to 2)
			var/mold_choice = P.choose(mold_names, "选择你的初始模具", "选择")
			if(P.cancelled)
				return
			if (i == 1)
				l_hand = molds[mold_choice]
			else
				r_hand = molds[mold_choice]

	if(H.pronouns == HE_HIM)
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	if(SSmapping.current_map.map_name == "Desert Town")
		pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
		head = /obj/item/clothing/head/roguetown/turban/random
		shoes = /obj/item/clothing/shoes/roguetown/sandals

	if(H.age == AGE_MIDDLEAGED)
		P.skill_floor(/datum/skill/craft/blacksmithing, 5, TRUE)
		P.skill_floor(/datum/skill/craft/armorsmithing, 5, TRUE)
		P.skill_floor(/datum/skill/craft/weaponsmithing, 5, TRUE)
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/craft/blacksmithing, 6, TRUE)
		P.skill_floor(/datum/skill/craft/armorsmithing, 6, TRUE)
		P.skill_floor(/datum/skill/craft/weaponsmithing, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/builder.dm
/datum/outfit/job/roguetown/adventurer/builder/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	head = /obj/item/clothing/head/roguetown/hatblu
	mask = /obj/item/clothing/mask/rogue/spectacles/golden
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	cloak = /obj/item/clothing/cloak/apron/waist/bar
	pants = /obj/item/clothing/under/roguetown/trou
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	beltl = /obj/item/rogueweapon/pick
	backr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/rogueweapon/hammer/steel = 1,
						/obj/item/rogueweapon/handsaw = 1,
						/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
						/obj/item/rogueweapon/chisel = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/flint = 1,
						/obj/item/rogueweapon/huntingknife = 1,
						/obj/item/rogueweapon/handsaw = 1,
						/obj/item/dye_brush = 1,
						/obj/item/roguekey/crafterguild = 1,
						/obj/item/rogueweapon/blowrod = 1,
						/obj/item/clothing/mask/rogue/spectacles/golden = 1,
						)
	if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
	else
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
		pants = /obj/item/clothing/under/roguetown/trou
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	if(H.age == AGE_MIDDLEAGED)
		P.skill_floor(/datum/skill/craft/carpentry, 5, TRUE)
		P.skill_floor(/datum/skill/craft/masonry, 5, TRUE)
		P.skill_floor(/datum/skill/craft/engineering, 4, TRUE)
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/craft/carpentry, 6, TRUE)
		P.skill_floor(/datum/skill/craft/masonry, 6, TRUE)
		P.skill_floor(/datum/skill/craft/engineering, 5, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/cheesemaker.dm
/datum/outfit/job/roguetown/adventurer/cheesemaker/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	mouth = /obj/item/rogueweapon/huntingknife
	belt = /obj/item/storage/belt/rogue/leather
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		pants = /obj/item/clothing/under/roguetown/skirt/random
	else if(should_wear_masc_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	head = /obj/item/clothing/head/roguetown/cookhat
	cloak = /obj/item/clothing/cloak/apron
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	backl = /obj/item/storage/backpack/rogue/backpack
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltl = /obj/item/flint
	beltr = /obj/item/rogueweapon/scabbard/sheath
	if(SSmapping.current_map.map_name == "Desert Town")
		pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
		shoes = /obj/item/clothing/shoes/roguetown/sandals
	backpack_contents = list(
		/obj/item/reagent_containers/powder/salt = 3,
		/obj/item/reagent_containers/food/snacks/rogue/cheddar = 2,
		/obj/item/reagent_containers/glass/bottle/waterskin,
		/obj/item/reagent_containers/food/snacks/grown/wheat = 6,
		/obj/item/natural/cloth = 2,
		/obj/item/book/rogue/yeoldecookingmanual = 1,
		)
	r_hand = /obj/item/flashlight/flare/torch
	if(H.age == AGE_MIDDLEAGED)
		P.skill_floor(/datum/skill/craft/cooking, 5, TRUE)
		P.skill_floor(/datum/skill/labor/farming, 3, TRUE)
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/craft/cooking, 6, TRUE)
		P.skill_floor(/datum/skill/labor/farming, 4, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/drunkard.dm
/datum/outfit/job/roguetown/adventurer/drunkard/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	pants = /obj/item/clothing/under/roguetown/tights/vagrant
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/clothing/mask/cigarette/rollie/cannabis
	beltl = /obj/item/flint
	if(SSmapping.current_map.map_name == "Desert Town")
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
		shoes = /obj/item/clothing/shoes/roguetown/shalal
	backpack_contents = list(
						/obj/item/storage/pill_bottle/dice = 1,
						/obj/item/storage/pill_bottle/dice/farkle = 1,
						/obj/item/reagent_containers/glass/cup = 1,
						/obj/item/toy/cards/deck = 1,
						/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
						/obj/item/flashlight/flare/torch = 1,
						)
	P.add_trait(TRAIT_CRACKHEAD)

	if(H.age == AGE_MIDDLEAGED)
		P.skill_floor(/datum/skill/misc/stealing, 5, TRUE)
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/misc/stealing, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/fisher.dm
/datum/outfit/job/roguetown/adventurer/fisher/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/labor/fishing, SKILL_LEVEL_MASTER, TRUE)
	else
		P.skill_floor(/datum/skill/labor/fishing, SKILL_LEVEL_EXPERT, TRUE)
	if(H.pronouns == HE_HIM || H.pronouns == THEY_THEM || H.pronouns == IT_ITS)
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		neck = /obj/item/storage/belt/rogue/pouch/coins/poor
		head = /obj/item/clothing/head/roguetown/fisherhat
		mouth = /obj/item/rogueweapon/huntingknife
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
		backl = /obj/item/storage/backpack/rogue/satchel
		belt = /obj/item/storage/belt/rogue/leather
		backr = /obj/item/fishingrod
		beltr = /obj/item/cooking/pan
		beltl = /obj/item/flint
		backpack_contents = list(
							/obj/item/natural/worms = 2,
							/obj/item/rogueweapon/shovel/small = 1,
							/obj/item/flashlight/flare/torch = 1,
							/obj/item/rogueweapon/scabbard/sheath = 1
							)
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		neck = /obj/item/storage/belt/rogue/pouch/coins/poor
		head = /obj/item/clothing/head/roguetown/fisherhat
		mouth = /obj/item/rogueweapon/huntingknife
		backl = /obj/item/storage/backpack/rogue/satchel
		belt = /obj/item/storage/belt/rogue/leather
		backr = /obj/item/fishingrod
		beltr = /obj/item/cooking/pan
		beltl = /obj/item/flint
		backpack_contents = list(
							/obj/item/natural/worms = 2,
							/obj/item/rogueweapon/shovel/small = 1,
							/obj/item/flashlight/flare/torch = 1,
							/obj/item/rogueweapon/scabbard/sheath = 1,
							/obj/item/mini_flagpole/fisher
							)
	if(SSmapping.current_map.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/sandals
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/random
	if(H.age == AGE_MIDDLEAGED)
		P.skill_floor(/datum/skill/labor/fishing, 5, TRUE)
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/labor/fishing, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/homesteader.dm
/datum/outfit/job/roguetown/homesteader/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	var/cosmetic_titles = list(
	"垂钓者",
	"工艺师", "女工艺师",
	"屠夫",
	"工匠", "女工匠",
	"虔信者", "女虔信者",
	"农工",
	"采集者",
	"护林人",
	"自耕农",
	"园丁",
	"杂务工",
	"乡野居民",
	"草药师",
	"拓荒农", "女拓荒农",
	"家政工",
	"户主", "家庭主夫", "家庭主妇",
	"猎人",
	"劳工",
	"年轻贵族",
	"石匠",
	"护理员", "修女",
	"望族",
	"开拓者",
	"勘探者",
	"学者",
	"抄写员",
	"贵族后裔",
	"定居者",
	"牧羊人",
	"铁匠",
	"城镇医生",
	"城镇游侠",
	"手艺商人", "女手艺商人",
	"仆役",
	"村民",
	"织工",
	"平民姑娘",
	"林地居民", "林地女居民",
	"外科医师",
	"平民姑娘", "仆役")
	var/cosmetic_choice = P.choose(cosmetic_titles, "选择你的外观头衔。", "外观头衔")
	if(P.cancelled)
		return

	switch(cosmetic_choice)
		if("虔信者")
			P.cosmetic_title = "虔信者"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("女虔信者")
			P.cosmetic_title = "女虔信者"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("农工")
			P.cosmetic_title = "农工"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("女农工")
			P.cosmetic_title = "女农工"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("杂务工")
			P.cosmetic_title = "杂务工"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("女杂务工")
			P.cosmetic_title = "女杂务工"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("乡野居民")
			P.cosmetic_title = "乡野居民"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("草药师")
			P.cosmetic_title = "草药师"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("拓荒农")
			P.cosmetic_title = "拓荒农"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("女拓荒农")
			P.cosmetic_title = "女拓荒农"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("户主")
			P.cosmetic_title = "户主"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("家庭主夫")
			P.cosmetic_title = "家庭主夫"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("家庭主妇")
			P.cosmetic_title = "家庭主妇"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("猎人")
			P.cosmetic_title = "猎人"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("劳工")
			P.cosmetic_title = "劳工"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("年轻贵族")
			P.cosmetic_title = "年轻贵族"
			P.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("女劳工")
			P.cosmetic_title = "女劳工"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("村民")
			P.cosmetic_title = "村民"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("女村民")
			P.cosmetic_title = "女村民"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("工艺师")
			P.cosmetic_title = "工艺师"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("女工艺师")
			P.cosmetic_title = "女工艺师"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("望族")
			P.cosmetic_title = "望族"
			P.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("贵族后裔")
			P.cosmetic_title = "贵族后裔"
			P.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("开拓者")
			P.cosmetic_title = "开拓者"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("女开拓者")
			P.cosmetic_title = "女开拓者"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("定居者")
			P.cosmetic_title = "定居者"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("女定居者")
			P.cosmetic_title = "女定居者"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("手艺商人")
			P.cosmetic_title = "手艺商人"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("女手艺商人")
			P.cosmetic_title = "女手艺商人"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("仆役")
			P.cosmetic_title = "仆役"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("村民")
			P.cosmetic_title = "村民"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("女村民")
			P.cosmetic_title = "女村民"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("织工")
			P.cosmetic_title = "织工"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("平民姑娘")
			P.cosmetic_title = "平民姑娘"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("林地居民")
			P.cosmetic_title = "林地居民"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("林地女居民")
			P.cosmetic_title = "林地女居民"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("工匠")
			P.cosmetic_title = "工匠"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("女工匠")
			P.cosmetic_title = "女工匠"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("采集者")
			P.cosmetic_title = "采集者"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("护理员")
			P.cosmetic_title = "护理员"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("修女")
			P.cosmetic_title = "修女"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("外科医师")
			P.cosmetic_title = "外科医师"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("垂钓者")
			P.cosmetic_title = "垂钓者"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("织工")
			P.cosmetic_title = "织工"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("石匠")
			P.cosmetic_title = "石匠"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("护林人")
			P.cosmetic_title = "护林人"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("城镇游侠")
			P.cosmetic_title = "城镇游侠"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("勘探者")
			P.cosmetic_title = "勘探者"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("自耕农")
			P.cosmetic_title = "自耕农"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("家政工")
			P.cosmetic_title = "家政工"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("城镇医生")
			P.cosmetic_title = "城镇医生"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("抄写员")
			P.cosmetic_title = "抄写员"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("贵族后裔")
			P.cosmetic_title = "贵族后裔"
			P.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("学者")
			P.cosmetic_title = "学者"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("屠夫")
			P.cosmetic_title = "屠夫"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("园丁")
			P.cosmetic_title = "园丁"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("牧羊人")
			P.cosmetic_title = "牧羊人"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("铁匠")
			P.cosmetic_title = "铁匠"
			P.social_rank = SOCIAL_RANK_YEOMAN
		if("平民姑娘")
			P.cosmetic_title = "平民姑娘"
			P.social_rank = SOCIAL_RANK_PEASANT
		if("仆役")
			P.cosmetic_title = "仆役"
			P.social_rank = SOCIAL_RANK_PEASANT

	var/stat_packs = list("敏捷——速度 +2，体质 +1，力量 -1，意志 -1", "书痴——智力 +1，感知 +2，意志 +2，力量 -2，体质 -2", "健壮——力量 +1，体质 +1，意志 +1，智力 -1", "均衡——属性不变")
	var/stat_choice = P.choose(stat_packs, "选择你的属性倾向。[1/1]", "属性组合选择")
	if(P.cancelled)
		return

	switch(stat_choice)
		if("敏捷——速度 +2，体质 +1，力量 -1，意志 -1")
			P.add_stat(STATKEY_SPD, 2)
			P.add_stat(STATKEY_WIL, -1)
			P.add_stat(STATKEY_STR, -1)
			P.add_stat(STATKEY_CON, 1)
		if("书痴——智力 +1，感知 +2，意志 +2，力量 -2，体质 -2")
			P.add_stat(STATKEY_INT, 1)
			P.add_stat(STATKEY_PER, 2)
			P.add_stat(STATKEY_WIL, 2)
			P.add_stat(STATKEY_STR, -2)
			P.add_stat(STATKEY_CON, -2)
		if("健壮——力量 +1，体质 +1，意志 +1，智力 -1")
			P.add_stat(STATKEY_STR, 1)
			P.add_stat(STATKEY_CON, 1)
			P.add_stat(STATKEY_WIL, 1)
			P.add_stat(STATKEY_INT, -1)
		if("均衡——属性不变")
			P.cancelled = FALSE

	var/profession_sets = list(
		"医师套装" = list(
			/obj/item/bedroll,
			/obj/item/rogueweapon/huntingknife/scissors,
			/obj/item/storage/belt/rogue/surgery_bag/full,
			/obj/item/storage/belt/rogue/pouch/medicine,
			/obj/effect/proc_holder/spell/invoked/diagnose/secular,
			/obj/item/storage/magebag/alchemist,
			/obj/item/folding_table_stored
		),
		"补给者套装" = list(
			/obj/item/storage/roguebag/food,
			/obj/item/folding_table_stored,
			/obj/item/storage/meatbag,
			/obj/item/millstone,
			/obj/item/rogueweapon/hoe
		),
		"勘探者套装" = list(
			/obj/item/rogueweapon/hammer/steel,
			/obj/item/folding_table_stored,
			/obj/item/lockpickring/mundane,
			/obj/item/rogueweapon/pick,
			/obj/item/rogueweapon/huntingknife/scissors,
			/obj/item/rogueweapon/scabbard/gwstrap
		),
		"铁匠套装" = list(
			/obj/item/rogueweapon/hammer/copper,
			/obj/item/rogueweapon/tongs,
			/obj/item/rogueweapon/huntingknife/bronze,
			/obj/item/ingot/iron,
			/obj/item/ingot/iron,
			/obj/item/rogueore/coal
		),
		"工匠套装" = list(
			/obj/item/rogueweapon/stoneaxe/handaxe,
			/obj/item/rogueweapon/hammer/steel,
			/obj/item/folding_table_stored
		),
		"猎人套装" = list(
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow,
			/obj/item/quiver/arrows,
			/obj/item/rogueweapon/huntingknife/bronze,
			/obj/item/storage/meatbag,
			/obj/item/natural/worms,
			/obj/item/natural/worms
		),
		"渔夫套装" = list(
			/obj/item/fishingrod,
			/obj/item/natural/worms,
			/obj/item/natural/worms,
			/obj/item/natural/worms,
			/obj/item/rogueweapon/huntingknife/bronze,
			/obj/item/storage/roguebag
		),
		"裁缝套装" = list(
			/obj/item/rogueweapon/huntingknife/scissors,
			/obj/item/needle,
			/obj/item/natural/cloth,
			/obj/item/natural/cloth,
			/obj/item/natural/cloth,
			/obj/item/natural/bundle/fibers
		),
		"抄写员套装" = list(
			/obj/item/paper,
			/obj/item/paper,
			/obj/item/paper,
			/obj/item/paper/scroll,
			/obj/item/natural/feather
		)
	)

	var/daily_tools_combos = list(
		"青铜斧 + 青铜刀 + 刀鞘" = list(/obj/item/rogueweapon/stoneaxe/woodcut/bronze, /obj/item/rogueweapon/huntingknife/bronze, /obj/item/rogueweapon/scabbard/sheath),
		"简易弓 + 箭袋" = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow, /obj/item/quiver/arrows),
		"铁矛 + 备用匕首" = list(/obj/item/rogueweapon/spear, /obj/item/rogueweapon/huntingknife/bronze, /obj/item/rogueweapon/scabbard/gwstrap),
		"钓竿 + 蚯蚓" = list(/obj/item/fishingrod, /obj/item/natural/worms, /obj/item/natural/worms),
		"镰刀 + 农用锄" = list(/obj/item/rogueweapon/sickle, /obj/item/rogueweapon/hoe),
		"矿镐 + 铜锤" = list(/obj/item/rogueweapon/pick, /obj/item/rogueweapon/hammer/copper),
		"短棍 + 绳索" = list(/obj/item/rogueweapon/mace/cudgel, /obj/item/rope, /obj/item/rope)
	)

	if(H.mind)

		for(var/i in 1 to 1)
			var/profession_set_name = P.choose(profession_sets, "选择一套职业装备。[i]/1", "职业装备")
			if(P.cancelled)
				return
			if(profession_set_name)
				var/profession_list = profession_sets[profession_set_name]
				var/counter = 1
				for(var/item_path in profession_list)
					if(ispath(item_path, /obj/effect/proc_holder/spell))

						P.add_spell(item_path)
					else

						var/item_name = initial(item_path:name)
						var/unique_key = "[item_name] ([profession_set_name] [counter])"
						P.stash[unique_key] = item_path
					counter++
				if(profession_set_name == "工匠套装")
					P.add_trait(TRAIT_MASTER_CARPENTER)
					P.add_trait(TRAIT_MASTER_MASON)
				if(profession_set_name in profession_sets)
					profession_sets -= profession_set_name

		var/combo_name = P.choose(daily_tools_combos, "选择一组日常工具。[1/1]", "日常工具")
		if(P.cancelled)
			return
		if(combo_name)
			var/combo_list = daily_tools_combos[combo_name]
			var/counter = 1
			for(var/item_path in combo_list)
				var/item_name = initial(item_path:name)
				var/unique_key = "[item_name] ([combo_name] [counter])"
				P.stash[unique_key] = item_path
				counter++

	var/outfit_styles = list(
		"劳工——工人背心、长裤、靴子",
		"农工——草帽、短衫、长裤",
		"林地居民——兜帽、工人背心、护腕",
		"渔夫——渔夫帽、短衫、工作背心",
		"工艺师——束腰外衣、紧身裤、毛皮斗篷",
		"缝纫师——护甲裙、白色束腰外衣、布腰带",
		"旅人——短斗篷、内衫、靴子",
		"乡民——毛皮帽、短衫、皮靴",
		"矿工——武装帽、长裤、工作背心",
		"艺人——华丽帽子、束腰外衣、短斗篷",
		"朴素学者——眼镜、学者长袍、包头帽",
		"乡村风格——草帽、衬裙、短靴"
	)

	var/outfit_choice = P.choose(outfit_styles, "选择你的服装风格。", "服装选择")
	if(P.cancelled)
		return

	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor

	switch(outfit_choice)
		if("劳工——工人背心、长裤、靴子")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
				head = /obj/item/clothing/head/roguetown/roguehood/random
			else
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
				pants = /obj/item/clothing/under/roguetown/trou
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
				head = /obj/item/clothing/head/roguetown/armingcap

		if("农工——草帽、短衫、长裤")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				pants = /obj/item/clothing/under/roguetown/trou
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/strawhat

		if("林地居民——兜帽、工人背心、护腕")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			else
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
				pants = /obj/item/clothing/under/roguetown/trou
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/roguehood
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather

		if("渔夫——渔夫帽、短衫、工作背心")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
			else
				pants = /obj/item/clothing/under/roguetown/tights/random
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/fisherhat

		if("工艺师——束腰外衣、紧身裤、毛皮斗篷")
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			cloak = /obj/item/clothing/cloak/raincloak/furcloak
			head = /obj/item/clothing/head/roguetown/hatblu

		if("缝纫师——护甲裙、白色束腰外衣、布腰带")
			armor = /obj/item/clothing/suit/roguetown/armor/armordress
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			cloak = /obj/item/clothing/cloak/raincloak/furcloak
			belt = /obj/item/storage/belt/rogue/leather/cloth/lady

		if("旅人——短斗篷、内衫、靴子")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
				pants = /obj/item/clothing/under/roguetown/trou
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			cloak = /obj/item/clothing/cloak/half
			head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood

		if("乡民——毛皮帽、短衫、皮靴")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				pants = /obj/item/clothing/under/roguetown/trou
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/hatfur

		if("矿工——武装帽、长裤、工作背心")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/brown
			else
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
				pants = /obj/item/clothing/under/roguetown/trou
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
			head = /obj/item/clothing/head/roguetown/armingcap
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather

		if("艺人——华丽帽子、束腰外衣、短斗篷")
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			cloak = /obj/item/clothing/cloak/half
			head = /obj/item/clothing/head/roguetown/fancyhat
			belt = /obj/item/storage/belt/rogue/leather/cloth

		if("朴素学者——眼镜、学者长袍、包头帽")
			shirt = /obj/item/clothing/suit/roguetown/shirt/robe/archivist
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			head = /obj/item/clothing/head/roguetown/chaperon
			mask = /obj/item/clothing/mask/rogue/spectacles

		if("乡村风格——草帽、衬裙、短靴")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				pants = /obj/item/clothing/under/roguetown/trou
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			head = /obj/item/clothing/head/roguetown/strawhat
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	backl = /obj/item/storage/backpack/rogue/backpack

	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/rogueweapon/handsaw = 1,
						/obj/item/dye_brush = 1,
						/obj/item/reagent_containers/powder/salt = 1,
						/obj/item/reagent_containers/food/snacks/rogue/cheddar = 2,
						/obj/item/natural/cloth = 2,
						/obj/item/flashlight/flare/torch/lantern = 1,

						/obj/item/rogueweapon/shovel/small = 1,
						/obj/item/rogueweapon/chisel = 1,
	)

	if(H.mind)

		var/misc_skills = list(
			"偷窃" = /datum/skill/misc/stealing,
			"音乐" = /datum/skill/misc/music,
			"阅读" = /datum/skill/misc/reading,
			"医疗" = /datum/skill/misc/medicine,
			"追踪" = /datum/skill/misc/tracking,
			"开锁" = /datum/skill/misc/lockpicking,
			"潜行" = /datum/skill/misc/sneaking,
			"骑术" = /datum/skill/misc/riding
		)
		var/labor_skills = list(
			"耕作" = /datum/skill/labor/farming,
			"伐木" = /datum/skill/labor/lumberjacking,
			"钓鱼" = /datum/skill/labor/fishing,
			"屠宰" = /datum/skill/labor/butchering,
			"采矿" = /datum/skill/labor/mining
		)
		var/craft_skills = list(
			"缝纫" = /datum/skill/craft/sewing,
			"制陶" = /datum/skill/craft/ceramics,
			"木工" = /datum/skill/craft/carpentry,
			"石工" = /datum/skill/craft/masonry,
			"工程" = /datum/skill/craft/engineering,
			"炼金" = /datum/skill/craft/alchemy,
			"制革" = /datum/skill/craft/tanning,
			"烹饪" = /datum/skill/craft/cooking,
			"武器锻造" = /datum/skill/craft/weaponsmithing,
			"护甲锻造" = /datum/skill/craft/armorsmithing,
			"铁匠工艺" = /datum/skill/craft/blacksmithing,
			"冶炼" = /datum/skill/craft/smelting
		)
		var/combat_skills = list(
			"斧术" = /datum/skill/combat/axes,
			"徒手格斗" = /datum/skill/combat/unarmed,
			"短刃" = /datum/skill/combat/knives,
			"摔跤" = /datum/skill/combat/wrestling,
			"鞭与连枷" = /datum/skill/combat/whipsflails,
			"弓术" = /datum/skill/combat/bows,
			"弩术" = /datum/skill/combat/crossbows,
			"长柄武器" = /datum/skill/combat/polearms,
			"盾术" = /datum/skill/combat/shields,
			"投石索" = /datum/skill/combat/slings,
			"剑术" = /datum/skill/combat/swords,
			"锤术" = /datum/skill/combat/maces
		)

		var/expert_skill_name = P.choose(misc_skills + labor_skills + craft_skills, "选择一项技能提升至专家级。[1/1]", "技能选择")
		if(P.cancelled)
			return
		if(expert_skill_name)
			P.skill_floor(misc_skills[expert_skill_name] || labor_skills[expert_skill_name] || craft_skills[expert_skill_name], SKILL_LEVEL_EXPERT, TRUE)
			if(expert_skill_name in misc_skills)
				misc_skills -= expert_skill_name
			if(expert_skill_name in labor_skills)
				labor_skills -= expert_skill_name
			if(expert_skill_name in craft_skills)
				craft_skills -= expert_skill_name

		for(var/i in 1 to 4)
			var/journeyman_name = P.choose(misc_skills + labor_skills + craft_skills + combat_skills, "选择一项技能提升至熟练级。[i]/4", "技能选择")
			if(P.cancelled)
				return
			if(journeyman_name)
				P.skill_floor(misc_skills[journeyman_name] || labor_skills[journeyman_name] || craft_skills[journeyman_name] || combat_skills[journeyman_name], SKILL_LEVEL_JOURNEYMAN, TRUE)
				if(journeyman_name in misc_skills)
					misc_skills -= journeyman_name
				if(journeyman_name in labor_skills)
					labor_skills -= journeyman_name
				if(journeyman_name in craft_skills)
					craft_skills -= journeyman_name
				if(journeyman_name in combat_skills)
					combat_skills -= journeyman_name

		for(var/i in 1 to 3)
			var/apprentice_name = P.choose(misc_skills + labor_skills + craft_skills + combat_skills, "选择一项技能提升至学徒级。[i]/3", "技能选择")
			if(P.cancelled)
				return
			if(apprentice_name)
				P.skill_floor(misc_skills[apprentice_name] || labor_skills[apprentice_name] || craft_skills[apprentice_name] || combat_skills[apprentice_name], SKILL_LEVEL_APPRENTICE, TRUE)
				if(apprentice_name in misc_skills)
					misc_skills -= apprentice_name
				if(apprentice_name in labor_skills)
					labor_skills -= apprentice_name
				if(apprentice_name in craft_skills)
					craft_skills -= apprentice_name
				if(apprentice_name in combat_skills)
					combat_skills -= apprentice_name

		for(var/i in 1 to 5)
			var/novice_name = P.choose(misc_skills + labor_skills + craft_skills + combat_skills, "选择一项技能提升至入门级。[i]/5", "技能选择")
			if(P.cancelled)
				return
			if(novice_name)
				P.skill_floor(misc_skills[novice_name] || labor_skills[novice_name] || craft_skills[novice_name] || combat_skills[novice_name], SKILL_LEVEL_NOVICE, TRUE)
				if(novice_name in misc_skills)
					misc_skills -= novice_name
				if(novice_name in labor_skills)
					labor_skills -= novice_name
				if(novice_name in craft_skills)
					craft_skills -= novice_name
				if(novice_name in combat_skills)
					combat_skills -= novice_name

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/hunter.dm
/datum/outfit/job/roguetown/adventurer/hunter/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	pants = /obj/item/clothing/under/roguetown/trou/artipants
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backl = /obj/item/storage/backpack/rogue/backpack
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/quiver/arrows
	r_hand = /obj/item/storage/meatbag
	backpack_contents = list(
				/obj/item/flint = 1,
				/obj/item/bait = 1,
				/obj/item/rogueweapon/huntingknife = 1,
				/obj/item/flashlight/flare/torch/lantern = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1
				)
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	if(SSmapping.current_map.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey
		head = /obj/item/clothing/head/roguetown/tagelmust
	if(H.age == AGE_MIDDLEAGED)
		P.skill_floor(/datum/skill/labor/butchering, 5, TRUE)
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/labor/butchering, 6, TRUE)
		P.skill_floor(/datum/skill/craft/tanning, 4, TRUE)
	if(H.mind)
		P.add_spell(/obj/effect/proc_holder/spell/invoked/huntersyell)
		var/weapons = list("砍刀","短柄斧")
		var/weapon_choice = P.choose(weapons, "选择你的武器。", "选择装备")
		if(P.cancelled)
			return

		switch(weapon_choice)
			if("砍刀")
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/short/messer/iron
				P.skill_floor(/datum/skill/combat/swords, 2, TRUE)
			if("短柄斧")
				beltl = /obj/item/rogueweapon/stoneaxe/handaxe
				P.skill_floor(/datum/skill/combat/axes, 2, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/hunter.dm
/datum/outfit/job/roguetown/adventurer/hunter_spear/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedboots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	backl = /obj/item/storage/backpack/rogue/backpack
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/meatbag
	beltl = /obj/item/flashlight/flare/torch/lantern
	l_hand = /obj/item/rogueweapon/spear
	backpack_contents = list(
				/obj/item/flint = 1,
				/obj/item/bait = 1,
				/obj/item/rogueweapon/huntingknife = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1,
				/obj/item/rogueweapon/stoneaxe/handaxe
				)
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	if(SSmapping.current_map.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey
		head = /obj/item/clothing/head/roguetown/tagelmust
	if(H.age == AGE_MIDDLEAGED)
		P.skill_floor(/datum/skill/labor/butchering, 5, TRUE)
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/labor/butchering, 6, TRUE)
		P.skill_floor(/datum/skill/craft/tanning, 4, TRUE)
	if(H.mind)
		P.add_spell(/obj/effect/proc_holder/spell/invoked/huntersyell)
	return

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/miner.dm
/datum/outfit/job/roguetown/adventurer/miner/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	head = /obj/item/clothing/head/roguetown/armingcap
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/pick
	beltr = /obj/item/storage/hip/orestore/bronze
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/chisel = 1,
						/obj/item/rogueweapon/hammer/wood = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1,
						/obj/item/rogueweapon/huntingknife = 1,
						/obj/item/storage/hip/orestore/bronze = 1
						)
	if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/brown
	if(H.pronouns == HE_HIM || H.pronouns == THEY_THEM || H.pronouns == IT_ITS)
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
		pants = /obj/item/clothing/under/roguetown/trou
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	if(H.mind)
		P.add_spell(/obj/effect/proc_holder/spell/invoked/mineroresight)
	if(SSmapping.current_map.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/sandals
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey
		head = /obj/item/clothing/head/roguetown/tagelmust
	if(H.age == AGE_MIDDLEAGED)
		P.skill_floor(/datum/skill/labor/mining, 5, TRUE)
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/labor/mining, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/minstrel.dm
/datum/outfit/job/roguetown/adventurer/minstrel/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/half
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
	r_hand = /obj/item/rogue/instrument/accord
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/cloth
	beltr = /obj/item/rogueweapon/huntingknife/idagger
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
						/obj/item/rogue/instrument/lute = 1,
						/obj/item/rogue/instrument/flute = 1,
						/obj/item/rogue/instrument/drum = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1
						)

	P.bard_tier = BARD_T3

	if(SSmapping.current_map.map_name == "Desert Town")
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
		pants = /obj/item/clothing/under/roguetown/sirwal/fancy/random
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		belt = /obj/item/storage/belt/rogue/leather/cloth/sash/random
	if(H.mind)
		var/weapons = list("手风琴","风笛","鼓","长笛","吉他","竖琴","手摇琴","口弦琴","鲁特琴","拨弦琴","三味线","小号","中提琴","歌唱护符")
		var/weapon_choice = P.choose(weapons, "选择你的乐器。", "选择装备")
		if(P.cancelled)
			return

		switch(weapon_choice)
			if("手风琴")
				backr = /obj/item/rogue/instrument/accord
			if("风笛")
				backr = /obj/item/rogue/instrument/bagpipe
			if("鼓")
				backr = /obj/item/rogue/instrument/drum
			if("长笛")
				backr = /obj/item/rogue/instrument/flute
			if("吉他")
				backr = /obj/item/rogue/instrument/guitar
			if("竖琴")
				backr = /obj/item/rogue/instrument/harp
			if("手摇琴")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("口弦琴")
				backr = /obj/item/rogue/instrument/jawharp
			if("鲁特琴")
				backr = /obj/item/rogue/instrument/lute
			if("拨弦琴")
				backr = /obj/item/rogue/instrument/psyaltery
			if("三味线")
				backr = /obj/item/rogue/instrument/shamisen
			if("小号")
				backr = /obj/item/rogue/instrument/trumpet
			if("中提琴")
				backr = /obj/item/rogue/instrument/viola
			if("歌唱护符")
				backr = /obj/item/rogue/instrument/vocals
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/misc/music, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/peasant.dm
/datum/outfit/job/roguetown/adventurer/peasant/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	belt = /obj/item/storage/belt/rogue/leather/rope
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/trou
	head = /obj/item/clothing/head/roguetown/armingcap
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	mouth = /obj/item/rogueweapon/huntingknife
	beltr = /obj/item/flint
	if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		pants = null
	backpack_contents = list(
						/obj/item/seeds/wheat=3,
						/obj/item/seeds/apple=3,
						/obj/item/ash=3,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1
						)
	beltl = /obj/item/rogueweapon/sickle
	backr = /obj/item/rogueweapon/hoe
	if(SSmapping.current_map.map_name == "Desert Town")
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
		shoes = /obj/item/clothing/shoes/roguetown/sandals
	if(H.age == AGE_MIDDLEAGED)
		P.skill_floor(/datum/skill/labor/farming, 5, TRUE)
		P.skill_floor(/datum/skill/labor/butchering, 3, TRUE)
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/labor/farming, 6, TRUE)
		P.skill_floor(/datum/skill/labor/butchering, 4, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/potter.dm
/datum/outfit/job/roguetown/adventurer/potter/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	head = /obj/item/clothing/head/roguetown/hatfur
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/hatblu

	cloak = /obj/item/clothing/cloak/apron/blacksmith
	pants = /obj/item/clothing/under/roguetown/trou
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/rogueweapon/blowrod
	beltr = /obj/item/rogueweapon/tongs
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/shovel

	backpack_contents = list(
		/obj/item/natural/clay = 8,
		/obj/item/natural/clay/glassbatch = 2,
		/obj/item/rogueore/coal = 1,
		/obj/item/dye_brush = 1,
		/obj/item/storage/roguebag,
		/obj/item/recipe_book/ceramics = 1)

	if(H.mind)
		P.add_spell(/obj/effect/proc_holder/spell/invoked/digclay)

	if(SSmapping.current_map.map_name == "Desert Town")
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
		shoes = /obj/item/clothing/shoes/roguetown/sandals

		P.add_spell(/obj/effect/proc_holder/spell/invoked/takeapprentice)
	if(H.age == AGE_MIDDLEAGED)
		P.skill_floor(/datum/skill/craft/ceramics, 5, TRUE)
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/craft/ceramics, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/rare/Lchef.dm
/datum/outfit/job/roguetown/adventurer/masterchef/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/tights/random
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	cloak = /obj/item/clothing/cloak/apron
	head = /obj/item/clothing/head/roguetown/chef
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/backpack
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/cooking/pan
	mouth = /obj/item/rogueweapon/huntingknife/cleaver
	beltl = /obj/item/flint
	r_hand = /obj/item/flashlight/flare/torch
	var/packcontents = pickweight(list("Honey" = 1, "Truffles" = 1, "Bacon" = 1))
	switch(packcontents)
		if("Honey")
			backpack_contents = list(
				/obj/item/kitchen/rollingpin = 1,
				/obj/item/flint = 1,
				/obj/item/kitchen/spoon = 1,
				/obj/item/natural/cloth = 1,
				/obj/item/reagent_containers/peppermill = 1,
				/obj/item/reagent_containers/powder/flour = 2,
				/obj/item/reagent_containers/food/snacks/rogue/honey/spider = 1,
				/obj/item/reagent_containers/food/snacks/rogue/honey = 1,
				/obj/item/reagent_containers/powder/salt = 1,
				/obj/item/reagent_containers/food/snacks/butter = 1,
				/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
				/obj/item/reagent_containers/food/snacks/rogue/handpie = 1,
				/obj/item/book/rogue/yeoldecookingmanual = 1,
				)
		if("Truffles")
			backpack_contents = list(
				/obj/item/kitchen/rollingpin = 1,
				/obj/item/flint = 1,
				/obj/item/kitchen/spoon = 1,
				/obj/item/natural/cloth = 1,
				/obj/item/reagent_containers/peppermill = 1,
				/obj/item/reagent_containers/powder/flour = 2,
				/obj/item/reagent_containers/food/snacks/rogue/truffles = 2,
				/obj/item/reagent_containers/powder/salt = 1,
				/obj/item/reagent_containers/food/snacks/butter = 1,
				/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
				/obj/item/reagent_containers/food/snacks/rogue/handpie = 1,
				/obj/item/book/rogue/yeoldecookingmanual = 1,
				)
		if("Bacon")
			backpack_contents = list(
				/obj/item/kitchen/rollingpin = 1,
				/obj/item/flint = 1,
				/obj/item/kitchen/spoon = 1,
				/obj/item/natural/cloth = 1,
				/obj/item/reagent_containers/peppermill = 1,
				/obj/item/reagent_containers/powder/flour = 2,
				/obj/item/reagent_containers/food/snacks/rogue/meat/bacon = 2,
				/obj/item/reagent_containers/powder/salt = 1,
				/obj/item/reagent_containers/food/snacks/butter = 1,
				/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
				/obj/item/reagent_containers/food/snacks/rogue/handpie = 1,
				/obj/item/book/rogue/yeoldecookingmanual = 1,
				)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/rare/Lfish.dm
/datum/outfit/job/roguetown/adventurer/fishermaster/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	if(H.pronouns == HE_HIM || H.pronouns == THEY_THEM || H.pronouns == IT_ITS)
		pants = /obj/item/clothing/under/roguetown/trou
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		neck = /obj/item/storage/belt/rogue/pouch/coins/mid
		head = /obj/item/clothing/head/roguetown/fisherhat
		backr = /obj/item/storage/backpack/rogue/satchel
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
		belt = /obj/item/storage/belt/rogue/leather
		backl = /obj/item/fishingrod
		beltr = /obj/item/cooking/pan
		mouth = /obj/item/rogueweapon/huntingknife
		beltl = /obj/item/flint
		backpack_contents = list(
							/obj/item/natural/worms = 2,
							/obj/item/rogueweapon/shovel/small=1,
							/obj/item/flashlight/flare/torch = 1,
							)
	else
		pants = /obj/item/clothing/under/roguetown/trou
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
		neck = /obj/item/storage/belt/rogue/pouch/coins/mid
		head = /obj/item/clothing/head/roguetown/fisherhat
		backr = /obj/item/storage/backpack/rogue/satchel
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
		belt = /obj/item/storage/belt/rogue/leather/rope
		beltr = /obj/item/fishingrod
		beltl = /obj/item/rogueweapon/huntingknife
		backpack_contents = list(
			/obj/item/natural/worms = 2,
			/obj/item/rogueweapon/shovel/small=1,
			/obj/item/rogueweapon/scabbard/sheath = 1
			)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/rare/Lminer.dm
/datum/outfit/job/roguetown/adventurer/minermaster/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	head = /obj/item/clothing/head/roguetown/armingcap
	pants = /obj/item/clothing/under/roguetown/trou
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/rogueweapon/pick
	beltr = /obj/item/storage/hip/orestore/bronze
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/chisel = 1,
						/obj/item/rogueweapon/hammer/wood = 1,
						/obj/item/recipe_book/survival = 1,
						/obj/item/recipe_book/builder = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1,
						/obj/item/rogueweapon/huntingknife = 1,
						/obj/item/storage/hip/orestore/bronze = 1
						)
	if(H.mind)
		P.add_spell(/obj/effect/proc_holder/spell/invoked/mineroresight)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/rare/Lpeasant.dm
/datum/outfit/job/roguetown/adventurer/farmermaster/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	belt = /obj/item/storage/belt/rogue/leather/rope
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/trou
	head = /obj/item/clothing/head/roguetown/strawhat
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	mouth = /obj/item/clothing/mask/cigarette/pipe/westman
	if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		pants = null
	backpack_contents = list(
						/obj/item/seeds/wheat=1,
						/obj/item/seeds/apple=1,
						/obj/item/ash=1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/huntingknife = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1
						)
	beltl = /obj/item/rogueweapon/sickle
	beltr = /obj/item/flint
	backr = /obj/item/rogueweapon/hoe

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/rare/Lsmith.dm
/datum/outfit/job/roguetown/adventurer/masterblacksmith/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/hammer/iron
	beltl = /obj/item/rogueweapon/tongs
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	mouth = /obj/item/rogueweapon/huntingknife

	gloves = /obj/item/clothing/gloves/roguetown/leather
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	pants = /obj/item/clothing/under/roguetown/trou
	cloak = /obj/item/clothing/cloak/apron/blacksmith

	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/rogueore/coal=2,
						/obj/item/rogueore/iron=2,
						/obj/item/rogueore/silver=1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1
						)
	if(H.pronouns == HE_HIM)
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		shoes = /obj/item/clothing/shoes/roguetown/shortboots

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/scavenger.dm
/datum/outfit/job/roguetown/refugee/harvester/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	P.skill_add(/datum/skill/misc/athletics, 3, TRUE)
	P.skill_add(/datum/skill/misc/swimming, 2, TRUE)
	P.skill_add(/datum/skill/misc/climbing, 2, TRUE)

	P.skill_add(/datum/skill/combat/knives, 2, TRUE)
	P.skill_add(/datum/skill/combat/axes, 2, TRUE)
	P.skill_add(/datum/skill/combat/wrestling, 2, TRUE)
	P.skill_add(/datum/skill/combat/unarmed, 2, TRUE)
	P.skill_add(/datum/skill/combat/polearms, 2, TRUE)

	P.skill_add(/datum/skill/misc/reading, 1, TRUE)

	P.skill_add(/datum/skill/craft/crafting, 2, TRUE)
	P.skill_add(/datum/skill/craft/carpentry, 2, TRUE)
	P.skill_add(/datum/skill/craft/masonry, 1, TRUE)
	P.skill_add(/datum/skill/labor/farming, 3, TRUE)

	P.skill_add(/datum/skill/misc/medicine, 1, TRUE)

	P.skill_add(/datum/skill/craft/cooking, 2, TRUE)
	P.skill_add(/datum/skill/labor/lumberjacking, 2, TRUE)
	P.skill_add(/datum/skill/labor/butchering, 2, TRUE)
	P.skill_add(/datum/skill/craft/sewing, 1, TRUE)

	belt = /obj/item/storage/belt/rogue/leather/rope
	head = /obj/item/clothing/head/roguetown/strawhat
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/stoneaxe/woodcut/
	neck = 	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/sickle

	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/seeds/wheat = 2,
		/obj/item/seeds/apple = 1,
		/obj/item/ash = 3,
		/obj/item/seeds/potato = 1,
	)
	if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen
	else
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
		pants = /obj/item/clothing/under/roguetown/trou
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/scavenger.dm
/datum/outfit/job/roguetown/refugee/prospector/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	r_hand = /obj/item/rogueweapon/pick/copper
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/hammer/copper
	beltl = /obj/item/rogueweapon/tongs
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	cloak = /obj/item/clothing/cloak/apron/blacksmith
	mouth = /obj/item/rogueweapon/huntingknife/bronze
	pants = /obj/item/clothing/under/roguetown/trou
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/flint = 1,
		/obj/item/rogueore/coal = 4,
		/obj/item/rogueore/iron = 5,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/blacksmithing = 1,
		/obj/item/armor_brush = 1,
		/obj/item/polishing_cream = 1
		)

	if(H.pronouns == HE_HIM)
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shoes = /obj/item/clothing/shoes/roguetown/shortboots

	P.skill_add(/datum/skill/combat/swords, 1, TRUE)
	P.skill_add(/datum/skill/combat/knives, 1, TRUE)
	P.skill_add(/datum/skill/combat/crossbows, 1, TRUE)
	P.skill_add(/datum/skill/combat/maces, 3, TRUE)
	P.skill_add(/datum/skill/combat/axes, 2, TRUE)
	P.skill_add(/datum/skill/misc/athletics, 2, TRUE)
	P.skill_add(/datum/skill/misc/climbing, 3, TRUE)

	P.skill_add(/datum/skill/combat/wrestling, 3, TRUE)
	P.skill_add(/datum/skill/combat/unarmed, 3, TRUE)

	P.skill_add(/datum/skill/misc/reading, 1, TRUE)
	P.skill_add(/datum/skill/craft/crafting, 2, TRUE)

	P.skill_add(/datum/skill/craft/engineering, 2, TRUE)
	P.skill_add(/datum/skill/craft/armorsmithing, 2, TRUE)
	P.skill_add(/datum/skill/craft/weaponsmithing, 2, TRUE)
	P.skill_add(/datum/skill/craft/blacksmithing, 3, TRUE)
	P.skill_add(/datum/skill/craft/smelting, 3, TRUE)
	P.skill_add(/datum/skill/labor/mining, 3, TRUE)

	P.skill_add(/datum/skill/misc/medicine, 1, TRUE)

	P.skill_add(/datum/skill/craft/cooking, 1, TRUE)
	P.skill_add(/datum/skill/craft/ceramics, 2, TRUE)
	P.skill_add(/datum/skill/craft/carpentry, 1, TRUE)
	P.skill_add(/datum/skill/craft/masonry, 3, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/seamstress.dm
/datum/outfit/job/roguetown/adventurer/seamstress/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	armor = /obj/item/clothing/suit/roguetown/armor/armordress
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/cloth/lady
	beltl = /obj/item/needle
	beltr = /obj/item/rogueweapon/huntingknife/scissors
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
						/obj/item/natural/cloth = 2,
						/obj/item/natural/bundle/fibers/full = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/needle/thorn = 1,
						/obj/item/book/rogue/swatchbook = 1,
						)
	if(H.mind)
		P.add_spell(/obj/effect/proc_holder/spell/invoked/fittedclothing)

	if(SSmapping.current_map.map_name == "Desert Town")
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/purple
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
		shoes = /obj/item/clothing/shoes/roguetown/gladiator

	if(H.age == AGE_MIDDLEAGED)
		P.skill_floor(/datum/skill/craft/sewing, 5, TRUE)
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/craft/sewing, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/thug.dm
/datum/outfit/job/roguetown/adventurer/thug/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	belt = /obj/item/storage/belt/rogue/leather/rope
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	backpack_contents = list(/obj/item/reagent_containers/glass/bottle/rogue/beer = 1)

	var/classes = list("街头打手", "恶棍", "壮汉", "码头工")
	var/classchoice = P.choose(classes, "你是哪种街头混混？", "选择装备")
	if(P.cancelled)
		return

	switch(classchoice)

		if("街头打手")
			P.cosmetic_title = "街头打手"

			P.add_stat(STATKEY_STR, 2)
			P.add_stat(STATKEY_WIL, 1)
			P.add_stat(STATKEY_CON, 3)
			P.add_stat(STATKEY_SPD, -1)
			P.add_stat(STATKEY_INT, -1)

			P.skill_floor(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
			P.skill_floor(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
			P.skill_floor(/datum/skill/combat/axes, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/combat/knives, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
			P.skill_floor(/datum/skill/craft/cooking, SKILL_LEVEL_NOVICE, TRUE)
			P.skill_floor(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
			P.skill_floor(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
			P.skill_floor(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			P.skill_floor(/datum/skill/labor/mining, SKILL_LEVEL_NOVICE, TRUE)
			P.skill_floor(/datum/skill/labor/lumberjacking, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/labor/farming, SKILL_LEVEL_NOVICE, TRUE)
			P.skill_floor(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/misc/sneaking, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/misc/stealing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			var/options = list("煎锅", "指虎", "折刀", "赤手空拳")
			var/option_choice = P.choose(options, "选择你的手段。", "选择装备")
			if(P.cancelled)
				return

			switch(option_choice)
				if("煎锅")
					P.skill_floor(/datum/skill/craft/cooking, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/cooking/pan
				if("指虎")
					P.skill_floor(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/rogueweapon/knuckles
				if("折刀")
					P.skill_floor(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/rogueweapon/huntingknife/idagger/navaja
				if("赤手空拳")
					P.skill_floor(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
					P.add_trait(TRAIT_CIVILIZEDBARBARIAN)

		if("恶棍")
			P.cosmetic_title = "恶棍"

			P.add_stat(STATKEY_CON, -2)
			P.add_stat(STATKEY_SPD, 2)
			P.add_stat(STATKEY_INT, 2)

			P.add_trait(TRAIT_NUTCRACKER)
			P.add_trait(TRAIT_CICERONE)

			P.skill_floor(/datum/skill/combat/wrestling, SKILL_LEVEL_NOVICE, TRUE)
			P.skill_floor(/datum/skill/combat/unarmed, SKILL_LEVEL_NOVICE, TRUE)
			P.skill_floor(/datum/skill/combat/knives, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_NOVICE, TRUE)
			P.skill_floor(/datum/skill/craft/armorsmithing, SKILL_LEVEL_NOVICE, TRUE)
			P.skill_floor(/datum/skill/misc/athletics, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/misc/swimming, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
			P.skill_floor(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/misc/reading, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
			P.skill_floor(/datum/skill/misc/stealing, SKILL_LEVEL_JOURNEYMAN, TRUE)

			var/options = list("投石索", "魔法砖块", "开锁工具")
			var/option_choice = P.choose(options, "选择你的手段。", "选择装备")
			if(P.cancelled)
				return

			switch(option_choice)
				if("投石索")
					P.skill_floor(/datum/skill/combat/slings, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
					l_hand = /obj/item/quiver/sling
				if("魔法砖块")
					P.skill_floor(/datum/skill/magic/arcane, SKILL_LEVEL_EXPERT, TRUE)
					P.add_spell(/obj/effect/proc_holder/spell/self/magicians_brick)
					P.add_trait(TRAIT_ARCYNE_T1)
				if("开锁工具")
					P.skill_floor(/datum/skill/misc/sneaking, SKILL_LEVEL_EXPERT, TRUE)
					P.skill_floor(/datum/skill/misc/stealing, SKILL_LEVEL_EXPERT, TRUE)
					P.skill_floor(/datum/skill/misc/lockpicking, SKILL_LEVEL_EXPERT, TRUE)
					P.add_trait(TRAIT_LIGHT_STEP)
					r_hand = /obj/item/lockpickring/mundane

		if("壮汉")
			P.cosmetic_title = "壮汉"

			P.add_trait(TRAIT_STEELHEARTED)
			P.add_trait(TRAIT_HARDDISMEMBER)

			P.add_stat(STATKEY_STR, 3)
			P.add_stat(STATKEY_WIL, 2)
			P.add_stat(STATKEY_CON, 5)
			P.add_stat(STATKEY_SPD, -4)
			P.add_stat(STATKEY_INT, -6)
			P.add_stat(STATKEY_PER, -3)

			P.skill_floor(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
			P.skill_floor(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
			P.skill_floor(/datum/skill/combat/maces, SKILL_LEVEL_NOVICE, TRUE)
			P.skill_floor(/datum/skill/combat/axes, SKILL_LEVEL_NOVICE, TRUE)
			P.skill_floor(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
			P.skill_floor(/datum/skill/misc/swimming, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/misc/climbing, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/labor/mining, SKILL_LEVEL_JOURNEYMAN, TRUE)
			P.skill_floor(/datum/skill/labor/lumberjacking, SKILL_LEVEL_JOURNEYMAN, TRUE)

			var/options = list("近身搏斗", "大斧", "大棒")
			var/option_choice = P.choose(options, "选择你的手段。", "选择装备")
			if(P.cancelled)
				return

			switch(option_choice)
				if("近身搏斗")
					P.add_trait(TRAIT_BIGGUY)
					P.add_trait(TRAIT_CIVILIZEDBARBARIAN)
				if("大斧")
					P.skill_floor(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/greataxe
				if("大棒")
					P.skill_floor(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/mace

		if("码头工")
			P.cosmetic_title = "码头工"

			P.add_trait(TRAIT_STEELHEARTED)

			P.add_stat(STATKEY_STR, 2)
			P.add_stat(STATKEY_WIL, 2)
			P.add_stat(STATKEY_CON, 2)
			P.add_stat(STATKEY_SPD, -1)
			P.add_stat(STATKEY_INT, -1)
			P.add_stat(STATKEY_PER, -1)

			head = /obj/item/clothing/head/roguetown/helmet/bandana
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
			pants = /obj/item/clothing/under/roguetown/trou/leather
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
			r_hand = /obj/item/rogueweapon/sword/cutlass
			beltr = /obj/item/rogueweapon/scabbard/sword
			beltl = /obj/item/rogueweapon/huntingknife/idagger

			P.skill_floor(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
			P.skill_floor(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
			P.skill_floor(/datum/skill/combat/knives, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/combat/maces, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			P.skill_floor(/datum/skill/combat/crossbows, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/craft/cooking, SKILL_LEVEL_NOVICE, TRUE)
			P.skill_floor(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
			P.skill_floor(/datum/skill/misc/swimming, SKILL_LEVEL_MASTER, TRUE)
			P.skill_floor(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			P.skill_floor(/datum/skill/labor/lumberjacking, SKILL_LEVEL_NOVICE, TRUE)
			P.skill_floor(/datum/skill/labor/fishing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			P.skill_floor(/datum/skill/misc/sneaking, SKILL_LEVEL_APPRENTICE, TRUE)
			P.skill_floor(/datum/skill/misc/stealing, SKILL_LEVEL_JOURNEYMAN, TRUE)

	var/gang = list("朗茨鼠帮", "布洛茨狼帮", "算了")
	var/gang_choice = P.choose(gang, "要加入帮派吗？")
	if(P.cancelled)
		return

	switch(gang_choice)
		if("朗茨鼠帮")
			P.add_trait(TRAIT_GANG_A)
			mask = /obj/item/clothing/mask/rogue/ragmask/red
		if("布洛茨狼帮")
			P.add_trait(TRAIT_GANG_B)
			mask = /obj/item/clothing/mask/rogue/ragmask/azure
		if("算了")
			return null

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/townelder.dm
/datum/outfit/job/roguetown/elder/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	cloak = /obj/item/clothing/cloak/stabard/guardhood/elder
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/white
	pants = /obj/item/clothing/under/roguetown/tights
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/mace
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/storage/belt/rogue/pouch/coins/rich = 1)
	if(should_wear_femme_clothes(H))
		head = /obj/item/clothing/head/roguetown/chaperon/greyscale/elder
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress
		backr = /obj/item/clothing/cloak/raincloak/furcloak
	else if(should_wear_masc_clothes(H))
		head = /obj/item/clothing/head/roguetown/chaperon/greyscale/elder
		shirt = /obj/item/clothing/suit/roguetown/shirt/tunic
		gloves = /obj/item/clothing/gloves/roguetown/leather

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/witch.dm
/datum/outfit/job/roguetown/adventurer/witch/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	mask = /obj/item/clothing/head/roguetown/roguehood/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/phys
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/storage/magebag/witch
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
						/obj/item/reagent_containers/glass/mortar = 1,
						/obj/item/pestle = 1,
						/obj/item/candle/yellow = 2,
						/obj/item/recipe_book/alchemy = 1,
						/obj/item/recipe_book/magic = 1,
						/obj/item/chalk = 1
						)
	if(H.age == AGE_MIDDLEAGED)
		P.skill_floor(/datum/skill/craft/alchemy, 5, TRUE)
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/craft/alchemy, 6, TRUE)

	var/hats = list(
		"巫师帽" 		= /obj/item/clothing/head/roguetown/witchhat,
		"旧巫师帽"	= /obj/item/clothing/head/roguetown/witchhat/old,
		"无"
	)
	var/hatchoice = P.choose(hats, "选择你的帽子。", "巫师装束")
	if(P.cancelled)
		return
	if(hatchoice != "无")
		head = hats[hatchoice]

	var/classes = list("古老魔法", "神之血脉", "秘仪师")
	var/classchoice = P.choose(classes, "你的力量以何种形式显现？", "古老之道")
	if(P.cancelled)
		return

	var/shapeshifts = list("扎德", "猫", "黑猫", "蝙蝠", "卡比特", "小型老鼠", "小型维纳德狐", "小型沃尔夫", "青蛙")
	var/shapeshiftchoice = P.choose(shapeshifts, "你的第二副身躯是什么形态？", "古老之道")
	if(P.cancelled)
		return

	switch (classchoice)
		if("古老魔法")

			P.add_trait(TRAIT_ARCYNE_T2)
			P.skill_add(/datum/skill/magic/arcane, 1, TRUE)
			P.add_points(9)
			neck = null
		if("神之血脉")


			P.skill_add(/datum/skill/magic/holy, 1, TRUE)
			P.set_devotion(CLERIC_T2, CLERIC_REGEN_WITCH, CLERIC_REQ_2)
			P.devotion_multiplier = 0.5
			switch(H.patron?.type)
				if(/datum/patron/divine/astrata)
					neck = /obj/item/clothing/neck/roguetown/psicross/astrata
				if(/datum/patron/divine/noc)
					neck = /obj/item/clothing/neck/roguetown/psicross/noc
				if(/datum/patron/divine/abyssor)
					neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
				if(/datum/patron/divine/dendor)
					neck = /obj/item/clothing/neck/roguetown/psicross/dendor
				if(/datum/patron/divine/necra)
					neck = /obj/item/clothing/neck/roguetown/psicross/necra
				if(/datum/patron/divine/pestra)
					neck = /obj/item/clothing/neck/roguetown/psicross/pestra
				if(/datum/patron/divine/ravox)
					neck = /obj/item/clothing/neck/roguetown/psicross/ravox
				if(/datum/patron/divine/malum)
					neck = /obj/item/clothing/neck/roguetown/psicross/malum
				if(/datum/patron/divine/eora)
					neck = /obj/item/clothing/neck/roguetown/psicross/eora
				if(/datum/patron/divine/xylix)
					neck = /obj/item/clothing/neck/roguetown/psicross/xylix
				else
					neck = /obj/item/clothing/neck/roguetown/psicross/wood
		if("秘仪师")


			P.skill_add(/datum/skill/magic/holy, 1, TRUE)
			P.set_devotion(CLERIC_T1, CLERIC_REGEN_MINOR, CLERIC_REQ_1)
			P.devotion_multiplier = 0.5
			P.add_trait(TRAIT_ARCYNE_T1)
			P.skill_add(/datum/skill/magic/arcane, 1, TRUE)
			P.add_points(6)
			switch(H.patron?.type)
				if(/datum/patron/divine/astrata)
					neck = /obj/item/clothing/neck/roguetown/psicross/astrata
				if(/datum/patron/divine/noc)
					neck = /obj/item/clothing/neck/roguetown/psicross/noc
				if(/datum/patron/divine/abyssor)
					neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
				if(/datum/patron/divine/dendor)
					neck = /obj/item/clothing/neck/roguetown/psicross/dendor
				if(/datum/patron/divine/necra)
					neck = /obj/item/clothing/neck/roguetown/psicross/necra
				if(/datum/patron/divine/pestra)
					neck = /obj/item/clothing/neck/roguetown/psicross/pestra
				if(/datum/patron/divine/ravox)
					neck = /obj/item/clothing/neck/roguetown/psicross/ravox
				if(/datum/patron/divine/malum)
					neck = /obj/item/clothing/neck/roguetown/psicross/malum
				if(/datum/patron/divine/eora)
					neck = /obj/item/clothing/neck/roguetown/psicross/eora
				if(/datum/patron/divine/xylix)
					neck = /obj/item/clothing/neck/roguetown/psicross/xylix
				else
					neck = /obj/item/clothing/neck/roguetown/psicross/wood

	if(H.mind)
		switch (shapeshiftchoice)
			if("扎德")
				P.add_spell(/obj/effect/proc_holder/spell/targeted/shapeshift/witch/crow)
			if("猫")
				P.add_spell(/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat)
			if("黑猫")
				P.add_spell(/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat/black)
			if("蝙蝠")
				P.add_spell(/obj/effect/proc_holder/spell/targeted/shapeshift/witch/bat)
			if("小型沃尔夫")
				P.add_spell(/obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_wolf)
			if("小型维纳德狐")
				P.add_spell(/obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_vernard)
			if("小型老鼠")
				P.add_spell(/obj/effect/proc_holder/spell/targeted/shapeshift/witch/rous)
			if("卡比特")
				P.add_spell(/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cabbit)
			if("青蛙")
				P.add_spell(/obj/effect/proc_holder/spell/targeted/shapeshift/witch/frog)

		switch (classchoice)
			if("古老魔法")
				P.add_spell(/obj/effect/proc_holder/spell/invoked/guidance)
				P.add_spell(/obj/effect/proc_holder/spell/invoked/projectile/arcynebolt)
				P.add_spell(/obj/effect/proc_holder/spell/invoked/fortitude)

	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/armor/corset
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		pants = /obj/item/clothing/under/roguetown/skirt/red

	if(H.age == AGE_OLD)
		P.add_stat(STATKEY_SPD, -1)
		P.add_stat(STATKEY_INT, 1)
		P.add_stat(STATKEY_LCK, 1)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			P.music = 'sound/music/combat_heretic.ogg'
			P.add_trait(TRAIT_HERESIARCH)
		if(/datum/patron/inhumen/matthios)
			P.music = 'sound/music/combat_matthios.ogg'
			P.add_trait(TRAIT_HERESIARCH)
		if(/datum/patron/inhumen/graggar)
			P.music = 'sound/music/combat_graggar.ogg'
			P.add_trait(TRAIT_HERESIARCH)
		if(/datum/patron/inhumen/baotha)
			P.music = 'sound/music/combat_baotha.ogg'
			P.add_trait(TRAIT_HERESIARCH)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/woodcutter.dm
/datum/outfit/job/roguetown/adventurer/woodworker/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	belt = /obj/item/storage/belt/rogue/leather
	head = /obj/item/clothing/head/roguetown/roguehood
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/rogueweapon/handsaw
	beltl = /obj/item/rogueweapon/hammer/wood
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/rogueweapon/huntingknife = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1
						)
	if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
	else
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
		pants = /obj/item/clothing/under/roguetown/trou
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random

	if(SSmapping.current_map.map_name == "Desert Town")
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht
		head = /obj/item/clothing/head/roguetown/turban/random
		shoes = /obj/item/clothing/shoes/roguetown/sandals
	if(H.age == AGE_MIDDLEAGED)
		P.skill_floor(/datum/skill/labor/lumberjacking, 5, TRUE)
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/labor/lumberjacking, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/trader/brewer.dm
/datum/outfit/job/roguetown/adventurer/brewer/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	mask = /obj/item/clothing/mask/rogue/ragmask/black
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	pants = /obj/item/clothing/under/roguetown/tights/black
	cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/rogueweapon/mace/cudgel
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/voddena = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/blackgoat = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/elfred = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/elfblue = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/ingot/copper = 2,
		/obj/item/roguegear = 1,
		/obj/item/bottle_kit = 1,
		/obj/item/recipe_book/survival = 1)

// 来源：code/modules/jobs/job_types/roguetown/trader/cuisiner.dm
/datum/outfit/job/roguetown/adventurer/cuisiner/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	if(H.age == AGE_MIDDLEAGED)
		P.skill_floor(/datum/skill/craft/cooking, SKILL_LEVEL_MASTER, TRUE)
		P.skill_floor(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
	if(H.age == AGE_OLD)
		P.skill_floor(/datum/skill/craft/cooking, SKILL_LEVEL_LEGENDARY, TRUE)
		P.skill_floor(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
	head = /obj/item/clothing/head/roguetown/chef
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	pants = /obj/item/clothing/under/roguetown/trou
	armor = /obj/item/clothing/suit/roguetown/armor/workervest
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/backpack
	beltr = /obj/item/cooking/pan
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/clothing/mask/cigarette/rollie/nicotine/cheroot = 5,
		/obj/item/reagent_containers/peppermill = 1,
		/obj/item/reagent_containers/food/snacks/rogue/cheddar/aged = 1,
		/obj/item/reagent_containers/food/snacks/butter = 1,
		/obj/item/kitchen/rollingpin = 1,
		/obj/item/flint = 1,
		/obj/item/rogueweapon/huntingknife/chefknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/recipe_book/survival = 1,
		)

// 来源：code/modules/jobs/job_types/roguetown/trader/doomsayer.dm
/datum/outfit/job/roguetown/adventurer/doomsayer/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	head = /obj/item/clothing/head/roguetown/roguehood/black
	mask = /obj/item/clothing/mask/rogue/skullmask
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/half
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut
	backpack_contents = list(
		/obj/item/clothing/neck/roguetown/psicross/silver = 3,
		/obj/item/clothing/neck/roguetown/psicross = 2,
		/obj/item/clothing/neck/roguetown/psicross/wood = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

// 来源：code/modules/jobs/job_types/roguetown/trader/harlequin.dm
/datum/outfit/job/roguetown/adventurer/harlequin/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	shoes = /obj/item/clothing/shoes/roguetown/jester
	pants = /obj/item/clothing/under/roguetown/tights
	armor = /obj/item/clothing/suit/roguetown/shirt/jester
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/huntingknife/idagger
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/jester
	mask = /obj/item/clothing/mask/rogue/xylixmask
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	backpack_contents = list(
		/obj/item/bomb/smoke = 3,
		/obj/item/storage/pill_bottle/dice = 1,
		/obj/item/toy/cards/deck = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	if(H.mind)
		var/weapons = list("手风琴","风笛", "班卓琴","鼓","长笛","吉他","口琴","竖琴","手摇琴","口弦琴","鲁特琴","拨弦琴","三味线","小号","中提琴","歌唱护符")
		var/weapon_choice = P.choose(weapons, "选择你的乐器。", "选择装备")
		if(P.cancelled)
			return

		switch(weapon_choice)
			if("手风琴")
				backr = /obj/item/rogue/instrument/accord
			if("风笛")
				backr = /obj/item/rogue/instrument/bagpipe
			if("班卓琴")
				backr = /obj/item/rogue/instrument/banjo
			if("鼓")
				backr = /obj/item/rogue/instrument/drum
			if("长笛")
				backr = /obj/item/rogue/instrument/flute
			if("吉他")
				backr = /obj/item/rogue/instrument/guitar
			if("口琴")
				backr = /obj/item/rogue/instrument/harmonica
			if("竖琴")
				backr = /obj/item/rogue/instrument/harp
			if("手摇琴")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("口弦琴")
				backr = /obj/item/rogue/instrument/jawharp
			if("鲁特琴")
				backr = /obj/item/rogue/instrument/lute
			if("拨弦琴")
				backr = /obj/item/rogue/instrument/psyaltery
			if("三味线")
				backr = /obj/item/rogue/instrument/shamisen
			if("小号")
				backr = /obj/item/rogue/instrument/trumpet
			if("中提琴")
				backr = /obj/item/rogue/instrument/viola
			if("歌唱护符")
				backr = /obj/item/rogue/instrument/vocals

// 来源：code/modules/jobs/job_types/roguetown/trader/jeweler.dm
/datum/outfit/job/roguetown/adventurer/trader/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	mask = /obj/item/clothing/mask/rogue/lordmask
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/purple
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/raincloak/purple
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/huntingknife
	backpack_contents = list(
		/obj/item/clothing/ring/silver = 2,
		/obj/item/clothing/ring/gold = 1,
		/obj/item/rogueweapon/tongs = 1,
		/obj/item/rogueweapon/hammer/steel = 1,
		/obj/item/roguegem/yellow = 1,
		/obj/item/roguegem/green = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/chisel = 1,
		/obj/item/carvedgem/rose/rawrose = 1,
		/obj/item/roguegem/jade = 1,
		/obj/item/roguegem/onyxa = 1,
		/obj/item/roguegem/turq = 1,
		/obj/item/roguegem/coral = 1,
		/obj/item/roguegem/amber = 1,
		/obj/item/roguegem/opal = 1
		)

// 来源：code/modules/jobs/job_types/roguetown/trader/peddler.dm
/datum/outfit/job/roguetown/adventurer/peddler/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	head = /obj/item/clothing/head/roguetown/roguehood
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/storage/belt/rogue/surgery_bag/full
	beltl = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/reagent_containers/powder/spice = 2,
		/obj/item/reagent_containers/powder/ozium = 1,
		/obj/item/reagent_containers/powder/moondust = 2,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	if(H.mind)
		P.add_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular)

// 来源：code/modules/jobs/job_types/roguetown/trader/scholar.dm
/datum/outfit/job/roguetown/adventurer/scholar/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)

	head = /obj/item/clothing/head/roguetown/roguehood/black
	mask = /obj/item/clothing/mask/rogue/spectacles
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/archivist
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/woodstaff
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/huntingknife
	if(H.mind)
		P.add_spell(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		P.add_spell(/obj/effect/proc_holder/spell/invoked/teach)
		P.add_spell(/obj/effect/proc_holder/spell/invoked/learn)
		P.add_spell(/obj/effect/proc_holder/spell/invoked/refocusstudies)
	backpack_contents = list(
		/obj/item/paper/scroll = 3,
		/obj/item/natural/feather = 1,
		/obj/item/skillbook/unfinished = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	if(H.age == AGE_OLD)
		P.add_stat(STATKEY_SPD, -1)
		P.add_stat(STATKEY_INT, 1)

// 候选服装必须有显式适配，避免以后新增职业误走出生流程。
/proc/z121_parallel_outfits()
	return list(
		/datum/outfit/job/roguetown/adventurer/artificer,
		/datum/outfit/job/roguetown/adventurer/doctor,
		/datum/outfit/job/roguetown/adventurer/blacksmith,
		/datum/outfit/job/roguetown/adventurer/builder,
		/datum/outfit/job/roguetown/adventurer/cheesemaker,
		/datum/outfit/job/roguetown/adventurer/drunkard,
		/datum/outfit/job/roguetown/adventurer/fisher,
		/datum/outfit/job/roguetown/homesteader,
		/datum/outfit/job/roguetown/adventurer/hunter,
		/datum/outfit/job/roguetown/adventurer/hunter_spear,
		/datum/outfit/job/roguetown/adventurer/miner,
		/datum/outfit/job/roguetown/adventurer/minstrel,
		/datum/outfit/job/roguetown/adventurer/peasant,
		/datum/outfit/job/roguetown/adventurer/potter,
		/datum/outfit/job/roguetown/adventurer/masterchef,
		/datum/outfit/job/roguetown/adventurer/fishermaster,
		/datum/outfit/job/roguetown/adventurer/minermaster,
		/datum/outfit/job/roguetown/adventurer/farmermaster,
		/datum/outfit/job/roguetown/adventurer/masterblacksmith,
		/datum/outfit/job/roguetown/refugee/harvester,
		/datum/outfit/job/roguetown/refugee/prospector,
		/datum/outfit/job/roguetown/adventurer/seamstress,
		/datum/outfit/job/roguetown/adventurer/thug,
		/datum/outfit/job/roguetown/elder,
		/datum/outfit/job/roguetown/adventurer/witch,
		/datum/outfit/job/roguetown/adventurer/woodworker,
		/datum/outfit/job/roguetown/adventurer/brewer,
		/datum/outfit/job/roguetown/adventurer/cuisiner,
		/datum/outfit/job/roguetown/adventurer/doomsayer,
		/datum/outfit/job/roguetown/adventurer/harlequin,
		/datum/outfit/job/roguetown/adventurer/trader,
		/datum/outfit/job/roguetown/adventurer/peddler,
		/datum/outfit/job/roguetown/adventurer/scholar
	)
