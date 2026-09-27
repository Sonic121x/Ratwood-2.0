// This is a workpiece on the artificer table, not a nearby crafting-menu recipe.
/datum/artificer_recipe/z121_void_cube
	name = "虚空魔方（传奇工程）"
	i_type = "虚空装置"
	required_item = /obj/item/roguegear/bronze
	created_item = /obj/item/void_cube
	appro_skill = /datum/skill/craft/engineering
	skill_level = SKILL_LEVEL_LEGENDARY
	hammers_per_item = 6
	additional_items = list(
		/obj/item/riddleofsteel,
		/obj/item/roguegear/bronze,
		/obj/item/roguegear/bronze,
		/obj/item/roguegear/bronze,
		/obj/item/magic/voidstone,
		/obj/item/roguegem/amethyst,
		/obj/item/grown/log/tree,
	)

/datum/artificer_recipe/z121_void_cube/New(obj/item/workpiece)
	..()
	parent = workpiece
	additional_items = additional_items.Copy()

/datum/artificer_recipe/z121_void_cube/advance(obj/item/tool, mob/living/user)
	if(!istype(user))
		return
	if(user.get_skill_level(appro_skill) < skill_level)
		to_chat(user, span_warning("制作虚空魔方需要传奇级工程技艺。"))
		return
	var/obj/item/workpiece = parent
	if(QDELETED(workpiece) || !istype(workpiece.loc, /obj/machinery/artificer_table))
		return
	var/obj/machinery/artificer_table/table = workpiece.loc
	if(table.material != workpiece || workpiece.artrecipe != src || !user.Adjacent(table) || user.incapacitated())
		return
	if(hammers_per_item > 0)
		hammers_per_item = max(0, hammers_per_item - 3)
		user.visible_message(span_warning("[user]敲打着这件虚空装置。"))
		return
	if(needed_item)
		return
	if(length(additional_items))
		hammered = TRUE
		needed_item = additional_items[1]
		// Remove only this entry; list subtraction would remove all three gears.
		additional_items.Cut(1, 2)
		to_chat(user, span_info("现在该加入[initial(needed_item.name)]了。"))
		return
	// Finish here instead of exposing progress == 100 to the table's generic
	// completion branch, which does not enforce the finisher's skill level.
	var/obj/item/void_cube/cube = new(get_turf(table))
	if(QDELETED(cube))
		return
	user.visible_message(span_info("[user]在工匠台上完成了[cube.name]。"))
	user.log_message("crafted [created_item] at [table] ([type])", LOG_GAME)
	user.mind?.add_sleep_experience(appro_skill, user.STAINT * skill_level * 5)
	qdel(workpiece) // Also deletes this recipe and clears the table's material.

// The normal table accepts ingots/planks, but not a gear as its starting item.
// Extend its fallback interaction without replacing other table recipes.
/obj/machinery/artificer_table/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_PARENT_ATTACKBY, PROC_REF(z121_load_void_cube_base))

/obj/machinery/artificer_table/proc/z121_load_void_cube_base(datum/source, obj/item/I, mob/living/user, params)
	SIGNAL_HANDLER
	if(material || !istype(I, /obj/item/roguegear/bronze))
		return
	if(!user || user.incapacitated() || !user.Adjacent(src) || !user.is_holding(I))
		return COMPONENT_NO_AFTERATTACK
	if(user.get_skill_level(/datum/skill/craft/engineering) < SKILL_LEVEL_LEGENDARY)
		to_chat(user, span_warning("以齿轮为基底制作虚空魔方，需要传奇级工程技艺。"))
		return COMPONENT_NO_AFTERATTACK
	if(I.artrecipe && !istype(I.artrecipe, /datum/artificer_recipe/z121_void_cube))
		return COMPONENT_NO_AFTERATTACK
	if(!user.transferItemToLoc(I, src) || QDELETED(I) || I.loc != src)
		return COMPONENT_NO_AFTERATTACK
	material = I
	update_icon()
	to_chat(user, span_info("你将齿轮放上工匠台作为基底。用锤子敲击工匠台，选择虚空魔方并按提示追加材料。"))
	return COMPONENT_NO_AFTERATTACK
