//Helper Modules


// Helper to repressurize the area in case it was run in space
/datum/mapGeneratorModule/bottomLayer/repressurize
	spawnableAtoms = list()
	spawnableTurfs = list()

/datum/mapGeneratorModule/bottomLayer/repressurize/generate()
	if(!mother)
		return

/datum/mapGeneratorModule/bottomLayer/massdelete
	spawnableAtoms = list()
	spawnableTurfs = list()
	var/deleteturfs = TRUE	//separate var for the empty type.
	var/list/ignore_typecache

/datum/mapGeneratorModule/bottomLayer/massdelete/generate()
	if(!mother)
		return
	for(var/V in mother.map)
		var/turf/T = V
		T.empty(deleteturfs? null : T.type, null, ignore_typecache, CHANGETURF_FORCEOP)

/datum/mapGeneratorModule/bottomLayer/massdelete/no_delete_mobs/New()
	..()
	ignore_typecache = GLOB.typecache_mob

/datum/mapGeneratorModule/bottomLayer/massdelete/leave_turfs
	deleteturfs = FALSE

/datum/mapGeneratorModule/bottomLayer/massdelete/regeneration_delete
	deleteturfs = FALSE

/datum/mapGeneratorModule/bottomLayer/massdelete/regeneration_delete/New()
	..()
	ignore_typecache = GLOB.typecache_mob

//Only places atoms/turfs on area borders
/datum/mapGeneratorModule/border
	clusterCheckFlags = CLUSTER_CHECK_NONE

/datum/mapGeneratorModule/border/generate()
	if(!mother)
		return
	var/list/map = mother.map
	for(var/turf/T in map)
		if(is_border(T))
			place(T)

/datum/mapGeneratorModule/border/proc/is_border(turf/T)
	for(var/direction in list(SOUTH,EAST,WEST,NORTH))
		if (get_step(T,direction) in mother.map)
			continue
		return 1
	return 0

/datum/mapGenerator/repressurize
	modules = list(/datum/mapGeneratorModule/bottomLayer/repressurize)
	buildmode_name = "区域：恢复回合开始时的空气成分"

/datum/mapGenerator/massdelete
	modules = list(/datum/mapGeneratorModule/bottomLayer/massdelete)
	buildmode_name = "区域：批量删除全部内容"

/datum/mapGenerator/massdelete/nomob
	modules = list(/datum/mapGeneratorModule/bottomLayer/massdelete/no_delete_mobs)
	buildmode_name = "区域：批量删除，保留生物"

/datum/mapGenerator/massdelete/noturf
	modules = list(/datum/mapGeneratorModule/bottomLayer/massdelete/leave_turfs)
	buildmode_name = "区域：批量删除，保留地块"

/datum/mapGenerator/massdelete/regen
	modules = list(/datum/mapGeneratorModule/bottomLayer/massdelete/regeneration_delete)
	buildmode_name = "区域：批量删除，保留生物和地块"
