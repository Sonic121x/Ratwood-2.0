/obj/item/natural/chaff
	icon = 'icons/roguetown/items/produce.dmi'
	var/foodextracted = null
	name = "谷秆"
	icon_state = "chaff1"
	desc = "农夫收下的谷秆。" //english is not my native language, upon searching "chaff" i didn't even get what this is.
	var/canthresh = TRUE
	//dropshrink = 0.75

/obj/item/natural/chaff/attack_right(mob/user)
	if(foodextracted && !user.get_active_held_item())
		to_chat(user, span_warning("我开始给[src]脱粒……"))
		if(move_after(user,40, target = src)) //ROGTODO make this based on farming skill and speed
			user.visible_message(span_notice("[user]给[src]脱了粒。"), \
								span_notice("我给[src]脱了粒。"))
			testing("1")
			var/obj/item/G = new foodextracted(get_turf(src))
			user.put_in_active_hand(G)
			new /obj/item/natural/fibers(get_turf(src))
			qdel(src)

/obj/item/natural/chaff/proc/thresh()
	if(foodextracted && canthresh)
		new foodextracted(loc)
		new /obj/item/natural/fibers(loc)
		qdel(src)

/obj/item/natural/chaff/attackby(obj/item/I, mob/living/user, params)
	testing("attackb")
	if(istype(I, /obj/item/rogueweapon/pitchfork))
		if(user.used_intent.type == DUMP_INTENT)
			var/obj/item/rogueweapon/pitchfork/W = I
			if(I.wielded)
				if(isturf(loc))
					var/stuff = 0
					for(var/obj/item/natural/chaff/R in loc)
						if(W.forked.len <= 19)
							R.forceMove(W)
							W.forked += R
							stuff++
					if(stuff)
						to_chat(user, span_notice("我用草叉挑起了谷秆。"))
					else
						to_chat(user, span_warning("我的草叉已经装不下更多谷秆了。"))
					W.update_icon()
					return

	if(istype(I, /obj/item/rogueweapon/mace/woodclub))//reused some commented out code
		var/statboost = user.STASTR*3 + (user?.get_skill_level(/datum/skill/labor/farming)*5) //a person with no skill and 10 strength will thresh about a third of the stalks on average
		var/threshchance = clamp(statboost, 20, 100)
		for(var/obj/item/natural/chaff/C in get_turf(src))
			if(C == src)//so it doesnt delete itself and stop the loop
				continue
			if(prob(threshchance))
				C.thresh()
		user.visible_message(span_notice("[user]正在给谷秆脱粒！"), \
							span_notice("我正在给谷秆脱粒。"))
		user.changeNext_move(CLICK_CD_MELEE)
		playsound(loc,"plantcross", 100, FALSE)
		playsound(loc,"smashlimb", 50, FALSE)
		src.thresh()
		return
	..()

/obj/item/natural/chaff/wheat
	icon_state = "wheatchaff"
	name = "小麦秆"
	foodextracted = /obj/item/reagent_containers/food/snacks/grown/wheat

/obj/item/natural/chaff/oat
	name = "燕麦秆"
	icon_state = "oatchaff"
	foodextracted = /obj/item/reagent_containers/food/snacks/grown/oat

/obj/item/natural/chaff/rice
	name = "稻秆"
	icon_state = "ricechaff"
	foodextracted = /obj/item/reagent_containers/food/snacks/grown/rice
