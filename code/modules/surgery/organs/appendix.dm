/obj/item/organ/appendix
	name = "阑尾"
	icon_state = "appendix"
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_APPENDIX

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	now_failing = "<span class='warning'>我的右下腹突然爆发出一阵剧痛！</span>"
	now_fixed = "<span class='info'>我的腹痛消退了。</span>"

	var/inflamed

/obj/item/organ/appendix/update_icon()
	if(inflamed)
		icon_state = "appendixinflamed"
		name = "发炎的阑尾"
	else
		icon_state = "appendix"
		name = "阑尾"

/obj/item/organ/appendix/on_life()
	..()
	if(!(organ_flags & ORGAN_FAILING))
		return
	var/mob/living/carbon/M = owner
	if(M)
		M.adjustToxLoss(4, TRUE, TRUE)	//forced to ensure people don't use it to gain tox as slime person

/obj/item/organ/appendix/Remove(mob/living/carbon/M, special = 0)
	update_icon()
	..()

/obj/item/organ/appendix/prepare_eat()
	var/obj/S = ..()
	if(inflamed)
		S.reagents.add_reagent(/datum/reagent/toxin/bad_food, 5)
	return S
