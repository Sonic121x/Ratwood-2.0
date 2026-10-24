/obj/effect/proc_holder/spell/invoked/projectile/spitfire
	name = "吐焰火球"
	desc = "射出一枚低威力火球，命中时会点燃目标并附着少量火焰。 \n\
	对头脑简单的生物伤害提高 100%。\n\
	若以法师杖或法术书切换至弧射意图，还可越过盟友头顶发射；但那样会少造成 25% 伤害。"
	clothes_req = FALSE
	range = 8
	projectile_type = /obj/projectile/magic/aoe/fireball/spitfire
	overlay_state = "fireball_multi"
	sound = list('sound/magic/whiteflame.ogg')
	active = FALSE
	releasedrain = 30
	chargedrain = 1
	chargetime = 1
	recharge_time = 4 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2
	invocations = list("吐焰而出！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokefire
	associated_skill = /datum/skill/magic/arcane
	cost = 3

/obj/effect/proc_holder/spell/invoked/projectile/spitfire/cast(list/targets, mob/user = user)
	var/mob/living/carbon/human/H = user
	var/datum/intent/a_intent = H.a_intent
	if(istype(a_intent, /datum/intent/special/magicarc))
		projectile_type = /obj/projectile/magic/aoe/fireball/spitfire/arc
	else
		projectile_type = /obj/projectile/magic/aoe/fireball/spitfire
	. = ..()
