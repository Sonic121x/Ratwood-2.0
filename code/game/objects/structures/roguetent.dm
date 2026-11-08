/obj/structure/roguetent
	parent_type = /obj/structure/tent_component
	name = "帐篷门帘"
	icon = 'icons/turf/roguewall.dmi'
	icon_state = "tent_door1"
	layer = WALL_OBJ_LAYER
	plane = GAME_PLANE
	density = TRUE
	opacity = TRUE
	var/base_state = "tent_door"
	var/dismantle_dir
	var/obj/item/refund_material = /obj/item/natural/cloth

/obj/structure/roguetent/update_icon()
	icon_state = density ? "[base_state][pick("1","2")]" : "[base_state]0"
	return ..()

/obj/structure/roguetent/OnCrafted(dirin, mob/user)
	. = ..()
	if(user)
		dismantle_dir = get_dir(src, get_turf(user))

/obj/structure/roguetent/ShiftClick(mob/user)
	if(!parent_tent || !parent_tent.assembled)
		to_chat(user, span_warning("我需要一根木桩才能拆下这块门帘。"))
		return TRUE
	
	var/turf/T = get_turf(user)
	if(!T || !T.pseudo_roof)
		to_chat(user, span_warning("只能从帐篷里面拆掉它！"))
		return TRUE

	if(get_dist(user, src) > 1)
		to_chat(user, span_warning("我离得太远了！"))
		return TRUE

	var/confirm = alert(user, "你确定要收起[parent_tent.name]吗？", "拆除", "是", "否")
	if(confirm == "是" && get_dist(user, src) <= 1)
		parent_tent.disassemble_tent(user)
	return TRUE

/obj/structure/roguetent/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/grown/log/tree/stake))
		return try_dismantle(user, I)
	return ..()

/obj/structure/roguetent/proc/try_dismantle(mob/user, obj/item/I)
	if(!istype(I, /obj/item/grown/log/tree/stake))
		to_chat(user, span_warning("我需要一根木桩才能拆下这块门帘。"))
		return TRUE
	if(!dismantle_dir)
		dismantle_dir = get_dir(src, get_turf(user))
	if(get_dist(user, src) > 1 || get_dir(src, get_turf(user)) != dismantle_dir)
		to_chat(user, span_warning("我只能从搭建时所在的一侧拆下这块门帘。"))
		return TRUE
	if(alert(user, "拆下这块帐篷门帘？", "拆除", "是", "否") != "是")
		return TRUE
	if(get_dist(user, src) > 1 || get_dir(src, get_turf(user)) != dismantle_dir)
		return TRUE
	user.visible_message(span_notice("[user]开始拆除[src]。"))
	if(!do_after(user, 4 SECONDS, target = src))
		return TRUE
	new /obj/item/grown/log/tree/stick(get_turf(user))
	new refund_material(get_turf(user))
	qdel(src)
	return TRUE

/obj/structure/roguetent/leather
	color = "#7a4a2b"
	refund_material = /obj/item/natural/hide/cured

/obj/structure/roguetent/proc/open_up(mob/user)
	visible_message(span_info("[user]打开了[src]。"))
	playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
	density = FALSE
	opacity = FALSE
	update_icon()

/obj/structure/roguetent/proc/close_up(mob/user)
	visible_message(span_info("[user]关上了[src]。"))
	playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
	density = TRUE
	opacity = TRUE
	update_icon()

/obj/structure/roguetent/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!density)
		close_up(user)
	else
		open_up(user)
