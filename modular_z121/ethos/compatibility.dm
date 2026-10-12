// 恢复结束立即以角色记录校正需求和限时心情，不等待三秒轮询。
/datum/z121_return_snapshot/restore(mob/living/carbon/human/H, preparing = FALSE)
	. = ..()
	var/datum/z121_ethos/R = H.z121_get_ethos()
	if(R)
		R.reconcile_stress()
		R.reconcile_social()
		R.sync_effects()

// 仅额外保存本模块的弱来源，不改变身体快照对其他实例引用的过滤规则。
/datum/z121_return_record
	var/list/z121_ethos_doses
	var/list/z121_ethos_healers

/datum/z121_return_record/New(datum/source, list/fields)
	. = ..()
	if(istype(source, /datum/reagent/medicine))
		var/datum/reagent/R = source
		R.z121_ethos_reconcile_doses()
		z121_ethos_doses = list()
		for(var/list/dose as anything in R.z121_ethos_medicine_doses)
			z121_ethos_doses += list(dose.Copy())
	if(istype(source, /datum/status_effect))
		var/datum/status_effect/E = source
		z121_ethos_healers = E.z121_ethos_healer_refs?.Copy()

/datum/z121_return_record/apply(datum/target)
	. = ..()
	if(istype(target, /datum/reagent/medicine) && islist(z121_ethos_doses))
		var/datum/reagent/R = target
		R.z121_ethos_medicine_doses = list()
		for(var/list/dose as anything in z121_ethos_doses)
			R.z121_ethos_medicine_doses += list(dose.Copy())
		R.z121_ethos_reconcile_doses()
	if(istype(target, /datum/status_effect))
		var/datum/status_effect/E = target
		E.z121_ethos_healer_refs = z121_ethos_healers?.Copy()
