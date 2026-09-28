// 每日额度属于角色心智，换弓或重新获得法术不能刷新。
/datum/mind
	var/z121_heartpiercing_day = -1

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
	var/arrow_buff

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
	if(arrow_buff)
		. += span_info("持续时间：60秒；再次施放刷新持续时间。")

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

/obj/effect/proc_holder/spell/self/z121_arcane_archery/cast(list/targets, mob/living/user = usr)
	if(!get_ready_bow(user) || !arrow_buff)
		revert_cast(user)
		return FALSE
	user.apply_status_effect(arrow_buff)
	user.energy_add(-energy_cost)
	to_chat(user, span_notice("咒文的余音沉入指尖，弦上的微光随之应和。"))
	return ..()

/obj/effect/proc_holder/spell/self/z121_arcane_archery/empower
	name = "强化箭"
	desc = "将一段短促的咒文压进弓弦，松散的辉光便渐渐凝实，锋端隐约泛出冷铁般的光泽。这份锐意留不长，足够让接下来的几声弦响更沉一些。"
	recharge_time = 3 MINUTES
	cooldown_min = 3 MINUTES
	energy_cost = 300
	arrow_buff = /datum/status_effect/buff/z121_empowered_arrows
	overlay_state = "ironarrow"
	invocations = list("凝锋于矢！")

/obj/effect/proc_holder/spell/self/z121_arcane_archery/tracking
	name = "追踪箭"
	desc = "让目光先于箭锋落在猎物身上，再以低语系住那道身影。片刻之间，弦与血肉仿佛近在咫尺；披甲者仍可倚仗冷铁，灵巧的脚步却未必来得及。"
	recharge_time = 6 MINUTES
	cooldown_min = 6 MINUTES
	energy_cost = 600
	arrow_buff = /datum/status_effect/buff/z121_tracking_arrows
	invocations = list("意之所指，矢之所至！")

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
	// 不调用增益法术的父级施放，防止再次扣费或把穿心箭当作持续增益。
	SEND_SIGNAL(user, COMSIG_MOB_CAST_SPELL)
	record_featured_object_stat(FEATURED_STATS_SPELLS, name)
	return TRUE

/datum/status_effect/buff/z121_empowered_arrows
	id = "z121_empowered_arrows"
	duration = 60 SECONDS
	tick_interval = -1
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/z121_empowered_arrows

/datum/status_effect/buff/z121_tracking_arrows
	id = "z121_tracking_arrows"
	duration = 60 SECONDS
	tick_interval = -1
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/z121_tracking_arrows

/atom/movable/screen/alert/status_effect/z121_empowered_arrows
	name = "强化箭"
	desc = "凝在弦上的辉光添了几分冷铁的锋锐，咒文的余韵仍留在指间。"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "ironarrow"

/atom/movable/screen/alert/status_effect/z121_tracking_arrows
	name = "追踪箭"
	desc = "视线像一根无形的细线，牵着弦上的微光，系向尚在眼前的猎物。"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow"
