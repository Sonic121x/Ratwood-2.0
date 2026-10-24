/datum/action/cooldown/spell/augment_buff/blood_rush
	name = "热血奔涌"
	desc = "让活力涌入目标血管，短时间加快身体动作。"
	button_icon_state = "blood_rush"

	cooldown_time = 60 SECONDS

	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = SPELLCOST_BRUSH

	invocations = list("激荡！")
	invocation_type = INVOCATION_SHOUT
	charge_required = FALSE
	other_cast_cooldown_reduction = 0 // Too powerful otherwise

	point_cost = 2

/datum/action/cooldown/spell/augment_buff/blood_rush/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("那不是有效目标！"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget == H)
		H.visible_message("[H]低声念咒，血管中骤然涌起活力。")
		H.apply_status_effect(/datum/status_effect/buff/adrenaline_rush)
		return TRUE

	H.visible_message("[H]低声念咒，[spelltarget]的血管中骤然涌起活力。")
	spelltarget.apply_status_effect(/datum/status_effect/buff/adrenaline_rush)

	return TRUE
