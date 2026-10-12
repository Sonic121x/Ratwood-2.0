// 七罪七德：仅实现日常机制版。所有角色进度由 mind 上的 z121_ethos 保留。
// 核心覆写过程在编译器中使用原路径，静态检查器要求补齐过程路径段。
// 两种写法指向同一类型的同一过程，避免退化为按名称调用而再次进入自身覆写。
#ifdef SPACEMAN_DMM
#define Z121_ETHOS_OVERRIDE_PROC(parent_type, proc_name) parent_type/proc/proc_name
#else
#define Z121_ETHOS_OVERRIDE_PROC(parent_type, proc_name) parent_type/proc_name
#endif

/datum/charflaw/z121_sin
	point_value = 1
	var/ethos_id

/datum/charflaw/z121_sin/on_mob_creation(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/datum/z121_ethos/R = H.z121_get_ethos(TRUE)
		R.set_sin(ethos_id, TRUE)
		addtimer(CALLBACK(R, TYPE_PROC_REF(/datum/z121_ethos, finish_envy_initialization)), 0)

/datum/charflaw/z121_sin/on_removal(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.z121_get_ethos()?.set_sin(ethos_id, FALSE)

/datum/charflaw/z121_sin/pride
	name = "折不得的冠冕〔傲慢〕"
	desc = "被他人攻击击倒后，压力+4、意志−1，完整持续3分钟，不能提前解除或缩短。每场冲突仅触发一次；60秒未攻击或受攻击后结束冲突。"
	ethos_id = "pride"

/datum/charflaw/z121_sin/greed
	name = "空囊之惧〔贪婪〕"
	desc = "入场10分钟后，随身钱币不足50玛蒙时压力+3、意志−1；补足立即解除。钱袋和背包内钱币计入，银行与物品估价不计。"
	ethos_id = "greed"

/datum/charflaw/z121_sin/lust
	name = "难餍之心〔色欲〕"
	desc = "清醒活动30分钟未获成人活动满足后，压力+3、感知−1。只能通过实际成人活动中的满足重置；药物、冥想、休息、复活和重登不能缓解。须成年并开启成人功能。"
	ethos_id = "lust"

/datum/charflaw/z121_sin/envy
	name = "他人的光芒〔嫉妒〕"
	desc = "出生后锁定最高技能，检视该技能高于自己至少2级的玩家后，压力+3、意志−1，持续3分钟。获得该技能经验或独处30秒解除；同一对象冷却10分钟。"
	ethos_id = "envy"

/datum/charflaw/z121_sin/gluttony
	name = "腹中空洞〔暴食〕"
	desc = "进食获得的营养减少20%。营养低于700时压力+3，达到800才解除。无需进食的角色不可选择。"
	ethos_id = "gluttony"

/datum/charflaw/z121_sin/wrath
	name = "一点即燃〔暴怒〕"
	desc = "遭他人直接攻击，单次实际伤害至少10时，力量+1、感知−2、压力+4，持续20秒，冷却60秒。脱战静坐10秒可提前结束。"
	ethos_id = "wrath"

/datum/charflaw/z121_sin/sloth
	name = "沉重的清晨〔怠惰〕"
	desc = "清醒活动15分钟后，速度−1、制作动作耗时+15%。坐下或躺卧连续休息45秒重置；移动、攻击或受攻击中断。"
	ethos_id = "sloth"

/datum/virtue/z121_virtue
	var/ethos_id

/datum/virtue/z121_virtue/check_triumphs(mob/living/carbon/human/recipient)
	if(ethos_id == "chastity" && recipient.z121_get_ethos()?.chastity_lost)
		to_chat(recipient, span_warning("你已失去本局的自主之誓，不能重新获得。"))
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
	desc = "导师技能高于自己时，教学经验+30%；接受其他玩家有效治疗后，压力−2持续3分钟，冷却5分钟。"
	custom_text = "导师技能高于自己时，教学经验+30%；接受其他玩家有效治疗后，压力−2持续3分钟，冷却5分钟。"
	triumph_cost = 4
	ethos_id = "humility"
	incompatible_vices = list(/datum/charflaw/z121_sin/pride)

/datum/virtue/z121_virtue/charity
	name = "分食者〔慷慨〕"
	desc = "另一名玩家接受所赠食物、药品或至少20玛蒙后，双方压力−3持续5分钟，冷却10分钟。同一物品或钱币往返不能重复获益。"
	custom_text = "另一名玩家接受所赠食物、药品或至少20玛蒙后，双方压力−3持续5分钟，冷却10分钟。同一物品或钱币往返不能重复获益。"
	triumph_cost = 4
	ethos_id = "charity"
	incompatible_vices = list(/datum/charflaw/z121_sin/greed)

/datum/virtue/z121_virtue/chastity
	name = "自主之誓〔贞洁〕"
	desc = "持有20分钟后意志+1，有限时长负面心情缩短15%（傲慢除外）。任何成人活动实际参与，主动、被动、自行均立即永久失去本局美德，不退凯旋；复活、重登均不能恢复。"
	custom_text = "持有20分钟后意志+1，有限时长负面心情缩短15%（傲慢除外）。任何成人活动实际参与，主动、被动、自行均立即永久失去本局美德，不退凯旋；复活、重登均不能恢复。"
	triumph_cost = 6
	ethos_id = "chastity"
	incompatible_vices = list(/datum/charflaw/z121_sin/lust)

/datum/virtue/z121_virtue/kindness
	name = "为你欢喜〔仁爱〕"
	desc = "为其他玩家完成有效包扎或治疗后，双方压力−2持续5分钟，冷却5分钟；自己产生的正面社交心情持续时间+25%。"
	custom_text = "为其他玩家完成有效包扎或治疗后，双方压力−2持续5分钟，冷却5分钟；自己产生的正面社交心情持续时间+25%。"
	triumph_cost = 4
	ethos_id = "kindness"
	incompatible_vices = list(/datum/charflaw/z121_sin/envy)

/datum/virtue/z121_virtue/temperance
	name = "知足之腹〔节制〕"
	desc = "营养和水分自然消耗减少20%；营养在350至800时压力−2。不降低疾病、法术等特殊消耗。"
	custom_text = "营养和水分自然消耗减少20%；营养在350至800时压力−2。不降低疾病、法术等特殊消耗。"
	triumph_cost = 4
	ethos_id = "temperance"
	incompatible_vices = list(/datum/charflaw/z121_sin/gluttony)

/datum/virtue/z121_virtue/patience
	name = "缓息如石〔忍耐〕"
	desc = "疼痛造成的属性惩罚减轻20%，不改变伤害与伤口。受攻击后10秒未主动攻击，意志+1持续30秒，冷却60秒。"
	custom_text = "疼痛造成的属性惩罚减轻20%，不改变伤害与伤口。受攻击后10秒未主动攻击，意志+1持续30秒，冷却60秒。"
	triumph_cost = 6
	ethos_id = "patience"
	incompatible_vices = list(/datum/charflaw/z121_sin/wrath)

/datum/virtue/z121_virtue/diligence
	name = "双手不息〔勤勉〕"
	desc = "制作、采集和修理的正向技能经验+20%；完成有经验的有效劳动后压力−2持续5分钟，不叠加。"
	custom_text = "制作、采集和修理的正向技能经验+20%；完成有经验的有效劳动后压力−2持续5分钟，不叠加。"
	triumph_cost = 6
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
	if(!GLOB.z121_ethos_service)
		GLOB.z121_ethos_service = new
		GLOB.z121_ethos_service.register()


