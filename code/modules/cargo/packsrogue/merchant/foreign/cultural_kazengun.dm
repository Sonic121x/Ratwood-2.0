/datum/supply_pack/rogue/kazengun
	group = "文化货物" // English: Cultural Stock
	crate_name = "风郡货箱"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/kazengun/kanabo
	name = "金棒"
	cost = 220
	contains = list(/obj/item/rogueweapon/mace/goden/steel)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/kazengun/ssangsudo
	name = "双手刀"
	cost = 240
	contains = list(/obj/item/rogueweapon/sword/long/kriegmesser)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/kazengun/haraate
	name = "腹当板甲衣"
	cost = 200
	contains = list(/obj/item/clothing/suit/roguetown/armor/basiceast/crafteast)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/kazengun/kazenpants
	name = "风郡厚皮长裤"
	cost = 40 
	contains = list (/obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/kazengun/mentorhat
	name = "旧竹笠"
	cost = 60
	contains = list(/obj/item/clothing/head/roguetown/mentorhat)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/kazengun/mask_full
	name = "钢制面具"
	cost = 120
	contains = list(/obj/item/clothing/mask/rogue/facemask/steel/kazengun/full)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/kazengun/mask_half
	name = "半棒半面具"
	cost = 90
	contains = list(/obj/item/clothing/mask/rogue/facemask/steel/kazengun)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/kazengun/cloak
	name = "丝绸斗篷"
	cost = 80
	contains = list(/obj/item/clothing/cloak/eastcloak1)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/kazengun/shirt_black
	name = "黑色异域衬衣"
	cost = 35
	contains = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/kazengun/shirt_white
	name = "白色异域衬衣"
	cost = 35
	contains = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/kazengun/captainrobe
	name = "异域长袍"
	cost = 90
	contains = list(/obj/item/clothing/suit/roguetown/armor/basiceast/captainrobe)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/kazengun/kote
	name = "扎曾纳笼手"
	cost = 90
	contains = list(/obj/item/clothing/gloves/roguetown/eastgloves2)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/kazengun/boots
	name = "加固足袋"
	cost = 35
	contains = list(/obj/item/clothing/shoes/roguetown/armor/rumaclan)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/kazengun/trousers
	name = "棉甲袴"
	cost = 30
	contains = list(/obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/kazengun/chonin_kit
	name = "町人步兵套装"
	no_name_quantity = TRUE
	cost = 380
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson,
		/obj/item/clothing/suit/roguetown/armor/basiceast/crafteast,
		/obj/item/clothing/head/roguetown/mentorhat,
		/obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1,
		/obj/item/clothing/shoes/roguetown/armor/rumaclan,
	)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/kazengun/kouken_kit
	name = "寇肯重型甲胄"
	no_name_quantity = TRUE
	cost = 800
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/basiceast/crafteast,
		/obj/item/clothing/head/roguetown/helmet/sallet/beastskull,
		/obj/item/clothing/mask/rogue/facemask/steel/kazengun/full,
		/obj/item/clothing/gloves/roguetown/eastgloves2,
		/obj/item/clothing/cloak/eastcloak1,
	)
	ship_qty_min = 1
	ship_qty_max = 1
