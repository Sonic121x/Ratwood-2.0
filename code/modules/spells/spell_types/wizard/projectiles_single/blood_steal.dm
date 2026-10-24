// Lich / Vampire shared list only
/obj/effect/proc_holder/spell/invoked/projectile/bloodsteal
	name = "夺血术"
	desc = "窃取他人的血液，收入自己的收藏。"
	clothes_req = FALSE
	overlay_state = "bloodsteal"
	sound = 'sound/magic/vlightning.ogg'
	range = 8
	projectile_type = /obj/projectile/magic/bloodsteal
	releasedrain = SPELLCOST_MAJOR_PROJECTILE
	chargedrain = 1
	chargetime = 25
	recharge_time = 20 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	invocations = list("鲜血，归我！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_VAMPIRIC
	glow_intensity = GLOW_INTENSITY_MEDIUM
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/blood
	cost = 3
	human_req = TRUE

/obj/projectile/magic/bloodsteal
	name = "夺血矢"
	expose_caster_on_deflect = TRUE
	tracer_type = /obj/effect/projectile/tracer/bloodsteal
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	damage = 25
	damage_type = BRUTE
	nodamage = FALSE
	speed = 0.3
	flag = "piercing"
	light_color = "#e74141"
	light_outer_range = 7


/obj/projectile/magic/bloodsteal/on_hit(target, blocked = FALSE)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] 在接触[target]时噗地溃散了！"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(out_of_effective_range())
			return
		if(ishuman(target) && blocked < 100)
			var/mob/living/carbon/human/H = target
			H.adjust_blood_volume(-45)
			H.handle_blood()
			H.visible_message(span_danger("[target] 的鲜血被硬生生从体内抽了出来！！"), \
					span_userdanger("我的鲜血正从体内猛然喷涌而出！"), \
					span_hear("..."), COMBAT_MESSAGE_RANGE, target)
			new /obj/effect/decal/cleanable/blood/puddle(H.loc)
			sender.adjust_bloodpool(400)
	qdel(src)
