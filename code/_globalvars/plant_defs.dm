#define BERRYCOLORS	list("#6a6699" = "浅蓝色", "#9b6464" = "红色", "#58a75c" = "绿色", "#5658a9" = "蓝色", "#669799" = "青色")
GLOBAL_LIST_EMPTY(berrycolors)

GLOBAL_LIST_INIT(plant_defs, build_plant_defs())

/proc/build_plant_defs()
	. = list()
	for(var/path in subtypesof(/datum/plant_def))
		.[path] = new path()
