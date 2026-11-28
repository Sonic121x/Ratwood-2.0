/proc/input_updated_loadout_display(mob/user, list/values, prompt)
	var/static/list/names = list(
		"Light Armor" = "轻甲", "Medium Armor" = "中甲",
		"white" = "白色", "blue" = "蓝色", "black" = "黑色", "red" = "红色", "beige" = "米色", "green" = "绿色",
		"Kriegmesser & Buckler" = "战刀与小圆盾", "Falchion & Kite Shield" = "弯刃刀与鸢盾", "Sword & Crossbow" = "剑与十字弩",
		"Pigface Bascinet" = "猪面盆盔", "Guard Helmet" = "卫兵头盔", "Barred Helmet" = "栅栏头盔", "Bucket Helmet" = "桶盔",
		"Knight Helmet" = "骑士头盔", "Visored Sallet" = "带面罩萨勒盔", "Snouted Visored Sallet" = "带吻部面罩萨雷特盔",
		"Armet" = "阿米特盔", "Snouted Armet" = "带吻部阿米特盔", "Knight's Armet" = "骑士头盔（阿米特式）", "Hounskull Bascinet" = "犬首盆盔",
		"Klappvisier Bascinet" = "伊特鲁斯卡盆盔", "Slitted Kettle" = "开缝锅盔", "Volfskulle Bascinet" = "沃尔夫面甲头盔",
		"Roundface Bascinet" = "圆面盆盔", "Snouted Roundface Bascinet" = "带吻部圆面盆盔", "None" = "无",
		"Decorated Bucket Helmet" = "华饰桶盔", "Old Astratan Helm" = "古旧阿斯特拉塔头盔", "Astratan Plumed Helm" = "阿斯特拉塔羽饰头盔",
		"Old Necran Helm" = "古旧奈克拉头盔", "Old Eoran Sallet" = "古旧伊欧拉萨莱特盔", "Noc Helm" = "诺克头盔", "Ravox Helmet" = "拉沃克斯头盔",
		"Tabard" = "罩袍", "Cloak" = "披风", "brown" = "棕色", "halo" = "环冠式", "knighty" = "骑士式",
		"Blue Tabard" = "蓝色罩袍", "Pink Tabard" = "粉色罩袍",
		"Blue Cloak" = "蓝色披风", "Red Cloak" = "红色披风",
		"Blue Furcloak" = "蓝色毛皮披风", "Red Furcloak" = "红色毛皮披风",
		"Blue Short Cloak" = "蓝色短披风", "Red Short Cloak" = "红色短披风",
		"Blue Short Furcloak" = "蓝色毛皮短披风", "Red Short Furcloak" = "红色毛皮短披风"
	)
	var/list/options = list()
	for(var/value in values)
		options[names[value] || value] = value
	var/choice = input(user, prompt, "选择装备") as anything in options
	return options[choice]

/proc/select_stashed_item(mob/user, list/items)
	if(items["Spectacles"] != /obj/item/clothing/mask/rogue/spectacles || user.client?.prefs?.resolve_loadout_to_name(items["Spectacles"]) == "Spectacles")
		return input(user, "我要取出什么？", "储藏") as null|anything in items
	var/list/options = list()
	for(var/key in items)
		var/label = key
		if(key == "Spectacles")
			label = "眼镜"
			while((label in items) || (label in options))
				label = "[label]（[key]）"
		options[label] = key
	var/choice = input(user, "我要取出什么？", "储藏") as null|anything in options
	return choice ? options[choice] : null
