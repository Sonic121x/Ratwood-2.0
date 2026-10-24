/datum/action/cooldown/spell/augment_buff/precognition
	name = "预知术"
	desc = "为自己或盟友窥见片刻后的未来，提前做好准备。使目标防御与特殊招式的剩余冷却缩短 15 秒。"
	button_icon_state = "readomen"

	primary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("先知先觉！")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 75 SECONDS
	other_cast_cooldown_reduction = 0 // Does not benefit from ally-cast cooldown reduction

	point_cost = 2

/datum/action/cooldown/spell/augment_buff/precognition/cast(atom/cast_on)
	. = ..()
	if(!isliving(cast_on))
		to_chat(owner, span_warning("那不是有效目标！"))
		return FALSE
	var/mob/living/target = cast_on

	var/hastened = FALSE
	hastened |= reduce_intent_cooldown(target, /datum/status_effect/debuff/clashcd)
	hastened |= reduce_intent_cooldown(target, /datum/status_effect/debuff/specialcd)

	var/obj/effect/temp_visual/origin_haste/V = new
	target.vis_contents += V

	if(hastened)
		target.balloon_alert_to_viewers("<font color='#66ffcc'>冷却 -15 秒！</font>")
		to_chat(target, span_notice("我瞥见将至的片刻，为下一招做好准备。"))
	else
		to_chat(target, span_notice("我瞥见将至的片刻，但已没有需要加速恢复的动作。"))
	return TRUE

/proc/reduce_intent_cooldown(mob/living/target, effect_type, amount = 15 SECONDS)
	var/datum/status_effect/S = target.has_status_effect(effect_type)
	if(!S)
		return FALSE
	S.duration -= amount
	if(S.duration <= world.time)
		target.remove_status_effect(effect_type)
	return TRUE
