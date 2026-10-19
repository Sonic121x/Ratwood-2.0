/obj/item/blade
	name = "刀刃"
	desc = "一块等待完成加工的铸造刀刃。"
	icon = 'icons/roguetown/items/anvil_casting.dmi'
	var/quality = SMELTERY_LEVEL_POOR
	var/datum/anvil_recipe/currecipe
	var/overlay_color

/obj/item/blade/Initialize(mapload)
	. = ..()
	if(overlay_color)
		color = overlay_color

/obj/item/blade/iron_axe
	name = "铁斧刃"
	icon_state = "blade_axe"
	overlay_color = "#808080"

/obj/item/blade/iron_mace
	name = "铁锤头"
	icon_state = "blade_mace"
	overlay_color = "#808080"

/obj/item/blade/iron_sword
	name = "铁剑刃"
	icon_state = "blade_sword"
	overlay_color = "#808080"

/obj/item/blade/iron_knife
	name = "铁刀刃"
	icon_state = "blade_knife"
	overlay_color = "#808080"

/obj/item/blade/iron_polearm
	name = "铁矛刃"
	icon_state = "blade_polearm"
	overlay_color = "#808080"

/obj/item/blade/iron_plate
	name = "铁甲片"
	icon_state = "blade_plate"
	overlay_color = "#808080"
	desc = "一块等待完成加工的铸造甲片。"

/obj/item/blade/steel_axe
	name = "钢斧刃"
	icon_state = "blade_axe"

/obj/item/blade/steel_mace
	name = "钢锤头"
	icon_state = "blade_mace"

/obj/item/blade/steel_sword
	name = "钢剑刃"
	icon_state = "blade_sword"

/obj/item/blade/steel_knife
	name = "钢刀刃"
	icon_state = "blade_knife"

/obj/item/blade/steel_polearm
	name = "钢矛刃"
	icon_state = "blade_polearm"

/obj/item/blade/steel_plate
	name = "钢甲片"
	icon_state = "blade_plate"
	desc = "一块等待完成加工的铸造甲片。"
