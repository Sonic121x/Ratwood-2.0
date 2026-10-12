GLOBAL_DATUM(z121_ethos_service, /datum/z121_ethos_service)

// 检视信号来自目标，兼容直接调用 examine 的现有交互。
/datum/z121_ethos_service
/datum/z121_ethos_service/proc/register()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_CREATED, PROC_REF(on_created))
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		watch(H)

/datum/z121_ethos_service/proc/on_created(datum/source, mob/created)
	SIGNAL_HANDLER
	if(ishuman(created))
		watch(created)

/datum/z121_ethos_service/proc/watch(mob/living/carbon/human/H)
	RegisterSignal(H, COMSIG_PARENT_EXAMINE, PROC_REF(on_examined))

/datum/z121_ethos_service/proc/on_examined(mob/living/carbon/human/target, mob/viewer, list/lines)
	SIGNAL_HANDLER
	if(ishuman(viewer))
		var/mob/living/carbon/human/H = viewer
		H.z121_get_ethos()?.on_examinate(target)

// 只在本人实际高潮结算后分发，不判断来源、满足感或是否消耗次数。
/datum/sex_controller/after_ejaculation(consume_charge = TRUE)
	. = ..()
	user?.z121_get_ethos()?.on_climax()

/client/toggle_ERP()
	. = ..()
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		H.z121_get_ethos()?.sync_effects()

// 只认可已交付并被接受的食物，不追踪价值或物品往返。
/mob/living/carbon/human/accept_offered_item(mob/living/offerer, obj/offered_item, stealthy)
	. = ..()
	if(!ishuman(offerer) || !istype(offered_item, /obj/item/reagent_containers/food/snacks) || offered_item.loc != src)
		return
	var/mob/living/carbon/human/giver = offerer
	if(giver == src || !client || !giver.client || stat == DEAD || giver.stat == DEAD)
		return
	var/datum/z121_ethos/R = giver.z121_get_ethos()
	if(R?.virtues["charity"])
		R.grant_mood(/datum/stressevent/z121_ethos/charity)

// 包扎前确有流血，完成后绷带确实装在原肢体上，才属于有效照料。
/obj/item/natural/cloth/bandage(mob/living/M, mob/user)
	var/mob/living/carbon/human/patient = ishuman(M) ? M : null
	var/mob/living/carbon/human/healer = ishuman(user) ? user : null
	var/obj/item/bodypart/part = patient?.get_bodypart(check_zone(user?.zone_selected))
	var/needed = part && !part.bandage && part.get_bleed_rate() > 0
	. = ..()
	if(!needed || QDELETED(part) || part.owner != patient || part.bandage != src || !healer || !patient || healer == patient)
		return
	if(!healer.client || !patient.client || healer.stat == DEAD || patient.stat == DEAD)
		return
	var/datum/z121_ethos/R = healer.z121_get_ethos()
	if(R?.virtues["kindness"])
		R.grant_mood(/datum/stressevent/z121_ethos/kindness)

