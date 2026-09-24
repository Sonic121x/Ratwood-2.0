/datum/crafting_recipe/roguetown/structure/composter
	name = "堆肥箱"
	result = /obj/structure/composter
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "建造"
	verbage = "建造"
	craftdiff = 0
	time = 2 SECONDS

/datum/crafting_recipe/roguetown/structure/plough
	name = "犁"
	result = /obj/structure/plough
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/ingot/iron = 1)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/carpentry
	time = 4 SECONDS

/datum/crafting_recipe/roguetown/survival/dryleaf
	name = "晾干沼泽烟叶"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "晾干"
	verbage = "晾干"
	craftsound = null
	skillcraft = null

/datum/crafting_recipe/roguetown/survival/drytea
	name = "晾干茶叶"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/tea = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "晾干"
	verbage = "晾干"
	craftsound = null
	skillcraft = null

/datum/crafting_recipe/roguetown/survival/dryweed
	name = "晾干西池烟叶"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "晾干"
	verbage = "晾干"
	craftsound = null
	skillcraft = null

/datum/crafting_recipe/roguetown/survival/dryrosa
	name = "晾干玫瑰花瓣"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "晾干"
	verbage = "晾干"
	craftsound = null
	skillcraft = null

/datum/crafting_recipe/roguetown/survival/sigsweet
	name = "沼泽烟叶卷烟"
	result = /obj/item/clothing/mask/cigarette/rollie/cannabis
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1,
		/obj/item/paper = 1,
		)
	time = 10 SECONDS
	verbage_simple = "卷制"
	verbage = "卷制"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/sigsweet/cheroot
	name = "沼泽烟叶雪茄"
	result = /obj/item/clothing/mask/cigarette/rollie/cannabis/cheroot
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1,
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
		)
	time = 10 SECONDS
	verbage_simple = "卷制"
	verbage = "卷制"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/sigdry
	name = "西池烟叶卷烟"
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
		/obj/item/paper = 1,
		)
	time = 10 SECONDS
	verbage_simple = "卷制"
	verbage = "卷制"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/sigdry/cheroot
	name = "西池烟叶雪茄"
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine/cheroot
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1,
		)
	time = 10 SECONDS
	verbage_simple = "卷制"
	verbage = "卷制"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/rocknutdry
	name = "石果卷烟"
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine
	reqs = list(
		/obj/item/reagent_containers/powder/rocknut = 1,
		/obj/item/paper = 1,
		)
	time = 10 SECONDS
	verbage_simple = "卷制"
	verbage = "卷制"
	craftdiff = 0
