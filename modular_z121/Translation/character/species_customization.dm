/proc/get_species_customization_display_name(internal_name)
	var/static/list/display_names = list(
		"+1 STR" = "+1 [get_stat_display_name(STATKEY_STR)]", "+1 FOR" = "+1 [get_stat_display_name(STATKEY_LCK)]", "+1 INT" = "+1 [get_stat_display_name(STATKEY_INT)]", "+1 CON" = "+1 [get_stat_display_name(STATKEY_CON)]", "+1 WIL" = "+1 [get_stat_display_name(STATKEY_WIL)]", "+1 PER" = "+1 [get_stat_display_name(STATKEY_PER)]", "+1 SPD" = "+1 [get_stat_display_name(STATKEY_SPD)]",
		"a tangled lineage" = "错综复杂的血统", "bastardized" = "混杂血统", "disputed" = "存疑血统",
		"Abyss" = "深渊", "Abyssal" = "深渊之裔", "Ashen" = "灰烬", "Beach" = "沙滩", "Bone" = "骨白", "Ghost" = "幽魂",
		"Ochre" = "赭色", "Meadow" = "草甸", "Olive" = "橄榄色", "Green" = "绿色", "Moss" = "苔绿", "Taiga" = "针叶林",
		"Bronze" = "青铜", "Red" = "红色", "Frost" = "霜白", "Teal" = "青绿色", "Hadal" = "海渊", "Pale" = "苍白", "Palm" = "棕榈",
		"Brass" = "黄铜", "Iron" = "铁", "Steel" = "钢", "Toper" = "托珀石", "Coal" = "煤", "Cobalt" = "钴", "Granite" = "花岗岩",
		"Jade" = "玉石", "Amythortz" = "紫晶", "Silver" = "银", "Coral" = "珊瑚", "Gold" = "金", "Limestone" = "石灰岩", "Copper" = "铜",
		"Rust" = "铁锈", "Obsidian" = "黑曜石", "Lapis" = "青金石", "Basalt" = "玄武岩", "Platinum" = "铂", "Aurum" = "黄金",
		"Quicksilver" = "水银", "Malachite" = "孔雀石", "Brimstone" = "硫磺", "Ceragyrite" = "角银矿", "Tuscan Red" = "托斯卡纳红", "Smoky Quartz" = "烟水晶",
		"Grenzelhoft" = "格伦泽尔霍夫特", "Hammerhold" = "铁锤堡", "Avar" = "阿瓦尔", "Rockhill" = "岩丘", "Otava" = "奥塔瓦",
		"Etrusca" = "伊特鲁斯卡", "Gronn" = "格隆", "Giza" = "吉萨", "Shalvistine" = "沙尔维斯廷", "Lalvestine" = "拉尔维斯廷",
		"Naledi" = "纳莱迪", "Naledi South" = "南纳莱迪", "Kazengun" = "风郡", "Czwarteki" = "茨瓦尔特基", "Ebon" = "乌木",
		"West Zybantium (Vrdaqnan)" = "西齐班廷（弗尔达克南）", "East Zybantium (Nshkormh)" = "东齐班廷（恩什科尔姆）", "North Zybantium (Chorodiaki)" = "北齐班廷（乔罗迪亚基）",
		"Lalve Steppes" = "拉尔韦草原", "Naledi Coast" = "纳莱迪海岸",
		"Grenzel Woods" = "格伦泽尔林地", "Dandelion Creek" = "蒲公英溪", "Roseveil" = "玫瑰帷幕", "Azuregrove" = "蔚蓝林苑",
		"Arborshome" = "林木家园", "Almondvalle" = "杏仁谷", "Walnut Woods" = "胡桃林地", "Timberborn" = "林木之裔", "Lotus Coast" = "莲花海岸",
		"Etruscan Swamps" = "伊特鲁斯卡沼泽", "Shalvine Forests" = "沙尔文森林", "Lalvestine Thickets" = "拉尔维斯廷灌木林", "Naledi Coverts" = "纳莱迪密林", "Ebon Coverts" = "乌木密林",
		"Commorah" = "科莫拉", "Gloomhaven" = "幽暗港", "Darkpila" = "达克皮拉", "Sshanntynlan" = "斯尚廷兰", "Llurth Dreir" = "卢尔斯·德雷尔",
		"Tafravma" = "塔弗拉夫玛", "Yuethindrynn" = "尤辛德林", "Koredynn" = "科雷丁", "Aiseedrynn" = "艾西德林", "Grenduskra" = "格伦杜斯克拉",
		"Timber-Gronn" = "林木－格隆", "Giza-Vale" = "吉萨－谷地", "Walnut-Stine" = "胡桃－斯廷", "Etrustcan-Dandelion" = "伊特鲁斯卡－蒲公英",
		"Naledi-Born" = "纳莱迪后裔", "Naledi-Southerner" = "纳莱迪南方人", "Kaze-Lotus" = "风郡－莲花", "Grenzel-Vale" = "格伦泽尔－谷地",
		"Etrusca-Lirvas" = "伊特鲁斯卡－利尔瓦斯", "Free Roamers" = "自由漫游者", "Avar Borne" = "阿瓦尔后裔", "Shalvine Roamer" = "沙尔文漫游者",
		"Lalve-Steppes" = "拉尔韦－草原", "Naledi-Otava" = "纳莱迪－奥塔瓦", "Grezel-Avar" = "格伦泽尔－阿瓦尔", "Hammer-Gronn" = "铁锤堡－格隆",
		"Commorah-kin" = "科莫拉裔", "Gloomhaven-kin" = "幽暗港裔", "Darkpila-kin" = "达克皮拉裔", "Sshanntynlan-kin" = "斯尚廷兰裔", "Llurth Dreir-kin" = "卢尔斯·德雷尔裔",
		"Tafravma-kin" = "塔弗拉夫玛裔", "Yuethindrynn-kin" = "尤辛德林裔", "Koredynn-kin" = "科雷丁裔", "Aiseedrynn-kin" = "艾西德林裔", "Grenduskra-kin" = "格伦杜斯克拉裔",
		"Shellcrest" = "甲冠", "Bloodaxe" = "血斧", "Splitjaw" = "裂颚", "Blackhammer" = "黑锤", "Skullseeker" = "寻颅者", "Crescent Fang" = "弦月獠牙",
		"Murkwalker" = "幽沼行者", "Shatterhorn" = "碎角", "Spirit Crusher" = "碎魂者", "Underdweller" = "地底居民", "Underdark" = "幽暗地域",
		"Jehoel" = "耶霍埃尔", "Urvix" = "乌尔维克斯", "Sarvyra" = "萨维拉", "Vheslyn" = "维斯林", "Arlenneth" = "阿伦尼斯", "Nessyss" = "内西斯",
		"Helixia" = "赫利克西亚", "Nymsea" = "宁西亚", "Vodyanev" = "沃迪亚涅夫", "Calvus" = "卡尔乌斯", "Voibion" = "沃伊比翁", "Chyerno" = "切尔诺",
		"Drema" = "德雷玛", "Chir" = "奇尔", "Vesyl" = "维希尔", "Krosec" = "克罗塞克", "Asza" = "阿莎", "Krizzsha" = "克里兹莎",
		"Tosiz" = "托西兹", "Velothel" = "维洛瑟尔", "Ashol" = "阿索尔", "Pyris" = "皮里斯",
		"Archon" = "神使", "Deva" = "天使", "Planetar" = "行星天使", "Solar" = "炽天使", "Empyrea" = "至高天", "Cultor" = "耕耘者",
		"Spiritus" = "圣灵", "Gaeia" = "盖娅", "Celestial" = "天界", "Olympia" = "奥林匹亚", "Necral" = "冥界", "Dendorite Construct" = "登多尔构装体", "Pestran Construct" = "佩斯特拉构装体", "astratan crown Crest" = "阿斯特拉塔王冠饰纹",
		"Vakran" = "瓦克兰", "Lanarain" = "拉纳莱恩", "Frostfell" = "霜原", "Varghelm" = "瓦格海姆", "Dawnbreak" = "破晓", "Bloodmoon" = "血月",
		"Felsaad" = "费尔萨德", "Hizmut" = "希兹穆特", "Langqan" = "朗钦", "Hun'sek" = "洪塞克",
		"Orange" = "橙色", "Light grey" = "浅灰色", "Dark grey" = "深灰色", "Light orange" = "浅橙色", "Light brown" = "浅棕色", "White brown" = "棕白色", "Dark brown" = "深棕色", "Black" = "黑色",
		"Porcelain" = "瓷白", "Walnut" = "胡桃色", "Sienna" = "赭棕", "Gloom" = "幽暗", "Lotus" = "莲花", "Scarlet" = "猩红", "Scarlet Reach" = "猩红边境",
		"Minotaur" = "牛头人", "Volf" = "沃尔夫狼", "Maneater" = "食人者", "Mud" = "泥土",
		"skin1" = "肤色一", "skin2" = "肤色二", "skin3" = "肤色三",
		"black - cave" = "黑色－洞窟", "black - midnight" = "黑色－午夜", "black - nightsky" = "黑色－夜空", "black - oil" = "黑色－油墨", "black - rogue" = "黑色－游侠",
		"blond - dirty" = "金色－暗金", "blond - drywheat" = "金色－干麦", "blond - pale" = "金色－浅金", "blond - strawberry" = "金色－草莓金", "blonde - moonlight" = "金色－月光",
		"brown - grain" = "棕色－谷物", "brown - mud" = "棕色－泥浆", "brown - oats" = "棕色－燕麦", "brown - soil" = "棕色－土壤", "brown - treebark" = "棕色－树皮",
		"green - grass" = "绿色－青草", "green - leaf" = "绿色－树叶", "green - moss" = "绿色－苔藓", "green - swamp" = "绿色－沼泽",
		"red - autumn" = "红色－秋叶", "red - berry" = "红色－浆果", "red - blood" = "红色－鲜血", "red - flame" = "红色－火焰", "red - sunset" = "红色－夕阳", "red - wine" = "红色－葡萄酒",
		"white - alabaster" = "白色－雪花石", "white - cavedew" = "白色－洞窟露珠", "white - ice" = "白色－寒冰", "white - silver" = "白色－银白", "white - skies" = "白色－天空", "white - snow" = "白色－雪白", "white - spiderweb" = "白色－蛛网", "yellow - sunlight" = "黄色－阳光"
	)
	var/swatch_start = findtext(internal_name, " <span")
	if(swatch_start)
		return "[get_species_customization_display_name(copytext(internal_name, 1, swatch_start))][copytext(internal_name, swatch_start)]"
	return display_names[internal_name] || internal_name

/proc/get_species_display_options(list/options)
	var/list/display_options = list()
	for(var/internal_name in options)
		var/display_name = get_species_customization_display_name(internal_name)
		if(display_name in display_options)
			display_name = "[display_name] ([internal_name])"
		display_options[display_name] = options[internal_name]
	return display_options
