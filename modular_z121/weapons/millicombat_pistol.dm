// 单独放开副手和手臂数量限制，仍沿用火器技能对应的瞄准时间。
/datum/intent/shoot/firearm/z121_millicombat_pistol
	allow_offhand = TRUE

/datum/intent/shoot/firearm/z121_millicombat_pistol/can_charge()
	return TRUE

/datum/intent/arc/firearm/z121_millicombat_pistol
	allow_offhand = TRUE

/datum/intent/arc/firearm/z121_millicombat_pistol/can_charge()
	return TRUE

// 直接继承弹道枪械，不继承普通火器的通条、随机烧伤和震退逻辑。
/obj/item/gun/ballistic/z121_millicombat_pistol
	name = "米莉康巴特手枪"
	desc = "一把更小巧，更轻便，枪管更短装药更少的铳枪，威力远小于标准铳枪。部分专业人士能在战斗中玩成快速装填射击"
	icon = 'modular_z121/icon/weapon32.dmi'
	icon_state = "shortgun1"
	item_state = "shortgun1"
	force = 10
	possible_item_intents = list(/datum/intent/shoot/firearm/z121_millicombat_pistol, /datum/intent/arc/firearm/z121_millicombat_pistol, /datum/intent/mace/strike/wood)
	gripped_intents = null
	twohands_required = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	grid_height = 32
	grid_width = 64
	// 原图虽为三十二像素，上身图生成器仍输出六十四像素画布，手持与腰挂都需按该尺寸居中。
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	experimental_onhip = TRUE
	bigboy = FALSE
	gripsprite = FALSE
	can_parry = TRUE
	minstr = 10
	internal_magazine = TRUE
	mag_type = /obj/item/ammo_box/magazine/internal/firearm
	bolt_type = BOLT_TYPE_NO_BOLT
	casing_ejector = FALSE
	cartridge_wording = "铅弹"
	load_sound = 'modular_helmsguard/sound/arquebus/musketload.ogg'
	dry_fire_sound = 'modular_helmsguard/sound/arquebus/musketcock.ogg'
	fire_sound = 'modular_helmsguard/sound/arquebus/arquefire.ogg'
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel
	// 不进入按初始价值筛选的贤者之石造物列表。
	sellprice = 0
	var/gunpowder = FALSE
	var/operating = FALSE
	var/firing = FALSE
	var/firing_stage = 0
	var/load_time = 3 SECONDS
	var/projectile_damage = 40
	var/projectile_penetration = 60
	var/projectile_range = 8

/obj/item/gun/ballistic/z121_millicombat_pistol/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_PROJECTILE_BEFORE_FIRE, PROC_REF(apply_projectile_modifiers))

/obj/item/gun/ballistic/z121_millicombat_pistol/Destroy()
	UnregisterSignal(src, COMSIG_PROJECTILE_BEFORE_FIRE)
	return ..()

/obj/item/gun/ballistic/z121_millicombat_pistol/proc/apply_projectile_modifiers(datum/source, obj/projectile/projectile)
	SIGNAL_HANDLER
	if(!istype(projectile, /obj/projectile/bullet/firearm/lead))
		return
	var/obj/projectile/bullet/firearm/lead/base_projectile = /obj/projectile/bullet/firearm/lead
	// 只缩放本枪实际发射的弹丸，保留此前施加的战斗倍率及曲射落点。
	projectile.damage *= projectile_damage / initial(base_projectile.damage)
	projectile.armor_penetration *= projectile_penetration / initial(base_projectile.armor_penetration)
	projectile.range = projectile.arcshot ? min(projectile.range, projectile_range) : projectile_range
	if(istype(projectile, /obj/projectile/bullet/firearm/lead/z121_highwayman))
		var/obj/projectile/bullet/firearm/lead/z121_highwayman/finisher = projectile
		finisher.configure_shot()

// 膛内弹不再留在弹仓列表中，确保计数正确且总共只能装一颗铅弹。
/obj/item/gun/ballistic/z121_millicombat_pistol/chamber_round(keep_bullet = FALSE)
	if(chambered || !magazine)
		return
	chambered = magazine.get_round(FALSE)
	if(chambered)
		chambered.forceMove(src)

/obj/item/gun/ballistic/z121_millicombat_pistol/process_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	if(empty_chamber)
		QDEL_NULL(chambered)

// 本枪不使用切换握法、拉栓或退弹操作。
/obj/item/gun/ballistic/z121_millicombat_pistol/attack_self(mob/living/user)
	return

/obj/item/gun/ballistic/z121_millicombat_pistol/proc/can_service(mob/user)
	return user && user.canUseTopic(src, BE_CLOSE) && (user.is_holding(src) || isturf(loc))

/obj/item/gun/ballistic/z121_millicombat_pistol/attackby(obj/item/I, mob/user, params)
	if(!can_service(user) || !user.is_holding(I))
		return
	if(operating || firing || firing_stage)
		to_chat(user, span_warning("枪械正在操作中。"))
		return
	if(istype(I, /obj/item/powderflask))
		if(gunpowder)
			to_chat(user, span_warning("枪内已经装有烟火药。"))
			return
		load_powder(user, I)
		return
	if(istype(I, /obj/item/ammo_casing/caseless/bullet/lead))
		var/obj/item/ammo_casing/caseless/bullet/lead/bullet = I
		if(!bullet.BB)
			to_chat(user, span_warning("这颗铅弹已经无法使用了。"))
			return
		if(get_ammo() >= 1 || !magazine)
			to_chat(user, span_warning("枪内已经装有一颗铅弹。"))
			return
		if(!gunpowder)
			to_chat(user, span_warning("我得先装入烟火药。"))
			return
		if(!user.transferItemToLoc(bullet, src))
			return
		if(!magazine.give_round(bullet))
			user.put_in_hands(bullet)
			return
		chamber_round()
		playsound(src, load_sound, 100, TRUE)
		to_chat(user, span_notice("我装入了一颗铅弹。"))
		update_icon()
		return
	if(istype(I, /obj/item/ammo_casing) || istype(I, /obj/item/ammo_box))
		to_chat(user, span_warning("这把手枪只能逐颗装入铅弹。"))
		return
	if(istype(I, /obj/item/ramrod))
		to_chat(user, span_notice("这把手枪不需要通条压实。"))
		return
	return ..()

/obj/item/gun/ballistic/z121_millicombat_pistol/proc/load_powder(mob/user, obj/item/powderflask/flask)
	if(operating || firing || firing_stage || gunpowder || !can_service(user) || !user.is_holding(flask))
		return
	var/start_location = loc
	var/service_time = max(0.1 SECONDS, load_time - user.get_skill_level(/datum/skill/combat/firearms) * 0.2 SECONDS)
	operating = TRUE
	to_chat(user, span_notice("我开始向[src]装填烟火药。"))
	playsound(src, 'modular_helmsguard/sound/arquebus/pour_powder.ogg', 100, TRUE)
	var/completed = do_after(user, service_time, target = src)
	if(QDELETED(src))
		return
	operating = FALSE
	// 中断、交接枪械或丢弃工具后不获得装药；成功时才提交状态。
	if(!completed || QDELETED(flask) || loc != start_location || !can_service(user) || !user.is_holding(flask) || gunpowder)
		return
	gunpowder = TRUE
	to_chat(user, span_notice("我向[src]装填好了烟火药。"))
	update_icon()

/obj/item/gun/ballistic/z121_millicombat_pistol/can_shoot()
	if(z121_highwayman_weapon?.finisher && !operating && !firing && !firing_stage)
		z121_highwayman_load()
	return chambered?.BB && gunpowder && !operating && !firing && !firing_stage

/obj/item/gun/ballistic/z121_millicombat_pistol/shoot_with_empty_chamber(mob/living/user)
	if(operating || firing || firing_stage)
		to_chat(user, span_warning("枪械正在操作中。"))
		return
	return ..()

/obj/item/gun/ballistic/z121_millicombat_pistol/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(!can_shoot())
		shoot_with_empty_chamber(user)
		return FALSE
	if(!user || !user.is_holding(src) || !can_trigger_gun(user) || !get_turf(target) || !get_turf(user))
		return FALSE
	if(user.used_intent?.arc_check() && get_dist_euclidian(target, user) > projectile_range)
		to_chat(user, span_warning("目标超出了这把手枪的曲射射程。"))
		return FALSE
	if(z121_highwayman_weapon?.finisher && !z121_highwayman_prepare_shot(target, user))
		return FALSE
	spread = user.client ? max(0, 150 - 150 * (user.client.chargedprog / 100)) : 0
	var/fully_aimed = user.client && user.client.chargedprog >= 100
	firing = TRUE
	. = ..()
	if(QDELETED(src))
		return
	firing = FALSE
	// 发射被原生流程拒绝时解除在途锁，武技仍可再次尝试。
	if(!. && z121_highwayman_weapon?.finisher)
		z121_highwayman_weapon.flying_bullet = null
	if(. && fully_aimed)
		adjust_experience(user, /datum/skill/combat/firearms, user.STAINT * 4)

/obj/item/gun/ballistic/z121_millicombat_pistol/shoot_live_shot(mob/living/user, pointblank = 0, mob/pbtarget = null, message = 1)
	// 父类仅在成功发射后调用这里，拒绝射击不会消耗装药或播放动画。
	gunpowder = FALSE
	firing_stage = 1
	. = ..()
	new /obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 1))
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(advance_firing_animation)), 0.2 SECONDS)

/obj/item/gun/ballistic/z121_millicombat_pistol/proc/advance_firing_animation()
	if(QDELETED(src) || !firing_stage)
		return
	firing_stage = firing_stage == 1 ? 2 : 0
	update_icon()
	if(firing_stage)
		addtimer(CALLBACK(src, PROC_REF(advance_firing_animation)), 0.2 SECONDS)

/obj/item/gun/ballistic/z121_millicombat_pistol/update_icon()
	if(QDELETED(src))
		return
	. = ..()
	// 替换通用弹匣叠图，防止引用本贴图文件中不存在的状态。
	cut_overlays()
	if(firing_stage)
		icon_state = firing_stage == 1 ? "shortgun3" : "shortgun4"
	else
		icon_state = chambered?.BB ? "shortgun2" : "shortgun1"
	item_state = icon_state
	// 使用当前位置刷新，动画中掉落或转交后也不会保留旧持有人的引用。
	if(isliving(loc))
		var/mob/living/holder = loc
		holder.update_inv_hands()
		if(ishuman(holder))
			var/mob/living/carbon/human/human_holder = holder
			human_holder.update_inv_belt()

/obj/item/gun/ballistic/z121_millicombat_pistol/generateonmob(tag, prop, behind = FALSE, mirrored = FALSE, used_index = null)
	if(tag == "onbelt")
		used_index = "shortgunbelt"
	return ..(tag, prop, behind, mirrored, used_index)

/obj/item/gun/ballistic/z121_millicombat_pistol/getonmobprop(tag)
	if(tag == "gen")
		return list("shrink" = 0.4, "sx" = -10, "sy" = -8, "nx" = 13, "ny" = -8, "wx" = -8, "wy" = -7, "ex" = 7, "ey" = -8, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = 30, "sturn" = -30, "wturn" = -30, "eturn" = 30, "nflip" = 0, "sflip" = 8, "wflip" = 8, "eflip" = 0)
	return ..()
