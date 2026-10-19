/datum/intent/spear/thrust/lance
	damfactor = 1.25 // Turns its base damage into 30 on the 2hand thrust. It keeps the spear thrust one handed.

/datum/intent/lance
	name = "骑枪冲刺"
	icon_state = "inlance"
	attack_verb = list("枪刺", "贯穿", "刺穿")
	animname = "stab"
	item_d_type = "stab"
	penfactor = PEN_NONE
	chargetime = 4 SECONDS
	damfactor = 4
	reach = 2
	cleave = /datum/cleave_pattern/lance

/datum/intent/lance/onehand
	chargetime = 4 SECONDS
	swingdelay = 1 SECONDS
	reach = 2
	damfactor = 4 // 25% less damage
	cleave = /datum/cleave_pattern/lance

// Lance - a sidegrade to spear that has two special AOE attack requiring a lot of charging
// But inflicts massive amount of non armor piercing damage.
// If we move to a tier based AP pattern, they can probably pierce armor. Until then
// It is an armor mulcher

/obj/item/rogueweapon/spear/lance
	name = "骑枪"
	desc = "一种专为骑乘作战设计的长杆武器，使用时需夹在腋下平持 \
	。它装有护臂托，防止手臂在撞击时顺着 枪杆向前滑去。"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	icon_state = "lance"
	force = 15 // Its gonna sucks for 1 handed use
	force_wielded = 20 // Lower damage because a 3 tiles thrust without full charge time still deal base damage.
	wdefense = 4 // 2 Lower than spear
	max_integrity = 200
	max_blade_int = 200 // Better sharpness
	possible_item_intents = list(SPEAR_THRUST_1H, /datum/intent/lance/onehand, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/spear/thrust/lance, /datum/intent/lance, SPEAR_BASH)
	resistance_flags = null
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/spear/lance/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "旗帜") as anything in GLOB.colorlist
		user.visible_message(span_warning("[user]给[src]挂上了一面旗帜。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = GLOB.colorlist[choice]
		detail_tag = "detail"
		update_icon()

/obj/item/rogueweapon/spear/lance/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/rogueweapon/spear/lance/attack_self(mob/living/user)
	. = ..()
	update_icon()

/obj/item/rogueweapon/spear/lance/blacksteel
	name = "黑钢骑枪"
	desc = "一柄华丽的黑钢骑枪，专为骑乘赛加兽进行马上比武而设计。即便如此，在格伦泽尔霍夫特，身 \
	着黑钢甲胄的骑士们步战时将其作为长矛使用也并不罕见。 在柄上裹一段布料以展示你的纹章。"
	icon_state = "bs_lance"
	force = 20
	force_wielded = 25
	wdefense_wbonus = 2 //+1 over the traditional spear, once wielded.
	max_integrity = 300
	max_blade_int = 300
	resistance_flags = FIRE_PROOF
	smeltresult = /obj/item/ingot/blacksteel
	possible_item_intents = list(/datum/intent/spear/thrust, /datum/intent/lance/onehand, SPEAR_BASH)
	gripped_intents = list(/datum/intent/spear/thrust/lance, /datum/intent/lance, SPEAR_BASH)
