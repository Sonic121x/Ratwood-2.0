// Port from Vanderlin with AP code for throwing the rock
/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave
	name = "洞穴巨魔"
	desc = "矮人关于巨人和巨魔的传说中常有这些生物的身影——一种血肉与水晶的恐怖融合体，早已背弃了马鲁姆之道。"
	icon = 'icons/roguetown/mob/monster/trolls/troll_cave.dmi'
	health = CAVETROLL_HEALTH
	maxHealth = CAVETROLL_HEALTH
	ai_controller = /datum/ai_controller/troll_cave

	botched_butcher_results = list (
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
		/obj/item/natural/bundle/bone/full = 1,
		/obj/item/alch/horn = 1, 
		/obj/item/natural/hide = 2)
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,
		/obj/item/natural/hide = 3,
		/obj/item/natural/bundle/bone/full = 1,
		/obj/item/alch/sinew = 5,
		/obj/item/alch/horn = 2,
		/obj/item/alch/viscera = 3,
		/obj/item/natural/head/troll/cave = 1,
		)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 5,
		/obj/item/natural/hide = 5,
		/obj/item/natural/bundle/bone/full = 1, 
		/obj/item/alch/sinew = 7, 
		/obj/item/alch/horn = 2, 
		/obj/item/alch/viscera = 3,
		/obj/item/natural/head/troll/cave = 1,
		)

	defprob = 15

/mob/living/simple_animal/hostile/retaliate/rogue/troll/cave/Initialize(mapload)
	. = ..()
	var/datum/action/cooldown/mob_cooldown/stone_throw/throwstone = new(src)
	throwstone.Grant(src)
	ai_controller.set_blackboard_key(BB_TARGETED_ACTION, throwstone)
