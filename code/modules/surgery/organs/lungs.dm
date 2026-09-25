/obj/item/organ/lungs
	var/failed = FALSE
	var/operated = FALSE	//whether we can still have our damages fixed through surgery
	name = "肺"
	icon_state = "lungs"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LUNGS
	gender = PLURAL
	w_class = WEIGHT_CLASS_SMALL

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	high_threshold_passed = "<span class='warning'>我感到胸口发紧，呼吸变得又浅又急。</span>"
	now_fixed = "<span class='warning'>我的肺似乎又能吸入空气了。</span>"
	high_threshold_cleared = "<span class='info'>胸口的紧绷感逐渐消退，我的呼吸也平稳下来。</span>"

/obj/item/organ/lungs/on_life()
	..()
	if((!failed) && ((organ_flags & ORGAN_FAILING)))
		if(owner.stat == CONSCIOUS)
			owner.visible_message("<span class='danger'>[owner]抓着自己的喉咙，艰难地喘息！</span>", \
								"<span class='danger'>我突然感觉喘不过气了！</span>")
		failed = TRUE
	else if(!(organ_flags & ORGAN_FAILING))
		failed = FALSE
	return

/obj/item/organ/lungs/prepare_eat()
	var/obj/S = ..()
	return S

/obj/item/organ/lungs/plasmaman
	name = "等离子过滤器"
	desc = ""
	icon_state = "lungs-plasma"


/obj/item/organ/lungs/slime
	name = "液泡"
	desc = ""

/obj/item/organ/lungs/construct
	name = "构装体气源"
	desc = "一块结构复杂的中空晶体，空气以难以理解的方式在其中流动。缕缕蒸汽在它周围盘旋。"
	icon_state = "lungs-con"
	
/obj/item/organ/lungs/t1
	name = "完善肺"
	icon_state = "lungs"
	desc = "完美的造物，感觉它已经……臻于完善。"
	sellprice = 100

/obj/item/organ/lungs/t2
	name = "受祝福的肺"
	icon_state = "lungs"
	desc = "为了击败更大的异端，他们接纳了这种异端。他们称之为祝福，但我们都知道并非如此……"
	sellprice = 200

/obj/item/organ/lungs/t3
	name = "腐化肺"
	icon_state = "lungs"
	desc = "一件受诅咒的扭曲造物。它能为你所用——为了活下去，你愿意付出怎样的牺牲？"
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	sellprice = 300

/datum/status_effect/buff/t1lungs
	id = "t1lungs"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t1lungs

/atom/movable/screen/alert/status_effect/buff/t1lungs
	name = "完善肺"
	desc = "我现在有了更强健的肺。"

/obj/item/organ/lungs/t1/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t1lungs)
		ADD_TRAIT(M, TRAIT_WATERBREATHING, ORGAN_TRAIT)

/obj/item/organ/lungs/t1/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M.has_status_effect(/datum/status_effect/buff/t1lungs))
		M.remove_status_effect(/datum/status_effect/buff/t1lungs)
		REMOVE_TRAIT(M, TRAIT_WATERBREATHING , ORGAN_TRAIT)

/datum/status_effect/buff/t2lungs
	id = "t2lungs"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t2lungs

/atom/movable/screen/alert/status_effect/buff/t2lungs //your helper against mages but not black king bar
	name = "受祝福的肺"
	desc = "受到祝福的肺……也许吧。"

/obj/item/organ/lungs/t2/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t2lungs)
		ADD_TRAIT(M, TRAIT_BREADY, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_ZJUMP, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_WATERBREATHING, ORGAN_TRAIT)


/obj/item/organ/lungs/t2/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M.has_status_effect(/datum/status_effect/buff/t2lungs))
		M.remove_status_effect(/datum/status_effect/buff/t2lungs)
		REMOVE_TRAIT(M, TRAIT_BREADY , ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_ZJUMP , ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_WATERBREATHING , ORGAN_TRAIT)


/datum/status_effect/buff/t3lungs
	id = "t3lungs"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t3lungs

/atom/movable/screen/alert/status_effect/buff/t3lungs
	name = "腐化肺"
	desc = "那受诅咒的东西如今就在我体内。"


/obj/item/organ/lungs/t3/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t3lungs)
		ADD_TRAIT(M, TRAIT_BREADY, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_LEAPER, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_ZJUMP, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_NOBREATH, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_LONGSTRIDER, ORGAN_TRAIT)


/obj/item/organ/lungs/t3/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M.has_status_effect(/datum/status_effect/buff/t3lungs))
		M.remove_status_effect(/datum/status_effect/buff/t3lungs)
		REMOVE_TRAIT(M, TRAIT_BREADY, ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_LEAPER, ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_ZJUMP, ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_NOBREATH, ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_LONGSTRIDER, ORGAN_TRAIT)	
