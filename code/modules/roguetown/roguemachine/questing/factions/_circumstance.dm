GLOBAL_LIST_EMPTY(quest_circumstances_recovery)
GLOBAL_LIST_EMPTY(quest_circumstances_carriage)
GLOBAL_LIST_EMPTY(quest_circumstances_recovery_bandits)

/datum/writ_circumstance
	var/list/phrasings

/datum/writ_circumstance/proc/render()
	if(!length(phrasings))
		return null
	return pick(phrasings)

/proc/init_writ_circumstances()
	GLOB.quest_circumstances_recovery = list()
	for(var/path in subtypesof(/datum/writ_circumstance/recovery))
		GLOB.quest_circumstances_recovery += new path()
	GLOB.quest_circumstances_carriage = list()
	for(var/path in subtypesof(/datum/writ_circumstance/carriage))
		GLOB.quest_circumstances_carriage += new path()
	GLOB.quest_circumstances_recovery_bandits = list()
	for(var/path in subtypesof(/datum/writ_circumstance/recovery_bandits))
		GLOB.quest_circumstances_recovery_bandits += new path()

/proc/pick_circumstance_from(list/pool)
	if(!length(pool))
		return ""
	var/datum/writ_circumstance/C = pick(pool)
	return C.render()

/proc/pick_recovery_circumstance()
	return pick_circumstance_from(GLOB.quest_circumstances_recovery)

/proc/pick_carriage_circumstance()
	return pick_circumstance_from(GLOB.quest_circumstances_carriage)

/proc/pick_recovery_bandits_circumstance()
	return pick_circumstance_from(GLOB.quest_circumstances_recovery_bandits)


/datum/writ_circumstance/recovery/caravan_storm
	phrasings = list(
		"一支贸易商队在途中为风暴所冲散，货物零落散布于林间。",
		"恶劣的天气在河湾处掀翻了一辆货车；王国的货物如今无人认领地搁在泥中。",
	)

/datum/writ_circumstance/recovery/peddler_lost
	phrasings = list(
		"一名货郎为泥沼所吞，行囊就丢在他倒下的地方。",
		"一名游商在途中遭遇不测；他的货物仍散落在身旁，无人动过。",
	)

/datum/writ_circumstance/recovery/tax_wagon_broken
	phrasings = list(
		"一辆税车的车轴在小道上折断，车载货物被匆匆藏起，等待取回。",
		"一名什一税运送者的板车在重载下开裂，货物被匆匆遮盖后留在原地。",
	)

/datum/writ_circumstance/recovery/pilgrim_fallen
	phrasings = list(
		"一名朝圣者在圣路上病倒，把行囊丢在了路旁。",
		"一名病倒的朝圣者的供品，散落在路旁的神龛处。",
	)

/datum/writ_circumstance/recovery/courier_dead
	phrasings = list(
		"一名王室的信使在某个无人记得的凹谷中死于热病，他所携的包裹就与他的骸骨同在一处。",
		"一名王国的信使在途中遭遇不测；他的挎包与货物仍留在掉落之处。",
	)

/datum/writ_circumstance/recovery/cliff_drop
	phrasings = list(
		"王国的货物自高崖边小道上的货车滚落，散落在岩脚之下。",
		"一辆板车在陡坡上遗落了货物，包裹缠结在下方的荆棘丛中。",
	)

/datum/writ_circumstance/recovery/thief_cache
	phrasings = list(
		"一名窃贼将赃物藏在荒野，后来被处以绞刑；藏匿之物至今无人寻回。",
		"赃物由一名如今已被绞死的罪犯藏起，传言那批财物就在乡间某处。",
	)

/datum/writ_circumstance/recovery/noble_lost_kit
	phrasings = list(
		"一名贵族世家的侍从在一场以不幸收场的狩猎中，弄丢了主人托付的猎具。",
		"一位贵族的猎队遭野兽袭击，他的装备四散；余下之物仍留在小径上。",
	)

/datum/writ_circumstance/recovery/seal_case_dropped
	phrasings = list(
		"总管的一只印玺匣从信使的马鞍上坠落在途中，至今未被寻回。",
		"一名信使在策马归途中行囊崩裂，官方的包裹因此遗失。",
	)

/datum/writ_circumstance/recovery/flood_swept
	phrasings = list(
		"春汛从河畔码头卷走了货物，将它们搁在下游的岸边。",
		"涨水从码头带走了一车货物；未被冲走的部分搁浅在浅滩上。",
	)


/datum/writ_circumstance/carriage/physician_urgent
	phrasings = list(
		"此事紧急——医师须在今日之内用上这批货物。",
		"持件人被嘱速行；收件人有着格外的急需。",
	)

/datum/writ_circumstance/carriage/regular_runner_indisposed
	phrasings = list(
		"此路线的常任跑腿因伤不适，无法递送包裹。",
		"惯常的信使因热病卧床不起；此趟递送需另找他人。",
	)

/datum/writ_circumstance/carriage/courier_robbed
	phrasings = list(
		"此前一次的递送毁于匪患；包裹已重新备好，等待新的持件人。",
		"首名信使遭拦路强盗袭击，包裹已退回签发者；第二次递送正另寻更为强健的持件人。",
	)

/datum/writ_circumstance/carriage/contracted_shipment
	phrasings = list(
		"一份长期契约要求履行此次递送；收件人已预先付款。",
		"收件人已凭约据买下此次递送，正等待交付。",
	)

/datum/writ_circumstance/carriage/private_gift
	phrasings = list(
		"此包裹是两方之间的私人赠礼；内中之物与持件人无关。",
		"此次递送是一方对另一方的赠与；请勿破损封印。",
	)

/datum/writ_circumstance/carriage/sealed_confidential
	phrasings = list(
		"封印已然封妥——持件人不得知晓内中之物，违者将失去令状。",
		"包裹之内为何物，只与收件人有关；持件人请勿窥探。",
	)

/datum/writ_circumstance/carriage/replacement_for_spoilage
	phrasings = list(
		"第一份包裹在途中因腐坏而损失；这第二份装的是同样的货物，重新备好。",
		"先前的一次递送因事故告败；其中货物用以替代遗失之物。",
	)

/datum/writ_circumstance/carriage/festival_provisioning
	phrasings = list(
		"收件人正为十神的节庆作准备，其中货物须在约定之日以前送到。",
		"宴日将近，收件人的家中需在当日到来之前用上这批货物。",
	)

/datum/writ_circumstance/carriage/payment_in_kind
	phrasings = list(
		"此次递送用以清偿一笔以实物偿付的债务，收件人正等这批货物来结清。",
		"此包裹是以货物而非钱币的部分偿付，收件人将此账挂起，直到它送达。",
	)


/datum/writ_circumstance/recovery_bandits/scattered_caravan
	phrasings = list(
		"商队遭袭击并被拆散；匪徒带走了能拿的东西，但一只加了封的包裹仍在他们看守之下。",
		"匪徒取走了想要之物，其余的藏在他们巢穴里；去取回属于王国的东西。",
	)

/datum/writ_circumstance/recovery_bandits/raided_tithe
	phrasings = list(
		"一辆什一税车遭伏击，货物被运入匪帮营地；必须把包裹夺回。",
		"王室的什一税运送者遭劫，货物如今正由夺走它们的匪徒本人保管。",
	)

/datum/writ_circumstance/recovery_bandits/captured_courier
	phrasings = list(
		"一名王国的信使连同其包裹一同被掳；包裹仍在掳走他的那伙人手中。",
		"一名信使的行囊被劫掠者夺去，他们留着它，或是为了赎金，或是出于恶意。",
	)

/datum/writ_circumstance/recovery_bandits/looted_shipment
	phrasings = list(
		"一批货物在途中被从运送者手中夺走，目前由肇事的匪帮持有。",
		"其中货物是以武力从合法运送者处夺来的，目前由夺取者保管。",
	)

/datum/writ_circumstance/recovery_bandits/cached_loot
	phrasings = list(
		"匪徒将掠夺之物藏在巢穴附近；其中有一只属于王国的包裹。",
		"有人在匪帮的赃物中见到了王室的失窃货物，必须将其取回。",
	)

/datum/writ_circumstance/recovery_bandits/ambush_dropped
	phrasings = list(
		"伏击的混乱中包裹被丢下，匪徒看守着那处地方，以防有人回来寻找。",
		"运送者保住了性命却没能保住包裹，如今那伙人正看守着它。",
	)
