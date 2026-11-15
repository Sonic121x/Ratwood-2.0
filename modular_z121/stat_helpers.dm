// 实际属性包含显示值与溢出缓冲；回收直接结算总量，避免旧缓冲再次放大变化。
/proc/z121_stat_fields(stat)
	switch(stat)
		if(STATKEY_STR)
			return list("STASTR", "BUFSTR")
		if(STATKEY_PER)
			return list("STAPER", "BUFPER")
		if(STATKEY_INT)
			return list("STAINT", "BUFINT")
		if(STATKEY_CON)
			return list("STACON", "BUFCON")
		if(STATKEY_WIL)
			return list("STAWIL", "BUFEND")
		if(STATKEY_SPD)
			return list("STASPD", "BUFSPE")
		if(STATKEY_LCK)
			return list("STALUC", "BUFLUC")

/proc/z121_stat_total(mob/living/carbon/human/H, stat)
	var/list/fields = z121_stat_fields(stat)
	return fields ? H.vars[fields[1]] + H.vars[fields[2]] : 0

/proc/z121_stat_delta(mob/living/carbon/human/H, stat, amount)
	var/list/fields = z121_stat_fields(stat)
	if(!fields || !amount)
		return
	var/total = z121_stat_total(H, stat) + amount
	H.vars[fields[1]] = clamp(total, 1, 20)
	H.vars[fields[2]] = total - H.vars[fields[1]]
	if(stat == STATKEY_PER)
		H.see_override = initial(H.see_invisible) + (H.STAPER / 3.25)
		H.update_sight()
		H.update_fov_angles()
	if(stat == STATKEY_SPD)
		H.update_move_intent_slowdown()

