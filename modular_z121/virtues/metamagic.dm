/datum/virtue/utility/z121_metamagic
	triumph_cost = 8
	var/toggle_verb
	var/charge_multiplier = 1
	var/energy_multiplier = 1
	var/damage_multiplier = 1
	var/silent_cast = FALSE

/datum/virtue/utility/z121_metamagic/New()
	. = ..()
	if(toggle_verb)
		added_traits = list(name)

/datum/virtue/utility/z121_metamagic/quick
	name = "速发超魔"
	desc = "通过 IC 中的「速发超魔」开关。开启时，奥术引导时间变为原来的 0.8 倍，精力消耗变为 3 倍。"
	toggle_verb = /mob/living/carbon/human/proc/z121_toggle_quick_metamagic
	charge_multiplier = 0.8
	energy_multiplier = 3

/datum/virtue/utility/z121_metamagic/silent
	name = "默发超魔"
	desc = "通过 IC 中的「默发超魔」开关。开启时，施放奥术无需念出咒词，引导时间和精力消耗均变为原来的 2 倍。"
	toggle_verb = /mob/living/carbon/human/proc/z121_toggle_silent_metamagic
	charge_multiplier = 2
	energy_multiplier = 2
	silent_cast = TRUE

/datum/virtue/utility/z121_metamagic/empowered
	name = "强效超魔"
	desc = "通过 IC 中的「强效超魔」开关。开启时，奥术伤害变为原来的 1.5 倍，引导时间变为 1.2 倍，精力消耗变为 4 倍。"
	toggle_verb = /mob/living/carbon/human/proc/z121_toggle_empowered_metamagic
	charge_multiplier = 1.2
	energy_multiplier = 4
	damage_multiplier = 1.5

/datum/controller/subsystem/custom_bootstrap
	var/list/z121_metamagic_by_trait = list()

/datum/controller/subsystem/custom_bootstrap/proc/register_z121_metamagic()
	for(var/feat_type in subtypesof(/datum/virtue/utility/z121_metamagic))
		var/datum/virtue/utility/z121_metamagic/feat = GLOB.virtues[feat_type]
		z121_metamagic_by_trait[feat.name] = feat
		GLOB.roguetraits[feat.name] = initial(feat.desc)
	RegisterSignal(SSdcs, list(COMSIG_ATOM_ADD_TRAIT, COMSIG_ATOM_REMOVE_TRAIT), PROC_REF(on_z121_metamagic_trait_changed))

/datum/controller/subsystem/custom_bootstrap/proc/on_z121_metamagic_trait_changed(datum/source, mob/living/carbon/human/holder, trait)
	SIGNAL_HANDLER
	var/datum/virtue/utility/z121_metamagic/feat = z121_metamagic_by_trait[trait]
	if(!feat || !ishuman(holder))
		return
	if(HAS_TRAIT(holder, trait))
		holder.verbs |= feat.toggle_verb
		return
	holder.verbs -= feat.toggle_verb
	if(feat in holder.z121_active_metamagic)
		holder.z121_active_metamagic -= feat
		holder.z121_update_casting_factors()

/mob/living/carbon/human/proc/z121_toggle_quick_metamagic()
	set name = "速发超魔"
	set category = "IC"
	set hidden = FALSE
	z121_toggle_metamagic(/datum/virtue/utility/z121_metamagic/quick)

/mob/living/carbon/human/proc/z121_toggle_silent_metamagic()
	set name = "默发超魔"
	set category = "IC"
	set hidden = FALSE
	z121_toggle_metamagic(/datum/virtue/utility/z121_metamagic/silent)

/mob/living/carbon/human/proc/z121_toggle_empowered_metamagic()
	set name = "强效超魔"
	set category = "IC"
	set hidden = FALSE
	z121_toggle_metamagic(/datum/virtue/utility/z121_metamagic/empowered)

/mob/living/carbon/human/proc/z121_toggle_metamagic(feat_type)
	var/datum/virtue/utility/z121_metamagic/feat = GLOB.virtues[feat_type]
	if(!feat || !HAS_TRAIT(src, feat.name))
		return
	if(feat in z121_active_metamagic)
		z121_active_metamagic -= feat
		to_chat(src, span_notice("[feat.name]已关闭。"))
	else
		LAZYADD(z121_active_metamagic, feat)
		to_chat(src, span_notice("[feat.name]已开启。"))
	z121_update_casting_factors()

/mob/living
	/// 每具身体只记录已开启的美德；VV 字段始终保留管理员设置的基础值。
	var/list/z121_active_metamagic

/mob/living/proc/z121_effective_charge_multiplier()
	var/multiplier = z121_spell_charge_multiplier
	for(var/datum/virtue/utility/z121_metamagic/feat as anything in z121_active_metamagic)
		multiplier *= feat.charge_multiplier
	return multiplier

/mob/living/proc/z121_effective_cost_multiplier()
	var/multiplier = z121_spell_cost_multiplier
	for(var/datum/virtue/utility/z121_metamagic/feat as anything in z121_active_metamagic)
		multiplier *= feat.energy_multiplier
	return multiplier

/mob/living/proc/z121_effective_damage_multiplier()
	var/multiplier = z121_spell_damage_multiplier
	for(var/datum/virtue/utility/z121_metamagic/feat as anything in z121_active_metamagic)
		multiplier *= feat.damage_multiplier
	return multiplier

/mob/living/proc/z121_effective_silent_cast()
	if(z121_spell_silent_cast)
		return TRUE
	for(var/datum/virtue/utility/z121_metamagic/feat as anything in z121_active_metamagic)
		if(feat.silent_cast)
			return TRUE
	return FALSE
