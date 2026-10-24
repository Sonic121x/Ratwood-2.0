/datum/advclass/witch
	name = "女巫"
	tutorial = "你是一名女巫，有人把你当作贤者，也有更多人视你为妖魔。因异端思想乃至公然邪说而被排斥、被隔绝于众人之外，可当凡人再无别的法子时，他们最终还是会转而求助于你的药剂，也正因如此，他们才勉强容忍你的存在，当然，始终隔着一臂之遥。小心别落得被绑上火刑柱的下场，教会可从不会宽恕你这条左道。"
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/adventurer/witch
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	traits_applied = list(TRAIT_DEATHSIGHT, TRAIT_WITCH, TRAIT_ALCHEMY_EXPERT)
	townie_contract_gate_exempt = TRUE
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1
	)
	age_mod = /datum/class_age_mod/witch

	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)
	maximum_possible_slots = 20 // Should not fill, just a hack to make it shows what types of towners are in round

/datum/outfit/job/roguetown/adventurer/witch/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/witchhat
	mask = /obj/item/clothing/head/roguetown/roguehood/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/phys
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/magebag/witch
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/shortboots

	// RW does not have this ! Having it as null for now should work Fine.
	var/list/prefs
	var/list/witchprefs
	if(prefs)
		witchprefs = prefs["Towner"]
	var/classchoice
	var/shapeshiftchoice
	var/skillchoice
	if(witchprefs && witchprefs["witch_type"])
		classchoice = witchprefs["witch_type"]
	if(witchprefs && witchprefs["witch_form"])
		shapeshiftchoice = witchprefs["witch_form"]
	if(witchprefs && witchprefs["witch_skills"])
		skillchoice = witchprefs["witch_skills"]
	if(!classchoice)
		var/classes = list("古老魔法", "神血", "秘仪师")
		classchoice = input(H, "你的力量如何显现？", "古老之道") as anything in classes
	if(!shapeshiftchoice)
		var/shapeshifts = list("Zad", "Cat", "Cat (Black)", "Bat", "Lesser Volf", "Cabbit", "Small Rous", "Lesser Venard")
		shapeshiftchoice = input(H, "你的第二层皮会化作什么形态？", "古老之道") as anything in shapeshifts
	if(!skillchoice)
		var/skillsets = list("草药师", "采集者")
		skillchoice = input(H, "你学过哪些实用技能？", "古老之道") as anything in skillsets

	switch(skillchoice)
		if("草药师")
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/lumberjacking, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_NOVICE, TRUE)
		if("采集者")
			H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/tracking, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_NOVICE, TRUE)

	switch (classchoice)
		if("古老魔法")
			ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if(H.mind)
				H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 1, "minor" = 1, "utilities" = 5, "ward" = TRUE))
			backl = /obj/item/storage/backpack/rogue/satchel
			backr = choose_implement(H, "lesser")
			backpack_contents = list(
								/obj/item/rogueweapon/spellbook = 1,
								/obj/item/reagent_containers/glass/mortar = 1,
								/obj/item/pestle = 1,
								/obj/item/candle/yellow = 2,
								/obj/item/chalk = 1,
								)
			if (H.age == AGE_OLD)
				H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE)
		if("神血")
			//miracle witch: capped at t2 miracles. cannot pray to regain devo, but has high innate regen because of it (2 instead of 1 from major)
			var/datum/devotion/D = new /datum/devotion/(H, H.patron)
			H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_APPRENTICE, TRUE)
			D.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_2)
			D.max_devotion *= 0.5
			if (istype (H.patron, /datum/patron/inhumen/zizo))
				if(H.mind)
					H.mind.AddSpell(new /datum/action/cooldown/spell/minion_order)
			neck = /obj/item/clothing/neck/roguetown/psicross/wood
			backl = /obj/item/storage/backpack/rogue/satchel
			backpack_contents = list(
								/obj/item/reagent_containers/glass/mortar = 1,
								/obj/item/pestle = 1,
								/obj/item/candle/yellow = 2
								)
			if (H.age == AGE_OLD)
				H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
		if("秘仪师")
			// hybrid arcane/holy witch with t1 arcane and t1 miracles
			var/datum/devotion/D = new /datum/devotion/(H, H.patron)
			H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
			D.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
			D.max_devotion *= 0.5
			ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_NOVICE, TRUE)
			if(H.mind)
				H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 3))
			neck = /obj/item/clothing/neck/roguetown/psicross/wood
			backl = /obj/item/storage/backpack/rogue/satchel
			backpack_contents = list(
								/obj/item/rogueweapon/spellbook = 1,
								/obj/item/reagent_containers/glass/mortar = 1,
								/obj/item/pestle = 1,
								/obj/item/candle/yellow = 2,
								/obj/item/chalk = 1,
								)
			if (H.age == AGE_OLD)
				H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_NOVICE, TRUE)
				H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
	if(H.mind)
		switch (shapeshiftchoice)
			if("扎德")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/crow)
			if("猫")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat)
			if("猫（黑）")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat/black)
			if("蝙蝠")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/bat)
			if("小型沃尔夫")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_wolf)
			if("小型维纳德狐")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_vernard)
			if("小型老鼠")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/rous)
			if("卡比特")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cabbit)
		switch (classchoice)
			if("秘仪师")
				grant_poke_spell(H)
	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/armor/corset
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
		pants = /obj/item/clothing/under/roguetown/skirt/red

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cast(list/targets, mob/user = usr)
	user.visible_message(span_warning("[user]的身形开始扭曲变形！"), span_notice("我开始变形了……"))
	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/Shapeshift(mob/living/caster)
	// Do-after before transforming
	if(!do_after(caster, 3 SECONDS, target = caster))
		to_chat(caster, span_warning("变形被打断了！"))
		revert_cast(caster)  // Refund the cooldown
		return

	// Call parent to actually transform
	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/Restore(mob/living/shape)
	// Check if restrained before allowing revert
	if(shape.restrained(ignore_grab = FALSE))
		to_chat(shape, span_warn("我被束缚住了，没法变回去！"))
		revert_cast(shape)  // Refund the cooldown
		return

	// Add do-after for witches when reverting
	shape.visible_message(span_warning("[shape]开始变回原状！"), span_notice("我开始变形了……"))
	if(!do_after(shape, 3 SECONDS, target = shape))
		to_chat(shape, span_warning("恢复原形被打断了！"))
		revert_cast(shape)  // Refund the cooldown
		return

	return ..()

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat
	name = "猫形态"
	desc = ""
	overlay_state = "cat_transform"
	gesture_required = TRUE
	chargetime = 5 SECONDS
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/pet/cat/witch_shifted
	convert_damage = FALSE
	do_gib = FALSE
	shifted_speed_increase = 1.35
	show_true_name = FALSE

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat/black
	shapeshift_type = /mob/living/simple_animal/pet/cat/rogue/black/witch_shifted
	do_gib = FALSE

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_wolf
	name = "小型 沃尔夫 形态"
	desc = ""
	overlay_state = "volf_transform"
	gesture_required = TRUE
	chargetime = 5 SECONDS
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/wolf/witch_shifted
	convert_damage = FALSE
	do_gib = FALSE
	show_true_name = FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/witch_shifted
	name = "小型 沃尔夫"
	desc = "经典 沃尔夫 的一种更小、更瘦弱的变种，时常在附近林地间游荡。这里很少见到它们，而它看上去也远没有那些体型更大的同类危险。只是这只黄色眼睛里，透着股异样的灵性……"
	STASPD = 15
	STASTR = 3
	STACON = 5
	melee_damage_lower = 9
	melee_damage_upper = 14
	del_on_deaggro = null
	defprob = 70

/mob/living/simple_animal/pet/cat/witch_shifted
	name = "冷淡的猫"
	desc = "一只看起来百无聊赖的猫科动物。它那双绿色眼睛里，透着股异样的灵性……"
	defprob = 90
	STASPD = 18
	STASTR = 1
	STACON = 3
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 2
	melee_damage_upper = 5

/mob/living/simple_animal/pet/cat/rogue/black/witch_shifted
	name = "漆黑猫"
	desc = "据说是 内克拉 所钟爱的圣兽，对老鼠的兴趣也不比其他同类少。它那双漆黑而圆睁的眼睛后头，藏着种古怪的聪慧……"
	defprob = 90
	STASPD = 18
	STASTR = 1
	STACON = 3
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 2
	melee_damage_upper = 5

/datum/intent/simple/claw/witch_cat
	name = "抓挠"
	attack_verb = list("抓挠", "爪击")

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_vernard
	name = "小型维纳德狐形态"
	desc = ""
	overlay_state = "vernard_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/fox/witch_shifted

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/rous
	name = "小型老鼠形态"
	desc = ""
	overlay_state = "rous_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/smallrat/witch_shifted

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/cabbit
	name = "卡比特形态"
	desc = ""
	overlay_state = "cabbit_transform"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/witch_shifted


/mob/living/simple_animal/hostile/retaliate/rogue/fox/witch_shifted
	name = "小型维纳德狐"
	desc = "附近林地中潜行出没的狡黠维纳德狐也有这种更小、更瘦弱的变种。这里很少见到它们，而它看上去也远没有那些体型更大的同类危险。只是这只狐狸的黄色眼睛里，透着股异样的灵性……"
	defprob = 90
	STASPD = 18
	STASTR = 2
	STACON = 4
	melee_damage_lower = 8
	melee_damage_upper = 12
	del_on_deaggro = null
	defprob = 70

/mob/living/simple_animal/hostile/retaliate/smallrat/witch_shifted
	name = "小型老鼠"
	desc = "据说这些小小的、有时还会传播疫病的生灵是 佩斯特拉 的圣物，通常出没于食品储藏间和船只之中。可这一只看起来似乎比其他同类更聪明一些……"
	defprob = 90
	STASPD = 18
	STASTR = 1
	STACON = 1
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 1
	melee_damage_upper = 2

/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/witch_shifted
	name = "小型卡比特"
	desc = "据说只要见到这种迅捷的小兽，再加上它们的脚，就能招来 赛利克斯 的好运。它看上去弱小无辜，而且可爱得过分。"
	defprob = 90
	STASPD = 20
	STASTR = 1
	STACON = 2
	base_intents = list(/datum/intent/simple/claw/witch_cat)
	melee_damage_lower = 1
	melee_damage_upper = 2

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/bat
	name = "蝙蝠形态"
	desc = ""
	overlay_state = "bat_transform"
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form =  FALSE
	do_gib = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/bat
	knockout_on_death = 15 SECONDS
	shifted_speed_increase = 0.75 //25% slower than normal walking speed
	show_true_name = FALSE

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/crow
	name = "扎德形态"
	overlay_state = "zad"
	desc = ""
	gesture_required = TRUE
	chargetime = 5 SECONDS
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form =  FALSE
	do_gib = FALSE
	knockout_on_death = 15 SECONDS
	shifted_speed_increase = 0.75 //25% slower than normal walking speed
	show_true_name = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/bat/crow
	sound = 'sound/vo/mobs/bird/birdfly.ogg'

/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/frog
	name = "青蛙"
	desc = "沼地中的黏滑小生物。"
	icon_state = "frog"
	icon_living = "frog"
	icon_dead = "frog_dead"
	speak = list("呱", "呱呱")
	speak_emote = list("呱", "呱呱")
	emote_hear = list("呱。", "呱呱。")
	emote_see = list("蹦跳了一圈。", "抖了抖身子。")

/obj/effect/proc_holder/spell/targeted/shapeshift/witch/frog
	name = "青蛙形态"
	desc = ""
	overlay_state = "blindness"
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/frog
	do_gib = FALSE
