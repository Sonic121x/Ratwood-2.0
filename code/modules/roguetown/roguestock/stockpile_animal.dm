// Ratwood deviation from AP: AP's exotic meats are sibling types (meat/rat, meat/wolf, meat/bear).
// In ES they are SUBTYPES of steak (meat/steak/rat, meat/steak/wolf, meat/steak/bear), so they
// must be defined BEFORE the plain steak "Meat" entry - stockpile matching walks
// SStreasury.stockpile_datums in definition order with istype(), same reason hide/cured
// precedes hide in stockpile_rawmat.dm.
/datum/roguestock/stockpile/volf
	name = "丛林肉"
	desc = "从沃尔夫身上取得的勉强能吃的肉。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf
	trade_good_id = TRADE_GOOD_MEAT_EXOTIC
	importexport_amt = 5
	stockpile_amount = 0
	stockpile_limit = 20
	payout_price = 2
	withdraw_price = 4
	category = "Animal"

/datum/roguestock/stockpile/meat
	name = "肉"
	desc = "从动物身上取得的可食用肉。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak
	trade_good_id = TRADE_GOOD_MEAT
	importexport_amt = 10
	stockpile_amount = 5
	stockpile_limit = 50
	category = "Animal"

/datum/roguestock/stockpile/spider
	name = "沼泽肉"
	desc = "从泥伏兽身上取得的勉强能吃的肉。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/spider
	trade_good_id = TRADE_GOOD_MEAT_EXOTIC
	importexport_amt = 5
	stockpile_amount = 0
	stockpile_limit = 20
	category = "Animal"

/datum/roguestock/stockpile/crabbo
	name = "蟹肉"
	desc = "从螃蟹身上取得的可食用肉。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/crab
	trade_good_id = TRADE_GOOD_MEAT_EXOTIC
	importexport_amt = 5
	stockpile_amount = 0
	stockpile_limit = 20
	payout_price = 4
	withdraw_price = 8
	category = "Seafood"

/datum/roguestock/stockpile/poultry
	name = "禽肉"
	desc = "从鸟类身上取得的可食用肉。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry
	trade_good_id = TRADE_GOOD_POULTRY
	importexport_amt = 5
	stockpile_amount = 2
	stockpile_limit = 25
	category = "Animal"

/datum/roguestock/stockpile/rabbit
	name = "兔兽肉"
	desc = "从兔兽身上取得的可食用肉。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit
	trade_good_id = TRADE_GOOD_RABBIT
	importexport_amt = 5
	stockpile_amount = 2
	stockpile_limit = 25
	category = "Animal"

/datum/roguestock/stockpile/pork
	name = "猪肉"
	desc = "从猪身上取得的可食用肉。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty
	trade_good_id = TRADE_GOOD_PORK
	stockpile_amount = 2
	importexport_amt = 5
	stockpile_limit = 25
	category = "Animal"

/datum/roguestock/stockpile/bones
	name = "骨头"
	desc = "熬汤及其他用途的上好材料。"
	item_type = /obj/item/natural/bone
	trade_good_id = TRADE_GOOD_BONES
	stockpile_amount = 0
	importexport_amt = 0
	stockpile_limit = 50
	category = "Animal"

/datum/roguestock/stockpile/fat
	name = "脂肪"
	desc = "动物身上的油脂。"
	item_type = /obj/item/reagent_containers/food/snacks/fat
	trade_good_id = TRADE_GOOD_FAT
	stockpile_amount = 10
	importexport_amt = 5
	stockpile_limit = 50
	category = "Animal"

/datum/roguestock/stockpile/tallow
	name = "牛脂"
	desc = "便于储藏的脂肪组织。"
	item_type = /obj/item/reagent_containers/food/snacks/tallow
	trade_good_id = TRADE_GOOD_TALLOW
	importexport_amt = 5
	stockpile_limit = 25
	category = "Animal"

/datum/roguestock/stockpile/honey
	name = "蜂蜜"
	desc = "来自甜美之地的甜美美味。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/honey
	trade_good_id = TRADE_GOOD_HONEY
	stockpile_amount = 1
	importexport_amt = 5
	stockpile_limit = 15
	category = "Animal"

/datum/roguestock/stockpile/egg
	name = "蛋"
	desc = "母鸡下的蛋。"
	item_type = /obj/item/reagent_containers/food/snacks/egg
	trade_good_id = TRADE_GOOD_EGG
	stockpile_amount = 4
	importexport_amt = 5
	stockpile_limit = 25
	category = "Animal"

/datum/roguestock/stockpile/butter
	name = "黄油"
	desc = "牛奶与盐的产物。"
	item_type = /obj/item/reagent_containers/food/snacks/butter
	trade_good_id = TRADE_GOOD_BUTTER
	importexport_amt = 5
	stockpile_amount = 5
	stockpile_limit = 25
	category = "Animal"

/datum/roguestock/stockpile/cheese
	name = "奶酪"
	desc = "牛奶与盐的产物。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/cheese
	trade_good_id = TRADE_GOOD_CHEESE
	stockpile_amount = 5
	importexport_amt = 5
	stockpile_limit = 25
	category = "Animal"

/datum/roguestock/stockpile/salumoi
	name = "萨卢莫伊"
	desc = "矮人烟熏香肠，经腌制可存放十年不腐。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/salami
	trade_good_id = TRADE_GOOD_SALUMOI
	importexport_amt = 3
	stockpile_limit = 20
	category = "Animal"

/datum/roguestock/stockpile/sausage
	name = "香肠"
	desc = "将熟肉塞入肠衣制成，可存放一季不坏。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	trade_good_id = TRADE_GOOD_SAUSAGE
	importexport_amt = 3
	stockpile_limit = 20
	category = "Animal"
