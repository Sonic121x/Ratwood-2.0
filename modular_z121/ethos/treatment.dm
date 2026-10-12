// 治疗来源按操作保存；并行法术互不覆盖，异常退出也会撤销自己的来源。
/proc/z121_ethos_provider_ref(mob/living/carbon/human/H)
	return WEAKREF(H.mind ? H.mind : H)

/proc/z121_ethos_resolve_provider(datum/weakref/source_ref)
	var/datum/source = source_ref?.resolve()
	if(istype(source, /datum/mind))
		var/datum/mind/M = source
		source = M.current
	return ishuman(source) && !QDELETED(source) ? source : null

/mob/living/carbon/human
	var/list/z121_ethos_treatments = list()

/datum/z121_ethos_treatment
	var/datum/weakref/patient_ref
	var/list/provider_refs = list()
	var/mob/call_user

/datum/z121_ethos_treatment/New(mob/living/carbon/human/patient, provider)
	patient_ref = WEAKREF(patient)
	var/list/providers = islist(provider) ? provider : list(provider)
	for(var/mob/living/carbon/human/H in providers)
		if(H != patient)
			provider_refs |= z121_ethos_provider_ref(H)
	call_user = usr
	patient.z121_ethos_treatments += src

/datum/z121_ethos_treatment/Destroy()
	var/mob/living/carbon/human/H = patient_ref?.resolve()
	if(H && !QDELETED(H))
		H.z121_ethos_treatments.Remove(src)
	provider_refs.Cut()
	call_user = null
	return ..()

/mob/living/carbon/human/proc/z121_ethos_treatment_providers()
	for(var/i = length(z121_ethos_treatments), i >= 1, i--)
		var/datum/z121_ethos_treatment/T = z121_ethos_treatments[i]
		// 等待中的施法不能替其他调用栈或自然恢复署名。
		if(T.call_user && T.call_user == usr)
			var/list/providers = list()
			for(var/datum/weakref/ref in T.provider_refs)
				var/mob/living/carbon/human/H = z121_ethos_resolve_provider(ref)
				if(H && !QDELETED(H))
					providers |= H
			return providers
	// 范围法术的初始目标可以是地块，实际受治者仍应认领当前施法者。
	if(ishuman(usr) && usr != src)
		var/mob/living/carbon/human/caster = usr
		if(length(caster.z121_ethos_spell_scopes))
			return list(caster)
	return list()

/mob/living/carbon/human/proc/z121_ethos_treated_by(list/providers)
	for(var/mob/living/carbon/human/H in providers)
		z121_get_ethos(TRUE).treated(H)

/obj/effect/proc_holder/spell/perform(list/targets, recharge = TRUE, mob/user = usr)
	var/mob/saved_user = usr
	var/datum/z121_ethos_spell_scope/combat
	if(isliving(user))
		usr = user
		combat = new(user)
	var/list/scopes = list()
	if(ishuman(user))
		for(var/mob/living/carbon/human/H in targets)
			scopes += new /datum/z121_ethos_treatment(H, user)
	try
		. = ..()
	catch(var/exception/error)
		QDEL_LIST(scopes)
		qdel(combat)
		usr = saved_user
		throw error
	QDEL_LIST(scopes)
	qdel(combat)
	usr = saved_user

/datum/surgery_step/initiate(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, try_to_fail = FALSE)
	var/mob/saved_user = usr
	if(user)
		usr = user
	var/datum/z121_ethos_treatment/T
	if(ishuman(target) && ishuman(user))
		T = new(target, user)
	try
		. = ..()
	catch(var/exception/error)
		qdel(T)
		usr = saved_user
		throw error
	qdel(T)
	usr = saved_user

// 局部治疗、整体治疗和直接减伤都汇入肢体；只认实际减少的伤害。
/obj/item/bodypart/heal_damage(brute, burn, stamina, required_status, updating_health = TRUE)
	var/mob/living/carbon/human/H = ishuman(owner) ? owner : null
	var/list/providers = H?.z121_ethos_treatment_providers()
	var/before = brute_dam + burn_dam
	. = ..()
	if(H && !QDELETED(H) && length(providers) && brute_dam + burn_dam < before)
		H.z121_ethos_treated_by(providers)

/datum/wound/heal_wound(heal_amount)
	var/mob/living/carbon/human/H = ishuman(owner) ? owner : null
	var/list/providers = H?.z121_ethos_treatment_providers()
	. = ..()
	if(. > 0 && H && !QDELETED(H) && length(providers))
		H.z121_ethos_treated_by(providers)

// 缝合、烧灼与止血法术可只改变流血，不一定调用伤口治疗入口。
/datum/wound/set_bleed_rate(amount)
	var/mob/living/carbon/human/H = ishuman(owner) ? owner : null
	var/list/providers = H?.z121_ethos_treatment_providers()
	var/before = bleed_rate
	. = ..()
	if(!QDELETED(src) && H && !QDELETED(H) && bleed_rate < before && length(providers))
		H.z121_ethos_treated_by(providers)

// 实体治疗保留明确施治者；仅实际减伤或止血入口能够发奖。
/obj/item/needle/sew(mob/living/target, mob/living/user)
	var/mob/saved_user = usr
	usr = user
	var/datum/z121_ethos_treatment/T
	if(ishuman(target) && ishuman(user))
		T = new(target, user)
	try
		. = ..()
	catch(var/exception/error)
		qdel(T)
		usr = saved_user
		throw error
	qdel(T)
	usr = saved_user

/obj/item/flashlight/flare/torch/singe(mob/living/target, mob/living/user)
	var/mob/saved_user = usr
	usr = user
	var/datum/z121_ethos_treatment/T
	if(ishuman(target) && ishuman(user))
		T = new(target, user)
	try
		. = ..()
	catch(var/exception/error)
		qdel(T)
		usr = saved_user
		throw error
	qdel(T)
	usr = saved_user

/obj/item/rogueweapon/hammer/hammerheal(mob/living/M, mob/user)
	var/mob/saved_user = usr
	usr = user
	var/datum/z121_ethos_treatment/T
	if(ishuman(M) && ishuman(user))
		T = new(M, user)
	try
		. = ..()
	catch(var/exception/error)
		qdel(T)
		usr = saved_user
		throw error
	qdel(T)
	usr = saved_user

/datum/status_effect
	var/list/z121_ethos_healer_refs

/mob/living/carbon/human/apply_status_effect(effect, ...)
	var/list/providers = z121_ethos_treatment_providers()
	var/datum/status_effect/previous = has_status_effect(effect)
	var/previous_end = previous?.duration
	. = ..(arglist(args))
	var/datum/status_effect/E = .
	// 核心刷新已存在的状态不返回实例，只在实际延长后更新来源。
	if(!istype(E) && previous && !QDELETED(previous) && previous.status_type == STATUS_EFFECT_REFRESH && previous.duration > previous_end)
		E = previous
	if(istype(E))
		E.z121_ethos_healer_refs = list()
		for(var/mob/living/carbon/human/H in providers)
			E.z121_ethos_healer_refs |= z121_ethos_provider_ref(H)

// 歌曲在后续脉冲才向听众施加效果，来源应为当前演奏者。
/datum/status_effect/buff/playing_melody/tick()
	var/mob/saved_user = usr
	var/datum/z121_ethos_spell_scope/scope
	if(ishuman(owner))
		usr = owner
		scope = new(owner)
	try
		. = ..()
	catch(var/exception/error)
		qdel(scope)
		usr = saved_user
		throw error
	qdel(scope)
	usr = saved_user

/datum/status_effect/process()
	var/mob/saved_user = usr
	var/mob/living/carbon/human/H = ishuman(owner) ? owner : null
	var/list/providers = list()
	for(var/datum/weakref/ref in z121_ethos_healer_refs)
		var/mob/living/carbon/human/provider = z121_ethos_resolve_provider(ref)
		if(provider && !QDELETED(provider))
			providers |= provider
	var/datum/z121_ethos_treatment/T
	if(H && length(providers))
		// 后台过程使用受治者作调用者；施治者只从记录读取，不冒充其主动攻击。
		usr = H
		T = new(H, providers)
	try
		. = ..()
	catch(var/exception/error)
		qdel(T)
		usr = saved_user
		throw error
	qdel(T)
	usr = saved_user

// 混合药剂按施用份额保存来源；消耗按混合比例扣除，不让最后一滴认领整份。
/datum/reagent
	var/list/z121_ethos_medicine_doses = list()

/datum/reagent/proc/z121_ethos_reconcile_doses(available = null)
	if(isnull(available))
		available = volume
	available = max(0, available)
	var/recorded = 0
	for(var/list/dose as anything in z121_ethos_medicine_doses)
		recorded += dose[2]
	if(recorded > available)
		for(var/list/dose as anything in z121_ethos_medicine_doses)
			dose[2] *= available / recorded
	else if(recorded < available)
		z121_ethos_medicine_doses += list(list(null, available - recorded))

/datum/reagent/proc/z121_ethos_add_dose(mob/provider, amount)
	z121_ethos_reconcile_doses(max(0, volume - amount))
	var/datum/weakref/source_ref = ishuman(provider) && provider != holder?.my_atom ? z121_ethos_provider_ref(provider) : null
	for(var/list/dose as anything in z121_ethos_medicine_doses)
		if(dose[1] == source_ref)
			dose[2] += amount
			return
	z121_ethos_medicine_doses += list(list(source_ref, amount))

/datum/reagent/proc/z121_ethos_medicine_providers()
	z121_ethos_reconcile_doses()
	var/list/providers = list()
	for(var/list/dose as anything in z121_ethos_medicine_doses)
		var/datum/weakref/source_ref = dose[1]
		var/mob/living/carbon/human/H = z121_ethos_resolve_provider(source_ref)
		if(dose[2] > 0 && H && !QDELETED(H))
			providers |= H
	return providers

/datum/reagents
	var/list/z121_ethos_transfers = list()

/datum/z121_ethos_medicine_transfer
	var/datum/reagents/destination
	var/mob/provider
	var/mob/call_user

/datum/z121_ethos_medicine_transfer/New(datum/reagents/target, mob/giver)
	destination = target
	provider = giver
	call_user = usr
	destination.z121_ethos_transfers += src

/datum/z121_ethos_medicine_transfer/Destroy()
	if(destination && !QDELETED(destination))
		destination.z121_ethos_transfers.Remove(src)
	destination = null
	provider = null
	call_user = null
	return ..()

/datum/reagents/trans_to(obj/target, amount = 1, multiplier = 1, preserve_data = TRUE, no_react = FALSE, mob/transfered_by, remove_blacklisted = FALSE, method = null, show_message = TRUE, round_robin = FALSE, prepend = FALSE)
	var/datum/reagents/destination = istype(target, /datum/reagents) ? target : target?.reagents
	var/datum/z121_ethos_medicine_transfer/transfer
	if(ishuman(destination?.my_atom))
		transfer = new(destination, transfered_by)
	try
		. = ..(arglist(args))
	catch(var/exception/error)
		qdel(transfer)
		throw error
	qdel(transfer)

// 在单味药剂进入身体时立即记录，后续反应与代谢都能读取正确来源。
/datum/reagents/add_reagent(reagent, amount, list/data = null, reagtemp = 300, no_react = 0, prepend = FALSE)
	var/datum/reagent/old = has_reagent(reagent)
	var/before = old ? old.volume : 0
	if(istype(old, /datum/reagent/medicine))
		old.z121_ethos_reconcile_doses()
	. = ..()
	if(!ishuman(my_atom))
		return
	var/datum/reagent/R = has_reagent(reagent)
	if(!istype(R, /datum/reagent/medicine) || R.volume <= before)
		return
	var/mob/provider
	for(var/i = length(z121_ethos_transfers), i >= 1, i--)
		var/datum/z121_ethos_medicine_transfer/transfer = z121_ethos_transfers[i]
		if(transfer.call_user == usr)
			provider = transfer.provider
			break
	R.z121_ethos_add_dose(provider, R.volume - before)

/proc/z121_ethos_metabolize_reagent(datum/reagent/R, mob/living/carbon/C)
	var/mob/saved_user = usr
	var/mob/living/carbon/human/H = ishuman(C) ? C : null
	var/list/providers = istype(R, /datum/reagent/medicine) ? R.z121_ethos_medicine_providers() : list()
	var/datum/z121_ethos_treatment/T
	if(H && length(providers))
		usr = H
		T = new(H, providers)
	// 噬血者的血液进食不是食用试剂子类，同样属于进食营养。
	var/feeding = H && istype(R, /datum/reagent/blood) && HAS_TRAIT(H, TRAIT_HEMOPHAGE)
	if(feeding)
		H.z121_ethos_food_depth++
	try
		. = R.on_mob_life(C)
	catch(var/exception/error)
		qdel(T)
		if(feeding && !QDELETED(H))
			H.z121_ethos_food_depth--
		usr = saved_user
		throw error
	qdel(T)
	if(feeding && !QDELETED(H))
		H.z121_ethos_food_depth--
	usr = saved_user

