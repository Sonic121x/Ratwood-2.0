/obj/item/repair_kit
	name = "缝纫套件"
	icon_state = "sewingkit"
	desc = "一个制作精良的修复套件，内含高品质的加固织物线材和皮革补片，用于野外修补。无需裁缝针即可缝补皮布上的裂口。"
	icon = 'icons/roguetown/items/misc.dmi'
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_HIP
	max_integrity = 700
	experimental_inhand = FALSE
	var/can_repair = TRUE
	var/table_need = FALSE
	var/repair_type = 0 //0 - cloth; 1 - metal
	dropshrink = 0.7
	grid_width = 64
	grid_height = 32

/obj/item/repair_kit/examine()
	. = ..()
	if(src.obj_integrity > 0)
		. += span_bold("剩余 [src.obj_integrity] 次使用。")
	else
		. += span_bold("已无剩余使用次数。")

/obj/item/repair_kit/proc/self_del()
	if(repair_type == 0)
		if(prob(50))
			new /obj/item/natural/cloth(get_turf(src))
		if(prob(40))
			new /obj/item/natural/fibers(get_turf(src))
		if(prob(20))
			new /obj/item/natural/fibers(get_turf(src))
	if(repair_type == 1)
		if(prob(20))
			new /obj/item/scrap(get_turf(src))
	qdel(src)

/obj/item/repair_kit/attack_obj(obj/O, mob/living/user)
	if(!isitem(O))
		return
	var/obj/item/I = O
	if(src.obj_integrity <= 0)
		if(I.sewrepair)
			playsound(loc, 'sound/foley/cloth_rip.ogg', 100, TRUE, -2)
		if(I.anvilrepair)
			playsound(loc,'sound/items/bsmithfail.ogg', 100, TRUE, -2)
		self_del()
		return
	if(can_repair)
		if(I.sewrepair && repair_type == 1)
			return
		if(I.anvilrepair && repair_type == 0)
			return
		if(I.max_integrity)
			if(I.obj_integrity == I.max_integrity)
				to_chat(user, span_warning("这并未损坏。"))
				return
			if(!I.ontable() && table_need == TRUE)
				to_chat(user, span_warning("我应该先把它放在桌子上。"))
				return
			if(I.sewrepair)
				playsound(loc, 'sound/foley/sewflesh.ogg', 100, TRUE, -2)
			if(I.anvilrepair)
				playsound(loc,'sound/items/bsmith3.ogg', 100, TRUE, -2)
			var/const/XP_ON_SUCCESS = 0.7
			var/const/AUTO_SEW_DELAY = CLICK_CD_MELEE
			if(!do_after(user, 2 SECONDS, target = I))
				return
			else
				if(I.sewrepair)
					playsound(loc, 'sound/foley/sewflesh.ogg', 50, TRUE, -2)
				if(I.anvilrepair)
					playsound(loc,'sound/items/bsmith3.ogg', 100, TRUE, -2)

				user.visible_message(span_info("[user]修理了[I]!"))
				if(I.body_parts_covered != I.body_parts_covered_dynamic)
					user.visible_message(span_info("[user]修复了[I]的覆盖!"))
					I.repair_coverage()
				if(XP_ON_SUCCESS > 0)
					if(I.anvilrepair)
						user.mind.add_sleep_experience(I.anvilrepair, user.STAINT * XP_ON_SUCCESS)
					else
						user.mind.add_sleep_experience(/datum/skill/craft/sewing, user.STAINT * XP_ON_SUCCESS)
				I.obj_integrity = min(I.obj_integrity + (max_integrity/10), I.max_integrity) //10%
				src.obj_integrity = min(src.obj_integrity - 10, src.max_integrity) //can restore 700% for good cloth kits, and 300% for bad cloth, 400% for bad metal,	1000% for good metal kit.
				if(I.obj_broken && I.obj_integrity >= I.max_integrity)
					var/obj/item/T = I
					T.obj_fix()
					return
				if(do_after(user, AUTO_SEW_DELAY, target = I))
					attack_obj(I, user)
		return
	return ..()

/obj/item/repair_kit/bad
	name = "织物补片"
	icon_state = "custarsewingkit"
	desc = "一套寒酸的布片、一束线头和一根松散的绳子。可用于野外修补。"
	max_integrity = 300
	grid_width = 32
	grid_height = 32

/obj/item/repair_kit/metal
	name = "护甲板"
	icon_state = "armorkit"
	desc = "一套出色的金属补片、独立护甲板和固定用的皮带。无需铁匠锤即可修复受损的武器与护甲。"
	repair_type = 1
	max_integrity = 600
	table_need = TRUE

/obj/item/repair_kit/metal/bad
	name = "金属废料套件"
	icon_state = "custararmorkit"
	desc = "一套简陋的金属补片、回收的铁皮瓦和固定用的皮带。无需铁匠锤即可临时修复受损的武器与护甲。也可用于锻造中制作带状铁件。"
	max_integrity = 300

/obj/item/armorkit_empty
	name = "空金属套件"
	desc = "一个空金属盒，适合存放各种五金件和其他废料。</br>在其中塞入三块铁质废料（可通过摧毁铁制装备获得），即可制作成金属修复套件。"
	icon_state = "armorkit_empty"
	icon = 'icons/roguetown/items/misc.dmi'
	grid_width = 64
	grid_height = 32
	var/need_scrap = 3
	var/current_scrap = 0
	dropshrink = 0.7

/obj/item/armorkit_empty/attackby(obj/O, mob/living/user, params)
	if(!isitem(O))
		return
	var/obj/item/I = O
	if(I.anvilrepair || I.type == /obj/item/scrap)
		if(I.smeltresult == /obj/item/ingot/iron || I.type == /obj/item/scrap) //all iron stuff and iron scrap
			if(!do_after(user, 2 SECONDS, target = I))
				return
			user.visible_message(span_notice("[user]将[I]拆解为可用材料。"))
			qdel(I)
			current_scrap++
			if(current_scrap < need_scrap)
				var/visible_scrap = need_scrap - current_scrap
				to_chat(user, span_info("要填满[name],你还需要[visible_scrap]个..."))
			if(current_scrap >= need_scrap)
				new /obj/item/repair_kit/metal/bad(get_turf(src))
				qdel(src)
			return
		return
	return

/obj/item/scrap
	name = "铁质废料"
	desc = "铁器遭受暴力后产生的碎片与边角料。这些碎片或许仍有用处。</br>铁质废料可被制成金属修复套件——套件内再塞入铁质废料，就能在不使用铁匠锤的情况下修复受损装备。"
	icon_state = "scrap"
	icon = 'icons/roguetown/items/misc.dmi'
	grid_width = 32
	grid_height = 32
	dropshrink = 0.7
	anvilrepair = /datum/skill/craft/blacksmithing //for empty kit code
