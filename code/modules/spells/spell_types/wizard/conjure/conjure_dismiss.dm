
/datum/action/cooldown/spell/conjure_dismiss
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	name = "遣散召唤物"
	desc = "短暂引导，将召唤仆从释放回地脉。它们会消失而不引发猛烈震荡，但伤得越重，反噬越大。引导时你会暴露破绽。"
	button_icon_state = "dismiss_conjure"
	sound = null
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CONJURATION

	charge_required = TRUE
	primary_resource_type = SPELL_COST_NONE
	charge_time = 3 SECONDS
	charge_swingdelay_type = SWINGDELAY_CANCEL // People CAN take advantage of you trying to combat unsummon if they are in a tight spot. This is on purpose
	cooldown_time = 30 SECONDS

	charge_slowdown = CHARGING_SLOWDOWN_HEAVY

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_NONE
	point_cost = 0

	spell_requirements = SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/conjure_dismiss/can_cast_spell(feedback = TRUE)
	if(isnull(owner))
		return FALSE
	for(var/datum/action/cooldown/spell/conjure_summon/summon_spell in owner.actions)
		for(var/mob/living/M in summon_spell.conjured_mobs)
			if(!QDELETED(M))
				return TRUE
	if(feedback)
		owner.balloon_alert(owner, "没有召唤仆从")
	return FALSE

/datum/action/cooldown/spell/conjure_dismiss/cast(atom/cast_on)
	. = ..()
	var/count = 0
	var/total_scale = 0
	var/severity = CONJURE_RECOIL_LIGHT
	var/energy_floor = 200
	var/stamina_only = FALSE
	for(var/datum/action/cooldown/spell/conjure_summon/summon_spell in owner.actions)
		for(var/mob/living/M in summon_spell.conjured_mobs.Copy())
			if(QDELETED(M))
				continue
			total_scale += M.conjure_damage_fraction()
			var/datum/component/conjured_minion/minion = M.GetComponent(/datum/component/conjured_minion)
			if(minion && minion.recoil_severity > severity)
				severity = minion.recoil_severity
				energy_floor = minion.recoil_energy_floor
			if(minion && minion.recoil_stamina_only)
				stamina_only = TRUE
			dismiss_conjured_minion(M)
			count++
	if(count)
		to_chat(owner, span_notice("我开始将召唤仆从释放回地脉。"))
		if(total_scale > 0 && isliving(owner))
			apply_conjure_recoil(owner, energy_floor, severity, clamp(total_scale, 0, 1), FALSE, stamina_only)
	else
		to_chat(owner, span_warning("我没有可以遣散的召唤仆从。"))
		reset_spell_cooldown()
	return TRUE
