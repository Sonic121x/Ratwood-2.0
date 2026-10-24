/datum/action/cooldown/spell/augment_buff/guidance
	name = "指引术"
	desc = "将奥术之力引入盟友体内，为其下一击赋能，使之突破招架与闪避。武器及徒手攻击均可受益。\
		启用同伴模式（Shift+G）可在未点中目标时自动选择范围内最近的结社同伴。\
		对自身施放会使冷却延长一半。"
	button_icon_state = "guidance"

	invocations = list("必中之手！")
	invocation_type = INVOCATION_SHOUT
	cooldown_time = 30 SECONDS

	point_cost = 2
	charge_required = FALSE // Special
	charge_time = 0 // Special

	self_cast_cooldown_multiplier = 1.5

	/// How long the empowered strike lingers - longer than Empower Weapon's, so a guided ally has time to close in.
	var/empowered_duration = 10 SECONDS

/datum/action/cooldown/spell/augment_buff/guidance/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("那不是有效目标！"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget.has_status_effect(/datum/status_effect/buff/empowered_strike))
		to_chat(H, span_warning("[spelltarget == H ? "我的" : "[spelltarget]的"]武器已经被赋能！"))
		H.balloon_alert(H, "已经赋能了！")
		return FALSE

	spelltarget.apply_status_effect(/datum/status_effect/buff/empowered_strike, empowered_duration)

	if(spelltarget == H)
		H.visible_message("[H]低声念咒，武器爆发出猛烈的红光！")
		to_chat(H, span_notice("我指引自己的打击——下一击将无可阻挡。（冷却 x[self_cast_cooldown_multiplier]）"))
	else
		H.visible_message("[H]低声念咒，[spelltarget]的武器爆发出猛烈的红光！")
		to_chat(H, span_notice("我指引[spelltarget]的打击——对方的下一击将无可阻挡。"))
		to_chat(spelltarget, span_notice("[H]的指引为我的武器赋能——下一击将无可阻挡！"))

	return TRUE
