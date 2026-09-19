// 每个延迟回调保存独立快照，避免下一次施法覆盖已经发出的效果。
/datum/z121_metamagic_payload/New(datum/source)
	z121_meta_power = source.z121_power(1)
	z121_meta_duration = source.z121_duration(1)

/obj/effect/proc_holder/spell/z121_power(amount)
	if(z121_metamagic_cast && z121_meta_power != 1 && amount)
		z121_metamagic_cast.applied = TRUE
	return ..()

/obj/effect/proc_holder/spell/z121_duration(amount)
	if(z121_metamagic_cast && z121_meta_duration != 1 && amount > 0)
		z121_metamagic_cast.applied = TRUE
	return ..()

// 只调整本次明确施加或刷新的状态；唯一状态没有重施成功时不能再次翻倍。
/datum/proc/z121_apply_status(mob/living/target, effect, ...)
	if(QDELETED(target))
		return null
	var/datum/status_effect/before = target.has_status_effect(effect)
	var/before_expiry = before?.duration
	var/list/effect_args = args.Copy(2)
	. = target.apply_status_effect(arglist(effect_args))
	var/datum/status_effect/after = target.has_status_effect(effect)
	if(!after || (before == after && before_expiry == after.duration))
		return .
	if(after.duration > world.time)
		after.duration = world.time + z121_duration(after.duration - world.time)
	after.z121_meta_power = z121_meta_power
	return .

/obj/effect/proc_holder/spell/proc/z121_base_cast(list/targets, mob/user)
	SEND_SIGNAL(user, COMSIG_MOB_CAST_SPELL)
	record_featured_object_stat(FEATURED_STATS_SPELLS, name)
	return TRUE

// 必须在子类 ready_projectile 写入技能伤害之后复制倍率，不能在弹丸出生时提前乘算。
/obj/effect/proc_holder/spell/invoked/projectile/fire_projectile(mob/living/user, atom/target)
	if(!z121_metamagic_cast)
		return ..()
	current_amount--
	for(var/i in 1 to projectiles_per_fire)
		var/obj/projectile/P = new projectile_type(user.loc)
		if(istype(P, /obj/projectile/magic/bloodsteal))
			var/obj/projectile/magic/bloodsteal/B = P
			B.sender = user
		P.def_zone = user.zone_selected
		P.accuracy += (user.STAINT - 9) * 4
		P.bonus_accuracy += (user.STAINT - 8) * 3
		if(user.mind)
			P.bonus_accuracy += user.get_skill_level(associated_skill) * 5
		P.firer = user
		P.preparePixelProjectile(target, user)
		for(var/V in projectile_var_overrides)
			if(P.vars[V])
				P.vv_edit_var(V, projectile_var_overrides[V])
		ready_projectile(P, target, user, i)
		P.z121_meta_power = z121_meta_power
		P.z121_meta_duration = z121_meta_duration
		P.damage = z121_power(P.damage)
		if(z121_meta_has_duration)
			P.z121_meta_duration = z121_duration(1)
		P.fire()
	return TRUE

// 命中过程同步完成后，只扩展该命中真正新建或刷新的指定状态。
/obj/projectile/proc/z121_status_snapshot(list/targets, list/effect_types)
	var/list/snapshot = list()
	for(var/mob/living/target as anything in targets)
		var/list/effects = list()
		for(var/effect_type in effect_types)
			var/datum/status_effect/effect = target.has_status_effect(effect_type)
			effects[effect_type] = list(effect, effect?.duration)
		snapshot[target] = effects
	return snapshot

/obj/projectile/proc/z121_finish_statuses(list/snapshot)
	for(var/mob/living/target as anything in snapshot)
		if(QDELETED(target))
			continue
		var/list/effects = snapshot[target]
		for(var/effect_type in effects)
			var/datum/status_effect/effect = target.has_status_effect(effect_type)
			var/list/previous = effects[effect_type]
			if(!effect || (effect == previous[1] && effect.duration == previous[2]))
				continue
			if(effect.duration > world.time)
				effect.duration = world.time + z121_duration(effect.duration - world.time)
			effect.z121_meta_power = z121_meta_power

/obj/projectile/magic/acidsplash/on_hit(atom/target, blocked = FALSE)
	var/list/victims = list()
	for(var/mob/living/L in range(aoe_range, get_turf(src)))
		victims += L
	var/list/snapshot = z121_status_snapshot(victims, list(/datum/status_effect/buff/acidsplash))
	. = ..()
	z121_finish_statuses(snapshot)

/datum/status_effect/buff/acidsplash/tick()
	if(z121_meta_power == 1)
		return ..()
	owner.adjustFireLoss(z121_power(5))

/obj/projectile/magic/frostbolt/on_hit(target)
	var/list/snapshot = z121_status_snapshot(isliving(target) ? list(target) : list(), list(/datum/status_effect/buff/frost, /datum/status_effect/buff/frostbite))
	. = ..()
	z121_finish_statuses(snapshot)

/obj/projectile/magic/lightning/on_hit(target)
	var/list/snapshot = z121_status_snapshot(isliving(target) ? list(target) : list(), list(/datum/status_effect/debuff/clickcd, /datum/status_effect/buff/lightningstruck, /datum/status_effect/incapacitating/immobilized))
	. = ..()
	z121_finish_statuses(snapshot)

// 召唤物在原初始化安排销毁之前取得时长；没有传入倍率时完全沿用旧值。
/obj/structure/forcefield_weak/Initialize(mapload, mob/summoner, meta_duration = 1)
	timeleft *= meta_duration
	return ..()

/obj/machinery/light/rogue/campfire/create_campfire/Initialize(mapload, meta_duration = 1)
	lifespan *= meta_duration
	return ..()

/obj/effect/proc_holder/spell/self/light/make_item()
	. = ..()
	if(istype(item, /obj/item/flashlight/flare/light))
		var/obj/item/flashlight/flare/light/light = item
		light.fuel = z121_duration(light.fuel)

// 独立效果实体在启动异步伤害过程前保存倍率。
/obj/effect/temp_visual/target/Initialize(mapload, list/flame_hit, meta_power = 1)
	z121_meta_power = meta_power
	return ..()

/obj/effect/temp_visual/targetlightning/Initialize(mapload, list/flame_hit, meta_power = 1)
	z121_meta_power = meta_power
	return ..()

// 爆炸沿用原来的范围和随机伤害公式，只在该次爆炸的同步伤害结算内乘算。
/datum/proc/z121_explosion(atom/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = TRUE, ignorecap = FALSE, flame_range = 0, silent = FALSE, smoke = FALSE, soundin)
	var/datum/explosion/blast = new /datum/explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog, ignorecap, flame_range, silent, smoke, soundin)
	// 原构造函数在处理地块前先让出执行，因此此处先于所有实际伤害完成。
	blast.z121_meta_power = z121_meta_power
	return blast

/atom
	var/z121_explosion_power = 1

/atom/proc/z121_get_explosion_power(atom/epicenter)
	if(!epicenter)
		return 1
	var/turf/location = get_turf(src)
	if(!location?.explosion_id)
		return 1
	for(var/datum/explosion/blast as anything in GLOB.explosions)
		if(blast.explosion_id == location.explosion_id && get_turf(blast.explosion_source) == get_turf(epicenter))
			return blast.z121_meta_power
	return 1

/mob/living/carbon/human/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	var/previous = z121_explosion_power
	z121_explosion_power = z121_get_explosion_power(epicenter)
	. = ..()
	z121_explosion_power = previous

/mob/living/simple_animal/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	var/previous = z121_explosion_power
	z121_explosion_power = z121_get_explosion_power(epicenter)
	. = ..()
	z121_explosion_power = previous

/mob/living/take_overall_damage(brute = 0, burn = 0, stamina = 0, updating_health = TRUE, required_status = null)
	return ..(brute * z121_explosion_power, burn * z121_explosion_power, stamina, updating_health, required_status)

/mob/living/carbon/take_overall_damage(brute = 0, burn = 0, stamina = 0, updating_health = TRUE, required_status)
	return ..(brute * z121_explosion_power, burn * z121_explosion_power, stamina, updating_health, required_status)

/obj/structure/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	var/previous = z121_explosion_power
	z121_explosion_power = z121_get_explosion_power(epicenter)
	. = ..()
	z121_explosion_power = previous

/turf/closed/wall/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	var/previous = z121_explosion_power
	z121_explosion_power = z121_get_explosion_power(epicenter)
	. = ..()
	z121_explosion_power = previous

/obj/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir, armor_penetration = 0)
	return ..(damage_amount * z121_explosion_power, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)

/turf/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE)
	return ..(damage_amount * z121_explosion_power, damage_type, damage_flag, sound_effect)

// 接触法术在实际触碰并完成引导时结算，召出或收起手中焦点不算施法。
/obj/effect/proc_holder/spell/targeted/touch/nondetection/add_buff_timer(mob/living/user)
	addtimer(CALLBACK(src, PROC_REF(remove_buff), user), z121_duration(1 HOURS))
	z121_metamagic_cast?.finish(TRUE)

/obj/item/melee/touch_attack/nondetection/afterattack(atom/target, mob/living/carbon/user, proximity)
	var/obj/effect/proc_holder/spell/targeted/touch/nondetection/spell = attached_spell
	if(!spell || !spell.z121_mode(user))
		return ..()
	if(spell.z121_metamagic_cast?.executing)
		return
	var/datum/z121_metamagic_cast/casting = spell.z121_begin(user)
	if(casting)
		casting.executing = TRUE
	if(isliving(target))
		var/obj/item/sacrifice
		for(var/obj/item/I in user.held_items)
			if(istype(I, /obj/item/ash))
				sacrifice = I
		if(!sacrifice)
			to_chat(user, span_warning("我需要在空着的手里拿一些灰烬。"))
		else if(do_after(user, spell.z121_channel(5 SECONDS, user), target = target) && !QDELETED(sacrifice))
			qdel(sacrifice)
			ADD_TRAIT(target, TRAIT_ANTISCRYING, MAGIC_TRAIT)
			user.visible_message(span_notice("[user]在空中划出符文，将灰烬洒向[target]。"))
			spell.add_buff_timer(target)
			spell.remove_hand()
	if(casting && !QDELETED(casting))
		casting.finish(FALSE)

/obj/item/melee/touch_attack/prestidigitation/handle_mote(mob/living/carbon/human/user)
	if(!mote || mote.loc != src || attached_spell?.z121_mode(user) != Z121_META_QUICK)
		return ..()
	if(attached_spell.z121_metamagic_cast?.executing)
		return FALSE
	var/datum/z121_metamagic_cast/casting = attached_spell.z121_begin(user)
	if(casting)
		casting.executing = TRUE
	. = z121_handle_mote(user)
	if(casting && !QDELETED(casting))
		casting.finish(!!.)

/obj/item/melee/touch_attack/prestidigitation/clean_thing(atom/target, mob/living/carbon/human/user)
	if(attached_spell?.z121_mode(user) != Z121_META_QUICK)
		return ..()
	if(attached_spell.z121_metamagic_cast?.executing)
		return FALSE
	var/datum/z121_metamagic_cast/casting = attached_spell.z121_begin(user)
	if(casting)
		casting.executing = TRUE
	. = z121_clean_thing(target, user)
	if(casting && !QDELETED(casting))
		casting.finish(!!.)

/obj/effect/aerosol_cloud/Initialize(mapload, newdir, cloud_color, meta_duration = 1)
	z121_meta_duration = meta_duration
	return ..()

/obj/effect/aerosol_cloud/travel()
	if(z121_meta_duration == 1)
		return ..()
	sleep(6)
	for(var/i in 1 to 4)
		if(QDELETED(src))
			return
		z121_release_smoke()
		var/turf/next = get_step(src, travel_dir)
		if(!next || next.density)
			break
		sleep(6)
		forceMove(next)
	if(!QDELETED(src))
		z121_release_smoke()
		qdel(src)

/obj/effect/aerosol_cloud/proc/z121_release_smoke()
	var/datum/effect_system/smoke_spread/chem/smoke = new
	smoke.z121_meta_duration = z121_meta_duration
	smoke.set_up(payload, 0, get_turf(src), TRUE)
	smoke.start()

/datum/effect_system/smoke_spread/chem/start()
	if(z121_meta_duration == 1)
		return ..()
	var/mixcolor = mix_color_from_reagents(chemholder.reagents.reagent_list)
	if(holder)
		location = get_turf(holder)
	var/obj/effect/particle_effect/smoke/chem/S = new effect_type(location)
	S.lifetime = z121_duration(S.lifetime)
	if(chemholder.reagents.total_volume > 1)
		chemholder.reagents.copy_to(S, chemholder.reagents.total_volume)
	if(mixcolor)
		S.add_atom_colour(mixcolor, FIXED_COLOUR_PRIORITY)
	S.amount = amount
	if(S.amount)
		S.spread_smoke()
