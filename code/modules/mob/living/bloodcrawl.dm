/obj/effect/dummy/phased_mob/slaughter //Can't use the wizard one, blocked by jaunt/slow
	name = "water"
	icon = 'icons/effects/effects.dmi'
	icon_state = "nothing"
	density = FALSE
	anchored = TRUE
	invisibility = 60
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/canmove = TRUE

/obj/effect/dummy/phased_mob/slaughter/relaymove(mob/user, direction)
	forceMove(get_step(src,direction))

/obj/effect/dummy/phased_mob/slaughter/ex_act()
	return

/obj/effect/dummy/phased_mob/slaughter/bullet_act()
	return BULLET_ACT_FORCE_PIERCE

/mob/living/proc/phaseout(obj/effect/decal/cleanable/B)
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		for(var/obj/item/I in C.held_items)
			//TODO make it toggleable to either forcedrop the items, or deny
			//entry when holding them
			// literally only an option for carbons though
			to_chat(C, span_warning("血中潜行时，我不能拿着物品！"))
			return FALSE
		var/obj/item/bloodcrawl/B1 = new(C)
		var/obj/item/bloodcrawl/B2 = new(C)
		B1.icon_state = "bloodhand_left"
		B2.icon_state = "bloodhand_right"
		C.put_in_hands(B1)
		C.put_in_hands(B2)
		C.regenerate_icons()

	notransform = TRUE
	INVOKE_ASYNC(src, PROC_REF(bloodpool_sink), B)

	return TRUE

/mob/living/proc/bloodpool_sink(obj/effect/decal/cleanable/B)
	var/turf/mobloc = get_turf(loc)

	visible_message(span_warning("[src]沉入了血泊！"))
	playsound(get_turf(src), 'sound/blank.ogg', 50, TRUE, -1)
	// Extinguish, unbuckle, stop being pulled, set our location into the
	// dummy object
	var/obj/effect/dummy/phased_mob/slaughter/holder = new /obj/effect/dummy/phased_mob/slaughter(mobloc)
	extinguish_mob()

	// Keep a reference to whatever we're pulling, because forceMove()
	// makes us stop pulling
	var/pullee = pulling

	holder = holder
	forceMove(holder)

	// if we're not pulling anyone, or we can't eat anyone
	if(!pullee || bloodcrawl != BLOODCRAWL_EAT)
		notransform = FALSE
		return

	// if the thing we're pulling isn't alive
	if(!isliving(pullee))
		notransform = FALSE
		return

	var/mob/living/victim = pullee
	var/kidnapped = FALSE

	if(victim.stat == CONSCIOUS)
		visible_message(span_warning("[victim]在沉入血泊前一刻踢蹬着挣脱了！"), null, span_notice("我听到泼溅与挣扎声。"))
	else
		victim.forceMove(src)
		victim.emote("scream")
		visible_message(span_warning("<b>[src]将[victim]拖入血泊！</b>"), null, span_notice("我听到一声泼溅声。"))
		kidnapped = TRUE

	if(kidnapped)
		var/success = bloodcrawl_consume(victim)
		if(!success)
			to_chat(src, span_danger("我欢快地吞噬了……空气？我的食物不知何时消失了！"))

	notransform = FALSE
	return TRUE

/mob/living/proc/bloodcrawl_consume(mob/living/victim)
	to_chat(src, span_danger("我开始吞食[victim]... 在此期间无法移动。"))

	var/sound = 'sound/blank.ogg'

	for(var/i in 1 to 3)
		playsound(get_turf(src),sound, 50, TRUE)
		sleep(30)

	if(!victim)
		return FALSE

	if(victim.reagents)
		to_chat(src, span_warning("<b>啊！对方的血肉！好烫！</b>"))
		adjustBruteLoss(25) //I can't use adjustHealth() here because bloodcrawl affects /mob/living and adjustHealth() only affects simple mobs
		var/found_bloodpool = FALSE
		for(var/obj/effect/decal/cleanable/target in range(1,get_turf(victim)))
			if(target.can_bloodcrawl_in())
				victim.forceMove(get_turf(target))
				victim.visible_message(span_warning("[target]猛然吐出了[victim]！"))
				victim.exit_blood_effect(target)
				found_bloodpool = TRUE

		if(!found_bloodpool)
			// Fuck it, just eject them, thanks to some split second cleaning
			victim.forceMove(get_turf(victim))
			victim.visible_message(span_warning("[victim]凭空出现，浑身是血！"))
			victim.exit_blood_effect()
		return TRUE

	to_chat(src, span_danger("我吞噬了[victim]。我的生命值完全恢复了。"))
	revive(full_heal = TRUE, admin_revive = FALSE)

	// No defib possible after laughter
	victim.adjustBruteLoss(1000)
	victim.death()
	bloodcrawl_swallow(victim)
	return TRUE

/mob/living/proc/bloodcrawl_swallow(mob/living/victim)
	qdel(victim)

/obj/item/bloodcrawl
	name = "血中潜行"
	desc = ""
	icon = 'icons/effects/blood.dmi'
	item_flags = ABSTRACT | DROPDEL

/obj/item/bloodcrawl/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/mob/living/proc/exit_blood_effect(obj/effect/decal/cleanable/B)
	playsound(get_turf(src), 'sound/blank.ogg', 50, TRUE, -1)
	//Makes the mob have the color of the blood pool it came out of
	var/newcolor = rgb(149, 10, 10)
	if(istype(B, /obj/effect/decal/cleanable/xenoblood))
		newcolor = rgb(43, 186, 0)
	add_atom_colour(newcolor, TEMPORARY_COLOUR_PRIORITY)
	// but only for a few seconds
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, remove_atom_colour), TEMPORARY_COLOUR_PRIORITY, newcolor), 6 SECONDS)

/mob/living/proc/phasein(obj/effect/decal/cleanable/B)
	if(notransform)
		to_chat(src, span_warning("先吃完再说！"))
		return FALSE
	B.visible_message(span_warning("[B]开始冒泡..."))
	if(!do_after(src, 20, target = B))
		return
	if(!B)
		return
	forceMove(B.loc)
	client.eye = src
	visible_message(span_boldwarning("[src]从血泊中升起！"))
	exit_blood_effect(B)
	if(iscarbon(src))
		var/mob/living/carbon/C = src
		for(var/obj/item/bloodcrawl/BC in C)
			BC.flags_1 = null
			qdel(BC)
	QDEL_NULL(holder)
	return TRUE
