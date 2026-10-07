/client/proc/bluespace_artillery(mob/M in GLOB.mob_list)
	if(!holder || !check_rights(R_FUN))
		return

	var/mob/living/target = M

	if(!isliving(target))
		to_chat(usr, "此指令只能用于 /mob/living 类型的实例")
		return

	explosion(target.loc, 0, 0, 0, 0)

	var/turf/open/floor/T = get_turf(target)
	if(istype(T))
		T.break_tile()

	if(target.health <= 1)
		target.gib(1, 1)
	else
		target.adjustBruteLoss(min(99,(target.health - 1)))
		target.Paralyze(400)
		target.stuttering = 20
