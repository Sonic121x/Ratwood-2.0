// 临时存放物品，不加入地图，也不在提交成功前删除旧装备。
/obj/item/storage/backpack/rogue/satchel/z121_parallel_storage
	name = "职业切换暂存"
	desc = "切换中无法安全取出的物品暂存于此。"

/proc/z121_parallel_slots()
	return list("pants" = SLOT_PANTS, "armor" = SLOT_ARMOR, "shirt" = SLOT_SHIRT, "cloak" = SLOT_CLOAK, "back" = SLOT_BACK, "backl" = SLOT_BACK_L, "backr" = SLOT_BACK_R, "belt" = SLOT_BELT, "beltl" = SLOT_BELT_L, "beltr" = SLOT_BELT_R, "gloves" = SLOT_GLOVES, "shoes" = SLOT_SHOES, "head" = SLOT_HEAD, "mask" = SLOT_WEAR_MASK, "neck" = SLOT_NECK, "glasses" = SLOT_GLASSES, "id" = SLOT_RING, "wrists" = SLOT_WRISTS, "mouth" = SLOT_MOUTH, "l_pocket" = SLOT_L_STORE, "r_pocket" = SLOT_R_STORE, "suit_store" = SLOT_S_STORE)

/proc/z121_parallel_item_tree(atom/root)
	var/list/result = list()
	for(var/obj/item/I in root.contents)
		result |= I
		result |= z121_parallel_item_tree(I)
	return result

/datum/component/martins_morning/proc/commit(datum/z121_profession_plan/P)
	var/mob/living/carbon/human/H = parent
	var/turf/ground = get_turf(H)
	if(!P.valid() || !ground || !profession_compatible(H, P.profession) || !job_compatible(H, P.job))
		return FALSE
	var/datum/z121_profession_record/old = H.z121_profession
	if(!old || old.mind != H.mind)
		return FALSE
	// 不以夹零隐藏未知消费记录；无法安全结算时保留原职业。
	old.reconcile_purchases()
	var/refunds = 0
	for(var/key in old.purchases)
		var/list/payment = old.purchases[key]
		refunds += payment[2]
	if(H.mind.used_spell_points < refunds || H.mind.spell_points - old.points < H.mind.used_spell_points - refunds)
		to_chat(H, span_warning("法术点来源记录与当前账目不一致，今日暂不转换。"))
		return FALSE
	var/list/slots = z121_parallel_slots()
	var/list/previous_slots = list()
	var/list/previous_hands = H.held_items.Copy()
	var/list/old_roots = list()
	for(var/key in slots)
		var/obj/item/I = H.get_item_by_slot(slots[key])
		if(I)
			if(HAS_TRAIT(I, TRAIT_NODROP) || HAS_TRAIT(I, TRAIT_NO_SELF_UNEQUIP))
				return FALSE
			previous_slots[key] = I
			old_roots |= I
	for(var/obj/item/I as anything in previous_hands)
		if(I)
			if(HAS_TRAIT(I, TRAIT_NODROP))
				return FALSE
			old_roots |= I
	var/list/reclaim = list()
	for(var/obj/item/root as anything in old_roots)
		for(var/obj/item/I as anything in list(root) | z121_parallel_item_tree(root))
			if(WEAKREF(I) in old.items)
				reclaim |= I
	var/obj/item/storage/backpack/rogue/satchel/z121_parallel_storage/staging = new
	var/list/new_slots = list()
	var/list/new_hands = list()
	var/list/new_loose = list()
	var/list/new_roots = list()
	var/datum/z121_profession_record/fresh = new(H, P.profession)
	fresh.permanent_virtues = old.permanent_virtues.Copy()
	fresh.keep_prestidigitation = old.keep_prestidigitation
	fresh.unknown = old.unknown
	var/ok = FALSE
	var/abilities_started = FALSE
	var/role_started = FALSE
	var/datum/z121_role_snapshot/role_before = new(H)
	try
		P.outfit.handle_silver_weakness(H)
		// 所有新物品先创建在暂存区；不调用含出生副作用的服装装备过程。
		for(var/key in slots)
			var/path = P.outfit.vars[key]
			if(!ispath(path, /obj/item))
				continue
			var/obj/item/I = new path(staging)
			new_slots[key] = I
			new_roots |= I
		for(var/key in list("l_hand", "r_hand"))
			var/path = P.outfit.vars[key]
			if(ispath(path, /obj/item))
				var/obj/item/I = new path(staging)
				new_hands += I
				new_roots |= I
		for(var/path in P.outfit.backpack_contents)
			var/count = P.outfit.backpack_contents[path]
			if(!isnum(count))
				count = 1
			for(var/i in 1 to count)
				var/obj/item/I = new path(staging)
				new_loose += I
				new_roots |= I
		for(var/obj/item/I as anything in old_roots)
			if(!H.transferItemToLoc(I, staging, FALSE))
				throw EXCEPTION("旧装备无法安全暂存")
		// 私人物品先从待回收容器里取出；失败时整个职业提交终止。
		for(var/obj/item/I as anything in reclaim)
			for(var/obj/item/child as anything in I.contents.Copy())
				if(!(child in reclaim) && !child.forceMove(staging))
					throw EXCEPTION("容器中的私人物品无法安全取出")
		old.suspend(H)
		abilities_started = TRUE
		H.z121_profession = fresh
		P.apply_abilities(fresh)
		for(var/key in new_slots)
			var/obj/item/I = new_slots[key]
			if(!H.equip_to_slot_if_possible(I, slots[key], FALSE, TRUE, TRUE, TRUE))
				I.forceMove(ground)
		for(var/obj/item/I as anything in new_hands)
			H.put_in_hands(I)
			if(I.loc == staging)
				I.forceMove(ground)
		for(var/obj/item/I as anything in new_loose)
			var/inserted = FALSE
			for(var/slot in list(SLOT_BACK_L, SLOT_BACK_R, SLOT_BELT))
				var/obj/item/bag = H.get_item_by_slot(slot)
				if(bag && SEND_SIGNAL(bag, COMSIG_TRY_STORAGE_INSERT, I, null, TRUE, TRUE))
					inserted = TRUE
					break
			if(!inserted)
				I.forceMove(ground)
		if(!P.valid() || !profession_compatible(H, P.profession) || !job_compatible(H, P.job))
			throw EXCEPTION("提交过程中角色或岗位资格已改变")
		for(var/obj/item/I as anything in staging.contents.Copy())
			if(!(I in reclaim) && !I.forceMove(ground))
				throw EXCEPTION("私人物品无法安全落地")
		role_started = TRUE
		change_official_role(H, P, old, role_before)
		ok = TRUE
	catch(var/exception/error)
		log_game("平行存在换装取消：[error]")
	if(!ok)
		if(role_started)
			role_before.restore(H, P)
		if(abilities_started)
			fresh.suspend(H)
			fresh.dispose_suspended(H)
		else
			qdel(fresh)
		H.z121_profession = old
		old.resume(H)
		for(var/obj/item/I as anything in new_roots)
			if(!QDELETED(I))
				if(I.loc == H)
					H.temporarilyRemoveItemFromInventory(I, TRUE)
				qdel(I)
		for(var/key in previous_slots)
			var/obj/item/I = previous_slots[key]
			if(!QDELETED(I) && I.loc != H && !H.equip_to_slot_if_possible(I, slots[key], FALSE, TRUE, TRUE, TRUE))
				I.forceMove(ground)
		for(var/obj/item/I as anything in previous_hands)
			if(!QDELETED(I) && I.loc != H)
				H.put_in_hands(I)
		finish_storage(staging, ground)
		qdel(role_before)
		return FALSE
	// 从此处开始不等待输入；名额与身份一次提交，之后再销毁旧职业物品。
	H.z121_profession = fresh
	fresh.formal_job = P.job
	fresh.job_slot_owned = TRUE
	fresh.class_slot_owned = TRUE
	for(var/obj/item/root as anything in new_roots)
		if(!QDELETED(root))
			for(var/obj/item/I as anything in list(root) | z121_parallel_item_tree(root))
				fresh.items |= WEAKREF(I)
	for(var/obj/item/I as anything in reclaim)
		if(!QDELETED(I))
			qdel(I)
	finish_storage(staging, ground)
	old.dispose_suspended(H)
	qdel(role_before)
	H.mind.check_learnspell()
	H.update_body()
	to_chat(H, span_nicegreen("你如今是【[P.profession.name]】，正式岗位为【[P.job.title]】。私人财物已安全放在脚下。"))
	return TRUE

/datum/component/martins_morning/proc/finish_storage(obj/item/storage/staging, turf/ground)
	for(var/obj/item/I as anything in staging.contents.Copy())
		I.forceMove(ground)
	// 异常物品拒绝移动时也不能随暂存容器被删除，保留可打开的行囊供人工处理。
	if(length(staging.contents))
		staging.forceMove(ground)
	else
		qdel(staging)

/datum/component/martins_morning/proc/change_official_role(mob/living/carbon/human/H, datum/z121_profession_plan/P, datum/z121_profession_record/old, datum/z121_role_snapshot/rollback)
	// 资格查询可能等待数据库；在任何名额写入之前再做一次不等待的原子核对。
	if(!P.valid() || !body_compatible(H, P.profession) || !body_compatible(H, P.job))
		throw EXCEPTION("最终提交时角色资格已失效")
	if(P.profession.maximum_possible_slots >= 0 && P.profession.total_slots_occupied >= P.profession.maximum_possible_slots)
		throw EXCEPTION("进阶职业最后一个名额已被占用")
	if(H.job != P.job.title && P.job.total_positions >= 0 && P.job.current_positions >= P.job.total_positions)
		throw EXCEPTION("正式岗位最后一个名额已被占用")
	var/datum/job/old_job = SSjob.GetJob(H.job)
	var/datum/advclass/old_class = old.profession
	if(!old_class && H.advjob)
		old_class = SSrole_class_handler.get_advclass_by_name(H.advjob)
	if(old_class && old_class.total_slots_occupied > 0)
		old_class.total_slots_occupied--
		rollback.class_changes[old_class] -= 1
	P.profession.total_slots_occupied++
	rollback.class_changes[P.profession] += 1
	if(old_job != P.job)
		if(old_job && old_job.current_positions > 0)
			old_job.current_positions--
			rollback.job_changes[old_job] -= 1
		P.job.current_positions++
		rollback.job_changes[P.job] += 1
	if(old_job)
		for(var/trait in old_job.job_traits)
			REMOVE_TRAIT(H, trait, JOB_TRAIT)
		// 正式岗位工资停止，已有存款与私人财产保留。
		if(old_job.noble_income || old_class?.noble_income)
			SStreasury.noble_incomes -= H
	remove_office_verbs(H)
	if(SSticker.rulermob == H)
		// 任职解除不能广播登基信号；该信号会触发领主出生装备发放。
		SSticker.rulermob = null
	if(SSticker.regentmob == H)
		SSticker.regentmob = null
	H.job = P.job.title
	H.mind.assigned_role = P.job.title
	H.mind.job_bitflag = P.job.flag
	H.advjob = P.profession.name
	H.adaptive_name = P.profession.adaptive_name
	H.mind.cosmetic_class_title = P.cosmetic_title
	H.social_rank = P.social_rank || P.profession.subclass_social_rank || P.job.social_rank
	H.cmode_music = P.music || P.profession.cmode_music || P.job.cmode_music || initial(H.cmode_music)
	for(var/trait in P.job.job_traits)
		ADD_TRAIT(H, trait, JOB_TRAIT)
	for(var/department in GLOB.actors_list)
		var/list/entries = GLOB.actors_list[department]
		entries -= "[H.mobid]"
	var/department = SSjob.bitflag_to_department(P.job.department_flag, P.job.obsfuscated_job)
	var/list/entries = GLOB.actors_list[department]
	if(islist(entries))
		entries["[H.mobid]"] = "[H.real_name] as [P.profession.name]<BR>"
	H.add_credit(TRUE)
	SSrole_class_handler.adjust_class_amount(P.profession, 0)

/datum/component/martins_morning/proc/remove_office_verbs(mob/living/carbon/human/H)
	// 明确的任职命令随岗位撤销，不清除玩家自行获得的其他命令。
	switch(H.job)
		if("Steward")
			H.verbs -= /mob/living/carbon/human/proc/adjust_taxes
		if("Marshal")
			H.verbs -= list(/mob/proc/haltyell, /mob/living/carbon/human/proc/request_outlaw, /mob/living/carbon/human/proc/request_law, /mob/living/carbon/human/proc/request_law_removal, /mob/living/carbon/human/proc/request_purge)
		if("Hand")
			H.verbs -= /datum/job/roguetown/hand/proc/remember_agents
		if("Knight Captain")
			H.verbs -= list(/mob/living/carbon/human/proc/request_outlaw, /mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders, /mob/living/carbon/human/proc/take_squire)

// 只恢复本次修改的岗位字段、名额及展示记录，不恢复生命值或其他局内状态。
/datum/z121_role_snapshot
	var/list/body_values = list()
	var/list/mind_values = list()
	var/list/class_changes = list()
	var/list/job_changes = list()
	var/list/actor_entries = list()
	var/list/job_traits = list()
	var/list/verbs_before
	var/was_ruler
	var/was_regent
	var/had_income
	var/income

/datum/z121_role_snapshot/New(mob/living/carbon/human/H)
	for(var/key in list("job", "advjob", "adaptive_name", "social_rank", "cmode_music"))
		body_values[key] = H.vars[key]
	for(var/key in list("assigned_role", "job_bitflag", "cosmetic_class_title"))
		mind_values[key] = H.mind.vars[key]
	verbs_before = H.verbs.Copy()
	was_ruler = SSticker.rulermob == H
	was_regent = SSticker.regentmob == H
	had_income = (H in SStreasury.noble_incomes)
	income = SStreasury.noble_incomes[H]
	for(var/trait in H.status_traits)
		if(HAS_TRAIT_FROM(H, trait, JOB_TRAIT))
			job_traits |= trait
	for(var/department in GLOB.actors_list)
		var/list/entries = GLOB.actors_list[department]
		if(islist(entries) && ("[H.mobid]" in entries))
			actor_entries[department] = entries["[H.mobid]"]

/datum/z121_role_snapshot/proc/restore(mob/living/carbon/human/H, datum/z121_profession_plan/P)
	for(var/datum/advclass/C as anything in class_changes)
		C.total_slots_occupied -= class_changes[C]
	for(var/datum/job/J as anything in job_changes)
		J.current_positions -= job_changes[J]
	for(var/key in body_values)
		H.vars[key] = body_values[key]
	for(var/key in mind_values)
		H.mind.vars[key] = mind_values[key]
	for(var/trait in P.job.job_traits)
		if(!(trait in job_traits))
			REMOVE_TRAIT(H, trait, JOB_TRAIT)
	for(var/trait in job_traits)
		ADD_TRAIT(H, trait, JOB_TRAIT)
	H.verbs |= verbs_before
	if(was_ruler && !SSticker.rulermob)
		SSticker.rulermob = H
	if(was_regent && !SSticker.regentmob)
		SSticker.regentmob = H
	if(had_income)
		SStreasury.noble_incomes[H] = income
	for(var/department in GLOB.actors_list)
		var/list/entries = GLOB.actors_list[department]
		if(islist(entries))
			entries -= "[H.mobid]"
			if(department in actor_entries)
				entries["[H.mobid]"] = actor_entries[department]
	H.add_credit(TRUE)
