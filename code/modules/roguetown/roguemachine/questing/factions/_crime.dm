GLOBAL_LIST_EMPTY(quest_crimes)

/datum/quest_crime
	var/id
	var/tier = CRIME_TIER_COMMON
	var/list/phrasings

/datum/quest_crime/proc/render()
	if(!length(phrasings))
		return null
	return pick(phrasings)

/proc/init_quest_crimes()
	GLOB.quest_crimes = list()
	for(var/path in subtypesof(/datum/quest_crime))
		var/datum/quest_crime/C = new path()
		if(!C.id)
			continue
		if(GLOB.quest_crimes[C.id])
			CRASH("Duplicate quest_crime id: [C.id]")
		GLOB.quest_crimes[C.id] = C

/proc/get_quest_crime(id)
	return GLOB.quest_crimes[id]


/datum/quest_crime/petty_temple_wine
	id = CRIME_PETTY_TEMPLE_WINE
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"饮用为圣殿祭杯所藏之酒",
		"饮尽为祭仪封存的祭坛陈酿",
	)

/datum/quest_crime/petty_alms_theft
	id = CRIME_PETTY_ALMS_THEFT
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"窃取为朝圣者与贫者备下的食物",
		"吃掉为施舍钵摆出的面包",
	)

/datum/quest_crime/petty_relieving
	id = CRIME_PETTY_RELIEVING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"当众污秽路旁神龛",
		"污秽献给十神的路旁石冢",
		"在公爵亲自下令竖立的告示牌上便溺污秽。"
	)

/datum/quest_crime/petty_chicken
	id = CRIME_PETTY_CHICKEN
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"偷走佃农的母鸡",
		"从农户的鸡舍中夺取家禽",
	)

/datum/quest_crime/petty_orchard
	id = CRIME_PETTY_ORCHARD
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"将他人果园采摘一空",
		"光天化日、有人见证之下摘取他人树上的果子",
	)

/datum/quest_crime/petty_offering_eating
	id = CRIME_PETTY_OFFERING_EATING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"吃掉留在神龛前的还愿糕饼",
		"醉酒中吞食神圣的供品",
	)

/datum/quest_crime/petty_priest_mocking
	id = CRIME_PETTY_PRIEST_MOCKING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"在集市广场公然嘲弄祭司",
		"歌唱有关十神祭司的不堪之词",
	)

/datum/quest_crime/petty_drinking_temple
	id = CRIME_PETTY_DRINKING_TEMPLE
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"午夜醉步踉跄闯入圣殿",
		"在圣殿内为取乐而大声争吵",
	)

/datum/quest_crime/petty_brawl
	id = CRIME_PETTY_BRAWL
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"在酒馆中斗殴，违逆公爵的治安之令",
		"因一杯泼洒的酒而痛打守法之人",
	)

/datum/quest_crime/petty_dueling
	id = CRIME_PETTY_DUELING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"因赌债未偿而拔刀相向",
		"为琐事挑起决斗，违背公爵的治安之令",
	)

/datum/quest_crime/petty_dog_kicking
	id = CRIME_PETTY_DOG_KICKING
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"踢踹传令官的狗",
		"虐待公爵辖下的牲畜",
	)

/datum/quest_crime/petty_signpost
	id = CRIME_PETTY_SIGNPOST
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"将公爵的路标推倒在路上",
		"在公爵大道沿线的里程碑上题写粗鄙之言",
	)

/datum/quest_crime/petty_proposal_scorn
	id = CRIME_PETTY_PROPOSAL_SCORN
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"以过分侮辱回绝诚心求婚之人，违逆伊欧拉之爱",
		"公然嘲弄认真求爱之人，违背伊欧拉的约束",
	)

/datum/quest_crime/petty_barren_mock
	id = CRIME_PETTY_BARREN_MOCK
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"在集市上嘲弄不能生育的妇人，违逆伊欧拉的赐福",
		"公然讥讽丧子之人，轻蔑伊欧拉的恩赐",
	)

/datum/quest_crime/petty_guest_wine
	id = CRIME_PETTY_GUEST_WINE
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"在斟给客人的酒中吐唾，违背伊欧拉的待客之道",
		"将为客人备下的面包弄酸，是对伊欧拉餐桌的侮辱",
	)

/datum/quest_crime/petty_tombstone_insult
	id = CRIME_PETTY_TOMBSTONE_INSULT
	tier = CRIME_TIER_PETTY
	phrasings = list(
		"在墓碑上刻下刻薄诗句",
		"在墓碑上涂抹嘲弄的韵句，使亡者不得安息",
	)


/datum/quest_crime/brigandage
	id = CRIME_BRIGANDAGE
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"在公爵大道上结伙劫掠",
		"在通衢大道上设伏，意图劫夺",
	)

/datum/quest_crime/road_robbery
	id = CRIME_ROAD_ROBBERY
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"劫掠受山巅治安庇护的商人",
		"洗劫合法前往集市的商队",
	)

/datum/quest_crime/pilgrim_robbery
	id = CRIME_PILGRIM_ROBBERY
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"劫掠携带供品前往神龛的朝圣者",
		"夺取圣途之上行人的施舍钱袋",
	)

/datum/quest_crime/murder_stealth
	id = CRIME_MURDER_STEALTH
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"以潜行与伏击杀人",
		"暗中下手杀害自由民",
		"在暗处行凶，使无人得以呼喊追缉",
		"暗中下手杀害自由民，此等屠戮为拉沃克斯之法所憎恶",
	)

/datum/quest_crime/murder_watch
	id = CRIME_MURDER_WATCH
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"杀害卫队中宣誓效忠之人",
		"杀害受公爵辖制的军官",
	)

/datum/quest_crime/herald_slaying
	id = CRIME_HERALD_SLAYING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"杀害身负密封令状的传令官",
		"破坏通行保障，对公爵的信使行凶流血",
		"破坏在拉沃克斯剑下宣誓的通行保障，对公爵的信使行凶流血",
	)

/datum/quest_crime/arson_night
	id = CRIME_ARSON_NIGHT
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"夜间纵火焚烧农庄",
		"在沉睡人家的屋顶上点火",
		"纵火焚烧沉睡的人家，将阿斯特拉塔的白昼安宁撕裂入诺克的时辰",
	)

/datum/quest_crime/granary_burning
	id = CRIME_GRANARY_BURNING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"于匮乏之时焚烧粮仓",
		"纵火焚烧公共储粮，使饥饿降临于民众",
		"于匮乏之时焚烧粮仓，使阿斯特拉塔的谷粮在饥民眼前化为灰烬",
	)

/datum/quest_crime/burglary
	id = CRIME_BURGLARY
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"夜间入室行窃",
		"乘黑破门，洗劫炉边与厅堂",
	)

/datum/quest_crime/cattle_lifting
	id = CRIME_CATTLE_LIFTING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"盗取牲畜，并将牲畜自公共牧场赶走",
		"自诚实人家劫掠牛只",
		"自诚实人家劫掠牛只，将登多尔的恩赐窃为贼赃",
	)

/datum/quest_crime/horse_theft
	id = CRIME_HORSE_THEFT
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"从马厩中盗马",
		"赶走由合法主人饲养的坐骑",
	)

/datum/quest_crime/coin_clipping
	id = CRIME_COIN_CLIPPING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"铸造假玛门币并剪削真币",
		"伪造公爵的铸币，并在集市上使用不足重的钱币",
	)

/datum/quest_crime/seal_forgery
	id = CRIME_SEAL_FORGERY
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"伪造印章与文书契约",
		"于羊皮纸上加盖伪印，使谎言披上法律的外衣",
	)

/datum/quest_crime/prison_breaking
	id = CRIME_PRISON_BREAKING
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"劫狱，放走候审之人",
		"从公爵的牢狱中放走罪犯",
	)

/datum/quest_crime/harbouring_outlaws
	id = CRIME_HARBOURING_OUTLAWS
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"明知其为通缉之徒仍予窝藏",
		"为狼首之徒提供屋檐与面包",
	)

/datum/quest_crime/receiving_stolen
	id = CRIME_RECEIVING_STOLEN
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"明知为赃物而收受",
		"买卖自守法之人处掠来的赃物",
	)

/datum/quest_crime/poaching_land
	id = CRIME_POACHING_LAND
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"猎杀野兽超过所需，任其尸骸腐烂，侵害登多尔的恩赐",
		"在林野中过度狩猎，将好肉留给乌鸦",
	)

/datum/quest_crime/poaching_fish
	id = CRIME_POACHING_FISH
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"捕鱼超过所需，听任渔获在岸边腐坏，是违背阿比索尔恩赐之罪",
		"撒网之量远超口腹所需，为虚耗而掠夺阿比索尔的潮水",
	)

/datum/quest_crime/false_relics
	id = CRIME_FALSE_RELICS
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"贩卖伪圣物，以阿斯特拉塔之名换取玛门",
		"兜售伪造的骨骸与锁链，将圣者之名冠于琐碎饰物",
	)


/datum/quest_crime/treason_lord
	id = CRIME_TREASON_LORD
	tier = CRIME_TIER_OATH
	phrasings = list(
		"背叛曾宣誓效忠的领主",
		"辜负曾给予衣食之人的恩义",
		"在拉沃克斯的祭坛前宣誓效忠，却背叛其领主",
	)

/datum/quest_crime/oath_breaking
	id = CRIME_OATH_BREAKING
	tier = CRIME_TIER_OATH
	phrasings = list(
		"违背在拉沃克斯面前、以剑柄与祭坛所立之誓",
		"背弃在拉沃克斯听闻之下所立之誓",
	)

/datum/quest_crime/desertion
	id = CRIME_DESERTION
	tier = CRIME_TIER_OATH
	phrasings = list(
		"战时自公爵的征召军中逃亡",
		"敌人尚在阵前便弃械而逃",
		"自公爵的征召军中逃亡，在拉沃克斯要其坚守之时弃械",
	)

/datum/quest_crime/foreign_pay
	id = CRIME_FOREIGN_PAY
	tier = CRIME_TIER_OATH
	phrasings = list(
		"受山巅约束却领外邦船长之酬",
		"誓言犹温便将武力卖予陌生旗号",
	)

/datum/quest_crime/sedition
	id = CRIME_SEDITION
	tier = CRIME_TIER_OATH
	phrasings = list(
		"煽动平民暴乱，破坏治安",
		"在集市与酒馆中播撒纷争，违逆公爵的治理",
	)

/datum/quest_crime/compass_death
	id = CRIME_COMPASS_DEATH
	tier = CRIME_TIER_OATH
	phrasings = list(
		"图谋害死公爵麾下宣誓的军官",
		"谋划并教唆谋杀公爵的部属",
		"图谋害死公爵麾下宣誓的军官，此等邪恶为拉沃克斯闻息而知",
	)

/datum/quest_crime/adhering_enemies
	id = CRIME_ADHERING_ENEMIES
	tier = CRIME_TIER_OATH
	phrasings = list(
		"依附公爵的敌人，为其提供援助与谋划",
		"为与山巅交战之人传递消息并供给食粮",
	)

/datum/quest_crime/oath_betrayal
	id = CRIME_OATH_BETRAYAL
	tier = CRIME_TIER_OATH
	phrasings = list(
		"在危难之时背弃立誓的同伴，将拉沃克斯的誓约信义换作钱币",
		"抛下曾与之握手立誓之人，违背拉沃克斯的准则",
	)

/datum/quest_crime/marriage_vow_broken
	id = CRIME_MARRIAGE_VOW_BROKEN
	tier = CRIME_TIER_OATH
	phrasings = list(
		"违背在伊欧拉面前所立的婚誓，使此缘在其时限之前落入内克拉之手",
		"在伊欧拉注视下所立的约束之下抛弃配偶",
	)

/datum/quest_crime/sacrilege_temple
	id = CRIME_SACRILEGE_TEMPLE
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"对十神神殿犯下亵渎之行",
		"以不洁之手触碰祭坛与祝圣之石",
	)

/datum/quest_crime/priest_slaying
	id = CRIME_PRIEST_SLAYING
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"在祭司自己的祭坛前将其杀害",
		"在十神的圣域内洒下圣职者之血",
		"在祭司自己的祭坛前将其杀害，阿斯特拉塔仆人的血自石中呐喊",
	)

/datum/quest_crime/shrine_robbery
	id = CRIME_SHRINE_ROBBERY
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"劫掠神龛并带走圣器",
		"掠夺还愿的器皿，洗劫十神自己的居所",
	)

/datum/quest_crime/defiling_ground
	id = CRIME_DEFILING_GROUND
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"玷污祝圣之地",
		"在献给十神的福地上行不洁之事",
		"玷污祝圣之地，在登多尔赐福的土上行使不洁",
	)

/datum/quest_crime/sanctuary_breaking
	id = CRIME_SANCTUARY_BREAKING
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"破坏圣所庇护，将寻求庇护之人拖出",
		"侵犯神圣庇护之所，使灵魂无从逃向十神以求保全",
	)

/datum/quest_crime/cleric_robbery
	id = CRIME_CLERIC_ROBBERY
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"在途中劫掠身着祭袍的教士",
		"袭击身着圣衣行走于公爵大道的祭司",
	)

/datum/quest_crime/tomb_desecration
	id = CRIME_TOMB_DESECRATION
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"亵渎受人敬奉的亡者之墓",
		"掘开坟冢与墓室，使亡者不得安息",
		"亵渎受人敬奉的亡者之墓，公然违抗内克拉的帷幕",
	)

/datum/quest_crime/relic_theft
	id = CRIME_RELIC_THEFT
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"自圣物匣中窃取圣物",
		"将圣者骨骸盗走，令祭司们呼号耻辱",
	)

/datum/quest_crime/simony
	id = CRIME_SIMONY
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"买卖圣职，以钱币买取祭司之位",
		"以祝福与圣礼换取玛门",
	)

/datum/quest_crime/altar_casting_down
	id = CRIME_ALTAR_CASTING_DOWN
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"推倒十神的祭坛",
		"砸碎圣石，在十神的信众眼前使其受辱",
	)

/datum/quest_crime/pilgrim_slaughter
	id = CRIME_PILGRIM_SLAUGHTER
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"屠戮结队而行的朝圣者",
		"在前往圣地的行列中大肆流血",
	)

/datum/quest_crime/temple_peace_breaking
	id = CRIME_TEMPLE_PEACE_BREAKING
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"破坏圣殿的安宁，在圣域之内携带出鞘的刀剑",
		"在本不应有锋刃闪光的圣地上拔刀",
	)

/datum/quest_crime/well_poisoning
	id = CRIME_WELL_POISONING
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"毒害圣井",
		"污秽十神视为神圣的水源",
		"毒害圣井，同时污秽佩斯特拉的医术与阿比索尔的赐水",
	)

/datum/quest_crime/eoran_tree_felled
	id = CRIME_EORAN_TREE_FELLED
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"伐倒伊欧拉的神树，使系于其枝上的恋人誓言就此解除",
		"砍伐伊欧拉的圣树，使系于其上的羁绊自根断绝",
	)

/datum/quest_crime/necran_procession_broken
	id = CRIME_NECRAN_PROCESSION_BROKEN
	tier = CRIME_TIER_SACRAL
	phrasings = list(
		"扰乱内克拉的葬礼行列，使亡者最后一程中断",
		"暴力阻拦将亡者送往内克拉庇护的送葬者",
	)


/datum/quest_crime/apostasy
	id = CRIME_APOSTASY
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"背弃十神，公然嘲弄其圣礼",
		"抛弃神圣的誓约，在祭坛前嬉笑",
	)

/datum/quest_crime/forbidden_doctrine
	id = CRIME_FORBIDDEN_DOCTRINE
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"传授教廷所禁的教义",
		"在谷仓与篱下宣讲邪恶的邪说，与十神相悖",
	)

/datum/quest_crime/forbidden_books
	id = CRIME_FORBIDDEN_BOOKS
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"私藏祭司下令焚毁的禁书",
		"囤积被查封定罪的魔典",
	)

/datum/quest_crime/ascendant_consorting
	id = CRIME_ASCENDANT_CONSORTING
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"与伪神升格者往来勾结，与之共抗十神",
		"向升格者之力献上祈祷与香火，违抗教廷",
	)

/datum/quest_crime/demonic_pact
	id = CRIME_DEMONIC_PACT
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"与魔物立下契约，以灵魂为质换取力量",
		"以血与墨与地底之物订立盟约",
	)

/datum/quest_crime/maleficium
	id = CRIME_MALEFICIUM
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"对未生之子、病人与栏中牛畜施加诅咒",
		"对守法之人施以黑术，使田地荒芜、孩童病倒",
	)

/datum/quest_crime/summoning
	id = CRIME_SUMMONING
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"召唤十神已贬落之物",
		"以名号与符印自地下唤起形影",
	)

/datum/quest_crime/necromancy
	id = CRIME_NECROMANCY
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"行死灵术，唤起不安的亡者",
		"缚役尸骨使其再度行走，违逆内克拉本人的安宁",
	)

/datum/quest_crime/blasphemy
	id = CRIME_BLASPHEMY
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"在集市与圣殿门前公然说出亵渎之言",
		"在人证面前说出针对十神的邪恶名号",
	)

/datum/quest_crime/host_desecration
	id = CRIME_HOST_DESECRATION
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"掰碎祝圣的面饼，将其丢给狗吃",
		"糟践神圣的供品，使十神受嘲",
		"掰碎祝圣的面饼，将伊欧拉的恩赐丢给狗",
	)

/datum/quest_crime/priestly_blood
	id = CRIME_PRIESTLY_BLOOD
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"蓄意预谋使圣职者流血",
		"经事先谋划并与人共议而谋杀祭司",
	)

/datum/quest_crime/dreamer_sacrifice
	id = CRIME_DREAMER_SACRIFICE
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"将捆绑塞口的俘虏投入深渊，企图将梦者自其极乐的沉睡中唤醒",
		"将缚住的血肉献给深渊，欲以凡人之手打破阿比索尔的沉睡",
	)

/datum/quest_crime/inhumen_invocation
	id = CRIME_INHUMEN_INVOCATION
	tier = CRIME_TIER_HERESY
	phrasings = list(
		"呼唤异民的伪名——格拉加尔之八名、齐佐之六名，以及下方的吞噬者",
		"高声念出教廷勒令噤声的渎神名号",
	)


/datum/quest_crime/piracy
	id = CRIME_PIRACY
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"在公爵之海上行海盗之事，并登临受休战保护的船只",
		"以桨帆夺取船只，破坏海岸的安宁",
	)

/datum/quest_crime/bondage_taking
	id = CRIME_BONDAGE_TAKING
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"将船员掳为奴役，贩卖自由之民",
		"将水手拖向锁链与刑台",
	)

/datum/quest_crime/shore_slaving
	id = CRIME_SHORE_SLAVING
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"在海岸一带掠人为奴，使城镇化为荒墟",
		"从被纵火焚毁的村庄中掳掠奴仆",
	)

/datum/quest_crime/coastal_burning
	id = CRIME_COASTAL_BURNING
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"在拂晓潮时焚毁渔村",
		"在人们尚在沉睡时点燃海岸上的茅屋",
	)

/datum/quest_crime/coastal_rapine
	id = CRIME_COASTAL_RAPINE
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"在海岸大肆劫掠，使渔人不敢撒网",
		"蹂躏海岸，使海边之民逃往内陆",
	)

/datum/quest_crime/temple_ship_burned
	id = CRIME_TEMPLE_SHIP_BURNED
	tier = CRIME_TIER_PIRACY
	phrasings = list(
		"在海上焚烧圣殿船只，使船上圣骸未经仪式便沉入海底",
		"在阿比索尔的潮汐上点燃圣船，使朝圣者与祭司在安歇之时溺亡",
	)


/datum/quest_crime/beast_sheep
	id = CRIME_BEAST_SHEEP
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"叼走了东边羊圈中的羊",
		"袭击了牧场上的羊群",
		"咬住羊羔的喉咙将其拖走",
	)

/datum/quest_crime/beast_child
	id = CRIME_BEAST_CHILD
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"叼走了林地看守的孩子",
		"在黄昏时分叼走牧羊人的幼子",
	)

/datum/quest_crime/beast_traveller
	id = CRIME_BEAST_TRAVELLER
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"在僻静道路上袭击旅人",
		"使林间道路不再容独行者通行",
	)

/datum/quest_crime/beast_cattle
	id = CRIME_BEAST_CATTLE
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"在牛棚中挑断牛只的腿筋",
		"在栏中屠杀牛只",
	)

/datum/quest_crime/beast_dogs
	id = CRIME_BEAST_DOGS
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"咬死了被派来对付它的猎犬",
		"撕开了牧羊人的獒犬",
	)

/datum/quest_crime/beast_winter
	id = CRIME_BEAST_WINTER
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"带着饥饿自高地而来",
		"因匮乏而胆大，逼近炉火的炊烟",
	)

/datum/quest_crime/beast_corpse
	id = CRIME_BEAST_CORPSE
	tier = CRIME_TIER_COMMON
	phrasings = list(
		"在沟中留下啃得精光的骨头",
		"将死者抛散在路旁",
	)
