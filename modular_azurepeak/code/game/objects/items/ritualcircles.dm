/obj/structure/ritualcircle
	name = "仪式法阵"
	desc = ""
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "ritual_base"
	layer = BELOW_OBJ_LAYER
	density = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/allow_dreamwalkers = FALSE

/obj/structure/ritualcircle/attack_hand(mob/living/user)
	if(!allow_dreamwalkers && HAS_TRAIT(user, TRAIT_DREAMWALKER))
		to_chat(user, span_danger("如今唯有激荡符文仍在呼唤我......"))
		return FALSE
	return TRUE

/obj/structure/ritualcircle/attack_right(mob/living/carbon/human/user)
	user.visible_message(span_warning("[user]开始擦去这道符文。"))
	if(do_after(user, 15))
		playsound(loc, 'sound/foley/cloth_wipe (1).ogg', 100, TRUE)
		qdel(src)

// This'll be our tutorial ritual for those who want to make more later, let's go into details in comments, mm? - Onutsio
/obj/structure/ritualcircle/astrata
	name = "太阳符文" // defines name of the circle itself
	icon_state = "astrata_chalky" // the icon state, so, the sprite the runes use on the floor. As of making, we have 6, each needs an active/inactive state.
	desc = "阿斯特拉塔的神圣符文。温暖正从符文中散发出来。" // description on examine
	var/solarrites = list("指引之光") // This is important - This is the var which stores every ritual option available to a ritualist - Ideally, we'd have like, 3 for each God. Right now, just 1.

/obj/structure/ritualcircle/astrata/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/astrata)
		to_chat(user,span_smallred("我不懂施行此仪的正确礼法......"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("我不懂施行此仪的正确礼法......")) // You need ritualist to use them
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("我今天已经完成了足够多的仪式......若想再次沟通神意，我必须先休息。")) // If you have already done a ritual in the last 30 minutes, you cannot do another.
		return
	var/riteselection = input(user, "太阳仪礼", src) as null|anything in solarrites // When you use a open hand on a rune, It'll give you a selection of all the rites available from that rune
	switch(riteselection) // rite selection goes in this section, try to do something fluffy. Presentation is most important here, truthfully.
		if("指引之光") // User selects Guiding Light, begins the stuff for it
			if(do_after(user, 50)) // just flavor stuff before activation
				user.say("我向绝对秩序、向太阳与白昼恳求！！")
				if(do_after(user, 50))
					user.say("愿秩序降临这虚无之世！！")
					if(do_after(user, 50))
						user.say("请将目光投向我吧，光耀者！！")
						to_chat(user,span_danger("你感到阿斯特拉塔的目光落在自己身上。她的温暖轻抚过你的面颊，你觉得自己正在逐渐发热......")) // A bunch of flavor stuff, slow incanting.
						icon_state = "astrata_active"
						if(!HAS_TRAIT(user, TRAIT_CHOSEN)) //Priests don't burst into flames.
							loc.visible_message(span_warning("[user]猛然燃起烈焰！彻底被她的温暖所拥抱！"))
							playsound(loc, 'sound/combat/hits/burn (1).ogg', 100, FALSE, -1)
							user.adjust_fire_stacks(10)
							user.ignite_mob()
							user.fullscreen_redflash("redflash3")
							user.emote("firescream")
						guidinglight(src) // Actually starts the proc for applying the buff
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
						addtimer(VARSET_CALLBACK(src, icon_state, "astrata_chalky"), 120)

/obj/structure/ritualcircle/astrata/proc/guidinglight(src)
	var/ritualtargets = view(7, loc) // Range of 7 from the source, which is the rune
	for(var/mob/living/carbon/human/target in ritualtargets) // defines the target as every human in this range
		target.apply_status_effect(/datum/status_effect/buff/guidinglight) // applies the status effect
		to_chat(target,span_cultsmall("阿斯特拉塔的光辉指引我前行，被仪式师的圣焰牵引而来！"))
		playsound(target, 'sound/magic/holyshield.ogg', 80, FALSE, -1) // Cool sound!
// If you want to review a more complicated one, Undermaiden's Bargain is probs the most complicated of the starting set. - Have fun! - Onutsio 🏳️‍⚧️


/obj/structure/ritualcircle/noc
	name = "月亮符文"
	icon_state = "noc_chalky"
	desc = "诺克的神圣符文。月光正照耀着你。"
	var/lunarrites = list("月光之舞") // list for more to be added later

/obj/structure/ritualcircle/noc/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/noc)
		to_chat(user,span_smallred("我不懂施行此仪的正确礼法......"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("我不懂施行此仪的正确礼法......"))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("我今天已经完成了足够多的仪式......若想再次沟通神意，我必须先休息。"))
		return
	var/riteselection = input(user, "月之仪礼", src) as null|anything in lunarrites
	switch(riteselection) // put ur rite selection here
		if("月光之舞")
			if(do_after(user, 50))
				user.say("我向秘密之父、向明月与长夜祈求！！")
				if(do_after(user, 50))
					user.say("愿智慧降临这虚无之世！！")
					if(do_after(user, 50))
						user.say("请将目光投向我吧，睿智者！！")
						to_chat(user,span_cultsmall("月神的目光落在了你身上。只要稍加引导，便可将其赐予祈求者。"))
						playsound(loc, 'sound/magic/holyshield.ogg', 80, FALSE, -1)
						moonlightdance(src)
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)

/obj/structure/ritualcircle/noc/proc/moonlightdance(src)
	var/ritualtargets = view(7, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.apply_status_effect(/datum/status_effect/buff/moonlightdance)

/obj/structure/ritualcircle/xylix
	name = "诡计符文"
	desc = "赛利克斯的神圣符文。四周的空气都透着一股不可信赖。"
	icon_state = "xylix_chalky"
	var/trickeryrites = list("出丑之仪式", "舞台工之静默")

/obj/structure/ritualcircle/xylix/attack_hand(mob/living/user)
	if(!istype(user.patron, /datum/patron/divine/xylix))
		to_chat(user, span_smallred("我不懂施行此仪的正确礼法......"))
		return

	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user, span_smallred("我不懂施行此仪的正确礼法......"))
		return

	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user, span_smallred("我今天已经完成了足够多的仪式......"))
		return

	var/riteselection = input(user, "诡计仪礼", src) as null|anything in trickeryrites
	switch(riteselection)
		if("出丑之仪式")
			if(!do_after(user, 40))
				return
			user.say("嘿嘿！踮起脚尖，跌个底朝天……")
			playsound(loc, 'sound/misc/clownedhehe.ogg', 90, FALSE)

			if(!do_after(user, 40))
				return
			user.say("呼呼！走路要小心，不然就飞上天！")
			playsound(loc, 'sound/misc/clownedhohoho.ogg', 90, FALSE)

			if(!do_after(user, 30))
				return
			user.say("哈哈哈！每走一步，滑倒的命运都在等着你！一天摔一跤，尊严全跑掉！")
			playsound(loc, 'sound/magic/decoylaugh.ogg', 90, FALSE)

			icon_state = "xylix_active"
			loc.visible_message(span_warning("[user]在符文上描摹出一道带着嘲弄意味的印记。"))

			for(var/mob/living/M in range(1, src))
				M.apply_status_effect(/datum/status_effect/buff/xylix_pratfall)

			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			addtimer(CALLBACK(src, PROC_REF(reset_rune)), 120)

		if("舞台工之静默")
			if(!do_after(user, 50))
				return
			user.say("我呼唤千面悲剧演者！！")
			playsound(loc, 'sound/misc/clownedhehe.ogg', 90, FALSE)

			if(!do_after(user, 50))
				return
			user.say("拨动你的竖琴——让每根琴弦震聋我的敌人！！")
			playsound(loc, 'sound/misc/clownedhohoho.ogg', 90, FALSE)

			if(!do_after(user, 50))
				return
			user.say("--好戏开场！！")
			to_chat(user, span_cultsmall("每一场戏都需要幕后杂役。赛利克斯会让迟缓者变快，让你潜行更迅捷，也会让你的脚步暂时悄然无声。"))
			playsound(loc, 'sound/magic/mockery.ogg', 90, FALSE, -1)
			icon_state = "xylix_active"
			stagehands_silence()
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			addtimer(CALLBACK(src, PROC_REF(reset_rune)), 120)

/obj/structure/ritualcircle/xylix/proc/stagehands_silence()
	var/list/ritualtargets = view(1, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.apply_status_effect(/datum/status_effect/buff/stagehands_silence)

/obj/structure/ritualcircle/xylix/proc/reset_rune()
	icon_state = "xylix_chalky"

/obj/structure/ritualcircle/ravox
	name = "正义符文"
	icon_state = "ravox_chalky"
	desc = "拉沃克斯的神圣符文。象征着守护弱者之刃。"

/obj/structure/ritualcircle/pestra
	name = "疫病符文"
	desc = "佩斯特拉的神圣符文。一把清除杂草、带来新生的镰刀。"
	icon_state = "pestra_chalky"
	var/plaguerites = list("蝇王之分诊")


/obj/structure/ritualcircle/pestra/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/pestra)
		to_chat(user,span_smallred("我不懂施行此仪的正确礼法......"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("我不懂施行此仪的正确礼法......"))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("我今天已经完成了足够多的仪式......若想再次沟通神意，我必须先休息。"))
		return
	var/riteselection = input(user, "疫病仪礼", src) as null|anything in plaguerites
	switch(riteselection) // put ur rite selection here
		if("蝇王之分诊")
			if(do_after(user, 50))
				user.say("肿块、浓痰、鲜血与脏腑！！")
				if(do_after(user, 50))
					user.say("疖疮、鼻涕、腐肉与脓液！！")
					if(do_after(user, 50))
						user.say("水疱、高烧、流脓的疮口！！")
						to_chat(user,span_danger("你感到有什么东西正顺着喉咙往上爬，嗡鸣着、抓挠着......"))
						if(do_after(user, 30))
							icon_state = "pestra_active"
							user.say("让腐脓从你的伤口倾涌！！")
							to_chat(user,span_cultsmall("在我对疫病女王的虔诚许可下，她的侍从自我喉中爬出。来吧，苍蝇之父......"))
							loc.visible_message(span_warning("[user]张开嘴，猛地吐出一大群苍蝇！"))
							playsound(loc, 'sound/misc/fliesloop.ogg', 100, FALSE, -1)
							flylordstriage(src)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							addtimer(VARSET_CALLBACK(src, icon_state, "pestra_chalky"), 120)

/obj/structure/ritualcircle/pestra/proc/flylordstriage(src)
	var/ritualtargets = view(0, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		to_chat(target,span_userdanger("你感到它们正爬进你的伤口与毛孔。它们工作时那可怖的嗡鸣在你耳边回荡不休！"))
		target.flash_fullscreen("redflash3")
		target.emote("agony")
		target.Stun(200)
		target.Knockdown(200)
		to_chat(target, span_userdanger("难以想象的剧痛！"))
		target.apply_status_effect(/datum/status_effect/buff/flylordstriage)

/obj/structure/ritualcircle/dendor
	name = "野兽符文"
	desc = "登多尔的神圣符文。与自然合而为一，便是与你真正的本能相连。"
	icon_state = "dendor_chalky"
	var/bestialrites = list("下位狼之仪式", "借来之狂", "蜘蛛亲缘")

/obj/structure/ritualcircle/dendor/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/dendor)
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("今日我已行使了足够多的仪礼……必须先歇息，方可再度沟通神意。"))
		return
	var/riteselection = input(user, "野兽仪礼", src) as null|anything in bestialrites
	switch(riteselection) // put ur rite selection here
		if("下位狼之仪式")
			if(do_after(user, 50))
				user.say("RRRGH GRRRHHHG GRRRRRHH!!")
				playsound(loc, 'sound/vo/mobs/vw/idle (1).ogg', 100, FALSE, -1)
				if(do_after(user, 50))
					user.say("GRRRR GRRRRHHHH!!")
					playsound(loc, 'sound/vo/mobs/vw/idle (4).ogg', 100, FALSE, -1)
					if(do_after(user, 50))
						loc.visible_message(span_warning("[user]冲着符文龇牙低吼。涎水顺着唇边淌落......"))
						playsound(loc, 'sound/vo/mobs/vw/bark (1).ogg', 100, FALSE, -1)
						if(do_after(user, 30))
							icon_state = "dendor_active"
							loc.visible_message(span_warning("[user]猛地仰起头，发出一声长嚎！"))
							playsound(loc, 'sound/vo/mobs/wwolf/howl (2).ogg', 100, FALSE, -1)
							lesserwolf(src)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							addtimer(VARSET_CALLBACK(src, icon_state, "dendor_chalky"), 120)
		if("借来之狂")
			if(do_after(user, 50))
				user.say("我祈求力量……")
				playsound(loc, 'sound/vo/mobs/vw/idle (1).ogg', 100, FALSE, -1)
				if(do_after(user, 50))
					user.say("我祈求痛楚……")
					playsound(loc, 'sound/vo/mobs/vw/idle (4).ogg', 100, FALSE, -1)
					if(do_after(user, 50))
						loc.visible_message(span_warning("[user]发出诡异的声响，像是轻轻啜泣，又像低低窃笑。其身躯微微抽动着......"))
						playsound(loc, 'sound/vo/mobs/vw/bark (1).ogg', 100, FALSE, -1)
						if(do_after(user, 30))
							icon_state = "dendor_active"
							loc.visible_message(span_warning("[user]突然猛地抬头，发出一声扭曲的嚎叫！"))
							playsound(loc, 'sound/vo/mobs/wwolf/howl (2).ogg', 100, FALSE, -1)
							borrowedmadness(src)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							addtimer(VARSET_CALLBACK(src, icon_state, "dendor_chalky"), 120)
		if("蜘蛛亲缘")
			if(do_after(user, 50))
				user.say("我向无情荒野发出呼唤，")
				playsound(loc, 'sound/vo/mobs/spider/idle (1).ogg', 100, FALSE, -1)
				if(do_after(user, 50))
					user.say("……赐我你们支配之下那敏捷的形体……！")
					playsound(loc, 'sound/vo/mobs/spider/idle (3).ogg', 100, FALSE, -1)
					if(do_after(user, 30))
						icon_state = "dendor_active"
						loc.visible_message(span_warning("[user]浑身一僵，顷刻间被凌乱的丝网覆盖，随后那些蛛网又塌落成一滩黏糊糊的残堆！"))
						playsound(loc, 'sound/vo/mobs/spider/pain.ogg', 100, FALSE, -1)
						spiderkinship(src)
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
						addtimer(VARSET_CALLBACK(src, icon_state, "dendor_chalky"), 120)

/obj/structure/ritualcircle/dendor/proc/lesserwolf(src)
	var/ritualtargets = view(1, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.apply_status_effect(/datum/status_effect/buff/lesserwolf)

/obj/structure/ritualcircle/dendor/proc/borrowedmadness(src)
	var/ritualtargets = view(1, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		if(!istype(target.patron, /datum/patron/divine/dendor))
			to_chat(target, span_warning("仪式的力量并不认可我......"))
			continue
		to_chat(target, span_userdanger("你喜欢伤害别人吗？"))
		target.flash_fullscreen("redflash3")
		target.emote("agony")
		target.Unconscious(200)
		target.Knockdown(200)
		var/obj/effect/proc_holder/spell/self/wildshape/ws = target.mind?.get_spell(/obj/effect/proc_holder/spell/self/wildshape)
		if(ws)
			var/form_path = /mob/living/carbon/human/species/wildshape/dendormole
			if(!(form_path in ws.possible_shapes))
				ws.possible_shapes += form_path
				to_chat(target, span_notice("苔行者的形态正在我灵魂深处苏醒......"))
				addtimer(CALLBACK(src, PROC_REF(remove_ritual_form), target, form_path), 30 MINUTES)
		else
			to_chat(target, span_warning("我缺少驾驭这股力量所需的兽形能力......"))

/obj/structure/ritualcircle/dendor/proc/spiderkinship(src)
	var/ritualtargets = view(1, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		if(!istype(target.patron, /datum/patron/divine/dendor))
			to_chat(target, span_warning("仪式的力量并不认可我......"))
			continue
		to_chat(target, span_userdanger("疯狂与自然的蛛网正向我低语。蛛网不朽，巢群长存！"))
		target.flash_fullscreen("redflash3")
		target.emote("agony")
		target.Unconscious(100)
		target.Knockdown(200)
		var/obj/effect/proc_holder/spell/self/wildshape/ws = target.mind?.get_spell(/obj/effect/proc_holder/spell/self/wildshape)
		if(ws)
			var/form_path = /mob/living/carbon/human/species/wildshape/mirecrawler
			if(!(form_path in ws.possible_shapes))
				ws.possible_shapes += form_path
				to_chat(target, span_notice("泥沼爬蛛的形态正在我灵魂深处苏醒......"))
				addtimer(CALLBACK(src, PROC_REF(remove_ritual_form), target, form_path), 30 MINUTES)
		else
			to_chat(target, span_warning("我缺少驾驭这股力量所需的兽形能力......"))

/// Removes a temporary ritual form from the druid's Beast Form wheel when the duration expires.
/obj/structure/ritualcircle/dendor/proc/remove_ritual_form(mob/living/carbon/human/target, form_path)
	if(QDELETED(target) || !target.mind)
		return
	var/obj/effect/proc_holder/spell/self/wildshape/ws = target.mind.get_spell(/obj/effect/proc_holder/spell/self/wildshape)
	if(ws && (form_path in ws.possible_shapes))
		ws.possible_shapes -= form_path
		to_chat(target, span_warning("借来的形态正从我的灵魂中消散......"))



/obj/structure/ritualcircle/malum
	name = "锻炉符文"
	desc = "玛勒姆的神圣符文。凭借铁锤与炉火，足以修正一切瑕疵。"
	icon_state = "malum_chalky"
	var/forgerites = list("祝圣重铸之仪式")

/obj/structure/ritualcircle/malum/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/malum)
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("今日我已行使了足够多的仪礼……必须先歇息，方可再度沟通神意。"))
		return
	var/riteselection = input(user, "创造仪礼", src) as null|anything in forgerites
	switch(riteselection) // put ur rite selection here
		if("祝圣重铸之仪式")
			if(do_after(user, 50))
				user.say("匠作与炉火之神啊！！")
				if(do_after(user, 50))
					user.say("取走这些金属，使其在你的熔炉中重获新生！")
					if(do_after(user, 50))
						user.say("赐我可铸伟业之金属！")
						to_chat(user,span_danger("你感到一股热流骤然自体内升腾，在胸腔中灼烧翻涌......"))
						if(do_after(user, 30))
							icon_state = "malum_active"
							user.say("愿这些造物自你的炉中再获重铸！！")
							loc.visible_message(span_warning("一股热浪自[user]身前的法阵奔涌而出。金属在一闪而逝的光辉中重铸成形！"))
							playsound(loc, 'sound/magic/churn.ogg', 100, FALSE, -1)
							holyreforge(src)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							addtimer(VARSET_CALLBACK(src, icon_state, "malum_chalky"), 120)

/obj/structure/ritualcircle/malum/proc/holyreforge(src)
	var/ritualtargets = view(7, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.fullscreen_redflash("whiteflash") //Cool effect!
	for (var/obj/item/ingot/silver/I in loc)
		qdel(I)
		new /obj/item/ingot/silverblessed(loc)
	for (var/obj/item/ingot/steel/I in loc)
		qdel(I)
		new /obj/item/ingot/steelholy(loc)

/obj/structure/ritualcircle/abyssor
	name = "风暴符文"
	desc = "阿比索尔的神圣符文。你感觉自己的心神正被那道螺旋缓缓扯入其中。"
	icon_state = "abyssor_chalky"
	var/stormrites = list("潮汐之仪")

/obj/structure/ritualcircle/abyssor_alt
	name = "激荡符文"
	desc = "阿比索尔的神圣符文。这一道与其他的并不相同。有某种存在正在注视。"
	icon_state = "abyssoralt_active"

/obj/structure/ritualcircle/abyssor_alt_inactive
	name = "激荡符文"
	desc = "阿比索尔的神圣符文。这一道与其他的并不相同。有某种存在正在注视。"
	icon_state = "abyssoralt_chalky"
	allow_dreamwalkers = TRUE
	var/stirringrites = list("水晶尖塔之仪式")
	var/list/dreamwalker_rites = list("织梦之仪式")

// Ritual implementation
/obj/structure/ritualcircle/abyssor_alt_inactive/attack_hand(mob/living/user)
	if(!..())
		return
	// Allow both Abyssorites and Dreamwalkers to use the rune
	if((user.patron?.type) != /datum/patron/divine/abyssor && !HAS_TRAIT(user, TRAIT_DREAMWALKER))
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("今日我已行使了足够多的仪礼……必须先歇息，方可再度沟通神意。"))
		return

	// Build available rites based on user's status
	var/list/available_rites = list()

	// Abyssorites get access to stirring rites
	if(user.patron?.type == /datum/patron/divine/abyssor)
		available_rites += stirringrites

		// Time check for Rite of the Crystal Spire
		var/time_elapsed = STATION_TIME_PASSED() / (1 MINUTES)
		if(time_elapsed < 30 && ("水晶尖塔之仪式" in available_rites))
			var/time_left = 30 - time_elapsed
			to_chat(user, span_smallred("帷幕还太过稀薄，无法召来水晶尖塔。再等[round(time_left, 0.1)]分钟。"))
			available_rites -= "水晶尖塔之仪式"

	if(HAS_TRAIT(user, TRAIT_DREAMWALKER))
		available_rites += dreamwalker_rites

	if(!length(available_rites))
		to_chat(user,span_smallred("当前没有可用的仪礼。"))
		return

	var/riteselection = input(user, "祂之梦仪", src) as null|anything in available_rites
	switch(riteselection)
		if("水晶尖塔之仪式")
			if(do_after(user, 50))
				user.say("深海之父，聆听我的呼唤！")
				if(do_after(user, 50))
					user.say("自深渊而来，撕裂大地！")
					if(do_after(user, 50))
						icon_state = "abyssoralt_active"
						user.say("让你的风暴驱散那些懦夫！")
						to_chat(user, span_cultsmall("一块水晶碎片在符文中央凝结成形，嗡嗡震鸣着阿比索尔的力量。"))
						new /obj/item/abyssal_marker(loc)
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
						addtimer(VARSET_CALLBACK(src, icon_state, "abyssoralt_chalky"), 240)
		if("织梦之仪式")
			if(!HAS_TRAIT(user, TRAIT_DREAMWALKER))
				return

			var/list/weapon_options = list(
				"裂梦巨斧" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamaxe"),
				"和谐之矛" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamspear"),
				"渗流之剑" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamsword"),
				"雷霆三叉戟" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamtri")
			)

			var/choice = show_radial_menu(user, src, weapon_options, require_near = TRUE, tooltips = TRUE)
			if(!choice)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("梦啊！梦啊！显化我的愿景！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("梦啊！梦啊！屈从我的意志！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("梦啊！梦啊！铸就我的兵刃！！")
			if(!do_after(user, 5 SECONDS))
				return

			icon_state = "abyssoralt_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			dreamarmor(user)
			dreamcraft_weapon(user, choice)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(H.mind)
					H.mind.special_role = "dreamwalker"
			addtimer(VARSET_CALLBACK(src, icon_state, "abyssoralt_chalky"), 240)

/obj/structure/ritualcircle/abyssor_alt_inactive/proc/dreamcraft_weapon(mob/living/user, choice)
	var/obj/item/new_weapon
	var/datum/skill/skill_to_teach

	switch(choice)
		if("和谐之矛")
			new_weapon = new /obj/item/rogueweapon/halberd/glaive/dreamscape(user.loc)
			skill_to_teach = /datum/skill/combat/polearms
		if("渗流之剑")
			new_weapon = new /obj/item/rogueweapon/greatsword/bsword/dreamscape(user.loc)
			skill_to_teach = /datum/skill/combat/swords
		if("裂梦巨斧")
			new_weapon = new /obj/item/rogueweapon/greataxe/dreamscape(user.loc)
			skill_to_teach = /datum/skill/combat/axes
		if("雷霆三叉戟")
			new_weapon = new /obj/item/rogueweapon/spear/dreamscape_trident(user.loc)
			skill_to_teach = /datum/skill/combat/polearms

	if(new_weapon)
		user.put_in_hands(new_weapon)
		to_chat(user, span_warning("梦境凝实成了一把[choice]！"))

		var/current_skill = user.get_skill_level(skill_to_teach)
		var/current_athletics = user.get_skill_level(/datum/skill/misc/athletics)
		if(current_skill < 4)
			user.adjust_skillrank_up_to(skill_to_teach, 4)
			to_chat(user, span_notice("关于[skill_to_teach.name]的知识正涌入你的脑海！"))
		if(current_athletics < 6)
			user.adjust_skillrank_up_to(/datum/skill/misc/athletics, 6)
			to_chat(user, span_notice("你的耐力正在高涨！"))
	else
		to_chat(user, span_warning("梦境未能成形。"))

/obj/structure/ritualcircle/abyssor_alt_inactive/proc/dreamarmor(mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_DREAMWALKER))
		loc.visible_message(span_cult("此仪拒绝不以意志扭转梦境之人。"))
		return
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("难以想象的剧痛！"))
	target.emote("Agony")
	playsound(loc, 'sound/combat/newstuck.ogg', 50)
	loc.visible_message(span_cult("虚渺的触须自符文中涌出，缠上[target]的身躯。其形体扭曲变换，梦质凝结成甲。"))
	addtimer(CALLBACK(src, PROC_REF(dreamarmor_stage2), target), 20)
/obj/structure/ritualcircle/abyssor/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/abyssor)
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("今日我已行使了足够多的仪礼……必须先歇息，方可再度沟通神意。"))
		return
	var/riteselection = input(user, "潮汐仪礼", src) as null|anything in stormrites
	switch(riteselection)
		if("潮汐之仪")
			if(do_after(user, 50))
				user.say("深渊之父，聆听我的呼唤！")
				if(do_after(user, 50))
					user.say("我恳求你！让洪涛倾覆你的受膏者之敌！")
					if(do_after(user, 50))
						icon_state = "abyssor_active"
						user.say("让你的洪水吞没这片大地！")
						to_chat(user, span_cultsmall("一枚结晶碎片在符文中央成形，低鸣着阿比索尔的力量。"))
						new /obj/item/abyssal_marker/tidal(loc)
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
						addtimer(VARSET_CALLBACK(src, icon_state, "abyssor_chalky"), 240)

/obj/item/abyssal_marker
	name = "深渊标记"
	desc = "一块脉动着的水晶碎片，低鸣着异界能量。"
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "abyssal_marker"
	w_class = WEIGHT_CLASS_SMALL
	var/turf/marked_location
	var/effect_desc = " 在手中使用以标记位置，再次激活便会在标记处打破梦境与此界的屏障。你回想起大祭司的教诲……这些东西对所有人都很危险。"
	var/obj/rune_type = /obj/structure/active_abyssor_rune
	var/faith_locked = TRUE
	var/obj/upgraded_rune_type = /obj/structure/active_abyssor_rune/greater

/obj/item/abyssal_marker/volatile
	name = "不稳定深渊标记"
	effect_desc = " 低语充斥着你的脑海。水晶渴望被使用，它将带来一场美梦。首次使用会标记位置，第二次则会释放梦境。它看起来很脆弱，投掷时似乎可能因能量猛烈爆炸……"
	faith_locked = FALSE
	icon_state = "abyssal_marker_volatile"
	var/cooldown = 0
	var/creation_time

/obj/item/abyssal_marker/tidal
	name = "潮汐深渊标记"
	desc = "一块脉动着的水晶碎片，低鸣着深渊之力。摸上去湿漉漉的。"
	icon_state = "abyssal_marker_tidal"
	effect_desc = " 在手中使用以标记位置，再次激活便会在标记处打破梦境与此界的屏障。这一枚会召来深渊的潮水。"
	rune_type = /obj/structure/active_abyssor_rune/tidal
	upgraded_rune_type = null

/obj/item/abyssal_marker/volatile/Initialize(mapload)
	. = ..()
	creation_time = world.time
	var/area/A = get_area(src)
	if(istype(A, /area/rogue/underworld/dream))
		cooldown = 3 MINUTES

/obj/item/abyssal_marker/volatile/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(cooldown > 0 && world.time < creation_time + cooldown)
		visible_message(span_warning("[src]在地上弹了一下。它似乎还没准备好。"))
		return ..()

	var/turf/T = get_turf(hit_atom)
	if(T)
		marked_location = T
		visible_message(span_warning("[src]一撞即碎！"))
		playsound(src, 'sound/magic/lightning.ogg', 50, TRUE)
		var/mob/thrower = throwingdatum?.thrower
		if(thrower && HAS_TRAIT(thrower, TRAIT_HERESIARCH) && upgraded_rune_type)
			rune_type = upgraded_rune_type
		new rune_type(T)
		qdel(src)
	else
		return ..()

/obj/item/abyssal_marker/examine(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/c = user
		if(c.patron.type == /datum/patron/divine/abyssor || !faith_locked)
			. += span_info(effect_desc)

/obj/item/abyssal_marker/attack_self(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/c = user
		if(c.patron.type != /datum/patron/divine/abyssor && faith_locked)
			to_chat(user, span_warning("我与阿比索尔之梦的联系太过微弱，无法借这枚晶体唤起祂的力量。"))
			return ..()
		//Heretics get FAR stronger spires!
		if(HAS_TRAIT(user, TRAIT_HERESIARCH) && upgraded_rune_type)
			rune_type = upgraded_rune_type
	if(do_after(user, 2 SECONDS) && !marked_location)
		marked_location = get_turf(user)
		to_chat(user, span_notice("我以此地的本质为这枚晶体充能。"))
		playsound(src, 'sound/magic/vlightning.ogg', 50, TRUE)
	else if (marked_location)
		user.visible_message(span_warning("[user]在手中捏碎了[src]！"))
		playsound(src, 'sound/magic/lightning.ogg', 50, TRUE)
		new rune_type(marked_location)
		qdel(src)

/obj/item/abyssal_marker/volatile/attack_self(mob/user)
	if(cooldown > 0 && world.time < creation_time + cooldown)
		to_chat(user, span_warning("这枚晶体仍不稳定，还需要更多时间与此界调谐。稍后再试。"))
		return
	return ..()

/obj/structure/active_abyssor_rune
	name = "觉醒的深渊符文"
	desc = "一枚剧烈脉动、不断逸散风暴能量的符文。"
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "abyssoralt_active"
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	density = FALSE
	light_outer_range = 3
	light_color = LIGHT_COLOR_BLUE
	var/spawn_time = 10 SECONDS
	var/obj/spire_type = /obj/structure/crystal_spire

/obj/structure/active_abyssor_rune/tidal
	spire_type = /obj/structure/crystal_spire/tidal
	icon_state = "abyssor_active"

/obj/structure/active_abyssor_rune/greater
	spire_type = /obj/structure/crystal_spire/greater

/obj/structure/active_abyssor_rune/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(spawn_spire)), spawn_time)
	src.visible_message(span_userdanger("一道发光搏动的符文自行刻入地面。周遭现实清晰可见地裂开了缝隙！有什么东西要来了！"))

/obj/structure/active_abyssor_rune/proc/spawn_spire()
	new spire_type(get_turf(src))

#define ABYSSAL_GLOW_FILTER "abyssal_glow"

// Crystal Spire Structure
/obj/structure/crystal_spire
	name = "水晶尖塔"
	desc = "一座巨大的晶体结构，脉动着深渊能量。暗色寒冰自其底部蔓延开来。"
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "crystal_spire"
	anchored = TRUE
	density = TRUE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 500
	var/current_radius = 1
	var/max_radius = 4
	var/fiend_count = 0
	var/max_fiends = 3
	// Holds all the turf data so it can be unconverted.
	var/list/turf_data = list()
	var/expansion_timer = 3 MINUTES
	var/next_expansion_time = 0
	var/spawn_timer = 45 SECONDS
	var/next_fiend_time = 0
	var/awakened = FALSE
	var/converting = FALSE
	var/turf_to_use = /turf/open/floor/rogue/dark_ice
	var/mob/living/initial_fiend = /mob/living/simple_animal/hostile/rogue/dreamfiend/major/unbound
	pixel_y = 8

/obj/structure/crystal_spire/greater
	name = "巨型水晶尖塔"
	initial_fiend = /mob/living/simple_animal/hostile/rogue/dreamfiend/ancient/unbound
	max_integrity = 1000
	max_radius = 5
	max_fiends = 7

/obj/structure/crystal_spire/tidal
	name = "潮汐尖塔"
	desc = "一座巨大的晶体结构，脉动着深渊能量。咸涩海水自其底部漫开。"
	icon_state = "crystal_spire_tidal"
	max_integrity = 300
	max_fiends = 0
	turf_to_use = /turf/open/water/ocean/deep

/obj/structure/crystal_spire/Initialize(mapload)
	. = ..()
	spawn_fiends(1, initial_fiend)

	next_fiend_time = world.time + spawn_timer
	next_expansion_time = world.time + expansion_timer

	var/turf/T = loc
	turf_data[T] = T.type
	T.ChangeTurf(turf_to_use, flags = CHANGETURF_IGNORE_AIR)

	START_PROCESSING(SSobj, src)

/obj/structure/crystal_spire/tidal/spawn_fiends(amount, mob/living/fiend_type)
	return

/obj/structure/crystal_spire/process()
	if(world.time >= next_fiend_time)
		spawn_fiends(1)
		next_fiend_time = world.time + spawn_timer

	if(world.time >= next_expansion_time && current_radius < max_radius || !awakened)
		if(!awakened)
			awakened = TRUE
		expand_radius()
		next_expansion_time = world.time + expansion_timer

/obj/structure/crystal_spire/tidal/process()
	if(world.time >= next_expansion_time && current_radius < max_radius || !awakened)
		if(!awakened)
			awakened = TRUE
		expand_radius()
		next_expansion_time = world.time + expansion_timer

/obj/structure/crystal_spire/Destroy()
	for(var/turf/T in turf_data)
		T.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	turf_data.Cut()

	for(var/obj/structure/active_abyssor_rune/R in range(1, src))
		qdel(R)

	src.visible_message(span_danger("尖塔在刺耳的鸣响中破碎。转瞬间，梦境退回阿比索尔的领域，世界恢复了原貌。"))
	STOP_PROCESSING(SSobj, src)
	playsound(src, 'sound/foley/glassbreak.ogg', 50, TRUE)
	new /obj/effect/particle_effect/smoke(src.loc)

	var/list/witnesses = view(7, src)
	for(var/mob/living/carbon/human/H in witnesses)
		teleport_to_dream(H, 1000, 1)

	return ..()

/obj/structure/crystal_spire/proc/start_conversion()
	converting = TRUE
	resistance_flags |= INDESTRUCTIBLE

	add_filter(ABYSSAL_GLOW_FILTER, 2, list("type" = "outline", "color" = "#6A0DAD", "alpha" = 0, "size" = 2))
	update_icon()

/obj/structure/crystal_spire/proc/end_conversion()
	converting = FALSE
	resistance_flags &= ~INDESTRUCTIBLE

	remove_filter(ABYSSAL_GLOW_FILTER)
	update_icon()

/obj/structure/crystal_spire/proc/convert_surroundings()
	start_conversion()
	var/turf/center = get_turf(src)
	var/radius_sq = current_radius * current_radius

	for(var/turf/T in spiral_range_turfs(current_radius, center))
		// Skip if already converted
		if(istype(T, /turf/open/floor/rogue/dark_ice))
			continue

		// Calculate distance from center
		// P.S I hate math :)
		var/dx = abs(T.x - center.x)
		var/dy = abs(T.y - center.y)
		var/dist_sq = dx*dx + dy*dy

		// Skip corners with higher probability
		var/is_corner = (dx == dy) || (dx == current_radius && dy == current_radius)
		if(is_corner && prob(60))
			continue

		// Skip random tiles (10% chance)
		if(prob(10))
			continue

		// Only convert tiles within circular radius
		if(dist_sq <= radius_sq)
			turf_data[T] = T.type
			T.ChangeTurf(/turf/open/floor/rogue/dark_ice, flags = CHANGETURF_IGNORE_AIR)
			playsound(T, 'sound/magic/fleshtostone.ogg', 30, TRUE)
			sleep(10)

	end_conversion()

/obj/structure/crystal_spire/tidal/convert_surroundings()
	start_conversion()
	var/turf/center = get_turf(src)
	var/radius_sq = current_radius * current_radius

	for(var/turf/T in spiral_range_turfs(current_radius, center))
		// Skip if already converted
		// Additionally, we don't want this to be a reliable breaching tool, so ignore dense stuff and open spaces!
		if(istype(T, turf_to_use))
			continue
		if(T.density)
			continue
		if(istransparentturf(T))
			continue

		// Calculate distance from center
		var/dx = abs(T.x - center.x)
		var/dy = abs(T.y - center.y)
		var/dist_sq = dx*dx + dy*dy

		// Convert all tiles within circular radius. More circular than normal spires.
		if(dist_sq <= radius_sq)
			turf_data[T] = T.type
			T.ChangeTurf(turf_to_use, flags = CHANGETURF_IGNORE_AIR)
			playsound(T, 'sound/magic/fleshtostone.ogg', 30, TRUE)
			//Faster since it's less harmful.
			sleep(5)

	// Stop processing if fully expanded
	if(current_radius >= max_radius)
		STOP_PROCESSING(SSobj, src)
	end_conversion()

/obj/structure/crystal_spire/proc/expand_radius()
	if(current_radius >= max_radius)
		return

	current_radius++
	convert_surroundings()

/obj/structure/crystal_spire/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armour_penetration)
	if(converting)
		visible_message(span_warning("尖塔涌动着深渊能量，弹开了攻击！"))
		playsound(src, 'sound/magic/repulse.ogg', 50, TRUE)
		return FALSE
	return ..()

/obj/structure/crystal_spire/proc/spawn_spire_fiend(turf/spawn_turf, obj/structure/crystal_spire/spire, mob/living/fiend_type = /mob/living/simple_animal/hostile/rogue/dreamfiend/unbound)
	if(!spawn_turf || !spire || !ispath(fiend_type))
		return FALSE

	var/mob/living/F = new fiend_type(spawn_turf)
	F.visible_message(span_danger("[F]显现，龇出无数牙齿，敌视一切生命！"))

	var/datum/component/comp = F.AddComponent(/datum/component/spire_fiend, spire)
	return comp ? TRUE : FALSE

/obj/structure/crystal_spire/proc/spawn_fiends(amount, mob/living/fiend_type = /mob/living/simple_animal/hostile/rogue/dreamfiend/unbound)
	if(fiend_count >= max_fiends)
		return

	for(var/i in 1 to amount)
		if(fiend_count >= max_fiends)
			break

		var/turf/T = find_safe_spawn()
		if(T && spawn_spire_fiend(T, src, fiend_type))
			fiend_count++

/obj/structure/crystal_spire/proc/find_safe_spawn(outer_tele_radius = 3, inner_tele_radius = 2, include_dense = FALSE, include_teleport_restricted = FALSE)
	var/turf/target_turf = get_turf(src)
	var/list/turfs = list()

	for(var/turf/T in range(target_turf, outer_tele_radius))
		if(T in range(target_turf, inner_tele_radius))
			continue
		if(istransparentturf(T))
			continue
		if(T.density && !include_dense)
			continue
		if(T.teleport_restricted && !include_teleport_restricted)
			continue
		if(T.x>world.maxx-outer_tele_radius || T.x<outer_tele_radius)
			continue
		if(T.y>world.maxy-outer_tele_radius || T.y<outer_tele_radius)
			continue
		turfs += T

	if(!length(turfs))
		for(var/turf/T in orange(target_turf, outer_tele_radius))
			if(!(T in orange(target_turf, inner_tele_radius)))
				turfs += T

	if(!length(turfs))
		return null

	return pick(turfs)

/obj/structure/crystal_spire/proc/fiend_died()
	fiend_count = max(fiend_count - 1, 0)

/datum/component/spire_fiend
	var/obj/structure/crystal_spire/linked_spire

/datum/component/spire_fiend/Initialize(obj/structure/crystal_spire/spire)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	linked_spire = spire
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	RegisterSignal(linked_spire, COMSIG_QDELETING, PROC_REF(on_spire_deleted))

/datum/component/spire_fiend/proc/on_spire_deleted()
	linked_spire = null
	var/mob/living/living_parent = parent
	if(!istype(living_parent) || QDELETED(living_parent))
		return
	living_parent.dust()

/datum/component/spire_fiend/proc/on_death()
	SIGNAL_HANDLER
	if(linked_spire)
		linked_spire.fiend_died()
	qdel(src)

/obj/structure/ritualcircle/necra
	name = "死亡符文"
	desc = "内克拉的神圣符文。你心中泛起一阵宁静而顺从的接纳。"
	icon_state = "necra_chalky"
	var/deathrites = list("冥下侍女之约", "向冥下侍女之誓", "渡资")
	var/coinslot = 0


/obj/structure/ritualcircle/necra/examine(mob/user)
	. = ..()
	if(coinslot)
		. += "</br>法阵中已撒入[coinslot]枚渡资钱币……"

/obj/structure/ritualcircle/necra/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/thetoll))
		loc.visible_message(span_warning("[user]开始在仪式法阵上方掰碎[I]..."))
		if(do_after(user, 50))
			loc.visible_message(span_warning("[user]在仪式法阵上方砸碎了[I]……"))
			coinslot += 1
			qdel(I)

/obj/structure/ritualcircle/necra/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/necra)
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("今日我已行使了足够多的仪礼……必须先歇息，方可再度沟通神意。"))
		return
	var/riteselection = input(user, "死亡仪式", src) as null|anything in deathrites
	switch(riteselection) // put ur rite selection here
		if("冥下侍女之约")
			loc.visible_message(span_warning("[user]在符文前摇晃，张开嘴，却发不出任何话语……"))
			playsound(user, 'sound/vo/mobs/ghost/whisper (3).ogg', 100, FALSE, -1)
			if(do_after(user, 60))
				loc.visible_message(span_warning("[user]无声地哭泣，却没有泪水流下……"))
				playsound(user, 'sound/vo/mobs/ghost/whisper (1).ogg', 100, FALSE, -1)
				if(do_after(user, 60))
					loc.visible_message(span_warning("[user]突然僵住，仿佛被什么人抓住了……"))
					to_chat(user,span_danger("你感到一阵冰冷的吐息拂过后颈……"))
					playsound(user, 'sound/vo/mobs/ghost/death.ogg', 100, FALSE, -1)
					if(do_after(user, 20))
						icon_state = "necra_active"
						user.say("原谅我，契约已宣告！！")
						to_chat(user,span_cultsmall("我对冥下少女的虔敬，使我得以为这些灵魂谈成一笔交易……"))
						playsound(loc, 'sound/vo/mobs/ghost/moan (1).ogg', 100, FALSE, -1)
						undermaidenbargain(src)
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
						addtimer(VARSET_CALLBACK(src, icon_state, "necra_chalky"), 120)
		if("向冥下侍女之誓")
			loc.visible_message(span_warning("[user]在符文前摇晃，张开嘴，却发不出任何话语……"))
			playsound(user, 'sound/vo/mobs/ghost/whisper (3).ogg', 100, FALSE, -1)
			if(do_after(user, 60))
				loc.visible_message(span_warning("[user]无声地哭泣，却没有泪水流下……"))
				playsound(user, 'sound/vo/mobs/ghost/whisper (1).ogg', 100, FALSE, -1)
				if(do_after(user, 60))
					loc.visible_message(span_warning("[user]突然僵住，仿佛被什么人抓住了……"))
					to_chat(user,span_danger("你感到一阵冰冷的吐息拂过后颈……"))
					playsound(user, 'sound/vo/mobs/ghost/death.ogg', 100, FALSE, -1)
					if(do_after(user, 20))
						icon_state = "necra_active"
						user.say("此灵魂向你立誓效忠！！")
						to_chat(user,span_cultsmall("我对冥下少女的虔敬，使我得以为这道灵魂施加誓约……"))
						if(undermaidenvow(src))
							playsound(loc, 'sound/vo/mobs/ghost/moan (1).ogg', 100, FALSE, -1)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							addtimer(VARSET_CALLBACK(src, icon_state, "necra_chalky"), 120)
						else
							loc.visible_message(span_warning("随后……什么也没有。冥下少女并不在意受诅之人的誓言，也不在意其他信仰者的誓言。"))
		if("渡资")
			if(!coinslot)
				to_chat("此仪式需要先备好渡资……")
				return
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(persononrune.stat == DEAD)
					folksonrune += persononrune
			var/target = input(user, "选择祈求者") as null|anything in folksonrune
			if(target)
				loc.visible_message(span_warning("[user]将一缕缕灵辉般的幽光自空中扯起，撕开生与死之间的帷幕！"))
				playsound(user, 'sound/vo/mobs/ghost/whisper (3).ogg', 100, FALSE, -1)
				if(do_after(user, 60))
					playsound(user, 'sound/vo/mobs/ghost/whisper (1).ogg', 100, FALSE, -1)
					if(do_after(user, 60))
						loc.visible_message(span_warning("[user]嘴唇翕动，却听不到任何话语，正与另一侧的巨大幽魂交谈！"))
						playsound(user, 'sound/vo/mobs/ghost/death.ogg', 100, FALSE, -1)
						if(do_after(user, 20))
							icon_state = "necra_active"
							user.say("以这份渡资，换取一个灵魂！！")
							to_chat(user,span_cultsmall("[user]抓住灵辉丝线，试图将一个灵魂拉过裂隙！"))
							thetoll(target, user)
							addtimer(VARSET_CALLBACK(src, icon_state, "necra_chalky"), 120)



/obj/structure/ritualcircle/necra/proc/thetoll(mob/living/carbon/human/target, mob/living/user)
	var/revive_pq = PQ_GAIN_REVIVE
	if(!target.mind) // run the revive, but in ritual form!
		to_chat(user, "此人已无反应。")
		return
	if(!target.mind.active)
		to_chat(user, "内克拉还没有放过[target]。")
		return
	if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
		target.visible_message(span_danger("[target]被神术消解！渡资已被收下，[target]被拖入永恒的死亡！"), span_userdanger("我被神术消解了！"))
		target.gib()
		return
	target.adjustOxyLoss(-target.getOxyLoss()) //Ye Olde CPR
	if(!target.revive(full_heal = FALSE))
		to_chat(user, span_warning("什么也没有发生。"))
		return
	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
	if(underworld_spirit)
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		qdel(underworld_spirit)
		ghost.mind.transfer_to(target, TRUE)
	target.grab_ghost(force = TRUE)
	target.emote("breathgasp")
	target.Jitter(100)
	target.update_body()
	target.visible_message(span_notice("[target]猛然惊醒！幽魂们寻找着[target]身上的出口，几乎挣脱了束缚！"), span_green("我好不容易挤过其他绝望的幽魂，回到空荡的躯壳……好冷"))
	if(revive_pq && !HAS_TRAIT(target, TRAIT_IWASREVIVED) && user?.ckey)
		adjust_playerquality(revive_pq, user.ckey)
		ADD_TRAIT(target, TRAIT_IWASREVIVED, "[type]")
	target.mind.remove_antag_datum(/datum/antagonist/zombie)
	target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)
	target.apply_status_effect(/datum/status_effect/debuff/revived)
	target.apply_status_effect(/datum/status_effect/buff/healing, 14)
	target.add_stress(/datum/stressevent/necrarevive)
	src.coinslot -= 1 // -1 coin, please insert more coins.
	user.apply_status_effect(/datum/status_effect/debuff/ritesexpended) // only after a succesful revive

/obj/structure/ritualcircle/necra/proc/undermaidenbargain(src)
	var/ritualtargets = view(7, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.apply_status_effect(/datum/status_effect/buff/undermaidenbargain)

/obj/structure/ritualcircle/necra/proc/undermaidenvow(src)
	var/ritualtargets = view(1, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		if(HAS_TRAIT(target, TRAIT_ROTMAN) || HAS_TRAIT(target, TRAIT_NOBREATH) || target.mob_biotypes & MOB_UNDEAD)	//No Undead, no Rotcured, no Deathless
			return FALSE
		if(target.patron.type != /datum/patron/divine/necra)
			return FALSE
		target.apply_status_effect(/datum/status_effect/buff/necras_vow)
		target.apply_status_effect(/datum/status_effect/buff/healing/necras_vow)
		return TRUE
	return FALSE


/obj/item/soulthread
	name = "灵辉丝线"
	desc = "诡异发光的丝线，自坟冢而来。"
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "luxthread"
	var/strungtogether = 1
	sellprice = 3
	grid_width = 32
	grid_height = 32


/obj/item/soulthread/examine(mob/user)
	. = ..()
	. += "</br>所需的 10 根丝线已聚集了 [strungtogether] 根……"

/obj/item/soulthread/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/soulthread))
		var/obj/item/soulthread/thread2combine = attacking_item
		strungtogether += thread2combine.strungtogether
		sellprice += 3
		to_chat(user, "……渡资已凑齐[strungtogether]/10……")
		qdel(thread2combine)
	if(strungtogether >= 10)
		to_chat(user, "灵辉物质凝成了渡资！")
		new /obj/item/thetoll((get_turf(user)))
		qdel(src)

/obj/item/thetoll
	grid_width = 32
	grid_height = 32
	name = "代价"
	desc = "这是十道灵魂被送往内克拉的证明，由一种并非金属的材料构成，并不断渗出微量鲜血。十魂换一魂，在内克拉完全收走对方之前，摆渡人仍可送回一人。"
	icon = 'icons/roguetown/underworld/enigma_husks.dmi'
	icon_state = "soultoken"
	sellprice = 30


/obj/structure/ritualcircle/eora
	name = "爱之符文"
	desc = "伊欧拉的神圣符文。温柔的暖意与喜悦缓缓流过你的灵魂。"
	icon_state = "eora_chalky"

	var/peacerites = list("安抚之仪式", "敞炉之仪式")

/obj/structure/ritualcircle/eora/attack_hand(mob/living/user)
	if((user.patron?.type) != /datum/patron/divine/eora)
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("今日我已行使了足够多的仪礼……必须先歇息，方可再度沟通神意。"))
		return
	var/riteselection = input(user, "爱之仪礼", src) as null|anything in peacerites
	switch(riteselection) // put ur rite selection here
		if("安抚之仪式")
			if(do_after(user, 50))
				user.say("#愿你疲惫的心神蒙福……")
				if(do_after(user, 50))
					user.say("#纵然满是纷争与苦痛……")
					if(do_after(user, 50))
						user.say("#让祂抚平你的恐惧……")
						if(do_after(user, 50))
							icon_state = "eora_active"
							pacify(src)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							addtimer(VARSET_CALLBACK(src, icon_state, "eora_chalky"), 120)
		if("敞炉之仪式")
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(HAS_TRAIT(persononrune, TRAIT_EXTEROCEPTION))//Only works on Eorans
					folksonrune += persononrune
			if(!folksonrune.len)
				to_chat(user, span_warning("符文上没有可供施行此仪礼的伊欧拉信徒。"))
				return
			var/target = input(user, "选择宿主") as null|anything in folksonrune
			if(!target)
				return
			user.say("母亲，我立于你面前，祈求你倾听，并在此立誓！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("不助长苦难！不制造疼痛！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("修复破损之物，救赎迷途之人！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("庇护迷失者，温暖被遗忘者！！")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "eora_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			eoranaura(target)
			addtimer(VARSET_CALLBACK(src, icon_state, "eora_chalky"), 120)

/obj/structure/ritualcircle/eora/proc/pacify(src)
	var/ritualtargets = view(0, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		loc.visible_message(span_warning("[target]像风中的风铃般摇晃……"))
		target.visible_message(span_green("我感到心中的重负正在消散。可这感觉很不对劲……但我并不在意……"))
		target.apply_status_effect(/datum/status_effect/buff/pacify)

/obj/structure/ritualcircle/eora/proc/eoranaura(mob/living/carbon/human/target)
	loc.visible_message(span_good("[target]的身躯被安宁的气息笼罩。"))
	addtimer(CALLBACK(src, PROC_REF(eoranaura_stage2), target), 20)
// TIME FOR THE ASCENDANT. These can be stronger. As they are pretty much antag exclusive - Iconoclast for Matthios, Lich for ZIZO. ZIZO!


/obj/structure/ritualcircle/zizo
	name = "野心符文"
	desc = "齐佐的神圣符文。不惜一切代价的野心。"
	icon_state = "zizo_chalky"
	var/zizorites = list("武备之仪式", "暗水晶之仪式", "皈依")

/obj/structure/ritualcircle/zizo/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/inhumen/zizo)
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("今日我已行使了足够多的仪礼……必须先歇息，方可再度沟通神意。"))
		return
	var/riteselection = input(user, "野心仪式", src) as null|anything in zizorites
	switch(riteselection)
		if("武备之仪式")
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(HAS_TRAIT(persononrune, TRAIT_CABAL))
					folksonrune += persononrune
			var/target = input(user, "选择承受仪式者") as null|anything in folksonrune
			if(!target)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("齐佐！齐佐！野心女神！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("齐佐！齐佐！聆听我的呼唤！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("齐佐！齐佐！赐我兵刃，诛杀无知之人！！")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "zizo_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			zizoarmaments(target)
			addtimer(VARSET_CALLBACK(src, icon_state, "zizo_chalky"), 120)
		if("暗水晶之仪式")
			if(!user.mind)
				return
			if(user.mind.necro_crystal_count() >= user.mind.necro_crystal_cap())
				var/confirm = alert(user, "你与齐佐的契约规定，现有遗物仍受绑定时不能再造新的。是否断开最旧水晶及其所绑定亡者的联系，以铸造一枚新水晶？", "暗水晶之仪式", "断开并替换", "取消")
				if(confirm != "断开并替换")
					return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("齐佐！齐佐！野心女神！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("齐佐！齐佐！赐予秘会圣物！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("齐佐！齐佐！赐予号令亡者的暗水晶！！")
			if(!do_after(user, 5 SECONDS))
				return
			// re-check cap right before committing, in case circumstances changed during the chant
			if(user.mind.necro_crystal_count() >= user.mind.necro_crystal_cap())
				user.mind.necro_retire_oldest_crystal()
			icon_state = "zizo_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			var/obj/item/necro_relics/necro_crystal/new_crystal = new /obj/item/necro_relics/necro_crystal(loc)
			user.mind.necro_register_crystal(new_crystal)
			loc.visible_message(span_purple("一枚暗色水晶在仪式圆环中央显现，脉动着死灵能量！"))
			addtimer(VARSET_CALLBACK(src, icon_state, "zizo_chalky"), 120)
		if("皈依")
			if(!Adjacent(user))
				to_chat(user, "你必须站到符文近旁，才能接受齐佐的赐福。")
				return
			var/list/valids_on_rune = list()
			for(var/mob/living/carbon/human/peep in range(0, loc))
				if(HAS_TRAIT(peep, TRAIT_CABAL))
					continue
				valids_on_rune += peep
			if(!valids_on_rune.len)
				to_chat(user, "符文上没有可用目标！")
				return
			var/mob/living/carbon/human/target = input(user, "选择承受仪式者") as null|anything in valids_on_rune
			if(!target || QDELETED(target) || target.loc != loc)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("齐佐！齐佐！野心女神！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("齐佐！齐佐！聆听我的呼唤！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("齐佐！齐佐！让他们见证你的伟业！！")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "zizo_active"
			zizoconversion(target) // removed CD bc it's gonna be coal to sit there and wait for it to go off rite cooldown, this one is purely social in its nature
			addtimer(VARSET_CALLBACK(src, icon_state, "zizo_chalky"), 120)

/obj/structure/ritualcircle/zizo/proc/zizoarmaments(mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_CABAL))
		target.visible_message(span_cult("此仪拒绝并非秘社之人。"))
		return
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("难以想象的剧痛！"))
	target.emote("Agony")
	playsound(loc, 'sound/combat/newstuck.ogg', 50)
	if(HAS_TRAIT(target, TRAIT_INFINITE_STAMINA) || (target.mob_biotypes & MOB_UNDEAD))
		loc.visible_message(span_cult("巨钩从符文中伸出，刺入[target]的脚踝，将其拖到符文上，又刺入其手腕。漆黑腐败的灵辉从胸口被扯出，身体的精华随之涌动，将其塑成护甲。 "))
		target.Paralyze(120)
	else
		loc.visible_message(span_cult("巨钩从符文中伸出，刺入[target]的脚踝，将其拖到符文上，又刺入其手腕。灵辉从胸口被扯出，重新凝成护甲。 "))
	addtimer(CALLBACK(src, PROC_REF(zizoarmaments_stage2), target), 20)
/datum/outfit/job/roguetown/darksteelrite/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending/lesser)

	var/helmets = list("巴布塔盔 - 带面罩", "蛙嘴盔 - 强化护颈", "尖顶盔", "狼面盔 - 带面罩")
	var/helmet_choice = input(H, "选择你的头盔。", "来自那位女士的庇护") as anything in helmets
	switch(helmet_choice)
		if("巴布塔盔 - 带面罩")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/zizo
		if("蛙嘴盔 - 强化护颈")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth/zizo
		if("尖顶盔")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/zizo
		if("狼面盔 - 带面罩")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/zizo

	var/armors = list("重型护甲", "中型护甲")
	var/armors_choice = input(H, "选择你的护甲。", "来自那位女士的庇护") as anything in armors
	switch(armors_choice)
		if("重型护甲")
			armor = /obj/item/clothing/suit/roguetown/armor/plate/full/zizo
			pants = /obj/item/clothing/under/roguetown/platelegs/zizo
			gloves = /obj/item/clothing/gloves/roguetown/plate/zizo
			shoes = /obj/item/clothing/shoes/roguetown/boots/armor/zizo
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo
			wrists = /obj/item/clothing/wrists/roguetown/bracers/zizo
			neck = /obj/item/clothing/neck/roguetown/bevor/zizo
		if("中型护甲")
			armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/zizo
			pants = /obj/item/clothing/under/roguetown/platelegs/medium/zizo
			shoes = /obj/item/clothing/shoes/roguetown/boots/armor/avantyne/zizo
			gloves = /obj/item/clothing/gloves/roguetown/plate/medium/zizo
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo
			wrists = /obj/item/clothing/wrists/roguetown/bracers/zizo
			neck = /obj/item/clothing/neck/roguetown/bevor/zizo

	var/weapons = list("赦免 - (巨剑)", "复仇 - (长剑)", "定罪 - (刺剑)", "毁灭 - (战争大砍刀)", "收获 - (钩镰)", "虔诚 - (骑士剑)") // Funny evyl names
	var/weapons_choice = input(H, "选择你的武器。", "来自那位女士的兵刃") as anything in weapons
	switch(weapons_choice)
		if("赦免 - (巨剑)")
			r_hand = /obj/item/rogueweapon/greatsword/zizo
			l_hand = /obj/item/rogueweapon/scabbard/gwstrap
		if("复仇 - (长剑)")
			r_hand = /obj/item/rogueweapon/sword/long/zizo
			l_hand = /obj/item/rogueweapon/shield/tower/metal/zizo
		if("定罪 - (刺剑)")
			r_hand = /obj/item/rogueweapon/sword/rapier/zizo
			l_hand = /obj/item/rogueweapon/shield/tower/metal/zizo
		if("毁灭 - (战争大砍刀)")
			r_hand = /obj/item/rogueweapon/sword/long/kriegmesser/zizo
			l_hand = /obj/item/rogueweapon/shield/tower/metal/zizo
		if("收获 - (钩镰)")
			r_hand = /obj/item/rogueweapon/spear/billhook/zizo
			l_hand = /obj/item/rogueweapon/shield/tower/metal/zizo
			if(HAS_TRAIT(H, TRAIT_RITUALIST))
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("虔诚 - (骑士剑)")
			r_hand = /obj/item/rogueweapon/sword/arming/zizo
			l_hand = /obj/item/rogueweapon/shield/tower/metal/zizo
/obj/structure/ritualcircle/zizo/proc/zizoconversion(mob/living/carbon/human/target)
	if(!target || QDELETED(target) || target.loc != loc)
		to_chat(usr, "所选目标不在符文上！[target.p_they(TRUE)]必须正站在符文中心，才能接受齐佐的赐福。")
		return
	if(HAS_TRAIT(target, TRAIT_CABAL))
		loc.visible_message(span_cult("此仪拒绝已归于秘社之人。"))
		return
	if(target.already_converted_once)
		loc.visible_message(span_cult("该死的蠢货！！"))
		target.apply_damage(150, BRUTE, BODY_ZONE_HEAD)
		return
	var/prompt = alert(target, "臣服，还是死亡",, "臣服", "死亡")
	if(prompt == "臣服")
		to_chat(target, span_warning("她那最为宏伟的造业景象灌满了你的心智，异端知识被直接烙进你的血肉与灵魂。"))
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("难以想象的剧痛！"))
		target.emote("Agony")
		playsound(loc, 'sound/combat/newstuck.ogg', 50)
		loc.visible_message(span_cult("巨钩从符文中伸出，刺入[target]的脚踝，将其拖到符文上，又刺入其手腕。[target]在地上抽搐，终于接受了真相。 "))
		addtimer(CALLBACK(src, PROC_REF(zizoconversion_stage2), target), 20)
	if(prompt == "死亡")
		to_chat(target, span_warning("她那最为宏伟的造业景象灌满了你的心智……而你却选择拒绝。如今等待你的，便只有彻底的死亡了，愚物。"))
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("难以想象的剧痛！"))
		target.apply_damage(100, BURN, BODY_ZONE_HEAD)
		target.emote("Agony")
		loc.visible_message(span_cult("[target]胆敢违抗齐佐，在符文上剧烈挣扎、扭动。"))




/obj/structure/ritualcircle/matthios
	name = "交易符文"
	desc = "马西奥斯的神圣符文。万事皆有代价。"
	icon_state = "matthios_chalky"
	var/matthiosrites = list("武备之仪式", "掷出窗外", "皈依")


/obj/structure/ritualcircle/matthios/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/inhumen/matthios)
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("今日我已行使了足够多的仪礼……必须先歇息，方可再度沟通神意。"))
		return
	var/riteselection = input(user, "交易仪式", src) as null|anything in matthiosrites
	switch(riteselection) // put ur rite selection here
		if("武备之仪式")
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(HAS_TRAIT(persononrune, TRAIT_COMMIE))
					folksonrune += persononrune
			var/target = input(user, "选择一名承受者") as null|anything in folksonrune
			if(!target)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("黄金与白银，供祂享用！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("零钱也好，百枚也罢，成千上万之财，交易者皆来者不拒！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("以兵刃索取，以兵刃夺取！！")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "matthios_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			matthiosarmaments(target)
			addtimer(VARSET_CALLBACK(src, icon_state, "matthios_chalky"), 120)
		if("掷出窗外")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("窗扉已开，交易既成！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("十枚也好，百枚也罢，成千上万之财，交易者皆来者不拒！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("交易者啊，尽情吞吃这头贪婪的肥猪吧！！")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "matthios_active"
			if(defenestration())
				to_chat(user, span_cultsmall("仪式完成了，阿斯特拉塔那高贵的赠礼已被夺走！"))
				user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			else
				to_chat(user, span_cultsmall("仪式失败。圆环中央必须站着一位贵族！"))
			addtimer(VARSET_CALLBACK(src, icon_state, "matthios_chalky"), 120)
		if("皈依")
			if(!Adjacent(user))
				to_chat(user, "你必须站到符文近旁，才能接受马西奥斯的赐福。")
				return
			var/list/valids_on_rune = list()
			for(var/mob/living/carbon/human/peep in range(0, loc))
				if(HAS_TRAIT(peep, TRAIT_COMMIE))
					continue
				valids_on_rune += peep
			if(!valids_on_rune.len)
				to_chat(user, "符文上没有可用目标！")
				return
			var/mob/living/carbon/human/target = input(user, "选择一名承受者") as null|anything in valids_on_rune
			if(!target || QDELETED(target) || target.loc != loc)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("贪婪之喉，聆听我的呼唤！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("昔为奴隶，今为你的事业效力！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("打破这愚者的枷锁！")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "matthios_active"
			matthiosconversion(target)
			addtimer(VARSET_CALLBACK(src, icon_state, "matthios_chalky"), 120)

/obj/structure/ritualcircle/matthios/proc/matthiosarmaments(mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_COMMIE))
		loc.visible_message(span_cult("仪式拒绝了心中没有贪婪之人！！"))
		return
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("难以想象的剧痛！"))
	target.emote("Agony")
	playsound(loc, 'sound/misc/smelter_fin.ogg', 50)
	if(HAS_TRAIT(target, TRAIT_INFINITE_STAMINA) || (target.mob_biotypes & MOB_UNDEAD))
		loc.visible_message(span_cult("[target]腐败的灵辉如黏稠焦油般从鼻中涌出，在符文周围嘶响冒泡。这团液体猛然向上喷涌，灼烧着其皮肤！"))
		target.adjustFireLoss(200) //This gets spread across all limbs, 500+ is needed before it knocks someone out.
		playsound(src,'sound/misc/lava_death.ogg', rand(30,60), TRUE)
		return
	loc.visible_message(span_cult("[target]的灵辉从鼻中涌出，流入符文，闪耀的黄金嘶嘶作响。熔金与金属旋转着化为护甲，烙在其皮肤上。"))
	addtimer(CALLBACK(src, PROC_REF(matthiosarmaments_stage2), target), 20)
/// Performs the de-noblification ritual, which requires a noble character in the center of the circle. TRUE on success, FALSE on failure.
/obj/structure/ritualcircle/matthios/proc/defenestration()
	var/mob/living/carbon/human/victim = null
	for(var/mob/living/carbon/human/H in get_turf(src))
		if(HAS_TRAIT(H, TRAIT_OUTLAW))
			continue

		if(!H.is_noble() || H.has_status_effect(/datum/status_effect/debuff/ritualdefiled))
			continue

		victim = H
		break

	if(!victim)
		return FALSE

	playsound(loc, 'sound/combat/gib (1).ogg', 100, FALSE, -1)
	loc.visible_message(span_cult("[victim]的灵辉从鼻中涌出，流入符文……化为新铸的泽尼币！"))
	new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
	new /obj/item/roguecoin/silver/pile(get_turf(src))
	new /obj/item/roguecoin/silver/pile(get_turf(src))
	if(victim.mind?.assigned_role in GLOB.noble_positions) // Intentionally stacked with rulermob/regent/prince to get extra payout for royals
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
	// Draining nobility from the duke or the heirs increases payout and causes CHAOS. Astrata weeps!
	if((victim == SSticker.rulermob) || (victim == SSticker.regentmob) || (victim.mind?.assigned_role in list ("Prince", "Princess")))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		// Astrata loses her bearing due to this vile ritual
		priority_announce("阿斯特拉塔赐予的贵族之礼遭到玷污！太阳女神正在哭泣！", "凶兆", 'sound/misc/evilevent.ogg')
		var/datum/round_event_control/lightsout/E = new()
		E.req_omen = FALSE
		E.earliest_start = 0
		E.min_players = 0
		E.runEvent()

		var/datum/round_event_control/haunts/H = new()
		H.req_omen = FALSE
		H.earliest_start = 0
		H.min_players = 0
		if(LAZYLEN(GLOB.hauntstart))
			H.runEvent()

	victim.Stun(60)
	victim.Knockdown(60)
	to_chat(victim, span_userdanger("难以想象的剧痛！"))
	victim.apply_status_effect(/datum/status_effect/debuff/ritualdefiled)

	to_chat(victim, span_userdanger("阿斯特拉塔在哭泣！"))
	victim.emote("Agony")
	REMOVE_TRAIT(victim, TRAIT_NOBLE, TRAIT_GENERIC)
	REMOVE_TRAIT(victim, TRAIT_NOBLE, TRAIT_VIRTUE)
	ADD_TRAIT(victim, TRAIT_DEFILED_NOBLE, TRAIT_GENERIC)
	playsound(loc, 'sound/misc/evilevent.ogg', 100, FALSE, -1)
	to_chat(victim, span_cult("你感到阿斯特拉塔赐予的贵族之礼被剥夺，非人诸神正以它为食！"))
	return TRUE

/datum/outfit/job/roguetown/gildedrite/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/matthios
	pants = /obj/item/clothing/under/roguetown/platelegs/matthios
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/matthios
	gloves = /obj/item/clothing/gloves/roguetown/plate/matthios
	head = /obj/item/clothing/head/roguetown/helmet/heavy/matthios
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	backr = /obj/item/rogueweapon/flail/peasantwarflail/matthios
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending/lesser)

/obj/structure/ritualcircle/matthios/proc/matthiosconversion(mob/living/carbon/human/target)
	if(!target || QDELETED(target) || target.loc != loc)
		to_chat(usr, "所选目标不在符文上！[target.p_they(TRUE)]必须正站在符文中心，才能接受马西奥斯的赐福。")
		return
	if(HAS_TRAIT(target, TRAIT_COMMIE))
		loc.visible_message(span_cult("仪式拒绝了心中已有贪婪之人！！"))
		return
	if(target.already_converted_once)
		loc.visible_message(span_cult("该死的蠢货！！"))
		target.apply_damage(150, BRUTE, BODY_ZONE_HEAD)
		return
	var/prompt = alert(target, "好买卖？",, "好买卖！", "不成交！")
	if(prompt == "好买卖！")
		target.Stun(60)
		target.Knockdown(60)
		target.emote("Laugh")
		playsound(loc, 'sound/misc/smelter_fin.ogg', 50)
		loc.visible_message(span_cult("[target]屈从于对财富的渴望，双眼闪烁着万千珠宝的光辉。"))
		addtimer(CALLBACK(src, PROC_REF(matthiosconversion_stage2), target), 20)
	if(prompt == "不成交！")
		to_chat(target, span_warning("一切闪耀之物都可以属于你……只要你屈从于自己的贪婪本性。如今等待你的只有最终的死亡，清心寡欲之人。"))
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("难以想象的剧痛！"))
		target.emote("Agony")
		target.apply_damage(100, BURN, BODY_ZONE_HEAD)
		loc.visible_message(span_cult("[target]胆敢违抗马蒂奥斯，在符文上剧烈挣扎、扭动。"))



/obj/structure/ritualcircle/graggar
	name = "暴力符文"
	desc = "格拉加尔的神圣符文。命运既已破碎一次，祂的赐福便是真正属于所有人的自由。"
	icon_state = "graggar_chalky"
	var/graggarrites = list("武备之仪式", "战争仪式", "皈依")

/obj/structure/ritualcircle/graggar/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/inhumen/graggar)
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("今日我已行使了足够多的仪礼……必须先歇息，方可再度沟通神意。"))
		return
	var/riteselection = input(user, "暴力仪式", src) as null|anything in graggarrites
	switch(riteselection) // put ur rite selection here
		if("武备之仪式")
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(HAS_TRAIT(persononrune, TRAIT_HORDE))
					folksonrune += persononrune
			var/target = input(user, "选择一名承受者") as null|anything in folksonrune
			if(!target)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("原动力啊，暴力！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("一场华美的暴力盛宴，献给你，献给你！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("一场屠杀即将到来！！") // see the numbers taste the violence
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "graggar_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			graggararmor(target)
			addtimer(VARSET_CALLBACK(src, icon_state, "graggar_chalky"), 120)
		if("战争仪式")
			to_chat(user, span_userdanger("这场仪式会让我比平常更疲惫……我该继续吗？"))
			if(!do_after(user, 5 SECONDS))
				return
			user.say("鲜血献给战神，法阵已绘成！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("让贵族血肉成为召来部落的代价！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("让传送门开启，让哥布林蜂拥而来！")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "graggar_active"
			if(perform_warritual())
				user.apply_status_effect(/datum/status_effect/debuff/ritesexpended_heavy)
			else
				to_chat(user, span_smallred("仪式失败了。法阵中心必须有一具贵族、宗审庭成员或十神教会成员的躯体！"))
			addtimer(VARSET_CALLBACK(src, icon_state, "graggar_chalky"), 120)
		if("皈依")
			if(!Adjacent(user))
				to_chat(user, "你必须站到符文近旁，才能接受格拉加尔的赐福。")
				return
			var/list/valids_on_rune = list()
			for(var/mob/living/carbon/human/peep in range(0, loc))
				if(HAS_TRAIT(peep, TRAIT_HORDE))
					continue
				valids_on_rune += peep
			if(!valids_on_rune.len)
				to_chat(user, "符文上没有有效目标！")
				return
			var/mob/living/carbon/human/target = input(user, "选择一名承受者") as null|anything in valids_on_rune
			if(!target || QDELETED(target) || target.loc != loc)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("荣耀的屠杀！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("染红大地！！")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("遵循你的愿景，再一次征服！！")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "graggar_active"
			graggarconversion(target)
			addtimer(VARSET_CALLBACK(src, icon_state, "graggar_chalky"), 120)

/obj/structure/ritualcircle/graggar/proc/graggararmor(mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_HORDE))
		loc.visible_message(span_cult("仪式拒绝了心中没有杀戮之欲的人！！"))
		return
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("难以想象的剧痛！"))
	target.emote("Agony")
	playsound(loc, 'sound/misc/smelter_fin.ogg', 50)
	if(HAS_TRAIT(target, TRAIT_INFINITE_STAMINA) || (target.mob_biotypes & MOB_UNDEAD))
		loc.visible_message(span_cult("[target]腐败的灵辉如黏稠焦油般从鼻中涌出，在符文周围嘶响冒泡。这团液体猛然向上喷涌，灼烧着其皮肤！"))
		target.adjustFireLoss(200) //This gets spread across all limbs, 500+ is needed before it knocks someone out.
		playsound(src,'sound/misc/lava_death.ogg', rand(30,60), TRUE)
		return
	loc.visible_message(span_cult("[target]的灵辉从鼻中涌出，流入符文，原动力与金属旋转着凝成护甲，紧紧包覆其身躯！"))
	addtimer(CALLBACK(src, PROC_REF(graggararmor_stage2), target), 20)
/// Performs the war ritual, which requires a noble or inquisition member in the center of the circle. TRUE on success, FALSE on failure.
/obj/structure/ritualcircle/graggar/proc/perform_warritual()
	var/mob/living/carbon/human/victim = null
	for(var/mob/living/carbon/human/H in get_turf(src))
		if(H.has_status_effect(/datum/status_effect/debuff/ritualdefiled))
			continue

		if(H.is_noble() || HAS_TRAIT(H, TRAIT_INQUISITION) || (H.mind?.assigned_role in list("Priest", "Templar", "Martyr")))
			victim = H
			break

	if(!victim)
		return FALSE

	playsound(loc, 'sound/combat/gib (1).ogg', 100, FALSE, -1)
	loc.visible_message(span_cult("[victim]的灵辉从鼻中涌出，流入符文！"))
	victim.Stun(60)
	victim.Knockdown(60)
	to_chat(victim, span_userdanger("难以想象的剧痛！"))
	victim.apply_status_effect(/datum/status_effect/debuff/ritualdefiled)
	victim.emote("Agony")
	victim.visible_message(
		span_danger("[victim]在难以想象的剧痛中扭动！"),
		span_userdanger("好痛！烧起来了！")
	)

	to_chat(world, span_danger("战争仪式已完成！哥布林传送门开始在各地撕裂空间，接连开启！"))
	playsound(loc, 'sound/magic/bloodrage.ogg', 100, FALSE, -1)
	var/datum/round_event_control/gobinvade/E = new()
	E.req_omen = FALSE
	E.earliest_start = 0
	E.min_players = 0
	if(LAZYLEN(GLOB.hauntstart))
		E.runEvent()

	sleep(2 SECONDS)
	victim.emote("painscream", forced = TRUE)
	return TRUE

/datum/outfit/job/roguetown/viciousrite/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar
	pants = /obj/item/clothing/under/roguetown/platelegs/graggar
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/graggar
	gloves = /obj/item/clothing/gloves/roguetown/plate/graggar
	head = /obj/item/clothing/head/roguetown/helmet/heavy/graggar
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	cloak = /obj/item/clothing/cloak/graggar
	r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead/graggar

/obj/structure/ritualcircle/graggar/proc/graggarconversion(mob/living/carbon/human/target)
	if(!target || QDELETED(target) || target.loc != loc)
		to_chat(usr, "所选目标不在符文上！[target.p_they(TRUE)]必须正站在符文中心，才能接受格拉加尔的赐福。")
		return
	if(HAS_TRAIT(target, TRAIT_HORDE))
		loc.visible_message(span_cult("仪式拒绝了心中已有杀戮之欲的人！！"))
		return
	if(target.already_converted_once)
		loc.visible_message(span_cult("该死的蠢货！！"))
		target.apply_damage(150, BRUTE, BODY_ZONE_HEAD)
		return
	var/prompt = alert(target, "杀戮与狩猎！",, "杀！杀！杀！！", "我绝不屈服！！")
	if(prompt == "杀！杀！杀！！")
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("难以想象的剧痛！"))
		target.emote("Warcry")
		loc.visible_message(span_cult("[target]接受了自己的暴力本性，抛弃荣誉与同情的枷锁，脑海中充满了至美的屠杀景象。")) // i cant
		addtimer(CALLBACK(src, PROC_REF(graggarconversion_stage2), target), 20)
	if(prompt == "我绝不屈服！！")
		to_chat(target, span_warning("啊啊啊啊啊啊啊！！"))
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("难以想象的剧痛！"))
		target.emote("Agony")
		target.say("去死吧，恶徒！！") // many enemies bring much honour
		target.apply_damage(100, BURN, BODY_ZONE_HEAD)
		loc.visible_message(span_cult("[target]胆敢违抗格拉加尔，在符文上剧烈挣扎、扭动。"))




/obj/structure/ritualcircle/baotha
	name = "享乐符文"
	desc = "巴奥莎的神圣符文。献给心碎之人的抚慰。"
	icon_state = "baotha_chalky"
	var/baotharites = list("皈依", "不洁的丰饶恩赐", "武备之仪式")

/obj/structure/ritualcircle/baotha/attack_hand(mob/living/user)
	if((user.patron?.type) != /datum/patron/inhumen/baotha)
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("今日我已行使了足够多的仪礼……必须先歇息，方可再度沟通神意。"))
		return
	if(!Adjacent(user))
		to_chat(user, "你必须站到符文近旁，才能接受巴奥莎的赐福。")
		return
	var/riteselection = input(user, "欲望仪式", src) as null|anything in baotharites
	switch(riteselection) // put ur rite selection here
		if("皈依")
			var/list/valids_on_rune = list()
			for(var/mob/living/carbon/human/peep in range(0, loc))
				if(HAS_TRAIT(peep, TRAIT_DEPRAVED))
					continue
				valids_on_rune += peep
			if(!valids_on_rune.len)
				to_chat(user, "符文上没有有效目标！")
				return
			var/mob/living/carbon/human/target = input(user, "选择一名承受者") as null|anything in valids_on_rune
			if(!target || QDELETED(target) || target.loc != loc)
				return
			if(do_after(user, 50))
				user.say("#欢愉女神，抚慰我们，赐予我们欢愉……")
				if(do_after(user, 50))
					user.say("#我们孤独，被人遗弃。请拥抱我们二人……")
					if(do_after(user, 50))
						user.say("#世间短暂的欢愉，令我们仍感空虚……") // can someone else write this instead of me
						if(do_after(user, 50))
							icon_state = "baotha_active"
							baothaconversion(target) // removed CD bc it's gonna be coal to sit there and wait for it to go off rite cooldown, this one is purely social in its nature
							addtimer(VARSET_CALLBACK(src, icon_state, "baotha_chalky"), 120)
		if("不洁的丰饶恩赐")
			var/list/valids_on_rune = list()
			for(var/mob/living/carbon/human/peep in range(0, loc))
				valids_on_rune += peep
			if(!valids_on_rune.len)
				to_chat(user, "符文上没有有效目标！")
				return
			var/mob/living/carbon/human/target = input(user, "选择一名承受者") as null|anything in valids_on_rune
			if(!target || QDELETED(target) || target.loc != loc)
				return
			if(do_after(user, 50))
				user.say("紫色火焰，唤醒欲望！")
				if(do_after(user, 50))
					user.say("占据这具躯体，依你的意志塑造它！")
					if(do_after(user, 50))
						user.say("让他们只为你燃烧！")
						if(do_after(user, 50))
							icon_state = "baotha_active"
							baothablessing(target)
							addtimer(VARSET_CALLBACK(src, icon_state, "baotha_chalky"), 120)
		if("武备之仪式")
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(HAS_TRAIT(persononrune, TRAIT_DEPRAVED))
					folksonrune += persononrune
			var/target = input(user, "选择一名承受者") as null|anything in folksonrune
			if(!target)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("女神，我的女神……")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("以黑暗裹身，以冰冷极乐包覆，以欲望为甲……")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("让所有注视我的人见到你的美丽，并为之绝望！！")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "baotha_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			baothaarmor(target)
			addtimer(VARSET_CALLBACK(src, icon_state, "baotha_active"), 120)

/obj/structure/ritualcircle/baotha/proc/baothaconversion(mob/living/carbon/human/target)
	if(!target || QDELETED(target) || target.loc != loc)
		to_chat(usr, "所选目标不在符文上！[target.p_they(TRUE)]必须正站在符文中心，才能接受巴奥莎的赐福。")
		return
	if(HAS_TRAIT(target, TRAIT_DEPRAVED))
		loc.visible_message(span_cult("仪式拒绝了已足够堕落之人！！"))
		return
	if(target.already_converted_once)
		loc.visible_message(span_cult("该死的蠢货！！"))
		target.apply_damage(150, BRUTE, BODY_ZONE_HEAD)
		return
	var/prompt = alert(target, "臣服的缰绳，还是反抗的鞭笞？",, "缰绳", "鞭笞")
	if(prompt == "缰绳")
		to_chat(target, span_warning("奢靡放纵的享乐幻象在脑海中回荡，药物般的迷雾笼罩了你的心智。你的身体渴求更多。")) // helloooOOOOOOOO
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("为了欢愉而欢愉！"))
		target.sexcon.set_arousal(300)
		loc.visible_message(span_cult("快感与疼痛涌遍[target]全身，令其扭动呻吟……")) // warhammer 3 slaaneshi daemonette quotes
		addtimer(CALLBACK(src, PROC_REF(baothaconversion_stage2), target), 20)
	if(prompt == "鞭笞")
		to_chat(target, span_warning("你也太清心寡欲、冷漠古板了吧？呸，我不会再在你身上浪费时间。")) // gotta change it too
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("难以想象的剧痛！"))
		target.emote("Agony")
		target.apply_damage(100, BURN, BODY_ZONE_HEAD)
		loc.visible_message(span_cult("[target]胆敢违抗巴奥莎，在符文上剧烈挣扎、扭动。"))

/obj/structure/ritualcircle/baotha/proc/baothablessing(mob/living/carbon/human/target)
	if(!target || QDELETED(target) || target.loc != loc)
		to_chat(usr, "所选目标不在符文上！[target.p_they(TRUE)]必须正站在符文中心，才能接受巴奥莎的赐福。")
		return
	if(HAS_TRAIT(target, TRAIT_BAOTHA_FERTILITY_BOON))
		loc.visible_message(span_cult("他们已经受过祝福了！"))
		return
	var/prompt = alert(target, "那位腐化爱欲的女神即将赐你生育的恩泽，使你能够孕育子嗣！",, "接受……", "抗拒！")
	if(prompt == "接受……")
		to_chat(target, span_warning("一种奇异的暖意在你腹中蔓延开来，越来越热，几乎让你以为自己正被火焚烧，可真正的痛苦却始终没有降临……"))
		target.Stun(60)
		target.Knockdown(60)
		target.sexcon.set_arousal(100)
		loc.visible_message(span_cult("[target]在符文上呻吟、颤抖。紫色火焰如鞭梢般在其下腹舞动，一道新的印记浮现在身上。"))
		addtimer(CALLBACK(src, PROC_REF(baothablessing_stage2), target), 20)
	if(prompt == "抗拒！")
		to_chat(target, span_warning("我诚心赐予你最伟大的祝福，你却拒绝我？何等愚蠢！"))
		target.Stun(60)
		target.Knockdown(60)
		to_chat(target, span_userdanger("难以想象的剧痛！"))
		target.emote("Agony")
		target.apply_damage(100, BRUTE, BODY_ZONE_CHEST)
		loc.visible_message(span_cult("[target]胆敢违抗巴奥莎，在符文上剧烈挣扎、扭动。"))

/obj/structure/ritualcircle/baotha/proc/baothaarmor(mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_DEPRAVED))
		loc.visible_message(span_cult("仪式拒绝了未蒙祂宠爱之人"))
		return
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("美妙的痛苦！"))
	target.emote("Agony")
	playsound(loc, 'sound/combat/newstuck.ogg', 50)
	if(HAS_TRAIT(target, TRAIT_INFINITE_STAMINA) || (target.mob_biotypes & MOB_UNDEAD))
		loc.visible_message(span_cult("巨钩从符文中伸出，刺入[target]的脚踝，将其拖到符文上，又刺入其手腕。漆黑腐败的灵辉从胸口被扯出，身体的精华随之涌动，将其塑成护甲。 "))
		target.Paralyze(120)
	else
		loc.visible_message(span_cult("巨钩从符文中伸出，刺入[target]的脚踝，将其拖到符文上，又刺入其手腕。灵辉从胸口被扯出，重新凝成护甲。 "))
	addtimer(CALLBACK(src, PROC_REF(baothaarmor_stage2), target), 20)
//TIME FOR THE ONE. Exclusive to ABSOLVERS. Allowing conversion, deconversion and removal of rite armour.
//'Lesser' expenditure allows us to have a stopgap to this, while not entirely making poultice farming useless.


/obj/structure/ritualcircle/psydon//No longer just a decoration.
	name = "坚忍符文"
	desc = "普赛顿的神圣符文。其上刻有祂的圣徽，然而你心中毫无触动。"
	icon_state = "psydon_chalky"
	var/psydonrites = list("皈依", "训诫", "自由")

/obj/structure/ritualcircle/psydon/attack_hand(mob/living/user)
	if((user.patron?.type) != /datum/patron/old_god)
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("我不知该为此行使何种正确仪礼……"))
		return
	if(!HAS_TRAIT(user, TRAIT_INQUISITION))//Just in case someone OUTSIDE of the Inquisition has this combination. A converted ritualist, for example.
		to_chat(user,span_smallred("我无法做到这种事。我没有引导和操控灵辉的能力。"))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended_lesser))//We only use lesser cooldown for this, given it's just the Absolver.
		to_chat(user,span_smallred("我暂时已经做得够多了，应该稍事休息。"))
		return
	var/riteselection = input(user, "失落者仪式", src) as null|anything in psydonrites
	switch(riteselection)
		if("皈依")//Convert non-Psydonites to Psydon.
			if(!Adjacent(user))
				to_chat(user, "你必须站到符文近旁，才能理解那位唯一者的意志。")
				return
			var/list/valids_on_rune = list()
			for(var/mob/living/carbon/human/peep in range(0, loc))
				if(HAS_TRAIT(peep, TRAIT_PSYDONIAN_GRIT))
					continue
				valids_on_rune += peep
			if(!valids_on_rune.len)
				to_chat(user, "符文上没有有效目标！")
				return
			var/mob/living/carbon/human/target = input(user, "选择一名承受者") as null|anything in valids_on_rune
			if(!target || QDELETED(target) || target.loc != loc)
				return
			if(do_after(user, 5 SECONDS))
				user.say("你的沉默，是考验。")
				if(do_after(user, 5 SECONDS))
					user.say("你的意志，是恩赐。")
					if(do_after(user, 5 SECONDS))
						user.say("恳请你接纳这迷途的灵魂。")//WEEP FOR THEM, LASZLO.
						user.emote("cry")
						loc.visible_message(span_cult("[user]哭泣着。"))
						if(do_after(user, 5 SECONDS))
							psydonconversion(target)
		if("训诫")//Deconvert WWs/Vampires.
			if(!Adjacent(user))
				return
			var/list/valids_on_rune = list()
			for(var/mob/living/carbon/human/peep in range(0, loc))
				if(HAS_TRAIT(peep, TRAIT_SILVER_BLESSED))
					continue
				valids_on_rune += peep
			if(!valids_on_rune.len)
				to_chat(user, "符文上没有有效目标！")
				return
			var/mob/living/carbon/human/target = input(user, "选择一名承受者") as null|anything in valids_on_rune
			if(!target || QDELETED(target) || target.loc != loc)
				return
			if(do_after(user, 5 SECONDS))
				to_chat(user, span_warning("你伸出手，握住[user.p_their()]的灵辉……"))
				if(do_after(user, 5 SECONDS))
					to_chat(user, span_warning("我开始四处翻找，寻找污染的痕迹..."))
					if(do_after(user, 5 SECONDS))
						to_chat(user, span_warning("你孤注一掷，呼唤唯一者斥退非人诸神……"))
						user.emote("cry")
						loc.visible_message(span_cult("[user]哭泣着。"))
						if(do_after(user, 5 SECONDS))
							psydonadmonishment(target)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended_lesser)
		if("自由")//Strip folks in rite armour.
			if(!Adjacent(user))
				return
			var/list/valids_on_rune = list()
			for(var/mob/living/carbon/human/peep in range(0, loc))
				if(!HAS_TRAIT(peep, TRAIT_OVERTHERETIC))
					continue
				valids_on_rune += peep
			if(!valids_on_rune.len)
				to_chat(user, "符文上没有有效目标！")
				return
			var/mob/living/carbon/human/target = input(user, "选择一名承受者") as null|anything in valids_on_rune
			if(!target || QDELETED(target) || target.loc != loc)
				return
			if(do_after(user, 5 SECONDS))
				to_chat(user, span_warning("你伸出手，握住[user.p_their()]的灵辉……"))
				if(do_after(user, 5 SECONDS))
					to_chat(user, span_warning("你拉扯着那份恶念……"))
					if(do_after(user, 5 SECONDS))
						to_chat(user, span_warning("你审慎地挥击，试图斩断束缚……"))
						user.emote("cry")
						loc.visible_message(span_cult("[user]哭泣着。"))
						if(do_after(user, 5 SECONDS))
							psydonstrip(target)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended_lesser)

/obj/structure/ritualcircle/psydon/proc/psydonconversion(mob/living/carbon/human/target)
	if(!target || QDELETED(target) || target.loc != loc)
		to_chat(usr, "所选目标不在符文上！[target.p_they(TRUE)]必须正站在符文中心，才能承接那位唯一者的意志。")
		return
	if(HAS_TRAIT(target, TRAIT_PSYDONIAN_GRIT))
		loc.visible_message(span_cult("苦痛早已折磨着此人的心灵。"))
		return
	var/prompt = alert(target, "你接受唯一者的意志吗？",, "接受", "拒绝")
	if(prompt == "接受")
		to_chat(target, span_warning("一阵沉重的愧疚涌上心头。唯一者正注视着你。祂在哭泣。"))
		target.emote("cry")
		loc.visible_message(span_cult("[target]哭泣着。"))
		target.Stun(80)//Keep them in place, for a bit. Until we're done.
		addtimer(CALLBACK(src, PROC_REF(psydonconversion_stage2), target), 20)
	if(prompt == "拒绝")
		to_chat(target, span_warning("你绷紧身体。为什么要绷紧身体？什么都没有发生。"))
		loc.visible_message(span_cult("[target]毫发无损地站着，拒绝了祂的意志。"))

/obj/structure/ritualcircle/psydon/proc/psydonadmonishment(mob/living/carbon/human/target)
	if(!target || QDELETED(target) || target.loc != loc)
		to_chat(usr, "所选目标不在符文上！[target.p_they(TRUE)]必须正站在符文中心，才能承受那位唯一者的告诫。")
		return

	if(!target.mind) //Stopping null lookup runtimes
		loc.visible_message(span_warning("[target]没有能够接受唯一者指引的心智。"))
		return

	if(HAS_TRAIT(target, TRAIT_SILVER_BLESSED))
		loc.visible_message(span_warning("[target]已经受过那位唯一者的告诫而得救。"))
		return

	if(target.stat == DEAD)
		loc.visible_message(span_warning("[target]的心脏已停止跳动，仪式无法生效。这样做只会白费力气。"))
		return

	var/datum/antagonist/werewolf/Were = target.mind.has_antag_datum(/datum/antagonist/werewolf/)
	var/datum/antagonist/werewolf/lesser/Wereless = target.mind.has_antag_datum(/datum/antagonist/werewolf/lesser/)
	var/datum/antagonist/vampire/Vamp = target.mind.has_antag_datum(/datum/antagonist/vampire)

	//Werewolf deconversion
	if(Were && !Wereless) //The roundstart elder/alpha werewolf, it cannot be saved
		to_chat(target, span_userdanger("这可憎的仪式重压着我的灵魂。丹多的祝福不会如此轻易离我而去"))
		loc.visible_message(span_danger("[target]本能地排斥那位唯一者的告诫。[target.p_they(TRUE)]已无可救药。"))
		target.Stun(30)
		target.Knockdown(30)
		return

	else if(Wereless) //A lesser werewolf can be deconverted
		if(Wereless.transformed == TRUE)
			var/mob/living/carbon/human/I = target.stored_mob
			to_chat(target, span_userdanger("这邪恶的仪式！我的身体正自行撕裂！"))
			target.werewolf_untransform()
			Wereless.on_removal()
			ADD_TRAIT(I, TRAIT_SILVER_BLESSED, POULTICE_TRAIT)
			ADD_TRAIT(I, TRAIT_PACIFISM, POULTICE_TRAIT)
			I.emote("agony", forced = TRUE)
			I.Stun(30)
			I.Knockdown(30)
			I.Jitter(30)
			return
		else
			target.fullscreen_redflash("redflash3")
			target.emote("agony", forced = TRUE)
			to_chat(target, span_userdanger("这邪恶的仪式！它烧进了我的骨髓！"))
			Were.on_removal()
			ADD_TRAIT(target, TRAIT_SILVER_BLESSED, POULTICE_TRAIT)
			target.poultice_pacify()
			target.Stun(30)
			target.Knockdown(30)
			target.Jitter(30)
			return

	else if(Vamp)
		if(Vamp.generation >= GENERATION_METHUSELAH || HAS_TRAIT(target, TRAIT_BLOODPOOL_BORN)) //Vampire Lords + their bloodpool summons cannot be deconverted.
			to_chat(target, span_userdanger("这可憎的仪式重压着我的灵魂。只要我仍存于死世，便永不会忘记这份侮辱。"))
			loc.visible_message(span_danger("[target]本能地排斥那位唯一者的告诫。[target.p_they(TRUE)]已无可救药。"))
			target.Stun(30)
			target.Knockdown(30)
			return

		if(alert(target, "仪式正在从我的血脉中烧去本性！我要抗拒这份恩膏吗？", "训诫之仪式", "屈从", "抗拒") == "抗拒") //Opt in convert, opt in deconvert
			to_chat(target, span_userdanger("这可憎的仪式重压着我的灵魂。但我仍沉于幻梦，心脏依旧寂静。"))
			loc.visible_message(span_danger("[target]本能地排斥那位唯一者的告诫。[target.p_they(TRUE)]拒绝被拯救。"))
			target.Stun(30)
			target.Knockdown(30)
			return
		else
			target.fullscreen_redflash("redflash3")
			target.emote("agony", forced = TRUE)
			to_chat(target, span_userdanger("这邪恶的仪式！我沉寂的心脏再次跳动了！"))
			Vamp.on_removal()
			ADD_TRAIT(target, TRAIT_SILVER_BLESSED, POULTICE_TRAIT)
			target.poultice_pacify()
			target.Stun(30)
			target.Knockdown(30)
			target.Jitter(30)
			return


/obj/structure/ritualcircle/psydon/proc/psydonstrip(mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_OVERTHERETIC))//A fallback. You should never see this.
		loc.visible_message(span_cult("此人的灵辉未受锁链束缚。此仪式已无法再为其做些什么。"))
		return
	target.Stun(20)
	target.Knockdown(20)
	to_chat(target, span_userdanger("它在我的脑子里！"))
	target.emote("Agony")
	playsound(loc, 'sound/misc/pressurepad_up.ogg', 50)
	loc.visible_message(span_cult("一股无形力量将装备从[target]身上扯下，其血肉短暂地扭曲了！"))
	addtimer(CALLBACK(src, PROC_REF(psydonstrip_stage2), target), 20)
//Dropping rite armour. Or, well, basically everything.
/datum/outfit/job/roguetown/rite_strip/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()

/obj/structure/ritualcircle/abyssor_alt_inactive/proc/dreamarmor_stage2(mob/living/carbon/human/target)
	playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
	target.equipOutfit(/datum/outfit/job/roguetown/dreamwalker_armorrite)
	target.apply_status_effect(/datum/status_effect/debuff/devitalised)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), target, span_purple("现实不过是脆弱易碎的梦。你即梦者，而你的意志便是律法。")), 40)

/obj/structure/ritualcircle/eora/proc/eoranaura_stage2(mob/living/carbon/human/target)
	target.apply_status_effect(/datum/status_effect/eoranaura)
	playsound(target, 'sound/magic/eora_bless.ogg', 90, FALSE, -1)
	to_chat(target, span_boldred("我无法伤害他人。"))
	ADD_TRAIT(target, TRAIT_PACIFISM, TRAIT_MIRACLE)

/obj/structure/ritualcircle/zizo/proc/zizoarmaments_stage2(mob/living/carbon/human/target)
	playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
	target.equipOutfit(/datum/outfit/job/roguetown/darksteelrite)
	target.apply_status_effect(/datum/status_effect/debuff/devitalised)
	if(!HAS_TRAIT(target, TRAIT_OVERTHERETIC))
		ADD_TRAIT(target, TRAIT_OVERTHERETIC, TRAIT_MIRACLE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), target, span_purple("他们无知、落后、毫无希望。而你，你将拥有力量。")), 40)

/obj/structure/ritualcircle/zizo/proc/zizoconversion_stage2(mob/living/carbon/human/target)
	playsound(target, 'sound/health/slowbeat.ogg', 60)
	playsound(loc, 'sound/ambience/creepywind.ogg', 80)
	target.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	target.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
	target.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	addtimer(CALLBACK(src, PROC_REF(zizoconversion_stage3), target), 40)

/obj/structure/ritualcircle/zizo/proc/zizoconversion_stage3(mob/living/carbon/human/target)
	playsound(loc, 'sound/misc/boatleave.ogg', 100)
	to_chat(target, span_purple("他们愚昧、落后、毫无希望。而你，你将以野心之名而战。"))
	if(target.devotion == null) // why can't it just go 'huh null? yeah ok dont care let's continue' why do i have to write this
		target.set_patron(new /datum/patron/inhumen/zizo)
		target.already_converted_once = TRUE
		return
	else
		var/previous_level = target.devotion.level // IF NULL JUST MOVE ON WHAT'S YOUR PROBLEM HOLY FUCKING SHIT!!!
		target.set_patron(new /datum/patron/inhumen/zizo) //now you might ask why we get previous_level variable before switching le patron. reason is when swapping patrons it completely fucks up devotion data for people
		var/datum/devotion/C = new /datum/devotion(target, target.patron)
		if(previous_level == 4)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE) // gotta change?
		if(previous_level == 3)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3) // gotta change?
		if(previous_level == 2)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
		if(previous_level == 1)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)
		target.already_converted_once = TRUE

/obj/structure/ritualcircle/matthios/proc/matthiosarmaments_stage2(mob/living/carbon/human/target)
	playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
	target.equipOutfit(/datum/outfit/job/roguetown/gildedrite)
	target.apply_status_effect(/datum/status_effect/debuff/devitalised)
	if(!HAS_TRAIT(target, TRAIT_OVERTHERETIC))
		ADD_TRAIT(target, TRAIT_OVERTHERETIC, TRAIT_MIRACLE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), target, span_cult("让巨口吞下更多，喂饱我们的贪婪。")), 40)

/obj/structure/ritualcircle/matthios/proc/matthiosconversion_stage2(mob/living/carbon/human/target)
	playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
	target.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE) //fuck do they gotta get? a better grip
	target.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
	target.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
	addtimer(CALLBACK(src, PROC_REF(matthiosconversion_stage3), target), 40)

/obj/structure/ritualcircle/matthios/proc/matthiosconversion_stage3(mob/living/carbon/human/target)
	to_chat(target, span_cult("让巨口吞下更多，[target]将与我们一同满足自己的贪婪！"))
	playsound(loc, 'sound/items/matidol2.ogg', 50)
	if(target.devotion == null) // why can't it just go 'huh null? yeah ok dont care let's continue' why do i have to write this
		target.set_patron(new /datum/patron/inhumen/matthios)
		return
	else
		var/previous_level = target.devotion.level // IF NULL JUST MOVE ON WHAT'S YOUR PROBLEM HOLY FUCKING SHIT!!!
		target.set_patron(new /datum/patron/inhumen/matthios) //now you might ask why we get previous_level variable before switching le patron. reason is when swapping patrons it completely fucks up devotion data for people
		var/datum/devotion/C = new /datum/devotion(target, target.patron)
		if(previous_level == 4)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE) // gotta change?
		if(previous_level == 3)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3) // gotta change?
		if(previous_level == 2)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
		if(previous_level == 1)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)

/obj/structure/ritualcircle/graggar/proc/graggararmor_stage2(mob/living/carbon/human/target)
	playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
	target.equipOutfit(/datum/outfit/job/roguetown/viciousrite)
	target.apply_status_effect(/datum/status_effect/debuff/devitalised)
	if(!HAS_TRAIT(target, TRAIT_OVERTHERETIC))
		ADD_TRAIT(target, TRAIT_OVERTHERETIC, TRAIT_MIRACLE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), target, span_cult("摧毁他们。")), 40)

/obj/structure/ritualcircle/graggar/proc/graggarconversion_stage2(mob/living/carbon/human/target)
	playsound(target, 'sound/misc/heroin_rush.ogg', 100)
	playsound(target, 'sound/health/fastbeat.ogg', 100)
	target.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	target.adjust_skillrank(/datum/skill/labor/butchering, 1, TRUE)
	addtimer(CALLBACK(src, PROC_REF(graggarconversion_stage3), target), 40)

/obj/structure/ritualcircle/graggar/proc/graggarconversion_stage3(mob/living/carbon/human/target)
	to_chat(target, span_cult("摧毁他们。"))
	target.say("屠杀！！") // many enemies bring much honour
	if(target.devotion == null) // why can't it just go 'huh null? yeah ok dont care let's continue' why do i have to write this
		target.set_patron(new /datum/patron/inhumen/graggar)
		return
	else
		var/previous_level = target.devotion.level // IF NULL JUST MOVE ON WHAT'S YOUR PROBLEM HOLY FUCKING SHIT!!!
		target.set_patron(new /datum/patron/inhumen/graggar) //now you might ask why we get previous_level variable before switching le patron. reason is when swapping patrons it completely fucks up devotion data for people
		var/datum/devotion/C = new /datum/devotion(target, target.patron)
		if(previous_level == 4)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE) // gotta change?
		if(previous_level == 3)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3) // gotta change?
		if(previous_level == 2)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
		if(previous_level == 1)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)

/obj/structure/ritualcircle/baotha/proc/baothaconversion_stage2(mob/living/carbon/human/target)
	playsound(target, 'sound/health/fastbeat.ogg', 60)
	playsound(loc, 'sound/ambience/creepywind.ogg', 80)
	target.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	target.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
	target.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE) // haha get it?
	addtimer(CALLBACK(src, PROC_REF(baothaconversion_stage3), target), 40)

/obj/structure/ritualcircle/baotha/proc/baothaconversion_stage3(mob/living/carbon/human/target)
	to_chat(target, span_purple("尽情享受吧，若无欢愉，活着还有何意义，嗯？")) // help
	if(target.devotion == null)
		target.set_patron(new /datum/patron/inhumen/baotha)
		return
	else
		var/previous_level = target.devotion.level //now you might ask why we get previous_level variable before switching le patron. reason is when swapping patrons it completely fucks up devotion data for people
		target.set_patron(new /datum/patron/inhumen/baotha)
		var/datum/devotion/C = new /datum/devotion(target, target.patron)
		if(previous_level == 4)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE) // gotta change?
		if(previous_level == 3)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3) // gotta change?
		if(previous_level == 2)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
		if(previous_level == 1)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)

/obj/structure/ritualcircle/baotha/proc/baothablessing_stage2(mob/living/carbon/human/target)
	var/mutable_appearance/marking_overlay = mutable_appearance('icons/roguetown/misc/baotha_marking.dmi', "marking_[target.gender == "male" ? "m" : "f"]", -BODY_LAYER)
	if(isdwarf(target) || isgoblinp(target) || iskobold(target) || iscritter(target))
		if(target.gender == MALE)
			marking_overlay.pixel_y -= 6
		else
			marking_overlay.pixel_y -= 4
	target.add_overlay(marking_overlay)
	target.update_body_parts()
	playsound(target, 'sound/health/fastbeat.ogg', 60)
	addtimer(CALLBACK(src, PROC_REF(baothablessing_stage3), target), 40)

/obj/structure/ritualcircle/baotha/proc/baothablessing_stage3(mob/living/carbon/human/target)
	to_chat(target, span_purple("享受全新的自己吧！"))
	ADD_TRAIT(target, TRAIT_BAOTHA_FERTILITY_BOON, TRAIT_GENERIC)
	var/obj/item/organ/vagina/vagina = target.getorganslot(ORGAN_SLOT_VAGINA)
	if(vagina && !vagina.fertility)
		vagina.fertility = TRUE

/obj/structure/ritualcircle/baotha/proc/baothaarmor_stage2(mob/living/carbon/human/target)
	playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
	target.equipOutfit(/datum/outfit/job/roguetown/baothaarmor)
	target.apply_status_effect(/datum/status_effect/debuff/devitalised)
	if(!HAS_TRAIT(target, TRAIT_OVERTHERETIC))
		ADD_TRAIT(target, TRAIT_OVERTHERETIC, TRAIT_MIRACLE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), target, span_purple("所有人都会爱上你，并为之绝望。")), 40)

/obj/structure/ritualcircle/psydon/proc/psydonconversion_stage2(mob/living/carbon/human/target)
	playsound(target, 'sound/magic/PSYDONE.ogg', 60)
	to_chat(target, span_mind_control("..."))
	addtimer(CALLBACK(src, PROC_REF(psydonconversion_stage3), target), 20)

/obj/structure/ritualcircle/psydon/proc/psydonconversion_stage3(mob/living/carbon/human/target)
	to_chat(target, span_warning("一直都这么安静吗？一切都如此昏暗……"))
	to_chat(target, span_mind_control("..."))
	addtimer(CALLBACK(src, PROC_REF(psydonconversion_stage4), target), 40)

/obj/structure/ritualcircle/psydon/proc/psydonconversion_stage4(mob/living/carbon/human/target)
	to_chat(target, span_mind_control("..."))
	if(target.devotion == null)
		target.set_patron(new /datum/patron/old_god)
		return
	else
		var/previous_level = target.devotion.level //now you might ask why we get previous_level variable before switching le patron. reason is when swapping patrons it completely fucks up devotion data for people
		target.set_patron(new /datum/patron/old_god)
		var/datum/devotion/C = new /datum/devotion(target, target.patron)
		if(previous_level == 4)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE) // gotta change?
		if(previous_level == 3)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3) // gotta change?
		if(previous_level == 2)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
		if(previous_level == 1)
			target.mind?.RemoveAllMiracles()
			C.grant_miracles(target, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)

/obj/structure/ritualcircle/psydon/proc/psydonstrip_stage2(mob/living/carbon/human/target)
	playsound(loc, 'sound/misc/pressurepad_down.ogg', 50)
	target.equipOutfit(/datum/outfit/job/roguetown/rite_strip)
	if(HAS_TRAIT(target, TRAIT_OVERTHERETIC))
		REMOVE_TRAIT(target, TRAIT_OVERTHERETIC, TRAIT_MIRACLE)
