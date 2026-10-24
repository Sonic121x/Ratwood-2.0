/obj/effect/proc_holder/spell/invoked/ley_lines
	name = "力量方尖碑"
	desc = "创建一个奥术法阵。站在其中可大幅增强施法能力，提升智力并缩短法术冷却时间。若未开启战斗模式，方尖碑则会快速恢复你的精力。<br><br>站在奥术回路中时，你无法进行防御。<br><br>同时获得一个可让你迅速返回奥术回路的法术。"
	overlay_state = "rune2"
	sound = 'sound/magic/chargingold.ogg'
	chargetime = 0
	recharge_time = 3 MINUTES
	releasedrain = 50

	sound = 'sound/magic/swap.ogg'
	var/obj/structure/leyline_circle/active_circle

/obj/effect/proc_holder/spell/invoked/ley_lines/cast(list/targets, mob/living/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(!H)
		return FALSE
	if(active_circle && !QDELETED(active_circle))
		qdel(active_circle)
	active_circle = new(get_turf(H), H, src)
	to_chat(H, span_blue("奥术符文在你脚下铺展，古老的方尖碑从失落的时光中浮现。符文与方尖碑彼此相连，构成了一道回路。"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/ley_lines/proc/on_circle_removed()
	active_circle = null

/obj/effect/proc_holder/spell/invoked/between_the_lines
	name = "尖塔之间"
	desc = "立刻返回你的奥术回路，你这魔法成瘾的家伙。"
	overlay_state = "rune3"
	recharge_time = 15 SECONDS
	chargetime = 1.5 SECONDS
	releasedrain = 30
	chargedrain = 1
	var/obj/structure/leyline_circle/linked_circle
	var/max_range = 9

/obj/effect/proc_holder/spell/invoked/between_the_lines/cast(list/targets, mob/living/user)
	. = ..()
	if(!user)
		return FALSE
	if(!linked_circle || QDELETED(linked_circle))
		return FALSE
	if(get_dist(user, linked_circle) > max_range)
		user.balloon_alert(user, "离我的奥术回路太远了！")
		return FALSE
	var/turf/T = get_turf(linked_circle)
	if(!T)
		return FALSE
	do_teleport(user, T, channel = TELEPORT_CHANNEL_MAGIC)
	playsound(T, 'sound/magic/blink.ogg', 50, TRUE)
	return TRUE


/obj/effect/beam_target
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = BELOW_OBJ_LAYER
