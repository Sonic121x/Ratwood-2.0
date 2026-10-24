/datum/action/cooldown/spell/augment_buff/attune_giant
	name = "协调：巨人"
	desc = "强化目标。（力量 +4）\n协调——巨人、鹰眼与迅捷共用冷却，同时只能持有其中一种。"
	button_icon_state = "giants_strength"

	invocations = list("巨人之力，加诸其身。")
	shared_cooldown = "augment_attunement"
	other_cast_cooldown_reduction = 0.33 // Casting on an ally cuts a third off the cooldown

	point_cost = 2

/datum/action/cooldown/spell/augment_buff/attune_giant/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("那不是有效目标！"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget != H)
		H.visible_message("[H]低声念咒，[spelltarget]的肌肉随之增强、膨大。")
	else
		H.visible_message("[H]低声念咒，肌肉随之增强、膨大。")
	spelltarget.apply_status_effect(/datum/status_effect/buff/attune_giant, ATTUNE_BUFF_DURATION)

	return TRUE
