// 基础材料不要求美食知识，种植和取种沿用原有农业规则。
/obj/item/reagent_containers/food/snacks/grown/z121
	name = "信义作物"
	desc = "可食用的作物，也能在地上用钝器取出种子。"
	icon = 'modular_z121/icon/food.dmi'
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_NEUTRAL
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	cooktime = 0
	cooked_type = null
	fried_type = null

/obj/item/reagent_containers/food/snacks/grown/z121/pre_attack(atom/A, mob/living/user, params)
	return ..() || z121_start_cuisine(A, user)

/obj/item/reagent_containers/food/snacks/grown/z121/attackby(obj/item/I, mob/living/user, params)
	if(!user.cmode && I.z121_start_cuisine(src, user))
		return TRUE
	return ..()

/obj/item/reagent_containers/food/snacks/rogue/z121_ingredient
	parent_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage
	name = "信义食材"
	faretype = FARE_NEUTRAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/pre_attack(atom/A, mob/living/user, params)
	return ..() || z121_start_cuisine(A, user)

/datum/reagent/consumable/z121_soy_sauce
	name = "酱油"
	description = "咸鲜醇厚的豆酿调味汁。"
	taste_description = "咸鲜酱香"
	color = "#51301d"
	nutriment_factor = 0

/datum/reagent/consumable/z121_rice_vinegar
	name = "米醋"
	description = "清酸的米酿调味汁，可用于调味与凝固豆浆。"
	taste_description = "清酸米醋"
	color = "#be9e52"
	nutriment_factor = 0

/obj/item/reagent_containers/glass/z121_condiment
	name = "调味瓶"
	desc = "装有料理调味汁的瓶子，用空后可以重新灌装。"
	icon = 'modular_z121/icon/food.dmi'
	volume = 40
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1, 2, 3, 5, 10, 20)
	experimental_inhand = TRUE
	w_class = WEIGHT_CLASS_SMALL

/obj/item/reagent_containers/glass/z121_condiment/soy_sauce
	name = "酱油瓶"
	icon_state = "soy_sauce"
	list_reagents = list(/datum/reagent/consumable/z121_soy_sauce = 40)

/obj/item/reagent_containers/glass/z121_condiment/rice_vinegar
	name = "米醋瓶"
	icon_state = "rice_vinegar"
	list_reagents = list(/datum/reagent/consumable/z121_rice_vinegar = 40)

/obj/item/reagent_containers/food/snacks/grown/z121/soybean
	name = "黄豆"
	desc = "圆润饱满的黄豆，带着淡淡豆香，可磨浆制成豆腐。"
	icon_state = "soybean"
	seed = /obj/item/seeds/z121_soybean
	eat_effect = /datum/status_effect/debuff/uncookedfood

/obj/item/seeds/z121_soybean
	name = "黄豆种子"
	desc = "一包黄豆种子，适宜播入松软湿润的土中。"
	seed_identity = "黄豆种子"
	plant_def_type = /datum/plant_def/z121_soybean
	icon = 'modular_z121/icon/crops.dmi'
	icon_state = "soybean_seed"

/datum/plant_def/z121_soybean
	name = "黄豆"
	desc = "可采收料理用黄豆的作物。"
	icon = 'modular_z121/icon/crops.dmi'
	icon_state = "soybean"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/z121/soybean
	maturation_time = 5 MINUTES
	produce_time = 3 MINUTES
	produce_amount_min = 3
	produce_amount_max = 4

/datum/plant_def/z121_soybean/New()
	. = ..()
	seed_color = "#ffffff"

/datum/supply_pack/rogue/seeds/z121_soybean
	name = "黄豆种子"
	cost = 6
	contains = list(/obj/item/seeds/z121_soybean, /obj/item/seeds/z121_soybean)

/obj/item/reagent_containers/food/snacks/grown/z121/chili
	name = "辣椒"
	desc = "鲜亮的辣椒，辛辣的香气藏在果皮之下。"
	icon_state = "chili"
	seed = /obj/item/seeds/z121_chili

/obj/item/seeds/z121_chili
	name = "辣椒种子"
	desc = "一包辣椒种子，适宜播入松软湿润的土中。"
	seed_identity = "辣椒种子"
	plant_def_type = /datum/plant_def/z121_chili
	icon = 'modular_z121/icon/crops.dmi'
	icon_state = "chili_seed"

/datum/plant_def/z121_chili
	name = "辣椒"
	desc = "可采收料理用辣椒的作物。"
	icon = 'modular_z121/icon/crops.dmi'
	icon_state = "chili"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/z121/chili
	maturation_time = 5 MINUTES
	produce_time = 3 MINUTES
	produce_amount_min = 3
	produce_amount_max = 4
	perennial = TRUE

/datum/plant_def/z121_chili/New()
	. = ..()
	seed_color = "#ffffff"

/datum/supply_pack/rogue/seeds/z121_chili
	name = "辣椒种子"
	cost = 6
	contains = list(/obj/item/seeds/z121_chili, /obj/item/seeds/z121_chili)

/obj/item/reagent_containers/food/snacks/grown/z121/peanut
	name = "花生"
	desc = "饱满的花生仁，炒熟后酥脆喷香。"
	icon_state = "peanut"
	seed = /obj/item/seeds/z121_peanut
	eat_effect = /datum/status_effect/debuff/uncookedfood

/obj/item/seeds/z121_peanut
	name = "花生种子"
	desc = "一包花生种子，适宜播入松软湿润的土中。"
	seed_identity = "花生种子"
	plant_def_type = /datum/plant_def/z121_peanut
	icon = 'modular_z121/icon/crops.dmi'
	icon_state = "peanut_seed"

/datum/plant_def/z121_peanut
	name = "花生"
	desc = "可采收料理用花生的作物。"
	icon = 'modular_z121/icon/crops.dmi'
	icon_state = "peanut"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/z121/peanut
	maturation_time = 5 MINUTES
	produce_time = 3 MINUTES
	produce_amount_min = 3
	produce_amount_max = 4

/datum/plant_def/z121_peanut/New()
	. = ..()
	seed_color = "#ffffff"

/datum/supply_pack/rogue/seeds/z121_peanut
	name = "花生种子"
	cost = 6
	contains = list(/obj/item/seeds/z121_peanut, /obj/item/seeds/z121_peanut)

/obj/item/reagent_containers/food/snacks/grown/z121/ginger
	name = "姜"
	desc = "辛香的姜块，适宜与肉料一同烹煮。"
	icon_state = "ginger"
	seed = /obj/item/seeds/z121_ginger

/obj/item/seeds/z121_ginger
	name = "姜种子"
	desc = "一包姜种子，适宜播入松软湿润的土中。"
	seed_identity = "姜种子"
	plant_def_type = /datum/plant_def/z121_ginger
	icon = 'modular_z121/icon/crops.dmi'
	icon_state = "ginger_seed"

/datum/plant_def/z121_ginger
	name = "姜"
	desc = "可采收料理用姜的作物。"
	icon = 'modular_z121/icon/crops.dmi'
	icon_state = "ginger"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/z121/ginger
	maturation_time = 5 MINUTES
	produce_time = 3 MINUTES
	produce_amount_min = 3
	produce_amount_max = 4

/datum/plant_def/z121_ginger/New()
	. = ..()
	seed_color = "#ffffff"

/datum/supply_pack/rogue/seeds/z121_ginger
	name = "姜种子"
	cost = 6
	contains = list(/obj/item/seeds/z121_ginger, /obj/item/seeds/z121_ginger)

/obj/item/reagent_containers/food/snacks/grown/z121/scallion
	name = "葱"
	desc = "青翠鲜嫩的葱，能为汤羹与肉馅添上一缕清香。"
	icon_state = "scallion"
	seed = /obj/item/seeds/z121_scallion

/obj/item/seeds/z121_scallion
	name = "葱种子"
	desc = "一包葱种子，适宜播入松软湿润的土中。"
	seed_identity = "葱种子"
	plant_def_type = /datum/plant_def/z121_scallion
	icon = 'modular_z121/icon/crops.dmi'
	icon_state = "scallion_seed"

/datum/plant_def/z121_scallion
	name = "葱"
	desc = "可采收料理用葱的作物。"
	icon = 'modular_z121/icon/crops.dmi'
	icon_state = "scallion"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/z121/scallion
	maturation_time = 5 MINUTES
	produce_time = 3 MINUTES
	produce_amount_min = 3
	produce_amount_max = 4

/datum/plant_def/z121_scallion/New()
	. = ..()
	seed_color = "#ffffff"

/datum/supply_pack/rogue/seeds/z121_scallion
	name = "葱种子"
	cost = 6
	contains = list(/obj/item/seeds/z121_scallion, /obj/item/seeds/z121_scallion)

/obj/item/reagent_containers/food/snacks/grown/z121/sichuan_pepper
	name = "花椒"
	desc = "一簇芳香的花椒，入口带着鲜明的麻意。"
	icon_state = "sichuan_pepper"
	seed = /obj/item/seeds/z121_sichuan_pepper

/obj/item/seeds/z121_sichuan_pepper
	name = "花椒种子"
	desc = "一包花椒种子，适宜播入松软湿润的土中。"
	seed_identity = "花椒种子"
	plant_def_type = /datum/plant_def/z121_sichuan_pepper
	icon = 'modular_z121/icon/crops.dmi'
	icon_state = "sichuan_pepper_seed"

/datum/plant_def/z121_sichuan_pepper
	name = "花椒"
	desc = "可采收料理用花椒的作物。"
	icon = 'modular_z121/icon/crops.dmi'
	icon_state = "sichuan_pepper"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/z121/sichuan_pepper
	maturation_time = 6 MINUTES
	produce_time = 3 MINUTES
	produce_amount_min = 2
	produce_amount_max = 3
	perennial = TRUE

/datum/plant_def/z121_sichuan_pepper/New()
	. = ..()
	seed_color = "#ffffff"

/datum/supply_pack/rogue/seeds/z121_sichuan_pepper
	name = "花椒种子"
	cost = 8
	contains = list(/obj/item/seeds/z121_sichuan_pepper, /obj/item/seeds/z121_sichuan_pepper)

/obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/tofu
	name = "豆腐"
	desc = "压制成形的白嫩豆腐。放在桌上加入豆瓣酱，可开始制作麻婆豆腐。"
	icon_state = "tofu"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)

/obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/doubanjiang
	name = "豆瓣酱"
	desc = "一份浓郁的豆瓣酱，连同可食用薄豆皮包装一起拌入料理。"
	icon_state = "doubanjiang"
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/abalone_dry
	name = "鲍鱼干"
	desc = "干制的鲍鱼肉。放在桌上用空碗盛装，再添足清水，耐心泡发。"
	icon_state = "abalone_dry"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	foodtype = MEAT
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/sea_cucumber_dry
	name = "海参干"
	desc = "干制的海参。放在桌上用空碗盛装，再添足清水，耐心泡发。"
	icon_state = "sea_cucumber_dry"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	foodtype = MEAT
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/abalone_soaked
	name = "泡发鲍鱼"
	desc = "泡发后的饱满鲍鱼肉。放在桌上加入泡发海参，可开始准备佛跳墙。"
	icon_state = "abalone_soaked"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	foodtype = MEAT
	eat_effect = /datum/status_effect/debuff/uncookedfood

/obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/sea_cucumber_soaked
	name = "泡发海参"
	desc = "已经泡软的海参，可作为佛跳墙的配料。"
	icon_state = "sea_cucumber_soaked"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	foodtype = MEAT
	eat_effect = /datum/status_effect/debuff/uncookedfood

/datum/supply_pack/rogue/food/z121_soy_sauce
	name = "酱油瓶"
	cost = 20
	contains = list(/obj/item/reagent_containers/glass/z121_condiment/soy_sauce)

/datum/supply_pack/rogue/food/z121_rice_vinegar
	name = "米醋瓶"
	cost = 20
	contains = list(/obj/item/reagent_containers/glass/z121_condiment/rice_vinegar)

/datum/supply_pack/rogue/food/z121_doubanjiang
	name = "豆瓣酱"
	cost = 16
	contains = list(/obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/doubanjiang, /obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/doubanjiang)

/datum/supply_pack/rogue/food/z121_abalone_dry
	name = "鲍鱼干"
	cost = 25
	contains = list(/obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/abalone_dry)

/datum/supply_pack/rogue/food/z121_sea_cucumber_dry
	name = "海参干"
	cost = 25
	contains = list(/obj/item/reagent_containers/food/snacks/rogue/z121_ingredient/sea_cucumber_dry)
