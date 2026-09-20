// 保留既有特性标识与接口名称，兼容其他模块对平行存在的引用。
#define TRAIT_MARTINS_MORNING "平行存在"

/datum/virtue/utility/martins_morning
	name = "平行存在（-23）"
	desc = "每天清晨，你沉睡片刻，再次醒来时，自己的职业已悄然改变。"
	custom_text = "仅限能够睡眠的角色。每天清晨沉睡30秒后更换合法的镇民或朝圣者职业及正式岗位。只回收有记录的职业能力和随身职业物品；私人财物落地，非职业能力与独立成长保留。来源不明的历史内容保留并提示。"
	triumph_cost = 23

/datum/virtue/utility/martins_morning/check_triumphs(mob/living/carbon/human/recipient)
	// 在扣费之前检查资格与重复授予，不能依靠退款补救。
	if(!istype(recipient) || QDELETED(recipient) || recipient.GetComponent(/datum/component/martins_morning))
		return FALSE
	if(HAS_TRAIT(recipient, TRAIT_NOSLEEP) || HAS_TRAIT(recipient, TRAIT_SLEEPIMMUNE))
		to_chat(recipient, span_warning("你无法入睡，不能获得平行存在；未扣除凯旋点。"))
		return FALSE
	return ..()

/datum/virtue/utility/martins_morning/apply_to_human(mob/living/carbon/human/recipient)
	if(istype(recipient) && !HAS_TRAIT(recipient, TRAIT_NOSLEEP) && !HAS_TRAIT(recipient, TRAIT_SLEEPIMMUNE))
		recipient.AddComponent(/datum/component/martins_morning)

/datum/component/martins_morning
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/phase = "idle"
	var/generation = 0
	var/last_day = -1
	var/timer_id
	var/datum/mind/session_mind
	var/datum/z121_profession_plan/pending
	var/datum/status_effect/incapacitating/sleeping/z121_parallel/sleep_effect
	var/history_warned = FALSE
	var/wake_time = 0

/datum/component/martins_morning/Initialize()
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/human/H = parent
	ADD_TRAIT(H, TRAIT_MARTINS_MORNING, TRAIT_MARTINS_MORNING)
	RegisterSignal(H, COMSIG_MOB_DAWNED, PROC_REF(on_dawned))
	RegisterSignal(H, list(COMSIG_LIVING_DEATH, COMSIG_MOB_LOGOUT, COMSIG_MIND_TRANSFER, COMSIG_QDELETING, SIGNAL_REMOVETRAIT(TRAIT_MARTINS_MORNING), SIGNAL_ADDTRAIT(TRAIT_NOSLEEP), SIGNAL_ADDTRAIT(TRAIT_SLEEPIMMUNE)), PROC_REF(on_invalidated))
	if(!H.z121_profession)
		H.z121_profession = new(H, null)
		H.z121_profession.unknown = TRUE

/datum/component/martins_morning/UnregisterFromParent()
	cancel_session()
	if(ishuman(parent))
		UnregisterSignal(parent, list(COMSIG_MOB_DAWNED, COMSIG_LIVING_DEATH, COMSIG_MOB_LOGOUT, COMSIG_MIND_TRANSFER, COMSIG_QDELETING, SIGNAL_REMOVETRAIT(TRAIT_MARTINS_MORNING), SIGNAL_ADDTRAIT(TRAIT_NOSLEEP), SIGNAL_ADDTRAIT(TRAIT_SLEEPIMMUNE)))
		REMOVE_TRAIT(parent, TRAIT_MARTINS_MORNING, TRAIT_MARTINS_MORNING)
	return ..()

/datum/component/martins_morning/proc/on_invalidated()
	SIGNAL_HANDLER
	cancel_session()

/datum/component/martins_morning/proc/cancel_session()
	generation++
	if(timer_id)
		deltimer(timer_id)
		timer_id = null
	if(pending)
		// 等待输入的过程自行释放草案；旧答案不得重新提交。
		pending.cancelled = TRUE
		pending = null
	if(sleep_effect)
		UnregisterSignal(sleep_effect, COMSIG_QDELETING)
		QDEL_NULL(sleep_effect)
	session_mind = null
	phase = "idle"

/datum/component/martins_morning/proc/on_dawned()
	SIGNAL_HANDLER
	if(last_day == GLOB.dayspassed)
		return
	cancel_session()
	var/mob/living/carbon/human/H = parent
	if(QDELETED(H) || !H.client || !H.mind || H.stat == DEAD || HAS_TRAIT(H, TRAIT_NOSLEEP) || HAS_TRAIT(H, TRAIT_SLEEPIMMUNE) || !HAS_TRAIT(H, TRAIT_MARTINS_MORNING))
		return
	last_day = GLOB.dayspassed
	if(SEND_SIGNAL(H, COMSIG_LIVING_STATUS_SLEEP, 30 SECONDS, TRUE, TRUE) & COMPONENT_NO_STUN)
		return
	phase = "sleeping"
	wake_time = world.time + 30 SECONDS
	session_mind = H.mind
	sleep_effect = H.apply_status_effect(/datum/status_effect/incapacitating/sleeping/z121_parallel, 30 SECONDS, TRUE)
	if(QDELETED(sleep_effect))
		cancel_session()
		return
	RegisterSignal(sleep_effect, COMSIG_QDELETING, PROC_REF(on_sleep_removed))
	to_chat(H, span_notice("你的意识沉入另一条人生。三十秒后，你将醒来……"))
	timer_id = addtimer(CALLBACK(src, PROC_REF(on_wake), generation), 30 SECONDS, TIMER_STOPPABLE)

/datum/component/martins_morning/proc/on_sleep_removed()
	SIGNAL_HANDLER
	sleep_effect = null
	if(world.time < wake_time)
		cancel_session()

/datum/component/martins_morning/proc/on_wake(token)
	timer_id = null
	if(token != generation)
		return
	var/mob/living/carbon/human/H = parent
	if(QDELETED(H) || H.stat == DEAD || !H.client || H.mind != session_mind || !HAS_TRAIT(H, TRAIT_MARTINS_MORNING))
		cancel_session()
		return
	QDEL_NULL(sleep_effect)
	// 仅结束自己的睡眠，药物及其他能力的睡眠继续生效。
	if(H.IsSleeping())
		phase = "waiting"
		timer_id = addtimer(CALLBACK(src, PROC_REF(on_wake), token), 1 SECONDS, TIMER_STOPPABLE)
		return
	begin_prepare(token)

/datum/component/martins_morning/proc/begin_prepare(token)
	set waitfor = FALSE
	var/mob/living/carbon/human/H = parent
	var/list/candidates = list()
	var/list/pool = list()
	pool |= SSrole_class_handler.sorted_class_categories[CTAG_TOWNER]
	pool |= SSrole_class_handler.sorted_class_categories[CTAG_PILGRIM]
	var/list/adapted = z121_parallel_outfits()
	for(var/datum/advclass/C as anything in pool)
		if(!(C.outfit in adapted) || C.name == H.advjob || !profession_compatible(H, C))
			continue
		var/datum/job/J = target_job(H, C)
		if(J)
			candidates[C] = J
	if(!length(candidates))
		to_chat(H, span_warning("今天没有符合资格且有空缺的职业，你仍是原来的自己。"))
		cancel_session()
		return
	var/datum/advclass/C = pick(candidates)
	var/datum/z121_profession_plan/P = new(src, C, candidates[C])
	pending = P
	phase = "preparing"
	if(H.z121_profession?.unknown && !history_warned)
		history_warned = TRUE
		to_chat(H, span_warning("部分历史能力与物品没有来源记录，将予以保留；明确记录的职业内容会正常回收。"))
	var/succeeded = FALSE
	try
		if(P.prepare() && token == generation && profession_compatible(H, C) && job_compatible(H, P.job))
			phase = "committing"
			succeeded = commit(P)
	catch(var/exception/error)
		log_game("平行存在异常：目标=[C.type]，阶段=[P.commit_stage]，位置=[error.file]:[error.line]，[error]")
		if(P.committed)
			succeeded = TRUE
			P.cleanup_failed = TRUE
	if(token == generation)
		if(P.committed && P.cleanup_failed)
			to_chat(H, span_warning("新职业已经生效，但收尾出现异常，部分物品或能力需要管理员核查；本次没有回退到旧职业。"))
		else if(P.rollback_failed)
			to_chat(H, span_warning("职业切换中断，恢复过程中出现异常；请联系管理员检查能力与装备，未能确认完整恢复。"))
		else if(!succeeded)
			to_chat(H, span_warning("这条人生没有成形，已保留你的原职业。"))
		pending = null
		cancel_session()
	qdel(P)

// 独立编号防止普通睡眠覆盖；睡眠查询仍能识别本美德。
/datum/status_effect/incapacitating/sleeping/z121_parallel
	id = "z121_parallel_sleep"

/mob/living/carbon/human/IsSleeping()
	return ..() || has_status_effect(/datum/status_effect/incapacitating/sleeping/z121_parallel)

/datum/component/martins_morning/proc/body_compatible(mob/living/carbon/human/H, datum/definition)
	if(!H.dna?.species)
		return FALSE
	var/list/sexes = definition.vars["allowed_sexes"]?.Copy()
	if(length(sexes) && !definition.vars["immune_to_genderswap"] && H.dna.species.gender_swapping)
		var/had_male = (MALE in sexes)
		var/had_female = (FEMALE in sexes)
		sexes -= list(MALE, FEMALE)
		if(had_male)
			sexes |= FEMALE
		if(had_female)
			sexes |= MALE
	if(length(sexes) && !(H.gender in sexes))
		return FALSE
	var/list/allowed = definition.vars["allowed_races"]
	var/list/denied = definition.vars["disallowed_races"]
	if(length(allowed) && !(H.dna.species.type in allowed))
		return FALSE
	if(H.dna.species.type in denied)
		return FALSE
	allowed = definition.vars["allowed_ages"]
	if(length(allowed) && !(H.age in allowed))
		return FALSE
	allowed = definition.vars["allowed_patrons"]
	if(length(allowed) && !(H.patron?.type in allowed))
		return FALSE
	var/datum/preferences/prefs = H.client?.prefs
	for(var/path in definition.vars["virtue_restrictions"])
		for(var/applied_type in H.z121_profession?.permanent_virtues)
			if(ispath(applied_type, path))
				return FALSE
		if(istype(prefs?.virtue, path) || istype(prefs?.virtuetwo, path))
			return FALSE
	for(var/path in definition.vars["vice_restrictions"])
		if(istype(H.charflaw, path))
			return FALSE
		for(var/i in 1 to 6)
			if(prefs && istype(prefs.vars["vice[i]"], path))
				return FALSE
	return TRUE

/datum/component/martins_morning/proc/profession_compatible(mob/living/carbon/human/H, datum/advclass/C)
	if(!H.client || !body_compatible(H, C) || is_banned_from(H.ckey, C.name))
		return FALSE
	if(C.maximum_possible_slots >= 0 && C.total_slots_occupied >= C.maximum_possible_slots)
		return FALSE
	#ifdef USES_PQ
	if(C.min_pq != -100 && get_playerquality(H.ckey) < C.min_pq)
		return FALSE
	#endif
	return TRUE

/datum/component/martins_morning/proc/job_compatible(mob/living/carbon/human/H, datum/job/J)
	if(!J || !H.client || !body_compatible(H, J) || is_banned_from(H.ckey, J.title))
		return FALSE
	if(H.job != J.title && J.total_positions >= 0 && J.current_positions >= J.total_positions)
		return FALSE
	if(!J.player_old_enough(H.client) || J.required_playtime_remaining(H.client))
		return FALSE
	#ifdef USES_PQ
	var/pq = get_playerquality(H.ckey)
	if(pq < J.min_pq || (!isnull(J.max_pq) && J.max_pq > 0 && pq > J.max_pq))
		return FALSE
	#endif
	return TRUE

/datum/component/martins_morning/proc/target_job(mob/living/carbon/human/H, datum/advclass/C)
	var/list/names = list()
	if(H.job == "Refugee" && (CTAG_PILGRIM in C.category_tags))
		names += "Refugee"
	if(CTAG_TOWNER in C.category_tags)
		names |= "Towner"
	if(CTAG_PILGRIM in C.category_tags)
		names |= "Refugee"
	for(var/title in names)
		var/datum/job/J = SSjob.GetJob(title)
		if(job_compatible(H, J))
			return J
	return null

/proc/register_martins_morning_trait()
	if(islist(GLOB.roguetraits))
		GLOB.roguetraits[TRAIT_MARTINS_MORNING] = span_info("每天清晨沉睡30秒，醒后随机更换有空缺的镇民或朝圣者职业及正式岗位。只回收可确认的职业能力和随身职业物品；私人财物落地，独立成长保留。")
