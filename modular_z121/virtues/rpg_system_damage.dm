// 击中期间保留明确的伤害来源；死亡信号早于伤害过程返回，不能等返回后才登记凶手。
/mob/living
	var/datum/z121_rpg_damage_context/z121_rpg_damage_context
	var/z121_rpg_damage_generation = 0

/datum/explosion
	// 爆炸异步处理地块，独立保存发射者，不能依赖已经删除的火球或当前操作者。
	var/datum/weakref/z121_rpg_caster_ref

/datum/z121_rpg_damage_context
	var/datum/weakref/target_ref
	var/datum/weakref/attacker_ref
	var/datum/z121_rpg_damage_context/previous_context
	var/previous_generation
	var/previous_health
	var/previous_damage
	var/previous_blood
	var/previous_fire_stacks
	var/recorded = FALSE

/datum/z121_rpg_damage_context/New(mob/living/target, mob/attacker)
	target_ref = WEAKREF(target)
	attacker_ref = WEAKREF(attacker)
	previous_context = target.z121_rpg_damage_context
	previous_generation = target.z121_rpg_damage_generation
	previous_health = target.health
	previous_damage = target.getBruteLoss() + target.getFireLoss() + target.getOxyLoss() + target.getToxLoss() + target.getCloneLoss()
	previous_blood = target.get_blood_volume()
	previous_fire_stacks = target.fire_stacks
	target.z121_rpg_damage_context = src

/datum/z121_rpg_damage_context/proc/record_attacker()
	var/mob/living/target = target_ref.resolve()
	if(!target || recorded || target.z121_rpg_damage_generation != previous_generation)
		return
	var/mob/attacker = attacker_ref?.resolve()
	target.lastattacker_weakref = WEAKREF(attacker)
	target.lastattacker = attacker?.real_name
	target.lastattackerckey = attacker?.ckey
	target.z121_rpg_damage_generation++
	recorded = TRUE

/datum/z121_rpg_damage_context/proc/finish()
	var/mob/living/target = target_ref.resolve()
	if(target)
		// 反射、闪避、治疗和完全免疫不改写归属；实际点燃则保留后续烧死的来源。
		var/current_damage = target.getBruteLoss() + target.getFireLoss() + target.getOxyLoss() + target.getToxLoss() + target.getCloneLoss()
		if(target.stat == DEAD || target.health < previous_health || current_damage > previous_damage || target.get_blood_volume() < previous_blood || target.fire_stacks > previous_fire_stacks)
			record_attacker()
		if(target.z121_rpg_damage_context == src)
			target.z121_rpg_damage_context = previous_context
	previous_context = null
	qdel(src)

/mob/living/proc/z121_rpg_begin_damage(atom/attacker)
	if(stat == DEAD || QDELETED(src))
		return null
	var/datum/component/rpg_kill_watcher/watcher = GetComponent(/datum/component/rpg_kill_watcher)
	if(!watcher)
		if(!ishuman(attacker) || !HAS_TRAIT(attacker, TRAIT_RPG_SYSTEM))
			return null
		var/datum/component/rpg_system/system = attacker.GetComponent(/datum/component/rpg_system)
		if(!system || (!system.is_rewardable_beast(src) && !system.get_fixed_reward(src)))
			return null
		// 命中时立即挂载，覆盖远距离和目标刚生成便被秒杀的情况。
		AddComponent(/datum/component/rpg_kill_watcher)
	// 已被监听的目标也记录非系统攻击者，避免把其击杀误算给此前的法师。
	return new /datum/z121_rpg_damage_context(src, ismob(attacker) ? attacker : null)

/mob/living/proc/z121_rpg_begin_explosion(atom/epicenter)
	var/turf/location = get_turf(src)
	if(!location?.explosion_id || !epicenter)
		return null
	for(var/datum/explosion/blast as anything in GLOB.explosions)
		if(blast.explosion_id != location.explosion_id || get_turf(blast.explosion_source) != get_turf(epicenter))
			continue
		return z121_rpg_begin_damage(blast.z121_rpg_caster_ref?.resolve())
	return null

// 在原本继承的入口增加包裹层，继续调用父类的伤害、命中率、护甲和免疫逻辑。
/mob/living/simple_animal/bullet_act(obj/projectile/projectile, def_zone = BODY_ZONE_CHEST)
	var/datum/z121_rpg_damage_context/context = z121_rpg_begin_damage(projectile.firer)
	try
		. = ..()
	catch(var/exception/error)
		context?.finish()
		throw error
	context?.finish()

/mob/living/carbon/human/species/bullet_act(obj/projectile/projectile, def_zone = BODY_ZONE_CHEST)
	var/datum/z121_rpg_damage_context/context = z121_rpg_begin_damage(projectile.firer)
	try
		. = ..()
	catch(var/exception/error)
		context?.finish()
		throw error
	context?.finish()

/mob/living/simple_animal/hostile/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	var/datum/z121_rpg_damage_context/context = z121_rpg_begin_explosion(epicenter)
	try
		. = ..()
	catch(var/exception/error)
		context?.finish()
		throw error
	context?.finish()

/mob/living/carbon/human/species/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	var/datum/z121_rpg_damage_context/context = z121_rpg_begin_explosion(epicenter)
	try
		. = ..()
	catch(var/exception/error)
		context?.finish()
		throw error
	context?.finish()
