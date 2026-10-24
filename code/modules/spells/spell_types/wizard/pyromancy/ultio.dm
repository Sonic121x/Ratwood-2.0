/datum/action/cooldown/spell/ultio
	button_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	name = "复仇之焰"
	expose_caster_on_deflect = FALSE
	desc = "施法者弹指或击掌。附近一处空气受火焰魔力激荡，自发燃起灼热烈焰，指向目标并烧灼范围内所有人。\n\
	火焰法术施加灼烧：达到 4 层时，会对瞄准的头部或胸部造成穿甲创伤；瞄准其他部位则在头胸之间随机选择。"
	fluff_desc = "复仇之焰由三个传统分别重创或改良，主要区别在于施法手势——\
	正统掌心弹指、弹指前掷与拉涅申击掌。掌心弹指是普通的弹响：在中指尖画出火之奥术圆环，\
	猛烈弹向掌心的另一圆环以点燃空气，起源于格伦泽霍夫。弹指前掷是\
	后来为精确控制距离而发展的变体，削弱指尖圆环、强化掌心圆环，再由\
	施法者将中指前甩指向目标，以施法时间换取传统。拉涅申击掌则使用双手，\
	合掌后推向目标，试图兼顾力量与精度。\n\
	随着法师用法杖辅助施法并回收能量，这些手势逐渐不再需要真实做出。如今，\
	大多数手势由杖尖的虚拟双手呈现；熟练施法者仍会在握杖时模仿部分动作，\
	以确保法术完全生效。\n\
	向敌人竖中指便能将其点燃的传说，正源自弹指前掷的传统。"
	button_icon_state = "ultio"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_PYROMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("复仇！")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = SPELL_COOLDOWN_POKE

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/impact_delay = TELEGRAPH_SKILLSHOT
	var/strike_damage = 65
	var/scorch_stacks = 2
	displayed_damage = 65

/datum/action/cooldown/spell/ultio/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	if(!(target_turf in get_hear(cast_range, get_turf(H))))
		to_chat(H, span_warning("我无法向看不见的地方施法！"))
		return FALSE

	new /obj/effect/temp_visual/telegraph/wall/fire/ultio(target_turf)
	addtimer(CALLBACK(src, PROC_REF(detonate), target_turf, H.zone_selected || BODY_ZONE_CHEST), impact_delay)
	return TRUE

/datum/action/cooldown/spell/ultio/proc/detonate(turf/target_turf, def_zone)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(target_turf))
		return
	var/mob/living/carbon/human/caster = owner
	playsound(target_turf, pick('sound/misc/explode/incendiary (1).ogg', 'sound/misc/explode/incendiary (2).ogg'), 100, TRUE, 4)
	new /obj/effect/temp_visual/spell_impact(target_turf, spell_color, spell_impact_intensity)
	new /obj/effect/temp_visual/dragonfire(target_turf)

	target_turf.fire_act()
	for(var/atom/A in target_turf)
		if(ismob(A))
			continue
		A.fire_act()

	for(var/mob/living/L in target_turf)
		if(L.anti_magic_check())
			L.visible_message(span_warning("火焰在[L]周围噗噗熄灭！"))
			playsound(target_turf, 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(spell_guard_check(L, TRUE))
			L.visible_message(span_warning("[L]抵住了火焰！"))
			continue
		if(istype(caster) && ishuman(L))
			if(arcyne_strike(caster, L, null, strike_damage, def_zone, BCLASS_BURN, spell_name = "复仇之焰", damage_type = BURN, skip_animation = TRUE) == ARCYNE_STRIKE_WARDED)
				continue
		else
			L.adjustFireLoss(strike_damage)
		apply_scorch_stack(L, scorch_stacks, def_zone)

/obj/effect/temp_visual/telegraph/wall/fire/ultio
	duration = TELEGRAPH_SKILLSHOT
