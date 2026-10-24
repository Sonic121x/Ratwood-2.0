/obj/effect/proc_holder/spell/invoked/projectile/fetch/miracle
	name = "神圣牵引"
	miracle = TRUE
	devotion_cost = 10
	invocations = list()
	associated_skill = /datum/skill/magic/holy
	recharge_time = 5 SECONDS

/obj/effect/proc_holder/spell/invoked/projectile/fetch/miracle/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1])
	if(T.z < user.z)
		to_chat(user, span_warning("你不能在低于自己所在楼层的位置使用神圣牵引！"))
		revert_cast()
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/invoked/projectile/repel/miracle
	name = "神圣斥退"
	miracle = TRUE
	devotion_cost = 14
	invocations = list()
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/projectile/repel/miracle/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1])
	if(T.z < user.z)
		to_chat(user, span_warning("你不能在低于自己所在楼层的位置使用神圣斥退！"))
		revert_cast()
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/invoked/slick_trick_small/miracle
	name = "赛利克斯滑域"
	desc = "创造一小片神圣湿滑区域，绊倒疏于防备者。"
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "slipsquare1"
	miracle = TRUE
	devotion_cost = 30
	chargetime = 0.5 SECONDS
	invocations = list()
	associated_skill = /datum/skill/magic/holy
	recharge_time = 30 SECONDS

/obj/effect/proc_holder/spell/invoked/slick_trick/miracle
	name = "巨型赛利克斯滑域"
	desc = "让大片区域覆满神圣滑面，将受害者掀翻在地。"
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "slipsquare2"
	miracle = TRUE
	devotion_cost = 60
	chargetime = 1 SECONDS
	invocations = list()
	associated_skill = /datum/skill/magic/holy
	recharge_time = 90 SECONDS
	area_of_effect_radius = 1 // 1 = 3x3

#define NOTHING "nothing"
#define XYLIX "xylix"
#define ASTRATA "astrata"
#define NOC "noc"
#define ZIZO "zizo"
#define RAVOX "ravox"
#define ABYSSOR "abyssor"
#define MALUM "malum"
#define EORA "eora"
#define NECRA "necra"
#define PESTRA "pestra"
#define DENDOR "dendor"
#define BAOTHA "baotha"
#define GRAGGAR "graggar"
#define MATTHIOS "matthios"

//JACKPOOOOOOOT 777
#undef NOTHING
#undef XYLIX
#undef ASTRATA
#undef NOC
#undef ZIZO
#undef RAVOX
#undef ABYSSOR
#undef MALUM
#undef EORA
#undef NECRA
#undef PESTRA
#undef DENDOR
#undef BAOTHA
#undef GRAGGAR
#undef MATTHIOS
