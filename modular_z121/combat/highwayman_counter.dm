// 反击用移动信号站定，不移除行动能力，避免原版防御因定身而失效。
/datum/status_effect/z121_highwayman_counter
	id = "z121_highwayman_counter"
	duration = 3 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/z121_highwayman_counter
	var/datum/weakref/attacker_ref
	var/attack_serial = 0
	var/damage_pending = FALSE
	var/damage_type = BRUTE
	var/damage_before = 0
	var/spent = FALSE

/atom/movable/screen/alert/status_effect/z121_highwayman_counter
	name = "反击"
	desc = "站定，近战闪避增加20个百分点。首次受击或闪避后反击；幸运判定成功可追加返还此次攻击伤害。"
	icon = 'modular_z121/icon/custompell.dmi'
	icon_state = "DuelThrust"

/datum/status_effect/z121_highwayman_counter/on_apply()
	if(!z121_highwayman_armor_allowed(owner))
		return FALSE
	. = ..()
	RegisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(block_move))
	RegisterSignal(owner, COMSIG_ITEM_ATTACKED_SUCCESS, PROC_REF(weapon_hit))
	RegisterSignal(owner, COMSIG_ATOM_BULLET_ACT, PROC_REF(bullet_hit))
	RegisterSignal(owner, COMSIG_MOB_ATTACKED_BY_HAND, PROC_REF(unarmed_hit))
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(before_damage))
	RegisterSignal(owner, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(after_damage))

/datum/status_effect/z121_highwayman_counter/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOVABLE_PRE_MOVE, COMSIG_ITEM_ATTACKED_SUCCESS, COMSIG_ATOM_BULLET_ACT, COMSIG_MOB_ATTACKED_BY_HAND, COMSIG_MOB_APPLY_DAMGE, COMSIG_LIVING_HEALTH_UPDATE))
	return ..()

/datum/status_effect/z121_highwayman_counter/proc/block_move()
	SIGNAL_HANDLER
	if(!spent && z121_highwayman_armor_allowed(owner))
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/datum/status_effect/z121_highwayman_counter/proc/weapon_hit(datum/source, obj/item/weapon, mob/living/attacker)
	SIGNAL_HANDLER
	begin_attack(attacker)

/datum/status_effect/z121_highwayman_counter/proc/bullet_hit(datum/source, obj/projectile/P, zone)
	SIGNAL_HANDLER
	if(!P.nodamage && isliving(P.firer))
		begin_attack(P.firer)

// 徒手伤害在防御判定后还有一次前摇，必须在真正结算时重新绑定来源。
/datum/status_effect/z121_highwayman_counter/proc/unarmed_hit(datum/source, mob/living/carbon/human/attacker, mob/living/carbon/human/target, datum/martial_art/style)
	SIGNAL_HANDLER
	if(target != owner || !z121_highwayman_armor_allowed(owner) || !istype(attacker.used_intent, /datum/intent/unarmed))
		return
	if(attacker.used_intent.type in list(INTENT_HELP, INTENT_GRAB, INTENT_DISARM))
		return
	INVOKE_ASYNC(target.dna.species, TYPE_PROC_REF(/datum/species, z121_highwayman_counter_harm), attacker, target, style)
	return COMPONENT_HAND_NO_ATTACK

/datum/status_effect/z121_highwayman_counter/proc/begin_attack(mob/living/attacker)
	if(spent || QDELETED(attacker) || attacker == owner || !z121_highwayman_armor_allowed(owner))
		return
	attacker_ref = WEAKREF(attacker)
	damage_pending = FALSE
	attack_serial++
	// 防御到伤害结算之间没有等待；本轮结束即丢弃来源，流血不能借用旧攻击者。
	addtimer(CALLBACK(src, PROC_REF(finish_attack), attack_serial), 0)

/datum/status_effect/z121_highwayman_counter/proc/before_damage(datum/source, amount, type, zone)
	SIGNAL_HANDLER
	if(spent || !attacker_ref?.resolve() || damage_pending || amount < 0)
		return
	damage_type = type
	damage_before = owner.get_damage_amount(type)
	damage_pending = TRUE

/datum/status_effect/z121_highwayman_counter/proc/after_damage()
	SIGNAL_HANDLER
	if(!damage_pending || spent)
		return
	var/actual = max(0, owner.get_damage_amount(damage_type) - damage_before)
	if(actual > 0)
		retaliate(actual, damage_type)

/datum/status_effect/z121_highwayman_counter/proc/finish_attack(serial)
	if(serial != attack_serial || spent)
		return
	// 护甲全挡时没有生命更新，仍是受击；返还伤害为零但保留基础反击。
	if(damage_pending)
		retaliate(max(0, owner.get_damage_amount(damage_type) - damage_before), damage_type)
	else
		attacker_ref = null

/datum/status_effect/z121_highwayman_counter/proc/counter_dodge(mob/living/attacker, datum/intent/attack_intent)
	if(spent || !attacker || !attack_intent || !z121_highwayman_armor_allowed(owner))
		return
	attacker_ref = WEAKREF(attacker)
	var/amount = 0
	var/type = BRUTE
	var/flag = "blunt"
	var/penetration = BLUNT_DEFAULT_PENFACTOR
	var/obj/item/I = attack_intent.masteritem
	if(I)
		amount = get_complex_damage(I, attacker)
		type = I.damtype
		flag = I.d_type
		penetration = flag == "blunt" ? BLUNT_DEFAULT_PENFACTOR : I.armor_penetration + attack_intent.penfactor
		if(attacker.has_status_effect(/datum/status_effect/z121_highwayman_flaws) && z121_highwayman_armor_allowed(attacker))
			amount *= 1.3
	else if(isanimal(attacker))
		var/mob/living/simple_animal/A = attacker
		amount = rand(A.melee_damage_lower, A.melee_damage_upper)
		type = A.melee_damage_type
		flag = A.d_type
		penetration = flag == "blunt" ? BLUNT_DEFAULT_PENFACTOR : A.armor_penetration
	else
		amount = attacker.get_punch_dmg()
		if(istype(attacker.rmb_intent, /datum/rmb_intent/strong))
			amount *= 1 + STRONG_STANCE_DMG_BONUS
	// 只读护甲属性，绝不为一次成功闪避损坏护甲或消耗受伤状态。
	var/mob/living/carbon/human/H = owner
	var/armor = 0
	if(istype(H))
		var/obj/item/clothing/C = H.get_best_worn_armor(check_zone(attacker.zone_selected), flag)
		armor = (C ? C.armor.getRating(flag) : 0) + H.physiology.armor.getRating(flag)
		armor = max(0, armor - penetration)
		amount = max(0, amount - armor) * (1 - H.dna.species.armor / 100)
		amount *= 1 - H.physiology.damage_resistance / 100
		if(type == BRUTE)
			amount *= H.dna.species.brutemod * H.physiology.brute_mod
		else if(type == BURN)
			amount *= H.dna.species.burnmod * H.physiology.burn_mod
	retaliate(max(0, amount), type)

/datum/status_effect/z121_highwayman_counter/proc/retaliate(amount, type)
	if(spent)
		return
	if(!z121_highwayman_armor_allowed(owner))
		qdel(src)
		return
	spent = TRUE
	var/mob/living/defender = owner
	var/mob/living/attacker = attacker_ref?.resolve()
	var/success = prob(clamp(defender.STALUC * 5, 5, 95))
	// 先删除状态与监听，再施加伤害，双方反击不会形成递归。
	qdel(src)
	if(QDELETED(defender) || QDELETED(attacker) || defender.stat == DEAD || attacker.stat == DEAD)
		return
	var/datum/status_effect/z121_highwayman_counter/other_counter = attacker.has_status_effect(/datum/status_effect/z121_highwayman_counter)
	if(other_counter)
		other_counter.attacker_ref = null
		other_counter.damage_pending = FALSE
	z121_highwayman_true_damage(defender, attacker, 30, BRUTE, defender.zone_selected, TRUE)
	if(success && !QDELETED(attacker))
		z121_highwayman_true_damage(defender, attacker, amount, type, defender.zone_selected)
	defender.visible_message(span_warning("[defender]抓住破绽，反击了[attacker]！"))
	log_combat(defender, attacker, "武技反击", addition = "基础锐伤30，幸运[success ? "成功" : "失败"]，返还[success ? amount : 0]点[type]伤害")

/mob/living/carbon/human/checkdefense(datum/intent/intenty, mob/living/attacker)
	var/datum/status_effect/z121_highwayman_counter/C = has_status_effect(/datum/status_effect/z121_highwayman_counter)
	C?.begin_attack(attacker)
	. = ..()
	if(. && d_intent == INTENT_DODGE && C && !QDELETED(C))
		C.counter_dodge(attacker, intenty)

/mob/living/carbon/human/attempt_dodge(datum/intent/intenty, mob/living/attacker)
	if(!has_status_effect(/datum/status_effect/z121_highwayman_counter) || !z121_highwayman_armor_allowed(src))
		return ..()
	if(!intenty?.dodgeable_intent || HAS_TRAIT(src, TRAIT_NODEF) || !mob_can_dodge || pulledby || pulling || loc == attacker.loc)
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/exposed) || has_status_effect(/datum/status_effect/debuff/vulnerable) || has_status_effect(/datum/status_effect/debuff/riposted))
		return FALSE
	if(!COOLDOWN_FINISHED(src, last_dodge) && !istype(rmb_intent, /datum/rmb_intent/riposte))
		return FALSE
	COOLDOWN_START(src, last_dodge, dodgetime)
	if(do_dodge(attacker, get_turf(src)))
		flash_fullscreen("blackflash2")
		attacker.aftermiss()
		return TRUE
	return FALSE
