/datum/anvil_recipe/engineering
	i_type = "Engineering"
	appro_skill = /datum/skill/craft/engineering
	craftdiff = 1
	
//--------- TIN RECIPES -----------

/datum/anvil_recipe/engineering/nails
	name = "钉子 x5"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/construction/nail
	createditem_num = 5
	craftdiff = 1

// --------- IRON RECIPES -----------

/datum/anvil_recipe/engineering/jingle_bells
	name = "叮当铃铛"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/jingle_bells
	createditem_num = 5
	craftdiff = 1

/datum/anvil_recipe/engineering/flint
	name = "燧石 x3（+1 石头）"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/stone)
	created_item = /obj/item/flint
	createditem_num = 4
	craftdiff = 0

/datum/anvil_recipe/engineering/chains
	name = "锁链"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/rope/chain
	createditem_num = 1
	craftdiff = 0

/datum/anvil_recipe/engineering/roughbarrel
	name = "粗制铁炮管 (+5 铁)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/bombard_roughbarrel
	createditem_num = 1
	craftdiff = 5

/datum/anvil_recipe/engineering/sandedbarrel
	name = "磨砂铁炮管 (+3 沙子, +2 石粉, +1 半精制炮管)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/dirtclod/sand, /obj/item/natural/dirtclod/sand, /obj/item/natural/dirtclod/sand, /obj/item/alch/stonedust, /obj/item/alch/stonedust, /obj/item/bombard_partiallyrefinedbarrel)
	created_item = /obj/item/bombard_sandedbarrel
	createditem_num = 1
	craftdiff = 5

/datum/anvil_recipe/engineering/repairedsandedbarrel
	name = "修理磨砂炮管 (+4 铁, +1 磨砂铁炮管)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/ingot/iron, /obj/item/bombard_sandedbarrel)
	created_item = /obj/item/bombard_sandedrepairedbarrel
	createditem_num = 1
	craftdiff = 5
