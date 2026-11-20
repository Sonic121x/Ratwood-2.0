/**
 * Parent bullet.
 */
/obj/item/ammo_casing/caseless/bullet
	name = "父类弹丸"
	desc = "你不该看到这个。快去喊卡尔！！！"
	projectile_type = /obj/projectile/bullet/firearm
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball"
	possible_item_intents = list(/datum/intent/use)
	dropshrink = 0.5
	max_integrity = 0.1
	w_class = WEIGHT_CLASS_TINY

/obj/projectile/bullet/firearm
	name = "父类火药投射物"
	damage = 90//Do you see how infrequently these things fire...
	armor_penetration = PEN_BSTEEL //... and yet I need to explain?
	range = 7 //Effective range? 7 tiles. You aren't sniping with this.
	embedchance = 100//Yessir.
	speed = 0.1//Take a guess.
	npc_simple_damage_mult = 4//320, at 80 base.
	accuracy = 90//Their point. Very slow firing. Yet powerful and accurate.
	bonus_accuracy = 10//As opposed to using PER.
	damage_type = BRUTE
	woundclass = BCLASS_PIERCE
	flag = "piercing"//Vestigial, but just in case we use another flag later.
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/caseless/bullet
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	var/stumble_strength = 4
	var/secondary_damage
	var/secondary_damage_type
	var/silver = FALSE
	var/blessed = FALSE
	var/critfactor = 1
	var/gunpowder_npc_critfactor = 1
	var/gunpowder

/obj/item/ammo_casing
	var/obj/item/quiver/twilight_bullet/runicbag/linked_bag = null
	var/obj/item/storage/belt/rogue/leather/entropy_sphere_belt/linked_belt = null
	var/breech_loaded = FALSE

/**
 * Generic ammo used by handgonnes and arquebuses
 */

/obj/item/ammo_casing/caseless/bullet/lead
	name = "铅弹"
	desc = "一颗小小的铅球。它和烟火药正好绝配。"
	projectile_type = /obj/projectile/bullet/firearm/lead
	caliber = "lead_sphere"

/obj/projectile/bullet/firearm/lead
	name = "铅弹"
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead

/obj/projectile/bullet/firearm/lead/on_hit(atom/target)
	if(isliving(target))
		var/mob/living/target_living = target
		if(target_living.has_status_effect(/datum/status_effect/debuff/exposed) || target_living.has_status_effect(/datum/status_effect/debuff/vulnerable))
			damage *= 1.5

	. = ..()

	var/mob/living/L = firer
	if(!L || !L.mind)
		return

	var/skill_multiplier = 0

	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 4

	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/firearms, SKILL_LEVEL_EXPERT))
		L.mind.add_sleep_experience(/datum/skill/combat/firearms, L.STAINT * skill_multiplier)

/**
 * Now, actual grapeshot, for the proper blunderbuss.
 */

/obj/item/ammo_casing/caseless/bullet/grapeshot
	name = "霰弹"
	desc = "一捧细小的金属珠粒。它和烟火药正好绝配。"
	projectile_type = /obj/projectile/bullet/firearm/grapeshot
	caliber = "grapeshot"
	icon_state = "grapeshot"
	pellets = 6//180 point blank, based on 30 damage.
	variance = 30

/obj/projectile/bullet/firearm/grapeshot
	name = "霰弹"
	damage = 30
	range = 15
	npc_simple_damage_mult = 4//720 potential, if all hit.
	ammo_type = /obj/item/ammo_casing/caseless/bullet/grapeshot
	stumble_strength = 1//6 potential, if all hit.

/obj/projectile/bullet/firearm/grapeshot/on_hit(atom/target)
	. = ..()

	var/mob/living/L = firer
	if(!L || !L.mind)
		return

	var/skill_multiplier = 0

	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 4

	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/firearms, SKILL_LEVEL_EXPERT))
		L.mind.add_sleep_experience(/datum/skill/combat/firearms, L.STAINT * skill_multiplier)

/**
 * General firearm effect, on strike.
 * You roll 1-12, and if it's higher than your CON, you're FUCKED.
 * Otherwise, applies a slowdown for beating the check.
 * Silver and blessed burn is handled here too, so every subtype inherits it.
 */

/obj/projectile/bullet/firearm/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		var/list/screams = list("painscream", "paincrit")
		var/check = rand(1, 12)//12CON or higher to beat this every time.
		if(isliving(target))
			if(check > M.STACON)//Has to beat, not meet.
				M.emote(screams)//MY INSIDES ARE ON THE OUTSIDE!!!
				M.Knockdown(rand(15,30))
				M.Immobilize(rand(30,60))
			else
				M.Slowdown(stumble_strength)
	if(silver && isliving(target))
		var/mob/living/T = target
		if(HAS_TRAIT(T, TRAIT_SILVER_WEAK))
			if(blessed)
				if(!T.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder))
					if(T.patron)
						to_chat(T, span_danger("这该诅咒千遍的奥塔万白银！[T.patron.name]在上，痛死我了！！"))
					else
						to_chat(T, span_danger("这该诅咒千遍的奥塔万白银！诸神在上，痛死我了！！"))
				T.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/sunder/blessed)
			else
				if(!T.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
					to_chat(T, span_danger("白银排斥着我的存在！烈焰正在鞭笞我的灵魂！"))
				T.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/sunder)
			T.ignite_mob()

//The actual pouches.
/obj/item/quiver/bullet
	name = "铅弹袋"
	desc = "这个小袋能装下一把火枪铅弹，或者一把霰弹。"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "slingpouch"//Need another sprite.
	item_state = "slingpouch"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_NECK
	max_storage = 8
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 64
	grid_width = 32

/obj/item/quiver/bullet/attack_turf(turf/T, mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_warning("我的[src.name]已经装满了！"))
		return
	to_chat(user, span_notice("我开始收拢这些弹药……"))
	for(var/obj/item/ammo_casing/caseless/bullet in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(bullet))
				break

/obj/item/quiver/bullet/attackby(obj/A, loc, params)
	if(A.type in subtypesof(/obj/item/ammo_casing/caseless/bullet))
		if(arrows.len < max_storage)
			if(ismob(loc))
				var/mob/M = loc
				M.doUnEquip(A, TRUE, src, TRUE, silent = TRUE)
			else
				A.forceMove(src)
			arrows += A
			update_icon()
		else
			to_chat(loc, span_warning("装满了！"))
		return
	if(istype(A, /obj/item/gun/ballistic/firearm))
		var/obj/item/gun/ballistic/firearm/B = A
		if(arrows.len && !B.chambered)
			for(var/AR in arrows)
				if(istype(AR, /obj/item/ammo_casing/caseless/bullet))
					arrows -= AR
					B.attackby(AR, loc, params)
					break
		return
	..()

/obj/item/quiver/bullet/attack_right(mob/user)
	if(arrows.len)
		var/obj/O = arrows[arrows.len]
		arrows -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/quiver/bullet/update_icon()
	return

/obj/item/quiver/bullet/lead/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/bullet/lead/B = new()
		arrows += B
	update_icon()

/obj/item/quiver/bullet/grapeshot/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/bullet/grapeshot/B = new()
		arrows += B
	update_icon()

//RUNELOCK
/obj/item/ammo_casing/caseless/bullet/lead/silver
	name = "银弹"
	desc = "一颗小银球。比铅弹更软，却能有效对付亡灵。"
	projectile_type = /obj/projectile/bullet/firearm/lead/silver
	icon_state = "musketball_silver"

/obj/projectile/bullet/firearm/lead/silver
	name = "银弹"
	desc = "一颗小银球。比铅弹更软，却能有效对付亡灵。"
	damage = 120
	silver = TRUE
	critfactor = 0.8
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/silver
	damage_type = BRUTE
	armor_penetration = PEN_NONE

/obj/item/ammo_casing/caseless/bullet/lead/runelock
	name = "父类符文锁弹丸"
	desc = "你不该看到这个。快去通知开发者！！！"
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock
	caliber = "runed_sphere"
	max_integrity = 0

/obj/item/ammo_casing/caseless/bullet/lead/runelock/Initialize(mapload)
	. = ..()
	if(!get_filter("rune_filter"))
		add_filter("rune_filter", 2, list("type" = "outline", "color" = rgb(112, 28, 28, 1), "alpha" = 200, "size" = 2))

/obj/item/ammo_casing/caseless/bullet/lead/runelock/Destroy()
	if(linked_bag)
		linked_bag.unlink_casing(src)
	if(linked_belt)
		linked_belt.unlink_casing(src)
	linked_bag = null
	linked_belt = null
	return ..()

/obj/item/ammo_casing/caseless/bullet/lead/runelock/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	. = ..()
	if(linked_bag && length(linked_bag.linked_ammo_types) < linked_bag.max_storage)
		linked_bag.linked_ammo_types += type
	if(linked_belt && length(linked_belt.linked_ammo_types) < linked_belt.max_storage)
		linked_belt.linked_ammo_types += type

/obj/item/ammo_casing/caseless/bullet/lead/runelock/equipped(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!HAS_TRAIT(H, TRAIT_INQUISITION) && !(H.STAINT >= 15) && !(H.patron?.type == /datum/patron/old_god) && !(H.merctype == 10))
			to_chat(H, "<font color='yellow'>[name]烫得惊人！它灼伤了你的手！</font>")
			var/def_zone = "[(H.active_hand_index == 2) ? "r" : "l" ]_hand"
			H.apply_damage(rand(5,15), BURN, def_zone)
			forceMove(get_turf(H))
	else
		to_chat(user, "<font color='yellow'>[name]烫得惊人！它灼伤了你的手！</font>")
		user.apply_damage(rand(5,15), BURN)
		forceMove(get_turf(user))
	..()

/obj/projectile/bullet/firearm/lead/runelock
	name = "父类符文锁投射物"
	speed = 0.6
	max_range = 7
	range = 12
	var/passby_sound = 'sound/magic/blade_burst.ogg'
	var/last_passby_sound = 0
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock
	damage_type = BRUTE

/obj/projectile/bullet/firearm/lead/runelock/Move(atom/newloc, dir = NONE)
	. = ..()
	if(!. || !loc)
		return
	if(world.time < last_passby_sound + 2)
		return
	last_passby_sound = world.time
	playsound(src, passby_sound, 60, FALSE, 2)

/obj/item/ammo_casing/caseless/bullet/lead/runelock/runed
	name = "符文弹丸"
	desc = "一颗浑圆的小金属球，上面布满普赛顿符文。高速飞行时足以致命。"
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock/runed
	icon_state = "musketball_runed"

/obj/projectile/bullet/firearm/lead/runelock/runed
	name = "符文弹丸"
	desc = "一颗浑圆的小金属球，上面布满普赛顿符文。高速飞行时足以致命。"
	damage = 45
	icon_state = "musketball_runed"
	armor_penetration = PEN_BSTEEL
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/runed

/obj/projectile/bullet/firearm/lead/runelock/runed/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.apply_status_effect(/datum/status_effect/debuff/psypowder)

/obj/item/ammo_casing/caseless/bullet/lead/runelock/blessed
	name = "祝圣符文弹丸"
	desc = "一颗以纯银制成的浑圆小球。这种弹药由最精湛的奥塔万铁匠锻造，并由大团长亲自祝圣。对亡灵极其致命，对其他异端也同样有效。"
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock/blessed
	icon_state = "musketball_blessed"

/obj/projectile/bullet/firearm/lead/runelock/blessed
	name = "祝圣弹丸"
	desc = "一颗以纯银制成的浑圆小球。这种弹药由最精湛的奥塔万铁匠锻造，并由大团长亲自祝圣。对亡灵极其致命，对其他异端也同样有效。"
	damage = 120
	icon_state = "musketball_blessed"
	silver = TRUE
	blessed = TRUE
	armor_penetration = PEN_NONE
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/blessed

/atom/movable/screen/alert/status_effect/debuff/psypowder
	name = "符文毒蚀"
	desc = "这些粉末正在摧残我的眼睛和身体。我几乎看不见，也动弹不得……"
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "runed_poison"

/datum/status_effect/debuff/psypowder
	id = "runed_poison"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/psypowder
	effectedstats = list(STATKEY_STR = -3, STATKEY_SPD = -3, STATKEY_CON = -2, STATKEY_PER = -2)
	duration = 15 SECONDS

/datum/status_effect/debuff/psypowder/on_remove()
	. = ..()
	to_chat(owner, span_warning("我的视力恢复了……！"))

/datum/status_effect/debuff/psypowder/heavy
	duration = 30 SECONDS

/obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy
	name = "重型符文弹丸"
	desc = "你不该看到这个。"
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock/heavy
	caliber = "runed_sphere"
	icon_state = "musketball_runed"
	max_integrity = 0

/obj/projectile/bullet/firearm/lead/runelock/heavy // only shot by the rifle
	name = "重型符文弹丸"
	desc = "你不该看到这个。"
	damage = 100
	speed = 0.4 // a bit faster
	icon_state = "musketball_runed"
	max_range = 25 // be a sniper you alwys wished to be
	range = 25
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy
	damage_type = BRUTE
	armor_penetration = PEN_BSTEEL

/obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/blessed
	name = "重型祝圣符文弹丸"
	desc = "一颗以纯银制成的浑圆大球。这种弹药由最精湛的奥塔万铁匠锻造，并由大团长亲自祝圣。扩展的符文结构使它只能由步枪发射。"
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock/heavy/blessed
	icon_state = "musketball_blessed"

/obj/projectile/bullet/firearm/lead/runelock/heavy/blessed
	name = "重型祝圣符文弹丸"
	desc = "一颗以纯银制成的浑圆大球。这种弹药由最精湛的奥塔万铁匠锻造，并由大团长亲自祝圣。扩展的符文结构使它只能由步枪发射。"
	damage = 240
	icon_state = "musketball_blessed"
	silver = TRUE
	blessed = TRUE
	armor_penetration = PEN_NONE
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/blessed

/obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/runed
	name = "重型符文弹丸"
	desc = "一颗浑圆的大金属球，上面布满普赛顿符文。高速飞行时足以致命。"
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock/heavy/runed
	caliber = "runed_sphere"
	icon_state = "musketball_runed"

/obj/projectile/bullet/firearm/lead/runelock/heavy/runed
	name = "重型符文弹丸"
	desc = "一颗浑圆的大金属球，上面布满普赛顿符文。高速飞行时足以致命。"
	damage = 90
	icon_state = "musketball_runed"
	armor_penetration = PEN_BSTEEL
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/runed

/obj/projectile/bullet/firearm/lead/runelock/heavy/runed/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.apply_status_effect(/datum/status_effect/debuff/psypowder/heavy) // 2 times duration

/obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/entropy
	name = "熵蚀弹丸"
	desc = "凝视这颗弹丸上的繁复符文，你莫名感到自身仿佛被削弱了。"
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock/heavy/entropy
	caliber = "runed_sphere"
	icon_state = "musketball_blessed"

/obj/projectile/bullet/firearm/lead/runelock/heavy/entropy
	name = "熵蚀弹丸"
	desc = "仅仅看着它，你就感觉自身受到了削弱。"
	damage = 120
	icon_state = "musketball_blessed"
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/entropy
	armor_penetration = PEN_BSTEEL
	silver = TRUE
	blessed = TRUE

/obj/projectile/bullet/firearm/lead/runelock/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/L = target
		L.stamina_add(25)
		L.energy_add(-100) 
		if(L.devotion)
			L.devotion.update_devotion(-100) 
		if(L.get_bloodpool())
			L.adjust_bloodpool(-100) 
		to_chat(L, span_danger("你感到自己仿佛被某种力量削弱了！"))
		

/obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/tracker
	name = "追猎印记弹"
	desc = "一种昂贵的专用追踪弹丸。中弹者逃跑时会留下银粉痕迹，移动还会加剧出血。"
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock/heavy/tracker
	caliber = "runed_sphere"
	icon_state = "musketball_silver"

/obj/projectile/bullet/firearm/lead/runelock/heavy/tracker
	name = "追猎印记弹"
	desc = "你逃不脱猎人的印记。"
	damage = 80
	icon_state = "musketball_silver"
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/tracker
	armor_penetration = PEN_BSTEEL // we want this to go though no mater what
	silver = TRUE
	blessed = TRUE

/obj/projectile/bullet/firearm/lead/runelock/heavy/tracker/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/L = target
		L.apply_status_effect(/datum/status_effect/debuff/arbalest_hunt)

/obj/effect/decal/cleanable/blood/footprints/arbalest_trail
	name = "银粉"
	desc = "一串银粉痕迹，来自嵌在某个可怜异端体内的追猎印记弹。"
	blood_state = BLOOD_STATE_XENO
	alpha = 240

/obj/effect/decal/cleanable/blood/footprints/arbalest_trail/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(self_cleaning)), 5 MINUTES) // och look its self cleaning

/obj/effect/decal/cleanable/blood/footprints/arbalest_trail/proc/self_cleaning()
	qdel(src)
	

/atom/movable/screen/alert/status_effect/debuff/arbalest_hunt
	name = "猎人印记"
	desc = "有什么东西正在钻进我的身体！我越动就越严重！我得站稳不动，把它取出来（点击此提示）。"
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "embed"

/atom/movable/screen/alert/status_effect/debuff/arbalest_hunt/handle_click(location, control, params)
	if(!usr || !usr.client)
		return FALSE
	var/mob/user = usr
	var/paramslist = params2list(params)
	if(paramslist["shift"] && paramslist["left"]) // screen objects don't do the normal Click() stuff so we'll cheat
		examine_ui(user)
		return FALSE
	var/mob/living/carbon/human/L = usr
	if(!istype(L))
		return
	if(do_after(L, 10 SECONDS))	
		L.remove_status_effect(/datum/status_effect/debuff/arbalest_hunt)


/datum/status_effect/debuff/arbalest_hunt
	id = "arbalest_hunt"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/arbalest_hunt
	effectedstats = list(STATKEY_SPD = -1, STATKEY_WIL = -2)
	duration = 5 MINUTES

/datum/status_effect/debuff/arbalest_hunt/on_apply()
	. = ..()
	owner.add_filter("arbalest_hunt_glow", 2, list("type" = "outline", "color" = GLOW_COLOR_METAL, "alpha" = 150, "size" = 2))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move_init))
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(clear_hunt))

/datum/status_effect/debuff/arbalest_hunt/on_remove()
	. = ..()
	owner.remove_filter("arbalest_hunt_glow")
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, COMSIG_LIVING_DEATH)

/datum/status_effect/debuff/arbalest_hunt/proc/clear_hunt(mob/living/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/status_effect/debuff/arbalest_hunt/proc/handle_move()
	var/mob/living/carbon/human/H = owner
	var/turf/T = get_turf(H)
	if(istype(T))
		var/obj/effect/decal/cleanable/blood/footprints/arbalest_trail/trail = locate() in T
		if(!trail)
			trail = new(T)
		trail.entered_dirs |= H.dir
		trail.update_icon()

/datum/status_effect/debuff/arbalest_hunt/proc/handle_move_init(datum/source)
	SIGNAL_HANDLER
	if(source != owner)
		return FALSE
	INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/status_effect/debuff/arbalest_hunt, handle_move))

/obj/item/quiver/twilight_bullet/runicbag
	name = "召弹囊"
	desc = "用于存放符文弹丸的皮囊。囊扣上的符文会与囊中弹药绑定，激活后可将射出的符文弹丸召回囊内，再次使用。"
	icon_state = "runebag"
	item_state = "runebag"
	max_storage = 12
	var/has_types = TRUE
	var/ammo_type1 = /obj/item/ammo_casing/caseless/bullet/lead/runelock/runed 
	var/ammo_type2 = /obj/item/ammo_casing/caseless/bullet/lead/runelock/blessed 
	var/ammo_type_name1 = "符文"
	var/ammo_type_name2 = "祝圣"
	var/selected_type // what the pouch is currently attuned to
	var/list/linked_ammo_types = list() // types the casings report on firing
	var/list/linked_casings = list()    // every live casing linked to this bag, in or out of it
	var/recall_energy_cost = 25 // energy drained per sphere recalled

/obj/item/quiver/twilight_bullet/runicbag/Destroy()
	for(var/obj/item/ammo_casing/C as anything in linked_casings)
		C.linked_bag = null
	linked_casings.Cut()
	linked_ammo_types.Cut()
	QDEL_LIST(arrows)
	return ..()

/obj/item/quiver/twilight_bullet/runicbag/proc/link_casing(obj/item/ammo_casing/C)
	C.linked_bag = src
	linked_casings |= C

/obj/item/quiver/twilight_bullet/runicbag/proc/unlink_casing(obj/item/ammo_casing/C)
	linked_casings -= C
	arrows -= C
	if(C.linked_bag == src)
		C.linked_bag = null

/obj/item/quiver/twilight_bullet/runicbag/update_icon()
	icon_state = "runebag"

/obj/item/quiver/twilight_bullet/runicbag/attack_self(mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_notice("[src.name]已经装满，无法再容纳弹药！"))
		return
	if(user.energy < recall_energy_cost)
		to_chat(user, span_warning("囊扣上的符文闪烁后熄灭。我没有足够的能量召回弹丸。"))
		return
	var/type_name = (selected_type == ammo_type2) ? ammo_type_name2 : ammo_type_name1
	to_chat(user, span_notice("我呼唤[type_name]弹丸归来，囊扣上的符文随之亮起……"))
	if(!do_after(user, 15 SECONDS, src))
		to_chat(user, span_warning("我分了神，符文随之黯淡。"))
		return
	var/affordable = round(user.energy / recall_energy_cost)
	if(affordable < 1)
		to_chat(user, span_warning("弹丸尚未回应，我的能量便已耗尽。"))
		return
	var/summoned = 0
	for(var/obj/item/ammo_casing/C as anything in linked_casings - arrows)
		if(summoned >= affordable || arrows.len >= max_storage)
			break
		if(recursive_loc_check(C, /obj/item/gun))
			continue
		qdel(C)
		if(summon_round(selected_type))
			summoned++
	while(summoned < affordable && summon_round(selected_type))
		summoned++
	if(!summoned)
		return
	playsound(src, 'sound/magic/blink.ogg', 80)
	user.energy_add(-(recall_energy_cost * summoned))
	if(arrows.len < max_storage)
		to_chat(user, span_warning("我的能量耗尽了。只有[summoned]颗弹丸回应了召唤。"))
	else
		to_chat(user, span_notice("弹丸倏地回到了召弹囊中。"))
	linked_ammo_types.Cut()
	update_icon()

/obj/item/quiver/twilight_bullet/runicbag/MiddleClick(mob/user, params)
	if(!has_types)
		to_chat(user, span_warning("这个囊中的弹丸无法转换类型。"))
		return TRUE
	if(selected_type == ammo_type1)
		selected_type = ammo_type2
		to_chat(user, span_notice("囊中的弹丸微微发光，变成了<b>[ammo_type_name2]</b>弹丸。"))
	else
		selected_type = ammo_type1
		to_chat(user, span_notice("囊中的弹丸黯淡下来，变成了<b>[ammo_type_name1]</b>弹丸。"))
	convert_spheres(selected_type)
	playsound(src, 'sound/magic/charged.ogg', 40, FALSE)
	return TRUE

/obj/item/quiver/twilight_bullet/runicbag/proc/convert_spheres(new_type)
	var/converted = 0
	for(var/obj/item/ammo_casing/C as anything in arrows.Copy())
		if(C.type == new_type)
			continue
		unlink_casing(C) 
		qdel(C)
		converted++
	for(var/i in 1 to converted)
		summon_round(new_type)
	update_icon()

/obj/item/quiver/twilight_bullet/runicbag/attack_right(mob/user)
	if(!arrows.len)
		to_chat(user, span_warning("囊中空空如也。"))
		return TRUE
	var/obj/item/ammo_casing/O = arrows[arrows.len]
	arrows -= O 
	O.forceMove(user.loc)
	user.put_in_hands(O)
	update_icon()
	return TRUE

// Examine requested by Xander
/obj/item/quiver/twilight_bullet/runicbag/examine(mob/user)
	. = ..()
	var/type_name = ""
	if(has_types)
		type_name = (selected_type == ammo_type2) ? ammo_type_name2 : ammo_type_name1
	else
		type_name = ammo_type_name1
	. += span_info("里面装有[arrows.len]/[max_storage]颗[type_name]弹丸。")
	if(has_types)
		. += span_info("握在手中使用可召回当前绑定类型的弹丸。中键点击转换囊中弹丸类型。右键点击取出一颗弹丸。")
	else
		. += span_info("握在手中使用可召回弹丸。右键点击取出一颗弹丸。")
	

/obj/item/quiver/twilight_bullet/runicbag/attackby(obj/item/A, mob/user, params)
	if((has_types && istype(A, ammo_type2)) || istype(A, ammo_type1))
		if(eatarrow(A, user))
			to_chat(user, span_notice("你将\the [A]放入\the [src]。"))
		else
			to_chat(user, span_warning("\The [src]已经装满了！"))
		return TRUE
	return ..()

/obj/item/quiver/twilight_bullet/runicbag/eatarrow(obj/A, loc)
	if((!has_types || !istype(A, ammo_type2)) && !istype(A, ammo_type1))
		return FALSE
	if(arrows.len >= max_storage)
		return FALSE
	var/obj/item/ammo_casing/R = A
	if(ismob(loc))
		var/mob/M = loc
		M.doUnEquip(R, TRUE, src, TRUE, silent = TRUE)
	else
		R.forceMove(src)
	arrows += R
	link_casing(R)
	update_icon()
	return TRUE

/obj/item/quiver/twilight_bullet/runicbag/proc/summon_round(sphere_type)
	if(!ispath(sphere_type, ammo_type1) && (!has_types || !ispath(sphere_type, ammo_type2)))
		return FALSE
	if(arrows.len >= max_storage)
		return FALSE
	var/obj/item/ammo_casing/R = new sphere_type(src)
	arrows += R
	link_casing(R)
	update_icon()
	return TRUE

/obj/item/quiver/twilight_bullet/runicbag/Initialize(mapload)
	. = ..()
	selected_type = ammo_type1
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/R = new selected_type(src)
		arrows += R
		link_casing(R)
	update_icon()

//Smaller, 8-sphere pharetras for the Arbalist's Fusilier option.
/obj/item/quiver/twilight_bullet/runicbag/arbalist
	name = "燧枪手召弹囊"
	desc = "用于存放符文弹丸的皮囊。囊扣上的符文会与囊中弹药绑定，激活后可将射出的符文弹丸召回囊内，再次使用。这一款用于容纳燧枪手使用的重型步枪弹丸。"
	max_storage = 8
	ammo_type1 = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/runed 
	ammo_type2 = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/blessed 
	ammo_type_name1 = "重型符文"
	ammo_type_name2 = "重型祝圣"

/obj/item/quiver/twilight_bullet/runicbag/arbalist/mark
	name = "追猎印记弹囊"
	desc = "刻有符文的小囊，可存放并召回一颗追猎印记弹。"
	max_storage = 1
	has_types = FALSE
	ammo_type1 = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/tracker
	ammo_type_name1 = "追猎印记"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_RING
	recall_energy_cost = 100 // special ammo
