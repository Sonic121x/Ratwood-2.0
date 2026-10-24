// Arcyne Forge — merged Conjure Weapon + Conjure Tool.
// Conjured items have halved durability and a glow to indicate they are conjured.

/datum/action/cooldown/spell/arcyne_forge
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	name = "奥术锻炉"
	desc = "召出自选的武器或工具。召唤物品的耐久减半。\n\
	同时只能存在一件召唤物品——召出新物品会摧毁旧物品。"
	button_icon_state = "arcyne_forge"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_FERRAMANCY

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE

	invocations = list("兵刃，显现！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 2 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 1 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2

	point_cost = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/conjured_item

	var/list/conjure_options = list(
		"匕首" = /obj/item/rogueweapon/huntingknife/idagger,
		"斧" = /obj/item/rogueweapon/stoneaxe/woodcut,
		"镐" = /obj/item/rogueweapon/pick,
		"锄头" = /obj/item/rogueweapon/hoe,
		"连枷" = /obj/item/rogueweapon/thresher,
		"镰刀" = /obj/item/rogueweapon/sickle,
		"草叉" = /obj/item/rogueweapon/pitchfork,
		"钳子" = /obj/item/rogueweapon/tongs,
		"锤子" = /obj/item/rogueweapon/hammer/iron,
		"铁锹" = /obj/item/rogueweapon/shovel,
		"手锯" = /obj/item/rogueweapon/handsaw,
		"扫帚" = /obj/item/broom,
		"剪刀" = /obj/item/rogueweapon/huntingknife/scissors,
		"钓竿" = /obj/item/fishingrod,
		"煎锅" = /obj/item/cooking/pan,
		"汤锅" = /obj/item/reagent_containers/glass/bucket/pot,
		"碗" = /obj/item/reagent_containers/glass/bowl,
		"餐叉" = /obj/item/kitchen/fork/iron,
		"汤匙" = /obj/item/kitchen/spoon/iron,
	)

/datum/action/cooldown/spell/arcyne_forge/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/choice = tgui_input_list(H, "选择要召唤的物品", "奥术锻炉", conjure_options)
	if(!choice)
		return FALSE

	// Destroy previous conjured item
	if(conjured_item && !QDELETED(conjured_item))
		conjured_item.visible_message(span_warning("[conjured_item]闪烁着消散了！"))
		qdel(conjured_item)

	var/item_path = conjure_options[choice]
	var/obj/item/R = new item_path(H.drop_location())

	// Halve durability
	R.max_integrity = round(R.max_integrity * 0.5)
	R.obj_integrity = R.max_integrity

	// Mark as conjured — no salvage, no smelting
	R.smeltresult = null
	R.salvage_result = null
	R.fiber_salvage = FALSE

	// Conjured glow
	R.AddComponent(/datum/component/conjured_item, GLOW_COLOR_ARCANE, FALSE, H, src)

	H.put_in_hands(R)
	conjured_item = R
	return TRUE

/datum/action/cooldown/spell/arcyne_forge/Destroy()
	if(conjured_item && !QDELETED(conjured_item))
		conjured_item.visible_message(span_warning("[conjured_item]闪烁着消散了！"))
		qdel(conjured_item)
	conjured_item = null
	return ..()

/datum/action/cooldown/spell/arcyne_forge/miracle
	name = "神圣锻炉"
	background_icon = 'icons/mob/actions/malummiracles.dmi'
	button_icon = 'icons/mob/actions/malummiracles.dmi'
	button_icon_state = "forge"
	invocations = list("玛勒姆，赐我祢的工具！")//Old incantation
	point_cost = 0
	spell_tier = 0
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
