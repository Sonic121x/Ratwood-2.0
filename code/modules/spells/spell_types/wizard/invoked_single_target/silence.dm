/obj/effect/proc_holder/spell/invoked/silence
	name = "缄默术"
	desc = "封住目标之舌。对真正的大法师不起作用。"
	cost = 3
	xp_gain = TRUE
	releasedrain = SPELLCOST_SINGLE_CC
	chargedrain = 1
	chargetime = 15
	recharge_time = 100 SECONDS
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "zizocloud"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	invocations = list("归于缄默。")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	zizo_spell = TRUE
	human_req = TRUE

/obj/effect/proc_holder/spell/invoked/silence/cast(list/targets, mob/user = usr)
	if(iscarbon(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(user == target) //self target
			to_chat(user, "<span class='warning'>我不能让自己沉默。</span>")
			revert_cast()
			return
		if(HAS_TRAIT(target, TRAIT_COUNTERCOUNTERSPELL) || HAS_TRAIT(target, TRAIT_ANTIMAGIC) || HAS_TRAIT(target, TRAIT_MUTE))
			to_chat(user, "<span class='warning'>法术噗地散掉了，对方不会受影响！</span>")
			revert_cast()
			return
		if(target.get_skill_level(/datum/skill/magic/arcane) > 2 || target.get_skill_level(/datum/skill/magic/holy) > 2)
			to_chat(user, "<span class='warning'>对方的魔力过于强盛，这招对他无效！</span>")
			revert_cast()
			return
		if(spell_guard_check(target, TRUE))
			target.visible_message(span_warning("[target]抵抗了沉默魔法！"))
			return TRUE
		ADD_TRAIT(target, TRAIT_MUTE, MAGIC_TRAIT)
		playsound(get_turf(target), 'sound/magic/zizo_snuff.ogg', 80, TRUE, soundping = TRUE)
		to_chat(target, span_warning("我喉中的风声忽然止息了。我说不出话了！"))
		var/dur = max((9 * (user.get_skill_level(associated_skill, 5))))
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = dur SECONDS)
		return TRUE
	else //misfire
		to_chat(user, "<span class='warning'>我必须选择能够说话、思考的生物。</span>")
		revert_cast()
		return


/obj/effect/proc_holder/spell/invoked/silence/proc/remove_buff(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_MUTE, MAGIC_TRAIT)
	to_chat(target, span_warning("我的声音回来了！"))

//Archivist special
/obj/effect/proc_holder/spell/invoked/silence/archivist_silence
	name = "档案管理员的噤声"
	desc = "让无礼者闭嘴！对真正的法师无效。"
	cost = 0 //can't unlearn it
	xp_gain = FALSE
	invocations = list()

/obj/effect/proc_holder/spell/invoked/silence/archivist_silence/cast(list/targets, mob/user = usr)
	if(!..())
		return
	user.emote("shh")
	if(iscarbon(targets[1]))
		var/mob/living/carbon/target = targets[1]
		target?.add_stress(/datum/stressevent/archivist_shushed)
		return TRUE
