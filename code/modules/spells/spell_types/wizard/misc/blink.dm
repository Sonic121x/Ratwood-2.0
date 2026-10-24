/datum/action/cooldown/spell/blink
	name = "闪现"
	desc = "瞬移至你视野内的目标地点。最远 5 格。只能在与施术者相同的平面上生效。"
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "rune6"
	sound = 'sound/magic/blink.ogg'
	spell_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = FALSE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_TELEPORT

	invocations = list("奥术跃迁！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_POKE
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 24 SECONDS

	associated_skill = /datum/skill/magic/arcane
	point_cost = 3
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/max_range = 5
	var/phase = /obj/effect/temp_visual/blink
	var/phase_sound = 'sound/magic/blink.ogg'
	var/phase_beam = "purple_lightning"

/obj/effect/temp_visual/blink
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_blast"
	name = "传送魔法"
	desc = "快闪开！"
	randomdir = FALSE
	duration = 4 SECONDS
	layer = MASSIVE_OBJ_LAYER
	light_outer_range = 2
	light_color = COLOR_PALE_PURPLE_GRAY

/obj/effect/temp_visual/blink/Initialize(mapload, new_caster)
	. = ..()

/datum/action/cooldown/spell/blink/cast(atom/cast_on)
	. = ..()
	var/turf/T = get_turf(cast_on)
	var/turf/start = get_turf(owner)

	var/dest_err = arcyne_validate_blink_dest(T, owner)
	if(dest_err)
		to_chat(owner, span_warning(dest_err))
		return FALSE

	var/distance = get_dist(start, T)
	if(distance > max_range)
		to_chat(owner, span_warning("那个地点太远了！我最多只能闪现 [max_range] 格。"))
		return FALSE

	var/path_err = arcyne_validate_blink_path(start, T)
	if(path_err)
		to_chat(owner, span_warning(path_err))
		return FALSE

	owner.visible_message(span_warning("<b>[owner]的身体开始闪烁奥术光芒，[owner.p_they()]正准备[owner.p_s()]闪现！</b>"),
					span_notice("<b>我凝聚奥术能量，准备穿越空间闪现！</b>"))

	var/obj/spot_one = new phase(start, owner.dir)
	var/obj/spot_two = new phase(T, owner.dir)

	if(phase_beam)
		spot_one.Beam(spot_two, phase_beam, time = 1.5 SECONDS)
	playsound(start, phase_sound, 65, TRUE)
	playsound(T, phase_sound, 25, TRUE)

	var/mob/living/L = owner
	if(istype(L) && L.buckled)
		L.buckled.unbuckle_mob(L, TRUE)

	// Afterimage at departure point
	var/obj/effect/after_image/img = new(start, 0, 0, 0, 0, 0.5 SECONDS, 2 SECONDS, 0)
	img.name = owner.name
	img.appearance = owner.appearance
	img.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	img.alpha = 120
	animate(img, alpha = 0, time = 1.5 SECONDS, easing = LINEAR_EASING)
	QDEL_IN(img, 1.5 SECONDS)

	do_teleport(owner, T, channel = TELEPORT_CHANNEL_MAGIC)

	owner.visible_message(span_danger("<b>[owner]在神秘紫光中消失！</b>"), span_notice("<b>我于刹那间穿梭空间完成闪现！</b>"))
	return TRUE
