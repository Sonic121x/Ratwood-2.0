/proc/get_sound_setting_display(value)
	if(!istext(value))
		return value
	var/static/list/labels = list(
		"fire" = "火焰", "misc" = "杂项", "rot" = "腐烂", "clock" = "时钟", "water" = "水声", "river" = "河流", "torch" = "火炬",
		"Live" = "实时", "Off" = "关闭", "On" = "开启", "Fallback loops" = "备用循环音", "unknown" = "未知", "on" = "开启", "off" = "关闭",
		"mode" = "模式", "move interval" = "移动更新间隔", "running override" = "奔跑专用间隔", "steps" = "步数", "speed cutoff" = "超速静音", "services per tick" = "每刻处理数", "queue" = "队列", "standing skip" = "静止检查跳过时限", "falloff hardness" = "衰减强度", "pan depth floor" = "声像最小深度", "door re-check" = "门状态复查",
		"Reset" = "重置", "Cancel" = "取消", "Start" = "开始", "Keep" = "保留", "Restart" = "重新开始", "Clear" = "清除",
		"config silencing" = "配置静音", "lights out" = "灯火熄灭"
	)
	return labels[value] || value

/client/proc/input_sound_display(message, title, list/values, current)
	var/list/options = list()
	for(var/value in values)
		var/label = get_sound_setting_display(value)
		if(label in options)
			label = "[label] ([value])"
		options[label] = value
	var/choice = input(src, message, title, get_sound_setting_display(current)) as null|anything in options
	return isnull(choice) ? null : options[choice]

/client/proc/alert_sound_display(message, title, first, second, third)
	var/list/options = list()
	for(var/value in list(first, second, third))
		if(!isnull(value))
			options[get_sound_setting_display(value)] = value
	var/choice = alert(src, message, title, get_sound_setting_display(first), get_sound_setting_display(second), get_sound_setting_display(third))
	return options[choice]
