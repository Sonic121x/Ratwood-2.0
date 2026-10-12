// 七罪七德：每项只保留一个主要效果；本局记录由 mind 持有。
/datum/charflaw/z121_sin
	point_value = 1
	var/ethos_id

/datum/charflaw/z121_sin/on_mob_creation(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/datum/z121_ethos/R = H.z121_get_ethos(TRUE)
		R.set_sin(ethos_id, TRUE)

/datum/charflaw/z121_sin/on_removal(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.z121_get_ethos()?.set_sin(ethos_id, FALSE)

/datum/charflaw/z121_sin/pride
	name = "折不得的冠冕〔傲慢〕"
	desc = "击倒状态下压力+3，击倒结束解除；主动躺卧不触发。"
	ethos_id = "pride"

/datum/charflaw/z121_sin/greed
	name = "空囊之惧〔贪婪〕"
	desc = "随身真实钱币不足50玛蒙时压力+3，补足解除。背包和钱袋计入，银行与物品估价不计。"
	ethos_id = "greed"

/datum/charflaw/z121_sin/lust
	name = "难餍之心〔色欲〕"
	desc = "连续游戏内24小时未高潮时感知−1，任何来源的高潮都会解除并重新计时。睡眠、死亡和离线不暂停计时；关闭成人功能时暂不施加负面。须成年并开启成人功能才能选择。"
	ethos_id = "lust"

/datum/charflaw/z121_sin/envy
	name = "他人的光芒〔嫉妒〕"
	desc = "检视另一名玩家，对方任一技能比自己同一技能高至少2级时，压力+3持续3分钟；再次触发只刷新时长。"
	ethos_id = "envy"

/datum/charflaw/z121_sin/gluttony
	name = "腹中空洞〔暴食〕"
	desc = "营养低于700时压力+3，达到800后解除。无需进食的角色不可选择。"
	ethos_id = "gluttony"

/datum/charflaw/z121_sin/wrath
	name = "一点即燃〔暴怒〕"
	desc = "蛮力与烧伤伤害合计达到20时感知−1，低于20解除。"
	ethos_id = "wrath"

/datum/charflaw/z121_sin/sloth
	name = "沉重的清晨〔怠惰〕"
	desc = "速度−1。"
	ethos_id = "sloth"

/datum/virtue/z121_virtue
	var/ethos_id

/datum/virtue/z121_virtue/check_triumphs(mob/living/carbon/human/recipient)
	if(ethos_id == "chastity" && recipient.z121_get_ethos()?.chastity_lost)
		to_chat(recipient, span_warning("自主之誓已在本局失效，重新选择也不能恢复增益。"))
		return FALSE
	if(recipient.has_flaw(z121_ethos_opposite_sin(ethos_id)) || recipient.z121_get_ethos()?.sins[z121_ethos_paired_id(ethos_id)])
		return FALSE
	return ..()

/datum/virtue/z121_virtue/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(istype(recipient))
		recipient.z121_get_ethos(TRUE).set_virtue(ethos_id, TRUE)

/datum/virtue/z121_virtue/humility
	name = "低首求学〔谦逊〕"
	desc = "智力+1。"
	custom_text = "智力+1。"
	triumph_cost = 4
	ethos_id = "humility"
	incompatible_vices = list(/datum/charflaw/z121_sin/pride)

/datum/virtue/z121_virtue/charity
	name = "分食者〔慷慨〕"
	desc = "通过赠予动作交付食物并被另一名在线、存活玩家接受后，自身压力−2持续3分钟；重复触发只刷新时长。"
	custom_text = "通过赠予动作交付食物并被另一名在线、存活玩家接受后，自身压力−2持续3分钟；重复触发只刷新时长。"
	triumph_cost = 4
	ethos_id = "charity"
	incompatible_vices = list(/datum/charflaw/z121_sin/greed)

/datum/virtue/z121_virtue/chastity
	name = "自主之誓〔贞洁〕"
	desc = "意志+1；持有期间首次高潮后立即失效，本局不能恢复，不退凯旋。任何来源的高潮均计入，复活、重登和重新授予不能恢复增益。"
	custom_text = "意志+1；持有期间首次高潮后立即失效，本局不能恢复，不退凯旋。任何来源的高潮均计入，复活、重登和重新授予不能恢复增益。"
	triumph_cost = 4
	ethos_id = "chastity"
	incompatible_vices = list(/datum/charflaw/z121_sin/lust)

/datum/virtue/z121_virtue/kindness
	name = "为你欢喜〔仁爱〕"
	desc = "为另一名在线、存活玩家成功包扎正在流血且未包扎的肢体后，自身压力−2持续3分钟；重复触发只刷新时长。"
	custom_text = "为另一名在线、存活玩家成功包扎正在流血且未包扎的肢体后，自身压力−2持续3分钟；重复触发只刷新时长。"
	triumph_cost = 4
	ethos_id = "kindness"
	incompatible_vices = list(/datum/charflaw/z121_sin/envy)

/datum/virtue/z121_virtue/temperance
	name = "知足之腹〔节制〕"
	desc = "营养在350至800之间（含边界）时压力−2。"
	custom_text = "营养在350至800之间（含边界）时压力−2。"
	triumph_cost = 4
	ethos_id = "temperance"
	incompatible_vices = list(/datum/charflaw/z121_sin/gluttony)

/datum/virtue/z121_virtue/patience
	name = "缓息如石〔忍耐〕"
	desc = "清醒且主动躺卧休息时压力−2，结束休息解除。"
	custom_text = "清醒且主动躺卧休息时压力−2，结束休息解除。"
	triumph_cost = 4
	ethos_id = "patience"
	incompatible_vices = list(/datum/charflaw/z121_sin/wrath)

/datum/virtue/z121_virtue/diligence
	name = "双手不息〔勤勉〕"
	desc = "制作类和劳动类技能的正向经验+20%，不区分经验来源或操作成败；零经验和负经验不放大。"
	custom_text = "制作类和劳动类技能的正向经验+20%，不区分经验来源或操作成败；零经验和负经验不放大。"
	triumph_cost = 4
	ethos_id = "diligence"
	incompatible_vices = list(/datum/charflaw/z121_sin/sloth)

/proc/z121_ethos_opposite_sin(virtue_id)
	var/static/list/opposites = list(
		"humility" = /datum/charflaw/z121_sin/pride,
		"charity" = /datum/charflaw/z121_sin/greed,
		"chastity" = /datum/charflaw/z121_sin/lust,
		"kindness" = /datum/charflaw/z121_sin/envy,
		"temperance" = /datum/charflaw/z121_sin/gluttony,
		"patience" = /datum/charflaw/z121_sin/wrath,
		"diligence" = /datum/charflaw/z121_sin/sloth)
	return opposites[virtue_id]

/proc/register_z121_ethos()
	GLOB.virtues -= /datum/virtue/z121_virtue
	for(var/path in subtypesof(/datum/charflaw/z121_sin))
		var/datum/charflaw/z121_sin/V = GLOB.charflaw_singletons[path]
		GLOB.character_flaws[V.name] = path
	for(var/path in subtypesof(/datum/virtue/z121_virtue))
		var/datum/virtue/z121_virtue/V = GLOB.virtues[path]
		GLOB.roguetraits[z121_ethos_trait(V.ethos_id)] = V.custom_text
	GLOB.roguetraits[z121_ethos_chastity_lost_trait()] = "自主之誓已失效：本局不再提供意志加成，凯旋不返还。"
	if(!GLOB.z121_ethos_service)
		GLOB.z121_ethos_service = new
		GLOB.z121_ethos_service.register()


