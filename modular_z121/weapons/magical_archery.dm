#define Z121_MAGIC_ARCHERY_GLOW "#8edcff"

// 继承长弓的显示位置，但使用反曲弓的射击参数。
/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic
	name = "魔弓"
	desc = "深黑的角质弓臂间游着几缕淡蓝微光，握柄已被掌心磨得温润。轻拨弓弦，指节深处便传来一阵凉意，仿佛有什么正等着随这一声轻响离去。"
	icon_state = "longbow_warden"
	heavy_bow = FALSE
	damfactor = 1
	accfactor = 1
	force = 10
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_HIP
	possible_item_intents = list(/datum/intent/shoot/bow/z121_magic, /datum/intent/arc/bow/z121_magic, INTENT_GENERIC)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/Initialize(mapload)
	. = ..()
	add_filter("z121_magic_bow", 2, list("type" = "outline", "color" = Z121_MAGIC_ARCHERY_GLOW, "alpha" = 150, "size" = 1))

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/proc/clear_magic_arrow()
	var/list/arrows = get_ammo_list(TRUE, TRUE)
	for(var/obj/item/ammo_casing/arrow as anything in arrows)
		qdel(arrow)
	update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/Destroy()
	clear_magic_arrow()
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(slot != SLOT_HANDS)
		clear_magic_arrow()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/dropped(mob/user, silent = FALSE)
	clear_magic_arrow()
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/attack_self(mob/living/user)
	clear_magic_arrow()
	to_chat(user, span_notice("我松开凝箭的魔力，让弓上的魔矢消散。"))

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/pre_attack(atom/target, mob/living/user, params)
	// 普通箭袋会先移出箭矢再调用装填，必须在该步骤之前拦截。
	if(istype(target, /obj/item/quiver))
		to_chat(user, span_warning("魔弓会自行凝箭，不需要从箭袋取箭。"))
		return TRUE
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/ammo_casing) || istype(item, /obj/item/ammo_box) || istype(item, /obj/item/quiver))
		to_chat(user, span_warning("魔弓只能搭载自身凝聚的魔矢。"))
		return
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/proc/nock_magic_arrow(mob/living/user, heartpiercing_energy = 0)
	if(QDELETED(user) || user.get_active_held_item() != src || !magazine)
		return FALSE
	if(heartpiercing_energy)
		if(istype(chambered, /obj/item/ammo_casing/caseless/rogue/arrow/magic/heartpiercing))
			return FALSE
	else
		if(chambered)
			return TRUE
		if(user.energy < 10)
			to_chat(user, span_warning("我的法力不足十点，无法凝聚魔矢。"))
			return FALSE
	var/arrow_type = heartpiercing_energy ? /obj/item/ammo_casing/caseless/rogue/arrow/magic/heartpiercing : /obj/item/ammo_casing/caseless/rogue/arrow/magic
	var/obj/item/ammo_casing/caseless/rogue/arrow/magic/arrow = new arrow_type(src)
	if(!arrow.BB)
		qdel(arrow)
		return FALSE
	if(heartpiercing_energy)
		arrow.base_damage = min(300, 100 + heartpiercing_energy / 10)
	clear_magic_arrow()
	// 原版弓在射击前从内部箭仓取出弹药，因此同时登记已搭箭与箭仓。
	magazine.stored_ammo += arrow
	chambered = arrow
	user.energy_add(-(heartpiercing_energy ? heartpiercing_energy : 10))
	playsound(src, load_sound, 50, TRUE)
	update_icon()
	return TRUE

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/process_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	clear_magic_arrow()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(QDELETED(user) || !user.client || user.get_active_held_item() != src || !istype(chambered, /obj/item/ammo_casing/caseless/rogue/arrow/magic))
		return FALSE
	var/obj/item/ammo_casing/caseless/rogue/arrow/magic/arrow = chambered
	var/obj/projectile/bullet/z121_magic_arrow/projectile = arrow.BB
	if(QDELETED(projectile))
		return FALSE
	// 每次尝试均从基础数值重新计算，射击失败不会累乘伤害或精度。
	projectile.damage = arrow.base_damage
	projectile.accuracy = initial(projectile.accuracy)
	projectile.bonus_accuracy = initial(projectile.bonus_accuracy)
	if(!istype(arrow, /obj/item/ammo_casing/caseless/rogue/arrow/magic/heartpiercing))
		if(user.has_status_effect(/datum/status_effect/buff/z121_empowered_arrows))
			var/obj/projectile/bullet/reusable/arrow/iron/iron_template = /obj/projectile/bullet/reusable/arrow/iron
			projectile.damage = initial(iron_template.damage)
		projectile.tracking = user.has_status_effect(/datum/status_effect/buff/z121_tracking_arrows) ? TRUE : FALSE
		if(projectile.tracking && isliving(target) && !projectile.valid_tracking_target(target, user))
			to_chat(user, span_warning("追踪箭只能锁定同层十五格内可见的目标。"))
			return FALSE
	. = ..()
	// 原版弓在结算前清空箭仓；失败时恢复登记，保留已付费的箭。
	if(!. && !QDELETED(arrow) && chambered == arrow)
		magazine.stored_ammo |= arrow

/datum/intent/shoot/bow/z121_magic/can_charge(atom/clicked_object)
	if(!..())
		return FALSE
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/bow = masteritem
	return istype(bow) && bow.nock_magic_arrow(mastermob)

/datum/intent/arc/bow/z121_magic/can_charge(atom/clicked_object)
	if(!..())
		return FALSE
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/bow = masteritem
	return istype(bow) && bow.nock_magic_arrow(mastermob)

/obj/item/ammo_casing/caseless/rogue/arrow/magic
	name = "魔矢"
	desc = "一线冷光绷在弦上，箭羽似有若无。目光稍一移开，它的轮廓便散得像一口薄雾。"
	projectile_type = /obj/projectile/bullet/z121_magic_arrow
	var/base_damage = 20

/obj/item/ammo_casing/caseless/rogue/arrow/magic/Destroy()
	QDEL_NULL(BB)
	return ..()

/obj/item/ammo_casing/caseless/rogue/arrow/magic/throw_proj(atom/target, turf/targloc, mob/living/user, params, spread)
	var/obj/projectile/bullet/z121_magic_arrow/projectile = BB
	if(projectile?.tracking && isliving(target))
		if(!projectile.valid_tracking_target(target, user))
			return FALSE
		// 先解除弹壳引用，防止命中回调删除弓时连带删除正在结算的投射物。
		BB = null
		projectile.forceMove(get_turf(user))
		projectile.starting = get_turf(user)
		projectile.tracking_hit(target)
		qdel(projectile)
		return TRUE
	return ..()

/obj/item/ammo_casing/caseless/rogue/arrow/magic/heartpiercing
	name = "穿心箭"
	desc = "弦上的光收束得极细，连余辉都不肯漏出。握弓的手已觉空乏，那一点锋芒却仍在缓缓搏动。"
	projectile_type = /obj/projectile/bullet/z121_magic_arrow/heartpiercing

// 直接继承不可回收的投射物，杜绝命中、格挡和射程终点生成实体箭。
/obj/projectile/bullet/z121_magic_arrow
	name = "魔矢"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_proj"
	damage = 20
	damage_type = BRUTE
	armor_penetration = 10
	accuracy = 60
	npc_simple_damage_mult = 2
	embedchance = 0
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	range = 15
	speed = 0.4
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	hitsound_wall = null
	impact_effect_type = null
	var/tracking = FALSE

/obj/projectile/bullet/z121_magic_arrow/Initialize(mapload)
	. = ..()
	add_filter("z121_magic_arrow", 2, list("type" = "outline", "color" = Z121_MAGIC_ARCHERY_GLOW, "alpha" = 170, "size" = 1))

/obj/projectile/bullet/z121_magic_arrow/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/mob/living/archer = firer
	if(istype(archer) && archer.mind && isliving(target))
		var/mob/living/victim = target
		if(victim.stat != DEAD && can_train_combat_skill(archer, /datum/skill/combat/bows, SKILL_LEVEL_EXPERT))
			archer.mind.add_sleep_experience(/datum/skill/combat/bows, archer.STAINT * 4)

/obj/projectile/bullet/z121_magic_arrow/proc/valid_tracking_target(atom/target, mob/living/user)
	return !QDELETED(target) && !QDELETED(user) && isliving(target) && target.z == user.z && get_dist(user, target) <= 15 && (target in view(15, user))

/obj/projectile/bullet/z121_magic_arrow/proc/tracking_hit(mob/living/target)
	// 跳过弹道与防御命中检查，但复用原版穿刺护甲、伤害和伤口接口。
	if(isliving(firer))
		if(ishuman(target))
			var/mob/living/carbon/human/human_target = target
			human_target.retaliate(firer)
		else if(istype(target, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/hostile_target = target
			if(hostile_target.stat == CONSCIOUS && !hostile_target.target && hostile_target.AIStatus != NPC_AI_OFF && !hostile_target.client)
				if(get_dist(hostile_target, firer) <= hostile_target.aggro_vision_range)
					hostile_target.next_seek = 0
					hostile_target.next_full_seek = 0
					hostile_target.FindTarget(list(firer), 1)
				hostile_target.Goto(starting, hostile_target.move_to_delay, 3)
	var/zone = def_zone ? def_zone : BODY_ZONE_CHEST
	var/armor = target.run_armor_check(zone, flag, "", "", armor_penetration = armor_penetration, damage = damage, used_weapon = src)
	target.next_attack_msg.Cut()
	on_hit(target, armor)
	if(target.apply_damage(damage, damage_type, zone, armor))
		target.check_projectile_wounding(src, zone, armor)
		playsound(target, hitsound, vol_by_damage(), TRUE, -1)
	else
		target.next_attack_msg += " 护甲挡住了伤害。"
	target.visible_message(span_danger("[src]直接击中了[target]的[target.hit_zone_name(zone)]！[target.next_attack_msg.Join()]"), span_danger("[src]直接击中了我的[target.hit_zone_name(zone)]！[target.next_attack_msg.Join()]"))
	target.next_attack_msg.Cut()

/obj/projectile/bullet/z121_magic_arrow/heartpiercing
	name = "穿心箭"

// 在完整命中流程返回后确认实际损伤；跟踪器独立存在，投射物删除也不会丢失结算。
/obj/projectile/bullet/z121_magic_arrow/heartpiercing/process_hit(turf/T, atom/target, qdel_self, hit_something = FALSE)
	var/datum/z121_heartpiercing_hit/hit
	if(isliving(target))
		hit = new(target)
	. = ..()
	hit?.finish()

/obj/projectile/bullet/z121_magic_arrow/heartpiercing/fire(angle, atom/direct_target)
	var/datum/z121_heartpiercing_hit/hit
	if(isliving(direct_target))
		hit = new(direct_target)
	. = ..()
	hit?.finish()

/datum/z121_heartpiercing_hit
	var/mob/living/victim
	var/damage_zone
	var/health_before
	var/brute_before

/datum/z121_heartpiercing_hit/New(mob/living/target)
	victim = target
	health_before = target.health
	brute_before = target.getBruteLoss()
	RegisterSignal(target, COMSIG_MOB_APPLY_DAMGE, PROC_REF(capture_damage_zone))

/datum/z121_heartpiercing_hit/proc/capture_damage_zone(mob/living/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(damage > 0 && damagetype == BRUTE)
		damage_zone = def_zone ? def_zone : BODY_ZONE_CHEST

/datum/z121_heartpiercing_hit/proc/finish()
	if(!QDELETED(victim) && damage_zone && (victim.health < health_before || victim.getBruteLoss() > brute_before))
		if(iscarbon(victim))
			var/mob/living/carbon/carbon_victim = victim
			var/obj/item/bodypart/part = isbodypart(damage_zone) ? damage_zone : carbon_victim.get_bodypart(check_zone(damage_zone))
			part?.add_wound(/datum/wound/puncture/z121_heartpiercing)
		else
			victim.simple_add_wound(/datum/wound/puncture/z121_heartpiercing)
	qdel(src)

/datum/z121_heartpiercing_hit/Destroy()
	if(victim)
		UnregisterSignal(victim, COMSIG_MOB_APPLY_DAMGE)
	victim = null
	return ..()

/datum/wound/puncture/z121_heartpiercing
	name = "穿心重创"
	severity = WOUND_SEVERITY_CRITICAL
	whp = 100
	sewn_whp = 25
	bleed_rate = 50
	sewn_bleed_rate = 0.5
	clotting_rate = 0
	clotting_threshold = null
	sewn_clotting_rate = 0.01
	sewn_clotting_threshold = 0.1
	woundpain = 50
	sewn_woundpain = 20
	sew_threshold = 100
	critical = TRUE

#undef Z121_MAGIC_ARCHERY_GLOW
