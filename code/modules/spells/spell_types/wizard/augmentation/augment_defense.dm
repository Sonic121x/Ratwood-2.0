/datum/action/cooldown/spell/augment_buff/augment_defense
	name = "防御增幅"
	desc = "用奥术能量恢复目标防御，清除其受到的易伤与破绽状态。"
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	button_icon_state = "stoneskin"

	primary_resource_cost = 5

	invocations = list("复原！")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE

	cooldown_time = 30 SECONDS

/datum/action/cooldown/spell/augment_buff/augment_defense/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	if(!istype(caster))
		return FALSE
	if(!isliving(cast_on))
		to_chat(caster, span_warning("那不是有效目标！"))
		return FALSE
	var/mob/living/target = cast_on

	if(target.has_status_effect(/datum/status_effect/debuff/exposed))
		target.remove_status_effect(/datum/status_effect/debuff/exposed)
	if(target.has_status_effect(/datum/status_effect/debuff/cast_disrupted))
		target.remove_status_effect(/datum/status_effect/debuff/cast_disrupted)
	if(target.has_status_effect(/datum/status_effect/debuff/vulnerable))
		target.remove_status_effect(/datum/status_effect/debuff/vulnerable)
	if(target.has_status_effect(/datum/status_effect/debuff/feinted))
		target.remove_status_effect(/datum/status_effect/debuff/feinted)

	target.balloon_alert_to_viewers("<font color='[spell_color]'>防守恢复！</font>")
	target.visible_message(span_warning("[target]的防御得到了强化！"), span_notice("我的防御立刻恢复了。"))
	if(target != caster)
		to_chat(caster, span_notice("我加固[target]的防御，消除了破绽。"))
	return TRUE
