// 万箭齐发：只借用地面武器，动画与暂存对象均限制在本模块内。
#define THOUSAND_ARROWS_CHANNEL_TIME (2 SECONDS)
#define THOUSAND_ARROWS_GATHER_TIME (0.5 SECONDS)
#define THOUSAND_ARROWS_GLOW "#8edcff"

/obj/effect/proc_holder/spell/invoked/thousand_arrows
	name = "万箭齐发"
	desc = "以魔力托起周围散落的武器，使其环绕周身，再疾射向选定目标。奥术造诣越高，可同时驾驭的武器越多。奥术1至6级分别最多驾驭1至6把武器，点选目标后固定引导2秒。"
	school = "transmutation"
	spell_tier = 2
	cost = 5
	releasedrain = 30
	chargedrain = 0
	// 点选后在 perform 内引导，不再叠加鼠标按住蓄力。
	chargetime = 0
	recharge_time = 30 SECONDS
	range = 7
	human_req = TRUE
	gesture_required = TRUE
	associated_skill = /datum/skill/magic/arcane
	xp_gain = TRUE
	miracle = FALSE
	no_early_release = TRUE
	movement_interrupt = TRUE
	warnie = "spellwarning"
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "thousand_arrows"
	invocations = list("万兵听令，破空齐发！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	var/obj/effect/z121_arrow_volley/volley
	var/channeling = FALSE
	var/chant_spoken = FALSE

/obj/effect/proc_holder/spell/invoked/thousand_arrows/Destroy()
	QDEL_NULL(volley)
	return ..()

/obj/effect/proc_holder/spell/invoked/thousand_arrows/Click()
	if(channeling)
		deactivate(usr)
		return
	return ..()

/obj/effect/proc_holder/spell/invoked/thousand_arrows/on_deactivation(mob/user)
	QDEL_NULL(volley)
	return ..()

/obj/effect/proc_holder/spell/invoked/thousand_arrows/InterceptClickOn(mob/living/caller, params, atom/target)
	// 重复点选不能重入 cast_check，或退还正在引导的这次施法。
	if(channeling)
		return TRUE
	return ..()

/obj/effect/proc_holder/spell/invoked/thousand_arrows/process()
	if(channeling)
		last_process_time = world.time
		return
	return ..()

/obj/effect/proc_holder/spell/invoked/thousand_arrows/invocation(mob/user = usr)
	if(chant_spoken)
		return
	. = ..()
	chant_spoken = TRUE

/obj/effect/proc_holder/spell/invoked/thousand_arrows/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	stats -= span_info("Charge time: None")
	stats += span_info("点选后引导：2秒（固定）")
	if(user)
		stats += span_info("最多驾驭武器：[clamp(user.get_skill_level(associated_skill), 0, 6)]把")
	return stats

/obj/effect/proc_holder/spell/invoked/thousand_arrows/proc/valid_target(atom/target, mob/living/user)
	if(QDELETED(target) || QDELETED(user) || !isturf(user.loc))
		return FALSE
	if(!isturf(target) && !ismob(target) && !isobj(target))
		return FALSE
	var/turf/target_turf = get_turf(target)
	if(!target_turf || target_turf == user.loc || target_turf.z != user.z)
		return FALSE
	if(get_dist(user, target_turf) > range)
		return FALSE
	return target in view(range, user)

/obj/effect/proc_holder/spell/invoked/thousand_arrows/proc/eligible_weapon(obj/item/weapon, mob/living/user)
	if(QDELETED(weapon) || !isturf(weapon.loc) || weapon.anchored || weapon.throwing)
		return FALSE
	if(!istype(weapon, /obj/item/rogueweapon) && !istype(weapon, /obj/item/gun))
		return FALSE
	if(weapon.move_resist == INFINITY || weapon.z != user.z || get_dist(user, weapon) > 1)
		return FALSE
	return weapon in view(1, user)

/obj/effect/proc_holder/spell/invoked/thousand_arrows/proc/select_weapons(mob/living/user, weapon_limit)
	var/list/nearby = list()
	var/list/at_feet = list()
	for(var/obj/item/weapon in view(1, user))
		if(!eligible_weapon(weapon, user))
			continue
		if(weapon.loc == user.loc)
			at_feet += weapon
		else
			nearby += weapon
	var/list/selected = list()
	while(length(selected) < weapon_limit && (length(at_feet) || length(nearby)))
		var/list/pool = length(at_feet) ? at_feet : nearby
		var/obj/item/weapon = pick(pool)
		pool -= weapon
		selected += weapon
	return selected

/obj/effect/proc_holder/spell/invoked/thousand_arrows/proc/refund_volley(mob/living/user)
	QDEL_NULL(volley)
	channeling = FALSE
	chant_spoken = FALSE
	if(!QDELETED(user))
		revert_cast(user)
	else
		charge_counter = recharge_time
		last_process_time = world.time
		START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/invoked/thousand_arrows/proc/channel_is_intact(mob/living/user)
	if(QDELETED(src) || QDELETED(volley) || QDELETED(user))
		return FALSE
	if(!active || ranged_ability_user != user || !length(volley.weapons))
		return FALSE
	if(user.loc != volley.origin || user.stat || HAS_TRAIT(user, TRAIT_SPELLCOCKBLOCK) || HAS_TRAIT(user, TRAIT_PARALYSIS))
		return FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(human_user.handcuffed || !human_user.has_active_hand())
			return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/thousand_arrows/perform(list/targets, recharge = TRUE, mob/user = usr)
	if(channeling || QDELETED(user) || !isliving(user))
		return FALSE
	var/mob/living/caster = user
	var/atom/target = length(targets) ? targets[1] : null
	if(!valid_target(target, caster))
		to_chat(caster, span_warning("我必须选择七格内可见的目标，且不能指向自己脚下。"))
		refund_volley(caster)
		return FALSE
	var/weapon_limit = clamp(caster.get_skill_level(associated_skill), 0, 6)
	if(!weapon_limit)
		to_chat(caster, span_warning("我的奥术造诣还不足以驾驭这些武器。"))
		refund_volley(caster)
		return FALSE
	var/list/selected = select_weapons(caster, weapon_limit)
	if(!length(selected))
		to_chat(caster, span_warning("我周围一格内没有可以驾驭的地面武器。"))
		refund_volley(caster)
		return FALSE
	var/action_coefficient = caster.do_after_coefficent()
	if(caster.doing || action_coefficient <= 0)
		to_chat(caster, span_warning("我现在无法专注引导这些武器。"))
		refund_volley(caster)
		return FALSE

	channeling = TRUE
	chant_spoken = FALSE
	caster.stop_attack()
	volley = new(caster.loc, caster)
	for(var/obj/item/weapon as anything in selected)
		if(QDELETED(volley))
			break
		if(eligible_weapon(weapon, caster))
			volley.capture(weapon)
	if(QDELETED(volley) || !length(volley.weapons))
		refund_volley(caster)
		return FALSE
	volley.begin_animation()
	invocation(caster)
	// do_after 内部会乘行动时间系数，在入口抵消该系数以保持固定两秒。
	var/completed = do_after(caster, z121_channel(THOUSAND_ARROWS_CHANNEL_TIME, caster) / action_coefficient, target = caster, progress = TRUE, extra_checks = CALLBACK(src, PROC_REF(channel_is_intact), caster))
	if(QDELETED(src))
		return FALSE
	if(!completed || !channel_is_intact(caster))
		if(!QDELETED(caster))
			to_chat(caster, span_warning("我的御兵术被打断了，悬浮的武器纷纷落地。"))
		refund_volley(caster)
		return FALSE
	if(!valid_target(target, caster))
		to_chat(caster, span_warning("目标已经离开了我的施法范围，武器失去牵引，落回地面。"))
		refund_volley(caster)
		return FALSE

	// 仅在引导成功后进入通用 perform，由框架结算一次疲劳、经验及冷却。
	. = ..(targets, recharge, caster)
	if(!QDELETED(src))
		QDEL_NULL(volley)
		channeling = FALSE
		chant_spoken = FALSE

/obj/effect/proc_holder/spell/invoked/thousand_arrows/cast(list/targets, mob/living/user = usr)
	if(QDELETED(volley) || !valid_target(targets[1], user))
		refund_volley(user)
		return FALSE
	volley.z121_meta_power = z121_power(1)
	var/launched = volley.launch(targets[1], user)
	if(QDELETED(src))
		return FALSE
	QDEL_NULL(volley)
	channeling = FALSE
	if(!launched)
		to_chat(user, span_warning("没有武器成功破空而出。"))
		refund_volley(user)
		return FALSE
	// 从实际齐射时刻开始冷却，读条时间不计入冷却。
	charge_counter = 0
	last_process_time = world.time
	..()
	return TRUE

// 真实武器只在这次引导期间存放于此，外观由独立的临时对象显示。
/obj/effect/z121_arrow_volley
	name = "御兵术"
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_system = MOVABLE_LIGHT
	light_color = THOUSAND_ARROWS_GLOW
	light_power = 0.5
	light_outer_range = 1.5
	var/turf/origin
	var/mob/living/caster
	var/list/weapons = list()

/obj/effect/z121_arrow_volley/Initialize(mapload, mob/living/new_caster)
	. = ..()
	origin = get_turf(src)
	caster = new_caster
	if(caster)
		RegisterSignal(caster, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED), PROC_REF(on_caster_lost))
	set_light_on(TRUE)

/obj/effect/z121_arrow_volley/proc/on_caster_lost(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/obj/effect/z121_arrow_volley/proc/capture(obj/item/weapon)
	var/obj/effect/z121_arrow_image/visual = new(origin, weapon)
	weapon.forceMove(src)
	if(QDELETED(src) || QDELETED(weapon) || weapon.loc != src)
		if(!QDELETED(weapon) && weapon.loc == src)
			weapon.forceMove(get_turf(visual))
		qdel(visual)
		return
	weapons[weapon] = visual
	RegisterSignal(weapon, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED), PROC_REF(on_weapon_lost))

/obj/effect/z121_arrow_volley/proc/on_weapon_lost(obj/item/weapon)
	SIGNAL_HANDLER
	if(QDELETED(weapon) || weapon.loc != src)
		forget_weapon(weapon)

/obj/effect/z121_arrow_volley/proc/forget_weapon(obj/item/weapon)
	var/obj/effect/z121_arrow_image/visual = weapons[weapon]
	weapons -= weapon
	UnregisterSignal(weapon, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	if(!QDELETED(visual))
		qdel(visual)

/obj/effect/z121_arrow_volley/proc/begin_animation()
	var/index = 0
	var/total = length(weapons)
	for(var/obj/item/weapon as anything in weapons)
		index++
		var/obj/effect/z121_arrow_image/visual = weapons[weapon]
		visual.float_into_position(index, total)

/obj/effect/z121_arrow_volley/proc/launch(atom/target, mob/living/thrower)
	var/launched = 0
	for(var/obj/item/weapon as anything in weapons.Copy())
		if(QDELETED(src) || QDELETED(target) || QDELETED(thrower))
			break
		if(QDELETED(weapon) || weapon.loc != src)
			continue
		forget_weapon(weapon)
		weapon.forceMove(origin)
		if(QDELETED(weapon) || weapon.loc != origin || weapon.anchored || weapon.throwing)
			continue
		// /obj/throw_at 未传回父类的成功值，以 POST_THROW 信号为准。
		var/datum/z121_arrow_flight/flight = new
		flight.z121_meta_power = z121_meta_power
		if(flight.launch(weapon, target, thrower))
			launched++
	return launched

// 单次御兵投掷的跟踪器。独立于蓄力容器，齐射后仍存活到本次投掷结束。
// 高速投掷会在一拍内走过多格，通用 tick 只在拍首 hitcheck，且终点
// finalize 的同名 target 参数遮蔽了选定目标。仅为本法术逐格补正常命中。
/datum/z121_arrow_flight
	// 仅本次御兵投掷借用伤害倍率，落地、取消和删除都会还原武器。
	var/z121_original_throwforce
	var/obj/item/weapon
	var/datum/thrownthing/flight
	var/started = FALSE
	var/launch_pending = TRUE
	var/finished = FALSE

/datum/z121_arrow_flight/proc/launch(obj/item/new_weapon, atom/target, mob/living/thrower)
	weapon = new_weapon
	if(z121_meta_power != 1)
		z121_original_throwforce = weapon.throwforce
		weapon.throwforce *= z121_meta_power
	RegisterSignal(weapon, COMSIG_MOVABLE_POST_THROW, PROC_REF(on_throw_started))
	RegisterSignal(weapon, COMSIG_QDELETING, PROC_REF(on_flight_finished))
	weapon.throw_at(target, 8, 4, thrower)
	// 近距离命中可能在 throw_at 返回前就结束投掷，因此不能用 weapon.throwing 计数。
	. = started
	launch_pending = FALSE
	if(!started || finished)
		qdel(src)

/datum/z121_arrow_flight/proc/on_throw_started(obj/item/source, datum/thrownthing/throwingdatum, spin)
	SIGNAL_HANDLER
	if(started || finished)
		return
	started = TRUE
	flight = throwingdatum
	// 物品存在覆盖 throw_at 的实现；命中效果仍需要正确的投掷者归属。
	source.thrownby = throwingdatum.thrower
	UnregisterSignal(source, COMSIG_MOVABLE_POST_THROW)
	RegisterSignal(source, COMSIG_MOVABLE_MOVED, PROC_REF(on_weapon_moved))
	RegisterSignal(flight, COMSIG_QDELETING, PROC_REF(on_flight_finished))

/datum/z121_arrow_flight/proc/on_weapon_moved(obj/item/source, atom/old_loc, direction, forced)
	SIGNAL_HANDLER
	if(finished)
		return
	if(QDELETED(flight) || source.throwing != flight || !isturf(source.loc) || forced)
		finish_tracking()
		return
	// hitcheck 优先处理途中的实体障碍和生物；hit_atom 只执行一次正常 throw_impact。
	// 命中可能嵌入或删除武器，并同步终止本跟踪器，故命中后直接返回。
	var/datum/thrownthing/current_flight = flight
	if(current_flight.hitcheck())
		return
	var/atom/movable/selected_target = current_flight.target
	if(ismovable(selected_target) && !QDELETED(selected_target) && selected_target != source && selected_target != current_flight.thrower && selected_target.loc == source.loc)
		// 也允许击中被直接点选的倒地目标；不对已离开弹道的目标补远程伤害。
		current_flight.hit_atom(selected_target)

/datum/z121_arrow_flight/proc/on_flight_finished(datum/source)
	SIGNAL_HANDLER
	finish_tracking()

/datum/z121_arrow_flight/proc/finish_tracking()
	if(finished)
		return
	finished = TRUE
	z121_restore_throwforce()
	if(weapon)
		UnregisterSignal(weapon, list(COMSIG_MOVABLE_POST_THROW, COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	if(flight)
		UnregisterSignal(flight, COMSIG_QDELETING)
	weapon = null
	flight = null
	// 同步命中时保留 started，供尚未返回的 launch 正确结算成功次数。
	if(!launch_pending)
		qdel(src)

/datum/z121_arrow_flight/Destroy()
	z121_restore_throwforce()
	if(weapon)
		UnregisterSignal(weapon, list(COMSIG_MOVABLE_POST_THROW, COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	if(flight)
		UnregisterSignal(flight, COMSIG_QDELETING)
	weapon = null
	flight = null
	return ..()

/datum/z121_arrow_flight/proc/z121_restore_throwforce()
	if(weapon && !isnull(z121_original_throwforce))
		weapon.throwforce = z121_original_throwforce
		z121_original_throwforce = null

/obj/effect/z121_arrow_volley/Destroy()
	if(caster)
		UnregisterSignal(caster, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	for(var/obj/item/weapon as anything in weapons.Copy())
		forget_weapon(weapon)
		if(!QDELETED(weapon) && weapon.loc == src)
			weapon.forceMove(origin)
	// 包括 forceMove 回调中途终止时尚未登记的武器，避免父类删除容器内容。
	for(var/obj/item/weapon in contents.Copy())
		if(!QDELETED(weapon))
			weapon.forceMove(origin)
	weapons = null
	caster = null
	origin = null
	return ..()

/obj/effect/z121_arrow_image
	name = "悬浮的武器"
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/z121_arrow_image/Initialize(mapload, obj/item/weapon)
	. = ..()
	var/turf/start = get_turf(weapon)
	var/turf/center = get_turf(src)
	appearance = weapon.appearance
	filter_data = weapon.filter_data?.Copy()
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	pixel_x = (start.x - center.x) * world.icon_size + weapon.pixel_x
	pixel_y = (start.y - center.y) * world.icon_size + weapon.pixel_y
	add_filter("thousand_arrows_outline", 2, list("type" = "outline", "color" = THOUSAND_ARROWS_GLOW, "alpha" = 180, "size" = 1))

/obj/effect/z121_arrow_image/proc/float_into_position(index, total)
	var/angle = 90 + 360 * (index - 1) / total
	var/hover_x = round(cos(angle) * 24)
	var/hover_y = 12 + round(sin(angle) * 16)
	animate(src, pixel_x = hover_x, pixel_y = hover_y, time = THOUSAND_ARROWS_GATHER_TIME, easing = SINE_EASING)
	animate(pixel_y = hover_y + 3, time = 0.5 SECONDS, easing = SINE_EASING)
	animate(pixel_y = hover_y - 3, time = 0.5 SECONDS, easing = SINE_EASING)
	animate(pixel_y = hover_y, time = 0.5 SECONDS, easing = SINE_EASING)

/obj/effect/z121_arrow_image/Destroy()
	animate(src)
	remove_filter("thousand_arrows_outline")
	return ..()

#undef THOUSAND_ARROWS_CHANNEL_TIME
#undef THOUSAND_ARROWS_GATHER_TIME
#undef THOUSAND_ARROWS_GLOW
