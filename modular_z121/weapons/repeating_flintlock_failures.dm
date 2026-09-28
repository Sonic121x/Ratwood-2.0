// 按完整停火周期衰减，保留不足五秒的余数；查看、装填和换手不重置计时。
/obj/item/gun/ballistic/z121_repeating_flintlock/proc/update_failure_decay()
	if(failure_points <= 0)
		return
	var/periods = round((world.time - failure_decay_time) / failure_decay_interval)
	if(periods <= 0)
		return
	failure_points = max(0, failure_points - periods)
	failure_decay_time += periods * failure_decay_interval

/obj/item/gun/ballistic/z121_repeating_flintlock/proc/failure_tier()
	if(failure_points <= 0)
		return 0
	if(failure_points <= 2)
		return 1
	if(failure_points <= 5)
		return 2
	return 3

/obj/item/gun/ballistic/z121_repeating_flintlock/proc/failure_description()
	switch(failure_tier())
		if(0)
			return "机构运转平稳。"
		if(1)
			return "机构略微发热。"
		if(2)
			return "齿轮声变得急促。"
		if(3)
			return "机构发烫并伴有异常震颤！"

/obj/item/gun/ballistic/z121_repeating_flintlock/proc/record_ignition(mob/user)
	update_failure_decay()
	var/old_tier = failure_tier()
	failure_points++
	failure_decay_time = world.time
	if(failure_tier() > old_tier && user?.is_holding(src))
		to_chat(user, span_warning(failure_description()))

// 只在通过全部开火检查后触发；散射不经过普通击发流程，因此不会递归判定故障。
/obj/item/gun/ballistic/z121_repeating_flintlock/proc/burst_barrel(mob/living/user)
	if(bursting || QDELETED(src))
		return
	bursting = TRUE
	firing = TRUE
	operating = TRUE
	var/turf/origin = get_turf(src)
	var/mob/living/carbon/holder
	if(iscarbon(loc))
		var/mob/living/carbon/candidate = loc
		if(candidate.is_holding(src))
			holder = candidate

	// 一次性分离膛内弹与弹仓弹，列表取并集以防同一弹药被重复处理。
	var/list/rounds = list()
	if(chambered)
		rounds |= chambered
		chambered = null
	if(magazine)
		rounds |= magazine.ammo_list(TRUE)
	var/list/projectiles = list()
	for(var/obj/item/ammo_casing/round in rounds)
		if(QDELETED(round))
			continue
		if(origin && powder_charges > 0 && istype(round, /obj/item/ammo_casing/caseless/bullet/lead) && !QDELETED(round.BB))
			var/obj/projectile/projectile = round.BB
			round.BB = null
			projectile.forceMove(origin)
			projectiles += projectile
			powder_charges--
		// 未被点燃的铅弹与空弹壳也随枪械销毁，不能掉落回收。
		QDEL_NULL(round.BB)
		qdel(round)
	powder_charges = 0
	QDEL_NULL(magazine)

	visible_message(span_danger("[src]的枪膛猛然炸裂，铅弹向四面八方飞散！"))
	var/scattered = length(projectiles)
	var/start_angle = rand(0, 359)
	for(var/index in 1 to scattered)
		var/obj/projectile/projectile = projectiles[index]
		projectile.firer = user
		projectile.fired_from = src
		projectile.original = origin
		projectile.starting = origin
		projectile.target_z = origin.z
		projectile.def_zone = BODY_ZONE_CHEST
		projectile.arcshot = FALSE
		// 发射信号应用同一份伤害与材质修正，每颗弹丸只应用一次。
		projectile.fire((start_angle + (index - 1) * 360 / scattered) % 360)

	var/limb_result = burst_remove_arms(holder)
	var/burst_log = "连发燧枪炸膛；位置：[loc_name(origin)]；操作者：[key_name(user)]；持枪者：[key_name(holder)]；散射：[scattered] 发；断肢结果：[limb_result]。"
	log_game(burst_log)
	if(user)
		user.log_message(burst_log, LOG_ATTACK, color = LOG_COLOR_SEVERE)
	// 爆炸内部异步执行，保存地面位置使删除枪械不会中断爆炸。
	if(origin)
		explosion(origin, devastation_range = -1, heavy_impact_range = -1, light_impact_range = 1, flash_range = 1, flame_range = 0, smoke = TRUE)
	qdel(src)

// 炸膛强制断臂，只保留管理员无敌保护；不调用会受护甲和重创抵抗拦截的断肢判定。
/obj/item/gun/ballistic/z121_repeating_flintlock/proc/burst_remove_arms(mob/living/carbon/holder)
	if(QDELETED(holder))
		return "无具有手臂的实际持枪者"
	if(holder.status_flags & GODMODE)
		return "管理员无敌保护，手臂保留"
	var/list/severed = list()
	for(var/zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		var/obj/item/bodypart/arm = holder.get_bodypart(zone)
		if(QDELETED(arm))
			continue
		var/arm_name = arm.name
		var/wound_type = arm.dismember_wound
		var/list/limb_sounds = arm.dismemsound
		// 普通移除保留原肢体并处理持物掉落、手铐、手套及角色外观。
		if(!arm.drop_limb())
			continue
		severed += arm_name
		var/obj/item/bodypart/chest = holder.get_bodypart(BODY_ZONE_CHEST)
		if(chest && wound_type && !isooze(holder))
			chest.add_wound(wound_type)
		if(!QDELETED(arm) && !(NOBLOOD in holder.dna?.species?.species_traits) && !(INVISBLOOD in holder.dna?.species?.species_traits))
			arm.add_mob_blood(holder)
		if(length(limb_sounds))
			playsound(holder, pick(limb_sounds), 50, FALSE, -1)
		holder.visible_message(span_danger("[holder]的[arm_name]被炸膛的冲击撕断了！"), span_userdanger("我的[arm_name]被炸断了！"))
		INVOKE_ASYNC(holder, TYPE_PROC_REF(/mob/living/carbon, delimb_pain))
	if(!length(severed))
		return "没有可移除的手臂"
	holder.add_stress(/datum/stressevent/dismembered)
	// 沿用目睹断肢的精神影响，保持钢铁意志与失明的既有豁免。
	if(holder.mind)
		for(var/mob/living/carbon/witness in hearers(world.view, holder))
			if(witness != holder && !HAS_TRAIT(witness, TRAIT_BLIND) && !HAS_TRAIT(witness, TRAIT_STEELHEARTED))
				witness.add_stress(/datum/stressevent/viewdismember)
	return jointext(severed, "、")
