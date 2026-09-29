// modular_z121 自定义奥术法术：摄神取念（Legilimency）
// ---------------------------------------------------------------------------
// 设计目标：一个 T3 控制类法术。激活法术 -> 框架蓄力 2 秒 -> 点击选定一名“他人”
//           目标（沿用 flight.dm 的点选方式）-> 目标进行“意志（Willpower）对抗”
//           检定来抵抗施法者的精神侵入；若目标对抗失败，则其暂时丧失对自己身体
//           的控制权，转而由“施法者”接管并操纵该身体；持续时间结束后，双方各自
//           回到自己原本的身体。
//
// 选取/蓄力方式：完全沿用 flight.dm 的做法——以 /spell/invoked 为基类，靠点击
//           选取目标（targets[1]），蓄力由基类 InterceptClickOn 依据 chargetime
//           校验完成；点选阶段施法者可随时取消（移开/点空），不会强制施放。
//
// 约束：所有代码都只存在于 modular_z121 内，仅“调用”主线已有机制
//       （mob.get_stat / anti_magic_check / datum/mind.transfer_to / ghostize /
//        status_effect 框架），不修改 modular_z121 之外的任何文件。
//       “接管身体”复用主线 transfer_to 的灵魂转移接口（resurrect.dm / eora.dm
//        等多处已验证可用），这里只是把它包装成“限时占据、到期归还”。
//
// 注册方式（均在 modular_z121 内）：
//   1) modular_z121/_load.dm            -> #include 本文件
//   2) modular_z121/spells/_registry.dm -> 加入 custom_learnable_spells 列表
// ---------------------------------------------------------------------------

// ===== 可调参数（文件末尾统一 #undef，避免污染全局命名空间）=====
#define LEGILIMENCY_MANA_COST     6             // 法力 / 法术点消耗（cost）
#define LEGILIMENCY_CHANNEL_TIME  (2 SECONDS)   // 蓄力时长（由 invoked 基类的点击拦截按 chargetime 校验）
#define LEGILIMENCY_COOLDOWN      (1 MINUTES)   // 成功施放后的冷却（1 分钟）
#define LEGILIMENCY_RESOURCE_COST 15            // “额外资源消耗”：每次施放抽取的疲劳/耐力（releasedrain），强力控制法术故偏高
#define LEGILIMENCY_TARGET_RANGE  7             // 点击选取目标的最大距离（range）

// 施法者“接管中”用的临时特性标记：占据期间挂在施法者“原身”上，
// 用于防止施法者在一次摄神取念尚未结束时再次施放（避免灵魂转移逻辑叠加错乱）。
// 每次状态效果用 REF(src) 作为来源，清理时不会移除其他来源的失能。
#define TRAIT_LEGILIMENCY_CASTER  "legilimency_casting"

// ===========================================================================
// 法术本体
// ---------------------------------------------------------------------------
// 选用 /spell/invoked 作为基类（与 flight.dm 一致）：点击图标后进入“点选目标”模式，
// 蓄力满后点击某个生物即对其生效。本法术只对“他人”有意义（不能摄取自己），
// 故在 cast() 中显式拒绝把自己当作目标。
// ===========================================================================
/obj/effect/proc_holder/spell/invoked/legilimency
	name = "摄神取念"
	desc = "一道侵入心神的高阶法术。以纯粹的意志撬开目标的心防，若对方的意志不足以抵抗，其身体便会暂时落入我的掌控；持续时间随我的奥术造诣而延长。"
	school = "enchantment"
	spell_tier = 4                              // T4 法术
	cost = LEGILIMENCY_MANA_COST                // “法力 / 法术点”消耗 = 6
	releasedrain = LEGILIMENCY_RESOURCE_COST    // “额外资源消耗”= 15（施法时抽取的疲劳/耐力）
	chargetime = LEGILIMENCY_CHANNEL_TIME       // 蓄力 2 秒（基类点击拦截会校验是否蓄满）
	recharge_time = LEGILIMENCY_COOLDOWN        // 冷却 = 1 分钟（由 charge_check 强制执行）
	cooldown_min = LEGILIMENCY_COOLDOWN         // 即便被“加速”，冷却也不会低于 1 分钟
	human_req = TRUE                            // 只有人类施法者能施放
	warnie = "spellwarning"
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "Legilimency"               // 动作按钮图标态（对应 custompell.dmi 中的 Legilimency 贴图）
	invocations = list("现出你的心神来!")        // 咒文（成功施放时由框架喊出）
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	no_early_release = TRUE                      // 未蓄满不允许提前释放
	movement_interrupt = FALSE                  // 与 flight.dm 一致：蓄力期间可移动
	charging_slowdown = 1                        // 蓄力时略微减速
	chargedloop = /datum/looping_sound/invokegen // 蓄力期间循环施法音效
	associated_skill = /datum/skill/magic/arcane // 时长缩放所依据的技能：奥术
	gesture_required = TRUE                      // 需要能自由活动的手
	range = LEGILIMENCY_TARGET_RANGE            // 点选目标的最大距离
	miracle = FALSE
	xp_gain = TRUE
	sound = null                                // 蓄力音由 chargedloop 负责；命中音效在 cast 内单独播放

// ---------------------------------------------------------------------------
// 时长缩放表：根据“施法者”的奥术技能等级，返回接管身体的持续时间（单位：游戏刻）。
// 规格表：L1→5s，L2→10s，L3→20s，L4→40s，L5→80s，L6→160s（逐级翻倍）。
// 用 clamp(1,6) 处理越界：0 级（未入门）按 1 级算，>6 级按 6 级（160s）封顶，
// 满足“超出范围时就近钳制”的要求。把它独立成一个 proc，便于单独调参与复用。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/legilimency/proc/get_duration_for_skill(skill_level)
	switch(clamp(skill_level, 1, 6))
		if(1)
			return 5 SECONDS
		if(2)
			return 10 SECONDS
		if(3)
			return 20 SECONDS
		if(4)
			return 40 SECONDS
		if(5)
			return 80 SECONDS
		if(6)
			return 160 SECONDS
	// 理论上 clamp 后必落入 1~6，这里仅作兜底，返回最低档时长。
	return 5 SECONDS

// ---------------------------------------------------------------------------
// 意志对抗检定：返回 TRUE 表示“施法者压制成功”（目标对抗失败，将被接管），
//               返回 FALSE 表示“目标抵抗成功”（精神侵入被弹开）。
// 设计：施法者一方的“精神强度”= 意志属性 + 奥术技能等级 + 一个随机扰动；
//       目标一方的“抵抗强度”   = 意志属性 + 一个随机扰动。
//       加入随机扰动是为了让势均力敌时双方都有机会，而非纯数值碾压。
// 独立成 proc，便于日后单独调整数值平衡。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/legilimency/proc/win_willpower_contest(mob/living/user, mob/living/target)
	// 施法者的奥术造诣会直接转化为精神侵蚀力，故计入压制方。
	var/caster_skill = user.get_skill_level(associated_skill)
	// 双方各自取“意志”属性作为对抗基础；get_stat 是主线统一的属性读取接口。
	var/caster_power = user.get_stat(STAT_WILLPOWER) + caster_skill + rand(1, 6)
	var/target_power = target.get_stat(STAT_WILLPOWER) + rand(1, 6)
	// 平局判给目标（抵抗方），即“必须严格压过对方意志”才能接管，体现侵入的难度。
	return caster_power > target_power

// ---------------------------------------------------------------------------
// cast：点击命中目标后由基类 InterceptClickOn -> perform 调用。
// targets[1] 即施法者点中的目标。
// 返回值约定：
//   - TRUE  -> perform() 调用 start_recharge()，进入 1 分钟冷却（法术已生效/已耗出）。
//   - FALSE -> 调用 revert_cast() 退还冷却（目标无效 / 点到自己 / 被反魔法挡下 等）。
// 注意：当“目标抵抗成功”时，法术其实已经施放出去了（魔力已消耗），因此返回 TRUE 让
//       其正常进入冷却，仅仅是没有夺取到控制权——这与“对抗检定”的设定一致。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/legilimency/cast(list/targets, mob/living/user = usr)
	// --- 取目标并做基础合法性校验 ---
	var/atom/target_atom = targets[1]
	// 点击式选取：targets[1] 必须是活物，否则视为无效目标并退还冷却。
	if(!isliving(target_atom))
		to_chat(user, span_warning("摄神取念只能施加在活物的心神之上。"))
		revert_cast()
		return FALSE

	var/mob/living/target = target_atom

	// 不能对自己施放：摄取自己的心念没有意义，且会让灵魂转移逻辑自指出错。
	if(target == user)
		to_chat(user, span_warning("我无法摄取自己的心念。"))
		revert_cast()
		return FALSE

	// 目标必须还活着：对一具尸体没有“心神”可夺，直接判无效。
	if(target.stat == DEAD)
		to_chat(user, span_warning("[target] 已无心神可夺——死者的身体不会再听我号令。"))
		revert_cast()
		return FALSE

	// 施法者必须有客户端（是个真正的玩家）：只有真人施法者才能把“控制权”转移到他人身体上。
	if(!user.client)
		revert_cast()
		return FALSE

	// 防重入：禁止“在仍占据他人身体时再次施放摄神取念”，否则会形成“傀儡操纵傀儡”的链式占据，
	// 令灵魂归还时的身体/心智引用彼此错乱（A→占据 B，再从 B 占据 C……，到期归还顺序无法自洽）。
	// 需要同时拦住两种入口，因为施法成功后 transfer_to 会把法术按钮一并搬进被占据的身体（transfer_actions），
	// 施法者完全可以“从傀儡身体里”再点一次本法术——而此时 user 是傀儡身体、并非施法者原身：
	//   情形①：user 是施法者“原身”，且原身仍挂着接管标记（理论上原身在被占据期间没有客户端、
	//           无法发起施法，这里作为冗余保险一并检查）。
	//   情形②：user 是“正被本法术占据中的身体”（身上挂着 legilimency_control 状态）——驱动这具
	//           身体的正是施法者本人，必须禁止其再次施放。这是真正能堵住链式占据的关键判断。
	if(user.legilimency_session || user.mind?.legilimency_session || HAS_TRAIT(user, TRAIT_LEGILIMENCY_CASTER) || user.has_status_effect(/datum/status_effect/legilimency_control))
		to_chat(user, span_warning("我的心神仍寄居在他人体内，无法再发动一次摄神取念。"))
		revert_cast()
		return FALSE

	// 反魔法检定：被反魔法保护的目标无法被精神侵入。
	if(target.anti_magic_check())
		target.visible_message(
			span_warning("[target] 周身泛起反魔法的涟漪，将那股侵入心神的魔力挡了下来。"),
			span_notice("一股外来的意志试图钻入我的脑海，却被我身上的反魔法弹开了。")
		)
		to_chat(user, span_warning("[target] 身上的反魔法抵消了『摄神取念』。"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		revert_cast()
		return FALSE

	// 两具身体及双方心智均不能参与另一场接管，包括已经离魂的施法者原身。
	if(target.legilimency_session || target.mind?.legilimency_session || HAS_TRAIT(target, TRAIT_LEGILIMENCY_CASTER) || target.has_status_effect(/datum/status_effect/legilimency_control))
		to_chat(user, span_warning("[target] 的心神已被另一股意志所占据，我无从插足。"))
		revert_cast()
		return FALSE

	// --- 意志对抗检定 ---
	// 这是法术的核心：目标用意志抵抗施法者的精神压制。
	if(!win_willpower_contest(user, target))
		// 目标抵抗成功：精神侵入被弹开，不夺取控制权，但魔力已耗出，故照常进入冷却（返回 TRUE）。
		target.visible_message(
			span_warning("[target] 猛地一震，仿佛奋力甩开了什么无形的东西。"),
			span_green("一股冰冷的意志试图攫住我的心神，但我咬紧牙关，把它逐了出去！")
		)
		to_chat(user, span_warning("[target] 的意志比我预想的更坚韧，我的心神侵入被狠狠弹开了。"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 70)
		return TRUE

	// --- 目标对抗失败：施法者接管其身体 ---
	// 时长取决于“施法者”的奥术技能等级（不是目标的）。
	var/caster_skill = user.get_skill_level(associated_skill)
	var/effect_duration = get_duration_for_skill(caster_skill)

	// 重要顺序说明：apply_status_effect 会“同步”执行状态效果的 on_apply，而 on_apply 内部会
	// 立即把施法者的客户端搬入目标身体。一旦搬走，再对 user 发消息就送不到玩家了（玩家已在目标体内）。
	// 因此把面向施法者的提示音与时长告知放在接管“之前”发出。
	playsound(get_turf(target), 'sound/magic/whiteflame.ogg', 70, TRUE)
	to_chat(user, span_info("此次『摄神取念』可维持 [effect_duration / 10] 秒（取决于我的奥术造诣）。"))

	// 把计算好的时长与“施法者引用”一并传给状态效果。
	// apply_status_effect(effect, custom_duration, caster) 会把这两个参数转发给 on_creation()，
	// 由状态效果在 on_apply() 中完成真正的灵魂转移，并在到期/移除时归还身体。
	target.apply_status_effect(/datum/status_effect/legilimency_control, effect_duration, user)

	// 防御性校验：确认接管状态确实挂上了，否则视为失败并退还冷却。
	// （on_apply 内部若发现任何前置条件不满足会返回 FALSE，从而让状态效果自删；此时灵魂尚未转移，
	//   user 仍在自己体内，故下面对 user 的提示与 revert_cast 都能正常生效。）
	if(!target.has_status_effect(/datum/status_effect/legilimency_control))
		to_chat(user, span_warning("精神的桥梁未能架起——什么也没发生。"))
		revert_cast()
		return FALSE

	return TRUE

// 一次接管同时登记双方身体和心智；外部转移完成后结束旧关系，不能抢回已经转移的心智。
/mob/living
	var/datum/status_effect/legilimency_control/legilimency_session

/datum/mind
	var/datum/status_effect/legilimency_control/legilimency_session
	// 原身被毁后暂存技能，观察者再次获得身体时恢复。
	var/datum/skill_holder/legilimency_saved_skills

/datum/mind/transfer_to(mob/new_character, force_key_move = FALSE)
	var/list/sessions = list()
	if(legilimency_session && !legilimency_session.internal_transfer)
		sessions |= legilimency_session
	if(isliving(new_character))
		var/mob/living/destination = new_character
		if(destination.legilimency_session && !destination.legilimency_session.internal_transfer)
			sessions |= destination.legilimency_session
	. = ..()
	if(!QDELETED(legilimency_saved_skills) && !QDELETED(current) && current.mind == src)
		legilimency_saved_skills.set_current(current)
		legilimency_saved_skills = null
	for(var/datum/status_effect/legilimency_control/session as anything in sessions)
		if(!QDELETED(session))
			qdel(session)

/datum/mind/Destroy()
	QDEL_NULL(legilimency_saved_skills)
	return ..()

/datum/status_effect/legilimency_control
	id = "legilimency_control"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 5 SECONDS
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/legilimency_control
	var/mob/living/caster_body
	var/mob/living/target_body
	var/datum/mind/caster_mind
	var/datum/mind/victim_mind
	var/datum/skill_holder/caster_skills
	var/datum/skill_holder/victim_skills
	var/datum/player_card/target_card
	var/internal_transfer = FALSE
	var/started = FALSE
	var/cleaning_up = FALSE

/datum/status_effect/legilimency_control/on_creation(mob/living/new_owner, custom_duration, mob/living/caster)
	if(isnum(custom_duration) && custom_duration > 0)
		duration = custom_duration
	caster_body = caster
	return ..()

/datum/status_effect/legilimency_control/on_apply()
	if(!..() || QDELETED(caster_body) || !caster_body.client)
		return FALSE
	if(QDELETED(caster_body) || QDELETED(owner) || owner == caster_body || owner.stat == DEAD)
		return FALSE
	if(QDELETED(caster_body.mind) || caster_body.mind.current != caster_body)
		return FALSE
	if(caster_body.legilimency_session || caster_body.mind.legilimency_session || owner.legilimency_session || owner.mind?.legilimency_session)
		return FALSE
	if(HAS_TRAIT(caster_body, TRAIT_LEGILIMENCY_CASTER) || HAS_TRAIT(owner, TRAIT_LEGILIMENCY_CASTER))
		return FALSE

	target_body = owner
	caster_mind = caster_body.mind
	victim_mind = owner.mind
	caster_skills = caster_body.ensure_skills()
	victim_skills = owner.skills

	// transfer_to 不会保存被挤出者的资料。先刷新其资料卡，并另存身体快照以覆盖无心智 NPC。
	if(ishuman(target_body))
		var/mob/living/carbon/human/human_target = target_body
		target_card = new
		target_card.capture_from(human_target)
		if(victim_mind && !human_target.is_shapeshift_shell())
			if(!victim_mind.player_card)
				victim_mind.player_card = new
			victim_mind.player_card.capture_from(human_target)

	// 先摘除被害者技能的迁移监听，避免它随施法者离开目标身体。
	if(victim_skills)
		victim_skills.set_current(null)
		target_body.skills = null
	caster_body.legilimency_session = src
	target_body.legilimency_session = src
	caster_mind.legilimency_session = src
	if(victim_mind)
		victim_mind.legilimency_session = src
	started = TRUE
	RegisterSignal(caster_body, COMSIG_QDELETING, PROC_REF(participant_deleted))
	RegisterSignal(target_body, COMSIG_QDELETING, PROC_REF(participant_deleted))
	RegisterSignal(caster_mind, COMSIG_QDELETING, PROC_REF(participant_deleted))
	if(victim_mind)
		RegisterSignal(victim_mind, COMSIG_QDELETING, PROC_REF(participant_deleted))

	// 独立来源的昏迷只属于本次接管，不调用 SetSleeping，也不受普通睡眠免疫影响。
	ADD_TRAIT(caster_body, TRAIT_LEGILIMENCY_CASTER, REF(src))
	ADD_TRAIT(caster_body, TRAIT_DEATHCOMA, REF(src))
	caster_body.update_stat()
	caster_body.update_mobility()
	to_chat(target_body, span_userdanger("一股冰冷而强大的意志攫住了你，把你硬生生挤出了自己的身体！"))
	internal_transfer = TRUE
	caster_mind.transfer_to(target_body, TRUE)
	internal_transfer = FALSE
	if(QDELETED(src))
		return FALSE
	playsound(get_turf(target_body), 'sound/magic/soulsteal.ogg', 60, TRUE)
	to_chat(target_body, span_boldwarning("我的意志钻入了这具身体，夺过了它的掌控权。"))
	return TRUE

/datum/status_effect/legilimency_control/proc/participant_deleted(datum/source)
	SIGNAL_HANDLER
	if(!cleaning_up)
		qdel(src)

// 也处理管理员直接更换引用等未经过 transfer_to 的情况。
/datum/status_effect/legilimency_control/tick()
	if(QDELETED(caster_body) || QDELETED(caster_mind) || caster_mind.current != target_body || target_body.mind != caster_mind || caster_body.mind || (victim_mind && victim_mind.current))
		qdel(src)

// 只移除本次保存的技能引用；归属跟随心智实际所在身体，不按开场身体强行复位。
/datum/status_effect/legilimency_control/proc/restore_skills(datum/skill_holder/holder, datum/mind/recipient, mob/living/npc_body)
	if(QDELETED(holder))
		return
	holder.set_current(null)
	if(caster_body?.skills == holder)
		caster_body.skills = null
	if(target_body?.skills == holder)
		target_body.skills = null
	if(!QDELETED(recipient))
		if(!QDELETED(recipient.current) && recipient.current.mind == recipient)
			holder.set_current(recipient.current)
		else
			recipient.legilimency_saved_skills = holder
	else if(!QDELETED(npc_body) && !npc_body.mind && !npc_body.key)
		holder.set_current(npc_body)
	else
		qdel(holder)

/datum/status_effect/legilimency_control/on_remove()
	if(cleaning_up)
		return
	cleaning_up = TRUE
	internal_transfer = TRUE
	if(started)
		for(var/datum/participant as anything in list(caster_body, target_body, caster_mind, victim_mind))
			if(participant)
				UnregisterSignal(participant, COMSIG_QDELETING)
		if(caster_body?.legilimency_session == src)
			caster_body.legilimency_session = null
		if(target_body?.legilimency_session == src)
			target_body.legilimency_session = null
		if(caster_mind?.legilimency_session == src)
			caster_mind.legilimency_session = null
		if(victim_mind?.legilimency_session == src)
			victim_mind.legilimency_session = null

		// 仅归还仍由本次接管控制的心智，绝不挤走原身中的第三者。
		if(!QDELETED(caster_mind) && caster_mind.current == target_body && target_body?.mind == caster_mind)
			if(!QDELETED(caster_body) && !caster_body.mind && !caster_body.key)
				caster_mind.transfer_to(caster_body, TRUE)
				to_chat(caster_body, span_notice("维系傀儡的魔力消散了，我的意志回到了自己的躯体。"))
			else
				// 原身消失或被外部机制占用：退出 NPC/目标，保留观察者的心智及技能。
				var/mob/dead/observer/ghost = target_body.ghostize(FALSE)
				// 尸体的僵尸复起限制可能拒绝 ghostize；销毁归还不能把客户端遗留在傀儡里。
				if(!ghost && target_body.key)
					ghost = new /mob/dead/observer/rogue/nodraw(target_body)
					ghost.can_reenter_corpse = FALSE
					ghost.key = target_body.key
				target_body.mind = null
				caster_mind.set_current(null)

		// 在被害者 Login 之前移走施法者技能，避免登录回调暂时读到错误的技能数据。
		restore_skills(caster_skills, caster_mind)
		if(!QDELETED(victim_mind) && !victim_mind.current && !QDELETED(target_body) && !target_body.mind && !target_body.key)
			if(!QDELETED(victim_skills))
				victim_skills.set_current(target_body)
			victim_mind.transfer_to(target_body, TRUE)
			to_chat(target_body, span_notice("束缚我的意志骤然松脱，我重新夺回了身体的掌控。"))

		restore_skills(victim_skills, victim_mind, victim_mind ? null : target_body)
		// 有第三者进入目标身体时尊重其资料；其余分支还原被暂时覆盖的身体资料。
		if(target_card && !QDELETED(target_body) && (!target_body.mind || target_body.mind == victim_mind))
			target_card.apply_card_to(target_body)
		if(!QDELETED(caster_body))
			REMOVE_TRAIT(caster_body, TRAIT_LEGILIMENCY_CASTER, REF(src))
			REMOVE_TRAIT(caster_body, TRAIT_DEATHCOMA, REF(src))
			caster_body.update_stat()
			caster_body.update_mobility()
		if(!QDELETED(target_body) && !victim_mind && !target_body.client)
			target_body.set_ssd_indicator(FALSE)

	QDEL_NULL(target_card)
	caster_mind = null
	victim_mind = null
	caster_skills = null
	victim_skills = null
	caster_body = null
	target_body = null
	return ..()

/atom/movable/screen/alert/status_effect/legilimency_control
	name = "摄神取念"
	desc = "一股外来的意志正在控制这具身体。"
	icon_state = "debuff"

#undef LEGILIMENCY_MANA_COST
#undef LEGILIMENCY_CHANNEL_TIME
#undef LEGILIMENCY_COOLDOWN
#undef LEGILIMENCY_RESOURCE_COST
#undef LEGILIMENCY_TARGET_RANGE
#undef TRAIT_LEGILIMENCY_CASTER
