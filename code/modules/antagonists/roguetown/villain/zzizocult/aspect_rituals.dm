GLOBAL_LIST_EMPTY(zizo_portals)
GLOBAL_VAR_INIT(zizo_portal_count, 0)
GLOBAL_LIST_EMPTY(gate_targets)
GLOBAL_LIST_EMPTY(cult_robes)
GLOBAL_LIST_EMPTY(zizo_reality_rends)
GLOBAL_LIST_EMPTY(zizo_fuges)
GLOBAL_LIST_EMPTY(zizo_summoned)
GLOBAL_LIST_EMPTY(zizo_marks)

GLOBAL_LIST_INIT(zizo_researchable, list(
	/datum/ritual/servantry/convert, /datum/ritual/servantry/sacrifice,
	/datum/ritual/servantry/heartache,
	/datum/ritual/servantry/gutted, /datum/ritual/transmutation/cross,
	/datum/ritual/transmutation/criminalstool, /datum/ritual/transmutation/invademind,
	/datum/ritual/transmutation/summonoutfit, /datum/ritual/servantry/aspect,
	/datum/ritual/transmutation/allseeingeye,
	/datum/ritual/fleshcrafting/bunnylegs, /datum/ritual/fleshcrafting/fleshmend,
	/datum/ritual/fleshcrafting/fleshmend/greater, /datum/ritual/fleshcrafting/darkeyes,
	/datum/ritual/fleshcrafting/nopain, /datum/ritual/fleshcrafting/immortality,
	/datum/ritual/transmutation/summonarmor, /datum/ritual/transmutation/summonweapon, /datum/ritual/transmutation/hiddenward, /datum/ritual/transmutation/lessernecromancy, /datum/ritual/fleshcrafting/lesserrituos,
	/datum/ritual/transmutation/summonpylon, /datum/ritual/transmutation/summonraver,
	/datum/ritual/transmutation/propaganda, /datum/ritual/servantry/sleepcurse, /datum/ritual/servantry/tongues, /datum/ritual/servantry/exhaustion, /datum/ritual/servantry/knock, /datum/ritual/servantry/misfortune,
	/datum/ritual/transmutation/silencerleech, /datum/ritual/servantry/darksunmark,
	/datum/ritual/strand/dream_jaunt, /datum/ritual/strand/strandsend,
	/datum/ritual/strand/strandrecall, /datum/ritual/toil/progress,
	/datum/ritual/toil/summonysis, /datum/ritual/toil/fulmenor,
	/datum/ritual/bite/necromancy, /datum/ritual/bite/resurrection,
	/datum/ritual/bite/thanatophobia,
	/datum/ritual/rot/transfuse, /datum/ritual/rot/blight,
	/datum/ritual/rot/plague, /datum/ritual/noise/thermalvis,
	/datum/ritual/noise/forgettongue, /datum/ritual/servantry/witchery,
	/datum/ritual/pitch/fireresist, /datum/ritual/pitch/shadowform,
	/datum/ritual/pitch/lightcurse, /datum/ritual/blood/transfuse,
	/datum/ritual/blood/bloodsnare, /datum/ritual/blood/bloodbond,
	/datum/ritual/transmutation/raiseshrine, /datum/ritual/servantry/guidance,
	))

GLOBAL_LIST_INIT(zizo_goals, list(
	/datum/zizogoal/worshipzizo, /datum/zizogoal/worshipzizo_church,
	/datum/zizogoal/worshipzizo_garrison, /datum/zizogoal/worshipzizo_warden, /datum/zizogoal/robgrave,
	/datum/zizogoal/drinklux,
	/datum/zizogoal/profaneshrine_church, /datum/zizogoal/profaneshrine_tavern,
	/datum/zizogoal/profaneshrine_bath, /datum/zizogoal/profaneshrine_academy,
	/datum/zizogoal/profaneshrine_graveyard,
	))

GLOBAL_LIST_EMPTY(zizo_bestowed)
GLOBAL_DATUM_INIT(zizo_research, /datum/zizo_research, new)

#define TIER_TWO_GATEROLES \
	/datum/job/roguetown/warden,\
	/datum/job/roguetown/watchcaptain,\
	/datum/job/roguetown/wardenmaster,\
	/datum/job/roguetown/sergeant,\
	/datum/job/roguetown/veteran,\
	/datum/job/roguetown/dungeoneer,\
	/datum/job/roguetown/manorguard,\
	/datum/job/roguetown/squire,\
	/datum/job/roguetown/guardsman,\
	/datum/job/roguetown/janissary,\
	/datum/job/roguetown/janissarysergeant,\
	/datum/job/roguetown/azeb,\
	/datum/job/roguetown/slavemaster,\
	/datum/job/roguetown/guardsman,\
	/datum/job/roguetown/jester,\
	/datum/job/roguetown/clerk,\
	/datum/job/roguetown/wapprentice,\
	/datum/job/roguetown/butler,\
	/datum/job/roguetown/apothecary,\
	/datum/job/roguetown/chaplain,\
	/datum/job/roguetown/dtchaplain,\
	/datum/job/roguetown/churchling,\
	/datum/job/roguetown/druid,\
	/datum/job/roguetown/niteman,\
	/datum/job/roguetown/archivist,\
	/datum/job/roguetown/monk,\
	/datum/job/roguetown/templar,\
	/datum/job/roguetown/orthodoxist

#define TIER_THREE_GATEROLES \
	/datum/job/roguetown/prince,\
	/datum/job/roguetown/councillor,\
	/datum/job/roguetown/physician,\
	/datum/job/roguetown/marshal,\
	/datum/job/roguetown/captain,\
	/datum/job/roguetown/hand,\
	/datum/job/roguetown/knight,\
	/datum/job/roguetown/puritan,\
	/datum/job/roguetown/steward,\
	/datum/job/roguetown/cataphract,\
	/datum/job/roguetown/magician,\
	/datum/job/roguetown/priest

// HELPERS !!!

/proc/is_zizo(mob/M)
	return M && (is_zizocultist(M.mind) || is_zizolackey(M.mind))

/proc/absorb_lux(mob/living/carbon/human/target, turf/T, give_crystal = TRUE)
	if(is_zizo(target))
		return FALSE
	if(target.has_status_effect(/datum/status_effect/debuff/devitalised) || target.has_status_effect(/datum/status_effect/debuff/devitalised/lux_ripped))
		return FALSE
	target.apply_status_effect(/datum/status_effect/debuff/devitalised/lux_ripped)
	ADD_TRAIT(target, TRAIT_LUX_RIPPED, TRAIT_GENERIC)
	new /obj/effect/temp_visual/cult/sac(get_turf(target))
	new /obj/effect/temp_visual/cult/sparks(get_turf(target))
	target.Unconscious(4 MINUTES)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, apply_status_effect), /datum/status_effect/buff/healing, 70, TRUE), 4 MINUTES)
	target.Jitter(4)
	target.emote("scream")
	target.visible_message(span_danger("[target]的记忆被抹去了！四分钟后醒来时，[target]会忘记这里发生的一切，也记不清是谁下的手。"))
	var/obj/item/bodypart/chest/torso = target.get_bodypart(BODY_ZONE_CHEST)
	if(torso)
		torso.receive_damage(85)
		torso.add_wound(/datum/wound/fracture)
	playsound(target, 'sound/gore/flesh_eat_04.ogg', 60, TRUE)
	target.purity = FALSE
	to_chat(target, span_danger("有人从你的灵魂里撕走了灵辉。记忆一片模糊。你记不起是谁下的手，也想不起事情的经过。"))
	if(give_crystal)
		new /obj/item/necro_relics/necro_crystal(T)
	return TRUE

/proc/psydont(mob/living/carbon/human/H)
	for(var/obj/item/clothing/neck/roguetown/psicross/silver/S in H.held_items + H.get_equipped_items(TRUE))
		return TRUE
	return FALSE

/proc/find_remnant(mob/user, turf/center)
	for(var/obj/item/natural/worms/leech/L in center)
		if(L.fed_from && !QDELETED(L.fed_from) && L.fed_from.stat != DEAD)
			if(psydont(L.fed_from))
				to_chat(user, span_danger("对方身上的白银抵挡了黑魔法！"))
				return FALSE
			return L
	to_chat(user, span_warning("空无一物。"))

/proc/zizo_target_error(mob/living/user, mob/living/carbon/human/target, list/wanted)
	if(!target || target == user)
		to_chat(user, span_warning("将祭品放在中央。"))
		return TRUE
	if(is_zizo(target))
		to_chat(user, span_warning("不能献祭同教成员。"))
		return TRUE
	if(!target.mind?.key)
		to_chat(user, span_warning("此人没有灵魂。"))
		return TRUE
	if(!wanted && HAS_TRAIT(target, TRAIT_LUX_RIPPED))
		to_chat(user, span_warning("此人的灵辉早已被夺走。"))
		return TRUE
	if(istype(target, /mob/living/carbon/human/species/skeleton) || is_species(target, /datum/species/gnoll))
		to_chat(user, span_warning("此人不适合这个仪式。"))
		return TRUE
	var/datum/job/J = SSjob.GetJob(target.mind?.assigned_role)
	if(!J || (J.type in list(KING_QUEEN_ROLES)) || J.type == /datum/job/roguetown/bandit || J.type == /datum/job/roguetown/wretch)
		to_chat(user, span_warning("此人不适合这个仪式。"))
		return TRUE
	if(!wanted && (target in GLOB.gate_targets))
		to_chat(user, span_warning("此人不适合这个仪式。"))
		return TRUE
	if(wanted && !(target in wanted))
		to_chat(user, span_warning("此人不适合这个仪式。"))
		return TRUE
	if(psydont(target))
		to_chat(user, span_warning("白银驱散了黑魔法！"))
		return TRUE
	return FALSE

/proc/refresh_zizo_marks()
	for(var/image/old in GLOB.zizo_marks)
		for(var/client/C in GLOB.clients)
			C.images -= old
	GLOB.zizo_marks.Cut()
	for(var/mob/living/carbon/human/T in GLOB.gate_targets)
		if(QDELETED(T) || T.stat == DEAD)
			continue
		var/image/mark = image('icons/effects/eldritch.dmi', T, "eye_pulse", ABOVE_ALL_MOB_LAYER) // cool eye stolen from heretic
		mark.pixel_y = 30
		GLOB.zizo_marks += mark
		for(var/datum/mind/M in SSmapping.retainer.cultists)
			var/client/C = M.current?.client
			if(C)
				C.images += mark

/proc/zizo_dist(atom/A, atom/B)
	return max(abs(A.x - B.x), abs(A.y - B.y)) + abs(A.z - B.z)

/proc/zizo_roll_start()
	refill_bestow_areas()

/datum/status_effect/buff/curse_immunity
	id = "curse_immunity"
	duration = 15 MINUTES
	alert_type = null

/proc/curse_target(mob/living/target, show = TRUE)
	if(!target || target.has_status_effect(/datum/status_effect/buff/curse_immunity))
		return FALSE
	target.apply_status_effect(/datum/status_effect/buff/curse_immunity, 15 MINUTES)
	if(!show)
		return TRUE
	target.playsound_local(target, 'sound/vo/mobs/ghost/whisper (1).ogg', 60, FALSE)
	if(target.client)
		var/image/eye = image('icons/effects/eldritch.dmi', target, "eye_open", ABOVE_ALL_MOB_LAYER)
		eye.pixel_y = 32
		target.client.images += eye
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(clear_curse_eye), target.client, eye), 4 SECONDS)
	return TRUE

/proc/clear_curse_eye(client/C, image/eye)
	C?.images -= eye

/proc/recolor_accessory(accessory_type, hex)
	var/datum/sprite_accessory/A = SPRITE_ACCESSORY(accessory_type)
	var/list/colors = list()
	for(var/i in 1 to A.color_keys)
		colors += "#[hex]"
	return color_list_to_string(colors)


/datum/ritual/strand
	abstract_type = /datum/ritual/strand
	needs_aspect = "STRAND"

/datum/ritual/pitch
	abstract_type = /datum/ritual/pitch
	needs_aspect = "PITCH"

/datum/ritual/toil
	abstract_type = /datum/ritual/toil
	needs_aspect = "TOIL"

/datum/ritual/bite
	abstract_type = /datum/ritual/bite
	needs_aspect = "BITE"

/datum/ritual/rot
	abstract_type = /datum/ritual/rot
	needs_aspect = "ROT"

/datum/ritual/noise
	abstract_type = /datum/ritual/noise
	needs_aspect = "NOISE"

/datum/ritual/blood
	abstract_type = /datum/ritual/blood
	needs_aspect = "BLOOD"

GLOBAL_LIST_EMPTY(zizo_bestow_areas)

/proc/refill_bestow_areas()
	if(!GLOB.zizo_bestow_areas)
		GLOB.zizo_bestow_areas = list()
	var/list/pool = list(
		/area/rogue/indoors/town/shop,
		/area/rogue/indoors/town/tavern,
		/area/rogue/indoors/town/church,
		/area/rogue/indoors/town/bath,
		/area/rogue/indoors/town/physician,
		/area/rogue/indoors/town/magician,
		/area/rogue/indoors/town/garrison,
		/area/rogue/indoors/town/warden,
		/area/rogue/outdoors/town/graveyard,
	) - GLOB.zizo_bestow_areas
	while(GLOB.zizo_bestow_areas.len < 3 && pool.len)
		var/chosen = pick(pool)
		GLOB.zizo_bestow_areas += chosen
		pool -= chosen

/proc/zizo_bestow_alert(area/where, final)
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.mind && H.get_skill_level(/datum/skill/magic/arcane) > 0)
			to_chat(H, span_userdanger("邪术的波动从[where.name]传来！那边出事了！"))
			if(!is_zizo(H))
				zizo_wonder(H, FALSE)
	for(var/obj/item/inqhound/hound in world)
		hound.say("侦测到[uppertext(where.name)]的界域不稳。疑有异端活动。")
	if(!final)
		return
	priority_announce("诸神垂泪。飞升将至。", title = "凶兆", sound = 'sound/villain/dreamer_warning.ogg')
	var/datum/particle_weather/gentle = new /datum/particle_weather/blood_rain_gentle
	SSParticleWeather.runningWeather = gentle
	gentle.start()

/obj/structure/reality_rend
	name = "现实裂隙"
	desc = "世界身上的一道伤口。"
	icon = 'icons/obj/tesla_engine/energy_ball.dmi'
	icon_state = "energy_ball"
	color = "#000000"
	density = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/radius = 2
	var/list/turf_data = list()

/datum/stressevent/saw_wonder/cult
	timer = 1 MINUTES

/obj/structure/reality_rend/examine(mob/user)
	if(!ishuman(user))
		return
	zizo_wonder(user)

/proc/zizo_wonder(mob/living/carbon/human/H, knockdown = TRUE)
	H.overlay_fullscreen("cult", /atom/movable/screen/fullscreen/druqks)
	H.add_stress(/datum/stressevent/saw_wonder/cult)
	H.emote("scream")
	if(knockdown)
		H.Paralyze(2 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(clear_cult_fullscreen), H), 2 SECONDS)

/proc/clear_cult_fullscreen(mob/user)
	user.clear_fullscreen("cult")

/turf/closed/wall/mineral/rogue/stone/unbreakable/space
	name = "???"
	desc = "???"
	icon = 'icons/roguetown/cult/cultsprites.dmi'
	icon_state = "cultwall"
	smooth = SMOOTH_FALSE

/turf/open/floor/rogue/underworld/space/quiet/cult
	icon = 'icons/roguetown/cult/cultsprites.dmi'
	icon_state = "cultfloor"
	smooth = SMOOTH_FALSE
	slowdown = 0

/turf/open/floor/rogue/underworld/space/quiet/cult/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/particles/zizo_void
	icon = 'icons/effects/particles/particle.dmi'
	icon_state = "puff"
	width = 160
	height = 160
	count = 30
	spawning = 0.5
	lifespan = 3 SECONDS
	fade = 1 SECONDS
	color = "#2a0a3a"
	scale = 0.6
	position = generator("circle", 20, 36, UNIFORM_RAND)
	drift = generator("circle", 0, 0.3)

// light flickers for rituals. Might b too obvious ?
/proc/zizo_flicker(atom/A)
	set waitfor = FALSE
	for(var/i in 1 to 4)
		A.set_light_on(FALSE)
		A.update_light()
		sleep(rand(1, 3))
		if(QDELETED(A))
			return
		A.set_light_on(TRUE)
		A.update_light()
		sleep(rand(1, 3))
		if(QDELETED(A))
			return

/particles/zizo_burst
	icon = 'icons/effects/particles/particle.dmi'
	icon_state = "puff"
	width = 160
	height = 160
	count = 12
	spawning = 12
	lifespan = 1.4 SECONDS
	fade = 0.8 SECONDS
	color = "#2a0a3a"
	scale = 0.6
	grow = 0.03
	velocity = generator("circle", 1, 3)

// scaduform aura
/particles/zizo_shadow
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state = list("smoke_1" = 1, "smoke_2" = 1, "smoke_3" = 1)
	count = 20
	spawning = 0.4
	lifespan = 1.5 SECONDS
	fade = 1 SECONDS
	color = "#1a0a2a"
	position = generator("box", list(-8, -8, 0), list(8, 8, 0), UNIFORM_RAND)
	velocity = list(0, 0.4, 0)
	grow = 0.03

// evil gassy aura for blight & rot
/particles/zizo_rot
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state = list("smoke_1" = 1, "smoke_2" = 1, "ash_1" = 1)
	count = 40
	spawning = 0.4
	lifespan = 2 SECONDS
	fade = 1 SECONDS
	color = "#7a2a2a"
	position = generator("box", list(-24, -16, 0), list(24, 16, 0), UNIFORM_RAND)
	velocity = list(0, 0.3, 0)
	grow = 0.02

/obj/effect/temp_visual/cult/rune_spawn/rune7/wide
	start_scale = 3.5

/obj/effect/temp_visual/zizo_crack
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "realitycrack"
	duration = 3.2 SECONDS

/obj/effect/temp_visual/zizo_ring
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "cosmic_ring"
	color = "#ff4040"
	duration = 1 SECONDS

/obj/effect/temp_visual/zizo_ring/Initialize(mapload)
	. = ..()
	transform = matrix() * 0.5
	animate(src, transform = matrix() * 3, alpha = 0, time = duration)

/obj/structure/reality_rend/Initialize(mapload)
	. = ..()
	GLOB.zizo_reality_rends += src
	add_filter("rend_ripple", 1, list(type = "ripple", size = 2, radius = 0, falloff = 1, repeat = 8))
	animate(get_filter("rend_ripple"), radius = 80, time = 4 SECONDS, loop = -1)
	animate(radius = 0, time = 0)
	new /obj/effect/abstract/particle_holder(src, /particles/zizo_void)
	START_PROCESSING(SSobj, src)
	var/turf/center = get_turf(src)
	for(var/turf/T in range(radius, center))
		if(isclosedturf(T) && !istype(T, /turf/closed/indestructible))
			turf_data[T] = T.type
			T.ChangeTurf(/turf/closed/wall/mineral/rogue/stone/unbreakable/space, flags = CHANGETURF_IGNORE_AIR)
			new /obj/effect/temp_visual/cult/turf(T)
		else if(isopenturf(T) && !istype(T, /turf/open/floor/rogue/underworld/space/quiet/cult))
			turf_data[T] = T.type
			T.ChangeTurf(/turf/open/floor/rogue/underworld/space/quiet/cult, flags = CHANGETURF_IGNORE_AIR)
			new /obj/effect/temp_visual/cult/turf/floor(T)

/obj/structure/reality_rend/process()
	if(length(turf_data) && prob(20))
		new /obj/effect/temp_visual/zizo_crack(pick(turf_data))

/obj/structure/reality_rend/Destroy()
	STOP_PROCESSING(SSobj, src)
	GLOB.zizo_reality_rends -= src
	for(var/turf/T in turf_data)
		T.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	turf_data.Cut()
	visible_message(span_danger("灵辉渗入荒石，大地重获生机！"))
	playsound(src, 'sound/foley/breaksound.ogg', 50, TRUE)
	return ..()

#define ZIZO_GATE_PULL_RANGE 50

/datum/status_effect/buff/zizo_gate_sense
	id = "zizo_gate_sense"
	duration = -1
	tick_interval = 15 SECONDS
	alert_type = null

/datum/status_effect/buff/zizo_gate_sense/tick()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/obj/structure/reality_rend/nearest_rend
	var/nearest_rend_dist = ZIZO_GATE_PULL_RANGE
	for(var/obj/structure/reality_rend/R as anything in GLOB.zizo_reality_rends)
		var/d = zizo_dist(H, R)
		if(d <= nearest_rend_dist)
			nearest_rend = R
			nearest_rend_dist = d
	if(!nearest_rend)
		H.remove_status_effect(/datum/status_effect/buff/zizo_gate_pull)
		return
	var/datum/status_effect/buff/zizo_gate_pull/pull = H.has_status_effect(/datum/status_effect/buff/zizo_gate_pull)
	if(!pull)
		pull = H.apply_status_effect(/datum/status_effect/buff/zizo_gate_pull)
	pull.target_rend = nearest_rend

/datum/status_effect/buff/zizo_gate_pull
	id = "zizo_gate_pull"
	duration = -1
	needs_processing = FALSE
	alert_type = /atom/movable/screen/alert/status_effect/buff/zizo_gate_pull
	var/obj/structure/reality_rend/target_rend

/atom/movable/screen/alert/status_effect/buff/zizo_gate_pull
	name = "虚幻之境"
	desc = "诸界正在流血。"
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "eye_pulse"

/atom/movable/screen/alert/status_effect/buff/zizo_gate_pull/handle_click(location, control, params)
	. = ..()
	var/datum/status_effect/buff/zizo_gate_pull/pull = attached_effect
	if(!pull || QDELETED(pull.target_rend))
		return
	var/obj/structure/reality_rend/rend = pull.target_rend
	var/atom/dest = rend
	if(GLOB.zizo_fuges.len)
		var/choice = input_zizo_display(mob_viewer, "要传送到哪里？", list("Reality Rend", "Fuge"), "归途")
		if(!choice)
			return
		if(choice == "Fuge")
			dest = GLOB.zizo_fuges[1]
	to_chat(mob_viewer, span_notice("我要传送了！我抓住的人会随我同行！"))
	var/turf/origin = get_turf(mob_viewer)
	var/poo = new /obj/effect/temp_visual/opengate(origin, 10 SECONDS)
	playsound(mob_viewer, 'sound/villain/littlescary2.ogg', 60, TRUE)
	if(!do_after(mob_viewer, 10 SECONDS, target = mob_viewer))
		qdel(poo)
		return
	if(QDELETED(dest) || QDELETED(rend) || QDELETED(mob_viewer) || !isliving(mob_viewer))
		return
	if(zizo_dist(mob_viewer, rend) > ZIZO_GATE_PULL_RANGE)
		to_chat(mob_viewer, span_warning("太远了！"))
		return
	var/mob/living/L = mob_viewer
	var/mob/living/grabbed = L.pulling
	if(!isliving(grabbed) || !grabbed.Adjacent(L))
		grabbed = null
	new /obj/effect/temp_visual/dir_setting/cult/phase/out(origin, L.dir)
	do_teleport(L, get_turf(dest), 1, asoundin = 'sound/magic/blink.ogg')
	new /obj/effect/temp_visual/dir_setting/cult/phase(get_turf(L), L.dir)
	if(grabbed)
		do_teleport(grabbed, get_turf(L), 1, asoundin = 'sound/magic/blink.ogg')

#undef ZIZO_GATE_PULL_RANGE

/datum/ritual/servantry/aspect
	name = "Open Gate"
	icon_type = /obj/item/necro_relics/necro_crystal
	desc = "启动仪式可得知施行地点。每开启一座界门，就会释放一种神相，供教徒研究新的仪式。开启三座界门后方可飞升。"
	is_cultist_ritual = TRUE
	var/gate_count

/obj/effect/temp_visual/opengate
	icon = 'icons/effects/clan.dmi'
	icon_state = "summoning"
	dir = SOUTH
	randomdir = FALSE
	duration = 15 SECONDS
	layer = MASSIVE_OBJ_LAYER
	var/list/runes = list()

/obj/effect/temp_visual/opengate/Initialize(mapload, set_duration)
	if(set_duration)
		duration = set_duration
	. = ..()
	runes += new /obj/effect/temp_visual/cult/rune_spawn/rune7/wide(loc, duration, "#cc1010")

/obj/effect/temp_visual/opengate/Destroy()
	QDEL_LIST(runes)
	return ..()

/obj/effect/temp_visual/opengate/fivesec
	duration = 5 SECONDS

/proc/print_gate_sacrifice_info(mob/user)
	refill_bestow_areas()
	to_chat(user, span_warning("前往下列地点举行仪式："))
	for(var/atype in GLOB.zizo_bestow_areas)
		var/area/A = atype
		to_chat(user, span_notice("- [initial(A.name)]"))
	if(GLOB.gate_targets.len)
		to_chat(user, span_warning("她渴求以下祭品："))
		for(var/mob/living/carbon/human/H in GLOB.gate_targets)
			to_chat(user, span_notice("- [H.real_name]"))
	else
		to_chat(user, span_warning("暂时找不到合适的祭品。"))

/turf/closed/wall/proc/zizo_collapse()
	var/datum/effect_system/smoke_spread/dust = new
	dust.set_up(0, src)
	dust.start()
	playsound(src, 'sound/misc/meteorimpact.ogg', 50, TRUE)
	dismantle_wall(1)

/proc/zizo_calamity(choice)
	if(choice == "BITE")
		SSmapping.add_world_trait(/datum/world_trait/zizo_bite, 0)
		for(var/datum/mind/M in SSmapping.retainer.cultists)
			if(M.current)
				ADD_TRAIT(M.current, TRAIT_RESISTCOLD, "zizocultist")
		priority_announce("异民教徒向岩丘降下了阴霾之咒！", title = "灾厄", sound = 'sound/villain/dreamer_warning.ogg')
	if(choice == "STRAND")
		SSmapping.add_world_trait(/datum/world_trait/zizo_strand, 0)
		priority_announce("异民教徒向岩丘降下了梦魇之咒！", title = "灾厄", sound = 'sound/villain/dreamer_warning.ogg')
	if(choice == "TOIL")
		SSmapping.add_world_trait(/datum/world_trait/zizo_toil, 0)
		priority_announce("异民教徒向岩丘降下了衰败之咒！", title = "灾厄", sound = 'sound/villain/dreamer_warning.ogg')
		var/list/town_walls = list()
		for(var/turf/closed/wall/W in world)
			if(istype(get_area(W), /area/rogue/indoors/town) || istype(get_area(W), /area/rogue/outdoors/town))
				town_walls += W
			CHECK_TICK
		var/list/collapsing = list()
		var/list/breaking = list()
		for(var/i in 1 to 5)
			if(!length(town_walls))
				break
			var/turf/closed/wall/epicenter = pick_n_take(town_walls)
			playsound(epicenter, 'sound/misc/cavein.ogg', 200, TRUE)
			for(var/turf/closed/wall/W in range(3, epicenter))
				collapsing |= W
			for(var/obj/structure/O in range(3, epicenter))
				if(istype(O, /obj/structure/mineral_door) || istype(O, /obj/structure/roguewindow))
					breaking |= O
		for(var/turf/closed/wall/W as anything in collapsing)
			new /obj/effect/temp_visual/trap/mine_collapse(W)
			addtimer(CALLBACK(W, TYPE_PROC_REF(/turf/closed/wall, zizo_collapse)), 4 SECONDS)
		for(var/obj/structure/O as anything in breaking)
			addtimer(CALLBACK(O, TYPE_PROC_REF(/obj, take_damage), O.max_integrity, BRUTE, "", FALSE), 4 SECONDS)
	if(choice == "ROT")
		SSmapping.add_world_trait(/datum/world_trait/zizo_rot, 0)
		for(var/datum/mind/M in SSmapping.retainer.cultists)
			if(M.current)
				ADD_TRAIT(M.current, TRAIT_NOHUNGER, "zizocultist")
		priority_announce("异民教徒向岩丘降下了腐朽之咒！", title = "灾厄", sound = 'sound/villain/dreamer_warning.ogg')
		var/list/food = list()
		for(var/obj/item/reagent_containers/food/snacks/F in world)
			if(F.eat_effect != /datum/status_effect/debuff/rotfood && !prob(40))
				food += F
		for(var/obj/item/reagent_containers/food/snacks/F as anything in food)
			if(F.become_rotten())
				STOP_PROCESSING(SSobj, F)
			CHECK_TICK
	if(choice == "NOISE")
		SSmapping.add_world_trait(/datum/world_trait/zizo_noise, 0)
		priority_announce("异民教徒向岩丘降下了癫狂之咒！", title = "灾厄", sound = 'sound/villain/dreamer_warning.ogg')
	if(choice == "BLOOD")
		SSmapping.add_world_trait(/datum/world_trait/zizo_blood, 0)
		priority_announce("异民教徒向岩丘降下了鲜血之咒！", title = "灾厄", sound = 'sound/villain/dreamer_warning.ogg')
		for(var/turf/open/water/W in world)
			W.water_reagent = /datum/reagent/blood
			W.water_color = "#C80000"
			W.mapped = FALSE
			W.update_icon()
			CHECK_TICK
	if(choice == "PITCH")
		GLOB.todoverride = "night"
		settod()
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(reset_tod_override)), 20 MINUTES)
		priority_announce("异民教徒向岩丘降下了黑暗之咒！", title = "灾厄", sound = 'sound/villain/dreamer_warning.ogg')
		for(var/obj/machinery/light/roguestreet/L in GLOB.streetlamp_list)
			L.break_light_tube()
			L.burn_out()
			addtimer(CALLBACK(L, TYPE_PROC_REF(/obj/machinery/light, fix)), 20 MINUTES)
		var/datum/round_event_control/lightsout/forced/blackout = new
		blackout.runEvent()

/datum/ritual/servantry/aspect/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(gate_count > 0)
		if(zizo_target_error(user, target, GLOB.gate_targets))
			print_gate_sacrifice_info(user)
			return
	refill_bestow_areas()
	var/area/here = get_area(center)
	var/valid_area = FALSE
	for(var/atype in GLOB.zizo_bestow_areas)
		if(istype(here, atype))
			valid_area = TRUE
			break

	if(!valid_area)
		to_chat(user, span_warning("地点不对。去下列地方寻找："))
		for(var/atype in GLOB.zizo_bestow_areas)
			var/area/A = atype
			to_chat(user, span_notice("- [initial(A.name)]"))
		if(gate_count > 0 && tgui_alert(user, "重新选定界门的祭品吗？", "齐佐", list("重选", "取消")) == "重选")
			reroll_gate_targets(gate_count)
			print_gate_sacrifice_info(user)
			return
		return
	var/list/choices = list("PITCH", "TOIL", "STRAND", "ROT", "BLOOD", "NOISE", "BITE") - GLOB.zizo_bestowed
	var/choice = input_zizo_display(user, "选择要释放的神相。", choices)
	if(!choice)
		return
	to_chat(user, span_notice("仪式开始了，保持不动。<BR>完成后可能有人会察觉你的位置。"))
	var/poo = new /obj/effect/temp_visual/opengate(center, 25 SECONDS)
	playsound(user, 'sound/villain/littlescary.ogg', 100, TRUE)
	if(!do_after(user, 25 SECONDS))
		qdel(poo)
		return
	if(choice in GLOB.zizo_bestowed)
		return
	GLOB.zizo_bestowed += choice
	if(gate_count > 0)
		zizo_calamity(choice)
	to_chat(user, span_boldnotice("[zizo_display(choice)]神相已降临格里莫里亚！现在可以研究其仪式。"))
	user.Jitter(4)
	gate_count++

	if(gate_count > 0)
		center_requirement = /mob/living/carbon/human

	if(gate_count < 3)
		to_chat(user, span_boldnotice("界门已开！再开启 [3 - gate_count] 座即可举行飞升仪式！"))
	if(gate_count == 3)
		GLOB.zizo_researchable |= /datum/ritual/fleshcrafting/ascend
		for(var/obj/item/clothing/cloak/cultrobe/robe as anything in GLOB.cult_robes)
			robe.empower()
		for(var/datum/mind/M in SSmapping.retainer.cultists)
			var/datum/antagonist/zizocultist/Z = M.has_antag_datum(/datum/antagonist/zizocultist)
			Z?.add_halo()

	if(gate_count > 0)
		reroll_gate_targets(gate_count)

	if(gate_count == 1)
		to_chat(user, span_userdanger("想开启下一座界门，就得向她献上祭品。"))
		print_gate_sacrifice_info(user)
		GLOB.zizo_researchable |= /datum/ritual/transmutation/summonfuge
		if(user.mind)
			user.mind.zizo_researched |= /datum/ritual/transmutation/summonfuge
			to_chat(user, span_boldnotice("我如今可以炼成异界织机了。"))

	if(target && !is_zizo(target))
		absorb_lux(target, get_turf(target), FALSE)

	for(var/datum/mind/M in SSmapping.retainer.cultists)
		if(M.current)
			zizo_award(M.current, 5)
	zizo_award(user, 5)
	playsound(user, 'sound/villain/hall_attack4.ogg', 100, TRUE)
	new /obj/structure/reality_rend(center)
	GLOB.zizo_bestow_areas -= here.type
	refill_bestow_areas()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(zizo_bestow_alert), here, gate_count >= 3), 30 SECONDS)

// WEAPONS

/datum/component/soulbound_weapon
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/weakref/owner_ref
	var/skill_path

/datum/component/soulbound_weapon/Initialize(skill_path_type)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	skill_path = skill_path_type
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))

/datum/component/soulbound_weapon/proc/on_equip(datum/source, mob/user, slot)
	SIGNAL_HANDLER
	if(slot != ITEM_SLOT_HANDS || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/weapon = parent
	if(!owner_ref)
		for(var/obj/effect/proc_holder/spell/self/recall_bound/old in H.mind?.spell_list)
			if(!QDELETED(old.weapon))
				to_chat(H, span_danger("[uppertext(weapon)]排斥我。我已经与另一把武器绑定了！"))
				H.dropItemToGround(weapon)
				return
		owner_ref = WEAKREF(H)
		if(skill_path)
			H.adjust_skillrank_up_to(skill_path, SKILL_LEVEL_MASTER)
		to_chat(H, span_danger("我感觉[weapon]与我结下了契约！"))
		var/obj/effect/proc_holder/spell/self/recall_bound/recall = new
		recall.weapon = weapon
		recall.name = "召回[weapon.name]"
		H.mind?.AddSpell(recall)
		return
	if(owner_ref.resolve() == H)
		return
	to_chat(H, span_danger("[uppertext(weapon)]憎恶我！"))
	H.dropItemToGround(weapon)

/obj/item/rogueweapon/huntingknife/idagger/steel/kris/zizo/conjured
	associated_skill = /datum/skill/combat/arcyne

/obj/item/rogueweapon/sword/long/zizo/conjured
	associated_skill = /datum/skill/combat/arcyne

/datum/action/cooldown/spell/conjure_arcyne_ward/zizo
	name = "异民护盾"
	desc = "以黑魔法加固奥术护盾。\
	护盾在受击前完全隐形，耐久为 400。\
	与普通奥术护盾一样，已穿戴护甲的部位优先由护甲防护，护盾无法自行修复。\
	再次施法可解除护盾。护盾解除或被击碎后开始冷却。"
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "ZIZO"
	source_aspect = null
	invocation_type = INVOCATION_NONE
	dismiss_invocation = ""
	regen_invocation = ""
	ward_type = /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/zizo

/datum/action/cooldown/spell/conjure_arcyne_ward/zizo/before_cast(atom/cast_on)
	var/mob/living/carbon/human/H = owner
	if((!conjured_ward || QDELETED(conjured_ward)) && H.skin_armor)
		to_chat(H, span_warning("已有护盾！"))
		return SPELL_CANCEL_CAST
	return ..()

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/zizo
	name = "异民护盾"
	desc = "以黑魔法加固的奥术护盾。"
	arcyne_armor_tier = ARCYNE_WARD_TIER_GREATER + 1
	armor = ARMOR_BRIGANDINE
	max_integrity = 400
	hidden = TRUE
	ward_color = "#7a1fa2"

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/zizo/flash_ward()
	if(!ward_owner)
		return
	hidden = FALSE
	ward_owner.remove_filter("zizo_ward_glow")
	ward_owner.add_filter("zizo_ward_glow", 2, list("type" = "outline", "color" = ward_color, "alpha" = 80, "size" = 1))
	addtimer(CALLBACK(src, PROC_REF(clear_flash)), 30 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/zizo/clear_flash()
	hidden = TRUE
	ward_owner?.remove_filter("zizo_ward_glow")

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/zizo/cleanup_ward()
	ward_owner?.remove_filter("zizo_ward_glow")
	return ..()

/datum/action/cooldown/spell/form_blade/avantyne
	name = "阿凡泰因之刃"
	desc = "召出阿凡泰因匕首或剑。按 Shift+G 切换形态，再次施法可将其驱散。"
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "ZIZO"
	attunement_school = null
	primary_resource_type = SPELL_COST_NONE
	invocation_type = INVOCATION_NONE
	shared_cooldown = "avantyne_blade"
	outline_color = "#2b0a3d"
	cooldown_time = 10 SECONDS
	associated_stat = null
	weapon_cast_penalized = FALSE
	ignore_armor_penalty = TRUE
	spell_requirements = SPELL_REQUIRES_HUMAN
	forms = list(
		list("label" = "匕首", "weapon" = /obj/item/rogueweapon/huntingknife/idagger/steel/kris/zizo/conjured),
		list("label" = "剑", "weapon" = /obj/item/rogueweapon/sword/long/zizo/conjured),
	)

/datum/action/cooldown/spell/form_blade/avantyne/cast(atom/cast_on)
	if(QDELETED(conjured_weapon))
		return ..()
	conjured_weapon.visible_message(span_warning("[conjured_weapon]碎裂消散了！"))
	qdel(conjured_weapon)
	conjured_weapon = null
	return TRUE

/obj/effect/proc_holder/spell/self/recall_bound
	name = "召回武器"
	desc = "将绑定的武器召回手中。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "ZIZO"
	recharge_time = 30 SECONDS
	chargedloop = null
	var/obj/item/weapon

/obj/effect/proc_holder/spell/self/recall_bound/cast(list/targets, mob/user = usr)
	. = ..()
	if(QDELETED(weapon))
		to_chat(user, span_warning("我的武器不见了。"))
		revert_cast()
		return FALSE
	if(weapon in user.held_items)
		to_chat(user, span_warning("它已经在我手里了。"))
		revert_cast()
		return FALSE
	var/obj/item/bodypart/part = weapon.loc
	if(istype(part))
		part.remove_embedded_object(weapon)
	else if(ismob(weapon.loc))
		var/mob/M = weapon.loc
		M.dropItemToGround(weapon)
	weapon.forceMove(get_turf(weapon))
	weapon.visible_message(span_warning("[weapon]突然消失了！"))
	if(!user.put_in_hands(weapon))
		weapon.forceMove(user.drop_location())
	user.visible_message(span_warning("[weapon]突然出现在[user]手中！"))
	return TRUE

/datum/intent/dagger/thrust/cult
	penfactor = PEN_BSTEEL

/datum/intent/dagger/cut/cult
	penfactor = PEN_BSTEEL

/datum/intent/sword/cut/sabre/cult
	penfactor = PEN_BSTEEL

/datum/intent/sword/thrust/sabre/cult
	penfactor = PEN_BSTEEL

/obj/item/rogueweapon/sword/long/noise
	name = "狂人之刃"
	desc = ""
	icon = 'icons/roguetown/cult/cultweapons64.dmi'
	icon_state = "hagsword"
	max_integrity = 9999
	resistance_flags = INDESTRUCTIBLE
	associated_skill = /datum/skill/combat/arcyne
	max_blade_int = 9999
	force = 25
	force_wielded = 35
	smeltresult = null
	sheathe_icon = "hagsword"
	special = /datum/special_intent/madman_delusion

/obj/item/rogueweapon/sword/long/noise/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/soulbound_weapon, /datum/skill/combat/arcyne)

/obj/item/rogueweapon/sword/long/noise/attack(mob/living/M, mob/living/user)
	update_force_dynamic()
	force_dynamic += force_dynamic * max(M.get_stress_amount(), 0) / 30
	return ..()

/datum/special_intent/madman_delusion
	name = "暴虐"
	desc = "使敌人陷入疯狂，不分敌我地痛下杀手。"
	tile_coordinates = list(list(0,0))
	use_clickloc = TRUE
	respect_adjacency = FALSE
	range = 6
	post_icon_state = "strike"
	pre_icon_state = "trap"
	delay = 0.5 SECONDS
	cooldown = 30 SECONDS
	stamcost = 20
	var/dam = 15
	var/frenzy_duration = 8 SECONDS

/datum/special_intent/madman_delusion/apply_hit(turf/T)
	for(var/mob/living/carbon/human/L in get_hearers_in_view(0, T))
		if(L != howner && L.stat != DEAD)
			apply_generic_weapon_damage(L, dam, "slash", BODY_ZONE_HEAD, bclass = BCLASS_CUT)
			if(HAS_TRAIT(L, TRAIT_IN_FRENZY))
				continue
			L.enter_frenzymod()
			addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living/carbon, exit_frenzymod)), frenzy_duration)
	..()

/obj/item/rogueweapon/huntingknife/idagger/steel
	var/active_intents =	list(/datum/intent/dagger/thrust/cult,/datum/intent/dagger/cut/cult)
	var/inactive_intents = list()

/obj/item/rogueweapon/huntingknife/idagger/steel/blood
	name = "奴隶之刃"
	desc = "普赛顿死后的乱世中，血坑里的奴隶用过这样的刀。刀上的血从未干过。"
	icon = 'icons/roguetown/cult/cultweapons32.dmi'
	icon_state = "graggardagger"
	sheathe_icon = "graggardagger"
	force = 25
	max_integrity = 9999
	resistance_flags = INDESTRUCTIBLE
	associated_skill = /datum/skill/combat/arcyne
	max_blade_int = 9999
	smeltresult = null
	possible_item_intents =	list(/datum/intent/dagger/thrust/cult,/datum/intent/dagger/cut/cult)

/obj/item/rogueweapon/huntingknife/idagger/steel/blood/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/soulbound_weapon, /datum/skill/combat/arcyne)

/obj/item/rogueweapon/huntingknife/idagger/steel/pitch
	name = "阿斯特拉塔之触"
	desc = "这柄匕首曾刺穿太阳女王的心脏。"
	icon = 'icons/roguetown/cult/cultweapons32.dmi'
	icon_state = "fdagger"
	sheathe_icon = "fdagger"
	force = 30
	max_integrity = 9999
	resistance_flags = INDESTRUCTIBLE
	associated_skill = /datum/skill/combat/arcyne
	max_blade_int = 9999
	smeltresult = null
	special = /datum/special_intent/ignite_dagger

/obj/item/rogueweapon/huntingknife/idagger/steel/pitch/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/soulbound_weapon, /datum/skill/combat/arcyne)

/datum/special_intent/ignite_dagger
	name = "点燃匕首"
	desc = "引动匕首中的漆黑之力，使刀刃变得灼热无比。"
	cooldown = 60 SECONDS
	stamcost = 25

/datum/special_intent/ignite_dagger/on_create()
	. = ..()
	howner.visible_message(span_warning("[howner]手中的[iparent]亮起刺目的光！"))
	var/obj/item/rogueweapon/huntingknife/idagger/steel/W = iparent
	active_timer = addtimer(CALLBACK(src, PROC_REF(effect_expire)), 30 SECONDS, TIMER_STOPPABLE)
	W.damtype = BURN
	W.force -= 15
	W.update_force_dynamic()
	if("[W.icon_state]_active" in icon_states(W.icon))
		W.icon_state = "[W.icon_state]_active"
	W.inactive_intents = W.possible_item_intents
	W.possible_item_intents = W.active_intents
	howner.update_a_intents()
	howner.regenerate_icons()
	playsound(W.loc, 'sound/items/firelight.ogg', 100)

/datum/special_intent/ignite_dagger/proc/effect_expire()
	howner.visible_message(span_warning("[iparent]的刀刃冷却了！"))
	var/obj/item/rogueweapon/huntingknife/idagger/steel/W = iparent
	W.damtype = BRUTE
	W.force += 15
	W.update_force_dynamic()
	W.icon_state = initial(W.icon_state)
	W.possible_item_intents = W.inactive_intents
	howner.update_a_intents()
	howner.regenerate_icons()
	playsound(W.loc, 'sound/items/firesnuff.ogg', 100)

/obj/item/rogueweapon/sword/sabre/rot
	name = "殒命之刃"
	desc = "这曾是一位美貌少女手中的正义之刃。如今早已变了模样。"
	icon = 'icons/roguetown/cult/cultweapons32.dmi'
	icon_state = "poisonsabre"
	force = 30
	max_integrity = 9999
	resistance_flags = INDESTRUCTIBLE
	associated_skill = /datum/skill/combat/arcyne
	max_blade_int = 9999
	var/active_intents =	list(/datum/intent/sword/cut/sabre/cult, /datum/intent/sword/thrust/sabre/cult)
	var/inactive_intents = list()
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	sellprice = 50
	smeltresult = null
	special = /datum/special_intent/coat_blade

/obj/item/rogueweapon/sword/sabre/rot/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/soulbound_weapon, /datum/skill/combat/arcyne)

/datum/special_intent/coat_blade
	name = "刀刃淬毒"
	desc = "引出军刀中的腐朽之力，使它重染昔日的剧毒。"
	cooldown = 120 SECONDS
	stamcost = 25

/datum/special_intent/coat_blade/on_create()
	. = ..()
	howner.visible_message(span_warning("[howner]手中的[iparent]刃上凝出一层毒壳！"))
	var/obj/item/rogueweapon/sword/sabre/rot/W = iparent
	active_timer = addtimer(CALLBACK(src, PROC_REF(effect_expire)), 30 SECONDS, TIMER_STOPPABLE)
	W.damtype = TOX
	W.force -= 22
	W.update_force_dynamic()
	W.inactive_intents = W.possible_item_intents
	W.possible_item_intents = W.active_intents
	howner.update_a_intents()
	W.icon_state = "poisonsabre_active"
	howner.regenerate_icons()
	playsound(W.loc, 'sound/misc/lava_death.ogg', 100)

/datum/special_intent/coat_blade/proc/effect_expire()
	howner.visible_message(span_warning("[iparent]上的毒壳剥落，掉在地上！"))
	var/obj/item/rogueweapon/sword/sabre/rot/W = iparent
	W.damtype = BRUTE
	W.force += 22
	W.possible_item_intents = W.inactive_intents
	howner.update_a_intents()
	W.update_force_dynamic()
	W.icon_state = "poisonsabre"
	playsound(W.loc, 'sound/magic/bladescrape.ogg', 100)

/obj/item/rogueweapon/mace/maul/toil
	name = "遗忘之械"
	desc = "远古永世之时，一名以盗窃为生的工匠用过的扳手。"
	icon_state = "bronzewrench"
	icon = 'icons/roguetown/cult/cultweapons64.dmi'
	force = 25
	force_wielded = 40
	wdefense_wbonus = 5
	minstr = 8
	max_integrity = 9999
	resistance_flags = INDESTRUCTIBLE
	associated_skill = /datum/skill/combat/arcyne
	w_class = WEIGHT_CLASS_BULKY
	smeltresult = null
	swingsound = BLUNTWOOSH_LARGE
	gripsprite = TRUE
	wlength = WLENGTH_LONG
	wbalance = WBALANCE_HEAVY
	grid_width = null
	grid_height = null
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	walking_stick = TRUE
	var/list/obj/structure/toilturret/turrets = list()
	var/max_turrets = 3

/obj/item/rogueweapon/mace/maul/toil/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/soulbound_weapon, /datum/skill/combat/arcyne)

/obj/item/rogueweapon/mace/maul/toil/equipped(mob/user, slot, initial)
	. = ..()
	if(slot != ITEM_SLOT_HANDS || !user.mind)
		return
	user.mind.AddSpell(new /datum/action/cooldown/spell/deploy_turret)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/direct_turrets)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/scrap_turrets)

/obj/item/rogueweapon/mace/maul/toil/dropped(mob/user, silent)
	. = ..()
	if(!user.mind)
		return
	user.mind.RemoveSpell(/datum/action/cooldown/spell/deploy_turret)
	user.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/direct_turrets)
	user.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/scrap_turrets)

/obj/effect/proc_holder/spell/self/direct_turrets
	name = "指定炮塔目标"
	desc = "命令炮塔瞄准指定的人。"
	recharge_time = 10 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/self/direct_turrets/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/obj/item/rogueweapon/mace/maul/toil/W = user.get_active_held_item()
	if(!istype(W))
		to_chat(user, span_warning("我得拿着遗忘之械。"))
		revert_cast()
		return FALSE
	var/list/possible = list()
	for(var/mob/living/carbon/human/H in oview(7, user))
		possible += H
	if(!length(possible))
		to_chat(user, span_warning("没有发现目标。"))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/target = input(user, "选择目标", "齐佐") as null|anything in possible
	if(!target)
		revert_cast()
		return FALSE
	for(var/obj/structure/toilturret/existing as anything in W.turrets.Copy())
		if(QDELETED(existing))
			W.turrets -= existing
			continue
		existing.forced_target = target
	to_chat(user, span_notice("炮塔已锁定[target]。"))
	return TRUE

/obj/effect/proc_holder/spell/self/scrap_turrets
	name = "拆除炮塔"
	desc = "拆解所有哨戒炮塔。"
	recharge_time = 5 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/self/scrap_turrets/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/obj/item/rogueweapon/mace/maul/toil/W = user.get_active_held_item()
	if(!istype(W))
		to_chat(user, span_warning("我得拿着遗忘之械。"))
		revert_cast()
		return FALSE
	for(var/obj/structure/toilturret/existing as anything in W.turrets.Copy())
		qdel(existing)
	W.turrets = list()
	to_chat(user, span_notice("我的哨戒炮塔都拆掉了。"))
	return TRUE

/datum/action/cooldown/spell/deploy_turret
	name = "部署炮塔"
	desc = "架起一座哨戒炮塔。"
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "toil"
	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 3
	charge_required = TRUE
	charge_time = 4 SECONDS
	charge_swingdelay_type = SWINGDELAY_CANCEL
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	cooldown_time = 20 SECONDS

/datum/action/cooldown/spell/deploy_turret/cast(atom/cast_on)
	. = ..()
	var/obj/item/rogueweapon/mace/maul/toil/W = owner.get_active_held_item()
	if(!istype(W))
		to_chat(owner, span_warning("我得拿着遗忘之械。"))
		return FALSE
	for(var/obj/structure/toilturret/existing as anything in W.turrets.Copy())
		if(QDELETED(existing))
			W.turrets -= existing
	if(length(W.turrets) >= W.max_turrets)
		to_chat(owner, span_warning("炮塔数量已达上限！"))
		return FALSE
	var/turf/T = get_turf(cast_on)
	if(!T || T.density || isopenspace(T))
		to_chat(owner, span_warning("这里放不下！"))
		return FALSE
	W.turrets += new /obj/structure/toilturret(T, owner, W)
	to_chat(owner, span_notice("炮塔嗡的一声启动了！"))
	return TRUE

/obj/structure/toilturret
	name = "齿轮炮塔"
	desc = "你敢肯定从未见过这东西，它的轮廓却熟悉得令人心悸。"
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "ocular_warden"
	density = TRUE
	anchored = TRUE
	max_integrity = 150
	var/mob/living/carbon/human/owner
	var/obj/item/rogueweapon/mace/maul/toil/source_wrench
	var/range = 5
	var/cooldown = 0
	var/active = TRUE
	var/mob/living/carbon/human/forced_target

/obj/structure/toilturret/Initialize(mapload, mob/living/carbon/human/builder, obj/item/rogueweapon/mace/maul/toil/wrench)
	. = ..()
	owner = builder
	source_wrench = wrench
	START_PROCESSING(SSobj, src)

/obj/structure/toilturret/Destroy()
	STOP_PROCESSING(SSobj, src)
	source_wrench?.turrets -= src
	source_wrench = null
	owner = null
	forced_target = null
	return ..()

/obj/structure/toilturret/attack_right(mob/living/user, params)
	. = ..()
	if(!istype(user.get_active_held_item(), /obj/item/rogueweapon/mace/maul/toil))
		return
	active = !active
	if(active)
		icon_state = "ocular_warden"
	else
		icon_state = "ocular_warden_unwrenched"

/obj/structure/toilturret/process()
	if(!active)
		return
	if(world.time < cooldown)
		return
	if(!owner)
		qdel(src)
		return
	var/mob/living/carbon/human/target
	if(forced_target && !QDELETED(forced_target) && forced_target.stat < SOFT_CRIT && (forced_target in view(range, src)))
		target = forced_target
	else
		for(var/mob/living/carbon/human/H in view(range, src))
			if(H == owner || is_zizo(H) || H.stat >= SOFT_CRIT)
				continue
			target = H
			break
	if(!target)
		return
	cooldown = world.time + 20
	visible_message(span_danger("[src]瞄准了[target]！"))
	var/turf/startloc = get_turf(src)
	var/obj/projectile/P = new /obj/projectile/toilbolt(startloc)
	playsound(src, 'sound/combat/hits/onmetal/metalimpact (1).ogg', 60, TRUE)
	P.starting = startloc
	P.fired_from = src
	P.yo = target.y - startloc.y
	P.xo = target.x - startloc.x
	P.original = target
	P.preparePixelProjectile(target, src)
	P.fire()

/obj/projectile/toilbolt
	name = "弩矢"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball_proj"
	damage = 15
	damage_type = BRUTE
	armor_penetration = 10
	range = 15
	hitsound = 'sound/combat/hits/hi_bolt (1).ogg'
	flag = "piercing"
	speed = 2

/obj/item/rogueweapon/contraption/linker/mace/big/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6, "sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/datum/intent/dream_beam
	name = "梦境射线"
	blade_class = null
	icon_state = "inshoot"
	tranged = TRUE
	noaa = TRUE
	no_attack = TRUE
	warnie = "aimwarn"
	chargetime = 3 SECONDS
	chargedrain = 2
	charging_slowdown = 3
	no_early_release = TRUE
	chargedloop = /datum/looping_sound/invokegen

/datum/intent/dream_fling
	name = "抛掷"
	blade_class = null
	icon_state = "inmove"
	tranged = TRUE
	noaa = TRUE
	no_attack = TRUE
	chargetime = 1 SECONDS
	chargedrain = 1
	charging_slowdown = 2
	no_early_release = TRUE

/datum/intent/dream_fling/get_chargetime()
	var/obj/item/rogueweapon/zizowand/wand = masteritem
	if(istype(wand) && wand.flung)
		return chargetime
	return 0

/obj/projectile/magic/dream_beam
	name = "梦境射线"
	tracer_type = /obj/effect/projectile/tracer/bloodsteal
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	damage = 100
	damage_type = BRUTE
	woundclass = BCLASS_STAB
	nodamage = FALSE
	speed = 0.3
	flag = "piercing"
	hitsound = 'sound/magic/obeliskbeam.ogg'
	light_color = "#9400D3"
	light_outer_range = 7
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	var/hits = 0

/obj/projectile/magic/dream_beam/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src]一碰到[target]便消散了！"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	if(!ismob(target))
		qdel(src)
		return . || BULLET_ACT_HIT
	hits++
	damage = round(initial(damage) * 0.75)
	if(hits >= 4)
		qdel(src)

/obj/projectile/energy/dream_shroom
	name = "梦境孢子"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "arcyne_bolt"
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	damage = 0
	nodamage = TRUE
	color = "#9b30ff"
	speed = MAGE_PROJ_FAST
	hitsound = null
	arcshot = TRUE

/obj/projectile/energy/dream_shroom/on_hit(target)
	..()
	var/turf/T = get_turf(src)
	if(!T || T.density)
		return
	var/obj/structure/zizo_bane/shroom = new(T)
	QDEL_IN(shroom, 2 MINUTES)

/datum/special_intent/dream_shroom
	name = "梦菇"
	desc = "射出一枚齐佐之灾的孢子！"
	use_clickloc = TRUE
	range = 7
	cooldown = 30 SECONDS

/datum/special_intent/dream_shroom/on_create()
	var/obj/projectile/energy/dream_shroom/spore = new(get_turf(howner))
	spore.firer = howner
	spore.fired_from = get_turf(howner)
	spore.def_zone = howner.zone_selected
	spore.range = max(1, get_dist_euclidian(click_loc, howner))
	spore.preparePixelProjectile(click_loc, howner)
	spore.fire()

/obj/item/rogueweapon/zizowand
	name = "巫木"
	desc = "雪精灵女王送给一位大能巫师的礼物。它曾让翻腾的大海陷入沉睡。"
	icon = 'icons/roguetown/cult/cultweapons32.dmi'
	icon_state = "zizowand"
	force = 15
	possible_item_intents = list(MACE_STRIKE, /datum/intent/dream_beam, /datum/intent/dream_fling)
	gripped_intents = null
	sharpness = IS_BLUNT
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	associated_skill = /datum/skill/combat/arcyne
	wdefense = 4
	max_integrity = 9999
	resistance_flags = INDESTRUCTIBLE
	smeltresult = null
	special = /datum/special_intent/dream_shroom
	var/fling_damage = 40
	var/datum/weakref/flung

/obj/item/rogueweapon/zizowand/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/soulbound_weapon, /datum/skill/combat/arcyne)

/obj/item/rogueweapon/zizowand/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -7,"nx" = 11,"ny" = -6,"wx" = -1,"wy" = -6,"ex" = 3,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/zizowand/proc/clear_fling()
	var/obj/item/I = flung?.resolve()
	I?.remove_filter("dream_fling")
	flung = null

/obj/item/rogueweapon/zizowand/afterattack(atom/target, mob/living/user, flag)
	. = ..()
	if(!isliving(user) || get_dist(user, target) > 7)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(istype(user.used_intent, /datum/intent/dream_beam))
		if(user.client?.chargedprog < 100)
			return
		playsound(user, 'sound/magic/soulshot.ogg', 100, TRUE)
		var/obj/projectile/magic/dream_beam/beam = new(get_turf(user))
		beam.firer = user
		beam.fired_from = get_turf(user)
		beam.def_zone = user.zone_selected
		beam.preparePixelProjectile(target, user)
		beam.fire()
		return
	if(!istype(user.used_intent, /datum/intent/dream_fling))
		return
	var/obj/item/held = flung?.resolve()
	if(!held)
		if(!isitem(target))
			return
		var/obj/item/I = target
		if(!isturf(I.loc) || I.anchored)
			return
		I.add_filter("dream_fling", 2, list("type" = "outline", "color" = "#9b30ff", "size" = 1))
		flung = WEAKREF(I)
		addtimer(CALLBACK(src, PROC_REF(clear_fling)), 15 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		return
	if(target == user || !isturf(held.loc))
		clear_fling()
		return
	if(user.client?.chargedprog < 100)
		return
	held.remove_filter("dream_fling")
	var/old_force = held.throwforce
	held.throwforce = fling_damage
	held.throw_at(target, 8, 2, user, TRUE, FALSE, VARSET_CALLBACK(held, throwforce, old_force))
	flung = null

/datum/intent/spear/cut/scythe
	reach = 3
	damfactor = 1

/obj/item/rogueweapon/spear/bite
	force = 20
	force_wielded = 30
	possible_item_intents = list(SPEAR_BASH)
	gripped_intents = list(/datum/intent/spear/cut/scythe, SPEAR_BASH, MACE_STRIKE)
	name = "雪镰"
	desc = "一柄收割巨菇的大镰刀。它的主人出身于幽暗地域的农家，曾走遍古老洞窟的每个角落。"
	icon_state = "silverpeasantscythe"
	icon = 'icons/roguetown/cult/cultweapons64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	max_integrity = 9999
	resistance_flags = INDESTRUCTIBLE
	associated_skill = /datum/skill/combat/arcyne
	max_blade_int = 9999
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = null
	walking_stick = TRUE
	wdefense = 6
	thrown_bclass = BCLASS_BLUNT
	throwforce = 10
	special = /datum/special_intent/scythe_cone

/obj/item/rogueweapon/spear/bite/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/soulbound_weapon, /datum/skill/combat/arcyne)

/datum/special_intent/scythe_cone
	name = "霜雪架势"
	desc = "以重击令冰霜蔓过地面。"
	tile_coordinates = list(
		list(0,0),
		list(-1,1), list(0,1), list(1,1),
		list(-2,2), list(-1,2), list(0,2), list(1,2), list(2,2)
	)
	post_icon_state = "shieldsparkles"
	pre_icon_state = "frost"
	delay = 0.6 SECONDS
	cooldown = 25 SECONDS
	stamcost = 20
	var/dam = 15

/datum/special_intent/scythe_cone/apply_hit(turf/T)
	for(var/mob/living/carbon/human/L in get_hearers_in_view(0, T))
		if(L != howner)
			apply_generic_weapon_damage(L, dam, "slash", BODY_ZONE_CHEST, bclass = BCLASS_CUT)
			L.apply_status_effect(/datum/status_effect/buff/frostbite)
	..()

/obj/item/rogueweapon/scythe/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

// STRAND

/obj/effect/proc_holder/spell/invoked/dream_jaunt
	name = "梦游"
	desc = "带着你抓住的人一同进入梦境。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "jaunt"
	range = 0
	movement_interrupt = FALSE
	chargedloop = null
	recharge_time = 60 SECONDS
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/dream_jaunt/cast(list/targets, mob/living/user)
	. = ..()
	if(!ishuman(user))
		return FALSE
	send_to_dream(user)
	if(ishuman(user.pulling))
		send_to_dream(user.pulling)
	return TRUE

/proc/send_to_dream(mob/living/carbon/human/target, status_type = /datum/status_effect/dream_teleport/strand)
	var/area/dream_area = GLOB.areas_by_type[/area/rogue/underworld/dream]
	var/turf/origin = get_turf(target)
	if(!dream_area || !origin)
		return
	var/list/safe_turfs = list()
	for(var/turf/T in get_area_turfs(dream_area))
		if(!T.density)
			safe_turfs += T
	if(!safe_turfs.len || !do_teleport(target, pick(safe_turfs)))
		return
	GLOB.players_in_dream |= target
	origin.visible_message(span_danger("[target]消失了！"))
	playsound(origin, 'sound/misc/area.ogg')
	target.apply_status_effect(status_type, origin)

/datum/status_effect/dream_teleport/strand
	duration = 30 SECONDS

/datum/status_effect/dream_teleport/recall
	duration = 3 MINUTES

/mob/living/simple_animal/hostile/rogue/dreamfiend/nightmare
	faction = list("dream", "crabs", "zizo_cult")

/datum/status_effect/dream_teleport/strand/nightmare/on_creation(mob/living/new_owner, turf/origin)
	if(prob(50) && length(GLOB.zizo_reality_rends))
		var/list/near_rend = list()
		for(var/turf/open/T in range(4, pick(GLOB.zizo_reality_rends)))
			if(!T.density)
				near_rend += T
		if(length(near_rend))
			origin = pick(near_rend)
	new_owner.SetSleeping(0)
	summon_dreamfiend(new_owner, null, /mob/living/simple_animal/hostile/rogue/dreamfiend/nightmare)
	return ..(new_owner, origin)

/datum/status_effect/dream_teleport/strand/nightmare/on_remove()
	. = ..()
	for(var/mob/living/simple_animal/hostile/rogue/dreamfiend/nightmare/F in world)
		if(F.ai_controller?.blackboard[BB_MAIN_TARGET] == owner)
			qdel(F)

/datum/ritual/strand/dream_jaunt
	name = "Dream Jaunt"
	icon_type = /mob/living/simple_animal/hostile/rogue/dreamfiend/nightmare
	desc = "学会将自己和抓住的人传送到一处独立空间，停留 30 秒。"
	passive = TRUE
	research_cost = 3

/datum/ritual/strand/dream_jaunt/apply_passive(mob/living/carbon/human/H)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dream_jaunt)
	return

/datum/ritual/strand/strandsend
	name = "Passage"
	icon_type = /obj/effect/decal/cleanable/sigil
	node_state = "strand2"
	desc = "举行仪式绘出传送符印。激活后，符印上的一切都会被传送至与之相连的另一枚符印。"
	center_requirement = /mob/living/carbon/human

/datum/ritual/strand/strandsend/invoke(mob/living/user, turf/center)
	var/obj/effect/decal/cleanable/sigil/S = locate() in center
	if(!S)
		return
	var/poo = new /obj/effect/temp_visual/opengate/fivesec(center)
	playsound(user, 'sound/villain/littlescary2.ogg', 60, TRUE)
	if(!do_after(user, 5 SECONDS))
		qdel(poo)
		return
	S.set_sigil_type("Portal")
	to_chat(user, span_notice("一只眼，就是一条通道。"))
	S.choose_link(user)

/datum/ritual/strand/strandrecall
	name = "Curse of Recall"
	icon_type = /obj/item/natural/worms/leech
	desc = "将你和目标传送到一处独立空间，停留 3 分钟。双方抓住的人也会同行。需要一条吸过目标血液的水蛭。"
	center_requirement = /obj/item/natural/worms/leech
	keep_center = TRUE

/datum/ritual/strand/strandrecall/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	var/mob/living/carbon/human/victim = remnant.fed_from
	if(!curse_target(victim))
		to_chat(user, span_warning("目标受到了保护，无法再施加诅咒。"))
		return
	qdel(remnant)
	to_chat(user, span_notice("无人能抗拒梦的召唤。我有 1 分钟准备，届时我抓住的人将随我同行。"))
	to_chat(victim, span_userdanger("我感觉有什么可怕的东西正在逼近。我有 1 分钟准备，届时我抓住的人将随我同行。"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(dreamcall), user, victim), 1 MINUTES)

/proc/dreamcall(mob/living/user, mob/living/victim)
	for(var/mob/living/M in list(user, victim))
		if(QDELETED(M) || !ishuman(M))
			continue
		send_to_dream(M, /datum/status_effect/dream_teleport/recall)
		if(ishuman(M.pulling))
			send_to_dream(M.pulling, /datum/status_effect/dream_teleport/recall)

// TOIL

/obj/effect/proc_holder/spell/invoked/projectile/toil_mend
	name = "修复术"
	desc = "射出一道电光，治疗目标并修复其装备。"
	clothes_req = FALSE
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "toil"
	sound = 'sound/magic/lightning.ogg'
	range = 7
	projectile_type = /obj/projectile/magic/mendbolt
	chargetime = 15
	recharge_time = 10 SECONDS
	chargedloop = null

/obj/projectile/magic/mendbolt
	name = "愈合电光"
	tracer_type = /obj/effect/projectile/tracer/disabler
	color = "#ffb347"
	hitscan_light_color_override = "#ffb347"
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	light_color = "#ffb347"
	damage = 0
	nodamage = TRUE
	speed = 0.3
	flag = "magic"
	light_outer_range = 7

/obj/projectile/magic/mendbolt/on_hit(target)
	. = ..()
	if(ismob(target) && isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check())
			visible_message(span_warning("[src]一碰到[target]便消散了！"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		L.apply_status_effect(/datum/status_effect/buff/healing, 10, TRUE)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			for(var/obj/item/I in H.get_equipped_items())
				I.obj_integrity = min(I.obj_integrity + (I.max_integrity * 0.2), I.max_integrity)
		to_chat(L, span_notice("我的伤口愈合了！"))
		ysis_effect(L, 4)
	qdel(src)

/datum/ritual/toil/progress
	name = "Mend"
	icon_type = /obj/effect/proc_holder/spell/invoked/projectile/toil_mend
	desc = "学会治疗他人并修复其装备的法术。无法对自己使用。"
	passive = TRUE
	research_cost = 3

/datum/ritual/toil/progress/apply_passive(mob/living/carbon/human/H)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/toil_mend)
	return

/datum/ritual/toil/summonysis
	name = "Summon Ysis"
	icon_type = /obj/structure/ysis
	desc = "召来一台愈合仪，任何人都能启动它来治疗自己并修复装备。"
	center_requirement = /obj/item/bedsheet
	research_cost = 5

/datum/ritual/toil/summonysis/invoke(mob/living/user, turf/center)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()
	new /obj/structure/ysis(center)
	to_chat(user, span_notice("架起愈合仪。"))

/proc/ysis_effect(atom/movable/target, healings)
	var/datum/effect_system/spark_spread/S = new(target)
	S.set_up(3, 1, target)
	S.start()
	for(var/i in 1 to healings)
		new /obj/effect/temp_visual/heal(get_turf(target), "#ffb347")
	target.add_filter("ysis_glow", 2, list(type = "outline", color = "#ffb347", size = 2))
	target.transition_filter("ysis_glow", list(size = 0), 2 SECONDS)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom/movable, remove_filter), "ysis_glow"), 2 SECONDS)

/obj/structure/ysis
	name = "愈合仪"
	desc = "摸上去很舒服！"
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "interdiction_lens"
	density = TRUE
	anchored = TRUE
	max_integrity = 200
	var/active = FALSE
	var/ready_time = 0
	var/cooldown_time = 45 SECONDS

/obj/structure/ysis/examine(mob/user)
	. = ..()
	if(world.time < ready_time)
		. += span_warning("请等待 [round((ready_time - world.time) / 10)] 秒。")

/obj/structure/ysis/update_icon()
	. = ..()
	if(active)
		icon_state = "interdiction_lens_active"
	else if(world.time < ready_time)
		icon_state = "interdiction_lens_unwrenched"
	else
		icon_state = "interdiction_lens"

/obj/structure/ysis/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user) || user.stat == DEAD)
		return
	if(active)
		to_chat(user, span_warning("[src]正在给别人治疗。"))
		return
	if(world.time < ready_time)
		to_chat(user, span_warning("[src]尚未恢复！"))
		return
	var/mob/living/carbon/human/H = user
	to_chat(H, span_notice("愈合仪开始为我治疗……"))
	active = TRUE
	update_icon()
	set_light(3, 1, 1.5, l_color = "#ffb347")
	ysis_effect(src, 0)
	playsound(src, 'sound/magic/charging.ogg', 60, TRUE)
	var/finished = do_after(H, 5 SECONDS, target = src)
	active = FALSE
	set_light(0)
	if(!finished)
		update_icon()
		return
	var/datum/status_effect/buff/healing/heal = H.apply_status_effect(/datum/status_effect/buff/healing, 10, TRUE)
	if(heal)
		heal.duration = world.time + 5 SECONDS
	for(var/obj/item/I in H.get_equipped_items())
		I.obj_integrity = min(I.obj_integrity + (I.max_integrity * 0.2), I.max_integrity)
	to_chat(H, span_notice("愈合仪治好了我。"))
	playsound(src, 'sound/magic/lightning.ogg', 60, TRUE)
	ysis_effect(H, 8)
	flick("interdiction_lens_discharged", src)
	ready_time = world.time + cooldown_time
	update_icon()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon)), cooldown_time)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ysis_effect), src, 0), cooldown_time)

/datum/ritual/toil/fulmenor
	name = "Curse of Fulmenor"
	icon_type = /obj/item/natural/worms/leech
	desc = "让目标变成力大无穷、能够再生的怪物，随机袭击他人，持续 1 分钟。需要一条吸过目标血液的水蛭。"
	center_requirement = /obj/item/natural/worms/leech
	keep_center = TRUE
	research_cost = 5

/datum/ritual/toil/fulmenor/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	var/mob/living/carbon/human/victim = remnant.fed_from
	if(!curse_target(victim))
		to_chat(user, span_warning("目标受到了保护，无法再施加诅咒。"))
		return
	qdel(remnant)
	victim.apply_status_effect(/datum/status_effect/fulmenor)
	victim.emote("scream")
	to_chat(victim, span_userdanger("偏偏在这可怕的夜里遭了诅咒。"))
	to_chat(user, span_notice("就让这怪物大闹一场吧。"))

/datum/status_effect/fulmenor
	id = "fulmenor"
	duration = 1 MINUTES
	tick_interval = 5 SECONDS
	alert_type = null

/datum/status_effect/fulmenor/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.change_stat(STATKEY_STR, 6)
	H.change_stat(STATKEY_CON, 6)
	ADD_TRAIT(H, TRAIT_MONSTROUS, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SILVER_WEAK, "fulmenor")
	H.enter_frenzymod()
	to_chat(H, span_notice("我想伤人！"))
	return TRUE

/datum/status_effect/fulmenor/tick()
	var/mob/living/carbon/human/H = owner
	H.heal_overall_damage(10, 10)

/datum/status_effect/fulmenor/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.exit_frenzymod()
	H.change_stat(STATKEY_STR, -6)
	H.change_stat(STATKEY_CON, -6)
	REMOVE_TRAIT(H, TRAIT_MONSTROUS, TRAIT_GENERIC)
	REMOVE_TRAIT(H, TRAIT_SILVER_WEAK, "fulmenor")
	to_chat(H, span_notice("那股怪物般的饥渴消退了。"))

// BITE

/datum/ritual/bite/necromancy
	name = "Necromancy"
	icon_type = /obj/item/natural/bone
	desc = "习得死灵法术，并学会用黑暗水晶召唤有自主意识的骷髅。"
	passive = TRUE
	spells = list(/obj/effect/proc_holder/spell/invoked/gravemark, /obj/effect/proc_holder/spell/invoked/command_undead, /obj/effect/proc_holder/spell/invoked/raise_undead_formation/necromancer, /datum/action/cooldown/spell/bonechill, /datum/action/cooldown/spell/bonemend)

/datum/ritual/bite/necromancy/apply_passive(mob/living/carbon/human/H)
	H.mind.current.faction |= "[H.name]_faction"
	H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_EXPERT)
	H.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/raise_undead_formation/lesser)

/datum/ritual/bite/resurrection
	name = "Resurrection"
	icon_type = /obj/item/organ/heart
	desc = "将死者置于中央符印，在北侧符印放一枚黑暗水晶，即可将其复活。缺少水晶时，死者将化作高阶尸鬼。它们有神智，能使用物品和武器，但仍有尸鬼的一切弱点，也未必忠于你。"
	center_requirement = /mob/living/carbon/human
	research_cost = 5

/datum/ritual/bite/resurrection/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/corpse = locate() in center.contents
	if(!corpse || corpse.stat != DEAD || !corpse.mind)
		to_chat(user, span_warning("你需要一具尸体。"))
		return
	playsound(get_turf(corpse), 'sound/magic/magnet.ogg', 80, TRUE)
	var/obj/item/necro_relics/necro_crystal/crystal = locate() in get_step(center, NORTH)
	if(crystal)
		qdel(crystal)
		corpse.revive(full_heal = TRUE, admin_revive = TRUE)
		ADD_TRAIT(corpse, TRAIT_ROTMAN, TRAIT_GENERIC)
		corpse.visible_message(span_notice("[corpse]死而复生了！"))
		return
	corpse.set_blood_volume(BLOOD_VOLUME_NORMAL)
	corpse.setOxyLoss(0, updating_health = FALSE, forced = TRUE)
	corpse.setToxLoss(0, updating_health = FALSE, forced = TRUE)
	corpse.adjustBruteLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
	corpse.adjustFireLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
	corpse.heal_wounds(INFINITY)
	corpse.zombie_check_can_convert()
	var/datum/antagonist/zombie/Z = corpse.mind.has_antag_datum(/datum/antagonist/zombie)
	if(Z)
		Z.wake_zombie(TRUE)
	REMOVE_TRAIT(corpse, TRAIT_CHUNKYFINGERS, "/datum/antagonist/zombie")
	REMOVE_TRAIT(corpse, TRAIT_ZOMBIE_SPEECH, "/datum/antagonist/zombie")
	corpse.emote("scream")
	to_chat(corpse, span_userdanger("我觉得自己比寻常尸鬼更有能耐。"))

/datum/ritual/bite/thanatophobia
	name = "Curse of Thanatophobia"
	icon_type = /obj/item/natural/worms/leech
	desc = "使目标极度畏惧骷髅和尸体，持续 10 分钟。需要一条吸过目标血液的水蛭。"
	center_requirement = /obj/item/natural/worms/leech
	keep_center = TRUE
	research_cost = 5

/datum/ritual/bite/thanatophobia/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	if(!curse_target(remnant.fed_from))
		to_chat(user, span_warning("目标受到了保护，无法再施加诅咒。"))
		return
	remnant.fed_from.apply_status_effect(/datum/status_effect/debuff/thanatophobia)
	to_chat(remnant.fed_from, span_danger("偏偏在这可怕的夜里遭了诅咒。"))
	remnant.fed_from.emote("scream")
	qdel(remnant)
	to_chat(user, span_notice("他们必将畏惧我的领域！"))

/datum/status_effect/debuff/thanatophobia
	id = "thanatophobia"
	duration = 10 MINUTES
	tick_interval = 10 SECONDS
	alert_type = null

/datum/status_effect/debuff/thanatophobia/tick()
	var/mob/living/carbon/human/H = owner
	if(!ishuman(H))
		return
	for(var/mob/living/L in view(5, H))
		if(L == H)
			continue
		if(L.stat == DEAD || L.mind?.has_antag_datum(/datum/antagonist/skeleton))
			to_chat(H, span_userdanger("我不能死！我受不了看见死人！"))
			H.emote("scream")
			H.adjustStaminaLoss(10)
			step_away(H, L, 10)
			break

// ROT

/obj/effect/proc_holder/spell/self/rot_transfuse
	name = "血液转注"
	desc = "把自己血液中的所有试剂转移给抓住的人。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "transfuse"
	recharge_time = 5 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/self/rot_transfuse/cast(list/targets, mob/user = usr)
	. = ..()
	var/obj/item/grabbing/G = user.get_active_held_item()
	if(!istype(G) || !isliving(G.grabbed))
		to_chat(user, span_warning("我得先抓住一个人。"))
		revert_cast()
		return FALSE
	var/mob/living/victim = G.grabbed
	if(user.reagents && victim.reagents && user.reagents.total_volume)
		user.reagents.trans_to(victim, user.reagents.total_volume, method = INJECT)
	to_chat(user, span_notice("我把血中的药物注入[victim]体内。"))
	return TRUE

/datum/ritual/rot/transfuse
	name = "Rot Initiate"
	icon_type = /obj/effect/proc_holder/spell/self/rot_transfuse
	desc = "学会将血中的药物注入你抓住的人体内，并习得次级腐化术。你将对毒素免疫。"
	passive = TRUE
	research_cost = 3

/datum/ritual/rot/transfuse/apply_passive(mob/living/carbon/human/H)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/rot_transfuse)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/lesser_blight)
	ADD_TRAIT(H, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	return

/turf/open/floor/rogue/naturalstone/rot
	name = "神经丝束"
	desc = "一团搏动的血肉，稍一触碰便颤抖扭动。"
	icon = 'icons/roguetown/cult/blightfloor.dmi'
	icon_state = "flesh_tile-0"
	transform = matrix(1, 0, -16, 0, 1, -16)
	layer = HIGH_TURF_LAYER
	color = "#bf5252"
	smooth = SMOOTH_FALSE

/turf/open/floor/rogue/naturalstone/rot/Initialize(mapload)
	. = ..()
	underlays += mutable_appearance('icons/turf/roguefloor.dmi', "digstone")
	update_flesh()
	for(var/d in GLOB.cardinals)
		var/turf/open/floor/rogue/naturalstone/rot/N = get_step(src, d)
		if(istype(N))
			N.update_flesh()

/turf/open/floor/rogue/naturalstone/rot/proc/update_flesh()
	var/mask = 0
	for(var/d in GLOB.cardinals)
		if(istype(get_step(src, d), /turf/open/floor/rogue/naturalstone/rot))
			mask |= d
	icon_state = "flesh_tile-[mask]"

/turf/closed/mineral/rogue/blight
	name = "血肉之墙"
	icon = 'icons/roguetown/cult/blightwall.dmi'
	smooth_icon = 'icons/roguetown/cult/blightwall.dmi'
	icon_state = "blightwall"
	color = "#bf5252"
	smooth = SMOOTH_FALSE

/turf/open/floor/rogue/naturalstone/rot/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/H = AM
	H.apply_status_effect(/datum/status_effect/debuff/rotground)
	var/obj/effect/temp_visual/small_smoke/puff = new(src)
	puff.color = "#7a2a2a"

/datum/status_effect/debuff/rotground
	id = "rotground"
	duration = -1
	tick_interval = 3 SECONDS
	alert_type = null
	var/elapsed = 0
	var/obj/effect/abstract/particle_holder/aura

/datum/status_effect/debuff/rotground/on_apply()
	. = ..()
	if(!is_zizo(owner))
		aura = new(owner, /particles/zizo_rot, PARTICLE_ATTACH_MOB)

/datum/status_effect/debuff/rotground/on_remove()
	. = ..()
	QDEL_NULL(aura)

/datum/status_effect/debuff/rotground/tick()
	var/mob/living/carbon/human/H = owner
	var/turf/T = get_turf(H)
	if(!ishuman(H) || !istype(T, /turf/open/floor/rogue/naturalstone/rot))
		qdel(src)
		return
	new /obj/effect/temp_visual/cult/turf/floor(T)
	if(is_zizo(H))
		H.heal_overall_damage(2, 2)
		H.heal_wounds(2)
		H.adjustStaminaLoss(-5)
		H.energy_add(20)
		new /obj/effect/temp_visual/heal(T, "#bf5252")
		if(prob(10))
			to_chat(H, span_notice("腐朽的芬芳令我重焕生机！"))
		return
	elapsed += 3
	H.adjustOxyLoss(3)
	H.adjustStaminaLoss(5)
	if(prob(10))
		to_chat(H, span_danger("臭死了！我喘不过气！"))
	if(elapsed > 30 && prob(10))
		H.vomit(50)

/obj/structure/blight_pillar
	name = "腐朽之柱"
	desc = "病肉与白骨熔成的柱子。摧毁它！"
	icon = 'icons/roguetown/maniac/creations.dmi'
	icon_state = "creation1"
	anchored = TRUE
	density = TRUE
	max_integrity = 300
	var/radius = 3
	var/list/turf_data = list()

/obj/structure/blight_pillar/Initialize(mapload)
	. = ..()
	new /obj/effect/abstract/particle_holder(src, /particles/zizo_rot)
	for(var/turf/T in range(radius, get_turf(src)))
		addtimer(CALLBACK(src, PROC_REF(blight_turf), T), get_dist(src, T) * 8)

/obj/structure/blight_pillar/proc/blight_turf(turf/T)
	if(QDELETED(src))
		return
	if(isclosedturf(T) && !istype(T, /turf/closed/indestructible))
		turf_data[T] = T.type
		T.ChangeTurf(/turf/closed/mineral/rogue/blight, flags = CHANGETURF_IGNORE_AIR)
	else if(isopenturf(T) && !istype(T, /turf/open/floor/rogue/naturalstone/rot))
		turf_data[T] = T.type
		T.ChangeTurf(/turf/open/floor/rogue/naturalstone/rot, flags = CHANGETURF_IGNORE_AIR)
	else
		return
	var/obj/effect/temp_visual/small_smoke/puff = new(T)
	puff.color = "#7a2a2a"

/obj/structure/blight_pillar/Destroy()
	for(var/turf/T in turf_data)
		T.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	turf_data.Cut()
	visible_message(span_danger("灵辉渗入荒石，大地重获生机！"))
	playsound(src, 'sound/foley/breaksound.ogg', 50, TRUE)
	return ..()

/obj/structure/blight_pillar/lesser
	name = "次级腐朽之柱"
	icon_state = "creation3"
	max_integrity = 150
	radius = 1

// weaker version of blight as spell, meant 2 emulate Rust heretic off TG. IDK if players will spam the terrain.
/obj/effect/proc_holder/spell/self/lesser_blight
	name = "次级腐化术"
	desc = "在面前竖起邪秽图腾，腐化大地。遍地的腐肉会伤害非信徒，却能滋养同教成员。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "profane"
	recharge_time = 2 MINUTES
	chargedloop = null

/obj/effect/proc_holder/spell/self/lesser_blight/cast(list/targets, mob/user = usr)
	. = ..()
	var/turf/T = get_step(user, user.dir)
	if(!T || T.density)
		to_chat(user, span_warning("没有空间。"))
		revert_cast()
		return FALSE
	new /obj/structure/blight_pillar/lesser(T)
	to_chat(user, span_notice("大地开始腐烂。"))
	return TRUE

/datum/ritual/rot/blight
	name = "Blight"
	icon_type = /obj/structure/blight_pillar
	desc = "举行仪式，使周围的土地石化。非教徒踏上石化的土地便会受伤，墙壁则会变成可开采的岩石。"
	center_requirement = /mob/living/carbon/human

/datum/ritual/rot/blight/invoke(mob/living/user, turf/center)
	var/poo = new /obj/effect/temp_visual/opengate/fivesec(center)
	playsound(user, 'sound/villain/littlescary2.ogg', 60, TRUE)
	if(!do_after(user, 5 SECONDS))
		qdel(poo)
		return
	new /obj/structure/blight_pillar(center)
	to_chat(user, span_notice("大地开始腐烂。"))

/datum/ritual/rot/plague
	name = "Curse of Black Rot"
	icon_type = /obj/item/natural/worms/leech
	desc = "使目标染上黑腐病。需要一条吸过目标血液的水蛭。"
	center_requirement = /obj/item/natural/worms/leech
	keep_center = TRUE

/datum/ritual/rot/plague/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	if(!curse_target(remnant.fed_from))
		to_chat(user, span_warning("目标受到了保护，无法再施加诅咒。"))
		return
	remnant.fed_from.apply_status_effect(/datum/status_effect/black_rot)
	to_chat(remnant.fed_from, span_danger("偏偏在这可怕的夜里遭了诅咒。"))
	remnant.fed_from.emote("scream")
	qdel(remnant)
	to_chat(user, span_notice("腐朽已在其体内生根。"))

// NOISE

/mob/living/proc/end_jaunt(obj/effect/dummy/phased_mob/slaughter/holder, turf/return_turf)
	if(QDELETED(holder))
		return
	forceMove(return_turf || get_turf(holder))
	var/obj/effect/temp_visual/dir_setting/cult/phase/P = new(get_turf(src), dir)
	P.color = "#2b0a3d"
	qdel(holder)

/mob/living/simple_animal/spook_spirit
	name = "???"
	desc = "别盯着它看。"
	icon = 'icons/effects/effects.dmi'
	icon_state = "nothing"
	invisibility = INVISIBILITY_OBSERVER
	density = FALSE
	incorporeal_move = TRUE
	movement_type = FLYING
	base_intents = list(INTENT_HELP)
	health = 500
	maxHealth = 500
	AIStatus = AI_OFF
	can_have_ai = FALSE

/mob/living/simple_animal/spook_spirit/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)

/mob/living/simple_animal/spook_spirit/canZMove(direction, turf/target)
	return TRUE

/mob/living/simple_animal/spook_spirit/verb/spirit_up()
	set category = "灵体出窍"
	set name = "向上飘"
	if(zMove(UP, TRUE))
		to_chat(src, span_notice("我向上飘去。"))

/mob/living/simple_animal/spook_spirit/verb/spirit_down()
	set category = "灵体出窍"
	set name = "向下飘"
	if(zMove(DOWN, TRUE))
		to_chat(src, span_notice("我向下飘去。"))

/mob/living/simple_animal/spook_spirit/ex_act()
	return

/mob/living/simple_animal/spook_spirit/bullet_act()
	return BULLET_ACT_FORCE_PIERCE

/mob/living/simple_animal/spook_spirit/fire_act()
	return

/datum/ritual/noise/thermalvis
	name = "Spook"
	icon_type = /obj/effect/proc_holder/spell/self/spook_scry
	desc = "学会灵体出窍，穿墙而行。你的双眼也能透过墙壁看见活物。"
	passive = TRUE
	research_cost = 3

/datum/ritual/noise/thermalvis/apply_passive(mob/living/carbon/human/H)
	ADD_TRAIT(H, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/spook_scry)
	return

/obj/effect/proc_holder/spell/self/spook_scry
	name = "灵体出窍"
	desc = "离开肉身，自由观察周围的世界，持续 20 秒。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "zizocloud"
	recharge_time = 30 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/self/spook_scry/charge_check(mob/user)
	return charge_counter >= recharge_time

/obj/effect/proc_holder/spell/self/spook_scry/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		revert_cast()
		return FALSE
	var/mob/living/simple_animal/spook_spirit/spirit = new(get_turf(H))
	H.visible_message(span_warning("[H]瘫软倒地！"))
	H.mind.transfer_to(spirit)
	addtimer(CALLBACK(src, PROC_REF(end_spook), H, spirit), 20 SECONDS)
	return TRUE

/obj/effect/proc_holder/spell/self/spook_scry/proc/end_spook(mob/living/carbon/human/H, mob/living/simple_animal/spook_spirit/spirit)
	if(QDELETED(H))
		qdel(spirit)
		return
	if(spirit.mind)
		spirit.mind.transfer_to(H)
	qdel(spirit)

/mob/living/simple_animal/pet/cat/rogue/black/witch
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 2
	melee_damage_upper = 5
	armor_penetration = PEN_MEDIUM
	hud_type = /datum/hud/dextrous
	held_items = list(null, null)
	var/mob/living/carbon/human/body
	var/list/bitten = list()

/mob/living/simple_animal/pet/cat/rogue/black/witch/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_ZJUMP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE2, TRAIT_GENERIC)
	pass_flags |= PASSTABLE | PASSGRILLE
	STAPER = 15
	see_in_dark = 12
	lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE

/mob/living/simple_animal/pet/cat/rogue/black/witch/UnarmedAttack(atom/A, proximity)
	var/mob/living/carbon/human/victim = A
	var/bleed_before = 0
	if(istype(victim))
		bleed_before = victim.get_bleed_rate()
	. = ..()
	if(istype(victim) && !is_zizo(victim) && victim.get_bleed_rate() > bleed_before && !(victim in bitten))
		bitten += victim
		to_chat(src, span_notice("我采到了[victim]的血！法术结束时，黑猫会留下一条残魂水蛭。"))

/mob/living/simple_animal/pet/cat/rogue/black/witch/Destroy()
	if(mind)
		if(QDELETED(body))
			ghostize()
		else
			mind.transfer_to(body)
	for(var/mob/living/carbon/human/victim in bitten)
		var/obj/item/natural/worms/leech/remnant = new(get_turf(src))
		remnant.fed_from = victim
		remnant.blood_storage = remnant.blood_maximum
		remnant.update_icon()
	return ..()

/mob/living/simple_animal/pet/cat/rogue/black/witch/death(gibbed)
	qdel(src)

/obj/effect/proc_holder/spell/self/witch_possess
	name = "黑猫附身"
	desc = "附身黑猫，或回到自己的身体。咬人可以采血，制成残魂水蛭。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "tame_deadite"
	recharge_time = 10 SECONDS
	chargedloop = null
	ignore_cockblock = TRUE
	var/mob/living/simple_animal/pet/cat/rogue/black/witch/cat

/obj/effect/proc_holder/spell/self/witch_possess/charge_check(mob/user, feedback = TRUE)
	if(user == cat)
		return TRUE
	return ..()

/obj/effect/proc_holder/spell/self/witch_possess/cast(list/targets, mob/user = usr)
	. = ..()
	if(user == cat)
		qdel(cat)
		return TRUE
	if(!ishuman(user) || !user.mind)
		revert_cast()
		return FALSE
	cat = new(get_turf(user))
	cat.body = user
	user.visible_message(span_warning("[user]瘫软倒地！"))
	user.mind.transfer_to(cat)
	return TRUE

/datum/ritual/servantry/witchery
	name = "Witchery"
	icon_type = /mob/living/simple_animal/pet/cat/rogue/black/witch
	desc = "学会召唤黑猫。你可以随时从远处附身于它，借它的双眼观察四周。咬人可以采血，制成残魂水蛭。"
	passive = TRUE
	lesser = TRUE
	research_cost = 3

/datum/ritual/servantry/witchery/apply_passive(mob/living/carbon/human/H)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/witch_possess)
	return

/datum/ritual/noise/forgettongue
	name = "Curse of Babel"
	icon_type = /obj/item/natural/worms/leech
	desc = "诅咒目标，使其遗忘通用语，也不再识字。需要一条吸过目标血液的水蛭。"
	center_requirement = /obj/item/natural/worms/leech
	keep_center = TRUE

/datum/ritual/noise/forgettongue/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	if(!curse_target(remnant.fed_from))
		to_chat(user, span_warning("目标受到了保护，无法再施加诅咒。"))
		return
	remnant.fed_from.remove_language(/datum/language/common, source = LANGUAGE_SOURCE_ALL)
	remnant.fed_from.adjust_skillrank(/datum/skill/misc/reading, -6, TRUE)
	to_chat(remnant.fed_from, span_danger("偏偏在这可怕的夜里遭了诅咒。"))
	remnant.fed_from.emote("scream")
	qdel(remnant)
	to_chat(user, span_notice("言语的意义被吞噬了，只留下噪音。"))

// PITCH

/datum/component/light_vulnerability
	var/burn_damage = 5

/datum/component/light_vulnerability/Initialize(damage = 5, duration = 0)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	burn_damage = damage
	if(duration)
		QDEL_IN(src, duration)
	RegisterSignal(parent, COMSIG_HUMAN_LIFE, PROC_REF(check_light))

/datum/component/light_vulnerability/proc/check_light(mob/living/carbon/human/H)
	if(!ishuman(H) || H.stat == DEAD)
		return
	var/turf/T = get_turf(H)
	if(T && T.get_lumcount() >= 0.75)
		H.adjustFireLoss(burn_damage)
		if(prob(30))
			to_chat(H, span_danger("光在灼烧我！"))

/datum/status_effect/shadowform
	id = "shadowform"
	duration = -1
	tick_interval = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/shadowform
	var/obj/effect/abstract/particle_holder/shadow_particles

/datum/status_effect/shadowform/on_apply()
	. = ..()
	owner.add_filter("shadowform", 2, list(type = "outline", color = "#2b0a3d", size = 1))
	shadow_particles = new(owner, /particles/zizo_shadow, PARTICLE_ATTACH_MOB)

/datum/status_effect/shadowform/on_remove()
	. = ..()
	owner.remove_filter("shadowform")
	QDEL_NULL(shadow_particles)

/datum/status_effect/shadowform/tick()
	var/turf/T = get_turf(owner)
	if(T && T.get_lumcount() < 0.75)
		owner.adjustBruteLoss(-5)
		owner.adjustFireLoss(-5)
		owner.heal_wounds(5)
	for(var/obj/item/I in owner.get_equipped_items() + owner.held_items)
		I.fire_act()
	for(var/obj/item/grabbing/G in owner.held_items)
		if(isliving(G.grabbed))
			var/mob/living/victim = G.grabbed
			victim.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/dark)
			victim.ignite_mob()
			victim.adjustFireLoss(10)

/atom/movable/screen/alert/status_effect/shadowform
	name = "阴影化身"
	desc = ""
	icon_state = "buff"

/obj/effect/proc_holder/spell/invoked/shadow_snuff
	name = "熄灯"
	desc = "熄灭一处火焰或光源。"
	range = 7
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "zizocandle"
	recharge_time = 2 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/invoked/shadow_snuff/cast(list/targets, mob/living/user)
	. = ..()
	var/atom/target = targets[1]
	if(!target)
		return FALSE
	if(isobj(target))
		var/obj/O = target
		O.extinguish()
	for(var/obj/O in target.contents)
		O.extinguish()
	return TRUE

/obj/effect/dummy/phased_mob/slaughter/shadow/relaymove(mob/user, direction)
	var/turf/dest = get_step(src, direction)
	if(!dest || dest.get_lumcount() >= 0.75)
		to_chat(user, span_warning("那里有光。"))
		return
	forceMove(dest)

/obj/effect/proc_holder/spell/self/shadow_jaunt
	name = "潜影穿行"
	desc = "隐去身形，穿墙而行。只能在黑暗中使用。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "zizocloud"
	recharge_time = 1 MINUTES
	chargedloop = null

/obj/effect/proc_holder/spell/self/shadow_jaunt/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/turf/T = get_turf(user)
	if(T.get_lumcount() >= 0.75)
		to_chat(user, span_warning("这里太亮了！"))
		revert_cast()
		return FALSE
	var/obj/effect/dummy/phased_mob/slaughter/shadow/holder = new(T)
	var/obj/effect/temp_visual/dir_setting/cult/phase/out/P = new(T, user.dir)
	P.color = "#2b0a3d"
	new /obj/effect/temp_visual/decoy/fading/halfsecond(T, user)
	user.visible_message(span_warning("[user]融入了阴影。"))
	user.forceMove(holder)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living, end_jaunt), holder), 5 SECONDS)
	return TRUE

/obj/effect/proc_holder/spell/invoked/dark_grip
	name = "暗焰擒拿"
	desc = "以强力抓握控制目标，再用暗焰将其吞没！"
	recharge_time = 60 SECONDS
	invocation_type = "emote"
	overlay_icon = 'icons/mob/actions/vampspells.dmi'
	action_icon = 'icons/mob/actions/vampspells.dmi'
	overlay_state = "potence"
	action_icon_state = "potence"

/obj/effect/proc_holder/spell/invoked/dark_grip/cast(list/targets, mob/living/user,)
	var/mob/living/target = targets[1]
	if(!target || target == user)
		to_chat(user, span_warning("你需要一个可以擒拿的目标！"))
		revert_cast()
		return FALSE

	if(user.pulling != target || user.grab_state < GRAB_AGGRESSIVE)
		to_chat(user, span_warning("你必须先以强力抓握控制[target]，才能开始擒拿！"))
		revert_cast()
		return FALSE

	var/datum/component/wrestle_combat_tracker/tracker = user.GetComponent(/datum/component/wrestle_combat_tracker)
	if(!tracker)
		tracker = user.AddComponent(/datum/component/wrestle_combat_tracker)

	to_chat(user, span_notice("暗焰在我掌心汇聚！"))
	to_chat(target, span_userdanger("[user]的掌心燃起暗焰！"))
	tracker.channeling_throw = TRUE
	user.emote("attack")
	if(!do_after(user, 1 SECONDS, target = target))
		tracker.channeling_throw = FALSE
		revert_cast()
		return FALSE

	if(target.has_status_effect(/datum/status_effect/buff/clash))
		target.remove_status_effect(/datum/status_effect/buff/clash)
		user.stop_pulling(TRUE)
		user.Knockdown(2 SECONDS)
		to_chat(user, span_notice("被反制了！"))
		playsound(user, 'sound/combat/crowdcheer.ogg', 100, TRUE)
	else
		target.adjust_fire_stacks(8, /datum/status_effect/fire_handler/fire_stacks/dark)
		target.ignite_mob()
		target.apply_damage(40, BURN, user.zone_selected || BODY_ZONE_CHEST)
		playsound(user, 'sound/combat/tf2crit.ogg', 100, TRUE)
	tracker.channeling_throw = FALSE
	return TRUE

/datum/ritual/pitch/fireresist
	name = "Fire Monk"
	icon_type = /obj/effect/proc_holder/spell/invoked/dark_grip
	desc = "将武艺练至肉身极限。所有擒拿检定取最大值，并习得大师级摔跤术。你还将学会以暗焰吞没被你抓住的目标。"
	passive = TRUE
	research_cost = 3

/datum/ritual/pitch/fireresist/apply_passive(mob/living/carbon/human/H)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_MASTER)
	ADD_TRAIT(H, TRAIT_PEAK_GRAPPLER, TRAIT_GENERIC)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dark_grip)
	return

/datum/ritual/pitch/shadowform
	name = "Scaduform"
	icon_type = /obj/effect/proc_holder/spell/invoked/shadow_snuff
	desc = "化为见光便会受伤的阴影，能穿行黑暗、隔空熄灯。你的身体显出异民的怪物形貌，失去生机，也不再失血。你触碰的一切都会燃烧，包括身上的装备和抓住的人。"
	center_requirement = /mob/living/carbon/human
	n_req = /obj/item/clothing/cloak

/datum/ritual/pitch/shadowform/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		to_chat(user, span_warning("此人不适合这个仪式。"))
		return
	if(target.has_status_effect(/datum/status_effect/shadowform))
		return
	if(!target.dna)
		return
	var/poo = new /obj/effect/temp_visual/opengate/fivesec(center)
	playsound(user, 'sound/villain/littlescary2.ogg', 60, TRUE)
	if(!do_after(user, 5 SECONDS))
		qdel(poo)
		return
	target.dna.species.species_traits |= MUTCOLORS
	target.dna.species.fixed_mut_color = "000000"
	target.dna.features["mcolor"] = "000000"
	target.update_body()
	target.update_hair()
	for(var/obj/item/bodypart/BP in target.bodyparts)
		for(var/datum/bodypart_feature/F in BP.bodypart_features)
			if(F.accessory_type)
				F.accessory_colors = recolor_accessory(F.accessory_type, "000000")
		BP.invalidate_limb_cache()
	for(var/obj/item/organ/O in target.internal_organs)
		if(O.accessory_type)
			O.accessory_colors = recolor_accessory(O.accessory_type, "000000")
	target.icon_render_key = null
	target.update_body_parts()
	target.apply_status_effect(/datum/status_effect/shadowform)
	target.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/shadow_snuff)
	target.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/shadow_jaunt)
	target.AddComponent(/datum/component/light_vulnerability)
	for(var/obj/item/I in target.get_equipped_items() + target.held_items)
		I.fire_act()
	var/obj/item/organ/eyes/eyes = target.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(target, TRUE)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision
	eyes.Insert(target)
	ADD_TRAIT(target, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOSLEEP, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOMETABOLISM, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_MONSTROUS, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOFIRE, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_FIRE_RESIST, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_RESISTHEAT, TRAIT_GENERIC)
	target.dna.species.name = "???"
	target.emote("scream")
	target.Knockdown(5 SECONDS)
	to_chat(target, span_danger("好烫！好烫！它黏在我的肉上烧个不停！"))

/datum/ritual/pitch/lightcurse
	name = "Curse of Radiance"
	icon_type = /obj/item/natural/worms/leech
	desc = "使目标在光下遭受灼烧。需要一条吸过目标血液的水蛭。"
	center_requirement = /obj/item/natural/worms/leech
	keep_center = TRUE

/datum/ritual/pitch/lightcurse/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	if(!curse_target(remnant.fed_from))
		to_chat(user, span_warning("目标受到了保护，无法再施加诅咒。"))
		return
	remnant.fed_from.AddComponent(/datum/component/light_vulnerability, 10, 10 MINUTES)
	to_chat(remnant.fed_from, span_danger("偏偏在这可怕的夜里遭了诅咒。"))
	remnant.fed_from.emote("scream")
	qdel(remnant)
	to_chat(user, span_notice("他们会明白我有多憎恨他的光。"))

// BLOOD

/obj/structure/rune_ward/zizo
	name = "血绘符印"
	desc = "用血涂成的奇异符文。"
	icon = 'icons/obj/sigils.dmi'
	icon_state = "lesser"
	alpha = 45
	max_integrity = 500
	checks_antimagic = FALSE
	var/charges = 3
	var/effect = "bleed"
	var/snare_damage = 120

/obj/structure/rune_ward/zizo/is_ally(mob/M)
	return is_zizo(M)

/obj/structure/rune_ward/zizo/consume()
	charges--
	if(charges <= 0)
		qdel(src)

/obj/structure/rune_ward/zizo/trigger_visual()
	new /obj/effect/temp_visual/cult/sparks(get_turf(src))

/obj/structure/rune_ward/zizo/rune_effect(mob/living/L)
	playsound(src, 'sound/magic/blade_burst.ogg', 80, TRUE)
	L.Slowdown(6)
	L.emote("scream")
	switch(effect)
		if("poison")
			L.reagents?.add_reagent(/datum/reagent/berrypoison, 25)
			L.Jitter(4)
			to_chat(L, span_danger("<B>符印喷了我一身污血！</B>"))
		if("stun")
			to_chat(L, span_danger("<B>符印劈啪作响，缚住了我的四肢！</B>"))
			L.electrocute_act(20, src)
			L.Paralyze(60)
		else
			to_chat(L, span_danger("<B>血刃破土而出，撕裂了我的身体！</B>"))
			new /obj/effect/temp_visual/blade_burst(get_turf(src))
			var/mob/living/carbon/human/owner = owner_ref?.resolve()
			if(ishuman(owner) && ishuman(L))
				arcyne_strike(owner, L, null, snare_damage, BODY_ZONE_CHEST, 					BCLASS_STAB, armor_penetration = PEN_HEAVY, spell_name = "鲜血陷阱", 					damage_type = BRUTE, skip_animation = TRUE)
			else
				L.adjustBruteLoss(snare_damage)

/datum/ritual/blood/transfuse
	name = "Sigil Expertise"
	icon_type = /obj/effect/decal/cleanable/sigil
	node_state = "center"
	desc = "大幅加快绘制符印的速度，双手无需沾血。"
	passive = TRUE
	research_cost = 2

/datum/ritual/blood/transfuse/apply_passive(mob/living/carbon/human/H)
	ADD_TRAIT(H, TRAIT_BLOODBOUND, TRAIT_GENERIC)
	return

/datum/ritual/blood/bloodsnare
	name = "Blood Snare"
	icon_type = /obj/effect/decal/cleanable/sigil
	node_state = "lesser"
	desc = "绘制半透明的符印陷阱，使踩中者受伤。用器官绘制可使人中毒，用武器可使人眩晕，其他材料则使人流血。"
	center_requirement = /obj/item
	keep_center = TRUE

/datum/ritual/blood/bloodsnare/invoke(mob/living/user, turf/center)
	var/effect = "bleed"
	if(locate(/obj/structure/rune_ward/zizo) in center)
		return FALSE
	if(locate(/obj/item/organ) in center)
		effect = "poison"
	else if(locate(/obj/item/rogueweapon) in center)
		effect = "stun"
	for(var/obj/item/I in center)
		qdel(I)
	for(var/obj/effect/decal/cleanable/sigil/sig in range(1, center))
		qdel(sig)
	new /obj/effect/temp_visual/opengate(center, 1.5 SECONDS)
	var/obj/structure/rune_ward/zizo/T = new(center)
	T.effect = effect
	T.owner_ref = WEAKREF(user)
	T.owner_name = user.real_name
	T.owner_ckey = user.ckey || "no ckey"
	to_chat(user, span_notice("符印渐渐隐去。陷阱布好了。"))

/datum/status_effect/bloodlink
	id = "bloodlink"
	duration = 10 MINUTES
	tick_interval = 5 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/bloodlink
	var/mob/living/carbon/human/partner

/datum/status_effect/bloodlink/on_creation(mob/living/new_owner, mob/living/carbon/human/linked)
	partner = linked
	. = ..()

/datum/status_effect/bloodlink/on_apply()
	. = ..()
	to_chat(owner, span_danger("偏偏在这可怕的夜里遭了诅咒。"))
	owner.emote("scream")

/datum/status_effect/bloodlink/tick()
	if(QDELETED(partner) || partner.stat == DEAD)
		qdel(src)
		return
	if(get_dist(owner, partner) > 7)
		owner.adjustOxyLoss(4)
		owner.Jitter(4)
		if(prob(30))
			to_chat(owner, span_danger("我心口好痛！[partner.real_name]在哪里？！"))

/atom/movable/screen/alert/status_effect/bloodlink
	name = "血契"
	desc = "我们的心脏一同跳动。我必须待在对方身边。"
	icon_state = "debuff"

/datum/ritual/blood/bloodbond
	name = "Curse of Blood"
	icon_type = /obj/item/natural/worms/leech
	desc = "诅咒两名目标，使他们分开便会逐渐死去。需要两条水蛭，分别吸过两人的血。"
	center_requirement = /obj/item/natural/worms/leech
	keep_center = TRUE

/datum/ritual/blood/bloodbond/invoke(mob/living/user, turf/center)
	var/list/found = list()
	for(var/obj/item/natural/worms/leech/L in center)
		if(L.fed_from && L.blood_storage > 0 && !QDELETED(L.fed_from) && L.fed_from.stat != DEAD)
			found += L
	if(found.len < 2)
		to_chat(user, span_warning("这个仪式需要两条水蛭。"))
		return
	var/obj/item/natural/worms/leech/L1 = found[1]
	var/obj/item/natural/worms/leech/L2 = found[2]
	var/mob/living/carbon/human/A = L1.fed_from
	var/mob/living/carbon/human/B = L2.fed_from
	if(A == B)
		to_chat(user, span_warning("蠢货！怎么能让一个人和自己结契！"))
		return
	if(A.has_status_effect(/datum/status_effect/buff/curse_immunity) || B.has_status_effect(/datum/status_effect/buff/curse_immunity))
		to_chat(user, span_warning("目标受到了保护，无法再施加诅咒。"))
		return
	curse_target(A)
	curse_target(B)
	A.apply_status_effect(/datum/status_effect/bloodlink, B)
	B.apply_status_effect(/datum/status_effect/bloodlink, A)
	qdel(L1)
	qdel(L2)
	to_chat(user, span_notice("我将[A]和[B]缚在一起，从此两颗心将一同跳动。"))
