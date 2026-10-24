/datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor
	name = "震颤"
	desc = "大地回应。蓄势后令周围一圈地面爆发，将所有邻近者向后抛出一格。蓄势期间圆环随你移动，伤害类型随武器而定。\
		命中积累 1 点动量。动量达到 3 点时：消耗 3 点，使伤害翻倍。可被防御姿态偏转。"
	button_icon_state = "tremor"
	sound = null
	invocations = list("震颤！")
	damage = 30
	empowered_mult = 2
	sweep_step = 0
	push_dist = 1
	detonate_sound = null
	momentum_on_hit = 1
	momentum_on_surge = 1

/datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor/get_pattern_offsets()
	return list(
		list(-1, -1), list(0, -1), list(1, -1),
		list(-1, 0), list(1, 0),
		list(-1, 1), list(0, 1), list(1, 1),
	)

/datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor/on_impact(mob/living/carbon/human/H, facing, atom/movable/visual)
	. = ..()
	var/obj/item/weapon = get_strike_weapon(H)
	if(blade_class == BCLASS_BLUNT)
		H.visible_message(span_danger("[H]将[weapon ? "\the [weapon.name]" : "重击"]砸向地面，震波向外扩散！"))
	else
		H.visible_message(span_danger("[H]以[weapon ? "\the [weapon.name]" : "低扫"]贴地横扫，收割[H.p_them()]周围的一切！"))
