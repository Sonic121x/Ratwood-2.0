// 神锋无影：伤害与流血分别结算，流血不要求本次 BRUTE 数值增加。
// 本文件保留原法术及投射物路径，注册入口、动作图标和弹道贴图无需改动。

#define SECTUM_TARGET_RANGE 12
#define SECTUM_SIMPLE_DAMAGE_MULTIPLIER 1.5
#define SECTUM_BLEED_CHANCE 30
#define SECTUM_BLEED_MULTIPLIER 2
#define SECTUM_BLEED_CAP 20
#define SECTUM_WOUND_HEALTH_MULTIPLIER 1.5

/obj/effect/proc_holder/spell/invoked/projectile/sectumsempra
	name = "神锋无影"
	desc = "一位传奇魔药大师创制的凶厉咒术。其创制之意早已无人知晓，唯有无形锋刃留下的伤痕，足以证明它的效用。"
	school = "evocation"
	spell_tier = 4
	cost = 9
	releasedrain = 30
	chargedrain = 1
	chargetime = 1 SECONDS // 基础释放时间；允许技能、法杖和法术书等修正。
	recharge_time = 5 SECONDS // 基础冷却；沿用属性、特性及管理员倍率修正。
	range = SECTUM_TARGET_RANGE
	projectile_type = /obj/projectile/energy/sectumsempra_bolt
	human_req = TRUE
	warnie = "spellwarning"
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "sectumsempra"
	invocations = list("神锋无影")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane // 影响施法与命中，不改变投射物基础伤害。
	gesture_required = TRUE
	miracle = FALSE
	xp_gain = TRUE
	sound = list('sound/magic/whiteflame.ogg')

/obj/effect/proc_holder/spell/invoked/projectile/sectumsempra/cast(list/targets, mob/living/user = usr)
	if(!length(targets))
		revert_cast()
		return FALSE

	// 弧射意图改变弹道并保留减伤；其它意图发射标准锋刃。
	projectile_type = /obj/projectile/energy/sectumsempra_bolt
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(istype(human_user.a_intent, /datum/intent/special/magicarc))
			projectile_type = /obj/projectile/energy/sectumsempra_bolt/arc

	user.visible_message(span_danger("[user] 手腕轻振，一道几乎无形的锋刃疾射而出！"))
	to_chat(user, span_notice("我将无形锋刃投向瞄准的方向。"))
	return ..()

// 只继承主线小割伤的治疗与流血参数，不额外增加直接伤害。
/datum/wound/slash/small/sectumsempra
	name = "轻微割伤"

/obj/projectile/energy/sectumsempra_bolt
	name = "无形锋刃"
	icon = 'modular_z121/icon/projectiles.dmi'
	icon_state = "sectumsempra"
	damage = 60
	damage_type = BRUTE
	flag = "slash"
	woundclass = BCLASS_CUT
	nodamage = FALSE
	dismemberment = 0
	speed = 0.6
	range = SECTUM_TARGET_RANGE
	muzzle_type = null
	impact_type = null
	hitsound = 'sound/combat/hits/bladed/genchop (1).ogg'

	// 护甲检查发生在命中率判定之后、伤害结算之前。
	// 记录实际受击肢体和已有流血最强的伤口，不借用伤害成功后的伤口钩子。
	var/mob/living/pending_target
	var/obj/item/bodypart/pending_bodypart
	var/datum/wound/pending_wound

/obj/projectile/energy/sectumsempra_bolt/arc
	name = "弧射·无形锋刃"
	damage = 45
	arcshot = TRUE

/obj/projectile/energy/sectumsempra_bolt/proc/clear_hit_record()
	pending_target = null
	pending_bodypart = null
	pending_wound = null

/obj/projectile/energy/sectumsempra_bolt/Destroy()
	clear_hit_record()
	return ..()

// 不改变护甲检查的签名、参数或返回值，仅为专属投射物补充命中记录。
// 盾牌拦截、反射和未命中不会进入这次主线护甲检查，因而不能触发流血。
/mob/living/run_armor_check(def_zone = null, attack_flag = "blunt", absorb_text = null, soften_text = null, armor_penetration, penetrated_text, damage, blade_dulling, peeldivisor, intdamfactor, used_weapon = null)
	. = ..()
	var/obj/projectile/energy/sectumsempra_bolt/bolt = used_weapon
	if(istype(bolt) && !QDELETED(bolt))
		bolt.record_hit(src, def_zone)

/obj/projectile/energy/sectumsempra_bolt/proc/record_hit(mob/living/target, hit_zone)
	clear_hit_record()
	if(QDELETED(target))
		return
	// 即使目标没有可流血肢体，也要确认实际命中并执行反魔法检查。
	pending_target = target

	var/list/wounds_before_hit
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/part = carbon_target.get_bodypart(check_zone(hit_zone))
		if(QDELETED(part) || part.owner != target || !(part in carbon_target.bodyparts) || !part.can_bloody_wound())
			return
		pending_bodypart = part
		wounds_before_hit = part.wounds
	else if(HAS_TRAIT(target, TRAIT_SIMPLE_WOUNDS))
		wounds_before_hit = target.simple_wounds
	else
		return

	// 严格大于才替换，流血速率并列时保留列表中的第一处。
	// 已缝合或凝血但仍有正流血值的伤口也计入，不主动拆线或重置治疗状态。
	for(var/datum/wound/wound as anything in wounds_before_hit)
		if(QDELETED(wound) || wound.owner != target || wound.bodypart_owner != pending_bodypart || wound.bleed_rate <= 0)
			continue
		if(!pending_wound || wound.bleed_rate > pending_wound.bleed_rate)
			pending_wound = wound

/obj/projectile/energy/sectumsempra_bolt/on_hit(atom/target, blocked = FALSE)
	// 先消费本次记录，防止回调重复使用；被拦截的命中也清理记录。
	var/mob/living/recorded_target = pending_target
	var/obj/item/bodypart/recorded_part = pending_bodypart
	var/datum/wound/recorded_wound = pending_wound
	clear_hit_record()

	if(!isliving(target))
		return ..()
	var/mob/living/living_target = target
	if(living_target.status_flags & GODMODE)
		return BULLET_ACT_BLOCK
	// 盾牌直接调用 on_hit 时没有主线实际命中记录，只处理原有命中特效。
	if(living_target != recorded_target)
		return ..()
	if(living_target.anti_magic_check())
		visible_message(span_warning("[src] 在触及 [living_target] 的刹那化作碎光，被反魔法驱散了！"))
		playsound(get_turf(living_target), 'sound/magic/magic_nulled.ogg', 100)
		return BULLET_ACT_BLOCK

	// 仅对实际命中的简单生物增加伤害，不按是否拥有心智扩大加成范围。
	if(issimple(living_target))
		damage *= SECTUM_SIMPLE_DAMAGE_MULTIPLIER

	. = ..()
	if(. == BULLET_ACT_BLOCK || QDELETED(src) || QDELETED(living_target))
		return .
	// 完全护甲吸收、伤害倍率为零或肢体伤害封顶均不阻止独立流血效果。
	apply_bleeding_effect(living_target, recorded_part, recorded_wound)

/obj/projectile/energy/sectumsempra_bolt/proc/apply_bleeding_effect(mob/living/target, obj/item/bodypart/part, datum/wound/existing_wound)
	if(QDELETED(target) || (target.status_flags & GODMODE))
		return FALSE
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		if(QDELETED(part) || part.owner != target || !(part in carbon_target.bodyparts) || !part.can_bloody_wound())
			return FALSE
	else if(part || !HAS_TRAIT(target, TRAIT_SIMPLE_WOUNDS))
		return FALSE

	if(existing_wound)
		// 命中前选中的伤口若已消失或改变归属，不转移到其它伤口，也不补抽新增概率。
		if(QDELETED(existing_wound) || existing_wound.owner != target || existing_wound.bodypart_owner != part)
			return FALSE
		if(part)
			if(!(existing_wound in part.wounds))
				return FALSE
		else if(!(existing_wound in target.simple_wounds))
			return FALSE
		if(existing_wound.bleed_rate <= 0)
			return FALSE

		var/old_bleed_rate = existing_wound.bleed_rate
		existing_wound.set_bleed_rate(max(old_bleed_rate, min(old_bleed_rate * SECTUM_BLEED_MULTIPLIER, SECTUM_BLEED_CAP)))
		if(isnum(existing_wound.whp))
			existing_wound.whp *= SECTUM_WOUND_HEALTH_MULTIPLIER
		target.mark_zone_selector_hud_dirty()
		target.mark_pain_hud_dirty()
		target.visible_message(
			span_danger("[target] 原有的伤口被无形锋刃再次撕裂，鲜血涌出！"),
			span_userdanger("无形锋刃撕开了我原有的伤口，伤势愈发严重！")
		)
		return TRUE

	if(!prob(SECTUM_BLEED_CHANCE))
		return FALSE
	var/datum/wound/new_wound
	if(part)
		new_wound = part.add_wound(/datum/wound/slash/small/sectumsempra, TRUE)
	else
		new_wound = target.simple_add_wound(/datum/wound/slash/small/sectumsempra, TRUE)
	if(!new_wound)
		return FALSE
	target.visible_message(
		span_danger("[target] 被无形锋刃划出一道细小的伤口，鲜血缓缓渗出。"),
		span_userdanger("无形锋刃划开了我的皮肉，鲜血从细小的伤口中渗出。")
	)
	return TRUE

// 专属流血效果已经在 on_hit 中结算；跳过该弹种的常规伤口生成，
// 防止主线自动割伤绕过 30% 新增概率。其它投射物完整沿用主线逻辑。
/mob/living/check_projectile_wounding(obj/projectile/P, def_zone, blocked)
	if(istype(P, /obj/projectile/energy/sectumsempra_bolt))
		return FALSE
	return ..()

/mob/living/carbon/check_projectile_wounding(obj/projectile/P, def_zone, blocked)
	if(istype(P, /obj/projectile/energy/sectumsempra_bolt))
		return FALSE
	return ..()

#undef SECTUM_TARGET_RANGE
#undef SECTUM_SIMPLE_DAMAGE_MULTIPLIER
#undef SECTUM_BLEED_CHANCE
#undef SECTUM_BLEED_MULTIPLIER
#undef SECTUM_BLEED_CAP
#undef SECTUM_WOUND_HEALTH_MULTIPLIER
