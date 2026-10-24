/datum/action/cooldown/spell/augment_buff/fortitude
	name = "坚韧术"
	desc = "强化体液，使身体更能抵御疲劳。（体力消耗 -15%）"
	button_icon_state = "fortitude"

	invocations = list("坚韧。")
	other_cast_cooldown_reduction = 0.33 // Casting on an ally cuts a third off the cooldown

	point_cost = 3

/datum/action/cooldown/spell/augment_buff/fortitude/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("那不是有效目标！"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget != H)
		H.visible_message("[H]低声念咒，[spelltarget]短暂泛起绿光。")
	else
		H.visible_message("[H]低声念咒，身上短暂泛起绿光。")
	spelltarget.apply_status_effect(/datum/status_effect/buff/fortitude, STAT_BUFF_SELF_DURATION)

	return TRUE
