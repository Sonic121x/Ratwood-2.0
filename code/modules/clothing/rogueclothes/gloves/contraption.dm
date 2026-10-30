/obj/item/clothing/gloves/roguetown/chain/contraption
	var/obj/item/accepted_power_source = /obj/item/roguegear/bronze	//Bronze by default
	//this is what we use to double power items with, this isn't for all devices
	var/obj/item/prime_power_source = /obj/item/roguegear/wood/reliable
	var/charge_per_source = 5
	var/charge_per_prime = 10
	//allows you to store several charges
	var/max_stored_charge = 20
	var/current_charge = 0
	var/misfire_chance = 0
	var/sneaky_misfire_chance
	var/misfiring = FALSE

/*/obj/item/clothing/gloves/roguetown/chain/contraption/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)
*/
// === CONTRAPTION CORE BEHAVIOR ===
/obj/item/clothing/gloves/roguetown/chain/contraption/proc/battery_collapse(obj/wearer, mob/living/user)
	to_chat(user, span_info("为[src]供能的[initial(accepted_power_source.name)]彻底化作了虚无！"))
	playsound(src, pick('sound/combat/hits/onmetal/grille (1).ogg','sound/combat/hits/onmetal/grille (2).ogg'), 100, FALSE)

/obj/item/clothing/gloves/roguetown/chain/contraption/proc/misfire(obj/wearer, mob/living/user)
	to_chat(user, span_danger("[src]在你手中猛烈迸出火花！"))
	playsound(src, 'sound/misc/bell.ogg', 100)
	addtimer(CALLBACK(src, PROC_REF(misfire_result), wearer, user), rand(5, 30))

/obj/item/clothing/gloves/roguetown/chain/contraption/proc/misfire_result(obj/wearer, mob/living/user)
	misfiring = TRUE
	explosion(src, light_impact_range = 2, flame_range = 2, smoke = TRUE)
	qdel(src)

/obj/item/clothing/gloves/roguetown/chain/contraption/proc/charge_deduction(obj/wearer, mob/living/user, deduction)
	current_charge -= deduction
	if(current_charge <= 0)
		addtimer(CALLBACK(src, PROC_REF(battery_collapse), wearer, user), 5)


/obj/item/clothing/gloves/roguetown/chain/contraption/voltic
	name = "伏电机关护手"
	desc = "由青铜与黄铜制成的护手，装有嗡鸣运转的机械，并刻满伏电符文。它正因不稳定的能量而低鸣。"
	icon_state = "volticgauntlets"
	slot_flags = ITEM_SLOT_GLOVES
	armor = ARMOR_MAILLE
	resistance_flags = FIRE_PROOF
	blocksound = CHAINHIT
	max_integrity = ARMOR_INT_SIDE_BRONZE
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/bronze
	grid_width = 64
	grid_height = 32
	unarmed_bonus = 1.2
	misfire_chance = 0
	var/activate_sound = 'sound/items/stunmace_gen (2).ogg'
	var/cdtime = 15 SECONDS
	var/activetime = 5 SECONDS
	var/delay = 3 SECONDS
	var/sprite_changes = 10
	var/datum/beam/current_beam = null
	var/active = FALSE
	var/cooldowny

/obj/item/clothing/gloves/roguetown/chain/contraption/voltic/attackby(obj/item/gear, mob/user, params)
	var/charge = 0
	if(istype(gear, prime_power_source))
		charge = charge_per_prime
	else if(istype(gear, accepted_power_source))
		charge = charge_per_source
	if(!charge)
		return ..()
	user.changeNext_move(CLICK_CD_FAST)
	var/datum/effect_system/spark_spread/sparks = new()
	sparks.set_up(1, 1, get_turf(src))
	sparks.start()
	playsound(src, 'sound/combat/hits/blunt/woodblunt (2).ogg', 100, TRUE)
	if((max_stored_charge - current_charge) < charge_per_source)
		to_chat(user, span_info("我试着装入[gear]，但[src]再也容纳不下更多电荷了！"))
		shake_camera(user, 1, 1)
		return TRUE
	to_chat(user, span_info("我装入[gear]，[src]随即开始滴答作响。"))
	current_charge = min(current_charge + charge, max_stored_charge)
	qdel(gear)
	return TRUE

/obj/item/clothing/gloves/roguetown/chain/contraption/voltic/attack_right(mob/user)
	if(loc != user)
		return
	if(cooldowny && world.time < cooldowny + cdtime)
		to_chat(user, span_warning("什么也没发生。"))
		return
	user.visible_message(span_warning("[user]启动了[src]!"))
	if(activate_sound)
		playsound(user, activate_sound, 100, FALSE, -1)
	cooldowny = world.time
	addtimer(CALLBACK(src, PROC_REF(demagicify)), activetime)
	active = TRUE
	update_icon()
	activate(user)

/obj/item/clothing/gloves/roguetown/chain/contraption/voltic/proc/demagicify()
	active = FALSE
	update_icon()
	if(ismob(loc))
		var/mob/user = loc
		user.visible_message(span_warning("[src] 平静了下来。"))
		user.update_inv_wear_id()

// === VOLTIC ZAP ===
/obj/item/clothing/gloves/roguetown/chain/contraption/voltic/proc/activate(mob/living/user)
	if(!user)
		return
	if(obj_broken)
		to_chat(user, span_warning("护手迸出火花。它已损坏得无法运作!"))
		return
	if(!current_charge)
		to_chat(user, span_warning("护手噼啪作响。它需要一个[initial(accepted_power_source.name)]!"))
		playsound(src, 'sound/magic/magic_nulled.ogg', 100)
		return
	var/skill = user.get_skill_level(/datum/skill/craft/engineering)

	if(skill > 1) //if they have 2 or above it won't misfire
		misfire_chance = 0
	// Check for misfire before activation
	if(misfire_chance && prob(max(0, misfire_chance - user.goodluck(2) - skill)))
		misfire(src, user)
		return
	// spend a charge
	charge_deduction(null, user, 1)

	var/list/mob/living/valid_targets = list()
	// Find targets in range
	for(var/mob/living/carbon/C in view(4, user))
		if(C.anti_magic_check())
			visible_message(span_warning("电光在 [C] 身上无害地消散了!"))
			playsound(get_turf(C), 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(C == user)
			continue
		valid_targets += C
		user.visible_message(span_warning("[C] 与 [user] 之间连起了一道伏电链！"),
		span_warning("你与 [C] 建立了一道静电链接。"))

	if(!valid_targets.len)
		return

	// Create beam effects and apply shock
	for(var/mob/living/carbon/C in valid_targets)
		if(C == user)
			continue
		var/datum/beam/current_beam
		for (var/x = 1; x <= sprite_changes; x++)
			current_beam = new(user, C, time = 50 / sprite_changes, icon_state = "lightning[ rand(1,12) ]", beam_type = /obj/effect/ebeam, max_distance = 10)
			INVOKE_ASYNC(current_beam, TYPE_PROC_REF(/datum/beam, Start))
			sleep(delay / sprite_changes)

		var/dist = get_dist(user, C)
		if (dist <= 4)
			if (HAS_TRAIT(C, TRAIT_SHOCKIMMUNE))
				continue
			else
				C.Immobilize(3 SECONDS)
				C.apply_status_effect(/datum/status_effect/debuff/clickcd, 8 SECONDS)
				C.electrocute_act(5, src, 5, SHOCK_NOSTUN)
				C.apply_status_effect(/datum/status_effect/buff/lightningstruck, 8 SECONDS)
		else
			playsound(user, 'sound/items/stunmace_toggle (3).ogg', 100)
			user.visible_message(span_warning("伏电链接熄灭了！"), span_warning("[C] 太远了！"))
