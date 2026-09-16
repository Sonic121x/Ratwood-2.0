// Cooked seafood. Not including special meals.
/obj/item/reagent_containers/food/snacks/rogue/fryfish
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood.dmi'
	trash = null
	list_reagents = list(/datum/reagent/consumable/nutriment = 10)
	tastes = list("鱼肉香" = 1)
	name = "熟鱼"
	faretype = FARE_POOR
	desc = "一条烤得焦香、酥脆恰到好处的鱼。"
	icon_state = "carpcooked"
	foodtype = MEAT
	warming = 5 MINUTES
	dropshrink = 0.6

/obj/item/reagent_containers/food/snacks/rogue/fryfish/carp
	name = "熟鲤鱼"
	desc = "一条烤得焦香酥脆的鲤鱼，味道温和、肉质结实。适合穷人果腹。"
	icon_state = "carpcooked"
	faretype = FARE_IMPOVERISHED

/obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish
	name = "熟小丑鱼"
	desc = "一条熟透的小丑鱼，昔日鲜艳的色彩已然褪去。"
	icon_state = "clownfishcooked"
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/fryfish/angler
	name = "熟鮟鱇鱼"
	desc = "一条熟透的鮟鱇鱼，味道甜美浓厚，足以讨人喜欢。"
	icon_state = "anglercooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/eel
	name = "熟鳗鱼"
	desc = "一条熟透的鳗鱼。味道浓郁，肉质松软，是一道佳肴。"
	icon_state = "eelcooked"
	faretype = FARE_NEUTRAL
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/jelliedeel

/obj/item/reagent_containers/food/snacks/rogue/fryfish/sole
	name = "熟鳎鱼"
	desc = "一条熟透的鳎鱼，味道温和、肉质松软。适合穷人果腹。"
	icon_state = "solecooked"
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/fryfish/cod
	name = "熟鳕鱼"
	desc = "一条熟透的鳕鱼，味道温和、肉质松软，相当受欢迎。"
	icon_state = "codcooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster
	name = "熟龙虾"
	desc = "一只熟透的龙虾。味道浓郁甘甜，但肉并不多。单独吃时常被视作穷人食物，但加上黄油或胡椒后就是佳肴。"
	icon_state = "lobstercooked"
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon
	name = "熟鲑鱼"
	desc = "一条熟透的鲑鱼。煮熟后就没那么吓人了。它的鱼肉丰腴油润，一旦加上香料就颇受欢迎。"
	icon_state = "salmoncooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice
	name = "熟鲽鱼"
	desc = "一条熟透的鲽鱼，味道温和而甘甜。深受富人喜爱。"
	icon_state = "plaicecooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/mudskipper
	name = "熟弹涂鱼"
	desc = "一条熟透的弹涂鱼，带着鱼腥与泥土气息。很受流浪汉欢迎。"
	icon_state = "mudskippercooked"
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/fryfish/bass
	name = "熟海鲈鱼"
	desc = "一条熟透的海鲈鱼。肉质紧实，很适合搭配香料和酱汁。"
	icon_state = "seabasscooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny
	name = "熟太阳鱼"
	desc = "一条熟透的太阳鱼，肉质细嫩松软。"
	icon_state = "sunnycooked"
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/fryfish/clam
	name = "熟蛤蜊"
	desc = "一只熟透的蛤蜊，味道甘甜而带海咸，常被拿来煮汤。"
	icon_state = "clamcooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp
	name = "熟虾"
	desc = "一只熟透的虾，肉质结实弹牙，带着天然咸鲜。"
	icon_state = "shrimpcooked"
	faretype = FARE_NEUTRAL
	name = "熟虾"
	tastes = list("虾仁香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/fryfish/crab
	name = "熟蟹"
	desc = "一只熟透的螃蟹，味道甘甜浓郁。人们常费劲把它做成蟹饼。"
	icon_state = "crabcooked"
	faretype = FARE_NEUTRAL
	name = "熟蟹"
	tastes = list("蟹肉香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon/black_headed
	name = "黑头鲑鱼"
	icon_state = "salmon_black"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/flounder
	name = "比目鱼"
	icon_state = "flounder"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_shrimp
	name = "沼虾"
	icon_state = "swamp_shrimp"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_mother
	name = "沼母鱼"
	icon_state = "swamp_mother"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/black_bass
	name = "黑鲈"
	icon_state = "black_bass"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/zizo_abberation
	name = "齐佐异变鱼"
	icon_state = "zizo_abberation"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/sturgeon
	name = "鲟鱼"
	icon_state = "sturgeon"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/mackerel
	name = "鲭鱼"
	icon_state = "mackerel"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/beaksnapper
	name = "喙鲷"
	icon_state = "beaksnapper"
	faretype = FARE_NEUTRAL
