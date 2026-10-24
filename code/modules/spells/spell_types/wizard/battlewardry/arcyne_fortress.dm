/datum/action/cooldown/spell/arcyne_fortress
	button_icon = 'icons/mob/actions/mage_battlewardry.dmi'
	name = "奥术堡垒"
	desc = "引导巨量奥术能量，在自身周围筑起一座 5x5 的箭矢结界要塞。\
	每段墙体阻挡外部射来的投射物，同时允许你与盟友自由向外射击。\
	要塞持续至冷却结束或墙体被摧毁。"
	button_icon_state = "arcyne_fortress"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_WARD
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_BATTLEWARDRY

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE

	invocations = list("奥术城塞，拔地而起！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 90 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/arcyne_fortress/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/center = get_turf(H)
	if(!center)
		return FALSE

	// 5x5 perimeter - outer ring at range 2 from caster
	var/list/perimeter_data = list() // list of list(turf, outward_dir)
	for(var/turf/T in range(2, center))
		var/dx = T.x - center.x
		var/dy = T.y - center.y
		if(abs(dx) != 2 && abs(dy) != 2)
			continue
		if(T.density)
			continue
		// Determine outward-facing direction based on which edge the tile is on
		var/outward_dir = 0
		if(abs(dx) == 2 && abs(dy) == 2)
			// Corners face diagonally outward
			outward_dir = get_dir(center, T)
		else if(abs(dx) == 2)
			// Left/right edges face east/west
			outward_dir = dx > 0 ? EAST : WEST
		else
			// Top/bottom edges face north/south
			outward_dir = dy > 0 ? NORTH : SOUTH
		perimeter_data += list(list(T, outward_dir))

	if(!length(perimeter_data))
		return FALSE

	H.visible_message(span_boldwarning("[H]引导一道庞大的结界铭文——空气中奥术能量噼啪作响！"), span_notice("我筑起奥术要塞！"))
	playsound(center, 'sound/magic/whiteflame.ogg', 80, TRUE, 5)

	for(var/list/entry in perimeter_data)
		var/turf/T = entry[1]
		var/outward_dir = entry[2]
		var/obj/structure/arrow_ward/wall = new(T, H, cooldown_time)
		wall.set_shield_dir(outward_dir)

	return TRUE
