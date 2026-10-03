/obj/item/rogueweapon/greatsword/moonlight_greatsword
	name = "月光大剑"
	desc = "过去背叛同胞的“无鳞”古龙 - 白龙希斯，其尾巴化成的武器。稀少的龙武器之一。为魔法始祖希斯的魔力结晶，那股力量能化为月光波动释放出来。"
	icon = 'modular_z121/icon/weapon64.dmi'
	icon_state = "moonlight1"
	item_state = "moonlight1"
	gripsprite = FALSE
	force = 18
	force_wielded = 30
	max_integrity = 400
	max_blade_int = 400
	wdefense = 6
	minstr = 10
	light_system = MOVABLE_LIGHT
	light_power = 3
	light_outer_range = 3
	light_on = FALSE
	light_color = "#BCDFFD"
	smeltresult = null
	sellprice = 250
	var/moonlight_active = FALSE
	var/moonlight_prompt_sent = FALSE
	// 冷却属于这把剑；只有跨过下一次黎明后的夜晚才能再次赐福。
	var/last_blessing_day = -1
	var/datum/weakref/spellbearer_ref
	var/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_wave/granted_wave_spell
	var/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_blessing/granted_blessing_spell

/obj/item/rogueweapon/greatsword/moonlight_greatsword/update_icon()
	icon_state = "moonlight1"
	return ..()

/obj/item/rogueweapon/greatsword/moonlight_greatsword/generateonmob(tag, prop, behind = FALSE, mirrored = FALSE, used_index = null)
	return ..(tag, prop, behind, mirrored, tag == "onback" ? "moonlight3" : "moonlight1")

/obj/item/rogueweapon/greatsword/moonlight_greatsword/add_blood_DNA(list/dna)
	return FALSE

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/is_blessing_ready()
	return is_moonlight_night() && GLOB.dayspassed > last_blessing_day

/obj/item/rogueweapon/greatsword/moonlight_greatsword/Initialize(mapload)
	. = ..()
	RegisterSignal(src, list(COMSIG_MOVABLE_MOVED, COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED), PROC_REF(on_moonlight_moved))
	START_PROCESSING(SSobj, src)
	update_moonlight_state()

/obj/item/rogueweapon/greatsword/moonlight_greatsword/Destroy()
	clear_moonlight_spells()
	QDEL_NULL(granted_wave_spell)
	QDEL_NULL(granted_blessing_spell)
	UnregisterSignal(src, list(COMSIG_MOVABLE_MOVED, COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/on_moonlight_moved()
	SIGNAL_HANDLER
	update_moonlight_state()

/obj/item/rogueweapon/greatsword/moonlight_greatsword/process()
	update_moonlight_state()

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/is_moonlight_night()
	return GLOB.tod == "night"

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/get_moonlight_holder()
	if(!ishuman(loc))
		return null
	var/mob/living/carbon/human/H = loc
	if(H.get_active_held_item() == src || H.get_inactive_held_item() == src)
		return H
	return null

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/find_moonlight_spell_instance(mob/living/carbon/human/holder, spell_type)
	if(!holder?.mind)
		return null
	for(var/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/spell as anything in holder.mind.spell_list)
		if(spell.type != spell_type)
			continue
		if(spell.get_source_weapon() == src)
			return spell
	return null

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/remove_moonlight_spell_instance(mob/living/carbon/human/holder, obj/effect/proc_holder/spell/self/moonlight_weapon_spell/spell_instance, spell_type)
	if(!holder?.mind)
		return
	var/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/spell_to_remove = spell_instance
	if(!spell_to_remove || !(spell_to_remove in holder.mind.spell_list) || spell_to_remove.get_source_weapon() != src)
		spell_to_remove = find_moonlight_spell_instance(holder, spell_type)
	if(!spell_to_remove)
		return
	holder.mind.spell_list -= spell_to_remove
	// 撤销授予而不销毁实例，离手期间仍继续冷却。
	var/mob/living/action_owner = spell_to_remove.action?.owner
	if(action_owner)
		action_owner.mind?.spell_list -= spell_to_remove
		spell_to_remove.deactivate(action_owner)
		spell_to_remove.on_lose(action_owner)
		spell_to_remove.action.Remove(action_owner)

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/clear_moonlight_spells(mob/living/carbon/human/holder_override)
	var/mob/living/carbon/human/holder = holder_override
	if(!holder)
		holder = spellbearer_ref?.resolve()
	if(holder?.mind)
		remove_moonlight_spell_instance(holder, granted_wave_spell, /obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_wave)
		remove_moonlight_spell_instance(holder, granted_blessing_spell, /obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_blessing)
	// 持有者已失去 mind 或发生身体转移时，也必须撤销原按钮。
	for(var/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/spell as anything in list(granted_wave_spell, granted_blessing_spell))
		var/mob/living/action_owner = spell?.action?.owner
		if(action_owner)
			action_owner.mind?.spell_list -= spell
			spell.deactivate(action_owner)
			spell.on_lose(action_owner)
			spell.action.Remove(action_owner)
	if(holder_override && holder_override == holder)
		to_chat(holder_override, span_notice("月光大剑中的秘术重新归于沉寂。"))
	spellbearer_ref = null

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/sync_moonlight_spells()
	var/mob/living/carbon/human/current_holder = get_moonlight_holder()
	var/mob/living/carbon/human/previous_holder = spellbearer_ref?.resolve()

	if(previous_holder && previous_holder != current_holder)
		clear_moonlight_spells(previous_holder)

	if(!moonlight_active || !current_holder?.mind)
		if(previous_holder == current_holder && previous_holder)
			clear_moonlight_spells(previous_holder)
		return

	if(!current_holder.mind.has_spell(/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_wave))
		if(QDELETED(granted_wave_spell))
			granted_wave_spell = new /obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_wave(src)
		current_holder.mind.AddSpell(granted_wave_spell, current_holder)
	if(!current_holder.mind.has_spell(/obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_blessing))
		if(QDELETED(granted_blessing_spell))
			granted_blessing_spell = new /obj/effect/proc_holder/spell/self/moonlight_weapon_spell/moonlight_blessing(src)
		current_holder.mind.AddSpell(granted_blessing_spell, current_holder)
	granted_blessing_spell?.action?.UpdateButtonIcon()

	if(previous_holder != current_holder)
		to_chat(current_holder, span_notice("月色沿着剑身流淌，两道古老的月光秘术在我心中浮现。"))
	spellbearer_ref = WEAKREF(current_holder)

/obj/item/rogueweapon/greatsword/moonlight_greatsword/proc/update_moonlight_state()
	var/should_be_active = is_moonlight_night()
	var/was_active = moonlight_active
	var/mob/living/carbon/human/holder = get_moonlight_holder()

	if(should_be_active)
		moonlight_active = TRUE
		obj_integrity = max_integrity
		blade_int = max_blade_int
		if(obj_broken)
			obj_fix()
			obj_integrity = max_integrity
			blade_int = max_blade_int
		force = 26
		force_wielded = 40
		if(!was_active)
			moonlight_prompt_sent = FALSE
	else
		moonlight_active = FALSE
		force = obj_broken ? initial(force) / 5 : initial(force)
		force_wielded = obj_broken ? initial(force_wielded) / 5 : initial(force_wielded)
		moonlight_prompt_sent = FALSE

	update_force_dynamic()
	var/attached_to_strap = istype(loc, /obj/item/rogueweapon/scabbard/gwstrap)
	var/new_light_flags = attached_to_strap ? light_flags | LIGHT_ATTACHED : light_flags & ~LIGHT_ATTACHED
	if(new_light_flags != light_flags)
		set_light_on(FALSE)
		if(!(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_FLAGS, new_light_flags) & COMPONENT_BLOCK_LIGHT_UPDATE))
			var/old_light_flags = light_flags
			light_flags = new_light_flags
			SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_FLAGS, old_light_flags)
	set_light_on(moonlight_active)
	if(was_active != moonlight_active)
		update_icon()

	sync_moonlight_spells()

	if(moonlight_active && !moonlight_prompt_sent)
		if(holder)
			to_chat(holder, span_notice("月光大剑似乎在吸收月光的力量，剑身愈发明亮。"))
			moonlight_prompt_sent = TRUE

// 巨型武器背带通常复制剑的物品图；月光大剑单独使用背挂图。
/obj/item/rogueweapon/scabbard/gwstrap/getmoboverlay(tag, prop, behind = FALSE, mirrored = FALSE)
	if(tag == "onback" && istype(sheathed, /obj/item/rogueweapon/greatsword/moonlight_greatsword))
		return fcopy_rsc(sheathed.generateonmob(tag, prop, behind, mirrored, "moonlight3"))
	return ..()
