/datum/action/item_action/toggle_light
	name = "切换照明"

/datum/action/item_action/toggle_hood
	name = "切换兜帽"

/datum/action/item_action/toggle_firemode
	name = "切换射击模式"

/datum/action/item_action/toggle_mode
	name = "切换模式"

/datum/action/item_action/pick_color
	name = "选择颜色"

/datum/action/item_action/toggle_mister
	name = "切换喷雾"

/datum/action/item_action/activate_injector
	name = "启动注射器"

/datum/action/item_action/toggle_helmet_light
	name = "切换头盔照明"

/datum/action/item_action/toggle_helmet_flashlight
	name = "切换头盔手电"

/datum/action/item_action/toggle_helmet_mode
	name = "切换头盔模式"

/datum/action/item_action/crew_monitor
	name = "打开成员监视器"

/datum/action/item_action/toggle

/datum/action/item_action/toggle/New(Target)
	..()
	var/obj/O = target
	name = "切换[O.name]"

/datum/action/item_action/halt
	name = "停下！"

/datum/action/item_action/change
	name = "更改"

/datum/action/item_action/adjust

/datum/action/item_action/adjust/New(Target)
	..()
	var/obj/O = target
	name = "调整[O.name]"

/datum/action/item_action/switch_hud
	name = "切换HUD"

/datum/action/item_action/toggle_wings
	name = "切换翅膀"

/datum/action/item_action/toggle_human_head
	name = "切换人类头部"

/datum/action/item_action/toggle_helmet
	name = "切换头盔"

/datum/action/item_action/hands_free
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/item_action/hands_free/activate
	name = "激活"

/datum/action/item_action/hands_free/shift_nerves
	name = "转移神经"

/datum/action/item_action/explosive_implant
	check_flags = NONE
	name = "启动爆炸植入体"

/datum/action/language_menu
	name = "语言菜单"
	desc = ""
	button_icon_state = "language_menu"
	check_flags = NONE

/datum/action/language_menu/Trigger()
	if(!..())
		return FALSE
	if(ismob(owner))
		var/mob/M = owner
		var/datum/language_holder/H = M.get_language_holder()
		H.open_language_menu(usr)
