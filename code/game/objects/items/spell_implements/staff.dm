/obj/item/rogueweapon/woodstaff/implement
	base_implement_name = "次级法杖"
	name = "次级法杖"
	desc = "镶有次级聚能宝石的法师杖。宝石会捕获施法时逸散到空气中的多余能量，并将其中一小部分返还给持有者。"
	icon = 'icons/obj/items/staffs.dmi'
	icon_state = "topazstaff"
	implement_tier = IMPLEMENT_TIER_LESSER
	implement_refund = IMPLEMENT_REFUND_LESSER
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH)
	gripped_intents = list(/datum/intent/spear/bash/staff, /datum/intent/mace/smash/wood)
	force = 10
	force_wielded = 20
	wdefense = 5
	wdefense_wbonus = 5 // 80% vs one-skill-up matchup. 60% vs two-skill-up matchup. (Rare)
	max_integrity = 200
	special = /datum/special_intent/quarterstaff_sweep
	sellprice = 34

/obj/item/rogueweapon/woodstaff/implement/amethyst
	icon_state = "amethyststaff"

/obj/item/rogueweapon/woodstaff/implement/greater
	base_implement_name = "高等法杖"
	name = "高等法杖"
	desc = "顶端镶有优质聚能宝石的法师杖。宝石会捕获施法时逸散到空气中的多余能量，并将其中相当一部分返还给持有者。"
	icon_state = "emeraldstaff"
	implement_tier = IMPLEMENT_TIER_GREATER
	implement_refund = IMPLEMENT_REFUND_GREATER
	force_wielded = 22
	max_integrity = 250
	sellprice = 42

/obj/item/rogueweapon/woodstaff/implement/greater/ruby
	icon_state = "rubystaff"

/obj/item/rogueweapon/woodstaff/implement/greater/quartz
	icon_state = "quartzstaff"

/obj/item/rogueweapon/woodstaff/implement/greater/sapphire
	icon_state = "sapphirestaff"

/obj/item/rogueweapon/woodstaff/implement/grand
	base_implement_name = "大师法杖"
	name = "大师法杖"
	desc = "镶嵌卓越宝石的杰作法杖。宝石会捕获施法时逸散到空气中的多余能量，并将其中大部分返还给持有者——将奥术的节用之道升华为艺术。"
	icon_state = "diamondstaff"
	implement_tier = IMPLEMENT_TIER_GRAND
	implement_refund = IMPLEMENT_REFUND_GRAND
	force_wielded = 25
	max_integrity = 280
	sellprice = 121

/obj/item/rogueweapon/woodstaff/implement/grand/riddle
	icon_state = "riddlestaff"

/obj/item/rogueweapon/woodstaff/implement/examine(mob/user)
	. = ..()
	if(implement_refund)
		. += span_notice("施法时手持此法器会留下余留专注，在 20 秒内将法术资源消耗的 [round(implement_refund * 100)]% 返还为能量。")


/datum/intent/magos_electrocute
	name = "电击助手"
	blade_class = null
	icon_state = "inuse"
	tranged = TRUE
	noaa = TRUE

/obj/item/rogueweapon/woodstaff/implement/grand/magos
	base_implement_name = null
	name = "\proper 宫廷魔导士法杖"
	icon_state = "courtstaff"
	possible_item_intents = list(SPEAR_BASH, /datum/intent/magos_electrocute)
	gripped_intents = list(/datum/intent/spear/bash/staff, /datum/intent/mace/smash/wood/ranged, /datum/intent/magos_electrocute)
	COOLDOWN_DECLARE(magosstaff)

/obj/item/rogueweapon/woodstaff/implement/grand/magos/afterattack(atom/target, mob/user, flag)
	. = ..()
	if(get_dist(user, target) > 7)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(ishuman(user))
		var/mob/living/carbon/human/HU = user
		if(HU.job != "Court Magician")
			to_chat(user, span_danger("法杖不听从我的指挥。"))
			return
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(H == HU)
				return
			if(!COOLDOWN_FINISHED(src, magosstaff))
				to_chat(user, span_danger("[src]还未准备好！还需 [round(COOLDOWN_TIMELEFT(src, magosstaff) / 10, 1)] 秒！"))
				return
			if(H.anti_magic_check())
				to_chat(user, span_danger("对方的魔法防护打断了我的施法！"))
				return
			if(H.job != "Magicians Associate")
				to_chat(user, span_danger("目标必须是我的助手！"))
				return
			if(istype(user.used_intent, /datum/intent/magos_electrocute))
				HU.visible_message(span_warning("[HU]用[src]电击了[H]。"))
				user.Beam(target,icon_state="lightning[rand(1,12)]",time=5)
				H.electrocute_act(5, src)
				COOLDOWN_START(src, magosstaff, 20 SECONDS)
				to_chat(H, span_danger("宫廷魔导师用雷电惩戒了我！"))
				return

/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel
	base_implement_name = "黑钢法杖"
	name = "黑钢法杖"
	desc = "以黑钢铆钉和配件加固的优质木杖，由毕业于天穹魔导学院的战争魔导师携带。顶端镶有一颗效能稍逊却同样美丽的炼金多佩尔石。或许翠晶能增强它的力量？"
	icon_state = "blacksteelstaff"

/obj/item/rogueweapon/woodstaff/implement/grand/blacksteel
	base_implement_name = "精制黑钢法杖"
	name = "精制黑钢法杖"
	desc = "以黑钢铆钉和配件加固的优质木杖，由毕业于天穹魔导学院的战争魔导师携带。顶端镶有一颗美丽的多佩尔石，闪烁着魔法能量。"
	icon_state = "blacksteelstaff"

/obj/item/rogueweapon/woodstaff/implement/grand/naledi
	base_implement_name = "纳莱迪战杖"
	name = "纳莱迪战杖"
	desc = "这根法杖上承载着普赛顿智慧的新月徽记，以及战学者所用的黑金纹章。"
	icon_state = "naledistaff"

/obj/item/rogueweapon/woodstaff/implement/grand/naledi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8,"sx" = -9,"sy" = 5,"nx" = 9,"ny" = 5,"wx" = -4,"wy" = 4,"ex" = 4,"ey" = 4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 8,"sy" = 0,"nx" = -1,"ny" = 0,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
