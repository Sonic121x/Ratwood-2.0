// 上下文只记录本次施法，延迟效果持有同一份不可变来源，离腹后不再享有内部命中。
/datum
	var/datum/z121_serpent_cast/z121_serpent_cast

/datum/z121_serpent_cast
	var/datum/weakref/stomach_ref
	var/datum/weakref/caster_ref
	var/datum/weakref/host_ref
	var/spell_name

/datum/z121_serpent_cast/New(obj/effect/z121_serpent_stomach/stomach, mob/caster, datum/action/cooldown/spell/spell)
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

// 攻击动作重定向到宿主，原动作仍负责蓄力、资源和冷却。
/datum/action/cooldown/spell
	var/z121_serpent_offensive = FALSE
	var/z121_admin_authorized = FALSE

/datum/action/cooldown/spell/projectile
	z121_serpent_offensive = TRUE

/datum/action/cooldown/spell/projectile/fetch
	z121_serpent_offensive = FALSE

/datum/action/cooldown/spell/PreActivate(atom/target)
	var/obj/effect/z121_serpent_stomach/stomach = owner?.loc
	if(!z121_serpent_offensive || !istype(stomach) || stomach.captive != owner)
		return ..()
	if(z121_serpent_cast)
		return FALSE
	z121_serpent_cast = new(stomach, owner, src)
	var/mob/living/host = z121_serpent_cast.host()
	if(!host || z121_serpent_cast.blocks(host))
		z121_serpent_cast = null
		return FALSE
	log_combat(owner, host, "在腹内施放[name]")
	. = ..(host)
	if(!QDELETED(src))
		z121_serpent_cast = null

/datum/action/cooldown/spell/projectile/cast(atom/cast_on)
	if(!z121_serpent_cast)
		return ..()
	var/mob/living/host = z121_serpent_cast.host()
	if(!host || z121_serpent_cast.blocks(host))
		return FALSE
	z121_serpent_notify_cast(host)
	return fire_projectile(host)

/datum/action/cooldown/spell/projectile/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	to_fire.z121_serpent_cast = z121_serpent_cast

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
	forceMove(get_turf(host))
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


// 腹内点按法术按钮即可锁定宿主，使用原生施法链统一结算。
/datum/action/cooldown/spell/Trigger(trigger_flags)
	var/obj/effect/z121_serpent_stomach/stomach = owner?.loc
	if(!z121_serpent_offensive || !istype(stomach) || stomach.captive != owner)
		return ..()
	if(!IsAvailable() || currently_charging || !can_cast_spell(TRUE))
		return FALSE
	INVOKE_ASYNC(src, PROC_REF(PreActivate), stomach.host)
	return TRUE

// 上游鼠标蓄力只接受地面施法；腹内通过同一套蓄力效果与中断检查完成引导。
/datum/action/cooldown/spell/before_cast(atom/cast_on)
	if(z121_serpent_cast && charge_required && click_to_activate)
		var/mob/living/caster = owner
		on_start_charge()
		charge_started_at = world.time
		charge_target_time = charge_time
		apply_charge_intent()
		var/completed = do_after(caster, charge_time, target = caster, needhand = FALSE, extra_checks = CALLBACK(src, PROC_REF(do_after_checks), caster, cast_on))
		if(QDELETED(src))
			return SPELL_CANCEL_CAST
		on_end_charge(completed)
		if(!completed || !z121_serpent_cast?.host() || z121_serpent_cast.blocks(cast_on))
			return SPELL_CANCEL_CAST
	return ..()

// 仅为蛇腹容器放宽地面限制，其余上游施法资格仍逐项检查。
// 不临时搬动施法者，避免触发移动、吞吐与心智转移回调。
/datum/action/cooldown/spell/can_cast_spell(feedback = TRUE)
	if((type in GLOB.z121_admin_learnable_spells) && !z121_admin_authorized)
		if(!owner?.client || !check_rights_for(owner.client, R_ADMIN))
			return FALSE
	var/obj/effect/z121_serpent_stomach/stomach = owner?.loc
	if(!z121_serpent_offensive || !istype(stomach) || stomach.captive != owner)
		return ..()
	if(!isliving(owner) || !stomach.host || stomach.host.stat == DEAD)
		return FALSE
	var/mob/living/caster = owner
	if(!(spell_flags & SPELL_IGNORE_SPELLBLOCK) && (HAS_TRAIT(caster, TRAIT_SPELLBLOCK) || HAS_TRAIT(caster, TRAIT_SPELLCOCKBLOCK)))
		return FALSE
	if(HAS_TRAIT(caster, TRAIT_SPELL_VAMPIRE_BLOCK) || HAS_TRAIT(caster, TRAIT_CURSE_NOC) || caster.has_status_effect(/datum/status_effect/debuff/cast_disrupted))
		return FALSE
	if(caster.mind?.has_spellmiracle_block_antag() && (source_aspect || primary_resource_type == SPELL_COST_DEVOTION || secondary_resource_type == SPELL_COST_DEVOTION))
		return FALSE
	if(caster.mind?.has_antag_datum(/datum/antagonist/vampire))
		var/tier = get_miracle_tier(type)
		if(!isnull(tier) && tier > CLERIC_T1)
			return FALSE
	if(!(spell_requirements & SPELL_CASTABLE_WHILE_MOUNTED) && caster.client && isliving(caster.buckled))
		return FALSE
	if((spell_requirements & SPELL_REQUIRES_CMODE) && !caster.cmode)
		return FALSE
	for(var/datum/action/cooldown/spell/S in caster.actions)
		if(S != src && S.currently_charging)
			return FALSE
	var/turf/ground = get_turf(caster)
	if(!ground || ((spell_requirements & SPELL_REQUIRES_STATION) && is_centcom_level(ground.z)))
		return FALSE
	if((spell_requirements & SPELL_REQUIRES_MIND) && !caster.mind)
		return FALSE
	if((spell_requirements & SPELL_REQUIRES_NO_ANTIMAGIC) && caster.anti_magic_check() && !HAS_TRAIT(caster, TRAIT_SPELL_DISPERSION))
		return FALSE
	if((spell_requirements & SPELL_REQUIRES_HUMAN) && !ishuman(caster))
		return FALSE
	if(length(required_items) && !HAS_TRAIT(caster, TRAIT_HALLOWED))
		var/found = FALSE
		for(var/obj/item/I in caster.contents)
			if(is_type_in_list(I, required_items))
				found = TRUE
				break
		if(!found)
			return FALSE
	return check_cost(feedback) && can_invoke(feedback)

// 内部定向效果跳过上游的地面选点分支，但仍发送同一套施法信号与日志。
/datum/action/cooldown/spell/proc/z121_serpent_notify_cast(atom/cast_on)
	SEND_SIGNAL(src, COMSIG_SPELL_CAST, cast_on)
	record_featured_object_stat(FEATURED_STATS_SPELLS, name)
	if(owner)
		SEND_SIGNAL(owner, COMSIG_MOB_CAST_SPELL, src, cast_on)
		if(owner.ckey)
			owner.log_message("在腹内施放 [name]，目标为 [key_name_admin(cast_on)]。", LOG_ATTACK)
			cast_on.log_message("受到 [key_name_admin(owner)] 的腹内法术 [name] 影响。", LOG_ATTACK)
