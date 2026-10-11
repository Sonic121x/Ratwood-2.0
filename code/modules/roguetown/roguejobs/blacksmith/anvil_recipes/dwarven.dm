// Dwarven armor recipes - only visible and usable by dwarves (req_trait = TRAIT_DWARF_REPAIR)

/datum/anvil_recipe/armor/dwarven
	abstract_type = /datum/anvil_recipe/armor/dwarven
	appro_skill = /datum/skill/craft/armorsmithing
	i_type = "护甲"
	req_bar = /obj/item/ingot/steel
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	req_trait = TRAIT_DWARF_REPAIR

/datum/anvil_recipe/armor/dwarven/plate
	name = "负怨者矮人板甲，另需3块钢锭、1块青铜锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/dwarven
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/dwarven/apron
	name = "负怨者板条铁围，另需3块钢锭、1块青铜锭"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/dwarven/smith
	display_category = ITEM_CAT_ARMOR_CHESTPIECES

/datum/anvil_recipe/armor/dwarven/helm
	name = "负怨者矮人头盔，另需2块钢锭、1块青铜锭"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/dwarven
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/dwarven/helm/smith
	name = "负怨者匠师头盔，另需1块钢锭、1块青铜锭"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/dwarven/smith
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/anvil_recipe/armor/dwarven/gauntlets
	name = "负怨者矮人臂铠，另需1块钢锭、1块青铜锭、1张鞣制皮革"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/bronze, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/gloves/roguetown/plate/dwarven
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/anvil_recipe/armor/dwarven/boots
	name = "负怨者矮人战靴，另需1块钢锭、1块青铜锭、1张鞣制皮革"
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
	name = "矮人大槌，另需4块钢锭、1块青铜锭"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/mace/maul/steel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/dwarven/spikedmaul
	name = "带刺大槌，另需3块钢锭、1块青铜锭"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/mace/maul/spiked
	display_category = ITEM_CAT_WEAPONS_MACES
