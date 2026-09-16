/*	........   Drying Rack recipes   ................ */
/datum/crafting_recipe/roguetown/cooking/salami
	name = "烟熏香肠"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/salami
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 2

/datum/crafting_recipe/roguetown/cooking/coppiette
	name = "风干肉条"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/coppiette
	craftdiff = 1
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/salo
	name = "盐腌肥膘"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/fat = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/fat/salo
	craftdiff = 1
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/brothbrique
	name = "汤砖"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/reagent_containers/food/snacks/rogue/raisins = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique
	craftdiff = 2
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/brothbriquealt
	name = "汤砖（备选）"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/reagent_containers/food/snacks/rogue/raisins = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique
	craftdiff = 2
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/salotack
	name = "肥膘硬饼"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/fat/salo = 1,
		/obj/item/reagent_containers/food/snacks/pepper = 1,
		/obj/item/reagent_containers/food/snacks/rogue/crackerscooked = 1)
	result = /obj/item/reagent_containers/food/snacks/balefire
	craftdiff = 2
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/raisins
	name = "葡萄干"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	parts = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/cooking/raisinsraspberry
	name = "覆盆子干块"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinsblackberry
	name = "黑莓干块"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinsstrawberry
	name = "草莓干块"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinsplum
	name = "李子干块"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/plum = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/plum
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinspear
	name = "梨干块"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/pear = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/pear
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinstangerine
	name = "柑橘干块"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinslemon
	name = "柠檬干块"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/lemon
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/raisinslime
	name = "青柠干块"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lime = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins/lime
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/trailmix
	name = "什锦干粮"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisins = 1,
		/obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced = 1,
		/obj/item/reagent_containers/food/snacks/roastseeds = 1,
		/obj/item/ration = 1
		)
	result = /obj/item/reagent_containers/food/snacks/rogue/trailmix
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 2

/datum/crafting_recipe/roguetown/cooking/fish
	name = "风干鱼片"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/driedfishfilet
	craftdiff = 2
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/frybirdbucket
	name = "炸鸟桶"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried = 3,
		/obj/item/reagent_containers/glass/bucket = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/frybirdbucket
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/dryleaf
	name = "沼泽干烟叶"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "风干"
	verbage = "风干"
	craftsound = null

/datum/crafting_recipe/roguetown/cooking/drytea
	name = "干茶叶"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/tea = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "风干"
	verbage = "风干"
	craftsound = null

/datum/crafting_recipe/roguetown/cooking/dryweed
	name = "西池干烟叶"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "风干"
	verbage = "风干"
	craftsound = null

/datum/crafting_recipe/roguetown/cooking/dryrosa
	name = "干玫瑰花瓣"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "风干"
	verbage = "风干"
	craftsound = null

/datum/crafting_recipe/roguetown/cooking/sigsweet/cheroot
	name = "沼叶雪茄"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/clothing/mask/cigarette/rollie/cannabis/cheroot
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1,
		)
	time = 10 SECONDS
	verbage_simple = "卷制"
	verbage = "卷制"

/datum/crafting_recipe/roguetown/cooking/sigdry/cheroot
	name = "西池雪茄"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine/cheroot
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1,
		)
	time = 10 SECONDS
	verbage_simple = "卷制"
	verbage = "卷制"

/datum/crafting_recipe/roguetown/cooking/sigsweet
	name = "沼叶卷烟"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/clothing/mask/cigarette/rollie/cannabis
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1,
		/obj/item/paper = 1,
		)
	time = 10 SECONDS
	verbage_simple = "卷制"
	verbage = "卷制"

/datum/crafting_recipe/roguetown/cooking/sigdry
	name = "西池卷烟"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
		/obj/item/paper = 1,
		)
	time = 10 SECONDS
	verbage_simple = "卷制"
	verbage = "卷制"

/datum/crafting_recipe/roguetown/cooking/rocknutdry
	name = "石果卷烟"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	result = /obj/item/clothing/mask/cigarette/rollie/nicotine
	reqs = list(
		/obj/item/reagent_containers/powder/rocknut = 1,
		/obj/item/paper = 1,
		)
	time = 10 SECONDS
	verbage_simple = "卷制"
	verbage = "卷制"

/datum/crafting_recipe/roguetown/cooking/menthadry
	name = "薄荷雪茄"
	result = /obj/item/clothing/mask/cigarette/rollie/mentha/cheroot
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
		/obj/item/alch/mentha = 1,
	)
	time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/blackberrydry
	name = "黑莓雪茄"
	result = /obj/item/clothing/mask/cigarette/rollie/blackberry/cheroot
	reqs = list(
	/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
		/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 1,
	)
	time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/appledry
	name = "苹果雪茄"
	result = /obj/item/clothing/mask/cigarette/rollie/apple/cheroot
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/grown/apple = 1,
	)
	time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/menthaappledry
    name = "薄荷苹果雪茄"
    result = /obj/item/clothing/mask/cigarette/rollie/menthaapple/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/alch/mentha = 1,
        /obj/item/reagent_containers/food/snacks/grown/apple = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/chocolatedry
    name = "巧克力雪茄"
    result = /obj/item/clothing/mask/cigarette/rollie/chocolate/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/chocolate = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/strawberrydry
    name = "草莓雪茄"
    result = /obj/item/clothing/mask/cigarette/rollie/strawberry/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/grown/fruit/strawberry = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/carrotdry
    name = "胡萝卜雪茄"
    result = /obj/item/clothing/mask/cigarette/rollie/carrot/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/grown/carrot = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/limedry
    name = "青柠雪茄"
    result = /obj/item/clothing/mask/cigarette/rollie/lime/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/grown/fruit/lime = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/salviadry
    name = "鼠尾草雪茄"
    result = /obj/item/clothing/mask/cigarette/rollie/salvia/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/alch/salvia = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/salviavalerianadry
    name = "鼠尾草-缬草雪茄"
    result = /obj/item/clothing/mask/cigarette/rollie/salviavaleriana/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/alch/salvia = 1,
        /obj/item/alch/valeriana = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/calenduladry
    name = "金盏花雪茄"
    result = /obj/item/clothing/mask/cigarette/rollie/calendula/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/alch/calendula = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/jacksberriesdry
    name = "杰克莓雪茄"
    result = /obj/item/clothing/mask/cigarette/rollie/jacksberries/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/jacksberriespoisondry
    name = "杰克莓雪茄（有毒）"
    result = /obj/item/clothing/mask/cigarette/rollie/jacksberriespoison/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/abyssdry
    name = "深渊雪茄"
    result = /obj/item/clothing/mask/cigarette/rollie/abyss/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1,
        /obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1,
        /datum/reagent/water/salty = 25,
        /obj/item/reagent_containers/food/snacks/fish = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/zigardry
    name = "齐加雪茄"
    result = /obj/item/clothing/mask/cigarette/rollie/zigar/cheroot
    reqs = list(
        /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 2,
        /obj/item/alch/hypericum  = 1,
    )
    time = 10 SECONDS

/datum/crafting_recipe/roguetown/cooking/lemonystickets
	name = "柠檬风味肉条"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/lemon = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1,
		/obj/item/ash = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/lemoncoppiette
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/cooking/allspice
	name = "调配什香粉"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/pepper = 1,
		/obj/item/reagent_containers/powder/salt = 1,
		/obj/item/reagent_containers/food/snacks/pumpkinspice = 1,
		/obj/item/reagent_containers/powder/rocknut = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/allspice
	verbage_simple = "调配"
	verbage = "调配"
	req_table = TRUE
	structurecraft = /obj/structure/table
	craftdiff = 4 //A true chef never reveals his secrets!

/datum/crafting_recipe/roguetown/cooking/sugartangerine
	name = "糖渍柑橘"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine_sugared
	structurecraft = /obj/structure/table
	req_table = TRUE
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/sugarblackberry
	name = "糖渍黑莓"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry_sugared
	craftdiff = 3
	structurecraft = /obj/structure/table
	req_table = TRUE

/datum/crafting_recipe/roguetown/cooking/sugarrocknut
	name = "糖渍石果"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/nut = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1,
		/obj/item/alch/calendula = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/nut_sugared
	craftdiff = 4 //A treat!
	structurecraft = /obj/structure/table
	req_table = TRUE

/datum/crafting_recipe/roguetown/cooking/sugarrocknutalt
	name = "糖渍石果（备选）"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/nut = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1,
		/obj/item/alch/calendula = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/nut_sugared
	craftdiff = 5 //Slightly harder to make than a regular Cook, but allows well-trained physicians to give out the medieval equivalent of lollipops to well-behaved patients.
	skillcraft = /datum/skill/misc/medicine
	structurecraft = /obj/structure/table
	req_table = TRUE

/datum/crafting_recipe/roguetown/cooking/spicechocolate
	name = "五香巧克力"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/chocolate/slice = 1,
		/obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/chocolate_spiced
	structurecraft = /obj/structure/table
	req_table = TRUE
	craftdiff = 3

/datum/crafting_recipe/roguetown/cooking/spicecoffee
	name = "五香咖啡豆"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted = 1,
		/obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/coffeebeans_spiced
	craftdiff = 3
	structurecraft = /obj/structure/table
	req_table = TRUE

/datum/crafting_recipe/roguetown/cooking/spicetea
	name = "五香茶叶"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground = 1,
		/obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_spiced
	craftdiff = 2
	structurecraft = /obj/structure/table
	req_table = TRUE

/datum/crafting_recipe/roguetown/cooking/spicerosa
	name = "五香玫瑰花瓣"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried = 1,
		/obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_spiced
	craftdiff = 2
	structurecraft = /obj/structure/table
	req_table = TRUE

//SUGARCRAFTING!!!
/datum/crafting_recipe/roguetown/cooking/sugarshapedmarkd
	name = "公爵印记糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/dmark
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarkp
	name = "普赛顿印记糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/pmark
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarkz
	name = "齐佐印记糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/zmark
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarka
	name = "圣堂印记糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/amark
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarks
	name = "骷髅印记糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/smark
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedmarkh
	name = "爱心印记糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/hmark
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedstatuek
	name = "骑士雕像糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/statuek
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedstatuer
	name = "王室雕像糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/statuer
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedstatuey
	name = "自耕农雕像糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/statuey
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedstatuel
	name = "领主雕像糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/statuel
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedarch
	name = "拱门糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/arch
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedarchway
	name = "拱道糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/archway
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedtower
	name = "塔楼糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/tower
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedtowers
	name = "小塔糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/towers
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedcastle
	name = "城堡糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/castle
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedflag
	name = "旗帜糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/flag
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedhouse
	name = "房屋糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/house
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table

/datum/crafting_recipe/roguetown/cooking/sugarshapedtree
	name = "树木糖塑"
	display_category = ITEM_CAT_FOODSTUFF_PRESERVED
	reqs = list(
		/obj/item/reagent_containers/food/snacks/sugar = 1)
	result = /obj/item/reagent_containers/food/snacks/grown/sugarshape/tree
	craftdiff = 4
	verbage_simple = "雕刻"
	verbage = "雕刻"
	req_table = TRUE
	structurecraft = /obj/structure/table
