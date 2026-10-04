/obj/item/ammo_casing/brutal_round
	name = "齐佐信徒杀手弹"
	desc = "<span class='yellow'><i>我们与齐佐信徒的战争已持续了数十年。至今已有六十多年了。 <br>这场战争令人精疲力竭。不过，凭借王田和兹班图沙漠各地的努力，我们终于造出了超越旧式铅弹的东西。它能把任何行尸打成血肉碎块，把任何骷髅的骨头轰成粉末。<br> 无论他们的阿万廷有多坚硬。</i></span>"
	icon = 'modular/timesoldier/sprites/nu_guns.dmi'
	icon_state = "kz41_bullet"
	caliber = "brutal"
	projectile_type = /obj/projectile/bullet/firearm/brutal_round


/obj/projectile/bullet/firearm/brutal_round
	name = "齐佐信徒杀手弹"
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/tracer/aiming
	color = "#FFD45A"
	dismemberment = 20
	damage = 200
	armor_penetration = 95
	range = 60
	ammo_type = /obj/item/ammo_casing/brutal_round

/obj/item/quiver/bullet/brutals
	name = "暴虐弹药箱"
	desc = "<span class='yellow'><i>这箱子装着专门向齐佐信徒施以暴虐的弹药，也称暴虐弹，或齐佐信徒杀手弹。<br>当王田那个疯矮人发明了这种超越铅弹的弹丸后，整场对抗齐佐的战争都变了。<br>齐佐信徒才勉强让亡灵部队用上黑火药，我们却已经适应了战局，并压倒了他们。</i></span>"
	max_storage = 20 // this might be overkill. oh well!!! :wilted_rose:
	icon = 'modular/timesoldier/sprites/nu_guns.dmi'
	icon_state = "kz_box"

/obj/item/quiver/bullet/brutals/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/brutal_round/B = new()
		arrows += B
	update_icon()


/obj/item/ammo_casing/brutal_round/update_icon()
	..()
	if(!BB)
		icon_state = "kz41_spent"
		name = "齐佐信徒杀手弹空弹壳"
	else
		icon_state = initial(icon_state)
		name = initial(name)


// yummy brain mush
/obj/projectile/bullet/firearm/brutal_round/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if (!ishuman(target))
		return
	
	var/mob/living/carbon/human/H = target

	if(blocked >= 100)
		return
	
	if(check_zone(def_zone) != BODY_ZONE_HEAD)
		return

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/fracture/head/brain, FALSE, TRUE)
	H.death()
	// a reference to simo hayha from record of ragnarok killing a god with a sniper bullet to the head.
	// the bullet is so fucking powerful, it bypasses godmode.
