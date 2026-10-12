// 低等级经验继续走人类入口；睡眠经验只在自己的分支结算一次倍率。
/mob/living/carbon/human
	var/z121_ethos_no_labor = 0

/datum/sleep_adv/add_sleep_experience(skill, amt, silent = FALSE)
	var/mob/living/carbon/human/H = ishuman(mind?.current) ? mind.current : null
	if(!H || (H.get_skill_level(skill) < SKILL_LEVEL_APPRENTICE && !is_considered_sleeping()))
		return ..()
	var/before = get_sleep_xp(skill)
	amt = H.z121_genius_experience(H.z121_ethos_experience(skill, amt))
	. = ..(skill, amt, silent)
	H.z121_get_ethos()?.experience_settled(skill, before, get_sleep_xp(skill))

// 失败仍可学习，但不能冒充成功劳动领取美德奖励。
/mob/living/carbon/human/proc/z121_ethos_failed_experience(skill, amount, sleeping = FALSE)
	z121_ethos_no_labor++
	try
		if(sleeping)
			mind?.add_sleep_experience(skill, amount)
		else
			adjust_experience(skill, amount, FALSE)
	catch(var/exception/error)
		z121_ethos_no_labor--
		throw error
	z121_ethos_no_labor--

/proc/z121_ethos_failed_learning(mob/student, skill, amount, sleeping = TRUE)
	if(ishuman(student))
		var/mob/living/carbon/human/H = student
		return H.z121_ethos_failed_experience(skill, amount, sleeping)
	if(sleeping)
		student.mind?.add_sleep_experience(skill, amount)
	else
		student.adjust_experience(skill, amount, FALSE)

/datum/sleep_adv/grant_inspiration_xp(skill_amt)
	var/mob/living/carbon/human/H = ishuman(mind?.current) ? mind.current : null
	if(H)
		H.z121_ethos_no_labor++
	try
		. = ..()
	catch(var/exception/error)
		if(H && !QDELETED(H))
			H.z121_ethos_no_labor--
		throw error
	if(H && !QDELETED(H))
		H.z121_ethos_no_labor--

// 装置故障的补偿经验属于失败学习，不应领取勤勉的倍率和减压。
/obj/item/contraption/misfire(obj/O, mob/living/user)
	var/mob/living/carbon/human/H = ishuman(user) ? user : null
	if(H)
		H.z121_ethos_no_labor++
	try
		. = ..()
	catch(var/exception/error)
		if(H && !QDELETED(H))
			H.z121_ethos_no_labor--
		throw error
	if(H && !QDELETED(H))
		H.z121_ethos_no_labor--
