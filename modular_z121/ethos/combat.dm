// 主动与被动的攻击通知使用同一筛选，排除治疗、无伤害意图和和平限制。
/proc/z121_ethos_hostile_item(mob/living/user, obj/item/weapon)
	return isliving(user) && weapon?.force > 0 && !(weapon.item_flags & NOBLUDGEON) && user.used_intent && user.used_intent.type != INTENT_HELP && !user.used_intent.no_attack && !HAS_TRAIT(user, TRAIT_PACIFISM)

// 攻击来源跟随当前调用者；等待中的其他攻击不能认领本次伤害。
/mob/living/carbon/human
	var/list/z121_ethos_hits = list()

/mob/living
	var/list/z121_ethos_spell_scopes = list()

/datum/z121_ethos_hit
	var/mob/living/carbon/human/target
	var/mob/living/attacker
	var/actual_damage = 0
	var/damage_tick = -1
	var/finished = FALSE

/datum/z121_ethos_hit/New(mob/living/carbon/human/H, mob/living/A)
	target = H
	attacker = A
	H.z121_ethos_hits += src
	if(ishuman(A) && A != H)
		var/mob/living/carbon/human/actor = A
		actor.z121_get_ethos()?.attacking()
	if(A != H)
		H.z121_get_ethos()?.attacked()

/datum/z121_ethos_hit/Destroy()
	if(target && !QDELETED(target))
		target.z121_ethos_hits.Remove(src)
	target = null
	attacker = null
	return ..()

/datum/z121_ethos_hit/proc/damaged(amount)
	if(!finished && amount > 0 && target && !QDELETED(target))
		// 同一招的多肢体伤害可相加；持续法术跨时刻的独立小伤害不能凑满阈值。
		if(damage_tick != world.time)
			actual_damage = 0
			damage_tick = world.time
		actual_damage += amount
		target.z121_get_ethos()?.attacked(actual_damage)

/datum/z121_ethos_hit/proc/check_fall(was_lying, was_knocked)
	if(!finished && target && !QDELETED(target) && !was_lying && !was_knocked && (target.lying || target.IsKnockdown()))
		target.z121_get_ethos()?.fallen()

/datum/z121_ethos_hit/proc/finish()
	finished = TRUE
	qdel(src)

/datum/z121_ethos_spell_scope
	var/mob/living/actor
	var/list/hits = list()

/datum/z121_ethos_spell_scope/New(mob/living/caster)
	actor = caster
	actor.z121_ethos_spell_scopes += src

/datum/z121_ethos_spell_scope/proc/hit_for(mob/living/carbon/human/H)
	var/key = REF(H)
	if(!hits[key])
		hits[key] = new /datum/z121_ethos_hit(H, actor)
	return hits[key]

/datum/z121_ethos_spell_scope/Destroy()
	if(actor && !QDELETED(actor))
		actor.z121_ethos_spell_scopes.Remove(src)
	for(var/key in hits)
		var/datum/z121_ethos_hit/hit = hits[key]
		hit.finish()
	hits.Cut()
	actor = null
	return ..()

/mob/living/carbon/human/proc/z121_ethos_current_hit()
	if(!isliving(usr) || usr == src)
		return null
	for(var/i = length(z121_ethos_hits), i >= 1, i--)
		var/datum/z121_ethos_hit/hit = z121_ethos_hits[i]
		if(!hit.finished && hit.attacker == usr)
			return hit
	var/mob/living/actor = usr
	if(length(actor.z121_ethos_spell_scopes))
		var/datum/z121_ethos_spell_scope/scope = actor.z121_ethos_spell_scopes[length(actor.z121_ethos_spell_scopes)]
		return scope.hit_for(src)
	return null

// 麻痹、昏迷及强制躺卧也会使人倒地；以实际姿态变化统一判定。
// 主动躺下没有他人的攻击来源，不建立攻击记录。
/mob/living/carbon/human/update_mobility()
	var/was_lying = lying
	var/was_knocked = IsKnockdown()
	. = ..()
	if(!was_lying && !was_knocked && lying)
		var/datum/z121_ethos_hit/hit = z121_ethos_current_hit()
		hit?.check_fall(was_lying, was_knocked)

// 肢体伤害在这里同步结算，只累计真正增加的伤害，不比较整段攻击等待期。
/obj/item/bodypart/receive_damage(brute = 0, burn = 0, stamina = 0, blocked = 0, updating_health = TRUE, required_status = null)
	var/mob/living/carbon/human/H = ishuman(owner) ? owner : null
	var/datum/z121_ethos_hit/hit = (brute > 0 || burn > 0 || stamina > 0) ? H?.z121_ethos_current_hit() : null
	var/before = brute_dam + burn_dam
	var/was_lying = H?.lying
	var/was_knocked = H?.IsKnockdown()
	. = ..()
	if(hit && !QDELETED(src))
		var/damage = max(0, brute_dam + burn_dam - before)
		hit.damaged(damage)
		if(damage)
			hit.check_fall(was_lying, was_knocked)

// 必须在击倒真正成功后判定；主动躺下、免疫或被抵抗的击倒不触发傲慢。
/mob/living/carbon/human/Knockdown(amount, updating = TRUE, ignore_canstun = FALSE)
	var/datum/z121_ethos_hit/hit = amount > 0 ? z121_ethos_current_hit() : null
	var/was_lying = lying
	var/was_knocked = IsKnockdown()
	. = ..()
	hit?.check_fall(was_lying, was_knocked)

/mob/living/carbon/human/SetKnockdown(amount, updating = TRUE, ignore_canstun = FALSE)
	var/datum/z121_ethos_hit/hit = amount > 0 ? z121_ethos_current_hit() : null
	var/was_lying = lying
	var/was_knocked = IsKnockdown()
	. = ..()
	hit?.check_fall(was_lying, was_knocked)

/mob/living/carbon/human/AdjustKnockdown(amount, updating = TRUE, ignore_canstun = FALSE)
	var/datum/z121_ethos_hit/hit = amount > 0 ? z121_ethos_current_hit() : null
	var/was_lying = lying
	var/was_knocked = IsKnockdown()
	. = ..()
	hit?.check_fall(was_lying, was_knocked)

// 投掷命中不经过近战或弹丸入口，使用本次投掷记录中的真实投掷者。
/mob/living/carbon/human/hitby(atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum, damage_flag = "blunt")
	var/mob/saved_user = usr
	var/mob/thrower = throwingdatum?.thrower
	if(!thrower && isitem(AM))
		var/obj/item/item = AM
		thrower = item.thrownby
	var/datum/z121_ethos_hit/hit
	if(isliving(thrower) && thrower != src)
		hit = new(src, thrower)
		usr = thrower
	try
		. = ..()
	catch(var/exception/error)
		usr = saved_user
		hit?.finish()
		throw error
	usr = saved_user
	hit?.finish()

// 发出有伤害或控制效果的弹丸就中断克制，不能靠射失继续积累忍耐。
/obj/projectile/fire(angle, atom/direct_target)
	if(ishuman(firer) && ((!nodamage && damage > 0) || stun > 0 || knockdown > 0 || paralyze > 0 || immobilize > 0 || unconscious > 0 || stamina > 0))
		var/mob/living/carbon/human/H = firer
		H.z121_get_ethos()?.attacking()
	return ..()

// 只记录核心确认成功的投出；投掷失败及无伤害物品不作为主动攻击。
/atom/movable/throw_at(atom/target, range, speed, mob/thrower, spin = FALSE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, extra = FALSE)
	var/hostile = isliving(src)
	if(isitem(src))
		var/obj/item/item = src
		hostile = item.throwforce > 0
	. = ..(arglist(args))
	if(. && hostile && ishuman(thrower) && !QDELETED(thrower))
		var/mob/living/carbon/human/H = thrower
		H.z121_get_ethos()?.attacking()
