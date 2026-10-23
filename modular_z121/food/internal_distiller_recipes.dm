// 原料按具体类型匹配，避免毒浆果、馅面团或其他派生食物冒充基础材料。
/datum/z121_distiller_recipe
	var/name
	var/category = "基础茶饮"
	var/output_reagent
	var/output_amount = 30
	var/list/input_items = list()
	var/list/input_reagents = list()
	var/input_amount = 0

/datum/z121_distiller_recipe/proc/material_description()
	var/list/material_names = list()
	for(var/obj/item/item_path as anything in input_items)
		material_names += initial(item_path.name)
	for(var/datum/reagent/reagent_path as anything in input_reagents)
		material_names += "[initial(reagent_path.name)]（[input_amount]单位）"
	return jointext(material_names, "／")

/proc/z121_distiller_recipes()
	var/static/list/recipes
	if(!recipes)
		recipes = list()
		for(var/datum/z121_distiller_recipe/recipe_path as anything in subtypesof(/datum/z121_distiller_recipe))
			if(!initial(recipe_path.name) || !initial(recipe_path.output_reagent))
				continue
			var/datum/z121_distiller_recipe/recipe = new recipe_path
			recipes[recipe.name] = recipe
	return recipes

/datum/z121_distiller_recipe/tea
	name = "茶"
	output_reagent = /datum/reagent/consumable/caffeine/tea
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/tea, /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry, /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground)

/datum/z121_distiller_recipe/spiced_tea
	name = "五香茶"
	output_reagent = /datum/reagent/consumable/caffeine/tea_spiced
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_spiced)

/datum/z121_distiller_recipe/rose
	name = "玫瑰花茶"
	output_reagent = /datum/reagent/water/rosewater
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals, /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried)

/datum/z121_distiller_recipe/spiced_rose
	name = "五香玫瑰花茶"
	output_reagent = /datum/reagent/water/rosewater_spiced
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_spiced)

/datum/z121_distiller_recipe/coffee
	name = "咖啡"
	output_reagent = /datum/reagent/consumable/caffeine/coffee
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/coffeebeans, /obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted)

/datum/z121_distiller_recipe/chocolate
	name = "热巧克力"
	output_reagent = /datum/reagent/consumable/chocolate
	input_items = list(/obj/item/reagent_containers/food/snacks/chocolate, /obj/item/reagent_containers/food/snacks/chocolate/slice)

/datum/z121_distiller_recipe/spiced_chocolate
	name = "五香巧克力"
	output_reagent = /datum/reagent/consumable/spiced_chocolate
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/rogue/chocolate_spiced)

/datum/z121_distiller_recipe/poppy_milk
	name = "罂粟奶"
	output_reagent = /datum/reagent/consumable/poppy_milk
	output_amount = 30
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/rogue/poppy)

/datum/z121_distiller_recipe/brew
	category = "初阶酿造"

/datum/z121_distiller_recipe/brew/beer
	name = "啤酒"
	output_reagent = /datum/reagent/consumable/ethanol/beer
	input_items = list(/obj/item/reagent_containers/food/snacks/rogue/bread, /obj/item/reagent_containers/food/snacks/rogue/breadslice, /obj/item/reagent_containers/food/snacks/rogue/bun, /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast, /obj/item/reagent_containers/food/snacks/rogue/crossbun, /obj/item/reagent_containers/food/snacks/rogue/dough, /obj/item/reagent_containers/food/snacks/rogue/doughslice)

/datum/z121_distiller_recipe/brew/fireleaf
	name = "火叶酒"
	output_reagent = /datum/reagent/consumable/ethanol/fireleaf
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/cabbage/rogue, /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced)

/datum/z121_distiller_recipe/brew/onion
	name = "洋葱干邑白兰地"
	output_reagent = /datum/reagent/consumable/ethanol/onion
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/onion/rogue, /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced)

/datum/z121_distiller_recipe/brew/rice
	name = "米酒"
	output_reagent = /datum/reagent/consumable/ethanol/ricewine
	input_items = list(/obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked)

/datum/z121_distiller_recipe/brew/vodka
	name = "伏特加"
	output_reagent = /datum/reagent/consumable/ethanol/voddena
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/potato/rogue, /obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced)

/datum/z121_distiller_recipe/brew/mead
	name = "蜜酒"
	output_reagent = /datum/reagent/consumable/ethanol/mead
	input_items = list(/obj/item/reagent_containers/food/snacks/rogue/honey)

/datum/z121_distiller_recipe/brew/spidermead
	name = "蛛蜜蜜酒"
	output_reagent = /datum/reagent/consumable/ethanol/mead/spider
	input_items = list(/obj/item/reagent_containers/food/snacks/rogue/honey/spider)

/datum/z121_distiller_recipe/brew/apple
	name = "苹果西打"
	output_reagent = /datum/reagent/consumable/ethanol/cider
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/apple, /obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced)

/datum/z121_distiller_recipe/brew/pear
	name = "梨西打"
	output_reagent = /datum/reagent/consumable/ethanol/cider/pear
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/pear)

/datum/z121_distiller_recipe/brew/strawberry
	name = "草莓西打"
	output_reagent = /datum/reagent/consumable/ethanol/cider/strawberry
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry)

/datum/z121_distiller_recipe/brew/butterhairs
	name = "黄油须酒"
	output_reagent = /datum/reagent/consumable/ethanol/butterhairs
	input_items = list(/obj/item/reagent_containers/food/snacks/squiresdelight)

/datum/z121_distiller_recipe/brew/stonebeards
	name = "石须珍藏"
	output_reagent = /datum/reagent/consumable/ethanol/stonebeards
	input_items = list(/obj/item/reagent_containers/food/snacks/rogue/bookbread, /obj/item/reagent_containers/food/snacks/rogue/butterdough, /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice)

/datum/z121_distiller_recipe/brew/molasses
	name = "糖蜜"
	output_reagent = /datum/reagent/consumable/sugar/molasses
	input_items = list(/obj/item/reagent_containers/food/snacks/sugar)

/datum/z121_distiller_recipe/brew/jackberry
	name = "杰克莓酒"
	output_reagent = /datum/reagent/consumable/ethanol/jackberrywine
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue)

/datum/z121_distiller_recipe/brew/tangerine
	name = "柑橘酒"
	output_reagent = /datum/reagent/consumable/ethanol/tangerine
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine)

/datum/z121_distiller_recipe/brew/raspberry
	name = "覆盆子酒"
	output_reagent = /datum/reagent/consumable/ethanol/raspberry
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry)

/datum/z121_distiller_recipe/brew/blackberry
	name = "黑莓酒"
	output_reagent = /datum/reagent/consumable/ethanol/blackberry
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry)

/datum/z121_distiller_recipe/brew/calendula
	name = "金盏花茶"
	output_reagent = /datum/reagent/consumable/golden_calendula_tea
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/nut_sugared, /obj/item/reagent_containers/food/snacks/dragee)

// 二段蒸馏只从容器扣除指定试剂，不把其他混合成分送入宿主体内。
/datum/z121_distiller_recipe/secondary
	category = "二段蒸馏"
	output_amount = 15
	input_amount = 30

/datum/z121_distiller_recipe/secondary/gin
	name = "金酒"
	output_reagent = /datum/reagent/consumable/ethanol/gin
	input_reagents = list(/datum/reagent/consumable/ethanol/voddena)

/datum/z121_distiller_recipe/secondary/ricespirit
	name = "米烧酒"
	output_reagent = /datum/reagent/consumable/ethanol/ricespirit
	input_reagents = list(/datum/reagent/consumable/ethanol/ricewine)

/datum/z121_distiller_recipe/secondary/rum
	name = "朗姆酒"
	output_reagent = /datum/reagent/consumable/ethanol/rum
	input_reagents = list(/datum/reagent/consumable/sugar/molasses)

/datum/z121_distiller_recipe/secondary/apple_brandy
	name = "苹果白兰地"
	output_reagent = /datum/reagent/consumable/ethanol/brandy
	input_reagents = list(/datum/reagent/consumable/ethanol/cider)

/datum/z121_distiller_recipe/secondary/pear_brandy
	name = "梨白兰地"
	output_reagent = /datum/reagent/consumable/ethanol/brandy/pear
	input_reagents = list(/datum/reagent/consumable/ethanol/cider/pear)

/datum/z121_distiller_recipe/secondary/strawberry_brandy
	name = "草莓白兰地"
	output_reagent = /datum/reagent/consumable/ethanol/brandy/strawberry
	input_reagents = list(/datum/reagent/consumable/ethanol/cider/strawberry)

// 没有柑橘西打这一原料，故不以柑橘酒替代图片中的橘子白兰地配方。
/datum/z121_distiller_recipe/secondary/plum_brandy
	name = "李子白兰地"
	output_reagent = /datum/reagent/consumable/ethanol/brandy/plum
	input_reagents = list(/datum/reagent/consumable/ethanol/kgunplum, /datum/reagent/consumable/ethanol/plum_wine, /datum/reagent/consumable/ethanol/plum_wine/aged, /datum/reagent/consumable/ethanol/plum_wine/delectable)

/datum/z121_distiller_recipe/secondary/vitae
	output_reagent = /datum/reagent/consumable/ethanol/aqua_vitae

/datum/z121_distiller_recipe/secondary/vitae/apple
	name = "生命之水·苹果"
	input_reagents = list(/datum/reagent/consumable/ethanol/brandy)

/datum/z121_distiller_recipe/secondary/vitae/pear
	name = "生命之水·梨"
	input_reagents = list(/datum/reagent/consumable/ethanol/brandy/pear)

/datum/z121_distiller_recipe/secondary/vitae/strawberry
	name = "生命之水·草莓"
	input_reagents = list(/datum/reagent/consumable/ethanol/brandy/strawberry)

/datum/z121_distiller_recipe/secondary/vitae/tangerine
	name = "生命之水·橘子"
	input_reagents = list(/datum/reagent/consumable/ethanol/brandy/tangerine)

/datum/z121_distiller_recipe/secondary/vitae/plum
	name = "生命之水·李子"
	input_reagents = list(/datum/reagent/consumable/ethanol/brandy/plum)

/datum/z121_distiller_recipe/misc
	category = "杂项"

/datum/z121_distiller_recipe/misc/aged_cheese
	name = "陈年奶酪汤"
	output_reagent = /datum/reagent/consumable/soup/stew/parmesan
	input_items = list(/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge/aged, /obj/item/reagent_containers/food/snacks/rogue/cheddarslice/aged)

/datum/z121_distiller_recipe/misc/cheese
	name = "奶酪浓汤"
	output_reagent = /datum/reagent/consumable/soup/stew/cheese
	input_items = list(/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge, /obj/item/reagent_containers/food/snacks/rogue/cheddarslice)

/datum/z121_distiller_recipe/misc/fondue
	name = "奶酪火锅"
	output_reagent = /datum/reagent/consumable/soup/stew/thickcheese
	input_items = list(/obj/item/reagent_containers/food/snacks/rogue/cheese)

/datum/z121_distiller_recipe/misc/lemon
	name = "柠檬汁"
	output_reagent = /datum/reagent/consumable/soup/lemon
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon, /obj/item/reagent_containers/food/snacks/rogue/lemoncoppiette)

/datum/z121_distiller_recipe/misc/lime
	name = "青柠汁"
	output_reagent = /datum/reagent/consumable/soup/lime
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lime)
