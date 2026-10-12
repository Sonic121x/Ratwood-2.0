// 教学入口保留原流程，只在成功授予技能时分发七德奖励。
/obj/effect/proc_holder/spell/invoked/teach/cast(list/targets, mob/user = usr)
	. = call(src, /obj/effect/proc_holder/spell/proc/cast)(targets, user)
	var/list/choices = list()
	var/mob/living/L = targets[1]
	var/list/datum/skill/skill_choices = list(
	/datum/skill/craft/alchemy,
	/datum/skill/magic/arcane,
	/datum/skill/craft/armorsmithing,

	/datum/skill/craft/blacksmithing,
	/datum/skill/labor/butchering,

	/datum/skill/craft/carpentry,
	/datum/skill/craft/ceramics,
	/datum/skill/misc/climbing,
	/datum/skill/craft/cooking,
	/datum/skill/craft/crafting,

	/datum/skill/craft/engineering,

	/datum/skill/labor/farming,
	/datum/skill/labor/fishing,

	/datum/skill/misc/lockpicking,
	/datum/skill/labor/lumberjacking,

	/datum/skill/craft/masonry,
	/datum/skill/labor/mining,
	/datum/skill/misc/music,
	/datum/skill/misc/medicine,



	/datum/skill/craft/sewing,
	/datum/skill/craft/smelting,
	/datum/skill/misc/sneaking,
	/datum/skill/misc/stealing,
	/datum/skill/misc/swimming,

	/datum/skill/craft/tanning,
	/datum/skill/misc/tracking,

	/datum/skill/misc/reading,
	/datum/skill/misc/riding,

	/datum/skill/craft/weaponsmithing,
	/datum/language/aavnic,
	/datum/language/celestial,
	/datum/language/draconic,
	/datum/language/dwarvish,
	/datum/language/elvish,
	/datum/language/etruscan,
	/datum/language/grenzelhoftian,
	/datum/language/gronnic,
	/datum/language/hammerholdian,
	/datum/language/hellspeak,
	/datum/language/kazengunese,
	/datum/language/orcish,
	/datum/language/otavan
	)
	for(var/i = 1, i <= skill_choices.len, i++)
		var/datum/skill/learn_item = skill_choices[i]
		if((L.get_skill_level(learn_item) < SKILL_LEVEL_NOVICE) && !(learn_item in list(/datum/language/aavnic, /datum/language/celestial, /datum/language/draconic, /datum/language/dwarvish, /datum/language/elvish, /datum/language/etruscan, /datum/language/grenzelhoftian, /datum/language/gronnic, /datum/language/hammerholdian, /datum/language/hellspeak, /datum/language/kazengunese, /datum/language/orcish, /datum/language/otavan)))
			continue
		if(L.get_skill_level(learn_item) > SKILL_LEVEL_EXPERT)
			continue
		if (L.has_language(learn_item))
			continue
		choices["[learn_item.name]"] = learn_item


	var/teachingtime = 30 SECONDS

	if(isliving(targets[1]))
		if(L == usr)
			to_chat(L, span_warning("若由我自己教自己，我便同时成了问题与答案。"))
			return
		else
			if(L in range(1, usr))
				to_chat(usr, span_notice("我的学生需要一点时间来选择课程。"))
				var/chosen_skill = input(L, "大多数课程都要求你在所选技能上至少达到新手水平", "选择技能") as null|anything in choices
				var/datum/skill/item = choices[chosen_skill]
				if(!item)
					return
				if(alert(L, "你确定要学习[item.name]吗？", "学习", "学习", "取消") == "取消")
					return
				if(HAS_TRAIT(L, TRAIT_STUDENT))
					to_chat(L, span_warning("这么多知识我根本承受不住！"))
					to_chat(usr, span_warning("我的学生一下子承受不了这么多知识！"))
					return
				if(!(item in list(/datum/skill/misc/music, /datum/skill/craft/cooking, /datum/skill/craft/sewing, /datum/skill/misc/lockpicking, /datum/skill/misc/climbing, /datum/language/aavnic, /datum/language/celestial, /datum/language/draconic, /datum/language/dwarvish, /datum/language/elvish, /datum/language/etruscan, /datum/language/grenzelhoftian, /datum/language/gronnic, /datum/language/hammerholdian, /datum/language/hellspeak, /datum/language/kazengunese, /datum/language/orcish, /datum/language/otavan)) && L.get_skill_level(item) < SKILL_LEVEL_NOVICE)
					to_chat(L, span_warning("我还听不懂关于[item.name]的课程，我得先提升自己的基础！"))
					to_chat(usr, span_warning("我试着向[L]传授[item.name]，但学生还是没能领会这堂课！"))
					return
				if(L.has_language(item))
					to_chat(L, span_warning("这个我已经会了！[item.name]！"))
					to_chat(usr, span_warning("对方已经会说[item.name]了！"))
					return
				if(L.get_skill_level(item) > SKILL_LEVEL_EXPERT)
					to_chat(L, span_warning("关于[item.name]，那个人已经没有什么可教我的了！"))
					to_chat(usr, span_warning("对方对[item.name]的掌握比我还深，我真该来当老师吗？"))
					return
				else
					to_chat(L, span_notice("[usr]开始向我传授[item.name]!"))
					to_chat(usr, span_notice("[L]开始认真听我讲授[item.name]。"))
					if((item in list(/datum/language/aavnic, /datum/language/celestial, /datum/language/draconic, /datum/language/dwarvish, /datum/language/elvish, /datum/language/etruscan, /datum/language/grenzelhoftian, /datum/language/gronnic, /datum/language/hammerholdian, /datum/language/hellspeak, /datum/language/kazengunese, /datum/language/orcish, /datum/language/otavan)))
						if(do_after(usr, teachingtime, target = L))
							user.visible_message("<font color='yellow'>[user]向[L]传授了一课。</font>")
							to_chat(usr, span_notice("我的学生学会了[item.name]这门语言！"))
							L.grant_language(item)
							ADD_TRAIT(L, TRAIT_STUDENT, "[type]")
						else
							to_chat(usr, span_warning("[L]分心走开了！"))
							to_chat(L, span_warning("我必须把注意力更集中在学习上！"))


					else
						if(L.get_skill_level(item) < SKILL_LEVEL_APPRENTICE)
							if(do_after(usr, teachingtime, target = L))
								user.visible_message("<font color='yellow'>[user]向[L]传授了一课。</font>")
								to_chat(usr, span_notice("我的学生对[item.name]的掌握大有长进！"))
								z121_ethos_teach_rank(L, item, 2, user)
								ADD_TRAIT(L, TRAIT_STUDENT, "[type]")
							else
								to_chat(usr, span_warning("[L]分心走开了！"))
								to_chat(L, span_warning("我必须更专注于自己的学习！"))
								return
						else
							if(do_after(usr, teachingtime, target = L))
								user.visible_message("<font color='yellow'>[user]向[L]传授了一课。</font>")
								to_chat(usr, span_notice("我的学生对[item.name]更加熟练了！"))
								z121_ethos_teach_rank(L, item, 1, user)
								ADD_TRAIT(L, TRAIT_STUDENT, "[type]")
							else
								to_chat(usr, span_warning("[L]分心走开了！"))
								to_chat(L, span_warning("我必须把注意力更集中在学习上！"))
								return
			else
				to_chat(usr, span_warning("我的学生在那边几乎听不见我说话。"))
				return
	else
		revert_cast()
		return FALSE

// 仅成功授课调用此处，基础经验及额外经验共享同一组倍率。
/proc/z121_ethos_teach_rank(mob/living/student, skill, levels, mob/teacher)
	// 两位导师并行授课时，只能由首个成功结束的课程授予经验。
	if(HAS_TRAIT(student, TRAIT_STUDENT))
		return FALSE
	if(!ishuman(student))
		return student.adjust_skillrank(skill, levels, FALSE)
	var/mob/living/carbon/human/H = student
	var/datum/skill/S = GetSkillRef(skill)
	var/before = H.ensure_skills().skill_experience[S]
	var/old_level = H.get_skill_level(skill)
	H.adjust_skillrank(skill, levels, FALSE)
	var/base_gain = H.ensure_skills().skill_experience[S] - before
	if(base_gain <= 0)
		return
	var/datum/z121_ethos/R = H.z121_get_ethos()
	var/multiplier = H.z121_genius_experience(1)
	if(R?.virtues["humility"] && teacher && teacher.get_skill_level(skill) > old_level)
		multiplier *= 1.3
	if(multiplier > 1)
		H.ensure_skills().adjust_experience(skill, base_gain * (multiplier - 1), TRUE)
	R?.experience_settled(skill, before, H.ensure_skills().skill_experience[S], FALSE)

// 阅读只结算学习经验，不能领取勤勉的劳动倍率与心情。
/proc/z121_ethos_study_experience(mob/student, skill, amount)
	return z121_ethos_failed_learning(student, skill, amount, TRUE)

/obj/item/skillbook/attack_self(mob/living/user)
	var/reading_skill = user.get_skill_level(/datum/skill/misc/reading)
	var/subject_skill = user.get_skill_level(subject)
	if(complete)
		if(open)
			to_chat(user, span_warning("我已经在阅读[src]了！"))
			return
		if(reading_skill < skill_req || subject_skill < skill_req)
			to_chat(user, span_warning("[src]对我来说太深奥了！"))
			return
		if(subject_skill >= skill_cap)
			to_chat(user, span_warning("[src]能教我的东西，我已经全都懂了！"))
			return
		if(HAS_TRAIT(user, TRAIT_STUDENT))
			to_chat(user, span_warning("我暂时已经学得太多了。"))
			return
		if(user?.mind?.sleep_adv.enough_sleep_xp_to_advance(subject, 2))
			to_chat(user, span_warning("我脑中关于[src]的知识已经太满了，需要先休息并整理心得。"))
			return
		to_chat(user,("我开始阅读[src]。"))
		open = TRUE
		update_icon()
		var/reading_duration = 80
		var/reading = TRUE
		var/reading_acceleration = 0
		while(reading)
			if(do_after(user, reading_duration - (reading_acceleration * 10)))
				if(reading_acceleration < 4)
					reading_acceleration++
					if(reading_acceleration == 2)
						to_chat(user,("我渐渐进入了阅读[src]的状态。"))
					if(reading_acceleration == 4)
						to_chat(user,("我已经完全沉浸在[src]之中了。"))
				if(subject != /datum/skill/misc/reading)
					add_sleep_experience(user, /datum/skill/misc/reading, user.STAINT*0.75)
				z121_ethos_study_experience(user, subject, user.STAINT * (1.5 * (wellwritten+1)))
				subject_skill = user.get_skill_level(subject)
				var/skill_difference = skill_cap - subject_skill
				if(user?.mind?.sleep_adv.enough_sleep_xp_to_advance(subject, min(skill_difference,2)) || skill_difference <= 0)
					reading = FALSE
					ADD_TRAIT(user, TRAIT_STUDENT, TRAIT_GENERIC)
					to_chat(user,span_notice("我从[src]中学到了很多，在再次阅读前需要先休息。"))
			else
				reading = FALSE
		to_chat(user,("我停止阅读[src]。"))
		open = FALSE
		update_icon()
	else
		if(writing_page)
			if(!skill_cap)
				choose_skill(user)
				return
			to_chat(user, span_notice("我从[src]里抽出一页。"))
			new /obj/item/paper(get_turf(src))
			writing_page = FALSE
			return
		if(reading_skill < skill_cap || subject_skill < skill_cap)
			to_chat(user, span_warning("我没法对[src]做什么。"))
			return
		if(alert("准备好完成这本书了吗？", "写作者", "是", "否") == "是")
			to_chat(user,"我开始完成最后的书写……")
			if(do_after(user, 50))
				to_chat(user, span_notice("我完成了这本书！"))
				add_sleep_experience(user, /datum/skill/misc/reading, user.STAINT*1.5)
				var/obj/item/skillbook/newbook = new /obj/item/skillbook(get_turf(src))
				newbook.set_bookstats(skill_req,skill_cap,subject)
				if(HAS_TRAIT(user, TRAIT_GOODWRITER))
					newbook.wellwritten = TRUE
				qdel(src)

// 主动求学与教师授课使用同一个成功结算入口。
/obj/effect/proc_holder/spell/invoked/learn/cast(list/targets, mob/user = usr)
	. = call(src, /obj/effect/proc_holder/spell/proc/cast)(arglist(args))
	if(isliving(targets[1]))
		var/mob/living/teacher = targets[1]
		if(teacher == user)
			to_chat(user, span_warning("若由我自己教自己，我便同时成了问题与答案。"))
			revert_cast()
			return
		if(HAS_TRAIT(user, TRAIT_STUDENT))
			to_chat(user, span_warning("这段时间里，我已经学不到更多了。"))
			revert_cast()
			return
		if(teacher.cmode)
			to_chat(user, span_warning("[teacher]正在战斗中！"))
			to_chat(teacher, span_warning("[user]想向你学习，但你正在战斗中。"))
			revert_cast()
			return
		if(!(teacher in range(2, user)))
			revert_cast()
			return FALSE
		to_chat(usr, span_notice("我请求[teacher]传授我[teacher.p_their()]一项技能。"))
		if(alert(teacher, "要把你的一项技能传授给[user]吗？", "教学", "是", "否") != "是")
			to_chat(user, span_warning("[teacher]决定保留[teacher.p_their()]知识，不向外传授。"))
			revert_cast()
			return
		to_chat(user, span_nicegreen("[teacher]决定教导你。靠近一些，等对方决定要传授什么......"))

		var/list/known_skills = list()
		var/list/skill_names = list()
		if(teacher.mind)
			var/teacher_skill = 0
			var/user_skill = 0
			for(var/skill_type in SSskills.all_skills)
				var/datum/skill/skill = GetSkillRef(skill_type)
				if(skill in teacher.skills?.known_skills)
					teacher_skill = teacher.get_skill_level(skill_type)
					user_skill = user.get_skill_level(skill_type)
					if(teacher_skill > user_skill)
						LAZYADD(skill_names, skill)
						LAZYADD(known_skills,skill_type)

			if(!length(known_skills))
				to_chat(teacher, span_warning("[user]已经掌握了我能教的一切。"))
				to_chat(user, span_warning("[teacher]已经没什么能教我的了。"))
				revert_cast()
				return
			var/skill_choice = input(teacher, "选择要教授的技能","技能") as null|anything in skill_names
			if(skill_choice)
				for(var/real_skill in known_skills)
					if(skill_choice == GetSkillRef(real_skill))
						if(!(teacher in range(2, user)))
							to_chat(teacher, span_warning("我离[user]太远了。"))
							to_chat(user, span_warning("[teacher]离我太远了。"))
							revert_cast()
							return
						teacher.visible_message(("[teacher]开始向[user]传授[skill_choice]。"), ("我开始向[user]传授[skill_choice]。"))
						if(!do_mob(user, teacher, 100))
							to_chat(teacher, span_warning("我离[user]太远了。"))
							to_chat(user, span_warning("[teacher]离我太远了。"))
							revert_cast()
							return

						teacher_skill = teacher.get_skill_level(real_skill)
						user_skill = user.get_skill_level(real_skill)
						// 等待期间已被授课或导师不再领先，不能重复领取本次教学。
						if(HAS_TRAIT(user, TRAIT_STUDENT) || teacher_skill <= user_skill)
							revert_cast()
							return
						if(teacher_skill - user_skill > 2)
							z121_ethos_teach_rank(user, real_skill, 2, teacher)
							user.visible_message(span_notice("[teacher]向[user]传授了[skill_choice]。"), span_notice("我对[skill_choice]的掌握大有长进！"))
						else
							z121_ethos_teach_rank(user, real_skill, 1, teacher)
							user.visible_message(span_notice("[teacher]向[user]传授了[skill_choice]。"), span_notice("我对[skill_choice]的掌握更熟练了！"))
						ADD_TRAIT(user, TRAIT_STUDENT, TRAIT_GENERIC)
	revert_cast()
	return FALSE
