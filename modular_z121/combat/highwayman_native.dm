// 局部适配主线武器攻击、部位伤害、闪避及招架流程。

// 普攻保留原有前摇、命中率、穿甲、伤口及耐久处理；仅职业强化攻击调用。

// 防御适配仅在对应状态存在时启用，未生效时调用父类。

/obj/item/proc/z121_highwayman_attack(mob/living/M, mob/living/user)
	var/override_status
	//Item signal for override
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK, M, user) & COMPONENT_ITEM_NO_ATTACK)
		return FALSE

	//Receiver signal for overrides
	var/_receiver_signal = SEND_SIGNAL(M, COMSIG_MOB_ITEM_BEING_ATTACKED, M, user, src)
	if(_receiver_signal & COMPONENT_ITEM_NO_ATTACK)
		return FALSE
	else if(_receiver_signal & COMPONENT_ITEM_NO_DEFENSE)
		override_status = ATTACK_OVERRIDE_NODEFENSE

	//Attacker signal generic + override for no defense
	var/_attacker_signal = SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK, M, user, src)
	if(_attacker_signal & COMPONENT_ITEM_NO_ATTACK)
		return FALSE
	else if(_attacker_signal & COMPONENT_ITEM_NO_DEFENSE)
		override_status = ATTACK_OVERRIDE_NODEFENSE


	if(item_flags & NOBLUDGEON)
		return FALSE

	if(force && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("我不想伤害其他生灵！"))
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
			if(user.used_intent.no_attack) //BYE!!!
				log_combat(user, M, "used a non-damaging intent on", src.name, "(INTENT: [uppertext(user.used_intent.name)])", log_seen = FALSE)
				add_fingerprint(user)
				return
	else
		return

//	if(force)
//		user.emote("attackgrunt")
	user.mob_timers[MT_SNEAKATTACK] = world.time
	var/swingdelay = user.used_intent?.swingdelay
	var/_swingdelay_mod = SEND_SIGNAL(src, COMSIG_LIVING_SWINGDELAY_MOD)
	if(_swingdelay_mod)
		swingdelay += _swingdelay_mod

	var/datum/intent/cached_intent = user.used_intent
	if(swingdelay && cached_intent.swingdelay_type)
		if(user.add_swingdelay(cached_intent))
			sleep(cached_intent.swingdelay)

	// Getting struck w/ /disrupt swingdelay type sets our swing_state to false. 
	// If we had the effect, but not the bool, we were interrupted. (Or something else went wrong.)
	if(user.is_swinging() && !user.swing_state)
		return

	user.swing_state = FALSE
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
	// Release drain on attacks besides unarmed attacks/grabs is 1, so it'll just be whatever the penalty is + 1.
	// Unarmed attacks are the only ones right now that have differing releasedrain, see unarmed attacks for their calc.
	user.stamina_add(user.used_intent.releasedrain + user.get_swifstrong_stam_penalty())
	var/bad_guard = FALSE
	//We have Guard / Clash active, and are hitting someone who doesn't. Cheesing a 'free' hit with a defensive buff is a no-no. You get punished.
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
			H.bad_guard(span_suicide("我切换架势太快，体力被耗尽了！"), cheesy = TRUE)

	if(user.mob_biotypes & MOB_UNDEAD)
		if(M.has_status_effect(/datum/status_effect/buff/necras_vow))
			if(isnull(user.mind))
				user.adjust_fire_stacks(5)
				user.ignite_mob()
			else
				if(prob(30))
					to_chat(M, span_warning("冥下侍女的邪恶祝福伤害了我们！"))
			user.adjust_blurriness(3)
			user.adjustBruteLoss(5)
			user.apply_status_effect(/datum/status_effect/churned, M)
		//This and necra's vow need a better way of handling this. But I'm too lazy to do that.
		if(M.has_status_effect(/datum/status_effect/buff/inviolability))
			if(isnull(user.mind))
				user.adjust_fire_stacks(1)
				user.ignite_mob()
			else
				if(prob(30))
					to_chat(M, span_warning("某种力量伤害了我们！"))
			user.adjust_blurriness(2)
			user.adjustBruteLoss(rand(10, 15))

	//Niche signal for post-swingdelay attacks when we want to care about those.
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
			M.visible_message(span_notice("[user]缴了[M]的械！"), \
							span_boldwarning("我被[user]缴械了！"))
			return

	if(user.zone_selected == BODY_ZONE_PRECISE_L_INHAND)
		var/offh = 0
		var/obj/item/W = M.held_items[2]
		if(W)
			if(!(M.mobility_flags & MOBILITY_STAND))
				M.throw_item(get_step(M,turn(M.dir, 270)), offhand = offh)
			else
				M.dropItemToGround(W)
			M.visible_message(span_notice("[user]缴了[M]的械！"), \
							span_boldwarning("我被[user]缴械了！"))
			return

	if(z121_highwayman_hit(M, user))
		if(user.used_intent == cached_intent)
			var/tempsound = user.used_intent.hitsound
			if(tempsound)
				playsound(M.loc,  tempsound, 100, FALSE, -1)
			else
				playsound(M.loc,  "nodmg", 100, FALSE, -1)

	log_combat(user, M, "攻击", src.name, "(INTENT: [uppertext(user.used_intent.name)]) (DAMTYPE: [uppertext(damtype)]) (AIMED: [uppertext(parse_zone(user.zone_selected))])")

	execute_cleave(user, get_turf(M), M)

	add_fingerprint(user)

//the equivalent of the standard version of attack() but for object targets.

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
		to_chat(user, span_warning("可惜，那里什么也没有。"))
		return 0

	SEND_SIGNAL(I, COMSIG_ITEM_ATTACK_ZONE, src, user, affecting)

	SSblackbox.record_feedback("nested tally", "item_used_for_combat", 1, list("[I.force]", "[I.type]"))
	SSblackbox.record_feedback("tally", "zone_targeted", 1, useder)

	if(I.force)
		retaliate(user)

	return dna.species.z121_highwayman_spec_attacked_by(I, user, affecting, used_intent, src, useder)

/datum/species/proc/z121_highwayman_spec_attacked_by(obj/item/I, mob/living/user, obj/item/bodypart/affecting, intent, mob/living/carbon/human/H, selzone)
	// Allows you to put in item-specific reactions based on species
	if(user != H && !I.z121_highwayman_cut_ready(user))
		if(H.check_shields(I, I.force, "[I.name]", MELEE_ATTACK, I.armor_penetration))
			return 0
	if(!I.z121_highwayman_cut_ready(user) && H.check_block())
		H.visible_message(span_warning("[H]挡住了[I]！"), \
						span_danger("我挡住了[I]！"))
		return 0

	SEND_SIGNAL(H, COMSIG_SPECIES_ATTACKED_BY)

	var/hit_area

	selzone = melee_accuracy_check(user.zone_selected, user, H, I.associated_skill, user.used_intent, I)
	affecting = H.get_bodypart(check_zone(selzone))

	if(!affecting)
		return
	
	var/datum/status_effect/buff/clash/limbguard/LG = H.has_status_effect(/datum/status_effect/buff/clash/limbguard)
	if(LG)
		if(LG.protected_zone == selzone && LG.is_active)	// We "missed" into limbguard's protected zone.
			LG.process_attack(H, H, user, I)
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

	// Penetration tier from the intent (0-5). Blunt/fire/acid use DR instead, pen is irrelevant.
	var/pen = user.used_intent?.penfactor ? user.used_intent.penfactor : PEN_NONE

//	var/armor_block = H.run_armor_check(affecting, "I.d_type", span_notice("My armor has protected my [hit_area]!"), span_warning("My armor has softened a hit to my [hit_area]!"),pen)

	var/Iforce = get_complex_damage(I, user) * ((user.has_status_effect(/datum/status_effect/z121_highwayman_flaws) && z121_highwayman_armor_allowed(user)) ? 1.3 : 1) //to avoid runtimes on the forcesay checks at the bottom. Some items might delete themselves if you drop them. (stunning yourself, ninja swords)
	if(!user.used_intent?.allow_offhand)
		if(user.get_num_arms(FALSE) < 2 || user.get_inactive_held_item())
			Iforce = 0
	var/bladec = user.used_intent.blade_class

	// Effective range check. Attacking a prone target doesn't apply a penalty at any range.
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
			pen = PEN_NONE
			Iforce *= 0.5

	var/higher_intfactor = max(user.used_intent.masteritem?.intdamage_factor, user.used_intent.intent_intdamage_factor)
	var/lowest_intfactor = min(user.used_intent.masteritem?.intdamage_factor, user.used_intent.intent_intdamage_factor)
	var/used_intfactor = 1
	if(lowest_intfactor < 1)	//Our intfactor multiplier can be either 0 to 1, or 1 to whatever.
		used_intfactor = lowest_intfactor
	if(higher_intfactor > 1)	//Make sure to keep your weapon and intent intfactors consistent to avoid problems here!
		used_intfactor = higher_intfactor

	if(ishuman(user) && user != H)
		var/text = "[bodyzone2readablezone(selzone)]..."
		if(HAS_TRAIT(user, TRAIT_DECEIVING_MEEKNESS))
			if(prob(10))
				text = "<i>我看不出来……</i>"
			else
				text = null
		if(text)
			user.filtered_balloon_alert(TRAIT_COMBAT_AWARE, text, show_self = FALSE)

	if(H.client?.prefs.floating_text_toggles & HITZONE_TEXT)
		H.balloon_alert(H, "[bodyzone2readablezone(selzone)]...") 
		
	var/pen_info_check = get_pen_info(H, user, H.get_best_worn_armor(def_zone, int.item_d_type), def_zone, int.item_d_type, int.penfactor, I)
	var/armor_block = H.run_armor_check(selzone, I.d_type, "", "",pen, damage = Iforce, blade_dulling=bladec, intdamfactor = used_intfactor, used_weapon = I, pen_info = pen_info_check)

	var/nodmg = FALSE

	if(Iforce)
		H.retaliate(user)
		var/post_weakness_dmg
		var/post_reduction_dmg

		var/weakness = H.check_weakness(I, user)
		post_weakness_dmg = Iforce * ((weakness == 0) ? 1 : weakness)
		H.next_attack_msg.Cut()
		if(!apply_damage(post_weakness_dmg, I.damtype, def_zone, armor_block, H))
			nodmg = TRUE
			H.next_attack_msg += VISMSG_ARMOR_BLOCKED
			var/obj/item/clothing/C = H.get_best_worn_armor(def_zone, I.d_type)	//this is kinda relying on the proc returnig the same as run_armor_check did. Clunky!
			var/extra_msg = C.get_armor_integ()
			if(extra_msg)
				H.next_attack_msg += extra_msg
			if(I)
				I.remove_bintegrity(1)
				I.take_damage(1, BRUTE, I.d_type)
			if(user.mind && user.goodluck(4) && user.d_intent == INTENT_DODGE)
				user.changeNext_def(clamp(user.dodgetime - 1, 0, CLICK_CD_DODGE))
				user.changeMaxDodge(1)
				//Blunt chipping, no matter what. Assuming it has damage. This is done after armour damage.
				if(user.used_intent.blunt_chipping)//We won't check for blunt. Just that it's able. For funny reasons.
					var/blunt_chip_block = H.run_armor_check(selzone, "blunt", armor_penetration = 80)//I hate this. So much.
					H.apply_damage(Iforce * user.used_intent.blunt_chip_strength, BRUTE, def_zone, blunt_chip_block)//, spread_damage = TRUE)
					H.next_attack_msg += " <span class='warning'>但冲击力仍然穿透了护甲！</span>"//But sometimes it lies!
		I.z121_highwayman_landed(user, H, selzone)
		if(!nodmg)
			post_reduction_dmg = (post_weakness_dmg - armor_block)
//			var/has_vuln_or_exposed = (H.has_status_effect(/datum/status_effect/debuff/exposed) || H.has_status_effect(/datum/status_effect/debuff/vulnerable)) //UNATOMIZABLE CODE FOR THE THE PR THAT WILL FOLLOW
			var/datum/wound/crit_wound = affecting.bodypart_attacked_by(user.used_intent.blade_class, post_reduction_dmg, user, selzone, crit_message = TRUE, weapon = I, pen_info = pen_info_check)
			if(should_embed_weapon(crit_wound, I))
				var/can_impale = TRUE
				if(!affecting)
					can_impale = FALSE
				else if(I.wlength > WLENGTH_SHORT && (affecting.body_zone != BODY_ZONE_CHEST))
					can_impale = FALSE
				if(can_impale && user.Adjacent(H))
					//affecting.add_embedded_object(I, silent = FALSE, crit_message = TRUE)
					H.emote("embed")
					H.Stun(10)
					playsound(H.loc, "genblunt", 100, FALSE, -1)
					user.visible_message(span_notice("[user]将[I]刺入了[H]的[affecting.name]！"), span_notice("我将[I]刺入了[H]的[affecting.name]。"))
					var/list/targets = list(H)
					if(do_after_mob(user,targets, 10, progress = 0, uninterruptible = 1, required_mobility_flags = null))
						affecting.receive_damage(I.embedding.embedded_unsafe_removal_pain_multiplier*I.w_class) //It hurts to rip it out, get surgery you dingus.
						H.emote("paincrit", forced = TRUE)
						playsound(H, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
						user.visible_message(span_notice("[user]从[H]的[affecting.name]中猛地拔出了[I]！"), span_notice("我从[H]的[affecting.name]中猛地拔出了[I]。"))
			I.do_special_attack_effect(user, affecting, intent, H, selzone)
			if(user.mind)
				user.dodgetime = (clamp(user.dodgetime - 2, 0, CLICK_CD_DODGE))
				user.changeMaxDodge(3)
			if(H.mind)
				H.dodgetime = (clamp(H.dodgetime - 8, 0, CLICK_CD_DODGE))	//We reset the dodgetime after getting struck directly in the body.
				H.changeMaxDodge(5)
//		if(H.used_intent.blade_class == BCLASS_BLUNT && I.force >= 15 && affecting.body_zone == "chest")
//			var/turf/target_shove_turf = get_step(H.loc, get_dir(user.loc,H.loc))
//			H.throw_at(target_shove_turf, 1, 1, H, spin = FALSE)

	I.funny_attack_effects(H, user, nodmg)
	H.send_item_attack_message(I, user, selzone, affecting, bladec)

	if(nodmg)
		return FALSE //dont play a sound

	//dismemberment
	var/bloody = 0
	var/probability = I.get_dismemberment_chance(affecting, user, selzone)
	//stopgap fix, this should prevent oathed martyr decaps from ashing the head
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
			I.add_mob_blood(H)	//Make the weapon bloody, not the person.
			user.update_inv_hands()
			if(prob(I.force * 2) || bloody)	//blood spatter!
				bloody = 1
				var/turf/location = H.loc
				var/splatter_dir = get_dir(H, user)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(H.loc, splatter_dir)
				if(istype(location))
					H.add_splatter_floor(location)
					H.add_splatter_wall(location, force = I.force)
				if(get_dist(user, H) <= 1)	//people with TK won't get smeared with blood
					user.add_mob_blood(H)

		switch(hit_area)
			if(BODY_ZONE_HEAD)
//				if(!I.get_sharpness() && armor_block < 50)
//					if(prob(I.force))
//						H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 20)
//						if(H.stat == CONSCIOUS)
//							H.visible_message(span_danger("[H] is knocked senseless!"), span_danger("You're knocked senseless!"))
//							H.confused = max(H.confused, 20)
//							H.adjust_blurriness(10)
//						if(prob(10))
//							H.gain_trauma(/datum/brain_trauma/mild/concussion)
//					else
//						H.adjustOrganLoss(ORGAN_SLOT_BRAIN, I.force * 0.2)

				if(bloody)	//Apply blood
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
//				if(H.stat == CONSCIOUS && !I.get_sharpness() && armor_block < 50)
//					if(prob(I.force))
//						H.visible_message(span_danger("[H] is knocked down!"), span_danger("You're knocked down!"))
//						H.apply_effect(60, EFFECT_KNOCKDOWN, armor_block)

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
			H.forcesay(GLOB.hit_appends)	//forcesay checks stat already.
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
				next_attack_msg += " <span class='warning'>护甲挡住了伤害。</span>"
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
	var/highwayman_bonus = has_status_effect(/datum/status_effect/z121_highwayman_flaws) && z121_highwayman_armor_allowed(src)
	var/glory_bonus = z121_victory_glow_active() ? 5 : 0
	if(!highwayman_bonus && !glory_bonus)
		return ..()
	if(!intenty.parriable_intent) // If the intent is unparriable whatsoever just skip all the math
		return FALSE
	if(HAS_TRAIT(src, TRAIT_CHUNKYFINGERS) || HAS_TRAIT(src, TRAIT_NODEF) || !mob_can_parry || (!highwayman_bonus && !length(held_items)))
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
			prob2defend += (defender_skill * 10)		// no bracers gonna be butts.
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
		if(!HAS_TRAIT(attacker, TRAIT_FENCERDEXTERITY))	// Yet another Frei related clamp
			if(!has_status_effect(/datum/status_effect/buff/weapon_binded))
				if((intenty.masteritem.wbalance == WBALANCE_SWIFT) && (attacker.STASPD > src.STASPD)) //enemy weapon is quick, so get a bonus based on spddiff
					var/spdmod = ((attacker.STASPD - src.STASPD) * 10)
					var/permod = ((src.STAPER - attacker.STAPER) * 5)
					var/intmod = ((src.STAINT - attacker.STAINT) * 3)
					if(mind)
						if(permod > 0)
							spdmod -= permod
						if(intmod > 0)
							spdmod -= intmod
					var/finalmod = spdmod
					if(mind)
						finalmod = clamp(spdmod, 0, 45)
					prob2defend -= finalmod
	else
		attacker_skill = attacker.get_skill_level(/datum/skill/combat/unarmed)
		prob2defend -= (attacker_skill * 20)

	// --- Weapon binding! ---

	if(has_status_effect(/datum/status_effect/buff/weapon_binded))
		prob2defend += 20
	if(!has_status_effect(/datum/status_effect/buff/weapon_binded) && !has_status_effect(/datum/status_effect/debuff/weapon_binded))
		var/mob/living/carbon/human/HL = src
		if(HL.try_bind(used_weapon, attacker))
			return TRUE	//Tentative, might be better if it only increased parry chance on the initial binding rather than a full block.

	// --- Weapon Binding End! ---

	if(HAS_TRAIT(src, TRAIT_GUIDANCE))
		prob2defend += 20

	if(HAS_TRAIT(attacker, TRAIT_GUIDANCE))
		prob2defend -= 20

	if(HAS_TRAIT(attacker, TRAIT_CURSE_RAVOX))
		prob2defend -= 40

	var/datum/status_effect/debuff/magical_blindness/magic_blind = src.has_status_effect(/datum/status_effect/debuff/magical_blindness)
	if (magic_blind)
		prob2defend -= magic_blind.effect_strength * 5 // 5% parry chance loss per level

	if(ishuman(src))
		var/mob/living/carbon/human/oldie = src
		if(oldie.age == AGE_OLD && !HAS_TRAIT(oldie, TRAIT_MAGEARMOR))//Old martial characters get a bonus to parry. Mages do not, they get unique bonuses already for being old.
			prob2defend += 20

	// parrying while knocked down sucks ass
	if(!(mobility_flags & MOBILITY_STAND) && !has_status_effect(/datum/status_effect/buff/weapon_binded))
		prob2defend *= 0.65

	if(HAS_TRAIT(src, TRAIT_SENTINELOFWITS))
		if(ishuman(src))
			var/mob/living/carbon/human/SH = src
			var/sentinel = SH.calculate_sentinel_bonus()
			prob2defend += sentinel

	if(HAS_TRAIT(attacker, TRAIT_ARMOUR_LIKED))
		if(HAS_TRAIT(attacker, TRAIT_FENCERDEXTERITY))
			prob2defend -= 5

	prob2defend = clamp(prob2defend * (highwayman_bonus ? 1.3 : 1) + glory_bonus, 5, 90)
	if(HAS_TRAIT(attacker, TRAIT_HARDSHELL) && client) //Dwarf-merc specific limitation w/ their armor on in pvp
		prob2defend = clamp(prob2defend, 5, 70)
	if(!check_armor_skill())
		prob2defend = clamp(prob2defend, 5, 75) //Caps your max parry to 75 if using armor you're not trained in. Bad dexerity.
		stamina_drained = stamina_drained + 5 //More stamina usage for not being trained in the armor you're using.

	//Dual Wielding
	var/defender_dualw
	var/extradefroll

	//Dual Wielder defense disadvantage
	if(HAS_TRAIT(src, TRAIT_DUALWIELDER) && (istype(offhand, mainhand) || istype(mainhand, offhand)))
		extradefroll = prob(prob2defend)
		defender_dualw = TRUE

	var/text = "Roll to parry... [HAS_TRAIT(attacker, TRAIT_DECEIVING_MEEKNESS) ? "???" : prob2defend]%"
	if(defender_dualw)
		text += " Twice! Disadvantage! [!HAS_TRAIT(attacker, TRAIT_DECEIVING_MEEKNESS) ? "([(prob2defend / 100) * (prob2defend / 100) * 100]%)" : ""]"

	if(has_status_effect(/datum/status_effect/swingdelay/penalty))
		prob2defend -= 50

	var/parry_status = FALSE
	if(defender_dualw)
		if(prob(prob2defend) && extradefroll)
			parry_status = TRUE
	else
		if(prob(prob2defend))
			parry_status = TRUE

	if(parry_status)
		if(!has_status_effect(/datum/status_effect/buff/weapon_binded))
			if(intenty.masteritem)
				if(intenty.masteritem.wbalance < WBALANCE_NORMAL && attacker.STASTR > src.STASTR) //enemy weapon is heavy, so get a bonus scaling on strdiff
					stamina_drained = stamina_drained + ( intenty.masteritem.wbalance * ((attacker.STASTR - src.STASTR) * (-2)) )
	else
		text += span_warning(" The enemy defeated my parry!")
	if(src.client?.prefs.showrolls)
		to_chat(src, span_info("[text]"))

	// Failed parry cutoff here
	if(!parry_status)
		if(HAS_TRAIT(src, TRAIT_MAGEARMOR))
			if(magearmor == 0)
				magearmor = 1
				apply_status_effect(/datum/status_effect/buff/magearmor)
				to_chat(src, span_boldwarning("我的法师护甲吸收了这一击，随之消散！"))
				return TRUE
			else
				return FALSE
		if(HAS_TRAIT(src, TRAIT_SCALEARMOR))
			if(scalearmor == 0)
				scalearmor = 1
				apply_status_effect(/datum/status_effect/buff/scalearmor)
				to_chat(src, span_boldwarning("我的鳞片承受了这一击，化解了冲击！"))
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
		if(!do_parry(used_weapon, stamina_drained, attacker)) //show message
			return FALSE
		//only gain experience if attacker and defender aren't using non-combat skills for their weapons
		if(ispath(attacker_skill_type, /datum/skill/combat) && ispath(used_weapon.associated_skill, /datum/skill/combat))
			if ((mobility_flags & MOBILITY_STAND))
				var/skill_target = attacker_skill
				if(!HAS_TRAIT(attacker, TRAIT_GOODTRAINER))
					skill_target -= SKILL_LEVEL_NOVICE
				if(HAS_TRAIT(attacker, TRAIT_BADTRAINER))
					skill_target -= SKILL_LEVEL_NOVICE
				if (can_train_combat_skill(src, used_weapon.associated_skill, skill_target))
					mind.add_sleep_experience(used_weapon.associated_skill, max(round(STAINT*exp_multi), 0), FALSE)

			//attacker skill gain
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

			// Heavy weapons chew through shields — use higher of demolition_mod or intent intdamage_factor
			if(istype(used_weapon, /obj/item/rogueweapon/shield) && intenty)
				var/shield_mult = max(intenty.demolition_mod, intenty.intent_intdamage_factor)
				intdam *= shield_mult

			if(!has_status_effect(/datum/status_effect/buff/weapon_binded))
				used_weapon.take_damage(intdam, BRUTE, used_weapon.d_type)
				used_weapon.remove_bintegrity(sharp_loss, attacker)
			if(mind)
				dodgetime = CLAMP(dodgetime - 2, 0, CLICK_CD_DODGE)
				changeMaxDodge(2)

		return TRUE

	if(weapon_parry == FALSE)
		if(!do_unarmed_parry(stamina_drained, attacker))
			testing("failparry")
			return FALSE
		//only gain experience if attacker isn't using a non-combat skill for their weapon
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
		if(mind)
			dodgetime = CLAMP(dodgetime - 2, 0, CLICK_CD_DODGE)
			changeMaxDodge(2)
		return TRUE

/mob/living/carbon/human/do_dodge(mob/living/attacker, turf/turfy)
	var/highwayman_bonus = has_status_effect(/datum/status_effect/z121_highwayman_counter) && z121_highwayman_armor_allowed(src)
	var/glory_bonus = z121_victory_glow_active() ? 5 : 0
	if(!highwayman_bonus && !glory_bonus)
		return ..()
	if(dodge_sanity)
		return FALSE
	if(stamina >= max_stamina) // Out of stamina? Out of dodge
		return FALSE
	var/obj/item/IL
	var/ourskill = 0
	var/theirskill = 0
	var/drained = 8
	var/drained_npc = 5
	var/obj/item/attacking_item = attacker?.used_intent?.masteritem

	var/mob/living/carbon/human/human_dodger
	if(ishuman(src))
		human_dodger = src
		IL = human_dodger.get_active_held_item()
		if(IL && IL?.associated_skill)
			ourskill = get_skill_level(IL.associated_skill)
		else
			ourskill = get_skill_level(/datum/skill/combat/unarmed)

	var/prob2defend = attacker.defprob
	var/is_in_cone = can_see_cone(src)
	if(!is_in_cone)
		changeNext_def(CLAMP(dodgetime + 2, 0, CLICK_CD_DODGE))
		changeMaxDodge(-2)
	var/has_trait = human_dodger?.check_dodge_skill()
	if(human_dodger?.check_dodge_skill())
		prob2defend += (STASPD * 15)
	else
		prob2defend += (STASPD * 10)
	prob2defend -= (attacker.STASPD * 10)

	if(attacking_item)
		if(attacking_item.wbalance == WBALANCE_SWIFT && attacker.STASPD > STASPD) //nme weapon is quick, so they get a bonus based on spddiff
			prob2defend = prob2defend - ( attacking_item.wbalance * ((attacker.STASPD - STASPD) * 10) )
		if(attacking_item.wbalance == WBALANCE_HEAVY && STASPD > attacker.STASPD) //nme weapon is slow, so its easier to dodge if we're faster
			prob2defend = prob2defend + ( attacking_item.wbalance * ((attacker.STASPD - STASPD) * 10) )
		prob2defend = prob2defend - (attacker.get_skill_level(attacking_item.associated_skill) * 10)

	if(!human_dodger)
		prob2defend = clamp(prob2defend + (highwayman_bonus ? 20 : 0) + glory_bonus, 5, 90)
		if(client?.prefs.showrolls)
			to_chat(src, span_info("闪避判定……[prob2defend]%"))
		if(!prob(prob2defend))
			return FALSE

	if(human_dodger)
		if(!human_dodger?.check_armor_skill() || human_dodger?.legcuffed)
			human_dodger.Knockdown(1)
			human_dodger.drop_all_held_items()
			return FALSE
		if(attacking_item) //the enemy attacked us with a weapon
			if(!attacking_item.associated_skill) //the enemy weapon doesn't have a skill because its improvised, so penalty to attack
				prob2defend = prob2defend + 10
			else
				prob2defend = prob2defend + (human_dodger.get_skill_level(attacking_item.associated_skill) * 10)
		else //the enemy attacked us unarmed or is nonhuman
			if(attacker?.used_intent?.unarmed)
				prob2defend = prob2defend - (attacker.get_skill_level(/datum/skill/combat/unarmed) * 10)
				prob2defend = prob2defend + (human_dodger.get_skill_level(/datum/skill/combat/unarmed) * 10)

		var/ignore_DE_bonus = FALSE

		if(HAS_TRAIT(src, TRAIT_GUIDANCE))
			prob2defend += 20
			drained -= 5

		if(HAS_TRAIT(attacker, TRAIT_GUIDANCE))
			prob2defend -= 20
			ignore_DE_bonus = TRUE

		if(HAS_TRAIT(attacker, TRAIT_CURSE_RAVOX))
			prob2defend -= 40
			ignore_DE_bonus = TRUE

		var/datum/status_effect/debuff/magical_blindness/magic_blind = human_dodger.has_status_effect(/datum/status_effect/debuff/magical_blindness)
		if (magic_blind)
			prob2defend -= magic_blind.effect_strength * 5 // 5% dodge chance loss per level

		// dodging while knocked down sucks ass
		if(!(mobility_flags & MOBILITY_STAND))
			prob2defend *= 0.25
			ignore_DE_bonus = TRUE

		if(HAS_TRAIT(human_dodger, TRAIT_SENTINELOFWITS))
			var/sentinel = human_dodger.calculate_sentinel_bonus()
			prob2defend += sentinel

		if(HAS_TRAIT(attacker, TRAIT_ARMOUR_LIKED))
			if(HAS_TRAIT(attacker, TRAIT_FENCERDEXTERITY))
				prob2defend -= 10
				ignore_DE_bonus = TRUE
		
		if(!is_in_cone)
			ignore_DE_bonus = TRUE
		if(attacking_item && IL)	//Skilldiff applies extra stamloss, tentative
			drained += (attacker.get_skill_level(attacking_item.associated_skill) - human_dodger.get_skill_level(IL.associated_skill))

			if(istype(attacker.rmb_intent, /datum/rmb_intent/swift) && attacking_item.wbalance != WBALANCE_HEAVY)
				drained += 3	//We drain extra stam if we're being attacked by swift stance

		if(has_trait && human_dodger.mind && !ignore_DE_bonus && human_dodger.STASPD > 10)
			prob2defend = 90	//We cap it out if we have Dodge Expert as a Player.

		if(dodgetime <= CLICK_CD_DODGE && !ignore_DE_bonus && has_trait && human_dodger.mind)

			var/mainh = get_active_held_item()
			var/offh = get_inactive_held_item()
			if(istype(mainh, /obj/item/rogueweapon/shield) || istype(offh, /obj/item/rogueweapon/shield))	//why do I have to pre-empt the worst of you
				max_dodge = MAX_DODGE_FLOOR
				changeNext_def(CLICK_CD_DODGE)
		prob2defend = clamp((prob2defend + max_dodge + (highwayman_bonus ? 20 : 0) + glory_bonus), 5, (90 + max_dodge))

		//------------Dual Wielding Checks------------
		var/attacker_dualw
		var/defender_dualw
		var/extraattroll
		var/extradefroll
		var/mainhand = get_active_held_item()
		var/offhand	= get_inactive_held_item()

		//Dual Wielder defense disadvantage
		if(mainhand && offhand)
			if(HAS_TRAIT(src, TRAIT_DUALWIELDER) && istype(offhand, mainhand))
				extradefroll = prob(prob2defend)
				defender_dualw = TRUE

		//dual-wielder attack advantage
		var/obj/item/mainh = attacker.get_active_held_item()
		var/obj/item/offh = attacker.get_inactive_held_item()
		if(mainh && offh && HAS_TRAIT(attacker, TRAIT_DUALWIELDER))
			if(istype(mainh, offh))
				extraattroll = prob(prob2defend)
				attacker_dualw = TRUE
		//----------Dual Wielding check end---------

		var/attacker_feedback
		if(attacker.client?.prefs.showrolls && (attacker_dualw || defender_dualw))
			attacker_feedback = "以优势发动攻击。（[100 - ((prob2defend / 100) * (prob2defend / 100) * 100)]%）"

		if(client?.prefs.showrolls)
			var/text = "闪避判定……[prob2defend]%"
			if((defender_dualw || attacker_dualw))
				if(defender_dualw && attacker_dualw)
					text += " 双方的双持效果相互抵消！"
				else//If we're defending against or as a dual wielder, we roll disadv. But if we're both dual wielding it cancels out.
					text += " 劣势判定，需连续成功两次！（[(prob2defend / 100) * (prob2defend / 100) * 100]%）"
			to_chat(src, span_info("[text]"))

		if(src.has_status_effect(/datum/status_effect/swingdelay/penalty))
			prob2defend -= 50

		var/dodge_status = FALSE
		if((!defender_dualw && !attacker_dualw) || (defender_dualw && attacker_dualw)) //They cancel each other out
			if(attacker_feedback)
				attacker_feedback = "优势被抵消了！"
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
		if(!attacker?.mind) // For NPC, reduce the drained to 5 stamina
			drained = drained_npc
		if(!human_dodger.stamina_add(max(drained,5)))
			to_chat(src, span_warning("我太累了，无法闪避！"))
			return FALSE

	// Should only show success cause it terminates earlier otherwise
	if(client)
		log_combat(src, attacker, "dodged", null, defense_log_note(attacker))
	dodge_sanity = TRUE
	playsound(src, 'sound/combat/dodge.ogg', 100, FALSE)
	if(!highwayman_bonus)
		throw_at(turfy, 1, 2, src, FALSE)
	if(drained > 0)
		visible_message(span_warning("<b>[src]</b>躲开了[attacker]的攻击！"))
	else
		visible_message(span_warning("<b>[src]</b>轻松躲开了[attacker]的攻击！"))
	if(get_dist(src, attacker) <= attacker.used_intent?.reach)	//We are still in range of the attacker's weapon post-dodge
		var/probclip = 50
		var/obj/item/IS = get_active_held_item()
		var/obj/item/IU = attacker.get_active_held_item()
		if(IS)
			if(IS.wlength > WLENGTH_NORMAL)
				probclip += (IS.wlength - WLENGTH_NORMAL) * 10	//if wlength isn't standardised this might skyrocket it to >100%
			else
				probclip -= (WLENGTH_NORMAL - IS.wlength) * 10
		var/dist = (attacker.used_intent?.reach - get_dist(src, attacker)) - 1 //-1 because we already are in range and triggered this check to begin with.
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

			attacker.visible_message(span_warning("<b>[attacker]</b>擦中了[src]的武器！"))
			playsound(attacker, 'sound/misc/weapon_clip.ogg', 100)

	var/ignore_penalty = FALSE
	if(fixedeye && goodluck(5))
		ignore_penalty = TRUE
	if(!ignore_penalty)
		var/max_mod = 0
		max_mod = ourskill - theirskill
		changeNext_def(clamp(dodgetime + 1, 0, CLICK_CD_DODGE))
		changeMaxDodge(-1 + ((max_mod < 0) ? max_mod : 0))

	dodge_sanity = FALSE
	return TRUE

/datum/species/proc/z121_highwayman_counter_harm(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("我不想伤害[target]！"))
		return FALSE
	if(target.check_block())
		target.visible_message(span_warning("[target]挡住了[user]的攻击！"), \
						span_danger("我挡住了[user]的攻击！"), span_hear("我听到一阵破空声！"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_warning("我对[target]的攻击被挡住了！"))
		return FALSE
	if(attacker_style && attacker_style.harm_act(user,target))
		return TRUE
	else

//		var/atk_verb = user.dna.species.attack_verb
//		if(!(target.mobility_flags & MOBILITY_STAND))
//			atk_verb = ATTACK_EFFECT_KICK

//	switch(atk_verb)//this code is really stupid but some genius apparently made "claw" and "slash" two attack types but also the same one so it's needed i guess
//		if(ATTACK_EFFECT_KICK)
//			user.do_attack_animation(target, ATTACK_EFFECT_KICK)
//		if(ATTACK_EFFECT_SLASH || ATTACK_EFFECT_CLAW)//smh
//			user.do_attack_animation(target, ATTACK_EFFECT_CLAW)
//		if(ATTACK_EFFECT_SMASH)
//			user.do_attack_animation(target, ATTACK_EFFECT_SMASH)
///			else
//				user.do_attack_animation(target, ATTACK_EFFECT_PUNCH)

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
		if(target.has_status_effect(/datum/status_effect/buff/clash) && ishuman(user))
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
						to_chat(user, span_warning("冥下侍女的邪恶祝福伤害了我们！"))
				user.adjust_blurriness(2)
				user.adjustBruteLoss(rand(5, 10))
				user.apply_status_effect(/datum/status_effect/churned, target)

		if(user.mob_biotypes & MOB_UNDEAD)//This and necra's vow need a better way of handling this. But I'm too lazy to do that.
			if(target.has_status_effect(/datum/status_effect/buff/inviolability))
				if(isnull(user.mind))
					user.adjust_fire_stacks(1)
					user.ignite_mob()
				else
					if(prob(30))
						to_chat(user, span_warning("某种力量伤害了我们！"))
				user.adjust_blurriness(2)
				user.adjustBruteLoss(rand(10, 15))

/*		var/miss_chance = 100//calculate the odds that a punch misses entirely. considers stamina and brute damage of the puncher. punches miss by default to prevent weird cases
		if(user.dna.species.punchdamagelow)
			if(atk_verb == ATTACK_EFFECT_KICK) //kicks never miss (provided my species deals more than 0 damage)
				miss_chance = 0
			else
				miss_chance = min((user.dna.species.punchdamagehigh/user.dna.species.punchdamagelow) + user.getStaminaLoss() + (user.getBruteLoss()*0.5), 100) //old base chance for a miss + various damage. capped at 100 to prevent weirdness in prob()

		if(!damage || !affecting || prob(miss_chance))//future-proofing for species that have 0 damage/weird cases where no zone is targeted
			playsound(target.loc, user.dna.species.miss_sound, 25, TRUE, -1)
			target.visible_message(span_danger("[user]'s [atk_verb] misses [target]!"), \
							span_danger("I avoid [user]'s [atk_verb]!"), span_hear("我听到一阵破空声！"), COMBAT_MESSAGE_RANGE, user)
			to_chat(user, span_warning("My [atk_verb] misses [target]!"))
			log_combat(user, target, "attempted to punch")
			return FALSE
*/
		var/selzone = melee_accuracy_check(user.zone_selected, user, target, /datum/skill/combat/unarmed, user.used_intent)
		var/selzone_real = user.zone_selected

		var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(selzone))

		if(!affecting)
			to_chat(user, span_warning("可惜，那里空无一物。"))
			return 0

		if(!target.lying_attack_check(user))
			return 0

		var/datum/status_effect/z121_highwayman_counter/counter = target.has_status_effect(/datum/status_effect/z121_highwayman_counter)
		counter?.begin_attack(user)
		var/armor_block = target.run_armor_check(selzone, "blunt", armor_penetration = PEN_NONE, blade_dulling = user.used_intent.blade_class, damage = damage, intdamfactor = user.used_intent?.intent_intdamage_factor)

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
			target.next_attack_msg += VISMSG_ARMOR_BLOCKED
		else
			affecting.bodypart_attacked_by(user.used_intent.blade_class, damage, user, selzone, crit_message = TRUE)
			SEND_SIGNAL(target, COMSIG_ATOM_ATTACK_HAND, user)
			if(affecting.body_zone == BODY_ZONE_HEAD)
				SEND_SIGNAL(user, COMSIG_HEAD_PUNCHED, target)
		log_combat(user, target, "punched", null, "(AIMED: [uppertext(parse_zone(user.zone_selected))])")
		if(ishuman(user))
			var/text = "[bodyzone2readablezone(selzone_real)]..."
			user.filtered_balloon_alert(TRAIT_COMBAT_AWARE, text, show_self = FALSE)

		if(!nodmg)
			if(user.limb_destroyer)
				var/easy_dismember = HAS_TRAIT(target, TRAIT_EASYDISMEMBER) || affecting.rotted
				var/probability = damage / (2 - easy_dismember)
				if(HAS_TRAIT(target, TRAIT_HARDDISMEMBER) && !easy_dismember)
					probability = min(probability, 5)
				if(prob(probability) && affecting.dismember())
					playsound(get_turf(target), "desecration", 80, TRUE)

/*		if(user == target)
			target.visible_message(span_danger("[user] [atk_verb]ed themself![target.next_attack_msg.Join()]"), COMBAT_MESSAGE_RANGE, user)
			to_chat(user, span_userdanger("I [atk_verb] myself![target.next_attack_msg.Join()]"))
		else
			target.visible_message(span_danger("[user] [atk_verb]ed [target]![target.next_attack_msg.Join()]"), \
							span_userdanger("I'm [atk_verb]ed by [user]![target.next_attack_msg.Join()]"), span_hear("I hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, user)
			to_chat(user, span_danger("I [atk_verb] [target]![target.next_attack_msg.Join()]"))
*/
		var/message_verb = "拳击"
		if(user.used_intent)
			message_verb = "[pick(user.used_intent.attack_verb)]"
		var/message_hit_area = ""
		if(selzone)
			message_hit_area = "的[span_userdanger(parse_zone(selzone, affecting))]"
		var/attack_message = "[user][message_verb][target][message_hit_area]！"
		var/attack_message_local = "[user][message_verb]我[message_hit_area]！"
		target.visible_message(span_danger("[attack_message][target.next_attack_msg.Join()]"),\
			span_danger("[attack_message_local][target.next_attack_msg.Join()]"), null, COMBAT_MESSAGE_RANGE)
		target.next_attack_msg.Cut()

/*		if((target.stat != DEAD) && damage >= user.dna.species.punchstunthreshold)
			target.visible_message(span_danger("[user]击倒了[target]！"), \
							span_danger("我被[user]击倒了！"), span_hear("我听到激烈的扭打声，随后是一声重响！"), COMBAT_MESSAGE_RANGE, user)
			to_chat(user, span_danger("我击倒了[target]！"))
			var/knockdown_duration = 40 + (target.getStaminaLoss() + (target.getBruteLoss()*0.5))*0.8 //50 total damage = 40 base stun + 40 stun modifier = 80 stun duration, which is the old base duration
			target.apply_effect(knockdown_duration, EFFECT_KNOCKDOWN, armor_block)
			target.forcesay(GLOB.hit_appends)
			log_combat(user, target, "got a stun punch with their previous punch")*/
		if(!(target.mobility_flags & MOBILITY_STAND))
			target.forcesay(GLOB.hit_appends)
		if(!nodmg)
			playsound(target.loc, user.used_intent.hitsound, 100, FALSE)

