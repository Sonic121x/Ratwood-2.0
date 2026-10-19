/datum/brewing_recipe/jack_wine
	name = "杰克莓酒"
	category = "果酒"
	bottle_name = "杰克莓酒"
	bottle_desc = "一瓶本地酿制的杰克莓酒。口感香甜果香浓郁，并带着一丝酸意。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/jackberrywine
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/jack_wine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_crops = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 6)
	brewed_amount = 6
	brew_time = 5 MINUTES // Wine will have a standard brew time of 5 minutes
	sell_value = 50

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/jackberrywine/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/jackberrywine/delectable = 20 MINUTES
	)

/datum/brewing_recipe/plum_wine
	name = "梅酒"
	category = "果酒"
	bottle_name = "梅酒"
	bottle_desc = "一瓶本地酿制的梅酒。口感香甜，略带酸味。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/plum_wine
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/plum_wine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/plum = 4, /obj/item/reagent_containers/food/snacks/sugar = 2)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 50

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/plum_wine/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/plum_wine/delectable = 20 MINUTES
	)

/datum/brewing_recipe/tangerine_wine
	name = "橘子酒"
	category = "果酒"
	bottle_name = "橘子酒"
	bottle_desc = "一瓶本地酿制的橘子酒。口感酸甜微苦，带着鲜明的柑橘风味。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/tangerine
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/tangerine_wine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine = 4, /obj/item/reagent_containers/food/snacks/sugar = 2)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 50

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/tangerine/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/tangerine/delectable = 20 MINUTES
	)

/datum/brewing_recipe/raspberry_wine
	name = "覆盆子酒"
	category = "果酒"
	bottle_name = "覆盆子酒"
	bottle_desc = "一瓶本地酿制的覆盆子酒。口感香甜而酸爽。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/raspberry
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/raspberry_wine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry = 4, /obj/item/reagent_containers/food/snacks/sugar = 2)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 50

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/raspberry/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/raspberry/delectable = 20 MINUTES
	)

/datum/brewing_recipe/blackberry_wine
	name = "黑莓酒"
	category = "果酒"
	bottle_name = "黑莓酒"
	bottle_desc = "一瓶本地酿制的黑莓酒。口感微苦而酸。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/blackberry
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/blackberry_wine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 4, /obj/item/reagent_containers/food/snacks/sugar = 2)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 50

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/blackberry/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/blackberry/delectable = 20 MINUTES
	)

/datum/brewing_recipe/whipwine
	name = "魔鞭酒"
	category = "其他"
	bottle_name = "魔鞭酒" // knockoff divine whip wine (magical penis wine)
	bottle_desc = "一瓶本地酿制的魔鞭酒。据说是基于风玄的配方改制而来的仿制品。带有一种格外...皮革般的风味。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/whipwine
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/whipwine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(
		/obj/item/alch/atropa = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 1,
		/obj/item/alch/matricaria = 1,
		/obj/item/alch/paris = 1,
		/obj/item/rogueweapon/whip = 1,
	) // poisonous herbs, sugar, and an actual whip. the power of Mistranslations...
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 30

/datum/brewing_recipe/luxintenebre
	name = "光暗同酿"
	category = "其他"
	bottle_name = "光暗同酿" // knockoff divine whip wine (magical penis wine)
	bottle_desc = "一瓶可能带有异端色彩的光暗同酿。灵魂核心在发酵后会分解为生命精华，而生命精华还能进一步发酵成可口的美酒。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/luxwine
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/luxintenebre
	needed_reagents = list(/datum/reagent/water = 198) // standard
	needed_items = list(
		/obj/item/reagent_containers/lux_impure = 1,
		/obj/item/reagent_containers/food/snacks/sugar = 2,
		/obj/item/alch/calendula = 1,
	) // a single lux, sugar, and a healing herb. seems fair 2 me.
	brewed_amount = 2 // should make 2 bottles
	brew_time = 5 MINUTES
	sell_value = 120  // this shits heretical and has a high black market value
