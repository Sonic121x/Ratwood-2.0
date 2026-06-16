/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/deserttown
	map_file_name = "deserttown.dmm"
	realm_name = "Al-Ashur"
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
		/datum/job/roguetown/marshal = "此文本待修改。你被苏丹委任为最高军事权威。在你的豪宅中坐镇，担任各主要武力支柱——铁甲骑兵队长（及其铁甲骑兵）、耶尼切里军士长（及其耶尼切里）和精锐兵队长（及其精锐兵）之间的主要协调联络人。",
		/datum/job/roguetown/physician = "你是一位医学大师，深得苏丹本人信赖，负责为王室宗亲、宫廷朝臣、 \
		其护卫及其臣民提供专业医护。你主要在宫殿医疗翼的城堡内居住，但也同样可以出入 \
		 集市中的地方诊所，那里有资历较浅的持证药剂师在你的偶尔路过指点下行医。",
		/datum/job/roguetown/magician = "你的信条致力于征服奥术艺术并追寻知识带来的永恒悸动。 \
		你欠苏丹一条命，因为正是他的金币让你在这黑暗时代中得以继续学业。 \
		作为回报，你一次又一次以公正裁决和可信顾问的身份证明了自己的价值，辅佐着苏丹的统治。",
		/datum/job/roguetown/shophand = "你靠着那位将你绑在这苦差上的商人，得以在阿尔-阿舒尔最大的店铺里工作。为雇主补货上架和盘点库存的工作令人麻木而重复——但至少你头顶上有片屋檐，身边环境也舒适。假以时日，或许有一天你会比一个光鲜的仆役更有出息。",
		/datum/job/roguetown/councillor = "你可能继承了这个职位，花钱买来的，或是被王室亲自任命； \
			无论出身如何，你现在作为维齐尔的助理、规划师和陪审官为其效力。 \
			你协助他监督税收、建设以及新法律的规划。 \
			你的主要职责是辅佐维齐尔完成其职务，只对他们和苏丹负责。",
		/datum/job/roguetown/hand = "你是国内最重要的人物之一。 \
			你长期扮演着贵族家族的间谍头子和知心密友，以至于你本身就是一座阴谋的宝库，而你也以坚定的信念利用着这一点。\
			让所有人永远不要忘记你是在谁的耳边低语。你用那双唇杀掉的人比任何剑术大师敢宣称的都多。",
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
			"name" = "The Great Firman of Al-Ashur",
			"flavor_text" = {"This Great Firman of Al-Ashur, pronounced in the name of PSYDON, Elder God of Humanity, declareth that the nobility of this land, and the blue blood of foreign realms sojourning within it, being of lineage proven in Psydon's sight, shall bear no tax nor levy upon their persons or estates.
Let no clerk nor collector of the Divan presume against them, for their service is rendered in blood and counsel, not in coin."},
			"revoke_text" = "The %RULER% has set aside the Great Firman. The noble houses of Al-Ashur shall contribute to the Crown, in both blood and gold. Let no lineage be too blessed to pay.",
			"restore_text" = "The %RULER% has renewed the Great Firman. The blue blood of Al-Ashur is freed again from the levy, that the nobility may serve the realm in arms, not in coin.",
		),
		/datum/decree/golden_bull = list(
			"name" = "The Chrysobull of Shahfield",
			"flavor_text" = {"This Chrysobull of Shahfield, sealed beneath the thorned sigil of PSYDON, witnesseth the ancient compact between the Crown of Al-Ashur and the makers of her wealth.
The burghers and bazaar masters of the realm shall be shielded from ruinous exaction: no levy nor fine shall strip more than a fixed portion from any of them, and the poll upon their heads is capped. In return their pledge replenishes the common defense with every dawn, as it has since the compact was first struck in gold."},
			"revoke_text" = "The %RULER% has suspended the Chrysobull of Shahfield. The burghers stand exposed to the Crown's full levy, and the outraged bazaar shall contribute no more to the common defense of the realm.",
			"restore_text" = "The %RULER% has restored the Chrysobull of Shahfield. The compact stands renewed in gold, and the bazaar resumes its tribute to the common defense.",
		),
		/datum/decree/indenture_of_war = list(
			"name" = "The Janissary Indenture",
			"flavor_text" = {"This Janissary Indenture, made betwene the Crown of Al-Ashur on the one part, and the armed men of the realm on the other part, witnesseth that:
The Crown shall pay to every sworn soldier of the garrison a wage no less than the floor herein appointed, promptly and without diminution; and the soldiery in return shall hold the walls, the pass, and the peace, as Psydon held the line in elder days. The wage and the oath each bind the other."},
			"revoke_text" = "The %RULER% has broken the Janissary Indenture. The soldier's oath is dissolved, and the Crown's armed men stand at liberty of service. Let the garrison remember whose seal was cut first.",
			"restore_text" = "The %RULER% has renewed the Janissary Indenture. The soldier's wage is pledged, and the soldier's oath stands. Each binds the other.",
		),
		/datum/decree/guild_charter_of_arms = list(
			"name" = "The Charter of Hired Blades",
			"flavor_text" = {"This Charter of Hired Blades, drawn beneath the thorned banner of PSYDON and entered unto between the Crown of Al-Ashur and the Guild of Arms, witnesseth that the Crown recognizeth the Guild as a chartered foreign body, self governing in its own affairs and answerable only to its own captains. Its sworn mercenaries shall bear no common levy save the lightest head count upon them.
In return the Guild remits its daily tribute to the burghers' pledge, that the realm which shelters its trade may be defended by it."},
			"revoke_text" = "The %RULER% has suspended the Charter of Hired Blades. The sellswords of Al-Ashur now bear the Crown's common levy in full, and the Guild's tribute to the Pledge ceases until the compact is renewed.",
			"restore_text" = "The %RULER% has affirmed the Charter of Hired Blades. The Guild's recognition is restored, and its tribute to the Pledge resumes.",
		),
		/datum/decree/magna_carta = list(
			"flavor_text" = {"%RULER_NAME%, by the grace of Psydon, %RULER% of Al-Ashur, Satrap of Shahfield, Karaholt, and Saltabad, Overlord of Rosabagh, Rocktepe, and Daftsmarz, Protector of Bleakthalassa, Northdez, and Heartkand, Defender of the Old Faith, to his high priests, chaplains, templars, inquisitors, amirs, sheikhs, viziers, hands, stewards, councillors, clerks, marshals, cataphracts, janissaries, azebs, mamaluks, squires, palace magicians, archivists, apothecaries, palace physicians, merchants, innkeepers, bathmasters, guildsmen, burghers, residents, nomads, farmers, cooks, tapsters, bathmaids, servants, slaves, soilsons, mercenaries, adventurers, pilgrims, and to all his officials and loyal subjects, Greeting.
Know that before Psydon, for the health of our soul and those of our ancestors and heirs, to the honour of the Old Faith and the better ordering of our realm, we have granted and confirmed the liberties hereinafter written."},
			"revoke_text" = "Hear ye, hear ye. %RULER_NAME%, by the grace of Psydon, %RULER% of Al-Ashur, Satrap of Shahfield, Karaholt, and Saltabad, Overlord of Rosabagh, Rocktepe, and Daftsmarz, Protector of Bleakthalassa, Northdez, and Heartkand, Defender of the Old Faith, hath this day set aside the Magna Carta. The realm's subjects are hereby restored to their accustomed fiscal obligations, and the Crown's revenue is restored in kind. Let the record reflect the reconsideration of %RULER_NAME%.",
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
