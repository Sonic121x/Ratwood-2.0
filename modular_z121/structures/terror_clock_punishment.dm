// 丧钟惩罚单位、战魂、绑定物品及远程技能均只在本模块生效。
#define TRAIT_Z121_TERROR_CLOCK_WAR_SOUL "z121_terror_clock_war_soul"

// 用归属链判断容器内物品，内部换槽和换手不会被当作离身。
/proc/terror_clock_contains(atom/container, atom/item)
	// 人形角色的肢体和部分器官位于空位置，用实际归属补充位置链。
	if(iscarbon(container))
		var/mob/living/carbon/C = container
		if((item in C.bodyparts) || (item in C.internal_organs))
			return TRUE
	while(item)
		if(item == container)
			return TRUE
		item = item.loc
	return FALSE

// 只把有玩家归属的、尚可作战的身体作为主动猎杀目标。
/proc/terror_clock_player_target(mob/living/L)
	return !QDELETED(L) && (L.client || L.ckey || L.mind?.key) && L.stat == CONSCIOUS && !L.InCritical() && !L.InFullCritical()

// 技能和移动共用遮挡判断；射击额外检查弹道上的惩罚队友。
/proc/terror_clock_line_clear(turf/origin, turf/destination, check_allies = FALSE)
	if(!origin || !destination || origin.z != destination.z)
		return FALSE
	// 对角移动不能从两块障碍的夹角穿过。
	if(abs(origin.x - destination.x) == 1 && abs(origin.y - destination.y) == 1)
		if(!terror_clock_line_clear(origin, locate(destination.x, origin.y, origin.z), check_allies) || !terror_clock_line_clear(origin, locate(origin.x, destination.y, origin.z), check_allies))
			return FALSE
	for(var/turf/T as anything in getline(origin, destination))
		if(T.density)
			return FALSE
		for(var/atom/movable/A in T)
			if(A.density && !isliving(A) && !istype(A, /obj/projectile))
				return FALSE
			if(check_allies && T != origin && istype(A, /mob/living/carbon/human/species/human/northern/terror_clock_hunter) && !QDELETED(A))
				return FALSE
	return TRUE

// 唯一组件统一授予战斗强化，并在移除时只撤销自己的来源和系数。
/datum/component/terror_clock_war_soul
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/trait_source
	var/applied = FALSE
	var/old_smart
	var/old_special
	var/list/old_intents
	var/list/battle_traits = list(TRAIT_Z121_TERROR_CLOCK_WAR_SOUL, TRAIT_MEDIUMARMOR, TRAIT_HEAVYARMOR, TRAIT_INFINITE_STAMINA, TRAIT_BREADY, TRAIT_NOPAINSTUN, TRAIT_IGNOREDAMAGESLOWDOWN)

/datum/component/terror_clock_war_soul/Initialize()
	if(!istype(parent, /mob/living/carbon/human/species/human/northern/terror_clock_hunter))
		return COMPONENT_INCOMPATIBLE
	trait_source = REF(src)

/datum/component/terror_clock_war_soul/RegisterWithParent()
	var/mob/living/carbon/human/H = parent
	if(applied)
		return
	applied = TRUE
	for(var/trait in battle_traits)
		ADD_TRAIT(H, trait, trait_source)
	H.physiology.brute_mod *= 0.8
	H.physiology.burn_mod *= 0.8
	old_smart = H.smart_combatant
	old_special = H.special_attacker
	old_intents = H.possible_rmb_intents.Copy()
	H.smart_combatant = TRUE
	H.special_attacker = TRUE
	H.possible_rmb_intents = list(/datum/rmb_intent/feint, /datum/rmb_intent/aimed, /datum/rmb_intent/strong, /datum/rmb_intent/riposte)
	RegisterSignal(H, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/terror_clock_war_soul/UnregisterFromParent()
	var/mob/living/carbon/human/H = parent
	UnregisterSignal(H, COMSIG_PARENT_EXAMINE)
	if(applied)
		applied = FALSE
		for(var/trait in battle_traits)
			REMOVE_TRAIT(H, trait, trait_source)
		if(H.physiology)
			H.physiology.brute_mod /= 0.8
			H.physiology.burn_mod /= 0.8
		H.smart_combatant = old_smart
		H.special_attacker = old_special
		H.possible_rmb_intents = old_intents

/datum/component/terror_clock_war_soul/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_warning("丧钟战魂：碎钟回响驱动着它。疼痛与伤势无法减缓它的追猎，重甲也无法消磨它的战意。")

// 原生物品自行追踪归属，避免钟被删除后丢失清理依据。
/datum/component/terror_clock_bound_item
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/weakref/hunter_ref
	var/removing = FALSE

/datum/component/terror_clock_bound_item/Initialize(mob/living/carbon/human/species/human/northern/terror_clock_hunter/H)
	if(!isitem(parent) || QDELETED(H))
		return COMPONENT_INCOMPATIBLE
	hunter_ref = WEAKREF(H)

/datum/component/terror_clock_bound_item/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(on_deleting))

/datum/component/terror_clock_bound_item/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))

/datum/component/terror_clock_bound_item/proc/on_moved()
	SIGNAL_HANDLER
	// 换槽过程可能短暂经过空位置，等本次移动链结束再确认最终归属。
	addtimer(CALLBACK(src, PROC_REF(check_owner)), 0, TIMER_UNIQUE)

/datum/component/terror_clock_bound_item/proc/check_owner()
	if(removing || QDELETED(parent))
		return
	var/mob/living/carbon/human/species/human/northern/terror_clock_hunter/H = hunter_ref?.resolve()
	if(H && terror_clock_contains(H, parent))
		return
	removing = TRUE
	if(H)
		H.clear_native_items(parent)
	else
		qdel(parent)

/datum/component/terror_clock_bound_item/proc/on_deleting()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/species/human/northern/terror_clock_hunter/H = hunter_ref?.resolve()
	if(H)
		H.native_items -= parent

// 四秒共享保护覆盖同批和不同钟生成的刃卫，避免连续震荡锁住玩家。
/datum/status_effect/terror_clock_resonance_guard
	id = "terror_clock_resonance_guard"
	duration = 4 SECONDS
	alert_type = null

/obj/effect/terror_clock_warning
	name = "丧钟余响"
	desc = "危险的钟声正在此处凝结！"
	icon = 'icons/mob/actions/actions_spells.dmi'
	icon_state = "projectile"
	color = "#bb2244"
	anchored = TRUE
	density = FALSE
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE

/mob/living/carbon/human/species/human/northern/terror_clock_hunter
	name = "丧钟刃卫"
	real_name = "丧钟刃卫"
	desc = "碎钟的回声寄宿在这副空甲之中。它追逐活人的心跳，直到最后一声钟鸣停止。"
	faction = list("z121_terror_clock")
	aggressive = TRUE
	mode = NPC_AI_IDLE
	ambushable = FALSE
	flee_in_pain = FALSE
	no_head_bounty = TRUE
	dodgetime = 1.5 SECONDS
	var/outfit_type = /datum/outfit/terror_clock_hunter
	var/backup_type
	var/projectile_type
	var/obj/item/primary_weapon
	var/ranged_min = 0
	var/ranged_max = 0
	var/shot_delay = 1 SECONDS
	var/shot_cooldown = 3 SECONDS
	var/ready = FALSE
	var/fading = FALSE
	var/cleanup_started = FALSE
	var/datum/weakref/preferred_victim
	var/datum/component/terror_clock_war_soul/war_soul
	var/list/native_items = list()
	var/creation_timer
	var/vanish_timer
	var/skill_timer
	var/skill_kind
	var/turf/skill_origin
	var/atom/skill_target
	var/list/skill_warnings = list()
	var/next_shot = 0
	var/next_special = 0
	var/next_charge = 0
	var/next_heal = 0
	var/heals_left = 8

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/Initialize(mapload)
	. = ..()
	set_species(/datum/species/human/northern)
	war_soul = AddComponent(/datum/component/terror_clock_war_soul)
	var/list/initial_items = GetAllContents(/obj/item)
	initial_items |= bodyparts
	initial_items |= internal_organs
	bind_native_items(initial_items)
	RegisterSignal(src, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(on_health_update))
	RegisterSignal(src, list(COMSIG_LIVING_STATUS_STUN, COMSIG_LIVING_STATUS_KNOCKDOWN, COMSIG_LIVING_STATUS_PARALYZE, COMSIG_LIVING_STATUS_UNCONSCIOUS, COMSIG_LIVING_STATUS_IMMOBILIZE, COMSIG_LIVING_STATUS_SLEEP), PROC_REF(on_control))
	creation_timer = addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS, TIMER_STOPPABLE)

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/after_creation()
	creation_timer = null
	if(ready || fading || QDELETED(src))
		return
	..()
	STASTR = 18
	STASPD = 16
	STACON = 18
	STAWIL = 18
	STAPER = 16
	STAINT = ranged_min && !istype(src, /mob/living/carbon/human/species/human/northern/terror_clock_hunter/archer) ? 18 : 12
	for(var/skill in list(/datum/skill/combat/swords, /datum/skill/combat/knives, /datum/skill/combat/maces, /datum/skill/combat/polearms, /datum/skill/combat/unarmed, /datum/skill/combat/wrestling, /datum/skill/combat/bows, /datum/skill/magic/arcane, /datum/skill/magic/holy))
		adjust_skillrank_up_to(skill, SKILL_LEVEL_MASTER, TRUE)
	ADD_TRAIT(src, TRAIT_NOMOOD, REF(src))
	ADD_TRAIT(src, TRAIT_NOHUNGER, REF(src))
	// 仅登记本次装备过程新增的物品，玩家在初始化期间放入的物品不绑定。
	var/list/before_equipment = GetAllContents(/obj/item)
	var/datum/outfit/equipment = new outfit_type
	equipOutfit(equipment)
	var/list/new_equipment = GetAllContents(/obj/item)
	new_equipment -= before_equipment
	bind_native_items(new_equipment)
	for(var/obj/item/I in held_items)
		if(istype(I, equipment.r_hand))
			primary_weapon = I
			break
	qdel(equipment)
	real_name = initial(name)
	name = real_name
	ready = TRUE
	next_shot = world.time
	mode = NPC_AI_IDLE
	update_body()
	regenerate_icons()
	handle_ai()
	choose_prey()

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/proc/bind_native_items(list/items)
	for(var/obj/item/I as anything in items)
		if(QDELETED(I) || (I in native_items))
			continue
		native_items += I
		I.AddComponent(/datum/component/terror_clock_bound_item, src)

// 先移出玩家物品，再删除原生内容；快照也覆盖藏在外来容器里的原生物品。
/mob/living/carbon/human/species/human/northern/terror_clock_hunter/proc/clear_native_items(atom/root)
	var/turf/drop_turf = get_turf(root)
	if(!drop_turf)
		drop_turf = get_turf(src)
	var/list/items = root.GetAllContents(/obj/item)
	if(istype(root, /obj/item/bodypart))
		var/obj/item/bodypart/B = root
		items |= B.embedded_objects
		if(B.bandage)
			items |= B.bandage
		// 肢体析构会删除绷带和嵌入物，先解除引用，才能保留外来的物品。
		for(var/obj/item/embedded as anything in B.embedded_objects?.Copy())
			if(!(embedded in native_items) && drop_turf)
				B.remove_embedded_object(embedded)
		B.embedded_objects = list()
		B.bandage = null
	if(istype(root, /obj/item/bodypart/chest))
		var/obj/item/bodypart/chest/C = root
		if(C.cavity_item)
			items |= C.cavity_item.GetAllContents(/obj/item)
			C.cavity_item = null
	for(var/obj/item/I as anything in items)
		if(QDELETED(I) || (I in native_items))
			continue
		if(isitem(I.loc) && !(I.loc in native_items))
			continue
		if(drop_turf)
			if(I.loc == src)
				doUnEquip(I, TRUE, drop_turf)
			else
				I.forceMove(drop_turf)
	for(var/obj/item/I as anything in items)
		if((I in native_items) && !QDELETED(I))
			qdel(I)

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/proc/on_health_update()
	SIGNAL_HANDLER
	if(health <= crit_threshold || stat == DEAD)
		vanish()
	else if(incapacitated())
		cancel_skill()

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/proc/on_control(datum/source, amount)
	SIGNAL_HANDLER
	// 清除控制的零值或负值请求不应打断正常蓄势。
	if(amount > 0)
		cancel_skill()

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/proc/vanish()
	if(cleanup_started || vanish_timer)
		return
	fading = TRUE
	visible_message(span_warning("[src]的甲胄化为暗红色碎影，随着最后一声钟鸣消散了。"))
	mode = NPC_AI_OFF
	stat = DEAD
	alpha = 0
	density = FALSE
	STOP_PROCESSING(SShumannpc, src)
	cancel_skill()
	// 立即隐藏并停止战斗，等当前伤害链返回后析构，避免上层代码访问已清空的身体。
	vanish_timer = addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), 0, TIMER_STOPPABLE)

// 不进入原生死亡、粉碎或化灰掉落流程。
/mob/living/carbon/human/species/human/northern/terror_clock_hunter/death(gibbed, nocutscene = FALSE)
	vanish()
	return TRUE

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/gib(no_brain, no_organs, no_bodyparts)
	vanish()

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/dust(just_ash, drop_items, force)
	vanish()

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/Destroy()
	cleanup_started = TRUE
	fading = TRUE
	mode = NPC_AI_OFF
	STOP_PROCESSING(SShumannpc, src)
	if(creation_timer)
		deltimer(creation_timer)
	if(vanish_timer)
		deltimer(vanish_timer)
	cancel_skill()
	UnregisterSignal(src, list(COMSIG_LIVING_HEALTH_UPDATE, COMSIG_LIVING_STATUS_STUN, COMSIG_LIVING_STATUS_KNOCKDOWN, COMSIG_LIVING_STATUS_PARALYZE, COMSIG_LIVING_STATUS_UNCONSCIOUS, COMSIG_LIVING_STATUS_IMMOBILIZE, COMSIG_LIVING_STATUS_SLEEP))
	clear_native_items(src)
	for(var/obj/item/I as anything in native_items.Copy())
		if(!QDELETED(I))
			clear_native_items(I)
	native_items.Cut()
	QDEL_NULL(war_soul)
	preferred_victim = null
	primary_weapon = null
	return ..()

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/Moved()
	. = ..()
	if(skill_kind)
		cancel_skill()

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/should_target(mob/living/L)
	if(!terror_clock_player_target(L) || L == src || L.z != z || HAS_TRAIT(src, TRAIT_PACIFISM))
		return FALSE
	if(L.alpha == 0 && L.rogue_sneaking)
		return FALSE
	return TRUE

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/proc/choose_prey()
	var/mob/living/preferred = preferred_victim?.resolve()
	var/mob/living/chosen
	if(should_target(preferred) && (preferred in view(7, src)))
		chosen = preferred
	else if(should_target(target) && get_dist(src, target) <= 14)
		mode = NPC_AI_HUNT
		return
	else
		for(var/mob/living/L in view(7, src))
			if(should_target(L) && (!chosen || get_dist(src, L) < get_dist(src, chosen)))
				chosen = L
	if(chosen && chosen != target)
		retaliate(chosen)
	else if(chosen)
		mode = NPC_AI_HUNT
	else if(!chosen && target)
		back_to_idle()

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/process_ai()
	if(!ready || fading)
		return FALSE
	if(skill_kind)
		if(incapacitated() || get_turf(src) != skill_origin)
			cancel_skill()
		return FALSE
	choose_prey()
	// 原生处理会先走旧路径，再执行战斗；射程内必须先撤销贴脸路径。
	if(ranged_min && target && get_dist(src, target) <= 7 && terror_clock_line_clear(get_turf(src), get_turf(target)))
		clear_path()
	return ..()

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/handle_combat()
	if(!ready || fading || skill_kind)
		return TRUE
	// 支援同伴不要求牧师此刻持有玩家目标。
	if(istype(src, /mob/living/carbon/human/species/human/northern/terror_clock_hunter/priest) && heals_left > 0 && world.time >= next_heal && terror_clock_contains(src, primary_weapon) && !QDELETED(primary_weapon))
		var/mob/living/carbon/human/species/human/northern/terror_clock_hunter/wounded = healing_target()
		if(wounded)
			next_heal = world.time + 10 SECONDS
			begin_skill("治疗", wounded, 1.5 SECONDS, "举起祭杖，以血色钟声修补同伴的躯体！")
			return TRUE
	if(!target || !should_target(target))
		return ..()
	var/distance = get_dist(src, target)
	if(!ranged_min)
		if(distance <= 2 && world.time >= next_special && (target in view(2, src)))
			next_special = world.time + 12 SECONDS
			begin_skill("震荡", src, 1.2 SECONDS, "停步举剑，甲胄中响起愈发尖锐的钟鸣！")
			return TRUE
		if(distance >= 3 && distance <= 6 && world.time >= next_charge && (target in view(7, src)))
			next_charge = world.time + 8 SECONDS
			begin_skill("突进", target, 0.6 SECONDS, "压低剑锋，准备向猎物发起突进！")
			return TRUE
		return ..()
	if(QDELETED(primary_weapon) || !(primary_weapon in held_items))
		use_backup()
		return ..()
	if(distance < ranged_min)
		if(retreat_safely())
			return TRUE
		use_backup()
		return ..()
	if(distance > 7 || !(target in view(7, src)) || !terror_clock_line_clear(get_turf(src), get_turf(target)))
		return ..()
	// 优先进入理想距离，但被地形阻挡时仍可在七格内射击。
	if(distance > ranged_max && next_move <= world.time)
		var/turf/approach = get_step(src, get_dir(src, target))
		if(terror_clock_safe_turf(approach) && terror_clock_line_clear(get_turf(src), approach) && Move(approach))
			changeNext_move(1 SECONDS)
			return TRUE
	if(istype(src, /mob/living/carbon/human/species/human/northern/terror_clock_hunter/mage) && world.time >= next_special)
		next_special = world.time + 12 SECONDS
		begin_skill("爆裂", get_turf(target), 1.5 SECONDS, "挥动法杖，在猎物脚下凝聚危险的丧钟余响！")
		for(var/turf/T in range(1, skill_target))
			if(terror_clock_line_clear(skill_target, T))
				skill_warnings += new /obj/effect/terror_clock_warning(T)
		return TRUE
	if(world.time >= next_shot)
		if(!terror_clock_line_clear(get_turf(src), get_turf(target), TRUE))
			retreat_safely(TRUE)
			return TRUE
		next_shot = world.time + shot_cooldown
		begin_skill("射击", target, shot_delay, istype(src, /mob/living/carbon/human/species/human/northern/terror_clock_hunter/archer) ? "拉开长弓，钟骨箭正对准猎物！" : "举起法杖，血色魔光正在凝聚！")
	return TRUE

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/proc/use_backup()
	if(!backup_type)
		return
	if(istype(get_inactive_held_item(), backup_type))
		swap_hand()

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/proc/retreat_safely(reposition = FALSE)
	if(!(mobility_flags & MOBILITY_MOVE) || next_move > world.time)
		return FALSE
	var/turf/chosen
	var/current_distance = get_dist(src, target)
	for(var/direction in GLOB.cardinals)
		var/turf/T = get_step(src, direction)
		if(!terror_clock_safe_turf(T) || !terror_clock_line_clear(get_turf(src), T))
			continue
		var/new_distance = get_dist(T, target)
		if(new_distance > 7 || (!reposition && new_distance <= current_distance))
			continue
		if(!terror_clock_line_clear(T, get_turf(target), reposition))
			continue
		if(!chosen || new_distance > get_dist(chosen, target))
			chosen = T
	if(chosen && Move(chosen))
		changeNext_move(1 SECONDS)
		return TRUE
	return FALSE

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/proc/healing_target()
	var/mob/living/carbon/human/species/human/northern/terror_clock_hunter/chosen
	for(var/mob/living/carbon/human/species/human/northern/terror_clock_hunter/H in view(5, src))
		if(!can_heal(H))
			continue
		if(!chosen || H.health / H.maxHealth < chosen.health / chosen.maxHealth)
			chosen = H
	return chosen

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/proc/can_heal(mob/living/carbon/human/species/human/northern/terror_clock_hunter/H)
	return !QDELETED(H) && H.ready && !H.fading && H.stat != DEAD && H.health > H.crit_threshold && H.health < H.maxHealth * 0.7 && H.z == z && get_dist(src, H) <= 5 && (H in view(5, src)) && terror_clock_line_clear(get_turf(src), get_turf(H))

// 蓄势期间清空移动路径，所有技能共用可撤销回调。
/mob/living/carbon/human/species/human/northern/terror_clock_hunter/proc/begin_skill(kind, atom/victim, delay, message)
	if(ranged_min && get_active_held_item() != primary_weapon && get_inactive_held_item() == primary_weapon)
		swap_hand()
	skill_kind = kind
	skill_target = victim
	skill_origin = get_turf(src)
	clear_path()
	walk_to(src, 0)
	visible_message(span_danger("[src][message]"))
	skill_timer = addtimer(CALLBACK(src, PROC_REF(finish_skill)), delay, TIMER_STOPPABLE)

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/proc/cancel_skill()
	if(skill_timer)
		deltimer(skill_timer)
	skill_timer = null
	skill_kind = null
	skill_target = null
	skill_origin = null
	for(var/obj/effect/E as anything in skill_warnings)
		qdel(E)
	skill_warnings.Cut()

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/proc/finish_skill()
	skill_timer = null
	if(QDELETED(src) || fading || incapacitated() || !(mobility_flags & MOBILITY_STAND) || get_turf(src) != skill_origin)
		cancel_skill()
		return
	var/kind = skill_kind
	var/atom/victim = skill_target
	cancel_skill()
	if(ranged_min && (QDELETED(primary_weapon) || !(primary_weapon in held_items)))
		return
	if(kind == "震荡")
		playsound(src, 'sound/misc/bell.ogg', 75, FALSE)
		for(var/mob/living/L in view(2, src))
			if(!should_target(L) || L.has_status_effect(/datum/status_effect/terror_clock_resonance_guard) || !terror_clock_line_clear(get_turf(src), get_turf(L)))
				continue
			L.apply_status_effect(/datum/status_effect/terror_clock_resonance_guard)
			var/armor = L.run_armor_check(BODY_ZONE_CHEST, "blunt", damage = 18)
			L.apply_damage(18, BRUTE, BODY_ZONE_CHEST, armor)
			if(!QDELETED(L))
				L.OffBalance(1 SECONDS)
		return
	if(kind == "爆裂")
		var/turf/center = victim
		if(!isturf(center) || center.z != z || get_dist(src, center) > 7 || !terror_clock_line_clear(get_turf(src), center))
			return
		playsound(center, 'sound/misc/demon_attack1.ogg', 75, FALSE)
		for(var/mob/living/L in view(1, center))
			if(should_target(L) && terror_clock_line_clear(center, get_turf(L)) && !L.anti_magic_check())
				var/armor = L.run_armor_check(BODY_ZONE_CHEST, "magic", damage = 36)
				L.apply_damage(36, BURN, BODY_ZONE_CHEST, armor)
		return
	if(kind == "治疗")
		var/mob/living/carbon/human/species/human/northern/terror_clock_hunter/H = victim
		if(heals_left > 0 && istype(H) && can_heal(H))
			var/old_damage = H.getBruteLoss() + H.getFireLoss()
			H.heal_overall_damage(20, 20)
			if(!QDELETED(H) && H.getBruteLoss() + H.getFireLoss() < old_damage)
				heals_left--
				H.visible_message(span_warning("血色余响填补了[H]甲胄下的裂痕！"))
		return
	var/mob/living/L = victim
	if(!isliving(L) || !should_target(L) || !(L in view(7, src)) || !terror_clock_line_clear(get_turf(src), get_turf(L)))
		return
	if(kind == "突进")
		for(var/i in 1 to 3)
			if(Adjacent(L))
				break
			var/turf/T = get_step(src, get_dir(src, L))
			if(!terror_clock_safe_turf(T) || !terror_clock_line_clear(get_turf(src), T) || !Move(T))
				break
		if(!QDELETED(L) && Adjacent(L))
			monkey_attack(L)
		return
	if(kind == "射击" && get_dist(src, L) >= ranged_min && get_dist(src, L) <= 7 && terror_clock_line_clear(get_turf(src), get_turf(L), TRUE))
		var/obj/projectile/P = new projectile_type(get_turf(src))
		P.firer = src
		P.fired_from = src
		P.def_zone = BODY_ZONE_CHEST
		P.preparePixelProjectile(L, src)
		P.fire()

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/archer
	name = "丧钟弓卫"
	real_name = "丧钟弓卫"
	outfit_type = /datum/outfit/terror_clock_hunter/archer
	backup_type = /obj/item/rogueweapon/sword/short/terror_clock
	projectile_type = /obj/projectile/bullet/terror_clock_arrow
	ranged_min = 3
	ranged_max = 5
	shot_delay = 1.2 SECONDS

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/mage
	name = "丧钟咒术师"
	real_name = "丧钟咒术师"
	outfit_type = /datum/outfit/terror_clock_hunter/mage
	backup_type = /obj/item/rogueweapon/sword/short/terror_clock
	projectile_type = /obj/projectile/magic/terror_clock
	ranged_min = 4
	ranged_max = 6

/mob/living/carbon/human/species/human/northern/terror_clock_hunter/priest
	name = "丧钟血祭司"
	real_name = "丧钟血祭司"
	outfit_type = /datum/outfit/terror_clock_hunter/priest
	backup_type = /obj/item/rogueweapon/mace/blacksteel/terror_clock
	projectile_type = /obj/projectile/magic/terror_clock/judgment
	ranged_min = 3
	ranged_max = 5
	shot_delay = 0.8 SECONDS
	shot_cooldown = 3.5 SECONDS

// 固定装备不带钱袋和宝物，现有素材通过中文名称和配色区分职业。
/datum/outfit/terror_clock_hunter
	armor = /obj/item/clothing/suit/roguetown/armor/plate/modern/blacksteel_full_plate
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	pants = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	shoes = /obj/item/clothing/shoes/roguetown/boots/blacksteel/modern/plateboots
	gloves = /obj/item/clothing/gloves/roguetown/blacksteel/modern/plategloves
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	head = /obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	cloak = /obj/item/clothing/cloak/terror_clock
	r_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel/terror_clock

/datum/outfit/terror_clock_hunter/archer
	r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/terror_clock
	l_hand = /obj/item/rogueweapon/sword/short/terror_clock

/datum/outfit/terror_clock_hunter/mage
	cloak = /obj/item/clothing/cloak/terror_clock/mage
	r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel/terror_clock
	l_hand = /obj/item/rogueweapon/sword/short/terror_clock

/datum/outfit/terror_clock_hunter/priest
	r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel/terror_clock/priest
	l_hand = /obj/item/rogueweapon/mace/blacksteel/terror_clock

/obj/item/clothing/cloak/terror_clock
	name = "丧钟披风"
	desc = "暗红色布料中回荡着碎钟的低语。"
	color = "#772233"

/obj/item/clothing/cloak/terror_clock/mage
	name = "丧钟咒术披风"
	color = "#552266"

/obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel/terror_clock
	name = "碎钟黑钢大剑"
	desc = "剑身随着猎物的心跳发出轻微的钟鸣。"

/obj/item/rogueweapon/sword/short/terror_clock
	name = "丧钟黑钢短剑"
	desc = "钟影凝结而成的黑色短剑。"
	color = "#444455"
	force = 28
	force_wielded = 32
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/terror_clock
	name = "丧钟长弓"
	desc = "弓弦绷紧时，仿佛有遥远的丧钟在响。"
	color = "#554455"

/obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel/terror_clock
	name = "丧钟法杖"
	desc = "血色余响环绕着这根沉重的黑钢法杖。"

/obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel/terror_clock/priest
	name = "血誓祭杖"

/obj/item/rogueweapon/mace/blacksteel/terror_clock
	name = "丧钟钉头锤"
	desc = "锤头上缠绕着不散的血色钟影。"

// 使用普通子弹基类而非可回收箭基类，命中和射程结束均不生成实体弹药。
/obj/projectile/bullet/terror_clock_arrow
	name = "钟骨箭"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_proj"
	damage = 65
	damage_type = BRUTE
	flag = "piercing"
	woundclass = BCLASS_PIERCE
	armor_penetration = 10
	embedchance = 0
	range = 7
	speed = 0.4
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'

/obj/projectile/bullet/terror_clock_arrow/prehit(atom/target)
	if(istype(target, /mob/living/carbon/human/species/human/northern/terror_clock_hunter))
		return FALSE
	return ..()

/obj/projectile/magic/terror_clock
	name = "丧钟魔矢"
	damage = 40
	damage_type = BURN
	nodamage = FALSE
	armor_penetration = 0
	range = 7
	speed = 0.5
	color = "#aa2244"

// 抗魔必须在原生伤害结算之前检查；遇到非角色障碍直接消散，不能损坏建筑。
/obj/projectile/magic/terror_clock/prehit(atom/target)
	if(istype(target, /mob/living/carbon/human/species/human/northern/terror_clock_hunter))
		return FALSE
	if(!isliving(target))
		qdel(src)
		return FALSE
	var/mob/living/L = target
	if(L.anti_magic_check())
		L.visible_message(span_warning("丧钟魔光在[L]身前消散了！"))
		qdel(src)
		return FALSE
	return ..()

/obj/projectile/magic/terror_clock/judgment
	name = "血誓裁决"
	damage = 30

#undef TRAIT_Z121_TERROR_CLOCK_WAR_SOUL
