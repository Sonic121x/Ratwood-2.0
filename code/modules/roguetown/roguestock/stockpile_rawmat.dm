/datum/roguestock/stockpile/wood
	passive_generation = 5 // Ratwood passive import
	generation_price = 4 // Ratwood passive import
	remote_limit = 20 // Ratwood passive import
	name = "木材"
	desc = "截短后便于运输的木料。"
	item_type = /obj/item/grown/log/tree/small
	trade_good_id = TRADE_GOOD_WOOD
	stockpile_amount = 10
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/coal
	passive_generation = 2 // Ratwood passive import
	generation_price = 5 // Ratwood passive import
	name = "煤炭"
	desc = "用于燃料和合金冶炼的煤块。"
	item_type = /obj/item/rogueore/coal
	trade_good_id = TRADE_GOOD_COAL
	stockpile_amount = 10
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/stone
	passive_generation = 10 // Ratwood passive import
	generation_price = 1 // Ratwood passive import
	remote_limit = 25 // Ratwood passive import
	name = "石头"
	desc = "石头。用于建造。"
	item_type = /obj/item/natural/stone
	trade_good_id = TRADE_GOOD_STONE
	stockpile_amount = 10
	importexport_amt = 10
	stockpile_limit = 50 // Allow a small amount of stones to be sold for chiselling

// Ratwood deviation from AP: ES's glass batch is /obj/item/natural/clay/glassbatch, a SUBTYPE of
// clay - so the glass entry must be defined BEFORE the clay entry for the istype() stockpile
// match to hit glass batches first (same reason hide/cured precedes hide below).
/datum/roguestock/stockpile/glass
	passive_generation = 3 // Ratwood passive import
	generation_price = 4 // Ratwood passive import
	name = "玻璃料"	//'Raw' glass
	desc = "一种由细磨材料混合而成、用于制玻璃的原料。"
	item_type = /obj/item/natural/clay/glassbatch
	trade_good_id = TRADE_GOOD_GLASS_BATCH
	stockpile_amount = 5
	importexport_amt = 5
	stockpile_limit = 25

/datum/roguestock/stockpile/clay
	name = "黏土"
	desc = "从沼泽沉积物中挖出的湿润黏土，可供塑形或烧制。"
	item_type = /obj/item/natural/clay
	trade_good_id = TRADE_GOOD_CLAY
	stockpile_amount = 10
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/salt//Comes from rocks not a farm
	name = "盐"
	desc = "岩盐，可用于腌制与烹饪。"
	item_type = /obj/item/reagent_containers/powder/salt
	trade_good_id = TRADE_GOOD_SALT
	stockpile_amount = 2
	importexport_amt = 5
	stockpile_limit = 25

/datum/roguestock/stockpile/iron
	passive_generation = 2 // Ratwood passive import
	generation_price = 8 // Ratwood passive import
	name = "粗铁"
	desc = "用于锻造的铁块。"
	item_type = /obj/item/rogueore/iron
	trade_good_id = TRADE_GOOD_IRON_ORE
	stockpile_amount = 15
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/copper
	passive_generation = 1 // Ratwood passive import
	generation_price = 4 // Ratwood passive import
	name = "粗铜"
	desc = "用于锻造和合金冶炼的铜块。"
	item_type = /obj/item/rogueore/copper
	trade_good_id = TRADE_GOOD_COPPER_ORE
	stockpile_amount = 12
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/tin
	passive_generation = 1 // Ratwood passive import
	generation_price = 4 // Ratwood passive import
	name = "粗锡"
	desc = "用于锻造和合金冶炼的锡块。"
	item_type = /obj/item/rogueore/tin
	trade_good_id = TRADE_GOOD_TIN_ORE
	stockpile_amount = 12
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/gold
	generation_price = 80 // Ratwood passive import
	name = "粗金"
	desc = "未经提炼的金块。"
	item_type = /obj/item/rogueore/gold
	trade_good_id = TRADE_GOOD_GOLD_ORE
	stockpile_amount = 4
	stockpile_limit = 50
	importexport_amt = 10

/datum/roguestock/stockpile/silver
	no_passive = TRUE // Ratwood passive import
	name = "粗银"
	desc = "未经提炼的银块。"
	item_type = /obj/item/rogueore/silver
	trade_good_id = TRADE_GOOD_SILVER_ORE
	stockpile_amount = 0 // Explicitly empty - players must produce their own silver.
	stockpile_limit = 25
	importexport_amt = 5

/datum/roguestock/stockpile/cinnabar
	passive_generation = 1 // Ratwood passive import
	generation_price = 8 // Ratwood passive import
	name = "朱砂"
	desc = "一种可用于制取水银的红色矿物。"
	item_type = /obj/item/rogueore/cinnabar
	trade_good_id = TRADE_GOOD_CINNABAR
	stockpile_amount = 20
	stockpile_limit = 50
	importexport_amt = 5

/datum/roguestock/stockpile/cloth
	passive_generation = 2 // Ratwood passive import
	generation_price = 3 // Ratwood passive import
	remote_limit = 15 // Ratwood passive import
	name = "布料"
	desc = "用于缝纫和裁缝工作的布匹。"
	item_type = /obj/item/natural/cloth
	trade_good_id = TRADE_GOOD_CLOTH
	stockpile_amount = 10
	importexport_amt = 10
	stockpile_limit = 100

/datum/roguestock/stockpile/fibers
	passive_generation = 4 // Ratwood passive import
	generation_price = 1 // Ratwood passive import
	remote_limit = 20 // Ratwood passive import
	name = "纤维"
	desc = "用于制作布料和其他物品的纤维。"
	item_type = /obj/item/natural/fibers
	trade_good_id = TRADE_GOOD_FIBERS
	stockpile_amount = 10
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/silk
	passive_generation = 1 // Ratwood passive import
	generation_price = 2 // Ratwood passive import
	name = "丝绸"
	desc = "用于制作异域服饰的蜘蛛丝。"
	item_type = /obj/item/natural/silk
	trade_good_id = TRADE_GOOD_SILK
	importexport_amt = 5
	stockpile_limit = 50

//natural/hide/cured must be defined/populated in sstreasury before natural/hide, for istype stockpile check to work
/datum/roguestock/stockpile/cured
	passive_generation = 1 // Ratwood passive import
	generation_price = 6 // Ratwood passive import
	remote_limit = 12 // Ratwood passive import
	name = "鞣制皮革"
	desc = "已经鞣制完成、可直接加工的皮革。"
	item_type = /obj/item/natural/hide/cured
	trade_good_id = TRADE_GOOD_CURED_LEATHER
	stockpile_amount = 15
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/hide
	passive_generation = 1 // Ratwood passive import
	generation_price = 10 // Ratwood passive import
	name = "兽皮"
	desc = "从动物身上剥下的皮。"
	item_type = /obj/item/natural/hide
	trade_good_id = TRADE_GOOD_HIDE
	stockpile_amount = 10
	importexport_amt = 5
	stockpile_limit = 50

/datum/roguestock/stockpile/fur
	generation_price = 12 // Ratwood passive import
	name = "毛皮"
	desc = "带有厚实冬毛的动物皮。"
	item_type = /obj/item/natural/fur
	trade_good_id = TRADE_GOOD_FUR
	stockpile_amount = 10
	importexport_amt = 5
	stockpile_limit = 25
