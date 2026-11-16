/datum/action/cooldown/spell/skyrend
	source_aspect = /datum/magic_aspect/pseudo/spellblade
	name = "裂空箭雨"
	desc = "以地脉为弓弦，向目标连续射出奥术箭矢，\
		每一箭都会重新瞄准逃跑中的目标。箭矢也会击中进入其飞行路径的人。不消耗箭矢。\
		需要7层动量：射出5支箭，每支造成22点伤害。\
		10层动量时过载：射出8支箭，每支造成22点伤害。"
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "blade_storm" // Placeholder until bow sprites exist
	sound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_HIGH

	cast_range = 7

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_ULT

	invocations = list("撕裂苍穹！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_MINOR
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_HIGH
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/base_arrows = 5
	var/bonus_arrows = 3
	var/arrow_delay = 2
	var/min_momentum = 7
	var/empowered_momentum = 10

/datum/action/cooldown/spell/skyrend/can_cast_spell(feedback = TRUE)
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

/datum/action/cooldown/spell/skyrend/cast(atom/cast_on)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/bow = arcyne_get_weapon(H)
	if(!istype(bow, /obj/item/gun/ballistic/revolver/grenadelauncher/bow))
		to_chat(H, span_warning("我必须手持绑定的弓！"))
		return FALSE

	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		to_chat(H, span_warning("目标无效！"))
		return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		to_chat(H, span_warning("动量不足！至少需要[min_momentum]层！"))
		return FALSE

	var/stacks = M.stacks
	var/arrows = base_arrows
	if(stacks >= empowered_momentum)
		arrows += bonus_arrows
	M.consume_all_stacks()
	to_chat(H, span_notice("全部[stacks]层动量已注入地脉！"))

	var/def_zone = H.zone_selected || BODY_ZONE_CHEST
	// lock on to someone or strike the ground
	var/datum/weakref/target_ref = WEAKREF(isliving(cast_on) ? cast_on : target_turf)

	H.visible_message(span_boldwarning("[H]拉开纯粹奥术之光凝成的弓弦，瞄准了[span_combatsecondarybp(parse_zone(def_zone))]！"))
	log_combat(H, cast_on, "对其使用了裂空箭雨", zone=def_zone)

	for(var/arrow_num in 1 to arrows)
		addtimer(CALLBACK(src, PROC_REF(loose_arrow), H, target_ref, target_turf, def_zone), (arrow_num - 1) * arrow_delay)
	. = ..()

/datum/action/cooldown/spell/skyrend/proc/loose_arrow(mob/living/carbon/human/user, datum/weakref/target_ref, turf/fallback_turf, def_zone)
	if(QDELETED(user) || user.stat == DEAD || !isturf(user.loc))
		return
	if(!arcyne_get_weapon(user))
		return

	var/atom/target = target_ref?.resolve()
	if(!target || (isliving(target) && !(target in view(cast_range, user))))
		target = fallback_turf

	var/obj/projectile/magic/skyrend_arrow/P = new(user.loc)
	P.firer = user
	P.fired_from = get_turf(user)
	P.def_zone = def_zone
	user.apply_spell_accuracy(P)
	P.preparePixelProjectile(target, user, spread = rand(-4, 4))
	P.fire()
	playsound(get_turf(user), 'sound/combat/Ranged/flatbow-shot-01.ogg', 70, TRUE)

/obj/projectile/magic/skyrend_arrow
	name = "奥术之箭"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_proj"
	color = "#88BFFF"
	expose_caster_on_deflect = TRUE
	damage = 22
	damage_type = BRUTE
	nodamage = FALSE
	flag = "piercing"
	woundclass = BCLASS_PIERCE
	armor_penetration = PEN_LIGHT
	range = 15
	speed = 0.4
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'

/obj/projectile/magic/skyrend_arrow/on_hit(target, blocked = FALSE)
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src]触及[target]时消散了！"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	return ..()
