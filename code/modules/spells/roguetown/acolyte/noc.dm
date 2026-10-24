// Noc Spells
// Blindness is a cancerous spells and should not be available to everyone.
// But I am not nuking it from Acolyte yet so it will be unavailable to mage.
// I repathed it to avoid it becoming available to mages again.
/obj/effect/proc_holder/spell/invoked/blindness
	name = "诺克之幕"
	desc = "驱使一缕活生生的黑暗，令他人暂时失明，并依你的信仰程度削弱其战斗技能。"
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "nocshroud"
	clothes_req = FALSE
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/churn.ogg'
	spell_tier = 2 // Combat spell
	invocations = list("诺克 以黑暗遮蔽你的罪目！")
	invocation_type = "shout" //can be none, whisper, emote and shout
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 15
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE
	cost = 3

/obj/effect/proc_holder/spell/invoked/blindness/warscholar // Be very careful who this is given out to, Blindness can be surprisingly strong.
	name = "奥术致盲"
	desc = "驱使一缕活生生的黑暗，令他人暂时失明。这是对神术的不完美模仿，需要纳莱迪圣十字架才能施展。"
	invocations = list("视野，消逝吧！")
	devotion_cost = 0
	recharge_time = 25 SECONDS // +10 because improper Naledi imitation
	miracle = FALSE
	req_items = list (/obj/item/clothing/neck/roguetown/psicross/naledi)
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/blindness/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.visible_message(span_warning("[user]指向了[target]的双眼！"),span_warning("黑暗遮住了我的双眼！"))
		target.apply_status_effect(/datum/status_effect/debuff/magical_blindness, user.get_skill_level(associated_skill))
		return TRUE
	revert_cast()
	return FALSE

/atom/movable/screen/fullscreen/magical_blindness
	icon_state = "oxydamageoverlay9"
	layer = BLIND_LAYER
	
/datum/status_effect/debuff/magical_blindness
	id = "magic_blind"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/magical_blindness
	duration = 100
	var/effect_strength = 0

/datum/status_effect/debuff/magical_blindness/on_creation(mob/living/new_owner, strength)
	if (isnum(strength))
		effect_strength = strength
		effectedstats = list(STATKEY_PER = -(round(strength / 2)))
		duration = (strength * 3) SECONDS
		new_owner.overlay_fullscreen("magical_blindness", /atom/movable/screen/fullscreen/magical_blindness)
	return ..()

/datum/status_effect/debuff/magical_blindness/on_remove()
	owner.clear_fullscreen("magical_blindness")
	. = ..()

/atom/movable/screen/alert/status_effect/debuff/magical_blindness
	name = "魔法致盲"
	desc = "一缕黑暗遮住了我的双眼！我的视野受阻，武器攻击也不再精准。"

/obj/effect/proc_holder/spell/invoked/invisibility
	name = "隐形术"
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "invisibility"
	desc = "令自己或他人暂时隐形。持续时间随 奥术 技艺提升而增加；施法、攻击或受击都会打断效果。"
	releasedrain = 30
	chargedrain = 5
	chargetime = 5
	clothes_req = FALSE
	recharge_time = 30 SECONDS
	range = 3
	warnie = "sydwarning"
	movement_interrupt = FALSE
	spell_tier = 1
	invocation_type = "none"
	sound = 'sound/misc/fade.ogg'
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = TRUE
	hide_charge_effect = FALSE
	cost = 3 // Very useful

/obj/effect/proc_holder/spell/invoked/invisibility/miracle
	miracle = TRUE
	desc = "令自己或他人暂时隐形。持续时间随神迹技能提升而增加；施法、攻击或受击都会打断效果。"
	devotion_cost = 25
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/invisibility/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.visible_message(span_warning("[target] 开始在空气中渐渐淡去！"), span_notice("你的身形开始隐没。"))
		var/dur = max((5 * (user.get_skill_level(associated_skill))), 5)
		if(dur >= recharge_time)
			recharge_time = dur + 5 SECONDS
		animate(target, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
		target.mob_timers[MT_INVISIBILITY] = world.time + dur SECONDS
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), dur SECONDS)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[target]重新显现在众人眼前。"), span_notice("你重新显露了身形。")), dur SECONDS)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/self/noc_spell_bundle
	name = "奥术亲和"
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "arcyne_affinity"
	desc = "允许你每个循环从特定类别中习得一两道法术。"
	miracle = TRUE
	devotion_cost = 250
	recharge_time = 40 MINUTES
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	var/list/chosen_bundles = list() // Tracks which categories have already been granted
	var/list/utility_bundle = list(	//Utility means exactly that. Nothing offensive and nothing that can affect another person negatively, 11 spellpoints total. (Barring Fetch, and technically Create Campfire)
	)
	var/list/offensive_bundle = list(	//This is not meant to make them combat-capable. A weak offensive, and mostly defensive option. 9 spellpoints total.
	)
	var/list/buff_bundle = list(	//Buffs! An Acolyte being a supportive caster is 100% what they already are, so this fits neatly. No debuffs -- every patron already has a plethora of those.
	)

/obj/effect/proc_holder/spell/self/noc_spell_bundle/cast(list/targets, mob/user)
	if(!..())
		return FALSE
	if(!user || !user.mind)
		revert_cast()
		return FALSE
	var/list/available_choices = list("功能", "进攻", "增益")
	for(var/already in chosen_bundles)
		available_choices.Remove(already)
	if(!available_choices.len)
		user.mind.RemoveSpell(src)
		to_chat(user, span_notice("诺克 所赐的 奥术 知识已经尽数降下。"))
		return TRUE
	var/choice = input(user, "诺克 赐予你的会是哪一类法术？", "选择道路") as null|anything in available_choices
	if(!choice)
		revert_cast()
		return FALSE
	chosen_bundles += choice
	switch(choice)
		if("功能")
			if(!user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular))
				var/secular_diagnose = new /obj/effect/proc_holder/spell/invoked/diagnose/secular
				user.mind?.AddSpell(secular_diagnose)
			add_spells(user, utility_bundle, grant_all = TRUE)
		if("进攻")
			add_spells(user, offensive_bundle, grant_all = TRUE)
			ADD_TRAIT(user, TRAIT_MAGEARMOR, TRAIT_MIRACLE)
		if("增益")
			add_spells(user, buff_bundle, choice_count = 4)
			ADD_TRAIT(user, TRAIT_MAGEARMOR, TRAIT_MIRACLE)
	if(chosen_bundles.len >= 3)
		user.mind.RemoveSpell(src)
		to_chat(user, span_notice("诺克 所赐的 奥术 知识已经尽数降下。"))
	return TRUE

/obj/effect/proc_holder/spell/self/noc_spell_bundle/proc/add_spells(mob/user, list/spells, choice_count = 1, grant_all = FALSE)
	if(!user || !user.mind || !islist(spells))
		return
	var/list/available = spells.Copy()
	for(var/spell_type in available)
		var/spell_path = available[spell_type]
		if(!spell_path)
			spell_path = spell_type
		if(!ispath(spell_path, /obj/effect/proc_holder/spell))
			available.Remove(spell_type)
			continue
		if(user.mind.has_spell(spell_path))
			available.Remove(spell_type)
	if(!available.len)
		return
	if(!grant_all)
		var/choice_count_visual = choice_count
		for(var/i in 1 to choice_count)
			if(!available.len)
				break
			var/choice = input(user, "选择一道法术！剩余可选次数：[choice_count_visual]") as null|anything in available
			if(isnull(choice))
				break
			var/picked_spell = available[choice]
			if(ispath(picked_spell, /obj/effect/proc_holder/spell) && !user.mind.has_spell(picked_spell))
				var/obj/effect/proc_holder/spell/new_spell = new picked_spell
				user.mind.AddSpell(new_spell)
			choice_count_visual--
			available.Remove(choice)
	else
		for(var/spell_type in available)
			var/spell_path = available[spell_type]
			if(!spell_path)
				spell_path = spell_type
			if(ispath(spell_path, /obj/effect/proc_holder/spell) && !user.mind.has_spell(spell_path))
				var/obj/effect/proc_holder/spell/new_spell = new spell_path
				user.mind.AddSpell(new_spell)

//15 PER peer-ahead.
/obj/effect/proc_holder/spell/invoked/noc_sight
	name = "诺克之视"
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "noc_sight"
	desc = "向前窥视。"
	chargetime = 0
	chargedrain = 0
	clothes_req = FALSE
	recharge_time = 5 SECONDS
	devotion_cost = 5
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocations = list("诺克，请引导我的目光。")
	invocation_type = "whisper"
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	hide_charge_effect = TRUE
	miracle = TRUE


//Identical to peering ahead as if you had 15 PER. (the max)
/obj/effect/proc_holder/spell/invoked/noc_sight/cast(list/targets, mob/user)
	if(isturf(targets[1]) && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/turf/T = targets[1]
		var/_x = T.x-H.loc.x
		var/_y = T.y-H.loc.y
		var/ttime = 6
		var/dist = get_dist(H, T)
		if(dist > 7 || dist  <= 2)
			return
		H.hide_cone()
		var/offset = 5
		if(_x > 0)
			_x += offset
		else if(_x != 0)
			_x -= offset
		if(_y > 0)
			_y += offset
		else if(_y != 0)
			_y -= offset
		animate(H.client, pixel_x = world.icon_size*_x, pixel_y = world.icon_size*_y, ttime)
		H.update_cone_show()
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/silence/miracle
	name = "沉默术"
	desc = "封锁嗓音，让空气归于寂静。无论法师还是凡人，都无法吐出半个字，不论咒语还是辱骂。"
	overlay_state = "silencenoc"
	clothes_req = FALSE
	releasedrain = 30
	chargedrain = 0
	chargetime = 5 SECONDS
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/zizo_snuff.ogg'
	spell_tier = 0
	invocations = list("月光之下，万籁俱寂！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 100 //Doubled devotion cost, because it's essentitally their Ultimate Move
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE

/obj/effect/proc_holder/spell/invoked/silence/miracle/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_COUNTERCOUNTERSPELL) || HAS_TRAIT(target, TRAIT_ANTIMAGIC) || HAS_TRAIT(target, TRAIT_MUTE))
			to_chat(user, "<span class='warning'>法术消散了，对其无效！</span>")
			revert_cast()
			return
		ADD_TRAIT(target, TRAIT_MUTE, MAGIC_TRAIT)
		playsound(get_turf(target), 'sound/magic/zizo_snuff.ogg', 80, TRUE, soundping = TRUE)
		to_chat(target, span_warning("我的声音归于寂静。我说不出话了！"))
		var/dur = max((5 * (user.get_skill_level(associated_skill, 5))))
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = dur SECONDS)
		return TRUE


/obj/effect/proc_holder/spell/invoked/magicshield
	name = "月光结界"
	desc = "以反魔法结界笼罩目标。"
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "antimagenoc"
	clothes_req = FALSE
	releasedrain = 30
	chargedrain = 0
	chargetime = 3 SECONDS
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/antimagic.ogg'
	spell_tier = 0
	invocations = list("诸般法术，皆不得近你之身！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 100
	recharge_time = 60 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE

/obj/effect/proc_holder/spell/invoked/magicshield/cast(list/targets, mob/user = usr)
	if(!targets || !length(targets) || !isliving(targets[1]))
		revert_cast()
		return FALSE
	var/mob/living/carbon/target = targets[1]
	if(HAS_TRAIT(target, TRAIT_ANTIMAGIC))
		to_chat(user, span_warning("对方已经受到反魔法保护！"))
		revert_cast()
		return FALSE
	ADD_TRAIT(target, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	target.visible_message(
		span_warning("[user]唤来结界，笼罩了[target]！"),
		span_warning("一股消解魔法的力量笼罩了我！")
	)
	var/dur = max((5 * (user.get_skill_level(associated_skill, 5))))
	addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = dur SECONDS)
	return TRUE
/obj/effect/proc_holder/spell/invoked/magicshield/proc/remove_buff(mob/living/carbon/target)
	if(!target)
		return
	REMOVE_TRAIT(target, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	to_chat(target, span_warning("反魔法结界消散了。"))

/datum/status_effect/debuff/blindness
	id = "blindness"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blindness
	duration = 15 SECONDS
	effectedstats = list(STATKEY_PER = -2)

/datum/status_effect/debuff/blindness/on_apply()
	. = ..()

/datum/status_effect/debuff/blindness/on_remove()
	. = ..()
	to_chat(owner, span_warning("我的视力恢复了……！"))

///////////////////////////
// T3 - Arcyne Affinity. //
///////////////////////////

/atom/movable/screen/alert/status_effect/debuff/blindness
	name = "失明"
	desc = "我眼中唯有黑暗！（感知 -2，视野锥缩小）"

/datum/action/cooldown/spell/noc
	background_icon = 'icons/mob/actions/nocmiracles.dmi'
	button_icon = 'icons/mob/actions/nocmiracles.dmi'
	spell_color = GLOW_COLOR_NOC

	ignore_armor_penalty = TRUE

	attunement_school = null

	primary_resource_type = SPELL_COST_DEVOTION

	secondary_resource_type = SPELL_COST_STAMINA

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0

	point_cost = 0

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/noc, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

///////////////////////////
// T3 - Arcyne Affinity. //
///////////////////////////

/datum/action/cooldown/spell/noc/spellpack
	name = "奥术亲和"
	desc = "允许你学习一组法术。\n \
	<b>魔导师</b>：高等奥术箭、电弧箭、相位穿梭、传讯术、营火术 \n \
	<b>附魔师</b>：冥河绽放、誓缚、符文结界、力墙术、热血奔涌 \n \
	<b>先知</b>：巨人协调、指引术、迅捷协调、坚韧术、心灵联结"
	button_icon_state = "spellpack"
//Magister = Generic magos, low utility mostly damage; Enchanter = Area denial beast, some utility; Seer = Full support with practically 0 offensive capacity.
	click_to_activate = FALSE
	primary_resource_cost = SPELLCOST_MIRACLE
	secondary_resource_cost = SPELLCOST_UTILITY_BUFF
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 5 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// var we use to flag we are currently choosing a bundle.
	var/choosing_bundle = FALSE
	var/chosen_bundle
	var/list/magister_bundle = list(
		/datum/action/cooldown/spell/projectile/greater_arcyne_bolt,
		/datum/action/cooldown/spell/projectile/arc_bolt,
		/datum/action/cooldown/spell/phase,
		/datum/action/cooldown/spell/message,
		/datum/action/cooldown/spell/create_campfire
	)
	var/list/enchanter_bundle = list(
		/datum/action/cooldown/spell/projectile/stygian_efflorescence,
		/datum/action/cooldown/spell/geas,
		/datum/action/cooldown/spell/touch/rune_ward,
		/datum/action/cooldown/spell/forcewall,
		/datum/action/cooldown/spell/augment_buff/blood_rush,
	)
	var/list/seer_bundle = list(
		/datum/action/cooldown/spell/augment_buff/attune_giant,
		/datum/action/cooldown/spell/augment_buff/guidance,
		/datum/action/cooldown/spell/augment_buff/attune_haste,
		/datum/action/cooldown/spell/augment_buff/fortitude,
		/datum/action/cooldown/spell/mindlink
	)

/datum/action/cooldown/spell/noc/spellpack/cast(atom/cast_on)
	. = ..()

	if(choosing_bundle)
		return FALSE
	var/choice = chosen_bundle
	if(!chosen_bundle)
		choosing_bundle = TRUE
		choice = alert(owner, "诺克赐予了你哪一类法术？", "选择道路", "魔导师", "附魔师", "先知")
		chosen_bundle = choice
		choosing_bundle = FALSE

	switch(choice)
		if("魔导师")
			add_spells(owner, magister_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("附魔师")
			add_spells(owner, enchanter_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("先知")
			add_spells(owner, seer_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
	return FALSE

/datum/action/cooldown/spell/noc/spellpack/proc/add_spells(mob/owner, list/spells, choice_count = 1, grant_all = FALSE)
	for(var/spell_type in spells)
		if(owner?.mind.has_spell(spells[spell_type]))
			spells.Remove(spell_type)
	if(!grant_all)
		var/choice_count_visual = choice_count
		for(var/i in 1 to choice_count)
			var/choice = input(owner, "选择一道法术！剩余可选次数：[choice_count_visual]") as null|anything in spells
			if(!isnull(choice))
				var/picked_spell = spells[choice]
				var/datum/new_spell = new picked_spell
				owner?.mind.AddSpell(new_spell)
				choice_count_visual--
				spells.Remove(choice)
	else
		for(var/spell_type in spells)
			var/datum/new_spell = new spell_type
			owner?.mind.AddSpell(new_spell)
	if(!length(spells))
		owner.mind?.RemoveSpell(src.type)

