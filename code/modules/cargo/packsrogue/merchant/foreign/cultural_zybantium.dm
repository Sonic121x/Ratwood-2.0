/datum/supply_pack/rogue/zybantine
	group = "文化货物"
	crate_name = "兹班图货箱"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/zybantine/janissary_kit
	name = "兹班图耶尼切里装具"
	no_name_quantity = TRUE
	cost = 440
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/zyb,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/janissary,
		/obj/item/clothing/head/roguetown/helmet/janissaryhelm,
		/obj/item/clothing/neck/roguetown/chaincoif/chainmantle,
		/obj/item/clothing/mask/rogue/facemask/steel,
		/obj/item/clothing/gloves/roguetown/chain,
		/obj/item/clothing/wrists/roguetown/bracers,
		/obj/item/clothing/under/roguetown/chainlegs/kilt,
		/obj/item/clothing/shoes/roguetown/shalal/reinforced,
		/obj/item/storage/belt/rogue/leather/shalal,
		/obj/item/clothing/cloak/citywatch/janissary,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/zybantine/desert_rider_kit
	name = "沙漠骑手装束"
	no_name_quantity = TRUE
	cost = 300
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat,
		/obj/item/clothing/head/roguetown/roguehood/shalal/hijab,
		/obj/item/clothing/neck/roguetown/gorget/copper,
		/obj/item/clothing/mask/rogue/facemask/copper,
		/obj/item/clothing/wrists/roguetown/bracers/copper,
		/obj/item/clothing/gloves/roguetown/angle,
		/obj/item/clothing/under/roguetown/trou/leather/pontifex,
		/obj/item/clothing/shoes/roguetown/shalal,
		/obj/item/storage/belt/rogue/leather/shalal,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/zybantine/megarmach_coat
	name = "巨颚兽鳞甲大衣"
	cost = 140
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/zyb)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/zybantine/paddedgambeson
	name = "加厚沙漠长衣"
	cost = 80
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/zyb)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/zybantine/gambeson
	name = "沙漠长衣"
	cost = 45 // Base sellprice of 20
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/zyb)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/zybantine/zybtrou
	name = "宽松硬化皮沙漠裤"
	cost = 60 // Base sellprice of 20
	contains = list (/obj/item/clothing/under/roguetown/trou/leather/pontifex/zyb)

/datum/supply_pack/rogue/zybantine/tower_shield
	name = "沙拉尔塔盾"
	cost = 80
	contains = list(/obj/item/rogueweapon/shield/tower)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/zybantine/shamshir
	name = "沙姆希尔弯刀"
	cost = 95
	contains = list(/obj/item/rogueweapon/sword/sabre/shamshir)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/zybantine/shalal_saber
	name = "沙拉尔弯刀"
	cost = 130
	contains = list(/obj/item/rogueweapon/sword/long/marlin)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/zybantine/navaja
	name = "纳瓦哈折刀"
	cost = 35
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/navaja)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/zybantine/grand_mace
	name = "钢制巨型钉头锤"
	cost = 110
	contains = list(/obj/item/rogueweapon/mace/goden/steel)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/zybantine/spear
	name = "耶尼切里巴迪什斧"
	cost = 60
	contains = list(/obj/item/rogueweapon/halberd/bardiche)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/zybantine/whip
	name = "泽贝克鞭"
	cost = 70
	contains = list(/obj/item/rogueweapon/whip)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/zybantine/recurve_bow
	name = "反曲弓"
	cost = 40
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/zybantine/javelins
	name = "标枪箭袋"
	cost = 50
	contains = list(/obj/item/quiver/javelin/iron)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/zybantine/headscarf
	name = "加厚头巾"
	cost = 30
	contains = list(/obj/item/clothing/head/roguetown/roguehood/shalal/hijab)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/zybantine/shalal_hood
	name = "沙拉尔兜帽"
	cost = 25
	contains = list(/obj/item/clothing/head/roguetown/roguehood/shalal)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/zybantine/shalal_scarf
	name = "沙拉尔围巾"
	cost = 20
	contains = list(/obj/item/clothing/neck/roguetown/shalal)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/zybantine/copper_gorget
	name = "铜护颈"
	cost = 55
	contains = list(/obj/item/clothing/neck/roguetown/gorget/copper)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/zybantine/copper_facemask
	name = "铜面具"
	cost = 45
	contains = list(/obj/item/clothing/mask/rogue/facemask/copper)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/zybantine/copper_bracers
	name = "铜臂甲"
	cost = 50
	contains = list(/obj/item/clothing/wrists/roguetown/bracers/copper)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/zybantine/shalal_slippers
	name = "巴布什鞋"
	cost = 25
	contains = list(/obj/item/clothing/shoes/roguetown/shalal)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/zybantine/shalal_belt
	name = "沙拉尔腰带"
	cost = 30
	contains = list(/obj/item/storage/belt/rogue/leather/shalal)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/zybantine/gladius
	name = "短罗马剑"
	cost = 70
	contains = list(/obj/item/rogueweapon/sword/short/gladius)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/zybantine/makhaira
	name = "马凯拉短剑"
	cost = 75
	contains = list(/obj/item/rogueweapon/sword/short/messer)
	ship_qty_min = 2
	ship_qty_max = 3
