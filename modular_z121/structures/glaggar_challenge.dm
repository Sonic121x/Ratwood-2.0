// ============================================================================
// 格拉加尔的凝视（Glaggar's Glance）—— 恐怖之钟的高难度挑战模式
// ----------------------------------------------------------------------------
// 本文件实现一个完整的“波次竞技场”挑战：玩家在恐怖之钟上选择该选项后，
//   1) 30 秒准备期，期间不断响起恐怖之声；
//   2) 准备期结束时，钟周围 6 格内随机挑选 3 名玩家成为“挑战者”；
//   3) 用不可摧毁的壁垒把竞技场围起来，并把非挑战者传送到教堂；
//   4) 依次刷出四波怪物：首波由 30 秒准备期触发，此后每波间隔 2 分钟；
//      每一波都会从该波的“预设池”中随机抽取一支敌人队伍刷出；
//   5) 通关后存活的挑战者获得“格拉加尔的奖励”（+2 力量 +2 速度）；
//   6) 挑战期间闯入场内的非挑战者将被诅咒并传走；离场者永久失去本次资格。
//
// 设计约束：所有自定义内容仅允许放在 modular_z121 下；本任务要求注释使用中文。
// 之所以用“轮询（polling）”而非信号来判定波次清空，是因为本仓库里
// COMSIG_LIVING_ATTACKED_BY 等攻击信号实际上并未被发出，轮询最稳健、最不易出错。
// ============================================================================

// --- 可调常量（集中放在文件顶部，便于平衡性调整）-----------------------------
// 准备期时长：选择挑战后到第一波刷新之间的缓冲时间。
#define GLAGGAR_PREP_TIME (30 SECONDS)
// 每一波被清空后，到下一波刷新之间的间隔时间。
// 注意：第一波由准备期（GLAGGAR_PREP_TIME=30 秒）触发；从第二波起，每波间隔为 2 分钟。
#define GLAGGAR_WAVE_DELAY (2 MINUTES)
// 竞技场半径（切比雪夫距离）：壁垒环建在该半径上，恰好把“无建筑净空区”围住。
// 与恐怖之钟的净空检测半径（TERROR_CLOCK_CLEAR_RANGE）保持一致，均为 6。
#define GLAGGAR_ARENA_RADIUS 6
// 怪物刷新半径：怪物只会出现在钟周围这个较小的范围内，保证它们在场地中央。
#define GLAGGAR_SPAWN_RADIUS 5
// 挑战者人数：准备期结束时最多标记这么多名玩家。
#define GLAGGAR_CHALLENGER_COUNT 3
// 主控制循环的轮询间隔：用于检测波次清空、干涉者、挑战者存活情况等。
#define GLAGGAR_TICK_INTERVAL (1 SECONDS)
// 挑战阶段的状态机取值。
#define GLAGGAR_PHASE_PREP 1          // 准备期
#define GLAGGAR_PHASE_FIGHT 2         // 战斗中（当前波怪物存活）
#define GLAGGAR_PHASE_INTERMISSION 3  // 波次间隙（等待下一波刷新）
#define GLAGGAR_PHASE_DONE 4          // 已结束（胜利/失败/中止），不再轮询
// 所有挑战怪物共用的阵营标签：用它来区分“召唤怪”与“干涉的玩家”，并避免怪物互殴。
#define GLAGGAR_FACTION "glaggar"

// ============================================================================
// 不可摧毁的竞技场壁垒
// 用临时生成的实体结构（而非改 turf）来围场，好处是结束时直接 qdel 即可完整还原，
// 不会破坏地图原有的地块数据。
// ============================================================================
/obj/structure/glaggar_barrier
	name = "格拉加尔的壁垒"
	desc = "一道由不祥之力凝成的栅栏，坚不可摧，将挑战者困在格拉加尔的目光之下。"
	// 复用现成的铁栅栏贴图，避免引入新资源；该 icon/state 在本仓库确实存在。
	icon = 'icons/roguetown/misc/gate.dmi'
	icon_state = "bar1"
	// 阻挡移动 + 视线 + 投射物：dense+opacity 能挡住近战进入与远程攻击穿透。
	density = TRUE
	opacity = TRUE
	anchored = TRUE
	// INDESTRUCTIBLE 让 /obj/structure 的受伤逻辑直接跳过，从根本上无法被破坏。
	resistance_flags = INDESTRUCTIBLE
	// 画在高层，避免被地面贴图盖住。
	layer = ABOVE_MOB_LAYER

// 显式拦截一切移动者：虽然 density=TRUE 默认就会让 CanPass 返回假，但部分怪物可能
// 带有 pass_flags 或特殊穿越逻辑。这里强制返回 FALSE，确保任何召唤怪/玩家都无法
// 穿过壁垒，彻底杜绝“怪物穿墙”的问题。
/obj/structure/glaggar_barrier/CanPass(atom/movable/mover, turf/target)
	return FALSE

// ============================================================================
// 状态效果：格拉加尔的奖励（通关奖励）
// 永久生效，+2 力量 +2 速度；玩家“查看”该效果（悬停状态图标）会看到奖励说明。
// ============================================================================
/datum/status_effect/glaggar_reward
	id = "glaggar_reward"
	// duration = -1 表示永久，不会自动消失。
	duration = -1
	// 不需要每 tick 处理，省去无谓的处理开销。
	needs_processing = FALSE
	// effectedstats 会被状态效果基类在 on_apply/on_remove 时自动加/减，无需手写 change_stat。
	effectedstats = list(STATKEY_STR = 2, STATKEY_SPD = 2)
	// 关联一个自定义警报图标，作为玩家可“查看”的功能入口。
	alert_type = /atom/movable/screen/alert/status_effect/glaggar_reward

// 奖励效果对应的 HUD 警报：name/desc 即玩家查看时显示的文案。
/atom/movable/screen/alert/status_effect/glaggar_reward
	name = "格拉加尔的奖励"
	// 这段 desc 就是需求中“查看该功能时会提示”的内容。
	desc = "你为格拉加尔献上了精彩的杀戮，这是你的奖励。"

// ============================================================================
// 状态效果：格拉加尔的诅咒（惩罚干涉者）
// 持续一段时间，周期性造成伤害并削弱属性，提醒玩家“不要插手挑战”。
// ============================================================================
/datum/status_effect/glaggar_curse
	id = "glaggar_curse"
	// 持续 60 秒后自动消失。
	duration = 60 SECONDS
	// 每 3 秒结算一次伤害。
	tick_interval = 3 SECONDS
	// 削弱属性：诅咒期间 -2 力量 -2 速度（基类会在结束时自动恢复）。
	effectedstats = list(STATKEY_STR = -2, STATKEY_SPD = -2)
	alert_type = /atom/movable/screen/alert/status_effect/glaggar_curse

// 诅咒效果对应的 HUD 警报文案。
/atom/movable/screen/alert/status_effect/glaggar_curse
	name = "格拉加尔的诅咒"
	desc = "你干涉了格拉加尔的试炼，神祇的目光正灼烧着你的灵魂。"

// 诅咒每个 tick 的实际效果：持续灼烧伤害 + 偶尔的痛苦提示。
/datum/status_effect/glaggar_curse/tick()
	// owner 可能在诅咒期间被删除/已死，做空值与状态校验后再施加伤害。
	if(QDELETED(owner) || owner.stat == DEAD)
		return
	// 同时造成灼烧与钝击伤害，模拟“被神祇之力惩罚”的效果。
	owner.adjustFireLoss(8)
	owner.adjustBruteLoss(4)
	// 给受诅咒者一个明确的反馈，强化“别再插手”的信号。
	to_chat(owner, span_danger("格拉加尔的诅咒撕扯着你！"))

// ============================================================================
// 挑战主控制器
// 每一次“格拉加尔的凝视”都会创建一个该 datum 实例，负责整场挑战的生命周期。
// ============================================================================
/datum/glaggar_challenge
	// 触发挑战的恐怖之钟（竞技场中心物体）。
	var/obj/structure/terror_clock/clock
	// 竞技场中心地块（即钟所在地块），缓存下来便于反复做范围计算。
	var/turf/center
	// 挑战锁定的楼层；正式开战后还要求挑战者始终位于壁垒内侧。
	var/z_level = 0
	// 当前阶段（见上面的 GLAGGAR_PHASE_* 状态机）。
	var/phase = GLAGGAR_PHASE_PREP
	// 当前是第几波（1~4），0 表示尚未开始。
	var/current_wave = 0
	// 当前波次仍然“在场”的怪物引用列表，用于判断本波是否被清空。
	var/list/current_wave_mobs = list()
	// 独立保留本场全部召唤记录，供失败、中止和直接销毁时清理。
	var/list/spawned_mobs = list()
	// 曾被玩家接管的召唤体永不作为普通怪物删除。
	var/list/player_owned_mobs = list()
	// 避免传送失败时每秒重复提示，但仍会在每次轮询重试。
	var/list/failed_evictions = list()
	// 本场挑战的挑战者（玩家 mob）列表。
	var/list/challengers = list()
	// 已生成的壁垒结构列表，结束时统一清除以还原场地。
	var/list/barriers = list()
	// 四波怪物的定义（在 New 中填充）：每一波是一个 (类型 = 数量) 的关联列表。
	var/list/waves = list()
	// 防重入标志：避免在一波刚清空的同一瞬间被重复判定为“通关本波”。
	var/advancing = FALSE

// 构造时填充四波怪物的数据。
// 数据结构为三层：waves[波号] = 该波的“预设池”（多支队伍），每支队伍是一个
// (类型 = 数量) 的关联列表。每波开战时会从对应预设池里随机抽取一支队伍刷出，
// 因此同一波每次挑战的敌人组合都可能不同，增加变数。
/datum/glaggar_challenge/New()
	..()
	waves = list(
		// 第一波预设池（随机选一支）：
		list(
			list(/mob/living/simple_animal/hostile/rogue/skeleton/axe = 4),     // 4 斧骷髅
			list(/mob/living/simple_animal/hostile/rogue/skeleton/spear = 4),   // 4 矛骷髅
			list(/mob/living/simple_animal/hostile/rogue/skeleton/guard = 4),   // 4 卫骷髅
			list(/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 4),   // 4 恶狼
			list(/mob/living/carbon/human/species/goblin/npc = 4),             // 4 哥布林
		),
		// 第二波预设池（随机选一支）：
		list(
			// 2 兽人劫掠者 + 2 兽人蹂躏者
			list(
				/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder = 2,
				/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder/ravager = 2,
			),
			list(/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound = 4), // 4 地狱犬
			list(/mob/living/carbon/human/species/human/northern/highwayman = 4),           // 4 拦路强盗
		),
		// 第三波预设池（随机选一支）：
		list(
			list(/mob/living/simple_animal/hostile/retaliate/rogue/troll/axe = 4),  // 4 持斧巨魔
			list(/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 4),   // 4 巨熊
			list(/mob/living/simple_animal/hostile/retaliate/rogue/lamia = 4),      // 4 拉弥亚
		),
		// 第四波预设池（随机选一支）：
		list(
			list(/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/ambush = 4),          // 4 蜥蜴人狱卒
			list(/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter = 4), // 4 疯狂寻宝者
			list(/mob/living/carbon/human/species/human/northern/deranged_knight = 4),             // 4 癫狂骑士
			list(/mob/living/carbon/human/species/elf/dark/drowraider = 4),                        // 4 卓尔劫掠者
		),
	)

// 直接销毁控制器也必须停止流程，并先清理怪物再拆除壁垒。
/datum/glaggar_challenge/Destroy()
	phase = GLAGGAR_PHASE_DONE
	release_arena()
	clock = null
	center = null
	challengers.Cut()
	failed_evictions.Cut()
	return ..()

/datum/glaggar_challenge/proc/start(obj/structure/terror_clock/source, mob/living/user)
	clock = source
	center = get_turf(clock)
	if(QDELETED(clock) || clock.obj_broken || !center)
		if(!QDELETED(user))
			to_chat(user, span_warning("此处无法举行格拉加尔的试炼。"))
		qdel(src)
		return FALSE
	z_level = center.z
	phase = GLAGGAR_PHASE_PREP
	clock.visible_message(span_danger("[clock]剧烈震颤，空气骤然冰冷——格拉加尔的目光正在降临……"))
	for(var/i in 0 to 4)
		addtimer(CALLBACK(src, PROC_REF(play_dread_sound)), i * 6 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(finish_prep)), GLAGGAR_PREP_TIME)
	addtimer(CALLBACK(src, PROC_REF(controller_tick)), GLAGGAR_TICK_INTERVAL)
	return TRUE

/datum/glaggar_challenge/proc/play_dread_sound()
	if(QDELETED(src) || phase != GLAGGAR_PHASE_PREP || !center)
		return
	playsound(center, pick('sound/misc/evilevent.ogg', 'sound/misc/demon_attack1.ogg', 'sound/misc/astratascream.ogg'), 100, FALSE, extrarange = 14)

// 先完成安全安置和驱逐，全部成功后才生成壁垒与怪物。
/datum/glaggar_challenge/proc/finish_prep()
	if(QDELETED(src) || phase != GLAGGAR_PHASE_PREP)
		return
	if(QDELETED(clock) || clock.obj_broken)
		abort_challenge("仪式的载体被摧毁了。")
		return
	// 准备期结束时复查整片地面，避免在新出现的悬空场地封场。
	var/ground_error = terror_clock_ground_error(center)
	if(ground_error)
		abort_challenge(ground_error)
		return
	if(!mark_challengers())
		abort_challenge("格拉加尔在周围找不到任何值得注视的灵魂。")
		return
	if(!place_challengers())
		abort_challenge("内场没有足够的安全位置安置挑战者。")
		return
	if(!teleport_non_challengers())
		abort_challenge("教堂没有足够的安全落点，无法驱逐非挑战者。")
		return
	erect_barriers()
	start_wave(1)

// 保留原有六格选人范围；外环玩家会在封场之前移入内侧。
/datum/glaggar_challenge/proc/mark_challengers()
	var/list/candidates = list()
	for(var/mob/living/carbon/human/H in range(GLAGGAR_ARENA_RADIUS, center))
		if(H.ckey && H.stat != DEAD)
			candidates += H
	if(!length(candidates))
		return FALSE
	candidates = shuffle(candidates)
	for(var/mob/living/carbon/human/H in candidates)
		if(length(challengers) >= GLAGGAR_CHALLENGER_COUNT)
			break
		challengers += H
		to_chat(H, span_danger("格拉加尔的目光落在了你身上——你成为了挑战者！正式开战后离开壁垒内侧将永久失去本次资格。"))
	return TRUE

// 先为全部需要移动的挑战者预留位置，避免空位不足时只安置一部分人。
/datum/glaggar_challenge/proc/place_challengers()
	var/list/available = get_spawn_turfs()
	var/list/destinations = list()
	for(var/mob/living/C in challengers)
		if(QDELETED(C))
			return FALSE
		if(is_inside_arena(C) && isturf(C.loc) && terror_clock_safe_turf(get_turf(C), C))
			continue
		var/turf/destination = terror_clock_take_safe_turf(available)
		if(!destination)
			return FALSE
		destinations[C] = destination
	for(var/mob/living/C in destinations)
		var/turf/destination = destinations[C]
		if(QDELETED(C) || !terror_clock_safe_turf(destination))
			return FALSE
		C.forceMove(destination)
		if(get_turf(C) != destination)
			return FALSE
	return TRUE

/datum/glaggar_challenge/proc/erect_barriers()
	for(var/turf/T in range(GLAGGAR_ARENA_RADIUS, center))
		if(get_dist(center, T) != GLAGGAR_ARENA_RADIUS || !isopenturf(T))
			continue
		var/obj/structure/glaggar_barrier/B = new(T)
		barriers += B

/datum/glaggar_challenge/proc/remove_barriers()
	for(var/obj/structure/glaggar_barrier/B in barriers)
		if(!QDELETED(B))
			qdel(B)
	barriers.Cut()

// 开场驱逐同样先预留全部落点；实际传送每个人之前仍会重新验证占用。
/datum/glaggar_challenge/proc/teleport_non_challengers()
	var/list/destinations = list()
	var/list/reserved = list()
	for(var/mob/living/L in range(GLAGGAR_ARENA_RADIUS, center))
		if(!L.ckey || (L in challengers))
			continue
		var/turf/church = get_church_turf(reserved)
		if(!church)
			return FALSE
		reserved += church
		destinations[L] = church
	for(var/mob/living/L in destinations)
		if(QDELETED(L))
			continue
		var/turf/church = destinations[L]
		if(!terror_clock_safe_turf(church))
			return FALSE
		L.forceMove(church)
		if(get_turf(L) != church)
			return FALSE
		to_chat(L, span_warning("一股无形之力将你逐出了格拉加尔的试炼之地。"))
	return TRUE

// 每波必须完整生成；失效或重复的定时回调不得重启已结束的试炼。
/datum/glaggar_challenge/proc/start_wave(wave_index)
	if(QDELETED(src) || phase == GLAGGAR_PHASE_DONE)
		return
	if(wave_index != current_wave + 1 || wave_index < 1 || wave_index > length(waves))
		return
	if((wave_index == 1 && phase != GLAGGAR_PHASE_PREP) || (wave_index > 1 && phase != GLAGGAR_PHASE_INTERMISSION))
		return
	if(QDELETED(clock) || clock.obj_broken)
		abort_challenge("仪式的载体被摧毁了。")
		return
	// 波次间隙也可能发生地形变化；场地不完整时取消后续波次并按原逻辑清理。
	var/ground_error = terror_clock_ground_error(center)
	if(ground_error)
		abort_challenge(ground_error)
		return
	disqualify_absent_challengers()
	if(!has_living_challenger())
		fail_challenge()
		return
	var/list/wave_presets = waves[wave_index]
	if(!islist(wave_presets) || !length(wave_presets))
		abort_challenge("本波的怪物预设缺失，试炼无法继续。")
		return
	var/list/this_wave = pick(wave_presets)
	var/required_count = 0
	for(var/mob_type in this_wave)
		required_count += this_wave[mob_type]
	var/list/spawn_turfs = get_spawn_turfs()
	if(length(spawn_turfs) < required_count)
		abort_challenge("没有足够的安全空地放置完整一波怪物，试炼无法进行。")
		return
	current_wave = wave_index
	phase = GLAGGAR_PHASE_FIGHT
	advancing = FALSE
	current_wave_mobs.Cut()
	for(var/mob_type in this_wave)
		var/count = this_wave[mob_type]
		for(var/i in 1 to count)
			var/turf/target = terror_clock_take_safe_turf(spawn_turfs)
			if(!target)
				abort_challenge("刷新位置已被占用，无法生成完整一波怪物。")
				return
			var/mob/living/M = new mob_type(target)
			if(QDELETED(M))
				abort_challenge("怪物生成失败，试炼中止。")
				return
			// 先登记再配置；后续发生中止时也能清理已生成的部分怪物。
			spawned_mobs += M
			RegisterSignal(M, COMSIG_MOB_LOGIN, PROC_REF(protect_player_mob))
			if(M.key || (M.mind && M.mind.key))
				player_owned_mobs |= M
			M.faction = list(GLAGGAR_FACTION)
			terror_clock_awaken_mob(M)
			current_wave_mobs += M
	clock.visible_message(span_danger("第[current_wave]波降临了！"))

// 记录玩家接管历史，防止玩家随后离线或离体后被收尾逻辑误删。
/datum/glaggar_challenge/proc/protect_player_mob(mob/living/source)
	SIGNAL_HANDLER
	player_owned_mobs |= source

/datum/glaggar_challenge/proc/controller_tick()
	if(QDELETED(src) || phase == GLAGGAR_PHASE_DONE)
		return
	if(QDELETED(clock) || clock.obj_broken)
		abort_challenge("仪式的载体被摧毁了，试炼戛然而止。")
		return
	if(phase == GLAGGAR_PHASE_PREP)
		addtimer(CALLBACK(src, PROC_REF(controller_tick)), GLAGGAR_TICK_INTERVAL)
		return
	prune_wave_mobs()
	disqualify_absent_challengers()
	if(!has_living_challenger())
		fail_challenge()
		return
	sweep_interferers()
	if(phase == GLAGGAR_PHASE_FIGHT && !length(current_wave_mobs) && !advancing)
		advancing = TRUE
		if(current_wave >= length(waves))
			victory()
			return
		phase = GLAGGAR_PHASE_INTERMISSION
		clock.visible_message(span_danger("怪物的嘶吼渐息……但更可怕的存在正在逼近。"))
		addtimer(CALLBACK(src, PROC_REF(start_wave), current_wave + 1), GLAGGAR_WAVE_DELAY)
	addtimer(CALLBACK(src, PROC_REF(controller_tick)), GLAGGAR_TICK_INTERVAL)

// 死亡或删除只影响波次计数，不丢弃独立的本场召唤记录。
/datum/glaggar_challenge/proc/prune_wave_mobs()
	for(var/mob/living/M in current_wave_mobs.Copy())
		if(QDELETED(M) || M.stat == DEAD)
			current_wave_mobs -= M

// 外环本身不属于内场；楼层比较在距离判断前完成。
/datum/glaggar_challenge/proc/is_inside_arena(atom/A)
	var/turf/T = get_turf(A)
	return center && T && T.z == z_level && get_dist(center, T) < GLAGGAR_ARENA_RADIUS

// 从资格列表永久移除离场者，返回场地也不会重新入选。
/datum/glaggar_challenge/proc/disqualify_absent_challengers()
	for(var/mob/living/C in challengers.Copy())
		if(QDELETED(C))
			challengers -= C
			continue
		if(!is_inside_arena(C))
			challengers -= C
			to_chat(C, span_warning("你离开了竞技场，已永久失去本次试炼资格。"))

/datum/glaggar_challenge/proc/has_living_challenger()
	for(var/mob/living/C in challengers)
		if(!QDELETED(C) && C.stat != DEAD && is_inside_arena(C))
			return TRUE
	return FALSE

/datum/glaggar_challenge/proc/sweep_interferers()
	for(var/mob/living/L in range(GLAGGAR_ARENA_RADIUS, center))
		if(!L.ckey || (L in challengers) || (L in spawned_mobs))
			continue
		curse_interferer(L)

// 无安全落点时保留诅咒并等待下一次轮询，不使用危险位置作为退路。
/datum/glaggar_challenge/proc/curse_interferer(mob/living/L)
	if(!L.has_status_effect(/datum/status_effect/glaggar_curse))
		L.apply_status_effect(/datum/status_effect/glaggar_curse)
		to_chat(L, span_danger("你胆敢干涉格拉加尔的试炼——诅咒降临于你！"))
	var/turf/church = get_church_turf()
	if(church && terror_clock_safe_turf(church))
		L.forceMove(church)
		if(get_turf(L) == church)
			failed_evictions -= L
			return
	if(!(L in failed_evictions))
		failed_evictions += L
		to_chat(L, span_warning("教堂暂时没有可用的安全落点，驱逐失败；诅咒仍然生效，稍后将再次尝试传送。"))

// 奖励仅发给仍有资格、存活且位于内场的挑战者。
/datum/glaggar_challenge/proc/victory()
	if(QDELETED(src) || phase == GLAGGAR_PHASE_DONE)
		return
	disqualify_absent_challengers()
	if(!has_living_challenger())
		fail_challenge()
		return
	phase = GLAGGAR_PHASE_DONE
	if(!QDELETED(clock))
		clock.visible_message(span_danger("[clock]发出满足的轰鸣——格拉加尔的试炼已被征服！"))
	for(var/mob/living/C in challengers)
		if(QDELETED(C) || C.stat == DEAD || !is_inside_arena(C))
			continue
		C.apply_status_effect(/datum/status_effect/glaggar_reward)
		to_chat(C, span_danger("你在格拉加尔的注视下幸存——它的恩赐已铭刻于你的血肉。"))
	cleanup()

/datum/glaggar_challenge/proc/fail_challenge()
	phase = GLAGGAR_PHASE_DONE
	if(!QDELETED(clock))
		clock.visible_message(span_danger("再无挑战者伫立——格拉加尔失望地移开了目光。"))
	cleanup()

/datum/glaggar_challenge/proc/abort_challenge(reason)
	phase = GLAGGAR_PHASE_DONE
	if(!QDELETED(clock))
		clock.visible_message(span_warning("格拉加尔的试炼中断了：[reason]"))
	cleanup()

// 收尾可重复调用；只处理本场登记的存活且没有玩家归属的怪物。
/datum/glaggar_challenge/proc/release_arena()
	for(var/mob/living/M in spawned_mobs)
		if(QDELETED(M))
			continue
		UnregisterSignal(M, COMSIG_MOB_LOGIN)
		if(M.stat == DEAD || M.key || (M.mind && M.mind.key) || (M in player_owned_mobs))
			continue
		qdel(M)
	spawned_mobs.Cut()
	player_owned_mobs.Cut()
	current_wave_mobs.Cut()
	remove_barriers()
	if(!QDELETED(clock) && clock.active_challenge == src)
		clock.active_challenge = null

/datum/glaggar_challenge/proc/cleanup()
	phase = GLAGGAR_PHASE_DONE
	release_arena()
	qdel(src)

/datum/glaggar_challenge/proc/get_spawn_turfs()
	var/list/valid = list()
	for(var/turf/T in range(GLAGGAR_SPAWN_RADIUS, center))
		if(T != center && terror_clock_safe_turf(T))
			valid += T
	return valid

// 保留礼拜堂优先、整个教堂其次的查找顺序；预留地块不可重复使用。
/datum/glaggar_challenge/proc/get_church_turf(list/reserved)
	var/turf/found = pick_church_turf_in(/area/rogue/indoors/town/church/chapel, reserved)
	if(found)
		return found
	return pick_church_turf_in(/area/rogue/indoors/town/church, reserved)

/datum/glaggar_challenge/proc/pick_church_turf_in(areatype, list/reserved)
	var/list/turfs = get_area_turfs(areatype, 0, TRUE)
	var/list/safe = list()
	for(var/turf/T in turfs)
		if(reserved && (T in reserved))
			continue
		// 钟即使建在教堂区域，也不能把人驱逐回竞技场或壁垒外环。
		if(center && T.z == z_level && get_dist(center, T) <= GLAGGAR_ARENA_RADIUS)
			continue
		if(terror_clock_safe_turf(T))
			safe += T
	return terror_clock_take_safe_turf(safe)

// --- 清理文件内的局部宏，避免泄漏到全局命名空间 ------------------------------
#undef GLAGGAR_PREP_TIME
#undef GLAGGAR_WAVE_DELAY
#undef GLAGGAR_ARENA_RADIUS
#undef GLAGGAR_SPAWN_RADIUS
#undef GLAGGAR_CHALLENGER_COUNT
#undef GLAGGAR_TICK_INTERVAL
#undef GLAGGAR_PHASE_PREP
#undef GLAGGAR_PHASE_FIGHT
#undef GLAGGAR_PHASE_INTERMISSION
#undef GLAGGAR_PHASE_DONE
#undef GLAGGAR_FACTION
