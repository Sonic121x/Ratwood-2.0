#define LIVER_DEFAULT_TOX_TOLERANCE 3 //amount of toxins the liver can filter out
#define LIVER_DEFAULT_TOX_LETHALITY 0.01 //lower values lower how harmful toxins are to the liver

/obj/item/organ/liver
	name = "肝脏"
	icon_state = "liver"
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LIVER
	desc = ""

	maxHealth = STANDARD_ORGAN_THRESHOLD
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	var/alcohol_tolerance = ALCOHOL_RATE//affects how much damage the liver takes from alcohol
	var/toxTolerance = LIVER_DEFAULT_TOX_TOLERANCE//maximum amount of toxins the liver can just shrug off
	var/toxLethality = LIVER_DEFAULT_TOX_LETHALITY//affects how much damage toxins do to the liver
	var/filterToxins = FALSE //whether to filter toxins

#define HAS_SILENT_TOXIN 0 //don't provide a feedback message if this is the only toxin present
#define HAS_NO_TOXIN 1
#define HAS_PAINFUL_TOXIN 2

/obj/item/organ/liver/on_life()
	var/mob/living/carbon/C = owner
	..()	//perform general on_life()
	if(istype(C))
		if(!(organ_flags & ORGAN_FAILING) && !HAS_TRAIT(C, TRAIT_NOMETABOLISM))//can't process reagents with a failing liver

			var/provide_pain_message = HAS_NO_TOXIN
			if(filterToxins && !HAS_TRAIT(owner, TRAIT_TOXINLOVER))
				//handle liver toxin filtration
				for(var/datum/reagent/toxin/T in C.reagents.reagent_list)
					var/thisamount = C.reagents.get_reagent_amount(T.type)
					if (thisamount && thisamount <= toxTolerance)
						C.reagents.remove_reagent(T.type, 1)
					else
						damage += (thisamount*toxLethality)
						if(provide_pain_message != HAS_PAINFUL_TOXIN)
							provide_pain_message = T.silent_toxin ? HAS_SILENT_TOXIN : HAS_PAINFUL_TOXIN

			//metabolize reagents
			C.reagents.metabolize(C, can_overdose=TRUE)

			if(provide_pain_message && damage > 10 && prob(damage/3))//the higher the damage the higher the probability
				to_chat(C, span_warning("我的腹部隐隐作痛。"))

		else	//for when our liver's failing
			C.liver_failure()

	if(damage > maxHealth)//cap liver damage
		damage = maxHealth

/obj/item/organ/liver/Remove(mob/living/carbon/carbon, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	carbon.apply_status_effect(/datum/status_effect/debuff/liver_failure)

/obj/item/organ/liver/Insert(mob/living/carbon/carbon, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	carbon.remove_status_effect(/datum/status_effect/debuff/liver_failure)

#undef HAS_SILENT_TOXIN
#undef HAS_NO_TOXIN
#undef HAS_PAINFUL_TOXIN

/obj/item/organ/liver/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent(/datum/reagent/iron, 5)
	return S

/obj/item/organ/liver/fly
	name = "虫类肝脏"
	icon_state = "liver-x" //xenomorph liver? It's just a black liver so it fits.
	desc = ""
	alcohol_tolerance = 0.007 //flies eat vomit, so a lower alcohol tolerance is perfect!

/obj/item/organ/liver/plasmaman
	name = "试剂处理晶体"
	icon_state = "liver-p"
	desc = ""

/obj/item/organ/liver/construct
	name = "构装体衰变调节器"
	icon_state = "liver-con"
	desc = "构装体的衰变调节器。佩斯特拉的力量在其中流转，防止腐蚀与腐烂。不幸的是，这也使构装体容易受到毒素侵害。"
/obj/item/organ/liver/alien
	name = "异星肝脏" // doesnt matter for actual aliens because they dont take toxin damage
	icon_state = "liver-x" // Same sprite as fly-person liver.
	desc = ""
	toxLethality = LIVER_DEFAULT_TOX_LETHALITY * 2.5 // rejects its owner early after too much punishment
	toxTolerance = 15 // complete toxin immunity like xenos have would be too powerful

/obj/item/organ/liver/cybernetic
	name = "机械肝脏"
	icon_state = "liver-c"
	desc = ""
	organ_flags = ORGAN_SYNTHETIC
	maxHealth = 1.1 * STANDARD_ORGAN_THRESHOLD
	toxTolerance = 3.3
	toxLethality = 0.009

/obj/item/organ/liver/cybernetic/upgraded
	name = "强化机械肝脏"
	icon_state = "liver-c-u"
	desc = ""
	alcohol_tolerance = 0.001
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	toxTolerance = 15 //can shrug off up to 15u of toxins
	toxLethality = 0.008 //20% less damage than a normal liver

/obj/item/organ/liver/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	damage += 100/severity

/obj/item/organ/liver/t1
	name = "完善肝脏"
	icon_state = "liver"
	desc = "佩斯特拉女士的完美杰作。想必这正是她希望看到的模样。干得好，学徒。"
	toxTolerance = 15 //can shrug off up to 15u of toxins
	sellprice = 100

/obj/item/organ/liver/t2
	name = "受祝福的肝脏"
	icon_state = "liver"
	desc = "一颗受到祝福的肝脏。这是仅赐予她的信徒的罕见恩宠。"
	toxTolerance = 35 //can shrug off up to 35u of toxins
	toxLethality = 0.008 //-20% toxin dmg from sources
	sellprice = 200


/obj/item/organ/liver/t3
	name = "腐化肝脏"
	icon_state = "liver"
	desc = "一件受诅咒的扭曲造物。它能为你所用——为了活下去，你愿意付出怎样的牺牲？"
	alcohol_tolerance = 0.001
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	toxTolerance = 50 //ignore up to 50 tox
	toxLethality = 0.005 //-50% toxin dmg from sources
	sellprice = 300

/datum/status_effect/buff/t1liver
	id = "t1liver"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t1liver

/atom/movable/screen/alert/status_effect/buff/t1liver
	name = "完善肝脏"
	desc = "我现在有了一颗更强健的肝脏。"

/obj/item/organ/liver/t1/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t1liver)
		ADD_TRAIT(M, TRAIT_SEA_DRINKER, ORGAN_TRAIT)

/obj/item/organ/liver/t1/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M.has_status_effect(/datum/status_effect/buff/t1liver))
		M.remove_status_effect(/datum/status_effect/buff/t1liver)
		REMOVE_TRAIT(M, TRAIT_SEA_DRINKER, ORGAN_TRAIT)

/datum/status_effect/buff/t2liver
	id = "t2liver"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t2liver

/atom/movable/screen/alert/status_effect/buff/t2liver
	name = "受祝福的肝脏"
	desc = "受到佩斯特拉祝福的器官……"


/obj/item/organ/liver/t2/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t2liver)
		ADD_TRAIT(M, TRAIT_TOXIMMUNE, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_ZOMBIE_IMMUNE, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_SEA_DRINKER, ORGAN_TRAIT)

/obj/item/organ/liver/t2/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M.has_status_effect(/datum/status_effect/buff/t2liver))
		M.remove_status_effect(/datum/status_effect/buff/t2liver)
		REMOVE_TRAIT(M, TRAIT_TOXIMMUNE, ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_ZOMBIE_IMMUNE, ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_SEA_DRINKER, ORGAN_TRAIT)


/datum/status_effect/buff/t3liver
	id = "t3liver"
	alert_type = /atom/movable/screen/alert/status_effect/buff/t3liver

/atom/movable/screen/alert/status_effect/buff/t3liver
	name = "腐化肝脏"
	desc = "那受诅咒的东西如今就在我体内。"


/obj/item/organ/liver/t3/Insert(mob/living/carbon/M)
	..()
	if(M)
		M.apply_status_effect(/datum/status_effect/buff/t3liver)
		ADD_TRAIT(M, TRAIT_TOXIMMUNE, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_ZOMBIE_IMMUNE, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_SEA_DRINKER, ORGAN_TRAIT)
		ADD_TRAIT(M, TRAIT_NOHUNGER, ORGAN_TRAIT)

/obj/item/organ/liver/t3/Remove(mob/living/carbon/M, special = 0)
	..()
	if(M.has_status_effect(/datum/status_effect/buff/t3liver))
		M.remove_status_effect(/datum/status_effect/buff/t3liver)
		REMOVE_TRAIT(M, TRAIT_TOXIMMUNE, ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_ZOMBIE_IMMUNE, ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_SEA_DRINKER, ORGAN_TRAIT)
		REMOVE_TRAIT(M, TRAIT_NOHUNGER, ORGAN_TRAIT)
