/datum/action/cooldown/spell/z121/invoked/yixinghuanying
	name = "移形换影"
	desc = "与所选活物瞬间互换位置。"
	point_cost = 3
	xp_gain = TRUE
	primary_resource_cost = 10
	hold_drain = 1
	charge_time = 1 SECONDS
	cooldown_time = 10 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	button_icon_state = "blink"
	spell_tier = 2
	button_icon = 'modular_z121/icon/custompell.dmi'
	button_icon_state = "yixinghuanying"
	invocations = list("形影相易，移位于此！")
	invocation_type = "shout"
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	charge_slowdown = 1
	associated_skill = /datum/skill/magic/arcane
	cast_range = 7
	miracle = FALSE
	sound = 'sound/magic/swap.ogg'

/datum/action/cooldown/spell/z121/invoked/yixinghuanying/z121_apply(atom/cast_on)
	var/list/targets = list(cast_on)
	var/mob/living/user = owner
	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		to_chat(user, span_warning("移形换影只能对活物施放，不能对物品使用。"))
		z121_cancel()
		return FALSE

	var/mob/living/target = target_atom
	if(target == user)
		to_chat(user, span_warning("我不能与自己交换位置。"))
		z121_cancel()
		return FALSE

	var/turf/target_turf = get_turf(target)
	var/turf/user_turf = get_turf(user)
	if(!target_turf || !user_turf)
		z121_cancel()
		return FALSE

	if(user.buckled)
		user.buckled.unbuckle_mob(user, TRUE)
	if(target.buckled)
		target.buckled.unbuckle_mob(target, TRUE)

	playsound(target_turf, 'sound/magic/swap.ogg', 100, TRUE)
	user.forceMove(target_turf)
	target.forceMove(user_turf)
	user.visible_message(span_warning("[user] 与 [target] 的身影骤然交错，转瞬间互换了位置！"), span_notice("我与 [target] 的位置在一瞬间互换了。"))
	to_chat(target, span_warning("一阵扭曲的奥术之力卷过，我与 [user] 的位置瞬间互换了！"))
	return TRUE
