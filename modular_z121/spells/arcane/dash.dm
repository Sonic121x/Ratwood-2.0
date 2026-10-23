// 冲刺术借用原生奔跑入口，只改变步进间隔并免除奔跑步进疲劳。
/obj/effect/proc_holder/spell/invoked/dash
	name = "冲刺术"
	desc = "一个有趣的小法术，发明它的法师只是为了在跑步比赛中赢下冠军"
	school = "transmutation"
	cost = 2
	spell_tier = 2
	releasedrain = 15
	chargedrain = 0
	chargetime = 1
	recharge_time = 10 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	gesture_required = TRUE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	xp_gain = TRUE
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "dash"
	invocations = list("疾风助我！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

/obj/effect/proc_holder/spell/invoked/dash/invocation(mob/user = usr)
	if(QDELETED(user))
		return
	var/datum/language/chant_language = user.get_default_language()
	if(invocation_type != "shout" || GLOB.language_datum_instances[chant_language])
		return ..()
	if(!length(invocations))
		return
	// 测试角色可能没有默认语言；显式使用通用语，避免发言流程读取空语言而中断。
	// 仍经正常发言流程处理禁言、口部限制、语言效果与聊天显示，且只吟唱一次。
	user.say(pick(invocations), language = /datum/language/common, forced = "spell")

/obj/effect/proc_holder/spell/invoked/dash/cast(list/targets, mob/user = usr)
	var/turf/target = length(targets) ? get_turf(targets[1]) : null
	var/turf/start = get_turf(user)
	if(!ishuman(user) || !target || !start || target == start || target.z != start.z)
		to_chat(user, span_warning("我需要指定同一层上另一个位置的方向。"))
		revert_cast(user)
		return FALSE
	var/mob/living/carbon/human/runner = user
	if(runner.z121_dash || !runner.z121_can_dash())
		to_chat(user, span_warning("我现在无法发起冲刺。"))
		revert_cast(user)
		return FALSE
	var/old_intent = runner.m_intent
	var/dash_dir = get_dir(start, target)
	if(runner.dir != dash_dir)
		runner.sprinted_tiles = 0
	runner.setDir(dash_dir)
	runner.toggle_rogmove_intent(MOVE_INTENT_RUN, TRUE)
	if(runner.m_intent != MOVE_INTENT_RUN)
		to_chat(user, span_warning("我现在无法奔跑。"))
		revert_cast(user)
		return FALSE
	new /datum/z121_dash_session(runner, dash_dir, old_intent)
	runner.visible_message(span_notice("[runner]脚下疾风涌起，向前冲刺！"), span_notice("疾风托起我的脚步！"))
	return TRUE

/mob/living/carbon/human
	var/datum/z121_dash_session/z121_dash

// 与原生奔跑准入一致，同时避免把冲刺转交给坐骑、遥控对象或容器。
/mob/living/carbon/human/proc/z121_can_dash()
	if(!client || client.mob != src || focus != src || client.movement_blocked || client.movement_locked)
		return FALSE
	if(!isturf(loc) || stat != CONSCIOUS || incapacitated() || !(mobility_flags & MOBILITY_MOVE) || !(mobility_flags & MOBILITY_STAND))
		return FALSE
	if(buckled || notransform || force_moving || throwing || control_object || remote_control || incorporeal_move || shifting || is_move_blocked_by_grab())
		return FALSE
	if(HAS_TRAIT(src, TRAIT_NORUN) || HAS_TRAIT(src, TRAIT_IN_FRENZY) || HAS_TRAIT(src, TRAIT_MOVEMENT_BLOCKED))
		return FALSE
	return stamina < max_stamina && energy > 0 && check_armor_skill() && !legcuffed

// 冲刺中的同向输入交给计时器，变向输入立即结束冲刺后照常处理。
/mob/living/carbon/human/keyLoop(client/user)
	if(!z121_dash)
		return ..()
	var/input_dir = (user.intended_direction | user.next_move_dir_add) & ~user.next_move_dir_sub
	if((input_dir & NORTH) && (input_dir & SOUTH))
		input_dir &= ~(NORTH | SOUTH)
	if((input_dir & EAST) && (input_dir & WEST))
		input_dir &= ~(EAST | WEST)
	input_dir = user.camera_relative_dir(input_dir)
	if((input_dir && input_dir != z121_dash.direction) || user.movement_locked)
		z121_dash.stop()
		return ..()
	return FALSE

// 保留玩家、疲劳或碰撞导致的模式切换，不在结束清理时重新开启奔跑。
/mob/living/carbon/human/toggle_rogmove_intent(intent, silent = FALSE)
	. = ..()
	if(z121_dash && intent != MOVE_INTENT_RUN)
		z121_dash.stop()

/datum/z121_dash_session
	var/mob/living/carbon/human/runner
	var/client/runner_client
	var/turf/last_turf
	var/direction
	var/previous_intent
	var/steps = 0
	var/in_step = FALSE
	var/waive_run_fatigue = FALSE
	var/cancelled = FALSE
	var/bumped = FALSE
	var/step_timer

/datum/z121_dash_session/New(mob/living/carbon/human/new_runner, new_direction, old_intent)
	. = ..()
	runner = new_runner
	runner_client = runner.client
	last_turf = get_turf(runner)
	direction = new_direction
	previous_intent = old_intent
	runner.z121_dash = src
	RegisterSignal(runner, COMSIG_MOB_MOVESPEED_UPDATED, PROC_REF(accelerate))
	RegisterSignal(runner, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(runner, COMSIG_MOVABLE_BUMP, PROC_REF(on_bump))
	RegisterSignal(runner, list(COMSIG_QDELETING, COMSIG_MOB_LOGOUT, COMSIG_LIVING_DEATH, COMSIG_MIND_TRANSFER), PROC_REF(on_runner_lost))
	runner.update_movespeed()
	// 等施法框架完成扣费与清理充能减速后，再开始原生移动。
	schedule_step()

/datum/z121_dash_session/proc/accelerate(mob/source)
	SIGNAL_HANDLER
	source.cached_multiplicative_slowdown *= 0.5

/datum/z121_dash_session/proc/schedule_step()
	step_timer = addtimer(CALLBACK(src, PROC_REF(advance)), max(world.tick_lag, runner_client.move_delay - world.time), TIMER_STOPPABLE)

/datum/z121_dash_session/proc/advance()
	step_timer = null
	if(cancelled || QDELETED(runner) || runner.client != runner_client || runner.m_intent != MOVE_INTENT_RUN || !runner.z121_can_dash() || get_turf(runner) != last_turf)
		stop()
		return
	// 原生移动冷却尚未结束时等待，不重复尝试或重置冷却。
	if(world.time < runner_client.move_delay)
		schedule_step()
		return
	var/turf/next_turf = get_step(runner, direction)
	if(!next_turf)
		stop()
		return
	in_step = TRUE
	waive_run_fatigue = FALSE
	runner_client.Move(next_turf, direction)
	in_step = FALSE
	waive_run_fatigue = FALSE
	if(cancelled || bumped || QDELETED(runner) || runner.m_intent != MOVE_INTENT_RUN || !runner.z121_can_dash())
		stop()
		return
	var/turf/arrived = get_turf(runner)
	var/actual_direction = get_dir(last_turf, arrived)
	// 原生斜向移动允许只完成一个正交子步，仍按实际成功的奔跑步数计数。
	if(!arrived || arrived.z != last_turf.z || get_dist(last_turf, arrived) != 1 || !actual_direction || (actual_direction & direction) != actual_direction)
		stop()
		return
	steps++
	last_turf = arrived
	if(steps >= 5)
		stop()
		return
	schedule_step()

/datum/z121_dash_session/proc/on_moved(mob/source, atom/old_loc, move_dir, forced)
	SIGNAL_HANDLER
	// 斜向奔跑可能包含原生的两个正交子步；外部强制位移始终中断。
	if(!in_step || forced)
		stop()
		return
	// 离开水面等地形消耗先于移动完成信号；只为随后原生奔跑扣费发放一次豁免。
	waive_run_fatigue = TRUE

/datum/z121_dash_session/proc/on_bump()
	SIGNAL_HANDLER
	bumped = TRUE
	// 等原生碰撞处理完成后清理，以免改变撞墙、撞人的奔跑判定。
	if(!in_step)
		stop()

/datum/z121_dash_session/proc/on_runner_lost()
	SIGNAL_HANDLER
	stop()

/datum/z121_dash_session/proc/stop()
	cancelled = TRUE
	if(!in_step)
		qdel(src)

/datum/z121_dash_session/Destroy()
	if(step_timer)
		deltimer(step_timer)
		step_timer = null
	if(runner)
		UnregisterSignal(runner, list(COMSIG_MOB_MOVESPEED_UPDATED, COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_BUMP, COMSIG_QDELETING, COMSIG_MOB_LOGOUT, COMSIG_LIVING_DEATH, COMSIG_MIND_TRANSFER))
		if(runner.z121_dash == src)
			runner.z121_dash = null
		if(!QDELETED(runner))
			// 已被碰撞、疲劳或玩家改成其他模式时，保留该模式。
			if(runner.m_intent == MOVE_INTENT_RUN)
				runner.toggle_rogmove_intent(previous_intent, TRUE)
			runner.update_movespeed()
	runner = null
	runner_client = null
	last_turf = null
	return ..()
