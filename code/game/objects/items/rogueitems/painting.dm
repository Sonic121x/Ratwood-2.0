
/obj/item/rogue/painting
	name = "画作"
	icon_state = "painting"
	desc = ""
	w_class = WEIGHT_CLASS_NORMAL
	static_price = TRUE
	sellprice = 100
	icon = 'icons/roguetown/items/misc.dmi'
	var/deployed_structure = /obj/structure/fluff/walldeco/painting

/obj/item/rogue/painting/attack_turf(turf/T, mob/living/user)
	if(isclosedturf(T))
		if(get_dir(T,user) in GLOB.cardinals)
			to_chat(user, span_warning("我把[src]挂到了墙上。"))
			var/obj/structure/S = new deployed_structure(user.loc)
			switch(get_dir(T,user))
				if(NORTH)
					S.pixel_y = -32
				if(SOUTH)
					S.pixel_y = 32
				if(WEST)
					S.pixel_x = 32
				if(EAST)
					S.pixel_x = -32
			qdel(src)
			return
	..()

/obj/structure/fluff/walldeco/painting
	name = "画作"
	desc = "作者不详，题材不详。也许是在通往这个现实的道路上，被踩碎的某具尸体的纪念像。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "painting_deployed"
	anchored = TRUE
	density = FALSE
	max_integrity = 0
	layer = ABOVE_MOB_LAYER
	var/stolen_painting = /obj/item/rogue/painting

/obj/structure/fluff/walldeco/painting/attack_hand(mob/user)
	if(do_after(user, 30, target = src))
		var/obj/item/I = new stolen_painting(user.loc)
		user.put_in_hands(I)
		qdel(src)
		return
	..()

/obj/structure/fluff/walldeco/painting/queen
	desc = "画中是费伦提亚的亚历克西娅一世“正直者”瓦尔蒙女王。二十年前，在其父马蒂梅奥国王被巴奥森魅魔诱惑后，她起兵反叛，并以异端罪名将其绑上十字架焚烧。"
	icon_state = "queenpainting_deployed"
	stolen_painting = /obj/item/rogue/painting/queen

/obj/item/rogue/painting/queen
	icon_state = "queenpainting"
	desc = "画中是费伦提亚的亚历克西娅一世“正直者”瓦尔蒙女王。二十年前，在其父马蒂梅奥国王被巴奥森魅魔诱惑后，她起兵反叛，并以异端罪名将其绑上十字架焚烧。这类量产复制画使其价值有所贬低。"
	dropshrink = 0.5
	sellprice = 200
	deployed_structure = /obj/structure/fluff/walldeco/painting/queen

/obj/item/rogue/painting/seraphina
	icon_state = "seraphinapainting"
	desc = "画中是圣职者塞拉菲娜，一世其名，愿其圣名蒙福。"
	dropshrink = 0.5
	sellprice = 200
	deployed_structure = /obj/structure/fluff/walldeco/painting/seraphina

/obj/structure/fluff/walldeco/painting/seraphina
	desc = "画中是圣职者塞拉菲娜，一世其名，愿其圣名蒙福。"
	icon_state = "seraphinapainting_deployed"
	stolen_painting = /obj/item/rogue/painting/seraphina

/obj/item/rogue/painting/skullzhg
	icon_state = "skullpainting"
	desc = "一幅氛围阴郁的场景画：桌上摆着骷髅与蜡烛。切记人终有一死。"
	sellprice = 200
	deployed_structure = /obj/structure/fluff/walldeco/painting/skull

/obj/structure/fluff/walldeco/painting/skull
	desc = "一幅氛围阴郁的场景画：桌上摆着骷髅与蜡烛。切记人终有一死。"
	icon_state = "skullpainting_deployed"
	stolen_painting = /obj/item/rogue/painting/skullzhg
