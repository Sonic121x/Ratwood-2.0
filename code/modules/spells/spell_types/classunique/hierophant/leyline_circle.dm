// HIEROPHANT UNIQUE SPELL - LEY LINES
// On use, create a tile that will disable your Parry/Dodge, but grant you capped INT. 
// This is only active while you are standing on said tile.
// Lasts 30 seconds.
// If Combat Mode is off, this will instead restore your Energy.

/datum/action/cooldown/spell/ley_lines
	source_aspect = /datum/magic_aspect/pseudo/hierophant
	name = "地脉法阵"
	desc = "创造一圈奥术能量。站在其中会大幅增强施法能力，提高智力并缩短法术冷却。若不处于战斗模式，地脉法阵则会迅速恢复能量。<br><br>站在地脉法阵内时，你无法防御。<br><br>同时获得一个能迅速返回地脉法阵的法术。"
	fluff_desc = "『不！我的地脉法阵！』大祭司只要被拖离精心布置的能量枢纽一寸，便常会如此哀嚎。在法阵内，奥术公式信手拈来，魔力丝线在心眼前舒展，复杂施法如自动锻机般精准流畅。踏出之后，现实又变得恼人地平庸。多数魔导师严厉警告这种感觉会令人上瘾，甚至危险。大祭司却将其当作建议。"
	button_icon_state = "rune2"
	charge_sound = 'sound/magic/chargingold.ogg'
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_NO_MOVE
	click_to_activate = FALSE
	self_cast_possible = TRUE
	invocations = list("开辟！联结！立定！")
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 1.5 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	cooldown_time = 3 MINUTES
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = 25
	secondary_resource_type = SPELL_COST_ENERGY
	secondary_resource_cost = 100
	sound = 'sound/magic/swap.ogg'
	var/obj/structure/leyline_circle/active_circle

/datum/action/cooldown/spell/ley_lines/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!H)
		return FALSE
	if(active_circle && !QDELETED(active_circle))
		qdel(active_circle)
	active_circle = new(get_turf(H), H, src)
	to_chat(H, span_blue("奥术符印在你脚下蔓延，连成与地脉相通的复杂网络。"))
	StartCooldown()
	return TRUE

/datum/action/cooldown/spell/ley_lines/proc/on_circle_removed()
	active_circle = null

/datum/action/cooldown/spell/between_the_lines
	source_aspect = /datum/magic_aspect/pseudo/hierophant
	name = "归于地脉"
	desc = "立刻返回你的地脉法阵，你这个瘾君子。"
	fluff_desc = "『归于地脉』是记载中最古老的大祭司法术之一，据说源于一个简单问题：离开地脉法阵的每一刻，都是远离完美的一刻。最初的大祭司不愿忍受走回去的屈辱，便扭曲空间，让自己一步不迈便可重返地脉法阵那令人沉醉的清明。"
	button_icon_state = "rune3"
	cooldown_time = 15 SECONDS
	charge_required = FALSE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_NO_MOVE
	click_to_activate = FALSE
	self_cast_possible = TRUE
	invocation_type = INVOCATION_SHOUT
	invocations = list("折转！归返！显现！")
	var/obj/structure/leyline_circle/linked_circle
	var/max_range = 9

/datum/action/cooldown/spell/between_the_lines/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!user)
		return FALSE
	if(!linked_circle || QDELETED(linked_circle))
		return FALSE
	if(get_dist(user, linked_circle) > max_range)
		user.balloon_alert(user, "太远了！啊！我的地脉法阵！！")
		return FALSE
	var/turf/T = get_turf(linked_circle)
	if(!T)
		return FALSE
	do_teleport(user, T, channel = TELEPORT_CHANNEL_MAGIC)
	playsound(T, 'sound/magic/blink.ogg', 50, TRUE)
	return TRUE

/obj/effect/leyline_ring
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = BELOW_OBJ_LAYER

/datum/status_effect/buff/circle_of_power
	id = "circle_of_power"
	duration = -1
	tick_interval = 0.5 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/buff/circle_of_power
	effectedstats = list(STATKEY_INT = 4)
	var/obj/structure/leyline_circle/source_circle

/datum/status_effect/buff/circle_of_power/on_apply()
	. = ..()
	if(owner)
		owner.balloon_alert_to_viewers("无法招架或闪避！", "魔法加速！无法招架或闪避！")
		ADD_TRAIT(owner, TRAIT_NODEF, "[id]")
		ADD_TRAIT(owner, TRAIT_LEYLINE_HASTE, "[id]")

/datum/status_effect/buff/circle_of_power/on_remove()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_NODEF, "[id]")
		REMOVE_TRAIT(owner, TRAIT_LEYLINE_HASTE, "[id]")
	. = ..()

/datum/status_effect/buff/circle_of_power/tick()
	. = ..()
	if(QDELETED(owner))
		qdel(src)
		return
	if(!source_circle || QDELETED(source_circle))
		qdel(src)
		return
	if(get_turf(owner) != get_turf(source_circle))
		qdel(src)
		return

/atom/movable/screen/alert/status_effect/buff/circle_of_power
	name = "力量法阵"
	desc = "相连的地脉大幅增强了我的奥术能力！"
	icon_state = "circle_of_power"

/obj/effect/phantom_leyline
	name = "幻影地脉"
	icon = 'icons/effects/32x64.dmi'
	icon_state = "leylinestable"
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 180

/obj/structure/leyline_circle
	name = "地脉法阵"
	desc = "一道编织于大地之上的奥术法阵。"
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "astrata_chalky"
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/mob/living/owner
	var/datum/mind/owner_mind
	var/datum/action/cooldown/spell/ley_lines/parent_spell
	var/list/phantom_leylines = list()
	var/list/active_beams = list()
	var/obj/effect/leyline_ring/ring_a
	var/obj/effect/leyline_ring/ring_b

/obj/structure/leyline_circle/Initialize(mapload, mob/living/user, datum/action/cooldown/spell/ley_lines/spell)
	. = ..()
	owner = user
	owner_mind = user?.mind
	parent_spell = spell
	if(owner_mind)
		var/datum/action/cooldown/spell/between_the_lines/BTL = new
		BTL.linked_circle = src
		owner_mind.AddSpell(BTL)
	ring_a = new(loc)
	ring_b = new(loc)
	ring_a.icon = icon
	ring_b.icon = icon
	ring_a.icon_state = icon_state
	ring_b.icon_state = icon_state
	ring_a.layer = layer + 0.1
	ring_b.layer = layer + 0.2
	ring_a.alpha = 110
	ring_b.alpha = 110
	ring_a.color = "#66AAFF"
	ring_b.color = "#CC88FF"
	ring_a.transform = matrix(1.8, 0, 0, 0.4, 0, 0)
	ring_b.transform = matrix(0.4, 0, 0, 1.8, 0, 0)
	animate(ring_a, transform = matrix(1.8, 0, 0, 0.4, 0, 0).Turn(360), time = 10 SECONDS, loop = -1)
	animate(ring_b, transform = matrix(0.4, 0, 0, 1.8, 0, 0).Turn(-360), time = 13 SECONDS, loop = -1)
	spawn_phantom_leylines()
	START_PROCESSING(SSobj, src)
	QDEL_IN(src, 30 SECONDS)

/obj/structure/leyline_circle/process()
	if(QDELETED(owner))
		qdel(src)
		return
	if(get_turf(owner) == get_turf(src))
		if(!owner.has_status_effect(/datum/status_effect/buff/circle_of_power))
			var/datum/status_effect/buff/circle_of_power/B = owner.apply_status_effect(/datum/status_effect/buff/circle_of_power)
			if(B)
				B.source_circle = src
		if(!length(active_beams))
			create_beams()
	else
		clear_beams()

/obj/structure/leyline_circle/proc/create_beams()
	clear_beams()
	for(var/obj/effect/phantom_leyline/L in phantom_leylines)
		if(QDELETED(L))
			continue
		var/datum/beam/B = L.Beam(owner, icon_state = "medbeam", time = 35 SECONDS, maxdistance = 10)
		if(B)
			active_beams += B

/obj/structure/leyline_circle/proc/clear_beams()
	if(!length(active_beams))
		return
	for(var/datum/beam/B in active_beams)
		if(!QDELETED(B))
			qdel(B)
	active_beams.Cut()

/obj/structure/leyline_circle/proc/spawn_phantom_leylines()
	var/turf/T = get_turf(src)
	if(!T)
		return
	var/list/offsets = list(list(2, 2), list(-2, 2), list(2, -2), list(-2, -2))
	for(var/list/O in offsets)
		var/turf/target = locate(T.x + O[1], T.y + O[2], T.z)
		if(!target)
			continue
		var/obj/effect/phantom_leyline/L = new(target)
		phantom_leylines += L

/obj/structure/leyline_circle/Destroy()
	STOP_PROCESSING(SSobj, src)
	clear_beams()
	if(owner)
		owner.remove_status_effect(/datum/status_effect/buff/circle_of_power)
	if(owner_mind)
		for(var/datum/action/cooldown/spell/between_the_lines/BTL in owner_mind.spell_list)
			if(BTL.linked_circle == src)
				owner_mind.RemoveSpell(BTL)
				break
	for(var/obj/effect/phantom_leyline/L in phantom_leylines)
		if(!QDELETED(L))
			qdel(L)
	phantom_leylines.Cut()
	if(ring_a)
		qdel(ring_a)
	if(ring_b)
		qdel(ring_b)
	if(parent_spell)
		parent_spell.on_circle_removed()
	return ..()
