//Badgers are about a little stronger than raccoons, but still weak compared to wolfs and foxes.
/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger
	icon = 'icons/roguetown/mob/monster/badger.dmi'
	name = "獾"
	desc = "一种充满敌意的小动物，它的攻击性甚至能让一些沃尔夫自愧弗如。"
	icon_state = "badger"
	icon_living = "badger"
	icon_dead = "badger_dead"
	aggressive = 1
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1, /obj/item/natural/bone = 2, /obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/natural/hide = 1,
						/obj/item/alch/sinew = 1, 
						/obj/item/alch/bone = 1, 
						/obj/item/alch/viscera = 1,
						/obj/item/natural/bone = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2, 
						/obj/item/alch/bone = 1, 
						/obj/item/alch/viscera = 1,
						/obj/item/natural/bone = 2,)
	remains_type = /obj/effect/decal/remains/badger
	health = 90
	maxHealth = 90	//Wolf is 120
	simple_detect_bonus = 25	//Good at detecting stealthed people, but not as well as bobcats or raccoons.
	melee_damage_lower = 15
	melee_damage_upper = 22
	STACON = 6
	STASTR = 7
	STASPD = 16	//Pretty fast.

/obj/effect/decal/remains/badger
	name = "遗骸"
	desc = "无论是命运不济还是其他原因，这只獾已经离世。算你走运。"
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/monster/badger.dmi'
