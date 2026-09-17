/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/deserttown
	map_file_name = "deserttown.dmm"
	realm_name = "阿尔-阿舒尔"
	slot_adjust = list(
		// /datum/job/roguetown/mercenary = 7, //haha fuck you one less slot!!
		// /datum/job/roguetown/apothecary = 1, //remodelled the building for more room
		/datum/job/roguetown/gnoll = 3,//hyenas just belong here!
		/datum/job/roguetown/slave = 8,
	)
	title_adjust = list(
		/datum/job/roguetown/lord = list(display_title = "苏丹", f_title = "苏丹娜"),
		/datum/job/roguetown/prince = list(display_title = "埃米尔", f_title = "阿米拉"),
		// /datum/job/roguetown/marshal = list(display_title = "Mayor"),
		/datum/job/roguetown/priest =  list(display_title = "大祭司", f_title = "大祭司"),
		/datum/job/roguetown/captain = list(display_title = "铁甲骑兵队长"),
		/datum/job/roguetown/physician = list(display_title = "宫廷医师"),
		/datum/job/roguetown/villager = list(display_title = "村民"),
		/datum/job/roguetown/magician = list(display_title = "宫廷法师"),
		/datum/job/roguetown/pilgrim = list(display_title = "游牧民"),
		/datum/job/roguetown/councillor = list(display_title = "谢赫"),
		/datum/job/roguetown/hand = list(display_title = "维齐尔"),
	)
	tutorial_adjust = list(
		// /datum/job/roguetown/marshal = "CHANGE THIS LATER. Manage the town outside of the palace. Hang out in the mayor building!!!",
		/datum/job/roguetown/marshal = "稍后修改。你受苏丹托付，成为最高军事权威。待在你那气派的房子里。充当各方武力支柱之间的主要中间人与协调者——铁甲骑兵队长（及其铁甲骑兵）、耶尼切里军士长（及其耶尼切里）与阿塞卜阿迦（及其阿塞卜）",
		/datum/job/roguetown/physician = "你是一位医术大师，受苏丹本人信任，为王室、宫廷、其护卫及其子民提供专业照护。 \
		虽然你主要居住在城堡中宫殿的医疗翼，你能使用集市中的本地诊所， \
		 那里持有次级执照的药剂师在你的偶尔路过指点下行医。",
		/datum/job/roguetown/magician = "你的信条是致力于征服奥术技艺，以及对知识永不停歇的渴求。 \
		你欠苏丹一条命，正是他的钱币让你得以在这黑暗的时代继续你的学业。 \
		作为回报，你一次又一次地以审判者与受信赖的顾问身份，证明了自己对其统治的价值。",
		/datum/job/roguetown/shophand = "你受商人恩典，在阿尔-阿舒尔最大的商铺里干活，他把你拴在这份苦差上。为雇主上货、盘点库存的工作枯燥而重复——但至少你头顶有片瓦，周遭也还算舒适。随着时间推移，或许有朝一日你能不再只是个被美化的仆役。",
		/datum/job/roguetown/councillor = "这个职位或许是你继承来的，或许是你花钱买来的，又或许是由王室亲自任命的； \
			无论来历如何，你如今担任维齐尔的助手、规划者与陪审员。 \
			你协助他监督税收、建设与新法律的筹划。 \
			你的主要职责是协助维齐尔处理其事务，只对他与苏丹负责。",
		/datum/job/roguetown/hand = "你是这片国度中最重要的人物之一。 \
			你长期担任贵族家族的密探头子与心腹，久到你本身已成了一座阴谋的宝库，而你以坚定的信念加以利用。\
			谁也别忘记你是在谁的耳边低语。死在你那两片嘴唇下的人，比任何剑术大师所能宣称的都要多。",
	)
	/// Jobs that this map won't use
	blacklist = list(
		// /datum/job/roguetown/adventurer//Adventurers (Could rename which are 'foreigners but who cares)'
		// /datum/job/roguetown/wretch,
		// /datum/job/roguetown/bandit,
		// /datum/job/roguetown/pilgrim, //I have Nomads in the dtvillager.dm //actually this makes sense as a non-zyb foreigner!
		// /datum/job/roguetown/trader,
		// /datum/job/roguetown/assassin,

		// /datum/job/roguetown/lord,// sultan//moved to an if-map-then-outfit
		/datum/job/roguetown/knight,// cataphract
		// /datum/job/roguetown/hand,// vizier
		// /datum/job/roguetown/suitor,
		// /datum/job/roguetown/steward, //gonna try merging this role with Vizier EDIT: with the higher pop we can afford to keep em separate now
		// /datum/job/roguetown/consort,
		// /datum/job/roguetown/captain,
		// /datum/job/roguetown/bailiff,

		//church. Fine as is

		/datum/job/roguetown/butler,// headslave
		// /datum/job/roguetown/councillor,// sheikh
		// /datum/job/roguetown/magician,// moved to an if-map-then-outfit statement in the baseblock
		/datum/job/roguetown/jester, //are jesters really a desert thing? Maybe ought to push people into playing slaves instead..?
		// /datum/job/roguetown/physician,
		/datum/job/roguetown/chaplain,//ought have a psydonite alternative

		/datum/job/roguetown/manorguard,//  mamaluk
		// /datum/job/roguetown/rookie,//  mamalukrookie!
		/datum/job/roguetown/guardsman,//  mamaluk
		/datum/job/roguetown/vanguard,//  jannissary
		/datum/job/roguetown/warden,//  jannissary
		/datum/job/roguetown/dungeoneer,// Slavemaster. Okay it's a bit different but it's nice to cut bloat y'know!
		/datum/job/roguetown/sergeant,//janissary sergeant
		// /datum/job/roguetown/squire,
		// /datum/job/roguetown/veteran,
		/datum/job/roguetown/watchcaptain,
		/datum/job/roguetown/wardenmaster,

		//trader (probably fine to keep as it is)

		/datum/job/roguetown/crier, //would be fun to integrate in with the arena? Reimplement when building is added
		// /datum/job/roguetown/archivist,
		// /datum/job/roguetown/barkeep,
		// /datum/job/roguetown/guildmaster,
		// /datum/job/roguetown/guildsman,
		// /datum/job/roguetown/merchant,
		// /datum/job/roguetown/niteman,
		// /datum/job/roguetown/tailor,
		// /datum/job/roguetown/elder,
		
		// /datum/job/roguetown/villager,
		// /datum/job/roguetown/farmer,
		// /datum/job/roguetown/prisonerb,
		// /datum/job/roguetown/prisonerr,
		// /datum/job/roguetown/hostage,
		// /datum/job/roguetown/nightmaiden, // Current ones are probably fine?
		// /datum/job/roguetown/cook,
		/datum/job/roguetown/knavewench, //maybe after expanding the tavern for it
		// /datum/job/roguetown/lunatic,


		//inquisition. Fine as is

		//mercenaries. Fine as is
		
		/datum/job/roguetown/servant,//slave
		// /datum/job/roguetown/apothecary,
		// /datum/job/roguetown/churchling,
		// /datum/job/roguetown/clerk, //gonna try merging this with Sheikh - EDIT with higher pop we can afford to keep this role around
		// /datum/job/roguetown/wapprentice,
		// /datum/job/roguetown/orphan,
		// /datum/job/roguetown/prince,//dtprince
		// /datum/job/roguetown/shophand,
		
		/datum/job/roguetown/tribalchieftain,
		/datum/job/roguetown/tribalshaman,
		/datum/job/roguetown/tribalguard,
		/datum/job/roguetown/tribalrabble,
		/datum/job/roguetown/tribalvillager,
		/datum/job/roguetown/slaver,
		/datum/job/roguetown/rockhillslave,
		/datum/job/roguetown/baron,
		/datum/job/roguetown/baron_retainer,
		
	)

//list to blacklist for other maps (update as new replacements are added)
		// /datum/job/roguetown/cataphract,
		// /datum/job/roguetown/vizier,
		// /datum/job/roguetown/headslave,
		// /datum/job/roguetown/sheikh,
		// /datum/job/roguetown/janissary,
		// /datum/job/roguetown/janissarysergeant,
		// /datum/job/roguetown/azeb,
		// /datum/job/roguetown/azebagha,
		// /datum/job/roguetown/slavemaster,
		// /datum/job/roguetown/dtslave,

	threat_regions = list(
		THREAT_REGION_DESERT_NEAR,
		THREAT_REGION_DESERT_DEEP,
	)
	// The Vale's trade roads become Al-Ashur's satrapies and themes: same region_ids and
	// goods, only the identity changes (see the alashar block in economic_region.dm).
	trade_region_swaps = list(
		TRADE_REGION_KINGSFIELD = /datum/economic_region/kingsfield/alashar,
		TRADE_REGION_ROSAWOOD = /datum/economic_region/rosawood/alashar,
		TRADE_REGION_ROCKHILL = /datum/economic_region/rockhill/alashar,
		TRADE_REGION_DAFTSMARCH = /datum/economic_region/daftsmarch/alashar,
		TRADE_REGION_BLACKHOLT = /datum/economic_region/blackholt/alashar,
		TRADE_REGION_SALTWICK = /datum/economic_region/saltwick/alashar,
		TRADE_REGION_BLEAKCOAST = /datum/economic_region/bleakcoast/alashar,
		TRADE_REGION_NORTHFORT = /datum/economic_region/northfort/alashar,
		TRADE_REGION_HEARTFELT = /datum/economic_region/heartfelt/alashar,
		TRADE_REGION_HAGENWALD = /datum/economic_region/hagenwald/alashar,
	)
	// Local identity charters in Al-Ashur's own voice, sworn to Psydon rather than the Ten;
	// shared realm lore (Otava, Zenitstadt, the Magna Carta's name) keeps its names.
	// Mechanics untouched.
	decree_reskins = list(
		/datum/decree/great_writ = list(
			"name" = "阿尔-阿舒尔大敕令",
			"flavor_text" = {"此阿尔-阿舒尔大敕令，以人类古神普赛顿之名颁布，宣告：本邦的贵族，以及旅居其间的外邦蓝血，其血统既已在普赛顿的注视下得到印证，皆不得对其人身或产业课以任何赋税或征缴。
迪万的任何文书或税吏均不得对其妄加冒犯，因为他们是以鲜血与谏言、而非钱币来效劳。"},
			"revoke_text" = "%RULER%已废止大敕令。阿尔-阿舒尔的贵族世家须以鲜血与黄金向王权纳贡。任何血统都不得尊贵到免于缴纳。",
			"restore_text" = "%RULER%已重新颁行大敕令。阿尔-阿舒尔的蓝血再度免于征缴，好让贵族以武力而非钱币效命于国度。",
		),
		/datum/decree/golden_bull = list(
			"name" = "沙赫田金玺诏书",
			"flavor_text" = {"此沙赫田金玺诏书，钤以普赛顿的荆棘印记，见证阿尔-阿舒尔王权与其财富缔造者之间古老的盟约。
国度的市民与集市主事应受庇护，免遭毁灭性的征敛：任何征缴或罚金都不得从他们身上夺去超过既定份额的部分，加之于他们头上的人头税亦有上限。作为回报，他们的认捐将于每个黎明补充共同防务，一如这盟约最初以黄金缔结之时。"},
			"revoke_text" = "%RULER%已中止沙赫田金玺诏书。市民们如今暴露于王权的全额征缴之下，而愤怒的集市将不再为国之共同防务作出任何贡献。",
			"restore_text" = "%RULER%已恢复沙赫田金玺诏书。盟约再度以黄金缔结，集市也恢复了对共同防务的纳贡。",
		),
		/datum/decree/indenture_of_war = list(
			"name" = "耶尼切里契约",
			"flavor_text" = {"此耶尼切里契约，订于阿尔-阿舒尔王权为一方与国度的武装人员为另一方之间，兹见证如下：
王权应向驻军中每一位宣誓的士兵支付不低于此处所定下限的薪饷，及时且不予削减；而军士们则须守住城墙、隘口与和平，一如普赛顿在昔日守住阵线。薪饷与誓言，彼此相缚。"},
			"revoke_text" = "%RULER%已撕毁耶尼切里契约。士兵的誓言就此解除，王权的武装人员可自由选择效命于谁。让驻军记住是谁的印玺先被割断。",
			"restore_text" = "%RULER%已重续耶尼切里契约。士兵的薪饷已作承诺，士兵的誓言依然有效。二者彼此相缚。",
		),
		/datum/decree/guild_charter_of_arms = list(
			"name" = "雇佣兵特许状",
			"flavor_text" = {"此雇佣兵特许状，拟于普赛顿的荆棘旗帜之下，立于阿尔-阿舒尔王权与武备行会之间，兹见证：王权承认行会为一受特许的外邦团体，自理其事务，仅对其自己的首领负责。其宣誓的佣兵除最轻微的人头计数外，不承担任何共同征缴。
作为回报，行会向市民认捐缴纳每日贡金，使庇护其生意的国度得以受其防卫。"},
			"revoke_text" = "%RULER%已中止雇佣兵特许状。阿尔-阿舒尔的佣兵如今须全额承担王权的共同征缴，而行会对认捐的贡金也停止缴纳，直至盟约重续。",
			"restore_text" = "%RULER%已确认雇佣兵特许状。行会的承认得以恢复，其对认捐的贡金也随之恢复。",
		),
		/datum/decree/magna_carta = list(
			"flavor_text" = {"%RULER_NAME%，蒙普赛顿恩典，阿尔-阿舒尔之%RULER%，沙赫田、卡拉霍尔特与萨尔塔巴德的总督，罗萨巴格、罗克泰佩与达夫特斯马兹的霸主，布利克塔拉萨、诺斯德兹与哈特坎德的保护者，古老信仰的捍卫者，致他的大祭司、牧师、圣堂武士、审判官、埃米尔、谢赫、维齐尔、执政之手、总管、参议、文书官、执法官、铁甲骑兵、耶尼切里、阿塞卜、马穆鲁克、侍从、宫廷法师、档案官、药剂师、宫廷医师、商人、旅店主人、浴场主、行会工匠、市民、居民、游牧民、农夫、厨子、酒馆伙计、浴场侍者、仆役、奴隶、农人、佣兵、冒险者、朝圣者，以及他所有的官员与忠诚臣民，谨致问候。
须知，在普赛顿面前，为了我们灵魂的健康，也为了我们祖先与继承者灵魂的健康，为了古老信仰的荣耀与我等国度更好的治理，我们已授予并确认下列写明的种种自由。"},
			"revoke_text" = "听好了，听好了。%RULER_NAME%，蒙普赛顿恩典，阿尔-阿舒尔之%RULER%，沙赫田、卡拉霍尔特与萨尔塔巴德的总督，罗萨巴格、罗克泰佩与达夫特斯马兹的霸主，布利克塔拉萨、诺斯德兹与哈特坎德的保护者，古老信仰的捍卫者，于今日废止大宪章。国度的子民就此恢复其惯常的财政义务，王权的岁入也如数恢复。且让记录载明%RULER_NAME%的这番重新考量。",
		),
	)
	// Blockade routes: gentle roads (no travel fee) through the near dunes, everything
	// far or dangerous through the deep desert at the mountain-tier fee; Al-Ashur's
	// far roads are brutal. Both regions carry hard quest spawners.
	blockade_route_map = list(
		TRADE_REGION_KINGSFIELD = THREAT_REGION_DESERT_NEAR,
		TRADE_REGION_ROSAWOOD = THREAT_REGION_DESERT_NEAR,
		TRADE_REGION_BLACKHOLT = THREAT_REGION_DESERT_NEAR,
		TRADE_REGION_HEARTFELT = THREAT_REGION_DESERT_NEAR,
		TRADE_REGION_ROCKHILL = THREAT_REGION_DESERT_DEEP,
		TRADE_REGION_SALTWICK = THREAT_REGION_DESERT_DEEP,
		TRADE_REGION_BLEAKCOAST = THREAT_REGION_DESERT_DEEP,
		TRADE_REGION_NORTHFORT = THREAT_REGION_DESERT_DEEP,
		TRADE_REGION_HAGENWALD = THREAT_REGION_DESERT_DEEP,
		TRADE_REGION_DAFTSMARCH = THREAT_REGION_DESERT_DEEP,
	)
	// Towner postings: the caravan rides the near roads (highwaymen in the faction
	// table), the miner's lead strikes the deep dunes (elemental guardians).
	towner_quest_regions = list(
		QUEST_TOWNER_SMITH_CARAVAN = list(THREAT_REGION_DESERT_NEAR),
		QUEST_TOWNER_MINER_OREVEIN = list(THREAT_REGION_DESERT_DEEP),
	)
