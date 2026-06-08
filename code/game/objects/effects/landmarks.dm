/obj/effect/landmark
	name = "landmark"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"
	anchored = TRUE
	layer = MID_LANDMARK_LAYER
	invisibility = INVISIBILITY_ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

// Please stop bombing the Observer-Start landmark.
/obj/effect/landmark/ex_act()
	return

INITIALIZE_IMMEDIATE(/obj/effect/landmark)

/obj/effect/landmark/Initialize(mapload)
	. = ..()
	GLOB.landmarks_list += src

/obj/effect/landmark/Destroy()
	GLOB.landmarks_list -= src
	return ..()

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "x"
	anchored = TRUE
	layer = MOB_LAYER
	var/list/jobspawn_override = list()
	var/delete_after_roundstart = TRUE
	var/used = FALSE

/obj/effect/landmark/start/proc/after_round_start()
	if(delete_after_roundstart)
		qdel(src)

/obj/effect/landmark/start/Initialize(mapload)
	GLOB.start_landmarks_list += src
	if(jobspawn_override.len)
		for(var/X in jobspawn_override)
			if(!GLOB.jobspawn_overrides[X])
				GLOB.jobspawn_overrides[X] = list()
			GLOB.jobspawn_overrides[X] += src
	. = ..()
	if(name != "start")
		tag = "start*[name]"

/obj/effect/landmark/start/Destroy()
	GLOB.start_landmarks_list -= src
	for(var/X in jobspawn_override)
		GLOB.jobspawn_overrides[X] -= src
	return ..()

/obj/effect/landmark/events/haunts
	name = "hauntz"
	icon_state = "generic_event"

/obj/effect/landmark/events/haunts/Initialize(mapload)
	. = ..()
	GLOB.hauntstart += src
	icon_state = ""


/obj/effect/landmark/events/testportal
	name = "testserverportal"
	icon_state = "x4"
	var/aportalloc = "a"

/obj/effect/landmark/events/testportal/Initialize(mapload)
	. = ..()
//	GLOB.hauntstart += loc
#ifdef TESTSERVER
	var/obj/structure/fluff/testportal/T = new /obj/structure/fluff/testportal(loc)
	T.aportalloc = aportalloc
	GLOB.testportals += T
#endif
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/start/adventurerlate
	name = "Adventurerlate"
	icon_state = "arrow"
	jobspawn_override = list("Skeleton", "Pilgrim", "Adventurer", "Migrant", "Refugee")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/banditlate
	name = "强盗"
	icon_state = "arrow"
	jobspawn_override = list("Bandit")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/bogguardlate
	name = "Bogguardlate"
	icon_state = "arrow"
	jobspawn_override = list("Bog Master", "Bog Guard", "Warden", "Vanguard")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/vanguardlate
	name = "Vanguardlate"
	icon_state = "arrow"
	jobspawn_override = list("Bog Master", "Bog Guard","Vanguard")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/wardenlate
	name = "Wardenlate"
	icon_state = "arrow"
	jobspawn_override = list("Bog Master", "Bog Guard","Warden")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/vagrantlate
	name = "Beggarlate"
	icon_state = "arrow"
	jobspawn_override = list("Beggar")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/orphanlate
	name = "Vagabondlate"
	icon_state = "arrow"
	jobspawn_override = list("Vagabond")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/desertriderlate
	name = "DesertRiderlate"
	icon_state = "arrow"
	jobspawn_override = list("Desert Rider Mercenary")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/grenzelhoftlate
	name = "Grenzelhoftlate"
	icon_state = "arrow"
	jobspawn_override = list("Grenzelhoft Mercenary")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/mercenarylate
	name = "Mercenarylate"
	icon_state = "arrow"
	jobspawn_override = list("Mercenary")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/villagerlate
	name = "Townerlate"
	icon_state = "arrow"
	jobspawn_override = list("Towner")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/lord
	name = "大公爵"
	icon_state = "arrow"

/obj/effect/landmark/start/knight
	name = "骑士"
	icon_state = "arrow"

/obj/effect/landmark/start/sheriff
	name = "卫队队长"
	icon_state = "arrow"

/obj/effect/landmark/start/guard_captain
	name = "骑士统领"
	icon_state = "arrow"

/obj/effect/landmark/start/barkeep
	name = "酒保"
	icon_state = "arrow"

/obj/effect/landmark/start/cook
	name = "厨师"
	icon_state = "arrow"

/obj/effect/landmark/start/steward
	name = "总管"
	icon_state = "arrow"

/obj/effect/landmark/start/clerk
	name = "文书"
	icon_state = "arrow"

/obj/effect/landmark/start/magician
	name = "宫廷法师"
	icon_state = "arrow"

/obj/effect/landmark/start/physician
	name = "首席医师"
	icon_state = "arrow"

/obj/effect/landmark/start/chaplain
	name = "宫廷司祭"
	icon_state = "arrow"

/obj/effect/landmark/start/guardsman
	name = "城卫兵"
	icon_state = "arrow"
	
/obj/effect/landmark/start/rookie
	name = "新兵"
	icon_state = "arrow"

/obj/effect/landmark/start/manorguardsman
	name = "披甲兵"
	icon_state = "arrow"

/obj/effect/landmark/start/bogmaster
	name = "总守望官"
	icon_state = "arrow"

/obj/effect/landmark/start/bogguardsman
	name = "泥沼守卫"
	icon_state = "arrow"
	jobspawn_override = list("Bog Guard", "Vanguard")

/obj/effect/landmark/start/warden
	name = "守望者"
	icon_state = "arrow"

/obj/effect/landmark/start/vanguard
	name = "先锋"
	icon_state = "arrow"

/obj/effect/landmark/start/marshal
	name = "元帅"
	icon_state = "arrow"

/obj/effect/landmark/start/councillor
	name = "顾问"
	icon_state = "arrow"

/obj/effect/landmark/start/veteran
	name = "老兵"
	icon_state = "arrow"

/obj/effect/landmark/start/dungeoneer
	name = "地牢看守"
	icon_state = "arrow"

/obj/effect/landmark/start/watchman
	name = "守门官"
	icon_state = "arrow"

/obj/effect/landmark/start/villager
	name = "镇民"
	icon_state = "arrow"

/obj/effect/landmark/start/crier
	name = "报信人"
	icon_state = "arrow"

/obj/effect/landmark/start/keeper
	name = "看守"
	icon_state = "arrow"

/obj/effect/landmark/start/priest
	name = "主教"
	icon_state = "arrow"

/obj/effect/landmark/start/cleric
	name = "教士"
	icon_state = "arrow"

/obj/effect/landmark/start/monk
	name = "侍僧"
	icon_state = "arrow"

/obj/effect/landmark/start/druid
	name = "德鲁伊"
	icon_state = "arrow"

/obj/effect/landmark/start/templar
	name = "圣殿骑士"
	icon_state = "arrow"

/obj/effect/landmark/start/martyr
	name = "殉道者"
	icon_state = "arrow"

/obj/effect/landmark/start/puritan
	name = "审判官"
	icon_state = "arrow"

/obj/effect/landmark/start/orthodoxist
	name = "正统派教士"
	icon_state = "arrow"

/obj/effect/landmark/start/absolver
	name = "赦罪者"
	icon_state = "arrow"

/obj/effect/landmark/start/inqlate
	name = "Inquisition Late"
	delete_after_roundstart = FALSE
	jobspawn_override = list("Absolver", "Orthodoxist", "Inquisitor")

/obj/effect/landmark/start/sergeant
	name = "中士"
	icon_state = "arrow"

/obj/effect/landmark/start/nightman
	name = "浴场主管"
	icon_state = "arrow"

/obj/effect/landmark/start/nightmaiden
	name = "浴场侍者"
	icon_state = "arrow"

/obj/effect/landmark/start/merchant
	name = "商人"
	icon_state = "arrow"

/obj/effect/landmark/start/shophand
	name = "店员"
	icon_state = "arrow"

/obj/effect/landmark/start/grabber
	name = "抓手"
	icon_state = "arrow"


/obj/effect/landmark/start/innkeep
	name = "旅店老板"
	icon_state = "arrow"

/obj/effect/landmark/start/archivist
	name = "档案官"
	icon_state = "arrow"

/obj/effect/landmark/start/guildsman
	name = "行会成员"
	icon_state = "arrow"

/obj/effect/landmark/start/guildmaster
	name = "行会会长"
	icon_state = "arrow"

/obj/effect/landmark/start/tailor
	name = "裁缝"
	icon_state = "arrow"

/obj/effect/landmark/start/alchemist
	name = "炼金术士"
	icon_state = "arrow"

/obj/effect/landmark/start/scribe
	name = "抄写员"
	icon_state = "arrow"

/obj/effect/landmark/start/farmer
	name = "农夫"
	icon_state = "arrow"

/obj/effect/landmark/start/beastmonger
	name = "屠夫"
	icon_state = "arrow"

/obj/effect/landmark/start/cook
	name = "厨师"
	icon_state = "arrow"

/obj/effect/landmark/start/knavewench
	name = "酒馆伙计"
	icon_state = "arrow"

/obj/effect/landmark/start/gravedigger
	name = "入殓师"
	icon_state = "arrow"

/obj/effect/landmark/start/mercenary
	name = "雇佣兵"
	icon_state = "arrow"

/obj/effect/landmark/start/vagrant
	name = "乞丐"
	icon_state = "arrow"

/obj/effect/landmark/start/suitor
	name = "求婚者"
	icon_state = "arrow"

/obj/effect/landmark/start/lady
	name = "配偶"
	icon_state = "arrow"

/obj/effect/landmark/start/prince
	name = "王子"
	icon_state = "arrow"

/obj/effect/landmark/start/prisonerr
	name = "囚犯（城镇）"
	icon_state = "arrow"

/obj/effect/landmark/start/prisonerb
	name = "囚犯（泥沼）"
	icon_state = "arrow"

/obj/effect/landmark/start/hostage
	name = "人质"
	icon_state = "arrow"

/obj/effect/landmark/start/jester
	name = "弄臣"
	icon_state = "arrow"

/obj/effect/landmark/start/hand
	name = "亲随"
	icon_state = "arrow"

/obj/effect/landmark/start/hunter
	name = "猎人"
	icon_state = "arrow"

/obj/effect/landmark/start/fisher
	name = "渔夫"
	icon_state = "arrow"

/obj/effect/landmark/start/lumberjack
	name = "伐木工"
	icon_state = "arrow"

/obj/effect/landmark/start/butler
	name = "管家长"
	icon_state = "arrow"

/obj/effect/landmark/start/barkeeper
	name = "旅馆老板"
	icon_state = "arrow"

/obj/effect/landmark/start/adventurer
	name = "冒险者"
	icon_state = "arrow"

//Remove this at some point. Vestigial.
/obj/effect/landmark/start/trader
	name = "难民"
	icon_state = "arrow"
//End of remove.

/obj/effect/landmark/start/courtagent
	name = "宫廷密探"
	icon_state = "arrow"

/obj/effect/landmark/start/lunatic
	name = "疯子"
	icon_state = "arrow"

//yrf

/obj/effect/landmark/start/squire
	name = "侍从骑士"
	icon_state = "arrow"

/obj/effect/landmark/start/wapprentice
	name = "法师助理"
	icon_state = "arrow"

/obj/effect/landmark/start/apothecary
	name = "药剂师"
	icon_state = "arrow"

/obj/effect/landmark/start/servant
	name = "仆役"
	icon_state = "arrow"

/obj/effect/landmark/start/churchling
	name = "教会侍童"
	icon_state = "arrow"

/obj/effect/landmark/start/orphan
	name = "流浪儿"
	icon_state = "arrow"

/obj/effect/landmark/start/sapprentice
	name = "铁匠学徒"
	icon_state = "arrow"
	
/obj/effect/landmark/start/lich
	name = "巫妖"
	icon_state = "arrow"
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/lich/Initialize(mapload)
	. = ..()
	GLOB.lich_starts += loc

//tribal

/obj/effect/landmark/start/tribalchieftain
	name = "酋长"
	icon_state = "arrow"

/obj/effect/landmark/start/tribalshaman
	name = "部落萨满"
	icon_state = "arrow"

/obj/effect/landmark/start/tribalguard
	name = "部落卫士"
	icon_state = "arrow"

/obj/effect/landmark/start/tribalrabble
	name =  "部落杂兵"
	icon_state = "arrow"

/obj/effect/landmark/start/tribalvillager
	name = "部落民"
	icon_state = "arrow"

/obj/effect/landmark/start/tribelate
	name = "Tribal Late"
	delete_after_roundstart = FALSE
	jobspawn_override = list("Chieftain", "Tribal Shaman", "Tribal Guard", "Tribal Rabble", "Tribal Villager")

//Antagonist spawns

/obj/effect/landmark/start/wizard
	name = "巫师"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "wiznerd_spawn"

/obj/effect/landmark/start/wizard/Initialize(mapload)
	. = ..()
	GLOB.wizardstart += loc

/obj/effect/landmark/start/nukeop
	name = "nukeop"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "snukeop_spawn"

/obj/effect/landmark/start/nukeop/Initialize(mapload)
	. = ..()
	GLOB.nukeop_start += loc

/obj/effect/landmark/start/bandit
	name = "强盗"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "arrow"
	jobspawn_override = list("Bandit")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/bandit/Initialize(mapload)
	. = ..()
	GLOB.bandit_starts += loc


/obj/effect/landmark/start/delf
	name = "暗精灵"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "arrow"

/obj/effect/landmark/start/delf/Initialize(mapload)
	. = ..()
	GLOB.delf_starts += loc

/obj/effect/landmark/start/wretch
	name = "悲惨者"
	icon_state = "arrow"
	jobspawn_override = list("Wretch")

/obj/effect/landmark/start/wretchlate
	name = "悲惨者"
	icon_state = "arrow"
	delete_after_roundstart = FALSE
	jobspawn_override = list("Wretch")

/obj/effect/landmark/start/gnoll
	name = "豺狼人"
	icon_state = "arrow"
	jobspawn_override = list("Gnoll")

/obj/effect/landmark/start/gnolllate
	name = "豺狼人"
	icon_state = "arrow"
	delete_after_roundstart = FALSE
	jobspawn_override = list("Gnoll")

/obj/effect/landmark/start/nukeop_leader
	name = "nukeop leader"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "snukeop_leader_spawn"

/obj/effect/landmark/start/nukeop_leader/Initialize(mapload)
	. = ..()
	GLOB.nukeop_leader_start += loc

// Must be immediate because players will
// join before SSatom initializes everything.
INITIALIZE_IMMEDIATE(/obj/effect/landmark/start/new_player)

/obj/effect/landmark/start/new_player
	name = "新玩家"

/obj/effect/landmark/start/new_player/Initialize(mapload)
	. = ..()
	GLOB.newplayer_start += loc

/obj/effect/landmark/latejoin
	name = "JoinLate"

/obj/effect/landmark/latejoin/Initialize(mapload)
	..()
	SSjob.latejoin_trackers += loc
	return INITIALIZE_HINT_QDEL

//space carps, magicarps, lone ops, slaughter demons, possibly revenants spawn here
/obj/effect/landmark/carpspawn
	name = "carpspawn"
	icon_state = "carp_spawn"

//observer start
/obj/effect/landmark/observer_start
	name = "Observer-Start"
	icon_state = "x"

//objects with the stationloving component (nuke disk) respawn here.
//also blobs that have their spawn forcemoved (running out of time when picking their spawn spot), santa and respawning devils
/obj/effect/landmark/blobstart
	name = "blobstart"
	icon_state = "blob_start"

/obj/effect/landmark/blobstart/Initialize(mapload)
	..()
	GLOB.blobstart += loc
	return INITIALIZE_HINT_QDEL

//spawns sec equipment lockers depending on the number of sec officers
/obj/effect/landmark/secequipment
	name = "secequipment"
	icon_state = "secequipment"

/obj/effect/landmark/secequipment/Initialize(mapload)
	..()
	GLOB.secequipment += loc
	return INITIALIZE_HINT_QDEL

//players that get put in admin jail show up here
/obj/effect/landmark/prisonwarp
	name = "prisonwarp"
	icon_state = "prisonwarp"

/obj/effect/landmark/prisonwarp/Initialize(mapload)
	..()
	GLOB.prisonwarp += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/ert_spawn
	name = "Emergencyresponseteam"
	icon_state = "ert_spawn"

/obj/effect/landmark/ert_spawn/Initialize(mapload)
	..()
	GLOB.emergencyresponseteamspawn += loc
	return INITIALIZE_HINT_QDEL

//ninja energy nets teleport victims here
/obj/effect/landmark/holding_facility
	name = "Holding Facility"
	icon_state = "holding_facility"

/obj/effect/landmark/holding_facility/Initialize(mapload)
	..()
	GLOB.holdingfacility += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/observe
	name = "tdomeobserve"
	icon_state = "tdome_observer"

/obj/effect/landmark/thunderdome/observe/Initialize(mapload)
	..()
	GLOB.tdomeobserve += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/one
	name = "tdome1"
	icon_state = "tdome_t1"

/obj/effect/landmark/thunderdome/one/Initialize(mapload)
	..()
	GLOB.tdome1	+= loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/two
	name = "tdome2"
	icon_state = "tdome_t2"

/obj/effect/landmark/thunderdome/two/Initialize(mapload)
	..()
	GLOB.tdome2 += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/admin
	name = "tdomeadmin"
	icon_state = "tdome_admin"

/obj/effect/landmark/thunderdome/admin/Initialize(mapload)
	..()
	GLOB.tdomeadmin += loc
	return INITIALIZE_HINT_QDEL

//generic event spawns
/obj/effect/landmark/event_spawn
	name = "generic event spawn"
	icon_state = "generic_event"
	layer = HIGH_LANDMARK_LAYER


/obj/effect/landmark/event_spawn/New()
	..()
	GLOB.generic_event_spawns += src

/obj/effect/landmark/event_spawn/Destroy()
	GLOB.generic_event_spawns -= src
	return ..()

/obj/effect/landmark/ruin
	var/datum/map_template/ruin/ruin_template

/obj/effect/landmark/ruin/New(loc, my_ruin_template)
	name = "ruin_[GLOB.ruin_landmarks.len + 1]"
	..(loc)
	ruin_template = my_ruin_template
	GLOB.ruin_landmarks |= src

/obj/effect/landmark/ruin/Destroy()
	GLOB.ruin_landmarks -= src
	ruin_template = null
	. = ..()

/// Marks the bottom left of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_bottom_left
	name = "unit test zone bottom left"

/// Marks the top right of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_top_right
	name = "unit test zone top right"

//Underworld landmark

/obj/effect/landmark/underworld
	name = "underworld spawn"

/obj/effect/landmark/underworldcoin
	name = "ferryman coin"

/obj/effect/landmark/underworldsafe
	name = "safe zone"

//Deathsdoor landmark
/obj/effect/landmark/deaths_door/entry/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	if(T)
		GLOB.deaths_door_entries += T
	qdel(src)

/obj/effect/landmark/deaths_door/entry/tl
	name = "deaths door entry point"
/obj/effect/landmark/deaths_door/entry/tr
	name = "deaths door entry point"
/obj/effect/landmark/deaths_door/entry/bl
	name = "deaths door entry point"
/obj/effect/landmark/deaths_door/entry/br
	name = "deaths door entry point"

/obj/effect/landmark/deaths_door/exit/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	if(T)
		GLOB.deaths_door_exit = T
	qdel(src)

/obj/effect/landmark/deaths_door/exit
	name = "deaths door exit point"

GLOBAL_LIST_EMPTY(travel_tile_locations)

/obj/effect/landmark/travel_tile_location
	name = "travel tile location"

/obj/effect/landmark/travel_tile_location/Initialize(mapload)
	. = ..()
	GLOB.travel_tile_locations += src

/obj/effect/landmark/travel_tile_location/Destroy()
	GLOB.travel_tile_locations -= src
	. = ..()

GLOBAL_LIST_EMPTY(travel_spawn_points)

/obj/effect/landmark/travel_spawn_point
	name = "travel spawn point"
	icon_state = "generic_event"
	var/taken = FALSE

/obj/effect/landmark/travel_spawn_point/Initialize(mapload)
	. = ..()
	GLOB.travel_spawn_points += src

/obj/effect/landmark/travel_spawn_point/Destroy()
	GLOB.travel_spawn_points -= src
	. = ..()

/proc/get_free_travel_spawn_point()
	var/list/shuffled = shuffle(GLOB.travel_spawn_points)
	for(var/obj/effect/landmark/travel_spawn_point/point as anything in shuffled)
		if(point.taken)
			continue
		point.taken = TRUE
		return point.loc
	return null

/proc/create_travel_tiles(atom/location, travel_id, travel_goes_to_id, required_trait)
	for(var/obj/effect/landmark/travel_tile_location/landmark as anything in GLOB.travel_tile_locations)
		if(get_dist(location, landmark) > 5)
			continue
		// Create travel tile here
		var/obj/structure/fluff/traveltile/tile = new /obj/structure/fluff/traveltile(landmark.loc)
		tile.aportalid = travel_id
		tile.aportalgoesto = travel_goes_to_id
		tile.required_trait = required_trait
