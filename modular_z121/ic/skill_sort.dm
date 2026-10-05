// 排序直接作用于当前身体的能力列表，关闭界面或重连不会重置。
/mob/living/carbon/verb/z121_skill_sort()
	set name = "技能排序"
	set category = "IC"
	set desc = "调整已有能力的顺序，使其对应数字快捷键。"
	if(!client || client.mob != src)
		return
	var/datum/component/z121_skill_sort/sorter = AddComponent(/datum/component/z121_skill_sort)
	sorter.ui_interact(src)

/datum/component/z121_skill_sort
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/z121_skill_sort/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/z121_skill_sort/ui_state(mob/user)
	return GLOB.self_state

/datum/component/z121_skill_sort/ui_status(mob/user, datum/ui_state/state)
	if(QDELETED(parent) || user != parent || !user.client || user.client.mob != user)
		return UI_CLOSE
	return ..()

/datum/component/z121_skill_sort/ui_interact(mob/user, datum/tgui/ui)
	if(ui_status(user, ui_state(user)) == UI_CLOSE)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SkillSort", "技能排序")
		ui.open()

/datum/component/z121_skill_sort/ui_data(mob/user)
	var/list/data = list("skills" = list(), "total" = 0)
	if(ui_status(user, ui_state(user)) == UI_CLOSE)
		return data
	var/mob/living/carbon/holder = parent
	var/list/skills = data["skills"]
	data["total"] = length(holder.actions)
	for(var/index in 1 to length(holder.actions))
		var/datum/action/ability = holder.actions[index]
		if(QDELETED(ability))
			continue
		skills += list(list("id" = REF(ability), "name" = ability.name, "position" = index))
	return data

/datum/component/z121_skill_sort/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ui || ui.user != usr || ui_status(usr, ui_state(usr)) != UI_INTERACTIVE)
		return FALSE
	if(!(action in list("up", "down", "move")) || !istext(params["id"]))
		return FALSE
	var/mob/living/carbon/holder = parent
	var/datum/action/selected
	var/current_position = 0
	// 只在本人的现有能力中解析引用，避免同名能力混淆和过期请求。
	for(var/index in 1 to length(holder.actions))
		var/datum/action/ability = holder.actions[index]
		if(!QDELETED(ability) && ability.owner == holder && REF(ability) == params["id"])
			selected = ability
			current_position = index
			break
	if(!selected)
		return FALSE
	var/target_position
	switch(action)
		if("up")
			target_position = current_position - 1
		if("down")
			target_position = current_position + 1
		if("move")
			target_position = params["position"]
	if(!isnum(target_position) || target_position != round(target_position) || target_position < 1 || target_position > length(holder.actions))
		return FALSE
	if(target_position == current_position)
		return FALSE
	// 插入到目标位置，区间内其余能力保持相对顺序；数字快捷键读取此列表。
	holder.actions.Cut(current_position, current_position + 1)
	holder.actions.Insert(target_position, selected)
	for(var/index in min(current_position, target_position) to max(current_position, target_position))
		var/datum/action/ability = holder.actions[index]
		if(QDELETED(ability) || QDELETED(ability.button))
			continue
		var/atom/movable/screen/movable/action_button/button = ability.button
		button.moved = FALSE
		button.ordered = TRUE
		if(button.id && holder.client.prefs)
			holder.client.prefs.action_buttons_screen_locs["[button.name]_[button.id]"] = null
	holder.update_action_buttons(TRUE)
	return TRUE
