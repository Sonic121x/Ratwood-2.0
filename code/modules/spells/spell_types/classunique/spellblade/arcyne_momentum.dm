#define MOMENTUM_FILTER "momentum_glow"
#define MOMENTUM_DECAY_DELAY (8 SECONDS)
#define SECOND_PER_MOMENTUM (6 SECONDS) // Time between each stack lost during decay.

/atom/movable/screen/alert/status_effect/buff/arcyne_momentum
	name = "奥术动量（0）"
	desc = "近战打击积蓄奥术力量。累积动量以释放强大能力。近战每 2 秒可提供 1 层，部分可命中多个目标的能力会提供额外动量。达到 7 层便会过载——尽快释放！若未使用便开始衰减，所有动量会同时泄出，令你承受反噬、短暂减速并陷入易伤。谨防失控。"
	icon_state = "buff"

/datum/status_effect/buff/arcyne_momentum
	id = "arcyne_momentum"
	alert_type = /atom/movable/screen/alert/status_effect/buff/arcyne_momentum
	duration = -1
	tick_interval = 20
	status_type = STATUS_EFFECT_UNIQUE
	var/stacks = 0
	var/max_stacks = 10
	var/glow_colour = "#4a90d9"
	var/crackle_colour = "#7b5ea7"
	var/overcharge_threshold = 7
	var/is_overcharged = FALSE
	var/last_stack_time = 0
	var/last_decay_time = 0
	var/static/mutable_appearance/electricity_overlay
	var/obj/item/bound_weapon
	var/chant
	var/last_melee_gain = 0
	var/melee_gain_cooldown = 2 SECONDS

/datum/status_effect/buff/arcyne_momentum/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_STATUS_STUN, PROC_REF(on_stunned))
	RegisterSignal(owner, COMSIG_LIVING_STATUS_KNOCKDOWN, PROC_REF(on_knockdown))
	// Flag the mind so it persists through death/revival
	if(owner.mind)
		owner.mind.has_arcyne_momentum = TRUE
	update_alert()

/datum/status_effect/buff/arcyne_momentum/on_remove()
	UnregisterSignal(owner, list(COMSIG_LIVING_STATUS_STUN, COMSIG_LIVING_STATUS_KNOCKDOWN))
	if(chant == "unarmed")
		UnregisterSignal(owner, list(COMSIG_HUMAN_MELEE_UNARMED_ATTACK, COMSIG_MOB_ITEM_ATTACK))
	if(is_overcharged)
		owner.cut_overlay(electricity_overlay)
	owner.remove_filter(MOMENTUM_FILTER)
	. = ..()

// Call this after setting chant to register the appropriate signals
/datum/status_effect/buff/arcyne_momentum/proc/set_chant(new_chant)
	// Unregister old unarmed signals if switching away
	if(chant == "unarmed" && new_chant != "unarmed")
		UnregisterSignal(owner, list(COMSIG_HUMAN_MELEE_UNARMED_ATTACK, COMSIG_MOB_ITEM_ATTACK))
	chant = new_chant
	// Register unarmed signals if needed
	if(chant == "unarmed")
		RegisterSignal(owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))
		RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_unarmed_item_attack))

/datum/status_effect/buff/arcyne_momentum/proc/on_unarmed_attack(mob/living/source, atom/target, proximity)
	SIGNAL_HANDLER
	if(!isliving(target))
		return
	// Only punch intent builds momentum, not touch/shove/grab
	if(!istype(owner.used_intent, /datum/intent/unarmed/punch))
		return
	var/mob/living/victim = target
	if(victim == owner || victim.stat == DEAD)
		return
	if(world.time < last_melee_gain + melee_gain_cooldown)
		return
	add_stacks(1)
	last_melee_gain = world.time

// Momentum from knuckle/katar hits — only if the weapon uses unarmed skill
/datum/status_effect/buff/arcyne_momentum/proc/on_unarmed_item_attack(mob/living/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(!isliving(target) || target == owner || target.stat == DEAD)
		return
	var/obj/item/weapon = user?.get_active_held_item()
	if(!weapon || weapon.associated_skill != /datum/skill/combat/unarmed)
		return
	if(world.time < last_melee_gain + melee_gain_cooldown)
		return
	add_stacks(1)
	last_melee_gain = world.time

/datum/status_effect/buff/arcyne_momentum/proc/on_stunned()
	SIGNAL_HANDLER
	if(stacks <= 0)
		return
	stacks = 0
	owner.balloon_alert(owner, "动量：0/[max_stacks]")
	update_visuals()
	update_alert()
	update_spell_buttons()
	to_chat(owner, span_warning("冲击打断了我的专注——所有动量尽失！"))

/datum/status_effect/buff/arcyne_momentum/proc/on_knockdown()
	SIGNAL_HANDLER
	if(stacks <= 0)
		return
	stacks = 0
	owner.balloon_alert(owner, "动量：0/[max_stacks]")
	update_visuals()
	update_alert()
	update_spell_buttons()
	to_chat(owner, span_warning("我摔倒在地——所有动量尽失！"))

/datum/status_effect/buff/arcyne_momentum/proc/add_stacks(amount)
	var/old_stacks = stacks
	stacks = min(stacks + amount, max_stacks)
	last_stack_time = world.time
	if(stacks == old_stacks)
		return
	owner.balloon_alert(owner, "动量：[stacks]/[max_stacks]")
	update_visuals()
	update_alert()
	update_spell_buttons()
	if(old_stacks < 3 && stacks >= 3)
		to_chat(owner, span_notice("奥术之力在我体内汇聚！"))
		playsound(get_turf(owner), 'sound/magic/charging.ogg', 30, TRUE)
	if(old_stacks < 6 && stacks >= 6)
		to_chat(owner, span_warning("释放！我必须立刻行动！"))
		playsound(get_turf(owner), 'sound/magic/charged.ogg', 50, TRUE)
	if(old_stacks < overcharge_threshold && stacks >= overcharge_threshold)
		to_chat(owner, span_boldwarning("力量！力量！力量！释放！释放！释放！"))
		playsound(get_turf(owner), 'sound/magic/charged.ogg', 70, TRUE)

/datum/status_effect/buff/arcyne_momentum/proc/consume_stacks(amount)
	var/consumed = min(stacks, amount)
	stacks = max(stacks - amount, 0)
	owner.balloon_alert(owner, "动量：[stacks]/[max_stacks]")
	update_visuals()
	update_alert()
	update_spell_buttons()
	return consumed

/datum/status_effect/buff/arcyne_momentum/proc/consume_all_stacks()
	var/consumed = stacks
	stacks = 0
	owner.balloon_alert(owner, "动量：0/[max_stacks]")
	update_visuals()
	update_alert()
	update_spell_buttons()
	return consumed

/datum/status_effect/buff/arcyne_momentum/proc/update_visuals()
	var/had_filter = owner.remove_filter(MOMENTUM_FILTER)
	if(stacks >= overcharge_threshold)
		owner.add_filter(MOMENTUM_FILTER, 2, list("type" = "outline", "color" = crackle_colour, "alpha" = 200, "size" = 2))
	else if(stacks >= 6)
		owner.add_filter(MOMENTUM_FILTER, 2, list("type" = "outline", "color" = crackle_colour, "alpha" = 150, "size" = 2))
	else if(stacks >= 3)
		owner.add_filter(MOMENTUM_FILTER, 2, list("type" = "outline", "color" = glow_colour, "alpha" = 100, "size" = 1))
	else if(had_filter && (owner.appearance_flags & KEEP_TOGETHER))
		// KEEP_TOGETHER mobs don't repaint filter removal until another appearance change
		owner.appearance_flags &= ~KEEP_TOGETHER
		addtimer(VARSET_CALLBACK(owner, appearance_flags, owner.appearance_flags | KEEP_TOGETHER), 1)
	if(stacks >= overcharge_threshold)
		if(!is_overcharged)
			enter_overcharge()
	else if(is_overcharged)
		exit_overcharge()

/datum/status_effect/buff/arcyne_momentum/proc/update_alert()
	if(!linked_alert)
		return
	linked_alert.name = "奥术动量（[stacks]/[max_stacks]）"

/datum/status_effect/buff/arcyne_momentum/proc/update_spell_buttons()
	if(!owner?.mind)
		return
	for(var/obj/effect/proc_holder/spell/S in owner.mind.spell_list)
		if(S.action)
			S.action.build_all_button_icons(UPDATE_BUTTON_STATUS)
	for(var/datum/action/cooldown/spell/S in owner.mind.spell_list)
		S.build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/status_effect/buff/arcyne_momentum/tick()
	if(stacks > 0 && world.time - last_stack_time >= MOMENTUM_DECAY_DELAY)
		if(world.time - last_decay_time >= SECOND_PER_MOMENTUM)
			last_decay_time = world.time
			if(stacks >= overcharge_threshold)
				strain()
				return
			stacks = max(stacks - 1, 0)
			owner.balloon_alert(owner, "动量：[stacks]/[max_stacks]")
			update_visuals()
			update_alert()
			update_spell_buttons()

/datum/status_effect/buff/arcyne_momentum/proc/strain()
	stacks = 0
	owner.balloon_alert(owner, "动量：0/[max_stacks]")
	update_visuals()
	update_alert()
	update_spell_buttons()
	owner.Slowdown(2)
	owner.apply_status_effect(/datum/status_effect/debuff/vulnerable, 5 SECONDS)
	owner.balloon_alert_to_viewers("<font color='#bb2b2b'>承受反噬！</font>")
	to_chat(owner, span_boldwarning("积蓄未发的力量反噬了我的身体！"))

/datum/status_effect/buff/arcyne_momentum/proc/enter_overcharge()
	is_overcharged = TRUE
	if(!electricity_overlay)
		electricity_overlay = mutable_appearance('icons/effects/effects.dmi', "electricity", EFFECTS_LAYER)
		electricity_overlay.appearance_flags = RESET_COLOR
	owner.add_overlay(electricity_overlay)
	to_chat(owner, span_boldwarning("奥术能量过载，电光在我周身噼啪作响！"))

/datum/status_effect/buff/arcyne_momentum/proc/exit_overcharge()
	is_overcharged = FALSE
	owner.cut_overlay(electricity_overlay)

/proc/get_arcyne_momentum(mob/living/target)
	if(!istype(target))
		return 0
	var/datum/status_effect/buff/arcyne_momentum/M = target.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M)
		return 0
	return M.stacks

#undef MOMENTUM_FILTER
#undef MOMENTUM_DECAY_DELAY
#undef SECOND_PER_MOMENTUM
