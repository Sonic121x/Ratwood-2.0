/datum/action/cooldown/spell/conjure_projection
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	button_icon_state = "spirit_projection"
	name = "灵体投射"
	desc = "将灵魂投入自己的召唤仆从，直接控制它，留下本体。牵系连接本体与容器；容器走得太远、改变楼层、本体受击或容器被杀时，灵魂都会立刻被拉回。使用返回身体可主动退出。"
	sound = 'sound/magic/soulsteal.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CONJURATION

	click_to_activate = TRUE
	cast_range = 12
	self_cast_possible = FALSE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE

	invocation_type = INVOCATION_SHOUT
	invocations = list("仆从，与汝缔结——容我灵魂入内！")

	charge_required = FALSE
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_NONE
	point_cost = 6

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_MIND

	var/projecting = FALSE
	var/datum/weakref/body_ref
	var/datum/weakref/vessel_ref
	var/datum/action/cooldown/spell/spirit_return/return_action
	var/datum/action/cooldown/spell/pilot_action
	var/body_base_pixel_x = 0
	var/body_base_pixel_y = 0
	var/leash_range = 7
	var/datum/beam/tether_beam

/datum/action/cooldown/spell/conjure_projection/Destroy()
	if(projecting)
		return_to_body("caster_gone")
	return ..()

/datum/action/cooldown/spell/conjure_projection/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	var/mob/living/caster = owner
	if(!isliving(caster))
		return FALSE
	if(!isliving(cast_on))
		caster.balloon_alert(caster, "不是仆从！")
		return FALSE
	var/mob/living/vessel = cast_on
	if(!HAS_TRAIT(vessel, TRAIT_CONJURED_SUMMON) || !(vessel in caster.summoned_minions))
		caster.balloon_alert(caster, "不是我的仆从！")
		return FALSE
	if(vessel.stat == DEAD)
		caster.balloon_alert(caster, "它已经死了！")
		return FALSE
	if(vessel.ckey)
		caster.balloon_alert(caster, "已被占据！")
		return FALSE
	return TRUE

/datum/action/cooldown/spell/conjure_projection/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	return . | SPELL_NO_IMMEDIATE_COOLDOWN

/datum/action/cooldown/spell/conjure_projection/cast(atom/cast_on)
	. = ..()
	var/mob/living/body = owner
	if(!istype(body) || projecting)
		return FALSE
	if(!body.key)
		return FALSE
	var/mob/living/vessel = cast_on
	if(!istype(vessel))
		return FALSE
	begin_projection(body, vessel)
	return TRUE

/datum/action/cooldown/spell/conjure_projection/proc/begin_projection(mob/living/body, mob/living/vessel)
	projecting = TRUE
	body_ref = WEAKREF(body)
	vessel_ref = WEAKREF(vessel)

	ADD_TRAIT(body, TRAIT_NOSLEEP, "spirit_projection")
	ADD_TRAIT(body, TRAIT_NOBREATH, "spirit_projection")
	ADD_TRAIT(body, TRAIT_NOHUNGER, "spirit_projection")
	ADD_TRAIT(body, TRAIT_NOMOOD, "spirit_projection")
	ADD_TRAIT(body, TRAIT_NOSSDINDICATOR, "spirit_projection")

	apply_projection_visuals(body)

	RegisterSignal(vessel, COMSIG_MOB_DEATH, PROC_REF(on_vessel_lost))
	RegisterSignal(vessel, COMSIG_QDELETING, PROC_REF(on_vessel_qdel))
	RegisterSignal(vessel, COMSIG_MOVABLE_MOVED, PROC_REF(on_tether_moved))
	RegisterSignal(body, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_body_harmed))
	RegisterSignal(body, COMSIG_LIVING_DEATH, PROC_REF(on_body_death))
	RegisterSignal(body, COMSIG_MOVABLE_MOVED, PROC_REF(on_tether_moved))

	tether_beam = body.Beam(vessel, icon_state = "b_beam", time = INFINITY, maxdistance = leash_range + 3, beam_type = /obj/effect/ebeam/spirit_tether)
	START_PROCESSING(SSprocessing, src)

	return_action = new /datum/action/cooldown/spell/spirit_return()
	return_action.origin = src
	return_action.Grant(vessel)

	var/pilot_ability_type = vessel.get_pilot_ability()
	if(pilot_ability_type)
		pilot_action = new pilot_ability_type()
		pilot_action.Grant(vessel)

	vessel.ai_controller?.set_ai_status(AI_STATUS_OFF)
	vessel.key = body.key

	body.visible_message(span_warning("[body]身体僵住，随后茫然站立，双眼空洞；微弱蓝光在颤抖的躯体周围摇曳。"))
	to_chat(vessel, span_notice("我的灵魂涌入[vessel.real_name]——借其双眼看世界，随其身体而动。"))
	playsound(body, 'sound/magic/soulsteal.ogg', 60, TRUE)

/datum/action/cooldown/spell/conjure_projection/proc/apply_projection_visuals(mob/living/body)
	body_base_pixel_x = body.pixel_x
	body_base_pixel_y = body.pixel_y
	body.add_filter("spirit_projection_aura", 2, list("type" = "outline", "size" = 1, "color" = "#4d90e0"))
	animate(body, pixel_x = body_base_pixel_x + 1, time = 2, loop = -1)
	animate(pixel_x = body_base_pixel_x - 1, time = 2)

/datum/action/cooldown/spell/conjure_projection/proc/clear_projection_visuals(mob/living/body)
	body.remove_filter("spirit_projection_aura")
	animate(body, pixel_x = body_base_pixel_x, pixel_y = body_base_pixel_y, time = 1)

/datum/action/cooldown/spell/conjure_projection/proc/on_vessel_lost(mob/living/source, gibbed)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(return_to_body), "vessel_slain")

/datum/action/cooldown/spell/conjure_projection/proc/on_vessel_qdel(datum/source)
	SIGNAL_HANDLER
	return_to_body("vessel_gone")

/datum/action/cooldown/spell/conjure_projection/proc/on_body_harmed(datum/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(damage <= 0)
		return
	INVOKE_ASYNC(src, PROC_REF(return_to_body), "body_struck")

/datum/action/cooldown/spell/conjure_projection/proc/on_body_death(mob/living/source, gibbed)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(return_to_body), "body_slain")

/datum/action/cooldown/spell/conjure_projection/proc/on_tether_moved(datum/source)
	SIGNAL_HANDLER
	evaluate_tether()

/datum/action/cooldown/spell/conjure_projection/process(seconds_per_tick)
	evaluate_tether()

/datum/action/cooldown/spell/conjure_projection/proc/evaluate_tether()
	if(!projecting)
		return
	var/mob/living/body = body_ref?.resolve()
	var/mob/living/vessel = vessel_ref?.resolve()
	if(!body || !vessel)
		return
	if(body.z != vessel.z || get_dist(body, vessel) > leash_range)
		INVOKE_ASYNC(src, PROC_REF(return_to_body), "out_of_range")

/datum/action/cooldown/spell/conjure_projection/proc/return_to_body(reason)
	if(!projecting)
		return
	projecting = FALSE

	var/mob/living/body = body_ref?.resolve()
	var/mob/living/vessel = vessel_ref?.resolve()
	body_ref = null
	vessel_ref = null

	STOP_PROCESSING(SSprocessing, src)
	if(tether_beam)
		if(!QDELETED(tether_beam))
			qdel(tether_beam)
		tether_beam = null

	if(return_action)
		if(!QDELETED(return_action))
			qdel(return_action)
		return_action = null
	if(pilot_action)
		if(!QDELETED(pilot_action))
			qdel(pilot_action)
		pilot_action = null

	if(vessel)
		UnregisterSignal(vessel, list(COMSIG_MOB_DEATH, COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	if(body)
		UnregisterSignal(body, list(COMSIG_MOB_APPLY_DAMGE, COMSIG_LIVING_DEATH, COMSIG_MOVABLE_MOVED))
		REMOVE_TRAIT(body, TRAIT_NOSLEEP, "spirit_projection")
		REMOVE_TRAIT(body, TRAIT_NOBREATH, "spirit_projection")
		REMOVE_TRAIT(body, TRAIT_NOHUNGER, "spirit_projection")
		REMOVE_TRAIT(body, TRAIT_NOMOOD, "spirit_projection")
		REMOVE_TRAIT(body, TRAIT_NOSSDINDICATOR, "spirit_projection")
		clear_projection_visuals(body)

	if(body && vessel && vessel.key)
		body.key = vessel.key
		vessel.ai_controller?.reset_ai_status()

	if(body)
		switch(reason)
			if("vessel_slain")
				to_chat(body, span_userdanger("容器被击杀——我的灵魂被猛烈抛回肉身！"))
			if("vessel_gone")
				to_chat(body, span_warning("容器崩解，我的灵魂急速归返。"))
			if("body_struck")
				to_chat(body, span_userdanger("本体传来剧痛——我的灵魂顷刻被拽回！"))
			if("body_slain")
				to_chat(body, span_userdanger("我的本体倒下——灵魂随着它的死亡被拉入其中！"))
			if("out_of_range")
				to_chat(body, span_userdanger("容器走得太远——牵系断裂，灵魂反弹回本体！"))
			else
				to_chat(body, span_notice("我收回灵魂，再次安居于自己的肉身。"))
		playsound(body, 'sound/magic/soulsteal.ogg', 50, TRUE)

	if(!QDELETED(src))
		StartCooldown(get_adjusted_cooldown())

/datum/action/cooldown/spell/spirit_return
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	button_icon_state = "spirit_projection"
	name = "返回躯体"
	desc = "收回投射的灵魂，在自己的肉身中醒来。"
	sound = null
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CONJURATION

	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	primary_resource_type = SPELL_COST_NONE
	cooldown_time = 0
	spell_tier = 3
	point_cost = 0
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = NONE
	check_flags = NONE

	var/datum/action/cooldown/spell/conjure_projection/origin

/datum/action/cooldown/spell/spirit_return/can_cast_spell(feedback = TRUE)
	return !isnull(owner) && !isnull(origin)

/datum/action/cooldown/spell/spirit_return/cast(atom/cast_on)
	. = ..()
	origin?.return_to_body("voluntary")
	return TRUE

/mob/living/proc/get_pilot_ability()
	return null

/obj/effect/ebeam/spirit_tether
	color = "#4d90e0"
	alpha = 180
	layer = ABOVE_MOB_LAYER
