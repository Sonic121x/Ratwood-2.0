// 旧装备流程在模块中适配：属性记录实际变化量，特性使用物品独立来源。
// 保留原有穿脱条件、技能、音效和文案，不重新执行穿戴来恢复角色。

/obj/item
	var/datum/weakref/z121_return_bonus_owner
	var/list/z121_return_bonuses
	var/list/z121_return_bonus_indexes
	var/list/z121_return_skill_bonuses
	var/z121_return_hallucination_before = 0

// 记录包含溢出缓冲的真实增量，避免到达属性上下限后仍按名义数值撤销。
/obj/item/proc/z121_return_equipment_stat(mob/living/user, stat, amount, index, removing = FALSE)
	if(!ishuman(user))
		return user.change_stat(stat, amount, index)
	var/mob/living/carbon/human/H = user
	if(removing)
		if(z121_return_bonus_owner?.resolve() == H && (stat in z121_return_bonuses))
			z121_parallel_stat_delta(H, stat, -z121_return_bonuses[stat])
			z121_return_bonuses -= stat
			if(index)
				H.statindex -= index
				z121_return_bonus_indexes -= index
		return
	var/before = z121_parallel_stat_total(H, stat)
	H.change_stat(stat, amount, index)
	z121_return_bonus_owner = WEAKREF(H)
	LAZYINITLIST(z121_return_bonuses)
	z121_return_bonuses[stat] += z121_parallel_stat_total(H, stat) - before
	if(index)
		LAZYINITLIST(z121_return_bonus_indexes)
		z121_return_bonus_indexes[index] = z121_return_copy(H.statindex[index])

// 这里只返回当前物品授予的数据，不保存或复制物品。
/mob/living/carbon/human/proc/z121_return_equipment_stats()
	var/list/stats = list()
	var/list/indexes = list()
	var/list/skills = list()
	for(var/obj/item/I as anything in (get_equipped_items() | held_items))
		if(QDELETED(I))
			continue
		if(I.z121_return_bonus_owner?.resolve() == src)
			for(var/stat in I.z121_return_bonuses)
				stats[stat] += I.z121_return_bonuses[stat]
			for(var/index in I.z121_return_bonus_indexes)
				indexes[index] = z121_return_copy(statindex[index])
			for(var/datum/skill/skill as anything in I.z121_return_skill_bonuses)
				skills[skill] += I.z121_return_skill_bonuses[skill]
		var/datum/component/z121_item_stat_bonuses/custom = I.GetComponent(/datum/component/z121_item_stat_bonuses)
		if(custom?.holder == src)
			for(var/stat in custom.actual_bonuses)
				stats[stat] += custom.actual_bonuses[stat]
				var/index = custom.source_key(stat)
				indexes[index] = z121_return_copy(statindex[index])
	// 环境及身份效果不回滚，其属性也必须与当前效果一起保留。
	for(var/datum/status_effect/E as anything in status_effects)
		if(z121_return_bodily_status(E))
			continue
		var/list/applied_stats = isnull(E.z121_return_applied_stats) ? E.effectedstats : E.z121_return_applied_stats
		for(var/stat in applied_stats)
			stats[stat] += applied_stats[stat]
	return list("stats" = stats, "indexes" = indexes, "skills" = skills)

// 项链造成的无限幻觉属于当前实物，不能进入身体存档或留在重建的裸身上。
/mob/living/carbon/human/proc/z121_return_equipment_symptoms(list/saved_values, restoring = FALSE)
	var/obj/item/clothing/neck/roguetown/dragon_scale/necklace = get_item_by_slot(SLOT_NECK)
	if(!istype(necklace) || !necklace.active_item || !HAS_TRAIT_FROM(src, TRAIT_PSYCHOSIS, "z121_equipment_[REF(necklace)]"))
		return
	if(restoring)
		necklace.z121_return_hallucination_before = hallucination
		hallucination = INFINITY
	else
		saved_values["hallucination"] = necklace.z121_return_hallucination_before

// 胸甲的技能强化同样属于实物，脱下时只撤销实际授予的经验。
/obj/item/proc/z121_return_equipment_skill(mob/living/user, skill, removing = FALSE)
	var/datum/skill/key = GetSkillRef(skill)
	var/datum/skill_holder/holder = user.ensure_skills()
	var/before = holder.skill_experience[key] || 0
	if(removing)
		if(z121_return_bonus_owner?.resolve() != user || !(key in z121_return_skill_bonuses))
			return
		var/datum/z121_profession_record/record
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			record = H.z121_profession
		if(record && !record.suspended)
			record.settle_experience(key, before)
		holder.adjust_experience(key, -z121_return_skill_bonuses[key], TRUE)
		if(record && !record.suspended)
			// 装备经验不是职业奖励，不能让撤销装备先扣掉职业部分。
			record.independent_experience[key] = max(0, record.independent_experience[key] - (before - holder.skill_experience[key]))
			record.observed_experience[key] = holder.skill_experience[key]
		z121_return_skill_bonuses -= key
		return
	user.adjust_skillrank(key, 1, TRUE)
	z121_return_bonus_owner = WEAKREF(user)
	LAZYINITLIST(z121_return_skill_bonuses)
	z121_return_skill_bonuses[key] = holder.skill_experience[key] - before

// 与核心经验门槛保持一致，只重算等级，不发放升级奖励或触发经验倍率。
/proc/z121_return_skill_level(experience)
	switch(experience)
		if(SKILL_EXP_LEGENDARY to INFINITY)
			return SKILL_LEVEL_LEGENDARY
		if(SKILL_EXP_MASTER to SKILL_EXP_LEGENDARY)
			return SKILL_LEVEL_MASTER
		if(SKILL_EXP_EXPERT to SKILL_EXP_MASTER)
			return SKILL_LEVEL_EXPERT
		if(SKILL_EXP_JOURNEYMAN to SKILL_EXP_EXPERT)
			return SKILL_LEVEL_JOURNEYMAN
		if(SKILL_EXP_APPRENTICE to SKILL_EXP_JOURNEYMAN)
			return SKILL_LEVEL_APPRENTICE
		if(SKILL_EXP_NOVICE to SKILL_EXP_APPRENTICE)
			return SKILL_LEVEL_NOVICE
	return SKILL_LEVEL_NONE

/obj/item/clothing/ring/statgemerald/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_green("'……生命之道，丰饶却短暂……'"))
		z121_return_equipment_stat(user, STATKEY_SPD, 1, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_LCK, 1, null, FALSE)
	return

/obj/item/clothing/ring/statgemerald/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_green("'……若旅途永无尽头，生命又何来意义？'"))
		z121_return_equipment_stat(user, STATKEY_SPD, -1, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_LCK, -1, null, TRUE)
		active_item = FALSE
	return

/obj/item/clothing/ring/statonyx/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_purple("'……鲜血之道，自你身上徒然流尽……'"))
		z121_return_equipment_stat(user, STATKEY_CON, 1, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_WIL, 1, null, FALSE)
	return

/obj/item/clothing/ring/statonyx/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_purple("'……若你不为那些无法挺身而出的人而战，又还能指望谁呢？'"))
		z121_return_equipment_stat(user, STATKEY_CON, -1, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_WIL, -1, null, TRUE)
		active_item = FALSE
	return

/obj/item/clothing/ring/statamythortz/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_rose("'……知识之道，以疯狂诅咒每一个追逐者……'"))
		z121_return_equipment_stat(user, STATKEY_INT, 1, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_PER, 1, null, FALSE)
	return

/obj/item/clothing/ring/statamythortz/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_rose("'……可若我们扎根于盲昧，又该如何继续前行？'"))
		z121_return_equipment_stat(user, STATKEY_INT, -1, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_PER, -1, null, TRUE)
		active_item = FALSE
	return

/obj/item/clothing/ring/statrontz/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_red("'……死亡之道，无差别而彻底……'"))
		z121_return_equipment_stat(user, STATKEY_STR, 1, null, FALSE)
		ADD_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, "z121_equipment_[REF(src)]")
	return

/obj/item/clothing/ring/statrontz/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_red("'……但若没有暴力，又该如何阻止邪恶得胜？'"))
		z121_return_equipment_stat(user, STATKEY_STR, -1, null, TRUE)
		REMOVE_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, "z121_equipment_[REF(src)]")
		active_item = FALSE
	return

/obj/item/clothing/ring/statdorpel/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_blue("'……希望之道，不可摧折，亦能凝聚众人……'"))
		z121_return_equipment_stat(user, STATKEY_SPD, 1, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_LCK, 1, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_INT, 1, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_PER, 1, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_CON, 1, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_WIL, 1, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_STR, 1, null, FALSE)
		ADD_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, "z121_equipment_[REF(src)]")
		ADD_TRAIT(user, TRAIT_INFINITE_STAMINA, "z121_equipment_[REF(src)]")
	return

/obj/item/clothing/ring/statdorpel/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_blue("'……我知善意存在，因为我心怀善意……'</br>'……我知希望存在，因为我仍怀希望……'</br>'……而我知爱存在，因为我仍会去爱。'"))
		z121_return_equipment_stat(user, STATKEY_SPD, -1, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_LCK, -1, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_INT, -1, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_PER, -1, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_CON, -1, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_WIL, -1, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_STR, -1, null, TRUE)
		REMOVE_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, "z121_equipment_[REF(src)]")
		REMOVE_TRAIT(user, TRAIT_INFINITE_STAMINA, "z121_equipment_[REF(src)]")
		active_item = FALSE
	return

/obj/item/clothing/ring/dragon_ring/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_suicide("龙焰在我血脉中奔涌！我感到力量充盈！"))
		z121_return_equipment_stat(user, STATKEY_STR, 2, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_CON, 2, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_WIL, 2, null, FALSE)
	return

/obj/item/clothing/ring/dragon_ring/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_suicide("一股寒意流遍我的全身，而戒指残留的热度依旧令人迷醉……</br>……但也不禁让人思索……这般炽烈的力量，能否经受熔炉之火？"))
		z121_return_equipment_stat(user, STATKEY_STR, -2, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_CON, -2, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_WIL, -2, null, TRUE)
		active_item = FALSE
	return

/obj/item/clothing/neck/roguetown/luckcharm/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_NECK)
		z121_return_equipment_stat(user, STATKEY_LCK, 1, null, FALSE)
		goodluckactivated = TRUE
	return

/obj/item/clothing/neck/roguetown/luckcharm/dropped(mob/living/carbon/human/user)
	. = ..()
	if(goodluckactivated == TRUE)
		z121_return_equipment_stat(user, STATKEY_LCK, -1, null, TRUE)
		goodluckactivated = FALSE
	return

/obj/item/clothing/neck/roguetown/psicross/malum/secret/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_NECK)
		active_item = TRUE
		to_chat(user, span_hypnophrase("……暖意流过我的血脉，而我却并未灼伤；恰恰相反，我的头脑比以往任何时候都更清明……</br>……发光的符文自我眼前掠过，渐渐解译为熔炉中最伟大的秘密……</br>'黑钢与黄金，萨菲拉与布洛兹，以白银教十字束缚，方能催发龙之怒火。'</br>'四枚附魔戒指，以白银相系。绿宝石、缟玛瑙、阿密索兹、龙红石，合而为一，即为全能。'</br>'五块白银锭，龙戒残片与泣血教十字，一截巨木，以及这枚护符中所蕴之物；足以诛灭维斯林的恶魔。'"))
		z121_return_equipment_stat(user, STATKEY_INT, 3, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_LCK, 3, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_STR, -3, null, FALSE)
		ADD_TRAIT(user, TRAIT_SMITHING_EXPERT, "z121_equipment_[REF(src)]")
		ADD_TRAIT(user, TRAIT_FORGEBLESSED, "z121_equipment_[REF(src)]")
	return

/obj/item/clothing/neck/roguetown/psicross/malum/secret/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_monkeyhive("……那些符文化作难以分辨的污痕，随后再次消散回这个世界。就在那一瞬间，你几乎忘了掌心中灼烧般的热度……</br>……也许，这东西更适合被放进炽热闷烧的熔炉里……"))
		z121_return_equipment_stat(user, STATKEY_INT, -3, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_LCK, -3, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_STR, 3, null, TRUE)
		REMOVE_TRAIT(user, TRAIT_SMITHING_EXPERT, "z121_equipment_[REF(src)]")
		REMOVE_TRAIT(user, TRAIT_FORGEBLESSED, "z121_equipment_[REF(src)]")
		active_item = FALSE
	return

/obj/item/clothing/neck/roguetown/psicross/weeping/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_NECK)
		active_item = TRUE
		to_chat(user, span_red("当你戴上这枚教十字时，锁链如铁钳般骤然勒紧你的脖颈！可怕的痛苦感将你彻底吞没，仿佛人类的一切苦难都被强塞进了你的灵魂！你的胸口冰冷彻骨，血液却沸腾得比熔岩更炽热！普赛多尼亚的恶徒或许残暴无情，但你将比他们更甚！</br>你陷入狂暴了！"))
		z121_return_equipment_stat(user, STATKEY_STR, 3, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_CON, -3, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_WIL, 3, null, FALSE)
		ADD_TRAIT(user, TRAIT_PSYCHOSIS, "z121_equipment_[REF(src)]")
		ADD_TRAIT(user, TRAIT_NOCSHADES, "z121_equipment_[REF(src)]")
		ADD_TRAIT(user, TRAIT_DNR, "z121_equipment_[REF(src)]")
		ADD_TRAIT(user, TRAIT_STRONGKICK, "z121_equipment_[REF(src)]")
		ADD_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, "z121_equipment_[REF(src)]")
	return

/obj/item/clothing/neck/roguetown/psicross/weeping/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_monkeyhive("……转瞬之间，那股狂乱便退去了。熟悉的暖意重新爬回你的胸口。尽管你的神志已经清明，那个念头却仍挥之不去：方才真只是某种不适，还是别的什么？</br>……也许，这东西更适合被放进炽热闷烧的熔炉里……"))
		z121_return_equipment_stat(user, STATKEY_STR, -3, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_CON, 3, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_WIL, -3, null, TRUE)
		REMOVE_TRAIT(user, TRAIT_PSYCHOSIS, "z121_equipment_[REF(src)]")
		REMOVE_TRAIT(user, TRAIT_NOCSHADES, "z121_equipment_[REF(src)]")
		REMOVE_TRAIT(user, TRAIT_DNR, "z121_equipment_[REF(src)]")
		REMOVE_TRAIT(user, TRAIT_STRONGKICK, "z121_equipment_[REF(src)]")
		REMOVE_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, "z121_equipment_[REF(src)]")
		active_item = FALSE
	return

/obj/item/clothing/neck/roguetown/dragon_scale/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	if(slot == SLOT_NECK)
		active_item = TRUE
		if(user.mind?.special_role == "Bandit")
			to_chat(user, span_suppradio("藏宝主的意志开始与我的意志交融。巨大的<b>贪欲</b>充斥着我的脑海。"))
			z121_return_equipment_stat(user, STATKEY_LCK, 2, null, FALSE)
			user.add_stress(/datum/stressevent/dragon_scale)
			ADD_TRAIT(user, TRAIT_DARKVISION, "z121_equipment_[REF(src)]")
			ADD_TRAIT(user, TRAIT_HARDDISMEMBER, "z121_equipment_[REF(src)]")
			ADD_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, "z121_equipment_[REF(src)]")
			armor = getArmor("blunt" = 100, "slash" = 100, "stab" = 100, "piercing" = 100, "fire" = 50, "acid" = 0)
		else
			to_chat(user, span_suicide("这条项链……我听见有个声音在嘲弄我！"))
			ADD_TRAIT(user, TRAIT_PSYCHOSIS, "z121_equipment_[REF(src)]")
			z121_return_hallucination_before = user.hallucination
			user.hallucination = INFINITY
			armor = getArmor("blunt" = 0, "slash" = 0, "stab" = 0, "piercing" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/neck/roguetown/dragon_scale/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	if(HAS_TRAIT_FROM(user, TRAIT_DARKVISION, "z121_equipment_[REF(src)]"))
		to_chat(user, span_monkeyhive("藏宝主对我心智的掌控减弱了。难道我还不够吗？我能感受到那份失望。"))
	else
		to_chat(user, span_suicide("<b>把它从我身边拿开！！</b>"))
		if(HAS_TRAIT_FROM(user, TRAIT_PSYCHOSIS, "z121_equipment_[REF(src)]"))
			user.hallucination = z121_return_hallucination_before
	// 撤销按实际授予的来源进行，不能依赖读档后可能已变化的职业。
	z121_return_equipment_stat(user, STATKEY_LCK, -2, null, TRUE)
	user.remove_stress(/datum/stressevent/dragon_scale)
	REMOVE_TRAIT(user, TRAIT_DARKVISION, "z121_equipment_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_HARDDISMEMBER, "z121_equipment_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, "z121_equipment_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_PSYCHOSIS, "z121_equipment_[REF(src)]")
	armor = getArmor("blunt" = 100, "slash" = 100, "stab" = 100, "piercing" = 100, "fire" = 50, "acid" = 0)

/obj/item/clothing/mask/rogue/spectacles/goggles/equipped(mob/user, slot)
	..()
	if(slot == SLOT_WEAR_MASK || slot == SLOT_HEAD)
		ADD_TRAIT(user, TRAIT_SANDSTORM_GOGGLES, "z121_equipment_[REF(src)]")
	user.update_fov_angles()

/obj/item/clothing/mask/rogue/spectacles/goggles/dropped(mob/user)
	..()
	if(HAS_TRAIT(user, TRAIT_SANDSTORM_GOGGLES))
		REMOVE_TRAIT(user, TRAIT_SANDSTORM_GOGGLES, "z121_equipment_[REF(src)]")
	user.update_fov_angles()

/obj/item/clothing/suit/roguetown/shirt/robe/priest/equipped(mob/living/user, slot)
	..()
	if(slot != SLOT_ARMOR|SLOT_SHIRT)
		return
	if(!HAS_TRAIT(user, TRAIT_CHOSEN))
		return
	ADD_TRAIT(user, TRAIT_MONK_ROBE, "z121_equipment_[REF(src)]")
	to_chat(user, span_notice("持守清贫誓言并披上法衣后，我感到精力充沛，仿佛得到了神明加护！"))

/obj/item/clothing/suit/roguetown/shirt/robe/priest/dropped(mob/living/user)
	..()
	REMOVE_TRAIT(user, TRAIT_MONK_ROBE, "z121_equipment_[REF(src)]")
	to_chat(user, span_notice("我必须脱下长袍稍作歇息；即便是神选之人也需要休息……"))

/obj/item/clothing/suit/roguetown/shirt/robe/monk/holy/equipped(mob/living/user, slot)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_CIVILIZEDBARBARIAN))
		return
	ADD_TRAIT(user, TRAIT_MONK_ROBE, "z121_equipment_[REF(src)]")
	to_chat(user, span_notice("持守清贫誓言并披上法衣后，我感到精力充沛，仿佛得到了神明加护！"))

/obj/item/clothing/suit/roguetown/shirt/robe/monk/holy/dropped(mob/living/user)
	..()
	REMOVE_TRAIT(user, TRAIT_MONK_ROBE, "z121_equipment_[REF(src)]")
	to_chat(user, span_notice("我必须脱下长袍稍作歇息；即便是神选之人也需要休息……"))

/obj/item/clothing/head/roguetown/headband/bloodied/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_HEAD)
		ADD_TRAIT(user, TRAIT_SILVER_BLESSED, "z121_equipment_[REF(src)]")
		ADD_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, "z121_equipment_[REF(src)]")

/obj/item/clothing/head/roguetown/headband/bloodied/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.head == src)
		REMOVE_TRAIT(user, TRAIT_SILVER_BLESSED, "z121_equipment_[REF(src)]")
		REMOVE_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, "z121_equipment_[REF(src)]")

/obj/item/clothing/head/roguetown/wizhat/gen/wise/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/wise = user
	if(slot == SLOT_HEAD)
		z121_return_equipment_stat(wise, STATKEY_INT, 2, "wisehat", FALSE)
		to_chat(wise, span_green("我获得了智慧。"))

/obj/item/clothing/head/roguetown/wizhat/gen/wise/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/wise = user
	if(wise.get_item_by_slot(SLOT_HEAD) == src)
		z121_return_equipment_stat(wise, STATKEY_INT, -2, "wisehat", TRUE)
		to_chat(wise, span_red("我失去了智慧。"))

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_HEAD)
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_BITERHELM, "z121_equipment_[REF(src)]")
		to_chat(user, span_red("盆盔的面罩发出颤响，你的下颌也随之因共生般的冲动而绷紧……"))
	return

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	REMOVE_TRAIT(user, TRAIT_BITERHELM, "z121_equipment_[REF(src)]")
	to_chat(user, span_red("……就这样，盆盔的面罩再度沉寂下来，你下颌那股古怪的压迫感也随之消退了。"))

/obj/item/clothing/head/roguetown/helmet/heavy/graggar/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	if(slot == SLOT_HEAD)
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_BITERHELM, "z121_equipment_[REF(src)]")

/obj/item/clothing/head/roguetown/helmet/heavy/graggar/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	REMOVE_TRAIT(user, TRAIT_BITERHELM, "z121_equipment_[REF(src)]")

/obj/item/clothing/head/roguetown/helmet/heavy/mimic/equipped(mob/living/user, slot)
	. = ..()
	if(slot != SLOT_HEAD)
		return
	active_item = TRUE
	to_chat(user, span_hypnophrase("死去的拟形怪血肉裹住你的头颅，滑腻、冰冷而潮湿。野兽的饥渴涌上你身，你感到饥饿与消瘦，仿佛有什么抽干了你的体质；然而取而代之的，是一股啃噬不休的贪婪欲念，以及足以餍足它的幸运。"))
	z121_return_equipment_stat(user, STATKEY_LCK, 5, null, FALSE)
	z121_return_equipment_stat(user, STATKEY_CON, -5, null, FALSE)

/obj/item/clothing/head/roguetown/helmet/heavy/mimic/dropped(mob/living/user)
	. = ..()
	if(!active_item)
		return
	to_chat(user, span_hypnophrase("那具邪恶的尸骸伴着一声黏腻的闷响剥落下来。你的头颅湿漉漉的，覆满那生物亮滑的黏液……你感到自己的活力回来了！"))
	z121_return_equipment_stat(user, STATKEY_LCK, -5, null, TRUE)
	z121_return_equipment_stat(user, STATKEY_CON, 5, null, TRUE)
	active_item = FALSE

/obj/item/clothing/suit/roguetown/armor/plate/ancient/artificer/equipped(mob/living/user, slot)
	. = ..()
	if(!powered || active_item || slot != SLOT_ARMOR)
		return
	if(mode == 1)
		var/current_arcane = user.get_skill_level(/datum/skill/magic/arcane)
		if(current_arcane)
			if(current_arcane < 6)
				active_item = TRUE
				legendaryarcane = FALSE
				z121_return_equipment_skill(user, /datum/skill/magic/arcane)
				z121_return_equipment_stat(user, STATKEY_INT, 3, null, FALSE)
				to_chat(user, span_notice("魔力流遍我的全身。"))
				icon_state ="artificerplate_powered"
				item_state = "artificerplate_powered"
			else
				z121_return_equipment_stat(user, STATKEY_INT, 3, null, FALSE)
				legendaryarcane = TRUE
				active_item = TRUE
				to_chat(user, span_warning("[src] 微微嗡鸣，但你早已是奥术大师。"))
				icon_state ="artificerplate_powered"
				item_state = "artificerplate_powered"
		else
			to_chat(user, span_warning("对不通奥术之人而言，[src] 冰冷而死寂。"))
	if(mode == 2)
		if(slot != SLOT_ARMOR)
			return
		var/current_athletics = user.get_skill_level(/datum/skill/misc/athletics)
		if(current_athletics)
			if(current_athletics < 6)
				z121_return_equipment_skill(user, /datum/skill/misc/athletics)
				legendaryathletics = FALSE
				icon_state ="artificerplate_powered"
				item_state = "artificerplate_powered"
			else
				legendaryathletics = TRUE
			active_item = TRUE
			to_chat(user, span_notice("力量流遍我的全身。"))
			z121_return_equipment_stat(user, STATKEY_STR, 2, null, FALSE)
			z121_return_equipment_stat(user, STATKEY_WIL, 2, null, FALSE)
			icon_state ="artificerplate_powered"
			item_state = "artificerplate_powered"
			return
		else
			to_chat(user, span_warning("这件胸甲冰冷而死寂。"))

/obj/item/clothing/suit/roguetown/armor/plate/ancient/artificer/dropped(mob/living/user)
	. = ..()
	if(!active_item)
		return
	// 技能可能被存档还原到零级，仍须按物品账本完整撤销强化。
	z121_return_equipment_skill(user, /datum/skill/magic/arcane, TRUE)
	z121_return_equipment_skill(user, /datum/skill/misc/athletics, TRUE)
	z121_return_equipment_stat(user, STATKEY_INT, -3, null, TRUE)
	z121_return_equipment_stat(user, STATKEY_STR, -2, null, TRUE)
	z121_return_equipment_stat(user, STATKEY_WIL, -2, null, TRUE)
	active_item = FALSE
	to_chat(user, span_notice("增强我能力的力量消散了……"))

/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_ARMOR)
		to_chat(user, span_suicide("这套全装甲咔嗒作响地就位，我感到双肩在其重量下低垂，可即便如此，我也觉得自己前所未有地结实……"))
		z121_return_equipment_stat(user, STATKEY_CON, 1, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_SPD, -1, null, FALSE)
		bronzeplatecumbersome = TRUE
	return

/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/dropped(mob/living/carbon/human/user)
	. = ..()
	if(bronzeplatecumbersome == TRUE)
		to_chat(user, span_hypnophrase("……我终于松了口气，这套全装甲的重量不再压在我的肩上。"))
		z121_return_equipment_stat(user, STATKEY_CON, -1, null, TRUE)
		z121_return_equipment_stat(user, STATKEY_SPD, 1, null, TRUE)
		bronzeplatecumbersome = FALSE
	return

/obj/item/rogueweapon/spear/keep_standard/equipped(mob/living/user)
	. = ..()
	if(secondary_tag)
		detail_tag = "_det"
		update_icon()
	if(active_item)
		return
	active_item = TRUE
	if(user.job == "Man at Arms" || user.job == "Janissary")
		to_chat(user, span_suppradio("战旗上的符文脉动着，承认我是它的<b>主人</b>。"))
		z121_return_equipment_stat(user, STATKEY_LCK, 3, null, FALSE)
		z121_return_equipment_stat(user, STATKEY_PER, 2, null, FALSE)
		user.add_stress(/datum/stressevent/keep_standard)
		ADD_TRAIT(user, TRAIT_HARDDISMEMBER, "z121_equipment_[REF(src)]")
		ADD_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, "z121_equipment_[REF(src)]")
		if(HAS_TRAIT(user, TRAIT_STANDARD_BEARER))
			to_chat(user, span_suppradio("<small>它依然随时听候你的号令。你只需开口。</small>"))
			user.verbs |= /mob/proc/standard_position
			user.verbs |= /mob/proc/standard_recuperate
			user.verbs |= /mob/proc/standard_steady
			user.verbs |= /mob/proc/standard_rally
	else
		to_chat(user, span_suicide("战旗上的符文脉动着，拒绝承认我是它的<b>主人</b>。"))

/obj/item/rogueweapon/spear/keep_standard/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	if(user.job == "Man at Arms" || user.job == "Janissary")
		to_chat(user, span_monkeyhive("战旗上的符文有节奏地脉动着，仿佛因你放开掌控而感到惋惜。"))
		user.remove_stress(/datum/stressevent/keep_standard)
		if(HAS_TRAIT(user, TRAIT_STANDARD_BEARER))
			to_chat(user, span_monkeyhive("<small>我感到一阵不适。方才那是个错误吗？</small>"))
			user.verbs -= /mob/proc/standard_position
			user.verbs -= /mob/proc/standard_recuperate
			user.verbs -= /mob/proc/standard_steady
			user.verbs -= /mob/proc/standard_rally
	else
		to_chat(user, span_suicide("我一松手，战旗上的符文便脉动起来，像是终于松了口气。"))
	// 当前职业可能已变化，撤销不能再依赖当初获得加成的职业条件。
	user.remove_stress(/datum/stressevent/keep_standard)
	user.verbs -= /mob/proc/standard_position
	user.verbs -= /mob/proc/standard_recuperate
	user.verbs -= /mob/proc/standard_steady
	user.verbs -= /mob/proc/standard_rally
	z121_return_equipment_stat(user, STATKEY_LCK, -3, null, TRUE)
	z121_return_equipment_stat(user, STATKEY_PER, -2, null, TRUE)
	REMOVE_TRAIT(user, TRAIT_HARDDISMEMBER, "z121_equipment_[REF(src)]")
	REMOVE_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, "z121_equipment_[REF(src)]")
