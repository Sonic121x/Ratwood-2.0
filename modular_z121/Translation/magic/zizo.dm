/proc/zizo_display(value)
	var/static/list/names = list(
		"LESSER" = "次级", "GREATER" = "高等", "PORTAL" = "通道", "STRAND" = "丝缕", "PITCH" = "漆黑", "TOIL" = "劳役", "BITE" = "噬咬", "ROT" = "腐朽", "NOISE" = "噪音", "BLOOD" = "鲜血",
		"OPEN GATE" = "开启界门", "DREAM JAUNT" = "梦游", "PASSAGE" = "通道", "CURSE OF RECALL" = "召回之咒",
		"MEND" = "修复术", "SUMMON YSIS" = "召唤愈合仪", "CURSE OF FULMENOR" = "富尔门诺之咒",
		"NECROMANCY" = "死灵术", "RESURRECTION" = "复生术", "CURSE OF THANATOPHOBIA" = "惧死之咒",
		"ROT INITIATE" = "腐朽入门", "BLIGHT" = "腐化大地", "CURSE OF BLACK ROT" = "黑腐之咒",
		"SPOOK" = "灵体出窍", "WITCHERY" = "黑猫附身", "CURSE OF BABEL" = "乱语之咒",
		"FIRE MONK" = "烈焰武僧", "SCADUFORM" = "阴影化身", "CURSE OF RADIANCE" = "灼光之咒",
		"SIGIL EXPERTISE" = "符印精通", "BLOOD SNARE" = "鲜血陷阱", "CURSE OF BLOOD" = "血契之咒",
		"CONVERT" = "招募信徒", "SACRIFICE" = "献祭", "HEARTACHES" = "心痛指引", "DIVINE GUIDANCE" = "神谕",
		"GUTTED FISH" = "剖腹取脏", "CURSE OF ZIZO" = "齐佐之咒", "CURSE OF TONGUES" = "缄舌之咒",
		"CURSE OF EXHAUSTION" = "力竭之咒", "CURSE OF KNOCK" = "拒门之咒", "CURSE OF MISFORTUNE" = "厄运之咒", "CURSE OF PROXY" = "替身之咒",
		"DARK SUN'S MARK" = "暗日印记", "ALL-SEEING EYE" = "全视之眼", "SUMMON AMULET OF ZIZO" = "召唤齐佐护符", "RAISE PROFANE SHRINE" = "竖立亵渎神龛",
		"CRIMINAL'S TOOL" = "灭迹之物", "REMNANT LEECH" = "残魂水蛭", "SILENCING LEECH" = "噤声水蛭", "INVADE MIND" = "侵入心智",
		"SUMMON CULT OUTFIT" = "召唤密教服饰", "SUMMON DARKSTEEL ARMOR" = "召唤黑钢甲", "SUMMON FUGE" = "召唤异界织机",
		"SUMMON PYLON" = "召唤汲魂塔", "SUMMON RAVER" = "召唤血肉嫁接器", "SUMMON WEAPONS" = "召唤武器", "LESSER NECROMANCY" = "次级死灵术",
		"INHUMEN WARD" = "异民护盾", "SALIENDO PEDES" = "腾跃之足", "FLESHMEND" = "血肉愈合", "GREATER FLESHMEND" = "高等血肉愈合",
		"DARKENED EYES" = "夜视之眼", "PAINLESS BATTLE" = "无痛战斗", "LESSER RITUOS" = "次级仪式术", "FLAWED IMMORTALITY" = "有缺的不朽", "ASCEND!" = "飞升！",
		"WALL" = "墙壁", "DOOR" = "门", "ILLUSORY WALL" = "幻墙", "REALITY REND" = "现实裂隙", "FUGE" = "异界织机")
	return names[uppertext(value)] || value

/proc/zizo_scent_display(list/info)
	var/static/list/distances = list("very close" = "近在咫尺", "nearby" = "就在附近", "far away" = "还在远处")
	var/static/list/heights = list(", somewhere above" = "，在上方某处", ", somewhere below" = "，在下方某处")
	return "[distances[info["proximity"]] || info["proximity"]][heights[info["z"]] || info["z"]]"

/proc/input_zizo_display(mob/user, prompt, list/values, title = "齐佐")
	var/list/options = list()
	for(var/value in values)
		var/label = zizo_display(value)
		if(label in options)
			label = "[label]（[value]）"
		options[label] = value
	var/choice = tgui_input_list(user, prompt, title, options)
	return choice ? options[choice] : null
