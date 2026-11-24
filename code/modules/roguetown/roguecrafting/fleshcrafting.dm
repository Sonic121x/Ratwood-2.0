/datum/crafting_recipe/roguetown/fleshcrafting
	abstract_type = /datum/crafting_recipe/roguetown/fleshcrafting
	req_table = FALSE
	verbage_simple = "组装"
	skillcraft = /datum/skill/labor/butchering
	subtype_reqs = TRUE
	structurecraft = /obj/structure/roguemachine/chimeric_heart_beast

/datum/crafting_recipe/roguetown/fleshcrafting/decoy
	name = "血肉诱饵（2 份鲜肉）"
	category = "血肉"
	result = list(/obj/item/flesh_decoy)
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat = 2)
	structurecraft = null
	craftdiff = 2
	required_tech_node = "FLESH_DECOYS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/decoy_alt
	name = "血肉诱饵（2 份内脏）"
	category = "血肉"
	result = list(/obj/item/flesh_decoy)
	reqs = list(/obj/item/alch/viscera = 2)
	structurecraft = null
	craftdiff = 2
	required_tech_node = "VISCERA_DECOYS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/flesh_node // flesh nodes need to be made with beast, organs dont, but need the nodes
	name = "血肉结节（1 份腐肉）"
	category = "血肉"
	result = list(/obj/item/flesh_node)
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 1)
	craftdiff = 1
	required_tech_node = "FLESH_NODE"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/lungs
	name = "肺"
	category = "血肉"
	result = list(/obj/item/organ/lungs,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	structurecraft = null
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/heart
	name = "心脏"
	category = "血肉"
	result = list(/obj/item/organ/heart,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/liver
	name = "肝脏"
	category = "血肉"
	result = list(/obj/item/organ/liver,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	structurecraft = null
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/stomach
	name = "胃"
	category = "血肉"
	result = list(/obj/item/organ/stomach,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/eyes
	name = "眼球"
	category = "血肉"
	result = list(/obj/item/organ/eyes,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	structurecraft = null	
	tech_unlocked = FALSE
	
/datum/crafting_recipe/roguetown/fleshcrafting/ear
	name = "耳朵"
	category = "血肉"
	result = list(/obj/item/organ/ears,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	structurecraft = null	
	tech_unlocked = FALSE


/datum/crafting_recipe/roguetown/fleshcrafting/tongue
	name = "舌头"
	category = "血肉"
	result = list(/obj/item/organ/tongue,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "BASIC_ORGANS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/r_arm
	name = "右臂"
	category = "血肉"
	result = list(/obj/item/bodypart/r_arm,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 3
	required_tech_node = "BASIC_BODYPARTS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/l_arm
	name = "左臂"
	category = "血肉"
	result = list(/obj/item/bodypart/l_arm,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 3
	required_tech_node = "BASIC_BODYPARTS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/r_leg
	name = "右腿"
	category = "血肉"
	result = list(/obj/item/bodypart/r_leg,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 3
	required_tech_node = "BASIC_BODYPARTS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/l_leg
	name = "左腿"
	category = "血肉"
	result = list(/obj/item/bodypart/l_leg,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 1,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 3
	required_tech_node = "BASIC_BODYPARTS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/head // build a abomination!
	name = "头"
	category = "血肉"
	result = list(/obj/item/bodypart/head/filled,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 2,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "ADVANCED_BODYPARTS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/chest
	name = "躯干"
	category = "血肉"
	result = list(/mob/living/carbon/human/species/human/northern/torso,
				/obj/item/heart_blood_vial,)
	reqs = list(/obj/item/flesh_node = 2,
				/obj/item/heart_blood_vial/filled
	)
	craftdiff = 4
	required_tech_node = "ADVANCED_BODYPARTS"
	tech_unlocked = FALSE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/human // yea that one needs heart help. GO FORTH FRANKENSTAIN!!!
	name = "新生"
	category = "血肉"
	result = list(/mob/living/carbon/human/species/human/northern,)
	reqs = list(/obj/item/flesh_node = 7,
				/obj/item/heart_blood_vial/filled = 3,
				/obj/item/reagent_containers/lux = 1,)
	craftdiff = 5
	required_tech_node = "LIFE_CREATION"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/black_rose
	name = "黑玫瑰"
	category = "血肉"
	result = list(/obj/item/black_rose)
	reqs = list(/obj/item/heart_blood_canister/filled = 5,
				/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 15)
	craftdiff = 5
	required_tech_node = "BLACK_ROSE"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/fleshcrafting/leechbait
	name = "水蛭饵"
	craftdiff = 1
	result = list(
		/obj/item/bait/leech,
		/obj/item/bait/leech,
		/obj/item/bait/leech,
		)
	reqs = list(
		/obj/item/storage/roguebag = 3,
		/obj/item/reagent_containers/lux_impure = 1,
		)
	subtype_reqs = TRUE
	structurecraft = null

/datum/crafting_recipe/roguetown/fleshcrafting/imperfect_gnoll
	name = "邪孽血肉"
	craftdiff = 1
	result = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn
		)
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll = 1,
		/obj/item/roguegem/blood_diamond = 1,
		)
	subtype_reqs = TRUE
	structurecraft = null
