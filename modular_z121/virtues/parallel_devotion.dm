// 神迹在明确的授予入口按来源登记，解绑后析构不能访问旧宿主。
/datum/devotion/try_add_spells(silent = FALSE)
	if(!holder?.mind || !patron)
		return FALSE
	if(_is_clergy_radical(holder))
		return FALSE
	if(suppress_grants)
		return FALSE
	if(patron)
		if(length(patron.miracles))
			for(var/spell_type in patron.miracles)
				var/required_tier = patron.miracles[spell_type]
				if(required_tier <= level)
					if(holder.mind.has_spell(spell_type))
						continue

					var/obj/effect/proc_holder/spell/newspell = new spell_type
					if(istype(patron, /datum/patron/divine/xylix) && newspell.miracle)
						newspell.mute_allowed = TRUE
					if(!silent)
						to_chat(holder, span_boldnotice("I have unlocked a new spell: [newspell]"))
					holder.mind.AddSpell(newspell, holder)
					holder.z121_profession?.remember_miracle(src, newspell, required_tier)
					LAZYADD(granted_spells, newspell)

		if(length(patron.traits_tier))
			for(var/trait in patron.traits_tier)
				var/required_tier = patron.traits_tier[trait]
				if(required_tier <= level)
					if(!silent)
						to_chat(holder, span_boldnotice("I have unlocked a new trait: [trait]"))
					if(holder.z121_profession?.owns_miracle_tier(src, required_tier))
						holder.z121_profession.add_trait(holder, trait)
					else
						ADD_TRAIT(holder, trait, TRAIT_MIRACLE)








/datum/devotion/Destroy(force)
	. = ..()
	if(holder && (patron?.type == /datum/patron/inhumen/zizo || patron?.type == /datum/patron/divine/necra))
		REMOVE_TRAIT(holder, TRAIT_DEATHSIGHT, "devotion")
	holder?.hud_used?.shutdown_bloodpool()
	holder?.devotion = null
	holder = null
	patron = null
	granted_spells = null
	STOP_PROCESSING(SSobj, src)
