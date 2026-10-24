/obj/effect/proc_holder/spell/invoked/projectile/frostbolt // to do: get scroll icon
	name = "寒霜箭"
	desc = "一道冻结能量构成的寒霜射线，会减缓它碰到的第一个目标并造成轻度伤害。 \
		\n 对头脑简单的生物伤害提高 100%。\n 若以法师杖或法术书 \
		切换至弧射意图，还可越过盟友头顶发射；但那样会少造成 25% 伤害。"
	range = 8
	projectile_type = /obj/projectile/magic/frostbolt
	overlay_state = "frost_bolt"
	sound = list('sound/magic/whiteflame.ogg')
	active = FALSE

	releasedrain = 30
	chargedrain = 1
	chargetime = 8
	recharge_time = 5 SECONDS
	human_req = TRUE

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	antimagic_allowed = FALSE //can you use it if you are antimagicked?
	charging_slowdown = 3
	spell_tier = 2
	invocations = list("寒霜，凝矢！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_LOW
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane //can be arcane, druidic, blood, holy
	cost = 3

	xp_gain = TRUE
	miracle = FALSE

/obj/effect/proc_holder/spell/invoked/projectile/frostbolt/cast(list/targets, mob/user = user)
	var/mob/living/target = user
	var/datum/intent/a_intent = target.a_intent
	if(istype(a_intent, /datum/intent/special/magicarc))
		projectile_type = /obj/projectile/magic/frostbolt/arc
	else
		projectile_type = /obj/projectile/magic/frostbolt
	target.visible_message(span_warning("[target] 掷出了一道冰寒射线！"), span_notice("我掷出了一道冰寒射线！"))
	. = ..()
