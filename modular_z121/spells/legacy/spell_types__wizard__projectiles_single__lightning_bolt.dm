/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt
	name = "雷霆矢"
	desc = "射出一道雷霆电矢，灼烧目标，并使其在 6 秒内难以攻击 \
	且行动迟缓。\n 对头脑简单的生物伤害提高 100%。"
	clothes_req = FALSE
	overlay_state = "lightning"
	sound = 'sound/magic/lightning.ogg'
	range = 8
	projectile_type = /obj/projectile/magic/lightning
	releasedrain = 30
	chargedrain = 1
	chargetime = 15
	recharge_time = 15 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokelightning
	associated_skill = /datum/skill/magic/arcane
	glow_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_MEDIUM
	spell_tier = 2
	invocations = list("雷霆，迸发！")
	invocation_type = "shout"
	cost = 3
	xp_gain = TRUE
