/datum/intent/special
	name = "特殊招式"
	parriable_intent = FALSE
	dodgeable_intent = FALSE
	chargedrain = 0
	chargetime = 0
	noaa = TRUE

/datum/intent/special/on_mmb(atom/target, mob/living/user, params)
	if(!user)
		return
	if(user.incapacitated())
		return
	if(!user.mind)
		return
	if(!user.cmode)
		if(ishuman(user) && ishuman(target))
			var/mob/living/carbon/human/H = user
			H.attempt_steal(user, target)
			return
	if(user.has_status_effect(/datum/status_effect/debuff/specialcd))
		return

	var/obj/item/rogueweapon/W = user.get_active_held_item()
	if(istype(W, /obj/item/rogueweapon) && W.special)
		var/skillreq = W.associated_skill
		if(W.special.custom_skill)
			skillreq = W.special.custom_skill
		if(user.get_skill_level(skillreq) < SKILL_LEVEL_JOURNEYMAN)
			to_chat(user, span_info("我对这种武器的技艺掌握不足，无法使出这招。"))
			return
		W.special.deploy(user, W, target)
	
	. = ..()
