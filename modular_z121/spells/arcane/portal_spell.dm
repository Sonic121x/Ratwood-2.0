// 固定引导与可减免冷却分开处理，绑定坐标不随地块替换而丢失。
#define Z121_PORTAL_CHANNEL (10 SECONDS)
#define Z121_PORTAL_LIFETIME (1 MINUTES)
#define Z121_PORTAL_TRAVEL_CHANNEL (6 SECONDS)

/obj/effect/proc_holder/spell/self/z121_portal
	name = "传送门"
	desc = "在熟悉之地留下一缕魔力的回响，纵使远行千里，也能循着那道余韵，将相隔的两端折叠为一步之遥。只是世间的缝隙，从不肯长久敞开。"
	school = "transmutation"
	spell_tier = 4
	cost = 8
	xp_gain = TRUE
	chargetime = Z121_PORTAL_CHANNEL
	recharge_time = 12 MINUTES
	cooldown_min = 12 MINUTES
	is_cdr_exempt = FALSE
	releasedrain = 0
	chargedrain = 0
	human_req = TRUE
	gesture_required = TRUE
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'icons/roguetown/misc/structure.dmi'
	action_icon_state = "shitportal"
	base_action = /datum/action/spell_action/spell/z121_portal
	invocations = list("循回响，折远途，启门扉。")
	invocation_type = "whisper"
	var/anchor_x
	var/anchor_y
	var/anchor_z
	var/channeling = FALSE
	var/binding_cast = FALSE
	var/mob/living/carbon/human/channeling_user
	var/list/active_portals = list()

/obj/effect/proc_holder/spell/self/z121_portal/Destroy()
	channeling = FALSE
	binding_cast = FALSE
	channeling_user = null
	close_portals()
	return ..()

/obj/effect/proc_holder/spell/self/z121_portal/update_icon()
	if(!action)
		return
	// 通用法术会改用卷轴图标态；传送门图集没有该状态，直接保留门扉图标。
	action.button_icon_state = action_icon_state
	action.name = name
	action.UpdateButtonIcon()

// 按钮使用卷轴基底与传送门第一帧；仅在内存中取帧，不新增图标文件。
/datum/action/spell_action/spell/z121_portal/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(!icon_icon || !button_icon_state || (!force && current_button.button_icon_state == button_icon_state))
		return
	var/static/icon/portal_frame = icon('icons/roguetown/misc/structure.dmi', "shitportal", SOUTH, 1)
	current_button.cut_overlays(TRUE)
	current_button.add_overlay(mutable_appearance('icons/mob/actions/roguespells.dmi', "spell0", layer = current_button.layer + 0.1))
	current_button.add_overlay(mutable_appearance(portal_frame, layer = current_button.layer + 0.2))
	current_button.button_icon_state = button_icon_state

/obj/effect/proc_holder/spell/self/z121_portal/get_chargetime()
	return Z121_PORTAL_CHANNEL

/obj/effect/proc_holder/spell/self/z121_portal/calculate_chargetime(mob/living/user)
	return Z121_PORTAL_CHANNEL

/obj/effect/proc_holder/spell/self/z121_portal/Click()
	// 冷却或引导中的重复点击不得进入父类的失败返还路径。
	if(channeling || !ishuman(usr) || !charge_check(usr))
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/self/z121_portal/can_cast(mob/user = usr)
	if(channeling)
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/self/z121_portal/charge_check(mob/user, silent = FALSE)
	// 结束引导时允许复查本次已经预留冷却的施法，其余条件仍需通过。
	if(channeling && user == channeling_user)
		return TRUE
	return ..()

/obj/effect/proc_holder/spell/self/z121_portal/process()
	if(channeling)
		last_process_time = world.time
		return
	return ..()

/obj/effect/proc_holder/spell/self/z121_portal/start_recharge()
	if(binding_cast)
		// 绑定不启动通用冷却，也不留下管理员倍率的待结算状态。
		z121_cooldown_pending = FALSE
		z121_cooldown_running = FALSE
		last_process_time = world.time
		STOP_PROCESSING(SSfastprocess, src)
		finish_recharge()
		return
	return ..()

/obj/effect/proc_holder/spell/self/z121_portal/finish_recharge()
	. = ..()
	// 恢复计数时同步清除数字，避免已经可用却仍显示冷却。
	if(action?.button)
		action.button.update_maptext(0)

/obj/effect/proc_holder/spell/self/z121_portal/choose_targets(mob/user = usr)
	if(channeling)
		return
	if(!ishuman(user) || !user.mind || !user.client || !isturf(user.loc))
		cancel_portal_cast(user)
		return

	var/mob/living/carbon/human/caster = user
	var/datum/mind/casting_mind = caster.mind
	var/client/casting_client = caster.client
	var/action_coefficient = caster.do_after_coefficent()
	if(caster.doing || action_coefficient <= 0)
		to_chat(caster, span_warning("我此刻无法静心编织门扉。"))
		cancel_portal_cast(caster)
		return

	var/binding = !anchor_z
	// 先求出提示文本，避免条件表达式在文字宏展开后参与字符串加法。
	var/channel_message = binding ? "我静心将此地的回响编入魔力之中……" : "我循着远方的回响，开始编织连接两端的门扉……"
	binding_cast = binding
	channeling = TRUE
	channeling_user = caster
	STOP_PROCESSING(SSfastprocess, src)
	caster.visible_message(
		span_notice("[caster] 轻拂身前的空气，指尖的魔力缓缓织成一道幽微的弧线。"),
		span_notice(channel_message)
	)
	// 通用动作会再乘一次系数，在入口抵消它，保持完整十秒。
	var/completed = do_after(caster, Z121_PORTAL_CHANNEL / action_coefficient, target = caster, progress = TRUE, extra_checks = CALLBACK(src, PROC_REF(can_channel_portal), caster, casting_mind, casting_client))
	if(QDELETED(src))
		return
	if(!completed || !can_channel_portal(caster, casting_mind, casting_client) || !cast_check(TRUE, caster))
		if(!QDELETED(caster))
			to_chat(caster, span_warning("魔力的弧线散开了，我未能完成这次编织。"))
		cancel_portal_cast(caster)
		return

	// 仅在引导完成后进入通用结算，开门冷却从成功时刻开始。
	var/success = perform(null, user = caster)
	if(QDELETED(src))
		return
	if(!success)
		cancel_portal_cast(caster)
		return
	channeling = FALSE
	channeling_user = null
	binding_cast = FALSE
	if(binding)
		// 首次只留下锚点，立即恢复可用，不等待开门冷却。
		finish_recharge()
	action?.UpdateButtonIcon()

/obj/effect/proc_holder/spell/self/z121_portal/cast(list/targets, mob/living/user = usr)
	if(!channeling || user != channeling_user || QDELETED(user))
		return FALSE
	var/turf/source = get_turf(user)
	if(!portal_turf_is_clear(source))
		to_chat(user, span_warning("此处的空间无法容纳稳定的门扉。"))
		return FALSE
	if(!anchor_z)
		anchor_x = source.x
		anchor_y = source.y
		anchor_z = source.z
		to_chat(user, span_notice("此地的回响已铭入我的魔力，无论远行何处，它都会为门扉指引归途。"))
	else
		var/turf/destination = locate(anchor_x, anchor_y, anchor_z)
		if(source == destination)
			to_chat(user, span_warning("我已站在回响的源头，门扉的两端无法在此重叠。"))
			return FALSE
		if(!portal_turf_is_clear(destination))
			to_chat(user, span_warning("远方的回响仍在，但那里已无法容纳门扉。"))
			return FALSE
		var/list/new_portals = create_portal_pair(source, destination, src, Z121_PORTAL_LIFETIME, 0, /obj/effect/portal/z121_arcane, FALSE)
		if(length(new_portals) != 2)
			return FALSE
		// 新门连接成功之后再关闭旧门，不因失败施放拆掉已有通路。
		close_portals()
		active_portals = new_portals
		playsound(source, 'sound/misc/portalopen.ogg', 60, TRUE)
		playsound(destination, 'sound/misc/portalopen.ogg', 60, TRUE)
		to_chat(user, span_notice("相隔的回响在门扉中交汇，短暂的通路已然敞开。"))
	charge_counter = 0
	last_process_time = world.time
	..()
	return TRUE

/obj/effect/proc_holder/spell/self/z121_portal/proc/can_channel_portal(mob/living/carbon/human/caster, datum/mind/casting_mind, client/casting_client)
	if(QDELETED(src) || QDELETED(caster) || QDELETED(casting_mind))
		return FALSE
	if(!channeling || channeling_user != caster || !casting_client || caster.client != casting_client)
		return FALSE
	if(caster.mind != casting_mind || caster.incapacitated() || !isturf(caster.loc))
		return FALSE
	return (src in casting_mind.spell_list) || (src in caster.mob_spell_list)

/obj/effect/proc_holder/spell/self/z121_portal/proc/portal_turf_is_clear(turf/location)
	if(!isopenturf(location) || location.density || location.is_transition_turf())
		return FALSE
	var/area/portal_area = get_area(location)
	if(!portal_area || portal_area.noteleport)
		return FALSE
	// 生物可以站在门口；实体障碍物不能成为传送落点。
	for(var/obj/obstacle in location)
		if(obstacle.density)
			return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/z121_portal/proc/cancel_portal_cast(mob/user)
	channeling = FALSE
	binding_cast = FALSE
	channeling_user = null
	if(!QDELETED(user))
		revert_cast(user)
	else
		finish_recharge()

/obj/effect/proc_holder/spell/self/z121_portal/proc/close_portals()
	var/list/old_portals = active_portals
	active_portals = list()
	for(var/obj/effect/portal/portal as anything in old_portals)
		if(!QDELETED(portal))
			qdel(portal)

/obj/effect/proc_holder/spell/self/z121_portal/proc/on_portal_destroy(obj/effect/portal/portal, atom/old_location)
	active_portals -= portal

/obj/effect/portal/z121_arcane
	name = "魔法传送门"
	desc = "幽微的奥术辉光在门扉间流转，另一端隐约传来遥远之地的回响。伸手触及辉光，静心片刻，便能循着回响穿行。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shitportal"
	density = FALSE
	opacity = FALSE
	teleport_channel = TELEPORT_CHANNEL_MAGIC

// 经过门口不会自动传送，所有实体点击统一进入六秒引导。
/obj/effect/portal/z121_arcane/Crossed(atom/movable/mover, oldloc, force_stop = 0)
	return

/obj/effect/portal/z121_arcane/attack_hand(mob/user)
	return channel_travel(user)

/obj/effect/portal/z121_arcane/attackby(obj/item/item, mob/user, params)
	return channel_travel(user)

// 幽灵不沿用父类的即时传送入口。
/obj/effect/portal/z121_arcane/attack_ghost(mob/dead/observer/user)
	return

/obj/effect/portal/z121_arcane/proc/channel_travel(mob/user)
	if(!isliving(user) || !user.client)
		return FALSE
	var/mob/living/traveler = user
	var/obj/effect/portal/exit_portal = linked
	var/client/travel_client = traveler.client
	if(traveler.doing || !can_channel_travel(traveler, exit_portal, travel_client))
		return FALSE
	var/action_coefficient = traveler.do_after_coefficent()
	if(action_coefficient <= 0)
		return FALSE

	to_chat(traveler, span_notice("我伸手触及门扉的辉光，静心感应另一端的回响……"))
	// 抵消动作速度系数，穿行引导保持六秒；移动和失能仍会中断。
	var/completed = do_after(traveler, Z121_PORTAL_TRAVEL_CHANNEL / action_coefficient, target = src, progress = TRUE, extra_checks = CALLBACK(src, PROC_REF(can_channel_travel), traveler, exit_portal, travel_client))
	if(QDELETED(src))
		return TRUE
	if(!completed || !can_channel_travel(traveler, exit_portal, travel_client))
		if(!QDELETED(traveler))
			to_chat(traveler, span_warning("门扉中的回响从指间散去，我未能穿过通路。"))
		return TRUE
	if(teleport(traveler))
		playsound(get_turf(traveler), 'sound/misc/portalenter.ogg', 60, TRUE)
	else
		to_chat(traveler, span_warning("一股阻力隔断了门扉，我没能抵达另一端。"))
	return TRUE

/obj/effect/portal/z121_arcane/proc/can_channel_travel(mob/living/traveler, obj/effect/portal/exit_portal, client/travel_client)
	if(QDELETED(src) || QDELETED(traveler) || QDELETED(exit_portal))
		return FALSE
	if(!travel_client || traveler.client != travel_client || traveler.incapacitated())
		return FALSE
	if(!isturf(traveler.loc) || !Adjacent(traveler) || linked != exit_portal || exit_portal.linked != src)
		return FALSE
	var/obj/effect/proc_holder/spell/self/z121_portal/portal_spell = creator
	return !QDELETED(portal_spell) && portal_spell.portal_turf_is_clear(get_turf(exit_portal))

#undef Z121_PORTAL_CHANNEL
#undef Z121_PORTAL_LIFETIME
#undef Z121_PORTAL_TRAVEL_CHANNEL
