/proc/get_gallery_label_display(value)
	var/static/list/labels = list("Headshot" = "头像", "headshot" = "头像", "extra" = "OOC 附件", "nsfw_extra" = "成人向 OOC 附件", "OOC Extra" = "OOC 附件", "NSFW OOC Extra" = "成人向 OOC 附件", "SFW Art" = "全年龄作品", "NSFW Art" = "成人向作品", "art_removed" = "全年龄作品移除", "nsfw_art_removed" = "成人向作品移除", "blocked_removed" = "隐藏链接移除", "clear_all" = "清空图片", "artwork_settings" = "作品设置")
	if(labels[value])
		return labels[value]
	var/base = gallery_slot_label(value)
	if(base && labels[base])
		return "[labels[base]] [copytext(value, length(GALLERY_ART_PREFIX(base == "NSFW Art")) + 2)]"
	return value

/proc/get_gallery_blocked_display(list/entries)
	var/list/result = list()
	for(var/list/entry as anything in entries)
		var/label = entry["label"]
		var/display = get_gallery_label_display(label)
		if(istext(label) && copytext(label, -10) == " alternate")
			var/base = copytext(label, 1, -10)
			var/translated = get_gallery_label_display(base)
			if(translated != base)
				display = "[translated]（备用）"
		result += list(list("label" = display, "url" = entry["url"]))
	return result
