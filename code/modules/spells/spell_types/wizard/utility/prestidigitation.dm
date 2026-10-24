#define PRESTI_CLEAN "presti_clean"
#define PRESTI_SPARK "presti_spark"
#define PRESTI_MOTE "presti_mote"
#define PRESTI_SENSE "presti_sense"

/datum/action/cooldown/spell/touch/prestidigitation
	name = "戏法术"
	desc = "学徒练习奥术基础操控时常用的几种小戏法。除照明外，智力每超过 10 点一点，冷却缩短 10%，最多 50%。包含以下模式：\n \
	<b>清洁</b>：用奥术擦洗物体，如同使用肥皂。又称学徒之苦。\n \
	<b>点火</b>：在选定物品上引出火花，点燃火把、提灯、营火等易燃物；对地面使用时在面前点火。\n \
	<b>照明</b>：召出环绕自身的魔光，照亮道路。初始照明范围 5 格，智力每超过 10 点一点增加一格，最多 15 格。\n \
	<b>感知</b>：协调帷幕，感知附近地脉。 "
	button_icon_state = "prestidigitation"

	draw_message = span_notice("我准备施展一个小小的奥术咒法。")
	drop_message = span_notice("我散去微弱的奥术专注。")

	hand_path = /obj/item/melee/new_touch_attack/prestidigitation
	can_cast_on_self = TRUE
	infinite_use = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 0

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/touch/prestidigitation/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	var/obj/item/melee/new_touch_attack/prestidigitation/presti_hand = hand
	if(!istype(presti_hand))
		return FALSE

	switch(caster.used_intent.type)
		if(/datum/intent/hand/clean)
			if(istype(victim, /obj/structure/well/fountain/mana) || istype(victim, /turf/open/lava))
				presti_hand.gather_thing(victim, caster)
				handle_presti_cost(caster, PRESTI_CLEAN)
			else if(presti_hand.clean_thing(victim, caster))
				handle_presti_cost(caster, PRESTI_CLEAN)
		if(/datum/intent/hand/spark)
			if(presti_hand.create_spark(caster, victim))
				handle_presti_cost(caster, PRESTI_SPARK)
		if(/datum/intent/hand/light)
			if(presti_hand.handle_mote(caster))
				handle_presti_cost(caster, PRESTI_MOTE)
		if(/datum/intent/hand/sense)
			if(presti_hand.sense_leylines(caster))
				handle_presti_cost(caster, PRESTI_SENSE)

	return FALSE // don't consume the hand

/datum/action/cooldown/spell/touch/prestidigitation/proc/handle_presti_cost(mob/living/carbon/human/user, action)
	var/fatigue_used = get_adjusted_cost(primary_resource_cost)
	var/extra_fatigue = 0
	switch(action)
		if(PRESTI_CLEAN)
			fatigue_used *= 0.2
		if(PRESTI_SPARK)
			extra_fatigue = 5
		if(PRESTI_MOTE)
			extra_fatigue = 15
		if(PRESTI_SENSE)
			extra_fatigue = 10

	user.stamina_add(fatigue_used + extra_fatigue)

	var/skill_level = user.get_skill_level(associated_skill)
	if(skill_level >= SKILL_LEVEL_EXPERT)
		fatigue_used = 0

	return fatigue_used

/obj/item/melee/new_touch_attack/prestidigitation
	name = "\proper 戏法之触"
	possible_item_intents = list(/datum/intent/hand/clean, /datum/intent/hand/spark, /datum/intent/hand/light, /datum/intent/hand/sense)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#3FBAFD"
	var/obj/effect/wisp/prestidigitation/mote
	var/cleanspeed = 35
	var/motespeed = 20
	var/sparkspeed = 30
	var/gatherspeed = 35
	var/spark_cd = 0
	var/cast_range = 7
	experimental_inhand = FALSE

/obj/item/melee/new_touch_attack/prestidigitation/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity && get_dist(user, target) > cast_range)
		return
	var/datum/action/cooldown/spell/touch/prestidigitation/spell = spell_which_made_us?.resolve()
	if(spell)
		spell.cast_on_hand_hit(src, target, user)

/obj/item/melee/new_touch_attack/prestidigitation/proc/get_int_speed_mult(mob/living/user)
	var/int_above = max(user.STAINT - 10, 0)
	return clamp(1 - (int_above * 0.1), 0.5, 1)

/obj/item/melee/new_touch_attack/prestidigitation/Initialize(mapload, datum/action/cooldown/spell/spell)
	. = ..()
	mote = new(src)

/obj/item/melee/new_touch_attack/prestidigitation/Destroy()
	QDEL_NULL(mote)
	return ..()

/obj/item/melee/new_touch_attack/prestidigitation/proc/gather_thing(atom/target, mob/living/carbon/human/user)
	var/skill_level = user.get_skill_level(/datum/skill/magic/arcane)
	var/speed = initial(gatherspeed) - (skill_level * 3) // 3 speed per skill level, from 35 down to a maximum of 17 (pretty quick)
	var/turf/Turf = get_turf(target)
	if(istype(target, /obj/structure/well/fountain/mana))
		user.visible_message(span_notice("[user]开始将液态法力结晶化……"))
		while(do_after(user, speed, target = target))
			to_chat(user, span_notice("我用奥术之力塑形[target.name]中的液态法力，将其结晶化了！"))
			new /obj/item/magic/manacrystal(Turf)
		return TRUE
	if(istype(target, /turf/open/lava))
		user.visible_message(span_notice("[user]开始塑形那股流淌的熔岩……"))
		while(do_after(user, speed, target = target))
			to_chat(user, span_notice("我用奥术塑造一捧流淌的熔岩，使其迅速凝固！"))
			new /obj/item/magic/obsidian(user.loc)
		return TRUE

/obj/item/melee/new_touch_attack/prestidigitation/proc/sense_leylines(mob/living/carbon/human/user)
	if(!length(GLOB.leyline_sites))
		to_chat(user, span_warning("你探过帷幕，却一无所获。这个世界不存在地脉。"))
		return FALSE

	user.visible_message(span_notice("[user]闭上[user.p_their()]的双眼，向帷幕之外探寻……"), span_notice("我闭上双眼，协调帷幕的流动……"))
	if(!do_after(user, 2 SECONDS, target = user))
		to_chat(user, span_warning("你的专注被打断了。"))
		return FALSE

	var/list/sensed = list()
	var/user_z = user.z
	for(var/obj/structure/leyline/L in GLOB.leyline_sites)
		var/dist = get_dist(user, L)
		sensed += list(list("leyline" = L, "dist" = dist, "same_z" = (L.z == user_z)))

	for(var/i in 2 to length(sensed))
		var/j = i
		while(j > 1 && sensed[j]["dist"] < sensed[j - 1]["dist"])
			sensed.Swap(j, j - 1)
			j--

	to_chat(user, span_info("你协调帷幕，感知地脉能量的流动……"))
	var/count = 0
	for(var/entry in sensed)
		if(count >= 5)
			break
		var/obj/structure/leyline/L = entry["leyline"]
		var/dist = entry["dist"]
		var/same_z = entry["same_z"]
		var/direction = dir2text(get_dir(user, L))
		if(!direction)
			direction = "在你脚下"
		else
			direction = "在[direction]方"
		if(!same_z)
			if(L.z > user_z)
				direction += "，在你上方"
			else
				direction += "，在你下方"

		var/status = ""
		L.check_daily_reset()
		if(!L.has_uses_remaining())
			status = " <span style='color:#888'>（已枯竭）</span>"

		var/flavor = L.alignment
		var/flavor_color = "#FFFFFF"
		switch(L.alignment)
			if("infernal")
				flavor = "Scorched"
				flavor_color = "#EF5350"
			if("fae")
				flavor = "Sylvan"
				flavor_color = "#81C784"
			if("elemental")
				flavor = "Earthen"
				flavor_color = "#D4A04A"
			if("void")
				flavor = "Unstable"
				flavor_color = "#AB47BC"
			if("neutral")
				flavor = "Tamed"
				flavor_color = "#C0C0FF"

		var/colored_type = "<b><span style='color:[flavor_color]'>[flavor]</span></b>"
		if(dist <= 3)
			to_chat(user, span_info("[colored_type]地脉——就在你身旁[status]。"))
		else if(dist <= 30)
			to_chat(user, span_info("[colored_type]地脉——[direction]，距离不远[status]。"))
		else if(dist <= 100)
			to_chat(user, span_info("[colored_type]的气息——[direction]，尚有一段距离[status]。"))
		else
			to_chat(user, span_info("[colored_type]的低语——[direction]，十分遥远[status]。"))
		count++

	if(!count)
		to_chat(user, span_warning("你什么也没感知到。真奇怪。"))
	else
		var/charges = get_leyline_charges(user)
		to_chat(user, span_info("你的魔力还足以进行 <b>[charges]</b> 次仪式[charges != 1 ? "" : ""]。"))
	return TRUE

/obj/item/melee/new_touch_attack/prestidigitation/proc/handle_mote(mob/living/carbon/human/user)
	if(!mote)
		return

	var/int_bonus = max(user.STAINT - 10, 0)
	var/mote_power = 5 + FLOOR(int_bonus * 0.3, 1)
	mote.set_light_range(mote_power)
	if(mote.light_system == STATIC_LIGHT)
		mote.update_light()

	if(mote.loc == src)
		user.visible_message(span_notice("[user]摊开掌心，凝神专注......"), span_notice("我摊开掌心，将精神集中于自己的奥术之力......"))
		if(do_after(user, initial(motespeed) * get_int_speed_mult(user), target = user))
			mote.orbit(user, 1, TRUE, 0, 48, TRUE)
			return TRUE
		return FALSE
	else
		user.visible_message(span_notice("[user]将[mote.name]召回[user.p_their()]掌中，并合拢手掌熄灭其光辉。"), span_notice("我将[mote.name]召回掌心，再将手掌合拢。"))
		mote.forceMove(src)
		return TRUE

/obj/item/melee/new_touch_attack/prestidigitation/proc/create_spark(mob/living/carbon/human/user, atom/thing)
	var/actual_sparkspeed = initial(sparkspeed) * get_int_speed_mult(user)
	if(world.time < spark_cd + actual_sparkspeed)
		return FALSE
	spark_cd = world.time

	playsound(user, 'sound/foley/finger-snap.ogg', 100, FALSE)
	user.flash_fullscreen("whiteflash")
	flick("flintstrike", src)

	if(isturf(thing) || !user.Adjacent(thing))
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_step(user, user.dir)
		S.set_up(1, 1, front)
		S.start()
		user.visible_message(span_notice("[user]打了个响指，迸出一点火星！"), span_notice("我以一声响指唤出一点细小火星。"))
	else
		if(isliving(thing) && user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
			var/mob/living/carbon/M = thing
			var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M)

			if(cig)
				if(!cig.lit)
					M.spark_act()
					if(M == user)
						cig.light(span_notice("[user]打响[user.p_their()]的手指，唤出火花点燃[user.p_their()]的[cig.name]。"))
					else
						cig.light(span_notice("[user]打响[user.p_their()]的手指，唤出火花点燃[M]的[cig.name]。"))
				return TRUE
		thing.spark_act()
		user.visible_message(span_notice("[user]打了个响指，一点火星直跃向[thing]！"), span_notice("我唤出一点细小火星，并将它引向[thing]。"))

	return TRUE

/obj/item/melee/new_touch_attack/prestidigitation/proc/clean_thing(atom/target, mob/living/carbon/human/user)
	cleanspeed = initial(cleanspeed) * get_int_speed_mult(user)

	if(istype(target, /obj/effect/decal/cleanable))
		if(!should_clean_rune(target))
			user.visible_message(span_notice("[user]向\the [target.name]做出手势……活跃符文的奥术力量却斥退了[user.p_them()]！"), span_notice("我试图以奥术擦去\the [target.name]，但正在进行的仪式阻止了我！"))
			return FALSE
		user.visible_message(span_notice("[user]朝[target.name]施了个手势。奥术之力正缓缓将其抹去......"), span_notice("我开始用奥术之力将[target.name]一点点抹除......"))
		if(do_after(user, src.cleanspeed, target = target))
			var/turf/T = get_turf(target)
			new /obj/effect/temp_visual/cleaning_pulse(T)
			for(var/obj/effect/decal/cleanable/C in T)
				if(!should_clean_rune(target))
					return FALSE
			wash_atom(T, CLEAN_MEDIUM)
			to_chat(user, span_notice("我用法力将[target.name]清除了。"))
			return TRUE
		return FALSE
	else
		var/clean_name = isturf(target) ? "地面" : "\the [target.name]"
		user.visible_message(span_notice("[user]向[clean_name]做出手势，细小的奥术微粒涌过其表面……"), span_notice("我开始以奥术清洁[clean_name]……"))
		if(do_after(user, src.cleanspeed, target = target))
			var/turf/T = get_turf(target)
			new /obj/effect/temp_visual/cleaning_pulse(T)
			for(var/obj/effect/decal/cleanable/C in T)
				if(!should_clean_rune(C))
					return FALSE
			wash_atom(target, CLEAN_MEDIUM)
			to_chat(user, span_notice("我将[clean_name]清理干净。"))
			return TRUE
		return FALSE

// we have to do this here because wash_turf just qdels cleanable decals instead of checking their wash_act
/obj/item/melee/new_touch_attack/prestidigitation/proc/should_clean_rune(obj/effect/decal/cleanable/C)
	var/obj/effect/decal/cleanable/roguerune/rune = C
	if(istype(rune) && rune.active)
		return FALSE
	return TRUE

/obj/effect/wisp/prestidigitation
	name = "微型魔光微尘"
	desc = "一团用于照明的细小奥术显现。"
	pixel_x = 20
	light_outer_range =	5
	light_color = "#3FBAFD"
	light_system = MOVABLE_LIGHT

	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "wisp"

#undef PRESTI_CLEAN
#undef PRESTI_SPARK
#undef PRESTI_MOTE
#undef PRESTI_SENSE

/obj/effect/temp_visual/cleaning_pulse
	name = "清洁脉冲"
	icon = 'icons/effects/wizard_spell_effects.dmi'
	icon_state = "cleaning_pulse"
	duration = 8
	randomdir = 0
