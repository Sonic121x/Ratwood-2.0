//Each lists stores ckeys for "Never for this round" option category

#define POLL_IGNORE_SENTIENCE_POTION 		"sentience_potion"
#define POLL_IGNORE_POSSESSED_BLADE 		"possessed_blade"
#define POLL_IGNORE_SYNDICATE 				"syndicate"
#define POLL_IGNORE_HOLOPARASITE 			"holoparasite"
#define POLL_IGNORE_POSIBRAIN 				"posibrain"
#define POLL_IGNORE_SPECTRAL_BLADE 			"spectral_blade"
#define POLL_IGNORE_CONSTRUCT 				"construct"
#define POLL_IGNORE_SPIDER 					"spider"
#define POLL_IGNORE_ASHWALKER 				"ashwalker"
#define POLL_IGNORE_GOLEM 					"golem"
#define POLL_IGNORE_SWARMER 				"swarmer"
#define POLL_IGNORE_DRONE 					"drone"
#define POLL_IGNORE_FUGITIVE 				"fugitive"
#define POLL_IGNORE_DEFECTIVECLONE 			"defective_clone"
#define POLL_IGNORE_PYROSLIME 				"slime"
#define POLL_IGNORE_SHADE 					"shade"
#define POLL_IGNORE_IMAGINARYFRIEND 		"imaginary_friend"
#define POLL_IGNORE_SPLITPERSONALITY 		"split_personality"
#define POLL_IGNORE_CONTRACTOR_SUPPORT 		"contractor_support"
#define POLL_IGNORE_ACADEMY_WIZARD			"academy_wizard"
#define POLL_IGNORE_NECROMANCER_SKELETON	"necromancer_skeleton"
#define POLL_IGNORE_LICH_SKELETON			"lich_skeleton"
#define POLL_IGNORE_MAGE_SUMMON             "mage_summon"
#define POLL_IGNORE_DEATHKNIGHT_TARGET      "deathknight_target"
#define POLL_IGNORE_DEATHKNIGHT             "deathknight"
#define POLL_IGNORE_VL_SERVANT              "vl_servant"
#define POLL_IGNORE_NOTORIOUS_BOUNTY			"notorious_bounty"

GLOBAL_LIST_INIT(poll_ignore_desc, list(
	POLL_IGNORE_SENTIENCE_POTION = "启智药水",
	POLL_IGNORE_POSSESSED_BLADE = "附魂之刃",
	POLL_IGNORE_SYNDICATE = "辛迪加",
	POLL_IGNORE_HOLOPARASITE = "全息寄生体",
	POLL_IGNORE_POSIBRAIN = "正电子脑",
	POLL_IGNORE_SPECTRAL_BLADE = "幽魂之刃",
	POLL_IGNORE_CONSTRUCT = "构装体",
	POLL_IGNORE_SPIDER = "蜘蛛",
	POLL_IGNORE_ASHWALKER = "灰烬行者卵",
	POLL_IGNORE_GOLEM = "魔像",
	POLL_IGNORE_SWARMER = "蜂群机器外壳",
	POLL_IGNORE_DRONE = "无人机外壳",
	POLL_IGNORE_FUGITIVE = "逃犯猎手",
	POLL_IGNORE_DEFECTIVECLONE = "缺陷克隆体",
	POLL_IGNORE_PYROSLIME = "史莱姆",
	POLL_IGNORE_SHADE = "幽影",
	POLL_IGNORE_IMAGINARYFRIEND = "幻想朋友",
	POLL_IGNORE_SPLITPERSONALITY = "分裂人格",
	POLL_IGNORE_CONTRACTOR_SUPPORT = "承包商支援单位",
	POLL_IGNORE_ACADEMY_WIZARD = "学院巫师守卫",
	POLL_IGNORE_NECROMANCER_SKELETON = "死灵法师骷髅",
	POLL_IGNORE_MAGE_SUMMON = "法师召唤物",
	POLL_IGNORE_VL_SERVANT = "吸血鬼召唤物",
	POLL_IGNORE_NOTORIOUS_BOUNTY = "恶名悬赏目标"
))
GLOBAL_LIST_INIT(poll_ignore, init_poll_ignore())


/proc/init_poll_ignore()
	. = list()
	for (var/k in GLOB.poll_ignore_desc)
		.[k] = list()
