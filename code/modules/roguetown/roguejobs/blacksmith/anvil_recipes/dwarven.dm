// Dwarven armor recipes - only visible and usable by dwarves (req_trait = TRAIT_DWARF_REPAIR)

/datum/anvil_recipe/armor/dwarven
	abstract_type = /datum/anvil_recipe/armor/dwarven
	appro_skill = /datum/skill/craft/armorsmithing
	i_type = "护甲"
	req_bar = /obj/item/ingot/steel
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	req_trait = TRAIT_DWARF_REPAIR

/datum/anvil_recipe/armor/dwarven/plate
	name = "负怨者矮人板甲 (+3 钢, +1 青铜, +1 熟皮)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/dwarven
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/dwarven/apron
	name = "负怨者板条铁围 (+3 钢, +1 青铜)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/dwarven/smith
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/dwarven/helm
	name = "负怨者矮人头盔 (+2 钢, +1 青铜)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/dwarven
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/dwarven/helm/smith
	name = "负怨者匠师头盔 (+1 钢, +1 青铜)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/dwarven/smith
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/dwarven/gauntlets
	name = "负怨者矮人臂铠 (+1 钢, +1 青铜, +1 熟皮)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/gloves/roguetown/plate/dwarven
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/dwarven/boots
	name = "负怨者矮人战靴 (+1 钢, +1 青铜, +1 熟皮)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/roguetown/boots/armor/dwarven
	display_category = ITEM_CAT_ARMOR_BOOTS
// Dwarven weapon recipes - gated by TRAIT_DWARF_REPAIR like the armor

/datum/anvil_recipe/weapons/dwarven
	abstract_type = /datum/anvil_recipe/weapons/dwarven
	req_bar = /obj/item/ingot/steel
	craftdiff = SKILL_LEVEL_MASTER
	req_trait = TRAIT_DWARF_REPAIR

/datum/anvil_recipe/weapons/dwarven/maul
	name = "矮人大槌 (+4 钢, +1 青铜)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/mace/maul/steel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/dwarven/spikedmaul
	name = "带刺大槌 (+3 钢, +1 青铜)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/mace/maul/spiked
	display_category = ITEM_CAT_WEAPONS_MACES
