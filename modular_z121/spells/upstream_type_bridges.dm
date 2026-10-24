// 上游怪物、陷阱与神术仍引用这些辅助类型；这里只提供最小实现，不恢复旧法术动作。
/obj/effect/temp_visual/trap
	parent_type = /obj/effect/temp_visual/telegraph

/obj/projectile/magic/aoe/fireball/rogue/great
	parent_type = /obj/projectile/magic/aoe/fireball/rogue/artillery
	damage = 90
	npc_simple_damage_mult = 2

// 保留旧陷阱与怪物的酸液投射物参数，持续腐蚀使用模块自己的状态。
/obj/projectile/magic/acidsplash
	name = "酸泡"
	icon_state = "green_laser"
	damage = 15
	damage_type = BURN
	flag = "fire"
	range = 15
	speed = 1

/obj/projectile/magic/acidsplash/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(. == BULLET_ACT_BLOCK)
		return
	var/turf/center = get_turf(target)
	if(!center)
		return
	playsound(center, 'sound/misc/drink_blood.ogg', 100)
	for(var/mob/living/L in range(1, center))
		if(L.anti_magic_check() || (L.status_flags & GODMODE))
			continue
		L.apply_status_effect(/datum/status_effect/debuff/z121_acid_residue)

/datum/status_effect/debuff/z121_acid_residue
	id = "z121_acid_residue"
	duration = 20 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/z121_acid_residue

/datum/status_effect/debuff/z121_acid_residue/tick()
	if(!(owner.status_flags & GODMODE))
		owner.adjustFireLoss(5)

/atom/movable/screen/alert/status_effect/z121_acid_residue
	name = "酸蚀灼伤"
	desc = "残留的酸液正在灼烧我的皮肤。"
	icon_state = "debuff"
