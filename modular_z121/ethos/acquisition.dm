// 菜单之外的随机替换和运行时授予同样必须满足机制条件与对应互斥。
/proc/z121_ethos_paired_id(id)
	var/static/list/pairs = list("pride" = "humility", "greed" = "charity", "lust" = "chastity", "envy" = "kindness", "gluttony" = "temperance", "wrath" = "patience", "sloth" = "diligence", "humility" = "pride", "charity" = "greed", "chastity" = "lust", "kindness" = "envy", "temperance" = "gluttony", "patience" = "wrath", "diligence" = "sloth")
	return pairs[id]

/proc/z121_ethos_can_receive_sin(mob/living/carbon/human/H, id)
	if(!H)
		return FALSE
	var/datum/z121_ethos/R = H.z121_get_ethos()
	if(R?.virtues[z121_ethos_paired_id(id)])
		return FALSE
	if(id == "greed" && H.has_flaw(/datum/charflaw/greedy))
		return FALSE
	if(id == "lust")
		if(!(H.age in list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)) || H.has_flaw(/datum/charflaw/addiction/lovefiend))
			return FALSE
		var/datum/preferences/P = H.client?.prefs
		if(!P)
			P = usr?.client?.prefs
		if(P && !P.sexable)
			return FALSE
	if(id == "gluttony" && HAS_TRAIT(H, TRAIT_NOHUNGER))
		return FALSE
	return TRUE

/proc/z121_ethos_random_flaw(mob/living/carbon/human/H)
	var/list/choices = list()
	var/datum/preferences/P = H.client?.prefs
	if(!P)
		P = usr?.client?.prefs
	var/list/selected = list()
	for(var/datum/charflaw/V in H.vices)
		selected += V.type
	if(H.charflaw)
		selected |= H.charflaw.type
	for(var/flaw_name in GLOB.character_flaws)
		var/path = GLOB.character_flaws[flaw_name]
		if((path in list(/datum/charflaw/randflaw, /datum/charflaw/noflaw)) || (path in selected))
			continue
		if(ispath(path, /datum/charflaw/z121_sin))
			var/datum/charflaw/z121_sin/S = GLOB.charflaw_singletons[path]
			if(!z121_ethos_can_receive_sin(H, S.ethos_id) || P?.check_vice_pick_conflict(path) || P?.check_vice_vice_conflict(path, selected))
				continue
		if((path == /datum/charflaw/greedy && H.z121_get_ethos()?.sins["greed"]) || (path == /datum/charflaw/addiction/lovefiend && H.z121_get_ethos()?.sins["lust"]))
			continue
		choices += path
	var/path = length(choices) ? pick(choices) : /datum/charflaw/eznoflaw
	H.charflaw = new path()
	H.charflaw.on_mob_creation(H)

/datum/charflaw/randflaw/apply_post_equipment(mob/user)
	if(!ishuman(user))
		return ..()
	if(prob(50))
		z121_ethos_random_flaw(user)
	else
		var/mob/living/carbon/human/H = user
		H.charflaw = new /datum/charflaw/eznoflaw()
		H.charflaw.on_mob_creation(H)

/datum/charflaw/noflaw/apply_post_equipment(mob/user)
	if(ishuman(user) && user.get_triumphs() < 3)
		z121_ethos_random_flaw(user)
		return
	return ..()

/datum/charflaw/lawless/set_up(mob/living/carbon/human/H)
	if(has_bounty(H) || (H.job in list("Wretch", "Bandit")) || H.advjob == "Wanted")
		z121_ethos_random_flaw(H)
		to_chat(H, span_warning("无法无天带来的刺激已经不够了……命运将我的缺陷改写为：<b>[H.charflaw.name]</b>。"))
		return
	return ..()
