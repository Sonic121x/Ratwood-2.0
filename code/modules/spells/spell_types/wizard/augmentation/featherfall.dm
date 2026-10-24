/datum/action/cooldown/spell/featherfall
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	name = "羽落术"
	desc = "赋予你自己和邻近生物一些抵御坠落伤害的能力。"
	fluff_desc = "羽落术以空气屏障包围目标，减缓下坠。法师不会飞，却常会摔下来。据说它由一位爬果树时总摔断腿的笨拙法师发明，不过这大概只是传说；无人知道这道常见法术的真正起源。"
	button_icon_state = "featherfall"
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("如羽般轻坠。")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	charge_time = 1 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 2 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1

	point_cost = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/featherfall/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	H.visible_message("[H]低声念咒，一圈微弱的光脉向外扩散。")
	for(var/mob/living/L in range(1, H))
		L.apply_status_effect(/datum/status_effect/buff/featherfall)

	return TRUE
