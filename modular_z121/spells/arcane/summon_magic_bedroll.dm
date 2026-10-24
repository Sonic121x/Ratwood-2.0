/datum/action/cooldown/spell/z121/targeted/conjure_item/summon_magic_bedroll
	name = "召唤魔法睡袋"
	desc = "在手中召唤一只捆好的魔法睡袋。它与普通睡袋作用相同，但只能维持短短数分钟。"
	button_icon = 'modular_z121/icon/custompell.dmi'
	button_icon_state = "summon_bedroll"
	sound = list('sound/magic/whiteflame.ogg')
	invocation_type = "whisper"
	invocations = list("宿具，显形。")
	item_type = /obj/item/bedroll/magic
	hold_drain = 0
	primary_resource_cost = 1
	charge_time = 0
	cooldown_time = 30 SECONDS
	cooldown_min = 0.5 SECONDS
	cast_range = -1
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	point_cost = 1
	spell_tier = 1
	associated_skill = /datum/skill/magic/arcane
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	miracle = FALSE

/datum/action/cooldown/spell/z121/targeted/conjure_item/summon_magic_bedroll/z121_apply(atom/cast_on)
	var/list/targets = list(cast_on)
	var/mob/user = owner
	if(!ishuman(user))
		z121_cancel()
		return FALSE
	for(var/mob/living/carbon/caster as anything in targets)
		var/obj/item/held_item = caster.get_active_held_item()
		if(held_item && !caster.dropItemToGround(held_item))
			continue

		var/obj/item/bedroll/magic/summoned_bedroll = make_item()
		// 显式确认物品确实进手，避免沿用父类无返回值 cast 导致成功施法被判成失败。
		if(!caster.put_in_hands(summoned_bedroll, TRUE))
			qdel(summoned_bedroll)
			continue
		return TRUE

	z121_cancel()
	return FALSE

/datum/action/cooldown/spell/z121/targeted/conjure_item/summon_magic_bedroll/make_item()
	var/obj/item/bedroll/magic/summoned_bedroll = new item_type
	// 每次施法都生成一只独立计时的魔法睡袋，卷起/展开时会继承剩余寿命。
	summoned_bedroll.set_magic_expiration(world.time + 3 MINUTES)
	summoned_bedroll.AddComponent(/datum/component/conjured_item)
	return summoned_bedroll
