/datum/stressevent/lovezizo
	timer = 99999 MINUTES
	stressadd = -666 // :)
	desc = span_green("齐佐齐佐齐佐")

/datum/stressevent/hatezizo
	timer = 99999 MINUTES
	stressadd = 10 // :)
	desc = "<span class='red'>齐佐齐佐齐佐</span>"

/datum/stressevent/leechcult
	timer = 1 MINUTES
	stressadd = 3
	desc = list("<span class='red'>我脑袋里有只小地精对我指手画脚，烦死了！</span>","<span class='red'>“杀了你的朋友。”</span>","<span class='red'>“让他们流血。”</span>","<span class='red'>“别给他们尖叫的时间。”</span>","<span class='red'>“赞美齐佐。”</span>","<span class='red'>“愿十神尽灭。”</span>","<span class='red'>“他们的血肉还能再用。”</span>")

/proc/is_zizocultist(datum/mind/M)
	return istype(M?.has_antag_datum(/datum/antagonist/zizocultist), /datum/antagonist/zizocultist/leader)

/proc/is_zizolackey(datum/mind/M)
	var/datum/antagonist/zizocultist/Z = M?.has_antag_datum(/datum/antagonist/zizocultist)
	return Z && !istype(Z, /datum/antagonist/zizocultist/leader)

GLOBAL_LIST_INIT(ritualslist, build_zizo_rituals())

/proc/build_zizo_rituals()
	. = list()
	for(var/datum/ritual/ritual as anything in subtypesof(/datum/ritual))
		if(initial(ritual.abstract_type) == ritual)
			continue
		.[ritual.name] = new ritual

// RITUAL DATUMS
/proc/ritual_available(mob/living/carbon/human/user, datum/ritual/ritual)
	if(initial(ritual.abstract_type) == ritual)
		return FALSE
	if(!(ritual in user.mind.zizo_researched))
		return FALSE
	if((initial(ritual.is_cultist_ritual) || !initial(ritual.lesser)) && !is_zizo(user))
		return FALSE
	if(ritual.passive == TRUE)
		return FALSE
	return TRUE

/proc/zizo_award(mob/M, amt)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	H.mind.zizo_points += amt
	to_chat(M, span_boldnotice("秘闻揭晓。（+[amt]）"))

/datum/zizogoal
	var/name = "任务"
	var/desc = "完成方式"
	var/reward = 2
	var/weight = 10
	var/complete = FALSE

/datum/zizogoal/worshipzizo
	name = "公开礼赞齐佐"
	desc = "在三名教外人士眼前礼赞齐佐。"

/datum/zizogoal/worshipzizo_church
	name = "在教堂礼赞齐佐"
	desc = "进入教堂，礼赞齐佐。"

/datum/zizogoal/drinklux
	name = "饮下灵辉"
	desc = "吞下一颗灵辉凝珠。"
	reward = 3

/datum/zizogoal/robgrave
	name = "盗墓"
	desc = "挖开墓地里一座有标记的坟墓。"

/datum/zizogoal/worshipzizo_garrison
	name = "在兵营礼赞齐佐"
	desc = "进入兵营，礼赞齐佐。"

/datum/zizogoal/worshipzizo_warden
	name = "在守望者堡垒礼赞齐佐"
	desc = "进入守望者堡垒，礼赞齐佐。"

/datum/zizogoal/profaneshrine_church
	name = "在教堂设立神龛"
	desc = "在教堂内举行“竖立亵渎神龛”仪式。"

/datum/zizogoal/profaneshrine_tavern
	name = "在酒馆设立神龛"
	desc = "在酒馆内举行“竖立亵渎神龛”仪式。"

/datum/zizogoal/profaneshrine_bath
	name = "在澡堂设立神龛"
	desc = "在澡堂内举行“竖立亵渎神龛”仪式。"

/datum/zizogoal/profaneshrine_academy
	name = "在学院设立神龛"
	desc = "在学院内举行“竖立亵渎神龛”仪式。"

/datum/zizogoal/profaneshrine_graveyard
	name = "在墓地设立神龛"
	desc = "在教堂墓地内举行“竖立亵渎神龛”仪式。"

/proc/complete_zgoal(mob/living/carbon/human/user, goal_type)
	for(var/datum/zizogoal/gl in user.zizo_goals)
		if(gl.type != goal_type)
			continue
		if(gl.complete)
			continue
		gl.complete = TRUE
		user.zizo_goals_complete |= gl.type
		zizo_award(user, gl.reward)
		return TRUE

/proc/reroll_goals(mob/living/carbon/human/user)
	user.zizo_goals = list()
	var/list/weighted = list()
	for(var/item in GLOB.zizo_goals)
		if(item in user.zizo_goals_complete)
			continue
		weighted[item] = initial(item:weight)
	for(var/i in 1 to 3)
		if(!weighted.len)
			break
		var/chosen_type = pickweight(weighted)
		weighted -= chosen_type
		user.zizo_goals += new chosen_type()

/datum/zizo_research/ui_state(mob/user)
	return GLOB.always_state

/datum/zizo_research/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ZizoResearch", "齐佐密教研究", 700, 600)
		ui.open()

/datum/zizo_research/ui_data(mob/user)
	var/list/data = list("points" = user.mind.zizo_points)
	var/list/nodes = list()
	for(var/ritualtype in GLOB.zizo_researchable)
		var/datum/ritual/R = ritualtype
		if((R.is_cultist_ritual || !R.lesser) && !is_zizo(user))
			continue
		var/obj/item/needed = initial(R.research_item)
		var/list/node = list("path" = ritualtype, "name" = zizo_display(initial(R.name)), "desc" = R.desc, "cost" = initial(R.research_cost), "aspect" = R.needs_aspect, "lesser" = R.lesser)
		if(ispath(R.icon_type, /datum/action))
			var/datum/action/shown_action = R.icon_type
			node["icon"] = shown_action.button_icon
			node["state"] = shown_action.button_icon_state
		else if(ispath(R.icon_type, /obj/effect/proc_holder/spell))
			var/obj/effect/proc_holder/spell/shown_spell = R.icon_type
			node["icon"] = shown_spell.overlay_icon
			node["state"] = shown_spell.overlay_state
		else
			var/atom/shown = R.icon_type
			node["icon"] = shown.icon
			node["state"] = shown.icon_state
		if(R.node_state)
			node["state"] = R.node_state
		node["done"] = (ritualtype in user.mind.zizo_researched)
		node["disabled"] = (R.needs_aspect && !(R.needs_aspect in GLOB.zizo_bestowed))
		if(needed)
			node["item"] = uppertext(initial(needed.name))
		nodes += list(node)
	data["knowledge"] = nodes
	return data

/datum/zizo_research/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/user = usr
	if(!ishuman(user))
		return
	var/ritualtype = text2path(params["path"])
	if(!ritualtype || (ritualtype in user.mind.zizo_researched) || !(ritualtype in GLOB.zizo_researchable))
		return
	var/datum/ritual/R = new ritualtype
	if((R.is_cultist_ritual || !R.lesser) && !is_zizo(user))
		qdel(R)
		return
	if(user.mind.zizo_points < initial(R.research_cost))
		to_chat(user, span_warning("秘闻不足。"))
		return
	var/obj/item/needed = R.research_item
	if(needed)
		var/obj/item/held = locate(needed) in user.held_items
		if(!held)
			to_chat(user, span_warning("我得手持[initial(needed.name)]才能参透其中的奥秘。"))
			qdel(R)
			return
		qdel(held)
	user.mind.zizo_points -= initial(R.research_cost)
	user.mind.zizo_researched |= ritualtype
	for(var/spell in R.spells)
		if(!user.mind.has_spell(spell))
			user.mind.AddSpell(new spell)
	if(R.passive)
		R.apply_passive(user)
	to_chat(user, span_boldnotice("我悟了！我学会了[zizo_display(R.name)]！"))
	qdel(R)
	return TRUE

/proc/reroll_gate_targets(gate_count)
	if(gate_count <= 0)
		return
	var/list/weighted = list()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.mind || H.stat == DEAD || is_zizo(H))
			continue
		var/datum/job/J = SSjob.GetJob(H.mind.assigned_role)
		if(!J || (J.type in list(KING_QUEEN_ROLES)) || J.type == /datum/job/roguetown/bandit || J.type == /datum/job/roguetown/wretch)
			continue
		if(gate_count == 1 && !(J.type in (list(TIER_TWO_GATEROLES))))
			continue
		if(gate_count > 1 && !(J.type in (list(TIER_THREE_GATEROLES))))
			continue
		weighted[H] = 1
		if(H.purity == TRUE)
			weighted[H] = 5

	GLOB.gate_targets = list()
	for(var/i in 1 to 5)
		if(!weighted.len)
			break
		var/mob/living/carbon/human/chosen = pickweight(weighted)
		GLOB.gate_targets += chosen
		weighted -= chosen

/datum/ritual
	abstract_type = /datum/ritual
	var/name = "DVRK AND EVIL RITVAL"
	var/desc
	var/center_requirement
	var/n_req
	var/e_req
	var/s_req
	var/w_req
	var/is_cultist_ritual = FALSE
	var/research_cost = 5
	var/needs_aspect
	var/keep_center = FALSE
	var/center_desc
	var/n_desc
	var/e_desc
	var/s_desc
	var/w_desc
	var/passive = FALSE
	var/lesser = FALSE
	var/research_item
	var/icon_type
	var/node_state
	var/list/spells = list()

/datum/ritual/proc/invoke(mob/living/user, turf/center)
	return

/datum/ritual/proc/apply_passive(mob/living/carbon/human/H)
	return

/datum/ritual/proc/req_label(req, desc)
	if(desc)
		return desc
	if(req == /mob/living/carbon/human)
		return "一名人形生物"
	var/atom/A = req
	return initial(A.name)

/datum/ritual/proc/hugbox()
	var/list/parts = list()
	if(center_requirement)
		parts += "中央：[req_label(center_requirement, center_desc)]"
	if(n_req)
		parts += "北侧：[req_label(n_req, n_desc)]"
	if(e_req)
		parts += "东侧：[req_label(e_req, e_desc)]"
	if(s_req)
		parts += "南侧：[req_label(s_req, s_desc)]"
	if(w_req)
		parts += "西侧：[req_label(w_req, w_desc)]"
	return jointext(parts, ", ")

// SERVANTRY
/datum/ritual/servantry
	abstract_type = /datum/ritual/servantry

/datum/ritual/servantry/convert
	name = "Convert"
	icon_type = /obj/item/clothing/neck/roguetown/psicross/inhumen
	desc = "将祭品置于符文中央，使其皈依并成为仆从。成功可获得秘闻。若教徒超过三人，须有另一名教徒站在符文上协助。"
	center_requirement = /mob/living/carbon/human
	center_desc = "一名祭品"
	is_cultist_ritual = TRUE

/datum/ritual/servantry/convert/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(zizo_target_error(user, target))
		return
	if(target.has_status_effect(/datum/status_effect/debuff/devitalised/lux_ripped))
		to_chat(user, span_warning("此人的灵辉太弱了。"))
		return
	var/datum/antagonist/zizocultist/PR = user.mind.has_antag_datum(/datum/antagonist/zizocultist, TRUE)
	var/lackeys = 0
	for(var/datum/mind/M in SSmapping.retainer.cultists)
		if(!M.current || QDELETED(M.current) || M.current.stat == DEAD)
			continue
		if(is_zizolackey(M))
			lackeys++
	var/mob/living/carbon/human/assistant
	for(var/mob/living/carbon/human/H in range(1, center))
		if(H == user || H == target || !is_zizo(H))
			continue
		assistant = H
		break
	if(lackeys > 3 && !assistant)
		to_chat(user, span_warning("要招募更多信徒，须有另一名教徒站在符印上协助你举行仪式。"))
		return
	var/alert = "顺从"
	if(!istype(target.patron, /datum/patron/inhumen/zizo) && !(target.client && (ROLE_ZIZOIDCULTIST in target.client.prefs.be_special)))
		alert = tgui_alert(target, "你将得见真相。你要反抗吗？", "???", list("顺从", "反抗"))
	target.Immobilize(3 SECONDS)
	if(alert == "顺从")
		to_chat(target, span_notice("我看见真相了！一切都说得通了！他们不是异端，他们一心为我们着想！"))
		PR.add_cultist(target.mind)
		target.praise()
		target.apply_status_effect(/datum/status_effect/buff/healing, 70, TRUE)
		if(target.purity == TRUE)
			new /obj/item/necro_relics/necro_crystal(center)
			zizo_award(user, 3)
			zizo_award(target, 3)
		target.purity = FALSE
		for(var/datum/mind/M in SSmapping.retainer.cultists)
			if(M.current)
				zizo_award(M.current, 2)
		var/datum/job/J = SSjob.GetJob(target.mind?.assigned_role)
		if(J && (J.type in (list(NOBLE_ROLES) + list(CHURCH_ROLES) + list(GARRISON_ROLES) + list(INQUISITION_ROLES))))
			new /obj/item/necro_relics/necro_crystal(center)
			zizo_award(user, 3)
			zizo_award(target, 3)
		zizo_award(user, 3)
		zizo_award(target, 3)
	else
		target.visible_message(span_danger("[target]拼命挣扎，不肯屈服！"))
		if(tgui_alert(user, "这蠢货不肯皈依！", "齐佐", list("献祭", "饶命")) == "献祭" && (target in center.contents))
			var/datum/ritual/servantry/sacrifice/S = new
			S.invoke(user, center, TRUE)
			qdel(S)

/datum/ritual/servantry/sacrifice
	lesser = TRUE
	name = "Sacrifice"
	icon_type = /obj/item/rogueweapon/huntingknife/idagger
	desc = "将祭品置于符文中央，剥离其灵辉，获得秘闻与一枚黑暗水晶。须有另一名教徒持刀站在符印上，仪式才会生效。"
	center_requirement = /mob/living/carbon/human
	center_desc = "一名祭品"

/datum/ritual/servantry/sacrifice/invoke(mob/living/user, turf/center, solo)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(zizo_target_error(user, target))
		return
	var/mob/living/carbon/human/assistant
	for(var/mob/living/carbon/human/H in range(1, center))
		if(H == user || H == target)
			continue
		for(var/obj/item/I in H.held_items)
			if(istype(I, /obj/item/rogueweapon/huntingknife))
				assistant = H
				break
		if(assistant)
			break
	if(!assistant && !solo)
		to_chat(user, span_warning("我需要另一名教徒持刀站在符文上。"))
		return
	to_chat(user, span_notice("你开始献祭……"))
	if(solo)
		target.Immobilize(10 SECONDS)
	assistant?.Immobilize(10 SECONDS)
	var/poo = new /obj/effect/temp_visual/opengate(center, 10 SECONDS)
	if(!do_after(user, 10 SECONDS, target = target))
		assistant?.SetImmobilized(0)
		qdel(poo)
		return
	if(QDELETED(target) || !(target in center.contents) || (assistant && QDELETED(assistant)))
		return
	var/pure = target.purity
	if(!absorb_lux(target, center))
		to_chat(user, span_warning("[target]已没有灵辉可供献祭。"))
		return
	var/datum/job/J = SSjob.GetJob(target.mind?.assigned_role)
	if(J && (J.type in (list(NOBLE_ROLES) + list(CHURCH_ROLES) + list(GARRISON_ROLES) + list(INQUISITION_ROLES))))
		new /obj/item/necro_relics/necro_crystal(center)
		zizo_award(user, 3)
		zizo_award(assistant, 3)
	if(pure == TRUE)
		new /obj/item/necro_relics/necro_crystal(center)
		zizo_award(user, 3)
		zizo_award(assistant, 3)
	zizo_award(user, 5)
	zizo_award(assistant, 5)
	target.visible_message(span_danger("[assistant || user]剖开[target]的胸膛，扯出了其中的灵辉！"))
	to_chat(user, span_notice("她收下了祭品！"))

/datum/ritual/servantry/heartache
	lesser = TRUE
	name = "Heartaches"
	icon_type = /obj/item/corruptedheart
	desc = "造出一颗能指引你寻找祭品的心脏。"
	center_requirement = /obj/item/organ/heart

/datum/ritual/servantry/heartache/invoke(mob/user, turf/center)
	new /obj/item/corruptedheart(center)
	to_chat(user, span_notice("用这颗心脏寻找你的祭品。"))

/datum/ritual/servantry/guidance
	lesser = TRUE
	name = "Divine Guidance"
	icon_type = /obj/item/organ/eyes
	desc = "向齐佐求取指引，获得秘闻。每 20 分钟可用一次。"
	center_requirement = /obj/item/organ/eyes
	center_desc = "眼睛"
	keep_center = TRUE

/datum/ritual/servantry/guidance/invoke(mob/living/user, turf/center)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/cultist = user
	if(world.time < cultist.zizo_goals_cd)
		to_chat(user, span_warning("时机尚早，还得等等。"))
		return
	cultist.zizo_goals_cd = world.time + 20 MINUTES
	reroll_goals(cultist)
	for(var/datum/zizogoal/gl in cultist.zizo_goals)
		to_chat(cultist, span_notice("<B>[gl.name]：</B>[gl.desc]<BR><B>奖励 [gl.reward] 点秘闻。</B>"))

/obj/item/corruptedheart
	name = "腐化之心"
	desc = "禁忌的魔力在其中闪烁。"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "heart-on"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown
	var/tracked_name

/obj/item/corruptedheart/attack_right(mob/living/user)
	if(!istype(user.patron, /datum/patron/inhumen/zizo))
		to_chat(user, span_warning("心脏寂然无声。"))
		return
	var/new_name = input(user, "你要对心脏低语谁的名字？", "齐佐") as null|text
	if(!new_name)
		return
	var/known = user.mind?.do_i_know(name = new_name)
	for(var/mob/living/carbon/human/T in GLOB.gate_targets)
		if(T.real_name == new_name)
			known = TRUE
	if(!known)
		to_chat(user, span_warning("我不认识叫这个名字的人。"))
		return
	tracked_name = new_name
	to_chat(user, span_notice("心脏开始随着[tracked_name]的脉搏跳动。"))

/obj/item/corruptedheart/attack_self(mob/living/user)
	if(world.time < cooldown)
		to_chat(user, span_warning("还得再等等！"))
		return
	if(!istype(user.patron, /datum/patron/inhumen/zizo))
		to_chat(user, span_warning("心脏寂然无声。"))
		return
	if(!tracked_name)
		to_chat(user, span_warning("右键点击心脏可指定目标。"))
		return
	if(!do_after(user, 2 SECONDS, src))
		return
	var/mob/living/carbon/human/prey
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.real_name == tracked_name)
			prey = H
			break
	if(!prey || !prey.z)
		to_chat(user, span_warning("心脏没能找到目标。"))
		return
	if(psydont(prey))
		to_chat(user, span_danger("对方身上的白银抵挡了黑魔法！"))
		return
	var/list/info = get_locator_info(user, prey)
	var/beat = 'sound/health/slowbeat.ogg'
	if(info["proximity"] == "very close")
		beat = 'sound/health/fastbeat.ogg'
	else if(info["proximity"] == "nearby")
		beat = 'sound/health/heartbeat.ogg'
	playsound(user, beat, 60, TRUE)
	to_chat(user, span_danger("朝[get_direction_display(get_dir(user, prey))]时心跳更快了。[prey.real_name]似乎[zizo_scent_display(info)]。"))
	cooldown = world.time + 10 SECONDS

/proc/get_locator_info(mob/user, atom/prey, detailed = TRUE)
	var/list/info = list()
	info["dir"] = dir2text(get_dir(user, prey))
	info["z"] = ""
	if(prey.z > user.z)
		info["z"] = ", somewhere above"
	else if(prey.z < user.z)
		info["z"] = ", somewhere below"
	info["proximity"] = ""
	if(detailed)
		var/dist = get_dist(user, prey)
		info["proximity"] = "far away"
		if(dist <= 5)
			info["proximity"] = "very close"
		else if(dist <= 15)
			info["proximity"] = "nearby"
	return info

/datum/ritual/servantry/gutted
	lesser = TRUE
	name = "Gutted Fish"
	icon_type = /obj/item/rogueweapon/huntingknife
	desc = "将一具无心智的人形尸体置于符印中央，取出其内脏。"
	center_requirement = /mob/living/carbon/human // One to be gutted.human

/datum/ritual/servantry/gutted/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.stat != DEAD)
		return
	if(target.mind)
		to_chat(user, span_danger("祭品必须没有心智。"))
		return
	center.visible_message(span_danger("[target]被举到半空，皮肤上凭空绽开道道划痕和深切的伤口，内脏尽数掉落在地！"))
	var/atom/drop_location = target.drop_location()
	for(var/obj/item/organ/organ as anything in target.internal_organs)
		organ.Remove(target)
		organ.forceMove(drop_location)
	for(var/obj/item/bodypart/part as anything in target.bodyparts)
		part.drop_limb()

/datum/ritual/servantry/sleepcurse
	name = "Curse of Zizo"
	icon_type = /obj/item/natural/worms/leech
	desc = "令目标心脏病发作，15 秒后失去意识，通常不会致死。需要一条吸过目标血液的水蛭。"
	center_requirement = /obj/item/natural/worms/leech
	research_cost = 3
	keep_center = TRUE

/datum/ritual/servantry/sleepcurse/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	var/mob/living/carbon/human/victim = remnant.fed_from
	if(!curse_target(victim))
		to_chat(user, span_warning("目标受到了保护，无法再施加诅咒。"))
		return
	qdel(remnant)
	to_chat(user, span_notice("就让那颗心停止跳动！"))
	to_chat(victim, span_userdanger("我的胸口一阵绞痛，像火烧一样！"))
	victim.emote("gasp", forced = TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(sleepcurse), victim), 15 SECONDS)

/proc/sleepcurse(mob/living/carbon/human/victim)
	if(QDELETED(victim) || victim.stat == DEAD)
		return
	victim.heart_attack()

/datum/ritual/servantry/tongues
	lesser = TRUE
	name = "Curse of Tongues"
	icon_type = /obj/item/natural/worms/leech
	desc = "让目标说的话无人听懂，持续 5 分钟。需要一条吸过目标血液的水蛭。"
	center_requirement = /obj/item/natural/worms/leech
	research_cost = 3
	keep_center = TRUE

/datum/ritual/servantry/tongues/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	var/mob/living/carbon/human/victim = remnant.fed_from
	if(!curse_target(victim))
		to_chat(user, span_warning("目标受到了保护，无法再施加诅咒。"))
		return
	qdel(remnant)
	to_chat(user, span_notice("愿那条舌头溃烂、流血、爆裂！"))
	to_chat(victim, span_userdanger("偏偏在这可怕的夜里遭了诅咒。"))
	victim.apply_status_effect(/datum/status_effect/debuff/zizo_tongues)

/datum/status_effect/debuff/zizo_tongues
	id = "zizo_tongues"
	duration = 5 MINUTES
	alert_type = null

/datum/status_effect/debuff/zizo_tongues/on_apply()
	ADD_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/debuff/zizo_tongues/on_remove()
	REMOVE_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAIT_STATUS_EFFECT(id))

/datum/ritual/servantry/exhaustion
	lesser = TRUE
	name = "Curse of Exhaustion"
	icon_type = /obj/item/natural/worms/leech
	desc = "使目标疲惫不堪，只想找张床躺下，持续 5 分钟。目标不会收到中咒提示。需要一条吸过目标血液的水蛭。"
	center_requirement = /obj/item/natural/worms/leech
	research_cost = 3
	keep_center = TRUE

/datum/ritual/servantry/exhaustion/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	var/mob/living/carbon/human/victim = remnant.fed_from
	if(!curse_target(victim, FALSE))
		to_chat(user, span_warning("目标受到了保护，无法再施加诅咒。"))
		return
	qdel(remnant)
	to_chat(user, span_notice("愿他们一睡不醒，直至死亡！"))
	victim.apply_status_effect(/datum/status_effect/debuff/zizo_exhaustion)

/datum/status_effect/debuff/zizo_exhaustion
	id = "zizo_exhaustion"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/sleepytimet3

/datum/status_effect/debuff/zizo_exhaustion/on_apply()
	var/mob/living/carbon/human/H = owner
	H.remove_sleep_depravation(TRUE)
	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living, remove_status_effect), type), 5 MINUTES)
	return ..()

/datum/status_effect/debuff/zizo_exhaustion/tick()
	var/datum/status_effect/incapacitating/sleeping/S = owner.IsSleeping()
	if(!S)
		return
	S.duration += 1 MINUTES
	owner.remove_status_effect(type)

/datum/ritual/servantry/knock
	lesser = TRUE
	name = "Curse of Knock"
	icon_type = /obj/item/storage/keyring
	node_state = "keyring3"
	desc = "让目标手中的钥匙失灵，持续 10 分钟。需要一条吸过目标血液的水蛭。"
	center_requirement = /obj/item/natural/worms/leech
	research_cost = 3
	keep_center = TRUE

/datum/ritual/servantry/knock/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	var/mob/living/carbon/human/victim = remnant.fed_from
	if(!curse_target(victim))
		to_chat(user, span_warning("目标受到了保护，无法再施加诅咒。"))
		return
	qdel(remnant)
	to_chat(user, span_notice("让他们连钥匙都拿不稳！"))
	to_chat(victim, span_userdanger("偏偏在这可怕的夜里遭了诅咒。"))
	victim.apply_status_effect(/datum/status_effect/debuff/zizo_knock)

/datum/status_effect/debuff/zizo_knock
	id = "zizo_knock"
	duration = 10 MINUTES
	alert_type = null

/datum/ritual/servantry/misfortune
	lesser = TRUE
	name = "Curse of Misfortune"
	icon_type = /obj/item/dice/d6
	desc = "使目标厄运缠身，持续 10 分钟。需要一条吸过目标血液的水蛭。"
	center_requirement = /obj/item/natural/worms/leech
	research_cost = 3
	keep_center = TRUE

/datum/ritual/servantry/misfortune/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	var/mob/living/carbon/human/victim = remnant.fed_from
	if(!curse_target(victim))
		to_chat(user, span_warning("目标受到了保护，无法再施加诅咒。"))
		return
	qdel(remnant)
	to_chat(user, span_notice("愿他们脚下一绊，摔个半死！"))
	to_chat(victim, span_userdanger("偏偏在这可怕的夜里遭了诅咒。"))
	victim.apply_status_effect(/datum/status_effect/debuff/zizo_misfortune)

/datum/status_effect/debuff/zizo_misfortune
	id = "zizo_misfortune"
	duration = 10 MINUTES
	alert_type = null

GLOBAL_LIST_EMPTY(zizo_proxy)

/*

/datum/ritual/servantry/proxy
	lesser = TRUE
	name = "Curse of Proxy"
	desc = "让嗅探器追踪目标，替你引开追兵，持续 10 分钟。需要一条吸过目标血液的水蛭。"
	center_requirement = /obj/item/natural/worms/leech
	research_cost = 3
	keep_center = TRUE

/datum/ritual/servantry/proxy/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	GLOB.zizo_proxy[user] = remnant.fed_from
	qdel(remnant)
	to_chat(user, span_notice("那只讨厌的猎犬暂时找不到我了。"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(zizo_unproxy), user), 10 MINUTES)

/proc/zizo_unproxy(mob/living/user)
	GLOB.zizo_proxy -= user
*/

/datum/ritual/servantry/darksunmark
	lesser = TRUE
	name = "Dark Sun's Mark"
	icon_type = /obj/item/candle/yellow
	desc = "为一人烙下死亡印记，引来格拉加尔的刺客追杀。"
	center_requirement = /obj/item/rogueweapon/huntingknife/idagger
	research_cost = 2

/datum/ritual/servantry/darksunmark/invoke(mob/living/user, turf/center)
	var/target_name = input(user, "你想让谁死？", "格拉加尔")
	if(!user.mind || !user.mind.do_i_know(name = target_name))
		to_chat(user, span_warning("我不认识叫这个名字的人。"))
		return
	var/mob/living/carbon/human/target
	var/assassin_found = FALSE
	for(var/mob/living/carbon/human/HL as anything in GLOB.human_list)
		if(HL.stat == DEAD)
			continue
		if(HL.real_name == target_name)
			target = HL
			continue
		if(HAS_TRAIT(HL, TRAIT_ASSASSIN))
			assassin_found = TRUE
			var/obj/item/rogueweapon/huntingknife/idagger/steel/profane/dagger = locate() in HL.get_all_gear()
			if(dagger)
				to_chat(HL, "亵渎匕首低语道：<span class='danger'>“可畏的齐佐召我们相助。去，追杀我们共同的敌人[target_name]！”</span>")
	if(!target || !assassin_found)
		to_chat(user, span_warning("暗日没有回应你的呼唤。他的仆从似乎离这里很远……"))
		return
	to_chat(user, span_warning("暗日回应了你亵渎的呼唤，目标已被标记。[target.real_name]必死无疑！"))
	to_chat(target, span_warningbig("我汗毛直竖。刚才有人说了我的名字？我得提防背后。"))
	target.playsound_local(target, 'sound/magic/marked.ogg', 100)

// TRANSMUTATION
/datum/ritual/transmutation
	abstract_type = /datum/ritual/transmutation

/datum/ritual/transmutation/allseeingeye
	name = "All-seeing Eye"
	icon_type = /obj/item/scrying/eye
	desc = "造出一只可供窥视远方的眼睛。"
	is_cultist_ritual = TRUE
	center_requirement = /obj/item/organ/eyes

/datum/ritual/transmutation/allseeingeye/invoke(mob/living/user, turf/center)
	new /obj/item/scrying/eye(center)
	to_chat(user, span_notice("全视之眼，得见目力所不及之处。"))

/datum/ritual/transmutation/cross
	lesser = TRUE
	name = "Summon Amulet of Zizo"
	icon_type = /obj/item/clothing/neck/roguetown/psicross/inhumen
	desc = "造出一枚齐佐护符。"
	center_requirement = /obj/item/clothing/neck/roguetown/psicross

/datum/ritual/transmutation/cross/invoke(mob/living/user, turf/center)
	new /obj/item/clothing/neck/roguetown/psicross/inhumen(center)
	to_chat(user, span_notice("普赛圣十字化作了一枚齐佐护符。"))

/datum/ritual/transmutation/raiseshrine
	lesser = TRUE
	name = "Raise Profane Shrine"
	icon_type = /obj/item/grown/log/tree/small
	desc = "竖起倒十字，作为供奉齐佐的神龛。可用来完成密教任务。"
	center_requirement = /obj/item/grown/log/tree/small

/datum/ritual/transmutation/raiseshrine/invoke(mob/living/user, turf/center)
	new /obj/structure/fluff/psycross/zizocross(center)
	to_chat(user, span_notice("原木变成了倒置的普赛圣十字。"))
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/cultist = user
	var/area/A = get_area(center)
	if(istype(A, /area/rogue/indoors/town/church))
		complete_zgoal(cultist, /datum/zizogoal/profaneshrine_church)
	if(istype(A, /area/rogue/indoors/town/tavern))
		complete_zgoal(cultist, /datum/zizogoal/profaneshrine_tavern)
	if(istype(A, /area/rogue/indoors/town/bath))
		complete_zgoal(cultist, /datum/zizogoal/profaneshrine_bath)
	if(istype(A, /area/rogue/indoors/town/academy) || istype(A, /area/rogue/indoors/town/magician))
		complete_zgoal(cultist, /datum/zizogoal/profaneshrine_academy)
	if(istype(A, /area/rogue/outdoors/town/graveyard))
		complete_zgoal(cultist, /datum/zizogoal/profaneshrine_graveyard)

/datum/ritual/transmutation/criminalstool
	lesser = TRUE
	name = "Criminal's Tool"
	icon_type = /obj/item/soap/cult
	desc = "造出一块能洗去符文的肥皂。"
	center_requirement = /obj/item/natural/cloth

/datum/ritual/transmutation/criminalstool/invoke(mob/living/user, turf/center)
	new /obj/item/soap/cult(center)
	to_chat(user, span_notice("灭迹之物。能用来掩去踪迹，也能洗去符印。"))

/obj/item/soap/cult
	name = "受诅肥皂"
	desc = "它在搏动。"
	color = LIGHT_COLOR_BLOOD_MAGIC

/datum/ritual/transmutation/propaganda
	lesser = TRUE
	name = "Remnant Leech"
	icon_type = /obj/item/natural/worms/leech/propaganda
	desc = "造出一条会悄然附着于目标的水蛭，可用来施咒。"
	center_requirement = /obj/item/natural/worms/leech
	n_req = /obj/item/paper
	s_req = /obj/item/natural/feather
	research_cost = 2

/datum/ritual/transmutation/propaganda/invoke(mob/living/user, turf/center)
	new /obj/item/natural/worms/leech/propaganda(center)
	to_chat(user, span_notice("用这条水蛭窃取他们的灵魂。"))

/obj/item/natural/worms/leech/propaganda
	name = "受诅水蛭"
	desc = "这条水蛭与寻常的很不一样。"
	icon_state = "leech"
	drainage = 0
	blood_sucking = 0
	suppressed = TRUE
	pierce_armor = TRUE
	instant_apply = TRUE
	embedding = list(
		"embed_chance" = 100,
		"embedded_unsafe_removal_time" = 0,
		"embedded_pain_chance" = 0,
		"embedded_fall_chance" = 0,
		"embedded_bloodloss"= 0,
	)

/obj/item/natural/worms/leech/propaganda/on_embed_life(mob/living/user, obj/item/bodypart/bodypart)
	if(!host && user)
		host = user
		if(ishuman(user))
			fed_from = user
		addtimer(CALLBACK(src, PROC_REF(fall_off)), 30 SECONDS)
	. = ..()
	if(!user)
		return
	if(iscarbon(user))
		var/mob/living/carbon/V = user
		if(prob(5))
			record_round_statistic(STATS_ZIZO_PRAISED)
			V.say(pick( \
				"赞美齐佐！", \
				"愿十神尽灭……", \
				"阿斯特拉塔必将败亡！", \
				"十神也拦不住我！", \
				"齐佐为我指路！", \
				"黑暗女士让我得见真相！", \
				"我的性命献给齐佐……", \
				"诅咒你们的兽神！", \
				"诺克的魔法在齐佐面前算得了什么！", \
				"阿比索尔不过是一粒盐！", \
				"佩斯特拉是最污秽的女神！", \
				"拉沃克斯的正义残缺而迟钝！", \
				"把烈日暴君从天上拽下来！", \
				"赛利克斯就是那条非割不可的舌头！", \
				"把玛勒姆丢进地狱的烈火！", \
				"只有黑暗精灵掌握着真理！", \
				"我要将内克拉的死者亵渎一千遍！", \
				"我要屠戮十神，就像内克拉屠戮普赛顿那样！", \
				"让伊欧拉名下每一颗心都停止跳动！"))
		V.add_stress(/datum/stressevent/leechcult)

/datum/ritual/transmutation/silencerleech
	name = "Silencing Leech"
	icon_type = /obj/item/natural/worms/leech/silencer
	desc = "转化一条水蛭，让被它附着的人无法出声。"
	center_requirement = /obj/item/natural/worms/leech
	n_req = /obj/item/paper
	s_req = /obj/item/natural/feather
	research_cost = 2

/datum/ritual/transmutation/silencerleech/invoke(mob/living/user, turf/center)
	new /obj/item/natural/worms/leech/silencer(center)
	to_chat(user, span_notice("用这条水蛭夺走他们的声音。"))

/obj/item/natural/worms/leech/silencer
	name = "噤声水蛭"
	icon_state = "leech"
	drainage = 0
	blood_sucking = 0
	pierce_armor = TRUE
	instant_apply = TRUE
	embedding = list(
		"embed_chance" = 100,
		"embedded_unsafe_removal_time" = 5 SECONDS,
		"embedded_pain_chance" = 0,
		"embedded_fall_chance" = 0,
		"embedded_bloodloss"= 0,
	)

/obj/item/natural/worms/leech/silencer/on_embed_life(mob/living/user, obj/item/bodypart/bodypart)
	if(host || !user)
		return
	host = user
	if(ishuman(user))
		fed_from = user
	ADD_TRAIT(user, TRAIT_MUTE, "silencer_leech")
	to_chat(user, span_userdanger("我发不出声音了！"))
	addtimer(CALLBACK(src, PROC_REF(fall_off)), 2 MINUTES)

/obj/item/natural/worms/leech/silencer/forceMove(atom/newloc)
	. = ..()
	if(!is_embedded && host)
		REMOVE_TRAIT(host, TRAIT_MUTE, "silencer_leech")
		host = null

/obj/item/natural/worms/leech/silencer/Destroy()
	if(host)
		REMOVE_TRAIT(host, TRAIT_MUTE, "silencer_leech")
		host = null
	return ..()

/datum/ritual/transmutation/invademind
	lesser = TRUE
	name = "Invade Mind"
	icon_type = /obj/item/natural/feather
	desc = "将一句话送入他人的脑海，隐去自己的身份。"
	center_requirement = /obj/item/natural/feather

/datum/ritual/transmutation/invademind/invoke(mob/living/user, turf/center)
	var/info = input(user, "你想传达什么？", "齐佐")
	var/target_name = input(user, "要传给谁？", "齐佐") as null|text
	if(!target_name)
		return
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == target_name)
			to_chat(HL, "<i>你听见脑海中响起一个声音……<b>[info]</b></i>")

/datum/ritual/transmutation/summonoutfit
	lesser = TRUE
	name = "Summon Cult Outfit"
	icon_type = /obj/item/clothing/head/roguetown/helmet/skullcap/cult
	desc = "召来一套令人不安的服饰，能提供少许防护。"
	center_requirement = /obj/item/natural/cloth

/datum/ritual/transmutation/summonoutfit/invoke(mob/living/user, turf/center)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()
	new /obj/item/clothing/head/roguetown/helmet/skullcap/cult(center)
	new /obj/item/clothing/cloak/half/cult(center)
	new /obj/item/rope/chain(center)
	playsound(center, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

/obj/item/clothing/head/roguetown/helmet/skullcap/cult
	name = "不祥兜帽"
	desc = "兜帽内回荡着不祥的笑声。可罩在小圆盔外。"
	icon = 'icons/roguetown/cult/zizohead.dmi'
	mob_overlay_icon = 'icons/roguetown/cult/zizohead.dmi'
	icon_state = "warlock"
	dynamic_hair_suffix = ""
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

	body_parts_covered = NECK|HAIR|EARS|HEAD

/obj/item/clothing/cloak/half/cult
	name = "不祥斗篷"
	icon = 'modular_deserttown/icons/clothing/shadowcloak.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shadowcloak.dmi'
	icon_state = "cultcloak"
	color = null
	sleeved = 'modular_deserttown/icons/clothing/onmob/shadowcloak.dmi'
	desc = "想披上它的人可得当心。凡是穿过它的人，再回来时都已变了模样。"
	body_parts_covered = ARMS|CHEST

/datum/ritual/transmutation/summonarmor
	name = "Summon Darksteel Armor"
	icon_type = /obj/item/clothing/suit/roguetown/armor/plate/full/zizo
	desc = "召来一套无法卸下的黑钢板甲。你将学会使用重甲并获得修复术。需要一枚黑暗水晶。"
	center_requirement = /mob/living/carbon/human
	n_req = /obj/item/necro_relics/necro_crystal
	w_req = /obj/item/ingot/steel
	e_req = /obj/item/ingot/steel

/datum/ritual/transmutation/summonarmor/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.stat == DEAD)
		target.gib(FALSE, FALSE, FALSE)
		return
	ADD_TRAIT(target, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()
	target.equipOutfit(/datum/outfit/job/roguetown/darksteelrite)
	playsound(center, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

/datum/ritual/transmutation/summonfuge
	name = "Summon Fuge"
	icon_type = /obj/structure/fuge
	desc = "召来一台能从异界取来物品的织机。必须在现实显得虚幻之处架设。"
	is_cultist_ritual = TRUE
	research_cost = 0

/datum/ritual/transmutation/summonfuge/invoke(mob/living/user, turf/center)
	if(GLOB.zizo_fuges.len)
		to_chat(user, span_warning("世上只能有一台异界织机。"))
		return
	var/near_rend = FALSE
	for(var/obj/structure/reality_rend/R as anything in GLOB.zizo_reality_rends)
		if(zizo_dist(R, center) <= 50)
			near_rend = TRUE
			break
	if(!near_rend)
		to_chat(user, span_warning("必须放在现实显得虚幻之处。"))
		return
	to_chat(user, span_notice("仪式开始了，保持不动。"))
	var/poo = new /obj/effect/temp_visual/opengate(center)
	playsound(user, 'sound/villain/littlescary.ogg', 100, TRUE)
	if(!do_after(user, 10 SECONDS))
		qdel(poo)
		return
	if(GLOB.zizo_fuges.len)
		to_chat(user, span_warning("世上只能有一台异界织机。"))
		return
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()
	new /obj/structure/fuge(center)

/obj/structure/fuge
	name = "异界织机"
	desc = ""
	icon = 'icons/effects/clan.dmi'
	icon_state = "teleport"
	density = FALSE
	anchored = TRUE
	max_integrity = 300
	var/busy = FALSE
	var/radius = 1
	var/list/turf_data = list()
	var/list/obj/structure/pylon/pylons = list()
	var/list/obj/structure/raver/ravers = list()
	// list(name, typepath, time 2 produce, aspect, & if unrepeatable)
	var/static/list/recipes = list(
		list("黑暗碎片", /obj/item/cultbrick, 40 SECONDS, null, FALSE),
		list("齐佐长袍", /obj/item/clothing/cloak/cultrobe, 90 SECONDS, null, FALSE),
		list("雪镰（噬咬）", /obj/item/rogueweapon/spear/bite, 90 SECONDS, "BITE", TRUE),
		list("殒命之刃（腐朽）", /obj/item/rogueweapon/sword/sabre/rot, 90 SECONDS, "ROT", TRUE),
		list("遗忘之械（劳役）", /obj/item/rogueweapon/mace/maul/toil, 90 SECONDS, "TOIL", TRUE),
		list("巫木（丝缕）", /obj/item/rogueweapon/zizowand, 90 SECONDS, "STRAND", TRUE),
		list("狂人之刃（噪音）", /obj/item/rogueweapon/sword/long/noise, 90 SECONDS, "NOISE", TRUE),
		list("奴隶之刃（鲜血）", /obj/item/rogueweapon/huntingknife/idagger/steel/blood, 90 SECONDS, "BLOOD", TRUE),
		list("阿斯特拉塔之触（漆黑）", /obj/item/rogueweapon/huntingknife/idagger/steel/pitch, 90 SECONDS, "PITCH", TRUE),
		list("受诅水蛭", /obj/item/natural/worms/leech/propaganda, 40 SECONDS, null, FALSE),
		list("噤声水蛭", /obj/item/natural/worms/leech/silencer, 40 SECONDS, null, FALSE),
	)

/obj/structure/fuge/attack_hand(mob/living/user)
	if(!is_zizo(user))
		return ..()
	if(busy)
		to_chat(user, span_warning("织机正在运转，等一等！"))
		return
	var/list/menu = list()
	for(var/list/Rtype in recipes)
		if(Rtype[4] && !(Rtype[4] in GLOB.zizo_bestowed))
			continue
		if(Rtype[5] && (Rtype[2] in GLOB.zizo_summoned))
			continue
		menu["[Rtype[1]]（[Rtype[3] / 10] 秒）"] = Rtype
	if(!length(menu))
		return
	var/choice = tgui_input_list(user, "制作哪件物品？", "异界织机", menu)
	if(!choice || busy)
		return
	var/list/Rtype = menu[choice]
	busy = TRUE
	icon_state = "teleport_trigger"
	visible_message(span_danger("异界织机开始运转！"))
	addtimer(CALLBACK(src, PROC_REF(finish_pull), Rtype[2], Rtype[5]), Rtype[3])

/obj/structure/fuge/proc/finish_pull(spawn_type, unrepeatable)
	busy = FALSE
	icon_state = "teleport"
	if(unrepeatable)
		GLOB.zizo_summoned |= spawn_type
	var/atom/produced = spawn_type
	new spawn_type(get_turf(src))
	visible_message(span_danger("异界织机吐出了[initial(produced.name)]！"))
	playsound(src, 'sound/magic/blink.ogg', 40, TRUE)

/obj/structure/fuge/Initialize(mapload)
	. = ..()
	GLOB.zizo_fuges += src
	var/turf/center = get_turf(src)
	for(var/turf/T in range(radius, center))
		if(isclosedturf(T) && !istype(T, /turf/closed/indestructible))
			turf_data[T] = T.type
			T.ChangeTurf(/turf/closed/wall/mineral/rogue/stone/space, flags = CHANGETURF_IGNORE_AIR)
			new /obj/effect/temp_visual/cult/turf(T)
		else if(isopenturf(T) && !istype(T, /turf/open/floor/rogue/underworld/space/quiet/cult))
			turf_data[T] = T.type
			T.ChangeTurf(/turf/open/floor/rogue/underworld/space/quiet/cult, flags = CHANGETURF_IGNORE_AIR)
			new /obj/effect/temp_visual/cult/turf/floor(T)

/obj/structure/fuge/Destroy()
	GLOB.zizo_fuges -= src
	for(var/obj/structure/pylon/P as anything in pylons.Copy())
		qdel(P)
	pylons = null
	for(var/obj/structure/raver/R as anything in ravers.Copy())
		qdel(R)
	ravers = null
	for(var/turf/T in turf_data)
		T.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	turf_data.Cut()
	return ..()

/datum/ritual/transmutation/summonpylon
	name = "Summon Pylon"
	icon_type = /obj/structure/pylon
	desc = "召来一座汲魂塔，抽取随机目标的生命精华以凝结黑暗水晶。目标会获得指向塔址的线索。必须建在异界织机附近。"
	is_cultist_ritual = TRUE
	center_requirement = /obj/item/candle/candlestick/gold
	research_cost = 5

/datum/ritual/transmutation/summonpylon/invoke(mob/living/user, turf/center)
	var/obj/structure/fuge/nearby_fuge
	for(var/obj/structure/fuge/F in range(5, center))
		nearby_fuge = F
		break
	if(!nearby_fuge)
		to_chat(user, span_warning("必须靠近异界织机！"))
		return
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()
	new /obj/structure/pylon(center, nearby_fuge)

/obj/structure/pylon
	name = "汲魂塔"
	desc = "此塔见证了异教习俗的虚妄。"
	icon = 'icons/roguetown/cult/cultsprites.dmi'
	icon_state = "cult_pylon"
	density = TRUE
	anchored = TRUE
	max_integrity = 250
	var/obj/structure/fuge/fuge
	var/datum/beam/beam
	var/busy = FALSE

/obj/structure/pylon/Initialize(mapload, obj/structure/fuge/linked_fuge)
	. = ..()
	fuge = linked_fuge
	if(fuge)
		LAZYADD(fuge.pylons, src)
		beam = fuge.Beam(src, "blood", 'icons/roguetown/cult/cultsprites.dmi', time = INFINITY)

/obj/structure/pylon/Destroy()
	qdel(beam)
	beam = null
	fuge?.pylons -= src
	fuge = null
	return ..()

/obj/structure/pylon/attack_hand(mob/living/user)
	. = ..()
	if(!. && is_zizo(user))
		to_chat(user, span_warning("将一条吸过人血的水蛭放在塔上。"))

/obj/structure/pylon/attackby(obj/item/I, mob/living/user)
	var/obj/item/natural/worms/leech/remnant = I
	if(!istype(remnant) || !is_zizo(user))
		return ..()
	if(busy)
		to_chat(user, span_warning("塔正在汲取灵辉，等一等！"))
		return
	if(!remnant.fed_from)
		to_chat(user, span_warning("这条水蛭还没吸过人血。"))
		return
	var/mob/living/carbon/human/target = remnant.fed_from
	if(QDELETED(target) || target.stat == DEAD || target.has_status_effect(/datum/status_effect/debuff/pylon_drain))
		to_chat(user, span_warning("找不到目标。"))
		return
	qdel(remnant)
	busy = TRUE
	var/datum/status_effect/debuff/pylon_drain/drain = target.apply_status_effect(/datum/status_effect/debuff/pylon_drain)
	drain.pylon = src
	to_chat(user, span_notice("塔锁定了[uppertext(target)]，5 分钟后将凝结一枚黑暗水晶。对方可能会找到汲魂塔。"))
	visible_message(span_danger("[src]发出令人不安的震颤！"))

/datum/status_effect/debuff/pylon_drain
	id = "pylon_drain"
	duration = 5 MINUTES
	tick_interval = 5 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/debuff/pylon_drain
	var/obj/structure/pylon/pylon

/atom/movable/screen/alert/status_effect/debuff/pylon_drain
	name = "灵辉流失"
	desc = "齐佐密教正隔着以太窃取我的灵辉！"

/datum/status_effect/debuff/pylon_drain/tick()
	if(!pylon || QDELETED(pylon))
		qdel(src)
		return
	if(!prob(10))
		return
	var/mob/living/carbon/human/H = owner
	switch(rand(1, 2))
		if(1)
			var/list/info = get_locator_info(H, pylon)
			to_chat(H, span_danger("……我感觉有东西在[get_direction_display(get_dir(H, pylon))]牵扯着我……似乎[zizo_scent_display(info)]……"))
		if(2)
			var/list/nearby_items = list()
			for(var/obj/item/I in range(3, pylon))
				nearby_items += I
			if(!length(nearby_items))
				return
			var/obj/item/picked = pick(nearby_items)
			if(prob(50))
				to_chat(H, span_danger("...[uppertext(picked.name)]..."))
			else
				to_chat(H, span_danger("...[picked.desc]..."))

/datum/status_effect/debuff/pylon_drain/on_remove()
	. = ..()
	if(!pylon || QDELETED(pylon))
		return
	pylon.busy = FALSE
	if(duration != -1 && world.time >= duration && !QDELETED(owner) && owner.stat != DEAD)
		if(owner.has_status_effect(/datum/status_effect/debuff/devitalised) || owner.has_status_effect(/datum/status_effect/debuff/devitalised/lux_ripped))
			return FALSE
		if(HAS_TRAIT(owner, TRAIT_LUX_FREAK))
			return
		owner.apply_status_effect(/datum/status_effect/debuff/devitalised)
		owner.Jitter(4)
		owner.emote("scream")
		playsound(owner, 'sound/gore/flesh_eat_04.ogg', 40, TRUE)
		to_chat(owner, span_danger("灵辉被生生剥离了你的灵魂。"))
		new /obj/item/necro_relics/necro_crystal(get_turf(pylon))
	playsound(pylon, 'sound/magic/blink.ogg', 40, TRUE)

/datum/ritual/transmutation/summonraver
	name = "Summon Raver"
	icon_type = /obj/structure/raver
	desc = "召来一台血肉嫁接器。将祭品绑在上面以抽取灵辉，之后教徒可将自己绑上去，接受肉身强化。必须建在异界织机附近。"
	center_requirement = /obj/item/natural/worms
	is_cultist_ritual = TRUE
	research_cost = 5

/datum/ritual/transmutation/summonraver/invoke(mob/living/user, turf/center)
	var/obj/structure/fuge/nearby_fuge
	for(var/obj/structure/fuge/F in range(5, center))
		nearby_fuge = F
		break
	if(!nearby_fuge)
		to_chat(user, span_warning("必须建在异界织机附近。"))
		return
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()
	new /obj/structure/raver(center, nearby_fuge)

/obj/structure/raver
	name = "血肉嫁接器"
	desc = "蠕动的肉团上长满了尖锐的倒刺。要是你够狠心，可以把人塞进去。"
	icon = 'icons/effects/clan.dmi'
	icon_state = "flesh_grip"
	density = TRUE
	anchored = TRUE
	max_integrity = 250
	can_buckle = TRUE
	max_buckled_mobs = 1
	buckle_lying = 0
	buckleverb = "捆绑"
	var/obj/structure/fuge/fuge
	var/datum/beam/beam
	var/material = 0

/obj/structure/raver/Initialize(mapload, obj/structure/fuge/linked_fuge)
	. = ..()
	fuge = linked_fuge
	if(fuge)
		LAZYADD(fuge.ravers, src)
		beam = fuge.Beam(src, "blood", 'icons/roguetown/cult/cultsprites.dmi', time = INFINITY)

/obj/structure/raver/Destroy()
	qdel(beam)
	beam = null
	fuge?.ravers -= src
	fuge = null
	return ..()

/obj/structure/raver/mouse_buckle_handling(mob/living/M, mob/living/user)
	return user_buckle_mob(M, user, check_loc = FALSE)

/obj/structure/raver/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(!is_zizo(buckled_mob))
		var/escape_time = 30 SECONDS
		if(buckled_mob.restrained())
			escape_time = 1 MINUTES
		to_chat(user, span_warning("嫁接器紧紧裹住了你，很难挣脱！"))
		if(!do_after(user, escape_time, target = src))
			return
	return ..()

/obj/structure/raver/examine(mob/user)
	. = ..()
	if(is_zizo(user))
		. += span_notice("其中的灵辉还够进行 [material] 次嫁接。")

/obj/structure/raver/post_buckle_mob(mob/living/M)
	. = ..()
	if(is_zizo(M))
		INVOKE_ASYNC(src, PROC_REF(graft), M)
		return
	if(M.has_status_effect(/datum/status_effect/debuff/devitalised) || M.has_status_effect(/datum/status_effect/debuff/devitalised/lux_ripped))
		visible_message(span_warning("[M]已没有灵辉可供汲取。"))
		return
	if(!M.mind?.key)
		visible_message(span_warning("[M]没有灵魂。"))
		return
	M.apply_status_effect(/datum/status_effect/raver_corruption, src)
	playsound(src, 'sound/foley/butcher.ogg', 80, TRUE)

/obj/structure/raver/proc/graft(mob/living/carbon/human/H)
	if(!ishuman(H))
		return
	if(!material)
		to_chat(H, span_warning("嫁接器缺乏灵辉。将祭品绑上去。"))
		return
	var/static/list/options = list(
		"嫁接心脏（免疫流血与断肢）" = /obj/item/organ/zizo_graft/bleed,
		"嫁接大脑（免疫昏迷）" = /obj/item/organ/zizo_graft/crit,
		"嫁接肺脏（增强耐力）" = /obj/item/organ/zizo_graft/fatigue,
		"嫁接肝脏（自愈能力）" = /obj/item/organ/zizo_graft/health,
	)
	var/list/menu = list()
	for(var/name in options)
		var/obj/item/organ/zizo_graft/graft_type = options[name]
		if(!H.getorganslot(initial(graft_type.slot)))
			menu += name
	if(!length(menu))
		to_chat(H, span_warning("我的肉身已臻完整。"))
		return
	var/choice = tgui_input_list(H, "选择要嫁接的器官", "血肉嫁接器", menu)
	if(!choice || H.buckled != src || !material)
		return
	H.apply_status_effect(/datum/status_effect/raver_corruption/graft, src)
	var/grafted = do_after(H, 10 SECONDS, target = src)
	H.remove_status_effect(/datum/status_effect/raver_corruption)
	if(!grafted)
		return
	var/organ_path = options[choice]
	var/obj/item/organ/zizo_graft/organ = new organ_path
	organ.Insert(H)
	ADD_TRAIT(H, TRAIT_MONSTROUS, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	material--
	to_chat(H, span_userdanger("嫁接器将器官硬塞进我的血肉！"))
	H.emote("scream")
	unbuckle_mob(H, force = TRUE)

/obj/item/organ/zizo_graft
	name = "嫁接器官"
	desc = "违逆天理，令人作呕！齐佐触碰过它！"
	icon = 'icons/obj/surgery.dmi'
	zone = BODY_ZONE_CHEST
	var/list/graft_traits = list()
	var/energy = 0
	var/heal = 0

/obj/item/organ/zizo_graft/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	. = ..()
	for(var/trait in graft_traits)
		ADD_TRAIT(M, trait, "zizo_graft")

/obj/item/organ/zizo_graft/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	for(var/trait in graft_traits)
		REMOVE_TRAIT(M, trait, "zizo_graft")
	return ..()

/obj/item/organ/zizo_graft/on_life()
	. = ..()
	if(!owner)
		return
	if(energy)
		owner.energy_add(energy)
		owner.adjustStaminaLoss(-energy / 5)
	if(heal)
		owner.heal_overall_damage(heal, heal)
		owner.heal_wounds(heal)

/obj/item/organ/zizo_graft/bleed
	name = "嫁接心脏"
	icon_state = "heartcon-on"
	slot = "zizo_graft_bleed"
	graft_traits = list(TRAIT_BLOODLOSS_IMMUNE, TRAIT_NODISMEMBER)

/obj/item/organ/zizo_graft/crit
	name = "嫁接大脑"
	icon_state = "brain-con"
	slot = "zizo_graft_crit"
	graft_traits = list(TRAIT_NOHARDCRIT, TRAIT_NOSOFTCRIT)

/obj/item/organ/zizo_graft/fatigue
	name = "嫁接肺脏"
	icon_state = "lungs-con"
	slot = "zizo_graft_fatigue"
	energy = 25

/obj/item/organ/zizo_graft/health
	name = "嫁接肝脏"
	icon_state = "liver-con"
	slot = "zizo_graft_health"
	heal = 1.5

/datum/status_effect/zizo_regen
	id = "zizo_regen"
	duration = -1
	tick_interval = 2 SECONDS
	alert_type = null
	var/energy = 0

/datum/status_effect/zizo_regen/tick()
	owner.energy_add(energy)
	owner.adjustStaminaLoss(-energy / 5)

/datum/status_effect/zizo_regen/robe
	id = "zizo_robe_regen"
	energy = 10

/obj/structure/raver/post_unbuckle_mob(mob/living/M)
	. = ..()
	M.remove_status_effect(/datum/status_effect/raver_corruption)

/datum/status_effect/raver_corruption
	id = "raver_corruption"
	duration = -1
	tick_interval = 3 SECONDS
	alert_type = null
	var/obj/structure/raver/raver
	var/elapsed = 0
	var/graft = FALSE

/datum/status_effect/raver_corruption/graft
	graft = TRUE

/datum/status_effect/raver_corruption/on_creation(mob/living/new_owner, obj/structure/raver/device)
	raver = device
	. = ..()

// these filters r kinda funky & idk if they're working right, but I think it looks cool .
/datum/status_effect/raver_corruption/on_apply()
	. = ..()
	owner.overlay_fullscreen("raver", /atom/movable/screen/fullscreen/brute, 4)
	owner.add_filter("raver_glow", 1, list(type = "outline", color = "#8b0000", size = 1))
	owner.add_filter("raver_warp", 2, list(type = "wave", x = 2, y = 2, size = 3, offset = 0))
	animate(owner.get_filter("raver_warp"), offset = 6, time = 2 SECONDS, loop = -1)
	animate(offset = 0, time = 0)

/datum/status_effect/raver_corruption/on_remove()
	. = ..()
	owner.clear_fullscreen("raver")
	owner.clear_fullscreen("raver_flash")
	owner.remove_filter("raver_glow")
	owner.remove_filter("raver_warp")

/datum/status_effect/raver_corruption/tick()
	if(QDELETED(raver) || owner.buckled != raver || (is_zizo(owner) && !graft))
		qdel(src)
		return
	if(!graft)
		owner.adjustStaminaLoss(5)
	owner.Jitter(4)
	shake_camera(owner, 6, 1)
	owner.do_jitter_animation(300)
	owner.overlay_fullscreen("raver_flash", /atom/movable/screen/fullscreen/painflash)
	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob, clear_fullscreen), "raver_flash"), 4)
	playsound(raver, pick('sound/gore/flesh_eat_01.ogg', 'sound/gore/flesh_eat_02.ogg', 'sound/gore/flesh_eat_03.ogg', 'sound/gore/flesh_eat_04.ogg', 'sound/gore/flesh_eat_05.ogg', 'sound/gore/flesh_eat_06.ogg'), 70, TRUE)
	if(prob(40))
		playsound(raver, pick('sound/combat/fracture/fracturewet (1).ogg', 'sound/combat/fracture/fracturewet (2).ogg', 'sound/combat/fracture/fracturewet (3).ogg', 'sound/foley/flesh_rem.ogg', 'sound/foley/gross.ogg', 'sound/surgery/organ1.ogg', 'sound/surgery/organ2.ogg'), 70, TRUE)
	new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(raver), pick(GLOB.cardinals))
	if(owner.client)
		for(var/i in 1 to 3)
			var/turf/start = get_turf(pick(range(3, owner)))
			var/d = pick(GLOB.cardinals)
			var/dx = 0
			var/dy = 0
			if(d == EAST)
				dx = 32
			else if(d == WEST)
				dx = -32
			else if(d == NORTH)
				dy = 32
			else
				dy = -32
			var/image/bug = image('icons/roguetown/cult/ravermeat.dmi', start, pick("bloodling_stage_1", "bloodling_stage_2"), ABOVE_MOB_LAYER)
			bug.dir = d
			owner.client.images += bug
			animate(bug, pixel_x = dx, pixel_y = dy, time = 3 SECONDS) // bugs crawling around
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(clear_curse_eye), owner.client, bug), 3 SECONDS)
	if(owner.client && prob(50))
		var/image/eye = image('icons/effects/eldritch.dmi', pick(range(3, owner)), "eye_open", ABOVE_ALL_MOB_LAYER)
		owner.client.images += eye
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(clear_curse_eye), owner.client, eye), 3 SECONDS)
	if(prob(15))
		owner.emote(pick("scream", "pain"))
		to_chat(owner, span_userdanger(pick("它们在我身上爬……", "有东西往我皮下钻……", "倒刺扎进了我的肉里……")))
	elapsed += 3
	if(elapsed >= 60 && !graft)
		raver_finish_corruption(owner, raver)
		qdel(src)

/proc/raver_finish_corruption(mob/living/carbon/human/H, obj/structure/raver/R)
	if(QDELETED(H) || is_zizo(H))
		return
	if(!QDELETED(R))
		R.unbuckle_mob(H, force = TRUE)
	if(!absorb_lux(H, get_turf(H), FALSE))
		return
	if(!QDELETED(R))
		R.material += 2
		R.visible_message(span_danger("[R]吸食着[H]的灵辉，渐渐膨胀起来！"))
		playsound(R, 'sound/combat/gib (1).ogg', 80, TRUE)

/turf/closed/wall/mineral/rogue/stone/space
	name = "???"
	desc = "???"
	icon = 'icons/roguetown/cult/cultsprites.dmi'
	icon_state = "cultwall"
	smooth = SMOOTH_FALSE

/obj/structure/illusory_wall
	density = FALSE
	opacity = TRUE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/illusory_wall/Initialize(mapload, turf/closed/wall/copied)
	. = ..()
	if(!copied)
		return
	icon = copied.icon
	icon_state = copied.icon_state
	name = copied.name
	desc = copied.desc

/obj/item/cultbrick
	name = "黑暗碎片"
	desc = "这些碎片可以用来造东西。"
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "shard_small3"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	var/amount = 5
	var/maxamount = 15

/obj/item/cultbrick/Initialize(mapload)
	. = ..()
	update_shard_icon()

/obj/item/cultbrick/proc/update_shard_icon()
	if(amount >= 11)
		icon_state = "shard_large1"
	else if(amount >= 6)
		icon_state = "shard_medium2"
	else
		icon_state = "shard_small3"

/obj/item/cultbrick/examine(mob/user)
	. = ..()
	. += span_notice("这一堆共有 [amount] 枚碎片。")

/obj/item/cultbrick/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/cultbrick))
		var/obj/item/cultbrick/B = W
		if(amount + B.amount > maxamount)
			B.amount = (amount + B.amount) - maxamount
			amount = maxamount
			B.update_shard_icon()
			to_chat(user, span_warning("[src]里放不下了。"))
		else
			to_chat(user, span_notice("我将[W]加进[src]。"))
			amount += B.amount
			qdel(B)
		update_shard_icon()
		return
	return ..()

/obj/item/cultbrick/attack_right(mob/user)
	if(!amount)
		return
	switch(amount)
		if(2)
			var/obj/item/cultbrick/A = new(src.loc)
			var/obj/item/cultbrick/B = new(src.loc)
			A.amount = 1
			B.amount = 1
			user.put_in_hands(A)
			user.put_in_hands(B)
			qdel(src)
		else
			amount -= 1
			update_shard_icon()
			var/obj/item/cultbrick/F = new(src.loc)
			F.amount = 1
			user.put_in_hands(F)
			user.visible_message(span_notice("[user]从[src]取下一枚碎片。"), span_notice("我从[src]取下一枚碎片。"))

/obj/item/cultbrick/attack_self(mob/living/user)
	if(!amount)
		return
	var/turf/T = get_step(user, user.dir)
	if(!istype(T))
		to_chat(user, span_warning("那里没有建造空间。"))
		return
	if(T.density && !istype(T, /turf/closed/wall) && !(locate(/obj/structure/mineral_door) in T))
		to_chat(user, span_warning("那里没有建造空间。"))
		return
	var/nearby_fuge = FALSE
	for(var/obj/structure/fuge/F in range(7, get_turf(user)))
		nearby_fuge = TRUE
		break
	if(nearby_fuge == FALSE)
		to_chat(user, span_warning("必须靠近异界织机！"))
		return
	var/choice = input_zizo_display(user, "要建造什么？", list("Wall", "Door", "Illusory Wall"))
	if(!choice || !amount)
		return
	var/turf/closed/wall/copied
	if(choice == "Illusory Wall")
		var/list/walls = list()
		for(var/turf/closed/wall/W in range(2, user))
			if(W != T)
				walls[W.name] = W
		if(!length(walls))
			to_chat(user, span_warning("附近没有墙壁。"))
			return
		var/pick = input(user, "选择要仿造的墙壁", "齐佐") as null|anything in walls
		if(!pick)
			return
		copied = walls[pick]
	if(choice == "Door")
		for(var/obj/structure/mineral_door/wood/donjon/stone/cult/D in range(2, T))
			if(get_turf(D) != T)
				to_chat(user, span_warning("离另一扇门太近了！"))
				return
	if(!do_after(user, 10 SECONDS, target = T))
		return
	if(!amount)
		return
	var/obj/structure/mineral_door/old_door = locate() in T
	if(old_door)
		qdel(old_door)
	if(istype(T, /turf/closed/wall))
		T.ChangeTurf(/turf/open/floor/rogue/underworld/space/quiet/cult)
	switch(choice)
		if("Wall")
			T.ChangeTurf(/turf/closed/wall/mineral/rogue/stone/space)
			new /obj/effect/temp_visual/cult/turf(T)
		if("Door")
			new /obj/structure/mineral_door/wood/donjon/stone/cult(T)
			new /obj/effect/temp_visual/cult/door(T)
		if("Illusory Wall")
			new /obj/structure/illusory_wall(T, copied)
			new /obj/effect/temp_visual/cult/turf(T)
	playsound(T, 'sound/foley/breaksound.ogg', 50, TRUE)
	amount--
	if(amount <= 0)
		qdel(src)
	else
		update_shard_icon()

/obj/structure/mineral_door/wood/donjon/stone/cult
	name = "怪门"
	desc = "这是什么……一扇门？"
	icon = 'icons/roguetown/cult/cultsprites.dmi'
	icon_state = "cult"
	base_state = "cult"
	over_state = "cultopen"

/obj/structure/mineral_door/wood/donjon/stone/cult/onkick(mob/user)
	to_chat(user, span_warning("我再怎么用力踹，[src]也纹丝不动。"))

/obj/structure/mineral_door/wood/donjon/stone/cult/TryToSwitchState(mob/living/user)
	if(!is_zizo(user))
		to_chat(user, span_warning("我怎么推都推不动[src]。"))
		return FALSE
	. = ..()
	new /obj/effect/temp_visual/cult/door(loc)

/obj/item/clothing/cloak/cultrobe
	name = "齐佐长袍"
	desc = "用防护布料制成的连帽长袍，格外沉重。"
	icon = 'modular_deserttown/icons/clothing/shadowcloak.dmi'
	mob_overlay_icon = 'modular_deserttown/icons/clothing/onmob/shadowcloak.dmi'
	icon_state = "warlock"
	sleeved = 'modular_deserttown/icons/clothing/onmob/shadowcloak.dmi'
	color = null
	body_parts_covered = CHEST|GROIN|ARM_LEFT|ARM_RIGHT|LEG_LEFT|LEG_RIGHT
	armor = ARMOR_LEATHER
	max_integrity = 200
	resistance_flags = FIRE_PROOF
	hoodtype = /obj/item/clothing/head/hooded/cultrobehood
	toggle_icon_state = FALSE
	var/empowered = FALSE
	var/active_item = FALSE
	var/regen_timer
	var/last_hit = -5 MINUTES
	is_cult = TRUE

/obj/item/clothing/cloak/cultrobe/take_damage(damage_amount, damage_type = BRUTE, damage_flag, sound_effect, attack_dir, armor_penetration)
	last_hit = world.time
	return ..()

/obj/item/clothing/cloak/cultrobe/Initialize(mapload)
	. = ..()
	GLOB.cult_robes += src
	if(/datum/ritual/fleshcrafting/ascend in GLOB.zizo_researchable)
		empower()
	regen()

/obj/item/clothing/cloak/cultrobe/Destroy()
	GLOB.cult_robes -= src
	deltimer(regen_timer)
	return ..()

/obj/item/clothing/head/hooded/cultrobehood
	name = "兜帽"
	desc = "邪气逼人的齐佐兜帽。"
	icon = 'icons/roguetown/cult/zizohead.dmi'
	mob_overlay_icon = 'icons/roguetown/cult/zizohead.dmi'
	icon_state = "warlockhood"
	item_state = "warlockhood"
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	block2add = FOV_BEHIND
	armor = ARMOR_LEATHER
	max_integrity = 200
	resistance_flags = FIRE_PROOF
	is_cult = TRUE

/obj/item/clothing/head/hooded/cultrobehood/empowered
	max_integrity = 400
	icon_state = "ewarlockhood"
	item_state = "ewarlockhood"

/obj/item/clothing/cloak/cultrobe/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_CLOAK && is_zizo(user))
		user.apply_status_effect(/datum/status_effect/zizo_regen/robe)
	if(slot != SLOT_CLOAK || !empowered || active_item)
		return
	active_item = TRUE
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	for(var/stat in MOBSTATS)
		H.change_stat(stat, 2)

/obj/item/clothing/cloak/cultrobe/dropped(mob/living/user)
	..()
	user?.remove_status_effect(/datum/status_effect/zizo_regen/robe)
	if(!active_item)
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	for(var/stat in MOBSTATS)
		H.change_stat(stat, -2)
	active_item = FALSE

/obj/item/clothing/cloak/cultrobe/proc/empower()
	if(empowered)
		return
	empowered = TRUE
	max_integrity = 400
	obj_integrity = max_integrity
	icon_state = "ewarlock"
	hoodtype = /obj/item/clothing/head/hooded/cultrobehood/empowered
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(!active_item)
			active_item = TRUE
			for(var/stat in MOBSTATS)
				H.change_stat(stat, 2)
		to_chat(H, span_userdanger("我的长袍中涌动着黑暗力量！"))
		H.update_inv_cloak()
		if(hoodtoggled)
			ToggleHood(H)
			ToggleHood(H)

/obj/item/clothing/cloak/cultrobe/proc/regen()
	if(QDELETED(src))
		return
	var/amount = 5
	if(empowered)
		amount = 15
	if(obj_integrity < max_integrity && world.time >= last_hit + 5 MINUTES)
		obj_integrity = min(obj_integrity + amount, max_integrity)
		if(obj_broken)
			obj_fix(full_repair = FALSE)
	regen_timer = addtimer(CALLBACK(src, PROC_REF(regen)), 1 MINUTES, TIMER_STOPPABLE)

// HOUND & SNIFFER

/obj/item/inqhound
	name = "猎犬"
	desc = "吾敌自取灭亡。装入炼金小瓶即可采集血样，供嗅探器使用。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "hound"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	grid_width = 64
	grid_height = 32
	obj_flags_ignore = TRUE
	item_flags = NOBLUDGEON
	var/bottles = 0
	var/max_bottles = 5
	var/list/obj/item/bloodvial/vials = list()

/obj/item/inqhound/proc/update_hound_icon()
	icon_state = "hound"

/obj/item/inqhound/attackby(obj/item/I, mob/living/user, params)
	if(!istype(I, /obj/item/reagent_containers/glass/bottle/alchemical))
		return ..()
	if(bottles >= max_bottles)
		to_chat(user, span_warning("[src]已经满了！"))
		return
	qdel(I)
	bottles++

/obj/item/inqhound/attack_right(mob/user)
	. = ..()
	if(!length(vials))
		to_chat(user, span_warning("[src]是空的。"))
		return
	var/obj/item/bloodvial/V = vials[1]
	vials -= V
	user.put_in_hands(V)
	update_hound_icon()

/obj/item/inqhound/attack_obj(obj/O, mob/living/user)
	var/list/blood = O.return_blood_DNA()
	if(!length(blood))
		to_chat(user, span_warning("[src]一无所获。"))
		return TRUE
	if(!bottles)
		to_chat(user, span_warning("[src]是空的。"))
		return TRUE
	icon_state = "hound_active"
	var/success = do_after(user, 3 SECONDS, target = O)
	var/list/final_blood = O.return_blood_DNA()
	if(!success || !length(final_blood))
		update_hound_icon()
		return TRUE
	bottles--
	var/obj/item/bloodvial/V = new(src)
	V.blood_dna = final_blood.Copy()
	V.name = "血样瓶（[jointext(V.blood_dna, "、")]）"
	vials += V
	to_chat(user, span_notice("[src]装满了一瓶血。"))
	update_hound_icon()
	return TRUE

/obj/item/bloodvial
	name = "血样瓶"
	desc = "一瓶采集到的血样。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "hound_vial_full"
	w_class = WEIGHT_CLASS_TINY
	var/list/blood_dna
	var/mob/living/carbon/human/target
	var/expiry

/obj/item/bloodvial/Initialize(mapload)
	. = ..()
	expiry = world.time + 10 MINUTES

/obj/item/bloodvial/examine(mob/user)
	. = ..()
	if(world.time > expiry)
		. += span_warning("血样已腐坏，不能再用了。")
	else
		. += span_notice("血样将在 [round((expiry - world.time) / (1 MINUTES))] 分钟后腐坏。")

/obj/item/inqscanner
	name = "嗅探器"
	desc = "因我等握有更高的智慧。装入猎犬采集的血样瓶，即可追踪目标。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scanner"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	grid_width = 32
	grid_height = 32
	var/obj/item/bloodvial/vial

/obj/item/inqscanner/attackby(obj/item/I, mob/living/user, params)
	if(!istype(I, /obj/item/bloodvial))
		return ..()
	if(vial)
		to_chat(user, span_warning("[src]已经满了！"))
		return
	var/obj/item/bloodvial/V = I
	if(world.time > V.expiry)
		to_chat(user, span_warning("血样已经腐坏！"))
		qdel(V)
		return
	if(!V.target)
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.dna && (H.dna.unique_enzymes in V.blood_dna))
				V.target = H
				break
	if(!V.target)
		to_chat(user, span_warning("[src]找不到踪迹！"))
		qdel(V)
		return
	user.transferItemToLoc(V, src)
	vial = V

/obj/item/inqscanner/attack_right(mob/user)
	. = ..()
	if(!vial)
		return
	user.put_in_hands(vial)
	vial = null

/obj/item/inqscanner/attack_self(mob/living/user)
	if(!vial || world.time > vial.expiry)
		if(vial)
			to_chat(user, span_warning("瓶里的血样已经腐坏。"))
			qdel(vial)
		else
			to_chat(user, span_warning("[src]找不到踪迹。"))
		vial = null
		return
	var/mob/living/carbon/human/target = vial.target
	if(GLOB.zizo_proxy[target] && !prob(25))
		target = GLOB.zizo_proxy[target]
	if(!target || QDELETED(target) || target.stat == DEAD)
		to_chat(user, span_warning("[src]找不到踪迹。"))
		qdel(vial)
		vial = null
		return
	var/dist = get_dist(user, target)
	if(dist <= 9)
		to_chat(user, span_notice("[src]离气味的源头太近了！"))
	else
		var/list/info = get_locator_info(user, target)
		to_chat(user, span_notice("[src]朝[get_direction_display(get_dir(user, target))]牵动。气味的源头似乎[zizo_scent_display(info)]。"))

/datum/ritual/transmutation/summonweapon
	lesser = TRUE
	name = "Summon Weapons"
	icon_type = /obj/item/rogueweapon/sword/long/zizo
	desc = "学会召唤阿凡泰因匕首或剑。研习时消耗一枚黑暗水晶。"
	passive = TRUE
	research_item = /obj/item/necro_relics/necro_crystal
	research_cost = 3

/datum/ritual/transmutation/summonweapon/apply_passive(mob/living/carbon/human/H)
	H.mind.AddSpell(new /datum/action/cooldown/spell/form_blade/avantyne)
	H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_EXPERT)
	return

/datum/ritual/transmutation/lessernecromancy
	lesser = TRUE
	name = "Lesser Necromancy"
	icon_type = /obj/item/natural/bone
	desc = "习得入门死灵术。研习时消耗一枚黑暗水晶。"
	research_item = /obj/item/necro_relics/necro_crystal
	passive = TRUE
	research_cost = 3
	spells = list(/obj/effect/proc_holder/spell/invoked/gravemark, /obj/effect/proc_holder/spell/invoked/command_undead, /obj/effect/proc_holder/spell/invoked/raise_undead_formation/lesser, /datum/action/cooldown/spell/bonechill, /datum/action/cooldown/spell/bonemend)

/datum/ritual/transmutation/lessernecromancy/apply_passive(mob/living/carbon/human/H)
	H.mind.current.faction |= "[H.name]_faction"
	H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE)

/datum/ritual/transmutation/hiddenward
	lesser = TRUE
	name = "Inhumen Ward"
	icon_type = /datum/action/cooldown/spell/conjure_arcyne_ward/zizo
	desc = "学会召唤坚固的隐形护盾。研习时消耗一枚黑暗水晶。"
	passive = TRUE
	research_item = /obj/item/necro_relics/necro_crystal
	research_cost = 3
	spells = list(/datum/action/cooldown/spell/conjure_arcyne_ward/zizo)

// FLESH CRAFTING
/datum/ritual/fleshcrafting
	abstract_type = /datum/ritual/fleshcrafting

/datum/ritual/fleshcrafting/bunnylegs
	name = "Saliendo Pedes"
	icon_type = /obj/item/bodypart/l_leg
	desc = "献上一双腿，永久提升跳跃高度。"
	center_requirement = /mob/living/carbon/human
	w_req = /obj/item/bodypart/l_leg
	e_req = /obj/item/bodypart/r_leg

/datum/ritual/fleshcrafting/bunnylegs/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	ADD_TRAIT(target, TRAIT_ZJUMP, TRAIT_GENERIC)
	to_chat(target, span_notice("我感觉双腿更有力了。"))

/datum/ritual/fleshcrafting/fleshmend
	lesser = TRUE
	name = "Fleshmend"
	icon_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak
	desc = "用一块生肉治疗自己。"
	n_req = /obj/item/reagent_containers/food/snacks/rogue/meat/steak
	center_requirement = /mob/living/carbon/human
	var/heal_tick = 30
	research_cost = 2

/datum/ritual/fleshcrafting/fleshmend/greater
	lesser = FALSE
	name = "Greater Fleshmend"
	icon_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak
	desc = "用一块生肉治疗自己，疗效更强。"
	is_cultist_ritual = TRUE
	heal_tick = 70
	research_cost = 5

/datum/ritual/fleshcrafting/fleshmend/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	target.playsound_local(target, 'sound/misc/vampirespell.ogg', 100, FALSE, pressure_affected = FALSE)
	target.apply_status_effect(/datum/status_effect/buff/healing, heal_tick, TRUE)
	to_chat(target, span_notice("齐佐赐予我力量。"))

/datum/ritual/fleshcrafting/darkeyes
	lesser = TRUE
	name = "Darkened Eyes"
	icon_type = /obj/item/organ/eyes
	desc = "献上一双眼睛，永久获得夜视能力。"
	center_requirement = /mob/living/carbon/human
	w_req = /obj/item/organ/eyes
	e_req = /obj/item/organ/eyes
	research_cost = 3

/datum/ritual/fleshcrafting/darkeyes/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	var/obj/item/organ/eyes/old_eyes = target.getorganslot(ORGAN_SLOT_EYES)
	if(old_eyes)
		old_eyes.Remove(target, 1)
		QDEL_NULL(old_eyes)
	var/obj/item/organ/eyes/night_vision/new_eyes = new
	new_eyes.lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	new_eyes.Insert(target)
	to_chat(target, span_notice("我再也不怕黑暗了。"))

/datum/ritual/fleshcrafting/nopain
	name = "Painless Battle"
	icon_type = /obj/item/organ/brain
	desc = "献上一颗心脏和一颗大脑，从此不再感到疼痛。需要一枚黑暗水晶。"
	research_cost = 3
	center_requirement = /mob/living/carbon/human
	n_req = /obj/item/necro_relics/necro_crystal
	w_req = /obj/item/organ/heart
	e_req = /obj/item/organ/brain

/datum/ritual/fleshcrafting/nopain/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	ADD_TRAIT(target, TRAIT_NOPAIN, TRAIT_GENERIC)
	to_chat(target, span_notice("我再也感觉不到疼痛。"))

/datum/ritual/fleshcrafting/lesserrituos
	lesser = TRUE
	name = "Lesser Rituos"
	icon_type = /obj/item/necro_relics/necro_crystal
	desc = "黑暗女士的小业。对自己施行仪式，从不死中汲取力量，最多可叠加三次。需要一枚黑暗水晶。"
	center_requirement = /mob/living/carbon/human
	n_req = /obj/item/necro_relics/necro_crystal
	research_cost = 10

/datum/ritual/fleshcrafting/lesserrituos/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = user
	var/obj/item/bodypart/head = target.get_bodypart(BODY_ZONE_HEAD)
	if(get_turf(user) != center || !target.mind || head?.skeletonized || HAS_TRAIT_FROM(target, TRAIT_MONSTROUS, "lesser_rituos"))
		to_chat(user, span_warning("仪式毫无反应。"))
		new /obj/item/necro_relics/necro_crystal(center)
		return
	to_chat(user, span_notice("仪式开始了，保持不动。"))
	var/poo = new /obj/effect/temp_visual/opengate(center, 10 SECONDS)
	playsound(user, 'sound/villain/littlescary.ogg', 100, TRUE)
	if(!do_after(user, 10 SECONDS) || QDELETED(target) || !(target in center.contents))
		qdel(poo)
		new /obj/item/necro_relics/necro_crystal(center)
		return
	var/limbs = 0
	for(var/obj/item/bodypart/part in target.bodyparts)
		if(part.skeletonized && part != head && !istype(part, /obj/item/bodypart/chest))
			limbs++
	var/stage = 1
	if(HAS_TRAIT(target, TRAIT_WARLOCK) || limbs >= 4)
		stage = 3
	else if(limbs)
		stage = 2
	target.mob_biotypes |= MOB_UNDEAD
	var/list/parts = list()
	for(var/obj/item/bodypart/part in target.bodyparts)
		if(part.skeletonized || (stage < 3 && (part == head || istype(part, /obj/item/bodypart/chest))))
			continue
		parts += part
	if(stage == 1 && length(parts))
		parts = list(pick(parts))
	for(var/obj/item/bodypart/part in parts)
		part.skeletonize(FALSE)
	target.update_body_parts()
	var/list/traits = list(TRAIT_ARCYNE)
	if(stage != 2)
		traits += list(TRAIT_NOMOOD, TRAIT_SILVER_WEAK)
	if(stage > 1)
		traits += list(TRAIT_TOXIMMUNE, TRAIT_NOHUNGER, TRAIT_NOBREATH, TRAIT_UNLYCKERABLE, TRAIT_LIMBATTACHMENT)
	if(stage == 3)
		traits += list(TRAIT_NOPAIN, TRAIT_BLOODLOSS_IMMUNE)
		ADD_TRAIT(target, TRAIT_MONSTROUS, "lesser_rituos")
	for(var/trait in traits)
		if(!HAS_TRAIT(target, trait))
			ADD_TRAIT(target, trait, "lesser_rituos")
	var/list/config = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 0)
	//I think this works...? It'd be nice if it was easier !
	if(LAZYLEN(target.mind.mage_aspect_config))
		config = target.mind.mage_aspect_config.Copy()
	if(stage < 3)
		config["minor"] += 1
		config["utilities"] += 3
	target.mind.setup_mage_aspects(config)
	playsound(center, 'sound/misc/lava_death.ogg', 100, FALSE)
	to_chat(target, span_notice("死亡并非终点。我的灵魂属于她。"))
	new /obj/effect/temp_visual/zizo_ring(center)
	var/obj/effect/abstract/particle_holder/burst = new(center, /particles/zizo_burst)
	QDEL_IN(burst, 1.4 SECONDS)
	target.Knockdown(5 SECONDS)
	target.emote("agony", forced = TRUE)
	for(var/atom/A in range(7, center))
		if(A.light_on && A.light_outer_range)
			zizo_flicker(A)
	if(stage == 3)
		if(HAS_TRAIT(target, TRAIT_WARLOCK))
			grant_poke_spell_zizo_warlock(target)
		else
			grant_poke_spell_zizo(target)

/datum/ritual/fleshcrafting/immortality
	lesser = TRUE
	name = "Flawed Immortality"
	icon_type = /obj/item/organ/heart
	desc = "献祭一名亚斯玛尔，换取有缺陷的不朽。它或许没有你想的那么有用。"
	center_requirement = /mob/living/carbon/human
	n_req = /mob/living/carbon/human
	research_cost = 10

/datum/ritual/fleshcrafting/immortality/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	var/mob/living/carbon/human/victim = locate() in get_step(center, NORTH)
	if(!(is_species(victim, /datum/species/aasimar)))
		to_chat(user, span_danger("祭品必须是一名亚斯玛尔。"))
		return
	victim.set_species(/datum/species/human/northern)
	ADD_TRAIT(target, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NODEATH, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOLIMBDISABLE, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NODISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOHARDCRIT, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_EXTREME_TEMPERATURE_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_PACIFISM, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOSOFTCRIT, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_MONSTROUS, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	to_chat(target, span_notice("齐佐赐予我力量！哪里出了差错，仪式失败了——可它仍把力量留给了我！"))
	target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/regenerate)
	target.change_stat(STATKEY_STR, -3)
	target.change_stat(STATKEY_SPD, -4)
	target.Knockdown(5 SECONDS)
	target.emote("agony", forced = TRUE)

/datum/ritual/fleshcrafting/ascend
	name = "ASCEND!"
	icon_type = /obj/item/clothing/head/roguetown/crown/zizo
	desc = "在城堡内举行仪式，将统治者置于北侧，将灵辉纯净之人置于南侧献祭。统治者须在亵渎祭坛上待满 5 分钟，你才能飞升。所有人都会收到警报。"
	center_requirement = /mob/living/carbon/human
	center_desc = "即将飞升之人"
	n_req = /mob/living/carbon/human
	n_desc = "统治者"
	s_req = /mob/living/carbon/human
	s_desc = "灵辉纯净之人"
	is_cultist_ritual = TRUE

/obj/effect/proc_holder/spell/bloodcrawl/ascendant
	recharge_time = 1 MINUTES
	invocations = list("Kri'tha mak!")
	invocation_type = "shout"
	gesture_required = TRUE

/datum/ritual/fleshcrafting/ascend/invoke(mob/living/user, turf/center)
	var/area/rogue/ritual_area = get_area(center)
	if(!istype(ritual_area) || !ritual_area.keep_area)
		to_chat(user, span_warning("飞升仪式必须在城堡内举行。统治者须躺在北侧，灵辉纯净之人须躺在南侧。"))
		return
	var/mob/living/carbon/human/cultist = locate() in center.contents
	if(!cultist || cultist != user || !is_zizo(cultist))
		return
	var/mob/living/carbon/human/RULER = SSticker.rulermob
	if(!RULER || RULER.loc != get_step(center, NORTH))
		to_chat(user, span_warning("飞升仪式必须在城堡内举行。统治者须躺在北侧，灵辉纯净之人须躺在南侧。"))
		return
	var/mob/living/carbon/human/cleric = locate() in get_step(center, SOUTH)
	if(!cleric || cleric.purity == FALSE || cleric.stat == DEAD)
		to_chat(user, span_warning("飞升仪式必须在城堡内举行。统治者须躺在北侧，灵辉纯净之人须躺在南侧。"))
		return
	cleric.visible_message(span_danger("[cleric]的身体干瘪下去，断了气！"))
	cleric.death()
	RULER.Unconscious(6 MINUTES)
	priority_announce("难以名状的邪恶正在城堡中苏醒！拿起武器，末日将至！", title = "齐佐", sound = 'sound/villain/seen_wonder.ogg')
	for(var/datum/mind/M in SSmapping.retainer.cultists)
		var/datum/antagonist/zizocultist/Z = M.has_antag_datum(/datum/antagonist/zizocultist)
		Z?.add_halo()
	var/datum/particle_weather/storm = new /datum/particle_weather/blood_rain_storm
	SSParticleWeather.runningWeather = storm
	storm.start()
	var/obj/structure/raver/altar/altar = new(RULER.loc)
	altar.buckle_mob(RULER, TRUE, FALSE)
	RULER.apply_status_effect(/datum/status_effect/zizo_ascension, cultist, altar)
	to_chat(user, span_boldnotice("不惜一切代价，让统治者留在祭坛上！"))

/obj/structure/raver/altar
	name = "亵渎祭坛"
	desc = "地狱的巨口已然裂开！"
	max_integrity = 600

/obj/structure/raver/altar/post_buckle_mob(mob/living/M)
	return

/obj/structure/raver/altar/examine(mob/user)
	return list("[name]. [desc]")

/datum/status_effect/zizo_ascension
	id = "zizo_ascension"
	duration = -1
	tick_interval = 5 SECONDS
	var/mob/living/carbon/human/cultist
	var/obj/structure/raver/altar/altar
	var/elapsed = 0

/datum/status_effect/zizo_ascension/on_creation(mob/living/new_owner, mob/living/carbon/human/leader, obj/structure/raver/altar/device)
	cultist = leader
	altar = device
	. = ..()

/datum/status_effect/zizo_ascension/tick()
	if(QDELETED(cultist) || cultist.stat == DEAD || QDELETED(altar) || owner.loc != altar.loc)
		ascension_fail()
		return
	elapsed += 5
	if(elapsed >= 300)
		zizo_ascend(cultist)
		owner.gib()
		qdel(altar)
		qdel(src)

/datum/status_effect/zizo_ascension/proc/ascension_fail()
	priority_announce("天光重现！飞升仪式被阻止了！", title = "安宁", sound = 'sound/misc/triumph.ogg')
	qdel(altar)
	qdel(src)

/proc/zizo_ascend(mob/living/carbon/human/cultist)
	if(QDELETED(cultist) || !cultist.mind)
		return
	SSmapping.retainer.cult_ascended = TRUE
	to_chat(cultist, span_userdanger("我成功了！我已超脱凡躯！齐佐对我微笑，望向无知之人的眼中却满是恶意！"))
	for(var/datum/action/A as anything in cultist.actions.Copy())
		qdel(A)
	cultist.RemoveAllSpells()
	cultist.mind.RemoveAllSpells()
	var/mob/living/simple_animal/hostile/retaliate/rogue/zizo_ascendant/ascendant = new(get_turf(cultist))
	cultist.mind.transfer_to(ascendant)
	qdel(cultist)
	priority_announce("天幕漆黑，格里莫里亚迎来了至暗之日。", title = "飞升", sound = 'sound/villain/dreamer_win.ogg')
	SSvote.initiate_vote("endround", "齐佐", null, forced = TRUE)
	for(var/mob/living/carbon/human/V in GLOB.human_list)
		if(V.mind in SSmapping.retainer.cultists)
			V.add_stress(/datum/stressevent/lovezizo)
		else
			V.add_stress(/datum/stressevent/hatezizo)

/obj/item/clothing/head/roguetown/crown/zizo
	name = "齐佐之冠"
	desc = "献给飞升者。"
	mob_overlay_icon = 'icons/roguetown/cult/zizohead.dmi'
	icon_state = "zcrown"

/obj/effect/proc_holder/spell/targeted/touch/cleave
	name = "斩首"
	desc = "取人性命。"
	clothes_req = FALSE
	overlay_state = "gravemark"
	recharge_time = 15 SECONDS
	chargedloop = null
	hand_path = /obj/item/melee/touch_attack/cleave
	cost = 0
	hide_charge_effect = TRUE
	gesture_required = TRUE

/obj/item/melee/touch_attack/cleave
	name = "收割之手"
	desc = "触碰敌人，斩下其头颅。"
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#8a13bd"

/obj/item/melee/touch_attack/cleave/attack_self()
	attached_spell.remove_hand()

/obj/item/melee/touch_attack/cleave/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/spelltarget = target
	if(psydont(spelltarget))
		to_chat(user, span_danger("对方身上的白银抵挡了黑魔法！"))
		return
	to_chat(spelltarget, span_danger("你有种极为不祥的预感。快逃！"))
	if(!do_after(user, 3 SECONDS, target = spelltarget))
		return
	var/obj/item/bodypart/head/head = spelltarget.get_bodypart("head")
	if(head)
		head.dismember()
	spelltarget.visible_message(span_danger("[user]扬手横斩，[spelltarget]的头颅应声飞落！"))
	attached_spell.remove_hand()

/obj/effect/proc_holder/spell/targeted/touch/ascended_heal
	name = "赐福"
	desc = "治愈伤者。"
	clothes_req = FALSE
	overlay_state = "gravemark"
	recharge_time = 10 SECONDS
	chargedloop = null
	hand_path = /obj/item/melee/touch_attack/ascended_heal
	cost = 0
	hide_charge_effect = TRUE
	gesture_required = TRUE

/obj/item/melee/touch_attack/ascended_heal
	name = "愈合之手"
	desc = "触碰一人，治愈其伤。"
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#8a13bd"

/obj/item/melee/touch_attack/ascended_heal/attack_self()
	attached_spell.remove_hand()

/obj/item/melee/touch_attack/ascended_heal/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!isliving(target))
		return
	var/mob/living/spelltarget = target
	if(spelltarget.stat == DEAD)
		to_chat(user, span_warning("人已经死了，得用复生术。"))
		return
	if(!do_after(user, 3 SECONDS, target = spelltarget))
		return
	spelltarget.revive(full_heal = TRUE, admin_revive = TRUE)
	spelltarget.visible_message(span_notice("光芒一闪，[user]治好了[spelltarget]！"))
	explosion(get_turf(spelltarget), flash_range = 7)
	attached_spell.remove_hand()

/obj/effect/proc_holder/spell/targeted/touch/true_resurrection
	name = "真复生术"
	desc = "唤回死者。"
	clothes_req = FALSE
	overlay_state = "gravemark"
	recharge_time = 30 SECONDS
	chargedloop = null
	hand_path = /obj/item/melee/touch_attack/true_resurrection
	cost = 0
	hide_charge_effect = TRUE
	gesture_required = TRUE

/obj/item/melee/touch_attack/true_resurrection
	name = "复生之手"
	desc = "触碰死者，使其重返人世。"
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#8a13bd"

/obj/item/melee/touch_attack/true_resurrection/attack_self()
	attached_spell.remove_hand()

/obj/item/melee/touch_attack/true_resurrection/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!isliving(target))
		return
	var/mob/living/spelltarget = target
	if(spelltarget.stat != DEAD)
		to_chat(user, span_warning("此人尚在人世。"))
		return
	if(!do_after(user, 3 SECONDS, target = spelltarget))
		return
	spelltarget.revive(full_heal = TRUE, admin_revive = TRUE)
	ADD_TRAIT(spelltarget, TRAIT_ROTMAN, TRAIT_GENERIC)
	spelltarget.visible_message(span_notice("[user]将[spelltarget]从死亡中拉了回来！"))
	explosion(get_turf(spelltarget), flash_range = 7)
	attached_spell.remove_hand()

/obj/effect/decal/cleanable/sigil
	name = "符印"
	desc = "奇异的符文，直视它们会让双眼刺痛。"
	icon_state = "center"
	icon = 'icons/obj/sigils.dmi'
	var/sigil_type
	var/portal_id
	var/obj/effect/decal/cleanable/sigil/portal_link
	var/static/list/sigil_states = list("Lesser" = "lesser", "Portal" = "strand2", "Strand" = "strand", "Toil" = "toil", "Bite" = "bite", "Pitch" = "pitch", "Noise" = "noise", "Blood" = "blood", "Rot" = "rot")

/obj/effect/decal/cleanable/sigil/examine(mob/user)
	. = ..()
	if(!sigil_type)
		return
	if(isliving(user))
		var/mob/living/living_user = user
		if(istype(living_user.patron, /datum/patron/inhumen/zizo))
			to_chat(user, "这是[zizo_display(sigil_type)]法阵的符印。")
			if(sigil_type == "Portal")
				var/area/current_area = get_area(src)
				var/info = "通道 #[portal_id]（[current_area.name]）。"
				if(portal_link)
					var/area/destination_area = get_area(portal_link)
					info += "已连接到 #[portal_link.portal_id]（[destination_area.name]）。"
				else
					info += "尚未连接。"
				to_chat(user, info)

/obj/effect/decal/cleanable/sigil/proc/set_sigil_type(newtype)
	sigil_type = newtype
	if(icon_state == "center")
		icon_state = sigil_states[newtype] || "center"
	if(newtype == "Portal")
		GLOB.zizo_portals |= src
		if(!portal_id)
			portal_id = ++GLOB.zizo_portal_count
		icon_state = "strand2"
		update_icon()

/obj/effect/decal/cleanable/sigil/proc/choose_link(mob/user)
	var/list/choices = list()
	for(var/obj/effect/decal/cleanable/sigil/passage in GLOB.zizo_portals)
		if(passage != src)
			var/area/passage_area = get_area(passage)
			choices["#[passage.portal_id], [passage_area.name]"] = passage
	if(!length(choices))
		to_chat(user, span_notice("先造另一条通道！"))
		return
	var/choice = tgui_input_list(user, "选择要连接的通道", "齐佐", choices)
	if(!choice)
		return
	var/obj/effect/decal/cleanable/sigil/connectee = choices[choice]
	if(QDELETED(connectee) || QDELETED(src))
		return
	if(portal_link)
		portal_link.portal_link = null
	if(connectee.portal_link)
		connectee.portal_link.portal_link = null
	portal_link = connectee
	connectee.portal_link = src
	to_chat(user, span_notice("通道 #[portal_id] 已连接到 #[connectee.portal_id]。"))

/obj/effect/decal/cleanable/sigil/attack_right(mob/user)
	. = ..()
	if(sigil_type == "Portal" && is_zizo(user))
		choose_link(user)

/obj/effect/decal/cleanable/sigil/Destroy()
	GLOB.zizo_portals -= src
	if(portal_link)
		portal_link.portal_link = null
		portal_link = null
	return ..()

/obj/effect/decal/cleanable/sigil/proc/consume_ingredients(datum/ritual/R)
	var/list/reqs = list("[NORTH]" = R.n_req, "[SOUTH]" = R.s_req, "[EAST]" = R.e_req, "[WEST]" = R.w_req)
	for(var/dir_req in reqs)
		for(var/atom/A in get_step(src, text2num(dir_req)))
			if(istype(A, reqs[dir_req]) && !ishuman(A))
				playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
				qdel(A)
	for(var/atom/A in loc.contents)
		if(istype(A, R.center_requirement) && !ishuman(A))
			if(R.keep_center)
				continue
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

/obj/effect/decal/cleanable/sigil/attack_hand(mob/living/user)
	. = ..()
	if(!istype(user.patron, /datum/patron/inhumen/zizo))
		return
	if(sigil_type == "Greater" && !is_zizo(user))
		to_chat(user, span_warning("我还无法驾驭这枚符印。"))
		return
	if(sigil_type == "Portal")
		var/obj/effect/decal/cleanable/sigil/dest = portal_link
		if(QDELETED(dest))
			to_chat(user, span_warning("尚未连接。右键点击符印可选择通道。"))
			return
		var/turf/effect_turf = get_turf(user)
		var/poo = new /obj/effect/temp_visual/opengate(effect_turf, 2 SECONDS)
		playsound(user, 'sound/villain/newheart.ogg', 60, TRUE)
		if(!do_after(user, 2 SECONDS))
			qdel(poo)
			return
		var/turf/T = get_turf(dest)
		new /obj/effect/temp_visual/cult/blood/out(effect_turf)
		new /obj/effect/temp_visual/cult/blood(T)
		new /obj/effect/temp_visual/zizo_ring(effect_turf)
		new /obj/effect/temp_visual/zizo_ring(T)
		for(var/mob/living/L in range(1, src))
			do_teleport(L, T)
		return
	var/list/rituals_pre = list()
	switch(sigil_type)
		if("Lesser", "Greater")
			for(var/datum/ritual/ritual_type as anything in subtypesof(/datum/ritual/servantry) + subtypesof(/datum/ritual/transmutation) + subtypesof(/datum/ritual/fleshcrafting))
				if(initial(ritual_type.lesser) == (sigil_type == "Lesser"))
					rituals_pre += ritual_type
		if("Strand")
			rituals_pre = subtypesof(/datum/ritual/strand)
		if("Pitch")
			rituals_pre = subtypesof(/datum/ritual/pitch)
		if("Toil")
			rituals_pre = subtypesof(/datum/ritual/toil)
		if("Bite")
			rituals_pre = subtypesof(/datum/ritual/bite)
		if("Rot")
			rituals_pre = subtypesof(/datum/ritual/rot)
		if("Noise")
			rituals_pre = subtypesof(/datum/ritual/noise)
		if("Blood")
			rituals_pre = subtypesof(/datum/ritual/blood)
	if(!length(rituals_pre))
		return
	var/list/rituals = list()
	for(var/datum/ritual/ritual as anything in rituals_pre)
		if(ritual_available(user, ritual))
			rituals += initial(ritual.name)
	if(!length(rituals))
		to_chat(user, span_warning("我不知道该怎样使用它。"))
		return

	var/ritualnameinput = input_zizo_display(user, "选择仪式", rituals)
	if(!ritualnameinput)
		return
	var/datum/ritual/pickritual = LAZYACCESS(GLOB.ritualslist, ritualnameinput)
	if(!pickritual)
		return

	var/list/reqs = list("[EAST]" = pickritual.e_req, "[SOUTH]" = pickritual.s_req, "[WEST]" = pickritual.w_req, "[NORTH]" = pickritual.n_req)
	var/ritual_ok = TRUE
	for(var/dir_req in reqs)
		if(!reqs[dir_req])
			continue
		var/found = FALSE
		for(var/atom/A in get_step(src, text2num(dir_req)))
			if(istype(A, reqs[dir_req]))
				found = TRUE
				break
		if(!found)
			ritual_ok = FALSE
	if(pickritual.center_requirement)
		var/found = FALSE
		for(var/atom/A in loc.contents)
			if(istype(A, pickritual.center_requirement))
				found = TRUE
				break
		if(!found)
			ritual_ok = FALSE
	if(!ritual_ok)
		to_chat(user, span_danger("仪式所需：[pickritual.hugbox()]"))
		to_chat(user, span_danger("蠢货，仪式可不是这么做的。"))
		user.electrocute_act(1, src, 1, SHOCK_NOSTUN)
		return

	consume_ingredients(pickritual)
	var/obj/effect/abstract/particle_holder/burst = new(src, /particles/zizo_burst)
	QDEL_IN(burst, 1.4 SECONDS)
	for(var/atom/A in range(7, src))
		if(A.light_on && A.light_outer_range)
			zizo_flicker(A)
	user.playsound_local(user, 'sound/vo/cult/tesa.ogg', 25)
	user.whisper("奥维纳·泰萨……")
	pickritual.invoke(user, loc)

/obj/effect/decal/cleanable/sigil/N
	icon_state = "N"
/obj/effect/decal/cleanable/sigil/NE
	icon_state = "NE"
/obj/effect/decal/cleanable/sigil/E
	icon_state = "E"
/obj/effect/decal/cleanable/sigil/SE
	icon_state = "SE"
/obj/effect/decal/cleanable/sigil/S
	icon_state = "S"
/obj/effect/decal/cleanable/sigil/SW
	icon_state = "SW"
/obj/effect/decal/cleanable/sigil/W
	icon_state = "W"
/obj/effect/decal/cleanable/sigil/NW
	icon_state = "NW"

/turf/open/floor/proc/generateSigils(mob/M, sigiltype)
	var/turf/T = get_turf(M.loc)
	for(var/obj/A in T)
		if(istype(A, /obj/effect/decal/cleanable/sigil))
			to_chat(M, span_warning("这里已经有一枚符印。"))
			return
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(M, span_warning("这里已经有东西了。"))
			return
	var/isblood = FALSE
	var/draw_time = 5 SECONDS
	if(HAS_TRAIT(M, TRAIT_BLOODBOUND))
		draw_time = 1 SECONDS
	if(sigiltype == "Greater")
		draw_time *= 2
	if(do_after(M, draw_time))
		if(!isblood)
			M.bloody_hands--
			M.update_inv_gloves()
		var/obj/effect/decal/cleanable/sigil/C = new(src)
		C.set_sigil_type(sigiltype)
		C.add_mob_blood(M)
		playsound(M, 'sound/items/write.ogg', 100)
		if(sigiltype == "Lesser")
			return
		var/list/sigilsPath = list(
			/obj/effect/decal/cleanable/sigil/N,
			/obj/effect/decal/cleanable/sigil/S,
			/obj/effect/decal/cleanable/sigil/E,
			/obj/effect/decal/cleanable/sigil/W,
			/obj/effect/decal/cleanable/sigil/NE,
			/obj/effect/decal/cleanable/sigil/NW,
			/obj/effect/decal/cleanable/sigil/SE,
			/obj/effect/decal/cleanable/sigil/SW
		)
		for(var/i = 1; i <= GLOB.alldirs.len; i++)
			var/turf/floor = get_step(src, GLOB.alldirs[i])
			var/sigil = sigilsPath[i]
			var/obj/effect/decal/cleanable/sigil/satellite = new sigil(floor)
			satellite.add_mob_blood(M)

/mob/living/carbon/human/proc/draw_sigil()
	set name = "绘制符印"
	set category = "齐佐"
	if(incapacitated() || stat >= UNCONSCIOUS)
		return
	if(!HAS_TRAIT(src, TRAIT_BLOODBOUND) && !bloody_hands && !get_bleed_rate())
		to_chat(src, span_danger("我手上沾的血还不够。"))
		return
	var/static/list/cats = list("Strand" = /datum/ritual/strand, "Pitch" = /datum/ritual/pitch, "Toil" = /datum/ritual/toil, "Bite" = /datum/ritual/bite, "Rot" = /datum/ritual/rot, "Blood" = /datum/ritual/blood, "Noise" = /datum/ritual/noise)
	var/list/runes = list()
	for(var/datum/ritual/ritual_type as anything in subtypesof(/datum/ritual/servantry) + subtypesof(/datum/ritual/transmutation) + subtypesof(/datum/ritual/fleshcrafting))
		if(!ritual_available(src, ritual_type))
			continue
		if(initial(ritual_type.lesser))
			runes |= "Lesser"
		else if(is_zizo(src))
			runes |= "Greater"
	for(var/cat in cats)
		for(var/datum/ritual/ritual as anything in subtypesof(cats[cat]))
			if(ritual_available(src, ritual))
				runes += cat
				break
	if(!runes.len)
		to_chat(src, span_warning("我还没学过任何仪式。"))
		return
	var/choice = input_zizo_display(src, "选择符印类型", runes)
	if(!choice)
		return
	var/turf/open/floor/T = get_turf(src)
	if(istype(T))
		T.generateSigils(src, choice)

/obj/effect/proc_holder/spell/self/regenerate // This is an aheal spell designed for the zizoid immortal abomination
	name = "再生"
	desc = "伤口在剧痛中重新长合。"
	overlay_state = "bloodrage"
	sound = 'sound/misc/vampirespell.ogg'

	antimagic_allowed = TRUE
	ignore_cockblock = TRUE

	recharge_time = 3 MINUTES

/obj/effect/proc_holder/spell/self/regenerate/cast(mob/living/user = usr)
	. = ..()
	user.emote("agony", forced = TRUE)
	user.revive(full_heal = TRUE, admin_revive = TRUE)
	user.visible_message(span_notice("[user]的身体痛苦地扭动着，破损的血肉重新长合。"))
