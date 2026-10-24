/datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter
	name = "碎裂"
	desc = "蓄势后打击正前方直线，将被击中者向后抛出一格。造成 40 点切割伤害。\
		打击无法穿墙，但会重创沿途建筑。\
		动量达到 3 点时：消耗 3 点，使伤害翻倍。命中多个目标可积累动量。可被防御姿态偏转。"
	button_icon_state = "shatter"
	invocations = list("碎裂！")
	damage = 40
	empowered_mult = 2
	windup_time = TELEGRAPH_DODGEABLE
	sweep_step = 0
	push_dist = 1
	sound = null
	detonate_sound = null
	momentum_on_hit = 0
	momentum_on_surge = 1
	var/line_length = 3

/datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter/get_pattern_offsets()
	var/list/offsets = list()
	for(var/i in 1 to line_length)
		offsets += list(list(0, i))
	return offsets
