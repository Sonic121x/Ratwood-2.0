
/datum/action/cooldown/spell/minion_order/conjurer
	name = "命令仆从"
	desc = "向 12 格内的召唤仆从，包括原初元素体、勇士等下达命令。<br>\
	<br>\
	对地面施放：命令它们前往那里。<br>\
	对自己施放：召回它们，并设为仅反击。<br>\
	对敌人施放：命令它们攻击该目标。<br>\
	对自己的仆从施放：在仅反击与攻击所有陌生人之间切换姿态。"
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	button_icon_state = "order_servants"
	spell_color = GLOW_COLOR_ARCANE
	associated_skill = /datum/skill/magic/arcane
	zizo_spell = FALSE

/datum/action/cooldown/spell/minion_mark
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	name = "召唤者印记"
	desc = "对某人施放，为其赋予让召唤仆从视为友军的印记，或移除已有印记。"
	button_icon_state = "primordial_mark"
	sound = null
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CONJURATION

	click_to_activate = TRUE
	cast_range = 7
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_NONE
	charge_required = FALSE
	cooldown_time = 1 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_NONE
	point_cost = 0

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/minion_mark/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE
	var/faction_tag = "[user.mind.current.real_name]_faction"
	if(isliving(cast_on))
		var/mob/living/target = cast_on
		if(target == user)
			to_chat(user, span_warning("让自己的召唤仆从与你为敌并不明智。"))
			return FALSE
		if(HAS_TRAIT(target, TRAIT_CONJURED_SUMMON))
			to_chat(user, span_warning("[target]已与另一位召唤者绑定。"))
			return FALSE
		if(target.mind && target.mind.current)
			if(faction_tag in target.mind.current.faction)
				target.mind.current.faction -= faction_tag
				user.say("宣告汝为敌。", language = /datum/language/common)
				target.notify_faction_change()
			else
				target.mind.current.faction += faction_tag
				user.say("宣告汝为友。", language = /datum/language/common)
				target.notify_faction_change()
		else if(istype(target, /mob/living/simple_animal))
			if(faction_tag in target.faction)
				target.faction -= faction_tag
				user.say("宣告汝为敌。", language = /datum/language/common)
				target.notify_faction_change()
			else
				target.faction |= faction_tag
				user.say("宣告汝为友。", language = /datum/language/common)
				target.notify_faction_change()
		return TRUE
	return FALSE

/datum/action/cooldown/spell/conjure_recall
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	button_icon_state = "order_servants"
	name = "召回仆从"
	desc = "无论召唤仆从走到哪里，都经由地脉拉回你身边——甚至能跨楼层或越过附身躯壳的牵系范围。"
	sound = 'sound/magic/magnet.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CONJURATION

	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_NONE
	point_cost = 0

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_MIND

/datum/action/cooldown/spell/conjure_recall/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return
	var/mob/living/user = owner
	if(!istype(user) || !length(user.summoned_minions))
		if(feedback)
			owner.balloon_alert(owner, "没有可召回的仆从！")
		return FALSE

/datum/action/cooldown/spell/conjure_recall/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE
	var/turf/center = get_turf(user)
	if(!center)
		return FALSE
	var/list/landing_turfs = list()
	for(var/turf/T in range(2, center))
		if(!isopenturf(T) || istype(T, /turf/open/transparent/openspace))
			continue
		if(T.is_transition_turf() || T.is_blocked_turf(exclude_mobs = TRUE))
			continue
		landing_turfs += T
	var/count = 0
	for(var/mob/living/M in user.summoned_minions.Copy())
		if(QDELETED(M) || M.stat == DEAD || M == user)
			continue
		var/turf/landing = length(landing_turfs) ? pick(landing_turfs) : center
		if(do_teleport(M, landing, precision = 0, channel = TELEPORT_CHANNEL_MAGIC, forced = TRUE))
			count++
	if(!count)
		to_chat(user, span_warning("没有仆从响应我的牵引。"))
		reset_spell_cooldown()
		return FALSE
	to_chat(user, span_notice("我拉紧地脉，将仆从拖回身边。"))
	playsound(user, 'sound/magic/magnet.ogg', 60, TRUE)
	return TRUE
