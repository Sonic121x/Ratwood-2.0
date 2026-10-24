#define SKILL_BIND_GLOW_FILTER "skill_bind_glow"

/datum/component/skill_bind
	var/swapped_skill
	var/original_skill
	var/stored = FALSE
	var/datum/weakref/binder_ref
	var/glow_applied = FALSE

/datum/component/skill_bind/Initialize(skill, mob/binder)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	if(!skill)
		return COMPONENT_INCOMPATIBLE
	swapped_skill = skill
	if(binder)
		binder_ref = WEAKREF(binder)
	var/obj/item/I = parent
	original_skill = I.associated_skill
	stored = TRUE
	I.associated_skill = swapped_skill
	apply_glow(I)
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))

/datum/component/skill_bind/proc/apply_glow(obj/item/I)
	if(glow_applied || already_glows(I))
		return
	I.add_filter(SKILL_BIND_GLOW_FILTER, 2, list("type" = "drop_shadow", "x" = 0, "y" = 0, "size" = 1, "offset" = 2, "color" = GLOW_COLOR_ARCANE))
	glow_applied = TRUE

/datum/component/skill_bind/proc/already_glows(obj/item/I)
	if(I.GetComponent(/datum/component/conjured_item))
		return TRUE
	for(var/filter_name in I.filter_data)
		var/list/params = I.filter_data[filter_name]
		if(params?["type"] == "outline" || params?["type"] == "drop_shadow")
			return TRUE
	return FALSE

/datum/component/skill_bind/proc/on_pickup(datum/source, mob/taker)
	SIGNAL_HANDLER
	var/mob/binder = binder_ref?.resolve()
	if(taker && taker == binder)
		return
	var/obj/item/I = parent
	if(istype(I))
		I.visible_message(span_warning("[I]易手时，其上的奥术联结闪烁着消散了。"))
		if(taker)
			to_chat(taker, span_notice("[I]在我手中颤动，奥术联结从它身上剥落。"))
	qdel(src)

/datum/component/skill_bind/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += "奥术联结引导着这把武器；它响应召唤者的训练。"

/datum/component/skill_bind/Destroy()
	var/obj/item/I = parent
	if(istype(I))
		if(stored && I.associated_skill == swapped_skill)
			I.associated_skill = original_skill
		if(glow_applied)
			I.remove_filter(SKILL_BIND_GLOW_FILTER)
			glow_applied = FALSE
	return ..()

#undef SKILL_BIND_GLOW_FILTER
