/datum/anvil_recipe/cannon
	i_type = "Engineering"
	abstract_type = /datum/anvil_recipe/cannon
	appro_skill = /datum/skill/craft/engineering
	req_trait = TRAIT_ENGINEER
	craftdiff = 4
	hides_from_books = TRUE

/datum/anvil_recipe/cannon/cannon
	name = "火炮"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small,)
	req_bar = /obj/item/ingot/steel
	created_item = /obj/structure/cannon

/datum/anvil_recipe/cannon/cannonball
	name = "炮弹"
	additional_items = list(/obj/item/ingot/steel)
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/cannon_shell/cannonball

/datum/anvil_recipe/cannon/grapeshot
	name = "葡萄弹"
	additional_items = list(/obj/item/ingot/steel)
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/cannon_shell/grapeshot

/datum/crafting_recipe/roguetown/survival/fiberfuse
	name = "纤维引信"

	result = /obj/item/cannon_fuse/fiber
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/reagent_containers/food/snacks/fat = 1,
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/parchmentfuse
	name = "羊皮纸引信"
	result = /obj/item/cannon_fuse/parchment
	reqs = list(
		/obj/item/paper = 2,
		/obj/item/reagent_containers/food/snacks/fat = 1,
		)
	craftdiff = 1

/obj/item/cannon_fuse
	name = "引信"
	desc = "火炮使用的引信。"
	icon = 'modular_twilight_axis/icons/cannon/cannon_fuse.dmi'
	icon_state = "fiber_fuse"
	w_class = WEIGHT_CLASS_SMALL
	var/burn_time = 3 SECONDS
	var/lit = FALSE
	var/icon_state_lit = "fiber_fuse_lit"

/obj/item/cannon_fuse/fiber
	name = "纤维引信"
	desc = "涂有油脂的普通编织引信。燃烧较慢，能让炮手有时间退到安全距离。"
	icon_state = "fiber_fuse"
	icon_state_lit = "fiber_fuse_lit"
	burn_time = 3 SECONDS

/obj/item/cannon_fuse/parchment
	name = "羊皮纸引信"
	desc = "浸过油脂的纸引信，几乎瞬间就会烧完，能迅速引燃火炮。"
	icon_state = "parchment_fuse"
	icon_state_lit = "parchment_fuse_lit"
	burn_time = 1 SECONDS


/obj/item/cannon_shell
	name = "炮弹"
	desc = "一枚炮弹。"
	icon = 'modular_twilight_axis/icons/cannon/cannon.dmi'
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/cannon_shell/cannonball
	name = "炮弹"
	desc = "一枚沉重的钢制炮弹。"
	icon_state = "cannonball"

/obj/item/cannon_shell/grapeshot
	name = "葡萄弹"
	desc = "一枚装有数十颗小弹丸的炮弹。"
	icon_state = "grapeshot"

/obj/projectile/bullet/cannon_debris
	name = "飞散碎屑"
	desc = "飞散的土石碎块。"
	icon = 'icons/effects/debris.dmi'
	icon_state = "shards"
	color = "#5c544d"
	damage = 0
	nodamage = TRUE
	flag = "blunt"
	speed = 1.0
	pass_flags = PASSTABLE | PASSMOB

/obj/projectile/bullet/cannon_debris/on_hit(atom/target, blocked = 0)
	var/turf/turf = get_turf(target)
	if(turf && !istype(target, /mob/living))
		new /obj/effect/particle_effect/smoke/arquebus(turf)
	qdel(src)
	return BULLET_ACT_HIT

/obj/projectile/bullet/cannonball_straight
	name = "炮弹"
	desc = "铅制弹芯"
	icon = 'modular_twilight_axis/icons/cannon/cannonball.dmi'
	icon_state = "ball"
	damage = 200
	damage_type = BRUTE

	flag = "bullet"
	speed = 3.5
	var/pierces_left = 3

/obj/projectile/bullet/cannonball_straight/on_hit(atom/target, blocked = 0)
	. = ..()
	var/turf/turf = get_turf(target)
	if(!turf)
		qdel(src)
		return

	if(isliving(target))
		var/mob/living/player = target


		if(ishuman(player))
			var/mob/living/carbon/human/H = player
			var/list/valid_limbs = list()
			for(var/obj/item/bodypart/BP in H.bodyparts)
				if(BP.body_zone != BODY_ZONE_CHEST && BP.body_zone != BODY_ZONE_HEAD)
					valid_limbs += BP

			var/limbs_to_lose = rand(1, 3)
			for(var/pellets in 1 to limbs_to_lose)
				if(!length(valid_limbs))
					break
				var/obj/item/bodypart/lost_limb = pick(valid_limbs)
				valid_limbs -= lost_limb
				lost_limb.dismember(BRUTE, BCLASS_CHOP, null, lost_limb.body_zone, 110, TRUE, TRUE)

			for(var/obj/item/bodypart/remaining_limb in H.bodyparts)
				H.apply_damage(140, BRUTE, remaining_limb.body_zone)
		else
			player.adjustBruteLoss(400)

		var/throw_dir = turn(dir, pick(-90, 90))
		var/turf/throw_turf = get_ranged_target_turf(player, throw_dir, rand(2, 4))
		if(throw_turf)
			player.throw_at(throw_turf, 4, 2, null, FALSE, FALSE, null, MOVE_FORCE_STRONG)
		if(ishuman(player))
			pierces_left = 1
			player.death()
			explosion(turf, devastation_range = 0, heavy_impact_range = 3, light_impact_range = 6, flame_range = 0, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

	else if(istype(target, /turf/closed) || istype(target, /obj/structure) || istype(target, /obj/machinery))
		target.ex_act(EXPLODE_DEVASTATE)
		new /obj/effect/particle_effect/smoke/arquebus(turf)

	pierces_left--

	if(pierces_left > 0)
		temporary_unstoppable_movement = TRUE
		movement_type |= UNSTOPPABLE
		return BULLET_ACT_FORCE_PIERCE

	else
		turf.visible_message(span_danger("炮弹轰然炸开！"))

		for(var/mob/living/mob in range(4, turf))
			if(!mob.mind || istype(mob, /mob/living/simple_animal))
				if(get_dist(turf, mob) <= 3)
					mob.adjustBruteLoss(400)
				else
					mob.adjustBruteLoss(300)
			if(mob != target)
				var/blast_dir = get_dir(turf, mob)
				if(blast_dir == 0)
					blast_dir = pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

				var/turf/blast_turf = get_ranged_target_turf(mob, blast_dir, rand(2, 4))
				if(blast_turf)
					mob.throw_at(blast_turf, 4, 2, null, FALSE, FALSE, null, MOVE_FORCE_STRONG)

				mob.Knockdown(60)
				mob.Paralyze(40)
				mob.adjustBruteLoss(rand(40, 80))

		var/shrapnel_count = rand(6, 12)
		var/list/all_dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
		for(var/pellets in 1 to shrapnel_count)
			var/obj/projectile/bullet/grapeshot_pellet/grapeshotpellets = new(turf)
			var/shoot_dir = pick(all_dirs)
			var/turf/shrapnel_target = get_ranged_target_turf(turf, shoot_dir, rand(4, 7))

			if(shrapnel_target)
				shrapnel_target = locate(shrapnel_target.x + rand(-2, 2), shrapnel_target.y + rand(-2, 2), shrapnel_target.z)

			grapeshotpellets.preparePixelProjectile(shrapnel_target, src, null, rand(-30, 30))
			grapeshotpellets.p_x = 16
			grapeshotpellets.p_y = 16
			grapeshotpellets.fire()

		for(var/pellets in 1 to 16)
			var/obj/projectile/bullet/cannon_debris/debris = new(turf)
			var/shoot_dir = pick(all_dirs)
			var/turf/debris_target = get_ranged_target_turf(turf, shoot_dir, rand(5, 9))

			if(debris_target)
				debris_target = locate(debris_target.x + rand(-3, 3), debris_target.y + rand(-3, 3), debris_target.z)

			debris.preparePixelProjectile(debris_target, src, null, rand(-45, 45))
			debris.p_x = 16
			debris.p_y = 16
			debris.fire()

		explosion(turf, devastation_range = 0, heavy_impact_range = 3, light_impact_range = 6, flame_range = 0, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

		qdel(src)
		return BULLET_ACT_HIT

/obj/projectile/bullet/grapeshot_pellet
	name = "弹片"
	icon = 'modular_twilight_axis/icons/cannon/ammo.dmi'
	icon_state = "musketball"
	damage = 110
	damage_type = BRUTE
	flag = "piercing"
	armor_penetration = PEN_BSTEEL
	speed = 2.5
	woundclass = BCLASS_PIERCE
	embedchance = 100

/obj/projectile/bullet/grapeshot_pellet/prehit(atom/target)
	if(isliving(target))
		temporary_unstoppable_movement = TRUE
		if(prob(50))
			return FALSE
	return ..()

/obj/structure/cannon
	name = "火炮"
	desc = "架在轮式炮架上的重型火炮，可发射高爆炮弹。"
	icon = 'modular_twilight_axis/icons/cannon/cannon.dmi'
	icon_state = "cannon"
	density = TRUE
	anchored = FALSE
	max_integrity = 2000

	pixel_x = -16
	pixel_y = -16

	var/powder_loaded = FALSE
	var/obj/item/cannon_shell/bullet_loaded = null
	var/rammed = FALSE
	var/obj/item/cannon_fuse/inserted_fuse = null
	var/fuse_burning = FALSE

	var/barrel_integrity = 15
	var/last_fired = 0
	var/cooldown = 10 SECONDS

/obj/structure/cannon/Initialize(mapload)
	. = ..()
	dir = NORTH
	update_icon() 

/obj/structure/cannon/Destroy()
	if(bullet_loaded)
		qdel(bullet_loaded)
		bullet_loaded = null
	if(inserted_fuse)
		qdel(inserted_fuse)
		inserted_fuse = null
	return ..()

/obj/structure/cannon/update_icon()
	. = ..()
	cut_overlays()

	if(!inserted_fuse)
		icon_state = "cannon"
	else if(fuse_burning)
		icon_state = "cannon_lit"
	else
		icon_state = "cannon_fib"

/obj/structure/cannon/examine(mob/user)
	. = ..()
	if((world.time - last_fired) < cooldown)
		. += span_warning("火炮刚刚开过火，炮管仍然滚烫！")
	else
		. += span_info("炮管已经冷却，可以重新装填。")

	if(fuse_burning)
		. += span_bold("引信正冒着火花燃烧！火炮马上就要发射了！")
		return

	if(!powder_loaded)
		. += span_info("炮管是空的，需要装入火药。")
	else if(!bullet_loaded)
		. += span_info("火药已经装好，但还没有装入炮弹。")
	else if(!rammed)
		. += span_warning("火药和炮弹已经装入炮管，但还没有用装药杆捣实！")
	else if(!inserted_fuse)
		. += span_notice("火炮已装填妥当，请将引信插入火门。")
	else
		. += span_bold("引信已就位，点燃即可发射炮弹！")

/obj/structure/cannon/fire_act()
	if(inserted_fuse && !fuse_burning)
		light_fuse()

/obj/structure/cannon/spark_act()
	if(inserted_fuse && !fuse_burning)
		light_fuse()

/obj/structure/cannon/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(fuse_burning)
		to_chat(user, span_warning("引信已经点燃！别碰火炮！"))
		return

	dir = turn(dir, -90)
	user.visible_message(span_notice("[user]转动了[src.name]。"), span_notice("你将炮口转向[get_direction_display(dir)]。"))
	playsound(src, 'modular_twilight_axis//sound/cannon/anglecorrection.ogg', 100, TRUE)

/obj/structure/cannon/attackby(obj/item/used_item, mob/user, params)
	if(istype(used_item, /obj/item/powderflask))
		var/obj/item/powderflask/powder = used_item
		if(powder_loaded)
			to_chat(user, span_warning("火炮已经装好火药了！"))
			return
		user.visible_message(span_notice("[user]开始往[src.name]里倒入火药……"))
		playsound(src, 'modular_twilight_axis//sound/cannon/powder.ogg', 100, TRUE)
		if(do_after(user, 3 SECONDS, src))
			if(QDELETED(powder) || QDELETED(src))
				return
			powder_loaded = TRUE
			to_chat(user, span_notice("你往炮管里倒入了火药。"))
		return

	if(istype(used_item, /obj/item/cannon_shell))
		if(!powder_loaded)
			to_chat(user, span_warning("你得先倒入火药！"))
			return
		if(bullet_loaded)
			to_chat(user, span_warning("炮管里已经有一枚炮弹了！"))
			return

		if(user.transferItemToLoc(used_item, src))
			bullet_loaded = used_item
			user.visible_message(span_notice("[user]往[src.name]里装入了一枚炮弹。"))
			playsound(src, 'modular_twilight_axis//sound/cannon/loading.ogg', 100, TRUE)
		return

	if(istype(used_item, /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge))
		if(!powder_loaded || !bullet_loaded)
			to_chat(user, span_warning("现在没有需要捣实的东西！先装入火药和炮弹。"))
			return
		if(rammed)
			to_chat(user, span_warning("炮内装药已经捣实了！"))
			return
		user.visible_message(span_notice("[user]开始用装药杆捣实[src.name]内的装药……"))
		playsound(src, 'modular_twilight_axis//sound/cannon/ramrod.ogg', 100, TRUE)
		if(do_after(user, 6 SECONDS, src))
			rammed = TRUE
			user.visible_message(span_notice("[user]用装药杆捣实了装药。火炮现在已做好发射准备。"))
		return

	if(istype(used_item, /obj/item/cannon_fuse) || istype(used_item, /obj/item/natural/fibers) || istype(used_item, /obj/item/natural/bundle/fibers))
		if(inserted_fuse)
			to_chat(user, span_warning("火炮的火门里已经有引信了！"))
			return
		if(!rammed)
			to_chat(user, span_warning("插入引信前，先用装药杆捣实火药和炮弹！"))
			return

		if(istype(used_item, /obj/item/natural/fibers) || istype(used_item, /obj/item/natural/bundle/fibers))
			inserted_fuse = new /obj/item/cannon_fuse/fiber(src)
			if(istype(used_item, /obj/item/natural/bundle/fibers))
				var/obj/item/natural/bundle/fibers/fiberbundle = used_item
				fiberbundle.amount--
				if(fiberbundle.amount <= 0)
					qdel(fiberbundle)
			else
				qdel(used_item)
		else
			if(user.transferItemToLoc(used_item, src))
				inserted_fuse = used_item

		user.visible_message(span_notice("[user]将引信插入了[src.name]。"))
		playsound(src, 'sound/foley/bandage.ogg', 100, FALSE)
		update_icon()
		return

	var/ignition_msg = used_item.ignition_effect(src, user)
	if(ignition_msg)
		if(inserted_fuse && !fuse_burning)
			visible_message(ignition_msg)
			light_fuse(user)
		return TRUE

	return ..()

/obj/structure/cannon/proc/light_fuse(mob/user)
	if(!inserted_fuse || fuse_burning)
		return

	fuse_burning = TRUE
	inserted_fuse.lit = TRUE
	inserted_fuse.icon_state = inserted_fuse.icon_state_lit
	update_icon()

	if(user)
		user.visible_message(span_danger("[user]点燃了[src.name]上的引信！火炮马上就要发射了！"))
	else
		visible_message(span_danger("[src.name]上的引信开始迸出危险的火花！火炮马上就要发射了！"))

	playsound(src, 'modular_twilight_axis/sound/cannon/fuse.ogg', 100, FALSE)

	addtimer(CALLBACK(src, PROC_REF(detonate_fuse), user), inserted_fuse.burn_time)

/obj/structure/cannon/proc/detonate_fuse(mob/user)
	fuse_burning = FALSE
	if(!inserted_fuse)
		return
	qdel(inserted_fuse)
	inserted_fuse = null
	update_icon()

	fire_cannon(user)

/obj/structure/cannon/proc/fire_cannon(mob/user)
	if(!powder_loaded || !bullet_loaded || !rammed)
		return

	var/turf/start_turf = get_step(src, dir)
	if(!start_turf)
		return

	for(var/mob/mob in range(7, src))
		if(mob.client)
			shake_camera(mob, 4, 2)

	playsound(src, 'modular_twilight_axis/sound/cannon/launch.ogg', 100, 0, 20, 1, null, null, FALSE, TRUE)

	for(var/turf/smoke in get_adjacent_turfs(src.loc))
		new /obj/effect/particle_effect/smoke/arquebus(smoke)
		if(prob(40))
			for(var/turf/smokeextra in get_adjacent_turfs(smoke))
				new /obj/effect/particle_effect/smoke/arquebus(smokeextra)

	var/turf/target_turf = get_ranged_target_turf(src, dir, 16)

	if(istype(bullet_loaded, /obj/item/cannon_shell/grapeshot))
		var/pellet_count = 30
		var/shoot_dir = dir
		for(var/pellets in 1 to pellet_count)
			var/obj/projectile/bullet/grapeshot_pellet/grapeshotpellets = new(start_turf)
			grapeshotpellets.def_zone = pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
			var/turf/pellet_target = get_ranged_target_turf(start_turf, shoot_dir, 8)

			if(pellet_target)
				grapeshotpellets.preparePixelProjectile(pellet_target, src, null, rand(-20, 20))

			grapeshotpellets.p_x = 16
			grapeshotpellets.p_y = 16
			grapeshotpellets.fire()
	else
		var/obj/projectile/bullet/cannonball_straight/powder = new(start_turf)
		if(target_turf)
			powder.preparePixelProjectile(target_turf, src)

		powder.p_x = 16
		powder.p_y = 16
		powder.fire()
	
	qdel(bullet_loaded)
	bullet_loaded = null
	powder_loaded = FALSE
	rammed = FALSE

	if((world.time - last_fired) < cooldown)
		barrel_integrity -= 2
	else
		barrel_integrity--
	last_fired = world.time

	if(barrel_integrity <= 0)
		src.visible_message(span_danger("[src]因炮管严重磨损而炸裂了！"))
		explosion(get_turf(src), 1, 2, 4, 0, TRUE, FALSE, 2)
		qdel(src)
