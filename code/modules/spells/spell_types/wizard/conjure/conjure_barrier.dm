#define ARCBARRIER_FILTER "arcyne_barrier"

/datum/action/cooldown/spell/conjure_arcyne_ward/barrier
	name = "召障术"
	desc = "召出奥术屏障，长时间免疫奥术性质的攻击。"
	button_icon_state = "barrier"
	spell_color = GLOW_COLOR_METAL
	invocations = list("命运，退避！")
	dismiss_invocation = "命运，消散！"
	regen_invocation = "命运，复原！"
	point_cost = 0
	exclusive_group = "arcyne_ward"
	ward_type = /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/barrier

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/barrier
	name = "奥术屏障"
	desc = "纳莱迪旅修者掌握的技艺。以自身火花驱动、抵御命运之风的屏障。魔法无法影响使用者。"
	ward_color = "#12f0f0"

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/barrier/setup_ward(mob/living/carbon/human/H)
	..()
	H.apply_status_effect(/datum/status_effect/buff/arcyne_barrier)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/barrier/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_status_effect(/datum/status_effect/buff/arcyne_barrier)
	..()

/datum/status_effect/buff/arcyne_barrier
	id = "arcyne_barrier"
	alert_type = /atom/movable/screen/alert/status_effect/buff/arcyne_barrier
	duration = -1
	var/outline_colour = "#12f0f0"

/atom/movable/screen/alert/status_effect/buff/arcyne_barrier
	name = "奥术屏障"
	desc = "奥术火花环绕着我，替我挡下命运之风的侵袭！"

/datum/status_effect/buff/arcyne_barrier/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_SPELL_DISPERSION, MAGIC_TRAIT)
	if(!owner.get_filter(ARCBARRIER_FILTER))
		owner.add_filter(ARCBARRIER_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))

/datum/status_effect/buff/arcyne_barrier/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_SPELL_DISPERSION, MAGIC_TRAIT)
	owner.remove_filter(ARCBARRIER_FILTER)

#undef ARCBARRIER_FILTER
