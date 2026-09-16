/obj/item/reagent_containers/peppermill // new with some animated art
	name = "胡椒研磨器"
	desc = "给领主添点风味；转动它的脑袋，直到它开窍为止。"
	icon = 'modular/Neu_Food/icons/cookware/peppermill.dmi'
	icon_state = "peppermill"
	layer = CLOSED_BLASTDOOR_LAYER // obj layer + a little, small obj layering above convenient
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	list_reagents = list(/datum/reagent/consumable/blackpepper = 5)
	reagent_flags = TRANSPARENT

/obj/item/reagent_containers/peppermill/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("左键点击各种熟肉（如煎牛排和鱼柳），即可为它们调味，使其成为更高档的菜肴。")
