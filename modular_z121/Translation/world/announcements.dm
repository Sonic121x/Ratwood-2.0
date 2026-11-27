/proc/get_announcement_title_display(title)
	var/static/list/display_titles = list(
		"Nature's Union!" = "自然结合！"
	)
	return display_titles[title] || title
