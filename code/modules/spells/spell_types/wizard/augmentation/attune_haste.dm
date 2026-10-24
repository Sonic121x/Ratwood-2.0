/datum/action/cooldown/spell/augment_buff/attune_haste
	name = "协调：迅捷"
	desc = "以魔法加快目标动作。（速度 +3，动作冷却 x0.85）\n协调——巨人、鹰眼与迅捷共用冷却，同时只能持有其中一种。"
	button_icon_state = "haste"

	invocations = list("迅捷加诸其身！")
	invocation_type = INVOCATION_SHOUT
	shared_cooldown = "augment_attunement"
	other_cast_cooldown_reduction = 0.33 // Casting on an ally cuts a third off the cooldown

	point_cost = 2

/datum/action/cooldown/spell/augment_buff/attune_haste/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("那不是有效目标！"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget != H)
		H.visible_message("[H]低声念咒，[spelltarget]短暂泛起黄光。")
	else
		H.visible_message("[H]低声念咒，身上短暂泛起黄光。")
	spelltarget.apply_status_effect(/datum/status_effect/buff/attune_haste, ATTUNE_BUFF_DURATION)

	return TRUE
