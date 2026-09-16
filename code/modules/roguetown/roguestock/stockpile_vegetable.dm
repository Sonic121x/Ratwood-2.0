// Withdraw Price used to be designed to match export price.
// However this meant that food were often too expensive to buy as raw materials
// Now for food the withdraw price is set to be the same as the payout price
// Theoretically this does create a perverse incentive to export food instead of selling it locally
// But I live for the consequences of stewards deciding to neglect their local economy.
//
/datum/roguestock/stockpile/grain
	name = "谷物"
	desc = "斯佩耳特小麦。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/wheat
	trade_good_id = TRADE_GOOD_GRAIN
	importexport_amt = 10
	stockpile_amount = 25
	stockpile_limit = 50
	category = "Vegetable" //Not entirely accurate but it looks prettier in UI

/datum/roguestock/stockpile/oat
	name = "燕麦"
	desc = "一种谷类作物。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/oat
	trade_good_id = TRADE_GOOD_OATS
	importexport_amt = 10
	stockpile_amount = 15
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/rice
	name = "稻米"
	desc = "一种用于烹饪的谷物。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/rice
	trade_good_id = TRADE_GOOD_RICE
	importexport_amt = 10
	stockpile_amount = 15
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/cabbage
	name = "卷心菜"
	desc = "一种叶菜。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/cabbage/rogue
	trade_good_id = TRADE_GOOD_CABBAGE
	importexport_amt = 10
	stockpile_amount = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/potato
	name = "马铃薯"
	desc = "一种有趣的块茎。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/potato/rogue
	trade_good_id = TRADE_GOOD_POTATO
	importexport_amt = 10
	stockpile_amount = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/onion
	name = "洋葱"
	desc = "一种鳞茎类蔬菜。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/onion/rogue
	trade_good_id = TRADE_GOOD_ONION
	importexport_amt = 10
	stockpile_amount = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/garlick
	name = "大蒜"
	desc = "一种气味辛辣的根茎类蔬菜。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/garlick/rogue
	trade_good_id = TRADE_GOOD_GARLICK
	importexport_amt = 10
	stockpile_amount = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/turnip
	name = "芜菁"
	desc = "一种耐寒的根茎类蔬菜，适合做汤。穷人常吃。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/vegetable/turnip
	trade_good_id = TRADE_GOOD_TURNIP
	importexport_amt = 10
	stockpile_amount = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/carrot
	name = "胡萝卜"
	desc = "一种细长的蔬菜，据说对视力有益。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/carrot
	trade_good_id = TRADE_GOOD_CARROT
	importexport_amt = 10
	stockpile_amount = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/cucumber
	name = "黄瓜"
	desc = "一种清爽的细长绿色蔬菜。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/cucumber
	trade_good_id = TRADE_GOOD_CUCUMBER
	importexport_amt = 10
	stockpile_amount = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/eggplant
	name = "茄子"
	desc = "一种味道清淡的紫色大蔬菜。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/eggplant
	trade_good_id = TRADE_GOOD_EGGPLANT
	importexport_amt = 10
	stockpile_amount = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/sugar
	name = "糖"
	desc = "由甘蔗磨成的甜味粉末。"
	item_type = /obj/item/reagent_containers/food/snacks/sugar
	trade_good_id = TRADE_GOOD_SUGAR
	importexport_amt = 10
	stockpile_amount = 5
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/coffee
	name = "咖啡豆"
	desc = "咖啡树的种子，用于制作提神饮品。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/coffeebeans
	trade_good_id = TRADE_GOOD_COFFEE
	importexport_amt = 10
	stockpile_amount = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/tea
	name = "干茶叶"
	desc = "从茶树采下的干茶叶。可以磨碎冲泡成茶。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	trade_good_id = TRADE_GOOD_TEA
	importexport_amt = 10
	stockpile_amount = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/poppy
	name = "罂粟"
	desc = "一种具有镇静效果的种子。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/rogue/poppy
	trade_good_id = TRADE_GOOD_POPPY
	importexport_amt = 10
	stockpile_amount = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/rocknut
	name = "岩果"
	desc = "一种略带兴奋作用的坚果。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/nut
	trade_good_id = TRADE_GOOD_ROCKNUT
	importexport_amt = 10
	stockpile_amount = 5
	stockpile_limit = 50
	category = "Vegetable"
