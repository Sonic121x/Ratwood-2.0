/proc/get_player_archive_display(value)
	var/static/list/display_names = list(
		"book" = "书籍",
		"books" = "书籍",
		"painting" = "画作",
		"paintings" = "画作",
		"Fiction" = "小说",
		"Non-fiction" = "纪实",
		"Religion" = "宗教",
		"Adult" = "成人",
		"Reference" = "参考",
		"Misc" = "其他",
		"Title" = "标题",
		"Author" = "作者",
		"Cover" = "封面",
		"Category" = "分类"
	)
	return display_names[value] || value

/proc/get_player_archive_options(list/values)
	var/list/options = list()
	var/list/label_counts = list()
	for(var/value in values)
		var/label = avoid_assoc_duplicate_keys(get_player_archive_display(value), label_counts)
		options[label] = value
	return options

/proc/input_player_book_category(mob/user)
	var/list/options = get_player_archive_options(GLOB.player_book_categories)
	var/choice = input(user, "选择这本书归入的分类", "书籍分类") as anything in options
	return options[choice]

/proc/input_player_book_amend_choice(mob/user, prompt, list/values)
	var/list/options = get_player_archive_options(values)
	var/choice = tgui_input_list(user, prompt, "修改书籍", options)
	return choice ? options[choice] : null

/proc/get_player_book_amend_value_display(field, value)
	if(field == "category")
		return get_player_archive_display(value)
	if(field == "icon")
		for(var/cover in GLOB.player_book_icons)
			if(GLOB.player_book_icons[cover] == value)
				return cover
	return value

/// Only the bundled example book carries this non-ckey signature.
/proc/get_player_archive_field_display(list/entry, field)
	var/value = entry[field]
	if(entry["author_ckey"] == "(test file)" && ("book_title" in entry))
		switch(field)
			if("book_title")
				if(value == "Unknown Title")
					return "未知标题"
			if("author")
				if(value == "Unknown Author")
					return "未知作者"
			if("author_ckey")
				return "示例文件"
			if("text")
				if(value == "\[moisture in the air or water leaks have rendered the carefully written caligraphy of this book unreadable\]")
					return "［书页受潮，原本工整的字迹已无法辨认。］"
	return value
