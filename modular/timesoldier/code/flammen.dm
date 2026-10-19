/obj/effect/hotspot/timesoldier_fire
	name = "灼烧烈焰"
	desc = "熊熊燃烧、紧附不散的火焰。"
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"

	life = 20
	firelevel = 3

	var/spread_radius = 0
	var/max_spread_radius = 0
	var/turf/spread_origin


/obj/effect/hotspot/timesoldier_fire/Initialize(mapload, starting_volume, starting_temperature, life)
	. = ..()

	// if the fire appears underneath somebody, that counts as contact.
	for(var/mob/living/L in loc)
		apply_scorcher_contact(L)


/obj/effect/hotspot/timesoldier_fire/process()
	. = ..()

	if(QDELETED(src))
		return

	icon_state = "3"


// we handle the Hei Long Pao's spread ourselves.
// do NOT let normal fire spread take over.
/obj/effect/hotspot/timesoldier_fire/handle_automatic_spread()
	return


/obj/effect/hotspot/timesoldier_fire/Crossed(atom/movable/AM, oldLoc)
	if(!isliving(AM))
		return

	var/mob/living/L = AM
	apply_scorcher_contact(L)


/obj/effect/hotspot/timesoldier_fire/proc/apply_scorcher_contact(mob/living/L)
	if(!L)
		return

	L.adjust_fire_stacks(100)
	L.ignite_mob()
	L.apply_status_effect(/datum/status_effect/debuff/timesoldier_scorcher_agony)



// LAVA GLOB

/obj/projectile/bullet/firearm/timesoldier_fire
	name = "熔岩团"
	desc = "一团猛烈燃烧的物质。"
	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	nondirectional_sprite = TRUE

	damage = 0
	damage_type = BURN
	armor_penetration = 0

	range = 8
	speed = 0.8


/obj/projectile/bullet/firearm/timesoldier_fire/proc/create_scorcher_fire(atom/target)
	var/turf/T = get_turf(target)
	if(!T)
		return

	var/obj/effect/hotspot/timesoldier_fire/F = locate(/obj/effect/hotspot/timesoldier_fire) in T

	if(!F)
		F = new /obj/effect/hotspot/timesoldier_fire(T)

	if(!F.spread_origin)
		F.start_scorcher_spread(2)


/obj/projectile/bullet/firearm/timesoldier_fire/on_hit(atom/target, blocked = FALSE)
	. = ..()

	create_scorcher_fire(target)

	if(isliving(target))
		var/mob/living/L = target

		L.adjust_fire_stacks(300)
		L.ignite_mob()
		L.apply_status_effect(/datum/status_effect/debuff/timesoldier_scorcher_agony)


/obj/projectile/bullet/firearm/timesoldier_fire/Destroy()
	if(fired)
		create_scorcher_fire(get_turf(src))

	return ..()



// FIRE SPREAD

/obj/effect/hotspot/timesoldier_fire/proc/start_scorcher_spread(radius = 2)
	spread_origin = get_turf(src)
	if(!spread_origin)
		return

	max_spread_radius = radius
	spread_radius = 1

	addtimer(CALLBACK(src, PROC_REF(spread_next_ring)), 2)


/obj/effect/hotspot/timesoldier_fire/proc/spread_next_ring()
	if(QDELETED(src))
		return

	if(!spread_origin)
		return

	if(spread_radius > max_spread_radius)
		return

	var/list/current_ring = circle_range_turfs(spread_origin, spread_radius)

	if(spread_radius > 1)
		var/list/previous_ring = circle_range_turfs(spread_origin, spread_radius - 1)
		current_ring -= previous_ring
	else
		current_ring -= spread_origin

	for(var/turf/T as anything in current_ring)
		if(T.density)
			continue

		if(!is_in_sight(spread_origin, T))
			continue

		if(locate(/obj/effect/hotspot/timesoldier_fire) in T)
			continue

		new /obj/effect/hotspot/timesoldier_fire(T)

	spread_radius++

	if(spread_radius <= max_spread_radius)
		addtimer(CALLBACK(src, PROC_REF(spread_next_ring)), 2)



// le ammo

/obj/item/ammo_casing/timesoldier_fire
	name = "lava charge"
	desc = "You should not be seeing this."
	icon_state = null

	caliber = "heilong"
	projectile_type = /obj/projectile/bullet/firearm/timesoldier_fire



// FUEL CANISTER

/obj/item/ammo_box/magazine/timesoldier_fire
	name = "黑龙炮储罐"
	desc = "一个沉重的密封容器，上面的奥术符印封存着极其炽热的熔岩。"
	grid_width = 64
	grid_height = 32

	icon = 'modular/timesoldier/sprites/nu_guns.dmi'
	icon_state = "heilong_a"

	ammo_type = /obj/item/ammo_casing/timesoldier_fire
	caliber = "heilong"

	max_ammo = 5
	multiload = FALSE
	start_empty = FALSE

	w_class = WEIGHT_CLASS_NORMAL


// do not let people pull the invisible internal charges out.
/obj/item/ammo_box/magazine/timesoldier_fire/attack_self(mob/user)
	to_chat(user, span_notice("[src]还剩[ammo_count(FALSE)]份装药。"))
	return


// these are sealed canisters.
/obj/item/ammo_box/magazine/timesoldier_fire/can_load(mob/user)
	return FALSE


// the canister only has one sprite for now.
/obj/item/ammo_box/magazine/timesoldier_fire/update_icon()
	return



// HEI LONG PAO



/obj/item/gun/ballistic/timesoldier_fire_wep
	name = "黑龙炮"
	desc = "<span class='red'><i>这件信义氏族的奥术奇物诞生于大玉帝国，如今是我的玩具了。我将用它制造何等壮观的杀戮！</i></span>"

	icon = 'modular/timesoldier/sprites/nu_guns.dmi'
	icon_state = "heilong_e"

	experimental_inhand = TRUE
	experimental_onback = TRUE
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE

	mag_type = /obj/item/ammo_box/magazine/timesoldier_fire
	internal_magazine = FALSE
	spawnwithmagazine = FALSE

	// this lets the chambered "round" remain conceptually inside
	// the canister rather than becoming a separate physical cartridge.
	bolt_type = BOLT_TYPE_OPEN

	semi_auto = TRUE
	automatic = 0
	casing_ejector = FALSE

	magazine_wording = "储罐"
	cartridge_wording = "装药"

	load_sound = 'modular/timesoldier/sounds/wepons/cannon_load.ogg'
	load_empty_sound = 'modular/timesoldier/sounds/wepons/cannon_load.ogg'
	fire_sound = 'modular/timesoldier/sounds/wepons/cannon.ogg'
	vary_fire_sound = FALSE
	load_sound_vary = FALSE

	load_sound_volume = 70
	fire_sound_volume = 100

	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(
		/datum/intent/shoot/firearm,
		/datum/intent/arc/firearm,
		INTENT_GENERIC
	)

	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	recoil = 2


/obj/item/gun/ballistic/timesoldier_fire_wep/Initialize(mapload)
	. = ..()

	// spawnwithmagazine = FALSE makes ballistic guns start locked.
	// the Hei Long Pao should be ready to accept and chamber a canister.
	bolt_locked = FALSE
	update_icon()


/obj/item/gun/ballistic/timesoldier_fire_wep/insert_magazine(mob/user, obj/item/ammo_box/magazine/AM, display_message = TRUE)
	. = ..()

	if(!.)
		return FALSE

	// Hei Long Pao handles its canister charges manually.
	// don't depend on the generic open-bolt state remaining correct.
	bolt_locked = FALSE

	if(!chambered?.BB && magazine?.ammo_count(FALSE))
		chambered = magazine.get_round(TRUE)

	update_icon()

	return TRUE


/obj/item/gun/ballistic/timesoldier_fire_wep/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.8,

					"sx" = -1, "sy" = -1,
					"nx" = 3,  "ny" = -1,
					"wx" = -2, "wy" = 0,
					"ex" = 4,  "ey" = 0,

					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,

					"nturn" = -14,
					"sturn" = 15,
					"wturn" = 19,
					"eturn" = -18,

					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 0
				)

			if("wielded")
				return list(
					"shrink" = 0.8,

					"sx" = 5,  "sy" = -2,
					"nx" = -5, "ny" = -1,
					"wx" = -2, "wy" = -1,
					"ex" = 8,  "ey" = 2,

					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 1,

					"nturn" = -45,
					"sturn" = 45,
					"wturn" = 0,
					"eturn" = 0,

					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 8,
					"eflip" = 0
				)

			if("onback")
				return list(
					"shrink" = 0.8,

					"sx" = -4, "sy" = 2,
					"nx" = 8,  "ny" = 2,
					"wx" = 0,  "wy" = 0,
					"ex" = -4, "ey" = 1,

					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,

					"nturn" = -85,
					"sturn" = -85,
					"wturn" = 90,
					"eturn" = -90,

					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0
				)

// WIELDING

/obj/item/gun/ballistic/timesoldier_fire_wep/attack_self(mob/living/user)
	if(wielded)
		ungrip(user)
		return

	wield(user)


/obj/item/gun/ballistic/timesoldier_fire_wep/can_shoot()
	if(!wielded)
		return FALSE

	// recover if the generic ballistic machinery somehow left us
	// with a loaded canister but no chambered lava charge.
	if(!chambered?.BB && magazine?.ammo_count(FALSE))
		chambered = magazine.get_round(TRUE)

	return !!chambered?.BB


/obj/item/gun/ballistic/timesoldier_fire_wep/shoot_with_empty_chamber(mob/living/user as mob|obj)
	if(!wielded)
		to_chat(user, span_warning("我得先用双手稳住[src]才能开火。"))
		return

	return ..()



// consume da glob

/obj/item/gun/ballistic/timesoldier_fire_wep/process_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	var/obj/item/ammo_casing/timesoldier_fire/spent_charge = chambered

	chambered = null

	if(spent_charge)
		if(magazine)
			magazine.stored_ammo -= spent_charge

		qdel(spent_charge)

	if(chamber_next_round && magazine?.ammo_count(FALSE))
		chambered = magazine.get_round(TRUE)

	update_icon()



// SPRITES

/obj/item/gun/ballistic/timesoldier_fire_wep/update_icon()
	..()

	// we use full sprite states instead of ballistic magazine overlays.
	cut_overlays()

	if(magazine && magazine.ammo_count(FALSE))
		icon_state = "heilong"
	else
		icon_state = "heilong_e"




// AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

/datum/status_effect/debuff/timesoldier_scorcher_agony
	id = "timesoldier_scorcher_agony"
	duration = 15 SECONDS
	tick_interval = 5 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null


/datum/status_effect/debuff/timesoldier_scorcher_agony/on_apply()
	. = ..()

	if(owner.stat == CONSCIOUS && !HAS_TRAIT(owner, TRAIT_NOPAIN))
		to_chat(owner, span_userdanger("操！！他们想把我活活烧死！！"))
		owner.emote("firescream", forced = TRUE)

	return TRUE

/datum/status_effect/debuff/timesoldier_scorcher_agony/tick()
	if(!owner || owner.stat != CONSCIOUS)
		return

	if(HAS_TRAIT(owner, TRAIT_NOPAIN))
		return

	if(owner.fire_stacks <= 0)
		qdel(src)
		return

	var/pain_message = pick(
		"烧起来了！！疼得受不了了！！",
		"我的皮肉正从骨头上熔落！！",
		"剧痛烧进了我的神经！！",
		"我受不了这折磨了！！求求你杀了我！！",
		"求求你结束我的痛苦！！",
		"诸神啊！！！")

	to_chat(owner, span_userdanger(pain_message))
	owner.emote("firescream", forced = TRUE)

