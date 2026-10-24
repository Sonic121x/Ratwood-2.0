/obj/effect/proc_holder/spell/invoked/projectile/fireball/artillery
	name = "攻城火球"
	desc = "一枚可进行弧射的火球，看起来对建筑造成的伤害远比对人更高。\n  \
	对头脑简单的生物伤害提高 100%。\n 若以法师杖或法术书切换 \
	至弧射意图，还可越过盟友头顶发射；那样会额外提高 30% 伤害。"
	clothes_req = FALSE
	cost = 6
	range = 8
	projectile_type = /obj/projectile/magic/aoe/fireball/rogue/artillery
	overlay_state = "fireball_artillery"
	sound = list('sound/magic/fireball.ogg')
	releasedrain = 30
	chargedrain = 1
	chargetime = 25
	recharge_time = 20 SECONDS // 5 seconds more than fireball
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	spell_tier = 4 // Court mage can have this as a treat
	invocations = list("攻城火球，直落！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_HIGH
	chargedloop = /datum/looping_sound/invokefire
	associated_skill = /datum/skill/magic/arcane
	xp_gain = TRUE

/obj/effect/proc_holder/spell/invoked/projectile/fireball/artillery/cast(list/targets, mob/user = user)
	var/mob/living/carbon/human/H = user
	var/datum/intent/a_intent = H.a_intent
	if(istype(a_intent, /datum/intent/special/magicarc))
		projectile_type = /obj/projectile/magic/aoe/fireball/rogue/artillery/arc
	else
		projectile_type = /obj/projectile/magic/aoe/fireball/rogue/artillery
	. = ..()
