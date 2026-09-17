/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/rockhill
	map_file_name = "rockhill.dmm"
	realm_name = "岩丘"
	blacklist = list(//I had wanted the map variable in the roles themselves to bar them from non-desert maps but it still shows up in the Latejoin menu so I'm doing this just to keep it clear)
		/datum/job/roguetown/cataphract,
		// /datum/job/roguetown/vizier,
		/datum/job/roguetown/headslave,
		// /datum/job/roguetown/sheikh,
		/datum/job/roguetown/janissary,
		/datum/job/roguetown/janissarysergeant,
		/datum/job/roguetown/azeb,
		/datum/job/roguetown/azebagha,
		/datum/job/roguetown/slavemaster,
		/datum/job/roguetown/slave,
		/datum/job/roguetown/dtchaplain,
		
		/datum/job/roguetown/tribalchieftain,
		/datum/job/roguetown/tribalshaman,
		/datum/job/roguetown/tribalguard,
		/datum/job/roguetown/tribalrabble,
		/datum/job/roguetown/tribalvillager,
		)
	slot_adjust = list(
		/datum/job/roguetown/manorguard = 4,//split with watchmen
		/datum/job/roguetown/warden = 4,//split with vanguard
		/datum/job/roguetown/adventurer/courtslave = 2,
	)
	title_adjust = list(
		/datum/job/roguetown/lord = list(display_title = "公爵", f_title = "公爵夫人"),
		/datum/job/roguetown/physician = list(display_title = "宫廷医师"),
		/datum/job/roguetown/niteman = list(display_title = "夜主", f_title = "夜主"),
		/datum/job/roguetown/nightmaiden = list(display_title = "夜侍", f_title = "夜侍女"),
		// /datum/job/roguetown/marshal = list(display_title = "Mayor"),
	)
	tutorial_adjust = list(
		/datum/job/roguetown/captain = "你出身贵族，在你之前已有数代强壮而忠诚的骑士与战士。 \
				你曾以陛下骑士的身份恪尽职守，如今你已成长为许多人只能梦想企及的职位。 \
				作为骑士中的老兵，你率领王权的骑士与忠诚的战士奔赴战场，并组织训练侍从。只服从执法官与王权。 \
				带领你的人走向胜利——并让他们守规矩——你将看到这片国度在千轮烈日下繁荣昌盛。",
		/datum/job/roguetown/physician = "你是一位医术大师，受公爵本人信任，为王室、宫廷、其护卫及其子民提供专业照护。 \
			虽然你主要居住在城堡中庄园的医疗翼，你也能使用本地高镇的诊所， \
			那里持有次级执照的药剂师在你的偶尔路过指点下行医。",
		// /datum/job/roguetown/archivist = "CHANGE THIS!! - Teach people skills, whether DIRECTLY or by writing SKILLBOOKS. You and the Veteran next door teach people shit."
		/datum/job/roguetown/warden = "你在先锋中历经数年的侦察、遭遇战与求生考验，证明了自己，因而被接纳为守林人——一个监视未驯荒野的精英游侠团体。你被信任深入低镇以南的蛮荒黑暗，担任斥候、士兵、哨卫与向导，执行远程侦察、清除危险野兽，并与先锋一同保护低镇。你从属于守林总长，而总长则效命于男爵，并可能应执法官与王权之召作为驻军的一员出战。以男爵的意志为令，作为抵御文明边界之外威胁的第一道防线，保障道路安全，守住先锋堡垒。王权正指望你。",
		/datum/job/roguetown/manorguard = "你已证明了自己的忠诚与能力，因而被托付守卫城堡，并在全城与公国中执行其意志。 \
				你定期接受战斗与攻城战的训练，应对来自内外的威胁。 \
				服从你的执法官、骑士队长与王权。向贵族与骑士表示敬意，这样你才能反过来赢得他们的敬意。不是以一个平民的身份，而是以一名士兵的身份..",
		/datum/job/roguetown/marshal = "你是王权在法律与军事事务上的代理人，确保法律由扈从推行、核验并施加于国度的公民身上。 \
				作为一切军事事务的最高权威，你的大部分工作都在案牍之后进行，在骑士队长、守望队长与守林总长之间分派职责， \
				并作为主要的中间人，确保公爵的意志经由你而在战场上得以执行。",
		/datum/job/roguetown/rookie = "打杂、递送消息、修补凹痕、与当地人交谈；城卫总是需要一双闲手、一双闲眼和一对闲耳。协助你的城卫同伴应对来自内外的威胁。 \
				你只接受过武器与守卫工作的简要入门，其余训练都要在工作中自行摸索。 \
				服从你的上级（除了你以外的所有人），向贵族表示敬意。多加留意，试着学上一两手，或许有朝一日你能活到成为一名合格的士兵。"
	
	)
	// species_adjust = list()
	// sexes_adjust = list()
	//Threat regions is used for displaying specific regions on notice boards
	threat_regions = list(
		THREAT_REGION_ROCKHILL_BASIN,
		THREAT_REGION_ROCKHILL_BOG_NORTH,
		THREAT_REGION_ROCKHILL_BOG_WEST,
		THREAT_REGION_ROCKHILL_BOG_SOUTH,
		THREAT_REGION_ROCKHILL_BOG_SUNKMIRE,
		THREAT_REGION_ROCKHILL_WOODS_NORTH,
		THREAT_REGION_ROCKHILL_WOODS_SOUTH
	)
	// The realm is Rockhill here, so the Rockhill trade county becomes Vespermill, its
	// noble seat. Same region_id and goods; only the identity changes.
	trade_region_swaps = list(
		TRADE_REGION_ROCKHILL = /datum/economic_region/vespermill,
	)
	// Towner postings: the caravan runs the wooded roads (highwaymen in the faction
	// tables), the miner's lead strikes the deep bogs. Both target regions carry hard
	// spawners and allow the towner types.
	towner_quest_regions = list(
		QUEST_TOWNER_SMITH_CARAVAN = list(THREAT_REGION_ROCKHILL_WOODS_NORTH, THREAT_REGION_ROCKHILL_WOODS_SOUTH),
		QUEST_TOWNER_MINER_OREVEIN = list(THREAT_REGION_ROCKHILL_BOG_SUNKMIRE, THREAT_REGION_ROCKHILL_BOG_WEST),
	)
	// Blockade routes. Tiers mirror dun_world's: grove-tier roads (no travel fee)
	// through the woods, coast-tier (75) through the outer bogs, mountain-tier (150)
	// through Sunkmire. Every target region carries hard quest spawners - a road
	// mapped to a region without one can never host its defense.
	blockade_route_map = list(
		TRADE_REGION_KINGSFIELD = THREAT_REGION_ROCKHILL_WOODS_SOUTH,
		TRADE_REGION_ROSAWOOD = THREAT_REGION_ROCKHILL_WOODS_NORTH,
		TRADE_REGION_BLACKHOLT = THREAT_REGION_ROCKHILL_WOODS_SOUTH,
		TRADE_REGION_HEARTFELT = THREAT_REGION_ROCKHILL_WOODS_NORTH,
		TRADE_REGION_ROCKHILL = THREAT_REGION_ROCKHILL_BOG_NORTH,
		TRADE_REGION_SALTWICK = THREAT_REGION_ROCKHILL_BOG_WEST,
		TRADE_REGION_BLEAKCOAST = THREAT_REGION_ROCKHILL_BOG_SOUTH,
		TRADE_REGION_NORTHFORT = THREAT_REGION_ROCKHILL_BOG_SUNKMIRE,
		TRADE_REGION_HAGENWALD = THREAT_REGION_ROCKHILL_BOG_SUNKMIRE,
		TRADE_REGION_DAFTSMARCH = THREAT_REGION_ROCKHILL_BOG_SUNKMIRE,
	)
d
