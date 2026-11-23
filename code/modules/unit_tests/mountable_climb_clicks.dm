// Integration regression: real click parameters, real climbing and real do_after.
// The previous dispatch-only spies missed attack_hand's second-argument contract.
/turf/closed/wall/mountable_click_test
	wallclimb = TRUE
	climbdiff = 0

/datum/unit_test/mountable_climb_clicks
	var/list/changed_turfs = list()

/datum/unit_test/mountable_climb_clicks/Destroy()
	for(var/turf/changed as anything in changed_turfs)
		changed.ChangeTurf(/turf/closed/void)
	return ..()

/datum/unit_test/mountable_climb_clicks/Run()
	var/datum/space_level/lower = SSmapping.add_new_zlevel("Mountable climb test lower", list(ZTRAIT_UP = TRUE))
	var/datum/space_level/upper = SSmapping.add_new_zlevel("Mountable climb test upper", list(ZTRAIT_DOWN = TRUE))
	for(var/z_value in list(lower.z_value, upper.z_value))
		for(var/turf/T in block(locate(9, 9, z_value), locate(12, 12, z_value)))
			changed_turfs += T.ChangeTurf(/turf/open/floor/rogue/naturalstone)
	var/turf/start = locate(10, 10, lower.z_value)
	var/turf/wall = locate(10, 11, lower.z_value)
	wall = wall.ChangeTurf(/turf/closed/wall/mountable_click_test)
	var/turf/open/transparent/openspace/gap = locate(10, 10, upper.z_value)
	gap = gap.ChangeTurf(/turf/open/transparent/openspace)
	var/turf/landing = locate(10, 11, upper.z_value)
	var/mob/living/carbon/human/mountable_pilot_test/mount = allocate(/mob/living/carbon/human/mountable_pilot_test, start)
	var/mob/living/carbon/human/rider = allocate(/mob/living/carbon/human/consistent, start)
	mount.mind_initialize()
	rider.mind_initialize()
	mount.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_LEGENDARY, TRUE)
	mount.physiology.do_after_speed = 0.1
	mount.used_hand = 1
	rider.used_hand = 1
	var/click_params = "icon-x=16;icon-y=16;left=1;button=left"
	TEST_ASSERT_EQUAL(get_step_multiz(start, UP), gap, "测试层级未连通")
	// Unmounted ordinary clicks: a params string must never become a callback.
	mount.ClickOn(wall, click_params)
	TEST_ASSERT_EQUAL(mount.loc, landing, "普通点击墙壁未能完成攀爬")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "普通攀爬后仍残留忙碌状态/进度条")
	mount.next_move = 0
	mount.next_click = 0
	mount.ClickOn(gap, click_params)
	TEST_ASSERT_EQUAL(mount.loc, start, "普通点击开放空间未能向下攀爬")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "向下攀爬后仍残留忙碌状态/进度条")
	TEST_ASSERT(do_after(mount, 2, target = mount), "独自攀爬后的计时动作失败")

	ADD_TRAIT(mount, TRAIT_PONYGIRL_RIDEABLE, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(mount.buckle_mob(rider, TRUE), "无法让集成测试骑手上骑")
	var/datum/component/riding/human/riding = mount.GetComponent(/datum/component/riding)
	// The mount's own click while carrying must remain functional.
	mount.next_move = 0
	mount.next_click = 0
	mount.ClickOn(wall, click_params)
	TEST_ASSERT_EQUAL(mount.loc, landing, "载有乘客时坐骑自身攀爬失败")
	TEST_ASSERT_EQUAL(rider.loc, landing, "乘客未跟随坐骑攀爬")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "坐骑自身攀爬后仍残留状态")
	mount.next_move = 0
	rider.next_move = 0
	rider.next_click = 0
	rider.ClickOn(gap, click_params)
	TEST_ASSERT_EQUAL(mount.loc, start, "乘客点击开放空间未能下降")
	TEST_ASSERT_EQUAL(rider.loc, start, "乘客未跟随下降")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "驾驶下降后仍残留状态")

	for(var/i in 1 to 2)
		mount.next_move = 0
		rider.next_move = 0
		rider.next_click = 0
		rider.ClickOn(wall, click_params)
		TEST_ASSERT_EQUAL(mount.loc, landing, "重复驾驶攀爬失败")
		TEST_ASSERT_EQUAL(rider.loc, landing, "重复驾驶攀爬使乘客分离")
		TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "驾驶攀爬累积了进度条")
		mount.next_move = 0
		rider.next_move = 0
		rider.next_click = 0
		rider.ClickOn(gap, click_params)
		TEST_ASSERT_EQUAL(mount.loc, start, "重复下降失败")
		TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "驾驶下降累积了进度条")
	TEST_ASSERT(do_after(mount, 2, target = mount), "攀爬后坐骑的计时动作仍被锁定")
	TEST_ASSERT(do_after(rider, 2, target = rider), "攀爬后骑手的计时动作仍被锁定")
	TEST_ASSERT(riding.handle_ride(rider, EAST), "攀爬后转向仍被阻止")
	TEST_ASSERT_EQUAL(mount.received_direction, EAST, "攀爬后的转向未传达到坐骑")

	// Real wall traversal and descent, not a dispatch spy.
	mount.forceMove(landing)
	var/turf/side_wall = locate(11, 12, upper.z_value)
	side_wall = side_wall.ChangeTurf(/turf/closed/wall/mountable_click_test)
	var/turf/open/transparent/openspace/traverse = locate(11, 11, upper.z_value)
	traverse = traverse.ChangeTurf(/turf/open/transparent/openspace)
	mount.next_move = 0
	traverse.MouseDrop_T(rider, rider)
	TEST_ASSERT_EQUAL(mount.loc, traverse, "真实驾驶越墙失败")
	TEST_ASSERT_EQUAL(rider.loc, traverse, "越墙后乘客被留在原地")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "越墙后仍残留动作状态")
	TEST_ASSERT(istype(mount.get_active_held_item(), /obj/item/clothing/wall_grab), "越墙应占用攀爬手")
	// As with normal climbing, select the free hand for the next click.
	mount.swap_hand()
	TEST_ASSERT(!mount.get_active_held_item(), "没有空闲的手可下降")
	var/turf/open/transparent/openspace/down_gap = locate(11, 10, upper.z_value)
	down_gap = down_gap.ChangeTurf(/turf/open/transparent/openspace)
	mount.next_move = 0
	rider.next_move = 0
	rider.next_click = 0
	rider.ClickOn(down_gap, click_params)
	TEST_ASSERT_EQUAL(mount.loc, locate(11, 10, lower.z_value), "越墙后无法下降")
	TEST_ASSERT_EQUAL(rider.loc, mount.loc, "越墙后的下降使乘客分离")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "越墙后的下降仍残留状态")
	mount.forceMove(start)

	// Real climb cancellation must clean up before a later action can begin.
	mount.next_move = 0
	rider.next_move = 0
	rider.next_click = 0
	mount.physiology.do_after_speed = 1
	addtimer(CALLBACK(mount, TYPE_PROC_REF(/mob/living/carbon/human, toggle_rider_steering)), 2)
	rider.ClickOn(wall, click_params)
	TEST_ASSERT_EQUAL(mount.loc, start, "取消驾驶攀爬后坐骑仍移动")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "取消攀爬后仍残留忙碌状态/进度条")
	TEST_ASSERT(do_after(mount, 2, target = mount), "取消攀爬后的计时动作失败")
	mount.toggle_rider_steering()
	TEST_ASSERT(riding.handle_ride(rider, EAST), "取消攀爬后转向失败")

	// Walking over a cliff must restore the passive passenger's own movement.
	mount.remove_status_effect(/datum/status_effect/debuff/climbing_lfwb)
	mount.forceMove(landing)
	mount.Move(gap, SOUTH)
	TEST_ASSERT_EQUAL(mount.loc, start, "悬崖坠落未到达下层地面")
	TEST_ASSERT_NULL(rider.buckled, "悬崖撞击未能使乘客下骑")
	TEST_ASSERT(rider.mobility_flags & MOBILITY_MOVE, "悬崖下骑后乘客失去移动能力")
	TEST_ASSERT(!rider.anchored && !rider.force_moving && !rider.doing, "乘客仍保持移动/动作锁定")
	TEST_ASSERT(rider.Move(get_step(start, EAST), EAST), "坠落后乘客无法走开")
	TEST_ASSERT(do_after(rider, 2, target = rider), "坠落后乘客的计时动作失败")

	// Match the reported pair: Arachnid mount and Fluvian passenger, no rider input.
	var/mob/living/carbon/human/species/arachnid/spider = allocate(/mob/living/carbon/human/species/arachnid, landing)
	var/mob/living/carbon/human/species/moth/fluvian = allocate(/mob/living/carbon/human/species/moth, landing)
	ADD_TRAIT(spider, TRAIT_PONYGIRL_RIDEABLE, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(spider.buckle_mob(fluvian, TRUE), "无法让 Fluvian 乘客上骑")
	spider.Move(gap, SOUTH)
	TEST_ASSERT_EQUAL(spider.loc, start, "Arachnid 未到达悬崖底部")
	TEST_ASSERT_NULL(fluvian.buckled, "撞击后 Fluvian 仍保持连接")
	TEST_ASSERT(fluvian.mobility_flags & MOBILITY_MOVE, "下骑后 Fluvian 失去移动能力")
	TEST_ASSERT(!fluvian.anchored && !fluvian.force_moving && !fluvian.doing && !fluvian.pulledby, "Fluvian 仍保持移动/动作锁定")
	TEST_ASSERT(fluvian.Move(get_step(start, WEST), WEST), "撞击后 Fluvian 无法走开")
	TEST_ASSERT(do_after(fluvian, 2, target = fluvian), "撞击后 Fluvian 无法执行计时动作")

	// Trees have an object click handler separate from the wall and open-space handlers.
	var/obj/structure/flora/newbranch/branch = allocate(/obj/structure/flora/newbranch, gap)
	mount = allocate(/mob/living/carbon/human/mountable_pilot_test, start)
	rider = allocate(/mob/living/carbon/human/consistent, start)
	ADD_TRAIT(mount, TRAIT_PONYGIRL_RIDEABLE, TRAIT_SOURCE_UNIT_TESTS)
	mount.used_hand = 1
	rider.used_hand = 1
	mount.physiology.do_after_speed = 0.1
	TEST_ASSERT(mount.buckle_mob(rider, TRUE), "无法为树木测试上骑")
	for(var/tree_type in list(/obj/structure/flora/newtree, /obj/structure/flora/newtreealt))
		var/obj/structure/flora/tree = allocate(tree_type, get_step(start, EAST))
		mount.next_move = 0
		rider.next_move = 0
		rider.next_click = 0
		rider.ClickOn(tree, click_params)
		TEST_ASSERT_EQUAL(mount.loc, gap, "骑手点击树木后未能与坐骑一起攀爬")
		TEST_ASSERT_EQUAL(rider.loc, gap, "骑手未跟随坐骑爬上树")
		mount.forceMove(start)
		qdel(tree)
	mount.physiology.do_after_speed = 1
	var/obj/structure/flora/newtree/tree = allocate(/obj/structure/flora/newtree, get_step(start, EAST))
	mount.next_move = 0
	rider.next_move = 0
	rider.next_click = 0
	addtimer(CALLBACK(mount, TYPE_PROC_REF(/mob/living/carbon/human, toggle_rider_steering)), 2)
	rider.ClickOn(tree, click_params)
	TEST_ASSERT_EQUAL(mount.loc, start, "撤销转向后树木攀爬仍完成")
	TEST_ASSERT_EQUAL(rider.loc, start, "撤销转向后树木攀爬仍移动了骑手")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "树木攀爬后坐骑仍处于忙碌状态")
	qdel(branch)
