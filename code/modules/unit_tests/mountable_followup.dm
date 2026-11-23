// Count grass contact without triggering unrelated random ambushes.
/mob/living/carbon/human/mountable_test
	parent_type = /mob/living/carbon/human/consistent
	var/plant_contacts = 0

/mob/living/carbon/human/mountable_test/consider_ambush(always, ignore_cooldown, min_dist, max_dist, silent)
	plant_contacts++

/datum/unit_test/mountable_followup/Run()
	var/mob/living/carbon/human/mountable_test/mount = allocate(/mob/living/carbon/human/mountable_test)
	var/mob/living/carbon/human/mountable_test/rider = allocate(/mob/living/carbon/human/mountable_test)
	var/turf/start = run_loc_floor_bottom_left
	var/turf/next = get_step(start, NORTH)
	mount.forceMove(start)
	rider.forceMove(start)
	ADD_TRAIT(mount, TRAIT_PONYGIRL_RIDEABLE, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(/mob/living/carbon/human/proc/toggle_rider_steering in mount.verbs, "可骑乘生物未授予转向开关")
	TEST_ASSERT(mount.buckle_mob(rider, TRUE), "无法让测试乘客上骑")
	var/datum/component/riding/human/riding = mount.GetComponent(/datum/component/riding)

	TEST_ASSERT(/mob/living/carbon/human/proc/dismount_rider in mount.verbs, "可骑乘生物未授予下骑指令")
	mount.resist()
	TEST_ASSERT_EQUAL(rider.buckled, mount, "普通 Resist 使骑手下骑")
	TEST_ASSERT(!rider.IsParalyzed(), "普通 Resist 使骑手瘫痪")
	mount.next_move = 0
	mount.dismount_rider()
	TEST_ASSERT_NULL(rider.buckled, "Dismount Rider 未释放骑手")
	rider.SetParalyzed(0)
	rider.set_resting(FALSE, TRUE)
	TEST_ASSERT(mount.buckle_mob(rider, TRUE), "主动下骑后无法重新上骑")
	riding = mount.GetComponent(/datum/component/riding)

	// Grass contact is suppressed, but tall plants still brush the passenger.
	var/obj/structure/flora/roguegrass/grass = allocate(/obj/structure/flora/roguegrass, start)
	var/obj/structure/flora/roguegrass/bush/bush = allocate(/obj/structure/flora/roguegrass/bush, start)
	var/datum/component/roguegrass/short_plants = grass.GetComponent(/datum/component/roguegrass)
	var/datum/component/roguegrass/tall_plants = bush.GetComponent(/datum/component/roguegrass)
	rider.plant_contacts = 0
	rider.m_intent = MOVE_INTENT_WALK
	short_plants.Crossed(grass, rider)
	TEST_ASSERT_EQUAL(rider.plant_contacts, 0, "草丛对被携带的乘客产生了反应")
	tall_plants.Crossed(bush, rider)
	TEST_ASSERT_EQUAL(rider.plant_contacts, 1, "灌木未能擦碰乘客")
	qdel(grass)
	qdel(bush)

	// Both web implementations must exempt a real passenger during transport.
	var/obj/structure/spider/stickyweb/web = allocate(/obj/structure/spider/stickyweb, next)
	var/obj/structure/spider/stickyweb/mirespider/thin_web = allocate(/obj/structure/spider/stickyweb/mirespider, next)
	ADD_TRAIT(mount, TRAIT_WEBWALK, TRAIT_SOURCE_UNIT_TESTS)
	for(var/i in 1 to 50)
		TEST_ASSERT(web.CanPass(rider, start), "蛛网困住了乘客")
		TEST_ASSERT(thin_web.CanPass(rider, start), "泥蛛网困住了乘客")
	TEST_ASSERT(mount.Move(next, NORTH), "Webwalker 无法携带乘客穿过蛛网")
	TEST_ASSERT_EQUAL(rider.loc, mount.loc, "穿越蛛网时骑手与坐骑分离")
	qdel(web)
	qdel(thin_web)

	// A protected mount crosses without exposing its passenger to ground shocks.
	var/obj/structure/glowshroom/kneestingers = allocate(/obj/structure/glowshroom, start)
	TEST_ASSERT(kneestingers.can_zap(mount), "未受保护的坐骑绕过了膝刺草")
	TEST_ASSERT(!kneestingers.can_zap(rider), "膝刺草瞄准了已连接的骑手")
	TEST_ASSERT(kneestingers.CanPass(rider, start), "膝刺草阻挡了被携带的骑手")
	ADD_TRAIT(mount, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(mount.Move(start, SOUTH), "Dendorite 坐骑无法携带骑手越过膝刺草")
	TEST_ASSERT_EQUAL(rider.loc, start, "膝刺草使骑手与坐骑分离")
	qdel(kneestingers)
	mount.forceMove(next)

	// Disabling control stops facing changes and movement, not carrying.
	mount.toggle_rider_steering()
	var/old_dir = mount.dir
	riding.last_vehicle_move = -1000
	riding.handle_ride(rider, WEST)
	TEST_ASSERT_EQUAL(mount.loc, next, "禁用转向后坐骑仍移动")
	TEST_ASSERT_EQUAL(mount.dir, old_dir, "禁用转向后坐骑仍转向")
	TEST_ASSERT(mount.Move(start, SOUTH), "转向开关阻挡了坐骑自身的移动")
	TEST_ASSERT_EQUAL(rider.buckled, mount, "转向开关使乘客下骑")
	mount.toggle_rider_steering()

	// Stun and immobilization prevent skating without forcing a standing dismount.
	mount.Stun(20)
	riding.last_vehicle_move = -1000
	riding.handle_ride(rider, NORTH)
	TEST_ASSERT_EQUAL(mount.loc, start, "骑手操纵了被击晕的坐骑")
	TEST_ASSERT_EQUAL(rider.buckled, mount, "站立击晕不必要地使骑手下骑")
	mount.SetStun(0)
	mount.Immobilize(20)
	riding.last_vehicle_move = -1000
	riding.handle_ride(rider, NORTH)
	TEST_ASSERT_EQUAL(mount.loc, start, "骑手操纵了被定身的坐骑")
	mount.SetImmobilized(0)

	// Player mounts no longer grant Riding XP, including sleep-banked XP.
	rider.mind_initialize()
	rider.adjust_skillrank(/datum/skill/misc/riding, SKILL_LEVEL_APPRENTICE, TRUE)
	var/before_sleep_xp = rider.mind.sleep_adv.get_sleep_xp(/datum/skill/misc/riding)
	rider.m_intent = MOVE_INTENT_RUN
	for(var/i in 1 to 6)
		mount.Move(mount.loc == start ? next : start, mount.loc == start ? NORTH : SOUTH)
	TEST_ASSERT_EQUAL(rider.mind.sleep_adv.get_sleep_xp(/datum/skill/misc/riding), before_sleep_xp, "玩家运输获得了睡眠经验")
	TEST_ASSERT_EQUAL(riding.riding_xp_move_counter, 0, "玩家运输计入了骑术经验移动")
	// A clientless mount must not fall back to unrestricted step/forceMove steering.
	var/atom/before_input = mount.loc
	TEST_ASSERT(!riding.handle_ride(rider, NORTH), "无客户端坐骑接受了转向")
	TEST_ASSERT_EQUAL(mount.loc, before_input, "无客户端转向移动了坐骑")

	// Resting keeps attachment; immunity must not eject.
	mount.set_resting(TRUE, TRUE)
	TEST_ASSERT_EQUAL(rider.buckled, mount, "自愿休息使骑手下骑")
	ADD_TRAIT(mount, TRAIT_STUNIMMUNE, TRAIT_SOURCE_UNIT_TESTS)
	mount.Knockdown(20)
	TEST_ASSERT_EQUAL(rider.buckled, mount, "免疫击倒仍使骑手下骑")
	REMOVE_TRAIT(mount, TRAIT_STUNIMMUNE, TRAIT_SOURCE_UNIT_TESTS)
	mount.SetKnockdown(0)
	TEST_ASSERT_EQUAL(rider.buckled, mount, "清除击倒时使骑手下骑")
	mount.AdjustKnockdown(20)
	TEST_ASSERT_NULL(rider.buckled, "调整击倒未能使已处于休息状态的骑手下骑")
	TEST_ASSERT(!mount.buckle_mob(rider, TRUE), "被击倒的坐骑仍可上骑")
	mount.SetKnockdown(0)
	mount.set_resting(FALSE, TRUE)
	TEST_ASSERT(mount.buckle_mob(rider, TRUE), "无法重新上骑已恢复的坐骑")
	mount.Paralyze(20, FALSE)
	TEST_ASSERT_NULL(rider.buckled, "未更新移动能力的瘫痪未能使骑手下骑")
	TEST_ASSERT_NULL(rider.get_mountable_mount(), "下骑后的骑手仍保留地面豁免")
	// Direct and Set variants must also dismount, not only AdjustKnockdown.
	for(var/variant in list("Knockdown", "SetKnockdown"))
		mount.SetParalyzed(0)
		mount.SetKnockdown(0)
		mount.set_resting(FALSE, TRUE)
		TEST_ASSERT(mount.buckle_mob(rider, TRUE), "无法为击倒变体重新上骑")
		call(mount, variant)(20)
		TEST_ASSERT_NULL(rider.buckled, "击倒变体未使骑手下骑")

	// A dismounted non-Webwalker must become vulnerable again.
	web = allocate(/obj/structure/spider/stickyweb, get_turf(rider))
	var/blocked_by_web = FALSE
	for(var/i in 1 to 50)
		if(!web.CanPass(rider, start))
			blocked_by_web = TRUE
			break
	TEST_ASSERT(blocked_by_web, "下骑后的乘客仍保留蛛网免疫")
	REMOVE_TRAIT(mount, TRAIT_PONYGIRL_RIDEABLE, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(!(/mob/living/carbon/human/proc/toggle_rider_steering in mount.verbs), "移除特性后仍保留转向指令")
