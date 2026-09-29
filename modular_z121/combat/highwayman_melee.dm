// 仅强化攻击走局部适配，其余武器攻击原样交还主线。
/obj/item/rogueweapon/attack(mob/living/M, mob/living/user)
	if(z121_highwayman_needs_attack(user))
		return z121_highwayman_attack_guard(M, user)
	return ..()

/obj/item/gun/attack(mob/living/M, mob/living/user)
	if(z121_highwayman_needs_attack(user))
		return z121_highwayman_attack_guard(M, user)
	return ..()

/obj/item/proc/z121_highwayman_needs_attack(mob/living/user)
	if(!ishuman(user) || user.used_intent?.tranged || user.used_intent?.unarmed || user.used_intent?.no_attack)
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!H.z121_highwayman || !H.z121_highwayman.enforce_armor() || !H.z121_highwayman.valid_melee_weapon(src))
		return FALSE
	return (z121_highwayman_weapon && !z121_highwayman_weapon.finisher && z121_highwayman_weapon.controller == H.z121_highwayman) || H.has_status_effect(/datum/status_effect/z121_highwayman_flaws)

/obj/item/proc/z121_highwayman_attack_guard(mob/living/M, mob/living/carbon/human/user)
	var/datum/component/z121_highwayman/C = user.z121_highwayman
	if(!C || C.attacking)
		return FALSE
	C.attacking = TRUE
	. = z121_highwayman_attack(M, user)
	if(!QDELETED(C))
		C.attacking = FALSE

/obj/item/proc/z121_highwayman_defense(mob/living/target, mob/living/user)
	if(!z121_highwayman_cut_ready(user))
		return target.checkdefense(user.used_intent, user)
	// 邪恶切割只跳过格挡；原有闪避条件与反击仍然有效。
	if(!target.cmode || target.stat || !(target.mobility_flags & MOBILITY_MOVE) || target.d_intent != INTENT_DODGE)
		return FALSE
	if(target.client?.charging && target.used_intent?.tranged && !target.used_intent?.tshield)
		return FALSE
	var/result = target.attempt_dodge(user.used_intent, user)
	if(result)
		var/datum/status_effect/z121_highwayman_counter/C = target.has_status_effect(/datum/status_effect/z121_highwayman_counter)
		C?.counter_dodge(user, user.used_intent)
	return result

/obj/item/proc/z121_highwayman_hit(mob/living/target, mob/living/user)
	if(target.stat == DEAD)
		return target.attacked_by(src, user)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		return H.z121_highwayman_attacked_by(src, user)
	if(isanimal(target))
		var/mob/living/simple_animal/A = target
		return A.z121_highwayman_attacked_by(src, user)
	. = target.attacked_by(src, user)
	if(.)
		z121_highwayman_landed(user, target, user.zone_selected)
