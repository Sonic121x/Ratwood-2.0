/obj/item/seeds
	name = "种子"
	icon = 'icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	possible_item_intents = list(/datum/intent/use)
	var/plant_def_type
	var/seed_identity = "某种种子"

	var/cooking = 0
	var/cooktime = 20 SECONDS
	var/burning = 0
	var/burntime = 3 MINUTES

	var/burned_color = "#302d2d"
	var/cooked_smell = /datum/pollutant/food/roasted_seeds
	var/cooked_type = /obj/item/reagent_containers/food/snacks/roastseeds

/obj/item/seeds/Initialize(mapload)
	. = ..()
	if(plant_def_type)
		var/datum/plant_def/def = GLOB.plant_defs[plant_def_type]
		color = def.seed_color

/obj/item/seeds/examine(mob/user)
	. = ..()
	var/show_real_identity = FALSE
	if(isliving(user))
		var/mob/living/living = user
		// Seed knowers, know the seeds (druids and such)
		if(HAS_TRAIT(living, TRAIT_SEEDKNOW))
			show_real_identity = TRUE
		// Journeyman farmers know them too
		else if(living.get_skill_level(/datum/skill/labor/farming) >= 2)
			show_real_identity = TRUE
	else
		show_real_identity = TRUE
	if(show_real_identity)
		. += span_info("我能看出这些是[seed_identity]。")

/obj/item/seeds/attack_turf(turf/T, mob/living/user)
	var/obj/structure/soil/soil = get_soil_on_turf(T)
	if(soil)
		try_plant_seed(user, soil)
		return
	else if(istype(T, /turf/open/floor/rogue/dirt))
		if(!(user.get_skill_level(/datum/skill/labor/farming) >= SKILL_LEVEL_JOURNEYMAN))
			to_chat(user, span_notice("我的农耕知识还不足以让我徒手整地。"))
			return
		to_chat(user, span_notice("我开始为种子堆起一个小土堆……"))
		if(do_after(user, get_farming_do_time(user, 10 SECONDS), target = src))
			apply_farming_fatigue(user, 30)
			soil = get_soil_on_turf(T)
			if(!soil)
				soil = new /obj/structure/soil(T)
		return
	. = ..()

/obj/item/seeds/proc/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(soil.plant)
		to_chat(user, span_warning("\the [soil]里已经种了别的东西！"))
		return
	if(!plant_def_type)
		return
	to_chat(user, span_notice("我把\the [src]种进了\the [soil]里。"))
	soil.insert_plant(GLOB.plant_defs[plant_def_type])
	qdel(src)

// Cook a seed, burninput is separate so that burning doesn't scale up with skills. Based on 'snacks.dm'
/obj/item/seeds/cooking(input as num, burninput, atom/A)
	if(!input)
		return
	if(cooktime)
		var/added_input = input
		if(cooking < cooktime)
			cooking = cooking + added_input
			if(cooking >= cooktime)
				return heating_act(A)
			return
	burning(burninput)

/obj/item/seeds/heating_act(atom/A)
	if(istype(A,/obj/machinery/light/rogue/oven))
		var/obj/item/result
		if(cooked_type)
			result = new cooked_type(A)
			if(cooked_smell)
				result.AddComponent(/datum/component/temporary_pollution_emission, cooked_smell, 20, 5 MINUTES)
		else
			result = new /obj/item/reagent_containers/food/snacks/badrecipe(A)
		initialize_cooked_seed(result, 1)
		return result
	if(istype(A,/obj/machinery/light/rogue/hearth) || istype(A,/obj/machinery/light/rogue/firebowl) || istype(A,/obj/machinery/light/rogue/campfire) || istype(A,/obj/machinery/light/rogue/hearth/mobilestove))
		var/obj/item/result
		if(cooked_type)
			result = new cooked_type(A)
			if(cooked_smell)
				result.AddComponent(/datum/component/temporary_pollution_emission, cooked_smell, 20, 5 MINUTES)
		else
			result = new /obj/item/reagent_containers/food/snacks/badrecipe(A)
		initialize_cooked_seed(result, 1)
		return result
	var/obj/item/result = new /obj/item/reagent_containers/food/snacks/badrecipe(A)
	initialize_cooked_seed(result, 1)
	return result

/obj/item/seeds/burning(input as num)
	if(!input)
		return
	if(burntime)
		burning = burning + input
		if(burning >= burntime)
			name = "烧焦的[name]"
			color = burned_color
		if(burning > (burntime * 2))
			burn()

/obj/item/seeds/proc/initialize_cooked_seed(obj/item/seeds/S, cooking_efficiency = 1)
	if(reagents)
		reagents.trans_to(S, reagents.total_volume)

/obj/item/seeds/random
	name = "random seed"
	desc = "Haha, im in danger."

/obj/item/seeds/random/Initialize(mapload)
	var/type = pick(list(
	/obj/item/seeds/wheat,
	/obj/item/seeds/wheat/oat,
	/obj/item/seeds/rice,
	/obj/item/seeds/apple,
	/obj/item/seeds/pear,
	/obj/item/seeds/lemon,
	/obj/item/seeds/lime,
	/obj/item/seeds/tangerine,
	/obj/item/seeds/plum,
	/obj/item/seeds/strawberry,
	/obj/item/seeds/blackberry,
	/obj/item/seeds/raspberry,
	/obj/item/seeds/tomato,
	/obj/item/seeds/nut,
	/obj/item/seeds/sugarcane,
	/obj/item/seeds/pipeweed,
	/obj/item/seeds/swampweed,
	/obj/item/seeds/berryrogue,
	/obj/item/seeds/turnip,
	/obj/item/seeds/sunflower,
	/obj/item/seeds/onion,
	/obj/item/seeds/cabbage,
	/obj/item/seeds/potato,
	/obj/item/seeds/fyritius,
	/obj/item/seeds/poppy,
	/obj/item/seeds/garlick,
	/obj/item/seeds/coffee,
	/obj/item/seeds/tea,
	/obj/item/seeds/pumpkin,
	/obj/item/seeds/carrot,
	/obj/item/seeds/cucumber,
	/obj/item/seeds/eggplant,))

	var/obj/item/seeds/boi = new type
	boi.forceMove(get_turf(src))
	boi.pixel_x += rand(-3,3)
	. = ..()

	return INITIALIZE_HINT_QDEL

/obj/item/seeds/wheat
	seed_identity = "小麦种子"
	plant_def_type = /datum/plant_def/wheat

/obj/item/seeds/wheat/oat
	seed_identity = "燕麦种子"
	plant_def_type = /datum/plant_def/oat

/obj/item/seeds/rice
	seed_identity = "水稻种子"
	plant_def_type = /datum/plant_def/rice

/obj/item/seeds/apple
	seed_identity = "苹果种子"
	plant_def_type = /datum/plant_def/tree/apple

/obj/item/seeds/pear
	seed_identity = "梨种子"
	plant_def_type = /datum/plant_def/tree/pear

/obj/item/seeds/lemon
	seed_identity = "柠檬种子"
	plant_def_type = /datum/plant_def/tree/lemon

/obj/item/seeds/lime
	seed_identity = "青柠种子"
	plant_def_type = /datum/plant_def/tree/lime

/obj/item/seeds/tangerine
	seed_identity = "橘子种子"
	plant_def_type = /datum/plant_def/tree/tangerine

/obj/item/seeds/plum
	seed_identity = "李子种子"
	plant_def_type = /datum/plant_def/tree/plum

/obj/item/seeds/strawberry
	seed_identity = "草莓种子"
	plant_def_type = /datum/plant_def/bush/strawberry

/obj/item/seeds/blackberry
	seed_identity = "黑莓种子"
	plant_def_type = /datum/plant_def/bush/blackberry

/obj/item/seeds/raspberry
	seed_identity = "覆盆子种子"
	plant_def_type = /datum/plant_def/bush/raspberry

/obj/item/seeds/tomato
	seed_identity = "番茄种子"
	plant_def_type = /datum/plant_def/bush/tomato

/obj/item/seeds/nut
	seed_identity = "石果种子"
	plant_def_type = /datum/plant_def/nut

/obj/item/seeds/sugarcane
	seed_identity = "甘蔗种子"
	plant_def_type = /datum/plant_def/sugarcane

/obj/item/seeds/pipeweed
	seed_identity = "西池烟草种子"
	plant_def_type = /datum/plant_def/pipeweed

/obj/item/seeds/swampweed
	seed_identity = "沼泽烟草种子"
	plant_def_type = /datum/plant_def/swampweed

/obj/item/seeds/berryrogue
	seed_identity = "浆果种子"
	plant_def_type = /datum/plant_def/bush/berry

/obj/item/seeds/berryrogue/poison
	seed_identity = "浆果种子"
	plant_def_type = /datum/plant_def/bush/berry_poison
	cooked_type = /obj/item/reagent_containers/food/snacks/grown/pepperseed //The rancid effects? Have you imagined eating a handful of grape-sized peppercorns before? That'd probably do a number on anyone.

/obj/item/seeds/turnip
	seed_identity = "芜菁种子"
	plant_def_type = /datum/plant_def/turnip

/obj/item/seeds/sunflower
	seed_identity = "向日葵种子"
	plant_def_type = /datum/plant_def/sunflower
	cooked_type = /obj/item/reagent_containers/food/snacks/roastseeds/sunflower

/obj/item/seeds/onion
	seed_identity = "洋葱种子"
	plant_def_type = /datum/plant_def/onion

/obj/item/seeds/cabbage
	seed_identity = "卷心菜种子"
	plant_def_type = /datum/plant_def/cabbage

/obj/item/seeds/potato
	seed_identity = "土豆种子"
	plant_def_type = /datum/plant_def/potato

/obj/item/seeds/fyritius
	seed_identity = "焰蕊花种子"
	plant_def_type = /datum/plant_def/fyritiusflower

/obj/item/seeds/poppy
	seed_identity = "罂粟种子"
	plant_def_type = /datum/plant_def/poppy

/obj/item/seeds/garlick
	seed_identity = "大蒜种子"
	plant_def_type = /datum/plant_def/garlick

/obj/item/seeds/coffee
	seed_identity = "咖啡种子"
	plant_def_type = /datum/plant_def/coffee

/obj/item/seeds/tea
	seed_identity = "茶树种子"
	plant_def_type = /datum/plant_def/tea

/obj/item/seeds/pumpkin
	seed_identity = "南瓜种子"
	plant_def_type = /datum/plant_def/pumpkin
	cooked_type = /obj/item/reagent_containers/food/snacks/roastseeds/pumpkin

/obj/item/seeds/carrot
	seed_identity = "胡萝卜种子"
	plant_def_type = /datum/plant_def/carrot

/obj/item/seeds/cucumber
	seed_identity = "黄瓜种子"
	plant_def_type = /datum/plant_def/cucumber

/obj/item/seeds/eggplant
	seed_identity = "茄子种子"
	plant_def_type = /datum/plant_def/eggplant

// -- Tree sapling seeds (Dendor druid content) ----------------------------
// These bypass the soil plant_def system and directly grow /obj/structure/tree_sapling.
// Require journeyman farming skill to use.

/obj/item/seeds/treesap
	name = "树苗"
	desc = "一株幼小的树苗。将它栽进整好的土壤中，勤加浇水，日后或许能长成参天大树。"
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "palebush_2"
	seed_identity = "树木种子"

/obj/item/seeds/treesap/attack_turf(turf/T, mob/living/user)
	if(user.get_skill_level(/datum/skill/labor/farming) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("我的农耕知识还不足以照料树苗。"))
		return
	if(locate(/obj/structure/tree_sapling) in T)
		to_chat(user, span_warning("这里已经有一株树苗了。"))
		return
	var/obj/structure/soil/existing_soil = locate(/obj/structure/soil) in T
	if(!existing_soil && !istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
		to_chat(user, span_warning("我需要把它种在土壤、泥地或草地上。"))
		return
	to_chat(user, span_notice("我开始为树苗整理土地……"))
	if(!do_after(user, get_farming_do_time(user, 15 SECONDS), target = src))
		return
	apply_farming_fatigue(user, 40)
	// Re-check after delay
	if(locate(/obj/structure/tree_sapling) in T)
		return
	if(!locate(/obj/structure/soil) in T)
		if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
			return
		new /obj/structure/soil(T)
	plant_tree_sapling(T, user)

/obj/item/seeds/treesap/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(user.get_skill_level(/datum/skill/labor/farming) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("我的农耕知识还不足以照料树苗。"))
		return
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("\the [soil]里已经有东西在生长了！"))
		return
	if(locate(/obj/structure/tree_sapling) in get_turf(soil))
		to_chat(user, span_warning("这里已经有一株树苗了。"))
		return
	plant_tree_sapling(get_turf(soil), user)

/obj/item/seeds/treesap/proc/plant_tree_sapling(turf/T, mob/living/user)
	new /obj/structure/tree_sapling(T)
	to_chat(user, span_notice("我小心地栽下树苗，拍实周围的泥土。"))
	qdel(src)

/obj/item/seeds/treesap/pine
	name = "松树苗"
	desc = "一株带着树脂的小树苗。将它栽进整好的土壤中，日后或许能长成高大的松树。"
	icon_state = "palebush_3"
	seed_identity = "松树种子"

/obj/item/seeds/treesap/pine/plant_tree_sapling(turf/T, mob/living/user)
	new /obj/structure/tree_sapling/pine(T)
	to_chat(user, span_notice("我小心地栽下松树苗，拍实周围的泥土。"))
	qdel(src)

/obj/item/seeds/treesap/sakura
	name = "樱树苗"
	desc = "一株泛着粉色的小树苗，来自遥远的异乡，极为罕见。悉心照料，它终会以满树繁花回报你的耐心。"
	icon_state = "palebush_1"
	seed_identity = "樱树种子"

/obj/item/seeds/treesap/sakura/plant_tree_sapling(turf/T, mob/living/user)
	new /obj/structure/tree_sapling/sakura(T)
	to_chat(user, span_notice("我小心地栽下樱树苗，拍实周围的泥土。"))
	qdel(src)

// -- Bush seeds (Dendor druid content) ------------------------------------
// Grows into a staged bush sapling that eventually becomes a harvestable bush,
// then a tall hedge if left unpruned. Requires journeyman farming to plant.

/obj/item/seeds/bush
	name = "灌木种子"
	desc = "一粒坚硬、带刺的种子。将它种进整好的土壤中，勤加浇水，就能长成一丛野生灌木。"
	icon_state = "seed"
	seed_identity = "灌木种子"

/obj/item/seeds/bush/attack_turf(turf/T, mob/living/user)
	if(user.get_skill_level(/datum/skill/labor/farming) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("我的农耕知识还不足以照料灌木幼苗。"))
		return
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in T
	if(locate(/obj/structure/bush_sapling) in T)
		to_chat(user, span_warning("这里已经有一株灌木幼苗了。"))
		return
	if(!soil && !istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
		to_chat(user, span_warning("我需要把它种在土壤、泥地或草地上。"))
		return
	to_chat(user, span_notice("我开始为灌木种子堆起泥土……"))
	if(!do_after(user, get_farming_do_time(user, 10 SECONDS), target = src))
		return
	apply_farming_fatigue(user, 25)
	// Re-check after delay
	if(locate(/obj/structure/bush_sapling) in T)
		return
	if(!soil)
		soil = locate(/obj/structure/soil) in T
		if(!soil)
			if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
				return
			soil = new /obj/structure/soil(T)
	new /obj/structure/bush_sapling(T)
	to_chat(user, span_notice("我种下灌木种子，拍实周围的泥土。"))
	qdel(src)

/obj/item/seeds/bush/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(user.get_skill_level(/datum/skill/labor/farming) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("我的农耕知识还不足以照料灌木幼苗。"))
		return
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("\the [soil]里已经有东西在生长了！"))
		return
	if(locate(/obj/structure/bush_sapling) in get_turf(soil))
		to_chat(user, span_warning("这里已经有一株灌木幼苗了。"))
		return
	new /obj/structure/bush_sapling(get_turf(soil))
	to_chat(user, span_notice("我种下灌木种子，拍实周围的泥土。"))
	qdel(src)

// -- Flower seeds (Dendor druid content) ----------------------------------
// Select a flower type in-hand, then plant in dirt/grass/soil.
// Waters once → blooms into the chosen decorative flower bush after 5 minutes.
// No skill gate — purely decorative.

/obj/item/seeds/flower
	name = "花种"
	desc = "一小包混合花种。在手中点击以选择要种植的花卉，再将种子播入土中并浇水。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "seeds"
	seed_identity = "花种"
	var/flower_sprout_type = null
	var/flower_name = null

/obj/item/seeds/flower/attack_self(mob/living/user)
	var/list/options = list(
		"黄花"        = /obj/structure/flora/ausbushes/ywflowers,
		"蓝红花"    = /obj/structure/flora/ausbushes/brflowers,
		"粉紫花" = /obj/structure/flora/ausbushes/ppflowers,
		"薰衣草"              = /obj/structure/flora/ausbushes/lavendergrass
	)
	var/choice = input(user, "你想用这些种子种出哪种花？", "选择花卉") as null|anything in options
	if(isnull(choice))
		return
	flower_sprout_type = options[choice]
	flower_name = choice
	name = "[LOWER_TEXT(choice)]种子"
	to_chat(user, span_notice("我挑选出[flower_name]的种子，准备种植。"))

/obj/item/seeds/flower/attack_turf(turf/T, mob/living/user)
	if(!flower_sprout_type)
		to_chat(user, span_warning("我还没选好要种什么。先在手中使用种子进行选择。"))
		return
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in T
	if(soil)
		try_plant_seed(user, soil)
		return
	if(!isopenturf(T))
		to_chat(user, span_warning("这里的地面不适合种植。"))
		return
	if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
		to_chat(user, span_warning("我应该把它们种在泥地或草地上。"))
		return
	to_chat(user, span_notice("我把种子撒入土中……"))
	if(!do_after(user, 5 SECONDS, target = src))
		return
	soil = locate(/obj/structure/soil) in T
	if(!soil)
		soil = new /obj/structure/soil(T)
	try_plant_seed(user, soil)

/obj/item/seeds/flower/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(!flower_sprout_type)
		to_chat(user, span_warning("我还没选好要种什么。先在手中使用种子进行选择。"))
		return
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("这里已经有东西在发芽了。"))
		return
	to_chat(user, span_notice("我把花种播进了\the [soil]里。"))
	var/obj/structure/soil_seedling/flower/seedling = new(get_turf(soil))
	seedling.configure_seedling(soil, icon, icon_state, flower_sprout_type, 5 MINUTES)
	qdel(src)

// -- Conjured seed variants (granted by Conjure Floral Seed spell) ----------
// These subtypes vanish the moment they leave the caster's inventory.

/obj/item/seeds/bush/conjured
	name = "召唤的灌木种子"
	desc = "依树父的意志召来的灌木种子。丢下后便会消失。"

/obj/item/seeds/bush/conjured/dropped(mob/user, silent = FALSE)
	. = ..()
	qdel(src)

// Conjured bush seeds bypass the farming skill gate — the druid's blessing provides the knowledge.
/obj/item/seeds/bush/conjured/attack_turf(turf/T, mob/living/user)
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in T
	if(locate(/obj/structure/bush_sapling) in T)
		to_chat(user, span_warning("这里已经有一株灌木幼苗了。"))
		return
	if(!soil && !istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
		to_chat(user, span_warning("我需要把它种在土壤、泥地或草地上。"))
		return
	to_chat(user, span_notice("我开始为灌木种子堆起泥土……"))
	if(!do_after(user, get_farming_do_time(user, 10 SECONDS), target = src))
		return
	// Re-check after delay
	if(locate(/obj/structure/bush_sapling) in T)
		return
	if(!soil)
		soil = locate(/obj/structure/soil) in T
		if(!soil)
			if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
				return
			soil = new /obj/structure/soil(T)
	new /obj/structure/bush_sapling(T)
	to_chat(user, span_notice("我种下灌木种子，拍实周围的泥土。"))
	qdel(src)

/obj/item/seeds/bush/conjured/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("\the [soil]里已经有东西在生长了！"))
		return
	if(locate(/obj/structure/bush_sapling) in get_turf(soil))
		to_chat(user, span_warning("这里已经有一株灌木幼苗了。"))
		return
	new /obj/structure/bush_sapling(get_turf(soil))
	to_chat(user, span_notice("我种下灌木种子，拍实周围的泥土。"))
	qdel(src)

/obj/item/seeds/flower/conjured
	name = "召唤的花种"
	desc = "依树父的意志召来的花种。丢下后便会消失。在手中使用以选择要种植的花卉。"

/obj/item/seeds/flower/conjured/dropped(mob/user, silent = FALSE)
	. = ..()
	qdel(src)

// -- Mushroom Fey Circle Spores ---------------------------
// Can only be planted in BLESSED soil. Seeds a mushroom sprout that blooms
// into a full fey teleport circle after 5 minutes of growing.
// Obtained as a reward from Sanctified Tree category 3 ritual.

/obj/item/seeds/mushroom_fey
	name = "妖精蘑菇孢子"
	desc = "一簇细小苍白的孢子，涌动着奇异的荒野能量。它们只能在受祝福的土壤中扎根。"
	icon_state = "seed"
	color = "#FFFFFF"
	seed_identity = "妖精蘑菇孢子"

/obj/item/seeds/mushroom_fey/attack_turf(turf/T, mob/living/user)
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in T
	if(!soil)
		if(!istype(T, /turf/open/floor/rogue/dirt) && !istype(T, /turf/open/floor/rogue/grass))
			to_chat(user, span_warning("我需要把它们种在整好的地块里。"))
			return
		to_chat(user, span_notice("我开始为孢子松土……"))
		if(!do_after(user, 5 SECONDS, target = src))
			return
		soil = locate(/obj/structure/soil) in T
		if(!soil)
			soil = new /obj/structure/soil(T)
	if(soil.blessed_time <= 0)
		to_chat(user, span_warning("土壤必须受到祝福，这些孢子才能扎根。"))
		return
	if(locate(/obj/structure/mushroom_sprout) in T || locate(/obj/structure/mushroom_circle) in T)
		to_chat(user, span_warning("这里已经有东西在生长了。"))
		return
	to_chat(user, span_notice("我小心地将孢子按入受祝福的土壤中……"))
	if(!do_after(user, 5 SECONDS, target = src))
		return
	if(QDELETED(soil) || soil.blessed_time <= 0)
		to_chat(user, span_warning("我还没种完，土壤的祝福就消退了。"))
		return
	if(locate(/obj/structure/mushroom_sprout) in T || locate(/obj/structure/mushroom_circle) in T)
		return
	new /obj/structure/mushroom_sprout(T)
	to_chat(user, span_notice("我种下了妖精蘑菇孢子。"))
	qdel(src)

/obj/item/seeds/mushroom_fey/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(soil.blessed_time <= 0)
		to_chat(user, span_warning("土壤必须受到祝福，这些孢子才能扎根。"))
		return
	if(soil.plant || soil.has_custom_growth())
		to_chat(user, span_warning("\the [soil]里已经有东西在生长了！"))
		return
	var/turf/T = get_turf(soil)
	if(locate(/obj/structure/mushroom_sprout) in T || locate(/obj/structure/mushroom_circle) in T)
		to_chat(user, span_warning("这里已经有东西在生长了。"))
		return
	to_chat(user, span_notice("我小心地将孢子按入受祝福的土壤中……"))
	new /obj/structure/mushroom_sprout(T)
	qdel(src)
