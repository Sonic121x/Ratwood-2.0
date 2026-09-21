// 上下文只记录本次施法，延迟效果持有同一份不可变来源，离腹后不再享有内部命中。
/datum
	var/datum/z121_serpent_cast/z121_serpent_cast

/datum/z121_serpent_cast
	var/datum/weakref/stomach_ref
	var/datum/weakref/caster_ref
	var/datum/weakref/host_ref
	var/spell_name

/datum/z121_serpent_cast/New(obj/effect/z121_serpent_stomach/stomach, mob/caster, obj/effect/proc_holder/spell/spell)
	stomach_ref = WEAKREF(stomach)
	caster_ref = WEAKREF(caster)
	host_ref = WEAKREF(stomach.host)
	spell_name = spell.name

/datum/z121_serpent_cast/proc/host()
	var/obj/effect/z121_serpent_stomach/stomach = stomach_ref.resolve()
	var/mob/living/caster = caster_ref.resolve()
	var/mob/living/host = host_ref.resolve()
	if(QDELETED(stomach) || QDELETED(caster) || QDELETED(host) || stomach.captive != caster || caster.loc != stomach || host.stat == DEAD)
		return null
	return host

/datum/z121_serpent_cast/proc/blocks(mob/living/target)
	if(QDELETED(target) || target != host())
		return FALSE
	return (target.status_flags & GODMODE) || target.anti_magic_check()

/datum/z121_serpent_cast/proc/targets(turf/location)
	var/list/result = location.contents.Copy()
	var/mob/living/host = host()
	if(host && host.loc == location)
		result -= host
		result.Insert(1, host)
	return result

/datum/z121_serpent_cast/proc/turfs(list/locations, turf/center)
	var/list/result = locations.Copy()
	if(center in result)
		result -= center
		result.Insert(1, center)
	return result

/obj/effect/proc_holder/spell
	// 明确登记作用方式，不根据名称、手势要求或魔法学派猜测攻击性质。
	var/z121_serpent_kind

/obj/effect/proc_holder/spell/perform(list/targets, recharge = TRUE, mob/user = usr)
	if(z121_serpent_cast)
		return FALSE
	var/obj/effect/z121_serpent_stomach/stomach = user?.loc
	if(!istype(stomach) || stomach.captive != user || !z121_serpent_kind)
		return ..()
	// 依据这些法术的实际治疗分支分类；不能将治疗亡灵的骨寒变成伤害活体宿主。
	if(z121_serpent_kind == "混合")
		var/mob/living/caster = user
		var/mob/living/intended = targets?[1]
		if(!isliving(intended) || intended == user)
			return ..()
		if(istype(src, /obj/effect/proc_holder/spell/invoked/bonechill))
			if(intended.mob_biotypes & MOB_UNDEAD)
				return ..()
		else if(!caster.patron?.undead_hater || !(intended.mob_biotypes & MOB_UNDEAD))
			return ..()
	var/datum/z121_serpent_cast/context = new(stomach, user, src)
	z121_serpent_cast = context
	var/previous_los = ignore_los
	ignore_los = TRUE
	log_combat(user, stomach.host, "在腹内施放[name]")
	. = ..(list(stomach.host), recharge, user)
	if(!QDELETED(src))
		ignore_los = previous_los
		z121_serpent_cast = null

/obj/effect/proc_holder/spell/invoked/projectile
	z121_serpent_kind = "弹道"

/obj/effect/proc_holder/spell/invoked/projectile/fetch
	z121_serpent_kind = null

/obj/effect/proc_holder/spell/invoked/projectile/cast(list/targets, mob/living/user)
	if(!z121_serpent_cast)
		return ..()
	var/mob/living/host = z121_serpent_cast.host()
	if(!host)
		return FALSE
	z121_base_cast(targets, user)
	fire_projectile(user, host)
	update_icon()
	// 冷却、咒语、资源及疲劳统一交给 perform，不能在这里再扣一遍。
	return TRUE

/obj/projectile
	var/z121_serpent_resolved = FALSE

/obj/projectile/fire(angle, atom/direct_target)
	if(!z121_serpent_cast)
		return ..()
	if(z121_serpent_resolved)
		return
	z121_serpent_resolved = TRUE
	var/mob/living/host = z121_serpent_cast.host()
	if(!host || !prehit(host))
		qdel(src)
		return
	original = host
	def_zone = BODY_ZONE_CHEST
	// 这里不经过穿戴防御、盾牌、武技或命中率检定；仍保留魔抗与伤害免疫。
	if(z121_serpent_cast.blocks(host))
		to_chat(host, span_notice("腹内涌起的魔力被无形的屏障压了回去。"))
		qdel(src)
		return
	if(SEND_SIGNAL(host, COMSIG_ATOM_BULLET_ACT, src, def_zone) & COMPONENT_ATOM_BLOCK_BULLET)
		qdel(src)
		return
	var/on_hit_state = on_hit(host, 0)
	if(!QDELETED(host) && !nodamage && on_hit_state != BULLET_ACT_BLOCK)
		if(host.apply_damage(damage, damage_type, def_zone, 0))
			host.apply_effects(stun = stun, knockdown = knockdown, unconscious = unconscious, slur = slur, stutter = stutter, eyeblur = eyeblur, drowsy = drowsy, blocked = 0, stamina = stamina, jitter = jitter, paralyze = paralyze, immobilize = immobilize)
			if(dismemberment)
				host.check_projectile_dismemberment(src, def_zone, 0)
			if(woundclass)
				host.check_projectile_wounding(src, def_zone, 0)
			if(poisontype && poisonamount && host.reagents)
				host.reagents.add_reagent(poisontype, poisonamount)
		to_chat(host, span_userdanger("一股狂暴的力量从腹内炸开，直袭我的血肉！"))
	if(!QDELETED(src))
		qdel(src)

// 瞄准式旧法术也有同样的地面限制，使用自身原有的弹数和配置，不借用其他法术。
/obj/effect/proc_holder/spell/aimed/fireball
	z121_serpent_kind = "弹道"

/obj/effect/proc_holder/spell/aimed/cast(list/targets, mob/living/user)
	if(!z121_serpent_cast)
		return ..()
	var/mob/living/host = z121_serpent_cast.host()
	if(!host)
		return FALSE
	current_amount--
	for(var/i in 1 to projectiles_per_fire)
		var/obj/projectile/projectile = new projectile_type(user.loc)
		projectile.firer = user
		projectile.preparePixelProjectile(host, user)
		for(var/key in projectile_var_overrides)
			if(projectile.vars[key])
				projectile.vv_edit_var(key, projectile_var_overrides[key])
		ready_projectile(projectile, host, user, i)
		projectile.z121_serpent_cast = z121_serpent_cast
		projectile.fire()
	update_icon()
	return TRUE

/datum/z121_metamagic_payload/New(datum/source)
	. = ..()
	z121_serpent_cast = source.z121_serpent_cast

// 普通直接伤害本来就不检定外穿护甲；这里只为腹内攻击补齐反魔和无敌的判定。
/obj/effect/proc_holder/spell/proc/z121_serpent_blocked(list/targets, mob/user)
	if(!z121_serpent_cast || !z121_serpent_cast.blocks(targets?[1]))
		return FALSE
	z121_base_cast(targets, user)
	to_chat(user, span_warning("魔力触及周遭的血肉，却被无形的屏障消解了。"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/repulse
	z121_serpent_kind = "范围"
/obj/effect/proc_holder/spell/invoked/blade_burst
	z121_serpent_kind = "范围"
/obj/effect/proc_holder/spell/invoked/snap_freeze
	z121_serpent_kind = "范围"
/obj/effect/proc_holder/spell/invoked/gravity
	z121_serpent_kind = "范围"
/obj/effect/proc_holder/spell/invoked/thunderstrike
	z121_serpent_kind = "范围"
/obj/effect/proc_holder/spell/invoked/wither
	z121_serpent_kind = "范围"
/obj/effect/proc_holder/spell/invoked/meteor_storm
	z121_serpent_kind = "范围"
/obj/effect/proc_holder/spell/invoked/sundering_lightning
	z121_serpent_kind = "范围"
/obj/effect/proc_holder/spell/invoked/aerosolize
	z121_serpent_kind = "范围"

// 这些法术对不同生物可能治疗或造成伤害，不把对自身的辅助施法改成攻击。
/obj/effect/proc_holder/spell/invoked/bonechill
	z121_serpent_kind = "混合"
/obj/effect/proc_holder/spell/invoked/lesser_heal
	z121_serpent_kind = "混合"
/obj/effect/proc_holder/spell/invoked/heal
	z121_serpent_kind = "混合"

/obj/effect/proc_holder/spell/invoked/rebuke
	z121_serpent_kind = "直接"
/obj/effect/proc_holder/spell/invoked/frostbite
	z121_serpent_kind = "直接"
/obj/effect/proc_holder/spell/invoked/eyebite
	z121_serpent_kind = "直接"
/obj/effect/proc_holder/spell/targeted/inflict_handler
	z121_serpent_kind = "直接"
/obj/effect/proc_holder/spell/targeted/churn
	z121_serpent_kind = "直接"
/obj/effect/proc_holder/spell/targeted/tesla
	z121_serpent_kind = "直接"

/obj/effect/proc_holder/spell/invoked/pain
	z121_serpent_kind = "弹道"

/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_wave
	z121_serpent_kind = "范围"

/obj/effect/proc_holder/spell/invoked/rebuke/cast(list/targets, mob/living/user)
	if(z121_serpent_blocked(targets, user))
		return TRUE
	return ..()
/obj/effect/proc_holder/spell/invoked/frostbite/cast(list/targets, mob/living/user)
	if(z121_serpent_blocked(targets, user))
		return TRUE
	return ..()
/obj/effect/proc_holder/spell/invoked/eyebite/cast(list/targets, mob/living/user)
	if(z121_serpent_blocked(targets, user))
		return TRUE
	return ..()
/obj/effect/proc_holder/spell/targeted/inflict_handler/cast(list/targets, mob/user = usr)
	if(z121_serpent_blocked(targets, user))
		return TRUE
	return ..()
/obj/effect/proc_holder/spell/targeted/churn/cast(list/targets, mob/living/user = usr)
	if(z121_serpent_blocked(targets, user))
		return TRUE
	return ..()

/obj/effect/proc_holder/spell/targeted/tesla/Bolt(mob/origin, mob/target, bolt_energy, bounces, mob/user = usr)
	if(z121_serpent_cast?.blocks(target))
		return
	return ..()

/obj/effect/proc_holder/spell/invoked/bonechill/cast(list/targets, mob/living/user)
	var/mob/living/target = targets?[1]
	if(isliving(target) && !(target.mob_biotypes & MOB_UNDEAD) && z121_serpent_blocked(targets, user))
		return TRUE
	return ..()

/obj/effect/proc_holder/spell/invoked/lesser_heal/cast(list/targets, mob/living/user)
	var/mob/living/target = targets?[1]
	if(isliving(target) && user.patron?.undead_hater && (target.mob_biotypes & MOB_UNDEAD) && z121_serpent_blocked(targets, user))
		return TRUE
	return ..()

/obj/effect/proc_holder/spell/invoked/heal/cast(list/targets, mob/living/user)
	var/mob/living/target = targets?[1]
	if(isliving(target) && user.patron?.undead_hater && (target.mob_biotypes & MOB_UNDEAD) && z121_serpent_blocked(targets, user))
		return TRUE
	return ..()

// 延迟雷击以独立上下文确定宿主优先级，保留其余地块的原有结算。
/obj/effect/proc_holder/spell/invoked/thunderstrike/thunderstrike_damage(turf/effect_layer, damage_mod, datum/z121_serpent_cast/context = null)
	if(!context)
		return ..()
	new /obj/effect/temp_visual/thunderstrike_actual(effect_layer)
	playsound(effect_layer, 'sound/magic/lightning.ogg', 50)
	for(var/mob/living/target in context.targets(effect_layer))
		if(context.blocks(target) || target.anti_magic_check())
			continue
		target.electrocute_act(damage * damage_mod, src, 1, SHOCK_NOSTUN | (target == context.host() ? SHOCK_NOGLOVES : 0))
		return

// 仅对应攻击来源击中自己的宿主时略过手套和衣甲；种族、电阻与正常免疫仍由原流程处理。
/mob/living/carbon/human/electrocute_act(shock_damage, datum/source, siemens_coeff = 1, flags = NONE)
	if(istype(source) && source.z121_serpent_cast?.host() == src)
		if(source.z121_serpent_cast.blocks(src))
			return FALSE
		flags = (flags & ~SHOCK_TESLA) | SHOCK_NOGLOVES
	return ..(shock_damage, source, siemens_coeff, flags)
