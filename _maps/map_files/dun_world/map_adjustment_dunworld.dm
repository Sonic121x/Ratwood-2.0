/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/dunworld
	map_file_name = "dun_world.dmm"
	realm_name = "腐木谷"
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
		/datum/job/roguetown/slaver,
		/datum/job/roguetown/rockhillslave,
		/datum/job/roguetown/baron,
		/datum/job/roguetown/baron_retainer,
		/datum/job/roguetown/adventurer/courtslave,
		/datum/job/roguetown/dtchaplain,
		
		/datum/job/roguetown/tribalchieftain,
		/datum/job/roguetown/tribalshaman,
		/datum/job/roguetown/tribalguard,
		/datum/job/roguetown/tribalrabble,
		/datum/job/roguetown/tribalvillager,
		
		/datum/job/roguetown/vanguard,//more wardens
		/datum/job/roguetown/guardsman,//MAA do double duty here
		/datum/job/roguetown/watchcaptain,//sergeant does the job here
		/datum/job/roguetown/wardenmaster,//wardens get to be more independent here!
	)
	slot_adjust = list(
		/datum/job/roguetown/warden = 6,
	)
	title_adjust = list(
		/datum/job/roguetown/lord = list(display_title = "公爵", f_title = "公爵夫人"),
	)
	tutorial_adjust = list(
		/datum/job/roguetown/rookie = "打杂、递送消息、修补凹痕、与当地人交谈；府卫总是需要一双闲手、一双闲眼和一对闲耳。协助你的卫兵同伴应对来自内外的威胁。 \
				你只接受过武器与守卫工作的简要入门，其余训练都要在工作中自行摸索。 \
				服从你的上级（除了你以外的所有人），向贵族表示敬意。多加留意，试着学上一两手，或许有朝一日你能活到成为一名合格的士兵。"
	)
	species_adjust = list()
	sexes_adjust = list()

	//Threat regions is used for displaying specific regions on notice boards
	threat_regions = list(
		THREAT_REGION_AZURE_BASIN,
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_TERRORBOG,
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_MOUNT_DECAP
	)
