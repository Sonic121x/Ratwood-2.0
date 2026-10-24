/datum/action/cooldown/spell/augment_buff/surge
	name = "振奋术"
	desc = "让活力充盈他人的身体，立即解除眩晕，使其重新站起。无法对自己施放。"
	button_icon_state = "enlarge"

	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_PHASED

	self_cast_possible = FALSE

	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = SPELLCOST_SURGE

	invocations = list("再度奋起！")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	other_cast_cooldown_reduction = 0 // Does not benefit from ally-cast cooldown reduction

	point_cost = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

/datum/action/cooldown/spell/augment_buff/surge/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	if(!istype(caster))
		return FALSE
	if(!isliving(cast_on))
		to_chat(caster, span_warning("那不是有效目标！"))
		return FALSE
	var/mob/living/target = cast_on

	target.SetUnconscious(0)
	target.SetSleeping(0)
	target.SetParalyzed(0)
	target.SetImmobilized(0)
	target.SetStun(0)
	target.SetKnockdown(0)
	if(target.has_status_effect(/datum/status_effect/incapacitating/off_balanced))
		target.remove_status_effect(/datum/status_effect/incapacitating/off_balanced)
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.stam_paralyzed = FALSE
	target.set_resting(FALSE)
	target.rest_locked_until = world.time + 1 SECONDS
	target.stamina_add(-10) // restore a burst of stamina (green bar) rather than a full reset

	target.balloon_alert_to_viewers("<font color='[spell_color]'>振奋！</font>")
	target.visible_message(span_warning("[target]在能量环绕中猛然起身！"), span_notice("奥术能量涌入全身——我站起来了！"))
	if(target != caster)
		to_chat(caster, span_notice("我让奥术活力充满[target]，将其扶回战场！"))
	new /obj/effect/temp_visual/spell_impact(get_turf(target), spell_color, spell_impact_intensity)
	return TRUE
