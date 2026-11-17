#include "ethos/compatibility.dm"
#include "../modular_z121/species/species_display.dm"
#include "jobs/translation_display.dm"
#include "sound_translation_display.dm"
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

/proc/get_preferences_label_display(value)
	if(!istext(value))
		return value
	var/static/list/labels = list(
		"Identity" = "身份", "Origin" = "出身", "Customization" = "个性定制", "Character Settings" = "角色设置", "Voice" = "声音", "Body" = "身体", "Flavor Text" = "角色描述",
		"Name" = "姓名", "Nickname" = "昵称", "Nickname Color" = "昵称颜色", "Pronouns" = "代词", "Age" = "年龄", "Race" = "种族", "Race Title" = "种族称谓", "Race Bonus" = "种族加成",
		"Body Type" = "体型", "Dominance" = "惯用手", "Family" = "家族", "Preferred Spouse" = "期望配偶", "Preferred Parent" = "期望父母", "Preferred Gender" = "期望性别", "Restrict Species" = "种族限制",
		"Faith" = "信仰", "Patron" = "守护神", "Language" = "语言", "Food Preferences" = "饮食偏好", "Loadout Menu" = "开局装备", "Presets" = "预设", "Statpack" = "属性组合", "Primary Virtue" = "首要美德", "Second Virtue" = "第二美德",
		"Change" = "更改", "None" = "无", "INVALID" = "无效", "Any Gender" = "不限性别", "Default" = "默认", "Select" = "选择", "Add Quirk" = "添加怪癖", "Add Vice" = "添加恶习",
		"\[Remove\]" = "\[移除\]", "\[Configure\]" = "\[配置\]", "\[Clear\]" = "\[清除\]",
		"Unrevivable" = "不可复活", "Combat Music" = "战斗音乐", "Map Preferences" = "地图偏好", "No Preference" = "无偏好", "Familiar Preferences" = "使魔偏好", "Gnoll Preferences" = "豺狼人偏好",
		"Voice Pack" = "语音包", "Voice Color" = "声音颜色", "Voice Pitch" = "音调", "Accent" = "口音", "Speech Mannerism" = "说话习惯", "Vocal Bark" = "发声效果", "<b>Preview Bark</b>" = "<b>试听发声</b>",
		"Vocal Bark Speed" = "发声速度", "Vocal Bark Pitch" = "发声音调", "Vocal Bark Variance" = "发声变化", "Vocal Bark Volume" = "发声音量",
		"Mutant Skintone" = "特殊肤色", "Sprite Scale" = "外观比例", "Mutant Color #1" = "特殊颜色一", "Mutant Color #2" = "特殊颜色二", "Mutant Color #3" = "特殊颜色三",
		"Taur Body Type" = "半人兽体型", "Taur Color" = "半人兽颜色", "Taur Markings" = "半人兽花纹", "Taur Tertiary" = "半人兽第三颜色", "Features" = "身体特征", "Markings" = "花纹", "Descriptors" = "体貌描述", "Update feature colors with change" = "更改时同步特征颜色",
		"NSFW Flavortext" = "成人外貌描述", "ERP Preferences" = "成人角色扮演偏好", "Headshot" = "头像", "Rumours & Noble Gossip" = "传闻与贵族秘闻", "Set Rumours" = "设置传闻", "Set Gossip" = "设置秘闻", "<i>Preview</i>" = "<i>预览</i>",
		"Song" = "歌曲", "Change URL" = "更改链接", "Title" = "标题", "Artist" = "艺术家", "OOC Extra" = "场外附加信息", "NSFW OOC Extra" = "成人场外附加信息", "Image Gallery" = "图片集", "Nsfw Image Gallery" = "成人图片集", "Add" = "添加", "Clear Gallery" = "清空图片集", "Clear Nsfw Gallery" = "清空成人图片集", "<b>Preview Examine</b>" = "<b>预览打量信息</b>"
	)
	return labels[value] || get_character_identity_display(value)

/proc/get_character_identity_display(value)
	if(!istext(value))
		return value
	var/static/list/labels = list(
		AGE_ADULT = "壮年", AGE_MIDDLEAGED = "中年", AGE_OLD = "老年", AGE_IMMORTAL = "永生",
		HE_HIM = "他", SHE_HER = "她", THEY_THEM = "TA（男装）", THEY_THEM_F = "TA（女装）", IT_ITS = "它", HE_HIM_F = "他（女装）", SHE_HER_M = "她（男装）",
		VOICE_TYPE_MASC = "男声", VOICE_TYPE_FEM = "女声", VOICE_TYPE_ANDR = "中性声音"
	)
	return labels[value] || value

/proc/input_character_identity_choice(mob/user, prompt, title, list/values)
	var/list/options = list()
	for(var/value in values)
		var/label = get_character_identity_display(value)
		if(label in options)
			label = "[label] ([value])"
		options[label] = value
	var/choice = tgui_input_list(user, prompt, title, options)
	return isnull(choice) ? null : options[choice]

/proc/get_update_choice_display(value)
	if(value == "Arbalest")
		return "重弩手"
	if(value == "Fusilier")
		return "燧枪手"
	var/static/list/labels = list("None" = "无", "Gross" = "难闻", "Neutral" = "中性", "Pleasant" = "怡人", "Describe scent" = "自定义气味", "Use default" = "使用默认气味", "Elvish Saber" = "精灵军刀", "Elvish Dagger" = "精灵匕首", "Holy See" = "格伦泽尔霍夫特教廷", "Orthodoxy" = "奥塔瓦正教会", "Misdeed" = "轻罪")
	return labels[value] || value

/proc/get_update_map_display(value)
	var/static/list/labels = list(
		"Inn Backdoor" = "旅店后门", "Seneschal's Quarters" = "总管住所", "Seneschal's Chambers" = "总管寝室", "Slave Auctions" = "奴隶拍卖场", "sergeant's bedroom" = "军士卧室", "sergeant's office" = "军士办公室", "reinforced roofing" = "加固屋顶", "reinforced window" = "加固窗户",
		"Nook Bunks" = "林官居铺位", "Nook" = "林官居", "Room II" = "二号房", "Room 1" = "一号房", "Academy Entrance" = "学院入口", "alchemycal spill" = "炼金液体洒漏", "Backdoor" = "后门", "Bakery Key" = "面包房钥匙", "bakery" = "面包房", "exit" = "出口", "Food Shop Peddler Key" = "食铺货郎钥匙",
		"locker 1" = "一号柜", "locker 2" = "二号柜", "locker 3" = "三号柜", "locker 4" = "四号柜", "locker 5" = "五号柜", "locker 6" = "六号柜", "Lowtown Bakery" = "下城区面包房", "Lowtown Inn Spare Room #1" = "下城区旅店备用房一", "Lowtown Inn Spare Room #2" = "下城区旅店备用房二", "Privy" = "厕所", "Revivification Supplies" = "复苏用品", "rogue den room III key" = "贼窝三号房钥匙", "Roof Access" = "屋顶入口", "Study" = "书房", "watch captain's office" = "巡卫队长办公室", "watch captain's quarters" = "巡卫队长住所", "Windmill Workshop" = "风车工坊",
		"Just looking at it makes you feel strangely warm inside." = "光是看着它，你心中就泛起一阵奇异的暖意。", "This old key opens the peddler for the local lowtown eatery." = "这把旧钥匙能打开本地下城区食铺的货郎售货机。", "This old key opens the peddler for the lowtown bakery." = "这把旧钥匙能打开下城区面包房的货郎售货机。",
		"above dining hall" = "餐厅上方", "archive noc shrine" = "档案室诺克神龛", "baron's stash" = "男爵藏物处", "basement escape" = "地下室逃生通道", "cell sewer escape" = "牢房下水道逃生口", "councillor's suite" = "议员套房", "hand's office" = "执政之手办公室", "heir suite access" = "继承人套房入口", "heir's rooms" = "继承人房间", "rear of pantry" = "储藏室后方", "retainer room escape tunnel" = "侍卫房间逃生隧道", "seneschal quarters" = "总管住所", "servant passage entrance" = "仆役通道入口", "study" = "书房", "summoning room north escape" = "召唤室北侧逃生口", "the warden's nook" = "守林官居所", "throneroom escape" = "王座厅逃生通道", "west kitchen escape" = "厨房西侧逃生口"
	)
	return labels[value] || value

/proc/input_translation_choice(mob/user, prompt, title, list/values)
	var/list/options = list()
	for(var/value in values)
		var/label = get_update_choice_display(value)
		if(label in options)
			label = "[label] ([value])"
		options[label] = value
	var/choice = tgui_input_list(user, prompt, title, options)
	return choice ? options[choice] : null

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
