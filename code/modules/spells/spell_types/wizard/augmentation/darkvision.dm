/datum/action/cooldown/spell/darkvision
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	name = "黑暗视觉"
	desc = "增强自身及周围所有人的夜视能力，持续 15 分钟。"
	fluff_desc = "最初的人类行走于世时，并无夜间视物之能，只能沦为黑暗中怪物与野兽的猎物。诺克以无穷智慧赐予人类夜视之礼。很快，法师们遵循祂的愿景，以魔法重现了这一恩赐。"
	button_icon_state = "darkvision"
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("黑夜之眼，向我敞开。")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	charge_time = 1 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 1.5 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1

	point_cost = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/darkvision/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	H.visible_message("[H]低声念咒，一圈微弱的光脉向外扩散。")
	for(var/mob/living/L in range(1, H))
		L.apply_status_effect(/datum/status_effect/buff/darkvision)

	return TRUE
