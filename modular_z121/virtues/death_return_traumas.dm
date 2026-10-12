// 创伤恢复只建立保存的数据、归属和持续关系，不重新征召玩家或发送催眠命令。
/datum/z121_return_record/proc/restore_trauma(mob/living/carbon/human/H, obj/item/organ/brain/brain, datum/brain_trauma/existing)
	var/datum/brain_trauma/trauma = existing
	var/current_controller
	var/initialized
	if(istype(existing, /datum/brain_trauma/severe/split_personality))
		var/datum/brain_trauma/severe/split_personality/personality = existing
		current_controller = personality.current_controller
		initialized = personality.initialized
	else if(ispath(saved_type, /datum/brain_trauma/hypnosis))
		trauma = new saved_type(values["hypnotic_phrase"])
	else if(ispath(saved_type, /datum/brain_trauma/mild/phobia))
		trauma = new saved_type(values["phobia_type"])
	else if(ispath(saved_type, /datum/brain_trauma/severe/paralysis))
		trauma = new saved_type(values["paralysis_type"])
	else if(ispath(saved_type, /datum/brain_trauma/severe/split_personality/brainwashing))
		trauma = new saved_type(null, null, values["codeword"], values["objective"])
	else
		trauma = new saved_type
	if(QDELETED(trauma))
		CRASH("死亡回归无法构造保存的脑部创伤：[saved_type]")
	apply(trauma)
	trauma.owner = H
	trauma.brain = brain
	brain.traumas += trauma
	LAZYREMOVE(H.z121_return_held_traumas, trauma)
	trauma.UnregisterSignal(H, list(COMSIG_MOB_SAY, COMSIG_MOVABLE_HEAR))
	trauma.RegisterSignal(H, COMSIG_MOB_SAY, TYPE_PROC_REF(/datum/brain_trauma, handle_speech))
	trauma.RegisterSignal(H, COMSIG_MOVABLE_HEAR, TYPE_PROC_REF(/datum/brain_trauma, handle_hearing))
	if(istype(trauma, /datum/brain_trauma/severe/aphasia))
		var/datum/brain_trauma/severe/aphasia/aphasia = trauma
		aphasia.prev_language = new /datum/language_holder(null)
		language_backup?.apply(aphasia.prev_language)
		aphasia.z121_return_bind_mind()
	if(istype(trauma, /datum/brain_trauma/hypnosis))
		H.throw_alert("hypnosis", /atom/movable/screen/alert/hypnosis)
	if(istype(trauma, /datum/brain_trauma/severe/split_personality))
		var/datum/brain_trauma/severe/split_personality/personality = trauma
		personality.z121_return_restored = TRUE
		if(existing)
			personality.current_controller = current_controller
			personality.initialized = initialized
		else
			// 已结束的人格关系不复制玩家；保留病症，但不再次打开征召窗口。
			personality.current_controller = 0
			personality.initialized = FALSE
			personality.make_backseats()
	restore_timers(trauma)
	return trauma

// 换脑中途失败也必须归还暂存人格，不能遗留没有器官归属的玩家座位。
/mob/living/carbon/human/proc/z121_return_release_held_traumas()
	var/obj/item/organ/brain/brain = getorganslot(ORGAN_SLOT_BRAIN)
	for(var/datum/brain_trauma/trauma as anything in z121_return_held_traumas)
		if(QDELETED(trauma))
			continue
		if(brain)
			trauma.brain = brain
			trauma.owner = src
			brain.traumas |= trauma
		else
			try
				qdel(trauma)
			catch(var/exception/error)
				log_game("死亡回归暂存人格收尾异常：[error.file]:[error.line]，[error]")
	z121_return_held_traumas = null

// 新身体承接当前的人格参与者；回退交接时也能将同一实例原路移回。
/mob/living/carbon/human/proc/z121_return_transfer_personalities(mob/living/carbon/human/replacement, rollback = FALSE)
	var/obj/item/organ/brain/old_brain = getorganslot(ORGAN_SLOT_BRAIN)
	var/obj/item/organ/brain/new_brain = replacement.getorganslot(ORGAN_SLOT_BRAIN)
	if(!new_brain)
		return
	for(var/datum/brain_trauma/severe/split_personality/personality in old_brain?.traumas.Copy())
		var/datum/brain_trauma/severe/split_personality/prepared = new_brain.has_trauma_type(personality.type)
		if(!prepared && !rollback)
			continue
		if(prepared)
			var/datum/z121_return_record/R = new(prepared)
			var/current_controller = personality.current_controller
			var/initialized = personality.initialized
			R.apply(personality)
			personality.current_controller = current_controller
			personality.initialized = initialized
			qdel(R)
			qdel(prepared)
		old_brain.traumas -= personality
		personality.UnregisterSignal(src, list(COMSIG_MOB_SAY, COMSIG_MOVABLE_HEAR))
		personality.owner = replacement
		personality.brain = new_brain
		personality.z121_return_restored = TRUE
		new_brain.traumas += personality
		personality.RegisterSignal(replacement, COMSIG_MOB_SAY, TYPE_PROC_REF(/datum/brain_trauma, handle_speech))
		personality.RegisterSignal(replacement, COMSIG_MOVABLE_HEAR, TYPE_PROC_REF(/datum/brain_trauma, handle_hearing))
		for(var/mob/living/split_personality/backseat as anything in list(personality.stranger_backseat, personality.owner_backseat))
			if(!QDELETED(backseat))
				backseat.body = replacement
				backseat.forceMove(replacement)

/datum/brain_trauma/severe/split_personality
	var/z121_return_restored = FALSE

// 保留核心的控制权交接流程；仅阻止恢复病症时向空人格座位转交玩家。
/datum/brain_trauma/severe/split_personality/switch_personalities()
	if(QDELETED(owner) || QDELETED(stranger_backseat) || QDELETED(owner_backseat))
		return
	var/mob/living/split_personality/current_backseat
	var/mob/living/split_personality/free_backseat
	if(current_controller == 0)
		current_backseat = stranger_backseat
		free_backseat = owner_backseat
	else
		current_backseat = owner_backseat
		free_backseat = stranger_backseat
	if(z121_return_restored && !current_backseat.client)
		return
	log_game("[key_name(current_backseat)]因双重人格接管[key_name(owner)]的身体，原控制人格：[current_controller]。")
	to_chat(owner, span_danger("我感觉自己的控制权正在被夺走……现在由另一个人格掌控身体了！"))
	to_chat(current_backseat, span_danger("我成功夺回了自己身体的控制权！"))
	// 当前身体的玩家进入空出的座位。
	var/h2b_id = owner.computer_id
	var/h2b_ip = owner.lastKnownIP
	owner.computer_id = null
	owner.lastKnownIP = null
	free_backseat.ckey = owner.ckey
	free_backseat.name = owner.name
	if(owner.mind)
		free_backseat.mind = owner.mind
	if(!free_backseat.computer_id)
		free_backseat.computer_id = h2b_id
	if(!free_backseat.lastKnownIP)
		free_backseat.lastKnownIP = h2b_ip
	// 另一人格的玩家接管身体。
	var/s2h_id = current_backseat.computer_id
	var/s2h_ip = current_backseat.lastKnownIP
	current_backseat.computer_id = null
	current_backseat.lastKnownIP = null
	owner.ckey = current_backseat.ckey
	owner.mind = current_backseat.mind
	if(!owner.computer_id)
		owner.computer_id = s2h_id
	if(!owner.lastKnownIP)
		owner.lastKnownIP = s2h_ip
	current_controller = !current_controller
