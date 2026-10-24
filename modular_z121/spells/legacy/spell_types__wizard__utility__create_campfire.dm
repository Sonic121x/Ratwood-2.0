/obj/effect/proc_holder/spell/invoked/create_campfire
	name = "生成营火"
	desc = "生成一团可供烹饪的魔法营火。射程 3 格。持续 10 分钟。"
	overlay_state = "create_campfire"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 30
	chargedrain = 1
	chargetime = 3 SECONDS
	no_early_release = TRUE
	recharge_time = 60 SECONDS

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	antimagic_allowed = FALSE
	charging_slowdown = 3
	cost = 1
	range = 3
	spell_tier = 1 // Utility, with situational combat use. Great for fighting trolls..
	ignore_los = FALSE

	invocations = list("营火，于此燃起！") // Literally "Magical Campfire"
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_LOW

	var/fire_type = /obj/machinery/light/rogue/campfire/create_campfire

// Conjure spell type is not reusable cuz it don't respect invocation so special code it is
/obj/effect/proc_holder/spell/invoked/create_campfire/cast(list/targets, mob/user = usr)
	var/turf/target = get_turf(targets[1])

	if(!target || target.density)
		revert_cast()
		return
	new /obj/machinery/light/rogue/campfire/create_campfire(target)

	return TRUE
