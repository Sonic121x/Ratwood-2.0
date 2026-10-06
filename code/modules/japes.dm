//Ventriloquism! Make things speak!

/mob/living/carbon/human/proc/ventriloquate()
	set name = "腹语术"
	set category = "戏法"
	
	var/obj/item/grabbing/I = get_active_held_item()
	if(!I)
		to_chat(src, span_warning("我得先拿着或抓住什么东西！"))
		return
	var/message = input(usr, "你想用腹语说些什么？", "腹语术！") as text | null
	if(!message)
		return
	I.say(message)
	log_admin("[key_name(usr)] ventriloquated [I] at [AREACOORD(I)] to say \"[message]\"")

// Ear Trick! Pull objects from behind someone's ear by the will of Xylix!

/mob/living/carbon/human/proc/ear_trick()
	set name = "耳后取物"
	set category = "戏法"

	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	var/obj/item/japery_obj
	japery_obj = get_japery()
	var/obj/item/J = new japery_obj(get_turf(H))


	if(!istype(I) || !ishuman(I.grabbed))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, span_warning("我知道自己耳朵后面有什么！"))
		return
	if(mob_timers["lasttrick"])
		if(world.time < mob_timers["lasttrick"] + 20 SECONDS)
			to_chat(src, span_warning("我得缓一会儿才能再变戏法！"))
			return
	qdel(I)
	src.put_in_hands(J)
	src.visible_message(span_notice("[src]笑着把手伸到[H]耳后，握拳晃了晃，然后亮出了手中的[J]！"))
	mob_timers["lasttrick"] = world.time

/mob/living/carbon/human/proc/get_japery()
	var/japery_list = list(/obj/item/roguecoin/copper,
		/obj/item/roguecoin/silver,
		/obj/item/natural/dirtclod,
		/obj/item/natural/worms,
		/obj/item/natural/thorn,
		/obj/item/natural/stone,
		/obj/item/natural/poo,
		/obj/item/natural/feather,
		/obj/item/natural/worms/leech,
		)
	
	var/japery = pick(japery_list)
	return japery
