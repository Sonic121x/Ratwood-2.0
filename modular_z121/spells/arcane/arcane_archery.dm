// 每日额度属于角色心智，换弓或重新获得法术不能刷新。
/datum/mind
	var/z121_heartpiercing_day = -1
	var/datum/weakref/z121_bound_bow_ref

/obj/effect/proc_holder/spell/self/z121_arcane_archery
	name = "魔弓术"
	school = "transmutation"
	human_req = TRUE
	gesture_required = TRUE
	miracle = FALSE
	cost = 0
	chargetime = 0
	chargedrain = 0
	releasedrain = 0
	recharge_time = 1 SECONDS
	cooldown_min = 1 SECONDS
	is_cdr_exempt = TRUE
	associated_skill = /datum/skill/magic/arcane
	base_action = /datum/action/spell_action/spell/z121_arcane_archery
	action_icon = 'icons/roguetown/weapons/ammo.dmi'
	overlay_state = "arrow"
	invocation_type = "whisper"
	sound = list('sound/magic/whiteflame.ogg')
	var/energy_cost = 0

// 卷轴与箭矢来自不同图集，分别叠加，保留普通法术的激活底图与按钮着色。
/datum/action/spell_action/spell/z121_arcane_archery/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(!icon_icon || !button_icon_state || (!force && current_button.button_icon_state == button_icon_state))
		return
	current_button.cut_overlays(TRUE)
	current_button.add_overlay(mutable_appearance('icons/mob/actions/roguespells.dmi', button_icon_state, layer = current_button.layer + 0.1))
	if(overlay_state)
		var/mutable_appearance/arrow_icon = mutable_appearance(icon_icon, overlay_state, layer = current_button.layer + 0.2)
		arrow_icon.alpha = overlay_alpha
		current_button.add_overlay(arrow_icon)
	current_button.button_icon_state = button_icon_state

/obj/effect/proc_holder/spell/self/z121_arcane_archery/start_recharge()
	// 使用各箭术自身的固定冷却，不受智力、技能或地脉加速改变。
	recharge_time = initial(recharge_time)
	last_process_time = world.time
	START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/self/z121_arcane_archery/get_spell_statistics(mob/living/user)
	. = ..()
	. += span_info("法力消耗：[energy_cost]（能量）")

/obj/effect/proc_holder/spell/self/z121_arcane_archery/proc/get_ready_bow(mob/living/user)
	if(QDELETED(user) || !user.mind)
		return null
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/bow = user.get_active_held_item()
	if(!istype(bow))
		to_chat(user, span_warning("我必须在主手持握魔弓，才能施放这道箭术。"))
		return null
	if(user.energy < energy_cost)
		to_chat(user, span_warning("我的法力不足[energy_cost]点。"))
		return null
	return bow

/obj/effect/proc_holder/spell/self/z121_arcane_archery/heartpiercing
	name = "穿心箭"
	desc = "把胸中尚存的余火尽数牵上弓弦，凝成一线近乎寂静的寒芒。它仍须由你的手送入血肉，而它留下的空隙，往往连热血也填不满。弦上的光一旦成形，纵然散去，也只能等下一个黎明再念此咒。"
	energy_cost = 300
	overlay_state = "steelarrow"
	invocations = list("倾尽此身，穿心一矢！")

/obj/effect/proc_holder/spell/self/z121_arcane_archery/heartpiercing/get_spell_statistics(mob/living/user)
	. = ..()
	. += span_info("实际消耗：全部当前法力；成功凝箭即消耗当日次数。")
	if(user?.mind)
		. += span_info("今日剩余次数：[user.mind.z121_heartpiercing_day < GLOB.dayspassed ? 1 : 0]")

/obj/effect/proc_holder/spell/self/z121_arcane_archery/heartpiercing/cast(list/targets, mob/living/user = usr)
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/bow = get_ready_bow(user)
	if(!bow)
		revert_cast(user)
		return FALSE
	if(user.mind.z121_heartpiercing_day >= GLOB.dayspassed)
		to_chat(user, span_warning("我今日已经凝聚过穿心箭，必须等待下一个黎明。"))
		revert_cast(user)
		return FALSE
	if(istype(bow.chambered, /obj/item/ammo_casing/caseless/rogue/arrow/magic/heartpiercing))
		to_chat(user, span_warning("弓上已经凝聚着一支穿心箭。"))
		revert_cast(user)
		return FALSE
	if(!bow.nock_magic_arrow(user, user.energy))
		revert_cast(user)
		return FALSE
	user.mind.z121_heartpiercing_day = GLOB.dayspassed
	to_chat(user, span_notice("胸中的余火已尽，弦上却多了一线沉静的寒芒。我稳住发空的手，尚未松弦。"))
	return ..()

/obj/effect/proc_holder/spell/self/z121_arcane_archery/binding
	name = "武器绑定"
	desc = "指尖记得那道旧弦的触感，弓臂也记得掌心的温度。轻声唤它，散落在远处的回音便会循着这份记忆归来；除非那张弓已彻底沉默。"
	recharge_time = 1 MINUTES
	cooldown_min = 1 MINUTES
	action_icon = 'icons/mob/actions/roguespells.dmi'
	overlay_state = "fetch"
	invocations = list("循我余音，归来弦上。")

/obj/effect/proc_holder/spell/self/z121_arcane_archery/binding/get_spell_statistics(mob/living/user)
	. = ..()
	var/obj/item/bow = user?.mind?.z121_bound_bow_ref?.resolve()
	. += span_info("当前绑定：[bow ? bow.name : "无"]；冷却60秒。原弓毁坏后，主手持魔弓可重新绑定。")

/obj/effect/proc_holder/spell/self/z121_arcane_archery/binding/cast(list/targets, mob/living/user = usr)
	if(!user?.mind)
		revert_cast(user)
		return FALSE
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/bow = user.mind.z121_bound_bow_ref?.resolve()
	if(!bow)
		bow = user.get_active_held_item()
		if(!istype(bow) || !bow.bind_to_archer(user.mind))
			to_chat(user, span_warning("我需要主手握住一张尚未回应他人的魔弓。"))
			revert_cast(user)
			return FALSE
		to_chat(user, span_notice("指尖的余音留在弓弦深处，从此便有了归处。"))
		return ..()
	if(bow in user.held_items)
		to_chat(user, span_notice("熟悉的弓弦已在我的掌中。"))
		revert_cast(user)
		return FALSE
	if(!bow.recall_to_archer(user))
		to_chat(user, span_warning("我听见了弓弦的回音，却无法将它带回。"))
		revert_cast(user)
		return FALSE
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/proc/bind_to_archer(datum/mind/archer)
	var/datum/mind/bound_mind = bound_mind_ref?.resolve()
	if(!archer || (bound_mind && bound_mind != archer) || obj_destroyed || (item_flags & ABSTRACT) || (SEND_SIGNAL(src, COMSIG_ITEM_MARK_RETRIEVAL) & COMPONENT_BLOCK_MARK_RETRIEVAL))
		return FALSE
	var/obj/item/existing_bow = archer.z121_bound_bow_ref?.resolve()
	if(existing_bow && existing_bow != src)
		return FALSE
	bound_mind_ref = WEAKREF(archer)
	archer.z121_bound_bow_ref = WEAKREF(src)
	return TRUE

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic/proc/recall_to_archer(mob/living/user)
	if(QDELETED(user) || user.mind != bound_mind_ref?.resolve() || obj_destroyed || !get_turf(src) || !isturf(user.loc) || (item_flags & ABSTRACT) || HAS_TRAIT(src, TRAIT_NODROP))
		return FALSE
	// 检查容器链，不把箱子或携带者连同魔弓一并传送。
	var/atom/container = src
	while(container && !isturf(container))
		if((SEND_SIGNAL(container, COMSIG_ITEM_MARK_RETRIEVAL) & COMPONENT_BLOCK_MARK_RETRIEVAL) || SEND_SIGNAL(container, COMSIG_IS_STORAGE_LOCKED))
			return FALSE
		if(isitem(container))
			var/obj/item/container_item = container
			if(container_item.item_flags & ABSTRACT)
				return FALSE
		container = container.loc
	var/turf/origin = get_turf(src)
	var/turf/destination = user.drop_location()
	if(ismob(loc))
		var/mob/holder = loc
		if(!holder.dropItemToGround(src))
			return FALSE
	else if(!isturf(loc))
		var/datum/component/storage/storage = loc.GetComponent(/datum/component/storage)
		if(!storage || !storage.remove_from_storage(src, origin))
			return FALSE
	if(QDELETED(src) || !isturf(loc))
		return FALSE
	clear_magic_arrow()
	origin.visible_message(span_notice("[src]的轮廓在一声轻响中散去。"))
	forceMove(destination)
	user.put_in_hands(src)
	to_chat(user, span_notice("熟悉的弦音重新落在我身畔。"))
	return TRUE

// 每次移速重新计算后只乘一次，重复命中仅刷新状态期限。
/datum/status_effect/z121_arrow_frost
	id = "z121_arrow_frost"
	duration = 5 SECONDS
	tick_interval = -1
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/z121_arrow_frost
	var/hostile_delay
	var/datum/weakref/slowed_ai_ref
	var/ai_delay

/datum/status_effect/z121_arrow_frost/on_apply()
	RegisterSignal(owner, COMSIG_MOB_MOVESPEED_UPDATED, PROC_REF(slow_movement))
	owner.update_movespeed()
	// 旧式追逐与新式人工智能各有独立步进时钟，玩家移速缓存不会影响它们。
	if(istype(owner, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/hostile = owner
		hostile_delay = hostile.move_to_delay
		hostile.move_to_delay *= 1.25
		refresh_pursuit(hostile)
	var/datum/ai_controller/controller = owner.ai_controller
	if(istype(controller))
		slowed_ai_ref = WEAKREF(controller)
		ai_delay = controller.movement_delay
		controller.movement_delay *= 1.25
	return TRUE

/datum/status_effect/z121_arrow_frost/proc/slow_movement(mob/source)
	SIGNAL_HANDLER
	source.cached_multiplicative_slowdown *= 1.25

/datum/status_effect/z121_arrow_frost/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_MOVESPEED_UPDATED)
	owner.update_movespeed()
	// 只有时钟仍等于本效果写入值时才还原，避免覆盖后续行为切换设置的新速度。
	if(istype(owner, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/hostile = owner
		if(hostile.move_to_delay == hostile_delay * 1.25)
			hostile.move_to_delay = hostile_delay
			refresh_pursuit(hostile)
	var/datum/ai_controller/controller = slowed_ai_ref?.resolve()
	if(controller && controller.movement_delay == ai_delay * 1.25)
		controller.movement_delay = ai_delay
	slowed_ai_ref = null
	return ..()

/datum/status_effect/z121_arrow_frost/proc/refresh_pursuit(mob/living/simple_animal/hostile/hostile)
	if(!hostile.client && !hostile.ai_controller && hostile.stat == CONSCIOUS && hostile.approaching_target && hostile.target)
		hostile.Goto(hostile.target, hostile.move_to_delay, hostile.minimum_distance)

/atom/movable/screen/alert/status_effect/z121_arrow_frost
	name = "霜缚"
	desc = "残留的寒意缠住了我的脚步。"
	icon_state = "debuff"
