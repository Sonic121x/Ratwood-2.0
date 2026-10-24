#define CURTAIN_TICK_DAMAGE 50
#define CURTAIN_SCORCH_PER_TICK 2
#define CURTAIN_THROWN_BURN_COOLDOWN (2 SECONDS)
#define CURTAIN_THROWN_GRACE (1 SECONDS)
#define CURTAIN_BURN_KEY "curtain_burn"
#define CURTAIN_GRACE_KEY "curtain_grace"

/datum/action/cooldown/spell/fire_curtain
	button_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	name = "火幕术"
	desc = "在目标位置召出一道 5x2 的火幕，与面朝方向垂直。\
	预警 3 秒后爆发，燃烧 10 秒。\
	火焰不阻挡移动，却会灼烧穿过或站在其中的一切，\
	每次灼烧叠加两层。你也无法免疫自己的火幕。\n\
	火焰法术施加灼烧：达到 4 层时，会对瞄准的头部或胸部造成穿甲创伤；瞄准其他部位则在头胸之间随机选择。"
	button_icon_state = "fire_curtain"
	sound = 'sound/magic/fireball.ogg'
	spell_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_PYROMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("烈火之幕！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = 1 SECONDS
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 25 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/curtain_width = 5
	var/curtain_depth = 2
	var/curtain_life = 10 SECONDS
	var/telegraph_time = 3 SECONDS

/datum/action/cooldown/spell/fire_curtain/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	stats += span_info("伤害：每秒 [CURTAIN_TICK_DAMAGE] 点灼伤（火中最多持续 [DisplayTimeText(curtain_life)]）")
	stats += span_info("灼烧：每次烧灼叠加 [CURTAIN_SCORCH_PER_TICK] 层")
	return stats

/datum/action/cooldown/spell/fire_curtain/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE

	var/list/affected_turfs = get_curtain_turfs(center, H.dir)

	for(var/turf/T in affected_turfs)
		new /obj/effect/temp_visual/telegraph/wall/fire(T)

	H.visible_message(span_danger("[H]召出了一堵火墙！"))
	playsound(get_turf(H), 'sound/magic/charging_fire.ogg', 60, TRUE)

	addtimer(CALLBACK(src, PROC_REF(spawn_curtain), affected_turfs, H, H.zone_selected), telegraph_time)
	return TRUE

/datum/action/cooldown/spell/fire_curtain/proc/get_curtain_turfs(turf/center, facing)
	var/list/row_turfs = list(center)
	var/spread_dir1
	var/spread_dir2
	if(facing == NORTH || facing == SOUTH)
		spread_dir1 = WEST
		spread_dir2 = EAST
	else
		spread_dir1 = NORTH
		spread_dir2 = SOUTH

	var/half = (curtain_width - 1) / 2
	var/turf/current = center
	for(var/i in 1 to half)
		current = get_step(current, spread_dir1)
		if(current)
			row_turfs += current
	current = center
	for(var/i in 1 to half)
		current = get_step(current, spread_dir2)
		if(current)
			row_turfs += current

	// Extend depth along the facing direction
	var/list/all_turfs = row_turfs.Copy()
	for(var/d in 1 to curtain_depth - 1)
		var/list/next_row = list()
		for(var/turf/T in row_turfs)
			var/turf/deep = get_step(T, facing)
			if(deep)
				all_turfs |= deep
				next_row += deep
		row_turfs = next_row
	return all_turfs

/datum/action/cooldown/spell/fire_curtain/proc/spawn_curtain(list/turfs, mob/living/caster, aim_zone)
	if(QDELETED(src) || QDELETED(owner))
		return
	for(var/turf/T in turfs)
		new /obj/effect/curtain_fire(T, curtain_life, caster, aim_zone)
	playsound(turfs[1], pick('sound/misc/explode/incendiary (1).ogg', 'sound/misc/explode/incendiary (2).ogg'), 120, TRUE, 6)

/obj/effect/temp_visual/telegraph/wall/fire
	light_color = GLOW_COLOR_FIRE
	duration = 3 SECONDS

/obj/effect/curtain_fire
	name = "烈焰之墙"
	desc = "由召唤火焰构成的灼热帷幕。"
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_outer_range = LIGHT_RANGE_FIRE
	light_color = LIGHT_COLOR_FIRE
	ai_path_weight = 15
	var/lifetime = 10 SECONDS
	var/tick_damage = CURTAIN_TICK_DAMAGE
	var/burn_cooldown = 1 SECONDS
	var/list/burn_times
	var/datum/weakref/caster_ref
	var/aim_zone

/obj/effect/curtain_fire/Initialize(mapload, life, mob/living/new_caster, aimed_zone)
	. = ..()
	if(life)
		lifetime = life
	if(new_caster)
		caster_ref = WEAKREF(new_caster)
	aim_zone = aimed_zone
	START_PROCESSING(SSobj, src)
	QDEL_IN(src, lifetime)

/obj/effect/curtain_fire/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/curtain_fire/Crossed(atom/movable/AM, oldLoc)
	. = ..()
	if(isliving(AM))
		var/mob/living/L = AM
		burn_occupant(L, !!L.throwing)

/obj/effect/curtain_fire/process(seconds_per_tick)
	var/turf/T = get_turf(src)
	if(!isturf(T))
		return
	for(var/mob/living/L in T)
		burn_occupant(L, !!L.throwing)

/obj/effect/curtain_fire/proc/burn_occupant(mob/living/L, involuntary = FALSE)
	if(HAS_TRAIT(L, TRAIT_NOFIRE))
		return
	// Grace timer for those who were involuntarily thrown into the fire curtain so that it doesn't instaproc charred in involuntary situation
	if(L.mob_timers[CURTAIN_GRACE_KEY] && world.time < L.mob_timers[CURTAIN_GRACE_KEY])
		return
	var/mob_key = REF(L)
	if(involuntary)
		if(L.mob_timers[CURTAIN_BURN_KEY] && world.time < L.mob_timers[CURTAIN_BURN_KEY])
			return
	else if(LAZYACCESS(burn_times, mob_key) && world.time < burn_times[mob_key])
		return
	L.mob_timers[CURTAIN_BURN_KEY] = world.time + CURTAIN_THROWN_BURN_COOLDOWN
	LAZYSET(burn_times, mob_key, world.time + burn_cooldown)
	if(involuntary)
		L.mob_timers[CURTAIN_GRACE_KEY] = world.time + CURTAIN_THROWN_GRACE
	var/hit_zone = aim_zone || BODY_ZONE_CHEST
	var/mob/living/carbon/human/caster = caster_ref?.resolve()
	if(istype(caster) && !QDELETED(caster))
		if(arcyne_strike(caster, L, null, tick_damage, hit_zone, BCLASS_BURN, spell_name = "火幕术", damage_type = BURN, skip_animation = TRUE, exact_zone = TRUE) == ARCYNE_STRIKE_WARDED)
			return
	else
		var/fallback_zone = check_zone(hit_zone)
		var/armor_block = L.run_armor_check(fallback_zone, "fire", blade_dulling = BCLASS_BURN, damage = tick_damage, no_debuff = TRUE)
		L.apply_damage(tick_damage, BURN, fallback_zone, armor_block)
	apply_scorch_stack(L, CURTAIN_SCORCH_PER_TICK, hit_zone)
	L.emote("pain", forced = TRUE)

#undef CURTAIN_TICK_DAMAGE
#undef CURTAIN_SCORCH_PER_TICK
#undef CURTAIN_THROWN_BURN_COOLDOWN
#undef CURTAIN_THROWN_GRACE
#undef CURTAIN_BURN_KEY
#undef CURTAIN_GRACE_KEY
