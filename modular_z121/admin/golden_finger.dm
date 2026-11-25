#define GOLDEN_FINGER_CKEY "kukuling"
#define GOLDEN_FINGER_SOURCE "z121_golden_finger"

// 管理身份可在同一具身体上解除或恢复。只查这一个连接，不遍历在线玩家。
SUBSYSTEM_DEF(z121_golden_finger)
	name = "金手指"
	flags = SS_NO_INIT
	wait = 1 SECONDS
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME

/datum/controller/subsystem/z121_golden_finger/fire(resumed = FALSE)
	var/client/player = GLOB.directory[GOLDEN_FINGER_CKEY]
	if(!player)
		return
	if(player.can_use_golden_finger())
		player.verbs |= /client/proc/z121_golden_finger
	else
		player.verbs -= /client/proc/z121_golden_finger
		QDEL_NULL(player.golden_finger_panel)

/client/var/datum/z121_golden_finger/golden_finger_panel

/client/proc/can_use_golden_finger()
	return ckey == GOLDEN_FINGER_CKEY && check_rights_for(src, R_ADMIN)

/client/proc/z121_golden_finger()
	set name = "金手指"
	set category = "IC"
	if(!can_use_golden_finger())
		return
	if(!ishuman(mob))
		to_chat(src, span_warning("需要控制人形角色才能使用金手指。"))
		return
	if(QDELETED(golden_finger_panel) || !golden_finger_panel.can_edit(mob))
		QDEL_NULL(golden_finger_panel)
		golden_finger_panel = new(mob)
	golden_finger_panel.ui_interact(mob)

/datum/z121_golden_finger
	var/mob/living/carbon/human/owner
	var/client/player
	var/datum/admins/permission_holder
	var/list/trait_catalog = list()

/datum/z121_golden_finger/New(mob/living/carbon/human/user)
	. = ..()
	owner = user
	player = user.client
	permission_holder = player.holder
	RegisterSignal(user, list(COMSIG_MOB_LOGOUT, COMSIG_QDELETING), PROC_REF(end_session))
	for(var/define_name in GLOB.all_traits)
		trait_catalog[GLOB.all_traits[define_name]] = define_name
	for(var/trait in GLOB.roguetraits)
		if(!(trait in trait_catalog))
			trait_catalog[trait] = trait

/datum/z121_golden_finger/proc/end_session()
	SIGNAL_HANDLER
	qdel(src)

/datum/z121_golden_finger/Destroy()
	SStgui.close_uis(src)
	if(owner)
		UnregisterSignal(owner, list(COMSIG_MOB_LOGOUT, COMSIG_QDELETING))
	if(player?.golden_finger_panel == src)
		player.golden_finger_panel = null
	owner = null
	player = null
	permission_holder = null
	return ..()

/datum/z121_golden_finger/proc/can_edit(mob/user)
	return !QDELETED(owner) && user == owner && player && user.client == player && player.mob == owner && player.golden_finger_panel == src && player.holder == permission_holder && player.can_use_golden_finger()

/datum/z121_golden_finger/ui_state(mob/user)
	return can_edit(user) ? GLOB.always_state : GLOB.never_state

/datum/z121_golden_finger/ui_status(mob/user, datum/ui_state/state)
	return can_edit(user) ? UI_INTERACTIVE : UI_CLOSE

/datum/z121_golden_finger/ui_interact(mob/user, datum/tgui/ui)
	if(!can_edit(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GoldenFinger", "金手指")
		ui.open()

/datum/z121_golden_finger/ui_static_data(mob/user)
	if(!can_edit(user))
		return list()
	var/list/traits = list()
	for(var/id in trait_catalog)
		traits += list(list("id" = id, "symbol" = trait_catalog[id]))
	return list("catalog" = traits)

/datum/z121_golden_finger/ui_data(mob/user)
	if(!can_edit(user))
		return list()
	var/list/stats = list()
	for(var/id in MOBSTATS)
		stats += list(list("id" = id, "name" = get_stat_display_name(id), "value" = owner.get_stat(id)))
	var/list/owned = list()
	for(var/trait in owner.status_traits)
		owned += trait
	var/datum/skill_holder/holder = owner.ensure_skills()
	var/list/skills = list()
	for(var/path in SSskills.all_skills)
		var/datum/skill/skill = GetSkillRef(path)
		var/datum/skill/category = skill.abstract_type
		skills += list(list("id" = "[path]", "name" = skill.name, "category" = initial(category.name), "base" = holder.known_skills[skill] || 0, "effective" = holder.get_skill_level(path)))
	return list("stats" = stats, "owned" = owned, "skills" = skills)

/datum/z121_golden_finger/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || !ui || ui.user != usr || !can_edit(usr))
		return
	var/id = params["id"]
	if(!istext(id))
		return FALSE
	var/value = params["value"]
	switch(action)
		if("set_stat", "step_stat")
			if(!(id in MOBSTATS) || !isnum(value))
				return FALSE
			if(action == "step_stat")
				if(value != 1 && value != -1)
					return FALSE
				value += owner.get_stat(id)
			if(value != round(value) || value < 1 || value > 20)
				return FALSE
			z121_stat_delta(owner, id, value - z121_stat_total(owner, id))
			owner.update_stamina()
			owner.updatehealth()
		if("add_trait")
			if(!(id in trait_catalog) || HAS_TRAIT(owner, id))
				return FALSE
			ADD_TRAIT(owner, id, GOLDEN_FINGER_SOURCE)
		if("remove_trait")
			if(!HAS_TRAIT(owner, id))
				return FALSE
			var/list/sources = owner.status_traits[id]
			for(var/source in sources.Copy())
				REMOVE_TRAIT(owner, id, source)
		if("set_skill")
			var/path = text2path(id)
			if(!(path in SSskills.all_skills) || !isnum(value) || value != round(value) || value < SKILL_LEVEL_NONE || value > SKILL_LEVEL_LEGENDARY)
				return FALSE
			var/datum/skill_holder/holder = owner.ensure_skills()
			var/datum/skill/skill = GetSkillRef(path)
			if((holder.known_skills[skill] || 0) != value)
				var/list/brackets = holder.get_xp_brackets(value)
				holder.adjust_experience(path, brackets[1] - (holder.skill_experience[skill] || 0), TRUE)
		else
			return FALSE
	return TRUE

#undef GOLDEN_FINGER_SOURCE
#undef GOLDEN_FINGER_CKEY
