// 每份记录只拥有明确授予的内容；没有记录的历史能力绝不猜测删除。
/mob/living/carbon/human
	var/datum/z121_profession_record/z121_profession

/datum/z121_profession_record
	var/datum/weakref/body
	var/datum/mind/mind
	var/datum/advclass/profession
	var/datum/job/formal_job
	var/job_slot_owned = FALSE
	var/class_slot_owned = FALSE
	var/list/stats = list()
	var/list/experience = list()
	var/list/independent_experience = list()
	var/list/observed_experience = list()
	var/list/removed_experience = list()
	var/applying_skill = FALSE
	var/list/traits = list()
	var/list/languages = list()
	var/list/spells = list()
	var/list/items = list()
	var/list/stash = list()
	var/list/added_verbs = list()
	var/list/purchases = list()
	var/points = 0
	var/spent = 0
	var/unknown = FALSE
	var/suspended = FALSE
	var/capturing_birth = FALSE
	var/court_mage_loadout_applied = FALSE
	var/datum/species/court_voice_species
	var/datum/voicepack/previous_court_voice
	var/datum/voicepack/court_voice
	var/court_voice_removed = FALSE
	var/list/removed_stash = list()
	var/list/detached_spells = list()
	var/datum/devotion/owned_devotion
	var/datum/inspiration/owned_inspiration
	var/list/devotion_delta = list()
	var/datum/devotion/shared_devotion
	var/list/inspiration_delta = list()
	var/datum/inspiration/shared_inspiration
	var/list/bard_spells = list()
	var/keep_prestidigitation = FALSE
	var/list/permanent_virtues = list()

/datum/z121_profession_record/New(mob/living/carbon/human/H, datum/advclass/job_class)
	body = WEAKREF(H)
	mind = H.mind
	profession = job_class
	RegisterSignal(H, COMSIG_QDELETING, PROC_REF(on_body_deleted))

/datum/z121_profession_record/proc/on_body_deleted()
	SIGNAL_HANDLER
	qdel(src)

/datum/z121_profession_record/Destroy()
	body = null
	mind = null
	profession = null
	formal_job = null
	return ..()

/datum/z121_profession_record/proc/add_stat(mob/living/carbon/human/H, stat, amount)
	var/before = z121_parallel_stat_total(H, stat)
	H.change_stat(stat, amount)
	stats[stat] += z121_parallel_stat_total(H, stat) - before

/datum/z121_profession_record/proc/add_skill(mob/living/carbon/human/H, skill, amount, floor_only = FALSE)
	var/datum/skill_holder/holder = H.ensure_skills()
	var/datum/skill/key = GetSkillRef(skill)
	var/before = holder.skill_experience[key] || 0
	experience_settled(skill, before, before)
	applying_skill = TRUE
	if(floor_only)
		H.adjust_skillrank_up_to(skill, amount, TRUE)
	else
		H.adjust_skillrank(skill, amount, TRUE)
	applying_skill = FALSE
	experience[key] += (holder.skill_experience[key] || 0) - before
	observed_experience[key] = holder.skill_experience[key] || 0

/datum/z121_profession_record/proc/add_trait(mob/living/carbon/human/H, trait)
	if(trait in H.dna.species.banned_traits)
		return
	traits |= trait
	ADD_TRAIT(H, trait, REF(src))

/datum/z121_profession_record/proc/add_language(mob/living/carbon/human/H, language)
	languages |= language
	H.grant_language(language, source = REF(src))

/datum/z121_profession_record/proc/remember_spell(obj/effect/proc_holder/spell/S)
	if(!QDELETED(S))
		spells |= WEAKREF(S)

/datum/z121_profession_record/proc/remember_bard_spell(mob/living/carbon/human/H, obj/effect/proc_holder/spell/S, rhythm)
	if(owned_inspiration == H.inspiration)
		remember_spell(S)
		bard_spells[WEAKREF(S)] = rhythm
	else if(shared_inspiration && shared_inspiration == H.inspiration)
		var/base_limit = rhythm ? shared_inspiration.maxrhythms - inspiration_delta["maxrhythms"] : shared_inspiration.maxsongs - inspiration_delta["maxsongs"]
		var/bought = rhythm ? shared_inspiration.rhythmsbought : shared_inspiration.songsbought
		if(bought >= base_limit)
			remember_spell(S)
			bard_spells[WEAKREF(S)] = rhythm

/datum/z121_profession_record/proc/add_spell(mob/living/carbon/human/H, spell_type)
	// 已有同类能力由其他来源持有，职业不取得其删除权。
	if(H.mind.has_spell(spell_type, TRUE))
		return
	var/obj/effect/proc_holder/spell/S = new spell_type
	H.mind.AddSpell(S)
	remember_spell(S)

/datum/z121_profession_record/proc/add_points(mob/living/carbon/human/H, amount)
	var/list/before = H.mind.spell_list.Copy()
	H.mind.adjust_spellpoints(amount)
	points += amount
	for(var/obj/effect/proc_holder/spell/S as anything in H.mind.spell_list - before)
		remember_spell(S)

/datum/z121_profession_record/proc/register_purchase(obj/effect/proc_holder/spell/S, cost)
	if(suspended || cost <= 0)
		return
	reconcile_purchases()
	var/profession_cost = min(cost, max(0, points - spent))
	if(!profession_cost)
		return
	var/datum/weakref/key = WEAKREF(S)
	purchases[key] = list(profession_cost, cost)
	spent += profession_cost
	RegisterSignal(S, COMSIG_QDELETING, PROC_REF(on_purchased_spell_deleted))
	log_game("平行存在法术消费登记：法术=[S.type]，职业出资=[profession_cost]，总消费=[cost]")

/datum/z121_profession_record/proc/on_purchased_spell_deleted(datum/source)
	SIGNAL_HANDLER
	// 删除与主动退款共用一次结算；职业挂起时总账已经退款，不能再扣。
	// 删除信号发出时对象已标记删除，不能重新调用拒绝该状态的弱引用工厂。
	var/datum/weakref/key = source.weak_reference
	var/list/payment = purchases[key]
	if(payment)
		if(!suspended && mind && mind.used_spell_points >= payment[2])
			mind.used_spell_points -= payment[2]
		spent -= payment[1]
		purchases -= key

/datum/z121_profession_record/proc/reconcile_purchases()
	for(var/datum/weakref/key as anything in purchases.Copy())
		var/obj/effect/proc_holder/spell/S = key.resolve()
		if(!S || !(S in mind.spell_list))
			var/list/payment = purchases[key]
			if(!suspended && mind.used_spell_points >= payment[2])
				mind.used_spell_points -= payment[2]
			if(S)
				UnregisterSignal(S, COMSIG_QDELETING)
			spent -= payment[1]
			purchases -= key

/datum/z121_profession_record/proc/collect_system_spells(mob/living/carbon/human/H)
	if(owned_devotion && H.devotion == owned_devotion)
		for(var/obj/effect/proc_holder/spell/S as anything in owned_devotion.granted_spells)
			remember_spell(S)

/datum/z121_profession_record/proc/detach_spell(mob/living/carbon/human/H, obj/effect/proc_holder/spell/S)
	if(QDELETED(S) || !(S in H.mind.spell_list))
		return
	H.mind.spell_list -= S
	S.deactivate(H)
	S.action?.Remove(H)
	detached_spells |= WEAKREF(S)

/datum/z121_profession_record/proc/suspend(mob/living/carbon/human/H)
	if(suspended)
		return
	reconcile_purchases()
	collect_system_spells(H)
	suspended = TRUE
	if(court_voice && court_voice_species == H.dna?.species && court_voice_species.soundpack_m == court_voice)
		court_voice_species.soundpack_m = previous_court_voice
		court_voice_removed = TRUE
	if(shared_devotion && shared_devotion == H.devotion)
		var/remaining_tier = shared_devotion.level - devotion_delta["level"]
		for(var/trait in shared_devotion.patron.traits_tier)
			if(shared_devotion.patron.traits_tier[trait] <= remaining_tier)
				ADD_TRAIT(H, trait, TRAIT_MIRACLE)
	for(var/stat in stats)
		z121_parallel_stat_delta(H, stat, -stats[stat])
	var/datum/skill_holder/holder = H.ensure_skills()
	for(var/datum/skill/skill as anything in experience)
		// 已损失的经验不可再扣一次；保存实际移除值供失败恢复。
		var/total = holder.skill_experience[skill] || 0
		// 挂起标志只防止外部钩子重入，这里主动结算尚未经过入口的经验变化。
		settle_experience(skill, total)
		var/removed = max(0, total - (independent_experience[skill] || 0))
		removed_experience[skill] = removed
		holder.adjust_experience(skill, -removed, TRUE)
	for(var/trait in traits)
		REMOVE_TRAIT(H, trait, REF(src))
	for(var/language in languages)
		H.remove_language(language, source = REF(src))
	for(var/key in stash)
		if(H.mind.special_items[key] == stash[key])
			removed_stash[key] = stash[key]
			H.mind.special_items -= key
	H.verbs -= added_verbs
	for(var/datum/weakref/key as anything in purchases)
		var/obj/effect/proc_holder/spell/S = key.resolve()
		var/list/payment = purchases[key]
		detach_spell(H, S)
		H.mind.used_spell_points -= payment[2]
	H.mind.spell_points -= points
	for(var/datum/weakref/key as anything in spells)
		var/obj/effect/proc_holder/spell/S = key.resolve()
		if(S && shared_devotion && shared_devotion == H.devotion)
			if((S.type in shared_devotion.patron.miracles) && shared_devotion.patron.miracles[S.type] <= shared_devotion.level - devotion_delta["level"])
				continue
		// 点数共享派生能力只在没有其他资金来源时移除。
		if(S && (istype(S, /obj/effect/proc_holder/spell/self/learnspell) || istype(S, /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)))
			if(keep_prestidigitation && istype(S, /obj/effect/proc_holder/spell/targeted/touch/prestidigitation))
				continue
			if(H.mind.spell_points > 0 || H.mind.used_spell_points > 0)
				continue
		detach_spell(H, S)
	if(owned_devotion && H.devotion == owned_devotion)
		STOP_PROCESSING(SSobj, owned_devotion)
		H.devotion = null
		H.hud_used?.shutdown_bloodpool()
	if(owned_inspiration && H.inspiration == owned_inspiration)
		H.inspiration = null
	if(shared_devotion == H.devotion)
		for(var/key in devotion_delta)
			shared_devotion.vars[key] -= devotion_delta[key]
	if(shared_inspiration == H.inspiration)
		for(var/key in inspiration_delta)
			shared_inspiration.vars[key] -= inspiration_delta[key]
		for(var/datum/weakref/key as anything in bard_spells)
			if(key in detached_spells)
				if(bard_spells[key])
					shared_inspiration.rhythmsbought--
				else
					shared_inspiration.songsbought--

/datum/z121_profession_record/proc/resume(mob/living/carbon/human/H)
	if(!suspended)
		return
	suspended = FALSE
	if(court_voice_removed && court_voice_species == H.dna?.species && court_voice_species.soundpack_m == previous_court_voice)
		court_voice_species.soundpack_m = court_voice
	court_voice_removed = FALSE
	for(var/stat in stats)
		z121_parallel_stat_delta(H, stat, stats[stat])
	var/datum/skill_holder/holder = H.ensure_skills()
	for(var/datum/skill/skill as anything in experience)
		holder.adjust_experience(skill, removed_experience[skill], TRUE)
	for(var/trait in traits)
		ADD_TRAIT(H, trait, REF(src))
	for(var/language in languages)
		H.grant_language(language, source = REF(src))
	for(var/key in removed_stash)
		H.mind.special_items[key] = removed_stash[key]
	removed_stash.Cut()
	H.verbs |= added_verbs
	H.mind.spell_points += points
	for(var/datum/weakref/key as anything in purchases)
		var/list/payment = purchases[key]
		H.mind.used_spell_points += payment[2]
	for(var/datum/weakref/key as anything in detached_spells)
		var/obj/effect/proc_holder/spell/S = key.resolve()
		if(S && !(S in H.mind.spell_list))
			H.mind.AddSpell(S)
	if(owned_devotion)
		H.devotion = owned_devotion
		H.hud_used?.initialize_bloodpool()
		H.hud_used?.bloodpool?.set_fill_color("#3C41A4")
		START_PROCESSING(SSobj, owned_devotion)
	if(owned_inspiration)
		H.inspiration = owned_inspiration
	if(shared_devotion == H.devotion)
		for(var/key in devotion_delta)
			shared_devotion.vars[key] += devotion_delta[key]
	if(shared_inspiration == H.inspiration)
		for(var/key in inspiration_delta)
			shared_inspiration.vars[key] += inspiration_delta[key]
		for(var/datum/weakref/key as anything in bard_spells)
			if(key in detached_spells)
				if(bard_spells[key])
					shared_inspiration.rhythmsbought++
				else
					shared_inspiration.songsbought++
	detached_spells.Cut()

/datum/z121_profession_record/proc/dispose_suspended(mob/living/carbon/human/H)
	for(var/datum/weakref/key as anything in detached_spells)
		var/obj/effect/proc_holder/spell/S = key.resolve()
		if(S && !(S in H.mind.spell_list))
			qdel(S)
	// 旧数据的析构会清空宿主引用，先断开旧宿主，不能误清新职业的数据。
	if(owned_devotion)
		owned_devotion.holder = null
		QDEL_NULL(owned_devotion)
	if(owned_inspiration)
		owned_inspiration.holder = null
		QDEL_NULL(owned_inspiration)
	qdel(src)

// 草案只保存待应用的操作；准备窗口期间角色仍保持原职业状态。
/datum/z121_profession_plan
	var/datum/component/martins_morning/session
	var/mob/living/carbon/human/host
	var/datum/mind/original_mind
	var/token
	var/cancelled = FALSE
	// 岗位提交后不再宣称回滚成功，清理异常单独报告。
	var/committed = FALSE
	var/cleanup_failed = FALSE
	var/rollback_failed = FALSE
	var/commit_stage = "准备"
	var/datum/advclass/profession
	var/datum/job/job
	var/datum/outfit/outfit
	var/list/stats = list()
	var/list/skill_ops = list()
	var/list/traits = list()
	var/list/spell_types = list()
	var/list/stash = list()
	var/points = 0
	var/social_rank
	var/music
	var/cosmetic_title
	var/devotion_tier
	var/devotion_regen
	var/devotion_limit
	var/devotion_multiplier = 1
	var/bard_tier

/datum/z121_profession_plan/New(datum/component/martins_morning/component, datum/advclass/target, datum/job/target_job)
	session = component
	host = component.parent
	original_mind = host.mind
	token = component.generation
	profession = target
	job = target_job
	outfit = new target.outfit

/datum/z121_profession_plan/Destroy()
	QDEL_NULL(outfit)
	session = null
	host = null
	original_mind = null
	return ..()

/datum/z121_profession_plan/proc/valid()
	return !cancelled && !QDELETED(session) && !QDELETED(host) && session.generation == token && host.mind == original_mind && host.client && host.stat == CONSCIOUS && !host.IsSleeping() && HAS_TRAIT(host, TRAIT_MARTINS_MORNING)

/datum/z121_profession_plan/proc/choose(list/choices, message, title = "平行存在")
	if(!valid())
		cancelled = TRUE
		return
	var/result = tgui_input_list(host, message, title, choices)
	if(!valid() || isnull(result))
		cancelled = TRUE
		return
	return result

/datum/z121_profession_plan/proc/add_stat(stat, amount)
	stats[stat] += amount

/datum/z121_profession_plan/proc/skill_floor(skill, amount, silent)
	skill_ops += list(list(skill, amount, TRUE))

/datum/z121_profession_plan/proc/skill_add(skill, amount, silent)
	skill_ops += list(list(skill, amount, FALSE))

/datum/z121_profession_plan/proc/add_trait(trait)
	traits |= trait

/datum/z121_profession_plan/proc/add_spell(spell_type)
	spell_types |= spell_type

/datum/z121_profession_plan/proc/add_points(amount)
	points += amount

/datum/z121_profession_plan/proc/set_devotion(tier, regen, limit)
	devotion_tier = tier
	devotion_regen = regen
	devotion_limit = limit

/datum/outfit/proc/z121_prepare(mob/living/carbon/human/H, datum/z121_profession_plan/P)
	P.cancelled = TRUE

/datum/z121_profession_plan/proc/prepare()
	outfit.z121_prepare(host, src)
	return valid()

/datum/z121_profession_plan/proc/apply_abilities(datum/z121_profession_record/R)
	var/list/before_spells = host.mind.spell_list.Copy()
	var/list/before_verbs = host.verbs.Copy()
	for(var/stat in job.job_stats)
		R.add_stat(host, stat, job.job_stats[stat])
	for(var/stat in stats)
		R.add_stat(host, stat, stats[stat])
	for(var/stat in profession.subclass_stats)
		R.add_stat(host, stat, profession.subclass_stats[stat])
	for(var/list/op as anything in skill_ops)
		R.add_skill(host, op[1], op[2], op[3])
	for(var/skill in profession.subclass_skills)
		R.add_skill(host, skill, profession.subclass_skills[skill], TRUE)
	for(var/trait in traits | profession.traits_applied)
		R.add_trait(host, trait)
	for(var/language in profession.subclass_languages)
		R.add_language(host, language)
	for(var/path in spell_types)
		R.add_spell(host, path)
	for(var/path in job.spells)
		R.add_spell(host, path)
	if(points + profession.subclass_spellpoints > 0)
		R.add_points(host, points + profession.subclass_spellpoints)
	for(var/key in profession.subclass_stashed_items)
		// 不覆盖同名的私人装载物。
		if(!host.mind.special_items[key])
			host.mind.special_items[key] = profession.subclass_stashed_items[key]
			R.stash[key] = profession.subclass_stashed_items[key]
	for(var/key in stash)
		if(!host.mind.special_items[key])
			host.mind.special_items[key] = stash[key]
			R.stash[key] = stash[key]
	if(devotion_tier)
		if(!host.devotion)
			R.owned_devotion = new /datum/devotion(host, host.patron)
			var/datum/devotion/D = R.owned_devotion
			R.take_devotion_source(host)
			D.grant_miracles(host, devotion_tier, devotion_regen, devotion_limit)
			D.max_devotion *= devotion_multiplier
		else
			// 已有非职业虔诚只增加职业需要的上限，不替换原对象与进度。
			R.shared_devotion = host.devotion
			var/list/floors = list("level" = devotion_tier, "max_devotion" = devotion_limit * devotion_multiplier, "max_progression" = devotion_limit, "passive_devotion_gain" = devotion_regen, "passive_progression_gain" = devotion_regen)
			for(var/key in floors)
				var/delta = max(0, floors[key] - host.devotion.vars[key])
				R.devotion_delta[key] = delta
				host.devotion.vars[key] += delta
			host.devotion.try_add_spells(TRUE)
			START_PROCESSING(SSobj, host.devotion)
	if(bard_tier)
		if(!host.inspiration)
			R.owned_inspiration = new /datum/inspiration(host)
			R.add_trait(host, INSPIRING_MUSICIAN)
			REMOVE_TRAIT(host, INSPIRING_MUSICIAN, "inspiration")
			R.owned_inspiration.grant_inspiration(host, bard_tier)
		else
			R.shared_inspiration = host.inspiration
			var/list/floors = list("level" = bard_tier, "maxaudience" = 2 * bard_tier, "maxsongs" = bard_tier + 2, "maxrhythms" = bard_tier)
			for(var/key in floors)
				var/delta = max(0, floors[key] - host.inspiration.vars[key])
				R.inspiration_delta[key] = delta
				host.inspiration.vars[key] += delta
			if(bard_tier >= BARD_T2)
				if(!host.inspiration.rhythm_tracker)
					host.inspiration.rhythm_tracker = new
				host.verbs |= list(/mob/living/carbon/human/proc/pickrhythms, /mob/living/carbon/human/proc/resetrhythms)
			if(bard_tier >= BARD_T3)
				R.add_spell(host, /obj/effect/proc_holder/spell/self/crescendo)
			host.verbs |= list(/mob/living/carbon/human/proc/setaudience, /mob/living/carbon/human/proc/clearaudience, /mob/living/carbon/human/proc/checkaudience, /mob/living/carbon/human/proc/picksongs, /mob/living/carbon/human/proc/resetsongs)
	R.added_verbs |= host.verbs - before_verbs
	for(var/obj/effect/proc_holder/spell/S as anything in host.mind.spell_list - before_spells)
		R.remember_spell(S)

/datum/z121_profession_record/proc/take_devotion_source(mob/living/carbon/human/H)
	if(HAS_TRAIT_FROM(H, TRAIT_DEATHSIGHT, "devotion"))
		add_trait(H, TRAIT_DEATHSIGHT)
		REMOVE_TRAIT(H, TRAIT_DEATHSIGHT, "devotion")

/datum/z121_profession_record/proc/owns_miracle_tier(datum/devotion/D, tier)
	if(owned_devotion == D)
		return TRUE
	if(shared_devotion == D)
		var/base_tier = capturing_birth ? devotion_delta["level"] : D.level - devotion_delta["level"]
		return tier > base_tier
	return FALSE

/datum/z121_profession_record/proc/remember_miracle(datum/devotion/D, obj/effect/proc_holder/spell/S, tier)
	if(owns_miracle_tier(D, tier))
		remember_spell(S)
// 学习入口仅调用此记录接口，不改变界面或权限验证。
/proc/z121_parallel_purchase(mob/living/user, obj/effect/proc_holder/spell/S, cost)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.z121_profession?.register_purchase(S, cost)

/proc/z121_parallel_level_xp(level)
	switch(level)
		if(SKILL_LEVEL_NOVICE)
			return SKILL_EXP_NOVICE + 1
		if(SKILL_LEVEL_APPRENTICE)
			return SKILL_EXP_APPRENTICE
		if(SKILL_LEVEL_JOURNEYMAN)
			return SKILL_EXP_JOURNEYMAN
		if(SKILL_LEVEL_EXPERT)
			return SKILL_EXP_EXPERT
		if(SKILL_LEVEL_MASTER)
			return SKILL_EXP_MASTER
		if(SKILL_LEVEL_LEGENDARY)
			return SKILL_EXP_LEGENDARY
	return 0

// 实际属性包含显示值与溢出缓冲；回收直接结算总量，避免旧缓冲再次放大变化。
/proc/z121_parallel_stat_fields(stat)
	switch(stat)
		if(STATKEY_STR)
			return list("STASTR", "BUFSTR")
		if(STATKEY_PER)
			return list("STAPER", "BUFPER")
		if(STATKEY_INT)
			return list("STAINT", "BUFINT")
		if(STATKEY_CON)
			return list("STACON", "BUFCON")
		if(STATKEY_WIL)
			return list("STAWIL", "BUFEND")
		if(STATKEY_SPD)
			return list("STASPD", "BUFSPE")
		if(STATKEY_LCK)
			return list("STALUC", "BUFLUC")

/proc/z121_parallel_stat_total(mob/living/carbon/human/H, stat)
	var/list/fields = z121_parallel_stat_fields(stat)
	return fields ? H.vars[fields[1]] + H.vars[fields[2]] : 0

/proc/z121_parallel_stat_delta(mob/living/carbon/human/H, stat, amount)
	var/list/fields = z121_parallel_stat_fields(stat)
	if(!fields || !amount)
		return
	var/total = z121_parallel_stat_total(H, stat) + amount
	H.vars[fields[1]] = clamp(total, 1, 20)
	H.vars[fields[2]] = total - H.vars[fields[1]]
	if(stat == STATKEY_PER)
		H.see_override = initial(H.see_invisible) + (H.STAPER / 3.25)
		H.update_sight()
		H.update_fov_angles()
	if(stat == STATKEY_SPD)
		H.update_move_intent_slowdown()

/datum/z121_profession_record/proc/experience_settled(skill, before, after)
	if(applying_skill || suspended)
		return
	var/datum/skill/key = GetSkillRef(skill)
	settle_experience(key, before)
	settle_experience(key, after)

/datum/z121_profession_record/proc/settle_experience(datum/skill/key, total)
	if(!(key in observed_experience))
		independent_experience[key] = total
		observed_experience[key] = total
		return
	var/delta = total - observed_experience[key]
	if(delta > 0)
		independent_experience[key] += delta
	else if(delta < 0)
		// 惩罚先消耗职业部分，剩余损失再记入独立经验；不会在离职时重复扣除。
		var/career_available = max(0, observed_experience[key] - independent_experience[key])
		independent_experience[key] = max(0, independent_experience[key] - max(0, -delta - career_available))
	observed_experience[key] = total
