/datum/action/cooldown/spell/recall_weapon
	source_aspect = /datum/magic_aspect/pseudo/spellblade
	name = "武器召回"
	desc = "将绑定武器从任意位置召回手中。"
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "recall_weapon"
	sound = 'sound/magic/blink.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_MOBILITY

	invocations = list("兵刃，归来！")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 20 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/recall_weapon/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	var/obj/item/bound_weapon = M?.bound_weapon

	if(!bound_weapon || QDELETED(bound_weapon))
		to_chat(H, span_warning("我没有可以召回的绑定武器！"))
		return FALSE

	if(bound_weapon in H.held_items)
		to_chat(H, span_warning("绑定武器已经在我手里！"))
		return FALSE

	// If the weapon is embedded in someone, rip it out first
	if(bound_weapon.is_embedded && istype(bound_weapon.loc, /obj/item/bodypart))
		var/obj/item/bodypart/BP = bound_weapon.loc
		BP.remove_embedded_object(bound_weapon)
	else if(bound_weapon.is_embedded && isliving(bound_weapon.loc))
		var/mob/living/simple_holder = bound_weapon.loc
		simple_holder.simple_remove_embedded_object(bound_weapon)
	else if(ismob(bound_weapon.loc))
		var/mob/holder = bound_weapon.loc
		holder.dropItemToGround(bound_weapon, TRUE)

	var/turf/weapon_turf = get_turf(bound_weapon)
	if(!weapon_turf)
		to_chat(H, span_warning("找不到我的绑定武器！"))
		return FALSE

	playsound(weapon_turf, 'sound/magic/blink.ogg', 30, TRUE)
	weapon_turf.visible_message(span_notice("[bound_weapon]在奥术光芒中一闪而逝。"))

	if(!H.put_in_hands(bound_weapon))
		bound_weapon.forceMove(get_turf(H))
		to_chat(H, span_notice("我的绑定武器回到了脚边——双手都满了。"))
	else
		to_chat(H, span_notice("绑定武器飞回我手中。"))

	playsound(get_turf(H), 'sound/magic/blink.ogg', 40, TRUE)
	H.visible_message(span_notice("[bound_weapon]在[H]手中显现。"))
	return TRUE
