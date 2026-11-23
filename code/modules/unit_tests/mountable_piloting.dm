// Spies verify action dispatch without inventing a client for headless tests.
/mob/living/carbon/human/mountable_pilot_test
	parent_type = /mob/living/carbon/human/consistent
	var/received_direction
	var/jump_count = 0
	var/received_jump_range
	var/received_jump_cost
	var/relax_message_invisibility

/mob/living/carbon/human/mountable_pilot_test/visible_message(message, self_message, blind_message, vision_distance = DEFAULT_MESSAGE_RANGE, list/ignored_mobs, runechat_message = null, log_seen = NONE, log_seen_msg = null)
	if(findtext(message, "再次降低他们的姿态"))
		relax_message_invisibility = invisibility
	return ..()

/mob/living/carbon/human/mountable_pilot_test/execute_piloted_move(direction)
	received_direction = direction
	return TRUE

/mob/living/carbon/human/mountable_pilot_test/jump_action_resolve(atom/target, stamina_cost, jump_range, extra)
	jump_count++
	received_jump_range = jump_range
	received_jump_cost = stamina_cost

// These turfs record the actor at the entry to existing climbing logic.
/turf/closed/mountable_climb_test
	wallclimb = TRUE
	var/mob/actor

/turf/closed/mountable_climb_test/attack_hand(mob/user, params, datum/callback/pilot_check = null)
	if(!pilot_check)
		return ..()
	if(pilot_check.Invoke())
		actor = user
	return TRUE

/turf/open/transparent/openspace/mountable_climb_test
	var/mob/actor
	var/along_wall = FALSE

// The unit-test reservation has no connected level below it.
/turf/open/transparent/openspace/mountable_climb_test/show_bottom_level()
	return TRUE

/turf/open/transparent/openspace/mountable_climb_test/attack_hand(mob/user, params, datum/callback/pilot_check = null)
	if(!pilot_check)
		return ..()
	if(pilot_check.Invoke())
		actor = user
	return TRUE

/turf/open/transparent/openspace/mountable_climb_test/climb_from_openspace(mob/living/user, datum/callback/pilot_check = null)
	if(pilot_check?.Invoke())
		actor = user
		along_wall = TRUE
	return TRUE

/datum/unit_test/mountable_piloting
	var/turf/changed_turf
	var/restore_type

/datum/unit_test/mountable_piloting/Destroy()
	if(changed_turf && restore_type)
		changed_turf.ChangeTurf(restore_type)
	return ..()

/datum/unit_test/mountable_piloting/Run()
	var/mob/living/carbon/human/mountable_pilot_test/mount = allocate(/mob/living/carbon/human/mountable_pilot_test)
	var/mob/living/carbon/human/mountable_pilot_test/rider = allocate(/mob/living/carbon/human/mountable_pilot_test)
	var/mob/living/carbon/human/stranger = allocate(/mob/living/carbon/human/consistent)
	var/turf/start = run_loc_floor_bottom_left
	var/turf/target = get_step(start, NORTH)
	mount.forceMove(start)
	rider.forceMove(start)
	stranger.forceMove(run_loc_floor_top_right)
	ADD_TRAIT(mount, TRAIT_PONYGIRL_RIDEABLE, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(mount.buckle_mob(rider, TRUE), "无法让测试驾驶者上骑")
	var/datum/component/riding/human/riding = mount.GetComponent(/datum/component/riding)
	TEST_ASSERT(riding.can_rider_steer(rider), "已注册的骑手无法转向")
	TEST_ASSERT(!riding.can_rider_steer(stranger), "无关玩家能够转向")
	TEST_ASSERT(riding.handle_ride(rider, NORTH), "转向未传达到坐骑输入")
	TEST_ASSERT_EQUAL(mount.received_direction, NORTH, "方向未转发给坐骑")
	TEST_ASSERT_NULL(rider.received_direction, "骑手执行了坐骑移动")
	mount.doing = TRUE
	TEST_ASSERT(!riding.handle_ride(rider, SOUTH), "骑手打断了坐骑的计时动作")
	mount.doing = FALSE
	TEST_ASSERT_EQUAL(mount.received_direction, NORTH, "忙碌的坐骑接收到了移动")

	// Resting retains the passenger but suspends piloting until standing again.
	mount.set_resting(TRUE, TRUE)
	TEST_ASSERT_EQUAL(rider.buckled, mount, "休息时使乘客下骑")
	TEST_ASSERT(!riding.can_rider_steer(rider), "休息中的坐骑允许驾驶")
	TEST_ASSERT(!riding.handle_ride(rider, SOUTH), "骑手移动了休息中的坐骑")
	TEST_ASSERT_EQUAL(mount.received_direction, NORTH, "休息中的坐骑接收到了移动输入")
	mount.set_resting(FALSE, TRUE)
	TEST_ASSERT_EQUAL(rider.buckled, mount, "站起时使乘客下骑")
	TEST_ASSERT(riding.handle_ride(rider, NORTH), "站起后转向未恢复")
	// Intent changes use the mount's restrictions and leave the rider's mode alone.
	rider.m_intent = MOVE_INTENT_WALK
	ADD_TRAIT(rider, TRAIT_NORUN, TRAIT_SOURCE_UNIT_TESTS)
	rider.request_movement_intent(MOVE_INTENT_RUN)
	TEST_ASSERT_EQUAL(mount.m_intent, MOVE_INTENT_RUN, "骑手的 NORUN 阻止了坐骑奔跑")
	TEST_ASSERT_EQUAL(rider.m_intent, MOVE_INTENT_WALK, "驾驶者改变了个人移动模式")
	TEST_ASSERT_EQUAL(rider.get_controlled_movement_intent(), MOVE_INTENT_RUN, "驾驶者 HUD 未反映坐骑模式")
	rider.request_movement_intent(MOVE_INTENT_SNEAK)
	TEST_ASSERT_EQUAL(mount.m_intent, MOVE_INTENT_SNEAK, "潜行未被转发")
	TEST_ASSERT_EQUAL(rider.m_intent, MOVE_INTENT_SNEAK, "骑手未共享潜行")
	ADD_TRAIT(mount, TRAIT_NORUN, TRAIT_SOURCE_UNIT_TESTS)
	rider.request_movement_intent(MOVE_INTENT_RUN)
	TEST_ASSERT_EQUAL(mount.m_intent, MOVE_INTENT_SNEAK, "驾驶者绕过了坐骑的 NORUN")
	REMOVE_TRAIT(mount, TRAIT_NORUN, TRAIT_SOURCE_UNIT_TESTS)
	mount.toggle_rider_steering()
	rider.request_movement_intent(MOVE_INTENT_RUN)
	TEST_ASSERT_EQUAL(mount.m_intent, MOVE_INTENT_SNEAK, "禁用转向改变了坐骑模式")
	TEST_ASSERT_EQUAL(rider.m_intent, MOVE_INTENT_SNEAK, "被拒绝的输入改变了骑手模式")
	mount.toggle_rider_steering()

	// Real jump setup, with only the final throw replaced by a recording spy.
	var/datum/intent/jump/jump_intent = new
	rider.sneak_faded = TRUE
	rider.invisibility = 100
	rider.request_movement_intent(MOVE_INTENT_WALK)
	TEST_ASSERT_EQUAL(rider.relax_message_invisibility, initial(rider.invisibility), "在离开潜行隐身前就发送了公开退出消息")
	TEST_ASSERT_EQUAL(mount.m_intent, MOVE_INTENT_WALK, "坐骑未离开潜行")
	TEST_ASSERT_EQUAL(rider.m_intent, MOVE_INTENT_WALK, "骑手未离开潜行")
	ADD_TRAIT(mount, TRAIT_BEWINGED, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(jump_intent.on_mmb(target, rider), "驾驶者的跳跃未执行")
	TEST_ASSERT_EQUAL(mount.jump_count, 1, "坐骑未执行跳跃")
	TEST_ASSERT_EQUAL(rider.jump_count, 0, "骑手独立跳跃")
	TEST_ASSERT_EQUAL(mount.received_jump_range, 3, "跳跃忽略了坐骑的种族距离")
	TEST_ASSERT_EQUAL(mount.received_jump_cost, 20, "跳跃未使用坐骑的行走消耗")
	TEST_ASSERT(mount.IsOffBalanced(), "跳跃未对坐骑施加恢复")
	TEST_ASSERT(!rider.IsOffBalanced(), "跳跃对乘客施加了恢复")
	TEST_ASSERT(!jump_intent.on_mmb(target, rider), "驾驶者绕过了共享跳跃冷却")
	mount.next_move = 0
	TEST_ASSERT(!jump_intent.on_mmb(target, rider), "驾驶者绕过了坐骑的失衡")
	mount.remove_status_effect(STATUS_EFFECT_OFFBALANCED)
	mount.toggle_rider_steering()
	TEST_ASSERT(!jump_intent.on_mmb(target, rider), "禁用转向后仍允许跳跃")
	TEST_ASSERT_EQUAL(rider.jump_count, 0, "被拒绝的跳跃回落到乘客")
	mount.toggle_rider_steering()
	qdel(jump_intent)

	// Wall click, down click and drag all dispatch as the mount.
	restore_type = target.type
	var/turf/closed/mountable_climb_test/wall = target.ChangeTurf(/turf/closed/mountable_climb_test)
	changed_turf = wall
	wall.attack_hand(rider, "icon-x=16;icon-y=16;left=1")
	TEST_ASSERT_EQUAL(wall.actor, mount, "点击墙壁时未使用坐骑作为攀爬者")
	mount.next_move = 0
	var/turf/open/transparent/openspace/mountable_climb_test/space = wall.ChangeTurf(/turf/open/transparent/openspace/mountable_climb_test)
	changed_turf = space
	space.attack_hand(rider, "icon-x=16;icon-y=16;left=1")
	TEST_ASSERT_EQUAL(space.actor, mount, "向下攀爬未使用坐骑")
	mount.next_move = 0
	space.actor = null
	space.MouseDrop_T(rider, rider)
	TEST_ASSERT(space.along_wall && space.actor == mount, "拖动骑手时未请求坐骑越墙")
	mount.next_move = 0
	space.actor = null
	space.MouseDrop_T(mount, rider)
	TEST_ASSERT_EQUAL(space.actor, mount, "拖动坐骑时未请求越墙")
	mount.next_move = 0
	space.actor = null
	space.MouseDrop_T(stranger, rider)
	TEST_ASSERT_NULL(space.actor, "拖动无关生物发起了攀爬")
	mount.toggle_rider_steering()
	space.attack_hand(rider, "icon-x=16;icon-y=16;left=1")
	space.MouseDrop_T(rider, rider)
	TEST_ASSERT_NULL(space.actor, "被拒绝的攀爬回落到乘客")
	mount.toggle_rider_steering()
	target = space.ChangeTurf(restore_type)
	changed_turf = null

	// A running climb callback cannot survive consent revocation, even if re-enabled.
	var/datum/callback/check = CALLBACK(riding, TYPE_PROC_REF(/datum/component/riding/human, continue_climb), rider, riding.steering_generation)
	TEST_ASSERT(check.Invoke(), "新的攀爬许可无效")
	addtimer(CALLBACK(mount, TYPE_PROC_REF(/mob/living/carbon/human, toggle_rider_steering)), 1)
	TEST_ASSERT(!do_after(mount, 10, target = target, extra_checks = check), "禁用转向未能取消计时动作")
	mount.toggle_rider_steering()
	TEST_ASSERT(!check.Invoke(), "重新启用转向复活了已取消的攀爬")
	qdel(check)
	check = CALLBACK(riding, TYPE_PROC_REF(/datum/component/riding/human, continue_climb), rider, riding.steering_generation)
	mount.unbuckle_mob(rider, TRUE)
	TEST_ASSERT(!check.Invoke(), "下骑后仍保留待处理的攀爬许可")
	TEST_ASSERT_EQUAL(rider.get_controlled_movement_intent(), rider.m_intent, "下骑后的 HUD 仍读取坐骑模式")
	qdel(check)
