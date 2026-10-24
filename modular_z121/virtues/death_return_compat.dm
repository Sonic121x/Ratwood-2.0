// 只迁移已审查的美德组件；物品、寄生关系及其他角色的组件不随新身体复制。
/proc/z121_return_virtue_components()
	return list(/datum/component/ancient_existence, /datum/component/hellblood_descendant, /datum/component/succubus_bloodline, /datum/component/life_potential, /datum/component/distortion_variant, /datum/component/martins_morning, /datum/component/z121_serpent_belly)

// 只保存属性、经验和特性的撤销账本；岗位、法术、账户和职业实例仍属于当前世界。
/datum/z121_return_profession
	var/source_ref
	var/list/stats = list()
	var/list/experience = list()
	var/list/independent_experience = list()
	var/list/observed_experience = list()
	var/list/traits = list()

/datum/z121_return_profession/New(mob/living/carbon/human/H)
	var/datum/skill_holder/skills = H.ensure_skills()
	observed_experience = skills.skill_experience.Copy()
	independent_experience = observed_experience.Copy()
	var/datum/z121_profession_record/R = H.z121_profession
	if(!R || R.suspended)
		return
	source_ref = REF(R)
	stats = R.stats.Copy()
	experience = R.experience.Copy()
	traits = R.traits.Copy()
	// 经验表以技能数据为键，必须保留键；不能用丢弃数据对象的通用复制函数。
	for(var/datum/skill/skill as anything in experience)
		var/total = observed_experience[skill] || 0
		if(!(skill in R.observed_experience))
			continue
		var/previous = R.observed_experience[skill] || 0
		var/independent = R.independent_experience[skill] || 0
		var/delta = total - previous
		if(delta > 0)
			independent += delta
		else if(delta < 0)
			independent = max(0, independent - max(0, -delta - max(0, previous - independent)))
		independent_experience[skill] = independent

/datum/z121_return_profession/proc/restore(mob/living/carbon/human/H, list/source_map)
	var/datum/z121_profession_record/R = H.z121_profession
	if(!R)
		return
	// 当前职业承接存档中实际存在的身体加成，下一次转职只能扣除这些加成。
	R.stats = stats.Copy()
	R.experience = experience.Copy()
	R.independent_experience = independent_experience.Copy()
	R.observed_experience = observed_experience.Copy()
	R.removed_experience.Cut()
	R.traits = traits.Copy()
	if(source_ref)
		source_map[source_ref] = REF(R)

/proc/z121_return_subtract_sources(list/traits, list/excluded)
	for(var/trait in excluded)
		var/list/sources = traits[trait]
		if(!sources)
			continue
		sources -= excluded[trait]
		if(!length(sources))
			traits -= trait

// 装备使用物品独立来源，永久能力使用通用来源；两者不能混合回滚。
/mob/living/carbon/human/proc/z121_return_equipment_traits()
	var/list/result = list()
	var/list/equipment = get_equipped_items() | held_items
	var/list/external_sources = list()
	for(var/datum/status_effect/E as anything in status_effects)
		if(!z121_return_bodily_status(E))
			external_sources |= TRAIT_STATUS_EFFECT(E.id)
	for(var/trait in status_traits)
		for(var/source in status_traits[trait])
			var/from_equipment = FALSE
			if(source in external_sources)
				from_equipment = TRUE
			if(source in list(CLOTHING_TRAIT, "redlens", "cursedmask", "castificocollar"))
				from_equipment = TRUE
			if(istext(source))
				var/source_type = text2path(source)
				if(ispath(source_type, /obj/item/clothing))
					from_equipment = TRUE
				for(var/obj/item/I as anything in equipment)
					if(!QDELETED(I) && findtext(source, REF(I)))
						from_equipment = TRUE
						break
			if(from_equipment)
				var/list/sources = result[trait]
				if(!sources)
					sources = list()
					result[trait] = sources
				sources |= source
	return result

/mob/living/carbon/human/proc/z121_return_cancel_ability_sessions()
	var/datum/component/martins_morning/parallel = GetComponent(/datum/component/martins_morning)
	parallel?.cancel_session()
	var/datum/component/distortion_variant/distortion = GetComponent(/datum/component/distortion_variant)
	if(distortion)
		for(var/datum/timedevent/T as anything in distortion.active_timers?.Copy())
			if(T.callBack?.delegate in list(TYPE_PROC_REF(/datum/component/distortion_variant, begin_distortion), TYPE_PROC_REF(/datum/component/distortion_variant, finish_distortion)))
				qdel(T)
		distortion.night_in_progress = FALSE

// 这里迁移的是回归时仍存在的身份及能力，不重放职业、入团或美德奖励。
/mob/living/carbon/human/proc/z121_return_transfer_identity(mob/living/carbon/human/replacement, rollback = FALSE)
	replacement.advjob = advjob
	z121_return_transfer_personalities(replacement, rollback)
	z121_return_transfer_external_effects(replacement)
	// 保留资源、已学能力和冷却，只更换宿主；不重新发放职业奖励。
	if(devotion && devotion.holder == src)
		devotion.holder = replacement
		replacement.devotion = devotion
		devotion = null
	if(inspiration && inspiration.holder == src)
		inspiration.holder = replacement
		replacement.inspiration = inspiration
		inspiration = null
	var/list/resource_verbs = list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray, /mob/living/carbon/human/proc/setaudience, /mob/living/carbon/human/proc/clearaudience, /mob/living/carbon/human/proc/checkaudience, /mob/living/carbon/human/proc/picksongs, /mob/living/carbon/human/proc/resetsongs, /mob/living/carbon/human/proc/pickrhythms, /mob/living/carbon/human/proc/resetrhythms)
	for(var/ability in resource_verbs)
		if(ability in verbs)
			replacement.verbs |= ability
			verbs -= ability
	if(z121_profession)
		var/datum/z121_profession_record/record = z121_profession
		record.UnregisterSignal(src, COMSIG_QDELETING)
		record.body = WEAKREF(replacement)
		record.RegisterSignal(replacement, COMSIG_QDELETING, TYPE_PROC_REF(/datum/z121_profession_record, on_body_deleted))
		replacement.z121_profession = record
		z121_profession = null
	for(var/component_type in z121_return_virtue_components())
		var/datum/component/ability = GetComponent(component_type)
		if(ability)
			replacement.TakeComponent(ability)
	// 身体持有的法术也移动原实例，保留冷却；不重复生成或删除已经学会的能力。
	for(var/datum/S in mob_spell_list.Copy())
		mob_spell_list -= S
		if(!QDELETED(S) && !(S in replacement.mob_spell_list))
			replacement.AddSpell(S)
	for(var/datum/fellowship/F as anything in GLOB.fellowships)
		F.z121_return_transfer_member(src, replacement)
	SScity_assembly?.z121_return_transfer_member(src, replacement)

/datum/component/ancient_existence/PostTransfer()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/hellblood_descendant/PostTransfer()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/succubus_bloodline/PostTransfer()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/life_potential/PostTransfer()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(on_health_update))

/datum/component/distortion_variant/PostTransfer()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_MOB_NIGHTED, PROC_REF(on_nighted))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/martins_morning/PostTransfer()
	// 仅重绑监听，保留原来的清晨编号与次数，不重新启动入场流程。
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_MOB_DAWNED, PROC_REF(on_dawned))
	RegisterSignal(parent, list(COMSIG_LIVING_DEATH, COMSIG_MOB_LOGOUT, COMSIG_MIND_TRANSFER, COMSIG_QDELETING, SIGNAL_REMOVETRAIT(TRAIT_MARTINS_MORNING), SIGNAL_ADDTRAIT(TRAIT_NOSLEEP), SIGNAL_ADDTRAIT(TRAIT_SLEEPIMMUNE)), PROC_REF(on_invalidated))

/datum/component/z121_serpent_belly/PreTransfer()
	var/mob/living/carbon/human/host = parent
	// 腹中人及物品按旧身体的死亡方式释放，不能借回归传送其他角色。
	on_host_lost()
	clear_channel_signals()
	UnregisterSignal(host, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_MOB_LOGIN, COMSIG_MOVABLE_MOVED))
	host.verbs -= /mob/living/carbon/human/proc/z121_serpent_toggle_digestion
	host.mob_spell_list -= swallow_spell
	host.mob_spell_list -= release_spell
	REMOVE_TRAIT(host, "蛇腹者", REF(src))

/datum/component/z121_serpent_belly/PostTransfer()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/human/host = parent
	host.AddSpell(swallow_spell)
	host.AddSpell(release_spell)
	ADD_TRAIT(host, "蛇腹者", REF(src))
	RegisterSignal(host, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING), PROC_REF(on_host_lost))

/datum/fellowship/proc/z121_return_transfer_member(mob/living/previous, mob/living/replacement)
	var/datum/weakref/old_ref = find_member_ref(previous)
	if(old_ref)
		members[members.Find(old_ref)] = WEAKREF(replacement)
		if(leader == old_ref)
			leader = WEAKREF(replacement)
		UnregisterSignal(previous, COMSIG_QDELETING)
		RegisterSignal(replacement, COMSIG_QDELETING, PROC_REF(on_member_qdel))
		previous.current_fellowship = null
		previous.faction -= faction_tag
		replacement.current_fellowship = src
		replacement.faction |= faction_tag
	for(var/invitee_name in pending_invites)
		var/list/entry = pending_invites[invitee_name]
		var/datum/weakref/invitee = entry[2]
		if(invitee?.resolve() != previous)
			continue
		entry[2] = WEAKREF(replacement)
		previous.incoming_fellowship_invites -= WEAKREF(src)
		replacement.incoming_fellowship_invites |= WEAKREF(src)
	if(old_ref)
		push_updates()

// 核心人类死亡会先撤销职位、再发送死亡信号，因此在职位入口保留正在回归者。
// 不接管核心死亡实现；辞职、罢免、谴责及管理移除继续立即生效。
/datum/controller/subsystem/city_assembly/demote_alderman(reason = "vacated")
	var/mob/current = resolve_get_alderman()
	if(!current)
		alderman_ref = null
		return
	if(reason == "Alderman has died" && ishuman(current))
		var/mob/living/carbon/human/H = current
		var/datum/component/z121_death_return/controller = H.z121_return_controller()
		if(controller?.begin_return())
			controller.held_office = TRUE
			return
	REMOVE_TRAIT(current, TRAIT_ALDERMAN, "assembly")
	log_game("市政议会：[key_name(current)] 的市政长老职位被移除（[reason]）。")
	alderman_ref = null
	current_warrant?.reset()
	invalidate_tallies()

/datum/controller/subsystem/city_assembly/proc/z121_return_transfer_member(mob/previous, mob/replacement)
	var/datum/weakref/old_ref = WEAKREF(previous)
	var/datum/weakref/new_ref = WEAKREF(replacement)
	if(alderman_ref == old_ref)
		alderman_ref = new_ref
		REMOVE_TRAIT(previous, TRAIT_ALDERMAN, "assembly")
		ADD_TRAIT(replacement, TRAIT_ALDERMAN, "assembly")
	if(old_ref in censured_refs)
		censured_refs[censured_refs.Find(old_ref)] = new_ref
		ADD_TRAIT(replacement, TRAIT_ALDERMAN_CENSURED, "assembly")
	if(current_session)
		if(old_ref in current_session.candidates)
			current_session.candidates[new_ref] = current_session.candidates[old_ref]
			current_session.candidates -= old_ref
		for(var/motion in current_session.ballots)
			var/list/votes = current_session.ballots[motion]
			if(old_ref in votes)
				votes[new_ref] = votes[old_ref]
				votes -= old_ref
			if(motion == ASSEMBLY_MOTION_ELECTION)
				for(var/voter in votes)
					var/list/ballot = votes[voter]
					if(ballot["choice"] == REF(old_ref))
						ballot["choice"] = REF(new_ref)
	invalidate_tallies()
