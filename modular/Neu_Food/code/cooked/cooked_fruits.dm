// Food that is primarily made out of a cooked fruit component.
/*	.............   Cooked pumpkin   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed
	name = "熟南瓜泥"
	icon = 'modular/Neu_Food/icons/cooked/cooked_fruits.dmi'
	icon_state = "pumpkinmash"
	desc = "原本平淡无奇，如今却成了意外地浓稠多纤维的泥糊。"
	faretype = FARE_POOR
	portable = FALSE
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	rotprocess = SHELFLIFE_LONG