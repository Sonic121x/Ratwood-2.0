// Regression checks for the passenger/mount movement relationship.
/datum/unit_test/mountable_movement/Run()
	var/mob/living/carbon/human/mount = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/rider = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/bystander = allocate(/mob/living/carbon/human/consistent)
	var/turf/start = run_loc_floor_bottom_left
	var/turf/destination = get_step(start, NORTH)
	mount.forceMove(start)
	rider.forceMove(start)
	ADD_TRAIT(mount, TRAIT_PONYGIRL_RIDEABLE, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(mount.buckle_mob(rider, TRUE), "无法让测试骑手上骑")

	// A thrown mount should pass its own rider, but not unrelated standing mobs.
	mount.throwing = new /datum/thrownthing(mount)
	rider.density = TRUE
	rider.mobility_flags |= MOBILITY_STAND
	bystander.density = TRUE
	bystander.mobility_flags |= MOBILITY_STAND
	var/pass_rider = rider.CanPass(mount, start)
	var/pass_bystander = bystander.CanPass(mount, start)
	bystander.forceMove(destination)
	var/hit_passenger = mount.throwing.hitcheck()
	QDEL_NULL(mount.throwing)
	TEST_ASSERT(!hit_passenger, "投掷碰撞检测撞到了已连接的乘客")
	TEST_ASSERT(pass_rider, "跳跃中的坐骑撞到了自己的骑手")
	TEST_ASSERT(!pass_bystander, "跳跃中的坐骑可以穿过无关站立生物")

	var/datum/component/riding/riding = mount.GetComponent(/datum/component/riding)
	TEST_ASSERT_EQUAL(riding.driver, rider, "已上骑的骑手未被注册为驾驶者")
	rider.m_intent = MOVE_INTENT_RUN
	riding.riding_xp_move_counter = 0
	// Forced transport must synchronize passengers without earning steering XP.
	mount.forceMove(destination)
	TEST_ASSERT_EQUAL(riding.riding_xp_move_counter, 0, "强制移动获得了转向经验")
	TEST_ASSERT_EQUAL(rider.last_mount_move_time, world.time, "坐骑移动时间戳未被记录")
	TEST_ASSERT_EQUAL(rider.loc, mount.loc, "强制移动把骑手留在原地")
	TEST_ASSERT_EQUAL(rider.buckled, mount, "强制移动破坏了扣具")
	TEST_ASSERT(!rider.can_zFall(destination, 1), "已上骑的乘客可以独立坠落")

	rider.mind_initialize()
	var/datum/skill/riding_skill = GetSkillRef(/datum/skill/misc/riding)
	var/datum/skill_holder/rider_skills = rider.ensure_skills()
	var/starting_xp = rider_skills.skill_experience[riding_skill]
	bystander.forceMove(run_loc_floor_top_right)
	riding.riding_xp_move_counter = 0
	for(var/i in 1 to 5)
		riding.last_vehicle_move = -1000
		mount.Move(mount.loc == start ? destination : start, mount.loc == start ? NORTH : SOUTH)
	TEST_ASSERT_EQUAL(rider_skills.skill_experience[riding_skill], starting_xp, "玩家运输获得了骑术经验")
	mount.forceMove(destination)
	mount.unbuckle_mob(rider, TRUE)
	mount.forceMove(start)
	TEST_ASSERT_EQUAL(rider.loc, destination, "下骑后的骑手仍跟随坐骑")
