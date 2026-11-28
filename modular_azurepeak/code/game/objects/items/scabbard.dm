/obj/item/rogueweapon/scabbard
	name = "剑鞘"
	desc = ""

	icon = 'modular_azurepeak/icons/obj/items/scabbard.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	icon_state = "scabbard"
	item_state = "scabbard"

	parrysound = "parrywood"
	attacked_sound = "parrywood"

	anvilrepair = /datum/skill/craft/blacksmithing

	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	possible_item_intents = list(SHIELD_BASH)
	sharpness = IS_BLUNT
	wlength = WLENGTH_SHORT
	resistance_flags = FLAMMABLE
	blade_dulling = DULLING_BASHCHOP
	w_class = WEIGHT_CLASS_BULKY
	alternate_worn_layer = UNDER_CLOAK_LAYER
	experimental_onhip = TRUE
	experimental_onback = TRUE
	can_parry = FALSE

	COOLDOWN_DECLARE(shield_bang)

	/// Weapon path and its children that are allowed
	var/obj/item/rogueweapon/valid_blade
	/// Specific weapons that are allowed. Bypasses valid_blade
	var/list/obj/item/rogueweapon/valid_blades
	/// Specific weapons that are not allowed. Bypassed valid_blade
	var/list/obj/item/rogueweapon/invalid_blades


	var/holster_type = /datum/component/holster
	/// Stores the holster component
	var/datum/component/holster/hol_comp
	/// Sheathe icon used when this scabbard has no state for the sheathed weapon's own sheathe_icon
	var/fallback_sheathe_icon = ""

	var/sheathe_time = 0.1 SECONDS

/obj/item/rogueweapon/scabbard/Initialize(mapload)
	. = ..()
	hol_comp = AddComponent(holster_type, valid_blade, valid_blades, invalid_blades, sheathe_time)

/obj/item/rogueweapon/scabbard/Destroy()
	hol_comp = null
	return ..()

/obj/item/rogueweapon/scabbard/attack_obj(obj/O, mob/living/user)
	return FALSE


/obj/item/rogueweapon/scabbard/attack_turf(turf/T, mob/living/user)
	to_chat(user, span_notice("我开始寻找自己的剑......"))
	for(var/obj/item/rogueweapon/sword/sword in T.contents)
		if(hol_comp.eat_sword(user, sword))
			break

	..()


/obj/item/rogueweapon/scabbard/MouseDrop(atom/over)
	..()
	var/mob/living/M = usr

	if(!Adjacent(M))
		return
	if(!M.incapacitated() && istype(over, /atom/movable/screen/inventory/hand))
		var/atom/movable/screen/inventory/hand/H = over
		if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
			add_fingerprint(usr)


/obj/item/rogueweapon/scabbard/attack_hand(mob/user)
	if(hol_comp.sheathed)
		return hol_comp.puke_sword(user)

	..()


/obj/item/rogueweapon/scabbard/attackby(obj/item/I, mob/user, params)
	if(!hol_comp.sheathed)
		if(!hol_comp.eat_sword(user, I))
			return ..()

/obj/item/rogueweapon/scabbard/quickdraw_interact(mob/living/user, obj/item/held_item)
	if(held_item)
		if(hol_comp.weapon_check(user, held_item))
			attackby(held_item, user)
		return TRUE
	if(hol_comp.sheathed)
		attack_hand(user)
	return TRUE


/obj/item/rogueweapon/scabbard/update_icon(mob/living/user)
	var/obj/item/rogueweapon/sheathed = hol_comp?.sheathed
	if(sheathed)
		icon_state = "[initial(icon_state)]_[sheathed.sheathe_icon]"
		if(!icon_exists(icon, icon_state))
			icon_state = "[initial(icon_state)]_[fallback_sheathe_icon]"
	else
		icon_state = "[initial(icon_state)]"

	if(user)
		user.update_inv_hands()
		user.update_inv_belt()
		user.update_inv_back()


/obj/item/rogueweapon/scabbard/getonmobprop(tag)
	..()

	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.6,
					"sx" = -6,
					"sy" = -1,
					"nx" = 6,
					"ny" = -1,
					"wx" = 0,
					"wy" = -2,
					"ex" = 0,
					"ey" = -2,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 1,
					"sflip" = 0,
					"wflip" = 1,
					"eflip" = 0
				)
			if("onback")
				return list(
					"shrink" = 0.5,
					"sx" = 1,
					"sy" = 4,
					"nx" = 1,
					"ny" = 2,
					"wx" = 3,
					"wy" = 3,
					"ex" = 0,
					"ey" = 2,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0
				)
			if("onbelt")
				return list(
					"shrink" = 0.5,
					"sx" = -2,
					"sy" = -5,
					"nx" = 4,
					"ny" = -5,
					"wx" = 0,
					"wy" = -5,
					"ex" = 2,
					"ey" = -5,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = -90,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 1
				)


/*
	DAGGER SHEATHS
*/


/obj/item/rogueweapon/scabbard/sheath
	name = "匕首套"
	desc = "一个可悬挂的皮制刀套，专门收纳那些更小巧的惊喜。"
	sewrepair = TRUE

	icon_state = "sheath"
	item_state = "sheath"

	valid_blade = /obj/item/rogueweapon/huntingknife
	fallback_sheathe_icon = "gendagger"
	holster_type = /datum/component/holster/sheath
	w_class = WEIGHT_CLASS_SMALL

	grid_width = 32
	grid_height = 64
	dropshrink = 0.85

	force = 3
	max_integrity = 500

	invalid_blades = list(
		/obj/item/rogueweapon/huntingknife/idagger/silver/stake
	)

/obj/item/rogueweapon/scabbard/sheath/getonmobprop(tag)
	..()

	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.5,
					"sx" = -6,
					"sy" = -1,
					"nx" = 6,
					"ny" = -1,
					"wx" = 0,
					"wy" = -2,
					"ex" = 0,
					"ey" = -2,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 1,
					"sflip" = 1,
					"wflip" = 1,
					"eflip" = 0
				)
			if("onback")
				return list(
					"shrink" = 0.4,
					"sx" = -3,
					"sy" = -1,
					"nx" = 0,
					"ny" = 0,
					"wx" = -4,
					"wy" = 0,
					"ex" = 2,
					"ey" = 1,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 0,
					"sturn" = 10,
					"wturn" = 32,
					"eturn" = -23,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 0
				)
			if("onbelt")
				return list(
					"shrink" = 0.5,
					"sx" = -2,
					"sy" = -5,
					"nx" = 4,
					"ny" = -5,
					"wx" = 0,
					"wy" = -5,
					"ex" = 2,
					"ey" = -5,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 1
				)


/*
	GREATWEAPON STRAPS
*/


/obj/item/rogueweapon/scabbard/gwstrap
	name = "巨型武器背带"
	desc = ""

	icon_state = "gws0"
	item_state = "gwstrap"
	icon = 'modular_azurepeak/icons/obj/items/gwstrap.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64

	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = NONE
	experimental_onback = FALSE
	bigboy = TRUE

	equip_delay_self = 5 SECONDS
	unequip_delay_self = 5 SECONDS
	strip_delay = 2 SECONDS
	sheathe_time = 2 SECONDS
	holster_type = /datum/component/holster/gwstrap

	max_integrity = 0

/obj/item/rogueweapon/scabbard/gwstrap/update_icon(mob/living/user)
	var/obj/item/rogueweapon/sheathed = hol_comp?.sheathed
	if(sheathed)
		worn_x_dimension = 64
		worn_y_dimension = 64
		icon = sheathed.icon
		icon_state = sheathed.icon_state
		experimental_onback = TRUE
	else
		icon = initial(icon)
		icon_state = initial(icon_state)
		worn_x_dimension = initial(worn_x_dimension)
		worn_y_dimension = initial(worn_y_dimension)
		experimental_onback = FALSE

	if(user)
		user.update_inv_back()

/obj/item/rogueweapon/scabbard/gwstrap/getonmobprop(tag)
	..()
	var/obj/item/rogueweapon/sheathed = hol_comp?.sheathed
	if(!sheathed)
		return
	if(istype(sheathed, /obj/item/rogueweapon/estoc) || istype(sheathed, /obj/item/rogueweapon/greatsword))
		switch(tag)
			if("onback")
				return list(
					"shrink" = 0.6,
					"sx" = -1,
					"sy" = 2,
					"nx" = 0,
					"ny" = 2,
					"wx" = 2,
					"wy" = 1,
					"ex" = 0,
					"ey" = 1,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 70,
					"eturn" = 15,
					"nflip" = 1,
					"sflip" = 1,
					"wflip" = 1,
					"eflip" = 1,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0
				)
	else
		switch(tag)
			if("onback")
				return list(
					"shrink" = 0.7,
					"sx" = 1,
					"sy" = -1,
					"nx" = 1,
					"ny" = -1,
					"wx" = 4,
					"wy" = -1,
					"ex" = -1,
					"ey" = -1,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0
				)

// Kazengun Greatsword strap //
/obj/item/rogueweapon/scabbard/gwstrap/nodachi
	name = "野太刀鞘"
	desc = "保养良好的背带连接着漆木刀鞘，鞘上饰有金属包边，看起来专为收纳格外修长的刀刃而制。"

	icon_state = "saya0"
	item_state = "saya"
	valid_blades = list(/obj/item/rogueweapon/greatsword/nodachi)
	experimental_onback = TRUE

/obj/item/rogueweapon/scabbard/gwstrap/nodachi/update_icon(mob/living/user)
	var/obj/item/rogueweapon/sheathed = hol_comp?.sheathed
	if(sheathed)
		icon = initial(icon)
		icon_state = "saya1"
		worn_x_dimension = 64
		worn_y_dimension = 64
		experimental_onback = TRUE
	else
		icon = initial(icon)
		icon_state = initial(icon_state)
		worn_x_dimension = initial(worn_x_dimension)
		worn_y_dimension = initial(worn_y_dimension)
		experimental_onback = TRUE
	if(user)
		user.update_inv_back()

/obj/item/rogueweapon/scabbard/gwstrap/nodachi/getonmobprop(tag)
	..()
	var/obj/item/rogueweapon/sheathed = hol_comp?.sheathed
	if(!sheathed)
		return
	if(istype(sheathed, /obj/item/rogueweapon/estoc) || istype(sheathed, /obj/item/rogueweapon/greatsword))
		switch(tag)
			if("onback")
				return list(
					"shrink" = 0.6,
					"sx" = -1,
					"sy" = 2,
					"nx" = 0,
					"ny" = 2,
					"wx" = 2,
					"wy" = 1,
					"ex" = 0,
					"ey" = 1,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = -70,
					"eturn" = -15,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0
				)
	else
		switch(tag)
			if("onback")
				return list(
					"shrink" = 0.7,
					"sx" = 1,
					"sy" = -1,
					"nx" = 1,
					"ny" = -1,
					"wx" = 4,
					"wy" = -1,
					"ex" = -1,
					"ey" = -1,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0
				)

///////////////////////
//	SWORD SCABBARDS  //
///////////////////////

/obj/item/rogueweapon/scabbard/sword
	name = "简易剑鞘"
	desc = "长剑出现后，自然而然演化出的配套之物。"

	icon_state = "scabbard"
	item_state = "scabbard"

	sewrepair = TRUE

	valid_blade = /obj/item/rogueweapon/sword
	fallback_sheathe_icon = "gensword"
//You'd think think it'd look for subtypes, but no.
	invalid_blades = list(
		/obj/item/rogueweapon/sword/long/exe,
		/obj/item/rogueweapon/sword/long/exe/astrata,
		/obj/item/rogueweapon/sword/long/exe/cloth,
		/obj/item/rogueweapon/sword/long/martyr,
		/obj/item/rogueweapon/sword/long/exe/silver,
		/obj/item/rogueweapon/sword/long/exe/psy,
		/obj/item/rogueweapon/sword/long/exe/berserk,
		/obj/item/rogueweapon/sword/long/exe/berserk/dragonslayer
	)

	force = 7
	max_integrity = 750


/obj/item/rogueweapon/scabbard/sword/noble
	name = "银饰剑鞘"
	desc = "一副缀有精巧银饰的贵族剑鞘，犹如用银盘托起贵族的佩剑。而且，就像真正的银盘一样，它也足以招架偶然袭来的一击并加以还击。"
	icon_state = "nscabbard"
	associated_skill = /datum/skill/combat/swords
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK, SHIELD_SMASH)
	can_parry = TRUE
	sewrepair = FALSE
	wdefense = 4
	max_integrity = 75
	resistance_flags = null

/obj/item/rogueweapon/scabbard/sword/royal
	name = "金饰剑鞘"
	desc = "一副缀有精美金饰的王室剑鞘，以金丝绸缎温柔裹住勇士的佩剑，仿佛不愿放手。"
	icon_state = "rscabbard"
	associated_skill = /datum/skill/combat/swords
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK, SHIELD_SMASH)
	can_parry = TRUE
	sewrepair = FALSE
	wdefense = 6
	max_integrity = 150
	resistance_flags = null

/obj/item/rogueweapon/scabbard/sheath/courtphysician
	name = "华丽手杖"
	desc = "一根饰有秃鹫面孔的精美手杖。"
	icon_state = "doccanesheath"
	item_state = "doccanesheath"
	valid_blade = /obj/item/rogueweapon/sword/rapier/courtphysician

/obj/item/rogueweapon/scabbard/sheath/courtphysician/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.5,
					"sx" = -6,
					"sy" = -6,
					"nx" = 6,
					"ny" = -5,
					"wx" = -1,
					"wy" = -5,
					"ex" = -1,
					"ey" = -5,
					"nturn" = -45,
					"sturn" = -45,
					"wturn" = -45,
					"eturn" = -45,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = FALSE,
					"southabove" = TRUE,
					"eastabove" = TRUE,
					"westabove" = FALSE
				)
			if("wielded")
				return list(
					"shrink" = 0.5,
					"sx" = 0,
					"sy" = 0,
					"nx" = 0,
					"ny" = 0,
					"wx" = -3,
					"wy" = 0,
					"ex" = 3,
					"ey" = 0,
					"nturn" = -90,
					"sturn" = 0,
					"wturn" = -90,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = FALSE,
					"southabove" = TRUE,
					"eastabove" = TRUE,
					"westabove" = TRUE
				)
			if("onbelt")
				return list(
					"shrink" = 0.3,
					"sx" = -2,
					"sy" = -5,
					"nx" = 4,
					"ny" = -5,
					"wx" = 0,
					"wy" = -5,
					"ex" = 2,
					"ey" = -5,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0
				)

/obj/item/rogueweapon/scabbard/sheath/courtphysician/hand
	name = "天鹅绒姐妹"
	desc = "优雅、时髦而致命，这根手杖与持杖者皆是如此。永远不要甘居人后，也永远不要只依赖一种手段。\
	柄中镶嵌的隆兹石可作为施展奥术的聚焦媒介。"
	icon = 'icons/roguetown/weapons/special/hand32.dmi'
	icon_state = "staffsheath"
	item_state = "staffsheath"
	valid_blade = /obj/item/rogueweapon/sword/rapier/hand
	// Is meant to be a wand for mage 2.0, but we don't have that on RW.

///////////////////////
//	KNIFE SCABBARDS  //
///////////////////////

/obj/item/rogueweapon/scabbard/sheath/noble
	name = "银饰匕首鞘"
	desc = "一副缀有精巧银饰的贵族匕首鞘，常被骑士挂在腰甲上炫耀。每当其中的钢刃出鞘，它便随之摇晃。"
	icon_state = "nsheath"
	associated_skill = /datum/skill/combat/knives
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK)
	can_parry = TRUE
	sewrepair = FALSE
	wdefense = 2
	max_integrity = 50
	resistance_flags = null

/obj/item/rogueweapon/scabbard/sheath/royal
	name = "金饰匕首鞘"
	desc = "一副缀有精美金饰的王室匕首鞘。拔出利刃的那只手将决定无数人的命运，无论是为了王国，还是整个世界。"
	icon_state = "rsheath"
	associated_skill = /datum/skill/combat/knives
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK)
	can_parry = TRUE
	sewrepair = FALSE
	wdefense = 4
	max_integrity = 100
	resistance_flags = null

/*
	KAZENGUN
*/


/obj/item/rogueweapon/scabbard/sword/kazengun
	name = "简式风军剑鞘"
	desc = "木衬钢鞘。很适合用来格挡来袭打击。"
	icon_state = "kazscab"
	item_state = "kazscab"
	fallback_sheathe_icon = "mulyeog"
	// Only accept Kazengun swords
	valid_blades = list(
		/obj/item/rogueweapon/sword/short/kazengun,
		/obj/item/rogueweapon/sword/sabre/mulyeog,
		/obj/item/rogueweapon/sword/sabre/mulyeog/silver,
		/obj/item/rogueweapon/sword/sabre/mulyeog/rumahench,
		/obj/item/rogueweapon/sword/sabre/mulyeog/rumacaptain,
		/obj/item/rogueweapon/sword/sabre/hook
	)

	associated_skill = /datum/skill/combat/swords
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK, SHIELD_SMASH)
	can_parry = TRUE
	sewrepair = FALSE
	wdefense = 8

	max_integrity = 220

/obj/item/rogueweapon/scabbard/sword/kazengun/noparry
	name = "仪式风军剑鞘"
	desc = "一把以青铜修边的简易木鞘。不同于它的钢制同类，这把无法招架。"
	// Accept Kazengun short/sabre swords and longswords
	valid_blades = list(
		/obj/item/rogueweapon/sword/short/kazengun,
		/obj/item/rogueweapon/sword/sabre/mulyeog,
		/obj/item/rogueweapon/sword/sabre/mulyeog/rumahench,
		/obj/item/rogueweapon/sword/sabre/mulyeog/rumacaptain,
		/obj/item/rogueweapon/sword/sabre/hook,
		/obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo,
		/obj/item/rogueweapon/sword/long/kriegmesser/silver/ssangsudo
	)
	can_parry = FALSE

/obj/item/rogueweapon/scabbard/sword/kazengun/noparry/loadout
	name = "仪式剑鞘"
	desc = "一把以青铜修边的简易木鞘。不同于它的钢制同类，这把无法招架。"
	// Accept Kazengun short/sabre swords and longswords
	valid_blades = list(
		/obj/item/rogueweapon/sword/short/kazengun,
		/obj/item/rogueweapon/sword/sabre/mulyeog,
		/obj/item/rogueweapon/sword/sabre/mulyeog/silver,
		/obj/item/rogueweapon/sword/sabre/mulyeog/rumahench,
		/obj/item/rogueweapon/sword/sabre/mulyeog/rumacaptain,
		/obj/item/rogueweapon/sword/sabre/hook,
		/obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo,
		/obj/item/rogueweapon/sword/long/kriegmesser/silver/ssangsudo
	)

/obj/item/rogueweapon/scabbard/sword/kazengun/steel
	name = "云纹剑鞘"
	desc = "一把带有云纹与布绶带的剑鞘。可用于格挡。"
	icon_state = "kazscab_steel"
	item_state = "kazscab_steel"
	associated_skill = /datum/skill/combat/swords
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK, SHIELD_SMASH)
	// Only accept Kazengun swords
	valid_blades = list(
		/obj/item/rogueweapon/sword/short/kazengun,
		/obj/item/rogueweapon/sword/sabre/mulyeog,
		/obj/item/rogueweapon/sword/sabre/mulyeog/rumahench,
		/obj/item/rogueweapon/sword/sabre/mulyeog/rumacaptain,
		/obj/item/rogueweapon/sword/sabre/hook
	)

/obj/item/rogueweapon/scabbard/sword/kazengun/gold
	name = "鎏金心意剑鞘"
	desc = "一把带绶带的华丽木鞘。很适合用来招架。"
	icon_state = "kazscab_gold"
	item_state = "kazscab_gold"
	associated_skill = /datum/skill/combat/swords
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK, SHIELD_SMASH)
	// Only accept Kazengun swords
	valid_blades = list(
		/obj/item/rogueweapon/sword/short/kazengun,
		/obj/item/rogueweapon/sword/sabre/mulyeog,
		/obj/item/rogueweapon/sword/sabre/mulyeog/rumahench,
		/obj/item/rogueweapon/sword/sabre/mulyeog/rumacaptain,
		/obj/item/rogueweapon/sword/sabre/hook
	)
	max_integrity = 220

/obj/item/rogueweapon/scabbard/sword/kazengun/kodachi
	name = "素漆剑鞘"
	desc = "一把朴素上漆的剑鞘，配有简洁钢制配件。以一条深色素布悬挂在腰带上。"
	icon_state = "kazscabyuruku"
	item_state = "kazscabyuruku"
	fallback_sheathe_icon = "kodachi"
	associated_skill = /datum/skill/combat/swords
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK, SHIELD_SMASH)
	// Only accept Kazengun swords (kodachi variant)
	valid_blades = list(
		/obj/item/rogueweapon/sword/short/kazengun,
		/obj/item/rogueweapon/sword/short/silver/kazengun,
		/obj/item/rogueweapon/sword/sabre/mulyeog,
		/obj/item/rogueweapon/sword/sabre/mulyeog/rumahench,
		/obj/item/rogueweapon/sword/sabre/mulyeog/rumacaptain,
		/obj/item/rogueweapon/sword/sabre/hook
	)
	wdefense = 4

/obj/item/rogueweapon/scabbard/sheath/kazengun
	name = "素漆刀套"
	desc = "一个简洁的上漆刀套，适用于较短的东方风格刀刃。"
	icon_state = "kazscabdagger"
	item_state = "kazscabdagger"
	fallback_sheathe_icon = "tanto"
	// Only accept Kazengun daggers
	valid_blades = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun,
		/obj/item/rogueweapon/huntingknife/idagger/silver/kazengun
	)
	associated_skill = /datum/skill/combat/knives
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK)
	can_parry = TRUE
	sewrepair = FALSE
	wdefense = 3

	max_integrity = 0
