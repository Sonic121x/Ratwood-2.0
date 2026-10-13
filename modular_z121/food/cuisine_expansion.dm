// 新增成品和可继续加工的加热阶段。

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/sixi
	name = "四喜丸子"
	desc = "四枚红亮的丸子焖得酥软，裹着咸甜酱汁。"
	icon_state = "sixi"
	foodtype = MEAT | VEGETABLES
	faretype = FARE_LAVISH
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("四喜丸子的鲜香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/white_chicken
	name = "白切鸡"
	desc = "白嫩鸡肉切成整齐的块，带着葱姜清香与鲜润蘸汁。"
	icon_state = "white_chicken"
	foodtype = MEAT | VEGETABLES
	faretype = FARE_FINE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("白切鸡的鲜香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/mapo
	name = "麻婆豆腐"
	desc = "鲜嫩豆腐浸在红亮豆瓣酱汁中，点缀肉末、辣椒和花椒。"
	icon_state = "mapo"
	foodtype = MEAT | VEGETABLES
	faretype = FARE_FINE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	tastes = list("麻婆豆腐的鲜香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/kungpao
	name = "宫保鸡丁"
	desc = "鸡丁、花生和辣椒裹着酸甜酱汁，葱姜香气浓郁。"
	icon_state = "kungpao"
	foodtype = MEAT | VEGETABLES
	faretype = FARE_FINE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	tastes = list("宫保鸡丁的鲜香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/buddha_serving
	name = "一碗佛跳墙"
	desc = "鲍鱼、海参和肉料炖出的浓汤，鲜香醇厚。"
	icon_state = "buddha_serving"
	foodtype = MEAT | VEGETABLES
	faretype = FARE_LAVISH
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("一碗佛跳墙的鲜香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/hotpot/buddha
	name = "佛跳墙"
	desc = "盛着鲍鱼、海参和肉料的浓汤，可用空碗分成四份。"
	icon_state = "buddha"
	faretype = FARE_LAVISH
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF * 4)
	tastes = list("醇厚海味" = 3, "酒香肉汤" = 1)
	serving_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/buddha_serving

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage/fried_sixi
	name = "炸定型的四喜丸子"
	desc = "外层刚炸定型，内里仍需焖熟。放桌上依次加入适量酱油、少许糖和米酒。"
	icon_state = "fried_sixi"

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage/poached_chicken
	name = "汆熟的白切鸡"
	desc = "鸡肉已熟。放桌上用菜刀切块，再加适量酱油与少许炼制油脂完成调味。"
	icon_state = "poached_chicken"
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage/soy_cooked
	name = "熟豆浆"
	desc = "这碗豆浆已经煮熟。放桌上加少许米醋，静候凝固，再用擀面杖压成豆腐。"
	icon_state = "soy_cooked"
	eat_effect = null
	z121_requires_bowl = TRUE

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/sixi
	name = "生四喜丸子"
	desc = "揉好的四枚生丸子，需要先炸定型，再调汁焖熟。"
	icon_state = "raw_sixi"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage/fried_sixi
	cuisine_time = 30 SECONDS
	cuisine_verb = "炸制"
	liquid_type = /datum/reagent/consumable/oil/tallow
	liquid_amount = 5
	foodtype = MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/sixi_braise
	name = "待焖四喜丸子"
	desc = "炸定型的丸子已裹上酱油、糖和米酒，需要焖至内里熟透。"
	icon_state = "braise_sixi"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/sixi
	cuisine_time = 45 SECONDS
	cuisine_verb = "焖煮"
	liquid_type = /datum/reagent/water
	liquid_amount = 30
	foodtype = MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/buddha
	name = "佛跳墙炖料"
	desc = "鲍鱼、海参、禽肉和五花肉配上姜与酒，等待慢炖。"
	icon_state = "raw_buddha"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/hotpot/buddha
	cuisine_time = 90 SECONDS
	cuisine_verb = "炖煮"
	liquid_type = /datum/reagent/water
	liquid_amount = 120
	foodtype = MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/white_chicken
	name = "待汆白切鸡"
	desc = "葱姜和米酒调味的生禽肉，汆熟后还需上桌切块调味。"
	icon_state = "raw_white_chicken"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage/poached_chicken
	cuisine_time = 60 SECONDS
	cuisine_verb = "汆煮"
	liquid_type = /datum/reagent/water
	liquid_amount = 60
	foodtype = MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/mapo
	name = "麻婆豆腐配料"
	desc = "豆腐块与肉糜、豆瓣酱及香辛料，等待炒熟。"
	icon_state = "raw_mapo"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/mapo
	cuisine_time = 30 SECONDS
	cuisine_verb = "炒制"
	liquid_type = /datum/reagent/consumable/oil/tallow
	liquid_amount = 5
	needs_bowl = TRUE
	foodtype = MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/kungpao
	name = "宫保鸡丁配料"
	desc = "生鸡丁与花生、辣椒、葱姜，裹着尚未炒香的调味汁。"
	icon_state = "raw_kungpao"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine/kungpao
	cuisine_time = 30 SECONDS
	cuisine_verb = "炒制"
	liquid_type = /datum/reagent/consumable/oil/tallow
	liquid_amount = 5
	foodtype = MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_raw/soy_milk
	name = "生豆浆"
	desc = "一碗磨细的黄豆浆，还带着生豆的气味，需要入锅煮熟。"
	icon_state = "soy_raw"
	result_type = /obj/item/reagent_containers/food/snacks/rogue/z121_cuisine_stage/soy_cooked
	cuisine_time = 30 SECONDS
	cuisine_verb = "煮浆"
	liquid_type = /datum/reagent/water
	liquid_amount = 10
	requires_cuisine_knowledge = FALSE
	z121_requires_bowl = TRUE
