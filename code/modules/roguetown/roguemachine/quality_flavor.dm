/proc/quality_delta_flavor(quality)
	if(quality < ITEM_QUALITY_STANDARD)
		return pick(
			"你的货物比那位古代纳莱迪商人还要粗劣。",
			"大人，我得雇三个铁匠才能重做那个。",
			"我都想为你写一块投诉泥板了。",
			"你竟以为这台机器里没有试金石，真是大胆。",
			"你货物的品质足以颠覆王国。",
		)
	if(quality > ITEM_QUALITY_STANDARD)
		return pick(
			"干得漂亮，大人！",
			"这是我在本地区见过的最上等的货物！",
			"啊！配得上国王的精品！",
			"我已划验过货物，确认其品质上乘。",
			"再来！",
		)
	return null

/proc/navigator_quality_jab(quality)
	if(quality < ITEM_QUALITY_STANDARD)
		return pick(
			"这甚至不值得为此升起气球。",
			"这玷污了公司的荣誉。",
			"这等货物有辱玛勒姆的尊严。",
			"这甚至不值它的重量。",
			"管事！这是什么！",
		)
	if(quality > ITEM_QUALITY_STANDARD)
		return pick(
			"美人鱼都为这批货物跃出水面！",
			"想必普赛顿也会归来，一睹你这批货物的品质。",
			"船长非常满意。",
			"值得跨越半个世界而来。",
			"公司赞赏你的努力。",
		)
	return null
