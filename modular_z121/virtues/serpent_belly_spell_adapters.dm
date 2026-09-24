// 蛇腹者的腹内施法适配：保存攻击来源与宿主判定，沿用法术原有伤害和时长。

/obj/effect/proc_holder/spell/proc/z121_serpent_base_cast(list/targets, mob/user)
	SEND_SIGNAL(user, COMSIG_MOB_CAST_SPELL)
	record_featured_object_stat(FEATURED_STATS_SPELLS, name)
	return TRUE

/obj/effect/proc_holder/spell/invoked/projectile/fire_projectile(mob/living/user, atom/target)
	if(!z121_serpent_cast)
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
		P.z121_serpent_cast = z121_serpent_cast
		P.fire()
	return TRUE

/obj/projectile/proc/z121_serpent_status_snapshot(list/targets, list/effect_types)
	var/list/snapshot = list()
	for(var/mob/living/target as anything in targets)
		var/list/effects = list()
		for(var/effect_type in effect_types)
			var/datum/status_effect/effect = target.has_status_effect(effect_type)
			effects[effect_type] = list(effect, effect?.duration)
		snapshot[target] = effects
	return snapshot

/obj/projectile/proc/z121_serpent_finish_statuses(list/snapshot)
	for(var/mob/living/target as anything in snapshot)
		if(QDELETED(target))
			continue
		var/list/effects = snapshot[target]
		for(var/effect_type in effects)
			var/datum/status_effect/effect = target.has_status_effect(effect_type)
			var/list/previous = effects[effect_type]
			if(!effect || (effect == previous[1] && effect.duration == previous[2]))
				continue
			effect.z121_serpent_cast = z121_serpent_cast

/obj/projectile/magic/acidsplash/on_hit(atom/target, blocked = FALSE)
	if(!z121_serpent_cast)
		return ..()
	var/list/victims = list()
	for(var/mob/living/L in range(aoe_range, get_turf(src)))
		victims += L
	var/list/snapshot = z121_serpent_status_snapshot(victims, list(/datum/status_effect/buff/acidsplash))
	. = ..()
	z121_serpent_finish_statuses(snapshot)

/datum/status_effect/buff/acidsplash/tick()
	if(z121_serpent_cast?.blocks(owner))
		return
	return ..()

/obj/projectile/magic/frostbolt/on_hit(target)
	if(!z121_serpent_cast)
		return ..()
	var/list/snapshot = z121_serpent_status_snapshot(isliving(target) ? list(target) : list(), list(/datum/status_effect/buff/frost, /datum/status_effect/buff/frostbite))
	. = ..()
	z121_serpent_finish_statuses(snapshot)

/obj/projectile/magic/lightning/on_hit(target)
	if(!z121_serpent_cast)
		return ..()
	var/list/snapshot = z121_serpent_status_snapshot(isliving(target) ? list(target) : list(), list(/datum/status_effect/debuff/clickcd, /datum/status_effect/buff/lightningstruck, /datum/status_effect/incapacitating/immobilized))
	. = ..()
	z121_serpent_finish_statuses(snapshot)

/obj/effect/temp_visual/target/Initialize(mapload, list/flame_hit, datum/z121_serpent_cast/context = null)
	z121_serpent_cast = context
	return ..()

/obj/effect/temp_visual/targetlightning/Initialize(mapload, list/flame_hit, datum/z121_serpent_cast/context = null)
	z121_serpent_cast = context
	return ..()

/datum/proc/z121_serpent_explosion(atom/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = TRUE, ignorecap = FALSE, flame_range = 0, silent = FALSE, smoke = FALSE, soundin)
	var/datum/explosion/blast = new /datum/explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog, ignorecap, flame_range, silent, smoke, soundin)
	// 原构造函数在处理地块前先让出执行，因此此处先于所有实际伤害完成。
	blast.z121_serpent_cast = z121_serpent_cast
	return blast

/mob/living/carbon/human/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	// 腹内释放的魔法爆炸只为原宿主补上魔抗检查，外界目标继续使用原规则。
	var/turf/location = get_turf(src)
	if(location?.explosion_id && epicenter)
		for(var/datum/explosion/blast as anything in GLOB.explosions)
			if(blast.explosion_id == location.explosion_id && get_turf(blast.explosion_source) == get_turf(epicenter) && blast.z121_serpent_cast?.blocks(src))
				return
	return ..()

/obj/effect/proc_holder/spell/invoked/bonechill/cast(list/targets, mob/living/user)
	if(!z121_serpent_cast)
		return ..()
	z121_serpent_base_cast(targets, user)
	if(!isliving(targets[1]))
		return FALSE
	var/mob/living/target = targets[1]
	if(target.mob_biotypes & MOB_UNDEAD)
		var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(user.zone_selected))
		if(affecting && (affecting.heal_damage(50, 50) || affecting.heal_wounds(50)))
			target.update_damage_overlays()
		target.visible_message(span_danger("[target] 在邪异能量中重新塑成！"), span_notice("我被黑暗魔法重新塑造了！"))
		return TRUE
	target.visible_message(span_info("死灵能量漫涌过 [target]！"), span_userdanger("黑暗能量灌入体内，我只觉得愈发寒冷！"))
	if(iscarbon(target))
		target.apply_status_effect(/datum/status_effect/debuff/chilled)
	else
		target.adjustBruteLoss(20)
	return TRUE

/obj/effect/proc_holder/spell/invoked/blade_burst/cast(list/targets, mob/user)
	if(!z121_serpent_cast)
		return ..()
	var/turf/T = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	if(T.z > (z121_serpent_cast ? source_turf.z : user.z))
		source_turf = get_step_multiz(source_turf, UP)
	if(T.z < (z121_serpent_cast ? source_turf.z : user.z))
		source_turf = get_step_multiz(source_turf, DOWN)
	for(var/turf/affected_turf in (z121_serpent_cast ? z121_serpent_cast.turfs(view(area_of_effect, T), T) : view(area_of_effect, T)))
		if(!(affected_turf in view(source_turf)))
			continue
		new /obj/effect/temp_visual/trap(affected_turf)
	playsound(T, 'sound/magic/blade_burst.ogg', 80, TRUE, soundping = TRUE)
	sleep(delay)
	var/play_cleave = FALSE
	for(var/turf/affected_turf in (z121_serpent_cast ? z121_serpent_cast.turfs(view(area_of_effect, T), T) : view(area_of_effect, T)))
		new /obj/effect/temp_visual/blade_burst(affected_turf)
		if(!(affected_turf in view(source_turf)))
			continue
		for(var/mob/living/L in (z121_serpent_cast ? z121_serpent_cast.targets(affected_turf) : affected_turf.contents))
			if(z121_serpent_cast?.blocks(L))
				continue
			if(L.anti_magic_check())
				visible_message(span_warning("那些魔刃一靠近 [L] 就消散了！"))
				playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
				if(!z121_serpent_cast)
					qdel(src)
				continue
			play_cleave = TRUE
			L.adjustBruteLoss(damage)
			playsound(affected_turf, "genslash", 80, TRUE)
			to_chat(L, "<span class='userdanger'>我被奥术之力化成的利刃割伤了！</span>")
	if(play_cleave)
		playsound(T, 'sound/combat/newstuck.ogg', 80, TRUE, soundping = TRUE)
	return TRUE

/obj/effect/proc_holder/spell/invoked/repulse/cast(list/targets, mob/user, stun_amt = 5)
	if(!z121_serpent_cast)
		return ..()
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	playsound(user, 'sound/magic/repulse.ogg', 80, TRUE)
	for(var/turf/T in view(push_range, z121_serpent_cast ? get_turf(user) : user))
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/atom/movable/AM in T)
			thrownatoms += AM
	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == user || AM.anchored || (isliving(AM) && z121_serpent_cast?.blocks(AM)))
			continue
		if(ismob(AM))
			var/mob/M = AM
			if(M.anti_magic_check())
				continue
		throwtarget = get_edge_target_turf(get_turf(user), get_dir(get_turf(user), get_step_away(AM, get_turf(user))))
		distfromcaster = get_dist(z121_serpent_cast ? get_turf(user) : user, AM)
		if(distfromcaster == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				M.adjustBruteLoss(20)
				to_chat(M, "<span class='danger'>我被 [user] 猛地砸向了地面！</span>")
		else
			new sparkle_path(get_turf(AM), get_dir(user, AM))
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				to_chat(M, "<span class='danger'>我被 [user] 的力量猛地震飞了出去！</span>")
			AM.safe_throw_at(throwtarget, ((CLAMP((maxthrow - (CLAMP(distfromcaster - 2, 0, distfromcaster))), 3, maxthrow))), 1,user, force = repulse_force)
	return TRUE

/obj/effect/proc_holder/spell/invoked/snap_freeze/cast(list/targets, mob/user)
	if(!z121_serpent_cast)
		return ..()
	var/turf/T = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	if(T.z > (z121_serpent_cast ? source_turf.z : user.z))
		source_turf = get_step_multiz(source_turf, UP)
	if(T.z < (z121_serpent_cast ? source_turf.z : user.z))
		source_turf = get_step_multiz(source_turf, DOWN)
	for(var/turf/affected_turf in (z121_serpent_cast ? z121_serpent_cast.turfs(view(area_of_effect, T), T) : view(area_of_effect, T)))
		if(!(affected_turf in view(source_turf)))
			continue
		new /obj/effect/temp_visual/trapice(affected_turf)
	playsound(T, 'sound/combat/wooshes/blunt/wooshhuge (2).ogg', 80, TRUE, soundping = TRUE)
	sleep(delay)
	var/play_cleave = FALSE
	for(var/turf/affected_turf in (z121_serpent_cast ? z121_serpent_cast.turfs(view(area_of_effect, T), T) : view(area_of_effect, T)))
		new /obj/effect/temp_visual/snap_freeze(affected_turf)
		if(!(affected_turf in view(source_turf)))
			continue
		for(var/mob/living/L in (z121_serpent_cast ? z121_serpent_cast.targets(affected_turf) : affected_turf.contents))
			if(z121_serpent_cast?.blocks(L))
				continue
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.apply_weather_temperature(-35)
			if(L.anti_magic_check())
				visible_message(span_warning("[L] 周围的寒冰魔力消散了！"))
				playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
				if(z121_serpent_cast)
					continue
				return
			play_cleave = TRUE
			if(ishuman(L))
				L.adjustFireLoss(damage)
			else
				L.adjustFireLoss(damage + 30)
			if(L.has_status_effect(/datum/status_effect/buff/frostbite))
				if(z121_serpent_cast)
					continue
				return
			else
				if(L.has_status_effect(/datum/status_effect/buff/frost))
					playsound(T, 'sound/combat/fracture/fracturedry (1).ogg', 80, TRUE, soundping = TRUE)
					L.remove_status_effect(/datum/status_effect/buff/frost)
					L.apply_status_effect(/datum/status_effect/buff/frostbite)
				else
					L.apply_status_effect(/datum/status_effect/buff/frost)
			playsound(affected_turf, "genslash", 80, TRUE)
			to_chat(L, "<span class='userdanger'>冰寒空气直透我的骨头！</span>")
	if(play_cleave)
		playsound(T, 'sound/combat/newstuck.ogg', 80, TRUE, soundping = TRUE)
	return TRUE

/obj/effect/proc_holder/spell/invoked/gravity/cast(list/targets, mob/user)
	if(!z121_serpent_cast)
		return ..()
	var/turf/T = get_turf(targets[1])
	for(var/turf/affected_turf in (z121_serpent_cast ? z121_serpent_cast.turfs(view(area_of_effect, T), T) : view(area_of_effect, T)))
		if(affected_turf.density)
			continue
	for(var/turf/affected_turf in (z121_serpent_cast ? z121_serpent_cast.turfs(view(area_of_effect, T), T) : view(area_of_effect, T)))
		new /obj/effect/temp_visual/gravity_trap(affected_turf)
		playsound(T, 'sound/magic/gravity.ogg', 80, TRUE, soundping = FALSE)
		sleep(delay)
		new /obj/effect/temp_visual/gravity(affected_turf)
		for(var/mob/living/L in (z121_serpent_cast ? z121_serpent_cast.targets(affected_turf) : affected_turf.contents))
			if(z121_serpent_cast?.blocks(L))
				continue
			if(L.anti_magic_check())
				visible_message(span_warning("[L] 周围的重压魔力消散了！"))
				playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
				if(z121_serpent_cast)
					continue
				return TRUE
			if(L.STASTR <= 15)
				L.adjustBruteLoss(60)
				L.Knockdown(5)
				to_chat(L, "<span class='userdanger'>魔力重压猛然加身，我脚下一滑，站立不稳！</span>")
			else
				L.OffBalance(10)
				L.adjustBruteLoss(15)
				to_chat(L, "<span class='userdanger'>魔力重压压在我身上，但我勉强顶住了！</span>")
	return TRUE

/obj/effect/proc_holder/spell/invoked/rebuke/cast(list/targets, mob/living/user)
	if(!z121_serpent_cast)
		return ..()
	if(!isliving(targets[1]))
		return FALSE
	var/mob/living/carbon/target = targets[1]
	target.adjustFireLoss(30)
	target.adjust_fire_stacks(4)
	target.ignite_mob()
	target.visible_message(span_warning("[user]朝着[target]比出一个粗鄙手势，令其当场燃起熊熊烈焰！"), \
	span_userdanger("[user]朝我比出一个粗鄙手势，我顿时被火焰吞没了！"))
	playsound(get_turf(target), 'sound/misc/explode/incendiary (1).ogg', 100, TRUE)
	return TRUE

/obj/effect/proc_holder/spell/invoked/frostbite/cast(list/targets, mob/living/user)
	if(!z121_serpent_cast)
		return ..()
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		target.apply_status_effect(/datum/status_effect/buff/frostbite/)
		target.adjustFireLoss(12)
		target.adjustBruteLoss(12)
		playsound(get_turf(target), 'sound/misc/bamf.ogg', 100, TRUE)
		if(ishuman(target))
			var/mob/living/carbon/human/human_target = target
			human_target.apply_weather_temperature(-35)
		playsound(get_turf(target), 'sound/misc/bamf.ogg', 100, TRUE)

/obj/effect/proc_holder/spell/invoked/thunderstrike/cast(list/targets, mob/user = usr)
	if(!z121_serpent_cast)
		return ..()
	var/turf/centerpoint = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	if(centerpoint.z > (z121_serpent_cast ? source_turf.z : user.z))
		source_turf = get_step_multiz(source_turf, UP)
	if(centerpoint.z < (z121_serpent_cast ? source_turf.z : user.z))
		source_turf = get_step_multiz(source_turf, DOWN)
	if(!(centerpoint in view(source_turf)))
		to_chat(user, span_warning("我无法向看不见的地方施法！"))
		return
	new /obj/effect/temp_visual/trap/thunderstrike(centerpoint)
	addtimer(CALLBACK(src, PROC_REF(thunderstrike_damage), centerpoint, 1, z121_serpent_cast), wait = delay1)
	for(var/turf/effect_layer_one in range(1, centerpoint))
		if(!(effect_layer_one in view(centerpoint)))
			continue
		if(get_dist(centerpoint, effect_layer_one) != 1)
			continue
		new /obj/effect/temp_visual/trap/thunderstrike/layer_one(effect_layer_one)
		addtimer(CALLBACK(src, PROC_REF(thunderstrike_damage), effect_layer_one, 0.5, z121_serpent_cast), wait = delay2)
	for(var/turf/effect_layer_two in range(2, centerpoint))
		if(!(effect_layer_two in view(centerpoint)))
			continue
		if(get_dist(centerpoint, effect_layer_two) != 2)
			continue
		new /obj/effect/temp_visual/trap/thunderstrike/layer_two(effect_layer_two)
		addtimer(CALLBACK(src, PROC_REF(thunderstrike_damage), effect_layer_two, 0.25, z121_serpent_cast), wait = delay3)
	return TRUE

/obj/effect/proc_holder/spell/invoked/wither/cast(list/targets, mob/user = usr)
	if(!z121_serpent_cast)
		return ..()
	var/turf/T = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	if(z121_serpent_cast)
		// 腹内直线攻击从宿主所在格开始，不能因起终点相同而整条射线落空。
		T = get_ranged_target_turf(source_turf, user.dir, range)
	if(T.z != (z121_serpent_cast ? source_turf.z : user.z))
		to_chat(user, span_warning("我无法对不同 z 层施放这个法术！"))
		return FALSE
	var/list/affected_turfs = getline(source_turf, T)
	for(var/i = 1, i < affected_turfs.len, i++)
		var/turf/affected_turf = affected_turfs[i]
		if(affected_turf == source_turf && !z121_serpent_cast)
			continue
		if(!(affected_turf in view(source_turf)))
			continue
		var/tile_delay = strike_delay * (i - 1) + delay
		new /obj/effect/temp_visual/trap/wither(affected_turf, tile_delay)
		addtimer(CALLBACK(src, PROC_REF(strike), affected_turf, z121_serpent_cast), wait = tile_delay)
	return TRUE

/obj/effect/proc_holder/spell/invoked/wither/strike(turf/damage_turf, datum/z121_serpent_cast/context = null)
	new /obj/effect/temp_visual/wither_actual(damage_turf)
	playsound(damage_turf, 'sound/magic/shadowstep_destination.ogg', 50)
	for(var/mob/living/L in (context ? context.targets(damage_turf) : damage_turf.contents))
		if(context?.blocks(L))
			continue
		if(L.anti_magic_check())
			visible_message(span_warning("[L] 周围的枯萎魔力消散了！"))
			playsound(damage_turf, 'sound/magic/magic_nulled.ogg', 100)
			return
		L.adjustFireLoss(damage)
		L.apply_status_effect(/datum/status_effect/buff/witherd)
		return

/obj/effect/proc_holder/spell/invoked/meteor_storm/cast(list/targets, mob/user = usr)
	if(!z121_serpent_cast)
		return ..()
	var/turf/T = get_turf(targets[1])
	playsound(T,'sound/magic/meteorstorm.ogg', 80, TRUE)
	T.visible_message(span_boldwarning("烈火自天而降！"))
	sleep(30)
	create_meteors(T)
	return TRUE

/obj/effect/proc_holder/spell/invoked/meteor_storm/create_meteors(atom/target)
	if(!target)
		return
	var/turf/targetturf = get_turf(target)
	for(var/turf/turf as anything in RANGE_TURFS(6,targetturf))
		if((z121_serpent_cast && turf == targetturf) || prob(20))
			new /obj/effect/temp_visual/target(turf, null, z121_serpent_cast)

/obj/effect/temp_visual/target/fall(list/flame_hit)
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/meteorstorm.ogg', 80, TRUE)
	new /obj/effect/temp_visual/fireball(T)
	sleep(duration)
	if(ismineralturf(T))
		var/turf/closed/mineral/M = T
		M.gets_drilled()
	new /obj/effect/hotspot(T)
	for(var/turf/nearby in RANGE_TURFS(3, T))
		var/dist = get_dist(T, nearby)
		if(dist > 3)
			continue
		for(var/mob/living/L in nearby.contents)
			if(z121_serpent_cast?.blocks(L))
				continue
			if(islist(flame_hit) && flame_hit[L])
				L.adjustFireLoss(5)
				continue
			switch(dist)
				if(0)
					L.adjustFireLoss(40)
					L.adjust_fire_stacks(8)
					L.ignite_mob()
					to_chat(L, span_userdanger("我被陨星正面砸中了！"))
				if(1)
					L.adjustFireLoss(20)
					L.adjust_fire_stacks(4)
					L.ignite_mob()
					to_chat(L, span_danger("陨星带来的高热正在灼烧我！"))
				if(2)
					L.adjustFireLoss(10)
					L.adjust_fire_stacks(2)
					to_chat(L, span_warning("我感受到了那股灼热的冲击！"))
				if(3)
					L.adjustFireLoss(5)
					L.adjust_fire_stacks(1)
			if(islist(flame_hit))
				flame_hit[L] = TRUE
	z121_serpent_explosion(T, -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire, soundin = explode_sound)

/obj/effect/proc_holder/spell/invoked/sundering_lightning/cast(list/targets, mob/user = usr)
	if(!z121_serpent_cast)
		return ..()
	var/turf/T = get_turf(targets[1])
	playsound(T,'sound/weather/rain/thunder_1.ogg', 80, TRUE)
	T.visible_message(span_boldwarning("空气中满是噼啪作响的电荷！"))
	sleep(30)
	create_lightning(T)
	return TRUE

/obj/effect/proc_holder/spell/invoked/sundering_lightning/create_lightning(atom/target)
	if(!target)
		return
	var/turf/targetturf = get_turf(target)
	var/last_dist = 0
	for(var/t in spiral_range_turfs(range, targetturf))
		var/turf/T = t
		if(!T)
			continue
		var/dist = get_dist(targetturf, T)
		if(dist > last_dist)
			last_dist = dist
			sleep(2 + min(range - last_dist, 12) * 0.5)
		new /obj/effect/temp_visual/targetlightning(T, null, z121_serpent_cast)

/obj/effect/temp_visual/targetlightning/storm(list/flame_hit)
	var/turf/T = get_turf(src)
	sleep(duration)
	playsound(T,'sound/magic/lightning.ogg', 80, TRUE)
	new /obj/effect/temp_visual/lightning(T)
	for(var/mob/living/L in T.contents)
		if(z121_serpent_cast?.blocks(L) || L.anti_magic_check())
			continue
		L.electrocute_act(65, src)
		to_chat(L, span_userdanger("我被雷霆击中了！！！"))

/obj/effect/proc_holder/spell/invoked/aerosolize/cast(list/targets, mob/living/user)
	if(!z121_serpent_cast)
		return ..()
	var/turf/T = get_turf(targets[1])
	var/obj/item/reagent_containers/con = get_container(user, targets[1])
	if(!T || !con)
		revert_cast()
		return
	var/datum/effect_system/smoke_spread/chem/smoke = new
	smoke.set_up(con.reagents, 1, T, FALSE)
	smoke.start()
	con.reagents.clear_reagents()
	playsound(user, 'sound/magic/webspin.ogg', 100)

/obj/effect/proc_holder/spell/invoked/aerosolize/wave/cast(list/targets, mob/living/user)
	if(!z121_serpent_cast)
		return ..()
	var/obj/item/reagent_containers/con = get_container(user, targets[1])
	if(!con)
		revert_cast()
		return
	var/datum/reagents/R = con.reagents
	var/cloud_color = mix_color_from_reagents(R.reagent_list)
	var/turf/front = get_turf(targets[1])
	var/list/affected_turfs = list()
	affected_turfs += front
	if(user.dir == SOUTH || user.dir == NORTH)
		affected_turfs += get_step(front, WEST)
		affected_turfs += get_step(front, EAST)
	else
		affected_turfs += get_step(front, NORTH)
		affected_turfs += get_step(front, SOUTH)
	for(var/turf/affected_turf in affected_turfs)
		var/obj/effect/aerosol_cloud/C = new(affected_turf, user.dir, cloud_color)
		R.copy_to(C.payload, R.total_volume)
	con.reagents.clear_reagents()
	playsound(user, 'sound/magic/whiteflame.ogg', 100)
	return TRUE

/obj/projectile/magic/aoe/fireball/on_hit(target)
	if(!z121_serpent_cast)
		return ..()
	return z121_serpent_fireball_hit(target)

/obj/projectile/magic/aoe/fireball/proc/z121_serpent_fireball_hit(target)
	. = call(src, /obj/projectile/proc/on_hit)(target)
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src]一接触[target]就化作烟雾消散了！"))
			return BULLET_ACT_BLOCK
		if(exp_fire)
			M.adjust_fire_stacks(exp_fire*3)
	var/turf/T
	if(isturf(target))
		T = target
	else
		T = get_turf(target)
	z121_serpent_explosion(T, -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire, soundin = explode_sound)
	if(ismob(target))
		var/mob/living/M = target
		var/atom/throw_target = get_edge_target_turf(M, angle2dir(Angle))
		M.throw_at(throw_target, exp_light, EXPLOSION_THROW_SPEED)

/obj/projectile/magic/aoe/fireball/rogue/artillery/on_hit(target)
	if(!z121_serpent_cast)
		return ..()
	. = z121_serpent_fireball_hit(target)
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] 在接触[target]时噗地熄散了！"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.adjust_fire_stacks(2)
	var/turf/fallzone = get_turf(target)
	if(!fallzone)
		return
	var/const/damage = 300
	var/const/radius = 1
	for(var/turf/open/visual in view(radius, fallzone))
		var/obj/effect/temp_visual/lavastaff/Lava = new /obj/effect/temp_visual/lavastaff(visual)
		var/datum/effect_system/smoke_spread/S = new /datum/effect_system/smoke_spread/fast
		animate(Lava, alpha = 255, time = 5)
		S.set_up(radius, fallzone)
		S.start()
	for(var/obj/structure/damaged in view(radius, fallzone))
		if(!istype(damaged, /obj/structure/flora/newbranch))
			damaged.take_damage(damage, BRUTE, "blunt", 1)
	for(var/turf/closed/wall/damagedwalls in view(radius, fallzone))
		damagedwalls.take_damage(damage, BRUTE, "blunt", 1)
