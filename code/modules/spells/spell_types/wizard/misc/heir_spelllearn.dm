/obj/effect/proc_holder/spell/self/heir_spell_bundle
	name = "回忆法术"
	desc = "允许你回忆一小组实用、攻击或辅助法术。"
	base_icon_state = "wisescroll"
	recharge_time = 25 MINUTES
	chargetime = 0
	chargedrain = 0
	range = 0
	associated_skill = /datum/skill/magic/arcane
	var/chosen_bundle
	var/list/utility_bundle = list(	//Fly! Well, sort of.
		/datum/action/cooldown/spell/leap,
		/datum/action/cooldown/spell/featherfall,
		/datum/action/cooldown/spell/mirror_transform
	)
	var/list/offensive_bundle = list(
		/datum/action/cooldown/spell/projectile/arcyne_lance
	)
	var/list/buff_bundle = list( //Support a knight, maybe. Or like, ERP harder without stamcritting.
		/datum/action/cooldown/spell/augment_buff/blood_rush,
		/datum/action/cooldown/spell/augment_buff/fortitude
	)
/obj/effect/proc_holder/spell/self/heir_spell_bundle/cast(list/targets, mob/user)
	. = ..()
	var/choice = chosen_bundle
	if(!chosen_bundle)
		choice = alert(user, "你一直在研习哪类法术？", "选择道路", "Utility", "Offense", "Support")
		chosen_bundle = choice
	switch(choice)
		if("Utility")
			add_spells(user, utility_bundle)
			user.mind?.RemoveSpell(src.type)
		if("Offense")
			add_spells(user, offensive_bundle)
			user.mind?.RemoveSpell(src.type)
		if("Support")
			add_spells(user, buff_bundle)
			user.mind?.RemoveSpell(src.type)
		else
			revert_cast()


/obj/effect/proc_holder/spell/self/heir_spell_bundle/proc/add_spells(mob/user, list/spells)
	for(var/spell_type in spells)
		if(user?.mind.has_spell(spells[spell_type]))
			spells.Remove(spell_type)
	for(var/spell_type in spells)
		var/datum/new_spell = new spell_type
		user?.mind.AddSpell(new_spell)
	if(!length(spells))
		user.mind?.RemoveSpell(src.type)
