// 排序直接作用于当前身体的能力列表，关闭界面或重连不会重置。
/mob/living/carbon/verb/z121_skill_sort()
	set name = "技能排序"
	set category = "IC"
	set desc = "调整能力顺序和数字快捷键，或隐藏能力栏中的单个图标。"
	if(!client || client.mob != src)
		return
	var/datum/component/z121_skill_sort/sorter = AddComponent(/datum/component/z121_skill_sort)
	sorter.ui_interact(src)

/mob/living/carbon/update_action_buttons(reload_screen)
	. = ..()
	if(!client || !hud_used || hud_used.hud_shown != HUD_STYLE_STANDARD || hud_used.action_buttons_hidden)
		return
	var/datum/component/z121_skill_sort/sorter = GetComponent(/datum/component/z121_skill_sort)
	if(!length(sorter?.hidden_actions))
		return
	// 父级负责刷新按钮和快捷键。只收紧可见按钮的布局，保留完整能力列表。
	var/visible_position = 0
	for(var/index in 1 to length(actions))
		var/datum/action/ability = actions[index]
		var/atom/movable/screen/movable/action_button/button = ability.viewers[hud_used]
		if(!button)
			continue
		if(sorter.hidden_actions[ability])
			button.screen_loc = null
			button.set_hotkey_label(null)
			continue
		button.screen_loc = hud_used.ButtonNumberToScreenCoords(++visible_position)
		button.set_hotkey_label(index <= 9 ? index : null)

/datum/component/z121_skill_sort
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/list/hidden_actions = list()

/datum/component/z121_skill_sort/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/z121_skill_sort/proc/show_action_icon(datum/action/ability)
	SIGNAL_HANDLER
	hidden_actions -= ability
	UnregisterSignal(ability, COMSIG_ACTION_REMOVED)

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
		ui = new(user, src, "ToggleOptionsMenu", "技能排序")
		ui.open()

/datum/component/z121_skill_sort/ui_data(mob/user)
	if(ui_status(user, ui_state(user)) == UI_CLOSE)
		return list("categories" = list())
	var/mob/living/carbon/holder = parent
	var/list/skills = list()
	var/sortable_count = holder.get_sortable_action_count()
	for(var/index in 1 to sortable_count)
		var/datum/action/ability = holder.actions[index]
		if(QDELETED(ability))
			continue
		var/hidden = hidden_actions[ability]
		var/list/options = list(list("label" = hidden ? "显示图标" : "隐藏图标", "value" = hidden ? "show" : "hide"))
		if(index > 1)
			options += list(list("label" = "上移", "value" = "up"))
		if(index < sortable_count)
			options += list(list("label" = "下移", "value" = "down"))
		if(sortable_count > 1)
			options += list(list("label" = "移至…", "value" = "move"))
		var/label = "[index]. [ability.name]"
		if(index <= 9)
			label += "（Alt+[index]）"
		if(hidden)
			label += " · 已隐藏"
		skills += list(list("id" = REF(ability), "label" = label, "options" = options, "desc" = "隐藏图标后仍可用原快捷键。设置仅对本局的当前身体有效。"))
	var/title = sortable_count ? "已有能力（[sortable_count]）" : "你目前没有可以排序的能力。"
	return list("categories" = list(list("name" = title, "entries" = list(), "selects" = skills)))

/datum/component/z121_skill_sort/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ui || ui.user != usr || ui_status(usr, ui_state(usr)) != UI_INTERACTIVE)
		return FALSE
	if(action != "select" || !istext(params["id"]))
		return FALSE
	var/mob/living/carbon/holder = parent
	var/sortable_count = holder.get_sortable_action_count()
	var/datum/action/selected
	var/current_position = 0
	// 只在本人的现有能力中解析引用，避免同名能力混淆和过期请求。
	for(var/index in 1 to sortable_count)
		var/datum/action/ability = holder.actions[index]
		if(!QDELETED(ability) && ability.owner == holder && REF(ability) == params["id"])
			selected = ability
			current_position = index
			break
	if(!selected)
		return FALSE
	var/target_position
	switch(params["value"])
		if("hide")
			if(hidden_actions[selected])
				return FALSE
			hidden_actions[selected] = TRUE
			RegisterSignal(selected, COMSIG_ACTION_REMOVED, PROC_REF(show_action_icon))
			holder.update_action_buttons(TRUE)
			return TRUE
		if("show")
			if(!hidden_actions[selected])
				return FALSE
			show_action_icon(selected)
			holder.update_action_buttons(TRUE)
			return TRUE
		if("up")
			target_position = current_position - 1
		if("down")
			target_position = current_position + 1
		if("move")
			target_position = tgui_input_number(holder, "将「[selected.name]」移至第几项？", "技能排序", current_position, sortable_count, 1)
			if(isnull(target_position) || QDELETED(src) || QDELETED(ui) || ui.user != holder || ui_status(holder, ui_state(holder)) != UI_INTERACTIVE)
				return FALSE
			// 输入期间可能失去能力或调整顺序，按当前列表重新核对。
			if(QDELETED(selected) || selected.owner != holder)
				return FALSE
			sortable_count = holder.get_sortable_action_count()
			current_position = holder.actions?.Find(selected)
			if(!current_position || current_position > sortable_count)
				return FALSE
	if(!isnum(target_position) || target_position != round(target_position) || target_position < 1 || target_position > sortable_count)
		return FALSE
	if(target_position == current_position)
		return FALSE
	// 插入到目标位置，区间内其余能力保持相对顺序；数字快捷键读取此列表。
	holder.actions.Cut(current_position, current_position + 1)
	holder.actions.Insert(target_position, selected)
	for(var/index in min(current_position, target_position) to max(current_position, target_position))
		var/datum/action/ability = holder.actions[index]
		var/atom/movable/screen/movable/action_button/button = ability ? ability.viewers[holder.hud_used] : null
		if(QDELETED(ability) || QDELETED(button))
			continue
		button.moved = FALSE
		if(button.id && holder.client.prefs)
			holder.client.prefs.action_buttons_screen_locs["[button.name]_[button.id]"] = null
	holder.mind?.sync_spell_list_to_actions()
	holder.update_action_buttons(TRUE)
	return TRUE
