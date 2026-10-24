/datum/keybinding/carbon
	category = CATEGORY_CARBON
	weight = WEIGHT_MOB


/datum/keybinding/carbon/toggle_throw_mode
	hotkey_keys = list("R")
	classic_keys = list("R") // END
	name = "toggle_throw_mode"
	full_name = "切换投掷模式"
	description = "切换是否投掷当前物品。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/toggle_throw_mode/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.toggle_throw_mode()
	return TRUE

//****** Base Intents ******

/datum/keybinding/carbon/intent_one
	hotkey_keys = list("1")
	name = "intent_one"
	full_name = "切换意图栏位 1"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_one/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(1)
/*	if(C.active_hand_index == 2)
		if(C.swap_hand(1))
			C.rog_intent_change(1)
	else
		if(C.l_index == 1)
			C.rog_intent_change(3)
		else
			C.rog_intent_change(1)*/

	return TRUE

/datum/keybinding/carbon/intent_two
	hotkey_keys = list("2")
	name = "intent_two"
	full_name = "切换意图栏位 2"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_two/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(2)
	return TRUE

/datum/keybinding/carbon/intent_three
	hotkey_keys = list("3")
	name = "intent_three"
	full_name = "切换意图栏位 3"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_three/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(3)
	return TRUE

/datum/keybinding/carbon/intent_four
	hotkey_keys = list("4")
	name = "intent_four"
	full_name = "切换意图栏位 4"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_four/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(4)
	return TRUE

/datum/keybinding/carbon/toggle_arc_mode
	hotkey_keys = list("ShiftG")
	name = "toggle_arc_mode"
	full_name = "切换法术替代模式"
	description = "切换当前激活法术的替代模式，例如投射物的弧线模式、循环切换符文类型等。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/toggle_arc_mode/down(client/user)
	if(!ishuman(user.mob))
		return FALSE
	var/mob/living/carbon/human/H = user.mob

	// Check new V2 spell system first
	var/datum/action/cooldown/spell/projectile/v2_spell = H.click_intercept
	if(istype(v2_spell))
		v2_spell.toggle_arc_mode(H)
		return TRUE

	// Check for generic alt mode (ward cycling, etc.)
	var/datum/action/cooldown/spell/v2_generic = H.click_intercept
	if(istype(v2_generic) && v2_generic.toggle_alt_mode(H))
		return TRUE

	// Fall back to old proc_holder system
	var/obj/effect/proc_holder/spell/invoked/projectile/spell = H.ranged_ability
	if(!istype(spell))
		to_chat(H, span_warning("当前没有具有替代模式的激活法术。"))
		return TRUE
	spell.toggle_arc_mode(H)
	return TRUE

//****** Quad Intents ******
/*
/datum/keybinding/carbon/give_intent
	hotkey_keys = list("G")
	name = "intent_give"
	full_name = "Select Give Intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/give_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_GIVE)
	return TRUE*/

/datum/keybinding/carbon/guard
	hotkey_keys = list("G")
	name = "guard"
	full_name = "防守"
	description = "在战斗模式下进入防守姿态，保证挡住下一次攻击。无需先通过右键切换至防御姿态。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/guard/down(client/user)
	if(!ishuman(user.mob))
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	if(!H.cmode)
		H.balloon_alert(H, "<font color = '#ffffff'>先开启战斗模式！</font>")
		return FALSE
	H.try_guard()
	return TRUE

/datum/keybinding/carbon/bite_intent
	hotkey_keys = list("H")
	name = "intent_bite"
	full_name = "选择撕咬意图"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/bite_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_BITE)
	return TRUE

/datum/keybinding/carbon/jump_intent
	hotkey_keys = list("J")
	name = "intent_jump"
	full_name = "选择跳跃意图"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/jump_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_JUMP)
	return TRUE

/datum/keybinding/carbon/kick_intent
	hotkey_keys = list("K")
	name = "intent_kick"
	full_name = "选择踢击意图"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/kick_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_KICK)
	return TRUE

/datum/keybinding/carbon/special_intent
	hotkey_keys = list("L")
	name = "intent_special"
	full_name = "选择特殊意图"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/special_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_SPECIAL)
	return TRUE

/*

/datum/keybinding/carbon/select_help_intent
	hotkey_keys = null
	name = "select_help_intent"
	full_name = "Select help intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_help_intent/down(client/user)
	if(iscyborg(user.mob))
		return FALSE
	user.mob?.a_intent_change(INTENT_HELP)
	return TRUE


/datum/keybinding/carbon/select_disarm_intent
	hotkey_keys = null
	name = "select_disarm_intent"
	full_name = "Select disarm intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_disarm_intent/down(client/user)
	user.mob?.a_intent_change(INTENT_DISARM)
	return TRUE


/datum/keybinding/carbon/select_grab_intent
	hotkey_keys = null
	name = "select_grab_intent"
	full_name = "Select grab intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_grab_intent/down(client/user)
	user.mob?.a_intent_change(INTENT_GRAB)
	return TRUE


/datum/keybinding/carbon/select_harm_intent
	hotkey_keys = null
	name = "select_harm_intent"
	full_name = "Select harm intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_harm_intent/down(client/user)
	if(iscyborg(user.mob))
		return FALSE
	user.mob?.a_intent_change(INTENT_HARM)
	return TRUE
*/

//****** RMB Intents ******

/datum/keybinding/carbon/rmb_intent_1
	hotkey_keys = list("Shift1")
	name = "rmb_intent_1"
	full_name = "选择佯攻架势"
	description = "选择右键佯攻架势。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_1/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 1)
	return TRUE

/datum/keybinding/carbon/rmb_intent_2
	hotkey_keys = list("Shift2")
	name = "rmb_intent_2"
	full_name = "选择瞄准架势"
	description = "选择右键瞄准架势。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_2/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 2)
	return TRUE

/datum/keybinding/carbon/rmb_intent_3
	hotkey_keys = list("Shift3")
	name = "rmb_intent_3"
	full_name = "选择强击架势"
	description = "选择右键强击架势。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_3/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 3)
	return TRUE

/datum/keybinding/carbon/rmb_intent_4
	hotkey_keys = list("Shift4")
	name = "rmb_intent_4"
	full_name = "选择迅捷架势"
	description = "选择右键迅捷架势。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_4/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 4)
	return TRUE

/datum/keybinding/carbon/rmb_intent_5
	hotkey_keys = list("Shift5")
	name = "rmb_intent_5"
	full_name = "选择防御架势"
	description = "选择右键防御架势。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_5/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 5)
	return TRUE

/datum/keybinding/carbon/rmb_intent_6
	hotkey_keys = list("Shift6")
	name = "rmb_intent_6"
	full_name = "选择虚招架势"
	description = "选择右键虚招架势。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_6/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 6)
	return TRUE

/datum/keybinding/carbon/cycle_rmb_intent
	hotkey_keys = list("N")
	name = "cycle_rmb_intent"
	full_name = "循环右键架势"
	description = "循环切换可用的右键架势。"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/cycle_rmb_intent/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.cycle_rmb_intent()
	return TRUE
