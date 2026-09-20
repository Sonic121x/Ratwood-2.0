// 正常出生保留原职业流程，仅在记录已启用时登记明确的职业授予。

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/artificer.dm
/datum/outfit/job/roguetown/adventurer/artificer/pre_equip(mob/living/carbon/human/H)
	..()
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
	..()
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
	..()
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
			"Iron sword mold" = /obj/item/mold/sword,
			"Iron axe mold" = /obj/item/mold/axe,
			"Iron mace mold" = /obj/item/mold/mace,
			"Iron knife mold" = /obj/item/mold/knife,
			"Iron polearm mold" = /obj/item/mold/polearm,
			"Iron plate" = /obj/item/mold/plate
		)
		var/mold_names = list()
		for (var/name in molds)
			mold_names += name
		for (var/i = 1 to 2)
			var/mold_choice = input(H, "Choose your starting molds", "Select") as anything in mold_names
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
	..()
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
	..()
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
	..()
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
	..()
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
	..()

	H.adjust_blindness(-3)
	var/cosmetic_titles = list(
	"Angler",
	"Artisan", "Artisana",
	"Butcher",
	"Craftsman", "Craftswoman",
	"Devotee", "Devotess",
	"Fieldworker",
	"Forager",
	"Forester",
	"Freeholder",
	"Gardener",
	"Handiworker",
	"Hedgefolk",
	"Herbalist",
	"Homesteader", "Homesteadress",
	"Housekeeper",
	"Householder", "Househusband", "Housewife",
	"Hunter",
	"Laborer",
	"Lordling",
	"Mason",
	"Nurse", "Nun",
	"Patrician",
	"Pioneer",
	"Prospector",
	"Scholar",
	"Scribe",
	"Scion",
	"Settler",
	"Shepherd",
	"Smith",
	"Town Doctor",
	"Town Ranger",
	"Tradesman", "Tradewoman",
	"Varlet",
	"Villager",
	"Weaver",
	"Wench",
	"Woodsman", "Woodswoman",
	"Chirurgeon",
	"Wench", "Varlet")
	var/cosmetic_choice = input(H, "Select your cosmetic title.", "Cosmetic Titles") as anything in cosmetic_titles

	switch(cosmetic_choice)
		if("Devotee")
			to_chat(H, span_notice("You are a Devotee, a pious peasant devoted to faith and community."))
			H.mind.cosmetic_class_title = "Devotee"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Devotess")
			to_chat(H, span_notice("You are a Devotess, a pious peasant devoted to faith and community."))
			H.mind.cosmetic_class_title = "Devotess"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Fieldworker")
			to_chat(H, span_notice("You are a Fieldworker, a laborer of fields and land."))
			H.mind.cosmetic_class_title = "Fieldworker"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Fieldwoman")
			to_chat(H, span_notice("You are a Fieldwoman, a laborer of fields and land."))
			H.mind.cosmetic_class_title = "Fieldwoman"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Handiworker")
			to_chat(H, span_notice("You are a Handiworker, skilled in small crafts and repairs."))
			H.mind.cosmetic_class_title = "Handiworker"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Handiwoman")
			to_chat(H, span_notice("You are a Handiwoman, skilled in small crafts and repairs."))
			H.mind.cosmetic_class_title = "Handiwoman"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Hedgefolk")
			to_chat(H, span_notice("You are Hedgefolk, a rural dweller of modest means."))
			H.mind.cosmetic_class_title = "Hedgefolk"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Herbalist")
			to_chat(H, span_notice("You are an Herbalist, skilled in plants and their remedies."))
			H.mind.cosmetic_class_title = "Herbalist"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Homesteader")
			to_chat(H, span_notice("You are a Homesteader, a settler and keeper of land."))
			H.mind.cosmetic_class_title = "Homesteader"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Homesteadress")
			to_chat(H, span_notice("You are a Homesteadress, a settler and keeper of land."))
			H.mind.cosmetic_class_title = "Homesteadress"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Householder")
			to_chat(H, span_notice("You are a Householder, a keeper of dwelling and family."))
			H.mind.cosmetic_class_title = "Householder"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Househusband")
			to_chat(H, span_notice("You are a Househusband, a keeper of dwelling and family."))
			H.mind.cosmetic_class_title = "Househusband"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Housewife")
			to_chat(H, span_notice("You are a Housewife, a keeper of dwelling and family."))
			H.mind.cosmetic_class_title = "Housewife"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Hunter")
			to_chat(H, span_notice("You are a Hunter, skilled in tracking and game."))
			H.mind.cosmetic_class_title = "Hunter"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Laborer")
			to_chat(H, span_notice("You are a Laborer, a hard worker and commoner."))
			H.mind.cosmetic_class_title = "Laborer"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Lordling")
			to_chat(H, span_notice("You are a Lordling, a young noble of minor standing."))
			H.mind.cosmetic_class_title = "Lordling"
			H.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("Laboress")
			to_chat(H, span_notice("You are a Laboress, a hard worker and commoner."))
			H.mind.cosmetic_class_title = "Laboress"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Villager")
			to_chat(H, span_notice("You are a Villager, common folk of the settlement."))
			H.mind.cosmetic_class_title = "Villager"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Villagewoman")
			to_chat(H, span_notice("You are a Villagewoman, common folk of the settlement."))
			H.mind.cosmetic_class_title = "Villagewoman"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Artisan")
			to_chat(H, span_notice("You are an Artisan, skilled in your craft and trade."))
			H.mind.cosmetic_class_title = "Artisan"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Artisana")
			to_chat(H, span_notice("You are an Artisana, skilled in your craft and trade."))
			H.mind.cosmetic_class_title = "Artisana"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Patrician")
			to_chat(H, span_notice("You are a Patrician, a member of the wealthy class."))
			H.mind.cosmetic_class_title = "Patrician"
			H.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("Scion")
			to_chat(H, span_notice("You are a Scion, a descendant of noble blood."))
			H.mind.cosmetic_class_title = "Scion"
			H.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("Pioneer")
			to_chat(H, span_notice("You are a Pioneer, a brave settler of new lands."))
			H.mind.cosmetic_class_title = "Pioneer"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Pioneress")
			to_chat(H, span_notice("You are a Pioneress, a brave settler of new lands."))
			H.mind.cosmetic_class_title = "Pioneress"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Settler")
			to_chat(H, span_notice("You are a Settler, one who makes a home in strange lands."))
			H.mind.cosmetic_class_title = "Settler"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Settleress")
			to_chat(H, span_notice("You are a Settleress, one who makes a home in strange lands."))
			H.mind.cosmetic_class_title = "Settleress"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Tradesman")
			to_chat(H, span_notice("You are a Tradesman, skilled in commerce and craft."))
			H.mind.cosmetic_class_title = "Tradesman"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Tradewoman")
			to_chat(H, span_notice("You are a Tradewoman, skilled in commerce and craft."))
			H.mind.cosmetic_class_title = "Tradewoman"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Varlet")
			to_chat(H, span_notice("You are a Varlet, a servant and attendant."))
			H.mind.cosmetic_class_title = "Varlet"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Villager")
			to_chat(H, span_notice("You are a Villager, common folk of the settlement."))
			H.mind.cosmetic_class_title = "Villager"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Villagewoman")
			to_chat(H, span_notice("You are a Villagewoman, common folk of the settlement."))
			H.mind.cosmetic_class_title = "Villagewoman"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Weaver")
			to_chat(H, span_notice("You are a Weaver, skilled in textiles and cloth."))
			H.mind.cosmetic_class_title = "Weaver"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Wench")
			to_chat(H, span_notice("You are a Wench, a working girl of the commons."))
			H.mind.cosmetic_class_title = "Wench"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Woodsman")
			to_chat(H, span_notice("You are a Woodsman, at home in forest and timber."))
			H.mind.cosmetic_class_title = "Woodsman"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Woodswoman")
			to_chat(H, span_notice("You are a Woodswoman, at home in forest and timber."))
			H.mind.cosmetic_class_title = "Woodswoman"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Craftsman")
			to_chat(H, span_notice("You are a Craftsman, skilled in your trade."))
			H.mind.cosmetic_class_title = "Craftsman"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Craftswoman")
			to_chat(H, span_notice("You are a Craftswoman, skilled in your trade."))
			H.mind.cosmetic_class_title = "Craftswoman"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Forager")
			to_chat(H, span_notice("You are a Forager, gathering from the wilds."))
			H.mind.cosmetic_class_title = "Forager"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Nurse")
			to_chat(H, span_notice("You are a Nurse, caring for the sick and wounded."))
			H.mind.cosmetic_class_title = "Nurse"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Nun")
			to_chat(H, span_notice("You are a Nun, devoted to faith and service."))
			H.mind.cosmetic_class_title = "Nun"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Chirurgeon")
			to_chat(H, span_notice("You are a Chirurgeon, skilled in surgical arts and healing."))
			H.mind.cosmetic_class_title = "Chirurgeon"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Angler")
			to_chat(H, span_notice("You are an Angler, skilled in fishing and catching."))
			H.mind.cosmetic_class_title = "Angler"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Weaver")
			to_chat(H, span_notice("You are a Weaver, skilled in textiles and cloth."))
			H.mind.cosmetic_class_title = "Weaver"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Mason")
			to_chat(H, span_notice("You are a Mason, skilled in stonework and building."))
			H.mind.cosmetic_class_title = "Mason"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Forester")
			to_chat(H, span_notice("You are a Forester, keeper of woods and timber."))
			H.mind.cosmetic_class_title = "Forester"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Town Ranger")
			to_chat(H, span_notice("You are a Town Ranger, protector of roads and wilderness."))
			H.mind.cosmetic_class_title = "Town Ranger"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Prospector")
			to_chat(H, span_notice("You are a Prospector, seeking minerals and fortune."))
			H.mind.cosmetic_class_title = "Prospector"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Freeholder")
			to_chat(H, span_notice("You are a Freeholder, owner of your own land."))
			H.mind.cosmetic_class_title = "Freeholder"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Housekeeper")
			to_chat(H, span_notice("You are a Housekeeper, maintaining home and hearth."))
			H.mind.cosmetic_class_title = "Housekeeper"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Town Doctor")
			to_chat(H, span_notice("You are a Town Doctor, healer of the common folk."))
			H.mind.cosmetic_class_title = "Town Doctor"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Scribe")
			to_chat(H, span_notice("You are a Scribe, keeper of records and letters."))
			H.mind.cosmetic_class_title = "Scribe"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Scion")
			to_chat(H, span_notice("You are a Scion, heir of a noble house."))
			H.mind.cosmetic_class_title = "Scion"
			H.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("Scholar")
			to_chat(H, span_notice("You are a Scholar, learned in books and knowledge."))
			H.mind.cosmetic_class_title = "Scholar"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Butcher")
			to_chat(H, span_notice("You are a Butcher, skilled in meat and trade."))
			H.mind.cosmetic_class_title = "Butcher"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Gardener")
			to_chat(H, span_notice("You are a Gardener, tending plants and soil."))
			H.mind.cosmetic_class_title = "Gardener"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Shepherd")
			to_chat(H, span_notice("You are a Shepherd, keeper of flocks."))
			H.mind.cosmetic_class_title = "Shepherd"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Smith")
			to_chat(H, span_notice("You are a Smith, forger of metal and tools."))
			H.mind.cosmetic_class_title = "Smith"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("Wench")
			to_chat(H, span_notice("You are a Wench, a common girl of humble birth."))
			H.mind.cosmetic_class_title = "Wench"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("Varlet")
			to_chat(H, span_notice("You are a Varlet, a low-born fellow accustomed to errands."))
			H.mind.cosmetic_class_title = "Varlet"
			H.social_rank = SOCIAL_RANK_PEASANT


	var/stat_packs = list("Agile - SPD +2, CON +1, STR -1, WIL -1", "Bookworm - INT +1, PER +2, WIL +2, STR -2, CON -2", "Toned - STR +1, CON +1, WIL +1, INT -1", "All-Rounded - No Changes")
	var/stat_choice = input(H, "Select your stat focus. [1/1]", "Stat Pack Selection") as anything in stat_packs

	switch(stat_choice)
		if("Agile - SPD +2, CON +1, STR -1, WIL -1")
			to_chat(H, span_notice("You are agile and nimble."))
			H.z121_birth_stat(STATKEY_SPD, 2)
			H.z121_birth_stat(STATKEY_WIL, -1)
			H.z121_birth_stat(STATKEY_STR, -1)
			H.z121_birth_stat(STATKEY_CON, 1)
		if("Bookworm - INT +1, PER +2, WIL +2, STR -2, CON -2")
			to_chat(H, span_notice("You are learned and wise."))
			H.z121_birth_stat(STATKEY_INT, 1)
			H.z121_birth_stat(STATKEY_PER, 2)
			H.z121_birth_stat(STATKEY_WIL, 2)
			H.z121_birth_stat(STATKEY_STR, -2)
			H.z121_birth_stat(STATKEY_CON, -2)
		if("Toned - STR +1, CON +1, WIL +1, INT -1")
			to_chat(H, span_notice("You are strong and hardy."))
			H.z121_birth_stat(STATKEY_STR, 1)
			H.z121_birth_stat(STATKEY_CON, 1)
			H.z121_birth_stat(STATKEY_WIL, 1)
			H.z121_birth_stat(STATKEY_INT, -1)
		if("All-Rounded - No Changes")
			to_chat(H, span_notice("You are balanced in all aspects."))




	var/profession_sets = list(
		"Physiker Set" = list(
			/obj/item/bedroll,
			/obj/item/rogueweapon/huntingknife/scissors,
			/obj/item/storage/belt/rogue/surgery_bag/full,
			/obj/item/storage/belt/rogue/pouch/medicine,
			/obj/effect/proc_holder/spell/invoked/diagnose/secular,
			/obj/item/storage/magebag/alchemist,
			/obj/item/folding_table_stored
		),
		"Provider Set" = list(
			/obj/item/storage/roguebag/food,
			/obj/item/folding_table_stored,
			/obj/item/storage/meatbag,
			/obj/item/millstone,
			/obj/item/rogueweapon/hoe
		),
		"Prospector Set" = list(
			/obj/item/rogueweapon/hammer/steel,
			/obj/item/folding_table_stored,
			/obj/item/lockpickring/mundane,
			/obj/item/rogueweapon/pick,
			/obj/item/rogueweapon/huntingknife/scissors,
			/obj/item/rogueweapon/scabbard/gwstrap
		),
		"Blacksmith Set" = list(
			/obj/item/rogueweapon/hammer/copper,
			/obj/item/rogueweapon/tongs,
			/obj/item/rogueweapon/huntingknife/bronze,
			/obj/item/ingot/iron,
			/obj/item/ingot/iron,
			/obj/item/rogueore/coal
		),
		"Craftsman Set" = list(
			/obj/item/rogueweapon/stoneaxe/handaxe,
			/obj/item/rogueweapon/hammer/steel,
			/obj/item/folding_table_stored
		),
		"Hunter Set" = list(
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow,
			/obj/item/quiver/arrows,
			/obj/item/rogueweapon/huntingknife/bronze,
			/obj/item/storage/meatbag,
			/obj/item/natural/worms,
			/obj/item/natural/worms
		),
		"Fisher Set" = list(
			/obj/item/fishingrod,
			/obj/item/natural/worms,
			/obj/item/natural/worms,
			/obj/item/natural/worms,
			/obj/item/rogueweapon/huntingknife/bronze,
			/obj/item/storage/roguebag
		),
		"Tailor Set" = list(
			/obj/item/rogueweapon/huntingknife/scissors,
			/obj/item/needle,
			/obj/item/natural/cloth,
			/obj/item/natural/cloth,
			/obj/item/natural/cloth,
			/obj/item/natural/bundle/fibers
		),
		"Scribe Set" = list(
			/obj/item/paper,
			/obj/item/paper,
			/obj/item/paper,
			/obj/item/paper/scroll,
			/obj/item/natural/feather
		)
	)


	var/daily_tools_combos = list(
		"Bronze Axe + Bronze Knife + Sheath" = list(/obj/item/rogueweapon/stoneaxe/woodcut/bronze, /obj/item/rogueweapon/huntingknife/bronze, /obj/item/rogueweapon/scabbard/sheath),
		"Simple Bow + Quiver" = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow, /obj/item/quiver/arrows),
		"Iron Spear + Backup Dagger" = list(/obj/item/rogueweapon/spear, /obj/item/rogueweapon/huntingknife/bronze, /obj/item/rogueweapon/scabbard/gwstrap),
		"Fishing Rod + Worms" = list(/obj/item/fishingrod, /obj/item/natural/worms, /obj/item/natural/worms),
		"Sickle + Farming Hoe" = list(/obj/item/rogueweapon/sickle, /obj/item/rogueweapon/hoe),
		"Mining Pick + Copper Hammer" = list(/obj/item/rogueweapon/pick, /obj/item/rogueweapon/hammer/copper),
		"Cudgel + Rope" = list(/obj/item/rogueweapon/mace/cudgel, /obj/item/rope, /obj/item/rope)
	)

	if(H.mind)

		for(var/i in 1 to 1)
			var/profession_set_name = input(H, "Choose a profession set [i]/1.", "Profession Sets") as anything in profession_sets
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
				if(profession_set_name == "Craftsman Set")
					H.z121_birth_trait(TRAIT_MASTER_CARPENTER, TRAIT_GENERIC)
					H.z121_birth_trait(TRAIT_MASTER_MASON, TRAIT_GENERIC)
				if(profession_set_name in profession_sets)
					profession_sets -= profession_set_name


		var/combo_name = input(H, "Choose a daily tools combination [1/1].", "Daily Tools") as anything in daily_tools_combos
		if(combo_name)
			var/combo_list = daily_tools_combos[combo_name]
			var/counter = 1
			for(var/item_path in combo_list)
				var/item_name = initial(item_path:name)
				var/unique_key = "[item_name] ([combo_name] [counter])"
				H.z121_birth_stash(unique_key, item_path)
				counter++


	var/outfit_styles = list(
		"Laborer - Worker vest, trou, boots",
		"Field Hand - Straw hat, shortshirt, trou",
		"Woodsman - Hood, workervest, bracers",
		"Fisher - Fisherhat, shortshirt, work vest",
		"Artisan - Tunic, tights, furcloak",
		"Seamster - Armordress, white tunic, cloth belt",
		"Traveler - Half cloak, undershirt, boots",
		"Rustic - Fur hat, shortshirt, leather boots",
		"Miner - Arming cap, trou, work vest",
		"Entertainer - Fancy hat, tunic, half cloak",
		"Modest Scholar - Spectacles, scholar's robe, chaperon",
		"Countryside - Straw hat, chemise, shortboots"
	)

	var/outfit_choice = input(H, "Choose your outfit style.", "Outfit Selection") as anything in outfit_styles


	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor

	switch(outfit_choice)
		if("Laborer - Worker vest, trou, boots")
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

		if("Field Hand - Straw hat, shortshirt, trou")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				pants = /obj/item/clothing/under/roguetown/trou
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/strawhat

		if("Woodsman - Hood, workervest, bracers")
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

		if("Fisher - Fisherhat, shortshirt, work vest")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
			else
				pants = /obj/item/clothing/under/roguetown/tights/random
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/fisherhat

		if("Artisan - Tunic, tights, furcloak")
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			cloak = /obj/item/clothing/cloak/raincloak/furcloak
			head = /obj/item/clothing/head/roguetown/hatblu

		if("Seamster - Armordress, white tunic, cloth belt")
			armor = /obj/item/clothing/suit/roguetown/armor/armordress
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			cloak = /obj/item/clothing/cloak/raincloak/furcloak
			belt = /obj/item/storage/belt/rogue/leather/cloth/lady

		if("Traveler - Half cloak, undershirt, boots")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
				pants = /obj/item/clothing/under/roguetown/trou
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			cloak = /obj/item/clothing/cloak/half
			head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood

		if("Rustic - Fur hat, shortshirt, leather boots")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				pants = /obj/item/clothing/under/roguetown/trou
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/hatfur

		if("Miner - Arming cap, trou, work vest")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/brown
			else
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
				pants = /obj/item/clothing/under/roguetown/trou
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
			head = /obj/item/clothing/head/roguetown/armingcap
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather

		if("Entertainer - Fancy hat, tunic, half cloak")
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			cloak = /obj/item/clothing/cloak/half
			head = /obj/item/clothing/head/roguetown/fancyhat
			belt = /obj/item/storage/belt/rogue/leather/cloth

		if("Modest Scholar - Spectacles, tunic, chaperon")
			shirt = /obj/item/clothing/suit/roguetown/shirt/robe/archivist
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			head = /obj/item/clothing/head/roguetown/chaperon
			mask = /obj/item/clothing/mask/rogue/spectacles

		if("Countryside - Straw hat, chemise, shortboots")
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
			"Stealing" = /datum/skill/misc/stealing,
			"Music" = /datum/skill/misc/music,
			"Reading" = /datum/skill/misc/reading,
			"Medicine" = /datum/skill/misc/medicine,
			"Tracking" = /datum/skill/misc/tracking,
			"Lockpicking" = /datum/skill/misc/lockpicking,
			"Sneaking" = /datum/skill/misc/sneaking,
			"Riding" = /datum/skill/misc/riding
		)
		var/labor_skills = list(
			"Farming" = /datum/skill/labor/farming,
			"Lumberjacking" = /datum/skill/labor/lumberjacking,
			"Fishing" = /datum/skill/labor/fishing,
			"Butchering" = /datum/skill/labor/butchering,
			"Mining" = /datum/skill/labor/mining
		)
		var/craft_skills = list(
			"Sewing" = /datum/skill/craft/sewing,
			"Ceramics" = /datum/skill/craft/ceramics,
			"Carpentry" = /datum/skill/craft/carpentry,
			"Masonry" = /datum/skill/craft/masonry,
			"Engineering" = /datum/skill/craft/engineering,
			"Alchemy" = /datum/skill/craft/alchemy,
			"Tanning" = /datum/skill/craft/tanning,
			"Cooking" = /datum/skill/craft/cooking,
			"Weaponsmithing" = /datum/skill/craft/weaponsmithing,
			"Armorsmithing" = /datum/skill/craft/armorsmithing,
			"Blacksmithing" = /datum/skill/craft/blacksmithing,
			"Smelting" = /datum/skill/craft/smelting
		)
		var/combat_skills = list(
			"Axes" = /datum/skill/combat/axes,
			"Unarmed" = /datum/skill/combat/unarmed,
			"Knives" = /datum/skill/combat/knives,
			"Wrestling" = /datum/skill/combat/wrestling,
			"Whips & Flails" = /datum/skill/combat/whipsflails,
			"Bows" = /datum/skill/combat/bows,
			"Crossbows" = /datum/skill/combat/crossbows,
			"Polearms" = /datum/skill/combat/polearms,
			"Shields" = /datum/skill/combat/shields,
			"Slings" = /datum/skill/combat/slings,
			"Swords" = /datum/skill/combat/swords,
			"Maces" = /datum/skill/combat/maces
		)


		var/expert_skill_name = input(H, "Choose one skill to EXPERT. [1/1]", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills
		if(expert_skill_name)
			H.z121_birth_skill_floor(misc_skills[expert_skill_name] || labor_skills[expert_skill_name] || craft_skills[expert_skill_name], SKILL_LEVEL_EXPERT, TRUE)
			if(expert_skill_name in misc_skills)
				misc_skills -= expert_skill_name
			if(expert_skill_name in labor_skills)
				labor_skills -= expert_skill_name
			if(expert_skill_name in craft_skills)
				craft_skills -= expert_skill_name


		for(var/i in 1 to 4)
			var/journeyman_name = input(H, "Choose a skill to JOURNEYMAN. [i]/4", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills + combat_skills
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
			var/apprentice_name = input(H, "Choose a skill to APPRENTICE. [i]/3", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills + combat_skills
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
			var/novice_name = input(H, "Choose a skill to NOVICE. [i]/5", "Skill Selection") as anything in misc_skills + labor_skills + craft_skills + combat_skills
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
	..()
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
		var/weapons = list("Machete","Hatchet")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Machete")
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/short/messer/iron
				H.z121_birth_skill_floor(/datum/skill/combat/swords, 2, TRUE)
			if("Hatchet")
				beltl = /obj/item/rogueweapon/stoneaxe/handaxe
				H.z121_birth_skill_floor(/datum/skill/combat/axes, 2, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/hunter.dm
/datum/outfit/job/roguetown/adventurer/hunter_spear/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a hunter who specializes in spears, excelling in strength and endurance."))
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
	..()
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
	..()
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
		var/weapons = list("Accordion","Bagpipe","Drum","Flute","Guitar","Harp","Hurdy-Gurdy","Jaw Harp","Lute","Psyaltery","Shamisen","Trumpet","Viola","Vocal Talisman")
		var/weapon_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", weapons)
		H.set_blindness(0)
		switch(weapon_choice)
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Bagpipe")
				backr = /obj/item/rogue/instrument/bagpipe
			if("Drum")
				backr = /obj/item/rogue/instrument/drum
			if("Flute")
				backr = /obj/item/rogue/instrument/flute
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Jaw Harp")
				backr = /obj/item/rogue/instrument/jawharp
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery
			if("Shamisen")
				backr = /obj/item/rogue/instrument/shamisen
			if("Trumpet")
				backr = /obj/item/rogue/instrument/trumpet
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/misc/music, 6, TRUE)

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/peasant.dm
/datum/outfit/job/roguetown/adventurer/peasant/pre_equip(mob/living/carbon/human/H)
	..()
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
	..()
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
	..()
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
	..()
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
	..()
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
	..()
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
	..()
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
	..()

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
	..()
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
	..()
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
	..()
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

	var/classes = list("Goon", "Miscreant", "Muscle", "Longshoreman")
	var/classchoice = input(H, "What kind of thug are you?", "TAKE UP ARMS") as anything in classes

	switch(classchoice)

		if("Goon")
			H.mind.cosmetic_class_title = "Goon"
			to_chat(H, span_warning("You're a goon, a low-lyfe thug in a painful world - not good enough for war, not smart enough for peace. What you lack in station you make up for in daring."))
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
			var/options = list("Frypan", "Knuckles", "Navaja", "Bare Hands")
			var/option_choice = input(H, "Choose your means.", "TAKE UP ARMS") as anything in options

			switch(option_choice)
				if("Frypan")
					H.z121_birth_skill_floor(/datum/skill/craft/cooking, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/cooking/pan
				if("Knuckles")
					H.z121_birth_skill_floor(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/rogueweapon/knuckles
				if("Navaja")
					H.z121_birth_skill_floor(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/rogueweapon/huntingknife/idagger/navaja
				if("Bare Hands")
					H.z121_birth_skill_floor(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
					H.z121_birth_trait(TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)

		if("Miscreant")
			H.mind.cosmetic_class_title = "Miscreant"
			to_chat(H, span_warning("You're smarter than the rest, by a stone's throw - and you know better than to get up close and personal. Unlike most others, you can read."))
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

			var/options = list("Stone Sling", "Magic Bricks", "Lockpicking Equipment")
			var/option_choice = input(H, "Choose your means.", "TAKE UP ARMS") as anything in options

			switch(option_choice)
				if("Stone Sling")
					H.z121_birth_skill_floor(/datum/skill/combat/slings, SKILL_LEVEL_EXPERT, TRUE)
					r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
					l_hand = /obj/item/quiver/sling
				if("Magic Bricks")
					H.z121_birth_skill_floor(/datum/skill/magic/arcane, SKILL_LEVEL_EXPERT, TRUE)
					H.z121_birth_spell(new /obj/effect/proc_holder/spell/self/magicians_brick)
					H.z121_birth_trait(TRAIT_ARCYNE_T1, TRAIT_GENERIC)
				if("Lockpicking Equipment")
					H.z121_birth_skill_floor(/datum/skill/misc/sneaking, SKILL_LEVEL_EXPERT, TRUE)
					H.z121_birth_skill_floor(/datum/skill/misc/stealing, SKILL_LEVEL_EXPERT, TRUE)
					H.z121_birth_skill_floor(/datum/skill/misc/lockpicking, SKILL_LEVEL_EXPERT, TRUE)
					H.z121_birth_trait(TRAIT_LIGHT_STEP, TRAIT_GENERIC)
					r_hand = /obj/item/lockpickring/mundane

		if("Muscle")
			H.mind.cosmetic_class_title = "Muscle"
			to_chat(H, span_warning("More akin to a corn-fed monster than a normal man, your size and strength are your greatest weapons; though they hardly supplement what's missing of your brains."))
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

			var/options = list("Hands-On", "Big Axe", "Big Stick")
			var/option_choice = input(H, "Choose your means.", "TAKE UP ARMS") as anything in options

			switch(option_choice)
				if("Hands-On")
					H.z121_birth_trait(TRAIT_BIGGUY, TRAIT_GENERIC)
					H.z121_birth_trait(TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				if("Big Axe")
					H.z121_birth_skill_floor(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/greataxe
				if("Big Stick")
					H.z121_birth_skill_floor(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
					r_hand = /obj/item/rogueweapon/mace

		if("Longshoreman")
			H.mind.cosmetic_class_title = "Longshoreman"
			to_chat(H, span_warning("You answered Abyssor's call when you were young, though in troublesome ways, \
	pilaging for treasury from anyone who'd cross your path. Now your captain retires from a life of crime, \
	settling down as do you. Still, there is coin to be made on land."))
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

	var/gang = list("Gang Rontz Ratz", "Gang Blortz Volves", "Neverminde")
	var/gang_choice = input(H, "Want to become a gang member?") as anything in gang

	switch(gang_choice)
		if("Gang Rontz Ratz")
			to_chat(H, span_warning("I'm a member of street gang Rontz Ratz, a lot of time has passed and now we have to build up our power again,\
			those bastards from Blortz Volves will answer for this.\
			Rontz Rats bite - feel the fight!"))
			H.z121_birth_trait(TRAIT_GANG_A, TRAIT_GENERIC)
			mask = /obj/item/clothing/mask/rogue/ragmask/red
		if("Gang Blortz Volves")
			to_chat(H, span_warning("I'm a member of street gang Blortz Volves, a lot of time has passed and now we have to build up our power again, \
			those bastards from Rontz Ratz will answer for this. \
			Blortz Wolves howl - enemies cower!"))
			H.z121_birth_trait(TRAIT_GANG_B, TRAIT_GENERIC)
			mask = /obj/item/clothing/mask/rogue/ragmask/azure
		if("Neverminde")
			return null

// 来源：code/modules/jobs/job_types/roguetown/adventurer/types/pilgrim/townelder.dm
/datum/outfit/job/roguetown/elder/pre_equip(mob/living/carbon/human/H)
	..()
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
	..()
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
		"Witch Hat" 		= /obj/item/clothing/head/roguetown/witchhat,
		"Witch Hat (Old)"	= /obj/item/clothing/head/roguetown/witchhat/old,
		"None"
	)
	var/hatchoice = input(H, "Choose your hat.", "WITCH ATTIRE") as anything in hats
	if(hatchoice != "None")
		head = hats[hatchoice]

	var/classes = list("Old Magick", "Godsblood", "Mystagogue")
	var/classchoice = input("How do your powers manifest?", "THE OLD WAYS") as anything in classes

	var/shapeshifts = list("Zad", "Cat", "Cat (Black)", "Bat", "Cabbit", "Small Rous", "Lesser Venard", "Lesser Volf", "Frog")
	var/shapeshiftchoice = input("What form does your second skin take?", "THE OLD WAYS") as anything in shapeshifts

	switch (classchoice)
		if("Old Magick")

			H.z121_birth_trait(TRAIT_ARCYNE_T2, TRAIT_GENERIC)
			H.z121_birth_skill_add(/datum/skill/magic/arcane, 1, TRUE)
			H.z121_birth_points(9)
			neck = null
		if("Godsblood")

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
		if("Mystagogue")

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
			if("Zad")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/crow)
			if("Cat")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat)
			if("Cat (Black)")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat/black)
			if("Bat")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/bat)
			if("Lesser Volf")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_wolf)
			if("Lesser Venard")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_vernard)
			if("Small Rous")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/rous)
			if("Cabbit")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cabbit)
			if("Frog")
				H.z121_birth_spell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/frog)

		switch (classchoice)
			if("Old Magick")
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
	..()
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
	..()
	to_chat(H, span_warning("You make your coin peddling imported alcohols from all over the world, though you're no stranger to the craft, and have experience brewing your own ale in a pinch. You have the equipments and know how on how to make your own distiller, too."))
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
	..()
	to_chat(H, span_warning("Whether a disciple of a culinary school, a storied royal chef, or a mercenary cook for hire, your trade is plied at the counter, \
	the cutting board, and the hearth."))
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
	..()
	to_chat(H, span_warning("THE WORLD IS ENDING!!! At least, that's what you want your clients to believe. You'll offer them a safe place in the new world, of course - built by yours truly."))
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
	..()
	to_chat(H, span_warning ("You are a travelling entertainer - a jester by trade. Where you go, chaos follows - and mischief is made."))
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
		var/weapons = list("Accordion","Bagpipe", "Banjo","Drum","Flute","Guitar","Harmonica","Harp","Hurdy-Gurdy","Jaw Harp","Lute","Psyaltery","Shamisen","Trumpet","Viola","Vocal Talisman")
		var/weapon_choice = input(H, "Choose your instrument.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Bagpipe")
				backr = /obj/item/rogue/instrument/bagpipe
			if("Banjo")
				backr = /obj/item/rogue/instrument/banjo
			if("Drum")
				backr = /obj/item/rogue/instrument/drum
			if("Flute")
				backr = /obj/item/rogue/instrument/flute
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Harmonica")
				backr = /obj/item/rogue/instrument/harmonica
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Jaw Harp")
				backr = /obj/item/rogue/instrument/jawharp
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery
			if("Shamisen")
				backr = /obj/item/rogue/instrument/shamisen
			if("Trumpet")
				backr = /obj/item/rogue/instrument/trumpet
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals

// 来源：code/modules/jobs/job_types/roguetown/trader/jeweler.dm
/datum/outfit/job/roguetown/adventurer/trader/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You make your coin peddling exotic jewelry, gems, and shiny things."))
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
	..()
	to_chat(H, span_warning("You make your coin peddling in spices and performing back-alley 'medical' procedures. Hope your patient didn't need that kidney."))
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
	..()
	to_chat(H, span_warning("You are a scholar traveling the world in order to write a book about your ventures. Although not quite as dedicated to your studies as some, you trade in stories and tales of your travels."))
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
