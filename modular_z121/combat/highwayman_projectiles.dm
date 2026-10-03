// 终结技沿用米莉手枪的弹道与穿甲，只替换该发弹丸伤害。
/obj/item/gun/ballistic/z121_millicombat_pistol/proc/z121_highwayman_load()
	var/datum/component/z121_highwayman_weapon/W = z121_highwayman_weapon
	if(!W?.finisher || W.controller?.fighter != loc || operating || firing || firing_stage)
		return FALSE
	var/mob/living/user = W.controller.fighter
	if(!user.is_holding(src) || user.stat == DEAD || !W.controller.enforce_armor())
		return FALSE
	// 免费装填只在准备终结技时执行一次；重复调用仅检查现有弹药。
	if(W.finisher_load_used)
		return can_shoot()
	// 弹丸仍在飞行时不能先补出第二颗，避免命中消耗武技后遗留免费弹药。
	if(W.flying_bullet?.resolve() && !chambered?.BB)
		return FALSE
	W.finisher_load_used = TRUE
	if(!chambered?.BB)
		QDEL_NULL(chambered)
		chamber_round()
		if(!chambered?.BB)
			QDEL_NULL(chambered)
			chambered = new /obj/item/ammo_casing/caseless/bullet/lead(src)
			W.z121_generated_round = chambered
	gunpowder = TRUE
	update_icon()
	return TRUE

/obj/item/gun/ballistic/z121_millicombat_pistol/proc/z121_highwayman_prepare_shot(atom/target, mob/living/user)
	var/datum/component/z121_highwayman_weapon/W = z121_highwayman_weapon
	if(!W?.finisher)
		return TRUE
	if(!W.controller?.enforce_armor())
		return FALSE
	if(W.controller?.fighter != user || user.get_active_held_item() != src || !user.used_intent?.tranged || HAS_TRAIT(user, TRAIT_PACIFISM))
		return FALSE
	if(W.flying_bullet?.resolve())
		to_chat(user, span_warning("上一发终结弹尚未落定。"))
		return FALSE
	var/distance = W.skill_id == Z121_HW_CLOSE ? 1 : (W.skill_id == Z121_HW_SWEEP ? 3 : 8)
	if(!isliving(target) || target == user || target.z != user.z || get_dist(target, user) > distance)
		to_chat(user, span_warning("终结技必须瞄准[distance]格内的活体目标。"))
		return FALSE
	var/mob/living/victim = target
	if(victim.stat == DEAD || !can_shoot())
		return FALSE
	QDEL_NULL(chambered.BB)
	var/obj/projectile/bullet/firearm/lead/z121_highwayman/P = new(get_turf(src))
	P.preparation_ref = WEAKREF(W)
	P.skill_id = W.skill_id
	P.skill_range = distance
	P.base_gun_damage = projectile_damage
	P.base_gun_penetration = projectile_penetration
	chambered.BB = P
	W.flying_bullet = WEAKREF(P)
	return TRUE

/obj/projectile/bullet/firearm/lead/z121_highwayman
	name = "终结弹"
	// 技能补出的铅弹不能嵌入、掉落或被取出作为额外物资。
	embedchance = 0
	ammo_type = null
	var/datum/weakref/preparation_ref
	var/skill_id
	var/skill_range = 8
	var/base_gun_damage = 40
	var/base_gun_penetration = 60
	var/resolved = FALSE
	var/atom/observed_target
	var/atom/body_hit_target

/obj/projectile/bullet/firearm/lead/z121_highwayman/proc/configure_shot()
	damage = base_gun_damage * (skill_id == Z121_HW_SWEEP ? 0.8 : (skill_id == Z121_HW_AIM ? 1.5 : 1))
	armor_penetration = base_gun_penetration
	range = skill_range
	arcshot = FALSE

/obj/projectile/bullet/firearm/lead/z121_highwayman/prehit(atom/target)
	var/datum/component/z121_highwayman_weapon/W = preparation_ref?.resolve()
	if(!W || W.controller?.fighter != firer || !W.controller.enforce_armor())
		damage = base_gun_damage
		preparation_ref = null
	if(observed_target)
		UnregisterSignal(observed_target, COMSIG_ATOM_BULLET_ACT)
	observed_target = target
	body_hit_target = null
	if(isliving(target))
		RegisterSignal(target, COMSIG_ATOM_BULLET_ACT, PROC_REF(mark_body_hit))
	return ..()

// 护甲数值恰好为一百仍算命中；盾牌拦截不会发出身体受弹信号。
/obj/projectile/bullet/firearm/lead/z121_highwayman/proc/mark_body_hit(datum/source, obj/projectile/P, zone)
	SIGNAL_HANDLER
	if(P == src)
		body_hit_target = source

/obj/projectile/bullet/firearm/lead/z121_highwayman/on_hit(atom/target, blocked = FALSE)
	var/datum/component/z121_highwayman_weapon/W = preparation_ref?.resolve()
	var/mob/living/shooter = firer
	var/mob/living/victim = target
	if(!W || W.controller?.fighter != shooter || !W.controller.enforce_armor())
		damage = base_gun_damage
		W = null
	var/trigger = !resolved && W && istype(victim) && victim.stat != DEAD && victim != shooter && (blocked != 100 || body_hit_target == target)
	. = ..()
	if(!trigger || QDELETED(W))
		return
	resolved = TRUE
	var/datum/component/z121_highwayman/C = W.controller
	// 命中消耗发生在射击调用链中，膛内弹交给枪械原流程销毁。
	W.z121_generated_round = null
	qdel(W)
	C.reset_minor_cooldowns()
	var/turf/impact = get_turf(victim)
	if(skill_id == Z121_HW_CLOSE)
		victim.drop_all_held_items()
		var/direction = get_dir(impact, get_turf(shooter))
		if(!direction)
			direction = turn(shooter.dir, 180)
		for(var/i in 1 to 2)
			var/turf/origin = get_turf(shooter)
			var/turf/destination = get_step(origin, direction)
			if(!z121_highwayman_clear_step(origin, destination, shooter) || !shooter.Move(destination, direction))
				break
	else if(skill_id == Z121_HW_SWEEP)
		victim.OffBalance(3 SECONDS)
		for(var/mob/living/other in range(1, impact))
			if(other == shooter || other == victim || other.stat == DEAD || !z121_highwayman_clear_shot(impact, get_turf(other)))
				continue
			// 次级弹仅结算一次原生枪伤，不再扩散或刷新技能。
			var/obj/projectile/bullet/firearm/lead/z121_highwayman_scatter/S = new(impact)
			S.damage = base_gun_damage * 0.8
			S.armor_penetration = base_gun_penetration
			S.firer = shooter
			S.original = other
			S.starting = starting
			S.def_zone = def_zone
			S.RegisterSignal(other, COMSIG_ATOM_BULLET_ACT, TYPE_PROC_REF(/obj/projectile/bullet/firearm/lead/z121_highwayman_scatter, mark_body_hit))
			other.bullet_act(S, def_zone)
			qdel(S)
	log_combat(shooter, victim, "终结技命中", addition = skill_id)

/obj/projectile/bullet/firearm/lead/z121_highwayman_scatter
	name = "霰弹"
	embedchance = 0
	ammo_type = null
	var/atom/body_hit_target

/obj/projectile/bullet/firearm/lead/z121_highwayman_scatter/proc/mark_body_hit(datum/source, obj/projectile/P, zone)
	SIGNAL_HANDLER
	if(P == src)
		body_hit_target = source

/obj/projectile/bullet/firearm/lead/z121_highwayman_scatter/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target) && (blocked != 100 || body_hit_target == target))
		var/mob/living/L = target
		L.OffBalance(3 SECONDS)

/proc/z121_highwayman_clear_shot(turf/origin, turf/destination)
	if(!origin || !destination || origin.z != destination.z)
		return FALSE
	if(abs(origin.x - destination.x) == 1 && abs(origin.y - destination.y) == 1)
		if(!z121_highwayman_clear_shot(origin, locate(destination.x, origin.y, origin.z)) || !z121_highwayman_clear_shot(origin, locate(origin.x, destination.y, origin.z)))
			return FALSE
	for(var/turf/T as anything in getline(origin, destination))
		if(T.density)
			return FALSE
		for(var/atom/movable/A in T)
			if(A.density && !isliving(A) && !istype(A, /obj/projectile))
				return FALSE
	return TRUE
