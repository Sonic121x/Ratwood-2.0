/obj/structure/ichor_stone
	name = "染血石台"
	desc = "用于安放脓血之牙的基座，也能将它召回！"
	max_integrity = 999999
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stonebig2"

/obj/structure/ichor_stone/attack_hand(mob/living/carbon/human/user)
	if(!istype(user))
		return

	var/datum/antagonist/vampire/vampire = user.mind.has_antag_datum(/datum/antagonist/vampire)
	if(!vampire)
		return

	if(user.clan.clan_leader != user)
		return

	if(user.get_vampire_generation() < GENERATION_METHUSELAH)
		return

	if(user.get_bloodpool() < 500)
		to_chat(user, span_warning("你需要500命髓才能召回你的剑。"))
		return

	var/choice = alert(user, "要消耗500命髓召回脓血之牙吗？", "染血石台", "召回", "取消")
	if(choice != "召回")
		return

	user.adjust_bloodpool(-500)
	new /obj/item/rogueweapon/sword/long/judgement/vlord(get_turf(src))
