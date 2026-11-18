/datum/world_trait/dendor_fertility
	name = "登多尔的赐福"
	desc = "提高作物的肥力，使其生长得更快、更茁壮。"

/datum/world_trait/dendor_drought
	name = "登多尔的惩戒"
	desc = "降低作物的肥力，使其生长得更慢。"

/datum/world_trait/pestra_mercy
	name = "佩斯特拉的仁慈"
	desc = "尸体腐烂得更慢。"

/datum/world_trait/matthios_fingers
	name = "马西奥斯之指"
	desc = "提高窃贼扒窃成功的几率。"

/datum/world_trait/necra_requiem
	name = "内克拉的安魂曲"
	desc = "新尸体不会变成尸鬼。"

/datum/world_trait/zizo_defilement
	name = "齐佐的亵渎"
	desc = "尸鬼将在镇中复起。"

/datum/world_trait/zizo_pet_cementery
	name = "齐佐的宠物墓园"
	desc = "尸鬼动物将频繁复起，并取代普通动物出现。"

/datum/world_trait/abyssor_rage
	name = "阿比索尔之怒"
	desc = "溺水会更加致命。"

/datum/world_trait/malum_diligence
	name = "玛勒姆的勤勉"
	desc = "开采岩石时会有额外产出。"
/*	- Unused for now
/datum/world_trait/noc_wisdom
	name = "诺克的智慧"
	desc = "All magic actions cost less mana."
*/
/datum/world_trait/baotha_revelry
	name = "巴奥莎的狂欢"
	desc = "酒精效果持续得更久。"

/datum/world_trait/zizo_blood
	name = "齐佐之血"

/datum/world_trait/zizo_noise
	name = "齐佐之噪音"

/datum/world_trait/zizo_rot
	name = "齐佐之腐朽"
	processes = TRUE
	var/list/spots = list()
	var/next_spawn = 0

/datum/world_trait/zizo_rot/New()
	. = ..()
	for(var/area/rogue/outdoors/town/A in world)
		if(istype(A, /area/rogue/outdoors/town/roofs))
			continue
		for(var/turf/open/floor/T in A)
			spots += T

/datum/world_trait/zizo_rot/process()
	if(world.time < next_spawn || !length(spots))
		return
	for(var/obj/structure/blight_pillar/P as anything in tracked_items.Copy())
		if(QDELETED(P))
			tracked_items -= P
	if(length(tracked_items) >= 6)
		return
	next_spawn = world.time + 5 MINUTES
	var/turf/T = pick(spots)
	if(T.density || (locate(/obj/structure) in T) || (locate(/mob/living) in T))
		return
	tracked_items += new /obj/structure/blight_pillar(T)

/datum/world_trait/zizo_toil
	name = "齐佐之劳役"

/datum/world_trait/zizo_strand
	name = "齐佐之丝缕"

/datum/world_trait/zizo_bite
	name = "齐佐之噬"
