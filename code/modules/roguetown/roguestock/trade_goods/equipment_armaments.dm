/datum/trade_good/equipment
	behavior = TRADE_BEHAVIOR_EQUIPMENT
	importable = FALSE
	crown_accepts = TRUE
	category = "Equipment"

/datum/trade_good/equipment/crafted
	derive_price = TRUE

// ============================================================================
// WEAPONS - STEEL (1-ingot tier)
// ============================================================================

/datum/trade_good/equipment/crafted/arming_sword
	id = TRADE_GOOD_STEEL_ARMING_SWORD
	name = "钢制骑士剑"
	item_type = /obj/item/rogueweapon/sword

/datum/trade_good/equipment/crafted/shortsword
	id = TRADE_GOOD_STEEL_SHORTSWORD
	name = "钢制短剑"
	item_type = /obj/item/rogueweapon/sword/short

/datum/trade_good/equipment/crafted/falchion
	id = TRADE_GOOD_STEEL_FALCHION
	name = "钢制弯刀"
	item_type = /obj/item/rogueweapon/sword/falchion

/datum/trade_good/equipment/crafted/messer
	id = TRADE_GOOD_STEEL_MESSER
	name = "钢制大砍刀"
	item_type = /obj/item/rogueweapon/sword/short/messer

/datum/trade_good/equipment/crafted/sabre
	id = TRADE_GOOD_STEEL_SABRE
	name = "钢制军刀"
	item_type = /obj/item/rogueweapon/sword/sabre

/datum/trade_good/equipment/crafted/mace
	id = TRADE_GOOD_STEEL_MACE
	name = "钢制钉锤"
	item_type = /obj/item/rogueweapon/mace/steel

/datum/trade_good/equipment/crafted/flanged_mace
	id = TRADE_GOOD_STEEL_FLANGED_MACE
	name = "棱纹钉锤"
	item_type = null // flanged mace does not exist in ES

/datum/trade_good/equipment/crafted/flail
	id = TRADE_GOOD_STEEL_FLAIL
	name = "钢制连枷"
	item_type = /obj/item/rogueweapon/flail/sflail

// ============================================================================
// WEAPONS - STEEL (2-ingot tier)
// ============================================================================

/datum/trade_good/equipment/crafted/longsword
	id = TRADE_GOOD_STEEL_LONGSWORD
	name = "钢制长剑"
	item_type = /obj/item/rogueweapon/sword/long

/datum/trade_good/equipment/crafted/broadsword
	id = TRADE_GOOD_STEEL_BROADSWORD
	name = "钢制阔剑"
	item_type = null // no steel broadsword subtype in ES

/datum/trade_good/equipment/crafted/warhammer
	id = TRADE_GOOD_STEEL_WARHAMMER
	name = "钢制战锤"
	item_type = /obj/item/rogueweapon/mace/warhammer/steel

/datum/trade_good/equipment/crafted/battleaxe
	id = TRADE_GOOD_STEEL_BATTLEAXE
	name = "战斧"
	item_type = /obj/item/rogueweapon/stoneaxe/battle

/datum/trade_good/equipment/crafted/hurlbat
	id = TRADE_GOOD_HURLBAT
	name = "投掷棍"
	item_type = null // hurlbat does not exist in ES

// ============================================================================
// WEAPONS - STEEL (3+ ingot tier)
// ============================================================================

/datum/trade_good/equipment/crafted/greatsword
	id = TRADE_GOOD_STEEL_GREATSWORD
	name = "巨剑"
	item_type = /obj/item/rogueweapon/greatsword

/datum/trade_good/equipment/crafted/halberd
	id = TRADE_GOOD_STEEL_HALBERD
	name = "戟"
	item_type = /obj/item/rogueweapon/halberd

/datum/trade_good/equipment/crafted/eaglebeak
	id = TRADE_GOOD_STEEL_EAGLEBEAK
	name = "鹰嘴锤"
	item_type = /obj/item/rogueweapon/eaglebeak

// ============================================================================
// RANGED
// ============================================================================

/datum/trade_good/equipment/crafted/recurve_bow
	id = TRADE_GOOD_RECURVE_BOW
	name = "反曲弓"
	item_type = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
