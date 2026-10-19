/obj/item/rogueweapon/greatsword
	force = 12
	force_wielded = 30
	possible_item_intents = list(/datum/intent/sword/chop, /datum/intent/sword/strike) //bash is for nonlethal takedowns, only targets limbs
	// Design Intent: I have a big fucking sword and I want to cut everything in sight.
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/thrust/zwei, /datum/intent/sword/cut/zwei/cleave, /datum/intent/sword/cut/zwei/sweep)
	alt_grips = list(/datum/alt_grip/mordhau/greatsword, /datum/alt_grip/halfsword/greatsword)
	name = "大剑"
	desc = "说不定真能把什么东西都一剑劈成两半！"
	icon_state = "gsw"
	parrysound = list(
		'sound/combat/parry/bladed/bladedlarge (1).ogg',
		'sound/combat/parry/bladed/bladedlarge (2).ogg',
		'sound/combat/parry/bladed/bladedlarge (3).ogg',
		)
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	swingsound = BLADEWOOSH_HUGE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 9
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/swords
	max_blade_int = 300
	wdefense = 5
	smelt_bar_num = 3
	special = /datum/special_intent/greatsword_swing

/obj/item/rogueweapon/greatsword/getonmobprop(tag)
	. = ..()
	if(tag == "altgrip" && .)
		return .
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("altgrip")
				return list("shrink" = 0.6,"sx" = 4,"sy" = 0,"nx" = -7,"ny" = 1,"wx" = -8,"wy" = 0,"ex" = 8,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -135,"sturn" = -35,"wturn" = 45,"eturn" = 145,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 1,"nx" = 0,"ny" = 1,"wx" = 2,"wy" = 0,"ex" = 0,"ey" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/greatsword/elfgsword
	name = "精灵双手大刀"
	desc = "一柄优雅的巨剑，闪亮的长刃虽长得骇人，却轻盈得不可思议。与多数精灵大师之作不同，它的握柄包覆着玫瑰皮革；这是一道不祥的宣告，昭示它将用来讨伐威胁精灵一族的敌人。"
	icon_state = "elfkriegmesser"
	item_state = "elfkriegmesser"
	minstr = 10
	wdefense = 7
	sellprice = 120

/obj/item/rogueweapon/greatsword/iron
	name = "铁制大剑"
	desc = "一柄需要双手才能妥善挥动的巨型铁剑。比同类钢剑更沉、更不结实，但仍能胜任杀敌的职责。"
	icon_state = "igsw"
	max_blade_int = 200
	max_integrity = 200
	wdefense = 4
	smelt_bar_num = 3
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/greatsword/ancient/decrepit
	name = "朽败大剑"
	desc = "一柄由腐朽金属打造的巨刃。它大得难以称为剑，厚重、沉笨，粗糙得不像话。与其说是剑，不如说是一堆未经雕琢的生铁。"
	force = 10
	force_wielded = 25
	max_integrity = 150
	icon_state = "ancient_gsw"
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	randomize_blade_int_on_init = TRUE


/obj/item/rogueweapon/greatsword/ancient
	name = "远古大剑"
	desc = "一柄由打磨光亮的吉尔青铜锻成的巨刃。你的族类终会在狂怒与毁灭中认清自身本性。你们将踏上群星之路，把它们一颗接一颗燃尽。直到最后一颗星辰也化作尘埃，你才会明白，祂试图将你们从人类最大的敌人手中拯救出来；那便是虚无。"
	icon_state = "ancient_gsw"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/greatsword/zwei
	name = "克莱摩大剑"
	desc = "这把剑比寻常大剑长得多，而且平衡也相当不错！"
	icon_state = "claymore"
	smeltresult = /obj/item/ingot/iron
	smelt_bar_num = 3
	max_blade_int = 220
	wdefense = 4
	force = 14
	force_wielded = 35

/obj/item/rogueweapon/greatsword/grenz
	name = "双手剑"
	icon_state = "steelzwei"
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 3
	max_blade_int = 240
	wdefense = 4
	force = 14
	force_wielded = 35

/obj/item/rogueweapon/greatsword/grenz/flamberge
	name = "焰形剑"
	desc = "这是格伦泽尔霍夫特式“双手剑”的近亲，深受奥塔瓦贵族青睐。其名源自那独特的火焰形剑身；这种工艺唯有普赛顿最出色的武匠方能驾驭。"
	icon_state = "steelflamberge"
	max_blade_int = 180
	max_integrity = 130
	wdefense = 6

/obj/item/rogueweapon/greatsword/grenz/flamberge/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/greatsword/grenz/flamberge/malum
	name = "炉魔焰形剑"
	desc = "这把剑的诞生本身就是一道谜。为了铸成一柄品质完美的利刃，有人付出了巨大的牺牲。"
	icon_state = "malumflamberge"
	max_integrity = 200
	max_blade_int = 200

/obj/item/rogueweapon/greatsword/grenz/flamberge/ravox
	name = "箴罚"
	desc = "一柄会令人联想到希望的剑。仿佛能看见那些披着碎裂板甲、肩披焦黑肩甲的 \
	人， 侍立在祂身侧。为纠正祂犯下的过错，他们曾试图向神圣暴政降下谴罚 \
	。 <small>即便到了现在，它仍带着灰烬的气味。</small>"
	icon_state = "ravoxflamberge"
	max_integrity = 240
	max_blade_int = 240
	wdefense = 7//You are truly unique, m'lord.

/obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel
	name = "黑钢焰形剑"
	desc = "这是一种并不常见的剑，拥有标志性的波浪形剑身，而铸造它的金属同样 \
	稀有。 人们认为剑刃上的起伏让它呈现出火焰般的姿态，使其看上去 \
	格外骇人。 “燃火之剑”常常是奥塔瓦史诗与其他骑士故事中的主角。"
	icon_state = "blackflamb"
	force = 25
	force_wielded = 40
	max_blade_int = 200
	smeltresult = /obj/item/ingot/blacksteel
	smelt_bar_num = 2 // Okay you CAN get a refund on the blacksteel
	var/used = FALSE
	var/list/selection = list(
		/datum/special_intent/greatsword_swing,
		/datum/special_intent/side_sweep,
		/datum/special_intent/limbguard
		)

/obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel/examine(mob/user)
	. = ..()
	if(!used)
		. += span_notice("此武器的特殊招式可以更换。用空手右键点击它，即可选择一种。此操作仅可进行一次。")

/obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel/attack_right(mob/user)
	. = ..()
	if(used)
		return

	var/list/special_options = list()
	for(var/intent in selection)
		var/datum/special_intent/S = intent // Hate this DM quirk.
		special_options[S::name] = S

	var/choice = input(user, "选择招式", "招式") as anything in special_options
	if(choice)
		qdel(special)
		var/datum/special_intent/S = special_options[choice]
		special = new S()
		used = TRUE

/obj/item/rogueweapon/greatsword/silver
	name = "银制巨剑"
	desc = "一柄装有巨大纯银剑刃的巨剑，深受西奥尼卡教团圣武士的青睐。这个武装修会致力于 \
	保护前往苍蓝之地的朝圣者。</br>“命运并非天定，而是由我们亲手铸就。决定普赛多尼亚未来的， \
	并非诸神的意志，而是她的儿女心中的希望。”"
	icon_state = "silverexealt"
	force = 8
	force_wielded = 25
	minstr = 11
	wdefense = 6
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greatsword/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/psygsword
	name = "普赛顿大剑"
	desc = "相传，一位普赛顿信徒铁匠受圣玛勒姆亲自指引，铸成了这柄威武的利刃，奉命斩杀 \
	肆虐奥塔万农田的恶魔。其图样后来被寻回并加以研究，却只造出少量仿品——他们相信，仿造会使原刃失去锋芒。"
	icon_state = "silverexealt"
	force = 8
	force_wielded = 30
	minstr = 11
	wdefense = 6
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/greatsword/psygsword/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/psygsword/relic
	name = "“秘典”"
	desc = "在奥塔瓦最宏伟的马赛克壁画中，圣拉沃克斯仅戴着喙盔、系着腰布，手持如此威严的巨兵， \
	迎战凶星格拉加尔。无论这件圣物是否真曾为神明所持，其无与伦比的力量 \
	仍足以令最强大的敌人倒下。站稳吧，神的孩子，将那些不可饶恕者逐回地狱。"
	force = 30
	force_wielded = 35
	icon_state = "psygsword"
	possible_item_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/thrust/exe, /datum/intent/sword/chop/heavy, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/thrust/heavy, /datum/intent/sword/chop/cleave, /datum/intent/rend)
	minstr = 13
	minstr_req = TRUE

/obj/item/rogueweapon/greatsword/psygsword/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/psygsword/relic/getonmobprop(tag)
	. = ..()
	if(tag == "altgrip" && .)
		return .
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("altgrip")
				return list("shrink" = 0.45,"sx" = 2,"sy" = 3,"nx" = -7,"ny" = 1,"wx" = -8,"wy" = 0,"ex" = 8,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -135,"sturn" = -35,"wturn" = 45,"eturn" = 145,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)

/obj/item/rogueweapon/greatsword/bsword/psy
	name = "被遗忘之刃"
	desc = "“愿祂之名不再被遗忘。”</br>一位传奇勇士留下的遗物，其姓名早已湮没于岁月。即便如此，黯淡的 \
	银刃仍闪烁着超凡的力量，誓要驱邪、除恶、坚忍到底。"
	icon_state = "oldpsybroadsword"
	force = 15
	force_wielded = 25
	minstr = 11
	wdefense = 6
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/chop/heavy, /datum/intent/sword/thrust/long, /datum/intent/rend/krieg)
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/chop/heavy, /datum/intent/sword/thrust/estoc/lunge, /datum/intent/sword/thrust/estoc)
	alt_grips = list(/datum/alt_grip/mordhau/broadsword/forgotten_blade)
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greatsword/bsword/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 10,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/bsword/psy/unforgotten
	name = "未被遗忘之刃"
	desc = "“愿祂之名不再被遗忘。”</br>大审判官阿奇博尔德曾记下一支由七位英勇裁决者组成的远征队，深入格隆恩积雪荒原 \
	铲除邪恶。相传领队圣律令官吉耶曼面对身披暗钢甲的异端坚守了七天七夜，终于让普赛顿认可了他的 \
	坚忍。最后只留下他的剑，普赛圣十字缠绕剑柄，寄托追思。"
	icon_state = "forgottenblade"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greatsword/bsword/psy/unforgotten/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 10,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/bsword/psy/relic
	name = "“信条”"
	desc = "普赛顿信徒的祈祷与十神信徒铁匠的技艺合而为一，铸成诛灭四恶神的武器。此刃巨大沉重，深得圣拉沃克斯青睐，用以 \
	扫除威胁祂子民的敌人。护手上的普赛圣十字映照着诺克最微弱的光。你就是光，为他们照亮前路。"
	icon_state = "psybroadsword"
	force = 25
	force_wielded = 25
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greatsword/bsword/psy/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.5, "sx" = -14, "sy" = -8, "nx" = 15, "ny" = -7, "wx" = -10, "wy" = -5, "ex" = 7, "ey" = -6, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -13, "sturn" = 110, "wturn" = -60, "eturn" = -30, "nflip" = 1, "sflip" = 1, "wflip" = 8, "eflip" = 1)
			if("wielded") return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback") return list("shrink" = 0.5, "sx" = -1, "sy" = 2, "nx" = 0, "ny" = 2, "wx" = 2, "wy" = 1, "ex" = 0, "ey" = 1, "nturn" = 0, "sturn" = 0, "wturn" = 70, "eturn" = 15, "nflip" = 1, "sflip" = 1, "wflip" = 1, "eflip" = 1, "northabove" = 1, "southabove" = 0, "eastabove" = 0, "westabove" = 0)
			if("onbelt") return list("shrink" = 0.3, "sx" = -4, "sy" = -6, "nx" = 5, "ny" = -6, "wx" = 0, "wy" = -6, "ex" = -1, "ey" = -6, "nturn" = 100, "sturn" = 156, "wturn" = 90, "eturn" = 180, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0)

/obj/item/rogueweapon/greatsword/bsword/psy/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/avantyne
	name = "阿凡泰因织纹巨剑"
	desc = "诅咒化作实形，异世勇士的巨兵，无惧最厚重的板甲与最坚韧的血肉。谁也休想阻挡 \
	祂的信徒向天幕上那道迸裂的伤口进军。夺回与生俱来的权利，登临天外，或为此战死。"
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/thrust/estoc, /datum/intent/sword/cut/zwei/cleave, /datum/intent/sword/cut/zwei/sweep)
	icon_state = "zizogsw"
	force = 20
	force_wielded = 40
	max_blade_int = 500
	max_integrity = 500

/obj/item/rogueweapon/greatsword/avantyne/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "巨剑")

/obj/item/rogueweapon/estoc
	name = "穿甲刺剑"
	desc = "剑刃修长而渐细，专为刺入敌人护甲的缝隙而打造。 \
	握柄紧裹黑色皮革，护手两端的弯角朝相反方向卷曲， \
	格外适合架开敌人蓄势待发的穿刺。"
	icon_state = "estoc"
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 20
	force_wielded = 28
	possible_item_intents = list(
		/datum/intent/sword/thrust,
		/datum/intent/sword/strike,
	)
	gripped_intents = list(
		/datum/intent/sword/thrust/estoc,
		/datum/intent/sword/thrust/estoc/lunge,
		/datum/intent/sword/strike,
	)
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/swords
	max_blade_int = 400
	max_integrity = 300
	wdefense = 3
	wdefense_wbonus = 6
	smelt_bar_num = 2

/obj/item/rogueweapon/estoc/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6, "sx" = -6, "sy" = 7, "nx" = 6, "ny" = 8, "wx" = 0, "wy" = 6, "ex" = -1, "ey" = 8, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -50, "sturn" = 40, "wturn" = 50, "eturn" = -50, "nflip" = 0, "sflip" = 8, "wflip" = 8, "eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/////////////////////
// Special Weapon! //
/////////////////////


/datum/intent/sword/thrust/estoc/dragonslayer
	name = "穿刺"
	icon_state = "inimpale"
	penfactor = PEN_HEAVY
	attack_verb = list("贯穿", "刺穿")
	reach = 2
	damfactor = 1.25
	clickcd = 55
	swingdelay = 15
	cleave = /datum/cleave_pattern/lance

/datum/intent/sword/chop/dragonslayer
	name = "开膛"
	icon_state = "inrend"
	blade_class = BCLASS_CHOP
	attack_verb = list("劈开", "剖开")
	animname = "chop"
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = PEN_HEAVY
	damfactor = 2
	swingdelay = 15
	reach = 2
	clickcd = 55
	item_d_type = "slash"

/datum/intent/sword/smash/dragonslayer
	name = "粉碎"
	blade_class = BCLASS_SMASH
	attack_verb = list("猛敲", "粉碎")
	hitsound = list('sound/combat/hits/blunt/frying_pan(1).ogg', 'sound/combat/hits/blunt/frying_pan(2).ogg', 'sound/combat/hits/blunt/frying_pan(3).ogg', 'sound/combat/hits/blunt/frying_pan(4).ogg')
	penfactor = PEN_NONE
	reach = 2
	damfactor = 2.5
	swingdelay = 25
	clickcd = 55
	icon_state = "insmash"
	item_d_type = "blunt"

/datum/intent/sword/sucker_punch/dragonslayer
	name = "避无可避的重拳"
	icon_state = "inpunch"
	attack_verb = list("拳击", "扼击", "重击")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/bluntsmall (1).ogg', 'sound/combat/hits/blunt/bluntsmall (2).ogg', 'sound/combat/hits/kick/kick.ogg')
	damfactor = 4
	penfactor = PEN_NONE
	clickcd = 55
	recovery = 15
	item_d_type = "blunt"
	parriable_intent = FALSE
	dodgeable_intent = FALSE

/datum/intent/sword/flay/dragonslayer
	name = "剥皮"
	icon_state = "inpeel"
	attack_verb = list("<font color ='#e7e7e7'>剥皮撕扯</font>")
	animname = "cut"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/frying_pan(1).ogg', 'sound/combat/hits/blunt/frying_pan(2).ogg', 'sound/combat/hits/blunt/frying_pan(3).ogg', 'sound/combat/hits/blunt/frying_pan(4).ogg')
	reach = 2
	penfactor = PEN_NONE
	swingdelay = 15
	clickcd = 50
	damfactor = 0.5
	item_d_type = "slash"

/datum/intent/sword/cut/exe/sweep/dragonslayer
	name = "斩首横扫"
	icon_state = "insweep"
	attack_verb = list("横扫", "横斩")
	clickcd = CLICK_CD_GLACIAL
	reach = 2
	damfactor = 2 // Hits harder but clunkier
	cleave = /datum/cleave_pattern/frontal_arc
	desc = "一记沉重的横扫，会斩开身前的所有目标。"

//

/obj/item/rogueweapon/sword/long/exe/berserk/dragonslayer
	name = "\"屠魔者\""
	desc = "“那东西已经大得不能称作剑了。太大、太厚、太重，也太粗糙。不，它更像是一大块银锭。”</br>它庞大得令人胆寒，强大得难以想象，而最重要的是，它本身就是勇气的证明。"
	icon_state = "machaslayer"
	icon = 'icons/roguetown/weapons/swords64.dmi'
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	possible_item_intents = list(/datum/intent/sword/thrust/estoc/dragonslayer, /datum/intent/sword/sucker_punch/dragonslayer, /datum/intent/sword/flay/dragonslayer)
	gripped_intents = list(/datum/intent/sword/chop/dragonslayer, /datum/intent/sword/thrust/estoc/dragonslayer, /datum/intent/sword/smash/dragonslayer, /datum/intent/sword/cut/exe/sweep/dragonslayer)
	force = 35
	force_wielded = 55
	minstr = 15
	minstr_req = TRUE//You MUST have the required strength. No exceptions.
	wdefense = 15
	var/coverage = 65//greatsword ds3 has 65 physical def. This is completely arbitrary but should be funny
	max_integrity = 555
	max_blade_int = 555
	alt_grips = null
	is_silver = TRUE
	smeltresult = /obj/item/rogueweapon/sword/long/exe/berserk//Too thick to completely melt.

/obj/item/rogueweapon/sword/long/exe/berserk/dragonslayer/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 0,\
		added_def = 0,\
	)

//snowflake coverage passive blocking for the funny super sword
/obj/item/rogueweapon/sword/long/exe/berserk/dragonslayer/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the projectile", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, args)
	var/mob/attacker
	var/obj/item/I
	if(attack_type == THROWN_PROJECTILE_ATTACK)
		if(istype(hitby, /obj/item))
			I = hitby
		if(I?.thrownby)
			attacker = I.thrownby
	if(attack_type == PROJECTILE_ATTACK)
		var/obj/projectile/P = hitby
		if(P?.firer)
			attacker = P.firer
	if(attacker && istype(attacker))
		if (!owner.can_see_cone(attacker))
			return FALSE
		if(obj_broken)
			return FALSE
		if(prob(coverage))
			owner.visible_message(span_danger("[owner]将[src]抡出一道弧线，把[hitby]打飞出去！"))
			playsound(src, BLADEWOOSH_LARGE, 100, TRUE, -1) //HOME RUN!!!
			return TRUE
	return FALSE

//Elven weapons originally sprited and added by Jamdrawers.
/obj/item/rogueweapon/greatsword/elvish
	possible_item_intents = list(/datum/intent/sword/chop,/datum/intent/sword/strike) //bash is for nonlethal takedowns, only targets limbs
	// Design Intent: It is pretty purely a two-handed weapon. In one hand it's a bit clumsy.
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/rend, /datum/intent/sword/thrust/zwei, /datum/intent/sword/strike/bad)
	alt_grips = null // can't be alt-gripped
	name = "精灵曲刃剑"
	desc = "精灵弯刃是一种传统兵器，运用它既像起舞，也像施以死亡。顺着流水般的轨迹，让它的锋路直抵敌人的喉咙。"
	icon_state = "elfcurveblade"
	wlength = WLENGTH_LONG// Less reach than greatsword!
	minstr = 7// Lighter
	wdefense = 8// Better defence than greatsword
	sellprice = 60
