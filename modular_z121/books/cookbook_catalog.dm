// 食典只装载预写正文；不读取游戏配方、食物、生物或试剂的类型初始值。
/datum/z121_cookbook_entry
	var/title
	var/category
	var/quality_text
	var/id
	var/search_text
	var/body_html

/datum/z121_cookbook_catalog
	var/list/entries = list()
	var/list/entries_by_section = list()
	var/list/sections = list("肉类料理", "海鲜", "蔬菜料理", "水果料理", "蛋类料理", "米饭料理", "三明治", "烘焙食品", "馅饼", "糕点", "蛋糕", "腌制与干制食品", "甜食", "组合料理", "炖菜", "非酒精饮品", "酒类", "生食介绍", "基础材料介绍")

/datum/z121_cookbook_catalog/New()
	. = ..()
	// 正文已按栏目、品质及名称排好顺序，目录和搜索文本随正文一同缓存。
	load_section_1()
	load_section_2()
	load_section_3()
	load_section_4()
	load_section_5()
	load_section_6()
	load_section_7()
	load_section_8()
	load_section_9()
	load_section_10()
	load_section_11()
	load_section_12()
	load_section_13()
	load_section_14()
	load_section_15()
	load_section_16()
	load_section_17()
	load_section_18()
	load_section_19()

/datum/z121_cookbook_catalog/proc/add_entry(title, category, quality_text, search_text, body_html)
	var/datum/z121_cookbook_entry/entry = new
	entry.title = html_encode(title)
	entry.category = category
	entry.quality_text = quality_text
	entry.search_text = search_text
	entry.body_html = body_html
	entry.id = "[length(entries) + 1]"
	entries.Add(entry)
	var/list/section_entries = entries_by_section[category]
	if(!section_entries)
		section_entries = list()
		entries_by_section[category] = section_entries
	section_entries.Add(entry)
