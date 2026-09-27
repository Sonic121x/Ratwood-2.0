// 独立于单发火器继承链，避免原火器射击时清空弹仓和装药状态。
/obj/item/gun/ballistic/z121_repeating_flintlock
	name = "连发燧枪"
	desc = "以齿轮机构连续供弹的燧枪，可分别储存十二颗铅弹和十二份烟火药。"
	icon = 'modular_helmsguard/icons/weapons/fusil.dmi'
	icon_state = "fusil"
	item_state = "fusil"
	force = 10
	force_wielded = 15
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/shoot/firearm, /datum/intent/arc/firearm, INTENT_GENERIC)
	internal_magazine = TRUE
	mag_type = /obj/item/ammo_box/magazine/internal/z121_repeating_flintlock
	bolt_type = BOLT_TYPE_NO_BOLT
	casing_ejector = FALSE
	pixel_x = -16
	pixel_y = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_LONG
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	can_parry = TRUE
	minstr = 10
	walking_stick = TRUE
	experimental_onback = TRUE
	cartridge_wording = "铅弹"
	load_sound = 'modular_helmsguard/sound/arquebus/musketload.ogg'
	dry_fire_sound = 'modular_helmsguard/sound/arquebus/musketcock.ogg'
	fire_sound = 'modular_helmsguard/sound/arquebus/arquefire.ogg'
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel
	// 管理员直接生成时采用铁机匣、青铜齿轮、铁长枪管的属性。
	var/receiver_material = "铁"
	var/barrel_material = "铁"
	var/gear_material = "青铜"
	var/range_bonus = 0.10
	var/penetration_bonus = 0
	var/accuracy_bonus = 0.07
	var/jam_chance = 8
	var/jammed = FALSE
	var/powder_charges = 0
	var/powder_capacity = 12
	var/ammo_capacity = 12
	var/next_shot_time = 0
	var/shot_interval = 2.5 SECONDS
	var/operating = FALSE
	var/firing = FALSE
	var/obj/item/ramrod/myrod

/obj/item/ammo_box/magazine/internal/z121_repeating_flintlock
	name = "连发燧枪内置弹仓"
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead
	caliber = "lead_sphere"
	max_ammo = 12
	start_empty = TRUE

/obj/item/gun/ballistic/z121_repeating_flintlock/Initialize(mapload)
	. = ..()
	myrod = new(src)
	RegisterSignal(src, COMSIG_PROJECTILE_BEFORE_FIRE, PROC_REF(apply_projectile_modifiers))

/obj/item/gun/ballistic/z121_repeating_flintlock/Destroy()
	UnregisterSignal(src, COMSIG_PROJECTILE_BEFORE_FIRE)
	QDEL_NULL(myrod)
	return ..()

/obj/item/gun/ballistic/z121_repeating_flintlock/handle_atom_del(atom/A)
	if(A == myrod)
		myrod = null
	return ..()

/obj/item/gun/ballistic/z121_repeating_flintlock/proc/effective_range()
	var/obj/projectile/bullet/firearm/lead/base_projectile = /obj/projectile/bullet/firearm/lead
	// 单参数取整向下截断，先加半格实现四舍五入。
	return max(1, round(initial(base_projectile.range) * (1 + range_bonus) + 0.5))

/obj/item/gun/ballistic/z121_repeating_flintlock/proc/apply_projectile_modifiers(datum/source, obj/projectile/projectile)
	SIGNAL_HANDLER
	if(!istype(projectile, /obj/projectile/bullet/firearm/lead))
		return
	// 此信号在弹丸真正发射时触发；保留曲射落点与骑乘精度惩罚。
	projectile.range = projectile.arcshot ? min(projectile.range, effective_range()) : effective_range()
	projectile.armor_penetration *= 1 + penetration_bonus
	projectile.accuracy *= 1 + accuracy_bonus

/obj/item/gun/ballistic/z121_repeating_flintlock/examine(mob/user)
	. = ..()
	. += span_notice("机匣：[receiver_material]；长枪管：[barrel_material]；齿轮：[gear_material]×3。")
	. += span_notice("铅弹：[get_ammo()]/[ammo_capacity]（含膛内弹）；火药：[powder_charges]/[powder_capacity]。")
	. += span_notice("射程：[effective_range()] 格（+[range_bonus * 100]%）；穿透：+[penetration_bonus * 100]%；精确度：+[accuracy_bonus * 100]%；卡壳率：[jam_chance]%。")
	if(jammed)
		. += span_warning("机构已卡壳，需要使用通条排障。")
	if(operating)
		. += span_notice("正在装药或排障，暂时无法射击。")
	// 提示宏会拼接文本，先求出条件文本，避免把通条对象参与字符串相加。
	var/rod_notice = myrod ? "枪管下收着一根通条，可用空着的主手右键取出。" : "枪管下没有收纳通条。"
	. += span_notice(rod_notice)

/obj/item/gun/ballistic/z121_repeating_flintlock/attack_self(mob/living/user)
	if(twohands_required)
		return
	if(altgripped || wielded)
		ungrip(user)
		return
	if(alt_intents)
		altgrip(user)
	if(gripped_intents)
		wield(user)
	update_icon()

/obj/item/gun/ballistic/z121_repeating_flintlock/proc/can_service(mob/user)
	return user && user.canUseTopic(src, BE_CLOSE) && (user.is_holding(src) || isturf(loc))

/obj/item/gun/ballistic/z121_repeating_flintlock/attack_right(mob/user)
	if(!can_service(user) || user.get_active_held_item() || operating || firing)
		return
	if(QDELETED(myrod) || myrod.loc != src)
		myrod = null
		to_chat(user, span_warning("枪管下没有通条。"))
		return
	var/obj/item/ramrod/rod = myrod
	var/taken = user.put_in_hands(rod)
	// 手部不可用时放入双手会把物品落地，仍须清除枪内引用。
	if(rod.loc != src)
		myrod = null
	if(taken)
		playsound(src, 'sound/items/sharpen_short1.ogg', 100, TRUE)
		to_chat(user, span_notice("我取出了通条。"))

// 膛内弹从弹仓列表移除，总容量由两处合计，避免重复计数和额外的第十三发。
/obj/item/gun/ballistic/z121_repeating_flintlock/chamber_round(keep_bullet = FALSE)
	if(chambered || !magazine)
		return
	chambered = magazine.get_round(FALSE)
	if(chambered)
		chambered.forceMove(src)

/obj/item/gun/ballistic/z121_repeating_flintlock/process_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	if(empty_chamber)
		QDEL_NULL(chambered)
	if(chamber_next_round)
		chamber_round()

/obj/item/gun/ballistic/z121_repeating_flintlock/attackby(obj/item/I, mob/user, params)
	if(!can_service(user) || !user.is_holding(I))
		return
	if(operating || firing)
		to_chat(user, span_warning("枪械正在操作中。"))
		return
	if(istype(I, /obj/item/ammo_casing/caseless/bullet/lead))
		var/obj/item/ammo_casing/caseless/bullet/lead/bullet = I
		if(!bullet.BB)
			to_chat(user, span_warning("这颗铅弹已经无法使用了。"))
			return
		if(get_ammo() >= ammo_capacity || !magazine)
			to_chat(user, span_warning("铅弹已装满。"))
			return
		if(!user.transferItemToLoc(bullet, src))
			return
		if(!magazine.give_round(bullet))
			user.put_in_hands(bullet)
			return
		chamber_round()
		playsound(src, load_sound, 100, TRUE)
		to_chat(user, span_notice("我装入一颗铅弹（[get_ammo()]/[ammo_capacity]）。"))
		return
	if(istype(I, /obj/item/ammo_casing) || istype(I, /obj/item/ammo_box))
		to_chat(user, span_warning("连发燧枪只能逐颗装入铅弹。"))
		return
	if(istype(I, /obj/item/powderflask))
		if(powder_charges >= powder_capacity)
			to_chat(user, span_notice("火药仓已经装满。"))
			return
		service_gun(user, I, FALSE)
		return
	if(istype(I, /obj/item/ramrod))
		if(jammed)
			service_gun(user, I, TRUE)
			return
		if(myrod && myrod.loc == src)
			to_chat(user, span_warning("枪管下已经收着一根通条。"))
			return
		if(user.transferItemToLoc(I, src))
			myrod = I
			playsound(src, load_sound, 100, TRUE)
			to_chat(user, span_notice("我把通条收到了枪管下方。"))
		return
	return ..()

/obj/item/gun/ballistic/z121_repeating_flintlock/proc/service_gun(mob/user, obj/item/tool, clearing_jam)
	if(operating || firing || !can_service(user) || !user.is_holding(tool))
		return
	var/start_location = loc
	var/service_time = max(1, 50 - user.get_skill_level(/datum/skill/combat/firearms) * 2)
	var/service_notice = clearing_jam ? "我开始用通条排除卡壳。" : "我开始向火药仓装填烟火药。"
	to_chat(user, span_notice(service_notice))
	playsound(src, clearing_jam ? 'modular_helmsguard/sound/arquebus/ramrod.ogg' : 'modular_helmsguard/sound/arquebus/pour_powder.ogg', 100, TRUE)
	// 准备完成后再锁定枪械，正常结束和中断读条均会释放此状态。
	operating = TRUE
	var/completed = do_after(user, service_time, target = src)
	if(QDELETED(src))
		return
	operating = FALSE
	// 读条结束后重新确认枪械和工具，阻止交接、丢弃或中断后的装填。
	if(!completed || QDELETED(tool) || loc != start_location || !can_service(user) || !user.is_holding(tool))
		return
	if(clearing_jam)
		jammed = FALSE
		to_chat(user, span_notice("我清除了卡壳，枪械可以继续射击了。"))
	else
		powder_charges = powder_capacity
		to_chat(user, span_notice("我装满了火药仓（[powder_charges]/[powder_capacity]）。"))

/obj/item/gun/ballistic/z121_repeating_flintlock/can_shoot()
	return chambered?.BB && powder_charges > 0 && !jammed && !operating && !firing && world.time >= next_shot_time

/obj/item/gun/ballistic/z121_repeating_flintlock/shoot_with_empty_chamber(mob/living/user)
	if(operating || firing)
		to_chat(user, span_warning("枪械正在操作中。"))
	else if(jammed)
		to_chat(user, span_warning("机构卡壳了，需要用通条排障。"))
	else if(world.time < next_shot_time)
		to_chat(user, span_warning("击发机构尚未复位。"))
	else if(powder_charges <= 0)
		to_chat(user, span_warning("火药仓已空。"))
	else
		to_chat(user, span_warning("枪内没有可用的铅弹。"))
		playsound(src, dry_fire_sound, 100, FALSE)

/obj/item/gun/ballistic/z121_repeating_flintlock/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(!can_shoot())
		shoot_with_empty_chamber(user)
		return FALSE
	if(!user || !can_trigger_gun(user) || !get_turf(target) || !get_turf(user))
		return FALSE
	// 所有拒绝开火的检查先于卡壳掷骰，和平主义者不会凭空触发故障。
	if(HAS_TRAIT(user, TRAIT_PACIFISM) && chambered.harmful)
		to_chat(user, span_warning("枪里装着致命弹药，我不愿开火。"))
		return FALSE
	if(user.used_intent?.arc_check() && get_dist_euclidian(target, user) > effective_range())
		to_chat(user, span_warning("目标超出了这把枪的曲射射程。"))
		return FALSE
	if(prob(jam_chance))
		jammed = TRUE
		playsound(src, dry_fire_sound, 100, FALSE)
		to_chat(user, span_warning("齿轮机构卡住了！需要使用通条排障。"))
		return FALSE
	spread = user.client ? max(0, 150 - 150 * (user.client.chargedprog / 100)) : 0
	var/fully_aimed = user.client && user.client.chargedprog >= 100
	firing = TRUE
	. = ..()
	if(QDELETED(src))
		return
	firing = FALSE
	if(. && fully_aimed)
		adjust_experience(user, /datum/skill/combat/firearms, user.STAINT * 4)

/obj/item/gun/ballistic/z121_repeating_flintlock/shoot_live_shot(mob/living/user, pointblank = 0, mob/pbtarget = null, message = 1)
	// 父类只有在弹丸成功发射后才调用此过程，失败开火不扣资源或开始冷却。
	powder_charges = max(0, powder_charges - 1)
	next_shot_time = world.time + shot_interval
	fire_sound = pick('modular_helmsguard/sound/arquebus/arquefire.ogg', 'modular_helmsguard/sound/arquebus/arquefire2.ogg', 'modular_helmsguard/sound/arquebus/arquefire3.ogg', 'modular_helmsguard/sound/arquebus/arquefire4.ogg', 'modular_helmsguard/sound/arquebus/arquefire5.ogg')
	spark_act()
	playsound(src, 'sound/items/flint.ogg', 100, TRUE)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(spawn_smoke), user, 1), 1)
	addtimer(CALLBACK(src, PROC_REF(spawn_smoke), user, 2), 5)
	addtimer(CALLBACK(src, PROC_REF(spawn_smoke), user, 1), 12)
	for(var/mob/viewer in range(5, user))
		if(!viewer.stat)
			shake_camera(viewer, 3, 1)

/obj/item/gun/ballistic/z121_repeating_flintlock/proc/spawn_smoke(mob/user, distance)
	if(!QDELETED(user))
		new /obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, distance))

// 持握与背负位置沿用燧枪。
/obj/item/gun/ballistic/z121_repeating_flintlock/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 6,"nx" = 7,"ny" = 6,"wx" = -2,"wy" = 3,"ex" = 1,"ey" = 3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -43,"sturn" = 43,"wturn" = 30,"eturn" = -30, "nflip" = 0, "sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -5,"ny" = -1,"wx" = -8,"wy" = 2,"ex" = 8,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = -45,"sturn" = 45,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

