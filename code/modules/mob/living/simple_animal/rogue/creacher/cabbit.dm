/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit	//Technically mudcrab subtype, it's a rabbit though. Shrimpler that way.
	name = "猫兔"
	desc = "一只猫兔，当地人最喜爱的动物；既可当宠物，也是美味佳肴。"
	icon = 'icons/roguetown/mob/cabbit.dmi'
	icon_state = "cabbit"
	icon_living = "cabbit"
	icon_dead = "cabbit_dead"
	remains_type = /obj/effect/decal/remains/cabbit
	speak = list("喵！", "Chk!", "呼噜！", "Chrr!")
	speak_emote = list("唧唧叫", "喵喵叫")
	faction = list("cabbits")	//Snowflake code
	emote_hear = list("喵喵叫。", "咯咯叫。")
	emote_see = list("竖起了耳朵。", "用后腿挠了挠耳朵。")
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit = 2)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit = 3, 
							/obj/item/alch/sinew = 1,
							/obj/item/alch/bone = 1,
							/obj/item/natural/fur/rabbit = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit = 4, 
							/obj/item/alch/sinew = 1,
							/obj/item/alch/bone = 1,
							/obj/item/natural/fur/rabbit = 1,
							/obj/item/natural/rabbitsfoot = 1)	//Rare rabbits foot for luck charm.

/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/start_pulling(atom/movable/AM, state, force, supress_message, obj/item/item_override)
	if(client)
		to_chat(src, span_warning("我的小爪子什么也抓不住。"))
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/rabbit/rabbit_alert.ogg')
		if("pain")
			return pick('sound/vo/mobs/rabbit/rabbit_pain1.ogg', 'sound/vo/mobs/rabbit/rabbit_pain2.ogg')
		if("death")
			return pick('sound/vo/mobs/rabbit/rabbit_death.ogg')

/obj/effect/decal/remains/cabbit
	name = "遗骸"
	gender = PLURAL
	icon = 'icons/roguetown/mob/cabbit.dmi'
	icon_state = "cabbit_remains"
