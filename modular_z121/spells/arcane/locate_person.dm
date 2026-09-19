// 寻人术共用引导、冷却、报告与私人箭头，两种公开法术保持独立类型。
#define Z121_LOCATE_CHANNEL (3 SECONDS)
#define Z121_LOCATE_DURATION (30 SECONDS)
#define Z121_LOCATE_CONSENT_TIMEOUT (30 SECONDS)

/mob/living/carbon/human
	// 同一施法者只显示一个定位箭头，等待中的请求不占用此位置。
	var/datum/z121_locate_session/z121_locate_tracker

/obj/effect/proc_holder/spell/self/z121_locate_base
	name = "寻人术"
	desc = "相识之人的魔力，总会在记忆中留下些许余韵。静心呼唤，若对方愿意回应，一缕微光便会为我引路；纵使生息已逝，只要灵魂尚未远去，余韵便仍有迹可循。"
	cost = 2
	xp_gain = TRUE
	releasedrain = 10
	chargedrain = 1
	chargetime = 0
	recharge_time = 1 MINUTES
	cooldown_min = 1 MINUTES
	human_req = TRUE
	warnie = "spellwarning"
	school = "transmutation"
	spell_tier = 2
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "locate_person"
	invocations = list("循迹寻人。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	miracle = FALSE
	gesture_required = TRUE
	var/selecting_or_channeling = FALSE
	var/list/locate_sessions = list()

/obj/effect/proc_holder/spell/self/locate_person
	parent_type = /obj/effect/proc_holder/spell/self/z121_locate_base

/obj/effect/proc_holder/spell/self/yandere_locate_person
	parent_type = /obj/effect/proc_holder/spell/self/z121_locate_base
	name = "病娇寻人术"
	desc = "我记得那个人的气息，比自己的呼吸还要熟悉。只需片刻凝神，心底的牵念便会指向 ta 所在之处。ta 不必回应我……沉默也好，长眠也罢，我总会循着那道踪迹寻去。"

/obj/effect/proc_holder/spell/self/z121_locate_base/Destroy()
	for(var/datum/z121_locate_session/session as anything in locate_sessions.Copy())
		qdel(session)
	locate_sessions = null
	return ..()

/obj/effect/proc_holder/spell/self/z121_locate_base/Click()
	// 避免重复点击走父类的失败返还路径，提前解除选人、引导或冷却锁定。
	if(selecting_or_channeling || !charge_check(usr))
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/self/z121_locate_base/process()
	// 父类在施法检查时已启动冷却处理，选人与引导期间不得累计。
	if(selecting_or_channeling)
		last_process_time = world.time
		return
	return ..()

/obj/effect/proc_holder/spell/self/z121_locate_base/cast(list/targets, mob/living/user = usr)
	if(selecting_or_channeling)
		return FALSE
	if(!ishuman(user) || !user.mind)
		cancel_locate_cast(user)
		return FALSE

	selecting_or_channeling = TRUE
	STOP_PROCESSING(SSfastprocess, src)
	var/datum/mind/casting_mind = user.mind
	var/mob/living/carbon/human/found_person = select_locate_target(user)
	if(QDELETED(src))
		return FALSE
	if(!can_channel(user, casting_mind) || QDELETED(found_person) || !target_allowed(user, found_person))
		cancel_locate_cast(user)
		return FALSE

	user.visible_message(
		span_notice("[user] 闭目凝神，以指尖拂过空气中残留的细微魔力波纹。"),
		span_notice("我开始顺着 [found_person.real_name] 残留在记忆中的独特魔力轨迹进行追索。")
	)
	// 抵消通用动作速度系数，使引导本身保持三秒，仍保留移动、失能与换手中断。
	var/channel_delay = z121_channel(Z121_LOCATE_CHANNEL, user) / max(0.01, user.do_after_coefficent())
	if(!do_after(user, channel_delay, target = user, progress = TRUE, extra_checks = CALLBACK(src, PROC_REF(can_channel), user, casting_mind)))
		if(!QDELETED(user))
			to_chat(user, span_warning("我的引导被打断了，熟悉的魔力踪迹也随之散开。"))
		if(!QDELETED(src))
			cancel_locate_cast(user)
		return FALSE

	if(QDELETED(src))
		return FALSE
	selecting_or_channeling = FALSE
	// 返回成功代表已完成引导；父类立即开始正常冷却，后续请求结果不再返还。
	charge_counter = 0
	if(!can_channel(user, casting_mind) || QDELETED(found_person) || !target_allowed(user, found_person))
		if(!QDELETED(user))
			to_chat(user, span_warning("魔力踪迹已经散去，我没能锁定对方。"))
		z121_metamagic_cast?.finish(FALSE)
		return TRUE
	new /datum/z121_locate_session(src, user, found_person)
	return TRUE

/obj/effect/proc_holder/spell/self/z121_locate_base/proc/can_channel(mob/living/carbon/human/user, datum/mind/casting_mind)
	return !QDELETED(src) && !QDELETED(user) && !QDELETED(casting_mind) && user.client && user.stat == CONSCIOUS && user.mind == casting_mind && (src in casting_mind.spell_list)

/obj/effect/proc_holder/spell/self/z121_locate_base/proc/cancel_locate_cast(mob/living/user)
	selecting_or_channeling = FALSE
	if(!QDELETED(user))
		revert_cast(user)
	else
		finish_recharge()

/obj/effect/proc_holder/spell/self/z121_locate_base/proc/select_locate_target(mob/living/carbon/human/user)
	return null

/obj/effect/proc_holder/spell/self/z121_locate_base/proc/target_allowed(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return FALSE

/obj/effect/proc_holder/spell/self/z121_locate_base/proc/needs_consent()
	return TRUE

/obj/effect/proc_holder/spell/self/locate_person/select_locate_target(mob/living/carbon/human/user)
	var/list/known_targets = list()
	for(var/person_name in user.mind.known_people)
		var/mob/living/carbon/human/person = find_known_human(person_name)
		if(person && person != user)
			known_targets[person_name] = person
	if(!length(known_targets))
		to_chat(user, span_warning("我当前感应不到任何熟识之人的清晰魔力踪迹。"))
		return null
	var/chosen_name = input(user, "选择一位你想追踪的熟识之人。", name) as null|anything in sortList(known_targets)
	// 选定后锁定具体身体，等待或引导结束时不再按同名重新找人。
	return known_targets[chosen_name]

/obj/effect/proc_holder/spell/self/locate_person/target_allowed(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target != user && (target.real_name in user.mind.known_people)

/obj/effect/proc_holder/spell/self/yandere_locate_person/select_locate_target(mob/living/carbon/human/user)
	var/datum/charflaw/yandere/flaw = user.get_flaw(/datum/charflaw/yandere)
	var/mob/living/carbon/human/crush = flaw?.locate_crush_ref?.resolve()
	if(!flaw?.designated || QDELETED(crush))
		to_chat(user, span_warning("我此刻无法感应到心爱之人的踪迹。"))
		return null
	return crush

/obj/effect/proc_holder/spell/self/yandere_locate_person/target_allowed(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/charflaw/yandere/flaw = user.get_flaw(/datum/charflaw/yandere)
	return flaw?.designated && flaw.locate_crush_ref?.resolve() == target

/obj/effect/proc_holder/spell/self/yandere_locate_person/needs_consent()
	return FALSE

/obj/effect/proc_holder/spell/self/z121_locate_base/proc/find_known_human(person_name)
	for(var/mob/living/carbon/human/person in GLOB.human_list)
		if(!QDELETED(person) && person.real_name == person_name)
			return person
	return null

/obj/effect/proc_holder/spell/self/z121_locate_base/proc/build_location_report(mob/living/carbon/human/user, mob/living/carbon/human/found_person)
	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(found_person)
	if(!user_turf || !target_turf)
		return "那道踪迹忽明忽暗，我暂时无法判断更具体的位置。"

	var/list/report_parts = list()
	var/dx = target_turf.x - user_turf.x
	var/dy = target_turf.y - user_turf.y
	var/horizontal_distance = max(abs(dx), abs(dy))
	var/z_difference = abs(target_turf.z - user_turf.z)
	var/direction = get_dir(user_turf, target_turf)

	// 先给出罗盘式方向反馈，再补充距离、区域与状态，方便玩家一眼读懂。
	if(horizontal_distance <= 0)
		report_parts += "方位：◎ 与我处于相同的水平位置"
	else
		report_parts += "方位：[get_direction_arrow(direction)] [get_direction_text(direction)]"

	report_parts += "距离：约 [horizontal_distance] 格"
	report_parts += "区域：[get_target_area_text(found_person)]"

	if(target_turf.z == user_turf.z)
		report_parts += "层级：与我处于同一层级"
	else if(target_turf.z > user_turf.z)
		report_parts += "层级：不在同一层级，对方位于更高处（相差 [z_difference] 层）"
	else
		report_parts += "层级：不在同一层级，对方位于更低处（相差 [z_difference] 层）"

	report_parts += "状态：[get_target_condition_text(found_person)]"

	return " [report_parts.Join("；")]。"

/obj/effect/proc_holder/spell/self/z121_locate_base/proc/get_direction_text(direction)
	switch(direction)
		if(NORTH)
			return "北方"
		if(SOUTH)
			return "南方"
		if(EAST)
			return "东方"
		if(WEST)
			return "西方"
		if(NORTHEAST)
			return "东北方"
		if(NORTHWEST)
			return "西北方"
		if(SOUTHEAST)
			return "东南方"
		if(SOUTHWEST)
			return "西南方"
	return "难以辨明的方向"

/obj/effect/proc_holder/spell/self/z121_locate_base/proc/get_direction_arrow(direction)
	switch(direction)
		if(NORTH)
			return "↑"
		if(SOUTH)
			return "↓"
		if(EAST)
			return "→"
		if(WEST)
			return "←"
		if(NORTHEAST)
			return "↗"
		if(NORTHWEST)
			return "↖"
		if(SOUTHEAST)
			return "↘"
		if(SOUTHWEST)
			return "↙"
	return "?"

/obj/effect/proc_holder/spell/self/z121_locate_base/proc/get_target_condition_text(mob/living/carbon/human/found_person)
	if(found_person.stat == DEAD)
		return "已死亡"
	// 本项目只有 SOFT_CRIT / UNCONSCIOUS / DEAD 三档 stat，濒死用 InFullCritical() 区分。
	if(found_person.InFullCritical())
		return "濒临死亡"
	if(found_person.stat == UNCONSCIOUS)
		return "失去意识"
	if(found_person.stat == SOFT_CRIT)
		return "重伤挣扎"
	if(found_person.stat == CONSCIOUS)
		return "神志清醒"
	return "状态难明"

/obj/effect/proc_holder/spell/self/z121_locate_base/proc/get_target_area_text(mob/living/carbon/human/found_person)
	var/area/target_area = get_area(found_person)
	if(!target_area)
		return "未知区域"

	// 优先使用地图作者提供的 location_name；若没有，则只在区名本身不是英文时才回显它。
	var/location_name = target_area.vars["location_name"]
	if(istext(location_name) && length(location_name))
		return location_name

	var/formatted_area_name = get_area_name(found_person, TRUE)
	if(!length(formatted_area_name))
		return "未知区域"
	if(has_latin_letters(formatted_area_name))
		return "未知区域"
	return formatted_area_name

/obj/effect/proc_holder/spell/self/z121_locate_base/proc/has_latin_letters(text_to_check)
	var/upper_text = uppertext("[text_to_check]")
	for(var/i in 1 to length(upper_text))
		var/current_char = copytext(upper_text, i, i + 1)
		if(current_char >= "A" && current_char <= "Z")
			return TRUE
	return FALSE

// 寻人请求使用独立的大尺寸界面，继续沿用通用弹窗的选择、关闭与超时处理。
/datum/tgui_alert/z121_locate_request/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LocatePersonRequest", title)
		ui.open()

// 请求与追踪独立于法术冷却处理，避免弹窗阻塞冷却或让迟到回复恢复失效定位。
/datum/z121_locate_session
	// 等待同意期间只预留超魔次数，真正开始定位才结算。
	var/datum/z121_metamagic_cast/metamagic_reservation
	var/datum/weakref/spell_ref
	var/datum/weakref/caster_ref
	var/datum/weakref/target_ref
	var/datum/weakref/caster_mind_ref
	var/datum/weakref/target_mind_ref
	var/client/viewer
	var/client/consenting_client
	var/datum/tgui_alert/consent_prompt
	var/image/arrow
	var/tracking = FALSE
	var/consent_granted = FALSE
	var/consent_required = TRUE
	var/request_expires
	var/tracking_expires

/datum/z121_locate_session/New(obj/effect/proc_holder/spell/self/z121_locate_base/spell, mob/living/carbon/human/caster, mob/living/carbon/human/target)
	spell_ref = WEAKREF(spell)
	z121_meta_duration = spell.z121_duration(1)
	metamagic_reservation = spell.z121_metamagic_cast
	if(metamagic_reservation)
		metamagic_reservation.deferred = TRUE
	caster_ref = WEAKREF(caster)
	target_ref = WEAKREF(target)
	caster_mind_ref = WEAKREF(caster.mind)
	if(target.mind)
		target_mind_ref = WEAKREF(target.mind)
	viewer = caster.client
	consent_required = spell.needs_consent()
	request_expires = world.time + Z121_LOCATE_CONSENT_TIMEOUT
	spell.locate_sessions += src
	START_PROCESSING(SSfastprocess, src)

/datum/z121_locate_session/Destroy()
	if(metamagic_reservation && !QDELETED(metamagic_reservation))
		metamagic_reservation.finish(FALSE)
	metamagic_reservation = null
	STOP_PROCESSING(SSfastprocess, src)
	var/obj/effect/proc_holder/spell/self/z121_locate_base/spell = spell_ref?.resolve()
	spell?.locate_sessions -= src
	var/mob/living/carbon/human/caster = caster_ref?.resolve()
	if(caster?.z121_locate_tracker == src)
		caster.z121_locate_tracker = null
	QDEL_NULL(consent_prompt)
	if(viewer && arrow)
		viewer.images -= arrow
	QDEL_NULL(arrow)
	viewer = null
	consenting_client = null
	return ..()

/datum/z121_locate_session/proc/target_online(mob/living/carbon/human/target)
	if(target.client)
		return TRUE
	if(target.stat != DEAD)
		return FALSE
	var/mob/dead/observer/ghost = target.get_ghost(even_if_they_cant_reenter = TRUE, ghosts_with_clients = TRUE)
	return !!ghost?.client

/datum/z121_locate_session/proc/fail(message)
	var/mob/living/carbon/human/caster = caster_ref?.resolve()
	if(caster)
		to_chat(caster, span_warning(message))
	qdel(src)

/datum/z121_locate_session/process()
	var/obj/effect/proc_holder/spell/self/z121_locate_base/spell = spell_ref?.resolve()
	var/mob/living/carbon/human/caster = caster_ref?.resolve()
	var/mob/living/carbon/human/target = target_ref?.resolve()
	if(!spell || !caster || !target || !viewer || caster.client != viewer || caster.stat == DEAD)
		fail("定位的魔力联系已经中断。")
		return
	if(caster.mind != caster_mind_ref?.resolve() || !caster.mind || !(spell in caster.mind.spell_list))
		fail("定位的魔力联系已经中断。")
		return
	if(consent_required && target.mind != target_mind_ref?.resolve())
		fail("定位的魔力联系已经中断。")
		return
	if(!spell.target_allowed(caster, target) || !get_turf(caster) || !get_turf(target))
		fail("我已无法继续追索这道魔力踪迹。")
		return
	if(consent_required && !target_online(target))
		fail("对方此刻无法回应魔力感应，定位失败。")
		return

	if(tracking)
		if(world.time >= tracking_expires)
			qdel(src)
			return
		if(consent_required && target.stat != DEAD && !consent_granted)
			fail("对方已重返生者之列，我需要重新征得其同意。")
			return
		update_arrow(spell, caster, target)
		return

	// 死亡且在线者直接定位尸体；病娇版本不检查在线状态，也不弹出请求。
	if(!consent_required || target.stat == DEAD)
		begin_tracking(spell, caster, target)
		return
	if(world.time >= request_expires)
		fail("对方未及时回应，这次寻人请求已经失效。")
		return
	if(!consenting_client)
		consenting_client = target.client
		// 直接复用现有弹窗类型，避免关闭简易输入偏好后回退为没有超时的原生弹窗。
		consent_prompt = new /datum/tgui_alert/z121_locate_request(target, "一缕似曾相识的魔力轻叩心扉，是 [caster.real_name] 在远处呼唤我。\n\n若我回应，ta 便能循着这道联系，在接下来的片刻里感知我的所在与安危。是否让这缕魔力为 ta 引路？", "熟悉的呼唤", list("同意", "拒绝"), Z121_LOCATE_CONSENT_TIMEOUT, TRUE, GLOB.tgui_always_state)
		consent_prompt.ui_interact(target)
		to_chat(caster, span_notice("我正在等待 [target.real_name] 同意这次寻人请求。"))
		return
	if(target.client != consenting_client || QDELETED(consent_prompt))
		fail("这次寻人请求已经失效。")
		return
	if(consent_prompt.choice == "同意")
		consent_granted = TRUE
		begin_tracking(spell, caster, target)
		return
	if(consent_prompt.closed || consent_prompt.choice == "拒绝")
		fail("对方没有同意这次定位。")

/datum/z121_locate_session/proc/begin_tracking(obj/effect/proc_holder/spell/self/z121_locate_base/spell, mob/living/carbon/human/caster, mob/living/carbon/human/target)
	QDEL_NULL(consent_prompt)
	if(caster.z121_locate_tracker && caster.z121_locate_tracker != src)
		qdel(caster.z121_locate_tracker)
	caster.z121_locate_tracker = src
	tracking = TRUE
	if(metamagic_reservation && !QDELETED(metamagic_reservation))
		metamagic_reservation.finish(TRUE)
	metamagic_reservation = null
	tracking_expires = world.time + z121_duration(Z121_LOCATE_DURATION)
	QDEL_IN(src, z121_duration(Z121_LOCATE_DURATION))
	arrow = image(loc = caster, layer = ABOVE_MOB_LAYER)
	arrow.plane = BALLOON_CHAT_PLANE
	arrow.appearance_flags = RESET_ALPHA | RESET_COLOR | RESET_TRANSFORM
	arrow.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	arrow.maptext_width = 64
	arrow.maptext_height = 64
	arrow.maptext_x = -16
	arrow.pixel_y = 32
	update_arrow(spell, caster, target)
	viewer.images += arrow
	playsound(get_turf(caster), 'sound/magic/whiteflame.ogg', 70, TRUE, soundping = TRUE)
	to_chat(caster, span_notice("我循着 [target.real_name] 的魔力踪迹得出了感应：[spell.build_location_report(caster, target)] 头顶的指引将持续[z121_duration(Z121_LOCATE_DURATION) / 10]秒。"))

/datum/z121_locate_session/proc/update_arrow(obj/effect/proc_holder/spell/self/z121_locate_base/spell, mob/living/carbon/human/caster, mob/living/carbon/human/target)
	var/turf/caster_turf = get_turf(caster)
	var/turf/target_turf = get_turf(target)
	var/symbol = "◎"
	if(caster_turf.x != target_turf.x || caster_turf.y != target_turf.y)
		// 使用坐标差排除层级方向位，跨层时仍给出正确的水平方向。
		var/direction = 0
		if(target_turf.x > caster_turf.x)
			direction |= EAST
		else if(target_turf.x < caster_turf.x)
			direction |= WEST
		if(target_turf.y > caster_turf.y)
			direction |= NORTH
		else if(target_turf.y < caster_turf.y)
			direction |= SOUTH
		symbol = spell.get_direction_arrow(direction)
	var/level_text = ""
	if(target_turf.z > caster_turf.z)
		level_text = "上层"
	else if(target_turf.z < caster_turf.z)
		level_text = "下层"
	arrow.maptext = "<div style='text-align:center;color:#b9eaff;-dm-text-outline:1px black;font-size:22px'>[symbol]</div><div style='text-align:center;color:white;font-size:10px'>[level_text]</div>"

#undef Z121_LOCATE_CHANNEL
#undef Z121_LOCATE_DURATION
#undef Z121_LOCATE_CONSENT_TIMEOUT
