/proc/get_update_map_display(value)
	var/static/list/labels = list(
		"Inn Backdoor" = "旅店后门", "Seneschal's Quarters" = "总管住所", "Seneschal's Chambers" = "总管寝室", "Slave Auctions" = "奴隶拍卖场", "sergeant's bedroom" = "军士卧室", "sergeant's office" = "军士办公室", "reinforced roofing" = "加固屋顶", "reinforced window" = "加固窗户",
		"Nook Bunks" = "林官居铺位", "Nook" = "林官居", "Room II" = "二号房", "Room 1" = "一号房", "Academy Entrance" = "学院入口", "alchemycal spill" = "炼金液体洒漏", "Backdoor" = "后门", "Bakery Key" = "面包房钥匙", "bakery" = "面包房", "exit" = "出口", "Food Shop Peddler Key" = "食铺货郎钥匙",
		"locker 1" = "一号柜", "locker 2" = "二号柜", "locker 3" = "三号柜", "locker 4" = "四号柜", "locker 5" = "五号柜", "locker 6" = "六号柜", "Lowtown Bakery" = "下城区面包房", "Lowtown Inn Spare Room #1" = "下城区旅店备用房一", "Lowtown Inn Spare Room #2" = "下城区旅店备用房二", "Privy" = "厕所", "Revivification Supplies" = "复苏用品", "rogue den room III key" = "贼窝三号房钥匙", "Roof Access" = "屋顶入口", "Study" = "书房", "watch captain's office" = "巡卫队长办公室", "watch captain's quarters" = "巡卫队长住所", "Windmill Workshop" = "风车工坊",
		"Just looking at it makes you feel strangely warm inside." = "光是看着它，你心中就泛起一阵奇异的暖意。", "This old key opens the peddler for the local lowtown eatery." = "这把旧钥匙能打开本地下城区食铺的货郎售货机。", "This old key opens the peddler for the lowtown bakery." = "这把旧钥匙能打开下城区面包房的货郎售货机。",
		"above dining hall" = "餐厅上方", "archive noc shrine" = "档案室诺克神龛", "baron's stash" = "男爵藏物处", "basement escape" = "地下室逃生通道", "cell sewer escape" = "牢房下水道逃生口", "councillor's suite" = "议员套房", "hand's office" = "执政之手办公室", "heir suite access" = "继承人套房入口", "heir's rooms" = "继承人房间", "rear of pantry" = "储藏室后方", "retainer room escape tunnel" = "侍卫房间逃生隧道", "seneschal quarters" = "总管住所", "servant passage entrance" = "仆役通道入口", "study" = "书房", "summoning room north escape" = "召唤室北侧逃生口", "the warden's nook" = "守林官居所", "throneroom escape" = "王座厅逃生通道", "west kitchen escape" = "厨房西侧逃生口"
	)
	return labels[value] || value

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
