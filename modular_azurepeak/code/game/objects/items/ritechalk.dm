/obj/item/ritechalk
	name = "仪式粉笔"
	icon_state = "chalk"
	desc = "普通的白色粉笔。举行仪式时的实用工具。"
	icon = 'icons/roguetown/misc/rituals.dmi'
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = FALSE
	dropshrink = 0.6

/obj/item/ritechalk/attack_self(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user, span_smallred("我根本不知道该拿这东西做什么......"))
		return

	var/ritechoices = list()
	switch (user.patron?.type)
		if(/datum/patron/inhumen/graggar)
			ritechoices+="暴力之符文"
		if(/datum/patron/inhumen/zizo)
			ritechoices+="齐佐之符文"
		if(/datum/patron/inhumen/matthios)
			ritechoices+="交易之符文"
		if(/datum/patron/inhumen/baotha)
			ritechoices+="享乐之符文"
		if(/datum/patron/divine/astrata)
			ritechoices+="太阳之符文"
		if(/datum/patron/divine/noc)
			ritechoices+="月亮之符文"
		if(/datum/patron/divine/dendor)
			ritechoices+="野兽之符文"
		if(/datum/patron/divine/malum)
			ritechoices+="锻炉之符文"
		if(/datum/patron/divine/xylix)
			ritechoices+="诡计之符文"
		if(/datum/patron/divine/necra)
			ritechoices+="死亡之符文"
		if(/datum/patron/divine/pestra)
			ritechoices+="瘟疫之符文"
		if(/datum/patron/divine/eora)
			ritechoices+="爱之符文"
		if(/datum/patron/divine/ravox)
			ritechoices+="正义之符文"
		if(/datum/patron/divine/abyssor)
			ritechoices+="风暴之符文"
			ritechoices+="翻涌之符文"
		if(/datum/patron/old_god)
			ritechoices+="坚忍之符文"

	if(HAS_TRAIT(user, TRAIT_DREAMWALKER) && !("翻涌之符文" in ritechoices))
		ritechoices+="翻涌之符文"

	var/runeselection = tgui_input_list(user, "我要刻下哪一道符文？", "[src]", ritechoices, strict_modern = TRUE)
	var/turf/step_turf = get_step(get_turf(user), user.dir)
	switch(runeselection)
		if("太阳之符文")
			to_chat(user,span_cultsmall("我开始刻画她的辉耀符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/astrata(step_turf)
		if("月亮之符文")
			to_chat(user, span_cultsmall("我开始刻画祂的智慧符文。"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/noc(step_turf)
		if("野兽之符文")
			to_chat(user,span_cultsmall("我开始刻画祂的狂乱符文。"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/dendor(step_turf)
		if("锻炉之符文")
			to_chat(user,span_cultsmall("我开始刻画祂们的工艺符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/malum(step_turf)
		if("诡计之符文")
			to_chat(user,span_cultsmall("我开始刻画祂的诡计符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/xylix(step_turf)
		if("死亡之符文")
			to_chat(user,span_cultsmall("我开始刻画她的拥抱符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/necra(step_turf)
		if("瘟疫之符文")
			to_chat(user,span_cultsmall("我开始刻画她的疫病符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/pestra(step_turf)
		if("爱之符文")
			to_chat(user,span_cultsmall("我开始刻画她的爱之符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/eora(step_turf)
		if("正义之符文")
			to_chat(user,span_cultsmall("我开始刻画祂的正义符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/ravox(step_turf)
		if("风暴之符文")
			to_chat(user,span_cultsmall("我开始刻画祂的风暴符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/abyssor(step_turf)
		if("翻涌之符文")
			to_chat(user,span_cultsmall("我开始刻画祂的梦之符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/abyssor_alt_inactive(step_turf)
		if("齐佐之符文")
			to_chat(user,span_cultsmall("我开始刻画她的知识符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/zizo(step_turf)
		if("交易之符文")
			to_chat(user,span_cultsmall("我开始刻画祂的交易符文。"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/matthios(step_turf)
		if("暴力之符文")
			to_chat(user,span_cultsmall("我开始刻画屠戮符文。"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/graggar(step_turf)
		if("享乐之符文")
			to_chat(user,span_cultsmall("我开始刻画沉溺符文。"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/baotha(step_turf)
		if("坚忍之符文")
			to_chat(user,span_cultsmall("我开始刻下祂的圣徽。"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/psydon(step_turf)
