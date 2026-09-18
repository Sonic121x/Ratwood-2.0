/datum/supply_pack/rogue/naledi
	group = "文化货物"
	crate_name = "纳莱迪货箱"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/naledi/hierophant_kit
	name = "纳莱迪大祭司法衣"
	no_name_quantity = TRUE
	cost = 290
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant,
		/obj/item/clothing/suit/roguetown/shirt/robe/hierophant,
		/obj/item/clothing/head/roguetown/roguehood/hierophant,
		/obj/item/clothing/cloak/hierophant,
		/obj/item/clothing/mask/rogue/lordmask/naledi,
		/obj/item/clothing/neck/roguetown/psicross/naledi,
		/obj/item/clothing/shoes/roguetown/sandals,
		/obj/item/rogueweapon/woodstaff/naledi,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/naledi/pontifex_kit
	name = "纳莱迪教宗法衣"
	no_name_quantity = TRUE
	cost = 200
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex,
		/obj/item/clothing/suit/roguetown/shirt/robe/pointfex,
		/obj/item/clothing/head/roguetown/roguehood/pontifex,
		/obj/item/clothing/under/roguetown/trou/leather/pontifex,
		/obj/item/clothing/mask/rogue/lordmask/naledi,
		/obj/item/clothing/neck/roguetown/psicross/naledi,
		/obj/item/clothing/shoes/roguetown/sandals,
		/obj/item/clothing/gloves/roguetown/angle/pontifex,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/naledi/psicross
	name = "纳莱迪普赛圣十字"
	cost = 80
	contains = list(/obj/item/clothing/neck/roguetown/psicross/naledi)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/naledi/lordmask
	name = "纳莱迪战学者面具"
	cost = 70
	contains = list(/obj/item/clothing/mask/rogue/lordmask/naledi)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/naledi/pashmina
	name = "大祭司帕什米纳"
	cost = 45
	contains = list(/obj/item/clothing/head/roguetown/roguehood/hierophant)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/naledi/hierophantshawl
	name = "大祭司披肩"
	cost = 60
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/naledi/naleditrou
	name = "教宗恰克丘尔"
	cost = 40 
	contains = list (/obj/item/clothing/under/roguetown/trou/leather/pontifex)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/naledi/naledigamba
	name = "教宗卡夫坦长袍"
	cost = 60 // Base sellprice of 30
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/naledi/sandals
	name = "纳莱迪凉鞋"
	cost = 25
	contains = list(
		/obj/item/clothing/shoes/roguetown/sandals,
		/obj/item/clothing/shoes/roguetown/sandals,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/naledi/treatise
	name = "战学者之路论著"
	cost = 60
	contains = list(
		/obj/item/book/rogue/naledi1,
		/obj/item/book/rogue/naledi2,
		/obj/item/book/rogue/naledi3,
		/obj/item/book/rogue/naledi4,
	)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/naledi/glassen_decanters
	name = "玻璃醒酒器套装"
	cost = 30
	contains = list(
		/obj/item/reagent_containers/glass/bottle/rogue,
		/obj/item/reagent_containers/glass/bottle/rogue,
		/obj/item/reagent_containers/glass/bottle/rogue,
		/obj/item/reagent_containers/glass/bottle/rogue,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/naledi/glass_statue
	name = "玻璃杰作雕像"
	cost = 110
	contains = list(/obj/item/roguestatue/glass)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/naledi/gold_finery
	name = "维拉伦黄金饰物"
	cost = 180
	contains = list(
		/obj/item/clothing/ring/gold,
		/obj/item/clothing/ring/gold,
	)
	ship_qty_min = 1
	ship_qty_max = 2
