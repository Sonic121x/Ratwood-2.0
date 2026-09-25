/mob/living/simple_animal/hostile/retaliate/rogue/troll/axe
	name = "裂颅巨魔"
	desc = "这只似乎比其他巨魔聪明些……而它的斧头足以把人劈成两半。"
	icon = 'icons/roguetown/mob/monster/trolls/troll_axe.dmi'
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll = 5,
		/obj/item/natural/hide = 5,
		/obj/item/natural/bundle/bone/full = 1, 
		/obj/item/alch/sinew = 7, 
		/obj/item/alch/horn = 2, 
		/obj/item/alch/viscera = 3,
		/obj/item/natural/head/troll/axe = 1
	)
	health = CAVETROLL_HEALTH * 1.1 // More health compared to normal troll
	maxHealth = CAVETROLL_HEALTH
	melee_damage_lower = 55 // More damage compared to the normal troll
	melee_damage_upper = 70
	base_intents = list(/datum/intent/simple/troll_axe)
	attack_sound = list('sound/combat/wooshes/blunt/wooshhuge (1).ogg','sound/combat/wooshes/blunt/wooshhuge (2).ogg','sound/combat/wooshes/blunt/wooshhuge (3).ogg')
	loot = list(/obj/item/rogueweapon/stoneaxe/woodcut/troll)

/datum/intent/simple/troll_axe
	name = "巨魔斧"
	icon_state = "instrike"
	attack_verb = list("劈砍", "挥砍", "砍劈", "碾压")
	animname = "blank22"
	hitsound = "genchop"
	blade_class = BCLASS_CHOP
	chargetime = 20
	penfactor = 10
	swingdelay = 3
