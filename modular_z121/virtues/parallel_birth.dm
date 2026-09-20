// 出生时只在选有本美德且客户端已可确认的角色上启用记录。
/proc/z121_parallel_selected(mob/living/carbon/human/H, client/preference_source)
	var/datum/preferences/P = preference_source?.prefs || H.client?.prefs
	return H.GetComponent(/datum/component/martins_morning) || istype(P?.virtue, /datum/virtue/utility/martins_morning) || (P?.statpack?.name == "Virtuous" && istype(P.virtuetwo, /datum/virtue/utility/martins_morning))

// 初始职业的来源覆盖范围独立于随机候选池，宫廷法师只支持切出，不加入随机池。
/proc/z121_parallel_birth_outfit_known(outfit_type)
	return !outfit_type || (outfit_type in z121_parallel_outfits()) || outfit_type == /datum/outfit/job/roguetown/magician || outfit_type == /datum/outfit/job/roguetown/magician/basic

// 同类型覆盖的父调用会重跑原职业；用基础服装执行一次通用出生效果。
/datum/outfit/job/roguetown/proc/z121_birth_parent(mob/living/carbon/human/H)
	var/datum/outfit/job/roguetown/base = new
	base.allowed_patrons = allowed_patrons
	base.default_patron = default_patron
	base.pre_equip(H)
	qdel(base)

/datum/job/roguetown/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, datum/outfit/outfit_override = null, client/preference_source)
	if(!visualsOnly && H && !H.z121_profession && z121_parallel_selected(H, preference_source))
		H.z121_profession = new(H, null)
		// 非候选岗位的专用服装仍有未适配内容，只登记能够确认的授予。
		H.z121_profession.unknown = !z121_parallel_birth_outfit_known(outfit_override || outfit)
	var/datum/z121_profession_record/R = H?.z121_profession
	if(R)
		R.capturing_birth = !visualsOnly
	. = ..()
	if(R)
		R.capturing_birth = FALSE

// 宫廷法师的年龄与信仰效果由延迟回调授予，必须在实际授予处记录。
/datum/outfit/job/roguetown/magician/choose_loadout(mob/living/carbon/human/H)
	var/datum/z121_profession_record/R = H?.z121_profession
	if(!R)
		return ..()
	if(QDELETED(H) || H.job != "Court Magician" || R.court_mage_loadout_applied || !has_loadout)
		return
	if(!H.client)
		addtimer(CALLBACK(src, PROC_REF(choose_loadout), H), 50)
		return
	// 正式岗位与进阶职业都可能安排回调，同一份职业记录只授予一次。
	R.court_mage_loadout_applied = TRUE
	if(H.age == AGE_OLD)
		H.z121_birth_skill_floor(/datum/skill/magic/arcane, 6, TRUE)
		H.z121_birth_stat(STATKEY_SPD, -1)
		H.z121_birth_stat(STATKEY_INT, 1)
		H.z121_birth_stat(STATKEY_PER, 1)
		H.z121_birth_points(6)
		if(ishumannorthern(H))
			belt = /obj/item/storage/belt/rogue/leather/plaquegold
			cloak = null
			head = /obj/item/clothing/head/roguetown/wizhat
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/wizard
			R.court_voice_species = H.dna.species
			R.previous_court_voice = H.dna.species.soundpack_m
			R.court_voice = new /datum/voicepack/male/wizard()
			H.dna.species.soundpack_m = R.court_voice
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			H.z121_birth_trait(TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			H.z121_birth_trait(TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			H.z121_birth_trait(TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			H.z121_birth_trait(TRAIT_HERESIARCH, TRAIT_GENERIC)

/datum/advclass/boost_by_plus_power(plus_factor, mob/living/carbon/human/H)
	for(var/stat in MOBSTATS)
		H.z121_birth_stat(stat, plus_factor)

/mob/living/carbon/human/proc/z121_birth_stat(stat, amount)
	if(z121_profession)
		z121_profession.add_stat(src, stat, amount)
	else
		change_stat(stat, amount)

/mob/living/carbon/human/proc/z121_birth_skill_floor(skill, amount, silent = TRUE)
	if(z121_profession)
		z121_profession.add_skill(src, skill, amount, TRUE)
	else
		adjust_skillrank_up_to(skill, amount, silent)

/mob/living/carbon/human/proc/z121_birth_skill_add(skill, amount, silent = TRUE)
	if(z121_profession)
		z121_profession.add_skill(src, skill, amount)
	else
		adjust_skillrank(skill, amount, silent)

/mob/living/carbon/human/proc/z121_birth_trait(trait, source)
	if(z121_profession)
		z121_profession.add_trait(src, trait)
	else
		ADD_TRAIT(src, trait, source)

/mob/living/carbon/human/proc/z121_birth_spell(obj/effect/proc_holder/spell/S)
	mind?.AddSpell(S)
	z121_profession?.remember_spell(S)

/mob/living/carbon/human/proc/z121_birth_points(amount)
	if(!mind)
		return
	if(z121_profession)
		z121_profession.add_points(src, amount)
	else
		mind.adjust_spellpoints(amount)

/mob/living/carbon/human/proc/z121_birth_language(language)
	if(z121_profession)
		z121_profession.add_language(src, language)
	else
		grant_language(language)

/mob/living/carbon/human/proc/z121_birth_stash(key, path)
	mind.special_items[key] = path
	if(z121_profession)
		z121_profession.stash[key] = path

/mob/living/carbon/human/proc/z121_birth_devotion()
	if(!z121_profession)
		return new /datum/devotion(src, patron)
	if(devotion)
		// 已有虔诚不推断为职业所有；保存本次调用前的数值，装备完成后记差额。
		z121_profession.shared_devotion = devotion
		for(var/key in list("level", "max_devotion", "max_progression", "passive_devotion_gain", "passive_progression_gain"))
			z121_profession.devotion_delta[key] = devotion.vars[key]
		return devotion
	var/datum/devotion/D = new(src, patron)
	z121_profession.owned_devotion = D
	z121_profession.take_devotion_source(src)
	return D

/mob/living/carbon/human/proc/z121_birth_inspiration()
	if(!z121_profession)
		return new /datum/inspiration(src)
	if(inspiration)
		z121_profession.shared_inspiration = inspiration
		for(var/key in list("level", "maxaudience", "maxsongs", "maxrhythms"))
			z121_profession.inspiration_delta[key] = inspiration.vars[key]
		return inspiration
	z121_profession.owned_inspiration = new /datum/inspiration(src)
	z121_profession.add_trait(src, INSPIRING_MUSICIAN)
	REMOVE_TRAIT(src, INSPIRING_MUSICIAN, "inspiration")
	return z121_profession.owned_inspiration

/mob/living/carbon/human/proc/z121_birth_grant_devotion(datum/devotion/D, cleric_tier, passive_gain, devotion_limit)
	if(z121_profession?.shared_devotion == D)
		// 共用数据只能提高能力上限，不重置已有虔诚、进度或更高的神迹等级。
		D.level = max(D.level, cleric_tier)
		D.max_devotion = max(D.max_devotion, devotion_limit)
		D.max_progression = max(D.max_progression, devotion_limit)
		D.passive_devotion_gain = max(D.passive_devotion_gain, passive_gain)
		D.passive_progression_gain = max(D.passive_progression_gain, passive_gain)
		D.try_add_spells(TRUE)
		START_PROCESSING(SSobj, D)
		return
	D.grant_miracles(src, cleric_tier, passive_gain, devotion_limit)

/mob/living/carbon/human/proc/z121_birth_half_devotion(datum/devotion/D)
	D.max_devotion *= 0.5
	if(z121_profession?.shared_devotion == D)
		D.max_devotion = max(D.max_devotion, z121_profession.devotion_delta["max_devotion"])

/mob/living/carbon/human/proc/z121_birth_finish_systems(datum/z121_profession_record/R, list/before_verbs)
	R.added_verbs |= verbs - before_verbs
	if(R.shared_devotion == devotion)
		for(var/key in R.devotion_delta)
			R.devotion_delta[key] = devotion.vars[key] - R.devotion_delta[key]
	if(R.shared_inspiration == inspiration)
		for(var/key in R.inspiration_delta)
			R.inspiration_delta[key] = inspiration.vars[key] - R.inspiration_delta[key]
// 保证非职业来源的最低技能承诺不会因旧职业曾经超过它而丢失。
/mob/living/carbon/human/adjust_skillrank_up_to(skill, amount, silent = FALSE)
	if(z121_profession && !z121_profession.applying_skill)
		var/datum/skill/key = GetSkillRef(skill)
		z121_profession.settle_experience(key, ensure_skills().skill_experience[key])
		z121_profession.independent_experience[key] = max(z121_profession.independent_experience[key], z121_parallel_level_xp(amount))
		. = ..()
		z121_profession.observed_experience[key] = ensure_skills().skill_experience[key]
		return
	return ..()

/mob/living/carbon/human/adjust_skillrank(skill, amount, silent = FALSE)
	var/datum/skill/key = GetSkillRef(skill)
	var/before = z121_profession ? ensure_skills().skill_experience[key] : 0
	. = ..()
	z121_profession?.experience_settled(skill, before, ensure_skills().skill_experience[key])

// 美德会复用已有虔诚；记录实际授予时机，不从玩家当前预设倒推。
/datum/virtue/apply_generic_effects(mob/living/carbon/human/H)
	var/datum/z121_profession_record/R = H.z121_profession
	var/datum/devotion/faith = H.devotion
	var/was_owned = R && R.owned_devotion && faith == R.owned_devotion && istype(src, /datum/virtue/combat/devotee)
	var/list/old_values = list()
	if(was_owned)
		for(var/key in list("level", "max_devotion", "max_progression", "passive_devotion_gain", "passive_progression_gain"))
			old_values[key] = faith.vars[key]
	. = ..()
	if(. && H.z121_profession)
		H.z121_profession.permanent_virtues |= type
		if(istype(src, /datum/virtue/combat/magical_potential))
			H.z121_profession.keep_prestidigitation = TRUE
		// 明确的非职业藏匿物品取代同名职业记录，即使二者物品路径相同。
		for(var/key in added_stashed_items)
			H.z121_profession.stash -= key
	if(. && was_owned && H.devotion == faith)
		R.owned_devotion = null
		R.shared_devotion = faith
		R.devotion_delta = old_values
		R.devotion_delta["max_devotion"] = max(0, old_values["max_devotion"] - (CLERIC_REQ_1 - 10))
		R.devotion_delta["max_progression"] = max(0, old_values["max_progression"] - (CLERIC_REQ_1 - 10))
		R.added_verbs -= list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray)
		if(HAS_TRAIT_FROM(H, TRAIT_DEATHSIGHT, REF(R)))
			ADD_TRAIT(H, TRAIT_DEATHSIGHT, "devotion")
		for(var/datum/weakref/key as anything in R.spells.Copy())
			var/obj/effect/proc_holder/spell/S = key.resolve()
			if(S && (S.type in H.patron.miracles) && H.patron.miracles[S.type] <= CLERIC_T0)
				R.spells -= key
		for(var/trait in H.patron.traits_tier)
			if(H.patron.traits_tier[trait] <= CLERIC_T0)
				ADD_TRAIT(H, trait, TRAIT_MIRACLE)
