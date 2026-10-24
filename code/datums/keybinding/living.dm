/datum/keybinding/living
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB


/datum/keybinding/living/swap_left
	hotkey_keys = list("Q")
	classic_keys = list("Q") // PAGEUP
	name = "swap_left"
	full_name = "切换到左手"
	description = ""

/datum/keybinding/living/swap_left/down(client/user)
	var/mob/M = user.mob
	if(!isliving(M))
		return
	if(M.atkswinging)
		M.stop_attack()
	if(M.active_hand_index == 1)
		var/obj/item/I = M.get_active_held_item()
		if(I)
			I.Click()
	else
		M.swap_hand(1)
	return TRUE

/datum/keybinding/living/swap_right
	hotkey_keys = list("E")
	classic_keys = list("E") // PAGEUP
	name = "swap_right"
	full_name = "切换到右手"
	description = ""

/datum/keybinding/living/swap_right/down(client/user)
	var/mob/M = user.mob
	if(!isliving(M))
		return
	if(M.atkswinging)
		M.stop_attack()
	if(M.active_hand_index == 2)
		var/obj/item/I = M.get_active_held_item()
		if(I)
			I.Click()
	else
		M.swap_hand(2)
	return TRUE

/datum/keybinding/living/swap_hands
	hotkey_keys = list()
	classic_keys = list()
	name = "swap_hands"
	full_name = "切换双手"
	description = ""

/datum/keybinding/living/swap_hands/down(client/user)
	var/mob/M = user.mob
	if(!isliving(M))
		return
	if(M.atkswinging)
		M.stop_attack()
	M.swap_hand()
	return TRUE

/datum/keybinding/living/activate_inhand
	hotkey_keys = list()
	classic_keys = list()
	name = "activate_inhand"
	full_name = "激活手持物"
	description = "使用我当前手中的物品"

/datum/keybinding/living/activate_inhand/down(client/user)
	var/mob/M = user.mob
	if(!isliving(M))
		return
	M.mode()
	return TRUE



/datum/keybinding/living/drop_item
	hotkey_keys = list("Z")
	name = "drop_item"
	full_name = "丢下物品"
	description = ""

/datum/keybinding/living/drop_item/down(client/user)
	var/mob/M = user.mob
	if(!isliving(M))
		return
	if(M.atkswinging)
		M.stop_attack()
	var/obj/item/I = M.get_active_held_item()
	if(I)
		user.mob.dropItemToGround(I, silent = FALSE)
	return TRUE

/datum/keybinding/living/sprint
	hotkey_keys = list()
	name = "sprint"
	full_name = "冲刺"
	description = "若不够小心，冲刺可能会危及我的健康。"

/datum/keybinding/living/sprint/down(client/user)
	var/mob/M = user.mob
	if(!isliving(M))
		return
	if(M.m_intent == MOVE_INTENT_RUN)
		M.toggle_rogmove_intent(MOVE_INTENT_WALK)
	else
		M.toggle_rogmove_intent(MOVE_INTENT_RUN)
	return TRUE

/datum/keybinding/living/sneak
	hotkey_keys = list()
	name = "sneak"
	full_name = "潜行"
	description = "按下这个热键进入潜行状态，它有许多用途。"

/datum/keybinding/living/sneak/down(client/user)
	var/mob/M = user.mob
	if(!isliving(M))
		return
	if(M.m_intent == MOVE_INTENT_SNEAK)
		M.toggle_rogmove_intent(MOVE_INTENT_WALK)
	else
		M.toggle_rogmove_intent(MOVE_INTENT_SNEAK)
	return TRUE


/datum/keybinding/living/submit
	hotkey_keys = list("ShiftX")
	name = "yield"
	full_name = "投降"
	description = "向敌人投降，也许能保住性命，也可能只是更快送命。"

/datum/keybinding/living/submit/down(client/user)
	var/mob/living/L = user.mob
	if(!isliving(L))
		return
	if(L.doing)
		L.doing = 0
	L.submit(TRUE)
	return TRUE

/datum/keybinding/living/toggle_compliance
	hotkey_keys = list()
	name = "toggle_compliance"
	full_name = "切换顺从模式"
	description = "静默切换为主动放弃防御，无论是被抓取、被扑倒，还是别人挣脱我的控制时都会生效。同时也会让他人更快束缚我、扒下我的装备。战斗中非常危险！"

/datum/keybinding/living/toggle_compliance/down(client/user)
	var/mob/living/L = user.mob
	if(!isliving(L))
		return
	L.toggle_compliance()
	return TRUE

/datum/keybinding/living/resist
	hotkey_keys = list("X")
	name = "cancelresist"
	full_name = "挣扎"
	description = "连续按这个键来挣脱抓取。"

/datum/keybinding/living/resist/down(client/user)
	var/mob/living/L = user.mob
	if(!istype(L))
		return FALSE
	L.resist()
	return TRUE

/datum/keybinding/living/defendtoggle
	hotkey_keys = list("C")
	name = "defendtoggle"
	full_name = "战斗模式"
	description = "切换进入战斗模式，启用部分右键意图，并允许闪避与招架。"

/datum/keybinding/living/defendtoggle/down(client/user)
	var/mob/living/L = user.mob
	if(!isliving(L))
		return
	L.toggle_cmode()

/datum/keybinding/living/dodgeparry
	hotkey_keys = list("ShiftC")
	name = "dodgeparry"
	full_name = "闪避/招架"
	description = "在闪避与招架之间切换。"

/datum/keybinding/living/dodgeparry/down(client/user)
	var/mob/living/L = user.mob
	if(!istype(L))
		return FALSE
	if(L.d_intent == INTENT_DODGE)
		L.def_intent_change(INTENT_PARRY)
	else
		L.def_intent_change(INTENT_DODGE)

/datum/keybinding/living/restd
	hotkey_keys = list("V")
	name = "standrest"
	full_name = "切换站立/休息"
	description = "在站立与躺地之间切换。"
	var/lastrest = 0

/datum/keybinding/living/restd/down(client/user)
	var/mob/living/L = user.mob
	if(!istype(L))
		return FALSE
	if(!lastrest || world.time > lastrest + 15)
		L.toggle_rest()
		lastrest = world.time
		return TRUE
	else
		return FALSE

/datum/keybinding/living/standu
	hotkey_keys = list()
	name = "stand"
	full_name = "起身"
	description = "从倒地状态站起来。"
	var/lastrest = 0

/datum/keybinding/living/standu/down(client/user)
	var/mob/living/L = user.mob
	if(!istype(L))
		return FALSE
	if(!lastrest || world.time > lastrest + 15)
		L.stand_up()
		lastrest = world.time
		return TRUE
	else
		return FALSE

/datum/keybinding/living/rest
	hotkey_keys = list()
	name = "休息"
	full_name = "躺下"
	description = "躺到地上。"
	var/lastrest = 0

/datum/keybinding/living/rest/down(client/user)
	var/mob/living/L = user.mob
	if(!istype(L))
		return FALSE
	if(!lastrest || world.time > lastrest + 15)
		L.lay_down()
		lastrest = world.time
		return TRUE
	else
		return FALSE

/datum/keybinding/living/lookup
	hotkey_keys = list("ShiftF")
	name = "lookup"
	full_name = "向上看"
	description = "若头顶是开阔空间，就查看我上方有什么。"
	var/lastrest = 0

/datum/keybinding/living/lookup/down(client/user)
	var/mob/living/L = user.mob
	if(!lastrest || world.time > lastrest + 15)
		L.look_up()
		lastrest = world.time
		return TRUE
	else
		return FALSE

/datum/keybinding/living/search
	hotkey_keys = list() // Unbound by default; ShiftG was freed for the spell alt-mode toggle. Rebind to taste.
	name = "search"
	full_name = "搜索"
	description = "搜索周围区域，寻找隐藏物品或暗格。"

/datum/keybinding/living/search/down(client/user)
	var/mob/living/L = user.mob
	if (isliving(L))
		L.look_around()

/datum/keybinding/living/alt_grip
	hotkey_keys = list("B")
	name = "alt_grip"
	full_name = "切换握法"
	description = "切换手中武器的握法，例如反握锤击式。"

/datum/keybinding/living/alt_grip/down(client/user)
	var/mob/living/L = user.mob
	if(!isliving(L))
		return FALSE
	var/obj/item/I = L.get_active_held_item()
	if(I)
		I.rmb_self(L)
		return TRUE
	return FALSE

//layer shifting

/datum/keybinding/living/pixel_shift_layerup
	hotkey_keys = list("CtrlShiftNortheast")
	name = "pixel_shift_layerup"
	full_name = "像素层级上移"
	description = ""
	var/lastrest = 0

/datum/keybinding/living/pixel_shift_layerup/down(client/user)
	var/mob/living/M = user.mob
	if(!isliving(M))
		return
	if(M.mobility_flags & MOBILITY_STAND)
		return
	if(M.pixelshift_layer <= 0.04)
		M.is_shifted = TRUE
		M.pixelshift_layer = M.pixelshift_layer + 0.01
		M.layer = LYING_MOB_LAYER + M.pixelshift_layer
		to_chat(user, span_info("像素层级已上移至：[M.pixelshift_layer]"))
		M.update_transform()
	return TRUE

/datum/keybinding/living/pixel_shift_layerdown
	hotkey_keys = list("CtrlShiftSoutheast")
	name = "pixel_shift_layerdown"
	full_name = "像素层级下移"
	description = ""
	var/lastrest = 0

/datum/keybinding/living/pixel_shift_layerdown/down(client/user)
	var/mob/living/M = user.mob
	if(!isliving(M))
		return
	if(M.mobility_flags & MOBILITY_STAND)
		return
	if(M.pixelshift_layer >= -0.04)
		M.is_shifted = TRUE
		M.pixelshift_layer = M.pixelshift_layer - 0.01
		M.layer = LYING_MOB_LAYER + M.pixelshift_layer
		to_chat(user, span_info("像素层级已下移至：[M.pixelshift_layer]"))
		M.update_transform()
	return TRUE

// ** Action Buttons **
// I stopped at 6 because it is probably the maximum number you can comfortably reach on keyboard
/datum/keybinding/living/actions
	var/action_taken = 1
/datum/keybinding/living/actions/down(client/user)
	if(!isliving(user.mob))
		return FALSE
	var/mob/living/C = user.mob
	var/datum/hud/H = C.hud_used
	if(H?.rearrange_mode)
		H.rearrange_hint(C)
		return TRUE
	var/count = 0
	for(var/datum/action/A as anything in C.actions)
		var/atom/movable/screen/movable/action_button/B = H ? A.viewers[H] : null
		if(B && B.moved)
			continue
		count++
		if(count == action_taken)
			A.Trigger()
			return TRUE
	return FALSE

/datum/keybinding/living/actions/action_1
	hotkey_keys = list("Alt1")
	name = "action_1"
	full_name = "动作 1"
	description = "触发第一个动作。"
	category = CATEGORY_HUMAN
	action_taken = 1

/datum/keybinding/living/actions/action_2
	hotkey_keys = list("Alt2")
	name = "action_2"
	full_name = "动作 2"
	description = "触发第二个动作。"
	category = CATEGORY_HUMAN
	action_taken = 2

/datum/keybinding/living/actions/action_3
	hotkey_keys = list("Alt3")
	name = "action_3"
	full_name = "动作 3"
	description = "触发第三个动作。"
	category = CATEGORY_HUMAN
	action_taken = 3

/datum/keybinding/living/actions/action_4
	hotkey_keys = list("Alt4")
	name = "action_4"
	full_name = "动作 4"
	description = "触发第四个动作。"
	category = CATEGORY_HUMAN
	action_taken = 4

/datum/keybinding/living/actions/action_5
	hotkey_keys = list("Alt5")
	name = "action_5"
	full_name = "动作 5"
	description = "触发第五个动作。"
	category = CATEGORY_HUMAN
	action_taken = 5

/datum/keybinding/living/actions/action_6
	hotkey_keys = list("Alt6")
	name = "action_6"
	full_name = "动作 6"
	description = "触发第六个动作。"
	category = CATEGORY_HUMAN
	action_taken = 6

/datum/keybinding/living/actions/action_7
	hotkey_keys = list("Alt7")
	name = "action_7"
	full_name = "动作 7"
	description = "触发第七个动作。"
	category = CATEGORY_HUMAN
	action_taken = 7


/datum/keybinding/living/actions/action_8
	hotkey_keys = list("Alt8")
	name = "action_8"
	full_name = "动作 8"
	description = "触发第八个动作。"
	category = CATEGORY_HUMAN
	action_taken = 8


/datum/keybinding/living/actions/action_9
	hotkey_keys = list("Alt9")
	name = "action_9"
	full_name = "动作 9"
	description = "触发第九个动作。"
	category = CATEGORY_HUMAN
	action_taken = 9
