/datum/action/cooldown/spell/form_blade/form_hammer
	name = "塑锤术"
	desc = "将原始魔力塑成巨大的奥术重锤——格罗泽重锤。同时只能存在一种召唤形态。"
	button_icon = 'icons/mob/actions/mage_ferramancy.dmi'
	button_icon_state = "form_blade"
	shared_cooldown = "form_hammer"
	invocations = list("格罗泽重锤，成形！！")
	forms = list(
		list("label" = "巨型重锤", "weapon" = /obj/item/rogueweapon/mace/maul/grand/ferramancy, "say" = null),
	)

/obj/item/rogueweapon/mace/maul/grand/ferramancy
	name = "格罗泽重锤"
	desc = "炼铁法师以意志将原始魔力凝成的奥术巨型重锤。"
	color = "#3b5bdb"
	minstr = 0
	unenchantable = TRUE
	anvilrepair = null
	smeltresult = null
	associated_skill = /datum/skill/combat/arcyne
