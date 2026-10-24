#define GATE_PHALANX_FILTER "gate_phalanx_glow"

/datum/action/cooldown/spell/gate_of_reckoning
	source_aspect = /datum/magic_aspect/pseudo/spellblade
	name = "清算之门"
	desc = "Porta Iudicii——审判之门。召出两柄幻影长矛，列阵于你两侧。\
		接下来 12 秒内，你每次近战命中，都会令幻影长矛\
		朝面向方向刺出一道三格宽的直线，攻击沿途所有敌人。\
		需要 7 点动量。3 次充能，每次 40 点伤害。\
		10 点动量时过载：6 次充能，每次 40 点伤害。\
		幻影打击可被盾牌格挡，但无法招架。"
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "gate_of_reckoning"
	sound = 'sound/magic/antimagic.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_HIGH

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_ULT

	invocations = list("审判之门，洞开！")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	weapon_cast_penalized = FALSE
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_HIGH
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/phantom_damage = 40
	var/base_charges = 3
	var/empowered_charges = 6
	var/min_momentum = 7
	var/max_momentum = 10

/datum/action/cooldown/spell/gate_of_reckoning/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/gate_of_reckoning/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		to_chat(H, span_warning("我必须握住绑定武器！"))
		return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		to_chat(H, span_warning("动量不足！至少需要 [min_momentum] 层！"))
		return FALSE

	var/stacks = M.stacks
	var/empowered = stacks >= max_momentum
	var/charges = empowered ? empowered_charges : base_charges
	M.consume_all_stacks()
	to_chat(H, span_notice("释放全部 [stacks] 点动量——召出 [charges] 柄幻影长矛！"))

	var/datum/status_effect/buff/gate_phalanx/effect = H.apply_status_effect(/datum/status_effect/buff/gate_phalanx)
	if(effect)
		effect.spell_ref = WEAKREF(src)
		effect.charges = charges
		effect.max_charges = charges
		effect.phantom_damage = phantom_damage
		effect.bound_weapon = held_weapon
		effect.update_alert()
		effect.create_spear_overlays()

	H.visible_message(
		span_boldwarning("[H]撕开地脉裂隙——三柄幻影长矛在[H.p_them()]周围显现！"),
		span_notice("三柄幻影长矛响应了我的召唤！"))
	playsound(get_turf(H), 'sound/misc/portalactivate.ogg', 70, TRUE)
	playsound(get_turf(H), 'sound/magic/antimagic.ogg', 60, TRUE)

	log_combat(H, H, "激活了 [name]（[charges] 层充能）")
	return TRUE

/datum/action/cooldown/spell/gate_of_reckoning/proc/do_phantom_thrust(mob/living/carbon/human/user, obj/item/weapon, charges_remaining)
	if(QDELETED(user) || user.stat == DEAD)
		return

	var/turf/origin = get_turf(user)
	if(!origin)
		return

	var/facing = user.dir
	var/list/thrust_turfs = get_phalanx_line(origin, facing)

	// Visual: spear thrust on each tile
	for(var/turf/T in thrust_turfs)
		var/obj/effect/temp_visual/gate_phalanx_thrust/V = new(T)
		V.dir = facing

	playsound(origin, pick('sound/combat/hits/bladed/genthrust (1).ogg', 'sound/combat/hits/bladed/genthrust (2).ogg'), 80, TRUE)

	// Strike all enemies in the 3x1 line
	var/deflected = FALSE
	for(var/turf/T in thrust_turfs)
		for(var/mob/living/victim in T)
			if(victim == user || victim.stat == DEAD)
				continue
			if(spell_guard_check(victim, FALSE, user, punish_caster = deflected ? FALSE : null))
				deflected = TRUE
				continue
			arcyne_strike(user, victim, weapon, phantom_damage, BODY_ZONE_CHEST, BCLASS_STAB, \
				spell_name = "清算之门", \
				skip_animation = TRUE, \
				allow_shield_check = TRUE)

/datum/action/cooldown/spell/gate_of_reckoning/proc/get_phalanx_line(turf/origin, facing)
	// 3-wide perpendicular line one tile ahead of the user
	var/turf/center = get_step(origin, facing)
	if(!center)
		return list()
	var/list/turfs = list(center)
	var/perp_dir1
	var/perp_dir2
	switch(facing)
		if(NORTH, SOUTH)
			perp_dir1 = WEST
			perp_dir2 = EAST
		if(EAST, WEST)
			perp_dir1 = NORTH
			perp_dir2 = SOUTH
		else
			// Diagonal facing: just use center tile
			return turfs
	var/turf/left = get_step(center, perp_dir1)
	var/turf/right = get_step(center, perp_dir2)
	if(left)
		turfs += left
	if(right)
		turfs += right
	return turfs

// --- Status effect: tracks charges, manages overlays, listens for hits ---

/atom/movable/screen/alert/status_effect/buff/gate_phalanx
	name = "清算之门（0）"
	desc = "幻影长矛随我的近战攻击一同刺出。"
	icon_state = "buff"

/datum/status_effect/buff/gate_phalanx
	id = "gate_phalanx"
	alert_type = /atom/movable/screen/alert/status_effect/buff/gate_phalanx
	duration = 12 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	var/datum/weakref/spell_ref
	var/charges = 3
	var/max_charges = 3
	var/phantom_damage = 40
	var/obj/item/bound_weapon
	var/list/spear_visuals = list()

/datum/status_effect/buff/gate_phalanx/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, PROC_REF(on_melee_hit))
	RegisterSignal(owner, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_dir_change))
	owner.add_filter(GATE_PHALANX_FILTER, 2, list("type" = "outline", "color" = "#4488ff", "alpha" = 200, "size" = 2))

/datum/status_effect/buff/gate_phalanx/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, COMSIG_ATOM_DIR_CHANGE))
	owner.remove_filter(GATE_PHALANX_FILTER)
	remove_spear_visuals()
	if(charges > 0)
		to_chat(owner, span_warning("幻影长矛消散了——尚余 [charges] 次突刺未使用。"))
		owner.visible_message(span_notice("[owner]的幻影长矛渐渐消散。"))
	else
		to_chat(owner, span_notice("所有幻影长矛已耗尽！"))
		owner.visible_message(span_notice("[owner]最后一柄幻影长矛碎裂了。"))
	. = ..()

/datum/status_effect/buff/gate_phalanx/proc/update_alert()
	if(!linked_alert)
		return
	linked_alert.name = "清算之门（[charges]/[max_charges]）"

/datum/status_effect/buff/gate_phalanx/proc/create_spear_overlays()
	remove_spear_visuals()
	// Two spears flanking the user, one tile left and one tile right
	for(var/i in 1 to 2)
		var/obj/effect/gate_phalanx_spear/spear = new(null)
		spear_visuals += spear
		owner.vis_contents += spear
	update_spear_positions(owner.dir)

/datum/status_effect/buff/gate_phalanx/proc/remove_spear_visuals()
	for(var/obj/effect/gate_phalanx_spear/spear in spear_visuals)
		owner.vis_contents -= spear
		qdel(spear)
	spear_visuals.Cut()

/datum/status_effect/buff/gate_phalanx/proc/on_dir_change(atom/source, old_dir, new_dir)
	SIGNAL_HANDLER
	update_spear_positions(new_dir)

/datum/status_effect/buff/gate_phalanx/proc/update_spear_positions(facing)
	// Spear sprite points top-right by default
	// Rotation to point in each cardinal direction
	var/rotation
	switch(facing)
		if(NORTH)
			rotation = -45
		if(SOUTH)
			rotation = 135
		if(EAST)
			rotation = 45
		if(WEST)
			rotation = 225
		else
			rotation = -45

	// One tile left, one tile right (perpendicular to facing)
	var/list/perp_offsets
	switch(facing)
		if(NORTH, SOUTH)
			perp_offsets = list(list(-32, 0), list(32, 0))
		if(EAST, WEST)
			perp_offsets = list(list(0, 32), list(0, -32))
		else
			perp_offsets = list(list(-32, 0), list(32, 0))

	for(var/i in 1 to min(length(spear_visuals), length(perp_offsets)))
		var/obj/effect/gate_phalanx_spear/spear = spear_visuals[i]
		var/list/offset = perp_offsets[i]
		var/matrix/M = matrix()
		M.Scale(0.5, 0.5)
		M.Turn(rotation)
		// -16 centers the 64x64 sprite on a 32x32 tile; pixel_x/pixel_y don't work correctly in vis_contents
		M.Translate(offset[1] - 16, offset[2] - 16)
		spear.transform = M
		spear.pixel_x = 0
		spear.pixel_y = 0

/datum/status_effect/buff/gate_phalanx/proc/on_melee_hit(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(!isliving(target) || target == owner || target.stat == DEAD)
		return
	if(!bound_weapon || weapon != bound_weapon)
		return
	if(charges <= 0)
		return

	charges--
	update_alert()
	owner.balloon_alert(owner, "幻影突刺！（剩余 [charges] 次）")

	var/datum/action/cooldown/spell/gate_of_reckoning/spell = spell_ref?.resolve()
	if(!spell)
		owner.remove_status_effect(/datum/status_effect/buff/gate_phalanx)
		return

	INVOKE_ASYNC(spell, TYPE_PROC_REF(/datum/action/cooldown/spell/gate_of_reckoning, do_phantom_thrust), owner, bound_weapon, charges)

	if(charges <= 0)
		owner.remove_status_effect(/datum/status_effect/buff/gate_phalanx)

// --- Thrust visual ---

/obj/effect/temp_visual/gate_phalanx_thrust
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	icon_state = "bronzewingedspear"
	duration = 4
	layer = ABOVE_ALL_MOB_LAYER
	randomdir = FALSE

/obj/effect/temp_visual/gate_phalanx_thrust/Initialize(mapload)
	. = ..()
	var/matrix/M = matrix()
	M.Scale(0.7, 0.7)
	switch(dir)
		if(NORTH)
			M.Turn(0)
		if(SOUTH)
			M.Turn(180)
		if(EAST)
			M.Turn(90)
		if(WEST)
			M.Turn(270)
	transform = M
	// Thrust animation: lunge from behind into position then fade
	var/target_x = pixel_x
	var/target_y = pixel_y
	switch(dir)
		if(NORTH)
			pixel_y = -16
		if(SOUTH)
			pixel_y = 16
		if(EAST)
			pixel_x = -16
		if(WEST)
			pixel_x = 16
	animate(src, pixel_x = target_x, pixel_y = target_y, alpha = 255, time = 1, easing = LINEAR_EASING)
	animate(alpha = 0, time = 3, easing = LINEAR_EASING)

// --- Persistent spear visual (vis_contents) ---

/obj/effect/gate_phalanx_spear
	name = "幻影长矛"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	icon_state = "bronzewingedspear"
	layer = EFFECTS_LAYER
	plane = GAME_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	alpha = 180

#undef GATE_PHALANX_FILTER
