// Light Armor Pack. Only includes the "highest tier" plus a special package of budget armor.
// Pricing principles - Based on uhh sell price x 1.5 approx lol.

/datum/supply_pack/rogue/light_armor
	group = "护甲（轻型）" // English: Armor (Light)
	crate_name = "商会货箱"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/light_armor/padded_gambeson
	name = "加厚绗缝护甲衣"
	cost = 40 // Base sellprice of 25
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy)

/datum/supply_pack/rogue/light_armor/leather_gorget
	name = "硬化皮革护喉"
	cost = 20 // Base sellprice of 10
	contains = list(/obj/item/clothing/neck/roguetown/leather)

/datum/supply_pack/rogue/light_armor/leather_bracers
	name = "硬化皮臂甲"
	cost = 20 // Base sellprice of 10
	contains = list(/obj/item/clothing/wrists/roguetown/bracers/leather/heavy)

/datum/supply_pack/rogue/light_armor/basic_leather_bracers
	name = "皮臂甲"
	cost = 10
	contains = list(/obj/item/clothing/wrists/roguetown/bracers/leather)

/datum/supply_pack/rogue/light_armor/heavy_leather_pants
	name = "硬化皮裤"
	cost = 30 // Base sellprice of 20
	contains = list(/obj/item/clothing/under/roguetown/heavy_leather_pants)

/datum/supply_pack/rogue/light_armor/leather_trousers
	name = "皮裤"
	cost = 15
	contains = list(/obj/item/clothing/under/roguetown/trou/leather)

/datum/supply_pack/rogue/light_armor/hide_armor
	name = "兽皮甲"
	cost = 30 // Base sellprice of 20
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/hide)

/datum/supply_pack/rogue/light_armor/leather_cuirass
	name = "皮胸甲"
	cost = 15
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/cuirass)

/datum/supply_pack/rogue/light_armor/leather_armor
	name = "皮甲"
	cost = 15
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather)

/datum/supply_pack/rogue/light_armor/leather_helmet
	name = "皮革头盔"
	cost = 20
	contains = list(/obj/item/clothing/head/roguetown/helmet/leather)

/datum/supply_pack/rogue/light_armor/heavy_leather_armor
	name = "硬化皮甲"
	cost = 30 // Base sellprice of 20
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy)

/datum/supply_pack/rogue/light_armor/studded_leather_armor
	name = "铆钉皮甲"
	cost = 40 // I added 5 to the base sellprice of 25 because it cost 1 ingot
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/studded)

/datum/supply_pack/rogue/light_armor/heavy_leather_coat
	name = "硬化皮大衣"
	cost = 35 // Base sellprice of 25
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat)

/datum/supply_pack/rogue/light_armor/heavy_leather_jacket
	name = "硬化皮夹克"
	cost = 35 // Base sellprice of 25
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket)

/datum/supply_pack/rogue/light_armor/heavy_leather_gloves
	name = "重型皮手套"
	cost = 20 // No one buying this lmao it costs 1 fur
	contains = list(/obj/item/clothing/gloves/roguetown/angle)

/datum/supply_pack/rogue/light_armor/fingerless_leather_gloves
	name = "露指皮手套"
	cost = 20
	contains = list(/obj/item/clothing/gloves/roguetown/fingerless_leather)

/datum/supply_pack/rogue/light_armor/leather_gloves
	name = "皮手套"
	cost = 15
	contains = list(/obj/item/clothing/gloves/roguetown/leather)

/datum/supply_pack/rogue/light_armor/padded_arming_cap
	name = "衬垫帽"
	cost = 15
	contains = list(/obj/item/clothing/head/roguetown/paddedcap)

/datum/supply_pack/rogue/light_armor/heavy_padded_coif
	name = "厚实衬垫护头巾"
	cost = 35 // Equivalent to a padded gambeson on the head, so pricier
	contains = list(/obj/item/clothing/neck/roguetown/coif/heavypadding)

/datum/supply_pack/rogue/light_armor/reinforced_hood
	name = "加固兜帽"
	cost = 40 // The mage hood type, in a sense. This is the one that fits on the face or head but not the neck.
	contains = list(
					/obj/item/clothing/head/roguetown/roguehood/reinforced)

/datum/supply_pack/rogue/light_armor/padded_leather_hood
	name = "衬垫皮革兜帽" // The newer version of the hood that fits around the neck like a coif.
	cost = 40
	contains = list(
					/obj/item/clothing/head/roguetown/helmet/leather/armorhood)

/datum/supply_pack/rogue/light_armor/studded_leather_hood
	name = "铆钉皮革兜帽"
	cost = 50
	contains = list(/obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced,)
