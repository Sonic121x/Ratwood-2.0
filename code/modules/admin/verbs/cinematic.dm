/client/proc/cinematic()
	set name = "过场动画"
	set category = "-主持-"
	set desc = ""	// Intended for testing but I thought it might be nice for events on the rare occasion Feel free to comment it out if it's not wanted.
	set hidden = 1
	if(!SSticker)
		return

	var/datum/cinematic/choice = input(src,"过场动画","选择",null) as anything in sortList(subtypesof(/datum/cinematic), GLOBAL_PROC_REF(cmp_typepaths_asc))
	if(choice)
		Cinematic(initial(choice.id),world,null)
