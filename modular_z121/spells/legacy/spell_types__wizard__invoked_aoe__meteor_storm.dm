/obj/effect/proc_holder/spell/invoked/meteor_storm
	name = "陨星风暴"
	desc = "自天穹召下危险的陨星，将敌人轰散并砸碎。"
	overlay_state = "meteor_storm"
	cost = 9
	spell_tier = 4 // Highest tier AOE
	releasedrain = 50
	chargedrain = 1
	chargetime = 50
	recharge_time =  100 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/meteor_storm/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(targets[1])
//	var/list/affected_turfs = list()
	playsound(T,'sound/magic/meteorstorm.ogg', 80, TRUE)
	T.visible_message(span_boldwarning("烈火自天而降！"))
	sleep(30)
	create_meteors(T)

//meteor storm and lightstorm.
/obj/effect/proc_holder/spell/invoked/meteor_storm/proc/create_meteors(atom/target)
	if(!target)
		return
	var/turf/targetturf = get_turf(target)
	for(var/turf/turf as anything in RANGE_TURFS(6,targetturf))
		if(prob(20))
			new /obj/effect/temp_visual/target(turf)
