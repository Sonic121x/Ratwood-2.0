/obj/item/organ/stomach
	name = "胃"
	icon_state = "stomach"
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_PRECISE_STOMACH
	slot = ORGAN_SLOT_STOMACH
	attack_verb = list("刺穿", "挤压", "扇打", "消化")
	desc = ""

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	low_threshold_passed = span_info("我的胃一阵刺痛，随后又平息下来。现在似乎不适合吃东西。")
	high_threshold_passed = span_warning("我的胃持续剧痛——现在光是想到食物就让我难以忍受！")
	high_threshold_cleared = span_info("我的胃痛暂时缓解了，但依然毫无食欲。")
	low_threshold_cleared = span_info("我的胃痛终于完全消退了。")

	var/disgust_metabolism = 1

/obj/item/organ/stomach/on_life()
	var/mob/living/carbon/human/H = owner
	var/datum/reagent/Nutri

	..()
	if(istype(H))
		if(!(organ_flags & ORGAN_FAILING))
			H.dna.species.handle_digestion(H)
		handle_disgust(H)

	if(damage < low_threshold)
		return

	Nutri = locate(/datum/reagent/consumable/nutriment) in H.reagents.reagent_list

	if(Nutri)
		if(prob((damage/40) * Nutri.volume * Nutri.volume))
			H.vomit(damage)
			to_chat(H, span_warning("我的胃翻搅着疼痛，吃下的食物全都要吐出来了！"))

	else if(Nutri && damage > high_threshold)
		if(prob((damage/10) * Nutri.volume * Nutri.volume))
			H.vomit(damage)
			to_chat(H, span_warning("我的胃翻搅着疼痛，吃下的食物全都要吐出来了！"))

/obj/item/organ/stomach/proc/handle_disgust(mob/living/carbon/human/H)
	if(H.disgust)
		var/pukeprob = 5 + 0.05 * H.disgust
		if(H.disgust >= DISGUST_LEVEL_GROSS)
			if(prob(10))
				H.stuttering += 1
				H.confused += 2
			if(prob(10) && !H.stat)
				to_chat(H, span_warning("我感觉有些不舒服……"))
			H.jitteriness = max(H.jitteriness - 3, 0)
		if(H.disgust >= DISGUST_LEVEL_VERYGROSS)
			if(prob(pukeprob)) //iT hAndLeS mOrE ThaN PukInG
				H.confused += 2.5
				H.stuttering += 1
				H.vomit(10, 0, 1, 0, 1, 0)
			H.Dizzy(5)
		if(H.disgust >= DISGUST_LEVEL_DISGUSTED)
			if(prob(25))
				H.blur_eyes(3) //We need to add more shit down here

		H.adjust_disgust(-0.5 * disgust_metabolism)
	switch(H.disgust)
		if(0 to DISGUST_LEVEL_GROSS)
			H.clear_alert("disgust")
		if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
			H.throw_alert("disgust", /atom/movable/screen/alert/gross)
		if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
			H.throw_alert("disgust", /atom/movable/screen/alert/verygross)
		if(DISGUST_LEVEL_DISGUSTED to INFINITY)
			H.throw_alert("disgust", /atom/movable/screen/alert/disgusted)

/obj/item/organ/stomach/Remove(mob/living/carbon/M, special = 0)
	var/mob/living/carbon/human/H = owner
	if(istype(H))
		H.clear_alert("disgust")
	..()

/obj/item/organ/stomach/fly
	name = "虫类胃"
	icon_state = "stomach-x" //xenomorph liver? It's just a black liver so it fits.
	desc = ""

/obj/item/organ/stomach/plasmaman
	name = "消化晶体"
	icon_state = "stomach-p"
	desc = ""

/obj/item/organ/stomach/construct
	name = "构装体魂种"
	icon_state = "stomach-con"
	desc = "构装体灵魂的居所，位于本该是胃的位置。缕缕灵辉在四周流转，无法抓住。"

/obj/item/organ/stomach/ethereal
	name = "生物电池"
	icon_state = "stomach-p" //Welp. At least it's more unique in functionaliy.
	desc = ""
	var/crystal_charge = ETHEREAL_CHARGE_FULL

/obj/item/organ/stomach/ethereal/on_life()
	..()
	adjust_charge(-ETHEREAL_CHARGE_FACTOR)

/obj/item/organ/stomach/ethereal/Insert(mob/living/carbon/M, special = 0)
	..()
	RegisterSignal(owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, PROC_REF(charge))
	RegisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))

/obj/item/organ/stomach/ethereal/Remove(mob/living/carbon/M, special = 0)
	UnregisterSignal(owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT)
	UnregisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT)
	..()

/obj/item/organ/stomach/ethereal/proc/charge(datum/source, amount, repairs)
	adjust_charge(amount / 70)

/obj/item/organ/stomach/ethereal/proc/on_electrocute(datum/source, shock_damage, siemens_coeff = 1, flags = NONE)
	if(flags & SHOCK_ILLUSION)
		return
	adjust_charge(shock_damage * siemens_coeff * 2)
	to_chat(owner, span_notice("我的身体吸收了部分电击能量！"))

/obj/item/organ/stomach/ethereal/proc/adjust_charge(amount)
	crystal_charge = CLAMP(crystal_charge + amount, ETHEREAL_CHARGE_NONE, ETHEREAL_CHARGE_FULL)

/obj/item/organ/stomach/t1
	name = "完善胃"
	icon_state = "stomach"
	desc = "完美的造物，感觉它已经……臻于完善。"
	sellprice = 100

/obj/item/organ/stomach/t2
	name = "受祝福的胃"
	icon_state = "stomach"
	desc = "为了击败更大的异端，他们接纳了这种异端。他们称之为祝福，但我们都知道并非如此……"
	sellprice = 200

/obj/item/organ/stomach/t3
	name = "腐化胃"
	icon_state = "stomach"
	desc = "一件受诅咒的扭曲造物。它能为你所用——为了活下去，你愿意付出怎样的牺牲？"
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	sellprice = 300

/datum/status_effect/buff/t1stomach
	id = "t1stomach"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t1stomach

/atom/movable/screen/alert/status_effect/buff/t1stomach
	name = "完善胃"
	desc = "我现在有了一个更强健的胃。"

/obj/item/organ/stomach/t1/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t1stomach)
		ADD_TRAIT(M, TRAIT_ROT_EATER, ORGAN_TRAIT)

/obj/item/organ/stomach/t1/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M.has_status_effect(/datum/status_effect/buff/t1stomach))
		M.remove_status_effect(/datum/status_effect/buff/t1stomach)
		REMOVE_TRAIT(M, TRAIT_ROT_EATER , ORGAN_TRAIT)

/datum/status_effect/buff/t2stomach
	id = "t2stomach"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t2stomach

/atom/movable/screen/alert/status_effect/buff/t2stomach
	name = "受祝福的胃"
	desc = "一个受祝福的胃……也许吧。"

/obj/item/organ/stomach/t2/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t2stomach)
		ADD_TRAIT(M, TRAIT_ROT_EATER, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_WILD_EATER, ORGAN_TRAIT)


/obj/item/organ/stomach/t2/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M.has_status_effect(/datum/status_effect/buff/t2stomach))
		M.remove_status_effect(/datum/status_effect/buff/t2stomach)
		REMOVE_TRAIT(M, TRAIT_ROT_EATER , ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_WILD_EATER , ORGAN_TRAIT)

/datum/status_effect/buff/t3stomach
	id = "t3stomach"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t3stomach

/atom/movable/screen/alert/status_effect/buff/t3stomach
	name = "腐化胃"
	desc = "那受诅咒的东西如今就在我体内。"

/obj/item/organ/stomach/t3/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t3stomach)
		ADD_TRAIT(M, TRAIT_NASTY_EATER, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_ORGAN_EATER, ORGAN_TRAIT)


/obj/item/organ/stomach/t3/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M.has_status_effect(/datum/status_effect/buff/t3stomach))
		M.remove_status_effect(/datum/status_effect/buff/t3stomach)
		REMOVE_TRAIT(M, TRAIT_NASTY_EATER, ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_ORGAN_EATER, ORGAN_TRAIT)
