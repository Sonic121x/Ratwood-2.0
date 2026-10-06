/mob
	var/tgui_multiline = TRUE

/mob/verb/toggle_tgui_multiline()
	set name = "切换 TGUI 多行输入"
	set category = "Options"
	set hidden = 1

	tgui_multiline = !tgui_multiline
	to_chat(src,span_notice("TGUI 多行输入现已[tgui_multiline ? "启用" : "禁用"]。"))
