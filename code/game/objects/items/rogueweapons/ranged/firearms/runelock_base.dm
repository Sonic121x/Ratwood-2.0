/obj/item/gun/ballistic/revolver/rune
	name = "符文锁火器"
	desc = "符文锁火器的基础类型。"
	icon_state = "dshotgun_sawn"
	item_state = "gun"
	fire_sound = 'sound/blank.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	bolt_type = BOLT_TYPE_NO_BOLT
	istrainable = TRUE 
	
	// Core scaling variables
	var/damfactor = 1 
	var/accfactor = 1 
	var/penfactor = 0 
	var/quickloading = FALSE
	var/ranged_skill = null
	var/per_scales_damage = FALSE
	var/steady_aim = FALSE
	var/heavy_load = FALSE // If true, can fire heavy bullets

/obj/item/gun/ballistic/revolver/rune/proc/can_quick_load(mob/user)
	return TRUE

/obj/item/gun/ballistic/revolver/rune/proc/get_per_damage_scaling(mob/living/user)
	if(!user || !per_scales_damage)
		return 1
	// Baseline PER 10, softcap 20. Scales 5% per point up to 20, and 2.5% per point after.
	return max(0.5, 1 + ((min(user.STAPER, 20) - 10) * 0.05) + (max(0, user.STAPER - 20) * 0.025))

/obj/item/gun/ballistic/revolver/rune/get_mechanics_examine(mob/user)
	. = ..()
	if(steady_aim)
		. += span_info("这件武器具有<b>稳定瞄准</b>：我瞄准四肢、手脚或面部，与瞄准胸口一样轻松。")
	if(chambered)
		. += span_info("里面装着\a [chambered.name]。")

/obj/item/gun/ballistic/revolver/rune/attackby(obj/item/A, mob/user, params)
	. = ..()
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		chamber_round()

/obj/item/gun/ballistic/revolver/rune/Destroy()
	chambered = null
	QDEL_NULL(magazine)
	return ..()
