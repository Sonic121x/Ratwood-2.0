/datum/action/cooldown/spell/conjure_summon/primordial
	name = "唤生元初灵"
	desc = "召唤原初元素体并肩作战。选中法术时用 Shift+G 切换火、水、风元素。\
	它的力量随你的奥术武装技能提升，在专家与大师级分别进阶。\
	可召唤三种原初元素体：\n\
	- 火：生命与伤害适中，能向前方喷吐灼热火焰。\n\
	- 水：行动缓慢、生命较高，能淹没地面以阻滞敌人。\n\
	- 风：行动迅速、近战伤害最高、生命最低，能用疾风击退并减速目标。"
	button_icon_state = "primetriangle"
	invocations = list("原初之灵，现身！")
	summon_noun = "原初元素体"
	recoil_energy_floor = 150
	modes = list(
		list("name" = "烈焰", "tag" = "火", "path" = /mob/living/simple_animal/hostile/retaliate/rogue/primordial/fire, "color" = GLOW_COLOR_FIRE, "invocation" = "烈火，升腾！"),
		list("name" = "流水", "tag" = "水", "path" = /mob/living/simple_animal/hostile/retaliate/rogue/primordial/water, "color" = GLOW_COLOR_ICE, "invocation" = "波涛，涌起！"),
		list("name" = "疾风", "tag" = "风", "path" = /mob/living/simple_animal/hostile/retaliate/rogue/primordial/air, "color" = "#cfe8ff", "invocation" = "疾风，呼啸！"),
	)

/datum/action/cooldown/spell/conjure_summon/primordial/spawn_summon(turf/T, mob/living/user)
	var/mob_path = modes[current_mode]["path"]
	var/mob/living/simple_animal/hostile/retaliate/rogue/primordial/conjured = new mob_path(T, user)
	scale_primordial(conjured, user)
	return conjured

/datum/action/cooldown/spell/conjure_summon/primordial/proc/scale_primordial(mob/living/simple_animal/hostile/retaliate/rogue/primordial/P, mob/living/user)
	var/tier = get_summon_tier(user)
	var/mult = 1 + (tier - 1) * 0.2
	P.maxHealth = round(P.maxHealth * mult)
	P.health = P.maxHealth
	P.melee_damage_lower = round(P.melee_damage_lower * mult)
	P.melee_damage_upper = round(P.melee_damage_upper * mult)
