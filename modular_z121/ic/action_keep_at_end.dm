// 新版 action 系统移除了 keep_at_end 字段。
// 为 guide_browser 等旧按钮保留兼容字段，并在 update_action_buttons 中排到按钮列表末尾。
/datum/action
	var/keep_at_end = FALSE
