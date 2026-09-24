/obj/item/reagent_containers/food/snacks/grown
	icon = 'icons/roguetown/items/produce.dmi'
	dried_type = null
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	var/list/pipe_reagents = list()
	var/seed
	var/bitesize_mod = 0
	experimental_inhand = TRUE
	/// Type of splat to use. If null - produce is unsquashable.
	var/splat_type = null
	/// Color of the splat, applied when splat_type is spawned (after squashing).
	var/splat_color = null

/obj/item/reagent_containers/food/snacks/grown/Initialize(mapload)
	. = ..()
	if(!tastes)
		tastes = list("[name]" = 1)
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

/obj/item/reagent_containers/food/snacks/grown/examine(mob/user)
	. = ..()
	. += span_smallnotice("Smash this with a blunt object to extract seeds from it.")

/obj/item/reagent_containers/food/snacks/grown/attackby(obj/item/weapon, mob/user, params)
	if(weapon && isturf(loc))
		var/turf/location = get_turf(src)
		if(seed && (user.used_intent.blade_class == BCLASS_BLUNT) && (!user.used_intent.noaa))
			playsound(src,'sound/items/seedextract.ogg', 100, FALSE)
			if(prob(5))
				user.visible_message(span_warning("[user] fails to extract the seeds."))
				qdel(src)
				return
			user.visible_message(span_info("[user] extracts the seeds."))
			new seed(location)
			if(prob(90))
				new seed(location)
			if(prob(23))
				new seed(location)
			if(prob(6))
				new seed(location)
			qdel(src)
			return
	return ..()

/obj/item/reagent_containers/food/snacks/grown/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!QDELETED(src) && !QDELETED(hit_atom) && !isnull(splat_type))
		return squash(hit_atom, throwingdatum)

/// Squashing logic. Returns TRUE if food is squashed and qdeleted, FALSE - otherwise.
/obj/item/reagent_containers/food/snacks/grown/proc/squash(atom/movable/hit_atom, datum/thrownthing/throwingdatum)
	var/mob/living/thrower = throwingdatum?.thrower
	if(istype(thrower) && (thrower.STASTR < 9 && prob(40 + (20 - thrower.STASTR))))
		visible_message(span_warning("[src] bounces off [hit_atom]!"))
		return FALSE // If thrower is weaker than average, it bounces off with no effect just for the pun of it.

	var/turf/T = get_turf(src)
	if(istransparentturf(T))
		T = GET_TURF_BELOW(src)
	if(istype(hit_atom) && !(hit_atom.density && !(hit_atom?.pass_flags & LETPASSTHROW) && !(hit_atom?.flags_1 & ON_BORDER_1)))
		T = get_turf(hit_atom) // No splats under walls and dense atoms

	forceMove(T)
	if(ispath(splat_type, /obj/effect/decal/cleanable/food/plant_smudge))
		if(filling_color)
			var/atom/movable/spawned_splat = new splat_type(T)
			spawned_splat.color = splat_color
			spawned_splat.name = "[name] smudge"
	else if(splat_type)
		new splat_type(T)

	if(trash)
		generate_trash(T)

	visible_message(span_warning("[src] has been squashed."), null, span_hear("I hear a smack."))

	qdel(src)
	return TRUE

/obj/item/reagent_containers/food/snacks/grown/wheat
	seed = /obj/item/seeds/wheat
	name = "小麦谷粒"
	desc = "小麦谷粒，准备好被磨成粉。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "wheat"
	gender = PLURAL
	filling_color = "#F0E68C"
	bitesize_mod = 2
	foodtype = GRAIN
	tastes = list("小麦味" = 1)
	grind_results = list(/datum/reagent/floure = 10)
	mill_result = /obj/item/reagent_containers/powder/flour
	dropshrink = 0.9

/obj/item/reagent_containers/food/snacks/grown/oat
	seed = /obj/item/seeds/wheat/oat
	name = "燕麦谷粒"
	desc = "燕麦谷粒，准备好被磨碎并煮沸。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "oat"
	gender = PLURAL
	filling_color = "#556B2F"
	bitesize_mod = 2
	foodtype = GRAIN
	tastes = list("燕麦味" = 1)
	grind_results = list(/datum/reagent/floure = 10)
	mill_result = /obj/item/reagent_containers/powder/flour
	dropshrink = 0.9

/obj/item/reagent_containers/food/snacks/grown/rice
	seed = /obj/item/seeds/rice
	name = "米粒"
	desc = "稻米颗粒，使用前需要用水清洗。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "rice"
	gender = PLURAL
	filling_color = "#f0f0f0"
	bitesize_mod = 2
	foodtype = GRAIN
	tastes = list("米味" = 1)
	grind_results = list(/datum/reagent/floure = 10)
	mill_result = /obj/item/reagent_containers/powder/flour
	dropshrink = 0.9

/obj/item/reagent_containers/food/snacks/grown/apple
	seed = /obj/item/seeds/apple
	name = "苹果"
	desc = "可口爽脆，香气扑鼻。据说弓箭手有时会将这种绯红色的果实放在他人头顶，\
	以炫耀自己长弓的准头。若一击命中，众人便鼓掌喝彩，无人受伤；但若偏差丝毫，\
	便有人要被拖进教堂了。"
	icon_state = "apple"
	filling_color = "#FF4500"
	bitesize = 3
	foodtype = FRUIT
	tastes = list("苹果味" = 1)
	trash = /obj/item/trash/applecore
	faretype = FARE_POOR
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	slot_flags = ITEM_SLOT_HEAD
	worn_x_dimension = 64
	list_reagents = list(/datum/reagent/consumable/nutriment = 3)
	worn_y_dimension = 64
	rotprocess = SHELFLIFE_SHORT
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced
	slices_num = 3
	chopping_sound = TRUE
	var/equippedloc = null
	var/list/bitten_names = list()

/obj/item/reagent_containers/food/snacks/grown/apple/On_Consume(mob/living/eater)
	..()
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(!(H.real_name in bitten_names))
			bitten_names += H.real_name

/obj/item/reagent_containers/food/snacks/grown/apple/blockproj(mob/living/carbon/human/H)

	if(prob(98))
		H.visible_message(span_notice("[H]被苹果拯救了！"))
		H.dropItemToGround(H.head)
		return 1
	else
		H.dropItemToGround(H.head)
		return 0

/obj/item/reagent_containers/food/snacks/grown/apple/equipped(mob/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head == src)

			equippedloc = H.loc
			START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/food/snacks/grown/apple/process()
	. = ..()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.head == src)
			if(equippedloc != H.loc)
				H.dropItemToGround(H.head)

/obj/item/reagent_containers/food/snacks/grown/apple/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/appledry,
		/datum/crafting_recipe/roguetown/cooking/menthaappledry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/reagent_containers/food/snacks/grown/fruit
	name = "普通水果"
	desc = "呃哦，这东西不该出现在这里。"
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = 3)
	foodtype = FRUIT
	faretype = FARE_POOR
	rotprocess = SHELFLIFE_DECENT
	splat_type = /obj/effect/decal/cleanable/food/plant_smudge

/obj/item/reagent_containers/food/snacks/grown/fruit/pear
	name = "梨"
	seed = /obj/item/seeds/pear
	desc = "多汁、钟形水果，带有细腻甜味和柔软略带颗粒感的果肉。"
	icon_state = "pear"
	tastes = list("梨味" = 1)
	splat_color = "#D2B48C"

/obj/item/reagent_containers/food/snacks/grown/fruit/lemon
	name = "柠檬"
	seed = /obj/item/seeds/lemon
	desc = "一种明亮黄色的柑橘类水果，以其酸爽清新的果汁和芳香的果皮而备受青睐。"
	icon_state = "lemon"
	tastes = list("柠檬味" = 1)
	splat_color = "#FFFF00"

/obj/item/reagent_containers/food/snacks/grown/fruit/lime
	name = "酸橙"
	seed = /obj/item/seeds/lime
	desc = "一颗小个子的绿色柑橘类水果，味道尖锐辛辣，常用于烹饪和调制饮品。"
	icon_state = "lime"
	tastes = list("青柠味" = 1)
	splat_color = "#00FF00"

/obj/item/reagent_containers/food/snacks/grown/fruit/lime/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/limedry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine
	name = "柑橘"
	seed = /obj/item/seeds/tangerine
	desc = "一种小型易剥的柑橘类水果，色泽鲜亮橙黄，果肉分瓣，甜美多汁。\
	它最广为人知的是作为‘橘子酱’的前身；一种美味的可涂抹果酱，通过将橘子浸入糖中并用沸腾的油脂浇淋而成。"
	icon_state = "tangerine"
	tastes = list("柑橘味" = 1)
	splat_color = "#FFA500"

/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine_sugared
	name = "糖渍柑橘"
	desc = "裹满糖的柑橘，甜得发腻，正等着在一锅滚烫的油脂中接受洗礼。"
	icon_state = "tangerinesugar"
	faretype = FARE_FINE
	splat_color = "#FFA500"
	tastes = list("甜得发腻" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	deep_fried_type = /obj/item/reagent_containers/food/snacks/marmalade
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/grown/fruit/plum
	name = "梅子"
	seed = /obj/item/seeds/plum
	desc = "一种表皮光滑的水果，果肉多汁，酸甜适中，呈深紫或红色。"
	icon_state = "plum"
	tastes = list("李子味" = 1)
	splat_color = "#8B008B"

/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry
	name = "草莓"
	seed = /obj/item/seeds/strawberry
	desc = "小型红色水果，味道甜，常用于甜点。"
	icon_state = "strawberry"
	tastes = list("草莓味" = 1)
	splat_color = "#9A1B00"

/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/strawberrydry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry
	name = "黑莓"
	seed = /obj/item/seeds/blackberry
	desc = "一种小型深色水果，味道甜中带微酸，常用于甜点制作。或——当裹上糖并用沸腾的油脂浇淋后——制成美味的果酱。"
	icon_state = "blackberry"
	tastes = list("黑莓味" = 1)
	splat_color = "#272C3F"

/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/blackberrydry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry_sugared
	name = "糖渍黑莓"
	desc = "裹满糖的黑莓，甜得发腻，正等着在一锅滚烫的油脂中接受洗礼。"
	icon_state = "blackberrysugar"
	faretype = FARE_FINE
	splat_color = "#272C3F"
	tastes = list("甜得发腻" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	deep_fried_type = /obj/item/reagent_containers/food/snacks/jamtallow
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry
	name = "树莓"
	seed = /obj/item/seeds/raspberry
	desc = "一种小型红色水果，味道甜中带微酸，常用于甜点制作。"
	icon_state = "raspberry"
	tastes = list("覆盆子味" = 1)
	splat_color = "#A01600"

/obj/item/reagent_containers/food/snacks/grown/fruit/tomato
	name = "番茄"
	seed = /obj/item/seeds/tomato
	desc = "一颗饱满的红色果实，果肉多汁，酸甜适中。可生食，也可烹饪使用。经验丰富的厨师知道总要把番茄切开，以制作出最顺滑的酱汁。"
	icon_state = "tomato"
	tastes = list("番茄味" = 1)
	splat_color = "#CD5320"
	slice_path = /obj/item/reagent_containers/food/snacks/grown/fruit/tomato_sliced
	slices_num = 1

/obj/item/reagent_containers/food/snacks/grown/fruit/tomato_sliced
	name = "切开的番茄"
	seed = /obj/item/seeds/tomato
	desc = "切成两半的饱满红果，果肉多汁，酸甜适中。裂开的果皮兜着丝滑美味的果肉，只需用手一抹，就能化作擀平面团上的酱汁。"
	icon_state = "tomato_split"
	tastes = list("番" = 1, "茄" = 1)
	splat_color = "#CD5320"

/obj/item/reagent_containers/food/snacks/grown/berries/rogue
	seed = /obj/item/seeds/berryrogue
	name = "杰克莓"
	desc = "一小簇深色的杰克莓，汁液浓郁。"
	icon_state = "berries"
	tastes = list("浆果味" = 1)
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/water = 5)
	faretype = FARE_NEUTRAL
	dropshrink = 0.75
	var/color_index = "good"
	rotprocess = SHELFLIFE_SHORT

/obj/item/reagent_containers/food/snacks/grown/berries/rogue/examine(mob/user)
	. = ..()
	if(!user.get_client_color(/datum/client_colour/monochrome))
		. += span_notice("These berries have a <b>[BERRYCOLORS[filling_color]]</b> hue.")

/obj/item/reagent_containers/food/snacks/grown/berries/rogue/Initialize(mapload)
	if(GLOB.berrycolors[color_index])
		filling_color = GLOB.berrycolors[color_index]
	else
		var/newcolor = pick(BERRYCOLORS)
		if(newcolor in GLOB.berrycolors)
			GLOB.berrycolors[color_index] = pick(BERRYCOLORS)
		else
			GLOB.berrycolors[color_index] = newcolor
		filling_color = GLOB.berrycolors[color_index]
	update_icon()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/jacksberriesdry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/reagent_containers/food/snacks/grown/berries/rogue/On_Consume(mob/living/eater)
	..()
	update_icon()

/obj/item/reagent_containers/food/snacks/grown/berries/rogue/update_icon()
	cut_overlays()
	var/used_state = "berriesc5"
	if(bitecount == 1)
		used_state = "berriesc4"
	if(bitecount == 2)
		used_state = "berriesc3"
	if(bitecount == 3)
		used_state = "berriesc2"
	if(bitecount == 4)
		used_state = "berriesc1"
	var/image/item_overlay = image(used_state)
	item_overlay.color = filling_color
	add_overlay(item_overlay)

/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison
	seed = /obj/item/seeds/berryrogue/poison
	icon_state = "berries"
	tastes = list("浆果味" = 1)
	list_reagents = list(/datum/reagent/berrypoison = 5, /datum/reagent/consumable/nutriment = 3, /datum/reagent/water = 5)
	grind_results = list(/datum/reagent/berrypoison = 5)
	color_index = "bad"

/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/jacksberriespoisondry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/reagent_containers/food/snacks/grown/nut
	name = "石果"
	desc = "一种带有刺激特性的芳香坚果，常与药草糖搭配享用。其粉末可用于制作手卷烟和混合香料。"
	seed = /obj/item/seeds/nut
	icon_state = "rocknut"
	tastes = list("坚果香" = 1)
	filling_color = "#6b4d18"
	bitesize = 1
	foodtype = FRUIT
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/nicotine = 1)
	grind_results = list(/datum/reagent/consumable/acorn_powder = 4)
	mill_result = /obj/item/reagent_containers/powder/rocknut

/obj/item/reagent_containers/food/snacks/grown/nut_sugared
	name = "糖渍石果"
	desc = "裹满糖的石果，浸润着草药的甜香，正等待滚烫油脂的洗礼。"
	icon_state = "rocknutssugar"
	faretype = FARE_FINE
	tastes = list("浓得发腻的甜味与坚果香" = 1)
	filling_color = "#6b4d18"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	grind_results = list(/datum/reagent/consumable/acorn_powder = 4)
	deep_fried_type = /obj/item/reagent_containers/food/snacks/dragee
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/grown/sugarcane
	seed = /obj/item/seeds/sugarcane
	name = "甘蔗"
	desc = "一种高大的叶状植物，有着粗壮纤维质的茎秆。可磨制成糖。在风郡部分地区常作为零食食用。"
	icon_state = "sugarcane"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/sugar = 5)
	dropshrink = 0.8
	rotprocess = null
	mill_result = /obj/item/reagent_containers/food/snacks/sugar

/obj/item/reagent_containers/food/snacks/sugar
	name = "糖"
	desc = "由甘蔗精制而成的糖粉，甜味纯粹而浓郁。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "sugar"
	tastes = list("甜味" = 1)
	list_reagents = list(/datum/reagent/consumable/sugar = 15)
	deep_fried_type = /obj/item/reagent_containers/food/snacks/caramel

/obj/item/reagent_containers/food/snacks/pepper
	name = "胡椒粉"
	desc = "磨碎的胡椒粒，辛辣十足。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "pepper"
	tastes = list("麻舌的辛辣" = 1, "淡淡的苦味" = 1)
	list_reagents = list(/datum/reagent/consumable/blackpepper = 1)

/obj/item/reagent_containers/food/snacks/grown/pepperseed
	name = "胡椒粒"
	desc = "费伦提亚杰克莓的近亲，已剥去果皮。烘烤似乎削弱了它扰乱体液平衡的\
	特性，不过仍需磨碎后才能用于烹饪。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "pepperseed"
	foodtype = GRAIN
	tastes = list("辛辣" = 1, "稍淡的苦味" = 1)
	grind_results = list(/datum/reagent/consumable/blackpepper = 1)
	mill_result = /obj/item/reagent_containers/food/snacks/pepper

/obj/item/reagent_containers/food/snacks/allspice
	name = "什香粉"
	desc = "混合香料，能让最寡淡的肉汤也变得有滋有味。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "spice_good"
	tastes = list("芳香的香料" = 1, "层次丰富的怡人香气" = 1) //Very low nutritional content, but can be applied to add a very solid moodboost to broths. Futurecoders could add it to meals, later, too.
	list_reagents = list(/datum/reagent/consumable/allspice = 1)
	sellprice = 30

/obj/item/reagent_containers/food/snacks/grown/vegetable/turnip
	name = "芜菁"
	desc = "抵御饥饿的盾牌，仅此而已。"
	seed = /obj/item/seeds/turnip
	icon_state = "turnip"
	tastes = list("泥土味" = 1)
	bitesize = 1
	slices_num = 1
	slice_path = /obj/item/reagent_containers/food/snacks/veg/turnip_sliced
	foodtype = VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	chopping_sound = TRUE
	dropshrink = 0.9
	rotprocess = SHELFLIFE_EXTREME

/*	..................   Sunflower   ................... */
/obj/item/reagent_containers/food/snacks/grown/sunflower
	name = "向日葵"
	desc = "一朵大大的、亮黄色的花。可以戴在头上。"
	icon_state = "sunflower"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	seed = /obj/item/seeds/sunflower
	slot_flags = ITEM_SLOT_HEAD
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 0)
	dropshrink = 0.8
	rotprocess = null

//pyroclastic flowers - stonekeep port
/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius
	name = "焰蕊花"
	seed = /obj/item/seeds/fyritius
	desc = "一朵精致的橙色花朵，散发着暖意。"
	icon_state = "fyritius"
	filling_color = "#ff5e00"
	tastes = list("tastes like a burning coal and fire" = 1)
	obj_flags = CAN_BE_HIT
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin/fyritiusnectar = 5)
	grind_results = list(/datum/reagent/toxin/fyritiusnectar = 10)
	dropshrink = 0.8
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3

/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/attack(mob/living/carbon/human/M, mob/user)
	if(M == user)
		return ..() //Eat it
	if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		return ..() //Make THEM eat it.
	if(!M.get_bleed_rate())
		to_chat(user, span_warning("There is no blood to wick into the flower bud."))
		return
	var/success = FALSE
	//Logic from funny_attack_effects
	var/datum/antagonist/werewolf/Were = M.mind.has_antag_datum(/datum/antagonist/werewolf/)
	var/datum/antagonist/vampire/Vamp = M.mind.has_antag_datum(/datum/antagonist/vampire/)
	if(Were && Were.transformed == TRUE)
		user.visible_message(span_notice("[user] brings [src] to soak up the ichor of [M]'s wounds."))
		if(do_after(user, 5 SECONDS, target = M))
			user.visible_message(span_notice("[user] draws the ichor of Dendor's Curse from [M]'s open wounds into [src]."), \
								span_notice("I have captured the ferocity of Dendor's Curse inside [src]."))
			success = TRUE
	else if(Vamp)
		user.visible_message(span_notice("[user] brings [src] to soak up the petrified blood of [M]'s wounds."))
		if(do_after(user, 5 SECONDS, target = M))
			user.visible_message(span_notice("[user] captures the petrified blood from [M]'s open wounds into [src]."), \
								span_notice("I have captured the quizzical properties of the petrified blood inside [src]."))
			success = TRUE
	else
		to_chat(user, span_warning("Their blood is not robust enough to hold to the warmth of [src]."))
	if(success)
		changefood(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied, user)

/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/inqarticles/indexer))
		var/obj/item/inqarticles/indexer/IND = I
		var/success
		if(HAS_TRAIT(user, TRAIT_INQUISITION))
			if(IND.cursedblood)
				if(alert(user, "DRENCH THE FYRITIUS?", "CURSED BLOOD", "YES", "NO") != "NO")
					success = TRUE
					IND.fullreset(user)
				else
					return
				if(success)
					changefood(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied, user)


/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied
	name = "染血的焰蕊花"
	desc = "一朵曾经精致的橙色花朵，如今被可怖的诅咒之血浸透。它在其间沸腾翻涌。"
	icon_state = "fyritius_blood"
	filling_color = "#ff3300"
	tastes = list("tastes like a burning coal and fire and blood" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin/fyritiusnectar = 5)
	rotprocess = SHELFLIFE_SHORT

/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied/become_rotten()
	visible_message(span_danger("[src] burns into ash!"))
	new /obj/item/ash(get_turf(src))
	qdel(src)
	return TRUE

/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed
	seed = /obj/item/seeds/swampweed
	name = "沼泽烟叶"
	desc = "一种气味刺鼻、表面闪亮的烟斗叶。"
	icon_state = "swampweed"
	filling_color = "#008000"
	bitesize_mod = 1
	foodtype = VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/berrypoison = 5)
	tastes = list("甜味" = 1,"苦味" = 1)
	eat_effect = /datum/status_effect/debuff/badmeal
	rotprocess = SHELFLIFE_SHORT

/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed
	seed = /obj/item/seeds/pipeweed
	name = "西池烟叶"
	desc = "一种以其浓郁风味著称的烟斗叶。"
	icon_state = "westleach"
	filling_color = "#008000"
	bitesize_mod = 1
	foodtype = VEGETABLES
	tastes = list("甜味" = 1,"苦味" = 1)
	list_reagents = list(/datum/reagent/drug/nicotine = 2, /datum/reagent/consumable/nutriment = 1, /datum/reagent/berrypoison = 5)
	grind_results = list(/datum/reagent/drug/nicotine = 5)
	eat_effect = /datum/status_effect/debuff/badmeal
	rotprocess = SHELFLIFE_SHORT

/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry
	seed = null
	name = "西池干烟叶"
	desc = "一片干燥处理好的烟斗叶，随时可以抽。"
	icon_state = "westleachd"
	dry = TRUE
	pipe_reagents = list(/datum/reagent/drug/nicotine = 30)
	eat_effect = /datum/status_effect/debuff/badmeal
	list_reagents = list(/datum/reagent/drug/nicotine = 5, /datum/reagent/consumable/nutriment = 1)
	grind_results = list(/datum/reagent/drug/nicotine = 10)

/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/sigdry,
		/datum/crafting_recipe/roguetown/cooking/sigdry/cheroot,
		/datum/crafting_recipe/roguetown/cooking/sigsweet/cheroot,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry
	seed = null
	name = "沼泽干烟叶"
	desc = "一片制备好的烟斗叶，以其迷幻效果闻名。"
	icon_state = "swampweedd"
	dry = TRUE
	pipe_reagents = list(/datum/reagent/drug/space_drugs = 30)
	list_reagents = list(/datum/reagent/drug/space_drugs = 2,/datum/reagent/consumable/nutriment = 1)
	grind_results = list(/datum/reagent/drug/space_drugs = 5)
	eat_effect = /datum/status_effect/debuff/badmeal

/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/sigsweet,
		/datum/crafting_recipe/roguetown/cooking/sigsweet/cheroot,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/reagent_containers/food/snacks/grown/onion/rogue
	name = "洋葱"
	desc = "一种层次丰富、风味多样的奇妙蔬菜。"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced
	chopping_sound = TRUE
	dropshrink = 0.6
	icon_state = "onion"
	slices_num = 2
	tastes = list("辛辣的甜味" = 1)
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	seed = /obj/item/seeds/onion

/obj/item/reagent_containers/food/snacks/grown/cabbage/rogue
	name = "卷心菜"
	desc = "一种叶片紧实的蔬菜，清脆而成熟。是精灵族象征繁荣的作物。"
	icon_state = "cabbage"
	tastes = list("寡淡的味道" = 1)
	bitesize = 10
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	slices_num = 3
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced
	chopping_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	seed = /obj/item/seeds/cabbage

/obj/item/reagent_containers/food/snacks/grown/potato/rogue
	name = "土豆"
	desc = "一颗块茎，矮人眼中的丰收之象。可以生吃。"
	icon_state = "potato"
	eat_effect = null
	tastes = list("土豆味" = 1)
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked
	chopping_sound = TRUE
	rotprocess = null
	seed = /obj/item/seeds/potato
	dropshrink = 0.7

/obj/item/reagent_containers/food/snacks/grown/garlick/rogue
	name = "大蒜瓣"
	desc = "潜藏于黑暗中的邪恶吸血鬼所憎恶之物。大蒜。"
	icon_state = "garlick"
	slices_num = 5
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	eat_effect = null
	tastes = list("浓烈的辛香" = 1)
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/water/blessed = 2)
	rotprocess = null
	chopping_sound = TRUE
	seed = /obj/item/seeds/garlick

// poppies, from vanderlin
/obj/item/reagent_containers/food/snacks/grown/rogue/poppy
	name = "罂粟"
	desc = "因其绯红之美与种子碾碎后的镇静效果而被珍视。一种受人喜爱的花卉。"
	icon_state = "poppy"
	seed = /obj/item/seeds/poppy
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 0)
	dropshrink = 0.5
	rotprocess = null

/obj/item/reagent_containers/food/snacks/grown/coffee
	name = "咖啡樱桃"
	desc = "一颗小小的甜美红色果实，内含一粒（有时是两粒）咖啡豆。干燥后可作为提神饮品冲泡。"
	icon_state = "coffee"
	seed = /obj/item/seeds/coffee
	tastes = list("木槿般的甜香" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	mill_result = /obj/item/reagent_containers/food/snacks/grown/coffeebeans
	rotprocess = null

/obj/item/reagent_containers/food/snacks/grown/tea
	name = "茶叶"
	desc = "从茶树上采摘的茶叶。仍然新鲜，使用前需干燥处理。"
	icon_state = "tea"
	seed = /obj/item/seeds/tea
	tastes = list("青草味" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	rotprocess = null

/obj/item/reagent_containers/food/snacks/grown/carrot
	name = "胡萝卜"
	desc = "一种据说有助于视力的大长蔬菜。常用于烘焙。"
	icon_state = "carrot"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	tastes = list("胡萝卜味" = 1)
	dropshrink = 0.75
	seed = /obj/item/seeds/carrot

/obj/item/reagent_containers/food/snacks/grown/carrot/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/carrotdry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

///////////  Skysugar   //////////////
// Stored here, as it uses deepfrying to make. Let's cook, yo!

/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry/skysugarbase
	name = "天糖灵药原液"
	desc = "由种类繁杂得令人费解的材料混合而成，只有放入油脂中煮炼，才会融合成一种 \
	经炼金术提纯的物质。在费伦提亚边境以南，它被称为“天糖”，是一种佩斯特拉异端造物；据说最初 \
	是为了医治连水银药膏也无能为力的病症而调制的。尽管散发着果香，最好还是别尝它。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "lux_impure_combo"
	faretype = FARE_IMPOVERISHED
	eat_effect = /datum/status_effect/debuff/uncookedfood
	tastes = list("糟糕透顶的主意" = 1, "淡淡的果味余韵" = 1)
	bitesize = 2
	list_reagents = list(/datum/reagent/toxin/killersice = 1, /datum/reagent/starsugar = 8, /datum/reagent/water = 7, /datum/reagent/consumable/nutriment = 3) //Feeling a little.. under the weather?
	deep_fried_type = /obj/item/reagent_containers/food/snacks/grown/skysugarslab
	sellprice = 23

/obj/item/reagent_containers/food/snacks/grown/skysugarslab
	name = "天糖晶砖"
	desc = "一块泛着近乎空灵光泽的结晶砖，尚待在炼金实验室中敲碎。古帝国语称它为 \
	“luchtblauw”；这是经炼金术提纯的星糖，精细到九百分之一打兰。作为佩斯特拉异端的产物，这种 \
	神秘物质效力强得荒唐，也遭到教会谴责。即便如此，它仍价值如金；若落到一个甘愿堕落的 \
	自耕农手中，便能卖给毫无道德的商人或浴场主，换来一大笔钱。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "lux_slab"
	gender = PLURAL
	bitesize = 7
	faretype = FARE_IMPOVERISHED //Have you ever tried eating a solid chunk of soul-meth, before?
	tastes = list("稍微没那么糟的主意" = 1, "带果味的玻璃碎片" = 1)
	list_reagents = list(/datum/reagent/starsugar = 16, /datum/reagent/water = 6, /datum/reagent/consumable/nutriment = 6)
	grind_results = list(/datum/reagent/starsugar = 98) //Add a custom reagent if you wish. I think that'd be pretty cool.
	sellprice = 137
	drop_sound = 'sound/foley/dropsound/glass_drop.ogg'

/obj/item/reagent_containers/powder/starsugar/skysugar
	name = "天糖"
	desc = "一种泛着近乎空灵光泽的结晶粉末，摸上去冰冷刺骨。古帝国语称它为 \
	“luchtblauw”；这是经炼金术提纯的星糖，精细到九百分之一打兰。作为佩斯特拉异端的产物，这种 \
	神秘物质效力强得荒唐，也遭到教会谴责。即便如此，它仍价值如金；若落到一个甘愿堕落的 \
	自耕农手中，便能卖给毫无道德的商人或浴场主，换来一大笔钱。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "lux_powder"
	item_state = "lux_powder"
	possible_transfer_amounts = list()
	volume = 38
	list_reagents = list(/datum/reagent/starsugar = 38, /datum/reagent/consumable/nutriment = 38) //Yeah, psyence!
	grind_results = list(/datum/reagent/starsugar = 38)
	sellprice = 123 //Tight, tight, tight! Blue, red, green; whatever, man, just bring me more!
	drop_sound = 'sound/foley/dropsound/glass_drop.ogg'

/*	..................   Cucumber   ................... */
/obj/item/reagent_containers/food/snacks/grown/cucumber
	name = "黄瓜"
	desc = "一种长条形的绿色蔬菜，口感爽脆，常用沙拉。"
	icon_state = "cucumber"
	dropshrink = 0.75
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced
	tastes = list("黄瓜味" = 1)
	chopping_sound = TRUE

/obj/item/reagent_containers/food/snacks/grown/eggplant
	name = "茄子"
	desc = "一个大大的紫色蔬菜，味道温和。常用于烹饪。"
	icon_state = "eggplant"
	slices_num = 1
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/eggplantcarved
	slice_sound = TRUE
	seed = /obj/item/seeds/eggplant
