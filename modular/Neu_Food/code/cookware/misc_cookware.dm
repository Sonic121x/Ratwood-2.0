// Please only put REALLY, REALLY MISCELLANEOUS stuff in here. Like rolling pins
/obj/item/kitchen/rollingpin
	name = "擀面杖"
	desc = "一根木制擀面杖，用来将面团压成薄片。"
	icon = 'modular/Neu_Food/icons/cookware/misc.dmi'
	icon_state = "rolling_pin"
	force = 8
	throwforce = 5
	throw_speed = 1
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("猛击", "殴打", "棒打", "抽打", "重打")
	custom_price = 20
	grid_width = 32
	grid_height = 64
	experimental_onhip = TRUE
	experimental_inhand = TRUE
	associated_skill = /datum/skill/craft/cooking //Same deal as the frypan!

/obj/item/kitchen/rollingpin/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -10,"sy" = 0,"nx" = 11,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/kitchen/rollingpin/get_mechanics_examine(mob/user)
    . = ..()
    . += span_info("左键点击一团面团——无论是揉成球状还是切成两半——即可进一步将其擀平。")

/obj/item/kitchen/rollingpin/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user]开始用[src]把自己的脑袋擀平！看起来是在自杀！</span>")
	return BRUTELOSS

/obj/item/tablecloth/silk
	name = "丝绸桌布"
	desc = "一块华美的丝绸桌布，专为外交宴席和其他重要场合铺设。"
	icon = 'modular/Neu_Food/icons/cookware/misc.dmi'
	icon_state = "tablecloth_silk"
	sellprice = 40
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 32
	grid_height = 64
	var/wet = 0
