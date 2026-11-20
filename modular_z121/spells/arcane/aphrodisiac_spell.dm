// ============================================================================
// 欲火咒 (Aphrodisiac) —— 自定义奥术投射法术
// ----------------------------------------------------------------------------
// 命中活物后施加【欲火】与【虚弱】：
//   · 欲火：只对开启 ERP(prefs.sexable) 的人类生效，命中瞬间直接增加一笔欲望值(不附加持续 debuff)。
//           未开启 ERP 的人类只会感到一阵燥热，体温略微升高，但始终低于中暑阈值。
//   · 虚弱：命中所有活物都会生效，10 秒内力量/体质/速度下降。
// 反魔法可完全抵消；未开启 ERP 者不会受到欲望效果，只承受燥热与虚弱。
// ============================================================================

/datum/action/cooldown/spell/z121/invoked/projectile/aphrodisiac
	name = "欲火咒"
	desc = "射出一枚绯红咒矢，命中后立即撩起目标的欲望，并使其陷入短暂的虚弱。只对开启 ERP 的玩家生效；其他人只会感到一阵燥热。"
	point_cost = 4
	primary_resource_cost = 15
	hold_drain = 0
	charge_time = 1 SECONDS
	cooldown_time = 15 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	spell_tier = 2
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "love"
	invocations = list("绯红之潮，漫过理智……")
	invocation_type = "whisper"
	spell_color = GLOW_COLOR_ILLUSION
	glow_intensity = GLOW_INTENSITY_LOW
	charge_slowdown = 1
	associated_skill = /datum/skill/magic/arcane
	cast_range = 8
	projectile_type = /obj/projectile/energy/aphrodisiac_spell_bolt
	sound = list('sound/magic/heartbeat.ogg')

/obj/projectile/energy/aphrodisiac_spell_bolt
	name = "欲火咒矢"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "arcyne_bolt"
	color = "#ff4f9a"
	damage = 0
	nodamage = TRUE
	speed = MAGE_PROJ_FAST
	range = 12
	muzzle_type = null
	impact_type = null
	hitsound = null

/obj/projectile/energy/aphrodisiac_spell_bolt/on_hit(atom/target, blocked = FALSE)
	if(!isliving(target))
		return ..()

	var/mob/living/hit_mob = target
	if(blocked == 100)
		return ..()
	if(hit_mob.anti_magic_check())
		visible_message(span_warning("[src] 在触碰到 [hit_mob] 的瞬间化作一缕粉色轻烟，被反魔法驱散了！"))
		playsound(get_turf(hit_mob), 'sound/magic/magic_nulled.ogg', 100)
		return BULLET_ACT_BLOCK

	. = ..()
	if(. == BULLET_ACT_BLOCK)
		return .

	apply_spell_effects(hit_mob)
	return BULLET_ACT_HIT

/obj/projectile/energy/aphrodisiac_spell_bolt/proc/apply_spell_effects(mob/living/hit_mob)
	// 欲火部分只对被命中的、开启 ERP 的人类生效。
	if(ishuman(hit_mob))
		var/mob/living/carbon/human/hit_human = hit_mob
		if(hit_human.client?.prefs?.sexable)
			if(!hit_human.sexcon)
				hit_human.sexcon = new /datum/sex_controller(hit_human)
			// 一次性注入欲望值：与旧版 20 秒持续累积的总量持平，但不再留下可反复续期的 debuff。
			hit_human.sexcon.adjust_arousal(35)
			hit_human.visible_message(
				span_warning("[hit_human] 被一团绯红咒光击中，脸颊迅速泛起潮红，双腿一软。"),
				span_love("一股滚烫的甜腻热流钻进身体深处，我的呼吸急促起来，双腿开始发软……"))
			if(isliving(firer))
				to_chat(firer, span_notice("欲火咒命中了 [hit_human]，[hit_human.p_their()] 的呼吸明显乱了。"))
		else
			// 未开启 ERP：不撩起欲望，只让体温略微升高；上限压在 BODYTEMP_NORMAL_MAX 之下，绝不会触发中暑。
			if(hit_human.bodytemperature < BODYTEMP_NORMAL_MAX)
				hit_human.bodytemperature = min(hit_human.bodytemperature + 5, BODYTEMP_NORMAL_MAX - 1)
			hit_human.visible_message(
				span_warning("[hit_human] 被一团绯红咒光击中，踉跄了一下。"),
				span_warning("那股甜腻的咒力掠过身体，只留下一阵燥热与虚弱。"))
	else
		hit_mob.visible_message(span_warning("[hit_mob] 被一团绯红咒光击中，动作明显迟缓了。"))

	// 虚弱部分对所有活物生效。
	hit_mob.apply_status_effect(/datum/status_effect/debuff/aphrodisiac_weakness)

// ---------------------------------------------------------------------------
// 虚弱状态：力量、体质、速度下降。
// ---------------------------------------------------------------------------
/datum/status_effect/debuff/aphrodisiac_weakness
	id = "aphrodisiac_weakness"
	alert_type = /atom/movable/screen/alert/status_effect/aphrodisiac_weakness
	effectedstats = list(STATKEY_STR = -2, STATKEY_CON = -1, STATKEY_SPD = -1)
	duration = 10 SECONDS

/atom/movable/screen/alert/status_effect/aphrodisiac_weakness
	name = "欲火咒·虚弱"
	desc = "四肢发软，使不上力气。"
	icon_state = "debuff"
