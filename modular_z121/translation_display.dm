#include "ethos/compatibility.dm"
#include "../modular_z121/species/species_display.dm"
#include "jobs/translation_display.dm"
/proc/get_mannerism_display_name(mannerism)
	var/static/list/display_names = list(
		"No mannerism" = "无特殊措辞习惯",
		"Nervous Stutter" = "紧张口吃",
		"Stutter" = "口吃",
		"Heavy Stutter" = "严重口吃",
		"Lisp" = "咬字不清",
		"Hesitant" = "吞吞吐吐",
		"Complex Stutter" = "复合口吃"
	)
	return display_names[mannerism] || mannerism

/proc/input_mannerism_display(mob/user, list/mannerisms)
	var/list/choices = list()
	for(var/mannerism in mannerisms)
		var/label = get_mannerism_display_name(mannerism)
		if(label in choices)
			label = "[label] ([mannerism])"
		choices[label] = mannerism
	var/selected = tgui_input_list(user, "选择你角色的说话习惯：", "角色偏好", choices)
	return selected ? choices[selected] : null

/proc/get_hoard_category_display(category)
	var/static/list/display_names = list(
		"Supplies" = "补给品",
		"Medicaments" = "医疗用品",
		"Clothing" = "衣物",
		"Brigand" = "悍匪",
		"Sellsword" = "佣兵剑客",
		"Sawbones" = "锯骨郎中",
		"Knight" = "落魄骑士",
		"Hedge Knight" = "落魄骑士",
		"Mage" = "野法师",
		"Hedge Mage" = "野法师",
		"Knave" = "无赖",
		"Iconoclast" = "破像者",
		"Pioneer" = "拓荒工兵"
	)
	return display_names[category] || category

/// Attribute keys stay identical to upstream; translate only at display boundaries.
/proc/get_stat_display_name(stat_key)
	var/static/list/display_names = list(
		STATKEY_STR = "力量",
		STATKEY_PER = "感知",
		STATKEY_INT = "智力",
		STATKEY_CON = "体质",
		STATKEY_WIL = "意志",
		STATKEY_SPD = "速度",
		STATKEY_LCK = "幸运"
	)
	return display_names[stat_key] || stat_key

/// Native input returns a label; callers must resolve it through this list before applying stats.
/proc/get_stat_display_options(list/stat_keys)
	var/list/options = list()
	for(var/stat_key in stat_keys)
		options[get_stat_display_name(stat_key)] = stat_key
	return options

// Reagents are identified by type paths. Only their player-facing names are translated.
/datum/reagent/buff/New()
	. = ..()
	name = get_stat_display_name(name)

/atom/movable/screen/alert/status_effect/buff/alch/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	name = get_stat_display_name(name)

/// Keep the native menu's labels separate from the value returned to gameplay code.
/proc/input_stat_choice(mob/user, message, title, list/stat_keys)
	var/list/options = get_stat_display_options(stat_keys)
	var/choice = input(user, message, title) as anything in options
	return options[choice]

/proc/get_direction_display(direction)
	var/static/list/display_names = list(
		"north" = "北方",
		"south" = "南方",
		"east" = "东方",
		"west" = "西方",
		"northeast" = "东北方",
		"southeast" = "东南方",
		"northwest" = "西北方",
		"southwest" = "西南方"
	)
	var/direction_name = dir2text(direction)
	return display_names[direction_name] || direction_name

/// Bounty labels may be translated without changing the upstream switch values.
/proc/input_wretch_bounty_severity(mob/user)
	var/list/options = list(
		"轻罪" = "Misdeed",
		"伤人害命（+1 [get_stat_display_name(STATKEY_LCK)]）" = "Harm towards lyfe (+1 FOR)",
		"骇人暴行（全属性+1）" = "Horrific atrocities (+1 ALL STATS)"
	)
	var/choice = input(user, "你的罪行有多严重？", "悬赏金额") as anything in options
	return options[choice]

/// Older character saves used translated attribute values; normalize only at the load boundary.
/proc/migrate_legacy_stat_key(stat_key)
	if(!istext(stat_key))
		return stat_key
	var/static/list/legacy_keys = get_stat_display_options(MOBSTATS)
	return legacy_keys[stat_key] || stat_key

/proc/get_announcement_title_display(title)
	var/static/list/display_titles = list(
		"Nature's Union!" = "自然结合！"
	)
	return display_titles[title] || title

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
		"Misc" = "其他"
	)
	return display_names[value] || value

/proc/input_player_book_category(mob/user)
	var/list/options = list()
	for(var/category in GLOB.player_book_categories)
		options[get_player_archive_display(category)] = category
	var/choice = input(user, "选择这本书归入的分类", "书籍分类") as anything in options
	return options[choice]

/proc/get_chess_result_display(value)
	var/static/list/names = list("Checkmate. 白方 wins." = "将死，白方获胜。", "Checkmate. 黑方 wins." = "将死，黑方获胜。")
	return names[value] || value

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

/proc/get_ancestral_blood_display(value)
	var/static/list/names = list("Rontz" = "隆兹石", "Saffira" = "蓝晶", "Gemerald" = "翠晶", "Toper" = "托珀石", "Amythortz" = "阿米索兹石")
	return names[value] || value

/proc/input_weapon_vow_display(mob/user, list/values)
	var/static/list/names = list("I still use weapons" = "我仍使用武器", "I forgo weapons" = "我放弃使用武器")
	var/list/options = list()
	for(var/value in values)
		options[names[value] || value] = value
	var/choice = input(user, "你是否已经放弃使用武器？", "你的决心有多坚定？") as anything in options
	return options[choice]
