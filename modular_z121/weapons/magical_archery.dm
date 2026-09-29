#define Z121_MAGIC_ARCHERY_GLOW "#8edcff"

// 继承长弓的显示位置，但使用反曲弓的射击参数。
/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic
	name = "魔弓"
	desc = "深黑的角质弓臂间游着几缕淡蓝微光，握柄已被掌心磨得温润。轻拨弓弦，余烬与薄霜的气息便在指间交替；角纹深处隐约传来第二道脉搏，悄悄抚平岁月留下的裂隙。"
	icon_state = "longbow_warden"
	heavy_bow = FALSE
	damfactor = 1
	accfactor = 1
	force = 10
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_HIP
	possible_item_intents = list(/datum/intent/shoot/bow/z121_magic, /datum/intent/arc/bow/z121_magic, INTENT_GENERIC)
	var/arrow_tier = 1
	var/tracking_enabled = FALSE
	var/arrow_element = "无"
	var/mixed_cost = FALSE
	var/next_blood_repair = 0
	var/datum/weakref/bound_mind_ref

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/Initialize(mapload)
	. = ..()
	add_filter("z121_magic_bow", 2, list("type" = "outline", "color" = Z121_MAGIC_ARCHERY_GLOW, "alpha" = 150, "size" = 1))

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/proc/clear_magic_arrow()
	var/list/arrows = get_ammo_list(TRUE, TRUE)
	for(var/obj/item/ammo_casing/arrow as anything in arrows)
		qdel(arrow)
	update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	bound_mind_ref = null
	clear_magic_arrow()
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(slot != SLOT_HANDS)
		STOP_PROCESSING(SSfastprocess, src)
		clear_magic_arrow()
	else
		next_blood_repair = world.time + 1 SECONDS
		START_PROCESSING(SSfastprocess, src)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/dropped(mob/user, silent = FALSE)
	STOP_PROCESSING(SSfastprocess, src)
	clear_magic_arrow()
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/attack_self(mob/living/user)
	if(!can_configure(user))
		return
	user.stop_attack()
	var/choice = input(user, "[configuration_text()]\n每箭：[cost_text()]\n切换只影响下一支凝聚的箭。", name) as null|anything in list("箭矢档位", "追踪开关", "元素选择", "消耗模式", "卸下魔矢")
	if(!choice || !can_configure(user))
		return
	var/selection
	switch(choice)
		if("箭矢档位")
			selection = input(user, "选择弦上锋芒的轻重。", name) as null|anything in list("一档·石箭", "二档·铁箭", "三档·黑钢箭")
		if("元素选择")
			selection = input(user, "让哪一种气息流入弓弦？", name) as null|anything in list("无", "火", "冰")
	if(!can_configure(user))
		return
	user.stop_attack()
	switch(choice)
		if("箭矢档位")
			if(!selection)
				return
			arrow_tier = list("一档·石箭", "二档·铁箭", "三档·黑钢箭").Find(selection)
		if("追踪开关")
			tracking_enabled = !tracking_enabled
		if("元素选择")
			if(!selection)
				return
			arrow_element = selection
		if("消耗模式")
			mixed_cost = !mixed_cost
		if("卸下魔矢")
			clear_magic_arrow()
			to_chat(user, span_notice("我松开凝箭的魔力，让弓上的魔矢消散。"))
			return
	to_chat(user, span_notice("[configuration_text()]；每箭：[cost_text()]。已搭箭的配置不变。"))

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/proc/can_configure(mob/living/user)
	return !QDELETED(src) && !QDELETED(user) && user.stat == CONSCIOUS && !user.incapacitated() && user.get_active_held_item() == src

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/proc/configuration_text()
	return "档位：[arrow_tier]；追踪：[tracking_enabled ? "开启" : "关闭"]；元素：[arrow_element]；消耗：[mixed_cost ? "魔力与血液" : "魔力"]"

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/proc/arrow_cost()
	var/list/tier_costs = list(5, 15, 30)
	return tier_costs[arrow_tier] + (tracking_enabled ? 20 : 0) + (arrow_element != "无" ? 10 : 0)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/proc/cost_text()
	var/total = arrow_cost()
	return mixed_cost ? "[total / 2]魔力＋[total / 2]血液" : "[total]魔力"

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/examine(mob/user)
	. = ..()
	. += span_info("[configuration_text()]；下支普通魔矢消耗：[cost_text()]。")
	. += span_info("手持自用可调弦或卸箭。握在手中时，每秒以1单位血液修复1点耐久，血液保留至少[BLOOD_VOLUME_OKAY]单位。")
	if(istype(chambered, /obj/item/ammo_casing/caseless/rogue/arrow/magic))
		var/obj/item/ammo_casing/caseless/rogue/arrow/magic/arrow = chambered
		. += span_info("已搭箭：[arrow.configuration]。")

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/proc/can_draw_blood(mob/living/user)
	if(!user || user.stat == DEAD || !user.get_blood_id())
		return FALSE
	if(iscarbon(user))
		var/mob/living/carbon/carbon_user = user
		if(NOBLOOD in carbon_user.dna?.species?.species_traits)
			return FALSE
	return TRUE

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/process()
	var/mob/living/holder = loc
	if(!istype(holder) || !(src in holder.held_items))
		return PROCESS_KILL
	if(world.time < next_blood_repair)
		return
	next_blood_repair = world.time + 1 SECONDS
	if(obj_destroyed || obj_integrity >= max_integrity || !can_draw_blood(holder))
		return
	var/repair_amount = min(1, max_integrity - obj_integrity, holder.get_blood_volume() - BLOOD_VOLUME_OKAY)
	if(repair_amount <= 0)
		return
	obj_integrity += repair_amount
	if(obj_broken && obj_integrity > integrity_failure * max_integrity)
		obj_fix(holder, FALSE)
	holder.adjust_blood_volume(-repair_amount)

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
	var/mana_cost = heartpiercing_energy
	var/blood_cost = 0
	if(heartpiercing_energy)
		if(heartpiercing_energy < 300 || istype(chambered, /obj/item/ammo_casing/caseless/rogue/arrow/magic/heartpiercing))
			return FALSE
	else
		if(chambered)
			return TRUE
		mana_cost = arrow_cost()
		if(mixed_cost)
			mana_cost /= 2
			blood_cost = mana_cost
		if(blood_cost && (!can_draw_blood(user) || user.get_blood_volume() - blood_cost < BLOOD_VOLUME_OKAY))
			to_chat(user, span_warning("我的血液已不足以回应弓弦。"))
			return FALSE
	if(user.energy < mana_cost)
		to_chat(user, span_warning("我的法力不足[mana_cost]点，无法凝聚魔矢。"))
		return FALSE
	var/arrow_type = heartpiercing_energy ? /obj/item/ammo_casing/caseless/rogue/arrow/magic/heartpiercing : /obj/item/ammo_casing/caseless/rogue/arrow/magic
	var/obj/item/ammo_casing/caseless/rogue/arrow/magic/arrow = new arrow_type(src)
	if(!arrow.BB)
		qdel(arrow)
		return FALSE
	if(heartpiercing_energy)
		arrow.base_damage = min(300, 100 + heartpiercing_energy / 10)
		arrow.configuration = "穿心箭；基础伤害[arrow.base_damage]，独立箭术"
	else
		// 凝箭时固定全部参数，已付费的箭不会随菜单改变或重复收费。
		var/list/templates = list(/obj/projectile/bullet/reusable/arrow/stone, /obj/projectile/bullet/reusable/arrow/iron, /obj/projectile/bullet/reusable/arrow/blacksteel)
		var/obj/projectile/template = templates[arrow_tier]
		arrow.base_damage = initial(template.damage)
		arrow.base_accuracy = initial(template.accuracy)
		arrow.base_penetration = initial(template.armor_penetration)
		arrow.tracking = tracking_enabled
		arrow.element = arrow_element
		arrow.configuration = "[configuration_text()]；已支付[cost_text()]"
		arrow.icon_state = arrow_tier == 3 ? "blacksteelarrow" : (arrow_tier == 2 ? "ironarrow" : "arrow")
	clear_magic_arrow()
	// 原版弓在射击前从内部箭仓取出弹药，因此同时登记已搭箭与箭仓。
	magazine.stored_ammo += arrow
	chambered = arrow
	user.energy_add(-mana_cost)
	if(blood_cost)
		user.adjust_blood_volume(-blood_cost)
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
	projectile.accuracy = arrow.base_accuracy
	projectile.armor_penetration = arrow.base_penetration
	projectile.bonus_accuracy = initial(projectile.bonus_accuracy)
	projectile.element = arrow.element
	projectile.damage_type = arrow.element == "火" ? BURN : BRUTE
	projectile.woundclass = arrow.element == "火" ? BCLASS_BURN : (arrow.element == "冰" ? BCLASS_BLUNT : BCLASS_PIERCE)
	if(arrow.tracking && !isturf(target) && !projectile.valid_tracking_target(target, user))
		to_chat(user, span_warning("追踪箭只能锁定同层十五格内可见的目标。"))
		return FALSE
	. = ..()
	// 原版弓在结算前清空箭仓；失败时恢复登记，保留已付费的箭。
	if(!. && !QDELETED(arrow) && chambered == arrow)
		magazine.stored_ammo |= arrow

/datum/intent/shoot/bow/z121_magic/can_charge(atom/clicked_object)
	// 原版鼠标入口没有把点击对象传给蓄力检查，须取回本次按下的对象。
	if(!clicked_object)
		clicked_object = mastermob?.client?.tcompare
	// 点击弓打开菜单不能预先凝箭，否则新设置会被已搭箭的旧配置覆盖。
	if(clicked_object == masteritem || istype(clicked_object, /atom/movable/screen))
		return FALSE
	if(!..(clicked_object))
		return FALSE
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/bow = masteritem
	return istype(bow) && bow.nock_magic_arrow(mastermob)

/datum/intent/arc/bow/z121_magic/can_charge(atom/clicked_object)
	// 弧射同样要排除自用菜单与界面点击，不在调整模式时生成普通箭。
	if(!clicked_object)
		clicked_object = mastermob?.client?.tcompare
	if(clicked_object == masteritem || istype(clicked_object, /atom/movable/screen))
		return FALSE
	if(!..(clicked_object))
		return FALSE
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/bow = masteritem
	return istype(bow) && bow.nock_magic_arrow(mastermob)

/obj/item/ammo_casing/caseless/rogue/arrow/magic
	name = "魔矢"
	desc = "一线冷光绷在弦上，箭羽似有若无。目光稍一移开，它的轮廓便散得像一口薄雾。"
	projectile_type = /obj/projectile/bullet/z121_magic_arrow
	var/base_damage = 20
	var/base_accuracy = 60
	var/base_penetration = 10
	var/tracking = FALSE
	var/element = "无"
	var/configuration = "普通魔矢"

/obj/item/ammo_casing/caseless/rogue/arrow/magic/Destroy()
	QDEL_NULL(BB)
	return ..()

/obj/item/ammo_casing/caseless/rogue/arrow/magic/fire_casing(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, atom/fired_from)
	// 生物和假人等物体都直接结算，只有未启用追踪或瞄准地面才使用弹道。
	if(!tracking || isturf(target))
		return ..()
	var/obj/projectile/bullet/z121_magic_arrow/projectile = BB
	if(QDELETED(projectile) || !projectile.valid_tracking_target(target, user))
		return FALSE
	ready_proj(target, user, quiet, zone_override, fired_from)
	// 仅保留伤害结算载体，不放到地图上，也不调用发射或像素弹道准备函数。
	BB = null
	projectile.moveToNullspace()
	projectile.starting = get_turf(user)
	if(isliving(target))
		projectile.tracking_hit(target)
	else
		projectile.tracking_hit_object(target)
	qdel(projectile)
	// 与普通箭保持相同的射击节奏，由弓的父级完成声音及箭仓清理。
	user.changeNext_move(click_cooldown_override ? click_cooldown_override : CLICK_CD_RANGE)
	return TRUE

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
	var/element = "无"

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
	if(QDELETED(target) || QDELETED(user) || !(isliving(target) || isobj(target)) || istype(target, /atom/movable/screen))
		return FALSE
	return target.z == user.z && get_dist(user, target) <= 15 && (target in view(15, user))

/obj/projectile/bullet/z121_magic_arrow/proc/tracking_hit_object(obj/target)
	// 假人属于物体；直接减少其耐久，不调用碰撞或弹道，也不选取沿途障碍。
	on_hit(target)
	if(QDELETED(target))
		return
	log_combat(firer, target, "directly hit with a tracking arrow", src)
	playsound(get_turf(target), hitsound, vol_by_damage(), TRUE, -1)
	target.visible_message(span_danger("[src]直接击中了[target]！"))
	// 保留物体自身的护甲、不可摧毁标记及破损处理，不使用生物的伤害倍率。
	target.take_damage(damage, damage_type, flag, FALSE, get_dir(target, starting), armor_penetration)

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
	var/datum/z121_magic_arrow_hit/hit = new(target, element)
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
	hit.finish()

/obj/projectile/bullet/z121_magic_arrow/heartpiercing
	name = "穿心箭"

// 在完整命中流程返回后确认实际损伤；跟踪器独立存在，投射物删除也不会丢失结算。
/obj/projectile/bullet/z121_magic_arrow/process_hit(turf/T, atom/target, qdel_self, hit_something = FALSE)
	var/datum/z121_magic_arrow_hit/hit
	if(isliving(target) && (element != "无" || istype(src, /obj/projectile/bullet/z121_magic_arrow/heartpiercing)))
		hit = new(target, element, istype(src, /obj/projectile/bullet/z121_magic_arrow/heartpiercing))
	. = ..()
	hit?.finish()

/obj/projectile/bullet/z121_magic_arrow/fire(angle, atom/direct_target)
	var/datum/z121_magic_arrow_hit/hit
	if(isliving(direct_target) && (element != "无" || istype(src, /obj/projectile/bullet/z121_magic_arrow/heartpiercing)))
		hit = new(direct_target, element, istype(src, /obj/projectile/bullet/z121_magic_arrow/heartpiercing))
	. = ..()
	hit?.finish()

/datum/z121_magic_arrow_hit
	var/mob/living/victim
	var/damage_zone
	var/health_before
	var/damage_before
	var/element
	var/heartpiercing

/datum/z121_magic_arrow_hit/New(mob/living/target, arrow_element = "无", is_heartpiercing = FALSE)
	victim = target
	health_before = target.health
	damage_before = target.getBruteLoss() + target.getFireLoss()
	element = arrow_element
	heartpiercing = is_heartpiercing
	RegisterSignal(target, COMSIG_MOB_APPLY_DAMGE, PROC_REF(capture_damage_zone))

/datum/z121_magic_arrow_hit/proc/capture_damage_zone(mob/living/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(damage > 0 && (damagetype == BRUTE || damagetype == BURN))
		damage_zone = def_zone ? def_zone : BODY_ZONE_CHEST

/datum/z121_magic_arrow_hit/proc/finish()
	if(!QDELETED(victim) && damage_zone && (victim.health < health_before || victim.getBruteLoss() + victim.getFireLoss() > damage_before))
		if(heartpiercing)
			if(iscarbon(victim))
				var/mob/living/carbon/carbon_victim = victim
				var/obj/item/bodypart/part = isbodypart(damage_zone) ? damage_zone : carbon_victim.get_bodypart(check_zone(damage_zone))
				part?.add_wound(/datum/wound/puncture/z121_heartpiercing)
			else
				victim.simple_add_wound(/datum/wound/puncture/z121_heartpiercing)
		else if(element == "火")
			victim.adjust_fire_stacks(1)
			victim.ignite_mob()
		else if(element == "冰")
			victim.apply_status_effect(/datum/status_effect/z121_arrow_frost)
	qdel(src)

/datum/z121_magic_arrow_hit/Destroy()
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
