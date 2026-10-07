/**
 * Performance Stress Test
 *
 * Tests the damage overlay system and icon update performance
 * by spawning hundreds of mobs with various wounds, damage states, and clothing
 */

GLOBAL_LIST_EMPTY(stress_test_mobs)

/client/proc/performance_stress_test()
	set name = "性能压力测试"
	set category = "调试"

	if(!check_rights(R_DEBUG))
		return

	var/mob_count = input(usr, "要生成多少个测试角色？", "压力测试", 300) as num|null
	if(!mob_count || mob_count <= 0)
		return

	var/auto_cleanup = alert(usr, "测试后自动删除角色？", "清理", "是", "否") == "是"

	var/radius = round(sqrt(mob_count) / 2) + 5
	var/turf/center = get_turf(mob)

	if(!center)
		to_chat(src, span_warning("必须位于有效位置才能运行此测试。"))
		return

	to_chat(src, span_notice("开始使用 [mob_count] 个角色进行性能压力测试……"))

	var/list/spawned_mobs = list()
	var/start_time = world.timeofday

	var/spawned = 0
	for(var/x_offset = -radius to radius)
		for(var/y_offset = -radius to radius)
			if(spawned >= mob_count)
				break

			var/turf/spawn_loc = locate(center.x + x_offset, center.y + y_offset, center.z)
			if(!spawn_loc || spawn_loc.density)
				continue

			var/mob/living/carbon/human/species/human/northern/H = new(spawn_loc)
			spawned_mobs += H
			spawned++

			H.gender = prob(50) ? MALE : FEMALE
			if(H.dna)
				H.dna.update_dna_identity()
			H.update_body()
			H.update_hair()

			equip_stress_test_clothing(H)

			apply_random_damage_state(H)

			if(spawned % 50 == 0)
				to_chat(src, span_notice("已生成 [spawned]/[mob_count] 个测试对象……"))

			CHECK_TICK

	var/spawn_time = world.timeofday - start_time
	to_chat(src, span_notice("已生成 [length(spawned_mobs)] 个角色，耗时 [spawn_time/10] 秒。"))
	to_chat(src, span_notice("开始伤害更新循环……"))

	addtimer(CALLBACK(src, PROC_REF(stress_test_damage_wave), spawned_mobs, 1), 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(stress_test_damage_wave), spawned_mobs, 2), 15 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(stress_test_damage_wave), spawned_mobs, 3), 30 SECONDS)

	if(auto_cleanup)
		addtimer(CALLBACK(src, PROC_REF(stress_test_cleanup), spawned_mobs), 45 SECONDS)
	else
		to_chat(src, span_warning("测试角色将会保留。稍后可使用“清理压力测试角色”指令移除它们。"))
		GLOB.stress_test_mobs = spawned_mobs

/client/proc/stress_test_damage_wave(list/mobs, wave_number)
	if(!mobs || !length(mobs))
		return

	to_chat(src, span_boldnotice("=== 第 [wave_number] 轮伤害 ==="))
	var/start_time = world.timeofday

	for(var/mob/living/carbon/human/H as anything in mobs)
		if(QDELETED(H))
			continue

		apply_random_damage_state(H)
		if(prob(30))
			var/obj/item/bodypart/BP = pick(H.bodyparts)
			if(BP.bandage)
				BP.remove_bandage()
			else if(prob(60))
				var/obj/item/natural/cloth/bandage = new()
				bandage.color = pick("#FFFFFF", "#F5F5DC", "#FFE4E1", "#8B0000")
				BP.try_bandage(bandage)

		H.update_damage_overlays()

	var/update_time = world.timeofday - start_time
	to_chat(src, span_notice("第 [wave_number] 轮完成。已更新 [length(mobs)] 个角色，耗时 [update_time/10] 秒。"))

/client/proc/stress_test_cleanup(list/mobs)
	if(!mobs)
		return

	to_chat(src, span_boldnotice("=== 压力测试完成 ==="))
	to_chat(src, span_notice("正在清理 [length(mobs)] 个测试对象……"))

	var/cleaned = 0
	for(var/mob/living/carbon/human/H as anything in mobs)
		if(!QDELETED(H))
			qdel(H)
			cleaned++

	to_chat(src, span_notice("压力测试清理完成。已删除 [cleaned] 个角色。"))
	to_chat(src, span_notice("请在服务器性能分析器中查看性能数据。"))

/client/proc/equip_stress_test_clothing(mob/living/carbon/human/H)

	var/list/shirts = list(
		/obj/item/clothing/suit/roguetown/shirt/undershirt,
		/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor,
		/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	)
	var/shirt_type = pick(shirts)
	H.equip_to_slot_or_del(new shirt_type(H), SLOT_SHIRT)


	var/list/pants = list(
		/obj/item/clothing/under/roguetown/trou,
		/obj/item/clothing/under/roguetown/trou/leather
	)
	var/pants_type = pick(pants)
	H.equip_to_slot_or_del(new pants_type(H), SLOT_PANTS)


	if(prob(50))
		var/list/armors = list(
			/obj/item/clothing/suit/roguetown/armor/leather,
			/obj/item/clothing/suit/roguetown/armor/leather/hide,
			/obj/item/clothing/suit/roguetown/armor/chainmail,
			/obj/item/clothing/suit/roguetown/armor/plate
		)
		var/armor_type = pick(armors)
		H.equip_to_slot_or_del(new armor_type(H), SLOT_ARMOR)


	var/list/shoes = list(
		/obj/item/clothing/shoes/roguetown/boots,
		/obj/item/clothing/shoes/roguetown/boots/leather
	)
	var/shoes_type = pick(shoes)
	H.equip_to_slot_or_del(new shoes_type(H), SLOT_SHOES)


	if(prob(30))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/leather(H), SLOT_GLOVES)


	if(prob(40))
		var/list/headgear = list(
			/obj/item/clothing/head/roguetown/helmet/leather,
			/obj/item/clothing/head/roguetown/roguehood
		)
		var/head_type = pick(headgear)
		H.equip_to_slot_or_del(new head_type(H), SLOT_HEAD)


	if(prob(20))
		H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/coif(H), SLOT_NECK)


	if(prob(30))
		H.equip_to_slot_or_del(new /obj/item/clothing/cloak/raincloak/brown(H), SLOT_CLOAK)


	H.update_body()
	H.update_hair()
	H.regenerate_icons()

/client/proc/apply_random_damage_state(mob/living/carbon/human/H)
	if(!H || QDELETED(H))
		return


	for(var/obj/item/bodypart/BP as anything in H.bodyparts)

		var/brute = rand(0, 60)
		if(brute > 0)
			BP.receive_damage(brute, 0)


		var/burn = rand(0, 40)
		if(burn > 0)
			BP.receive_damage(0, burn)


		if(prob(30))
			var/list/possible_wounds = list()


			possible_wounds += list(
				/datum/wound/dynamic/bruise,
				/datum/wound/dynamic/slash,
				/datum/wound/dynamic/puncture,
				/datum/wound/dynamic/bite
			)


			if(prob(20))
				possible_wounds += list(
					/datum/wound/fracture,
					/datum/wound/dislocation,
					/datum/wound/artery
				)

			var/wound_type = pick(possible_wounds)
			BP.add_wound(wound_type, silent = TRUE)


		if(prob(20))
			BP.bleeding = rand(1, 5)


		if(prob(5) && BP.body_zone != BODY_ZONE_HEAD)
			var/obj/item/arrow = new /obj/item/ammo_casing/caseless/rogue/arrow(BP)
			BP.add_embedded_object(arrow, silent = TRUE)

		if(prob(25) && !BP.bandage)
			var/obj/item/natural/cloth/bandage = new()
			bandage.color = pick("#FFFFFF", "#F5F5DC", "#FFE4E1", "#8B0000") // white, beige, pink, blood-red
			BP.try_bandage(bandage)


		if(prob(1))
			BP.skeletonized = TRUE

	H.updatehealth()
	for(var/obj/item/bodypart/BP as anything in H.bodyparts)
		BP.update_bodypart_damage_state()


/client/proc/cleanup_stress_test_mobs()
	set name = "清理压力测试角色"
	set category = "调试"

	if(!check_rights(R_DEBUG))
		return

	if(!GLOB.stress_test_mobs || !length(GLOB.stress_test_mobs))
		to_chat(src, span_warning("未找到需要清理的压力测试角色。"))
		return

	var/mob_count = length(GLOB.stress_test_mobs)
	if(alert(usr, "删除 [mob_count] 个压力测试角色？", "确认清理", "是", "否") != "是")
		return

	to_chat(src, span_notice("正在清理 [mob_count] 个压力测试角色……"))

	var/cleaned = 0
	for(var/mob/living/carbon/human/H as anything in GLOB.stress_test_mobs)
		if(!QDELETED(H))
			qdel(H)
			cleaned++

	GLOB.stress_test_mobs = list()
	to_chat(src, span_notice("清理完成。已删除 [cleaned] 个角色。"))
