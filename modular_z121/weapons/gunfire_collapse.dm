// 专用射击意图：取消蓄力瞄准，点击即射。
/datum/intent/shoot/firearm/z121_gunfire_collapse
	chargetime = 0
	chargedrain = 0

/datum/intent/shoot/firearm/z121_gunfire_collapse/get_chargetime()
	return 0

/datum/intent/arc/firearm/z121_gunfire_collapse
	chargetime = 0
	chargedrain = 0

/datum/intent/arc/firearm/z121_gunfire_collapse/get_chargetime()
	return 0

// 独立于旧火器故障链，保留弹道枪械的装匣与射击流程。
/obj/item/gun/ballistic/z121_gunfire_collapse
	name = "枪火击溃"
	desc = "一把沉重的霰弹枪，机匣侧面的凹槽正好卡住兔子怀表。你会用它拯救所有人吗，即使你并非英雄。"
	icon = 'modular_z121/icon/Gunfire.dmi'
	icon_state = "Gunfire Collapse"
	item_state = "Gunfire Collapse"
	force = 10
	force_wielded = 15
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/shoot/firearm/z121_gunfire_collapse, /datum/intent/arc/firearm/z121_gunfire_collapse, INTENT_GENERIC)
	internal_magazine = FALSE
	spawnwithmagazine = FALSE
	mag_type = /obj/item/ammo_box/magazine/z121_rabbit_watch
	bolt_type = BOLT_TYPE_OPEN
	semi_auto = TRUE
	casing_ejector = FALSE
	pixel_x = -16
	pixel_y = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = FALSE
	wlength = WLENGTH_LONG
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	can_parry = TRUE
	minstr = 10
	walking_stick = TRUE
	experimental_onback = TRUE
	magazine_wording = "怀表"
	cartridge_wording = "霰弹"
	load_sound = 'sound/firearm/musketload.ogg'
	dry_fire_sound = 'sound/firearm/musketcock.ogg'
	fire_sound = 'modular_z121/sound/shotgun_shot.ogg'
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel

/obj/item/gun/ballistic/z121_gunfire_collapse/Initialize(mapload)
	. = ..()
	bolt_locked = FALSE
	update_icon()

// 无论通用开膛逻辑怎么处理，膛内弹都真正移动到枪内，避免只停留在弹匣列表里。
/obj/item/gun/ballistic/z121_gunfire_collapse/chamber_round(keep_bullet = FALSE)
	if(chambered || !magazine)
		return
	chambered = magazine.get_round(FALSE)
	if(chambered)
		chambered.forceMove(src)

// 装入怀表后立即完成上膛，不依赖开膛枪机的状态。
/obj/item/gun/ballistic/z121_gunfire_collapse/insert_magazine(mob/user, obj/item/ammo_box/magazine/AM, display_message = TRUE)
	. = ..()
	if(!.)
		return FALSE
	bolt_locked = FALSE
	chamber_round()
	update_icon()
	return TRUE

// 射击前若发现膛内为空，自动从无限弹匣补上一发。
/obj/item/gun/ballistic/z121_gunfire_collapse/can_shoot()
	if(!chambered?.BB)
		chamber_round()
	return chambered?.BB

// 无壳霰弹不需要抛壳，只负责把下一发推进膛内。
/obj/item/gun/ballistic/z121_gunfire_collapse/process_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	if(empty_chamber)
		QDEL_NULL(chambered)
	if(chamber_next_round)
		chamber_round()

/obj/item/gun/ballistic/z121_gunfire_collapse/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	// 瞬发射击不使用蓄力进度，霰弹自身的散布仍由弹种决定。
	spread = 0
	return ..()

/obj/item/gun/ballistic/z121_gunfire_collapse/shoot_with_empty_chamber(mob/living/user)
	if(!magazine)
		to_chat(user, span_warning("没有兔子怀表。"))
	else
		to_chat(user, span_warning("枪内没有可用的霰弹。"))

/obj/item/gun/ballistic/z121_gunfire_collapse/attack_self(mob/living/user)
	if(twohands_required)
		return
	if(altgripped || wielded)
		ungrip(user)
		return
	if(has_altgrip_modes() && !gripped_intents)
		altgrip(user)
	if(gripped_intents)
		wield(user)
	update_icon()

// 有弹匣与无弹匣分别占用两个基础图态；三张姿态图仍由 generateonmob 单独选择。
/obj/item/gun/ballistic/z121_gunfire_collapse/update_icon()
	if(QDELETED(src))
		return
	..()
	cut_overlays()
	icon_state = magazine ? "Gunfire Collapse" : "Gunfire Collapse_empty"
	item_state = icon_state

// 普通、双手持握和背负分别使用三张姿态图。
/obj/item/gun/ballistic/z121_gunfire_collapse/generateonmob(tag, prop, behind = FALSE, mirrored = FALSE, used_index = null)
	if(!used_index)
		switch(tag)
			if("wielded", "altgrip")
				used_index = "Gunfire Collapse 2"
			if("onback")
				used_index = "Gunfire Collapse 3"
			else
				used_index = "Gunfire Collapse 1"
	return ..(tag, prop, behind, mirrored, used_index)

// 持握与背负位置沿用长枪。
/obj/item/gun/ballistic/z121_gunfire_collapse/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 6,"nx" = 7,"ny" = 6,"wx" = -2,"wy" = 3,"ex" = 1,"ey" = 3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -43,"sturn" = 43,"wturn" = 30,"eturn" = -30, "nflip" = 0, "sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -5,"ny" = -1,"wx" = -8,"wy" = 2,"ex" = 8,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = -45,"sturn" = 45,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
