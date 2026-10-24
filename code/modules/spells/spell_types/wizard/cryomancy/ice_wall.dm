#define ICEWALL_FROST_PASS_KEY "icewall_frost_pass"

/datum/action/cooldown/spell/forcewall/ice
	button_icon = 'icons/mob/actions/mage_cryomancy.dmi'
	name = "冰墙术"
	desc = "召出一道 5x1 的坚冰墙，阻挡所有射击与移动。\
	冰墙升起时，附近的人会沾染寒霜。持续 20 秒，或直到被击碎。"
	button_icon_state = "frost_blast"
	sound = 'sound/spellbooks/crystal.ogg'
	spell_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CRYOMANCY
	charge_swingdelay_type = SWINGDELAY_NORMAL
	telegraph_type = /obj/effect/temp_visual/telegraph/ice
	invocations = list("寒冰之墙！")

/datum/action/cooldown/spell/forcewall/ice/spawn_wall(turf/target, mob/caster)
	new /obj/structure/forcefield_weak/ice(target, caster)

/obj/structure/forcefield_weak/ice
	name = "冰墙"
	desc = "一块召唤而来的坚冰"
	icon = 'icons/effects/ice_wall.dmi'
	icon_state = "ice_cube"
	max_integrity = 120
	break_sound = 'sound/combat/fracture/fracturedry (1).ogg'

/obj/structure/forcefield_weak/ice/Initialize(mapload, mob/summoner)
	. = ..()
	frost_adjacent()

/obj/structure/forcefield_weak/ice/proc/frost_adjacent()
	for(var/mob/living/L in range(1, src))
		if(L == caster)
			continue
		if(L.mob_timers[ICEWALL_FROST_PASS_KEY] == world.time)
			continue
		L.mob_timers[ICEWALL_FROST_PASS_KEY] = world.time
		apply_frost_stack(L)

#undef ICEWALL_FROST_PASS_KEY
