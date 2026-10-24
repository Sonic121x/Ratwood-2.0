#define PHALANX_FILTER "phalanx_glow"

/datum/action/cooldown/spell/azurean_phalanx
	source_aspect = /datum/magic_aspect/pseudo/spellblade
	name = "费伦提亚方阵"
	desc = "为下一次近战打击注入奥术之力。命中时贯穿目标，\
		攻击其身后直线上的敌人。命中积累 1 点动量。\
		动量达到 3 点时：消耗 3 点，使穿刺更深、伤害更高。"
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "azurean_phalanx"
	sound = 'sound/magic/antimagic.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_POKE

	invocations = list("费伦提亚，列阵！")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	weapon_cast_penalized = FALSE
	cooldown_time = 12 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/pierce_length = 3
	var/pierce_damage = 35
	var/empowered_pierce_length = 4
	var/empowered_pierce_damage = 50
	var/momentum_cost = 3

/datum/action/cooldown/spell/azurean_phalanx/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!arcyne_get_weapon(H))
		to_chat(H, span_warning("我必须握住绑定武器！"))
		return FALSE

	if(H.has_status_effect(/datum/status_effect/buff/phalanx_ready))
		to_chat(H, span_warning("我的突刺已经准备好了！"))
		return FALSE

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("释放 [momentum_cost] 点动量——强化贯穿已就绪！"))

	var/datum/status_effect/buff/phalanx_ready/effect = H.apply_status_effect(/datum/status_effect/buff/phalanx_ready)
	if(effect)
		effect.spell_ref = WEAKREF(src)
		effect.empowered = empowered

	H.visible_message(
		span_notice("[H]为[H.p_their()]的武器注入涌动的奥术之力。"),
		span_notice("突刺已就绪——下一击将贯穿目标。"))
	playsound(get_turf(H), 'sound/magic/antimagic.ogg', 60, TRUE)
	return TRUE

/datum/action/cooldown/spell/azurean_phalanx/proc/do_pierce(mob/living/carbon/human/user, mob/living/struck, empowered)
	if(QDELETED(user) || user.stat == DEAD)
		return

	var/obj/item/weapon = arcyne_get_weapon(user)
	if(!weapon)
		return

	var/turf/origin = get_turf(struck)
	if(!origin)
		return

	var/pierce_dir = get_dir(user, struck)
	if(!pierce_dir)
		pierce_dir = user.dir

	var/def_zone = user.zone_selected || BODY_ZONE_CHEST
	var/damage = empowered ? empowered_pierce_damage : pierce_damage
	var/length = empowered ? empowered_pierce_length : pierce_length

	var/list/pierce_turfs = list()
	var/turf/current = origin
	for(var/i in 1 to length)
		current = get_step(current, pierce_dir)
		if(!current || current.density)
			break
		var/struct_blocked = FALSE
		for(var/obj/structure/S in current.contents)
			if(S.density && !S.climbable)
				struct_blocked = TRUE
				break
		if(struct_blocked)
			break
		pierce_turfs += current

	// Visuals on origin tile and all pierce tiles
	var/obj/effect/temp_visual/origin_burst = new /obj/effect/temp_visual/blade_stab(origin)
	origin_burst.dir = pierce_dir
	for(var/turf/T in pierce_turfs)
		var/obj/effect/temp_visual/V = new /obj/effect/temp_visual/blade_stab(T)
		V.dir = pierce_dir

	playsound(origin, pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 70, TRUE)

	var/hit_count = 0
	var/deflected = FALSE
	var/list/already_hit = list()

	// Hit the original struck target with the arcyne strike (they already took the normal weapon hit)
	if(!QDELETED(struck) && struck.stat != DEAD)
		if(spell_guard_check(struck, FALSE, user))
			deflected = TRUE
		else
			arcyne_strike(user, struck, weapon, damage, def_zone, BCLASS_STAB, spell_name = "费伦提亚方阵", skip_animation = TRUE)
			hit_count++
			already_hit += struck

	for(var/turf/T in pierce_turfs)
		for(var/mob/living/victim in T)
			if(victim == user || victim == struck || victim.stat == DEAD || (victim in already_hit))
				continue
			if(spell_guard_check(victim, FALSE, user, punish_caster = deflected ? FALSE : null))
				deflected = TRUE
				continue
			arcyne_strike(user, victim, weapon, damage, def_zone, BCLASS_STAB, spell_name = "费伦提亚方阵", skip_animation = TRUE)
			hit_count++
			already_hit += victim

	var/datum/status_effect/buff/arcyne_momentum/M = user.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M)
		M.add_stacks(1)

	if(hit_count)
		user.visible_message(span_danger("[user]用[user.p_their()]的[weapon.name]贯穿[struck]，刺中其身后的敌人！"))
		if(hit_count >= 2 && M)
			M.add_stacks(1)
			to_chat(user, span_notice("双重贯穿！奥术涌动！"))
	else
		user.visible_message(span_notice("[user]的打击贯穿了[struck]。"))

// --- Status effect ---

/atom/movable/screen/alert/status_effect/buff/phalanx_ready
	name = "方阵突刺就绪"
	desc = "我的下一次近战打击将贯穿目标。"
	icon_state = "buff"

/datum/status_effect/buff/phalanx_ready
	id = "phalanx_ready"
	alert_type = /atom/movable/screen/alert/status_effect/buff/phalanx_ready
	duration = 10 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	var/datum/weakref/spell_ref
	var/empowered = FALSE

/datum/status_effect/buff/phalanx_ready/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	owner.add_filter(PHALANX_FILTER, 2, list("type" = "outline", "color" = "#4488ff", "alpha" = 160, "size" = 2))

/datum/status_effect/buff/phalanx_ready/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	owner.remove_filter(PHALANX_FILTER)
	. = ..()

/datum/status_effect/buff/phalanx_ready/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(!isliving(target) || target == owner || target.stat == DEAD)
		return
	var/obj/item/bound = arcyne_get_weapon(owner)
	if(!bound || bound != weapon)
		return
	var/datum/action/cooldown/spell/azurean_phalanx/spell = spell_ref?.resolve()
	if(!spell)
		owner.remove_status_effect(/datum/status_effect/buff/phalanx_ready)
		return
	var/was_empowered = empowered
	owner.remove_status_effect(/datum/status_effect/buff/phalanx_ready)
	INVOKE_ASYNC(spell, TYPE_PROC_REF(/datum/action/cooldown/spell/azurean_phalanx, do_pierce), source, target, was_empowered)

/obj/effect/temp_visual/blade_stab
	icon = 'icons/effects/effects.dmi'
	icon_state = "stab"
	dir = NORTH
	name = "奥术突刺"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER

#undef PHALANX_FILTER
