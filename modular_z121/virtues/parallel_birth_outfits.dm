// 正常出生保留原职业流程，仅在记录已启用时登记明确的职业授予。

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/artificer.dm
/datum/outfit/job/roguetown/adventurer/artificer/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
		H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/barbersurgeon.dm
/datum/outfit/job/roguetown/adventurer/doctor/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
		H.z121_birth_stat(STATKEY_SPD, -1)
		H.z121_birth_stat(STATKEY_INT, 1)
		H.z121_birth_stat(STATKEY_PER, 1)
		H.z121_birth_skill_floor(/datum/skill/misc/medicine, 6, TRUE)
		H.z121_birth_skill_floor(/datum/skill/craft/alchemy, 4, TRUE)
	if(H.mind)
		H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/blacksmith.dm
/datum/outfit/job/roguetown/adventurer/blacksmith/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
			var/mold_choice = input(H, "选择你的初始模具", "选择") as anything in mold_names
			if (i == 1)
				l_hand = molds[mold_choice]
			else
				r_hand = molds[mold_choice]
		H.set_blindness(0)
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
		H.z121_birth_skill_floor(/datum/skill/craft/blacksmithing, 5, TRUE)
		H.z121_birth_skill_floor(/datum/skill/craft/armorsmithing, 5, TRUE)
		H.z121_birth_skill_floor(/datum/skill/craft/weaponsmithing, 5, TRUE)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/craft/blacksmithing, 6, TRUE)
		H.z121_birth_skill_floor(/datum/skill/craft/armorsmithing, 6, TRUE)
		H.z121_birth_skill_floor(/datum/skill/craft/weaponsmithing, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/builder.dm
/datum/outfit/job/roguetown/adventurer/builder/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
		H.z121_birth_skill_floor(/datum/skill/craft/carpentry, 5, TRUE)
		H.z121_birth_skill_floor(/datum/skill/craft/masonry, 5, TRUE)
		H.z121_birth_skill_floor(/datum/skill/craft/engineering, 4, TRUE)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/craft/carpentry, 6, TRUE)
		H.z121_birth_skill_floor(/datum/skill/craft/masonry, 6, TRUE)
		H.z121_birth_skill_floor(/datum/skill/craft/engineering, 5, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/cheesemaker.dm
/datum/outfit/job/roguetown/adventurer/cheesemaker/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
		H.z121_birth_skill_floor(/datum/skill/craft/cooking, 5, TRUE)
		H.z121_birth_skill_floor(/datum/skill/labor/farming, 3, TRUE)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/craft/cooking, 6, TRUE)
		H.z121_birth_skill_floor(/datum/skill/labor/farming, 4, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/drunkard.dm
/datum/outfit/job/roguetown/adventurer/drunkard/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
	H.z121_birth_trait(TRAIT_CRACKHEAD, TRAIT_GENERIC)

	if(H.age == AGE_MIDDLEAGED)
		H.z121_birth_skill_floor(/datum/skill/misc/stealing, 5, TRUE)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/misc/stealing, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/fisher.dm
/datum/outfit/job/roguetown/adventurer/fisher/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/labor/fishing, SKILL_LEVEL_MASTER, TRUE)
	else
		H.z121_birth_skill_floor(/datum/skill/labor/fishing, SKILL_LEVEL_EXPERT, TRUE)
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
		H.z121_birth_skill_floor(/datum/skill/labor/fishing, 5, TRUE)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/labor/fishing, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/homesteader.dm
/datum/outfit/job/roguetown/homesteader/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)

	H.adjust_blindness(-3)
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
	var/cosmetic_choice = input(H, "选择你的外观头衔。", "外观头衔") as anything in cosmetic_titles

	switch(cosmetic_choice)
		if("虔信者")
			to_chat(H, span_notice("你是虔信者，一名虔诚的农民，献身于信仰与乡邻。"))
			H.mind.cosmetic_class_title = "虔信者"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("女虔信者")
			to_chat(H, span_notice("你是女虔信者，一名虔诚的农民，献身于信仰与乡邻。"))
			H.mind.cosmetic_class_title = "女虔信者"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("农工")
			to_chat(H, span_notice("你是农工，在田间土地上辛勤劳作。"))
			H.mind.cosmetic_class_title = "农工"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("女农工")
			to_chat(H, span_notice("你是女农工，在田间土地上辛勤劳作。"))
			H.mind.cosmetic_class_title = "女农工"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("杂务工")
			to_chat(H, span_notice("你是杂务工，擅长小手工和修补工作。"))
			H.mind.cosmetic_class_title = "杂务工"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("女杂务工")
			to_chat(H, span_notice("你是女杂务工，擅长小手工和修补工作。"))
			H.mind.cosmetic_class_title = "女杂务工"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("乡野居民")
			to_chat(H, span_notice("你是乡野居民，是一名家境平常的乡野居民。"))
			H.mind.cosmetic_class_title = "乡野居民"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("草药师")
			to_chat(H, span_notice("你是草药师，熟悉植物及其药用功效。"))
			H.mind.cosmetic_class_title = "草药师"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("拓荒农")
			to_chat(H, span_notice("你是拓荒农，开垦并守护自己的土地。"))
			H.mind.cosmetic_class_title = "拓荒农"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("女拓荒农")
			to_chat(H, span_notice("你是女拓荒农，开垦并守护自己的土地。"))
			H.mind.cosmetic_class_title = "女拓荒农"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("户主")
			to_chat(H, span_notice("你是户主，照料着居所与家人。"))
			H.mind.cosmetic_class_title = "户主"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("家庭主夫")
			to_chat(H, span_notice("你是家庭主夫，照料着居所与家人。"))
			H.mind.cosmetic_class_title = "家庭主夫"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("家庭主妇")
			to_chat(H, span_notice("你是家庭主妇，照料着居所与家人。"))
			H.mind.cosmetic_class_title = "家庭主妇"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("猎人")
			to_chat(H, span_notice("你是猎人，擅长追踪与狩猎。"))
			H.mind.cosmetic_class_title = "猎人"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("劳工")
			to_chat(H, span_notice("你是劳工，是一名勤劳的平民。"))
			H.mind.cosmetic_class_title = "劳工"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("年轻贵族")
			to_chat(H, span_notice("你是年轻贵族，出身地位不高的贵族家庭。"))
			H.mind.cosmetic_class_title = "年轻贵族"
			H.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("女劳工")
			to_chat(H, span_notice("你是女劳工，是一名勤劳的平民。"))
			H.mind.cosmetic_class_title = "女劳工"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("村民")
			to_chat(H, span_notice("你是村民，是聚居地中的普通人。"))
			H.mind.cosmetic_class_title = "村民"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("女村民")
			to_chat(H, span_notice("你是女村民，是聚居地中的普通人。"))
			H.mind.cosmetic_class_title = "女村民"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("工艺师")
			to_chat(H, span_notice("你是工艺师，精通自己的手艺与行当。"))
			H.mind.cosmetic_class_title = "工艺师"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("女工艺师")
			to_chat(H, span_notice("你是女工艺师，精通自己的手艺与行当。"))
			H.mind.cosmetic_class_title = "女工艺师"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("望族")
			to_chat(H, span_notice("你是望族，属于富裕阶层。"))
			H.mind.cosmetic_class_title = "望族"
			H.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("贵族后裔")
			to_chat(H, span_notice("你是贵族后裔，身上流淌着贵族的血脉。"))
			H.mind.cosmetic_class_title = "贵族后裔"
			H.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("开拓者")
			to_chat(H, span_notice("你是开拓者，勇敢地开拓新的土地。"))
			H.mind.cosmetic_class_title = "开拓者"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("女开拓者")
			to_chat(H, span_notice("你是女开拓者，勇敢地开拓新的土地。"))
			H.mind.cosmetic_class_title = "女开拓者"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("定居者")
			to_chat(H, span_notice("你是定居者，在陌生土地上安家。"))
			H.mind.cosmetic_class_title = "定居者"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("女定居者")
			to_chat(H, span_notice("你是女定居者，在陌生土地上安家。"))
			H.mind.cosmetic_class_title = "女定居者"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("手艺商人")
			to_chat(H, span_notice("你是手艺商人，擅长贸易与手工艺。"))
			H.mind.cosmetic_class_title = "手艺商人"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("女手艺商人")
			to_chat(H, span_notice("你是女手艺商人，擅长贸易与手工艺。"))
			H.mind.cosmetic_class_title = "女手艺商人"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("仆役")
			to_chat(H, span_notice("你是仆役，从事服侍与随从工作。"))
			H.mind.cosmetic_class_title = "仆役"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("村民")
			to_chat(H, span_notice("你是村民，是聚居地中的普通人。"))
			H.mind.cosmetic_class_title = "村民"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("女村民")
			to_chat(H, span_notice("你是女村民，是聚居地中的普通人。"))
			H.mind.cosmetic_class_title = "女村民"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("织工")
			to_chat(H, span_notice("你是织工，擅长纺织与布料制作。"))
			H.mind.cosmetic_class_title = "织工"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("平民姑娘")
			to_chat(H, span_notice("你是平民姑娘，是一名靠劳动谋生的平民姑娘。"))
			H.mind.cosmetic_class_title = "平民姑娘"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("林地居民")
			to_chat(H, span_notice("你是林地居民，熟悉森林与木材。"))
			H.mind.cosmetic_class_title = "林地居民"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("林地女居民")
			to_chat(H, span_notice("你是林地女居民，熟悉森林与木材。"))
			H.mind.cosmetic_class_title = "林地女居民"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("工匠")
			to_chat(H, span_notice("你是工匠，精通自己的手艺。"))
			H.mind.cosmetic_class_title = "工匠"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("女工匠")
			to_chat(H, span_notice("你是女工匠，精通自己的手艺。"))
			H.mind.cosmetic_class_title = "女工匠"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("采集者")
			to_chat(H, span_notice("你是采集者，在荒野中采集物资。"))
			H.mind.cosmetic_class_title = "采集者"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("护理员")
			to_chat(H, span_notice("你是护理员，照料病人与伤者。"))
			H.mind.cosmetic_class_title = "护理员"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("修女")
			to_chat(H, span_notice("你是修女，献身于信仰与侍奉。"))
			H.mind.cosmetic_class_title = "修女"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("外科医师")
			to_chat(H, span_notice("你是外科医师，擅长外科手术与治疗。"))
			H.mind.cosmetic_class_title = "外科医师"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("垂钓者")
			to_chat(H, span_notice("你是垂钓者，擅长垂钓捕鱼。"))
			H.mind.cosmetic_class_title = "垂钓者"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("织工")
			to_chat(H, span_notice("你是织工，擅长纺织与布料制作。"))
			H.mind.cosmetic_class_title = "织工"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("石匠")
			to_chat(H, span_notice("你是石匠，擅长石作与建筑。"))
			H.mind.cosmetic_class_title = "石匠"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("护林人")
			to_chat(H, span_notice("你是护林人，守护林地与林木。"))
			H.mind.cosmetic_class_title = "护林人"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("城镇游侠")
			to_chat(H, span_notice("你是城镇游侠，守护道路与荒野。"))
			H.mind.cosmetic_class_title = "城镇游侠"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("勘探者")
			to_chat(H, span_notice("你是勘探者，寻找矿藏与财富。"))
			H.mind.cosmetic_class_title = "勘探者"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("自耕农")
			to_chat(H, span_notice("你是自耕农，拥有自己的土地。"))
			H.mind.cosmetic_class_title = "自耕农"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("家政工")
			to_chat(H, span_notice("你是家政工，打理家务与居所。"))
			H.mind.cosmetic_class_title = "家政工"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("城镇医生")
			to_chat(H, span_notice("你是城镇医生，为平民治病疗伤。"))
			H.mind.cosmetic_class_title = "城镇医生"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("抄写员")
			to_chat(H, span_notice("你是抄写员，负责文书与记录。"))
			H.mind.cosmetic_class_title = "抄写员"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("贵族后裔")
			to_chat(H, span_notice("你是贵族后裔，是贵族家族的继承人。"))
			H.mind.cosmetic_class_title = "贵族后裔"
			H.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("学者")
			to_chat(H, span_notice("你是学者，饱读诗书，学识丰富。"))
			H.mind.cosmetic_class_title = "学者"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("屠夫")
			to_chat(H, span_notice("你是屠夫，擅长肉类处理与买卖。"))
			H.mind.cosmetic_class_title = "屠夫"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("园丁")
			to_chat(H, span_notice("你是园丁，照料植物与土壤。"))
			H.mind.cosmetic_class_title = "园丁"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("牧羊人")
			to_chat(H, span_notice("你是牧羊人，照看着羊群。"))
			H.mind.cosmetic_class_title = "牧羊人"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("铁匠")
			to_chat(H, span_notice("你是铁匠，锻造金属与工具。"))
			H.mind.cosmetic_class_title = "铁匠"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("平民姑娘")
			to_chat(H, span_notice("你是平民姑娘，是一名出身平凡的姑娘。"))
			H.mind.cosmetic_class_title = "平民姑娘"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("仆役")
			to_chat(H, span_notice("你是仆役，出身平民，习惯了跑腿杂务。"))
			H.mind.cosmetic_class_title = "仆役"
			H.social_rank = SOCIAL_RANK_PEASANT


	var/stat_packs = list("敏捷——速度 +2，体质 +1，力量 -1，意志 -1", "书痴——智力 +1，感知 +2，意志 +2，力量 -2，体质 -2", "健壮——力量 +1，体质 +1，意志 +1，智力 -1", "均衡——属性不变")
	var/stat_choice = input(H, "选择你的属性倾向。[1/1]", "属性组合选择") as anything in stat_packs

	switch(stat_choice)
		if("敏捷——速度 +2，体质 +1，力量 -1，意志 -1")
			to_chat(H, span_notice("你身手敏捷，行动灵活。"))
			H.z121_birth_stat(STATKEY_SPD, 2)
			H.z121_birth_stat(STATKEY_WIL, -1)
			H.z121_birth_stat(STATKEY_STR, -1)
			H.z121_birth_stat(STATKEY_CON, 1)
		if("书痴——智力 +1，感知 +2，意志 +2，力量 -2，体质 -2")
			to_chat(H, span_notice("你学识渊博，富有智慧。"))
			H.z121_birth_stat(STATKEY_INT, 1)
			H.z121_birth_stat(STATKEY_PER, 2)
			H.z121_birth_stat(STATKEY_WIL, 2)
			H.z121_birth_stat(STATKEY_STR, -2)
			H.z121_birth_stat(STATKEY_CON, -2)
		if("健壮——力量 +1，体质 +1，意志 +1，智力 -1")
			to_chat(H, span_notice("你强壮而坚韧。"))
			H.z121_birth_stat(STATKEY_STR, 1)
			H.z121_birth_stat(STATKEY_CON, 1)
			H.z121_birth_stat(STATKEY_WIL, 1)
			H.z121_birth_stat(STATKEY_INT, -1)
		if("均衡——属性不变")
			to_chat(H, span_notice("你的各项能力十分均衡。"))




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
			var/profession_set_name = input(H, "选择一套职业装备。[i]/1", "职业装备") as anything in profession_sets
			if(profession_set_name)
				var/profession_list = profession_sets[profession_set_name]
				var/counter = 1
				for(var/item_path in profession_list)
					if(ispath(item_path, /obj/effect/proc_holder/spell))

						H.z121_birth_spell(new item_path)
					else

						var/item_name = initial(item_path:name)
						var/unique_key = "[item_name] ([profession_set_name] [counter])"
						H.z121_birth_stash(unique_key, item_path)
					counter++
				if(profession_set_name == "工匠套装")
					H.z121_birth_trait(TRAIT_MASTER_CARPENTER, TRAIT_GENERIC)
					H.z121_birth_trait(TRAIT_MASTER_MASON, TRAIT_GENERIC)
				if(profession_set_name in profession_sets)
					profession_sets -= profession_set_name


		var/combo_name = input(H, "选择一组日常工具。[1/1]", "日常工具") as anything in daily_tools_combos
		if(combo_name)
			var/combo_list = daily_tools_combos[combo_name]
			var/counter = 1
			for(var/item_path in combo_list)
				var/item_name = initial(item_path:name)
				var/unique_key = "[item_name] ([combo_name] [counter])"
				H.z121_birth_stash(unique_key, item_path)
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

	var/outfit_choice = input(H, "选择你的服装风格。", "服装选择") as anything in outfit_styles


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


		var/expert_skill_name = input(H, "选择一项技能提升至专家级。[1/1]", "技能选择") as anything in misc_skills + labor_skills + craft_skills
		if(expert_skill_name)
			H.z121_birth_skill_floor(misc_skills[expert_skill_name] || labor_skills[expert_skill_name] || craft_skills[expert_skill_name], SKILL_LEVEL_EXPERT, TRUE)
			if(expert_skill_name in misc_skills)
				misc_skills -= expert_skill_name
			if(expert_skill_name in labor_skills)
				labor_skills -= expert_skill_name
			if(expert_skill_name in craft_skills)
				craft_skills -= expert_skill_name


		for(var/i in 1 to 4)
			var/journeyman_name = input(H, "选择一项技能提升至熟练级。[i]/4", "技能选择") as anything in misc_skills + labor_skills + craft_skills + combat_skills
			if(journeyman_name)
				H.z121_birth_skill_floor(misc_skills[journeyman_name] || labor_skills[journeyman_name] || craft_skills[journeyman_name] || combat_skills[journeyman_name], SKILL_LEVEL_JOURNEYMAN, TRUE)
				if(journeyman_name in misc_skills)
					misc_skills -= journeyman_name
				if(journeyman_name in labor_skills)
					labor_skills -= journeyman_name
				if(journeyman_name in craft_skills)
					craft_skills -= journeyman_name
				if(journeyman_name in combat_skills)
					combat_skills -= journeyman_name


		for(var/i in 1 to 3)
			var/apprentice_name = input(H, "选择一项技能提升至学徒级。[i]/3", "技能选择") as anything in misc_skills + labor_skills + craft_skills + combat_skills
			if(apprentice_name)
				H.z121_birth_skill_floor(misc_skills[apprentice_name] || labor_skills[apprentice_name] || craft_skills[apprentice_name] || combat_skills[apprentice_name], SKILL_LEVEL_APPRENTICE, TRUE)
				if(apprentice_name in misc_skills)
					misc_skills -= apprentice_name
				if(apprentice_name in labor_skills)
					labor_skills -= apprentice_name
				if(apprentice_name in craft_skills)
					craft_skills -= apprentice_name
				if(apprentice_name in combat_skills)
					combat_skills -= apprentice_name


		for(var/i in 1 to 5)
			var/novice_name = input(H, "选择一项技能提升至入门级。[i]/5", "技能选择") as anything in misc_skills + labor_skills + craft_skills + combat_skills
			if(novice_name)
				H.z121_birth_skill_floor(misc_skills[novice_name] || labor_skills[novice_name] || craft_skills[novice_name] || combat_skills[novice_name], SKILL_LEVEL_NOVICE, TRUE)
				if(novice_name in misc_skills)
					misc_skills -= novice_name
				if(novice_name in labor_skills)
					labor_skills -= novice_name
				if(novice_name in craft_skills)
					craft_skills -= novice_name
				if(novice_name in combat_skills)
					combat_skills -= novice_name

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/hunter.dm
/datum/outfit/job/roguetown/adventurer/hunter/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
		H.z121_birth_skill_floor(/datum/skill/labor/butchering, 5, TRUE)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/labor/butchering, 6, TRUE)
		H.z121_birth_skill_floor(/datum/skill/craft/tanning, 4, TRUE)
	if(H.mind)
		H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/huntersyell)
		var/weapons = list("砍刀","短柄斧")
		var/weapon_choice = input(H, "选择你的武器。", "选择装备") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("砍刀")
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/short/messer/iron
				H.z121_birth_skill_floor(/datum/skill/combat/swords, 2, TRUE)
			if("短柄斧")
				beltl = /obj/item/rogueweapon/stoneaxe/handaxe
				H.z121_birth_skill_floor(/datum/skill/combat/axes, 2, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/hunter.dm
/datum/outfit/job/roguetown/adventurer/hunter_spear/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
	to_chat(H, span_warning("你是专精长矛的猎人，力量和耐力都十分出众。"))
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
		H.z121_birth_skill_floor(/datum/skill/labor/butchering, 5, TRUE)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/labor/butchering, 6, TRUE)
		H.z121_birth_skill_floor(/datum/skill/craft/tanning, 4, TRUE)
	if(H.mind)
		H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/huntersyell)
	return

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/miner.dm
/datum/outfit/job/roguetown/adventurer/miner/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
		H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/mineroresight)
	if(SSmapping.current_map.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/sandals
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/bluegrey
		head = /obj/item/clothing/head/roguetown/tagelmust
	if(H.age == AGE_MIDDLEAGED)
		H.z121_birth_skill_floor(/datum/skill/labor/mining, 5, TRUE)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/labor/mining, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/minstrel.dm
/datum/outfit/job/roguetown/adventurer/minstrel/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
	var/datum/inspiration/I = H.z121_birth_inspiration()
	I.grant_inspiration(H, bard_tier = BARD_T3)

	if(SSmapping.current_map.map_name == "Desert Town")
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
		pants = /obj/item/clothing/under/roguetown/sirwal/fancy/random
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		belt = /obj/item/storage/belt/rogue/leather/cloth/sash/random
	if(H.mind)
		var/weapons = list("手风琴","风笛","鼓","长笛","吉他","竖琴","手摇琴","口弦琴","鲁特琴","拨弦琴","三味线","小号","中提琴","歌唱护符")
		var/weapon_choice = tgui_input_list(H, "选择你的乐器。", "选择装备", weapons)
		H.set_blindness(0)
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
		H.z121_birth_skill_floor(/datum/skill/misc/music, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/peasant.dm
/datum/outfit/job/roguetown/adventurer/peasant/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
		H.z121_birth_skill_floor(/datum/skill/labor/farming, 5, TRUE)
		H.z121_birth_skill_floor(/datum/skill/labor/butchering, 3, TRUE)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/labor/farming, 6, TRUE)
		H.z121_birth_skill_floor(/datum/skill/labor/butchering, 4, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/potter.dm
/datum/outfit/job/roguetown/adventurer/potter/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
		H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/digclay)

	if(SSmapping.current_map.map_name == "Desert Town")
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/random
		pants = /obj/item/clothing/under/roguetown/sirwal/plainrandom
		shoes = /obj/item/clothing/shoes/roguetown/sandals

		H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/takeapprentice)
	if(H.age == AGE_MIDDLEAGED)
		H.z121_birth_skill_floor(/datum/skill/craft/ceramics, 5, TRUE)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/craft/ceramics, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/rare/Lchef.dm
/datum/outfit/job/roguetown/adventurer/masterchef/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
/datum/outfit/job/roguetown/adventurer/fishermaster/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
/datum/outfit/job/roguetown/adventurer/minermaster/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
		H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/mineroresight)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/rare/Lpeasant.dm
/datum/outfit/job/roguetown/adventurer/farmermaster/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
/datum/outfit/job/roguetown/adventurer/masterblacksmith/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
/datum/outfit/job/roguetown/refugee/harvester/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)

	H.z121_birth_skill_add(/datum/skill/misc/athletics, 3, TRUE)
	H.z121_birth_skill_add(/datum/skill/misc/swimming, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/misc/climbing, 2, TRUE)

	H.z121_birth_skill_add(/datum/skill/combat/knives, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/combat/axes, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/combat/wrestling, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/combat/unarmed, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/combat/polearms, 2, TRUE)

	H.z121_birth_skill_add(/datum/skill/misc/reading, 1, TRUE)

	H.z121_birth_skill_add(/datum/skill/craft/crafting, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/craft/carpentry, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/craft/masonry, 1, TRUE)
	H.z121_birth_skill_add(/datum/skill/labor/farming, 3, TRUE)

	H.z121_birth_skill_add(/datum/skill/misc/medicine, 1, TRUE)

	H.z121_birth_skill_add(/datum/skill/craft/cooking, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/labor/lumberjacking, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/labor/butchering, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/craft/sewing, 1, TRUE)

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
/datum/outfit/job/roguetown/refugee/prospector/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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

	H.z121_birth_skill_add(/datum/skill/combat/swords, 1, TRUE)
	H.z121_birth_skill_add(/datum/skill/combat/knives, 1, TRUE)
	H.z121_birth_skill_add(/datum/skill/combat/crossbows, 1, TRUE)
	H.z121_birth_skill_add(/datum/skill/combat/maces, 3, TRUE)
	H.z121_birth_skill_add(/datum/skill/combat/axes, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/misc/athletics, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/misc/climbing, 3, TRUE)

	H.z121_birth_skill_add(/datum/skill/combat/wrestling, 3, TRUE)
	H.z121_birth_skill_add(/datum/skill/combat/unarmed, 3, TRUE)

	H.z121_birth_skill_add(/datum/skill/misc/reading, 1, TRUE)
	H.z121_birth_skill_add(/datum/skill/craft/crafting, 2, TRUE)

	H.z121_birth_skill_add(/datum/skill/craft/engineering, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/craft/armorsmithing, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/craft/weaponsmithing, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/craft/blacksmithing, 3, TRUE)
	H.z121_birth_skill_add(/datum/skill/craft/smelting, 3, TRUE)
	H.z121_birth_skill_add(/datum/skill/labor/mining, 3, TRUE)

	H.z121_birth_skill_add(/datum/skill/misc/medicine, 1, TRUE)

	H.z121_birth_skill_add(/datum/skill/craft/cooking, 1, TRUE)
	H.z121_birth_skill_add(/datum/skill/craft/ceramics, 2, TRUE)
	H.z121_birth_skill_add(/datum/skill/craft/carpentry, 1, TRUE)
	H.z121_birth_skill_add(/datum/skill/craft/masonry, 3, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/seamstress.dm
/datum/outfit/job/roguetown/adventurer/seamstress/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
		H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/fittedclothing)

	if(SSmapping.current_map.map_name == "Desert Town")
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/gold
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/bisht/purple
		head = /obj/item/clothing/head/roguetown/turban/fancypurple
		shoes = /obj/item/clothing/shoes/roguetown/gladiator

	if(H.age == AGE_MIDDLEAGED)
		H.z121_birth_skill_floor(/datum/skill/craft/sewing, 5, TRUE)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/craft/sewing, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/thug.dm
/datum/outfit/job/roguetown/adventurer/thug/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
	var/classchoice = input(H, "你是哪种街头混混？", "选择装备") as anything in classes

	switch(classchoice)

		if("街头打手")
			H.mind.cosmetic_class_title = "街头打手"
			to_chat(H, span_warning("你是一名街头打手，在苦难世道里讨生活的小混混——本事不足以上战场，头脑也不足以安稳度日。地位上的不足，你用胆量来弥补。"))
			H.set_blindness(0)

			H.z121_birth_stat(STATKEY_STR, 2)
			H.z121_birth_stat(STATKEY_WIL, 1)
			H.z121_birth_stat(STATKEY_CON, 3)
			H.z121_birth_stat(STATKEY_SPD, -1)
			H.z121_birth_stat(STATKEY_INT, -1)

			H.z121_birth_skill_floor(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.z121_birth_skill_floor(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.z121_birth_skill_floor(/datum/skill/combat/axes, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/combat/knives, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.z121_birth_skill_floor(/datum/skill/craft/cooking, SKILL_LEVEL_NOVICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.z121_birth_skill_floor(/datum/skill/labor/mining, SKILL_LEVEL_NOVICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/labor/lumberjacking, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/labor/farming, SKILL_LEVEL_NOVICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/sneaking, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/stealing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			var/options = list("煎锅", "指虎", "折刀", "赤手空拳")
			var/option_choice = input(H, "选择你的手段。", "选择装备") as anything in options

			switch(option_choice)
				if("煎锅")
					H.z121_birth_skill_floor(/datum/skill/craft/cooking, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/cooking/pan
				if("指虎")
					H.z121_birth_skill_floor(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/rogueweapon/knuckles
				if("折刀")
					H.z121_birth_skill_floor(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/rogueweapon/huntingknife/idagger/navaja
				if("赤手空拳")
					H.z121_birth_skill_floor(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
					H.z121_birth_trait(TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)

		if("恶棍")
			H.mind.cosmetic_class_title = "恶棍"
			to_chat(H, span_warning("你比其他人聪明那么一点，也懂得避免贴身肉搏。与大多数同伴不同，你识字。"))
			H.set_blindness(0)

			H.z121_birth_stat(STATKEY_CON, -2)
			H.z121_birth_stat(STATKEY_SPD, 2)
			H.z121_birth_stat(STATKEY_INT, 2)

			H.z121_birth_trait(TRAIT_NUTCRACKER, TRAIT_GENERIC)
			H.z121_birth_trait(TRAIT_CICERONE, TRAIT_GENERIC)

			H.z121_birth_skill_floor(/datum/skill/combat/wrestling, SKILL_LEVEL_NOVICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/combat/unarmed, SKILL_LEVEL_NOVICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/combat/knives, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_NOVICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/craft/armorsmithing, SKILL_LEVEL_NOVICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/athletics, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/swimming, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
			H.z121_birth_skill_floor(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/reading, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/stealing, SKILL_LEVEL_JOURNEYMAN, TRUE)

			var/options = list("投石索", "魔法砖块", "开锁工具")
			var/option_choice = input(H, "选择你的手段。", "选择装备") as anything in options

			switch(option_choice)
				if("投石索")
					H.z121_birth_skill_floor(/datum/skill/combat/slings, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
					l_hand = /obj/item/quiver/sling
				if("魔法砖块")
					H.z121_birth_skill_floor(/datum/skill/magic/arcane, SKILL_LEVEL_EXPERT, TRUE)
					H.z121_birth_spell(new /obj/effect/proc_holder/spell/self/magicians_brick)
					H.z121_birth_trait(TRAIT_ARCYNE_T1, TRAIT_GENERIC)
				if("开锁工具")
					H.z121_birth_skill_floor(/datum/skill/misc/sneaking, SKILL_LEVEL_EXPERT, TRUE)
					H.z121_birth_skill_floor(/datum/skill/misc/stealing, SKILL_LEVEL_EXPERT, TRUE)
					H.z121_birth_skill_floor(/datum/skill/misc/lockpicking, SKILL_LEVEL_EXPERT, TRUE)
					H.z121_birth_trait(TRAIT_LIGHT_STEP, TRAIT_GENERIC)
					r_hand = /obj/item/lockpickring/mundane

		if("壮汉")
			H.mind.cosmetic_class_title = "壮汉"
			to_chat(H, span_warning("比起常人，你更像个吃得膘肥体壮的怪物。体格和蛮力是你最强的武器，却很难弥补脑子的不足。"))
			H.set_blindness(0)

			H.z121_birth_trait(TRAIT_STEELHEARTED, TRAIT_GENERIC)
			H.z121_birth_trait(TRAIT_HARDDISMEMBER, TRAIT_GENERIC)

			H.z121_birth_stat(STATKEY_STR, 3)
			H.z121_birth_stat(STATKEY_WIL, 2)
			H.z121_birth_stat(STATKEY_CON, 5)
			H.z121_birth_stat(STATKEY_SPD, -4)
			H.z121_birth_stat(STATKEY_INT, -6)
			H.z121_birth_stat(STATKEY_PER, -3)

			H.z121_birth_skill_floor(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.z121_birth_skill_floor(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.z121_birth_skill_floor(/datum/skill/combat/maces, SKILL_LEVEL_NOVICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/combat/axes, SKILL_LEVEL_NOVICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/swimming, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/climbing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/labor/mining, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.z121_birth_skill_floor(/datum/skill/labor/lumberjacking, SKILL_LEVEL_JOURNEYMAN, TRUE)

			var/options = list("近身搏斗", "大斧", "大棒")
			var/option_choice = input(H, "选择你的手段。", "选择装备") as anything in options

			switch(option_choice)
				if("近身搏斗")
					H.z121_birth_trait(TRAIT_BIGGUY, TRAIT_GENERIC)
					H.z121_birth_trait(TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				if("大斧")
					H.z121_birth_skill_floor(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/greataxe
				if("大棒")
					H.z121_birth_skill_floor(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/mace

		if("码头工")
			H.mind.cosmetic_class_title = "码头工"
			to_chat(H, span_warning("你年轻时响应了阿比索的召唤，却走上了歧途，劫掠所有途经你面前的人。如今船长金盆洗手，你也随之安定下来。不过，陆地上仍有赚钱的机会。"))
			H.set_blindness(0)

			H.z121_birth_trait(TRAIT_STEELHEARTED, TRAIT_GENERIC)

			H.z121_birth_stat(STATKEY_STR, 2)
			H.z121_birth_stat(STATKEY_WIL, 2)
			H.z121_birth_stat(STATKEY_CON, 2)
			H.z121_birth_stat(STATKEY_SPD, -1)
			H.z121_birth_stat(STATKEY_INT, -1)
			H.z121_birth_stat(STATKEY_PER, -1)

			head = /obj/item/clothing/head/roguetown/helmet/bandana
			armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
			pants = /obj/item/clothing/under/roguetown/trou/leather
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
			r_hand = /obj/item/rogueweapon/sword/cutlass
			beltr = /obj/item/rogueweapon/scabbard/sword
			beltl = /obj/item/rogueweapon/huntingknife/idagger

			H.z121_birth_skill_floor(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.z121_birth_skill_floor(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.z121_birth_skill_floor(/datum/skill/combat/knives, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/combat/maces, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.z121_birth_skill_floor(/datum/skill/combat/crossbows, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/craft/cooking, SKILL_LEVEL_NOVICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/swimming, SKILL_LEVEL_MASTER, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.z121_birth_skill_floor(/datum/skill/labor/lumberjacking, SKILL_LEVEL_NOVICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/labor/fishing, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/sneaking, SKILL_LEVEL_APPRENTICE, TRUE)
			H.z121_birth_skill_floor(/datum/skill/misc/stealing, SKILL_LEVEL_JOURNEYMAN, TRUE)

	var/gang = list("朗茨鼠帮", "布洛茨狼帮", "算了")
	var/gang_choice = input(H, "要加入帮派吗？") as anything in gang

	switch(gang_choice)
		if("朗茨鼠帮")
			to_chat(H, span_warning("我是朗茨鼠帮的一员。时过境迁，我们如今必须重振势力，布洛茨狼帮的家伙们终将为此付出代价。朗茨群鼠亮利齿，战意昂扬不退缩！"))
			H.z121_birth_trait(TRAIT_GANG_A, TRAIT_GENERIC)
			mask = /obj/item/clothing/mask/rogue/ragmask/red
		if("布洛茨狼帮")
			to_chat(H, span_warning("我是布洛茨狼帮的一员。时过境迁，我们如今必须重振势力，朗茨鼠帮的家伙们终将为此付出代价。布洛茨群狼齐嚎，敌人闻声胆寒！"))
			H.z121_birth_trait(TRAIT_GANG_B, TRAIT_GENERIC)
			mask = /obj/item/clothing/mask/rogue/ragmask/azure
		if("算了")
			return null

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/townelder.dm
/datum/outfit/job/roguetown/elder/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
/datum/outfit/job/roguetown/adventurer/witch/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
		H.z121_birth_skill_floor(/datum/skill/craft/alchemy, 5, TRUE)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/craft/alchemy, 6, TRUE)

	var/hats = list(
		"巫师帽" 		= /obj/item/clothing/head/roguetown/witchhat,
		"旧巫师帽"	= /obj/item/clothing/head/roguetown/witchhat/old,
		"无"
	)
	var/hatchoice = input(H, "选择你的帽子。", "巫师装束") as anything in hats
	if(hatchoice != "无")
		head = hats[hatchoice]

	var/classes = list("古老魔法", "神之血脉", "秘仪师")
	var/classchoice = input("你的力量以何种形式显现？", "古老之道") as anything in classes

	var/shapeshifts = list("扎德", "猫", "黑猫", "蝙蝠", "卡比特", "小型老鼠", "小型维纳德狐", "小型沃尔夫", "青蛙")
	var/shapeshiftchoice = input("你的第二副身躯是什么形态？", "古老之道") as anything in shapeshifts

	switch (classchoice)
		if("古老魔法")

			H.z121_birth_trait(TRAIT_ARCYNE_T2, TRAIT_GENERIC)
			H.z121_birth_skill_add(/datum/skill/magic/arcane, 1, TRUE)
			H.z121_birth_points(9)
			neck = null
		if("神之血脉")

			var/datum/devotion/D = H.z121_birth_devotion()
			H.z121_birth_skill_add(/datum/skill/magic/holy, 1, TRUE)
			H.z121_birth_grant_devotion(D, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_2)
			H.z121_birth_half_devotion(D)
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

			var/datum/devotion/D = H.z121_birth_devotion()
			H.z121_birth_skill_add(/datum/skill/magic/holy, 1, TRUE)
			H.z121_birth_grant_devotion(D, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
			H.z121_birth_half_devotion(D)
			H.z121_birth_trait(TRAIT_ARCYNE_T1, TRAIT_GENERIC)
			H.z121_birth_skill_add(/datum/skill/magic/arcane, 1, TRUE)
			H.z121_birth_points(6)
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
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/crow)
			if("猫")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat)
			if("黑猫")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat/black)
			if("蝙蝠")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/bat)
			if("小型沃尔夫")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_wolf)
			if("小型维纳德狐")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_vernard)
			if("小型老鼠")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/rous)
			if("卡比特")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cabbit)
			if("青蛙")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/frog)

		switch (classchoice)
			if("古老魔法")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/guidance)
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/projectile/arcynebolt)
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/fortitude)

	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/armor/corset
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		pants = /obj/item/clothing/under/roguetown/skirt/red

	if(H.age == AGE_OLD)
		H.z121_birth_stat(STATKEY_SPD, -1)
		H.z121_birth_stat(STATKEY_INT, 1)
		H.z121_birth_stat(STATKEY_LCK, 1)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			H.z121_birth_trait(TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			H.z121_birth_trait(TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			H.z121_birth_trait(TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			H.z121_birth_trait(TRAIT_HERESIARCH, TRAIT_GENERIC)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/woodcutter.dm
/datum/outfit/job/roguetown/adventurer/woodworker/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
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
		H.z121_birth_skill_floor(/datum/skill/labor/lumberjacking, 5, TRUE)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/labor/lumberjacking, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/trader/brewer.dm
/datum/outfit/job/roguetown/adventurer/brewer/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
	to_chat(H, span_warning("你靠兜售世界各地的进口酒谋生，也熟悉酿酒手艺，必要时能自己酿些麦酒。你还拥有制作蒸馏器的工具与知识。"))
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
/datum/outfit/job/roguetown/adventurer/cuisiner/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
	to_chat(H, span_warning("无论你是烹饪流派的传人、声名远扬的御厨，还是受雇谋生的厨师，你施展手艺的地方总是柜台、砧板和炉灶。"))
	if(H.age == AGE_MIDDLEAGED)
		H.z121_birth_skill_floor(/datum/skill/craft/cooking, SKILL_LEVEL_MASTER, TRUE)
		H.z121_birth_skill_floor(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/craft/cooking, SKILL_LEVEL_LEGENDARY, TRUE)
		H.z121_birth_skill_floor(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
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
/datum/outfit/job/roguetown/adventurer/doomsayer/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
	to_chat(H, span_warning("世界末日就要到了！！！至少，你希望顾客相信这一点。你会为他们在新世界提供一个安全的住处——当然，得由你亲手建造。"))
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
/datum/outfit/job/roguetown/adventurer/harlequin/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
	to_chat(H, span_warning ("你是一名四处游历的艺人，以弄臣为业。你走到哪里，混乱与恶作剧就跟到哪里。"))
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
		var/weapon_choice = input(H, "选择你的乐器。", "选择装备") as anything in weapons
		H.set_blindness(0)
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
/datum/outfit/job/roguetown/adventurer/trader/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
	to_chat(H, span_warning("你靠兜售异国珠宝、宝石和各种亮闪闪的东西谋生。"))
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
/datum/outfit/job/roguetown/adventurer/peddler/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
	to_chat(H, span_warning("你靠贩卖香料和在后巷进行“医疗”手术谋生。希望你的病人不需要那颗肾。"))
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
		H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)

// 来源：code/modules/jobs/job_types/roguetown/trader/scholar.dm
/datum/outfit/job/roguetown/adventurer/scholar/pre_equip(mob/living/carbon/human/H)
	if(!H.z121_profession?.capturing_birth)
		return ..()
	z121_birth_parent(H)
	to_chat(H, span_warning("你是一名游历世界的学者，想把自己的经历写成一本书。虽然你不像某些人那般专注学问，但你能靠旅途中的见闻与故事谋生。"))
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
		H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/teach)
		H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/learn)
		H.z121_birth_spell(new /obj/effect/proc_holder/spell/invoked/refocusstudies)
	backpack_contents = list(
		/obj/item/paper/scroll = 3,
		/obj/item/natural/feather = 1,
		/obj/item/skillbook/unfinished = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	if(H.age == AGE_OLD)
		H.z121_birth_stat(STATKEY_SPD, -1)
		H.z121_birth_stat(STATKEY_INT, 1)
