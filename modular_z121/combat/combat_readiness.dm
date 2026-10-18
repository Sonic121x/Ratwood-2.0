#define Z121_COMBAT_READY_SOUND_COOLDOWN (3 SECONDS)
#define Z121_COMBAT_READY_TEXT_DURATION (3 SECONDS)
#define Z121_COMBAT_READY_TEXT_WIDTH 640

GLOBAL_DATUM(z121_combat_readiness_service, /datum/z121_combat_readiness_service)

/proc/register_z121_combat_readiness()
	if(GLOB.z121_combat_readiness_service)
		return
	GLOB.z121_combat_readiness_service = new
	GLOB.z121_combat_readiness_service.register()

// 只为玩家接管过的活体附加提示组件，普通 NPC 不触发。
/datum/z121_combat_readiness_service/proc/register()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_CREATED, PROC_REF(on_mob_created))
	for(var/mob/living/player in GLOB.mob_list)
		watch_mob(player)

/datum/z121_combat_readiness_service/proc/on_mob_created(datum/source, mob/created)
	SIGNAL_HANDLER
	if(isliving(created))
		watch_mob(created)

/datum/z121_combat_readiness_service/proc/watch_mob(mob/living/player)
	RegisterSignal(player, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_login))
	if(player.client)
		player.z121_get_combat_readiness()

/datum/z121_combat_readiness_service/proc/on_login(mob/living/player, client/player_client)
	SIGNAL_HANDLER
	player.z121_get_combat_readiness()

/mob/living/proc/z121_get_combat_readiness()
	var/datum/component/z121_combat_readiness/readiness = GetComponent(/datum/component/z121_combat_readiness)
	if(!readiness && client)
		readiness = AddComponent(/datum/component/z121_combat_readiness)
	return readiness

// 保留原有切换与 on_cmode 行为，只在成功改变状态时发送提示。
/mob/living/toggle_cmode()
	set name = "cmode-change"
	set hidden = 1
	var/was_in_combat = cmode
	var/datum/component/z121_combat_readiness/readiness = z121_get_combat_readiness()
	. = ..()
	if(!QDELETED(src) && was_in_combat != cmode)
		readiness?.announce_state_change(cmode)

/datum/component/z121_combat_readiness
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/next_sound_at = 0
	var/image/state_text
	var/list/state_text_clients
	var/state_text_timer

/datum/component/z121_combat_readiness/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/z121_combat_readiness/RegisterWithParent()
	RegisterSignal(parent, list(COMSIG_LIVING_DEATH, COMSIG_MOB_LOGOUT), PROC_REF(on_unavailable))

/datum/component/z121_combat_readiness/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_LIVING_DEATH, COMSIG_MOB_LOGOUT))
	clear_state_text()

/datum/component/z121_combat_readiness/Destroy(force, silent)
	clear_state_text()
	return ..()

/datum/component/z121_combat_readiness/proc/on_unavailable()
	SIGNAL_HANDLER
	clear_state_text()

/datum/component/z121_combat_readiness/proc/announce_state_change(in_combat)
	if(QDELETED(parent))
		return
	var/mob/living/player = parent
	if(!player.client || player.stat == DEAD)
		return
	if(in_combat && world.time >= next_sound_at)
		next_sound_at = world.time + Z121_COMBAT_READY_SOUND_COOLDOWN
		play_entry_sound()
	show_state_text(in_combat)

/datum/component/z121_combat_readiness/proc/play_entry_sound()
	playsound(parent, 'modular_z121/sound/combat_ready.mp3', 80, FALSE, ignore_walls = FALSE)

// 仅由成功的战斗模式切换调用；不让生命更新、登录或复活补播文字。
/datum/component/z121_combat_readiness/proc/show_state_text(in_combat)
	clear_state_text()
	var/mob/living/player = parent
	if(QDELETED(player) || !player.client || player.stat == DEAD)
		return

	var/display_name = "某人"
	if(ishuman(player))
		var/mob/living/carbon/human/human = player
		// 必须先查面部，避免 get_visible_name 的名称覆盖绕过遮脸规则。
		if(length(human.get_face_name("")))
			display_name = human.get_visible_name()
	else
		display_name = player.get_visible_name()
	if(!length(display_name))
		display_name = "某人"
	var/message = "[html_encode(display_name)]看起来[in_combat ? "严阵以待" : "如释重负"]"

	var/list/viewers = get_hearers_in_view(DEFAULT_MESSAGE_RANGE, player, RECURSIVE_CONTENTS_CLIENT_MOBS)
	state_text_clients = list()
	for(var/mob/viewer in viewers)
		var/client/viewer_client = viewer.client
		if(!viewer_client?.prefs || !(viewer_client.prefs.floating_text_toggles & FLOATING_TEXT) || is_blind(viewer))
			continue
		if(viewer != player)
			if(!(player in view(DEFAULT_MESSAGE_RANGE, viewer)))
				continue
			if(isliving(viewer) && !viewer.can_see_cone(player))
				continue
		state_text_clients |= viewer_client
	if(!length(state_text_clients))
		state_text_clients = null
		return

	// 沿用气泡文字的平面与样式；固定宽高避免 MeasureText 阻塞切换和计时。
	state_text = image(loc = get_atom_on_turf(player), layer = ABOVE_MOB_LAYER)
	state_text.plane = BALLOON_CHAT_PLANE
	state_text.appearance_flags = RESET_ALPHA | RESET_COLOR | RESET_TRANSFORM
	state_text.maptext = MAPTEXT("<span style='text-align: center; -dm-text-outline: 1px #0005'>[message]</span>")
	state_text.maptext_width = Z121_COMBAT_READY_TEXT_WIDTH
	state_text.maptext_height = 64
	state_text.maptext_x = (Z121_COMBAT_READY_TEXT_WIDTH - ICON_SIZE_X) * -0.5 - player.base_pixel_x
	state_text.pixel_y = 48
	state_text.alpha = 0
	for(var/client/viewer_client in state_text_clients)
		viewer_client.images += state_text
	animate(state_text, pixel_y = 53, time = Z121_COMBAT_READY_TEXT_DURATION, easing = SINE_EASING | EASE_OUT)
	animate(state_text, alpha = 175, time = 0.2 SECONDS, easing = CUBIC_EASING | EASE_OUT, flags = ANIMATION_PARALLEL)
	animate(alpha = 175, time = 2.5 SECONDS)
	animate(alpha = 0, time = 0.3 SECONDS, easing = CUBIC_EASING | EASE_IN)
	state_text_timer = addtimer(CALLBACK(src, PROC_REF(expire_state_text)), Z121_COMBAT_READY_TEXT_DURATION, TIMER_STOPPABLE)

/datum/component/z121_combat_readiness/proc/expire_state_text()
	state_text_timer = null
	clear_state_text()

/datum/component/z121_combat_readiness/proc/clear_state_text()
	if(state_text_timer)
		deltimer(state_text_timer)
		state_text_timer = null
	for(var/client/viewer_client in state_text_clients)
		viewer_client.images -= state_text
	state_text_clients = null
	state_text = null

#undef Z121_COMBAT_READY_SOUND_COOLDOWN
#undef Z121_COMBAT_READY_TEXT_DURATION
#undef Z121_COMBAT_READY_TEXT_WIDTH
