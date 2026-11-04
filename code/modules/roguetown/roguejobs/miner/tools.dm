/obj/item/rogueweapon/pick
	force = 17
	force_wielded = 21
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	name = "铁镐"
	desc = "这件工具是在幽暗深处采矿的必需品。"
	icon_state = "pick"
	icon = 'icons/roguetown/weapons/tools.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.8
	wlength = WLENGTH_NORMAL
	max_integrity = 400
	slot_flags = ITEM_SLOT_HIP
	toolspeed = 1
	associated_skill = /datum/skill/labor/mining
	smeltresult = /obj/item/ingot/iron
	grid_width = 64
	grid_height = 64
	is_tool = TRUE

/obj/item/rogueweapon/pick/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -11,"sy" = -8,"nx" = 12,"ny" = -8,"wx" = -5,"wy" = -8,"ex" = 6,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -4,"nx" = -5,"ny" = -4,"wx" = -5,"wy" = -3,"ex" = 7,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -45,"sturn" = 45,"wturn" = -45,"eturn" = 45,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/pick/steel
	name = "钢镐"
	desc = "它有加固的握柄和坚固的镐柄，是深入黑暗矿脉时更为上乘的工具。"
	force = 21
	force_wielded = 28
	icon_state = "steelpick"
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 600
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/pick/bronze
	name = "军团斧镐"
	desc = "所谓的“军团士兵工具”；虽已过时，却仍因用途广泛而备受喜爱。青铜斧刃与镐尖相结合，让它既能应付地表劳作，也能胜任地下作业。"
	force = 20
	force_wielded = 25
	icon_state = "bronzepick"
	possible_item_intents = list(/datum/intent/pick/bad, /datum/intent/axe/chop, /datum/intent/axe/cut, MACE_STRIKE)
	gripped_intents = list(/datum/intent/pick, /datum/intent/axe/chop, /datum/intent/till, /datum/intent/flailthresh)
	max_integrity = 500
	max_blade_int = 225
	sharpness = IS_SHARP
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/pick/woodcutter/dolabra
	name = "debug long dolabra"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "pdolabra"
	gripsprite = TRUE
	force = 28
	force_wielded = 32
	desc = "you shouldn't be seeing this, scream at a coder!"
	dropshrink = 0.7
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/axe/bash/dolabra, /datum/intent/pick)
	gripped_intents = list(/datum/intent/axe/cut/long, /datum/intent/axe/chop/long/woodcutter, /datum/intent/axe/bash/dolabra, /datum/intent/pick/ranged/dolabra)
	max_integrity = 750
	max_blade_int = 1200
	associated_skill = /datum/skill/combat/axes
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK		//Needs to go on back.
	sharpness = IS_SHARP
	resistance_flags = FIRE_PROOF
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	special = /datum/special_intent/greatsword_swing
	
/obj/item/rogueweapon/pick/woodcutter/dolabra/pioneer
	name = "镀金军团斧镐"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "pdolabra"
	desc = "一柄长柄军团斧镐，握柄由硬化枫木雕成。磨损的黑钢斧刃早已失去漆光，刃后伸出一根长镐尖。柄身饰有金色加固箍，顶端装着沉重的金制锤头。"
	force = 30
	force_wielded = 34
	max_integrity = 1000
	wdefense = 6
	wdefense_wbonus = 3
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/axe/bash/dolabra/pioneer, /datum/intent/pick)
	gripped_intents = list(/datum/intent/axe/cut/long/dolabra/pioneer, /datum/intent/axe/chop/long/woodcutter/pioneer, /datum/intent/axe/bash/dolabra/pioneer, /datum/intent/pick/ranged/dolabra/pioneer)
	special = /datum/special_intent/greatsword_swing
	smeltresult = /obj/item/ingot/gold

/obj/item/rogueweapon/pick/woodcutter/dolabra/blacksteel
	name = "黑钢军团斧镐"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "edolabra"
	desc = "一把长柄的鹤嘴斧镐，握柄以硬化枫木雕制而成，前端装有抛光黑钢斧刃，刃后接一长鹤嘴镐头。"
	force = 30
	force_wielded = 34
	max_integrity = 1000 // more than a blacksteel pickaxe
	wdefense = 6
	wdefense_wbonus = 3
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/axe/bash/dolabra, /datum/intent/pick)
	gripped_intents = list(/datum/intent/axe/cut/long, /datum/intent/axe/chop/long/woodcutter, /datum/intent/axe/bash/dolabra, /datum/intent/pick/ranged/dolabra)
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/pick/woodcutter/dolabra/albranze
	name = "铝青铜军团斧镐
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "bdolabra" // albranze is a bronze aluminium mix, aluminium was traditionally more expensive than even silver and gold combined
	desc = "一把长柄鹤嘴斧镐，柄身以处理过的橡木制成，配抛光白铜斧头，刃后接一镐头。"
	wdefense = 6
	wdefense_wbonus = 2
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/pick/woodcutter/dolabra/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 5,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/pick/blacksteel
	name = "黑钢镐"
	desc = "它泛着银黑色的微光，是矿工深入黑暗时所用的名贵工具。"
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	force = 25
	force_wielded = 32
	icon_state = "blacksteelpick1"
	item_state = "blacksteelpick1"
	max_integrity = 800
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/pick/stone
	name = "石镐"
	desc = "石头对上尖石，究竟谁更胜一筹？"
	force = 12
	force_wielded = 17
	icon_state = "stonepick"
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 250
	smeltresult = null

/obj/item/rogueweapon/pick/decrepit
	name = "衰朽镐"
	desc = "一把锻造青铜制成的凿镐，曾被用来采集铸造某种古老合金所需的矿石；而那一切都在她升格之后湮没了。"
	force = 12
	force_wielded = 17
	icon_state = "apick"
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick)
	max_integrity = 150
	smeltresult = /obj/item/ingot/aaslag
	color = "#bb9696"
	sellprice = 15

/obj/item/rogueweapon/pick/copper
	name = "铜镐"
	desc = "一把铜镐，性能比石镐稍好一些。"
	force = 15
	force_wielded = 19
	icon_state = "cpick"
	max_integrity = 325
	smeltresult = /obj/item/ingot/copper
