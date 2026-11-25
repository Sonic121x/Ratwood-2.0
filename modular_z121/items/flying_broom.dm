// ============================================================================
// 飞天扫帚 (Flying Broom)
// ----------------------------------------------------------------------------
// 手持扫帚时右键点击它即可起飞/落地。
// 飞行状态沿用上游 fly 的 id = "fly"，以复用 Fly Up / Fly Down 楼层按钮；
// 但 FLYING 标志、悬浮高度、脚步静音、拖尾与起飞/落地动画在这里自行实现，
// 避免依赖父类 on_apply 时出现“只是在天上走路”的问题。
// ============================================================================

#define FLYING_BROOM_SPEED_ID "flying_broom_speed"
/// 飞行时人物整体抬高的像素数（哈比是 3px 左右的轻飘感）。
#define FLYING_BROOM_HOVER_HEIGHT 4
/// 浮空上下摆动的幅度（哈比用 ±3px、6 deciseconds 一摆）。
#define FLYING_BROOM_BOB_HEIGHT 3
/// 临时静音脚步的 trait 来源标记。
#define FLYING_BROOM_TRAIT_SOURCE "flying_broom"
/// 注册在 mob_offsets 里的悬浮偏移 ID。用 set_mob_offsets 才能扛住
/// update_transform() 对 pixel_y 的反复重置。
#define FLYING_BROOM_OFFSET_ID "flying_broom_hover"
/// 拖尾生成间隔（deciseconds，2 = 0.2 秒）。
#define FLYING_BROOM_TRAIL_COOLDOWN 2

/obj/item/broom/flying
	name = "魔法扫帚"
	desc = "一把绑着枯枝的旧扫帚，柄上缠绕着淡淡的蓝色魔力。奇怪的是,枯枝之中夹杂着一些绿色的鬃毛。"
	icon = 'modular_z121/icon/flying_broom.dmi'
	icon_state = "broom"
	/// 当前正在骑着这把扫帚的人（弱引用，防止物品顶着已删除的 mob）
	var/datum/weakref/flyer_ref

/// 判断某人是否正骑着魔法扫帚。
/// 骑扫帚期间禁止施法：核心的施法检查（`cast_check` / `can_cast` / `can_cast_spell`）
/// 都会调用此函数拦截，扫帚自带的上下楼按钮除外。
/proc/is_riding_flying_broom(mob/M)
	if(!isliving(M))
		return FALSE
	var/mob/living/L = M
	return istype(L.has_status_effect(/datum/status_effect/buff/fly), /datum/status_effect/buff/fly/broom)

/obj/item/broom/flying/rmb_self(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_active_held_item() != src)
		return

	// 再右键一次：落地。
	var/mob/living/current_flyer = flyer_ref?.resolve()
	if(current_flyer == H && H.has_status_effect(/datum/status_effect/buff/fly))
		H.remove_status_effect(/datum/status_effect/buff/fly)
		return

	// 其它来源的飞行（例如飞行术）优先，不叠 buff。
	if(H.has_status_effect(/datum/status_effect/buff/fly))
		to_chat(H, span_warning("我已经在空中了。"))
		return

	if(H.stat != CONSCIOUS || H.handcuffed || H.incapacitated() || !(H.mobility_flags & MOBILITY_STAND))
		to_chat(H, span_warning("我现在没法跨上 [src]。"))
		return

	flyer_ref = WEAKREF(H)
	var/datum/status_effect/buff/fly/broom/effect = H.apply_status_effect(/datum/status_effect/buff/fly/broom, src)
	if(!effect || QDELETED(effect))
		to_chat(H, span_warning("魔法扫帚：飞行状态没有成功挂上。"))
		flyer_ref = null
		return

	H.visible_message(span_warning("[H] 跨上 [src]，扫帚缓缓升空。"),
		span_notice("我握紧扫帚，双脚离开了地面。"))
	playsound(H, 'sound/magic/haste.ogg', 50, TRUE)

/// 备用落地入口：右键扫帚图标不方便时，也可以从物品右键菜单里选“落地”。
/obj/item/broom/flying/verb/land()
	set name = "落地"
	set category = "Object"
	set src in usr
	var/mob/living/carbon/human/H = usr
	if(istype(H) && flyer_ref?.resolve() == H)
		H.remove_status_effect(/datum/status_effect/buff/fly)

/// 起飞/落地时把“手上”的扫帚贴图切成透明或恢复，避免和脚下的骑乘扫帚
/// overlay 重复显示。注意这里不改 icon_state，所以物品栏里的扫帚图标仍然可见。
/obj/item/broom/flying/proc/set_riding_visuals(active, mob/living/carbon/human/H)
	if(active)
		experimental_inhand = FALSE
		item_state = "broom_empty"
		lefthand_file = 'modular_z121/icon/flying_broom.dmi'
		righthand_file = 'modular_z121/icon/flying_broom.dmi'
	else
		experimental_inhand = initial(experimental_inhand)
		item_state = initial(item_state)
		lefthand_file = initial(lefthand_file)
		righthand_file = initial(righthand_file)
	if(istype(H) && H.is_holding(src))
		H.update_inv_hands()

/obj/item/broom/flying/dropped(mob/user)
	. = ..()
	stop_flight(user)

/obj/item/broom/flying/Destroy()
	var/mob/living/L = flyer_ref?.resolve()
	if(L)
		L.remove_status_effect(/datum/status_effect/buff/fly)
	flyer_ref = null
	return ..()

/// 结束这把扫帚的飞行。user 可能为空，因此优先用传进来的丢下者，
/// 其次再用 flyer_ref 兜底。
/obj/item/broom/flying/proc/stop_flight(mob/user)
	var/mob/living/L
	if(isliving(user))
		L = user
	else
		L = flyer_ref?.resolve()
	if(!L)
		return
	var/datum/status_effect/S = L.has_status_effect(/datum/status_effect/buff/fly)
	if(istype(S, /datum/status_effect/buff/fly/broom))
		L.remove_status_effect(/datum/status_effect/buff/fly)

// ---------------------------------------------------------------------------
// 飞行状态：继承飞行的 FLYING/浮动/上下楼/落地逻辑，外加骑乘贴图。
// ---------------------------------------------------------------------------
/datum/status_effect/buff/fly/broom
	alert_type = /atom/movable/screen/alert/status_effect/buff/fly/broom
	/// 人物被删除时也走 on_remove，确保骑乘贴图一起清理。
	on_remove_on_mob_delete = TRUE
	var/datum/weakref/broom_ref
	/// 骑乘贴图改用独立 effect 跟随，不修改人物 underlays。
	var/obj/effect/flying_broom_visual/riding_visual
	/// 拖尾节流。
	var/last_trail = 0

/datum/status_effect/buff/fly/broom/on_creation(mob/living/new_owner, obj/item/broom/flying/source)
	broom_ref = WEAKREF(source)
	duration = -1 // 无时限，落地才结束
	return ..(new_owner)

// 这里完全自己实现飞行逻辑，而不是依赖父类 fly 的 on_apply。
// 直接确保 FLYING 标志、静音脚步、悬浮动画和拖尾都生效。
/datum/status_effect/buff/fly/broom/on_apply()
	. = TRUE
	if(!owner || !ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/obj/item/broom/flying/B = broom_ref?.resolve()

	// 最关键的一步放最前面：即使后面的任何显示/手势逻辑出错，
	// FLYING 和静音脚步也必须先生效。
	H.movement_type |= FLYING
	H.flying = TRUE
	ADD_TRAIT(H, TRAIT_SILENT_FOOTSTEPS, FLYING_BROOM_TRAIT_SOURCE)
	H.add_movespeed_modifier(FLYING_BROOM_SPEED_ID, multiplicative_slowdown = -0.3)

	// 悬浮高度必须写进 mob_offsets：update_transform() 会不断把 pixel_y
	// 重置为标准值；只有 mob_offsets 里的偏移会被 get_standard_pixel_y_offset
	// 重新加回来，这样浮空才不会在移动/换装/更新外观时被抹掉。
	// 起飞时逐级升高到悬浮高度。
	H.set_mob_offsets(FLYING_BROOM_OFFSET_ID, 0, 0)
	for(var/i in 1 to 4)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(flying_broom_set_hover), H, min(i, FLYING_BROOM_HOVER_HEIGHT), TRUE), i)
	addtimer(CALLBACK(src, PROC_REF(finish_takeoff)), 0.5 SECONDS)

	// 复用飞行术的上/下楼层按钮。
	fly_up_action = new /datum/action/cooldown/spell/fly_up(H)
	fly_up_action.Grant(H)
	fly_down_action = new /datum/action/cooldown/spell/fly_down(H)
	fly_down_action.Grant(H)

	// 跟随移动/转向。
	RegisterSignal(H, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_dir_change))
	RegisterSignal(H, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

	// 起飞尘雾。
	var/turf/T = get_turf(H)
	if(T)
		for(var/i in 1 to 3)
			var/obj/effect/temp_visual/small_smoke/halfsecond/smoke = new(T)
			smoke.color = "#8fe9ff"
			smoke.pixel_x = rand(-8, 8)
			smoke.pixel_y = rand(0, 6)

	// 最后再隐藏手持贴图；即使这一步因为外观刷新出问题，也不会影响飞行本身。
	if(B)
		try
			B.set_riding_visuals(TRUE, H)
		catch(var/exception/e)
			to_chat(H, span_warning("扫帚飞行：隐藏手持贴图时出错 [e]（不影响飞行）。"))

	return TRUE

/// 起飞动画结束：固定在悬浮高度、开始上下浮动，并生成骑乘扫帚贴图。
/datum/status_effect/buff/fly/broom/proc/finish_takeoff()
	if(QDELETED(src) || !owner || QDELETED(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.set_mob_offsets(FLYING_BROOM_OFFSET_ID, 0, FLYING_BROOM_HOVER_HEIGHT)
	start_hover_bob()
	if(!riding_visual)
		riding_visual = new /obj/effect/flying_broom_visual(get_turf(H))
	riding_visual.update_from(H)

/datum/status_effect/buff/fly/broom/proc/start_hover_bob()
	if(QDELETED(src) || !owner || QDELETED(owner))
		return
	// 与哈比飞行完全相同的逐帧写法：第一段 loop=-1，第二段不写 loop。
	var/base_y = owner.pixel_y
	animate(owner, pixel_y = base_y + FLYING_BROOM_BOB_HEIGHT, time = 6, loop = -1)
	animate(owner, pixel_y = base_y - FLYING_BROOM_BOB_HEIGHT, time = 6)

/datum/status_effect/buff/fly/broom/tick()
	. = ..()
	var/obj/item/broom/flying/B = broom_ref?.resolve()
	if(!B || QDELETED(B) || !owner.is_holding(B) || owner.stat != CONSCIOUS || !(owner.mobility_flags & MOBILITY_STAND))
		owner.remove_status_effect(/datum/status_effect/buff/fly)
		return
	riding_visual?.update_from(owner)

/datum/status_effect/buff/fly/broom/on_remove()
	var/mob/living/carbon/human/H = owner
	var/obj/item/broom/flying/B = broom_ref?.resolve()
	if(B && !QDELETED(B))
		B.set_riding_visuals(FALSE, H)
		if(B.flyer_ref?.resolve() == H)
			B.flyer_ref = null
	QDEL_NULL(riding_visual)

	if(H && !QDELETED(H))
		UnregisterSignal(H, list(
			COMSIG_ATOM_DIR_CHANGE,
			COMSIG_MOVABLE_MOVED,
		))
		H.movement_type &= ~FLYING
		H.flying = FALSE
		REMOVE_TRAIT(H, TRAIT_SILENT_FOOTSTEPS, FLYING_BROOM_TRAIT_SOURCE)
		H.remove_movespeed_modifier(FLYING_BROOM_SPEED_ID)

		if(fly_up_action)
			fly_up_action.Remove(H)
			qdel(fly_up_action)
			fly_up_action = null
		if(fly_down_action)
			fly_down_action.Remove(H)
			qdel(fly_down_action)
			fly_down_action = null

		// 落地：逐级下降，最后移除 mob_offsets 偏移。
		animate(H)
		for(var/i in 1 to 4)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(flying_broom_set_hover), H, max(0, FLYING_BROOM_HOVER_HEIGHT - i), FALSE), i)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(flying_broom_finish_landing_offset), H), 0.5 SECONDS)
		var/turf/T = get_turf(H)
		if(T)
			for(var/i in 1 to 3)
				var/obj/effect/temp_visual/small_smoke/halfsecond/smoke = new(T)
				smoke.color = "#8fe9ff"
				smoke.pixel_x = rand(-8, 8)
				smoke.pixel_y = rand(0, 6)
			playsound(T, 'sound/magic/whiteflame.ogg', 40, TRUE)
			if(T.zFall(H))
				to_chat(H, span_warning("扫帚的魔力耗尽，我坠落下去！"))

/datum/status_effect/buff/fly/broom/proc/on_dir_change(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER
	riding_visual?.update_from(owner, new_dir)

/datum/status_effect/buff/fly/broom/proc/on_moved(datum/source)
	SIGNAL_HANDLER
	riding_visual?.update_from(owner)
	if(world.time < last_trail)
		return
	last_trail = world.time + FLYING_BROOM_TRAIL_COOLDOWN
	var/turf/T = get_turf(owner)
	if(!T)
		return
	var/obj/effect/temp_visual/small_smoke/halfsecond/trail = new(T)
	trail.color = "#8fe9ff"
	trail.pixel_x = rand(-6, 6)
	trail.pixel_y = rand(-2, 4)

// ---------------------------------------------------------------------------
// 骑乘扫帚的地面贴图。独立原子，跟随人物移动/转向，但不修改人物 appearance。
// ---------------------------------------------------------------------------
/obj/effect/flying_broom_visual
	name = ""
	desc = ""
	icon = 'modular_z121/icon/flying_broom_ridden.dmi'
	icon_state = "ridden_south"
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	density = FALSE
	anchored = TRUE
	/// 每个方向单独的位置微调：list(pixel_x, pixel_y)。
	/// 64×64 的画布放在 32×32 格子上时，pixel_x = -16 表示水平居中，
	/// pixel_y = 0 表示画布底边贴住格子底边。pixel_x 往右增加、pixel_y 往上增加。
	var/static/list/overlay_offsets = list(
		"south" = list(-16, -4),
		"north" = list(-16, -24),
		"east" = list(-16, 0),
		"west" = list(-16, 0),
	)
	/// 当前方向对应的基准 Y，用于避免每次移动都重置上下浮动动画。
	var/overlay_base_y = null

/obj/effect/flying_broom_visual/proc/update_from(mob/living/carbon/human/H, dir_override = null)
	if(QDELETED(H) || !isturf(H.loc))
		qdel(src)
		return
	if(loc != H.loc)
		forceMove(H.loc)
	var/use_dir = dir_override || H.dir
	var/dir_name = flying_broom_dir_name(use_dir)
	setDir(use_dir)
	icon_state = "ridden_[dir_name]"
	var/list/offsets = overlay_offsets[dir_name] || list(-16, 0)
	pixel_x = offsets[1] + H.pixel_x
	var/new_base_y = offsets[2] + H.pixel_y
	if(overlay_base_y != new_base_y)
		overlay_base_y = new_base_y
		animate(src)
		pixel_y = new_base_y
		animate(src, pixel_y = new_base_y + FLYING_BROOM_BOB_HEIGHT, time = 6, loop = -1)
		animate(src, pixel_y = new_base_y - FLYING_BROOM_BOB_HEIGHT, time = 6)
	set_glide_size(H.glide_size)

/// 起飞/降落时逐级调整 mob_offsets 里的悬浮高度。
/// require_flying = TRUE：只有骑扫帚状态仍存在时才继续（起飞）。
/// require_flying = FALSE：只有骑扫帚状态已不存在时才继续（降落）。
/proc/flying_broom_set_hover(mob/living/carbon/human/H, value, require_flying)
	if(QDELETED(H))
		return
	var/datum/status_effect/S = H.has_status_effect(/datum/status_effect/buff/fly)
	var/is_broom = istype(S, /datum/status_effect/buff/fly/broom)
	if(require_flying && !is_broom)
		return
	if(!require_flying && is_broom)
		return
	H.set_mob_offsets(FLYING_BROOM_OFFSET_ID, 0, value)

/// 降落动画结束，彻底移除悬浮偏移。
/proc/flying_broom_finish_landing_offset(mob/living/carbon/human/H)
	if(QDELETED(H))
		return
	var/datum/status_effect/S = H.has_status_effect(/datum/status_effect/buff/fly)
	if(istype(S, /datum/status_effect/buff/fly/broom)) // 又起飞了，不要清
		return
	H.reset_offsets(FLYING_BROOM_OFFSET_ID)

/// 把 DM 的 8 向 dir 映射到 4 张骑乘贴图。人类实际只会用四向，
/// 但斜向移动时 dir 可能是组合值，这里优先取水平分量。
/proc/flying_broom_dir_name(dir)
	if(dir & EAST)
		return "east"
	if(dir & WEST)
		return "west"
	if(dir & NORTH)
		return "north"
	return "south"

/atom/movable/screen/alert/status_effect/buff/fly/broom
	name = "魔法扫帚"
	desc = "我正骑着魔法扫帚。再次右键手中的扫帚即可落地。"
	icon_state = "buff"

#undef FLYING_BROOM_SPEED_ID
#undef FLYING_BROOM_HOVER_HEIGHT
#undef FLYING_BROOM_BOB_HEIGHT
#undef FLYING_BROOM_TRAIT_SOURCE
#undef FLYING_BROOM_OFFSET_ID
#undef FLYING_BROOM_TRAIL_COOLDOWN
