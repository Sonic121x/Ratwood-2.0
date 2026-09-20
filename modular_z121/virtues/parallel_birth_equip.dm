// 保留原进阶职业装备顺序，只为明确的职业授予增加来源记录。
/datum/advclass/equipme(mob/living/carbon/human/H, dummy = FALSE)

	set waitfor = FALSE
	if(!H)
		return FALSE

	if(!dummy && z121_parallel_selected(H) && !H.z121_profession)
		H.z121_profession = new(H, src)
	if(!dummy && H.z121_profession && !H.z121_profession.profession)
		H.z121_profession.profession = src
	if(outfit)
		if(H.z121_profession)
			H.z121_profession.capturing_birth = !dummy
			if(!(outfit in z121_parallel_outfits()))
				H.z121_profession.unknown = TRUE
		H.equipOutfit(outfit, dummy)
		if(H.z121_profession)
			H.z121_profession.capturing_birth = FALSE

		if(dummy)
			return

	post_equip(H)

	H.advjob = name

	var/turf/TU = get_turf(H)
	if(TU)
		if(horse)
			new horse(TU)

	for(var/trait in traits_applied)
		if(trait in H.dna.species.banned_traits)
			continue
		H.z121_birth_trait(trait, ADVENTURER_TRAIT)
	if(H.client && (HAS_TRAIT(H, TRAIT_MEDIUMARMOR) || HAS_TRAIT(H, TRAIT_HEAVYARMOR)))
		H.def_intent_change(INTENT_PARRY)

	if(noble_income)
		var/already_has_income = (H in SStreasury.noble_incomes)
		SStreasury.noble_incomes[H] = noble_income
		SStreasury.grant_estate_income(H, noble_income, !already_has_income)

	if(adaptive_name)
		H.adaptive_name = TRUE

	if(length(subclass_languages))
		for(var/lang in subclass_languages)
			H.z121_birth_language(lang)

	if(length(subclass_stats))
		for(var/stat in subclass_stats)
			H.z121_birth_stat(stat, subclass_stats[stat])

	if(length(subclass_skills))
		for(var/skill in subclass_skills)
			H.z121_birth_skill_floor(skill, subclass_skills[skill], TRUE)

	if(length(subclass_stashed_items))
		if(!H.mind)
			return
		for(var/stashed_item in subclass_stashed_items)
			H.z121_birth_stash(stashed_item, subclass_stashed_items[stashed_item])
	if(subclass_spellpoints > 0)
		H.z121_birth_points(subclass_spellpoints)

	if(subclass_social_rank)
		H.social_rank = subclass_social_rank



	if(length(subclass_virtues))
		for(var/virtue in subclass_virtues)
			apply_virtue(H, new virtue)

	if(applies_post_equipment)
		if(H.dna?.species?.id == "gnoll")

			H.apply_gnoll_preferences(FALSE)
		else
			apply_character_post_equipment(H)
