/datum/action/cooldown/spell/augment_buff/grasp
	name = "入门"
	desc = "伸手锁定 7 格内的目标，引导 2 秒后将其拉至身边。拉扯时奥术牵系会连接双方，提醒目标做好准备。目标必须与你同属结社，且引导结束时仍在视野中。"
	button_icon_state = "grasp"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	cast_range = 7
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_TELEPORT

	invocations = list("来我身边！")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 45 SECONDS

	point_cost = 1
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	var/channel_time = 1.5 SECONDS
	var/channeling = FALSE

/datum/action/cooldown/spell/augment_buff/grasp/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	if(channeling)
		return FALSE
	if(!isliving(cast_on))
		to_chat(H, span_warning("那不是有效目标！"))
		return FALSE

	var/mob/living/target = cast_on
	if(target == H)
		to_chat(H, span_warning("我不能抓取自己！"))
		return FALSE
	if(!shares_fellowship(H, target) && !H.faction_check_mob(target))
		to_chat(H, span_warning("[target]与我没有同伴联结！"))
		return FALSE

	var/datum/beam/tether = H.Beam(target, "purple_lightning", time = channel_time)

	H.visible_message(span_warning("[H]向[target]伸出手，奥术之力在两人之间划出弧光！"), span_notice("我锁定[target]，开始将其拉近……"))
	to_chat(target, span_warning("奥术之力缠绕着你——[H]正将你拉向身边！做好准备。"))
	target.balloon_alert_to_viewers("<font color='[spell_color]'>正在抓取！</font>")

	channeling = TRUE
	var/completed = do_after(H, channel_time, needhand = FALSE, progress = TRUE, no_interrupt = TRUE, allow_movement = TRUE)
	channeling = FALSE
	if(tether)
		qdel(tether)
	if(!completed)
		to_chat(H, span_warning("我与[target]之间的抓取之力消散了。"))
		return FALSE

	if(QDELETED(target) || !isliving(target))
		return FALSE
	if(!shares_fellowship(H, target) && !H.faction_check_mob(target))
		to_chat(H, span_warning("[target]不再与我相连——抓取崩解了。"))
		return FALSE
	if(!can_see(H, target, cast_range))
		to_chat(H, span_warning("[target]已离开我的视野——抓取失败！"))
		return FALSE

	var/turf/dest = get_turf(H)
	var/turf/origin = get_turf(target)
	target.balloon_alert_to_viewers("<font color='[spell_color]'>已抓取！</font>")
	do_teleport(target, dest, channel = TELEPORT_CHANNEL_MAGIC)
	new /obj/effect/temp_visual/blink(origin, H.dir)
	new /obj/effect/temp_visual/blink(dest, H.dir)
	playsound(origin, 'sound/magic/blink.ogg', 40, TRUE)
	playsound(dest, 'sound/magic/blink.ogg', 50, TRUE)
	new /obj/effect/temp_visual/spell_impact(dest, spell_color, spell_impact_intensity)
	target.visible_message(span_warning("[target]被拖过地面，来到[H]身边！"), span_notice("奥术之力把我拽向[H]！"))
	return TRUE
