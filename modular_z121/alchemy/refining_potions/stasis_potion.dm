// 停滞药水仅延缓生命值过低导致的死亡，伤害、流血和昏迷仍按原版结算。
/datum/reagent/stasis_potion
	name = "停滞药水"
	description = "灰青色的药液沉静得近乎凝固，轻晃瓶身，涟漪也迟迟不肯散去。饮下时，仿佛有一口未尽的呼吸，被留在了沙漏的两端之间。"
	reagent_state = LIQUID
	color = "#829b9c"
	alpha = 200
	taste_description = "久闭石室里的一缕凉意"
	// 正常代谢周期为两秒，每次消耗三分之一单位，即每单位六秒。
	metabolization_rate = REAGENTS_METABOLISM / 3

/datum/reagent/stasis_potion/on_mob_metabolize(mob/living/M)
	. = ..()
	if(!M || QDELETED(M) || M.stat == DEAD)
		return
	// 以试剂实例为来源，重复饮用不叠加特性，也不干扰其他不死来源。
	ADD_TRAIT(M, TRAIT_NODEATH, REF(src))

/datum/reagent/stasis_potion/on_mob_end_metabolize(mob/living/M)
	remove_stasis(M)
	return ..()

/datum/reagent/stasis_potion/on_mob_delete(mob/living/M)
	remove_stasis(M)
	return ..()

/datum/reagent/stasis_potion/proc/remove_stasis(mob/living/M)
	if(!M || QDELETED(M) || !HAS_TRAIT_FROM(M, TRAIT_NODEATH, REF(src)))
		return
	REMOVE_TRAIT(M, TRAIT_NODEATH, REF(src))
	// 药力散尽后立即按现有伤势重算状态，不治疗伤势，也不强制杀死尚能存活的饮用者。
	M.updatehealth()

// 沿用气化之躯的五点停滞空气气息，以普通耐力药水为底料。
/datum/alch_refining_formula/stasis_potion
	name = "停滞药水"
	required_scent = "停滞的空气"
	required_scent_points = 5
	required_base = list(/datum/reagent/water = 50, /datum/reagent/medicine/stampot = 50)
	output_reagents = list(/datum/reagent/stasis_potion = 30)
	skill_required = SKILL_LEVEL_EXPERT
	smells_like = "久闭石室中的凉意"
