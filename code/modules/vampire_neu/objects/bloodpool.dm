#define VAMPCOST_ONE 8000
#define VAMPCOST_TWO 10000
#define VAMPCOST_THREE 12000
#define VAMPCOST_FOUR 14000
#define ARMOR_COST 5000
#define SUN_STEAL_COST 10000
#define SERVANT_COST 800
#define SERVANT_T2_COST 2500
#define SERVANT_T3_COST 4000

#define INITIATE_LORDE 1
#define INITIATE_ANYONE 2

/obj/structure/vampire/bloodpool
	name = "猩红熔炉"
	icon_state = "vat"
	var/current = 0
	var/datum/clan/owner_clan

	var/list/active_projects = list()
	var/list/available_project_types = list(
		/datum/vampire_project/power_growth,
		/datum/vampire_project/armor_crafting,
		/datum/vampire_project/servant/servant_t1,
		/datum/vampire_project/servant/servant_t2,
		/datum/vampire_project/servant/servant_t3,
		/datum/vampire_project/sunsteal,
	)
	var/sunstolen = FALSE

/obj/structure/vampire/bloodpool/Initialize(mapload)
	. = ..()
	set_light(3, 3, 20, l_color = LIGHT_COLOR_BLOOD_MAGIC)

/obj/structure/vampire/bloodpool/examine(mob/user)
	. = ..()
	to_chat(user, span_boldnotice("血液存量：[current]"))

	// Show active projects
	if(active_projects.len)
		to_chat(user, span_notice("进行中的项目："))
		for(var/project_key in active_projects)
			var/datum/vampire_project/project = active_projects[project_key]
			var/progress_percent = round((project.paid_amount / project.total_cost) * 100, 1)
			to_chat(user, span_notice("- [project.display_name]: [project.paid_amount]/[project.total_cost] ([progress_percent]%)"))

/obj/structure/vampire/bloodpool/attack_hand(mob/living/user)
	var/datum/antagonist/vampire/vampire = user.mind?.has_antag_datum(/datum/antagonist/vampire)
	if(!vampire)
		return

	var/lord = FALSE
	if(user.clan?.clan_leader == user)
		lord = TRUE

	var/list/available_options_lord = list()
	var/list/available_options_contributor = list()

	// Add available project types that aren't already active
	for(var/project_type in available_project_types)
		var/datum/vampire_project/temp_project = new project_type()
		if(temp_project.can_start(user, src, TRUE) && !(project_type in active_projects))
			available_options_lord[temp_project.display_name] = project_type
		qdel(temp_project)

	// Add option to contribute to existing projects
	if(active_projects.len)
		available_options_lord["为项目献血"] = "contribute"
		available_options_contributor["为项目献血"] = "contribute"
	// Add option to view/cancel projects
	if(active_projects.len)
		available_options_lord["管理项目"] = "manage"

	var/choice = input(user, "要做什么？", "血族") as null|anything in available_options_lord
	if(!choice)
		return

	var/action_lord = available_options_lord[choice]
	var/action_contributor = available_options_contributor[choice]

	if(lord)
		switch(action_lord)
			if("contribute")
				handle_project_contribution(user)
			if("manage")
				handle_project_management(user)
			else
				// It's a project type
				start_new_project(action_lord, user)
	else
		switch(action_contributor)
			if("contribute")
				handle_project_contribution(user)

/obj/structure/vampire/bloodpool/proc/start_new_project(project_type, mob/living/user)
	var/datum/vampire_project/project = new project_type()

	if(!project.can_start(user, src))
		to_chat(user, span_warning(project.start_failure_message))
		qdel(project)
		return

	if(!project.confirm_start(user))
		qdel(project)
		return

	project.bloodpool = src
	project.initiator = user
	project.initiator_clan = user.clan
	project.on_start(user)

	active_projects[project_type] = project

	to_chat(user, span_greentext("项目已启动：[project.display_name]。献出命髓以推进项目。"))

/obj/structure/vampire/bloodpool/proc/handle_project_contribution(mob/living/user)
	if(!active_projects.len)
		to_chat(user, span_warning("没有可供献血的进行中项目。"))
		return

	var/list/project_choices = list()
	for(var/project_type in active_projects)
		var/datum/vampire_project/project = active_projects[project_type]
		var/remaining = project.total_cost - project.paid_amount
		project_choices["[project.display_name]（剩余：[remaining]）"] = project_type

	var/choice = input(user, "选择要献血的项目：", "献血") as null|anything in project_choices
	if(!choice)
		return

	var/project_type = project_choices[choice]
	var/datum/vampire_project/project = active_projects[project_type]

	project.handle_contribution(user)

/obj/structure/vampire/bloodpool/proc/handle_project_management(mob/living/user)
	if(!active_projects.len)
		to_chat(user, span_warning("没有可管理的进行中项目。"))
		return

	var/list/project_options = list()
	for(var/project_type in active_projects)
		var/datum/vampire_project/project = active_projects[project_type]
		var/progress_percent = round((project.paid_amount / project.total_cost) * 100, 1)
		project_options["[project.display_name] ([progress_percent]%)"] = project_type

	var/choice = input(user, "选择要管理的项目：", "项目管理") as null|anything in project_options
	if(!choice)
		return

	var/project_type = project_options[choice]
	var/datum/vampire_project/project = active_projects[project_type]

	var/action = input(user, "你想做什么？", "管理") as null|anything in list("查看详情", "取消项目")

	switch(action)
		if("查看详情")
			project.show_details(user)
		if("取消项目")
			if(alert(user, "取消[project.display_name]？<BR>所有已投入的命髓都会退还。", "取消项目", "是", "否") == "是")
				cancel_project(project_type)

/obj/structure/vampire/bloodpool/proc/complete_project(project_type)
	var/datum/vampire_project/project = active_projects[project_type]
	if(!project)
		return

	// Detach before running effects, so a second call can't run them (or a refund) again
	active_projects.Remove(project_type)

	// Notify all contributors
	for(var/mob/living/contributor in project.contributors)
		to_chat(contributor, span_boldannounce("[project.display_name]已经完成！"))
		contributor.playsound_local(get_turf(src), project.completion_sound, 100, FALSE, pressure_affected = FALSE)

	// Execute project completion
	project.on_complete(src)

	qdel(project)

/obj/structure/vampire/bloodpool/proc/cancel_project(project_type)
	var/datum/vampire_project/project = active_projects[project_type]
	if(!project)
		return

	active_projects.Remove(project_type)

	project.on_cancel()

	qdel(project)

/datum/vampire_project
	var/display_name = "未知项目"
	var/description = "一项神秘的事业。"
	var/total_cost = 1000
	var/paid_amount = 0
	/// Assoc list of contributor mob -> vitae they personally paid in, so refunds can't mint blood
	var/list/contributors = list()
	var/obj/structure/vampire/bloodpool/bloodpool
	var/mob/living/initiator
	var/datum/clan/initiator_clan
	var/start_failure_message = "无法启动此项目。"
	var/completion_sound = 'sound/misc/batsound.ogg'
	var/can_be_initiated_by = INITIATE_LORDE

/datum/vampire_project/proc/can_start(mob/living/carbon/human/user, obj/structure/vampire/bloodpool/pool, silent = FALSE)
	if(!istype(user) || !istype(pool))
		return FALSE

	if(can_be_initiated_by == INITIATE_ANYONE)
		return TRUE
	else if(can_be_initiated_by == INITIATE_LORDE)
		if(user.clan.clan_leader == user)
			return TRUE
		else
			if(!silent)
				to_chat(user, span_warning("只有你的领主才能启动此项目。"))
			return FALSE

	return TRUE

/datum/vampire_project/proc/confirm_start(mob/living/user)
	return alert(user, "启动[display_name]？[description] 总消耗：[total_cost]。你可以分次献出命髓。", "启动项目", "启动", "取消") == "启动"

/datum/vampire_project/proc/on_start(mob/living/user)
	return

/datum/vampire_project/proc/get_max_contribution(mob/living/user)
	var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	var/headroom = total_cost - paid_amount
	if(!lord && (display_name != "邪铸板甲") && (display_name != "World Anchor"))
		headroom -= 100
	return min(user.get_bloodpool(), headroom)

/datum/vampire_project/proc/handle_contribution(mob/living/user)
	var/max_contribution = get_max_contribution(user)
	if(max_contribution <= 0)
		to_chat(user, span_warning("我已无法再为[display_name]献出命髓。"))
		return

	var/contribution = input(user, "献出多少命髓？（最多：[max_contribution]）", "献血") as num|null

	if(!contribution || contribution <= 0)
		return

	// Revalidate after the blocking prompt - the project may have finished, been cancelled, or been paid down further
	if(QDELETED(src) || !bloodpool || !(bloodpool.active_projects[type] == src))
		to_chat(user, span_warning("[display_name]已不再进行。"))
		return

	if(user.get_bloodpool() < contribution)
		to_chat(user, span_warning("我的命髓不足。"))
		return

	contribution = clamp(round(contribution), 1, max_contribution)

	user.adjust_bloodpool(-contribution)
	paid_amount += contribution
	contributors[user] += contribution

	to_chat(user, span_greentext("已为[display_name]献出[contribution]命髓。（[paid_amount]/[total_cost]）"))

	if(paid_amount >= total_cost)
		bloodpool.complete_project(type)

/datum/vampire_project/proc/show_details(mob/living/user)
	to_chat(user, span_notice("项目：[display_name]"))
	to_chat(user, span_notice("描述：[description]"))
	to_chat(user, span_notice("进度：[paid_amount]/[total_cost]"))
	to_chat(user, span_notice("献血者：[english_list(contributors)]"))

/datum/vampire_project/proc/on_complete()
	return

/datum/vampire_project/proc/on_cancel()
	// Refund each contributor exactly what they paid in, then zero the ledger so it can't be paid out twice
	for(var/mob/living/contributor in contributors)
		var/refund_amount = contributors[contributor]
		if(refund_amount <= 0)
			continue
		contributor.adjust_bloodpool(refund_amount)
		to_chat(contributor, span_notice("项目[display_name]已取消，退还了[refund_amount]命髓。"))

	contributors.Cut()
	paid_amount = 0

// Specific project types
/datum/vampire_project/power_growth
	display_name = "复苏之仪"
	description = "古老之血再度涌动，被遗忘的低语回荡在大地骨髓之中。"
	total_cost = VAMPCOST_ONE
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth/can_start(mob/living/user, obj/structure/vampire/bloodpool/pool)
	var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	return lord && !lord.ascended

/datum/vampire_project/power_growth/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			to_chat(user, span_greentext("众人的献祭使我的力量不断增长。"))
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			lord_body.adjust_maxbloodpool(1000)
			bloodpool.available_project_types -= /datum/vampire_project/power_growth
			bloodpool.available_project_types += /datum/vampire_project/power_growth_2
			break

/datum/vampire_project/power_growth_2
	display_name = "归还之仪"
	description = "封存已久的力量重新归来。泥土、岩石与暗影再次臣服于它们真正的主人。"
	total_cost = VAMPCOST_TWO
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_2/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			to_chat(user, span_greentext("众人的献祭使我的力量不断增长。"))
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			lord_body.adjust_maxbloodpool(1000)
			bloodpool.available_project_types -= /datum/vampire_project/power_growth_2
			bloodpool.available_project_types += /datum/vampire_project/power_growth_3
			break

/datum/vampire_project/power_growth_3
	display_name = "统御之仪"
	description = "时间的帷幕被撕裂。长老的意志倾泻而出，将闯入者禁锢于大地的掌握之中。"
	total_cost = VAMPCOST_THREE
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_3/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			to_chat(user, span_greentext("众人的献祭使我的力量不断增长。"))
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			lord_body.adjust_maxbloodpool(1000)
			bloodpool.available_project_types -= /datum/vampire_project/power_growth_3
			bloodpool.available_project_types += /datum/vampire_project/power_growth_4
			break

/datum/vampire_project/power_growth_4
	display_name = "君临之仪"
	description = "领主已重归完整。古老的力量浸透每块岩石与每条血脉，大地与其主人本为一体。"
	total_cost = VAMPCOST_FOUR
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_4/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			lord_body.adjust_maxbloodpool(1000)
			to_chat(user, span_danger("我即亘古，我即大地。就连太阳也向我俯首。"))
			lord.ascended = TRUE
			var/list/all_subordinates = user.clan_position.get_all_subordinates()
			for(var/mob/living/carbon/human/subordinate_body  in all_subordinates)
				subordinate_body.adjust_maxbloodpool(1000)
				for(var/S in MOBSTATS)
					subordinate_body.change_stat(S, 2)

			bloodpool.available_project_types -= /datum/vampire_project/power_growth_4
			break

/datum/vampire_project/armor_crafting
	display_name = "邪铸板甲"
	description = "用结晶之血打造一整套血族盔甲。"
	total_cost = 5000
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/armor_crafting/on_complete(atom/movable/creation_point)
	new /obj/item/clothing/under/roguetown/platelegs/vampire (bloodpool.loc)
	new /obj/item/clothing/suit/roguetown/armor/chainmail/iron/vampire (bloodpool.loc)
	new /obj/item/clothing/suit/roguetown/armor/plate/vampire (bloodpool.loc)
	new /obj/item/clothing/shoes/roguetown/boots/armor/vampire (bloodpool.loc)
	new /obj/item/clothing/head/roguetown/helmet/heavy/vampire (bloodpool.loc)
	new /obj/item/clothing/gloves/roguetown/chain/vampire (bloodpool.loc)
	creation_point.visible_message(span_notice("一整套盔甲从猩红熔炉中凝现。"))

/datum/vampire_project/sunsteal
	display_name = "窃取太阳"
	description = "太阳暴君灼热的目光将不再阻挠我们的计划。只有你的领主才能启动此项目。"
	total_cost = SUN_STEAL_COST
	completion_sound = 'sound/misc/vcraft.ogg'
	can_be_initiated_by = INITIATE_LORDE

/datum/vampire_project/sunsteal/on_complete(atom/movable/creation_point)
	var/obj/structure/vampire/bloodpool/bloodpool = creation_point
	if(!istype(bloodpool))
		return

	SSticker.sunsteal(initiator_clan?.clan_leader)

/datum/vampire_project/servant/proc/summon(type, atom/feedback_atom)
	feedback_atom.visible_message("熔炉开始翻涌，从异界召唤一名仆从……")
	var/list/candidates = pollGhostCandidates("你想扮演血族的[type == "Vampire Servant" ? "仆从" : type == "Vampire Guard" ? "卫士" : "骑士子嗣"]吗？", ROLE_VAMPIRE_SUMMON, null, null, 10 SECONDS, POLL_IGNORE_VL_SERVANT)
	if(!LAZYLEN(candidates))
		feedback_atom.visible_message("然而，深处空无一物……")
		return FALSE

	var/mob/C = pick(candidates)
	if(!C || !istype(C, /mob/dead))
		feedback_atom.visible_message("然而，深处空无一物……")
		return FALSE

	. = TRUE

	if(istype(C, /mob/dead/new_player))
		var/mob/dead/new_player/N = C
		N.close_spawn_windows()

	var/mob/living/carbon/human/species/human/northern/target = new /mob/living/carbon/human/species/human/northern(get_turf(feedback_atom))
	target.key = C.key
	target.visible_message(span_warning("[target]的眼中亮起诡异的光芒！"))
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, load_char_or_namechoice)), 3 SECONDS)
	switch(type)
		if("Vampire Servant")
			SSjob.EquipRank(target, "Vampire Servant", TRUE)
			var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = initiator_clan, forced_clan = TRUE, generation = GENERATION_THINBLOOD)
			target.mind.add_antag_datum(new_antag)
		if("Vampire Guard")
			SSjob.EquipRank(target, "Vampire Guard", TRUE)
			var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = initiator_clan, forced_clan = TRUE, generation = GENERATION_NEONATE)
			target.mind.add_antag_datum(new_antag)
		if("Vampire Spawn")
			SSjob.EquipRank(target, "Vampire Spawn", TRUE)
			var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = initiator_clan, forced_clan = TRUE, generation = GENERATION_ANCILLAE)
			target.mind.add_antag_datum(new_antag)
	ADD_TRAIT(target, TRAIT_BLOODPOOL_BORN, TRAIT_GENERIC)

/datum/vampire_project/servant/servant_t1
	display_name = "召唤仆从"
	description = "一名听命于你的忠诚仆从。"
	total_cost = SERVANT_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/servant/servant_t1/on_complete(obj/structure/vampire/bloodpool/creation_point)
	if(!summon("Vampire Servant", creation_point))
		on_cancel()

/datum/vampire_project/servant/servant_t2
	display_name = "召唤卫士"
	description = "一名听命于你的忠诚仆从。"
	total_cost = SERVANT_T2_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/servant/servant_t2/on_complete(obj/structure/vampire/bloodpool/creation_point)
	if(!summon("Vampire Guard", creation_point))
		on_cancel()

/datum/vampire_project/servant/servant_t3
	display_name = "召唤骑士子嗣"
	description = "一名听命于你的忠诚仆从。"
	total_cost = SERVANT_T3_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/servant/servant_t3/on_complete(obj/structure/vampire/bloodpool/creation_point)
	if(!summon("Vampire Spawn", creation_point))
		on_cancel()

#undef VAMPCOST_ONE
#undef VAMPCOST_TWO
#undef VAMPCOST_THREE
#undef VAMPCOST_FOUR
#undef ARMOR_COST
#undef SUN_STEAL_COST
#undef SERVANT_COST
#undef SERVANT_T2_COST
#undef SERVANT_T3_COST
