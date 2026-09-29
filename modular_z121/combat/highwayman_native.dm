// 局部适配主线武器攻击、部位伤害、闪避及招架流程。

// 普攻保留原有前摇、命中率、穿甲、伤口及耐久处理；仅职业强化攻击调用。

// 防御适配仅在对应状态存在时启用，未生效时调用父类。

/obj/item/proc/z121_highwayman_attack(mob/living/M, mob/living/user)
	var/override_status

	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK, M, user) & COMPONENT_ITEM_NO_ATTACK)
		return FALSE

	var/_receiver_signal = SEND_SIGNAL(M, COMSIG_MOB_ITEM_BEING_ATTACKED, M, user, src)
	if(_receiver_signal & COMPONENT_ITEM_NO_ATTACK)
		return FALSE
	else if(_receiver_signal & COMPONENT_ITEM_NO_DEFENSE)
		override_status = ATTACK_OVERRIDE_NODEFENSE

	var/_attacker_signal = SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK, M, user, src)
	if(_attacker_signal & COMPONENT_ITEM_NO_ATTACK)
		return FALSE
	else if(_attacker_signal & COMPONENT_ITEM_NO_DEFENSE)
		override_status = ATTACK_OVERRIDE_NODEFENSE

	if(item_flags & NOBLUDGEON)
		return FALSE

	if(force && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("I don't want to harm other living beings!"))
		return

	M.lastattacker = user.real_name
	M.lastattackerckey = user.ckey
	M.lastattacker_weakref = WEAKREF(user)
	if(M.mind)
		M.mind.attackedme[user.real_name] = world.time
	if(force)
		if(user.used_intent)
			if(!user.used_intent.noaa)
				playsound(get_turf(src), pick(swingsound), 100, FALSE, -1)
			if(user.used_intent.no_attack)
				log_combat(user, M, "used a non-damaging intent on", src.name, "(INTENT: [uppertext(user.used_intent.name)])", log_seen = FALSE)
				add_fingerprint(user)
				return
	else
		return

	user.mob_timers[MT_SNEAKATTACK] = world.time
	var/swingdelay = user.used_intent.swingdelay
	var/_swingdelay_mod = SEND_SIGNAL(src, COMSIG_LIVING_SWINGDELAY_MOD)
	if(_swingdelay_mod)
		swingdelay += _swingdelay_mod

	var/datum/intent/cached_intent = user.used_intent
	if(swingdelay)
		if(!user.used_intent.noaa && isnull(user.mind))
			if(get_dist(get_turf(user), get_turf(M)) <= user.used_intent.reach)
				user.do_attack_animation(M, user.used_intent.animname, user.used_intent.masteritem, used_intent = user.used_intent, simplified = TRUE)
		sleep(swingdelay)
	if(user.a_intent != cached_intent)
		return
	if(QDELETED(src) || QDELETED(M))
		return
	if(!user.CanReach(M,src))
		return
	if(user.get_active_held_item() != src && !HAS_TRAIT(user, TRAIT_DUALWIELDER))
		return
	if(user.incapacitated())
		return
	if((M.mobility_flags & MOBILITY_STAND))
		if(M.checkmiss(user))
			if(!swingdelay && !user.used_intent?.cleave)
				if(get_dist(get_turf(user), get_turf(M)) <= user.used_intent.reach)
					user.do_attack_animation(M, user.used_intent.animname, used_item = src, used_intent = user.used_intent, simplified = TRUE)
			return

	user.stamina_add(user.used_intent.releasedrain + user.get_swifstrong_stam_penalty())
	var/bad_guard = FALSE

	if(user.has_status_effect(/datum/status_effect/buff/clash) && !M.has_status_effect(/datum/status_effect/buff/clash))
		bad_guard = TRUE
	if(M.has_status_effect(/datum/status_effect/buff/clash) && M.get_active_held_item() && ishuman(M) && !bad_guard)
		var/mob/living/carbon/human/HM = M
		var/obj/item/IM = M.get_active_held_item()
		var/obj/item/IU
		if(user.used_intent.masteritem)
			IU = user.used_intent.masteritem
		HM.process_clash(user, IM, IU)
		return
	if(bad_guard)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.bad_guard(span_suicide("I switched stances too quickly! It drains me!"), cheesy = TRUE)

	if(user.mob_biotypes & MOB_UNDEAD)
		if(M.has_status_effect(/datum/status_effect/buff/necras_vow))
			if(isnull(user.mind))
				user.adjust_fire_stacks(5)
				user.ignite_mob()
			else
				if(prob(30))
					to_chat(M, span_warning("The foul blessing of the Undermaiden hurts us!"))
			user.adjust_blurriness(3)
			user.adjustBruteLoss(5)
			user.apply_status_effect(/datum/status_effect/churned, M)

		if(M.has_status_effect(/datum/status_effect/buff/inviolability))
			if(isnull(user.mind))
				user.adjust_fire_stacks(1)
				user.ignite_mob()
			else
				if(prob(30))
					to_chat(M, span_warning("Some matter of force harms us!"))
			user.adjust_blurriness(2)
			user.adjustBruteLoss(rand(10, 15))

	_attacker_signal = null
	_attacker_signal = SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, M, user, src)
	if(_attacker_signal & COMPONENT_ITEM_NO_ATTACK)
		return FALSE
	else if(_attacker_signal & COMPONENT_ITEM_NO_DEFENSE)
		override_status = ATTACK_OVERRIDE_NODEFENSE

	if(override_status != ATTACK_OVERRIDE_NODEFENSE)
		if(z121_highwayman_defense(M, user))
			return

	SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SUCCESS, M, user)
	SEND_SIGNAL(M, COMSIG_ITEM_ATTACKED_SUCCESS, src, user)
	if(user.zone_selected == BODY_ZONE_PRECISE_R_INHAND)
		var/offh = 0
		var/obj/item/W = M.held_items[1]
		if(W)
			if(!(M.mobility_flags & MOBILITY_STAND))
				M.throw_item(get_step(M,turn(M.dir, 90)), offhand = offh)
			else
				M.dropItemToGround(W)
			M.visible_message(span_notice("[user] disarms [M]!"), \
							span_boldwarning("I'm disarmed by [user]!"))
			return

	if(user.zone_selected == BODY_ZONE_PRECISE_L_INHAND)
		var/offh = 0
		var/obj/item/W = M.held_items[2]
		if(W)
			if(!(M.mobility_flags & MOBILITY_STAND))
				M.throw_item(get_step(M,turn(M.dir, 270)), offhand = offh)
			else
				M.dropItemToGround(W)
			M.visible_message(span_notice("[user] disarms [M]!"), \
							span_boldwarning("I'm disarmed by [user]!"))
			return

	if(z121_highwayman_hit(M, user))
		if(user.used_intent == cached_intent)
			var/tempsound = user.used_intent.hitsound
			if(tempsound)
				playsound(M.loc,  tempsound, 100, FALSE, -1)
			else
				playsound(M.loc,  "nodmg", 100, FALSE, -1)

	log_combat(user, M, "attacked", src.name, "(INTENT: [uppertext(user.used_intent.name)]) (DAMTYPE: [uppertext(damtype)]) (AIMED: [uppertext(parse_zone(user.zone_selected))])")

	execute_cleave(user, get_turf(M), M)

	add_fingerprint(user)

/mob/living/carbon/human/proc/z121_highwayman_attacked_by(obj/item/I, mob/living/user)
	if(!I || !user)
		return 0
	var/obj/item/bodypart/affecting
	var/useder = user.zone_selected
	if(!lying_attack_check(user,I))
		return 0
	if(user.tempatarget)
		useder = user.tempatarget
		user.tempatarget = null
	affecting = get_bodypart(check_zone(useder))

	if(!affecting)
		to_chat(user, span_warning("Unfortunately, there's nothing there."))
		return 0

	SEND_SIGNAL(I, COMSIG_ITEM_ATTACK_ZONE, src, user, affecting)

	SSblackbox.record_feedback("nested tally", "item_used_for_combat", 1, list("[I.force]", "[I.type]"))
	SSblackbox.record_feedback("tally", "zone_targeted", 1, useder)

	if(I.force)
		retaliate(user)

	return dna.species.z121_highwayman_spec_attacked_by(I, user, affecting, used_intent, src, useder)

/datum/species/proc/z121_highwayman_spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H, selzone)

	if(user != H && !I.z121_highwayman_cut_ready(user))
		if(H.check_shields(I, I.force, "the [I.name]", MELEE_ATTACK, I.armor_penetration))
			return 0
	if(!I.z121_highwayman_cut_ready(user) && H.check_block())
		H.visible_message(span_warning("[H] blocks [I]!"), \
						span_danger("I block [I]!"))
		return 0

	SEND_SIGNAL(H, COMSIG_SPECIES_ATTACKED_BY)

	var/hit_area

	selzone = melee_accuracy_check(user.zone_selected, user, H, I.associated_skill, user.used_intent, I)
	affecting = H.get_bodypart(check_zone(selzone))

	if(!affecting)
		return
	var/datum/intent/effect/int = user.used_intent
	if(istype(int, /datum/intent/effect) && selzone)
		var/do_effect = FALSE
		if(length(int.target_parts))
			if(selzone in int.target_parts)
				do_effect = TRUE
		else
			do_effect = TRUE
		if(do_effect)
			H.apply_status_effect(int.intent_effect)
	int.spec_on_apply_effect(H, user)
	hit_area = affecting.name
	var/def_zone = affecting.body_zone

	var/pen = I.armor_penetration
	if(user.used_intent?.penfactor)
		pen = I.armor_penetration + user.used_intent.penfactor
	if(I.d_type == "blunt")
		pen = BLUNT_DEFAULT_PENFACTOR

	var/Iforce = get_complex_damage(I, user) * ((user.has_status_effect(/datum/status_effect/z121_highwayman_flaws) && z121_highwayman_armor_allowed(user)) ? 1.3 : 1)
	if(!user.used_intent?.allow_offhand)
		if(user.get_num_arms(FALSE) < 2 || user.get_inactive_held_item())
			Iforce = 0
	var/bladec = user.used_intent.blade_class

	if(user.used_intent?.effective_range && H.mobility_flags & MOBILITY_STAND)
		var/dist = get_dist(H, user)
		var/range = user.used_intent?.effective_range
		var/apply_penalty = FALSE
		switch(user.used_intent?.effective_range_type)
			if(EFF_RANGE_EXACT)
				if(dist != range)
					apply_penalty = TRUE
			if(EFF_RANGE_ABOVE)
				if(dist < range)
					apply_penalty = TRUE
			if(EFF_RANGE_BELOW)
				if(dist > range)
					apply_penalty = TRUE
			else
				CRASH("Invalid effective_range_type used by [user] with effective_range! Please set an effective_range_type on [user.used_intent?.type]")
		if(apply_penalty)
			pen = BLUNT_DEFAULT_PENFACTOR
			Iforce *= 0.5

	if(H == user && bladec == BCLASS_PEEL)
		bladec = BCLASS_BLUNT

	var/higher_intfactor = max(user.used_intent.masteritem?.intdamage_factor, user.used_intent.intent_intdamage_factor)
	var/lowest_intfactor = min(user.used_intent.masteritem?.intdamage_factor, user.used_intent.intent_intdamage_factor)
	var/used_intfactor = 1
	if(lowest_intfactor < 1)
		used_intfactor = lowest_intfactor
	if(higher_intfactor > 1)
		used_intfactor = higher_intfactor

	if(ishuman(user) && user.mind && user.used_intent.blade_class != BCLASS_PEEL)
		var/text = "[bodyzone2readablezone(selzone)]..."
		if(HAS_TRAIT(user, TRAIT_DECEIVING_MEEKNESS))
			if(prob(10))
				text = "<i>I can't tell...</i>"
				user.filtered_balloon_alert(TRAIT_COMBAT_AWARE, text)
		else
			user.filtered_balloon_alert(TRAIT_COMBAT_AWARE, text)

	var/armor_block = H.run_armor_check(selzone, I.d_type, "", "",pen, damage = Iforce, blade_dulling=bladec, peeldivisor = user.used_intent.peel_divisor, intdamfactor = used_intfactor, used_weapon = I)

	var/nodmg = FALSE

	if(Iforce)
		H.retaliate(user)

		var/weakness = H.check_weakness(I, user)
		H.next_attack_msg.Cut()
		if(!apply_damage(Iforce * weakness, I.damtype, def_zone, armor_block, H))
			nodmg = TRUE
			H.next_attack_msg += " <span class='warning'>The armor yet remains...</span>"
			if(I)
				I.remove_bintegrity(1)
				I.take_damage(1, BRUTE, I.d_type)

				if(user.used_intent.blunt_chipping)
					var/blunt_chip_block = H.run_armor_check(selzone, "blunt", armor_penetration = 80)
					H.apply_damage(Iforce * user.used_intent.blunt_chip_strength, BRUTE, def_zone, blunt_chip_block)
					H.next_attack_msg += " <span class='warning'>and yet the force punches through!</span>"
		I.z121_highwayman_landed(user, H, selzone)
		if(!nodmg)
			var/datum/wound/crit_wound = affecting.bodypart_attacked_by(user.used_intent.blade_class, (Iforce * weakness) * ((100-(armor_block+armor))/100), user, selzone, crit_message = TRUE, weapon = I, armor_penetration = pen)
			if(should_embed_weapon(crit_wound, I))
				var/can_impale = TRUE
				if(!affecting)
					can_impale = FALSE
				else if(I.wlength > WLENGTH_SHORT && (affecting.body_zone != BODY_ZONE_CHEST))
					can_impale = FALSE
				if(can_impale && user.Adjacent(H))

					H.emote("embed")
					H.Stun(10)
					playsound(H.loc, "genblunt", 100, FALSE, -1)
					user.visible_message(span_notice("[user] embeds [I] within [H]'s [affecting.name]!"), span_notice("I embed my [I] in [H]'s [affecting.name]."))
					var/list/targets = list(H)
					if(do_after_mob(user,targets, 10, progress = 0, uninterruptible = 1, required_mobility_flags = null))
						affecting.receive_damage(I.embedding.embedded_unsafe_removal_pain_multiplier*I.w_class)
						H.emote("paincrit", forced = TRUE)
						playsound(H, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
						user.visible_message(span_notice("[user] rips [I] out of [H]'s [affecting.name]!"), span_notice("I rip [I] from [H]'s [affecting.name]."))
			I.do_special_attack_effect(user, affecting, intent, H, selzone)

	I.funny_attack_effects(H, user, nodmg)
	H.send_item_attack_message(I, user, selzone, affecting, bladec)

	if(nodmg)
		return FALSE

	var/bloody = 0
	var/probability = I.get_dismemberment_chance(affecting, user, selzone)

	var/dismember_damtype = I.damtype
	var/datum/component/martyrweapon/martyr = I.GetComponent(/datum/component/martyrweapon)
	if(martyr?.is_active)
		dismember_damtype = BRUTE
	if(affecting.brute_dam && prob(probability) && affecting.dismember(dismember_damtype, user.used_intent?.blade_class, user, selzone, vorpal = I.vorpal))
		bloody = 1
		I.add_mob_blood(H)
		user.update_inv_hands()
		playsound(get_turf(H), I.get_dismember_sound(), 80, TRUE)

	if(((I.damtype == BRUTE) && I.force && prob(25 + (I.force * 2))))
		if(affecting.status == BODYPART_ORGANIC)
			I.add_mob_blood(H)
			user.update_inv_hands()
			if(prob(I.force * 2) || bloody)
				bloody = 1
				var/turf/location = H.loc
				var/splatter_dir = get_dir(H, user)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(H.loc, splatter_dir)
				if(istype(location))
					H.add_splatter_floor(location)
					H.add_splatter_wall(location, force = I.force)
				if(get_dist(user, H) <= 1)
					user.add_mob_blood(H)

		switch(hit_area)
			if(BODY_ZONE_HEAD)

				if(bloody)
					if(H.wear_mask)
						H.wear_mask.add_mob_blood(H)
						H.update_inv_wear_mask()
					if(H.head)
						H.head.add_mob_blood(H)
						H.update_inv_head()
					if(H.glasses && prob(33))
						H.glasses.add_mob_blood(H)
						H.update_inv_glasses()

			if(BODY_ZONE_CHEST)

				if(bloody)
					if(H.wear_armor)
						H.wear_armor.add_mob_blood(H)
						H.update_inv_armor()
					if(H.wear_shirt)
						H.wear_shirt.add_mob_blood(H)
						H.update_inv_shirt()
					if(H.wear_pants)
						H.wear_pants.add_mob_blood(H)
						H.update_inv_pants()

		if(Iforce > 10 || Iforce >= 5 && prob(Iforce))
			H.forcesay(GLOB.hit_appends)
	return TRUE

/mob/living/simple_animal/proc/z121_highwayman_attacked_by(obj/item/I, mob/living/user)
	if(I.force_dynamic < force_threshold || I.damtype == STAMINA)
		playsound(loc, 'sound/blank.ogg', I.get_clamped_volume(), TRUE, -1)
	else
		var/hitlim = simple_limb_hit(user.zone_selected)
		I.funny_attack_effects(src, user)
		if(I.force_dynamic)
			var/newforce = get_complex_damage(I, user) * ((user.has_status_effect(/datum/status_effect/z121_highwayman_flaws) && z121_highwayman_armor_allowed(user)) ? 1.3 : 1)
			var/haha = user.used_intent.blade_class
			var/armor = run_armor_check(null, haha, armor_penetration = I.armor_penetration, damage = newforce, used_weapon = I)
			var/nodmg = FALSE
			next_attack_msg.Cut()
			if(armor > 0)
				nodmg = TRUE
				next_attack_msg += " <span class='warning'>Armor stops the damage.</span>"
			apply_damage(newforce, I.damtype, hitlim, armor)
			I.z121_highwayman_landed(user, src, user.zone_selected)
			I.remove_bintegrity(1)
			if(I.damtype == BRUTE && !nodmg)
				if(HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
					if(I.is_silver && HAS_TRAIT(src, TRAIT_SILVER_WEAK))
						newforce *= SILVER_SIMPLEMOB_DAM_MULT
					simple_woundcritroll(user.used_intent.blade_class, newforce, user, hitlim)
				if(newforce > 5)
					if(haha != BCLASS_BLUNT)
						I.add_mob_blood(src)
						var/turf/location = get_turf(src)
						add_splatter_floor(location)
						add_splatter_wall(location, force = newforce)
						if(get_dist(user, src) <= 1)
							user.add_mob_blood(src)
				if(newforce > 15)
					if(haha == BCLASS_BLUNT)
						I.add_mob_blood(src)
						var/turf/location = get_turf(src)
						add_splatter_floor(location)
						add_splatter_wall(location, force = newforce)
						if(get_dist(user, src) <= 1)
							user.add_mob_blood(src)
		send_item_attack_message(I, user, hitlim)
		next_attack_msg.Cut()
		if(I.force_dynamic)
			return TRUE
		I.do_special_attack_effect(user, null, null, src, null)

/mob/living/carbon/human/attempt_parry(datum/intent/intenty, mob/living/attacker)
	if(!has_status_effect(/datum/status_effect/z121_highwayman_flaws) || !z121_highwayman_armor_allowed(src))
		return ..()
	if(!intenty.parriable_intent)
		return FALSE
	if(HAS_TRAIT(src, TRAIT_CHUNKYFINGERS) || HAS_TRAIT(src, TRAIT_NODEF) || !mob_can_parry)
		return FALSE
	if(pulledby || pulling)
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/exposed) || has_status_effect(/datum/status_effect/debuff/vulnerable) || has_status_effect(/datum/status_effect/debuff/riposted))
		return FALSE
	if(!can_see_cone(attacker))
		return FALSE
	if(!COOLDOWN_FINISHED(src, last_parry))
		if(!istype(rmb_intent, /datum/rmb_intent/riposte))
			return FALSE
	COOLDOWN_START(src, last_parry, setparrytime)

	var/prob2defend = attacker.mind ? 0 : attacker.defprob
	if(m_intent == MOVE_INTENT_RUN)
		prob2defend = max(prob2defend - 15, 0)

	var/stamina_drained = BASE_PARRY_STAMINA_DRAIN
	var/obj/item/mainhand = get_active_held_item()
	var/mainhand_defense = 0
	var/obj/item/offhand = get_inactive_held_item()
	var/offhand_defense = 0

	var/weapon_parry = FALSE
	var/highest_defense = 0
	var/obj/item/used_weapon = mainhand

	if(istype(offhand, /obj/item/rogueweapon/shield/buckler))
		var/obj/item/rogueweapon/shield/buckler/blocking_buckler = offhand
		blocking_buckler.bucklerskill(src)
	if(istype(mainhand, /obj/item/rogueweapon/shield/buckler))
		var/obj/item/rogueweapon/shield/buckler/blocking_buckler = mainhand
		blocking_buckler.bucklerskill(src)

	if(mainhand?.can_parry)
		mainhand_defense += (get_skill_level(mainhand.associated_skill) * 20)
		mainhand_defense += (mainhand.wdefense_dynamic * 10)
	if(offhand?.can_parry)
		offhand_defense += (get_skill_level(offhand.associated_skill) * 20)
		offhand_defense += (offhand.wdefense_dynamic * 10)

	if(mainhand_defense >= offhand_defense)
		highest_defense += mainhand_defense
	else
		used_weapon = offhand
		highest_defense += offhand_defense

	var/defender_skill = 0
	var/attacker_skill = 0
	var/obj/item/clothing/wrists/roguetown/bracers/unarmed_bracers

	if(highest_defense <= (get_skill_level(/datum/skill/combat/unarmed) * 20))
		defender_skill = get_skill_level(/datum/skill/combat/unarmed)
		var/obj/B = get_item_by_slot(SLOT_WRISTS)
		if(istype(B, /obj/item/clothing/wrists/roguetown/bracers))
			prob2defend += (defender_skill * 35)
			unarmed_bracers = B
		else
			prob2defend += (defender_skill * 10)
		weapon_parry = FALSE
	else
		if(used_weapon)
			defender_skill = get_skill_level(used_weapon.associated_skill)
		else
			defender_skill = get_skill_level(/datum/skill/combat/unarmed)
		prob2defend += highest_defense
		weapon_parry = TRUE

	if(intenty.masteritem)
		attacker_skill = attacker.get_skill_level(intenty.masteritem.associated_skill)

		if(intenty.sharpness_penalty)
			intenty.masteritem.remove_bintegrity(intenty.sharpness_penalty)

		prob2defend -= (attacker_skill * 20)
		if((intenty.masteritem.wbalance == WBALANCE_SWIFT) && (attacker.STASPD > STASPD))
			var/spdmod = ((attacker.STASPD - STASPD) * 10)
			var/permod = ((STAPER - attacker.STAPER) * 10)
			var/intmod = ((STAINT - attacker.STAINT) * 3)
			if(mind)
				if(permod > 0)
					spdmod -= permod
				if(intmod > 0)
					spdmod -= intmod
			var/finalmod = spdmod
			if(mind)
				finalmod = clamp(spdmod, 0, 30)
			prob2defend -= finalmod
	else
		attacker_skill = attacker.get_skill_level(/datum/skill/combat/unarmed)
		prob2defend -= (attacker_skill * 20)

	if(HAS_TRAIT(src, TRAIT_GUIDANCE))
		prob2defend += 20

	if(HAS_TRAIT(attacker, TRAIT_GUIDANCE))
		prob2defend -= 20

	if(HAS_TRAIT(attacker, TRAIT_CURSE_RAVOX))
		prob2defend -= 40

	var/datum/status_effect/debuff/magical_blindness/magic_blind = src.has_status_effect(/datum/status_effect/debuff/magical_blindness)
	if (magic_blind)
		prob2defend -= magic_blind.effect_strength * 5

	if(ishuman(src))
		var/mob/living/carbon/human/oldie = src
		if(oldie.age == AGE_OLD && !HAS_TRAIT(oldie, TRAIT_MAGEARMOR))
			prob2defend += 20

	if(!(mobility_flags & MOBILITY_STAND))
		prob2defend *= 0.65

	if(HAS_TRAIT(src, TRAIT_SENTINELOFWITS))
		if(ishuman(src))
			var/mob/living/carbon/human/SH = src
			var/sentinel = SH.calculate_sentinel_bonus()
			prob2defend += sentinel

	if(HAS_TRAIT(attacker, TRAIT_ARMOUR_LIKED))
		if(HAS_TRAIT(attacker, TRAIT_FENCERDEXTERITY))
			prob2defend -= 5

	prob2defend = clamp(prob2defend * 1.3, 5, 90)
	if(HAS_TRAIT(attacker, TRAIT_HARDSHELL) && client)
		prob2defend = clamp(prob2defend, 5, 70)
	if(!check_armor_skill())
		prob2defend = clamp(prob2defend, 5, 75)
		stamina_drained = stamina_drained + 5

	var/defender_dualw
	var/extradefroll

	if(HAS_TRAIT(src, TRAIT_DUALWIELDER) && (istype(offhand, mainhand) || istype(mainhand, offhand)))
		extradefroll = prob(prob2defend)
		defender_dualw = TRUE

	if(client?.prefs.showrolls)
		var/text = "Roll to parry... [prob2defend]%"
		if(defender_dualw)
			text += " Twice! Disadvantage! ([(prob2defend / 100) * (prob2defend / 100) * 100]%)"
		to_chat(src, span_info("[text]"))

	var/parry_status = FALSE
	if(defender_dualw)
		if(prob(prob2defend) && extradefroll)
			parry_status = TRUE
	else
		if(prob(prob2defend))
			parry_status = TRUE

	if(parry_status)
		if(intenty.masteritem)
			if(intenty.masteritem.wbalance < WBALANCE_NORMAL && attacker.STASTR > STASTR)
				stamina_drained = stamina_drained + ( intenty.masteritem.wbalance * ((attacker.STASTR - STASTR) * (-2)) )
	else
		to_chat(src, span_warning("The enemy defeated my parry!"))
		if(HAS_TRAIT(src, TRAIT_MAGEARMOR))
			if(magearmor == 0)
				magearmor = 1
				apply_status_effect(/datum/status_effect/buff/magearmor)
				to_chat(src, span_boldwarning("My mage armor absorbs the hit and dissipates!"))
				return TRUE
			else
				return FALSE
		if(HAS_TRAIT(src, TRAIT_SCALEARMOR))
			if(scalearmor == 0)
				scalearmor = 1
				apply_status_effect(/datum/status_effect/buff/scalearmor)
				to_chat(src, span_boldwarning("My scales absorb the hit and dissipate the force!"))
				return TRUE
			else
				return FALSE
		else
			return FALSE

	stamina_drained = max(stamina_drained, 5)

	var/exp_multi = 1

	if(!attacker.mind)
		exp_multi = exp_multi/2
	if(istype(attacker.rmb_intent, /datum/rmb_intent/weak))
		exp_multi = exp_multi/2

	var/obj/item/AB = intenty.masteritem
	var/attacker_skill_type

	if(AB)
		attacker_skill_type = AB.associated_skill
	else
		attacker_skill_type = /datum/skill/combat/unarmed

	if(weapon_parry == TRUE)
		if(!do_parry(used_weapon, stamina_drained, attacker))
			return FALSE

		if(ispath(attacker_skill_type, /datum/skill/combat) && ispath(used_weapon.associated_skill, /datum/skill/combat))
			if ((mobility_flags & MOBILITY_STAND))
				var/skill_target = attacker_skill
				if(!HAS_TRAIT(attacker, TRAIT_GOODTRAINER))
					skill_target -= SKILL_LEVEL_NOVICE
				if(HAS_TRAIT(attacker, TRAIT_BADTRAINER))
					skill_target -= SKILL_LEVEL_NOVICE
				if (can_train_combat_skill(src, used_weapon.associated_skill, skill_target))
					mind.add_sleep_experience(used_weapon.associated_skill, max(round(STAINT*exp_multi), 0), FALSE)

			if(attacker.mind)
				if ((mobility_flags & MOBILITY_STAND))
					var/skill_target = defender_skill
					if(!HAS_TRAIT(src, TRAIT_GOODTRAINER))
						skill_target -= SKILL_LEVEL_NOVICE
					if(HAS_TRAIT(attacker, TRAIT_BADTRAINER))
						skill_target -= SKILL_LEVEL_NOVICE
					if (can_train_combat_skill(attacker, attacker_skill_type, skill_target))
						attacker.mind.add_sleep_experience(attacker_skill_type, max(round(STAINT*exp_multi), 0), FALSE)

		if(prob(66) && AB)
			if((used_weapon.flags_1 & CONDUCT_1) && (AB.flags_1 & CONDUCT_1))
				fullscreen_redflash("whiteflash")
				attacker.fullscreen_redflash("whiteflash")
				var/datum/effect_system/spark_spread/S = new()
				var/turf/front = get_step(src, dir)
				S.set_up(1, 1, front)
				S.start()
			else
				flash_fullscreen("blackflash2")
		else
			flash_fullscreen("blackflash2")

		var/dam2take = round((get_complex_damage(AB,attacker,used_weapon.blade_dulling)/2),1)
		if(dam2take)
			var/intdam = used_weapon.max_blade_int ? INTEG_PARRY_DECAY : INTEG_PARRY_DECAY_NOSHARP
			var/sharp_loss = SHARPNESS_ONHIT_DECAY
			if(used_weapon == offhand)
				intdam = INTEG_PARRY_DECAY_NOSHARP
			if(istype(attacker.rmb_intent, /datum/rmb_intent/strong))
				sharp_loss += STRONG_SHP_BONUS
				intdam += STRONG_INTG_BONUS
			used_weapon.take_damage(intdam, BRUTE, used_weapon.d_type)
			used_weapon.remove_bintegrity(sharp_loss, attacker)

		if(mind && attacker.mind && HAS_TRAIT(src, TRAIT_COMBAT_AWARE))
			var/text = "[bodyzone2readablezone(attacker.zone_selected)]..."
			if(HAS_TRAIT(attacker, TRAIT_DECEIVING_MEEKNESS))
				if(prob(10))
					text = "<i>Somewhere...</i>"
					attacker.balloon_alert(src, text)
			else
				attacker.balloon_alert(src, text)
		return TRUE

	if(weapon_parry == FALSE)
		if(!do_unarmed_parry(stamina_drained, attacker))
			testing("failparry")
			return FALSE

		if(ispath(attacker_skill_type, /datum/skill/combat))
			if((mobility_flags & MOBILITY_STAND))
				var/skill_target = attacker_skill
				if(!HAS_TRAIT(attacker, TRAIT_GOODTRAINER))
					skill_target -= SKILL_LEVEL_NOVICE
				if(HAS_TRAIT(attacker, TRAIT_BADTRAINER))
					skill_target -= SKILL_LEVEL_NOVICE
				if(can_train_combat_skill(src, /datum/skill/combat/unarmed, skill_target))
					mind?.add_sleep_experience(/datum/skill/combat/unarmed, max(round(STAINT*exp_multi), 0), FALSE)

		if(unarmed_bracers)
			unarmed_bracers.take_damage(INTEG_PARRY_DECAY_NOSHARP, "slash", armor_penetration = 100)
		flash_fullscreen("blackflash2")
		return TRUE

/mob/living/carbon/human/do_dodge(mob/living/attacker, turf/turfy)
	if(!has_status_effect(/datum/status_effect/z121_highwayman_counter) || !z121_highwayman_armor_allowed(src))
		return ..()
	if(dodge_sanity)
		return FALSE
	if(stamina >= max_stamina)
		return FALSE
	var/drained = 10
	var/drained_npc = 5
	var/obj/item/attacking_item = attacker?.used_intent?.masteritem

	var/mob/living/carbon/human/human_dodger
	if(ishuman(src))
		human_dodger = src

	var/prob2defend = attacker.defprob
	if(check_dodge_skill())
		prob2defend += (STASPD * 15)
	else
		prob2defend += (STASPD * 10)
	prob2defend -= (attacker.STASPD * 10)

	if(attacking_item)
		if(attacking_item.wbalance == WBALANCE_SWIFT && attacker.STASPD > STASPD)
			prob2defend = prob2defend - ( attacking_item.wbalance * ((attacker.STASPD - STASPD) * 10) )
		if(attacking_item.wbalance == WBALANCE_HEAVY && STASPD > attacker.STASPD)
			prob2defend = prob2defend + ( attacking_item.wbalance * ((attacker.STASPD - STASPD) * 10) )
		prob2defend = prob2defend - (attacker.get_skill_level(attacking_item.associated_skill) * 10)

	if(!human_dodger)
		prob2defend = clamp(prob2defend + 20, 5, 90)
		if(client?.prefs.showrolls)
			to_chat(src, span_info("Roll to dodge... [prob2defend]%"))
		if(!prob(prob2defend))
			return FALSE

	if(human_dodger)
		if(!human_dodger?.check_armor_skill() || human_dodger?.legcuffed)
			human_dodger.Knockdown(1)
			human_dodger.drop_all_held_items()
			return FALSE
		if(attacking_item)
			if(!attacking_item.associated_skill)
				prob2defend = prob2defend + 10
			else
				prob2defend = prob2defend + (human_dodger.get_skill_level(attacking_item.associated_skill) * 10)
		else
			if(attacker?.used_intent?.unarmed)
				prob2defend = prob2defend - (attacker.get_skill_level(/datum/skill/combat/unarmed) * 10)
				prob2defend = prob2defend + (human_dodger.get_skill_level(/datum/skill/combat/unarmed) * 10)

		if(HAS_TRAIT(src, TRAIT_GUIDANCE))
			prob2defend += 20

		if(HAS_TRAIT(attacker, TRAIT_GUIDANCE))
			prob2defend -= 20

		if(HAS_TRAIT(attacker, TRAIT_CURSE_RAVOX))
			prob2defend -= 40

		var/datum/status_effect/debuff/magical_blindness/magic_blind = human_dodger.has_status_effect(/datum/status_effect/debuff/magical_blindness)
		if (magic_blind)
			prob2defend -= magic_blind.effect_strength * 5

		if(!(mobility_flags & MOBILITY_STAND))
			prob2defend *= 0.25

		if(HAS_TRAIT(human_dodger, TRAIT_SENTINELOFWITS))
			var/sentinel = human_dodger.calculate_sentinel_bonus()
			prob2defend += sentinel

		if(HAS_TRAIT(attacker, TRAIT_ARMOUR_LIKED))
			if(HAS_TRAIT(attacker, TRAIT_FENCERDEXTERITY))
				prob2defend -= 10
		prob2defend = clamp(prob2defend + 20, 5, 90)

		var/attacker_dualw
		var/defender_dualw
		var/extraattroll
		var/extradefroll
		var/mainhand = get_active_held_item()
		var/offhand	= get_inactive_held_item()

		if(mainhand && offhand)
			if(HAS_TRAIT(src, TRAIT_DUALWIELDER) && istype(offhand, mainhand))
				extradefroll = prob(prob2defend)
				defender_dualw = TRUE

		var/obj/item/mainh = attacker.get_active_held_item()
		var/obj/item/offh = attacker.get_inactive_held_item()
		if(mainh && offh && HAS_TRAIT(attacker, TRAIT_DUALWIELDER))
			if(istype(mainh, offh))
				extraattroll = prob(prob2defend)
				attacker_dualw = TRUE

		var/attacker_feedback
		if(attacker.client?.prefs.showrolls && (attacker_dualw || defender_dualw))
			attacker_feedback = "Attacking with advantage. ([100 - ((prob2defend / 100) * (prob2defend / 100) * 100)]%)"

		if(client?.prefs.showrolls)
			var/text = "Roll to dodge... [prob2defend]%"
			if((defender_dualw || attacker_dualw))
				if(defender_dualw && attacker_dualw)
					text += " Our dual wielding cancels out!"
				else
					text += " Twice! Disadvantage! ([(prob2defend / 100) * (prob2defend / 100) * 100]%)"
			to_chat(src, span_info("[text]"))

		var/dodge_status = FALSE
		if((!defender_dualw && !attacker_dualw) || (defender_dualw && attacker_dualw))
			if(attacker_feedback)
				attacker_feedback = "Advantage cancelled out!"
			if(prob(prob2defend))
				dodge_status = TRUE
		else if(attacker_dualw)
			if(prob(prob2defend) && extraattroll)
				dodge_status = TRUE
		else if(defender_dualw)
			if(prob(prob2defend) && extradefroll)
				dodge_status = TRUE

		if(attacker_feedback)
			to_chat(attacker, span_info("[attacker_feedback]"))

		if(!dodge_status)
			return FALSE
		if(!attacker?.mind)
			drained = drained_npc
		if(!human_dodger.stamina_add(max(drained,5)))
			to_chat(src, span_warning("I'm too tired to dodge!"))
			return FALSE

	if(client)
		log_combat(src, attacker, "dodged", null, defense_log_note(attacker))
	dodge_sanity = TRUE
	playsound(src, 'sound/combat/dodge.ogg', 100, FALSE)

	if(drained > 0)
		visible_message(span_warning("<b>[src]</b> dodges [attacker]'s attack!"))
	else
		visible_message(span_warning("<b>[src]</b> easily dodges [attacker]'s attack!"))
	if(get_dist(src, attacker) <= attacker.used_intent?.reach)
		var/probclip = 50
		var/obj/item/IS = get_active_held_item()
		var/obj/item/IU = attacker.get_active_held_item()
		if(IS)
			if(IS.wlength > WLENGTH_NORMAL)
				probclip += (IS.wlength - WLENGTH_NORMAL) * 10
			else
				probclip -= (WLENGTH_NORMAL - IS.wlength) * 10
		var/dist = (attacker.used_intent?.reach - get_dist(src, attacker)) - 1
		if(dist > 0)
			probclip += dist * 10
		if(STALUC != attacker.STALUC)
			var/lucmod = STALUC - attacker.STALUC
			probclip += lucmod * 10
		if(prob(probclip) && IS && IU)
			var/intdam = IS.max_blade_int ? INTEG_PARRY_DECAY : INTEG_PARRY_DECAY_NOSHARP
			var/sharp_loss = SHARPNESS_ONHIT_DECAY
			if(istype(attacker.rmb_intent, /datum/rmb_intent/strong))
				sharp_loss += STRONG_SHP_BONUS
				intdam += STRONG_INTG_BONUS

			IS.take_damage(intdam, BRUTE, IU.d_type)
			IS.remove_bintegrity(sharp_loss, src)

			attacker.visible_message(span_warning("<b>[attacker]</b> clips [src]'s weapon!"))
			playsound(attacker, 'sound/misc/weapon_clip.ogg', 100)

	if(mind && attacker.mind && HAS_TRAIT(src, TRAIT_COMBAT_AWARE))
		var/text = "[bodyzone2readablezone(attacker.zone_selected)]..."
		if(HAS_TRAIT(attacker, TRAIT_DECEIVING_MEEKNESS))
			if(prob(10))
				text = "<i>Can't tell...</i>"
				attacker.balloon_alert(src, text)
		else
			attacker.balloon_alert(src, text)
	dodge_sanity = FALSE
	return TRUE

// 徒手流程保持原样，仅在前摇完成后为反击标记本次伤害来源。
/datum/species/proc/z121_highwayman_counter_harm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("I don't want to harm [target]!"))
		return FALSE
	if(target.check_block())
		target.visible_message(span_warning("[target] blocks [user]'s attack!"), \
						span_danger("I block [user]'s attack!"), span_hear("I hear a swoosh!"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_warning("My attack at [target] was blocked!"))
		return FALSE
	if(attacker_style && attacker_style.harm_act(user,target))
		return TRUE
	else

		var/cached_intent = user.used_intent
		sleep(user.used_intent.swingdelay)
		if(user.a_intent != cached_intent)
			return FALSE
		if(!target.Adjacent(user))
			return
		if(user.incapacitated())
			return

		var/damage = user.get_punch_dmg()
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			damage += (damage * STRONG_STANCE_DMG_BONUS)
		if(target.has_status_effect(/datum/status_effect/buff/clash) && target.get_active_held_item() && ishuman(user))
			var/obj/item/IM = target.get_active_held_item()
			target.process_clash(user, IM)
			return

		if(user.mob_biotypes & MOB_UNDEAD)
			if(target.has_status_effect(/datum/status_effect/buff/necras_vow))
				if(isnull(user.mind))
					user.adjust_fire_stacks(5)
					user.ignite_mob()
				else
					if(prob(30))
						to_chat(user, span_warning("The foul blessing of the Undermaiden hurts us!"))
				user.adjust_blurriness(2)
				user.adjustBruteLoss(rand(5, 10))
				user.apply_status_effect(/datum/status_effect/churned, target)

		if(user.mob_biotypes & MOB_UNDEAD)
			if(target.has_status_effect(/datum/status_effect/buff/inviolability))
				if(isnull(user.mind))
					user.adjust_fire_stacks(1)
					user.ignite_mob()
				else
					if(prob(30))
						to_chat(user, span_warning("Some matter of force harms us!"))
				user.adjust_blurriness(2)
				user.adjustBruteLoss(rand(10, 15))

		var/selzone = melee_accuracy_check(user.zone_selected, user, target, /datum/skill/combat/unarmed, user.used_intent)

		var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(selzone))

		if(!affecting)
			to_chat(user, span_warning("Unfortunately, there's nothing there."))
			return 0

		if(!target.lying_attack_check(user))
			return 0

		var/datum/status_effect/z121_highwayman_counter/counter = target.has_status_effect(/datum/status_effect/z121_highwayman_counter)
		counter?.begin_attack(user)
		var/armor_block = target.run_armor_check(selzone, "blunt", armor_penetration = BLUNT_DEFAULT_PENFACTOR, blade_dulling = user.used_intent.blade_class, damage = damage, intdamfactor = user.used_intent?.intent_intdamage_factor)

		target.lastattacker = user.real_name
		if(target.mind)
			target.mind.attackedme[user.real_name] = world.time
		target.lastattackerckey = user.ckey
		target.lastattacker_weakref = WEAKREF(user)
		user.dna.species.spec_unarmedattacked(user, target)

		target.next_attack_msg.Cut()

		var/nodmg = FALSE

		if(!target.apply_damage(damage, user.dna.species.attack_type, affecting, armor_block))
			nodmg = TRUE
			target.next_attack_msg += " <span class='warning'>Armor stops the damage.</span>"
		else
			affecting.bodypart_attacked_by(user.used_intent.blade_class, damage, user, selzone, crit_message = TRUE)
			SEND_SIGNAL(target, COMSIG_ATOM_ATTACK_HAND, user)
			if(affecting.body_zone == BODY_ZONE_HEAD)
				SEND_SIGNAL(user, COMSIG_HEAD_PUNCHED, target)
		log_combat(user, target, "punched", null, "(AIMED: [uppertext(parse_zone(user.zone_selected))])")
		if(ishuman(user) && user.mind)
			var/text = "[bodyzone2readablezone(selzone)]..."
			user.filtered_balloon_alert(TRAIT_COMBAT_AWARE, text)

		if(!nodmg)
			if(user.limb_destroyer)
				var/easy_dismember = HAS_TRAIT(target, TRAIT_EASYDISMEMBER) || affecting.rotted
				var/probability = damage / (2 - easy_dismember)
				if(HAS_TRAIT(target, TRAIT_HARDDISMEMBER) && !easy_dismember)
					probability = min(probability, 5)
				if(prob(probability) && affecting.dismember())
					playsound(get_turf(target), "desecration", 80, TRUE)

		var/message_verb = "punched"
		if(user.used_intent)
			message_verb = "[pick(user.used_intent.attack_verb)]"
		var/message_hit_area = ""
		if(selzone)
			message_hit_area = " in the [span_userdanger(parse_zone(selzone, affecting))]"
		var/attack_message = "[user] [message_verb] [target][message_hit_area]!"
		var/attack_message_local = "[user] [message_verb] me[message_hit_area]!"
		target.visible_message(span_danger("[attack_message][target.next_attack_msg.Join()]"),\
			span_danger("[attack_message_local][target.next_attack_msg.Join()]"), null, COMBAT_MESSAGE_RANGE)
		target.next_attack_msg.Cut()

		target.retaliate(user)

		if(!(target.mobility_flags & MOBILITY_STAND))
			target.forcesay(GLOB.hit_appends)
		if(!nodmg)
			playsound(target.loc, user.used_intent.hitsound, 100, FALSE)
