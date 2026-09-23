// 世界调制面板属于管理员会话，换身或断线后销毁，旧窗口不能操作新躯体。
/client
	var/datum/z121_world_modulation/z121_world_panel

/client/proc/z121_world_modulation()
	set category = "-GameMaster-"
	set name = "世界调制系统"
	set desc = "调制昼夜天气、调用目录产物并修改自身角色。"
	if(!check_rights(R_ADMIN) || !mob)
		return
	if(QDELETED(z121_world_panel))
		z121_world_panel = new(mob)
	z121_world_panel.ui_interact(mob)

/datum/z121_world_modulation
	var/mob/owner
	var/current_tab = "world"
	var/busy = FALSE
	var/notice = "所有操作无需积分、材料或货币。"
	var/spawn_position = "here"
	var/catalog_source = "all"
	var/catalog_category = "全部"
	var/catalog_page = 1
	var/list/catalog_entries = list()
	var/list/catalog_keys = list()
	var/trait_query = ""
	var/trait_page = 1
	var/owned_traits_only = FALSE
	var/list/weather_types = list()

/datum/z121_world_modulation/New(mob/user)
	. = ..()
	owner = user
	RegisterSignal(owner, list(COMSIG_MOB_LOGOUT, COMSIG_QDELETING), PROC_REF(end_session))
	build_catalog()
	for(var/datum/particle_weather/weather_type as anything in subtypesof(/datum/particle_weather))
		if(initial(weather_type.name) && initial(weather_type.name) != /datum/particle_weather::name)
			weather_types += weather_type

/datum/z121_world_modulation/Destroy()
	SStgui.close_uis(src)
	if(owner)
		UnregisterSignal(owner, list(COMSIG_MOB_LOGOUT, COMSIG_QDELETING))
		if(owner.client?.z121_world_panel == src)
			owner.client.z121_world_panel = null
	owner = null
	return ..()

/datum/z121_world_modulation/proc/end_session()
	SIGNAL_HANDLER
	qdel(src)

/datum/z121_world_modulation/proc/can_use(mob/user)
	return !QDELETED(owner) && user == owner && user.client && user.client.z121_world_panel == src && check_rights_for(user.client, R_ADMIN)

/datum/z121_world_modulation/ui_state(mob/user)
	return can_use(user) ? GLOB.always_state : GLOB.never_state

/datum/z121_world_modulation/ui_status(mob/user, datum/ui_state/state)
	return can_use(user) ? UI_INTERACTIVE : UI_CLOSE

/datum/z121_world_modulation/ui_interact(mob/user, datum/tgui/ui)
	if(!can_use(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WorldModulation", "世界调制系统")
		ui.open()

/datum/z121_world_modulation/proc/stat_definitions()
	return list(
		list("key" = STATKEY_STR, "name" = "力量", "buffer" = "BUFSTR"),
		list("key" = STATKEY_PER, "name" = "感知", "buffer" = "BUFPER"),
		list("key" = STATKEY_INT, "name" = "智力", "buffer" = "BUFINT"),
		list("key" = STATKEY_CON, "name" = "体质", "buffer" = "BUFCON"),
		list("key" = STATKEY_WIL, "name" = "意志", "buffer" = "BUFEND"),
		list("key" = STATKEY_SPD, "name" = "速度", "buffer" = "BUFSPE"),
		list("key" = STATKEY_LCK, "name" = "幸运", "buffer" = "BUFLUC"),
	)

/datum/z121_world_modulation/ui_data(mob/user)
	if(!can_use(user))
		return list()
	var/mob/living/body = isliving(user) ? user : null
	var/obj/item/held = body?.get_active_held_item()
	var/list/data = list(
		"tab" = current_tab,
		"busy" = busy,
		"notice" = notice,
		"body" = !!body,
		"character" = user.name,
		"godmode" = body ? !!(body.status_flags & GODMODE) : FALSE,
		"held_item" = held?.name,
		"position" = spawn_position,
		"source" = catalog_source,
		"category" = catalog_category,
	)
	if(current_tab == "world")
		var/list/weather_rows = list()
		for(var/index in 1 to length(weather_types))
			var/datum/particle_weather/weather_type = weather_types[index]
			weather_rows += list(list("id" = index, "name" = initial(weather_type.name)))
		data["weather_options"] = weather_rows
		data["weather"] = SSParticleWeather.runningWeather?.name || "晴天"
		data["tod"] = GLOB.tod
		data["tod_override"] = GLOB.todoverride || "natural"
		data["clock"] = station_time_timestamp("hh:mm")
		data["day"] = GLOB.dayspassed
	else if(current_tab in list("items", "buildings", "creatures"))
		data["catalog"] = catalog_data()
	else if(current_tab == "stats")
		var/list/rows = list()
		for(var/list/definition as anything in stat_definitions())
			rows += list(list("id" = definition["key"], "name" = definition["name"], "value" = body ? body.get_stat(definition["key"]) : 0))
		data["stats"] = rows
	else if(current_tab == "skills")
		var/list/rows = list()
		var/index = 0
		for(var/skill_type in SSskills.all_skills)
			index++
			var/datum/skill/skill = GetSkillRef(skill_type)
			rows += list(list("id" = index, "name" = skill.name, "value" = body ? body.get_skill_level(skill_type) : 0))
		data["skills"] = rows
	else if(current_tab == "traits")
		data["traits"] = trait_data(body)
		data["trait_query"] = trait_query
		data["owned_only"] = owned_traits_only
	return data

/datum/z121_world_modulation/proc/trait_keys(mob/living/body)
	var/list/keys = list()
	for(var/define_name in GLOB.all_traits)
		keys |= list(GLOB.all_traits[define_name])
	for(var/trait in GLOB.roguetraits)
		keys |= list(trait)
	for(var/trait in body?.status_traits)
		keys |= list(trait)
	return sortList(keys)

/datum/z121_world_modulation/proc/trait_data(mob/living/body)
	var/list/matches = list()
	for(var/trait in trait_keys(body))
		var/owned = body && HAS_TRAIT(body, trait)
		if(owned_traits_only && !owned)
			continue
		var/description = html_decode(GLOB.html_tags.Replace(GLOB.roguetraits[trait] || "", ""))
		if(length(trait_query) && !findtext(trait, trait_query) && !findtext(description, trait_query))
			continue
		matches += list(list("id" = trait, "name" = trait, "description" = description, "owned" = !!owned))
	var/pages = max(1, CEILING(length(matches) / 24, 1))
	trait_page = clamp(trait_page, 1, pages)
	var/list/rows = list()
	for(var/index = 1 + (trait_page - 1) * 24; index <= min(trait_page * 24, length(matches)); index++)
		rows += list(matches[index])
	return list("rows" = rows, "page" = trait_page, "pages" = pages, "total" = length(matches))

// 所有修改都在服务端分派；目录编号只能引用本会话已有条目。
/datum/z121_world_modulation/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..() || usr != ui.user || !can_use(ui.user) || busy)
		return FALSE
	var/mob/user = ui.user
	busy = TRUE
	try
		handle_action(user, action, params)
	catch(var/exception/error)
		log_runtime("世界调制操作异常：[error]")
		notice = "操作遇到异常，详情已记录到服务器日志。"
	busy = FALSE
	return TRUE

/datum/z121_world_modulation/proc/handle_action(mob/user, action, list/params)
	if(!can_use(user))
		return
	switch(action)
		if("tab")
			if(params["tab"] in list("world", "items", "buildings", "creatures", "stats", "skills", "traits"))
				current_tab = params["tab"]
				catalog_category = "全部"
				catalog_page = 1
			return
		if("source")
			if(params["source"] in list("all", "craft", "rpg", "purchase"))
				catalog_source = params["source"]
				catalog_category = "全部"
				catalog_page = 1
			return
		if("category")
			var/list/catalog = catalog_data()
			if(params["category"] in catalog["categories"])
				catalog_category = params["category"]
				catalog_page = 1
			return
		if("page")
			if(isnum(params["page"]))
				catalog_page = clamp(round(params["page"]), 1, max(1, length(catalog_entries)))
			return
		if("position")
			if(params["position"] in list("here", "front"))
				spawn_position = params["position"]
			return
		if("spawn")
			spawn_entry(user, params["id"])
			return
		if("tod")
			set_time_of_day(params["value"])
			return
		if("weather")
			set_weather(params["id"])
			return
		if("trait_query")
			if(istext(params["value"]))
				trait_query = copytext(trim(params["value"]), 1, 129)
				trait_page = 1
			return
		if("owned_only")
			owned_traits_only = !owned_traits_only
			trait_page = 1
			return
		if("trait_page")
			if(isnum(params["page"]))
				trait_page = max(1, round(params["page"]))
			return
	if(!isliving(user))
		notice = "此功能需要当前控制一个生物角色。"
		return
	var/mob/living/body = user
	switch(action)
		if("godmode")
			body.status_flags ^= GODMODE
			notice = "无敌模式已[body.status_flags & GODMODE ? "开启" : "关闭"]。"
			audit("[notice] 角色 [key_name(body)]")
		if("stat")
			var/value = params["value"]
			if(!isnum(value) || !(value >= 1 && value <= 20) || value != round(value))
				return
			for(var/list/definition as anything in stat_definitions())
				if(definition["key"] != params["id"])
					continue
				var/old_value = body.get_stat(definition["key"])
				// 管理员指定的是当前实际值，先清除该项隐藏的越界缓冲再调用属性接口。
				body.vars[definition["buffer"]] = 0
				body.change_stat(definition["key"], value - old_value)
				body.update_stamina()
				body.updatehealth()
				notice = "[definition["name"]]：[old_value] → [body.get_stat(definition["key"])]。"
				audit("修改自身属性：[notice]")
				break
		if("skill")
			var/index = params["id"]
			var/value = params["value"]
			if(!isnum(index) || index != round(index) || index < 1 || index > length(SSskills.all_skills))
				return
			if(!isnum(value) || !(value >= SKILL_LEVEL_NONE && value <= SKILL_LEVEL_LEGENDARY) || value != round(value))
				return
			var/skill_type = SSskills.all_skills[index]
			var/datum/skill/skill = GetSkillRef(skill_type)
			var/old_value = body.get_skill_level(skill_type)
			body.adjust_skillrank(skill_type, value - old_value, TRUE)
			notice = "[skill.name]：[old_value] → [body.get_skill_level(skill_type)]。"
			audit("修改自身技能：[notice]")
		if("add_trait", "remove_trait", "custom_trait")
			var/trait = params["id"]
			if(!istext(trait) || !length(trim(trait)) || length(trait) > 128)
				return
			trait = trim(trait)
			if(action != "custom_trait" && !(trait in trait_keys(body)))
				return
			if(action == "remove_trait")
				var/list/sources = body.status_traits?[trait]
				if(!length(sources))
					return
				// 必须显式复制来源列表，才能一并删除出生来源且不在遍历时修改同一列表。
				var/list/all_sources = sources.Copy()
				REMOVE_TRAIT(body, trait, all_sources)
				notice = "已移除特性：[trait]（全部来源）。"
			else
				ADD_TRAIT(body, trait, "z121_world_modulation")
				notice = "已添加特性：[trait]。"
			audit("修改自身 Trait：[notice]")
		if("duplicate")
			duplicate_held_item(body)

/datum/z121_world_modulation/proc/audit(message)
	log_admin("[key_name(owner)] 使用世界调制系统：[message]")
	message_admins("[key_name_admin(owner)] 使用世界调制系统：[message]")

// 直接更新阶段和表现，避免 settod() 的黎明分支触发日期、税收与任务结算。
/datum/z121_world_modulation/proc/set_time_of_day(value)
	if(!(value in list("natural", "dawn", "day", "dusk", "night")) || !SSnightshift)
		return
	var/old_value = GLOB.tod
	if(value == "natural")
		var/current_time = station_time()
		if(current_time > SSnightshift.nightshift_dawn_start && current_time <= SSnightshift.nightshift_day_start)
			GLOB.tod = "dawn"
		else if(current_time > SSnightshift.nightshift_day_start && current_time <= SSnightshift.nightshift_dusk_start)
			GLOB.tod = "day"
		else if(current_time > SSnightshift.nightshift_dusk_start && current_time <= SSnightshift.nightshift_start_time)
			GLOB.tod = "dusk"
		else
			GLOB.tod = "night"
		GLOB.todoverride = null
	else
		GLOB.todoverride = value
		GLOB.tod = value
	SSnightshift.current_tod = GLOB.tod
	SSnightshift.update_nightshift()
	z121_sync_world_sunlight()
	var/list/names = list("dawn" = "黎明", "day" = "白昼", "dusk" = "黄昏", "night" = "夜晚")
	notice = value == "natural" ? "已恢复自然昼夜，当前为[names[GLOB.tod]]。" : "昼夜已固定为[names[value]]。"
	audit("昼夜 [old_value] → [GLOB.tod]，模式 [value]，保持第 [GLOB.dayspassed] 天")

/datum/z121_world_modulation/proc/set_weather(index)
	if(!isnum(index) || index != round(index) || index < 0 || index > length(weather_types) || !SSParticleWeather)
		return
	var/old_name = SSParticleWeather.runningWeather?.name || "晴天"
	var/datum/particle_weather/running = SSParticleWeather.runningWeather
	var/datum/particle_weather/queued = SSParticleWeather.queued_weather
	// 排队实例可能与当前实例相同；先解除排队引用，再分别清理且不重复删除。
	SSParticleWeather.queued_weather = null
	SSParticleWeather.queued_weather_start_time = null
	if(queued && queued != running && !QDELETED(queued))
		qdel(queued)
	if(!QDELETED(running))
		if(SSParticleWeather.weatherEffect)
			running.end()
		else
			qdel(running)
	if(index)
		SSParticleWeather.run_weather(weather_types[index], TRUE)
	var/new_name = SSParticleWeather.runningWeather?.name || "晴天"
	notice = "天气已切换为：[new_name]。"
	audit("天气 [old_name] → [new_name]")

// 户外光照独立读取时间循环；临时使用单阶段循环即可固定光照，不覆盖核心过程。
GLOBAL_DATUM(z121_world_sunlight, /datum/z121_world_sunlight)

/proc/z121_sync_world_sunlight()
	if(!SSoutdoor_effects?.initialized)
		return
	if(GLOB.todoverride in list("dawn", "day", "dusk", "night"))
		if(QDELETED(GLOB.z121_world_sunlight))
			GLOB.z121_world_sunlight = new
		GLOB.z121_world_sunlight.apply_phase(GLOB.todoverride)
	else
		QDEL_NULL(GLOB.z121_world_sunlight)

/datum/z121_world_sunlight
	var/list/saved_steps
	var/datum/time_of_day/fixed_step
	var/phase

/datum/z121_world_sunlight/New()
	. = ..()
	saved_steps = SSoutdoor_effects.time_cycle_steps
	fixed_step = new
	START_PROCESSING(SSprocessing, src)

/datum/z121_world_sunlight/proc/apply_phase(new_phase)
	phase = new_phase
	var/list/phase_types = list(
		"dawn" = /datum/time_of_day/dawn,
		"day" = /datum/time_of_day/daytime,
		"dusk" = /datum/time_of_day/dusk,
		"night" = /datum/time_of_day/midnight,
	)
	var/datum/time_of_day/phase_type = phase_types[phase]
	var/colors = initial(phase_type.color)
	fixed_step.name = initial(phase_type.name)
	fixed_step.color = list(islist(colors) ? colors[1] : colors)
	fixed_step.start = 0
	SSoutdoor_effects.time_cycle_steps = list(fixed_step)
	SSoutdoor_effects.next_day = FALSE
	SSoutdoor_effects.get_time_of_day()
	refresh_planes()

/datum/z121_world_sunlight/proc/refresh_planes()
	SSoutdoor_effects.last_color = SSoutdoor_effects.picked_color
	for(var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/plane as anything in SSoutdoor_effects.sunlighting_planes)
		// 取消旧渐变并立刻显示新阶段；新登录者从 last_color 取得同样的颜色。
		animate(plane, color = SSoutdoor_effects.picked_color, time = 0)

/datum/z121_world_sunlight/process(delta_time)
	// 其他管理员指令或剧情恢复自然昼夜时，也撤销本面板的光照覆盖。
	if(GLOB.todoverride != phase)
		z121_sync_world_sunlight()

/datum/z121_world_sunlight/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(saved_steps && SSoutdoor_effects)
		SSoutdoor_effects.time_cycle_steps = saved_steps
		SSoutdoor_effects.next_day = FALSE
		SSoutdoor_effects.get_time_of_day()
		refresh_planes()
	if(GLOB.z121_world_sunlight == src)
		GLOB.z121_world_sunlight = null
	QDEL_NULL(fixed_step)
	saved_steps = null
	return ..()
