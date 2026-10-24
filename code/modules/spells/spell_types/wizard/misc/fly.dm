/datum/action/cooldown/spell/fly
	name = "飞行术"
	desc = "让自己或他人离地飞行，越过危险地形并自由往返楼层。\n任何受击、攻击或施法都会打断专注，使飞行者立即坠落。"
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "rune4"
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE
	charge_then_click = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("飞翔！","飘浮！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 10 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5 MINUTES

	associated_skill = /datum/skill/magic/arcane
	point_cost = 4
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_HIGH
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/fly/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!istype(cast_on, /mob/living/carbon/human))
		to_chat(H, span_warning("那不是有效目标！"))
		return FALSE

	var/mob/living/carbon/human/T = cast_on
	var/dur = (1 MINUTES) + min(max(H.STAINT - 10, 0) * 10 SECONDS, 2 MINUTES)

	if(T == H)
		H.visible_message(span_warning("<b>[H]高声念咒，缓缓升入空中！</b>"),
			span_notice("<b>我高诵升腾之言，感到重力松开了束缚。</b>"))
	else
		H.visible_message(span_warning("<b>[H]高声念咒，[T]缓缓升入空中！</b>"),
			span_notice("<b>我以咒文伸出无形之手，将[T]托入空中。</b>"))
		to_chat(T, span_warning("重力松开了束缚——[H]将我托入了空中！"))

	T.apply_status_effect(/datum/status_effect/buff/fly, dur)
	return TRUE

// --- Fly Up/Down spell buttons (granted/removed with the status effect) ---

/datum/action/cooldown/spell/fly_up
	name = "向上飞"
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "rune5"
	click_to_activate = FALSE
	charge_required = FALSE
	cooldown_time = 3 SECONDS
	spell_requirements = NONE

/datum/action/cooldown/spell/fly_up/cast(atom/cast_on)
	. = ..()
	var/mob/living/M = cast_on
	if(!isliving(M))
		return FALSE
	if(M.pulledby)
		to_chat(M, span_notice("被抓住时我无法向上飞！"))
		return FALSE
	M.visible_message(span_notice("[M]开始上升！"), span_notice("我向上飞去……"))
	if(do_after(M, 3 SECONDS))
		if(!M.has_status_effect(/datum/status_effect/buff/fly))
			return FALSE
		M.zMove(UP, TRUE)
	return TRUE

/datum/action/cooldown/spell/fly_down
	name = "向下飞"
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "rune3"
	click_to_activate = FALSE
	charge_required = FALSE
	cooldown_time = 3 SECONDS
	spell_requirements = NONE

/datum/action/cooldown/spell/fly_down/cast(atom/cast_on)
	. = ..()
	var/mob/living/M = cast_on
	if(!isliving(M))
		return FALSE
	if(M.pulledby)
		to_chat(M, span_notice("被抓住时我无法向下飞！"))
		return FALSE
	M.visible_message(span_notice("[M]开始下降！"), span_notice("我向下飞去……"))
	if(do_after(M, 1 SECONDS))
		if(!M.has_status_effect(/datum/status_effect/buff/fly))
			return FALSE
		M.zMove(DOWN, TRUE)
	return TRUE

// --- Screen alert ---

/atom/movable/screen/alert/status_effect/buff/fly
	name = "飞行中"
	desc = "我正悬浮。使用向上飞与向下飞按钮可跨越楼层。任何受击、攻击或施法都会打断专注，使我坠落。空中无法潜行。"
	icon_state = "buff"

// --- Status effect ---

/datum/status_effect/buff/fly
	id = "fly"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fly
	var/datum/action/cooldown/spell/fly_up/fly_up_action
	var/datum/action/cooldown/spell/fly_down/fly_down_action

/datum/status_effect/buff/fly/on_creation(mob/living/new_owner, new_duration)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/fly/on_apply()
	. = ..()
	owner.movement_type |= FLYING
	owner.float(TRUE)
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_hit))
	RegisterSignal(owner, COMSIG_MOB_ATTACK_HAND, PROC_REF(on_attack))
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	RegisterSignal(owner, COMSIG_MOB_CAST_SPELL, PROC_REF(on_cast))
	fly_up_action = new /datum/action/cooldown/spell/fly_up(owner)
	fly_up_action.Grant(owner)
	fly_down_action = new /datum/action/cooldown/spell/fly_down(owner)
	fly_down_action.Grant(owner)

/datum/status_effect/buff/fly/on_remove()
	. = ..()
	owner.movement_type &= ~FLYING
	owner.float(FALSE)
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
	UnregisterSignal(owner, COMSIG_MOB_ATTACK_HAND)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(owner, COMSIG_MOB_CAST_SPELL)
	if(fly_up_action)
		fly_up_action.Remove(owner)
		qdel(fly_up_action)
		fly_up_action = null
	if(fly_down_action)
		fly_down_action.Remove(owner)
		qdel(fly_down_action)
		fly_down_action = null
	var/turf/T = get_turf(owner)
	if(T?.zFall(owner))
		to_chat(owner, span_warning("专注被打断，我掉下去了！"))
	else
		to_chat(owner, span_warning("专注被打断！落地时我踉跄了一下。"))
		owner.Immobilize(0.5 SECONDS)

/datum/status_effect/buff/fly/proc/on_hit(mob/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(!damage)
		return
	owner.remove_status_effect(/datum/status_effect/buff/fly)

/datum/status_effect/buff/fly/proc/on_attack(mob/source, ...)
	SIGNAL_HANDLER
	owner.remove_status_effect(/datum/status_effect/buff/fly)

/datum/status_effect/buff/fly/proc/on_cast(mob/source, datum/action/cooldown/spell/spell, atom/cast_on)
	SIGNAL_HANDLER
	if(istype(spell, /datum/action/cooldown/spell/fly_up) || istype(spell, /datum/action/cooldown/spell/fly_down))
		return
	owner.remove_status_effect(/datum/status_effect/buff/fly)
