/obj/effect/temp_visual/small_smoke/gunsmoke //smoke visual
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/small_smoke/gunsmoke/Initialize(mapload, set_dir, size_mult = 1)
	. = ..()
	if(set_dir)
		dir = set_dir
	var/matrix/M = matrix()
	M.Turn(rand(-45, 45))
	M.Scale((rand(11, 16) / 10) * size_mult)
	var/drift_x = 0
	var/drift_y = 0
	switch(dir)
		if(NORTH)
			drift_y = rand(8, 16)
			drift_x = rand(-8, 8)
		if(SOUTH)
			drift_y = rand(-16, -8)
			drift_x = rand(-8, 8)
		if(EAST)
			drift_x = rand(8, 16)
			drift_y = rand(-8, 8)
		if(WEST)
			drift_x = rand(-16, -8)
			drift_y = rand(-8, 8)

	M.Translate(drift_x, drift_y)
	spawn(1)
		if(src)
			animate(src, transform = M, alpha = 0, time = rand(10, 15), easing = SINE_EASING | EASE_OUT)
			spawn(20)
				if(src)
					qdel(src)

/obj/effect/temp_visual/small_smoke/gunsmoke/black
	color = COLOR_BLACK

/obj/effect/temp_visual/small_smoke/gunsmoke/blue
	color = COLOR_BLUE_LIGHT

/obj/item/gun/ballistic/revolver/rune/twilight_runelock
	name = "符文锁手枪"
	desc = "一件极其致命的武器，以符文魔法代替火药。"
	icon = 'icons/roguetown/weapons/guns32.dmi'
	icon_state = "runepistol2"
	var/icon_state_ready = "runepistol2-1"
	var/default_icon_state = "runepistol2"
	item_state = "runepistol2"
	possible_item_intents = list(/datum/intent/shoot/twilight_runelock, /datum/intent/arc/twilight_runelock, INTENT_GENERIC)
	mag_type = /obj/item/ammo_box/magazine/internal/shot/twilight_runelock
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_BULKY
	spread = 10
	recoil = 3
	force = 10
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME | CLAMP_BREAK
	var/cocked = FALSE
	cartridge_wording = "符文弹丸"
	load_sound = 'sound/firearm/musketload.ogg'
	fire_sound = 'sound/firearm/runelock_fire.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 200
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel
	var/misfire_chance = 0
	var/reload_time = 8
	var/reload_stamina_cost = 30
	damfactor = 1
	per_scales_damage = TRUE
	var/critfactor = 0.7
	var/npcdamfactor = 4
	equip_delay_self = 1 SECONDS
	unequip_delay_self = 1 SECONDS
	inv_storage_delay = 1 SECONDS
	var/can_spin = TRUE // Pistols can be spun on the finger. The rifle turns this off.

	//spinning the pistol has a cooldown on the to_chat to reduce chatspam
	COOLDOWN_DECLARE(flip_cooldown)

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 30,"sturn" = -30,"wturn" = -30,"eturn" = 30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/rmb_self(mob/user)
	. = ..()
	if(.)
		return
	if(!can_spin)
		return

	SpinAnimation(4, 2) // The spin happens regardless of the cooldown

	if(!COOLDOWN_FINISHED(src, flip_cooldown))
		return

	COOLDOWN_START(src, flip_cooldown, 3 SECONDS)
	if((user.get_skill_level(/datum/skill/combat/firearms) < 3) && prob(40))
		user.visible_message(
			span_danger("[user]试图转动[src]，却把它掉在了地上！"),
			span_userdanger("你试图转动[src]，却把它掉在了地上！"),
		)
		if(isliving(user))
			var/mob/living/unfortunate_idiot = user
			var/dropped_gun_target = pick(
				BODY_ZONE_PRECISE_L_FOOT,
				BODY_ZONE_PRECISE_R_FOOT,
			)
			unfortunate_idiot.apply_damage(src.force, BRUTE, dropped_gun_target)
		user.dropItemToGround(src, TRUE)
	else
		user.visible_message(
			span_notice("[user]让[src]绕着[user.p_their()]手指转动。"),
			span_notice("你让[src]绕着自己的手指转动。"),
		)
		playsound(src, 'sound/foley/equip/swordsmall1.ogg', 20, FALSE)

	return

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/shoot_with_empty_chamber()
	if(cocked)
		playsound(src.loc, 'sound/firearm/musketcock.ogg', 100, FALSE)
		cocked = FALSE
		icon_state = initial(icon_state)
		update_icon()

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/attack_self(mob/living/user)
	if(twohands_required)
		return
	if(altgripped || wielded)
		ungrip(user)
		return
		
	if(!cocked)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(HAS_TRAIT(H, TRAIT_INQUISITION) || (H.STAINT >= 15) || (H.merctype == 10))
				to_chat(H, span_info("我开始向符文锁注入符文能量……"))
				var/adj_load_time = reload_time * 10
				if(H.mind)
					var/skill = H.get_skill_level(/datum/skill/combat/firearms)
					if(skill)
						adj_load_time = (reload_time * 10) / max(1, skill)
						
				if(do_after(H, adj_load_time, src))
					H.stamina_add(reload_stamina_cost)
					playsound(H, 'sound/magic/charged.ogg', 100, FALSE)
					user.visible_message(span_notice("[user]向\the [src]上的符文注入魔力。"))
					cocked = TRUE
			else
				to_chat(H, span_warning("我完全不知道该怎么用这东西！"))
		else
			to_chat(user, span_warning("我完全不知道该怎么用这东西！"))
	else
		if(alt_grips)
			altgrip(user)
		if(gripped_intents)
			wield(user)
			
	update_icon()

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/update_icon()
	if(cocked && icon_state_ready)
		icon_state = icon_state_ready
		item_state = icon_state_ready
	else
		icon_state = default_icon_state
		item_state = default_icon_state
	if(!ismob(loc))
		return
	var/mob/M = loc
	M.update_inv_hands()

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/powderflask))
		to_chat(user, span_warning("这件武器使用符文魔法，而非粗劣的火药！应当直接向它注入能量。"))
		return
		
	if(istype(A, /obj/item/ammo_casing))
		if(cocked)
			if((loc == user) && (user.get_inactive_held_item() != src) && (user.get_active_held_item() != src))
				return
			if(istype(A, /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy) && !heavy_load)
				to_chat(user, span_warning("这是重型弹丸，[name]的符文无法提供足够的发射能量。"))
				return
			if(!istype(A, /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy) && heavy_load)
				to_chat(user, span_warning("这是轻型弹丸，若强行发射，[name]的符文会使它过载。"))
				return
			..()
		else
			to_chat(user, span_warning("我得先为符文锁充能！"))

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/examine(mob/living/carbon/human/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/u = user
		if(HAS_TRAIT(u, TRAIT_INQUISITION) || (u.STAINT >= 15) || (u.merctype == 10))
			if(cocked)
				if(chambered)
					. += span_notice("符文已充能，弹丸已入膛。武器随时可以开火。")
				else
					. += span_notice("符文已充能，但尚未装入弹丸。")
			else
				. += span_notice("尚未充能。")
		else
			. += span_notice("你不熟悉这件武器的枪锁构造。")

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("符文锁需要专用的符文弹丸。开火前必须向武器注入魔力，再装入弹丸。")

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(chambered && HAS_TRAIT(user, TRAIT_PACIFISM))
		if(chambered.harmful)
			to_chat(user, span_warning("[src]装着致命弹药！你不愿冒伤害他人的风险……"))
			return
	var/skill = user.get_skill_level(/datum/skill/combat/firearms)
	if(skill)
		misfire_chance = max(0, misfire_chance - (skill * 2))
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	if(prob(misfire_chance))
		to_chat(user, span_warning("[name]发射失控了！"))
		explosion(src, light_impact_range = 2, heavy_impact_range = 1, smoke = FALSE, soundin = 'sound/misc/explode/bomb.ogg')
		qdel(src)
		return
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/bullet/firearm/BB = CB.BB
		if(BB)
			BB.gunpowder_npc_critfactor *= npcdamfactor
			BB.critfactor *= critfactor
			BB.damage *= damfactor * get_per_damage_scaling(user)
	cocked = FALSE
	update_icon()
	var/shoot_dir = get_dir(src, target)
	new /obj/effect/temp_visual/small_smoke/gunsmoke/blue(get_step(user, shoot_dir), shoot_dir)
	..()

/obj/item/ammo_box/magazine/internal/shot/twilight_runelock
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock
	caliber = "runed_sphere"
	max_ammo = 1
	start_empty = TRUE

/datum/intent/shoot/twilight_runelock
	chargedrain = 0

/datum/intent/shoot/twilight_runelock/get_chargetime()
	if(mastermob && chargetime)
		var/newtime = chargetime
		newtime = newtime + 75
		newtime = newtime / max(1, mastermob.get_skill_level(/datum/skill/combat/firearms))
		newtime = newtime + 20
		newtime = newtime - ((mastermob.STAPER)*1.5)
		if(newtime > 10)
			return newtime
		else
			return 10
	return chargetime

/datum/intent/arc/twilight_runelock
	chargetime = 1
	chargedrain = 0

/datum/intent/arc/twilight_runelock/get_chargetime()
	if(mastermob && chargetime)
		var/newtime = chargetime
		newtime = newtime + 70
		newtime = newtime / max(1, mastermob.get_skill_level(/datum/skill/combat/firearms))
		newtime = newtime + 20
		newtime = newtime - ((mastermob.STAPER)*1.5)
		if(newtime > 10)
			return newtime
		else
			return 10
	return chargetime

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/rifle
	name = "\"修院长\""
	desc = "新时代的圣器，为终结现世历史的大战而铸。这支符文步枪由奥塔万工匠大师打造，再由奥塔瓦的符文法师施以附魔，意在末日之时粉碎黑暗军团。枪管上的符文以异端之血铭刻；那些背弃正信之人，已用性命偿还了罪孽。"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "runelock"
	icon_state_ready = "runelock_loaded"
	default_icon_state = "runelock"
	item_state = "runelock"
	force_wielded = 15
	associated_skill = /datum/skill/combat/polearms
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/shoot/twilight_runelock, /datum/intent/arc/twilight_runelock, INTENT_GENERIC)
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	experimental_onback = TRUE
	bigboy = TRUE
	wlength = WLENGTH_LONG
	slot_flags = ITEM_SLOT_BACK
	wdefense = 3
	can_parry = TRUE
	minstr = 6
	walking_stick = TRUE
	damfactor = 1
	critfactor = 1
	reload_time = 40
	reload_stamina_cost = 80
	can_spin = FALSE // No twirling a rifle around your finger.
	heavy_load = TRUE // the one gun that fires heavy bullets

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/rifle/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 6,"nx" = 7,"ny" = 6,"wx" = -2,"wy" = 3,"ex" = 1,"ey" = 3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -43,"sturn" = 43,"wturn" = 30,"eturn" = -30, "nflip" = 0, "sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -5,"ny" = -1,"wx" = -8,"wy" = 2,"ex" = 8,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = -45,"sturn" = 45,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/lesser
	name = "符文锁手枪"
	desc = "一把仓促铭刻的符文锁手枪。符文刻得很浅，魔力传导效率低下。"
	damfactor = 0.8
