#define LIST_PRAISE_ZIZO list("赞美齐佐！", "齐佐万岁！", "荣耀归于苍白女士！", "齐佐！齐佐！齐佐！")

/datum/antagonist/zizocultist
	name = "齐佐教徒"
	roundend_category = "齐佐教徒"
	antagpanel_category = "齐佐密教"
	rogue_enabled = TRUE
	job_rank = ROLE_ZIZOIDCULTIST
	antag_hud_type = ANTAG_HUD_ZIZO
	antag_hud_name = "zcult_hud"
	confess_lines = list(
		"愿十神尽灭！",
		"赞美齐佐！",
		"我即是未来！",
		"世上没有神，只有主宰！",
	)
	var/islesser = TRUE
	var/start_budget = 20
	var/start_points = 0
	var/change_stats = TRUE
	var/mutable_appearance/halo
	var/list/innate_traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_CABAL,
		TRAIT_HERESIARCH,
	)

/datum/antagonist/zizocultist/roundstart
	start_budget = 26
	start_points = 5

/datum/antagonist/zizocultist/leader
	name = "齐佐教徒"
	islesser = FALSE
	innate_traits = list(
		TRAIT_DECEIVING_MEEKNESS,
		TRAIT_STEELHEARTED,
		TRAIT_NOMOOD,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_CABAL,
		TRAIT_HERESIARCH,
	)

/datum/antagonist/zizocultist/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	for(var/trait in innate_traits)
		ADD_TRAIT(M, trait, "zizocultist")
	if(has_world_trait(/datum/world_trait/zizo_bite))
		ADD_TRAIT(M, TRAIT_RESISTCOLD, "zizocultist")
	if(has_world_trait(/datum/world_trait/zizo_rot))
		ADD_TRAIT(M, TRAIT_NOHUNGER, "zizocultist")
	M.apply_status_effect(/datum/status_effect/buff/zizo_gate_sense)
	M.faction |= "zizo_cult"

/datum/antagonist/zizocultist/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	for(var/trait in innate_traits)
		REMOVE_TRAIT(M, trait, "zizocultist")
	REMOVE_TRAIT(M, TRAIT_RESISTCOLD, "zizocultist")
	REMOVE_TRAIT(M, TRAIT_NOHUNGER, "zizocultist")
	M.remove_status_effect(/datum/status_effect/buff/zizo_gate_sense)
	M.remove_status_effect(/datum/status_effect/buff/zizo_gate_pull)
	M.faction -= "zizo_cult"

/datum/antagonist/zizocultist/on_gain()
	. = ..()
	var/mob/living/carbon/human/H = owner.current
	SSmapping.retainer.cultists |= owner
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(refresh_zizo_marks)), 15 SECONDS, TIMER_UNIQUE | TIMER_LOOP)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(zizo_roll_start)), 1 MINUTES, TIMER_UNIQUE)
	H.set_patron(/datum/patron/inhumen/zizo)
	H.cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'
	H.playsound_local(get_turf(H), 'sound/music/maniac.ogg', 80, FALSE, pressure_affected = FALSE)
	H.verbs |= /mob/living/carbon/human/proc/communicate
	H.verbs |= /mob/living/carbon/human/proc/zizo_targets_list
	H.purity = FALSE

	H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_JOURNEYMAN)

	owner.special_role = ROLE_ZIZOIDCULTIST
	add_objective(/datum/objective/zizo)
	H.verbs |= /mob/living/carbon/human/proc/release_minion
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT)
	H.grant_language(/datum/language/undead)
	owner.zizo_points += start_points
	new /datum/antag_setup(owner.current, start_budget)
	add_antag_hud(antag_hud_type, antag_hud_name, owner.current)
	greet()

/datum/antagonist/zizocultist/proc/add_halo()
	halo = mutable_appearance('icons/roguetown/cult/halo.dmi', "halo1", ABOVE_ALL_MOB_LAYER)
	owner.current.add_overlay(halo)

/datum/antagonist/zizocultist/on_removal()
	SSmapping.retainer.cultists -= owner
	owner.current?.cut_overlay(halo)
	remove_own_antag_hud()
	var/mob/living/carbon/human/H = owner?.current
	if(istype(H))
		H.verbs -= /mob/living/carbon/human/proc/communicate
		H.verbs -= /mob/living/carbon/human/proc/zizo_targets_list
		H.verbs -= /mob/living/carbon/human/proc/release_minion
		for(var/key in owner.antag_setup_stats)
			H.change_stat(key, -owner.antag_setup_stats[key])
		if(owner.antag_setup_trait)
			REMOVE_TRAIT(H, owner.antag_setup_trait, TRAIT_GENERIC)
		for(var/datum/antag_setup/S in GLOB.antag_setups)
			if(S.user == H)
				qdel(S)
	owner.antag_setup_stats = null
	owner.antag_setup_trait = null
	return ..()

/datum/antagonist/zizocultist/greet()
	to_chat(owner, span_danger("我侍奉全能者。世人称她为不可言说者。新的时代开始了。"))
	owner.announce_objectives()

/datum/antagonist/zizocultist/leader/greet()
	to_chat(owner, span_danger("我侍奉全能者。世人称她为不可言说者。我需要仆从协助我主持仪式。我必将飞升。"))
	owner.announce_objectives()

/datum/antagonist/zizocultist/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/zizocultist/leader))
		return span_boldnotice("我们的首领！")
	if(istype(examined_datum, /datum/antagonist/zizocultist))
		return span_boldnotice("一名齐佐教徒。")
	if(istype(examined_datum, /datum/antagonist/assassin))
		return span_boldnotice("格拉加尔的信徒！格拉加尔的教徒！")

/datum/antagonist/zizocultist/can_be_owned(datum/mind/new_owner)
	. = ..()
	if(.)
		if(new_owner.current == SSticker.rulermob)
			return FALSE
		if(new_owner.unconvertable)
			return FALSE

/datum/antagonist/zizocultist/proc/add_cultist(datum/mind/cult_mind)
	cult_mind.add_antag_datum(/datum/antagonist/zizocultist)

/datum/antagonist/zizocultist/proc/add_objective(datum/objective/O)
	objectives += new O

/datum/objective/zizo
	name = "飞升"
	explanation_text = "让一名教徒成功飞升。打开研究菜单可查阅仪式。"
	team_explanation_text = "让一名教徒成功飞升。打开研究菜单可查阅仪式。"
	triumph_count = 5

/datum/objective/zizo/check_completion()
	if(SSmapping.retainer.cult_ascended)
		return TRUE

/mob/living/carbon/human/proc/praise()
	set name = "赞美黑暗女士！"
	set category = "齐佐"

	if(stat >= UNCONSCIOUS || !can_speak_vocal())
		return
	say(pick(LIST_PRAISE_ZIZO), spans = list("god_zizo"), sanitize = FALSE, language = /datum/language/undead)
	playsound(src, 'sound/vo/cult/praise.ogg', 45, 1)
	log_say("[src]礼赞了齐佐！（密教徒指令）")
	if(istype(get_area(src), /area/rogue/indoors/town/church))
		complete_zgoal(src, /datum/zizogoal/worshipzizo_church)
	if(istype(get_area(src), /area/rogue/indoors/town/garrison))
		complete_zgoal(src, /datum/zizogoal/worshipzizo_garrison)
	if(istype(get_area(src), /area/rogue/indoors/town/warden))
		complete_zgoal(src, /datum/zizogoal/worshipzizo_warden)
	var/observers = 0
	for(var/mob/living/carbon/human/L in hearers(7, src))
		if(L != src && L.stat != DEAD && L.mind && !is_zizo(L))
			observers++
	if(observers > 2)
		complete_zgoal(src, /datum/zizogoal/worshipzizo)

/mob/living/carbon/human/proc/zizo_objectives()
	set name = "秘闻任务"
	set category = "齐佐"

	if(!length(zizo_goals))
		reroll_goals(src)
	for(var/datum/zizogoal/gl in zizo_goals)
		if(gl.complete)
			to_chat(src, "<B>[gl.name]：</B>[gl.desc]<BR><B>已完成。</B><BR>")
		else
			to_chat(src, "<B>[gl.name]：</B>[gl.desc]<BR><B>奖励 [gl.reward] 点秘闻。</B><BR>")

/mob/living/carbon/human/proc/zizo_targets_list()
	set name = "密教秘闻"
	set category = "齐佐"

	var/list/lines = list("除了同教成员、匪徒和恶徒，<B>任何人都可以献祭或招入教中</B>。统治者只能在最后的飞升仪式中献祭。")
	if(length(GLOB.gate_targets))
		lines += "<B>开门仪式的祭品：</B>"
		for(var/mob/living/carbon/human/T in GLOB.gate_targets)
			lines += "- [T.real_name]（[SSjob.GetJob(T.mind?.assigned_role)?.display_title || T.mind?.assigned_role]）"
		for(var/atype in GLOB.zizo_bestow_areas)
			var/area/A = atype
			lines += "开门仪式地点：[initial(A.name)]"
	lines += "<B>仪式指南：</B>将祭品放在臣服符印中央。献祭时须有另一名教徒持刀站在符印上。若教中已有三人以上，招募新教徒时也须有另一名教徒站在符印上。开门仪式指定的祭品头顶会浮现一只黑眼，你可以循着心口的痛感寻找他们。"
	to_chat(src, jointext(lines, "<BR>"))

/mob/living/carbon/human/proc/communicate()
	set name = "向教徒传念"
	set category = "齐佐"

	if(stat >= UNCONSCIOUS || !can_speak_vocal())
		return

	var/speak = input("你想说什么？", "齐佐") as text|null
	if(!speak)
		return
	whisper("O schlet'a ty'schkotot ty'skvoro...")
	sleep(5)
	if(stat >= UNCONSCIOUS || !can_speak_vocal())
		return
	whisper("[speak]")

	for(var/datum/mind/V in SSmapping.retainer.cultists)
		to_chat(V, "<span style = \"font-size:110%; font-weight:bold\"><span style = 'color:#8a13bd'>来自</span><span style = 'color:#[voice_color]'>[real_name]</span>的传念：[speak]</span>")
		playsound_local(V.current, 'sound/vo/cult/skvor.ogg', 100)

	log_say("[key_name(src)]向教徒传念：[speak]")

/mob/living/carbon/human/proc/release_minion()
	set name = "处决仆从"
	set category = "齐佐"

	if(stat == DEAD)
		return

	var/list/mob/living/carbon/human/possible = list()
	for(var/datum/mind/V in SSmapping.retainer.cultists)
		if(V.special_role == "Zizoid Lackey")
			possible |= V.current

	var/mob/living/carbon/human/choice = input(src, "哪个仆从对你已无用处？", "齐佐") as null|anything in possible
	if(choice)
		var/alert = tgui_alert(src, "确定要撕碎这名仆从的灵魂吗？", "齐佐", list("确定", "取消"))
		if(alert == "确定")
			visible_message(span_danger("[src]伸出手，撕碎了[choice]的灵魂！"))
			to_chat(choice, span_danger("我辜负了首领！我辜负了齐佐！如今只剩一死！"))
			sleep(20)
			choice.gib()
			SSmapping.retainer.cultists -= choice.mind

#undef LIST_PRAISE_ZIZO

/mob/living/carbon/human/proc/zizo_lore()
	set name = "研究仪式"
	set category = "齐佐"
	GLOB.zizo_research.ui_interact(src)
