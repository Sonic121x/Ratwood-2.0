/mob/proc/lord_marriage_choice()
	
	var/datum/job/suitor_job = SSjob.GetJob("Suitor")
	var/datum/job/consort_job = SSjob.GetJob("Consort")

	if (consort_job.total_positions > 0 || suitor_job.total_positions > 0) //Safety for if the duke far travels and another duke replaces them.
		return

	if(!client)
		addtimer(CALLBACK(src, PROC_REF(lord_marriage_choice)), 50)
		return
	var/marriage_choice = list("已婚（王配）","单身（求婚贵胄）")
	var/choice = input(src, "我的婚姻状况是……", "罗格镇 - 婚姻选项") as anything in marriage_choice
	switch(choice)
		if("已婚（王配）")
			consort_job.total_positions = 1
			consort_job.spawn_positions = 1
		if("单身（求婚贵胄）")
			suitor_job.total_positions = 3
			suitor_job.spawn_positions = 3
