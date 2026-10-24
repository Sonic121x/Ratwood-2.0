/datum/action/cooldown/spell/leyline_anchor
	source_aspect = /datum/magic_aspect/pseudo/spellblade
	name = "地脉锚点"
	desc = "在脚下地脉上锚定一道奥术牵系。再次施放即可返回。\
		牵系具有 75 点生命，持续 20 秒。\
		最大召回距离为 7 格，仅限同层。\
		被抓住、束缚或固定时无法召回。\
		牵系被毁或到期时，法术进入完整冷却。"
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "leyline_anchor"
	sound = 'sound/misc/portalactivate.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_MOBILITY

	invocations = list("锚定地脉！")
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/structure/leyline_anchor_tether/active_portal
	var/max_range = 7
	var/teleport_delay = 5

/datum/action/cooldown/spell/leyline_anchor/before_cast(atom/cast_on)
	. = ..()
	. |= SPELL_NO_IMMEDIATE_COOLDOWN

/datum/action/cooldown/spell/leyline_anchor/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	// Recast while tether active - recall
	if(active_portal && !QDELETED(active_portal))
		var/turf/portal_turf = get_turf(active_portal)
		if(!portal_turf)
			to_chat(H, span_warning("地脉牵系已被切断！"))
			clear_portal()
			return FALSE
		if(H.pulledby || H.restrained() || H.buckled)
			to_chat(H, span_warning("受束缚时我无法返回！"))
			return FALSE
		var/turf/caster_turf = get_turf(H)
		if(caster_turf.z != portal_turf.z)
			to_chat(H, span_warning("地脉牵系不在同一层！"))
			return FALSE
		if(get_dist(caster_turf, portal_turf) > max_range)
			to_chat(H, span_warning("离地脉牵系太远了！"))
			return FALSE
		H.visible_message(span_warning("奥术能量在[H]周围噼啪作响！"))
		playsound(get_turf(H), 'sound/magic/shadowstep.ogg', 50, TRUE)
		addtimer(CALLBACK(src, PROC_REF(do_recall), H), teleport_delay)
		return TRUE

	// First cast - anchor tether
	var/turf/T = get_turf(H)
	active_portal = new /obj/structure/leyline_anchor_tether(T, src)
	to_chat(H, span_notice("我锚定了脚下的地脉。"))
	playsound(T, 'sound/misc/portalactivate.ogg', 50, TRUE)
	reset_spell_cooldown()
	return FALSE

/datum/action/cooldown/spell/leyline_anchor/proc/do_recall(mob/living/carbon/human/user)
	if(QDELETED(user) || user.stat == DEAD)
		return
	if(!active_portal || QDELETED(active_portal))
		return
	var/turf/dest = get_turf(active_portal)
	if(!dest)
		return

	var/turf/start = get_turf(user)
	var/obj/effect/after_image/img = new(start, 0, 0, 0, 0, 0.5 SECONDS, 2 SECONDS, 0)
	img.name = user.name
	img.appearance = user.appearance
	img.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	img.alpha = 80
	QDEL_IN(img, 2 SECONDS)

	do_teleport(user, dest, channel = TELEPORT_CHANNEL_MAGIC)
	playsound(dest, 'sound/magic/blink.ogg', 50, TRUE)
	user.visible_message(
		span_warning("[user]被沿地脉拉了回来！"),
		span_notice("地脉把我拉了回来。"))
	active_portal.parent_spell = null
	qdel(active_portal)
	active_portal = null
	StartCooldown()

/datum/action/cooldown/spell/leyline_anchor/proc/clear_portal()
	active_portal = null
	StartCooldown()
	build_all_button_icons()

// --- Tether object ---

/obj/structure/leyline_anchor_tether
	name = "地脉牵系"
	desc = "锚定于地脉的奥术牵系。摧毁它即可切断联结。"
	icon = 'icons/effects/effects.dmi'
	icon_state = "leylinerupture"
	max_integrity = 75
	anchored = TRUE
	density = FALSE
	opacity = 0
	light_outer_range = 1
	break_sound = 'sound/magic/magic_nulled.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg')
	var/datum/action/cooldown/spell/leyline_anchor/parent_spell

/obj/structure/leyline_anchor_tether/Initialize(mapload, datum/action/cooldown/spell/leyline_anchor/spell)
	. = ..()
	parent_spell = spell
	QDEL_IN(src, 20 SECONDS)

/obj/structure/leyline_anchor_tether/Destroy()
	if(parent_spell)
		parent_spell.clear_portal()
		parent_spell = null
	return ..()
