// 保留正式岗位出生过程，在明确授予处记录能力及实际占用的名额。
/datum/job/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	// 本实现完整替代原出生过程；调用上一份实现会重复发放法术、资金与出生奖励。
	SHOULD_CALL_PARENT(FALSE)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_JOB_AFTER_SPAWN, src)

	if(job_traits)
		for(var/trait in job_traits)
			ADD_TRAIT(H, trait, JOB_TRAIT)
		if(H.client && (HAS_TRAIT(H, TRAIT_MEDIUMARMOR) || HAS_TRAIT(H, TRAIT_HEAVYARMOR)))
			H.def_intent_change(INTENT_PARRY)

	if(!ishuman(H))
		return

	var/mob/living/carbon/human/parallel_human = H
	if(!parallel_human.z121_profession && z121_parallel_selected(parallel_human, M?.client))
		parallel_human.z121_profession = new(parallel_human, null)
	var/datum/z121_profession_record/R = parallel_human.z121_profession
	if(R)
		R.formal_job = src
		R.job_slot_owned = TRUE
	if(spells && H.mind)
		for(var/S in spells)
			var/obj/effect/proc_holder/spell/granted = new S
			H.mind.AddSpell(granted)
			R?.remember_spell(granted)

	if(length(job_stats))
		for(var/stat in job_stats)
			if(R)
				R.add_stat(parallel_human, stat, job_stats[stat])
			else
				H.change_stat(stat, job_stats[stat])

	for(var/X in peopleknowme)
		for(var/datum/mind/MF in get_minds(X))
			if(isnull(H.mind?.special_role) && (MF?.special_role in list(ROLE_VAMPIRE, ROLE_NBEAST, ROLE_BANDIT, ROLE_LICH, ROLE_WRETCH, ROLE_UNBOUND_DEATHKNIGHT)))
				continue
			H.mind.person_knows_me(MF)
	for(var/X in peopleiknow)
		for(var/datum/mind/MF in get_minds(X))
			if(isnull(H.mind?.special_role) && (MF?.special_role in list(ROLE_VAMPIRE, ROLE_NBEAST, ROLE_BANDIT, ROLE_LICH, ROLE_WRETCH, ROLE_UNBOUND_DEATHKNIGHT)))
				continue
			H.mind.i_know_person(MF)


	if(!H.islatejoin)
		H.adjust_triumphs(1)
		H.apply_status_effect(/datum/status_effect/buff/mealbuff)
		H.hydration = 1000

		if(H.mind)
			H.mind?.special_items["Pouch of Coins"] = /obj/item/storage/belt/rogue/pouch/coins/readyuppouch
			if (HAS_TRAIT(H, TRAIT_MEDIUMARMOR) || HAS_TRAIT(H, TRAIT_HEAVYARMOR))
				H.mind?.special_items["Metal Scrap (Repair kit)"] = /obj/item/repair_kit/metal/bad
			else
				H.mind?.special_items["Fabric Patch (Repair kit)"] = /obj/item/repair_kit/bad
		to_chat(M, span_notice("Rising early, you made sure to pack a pouch of coins in your stash and eat a hearty breakfast before starting your day. A true TRIUMPH!"))

	if(HAS_TRAIT(H, TRAIT_EXPLOSIVE_SUPPLY))
		H.mind.has_bomb = TRUE
		to_chat(H.mind, span_smallnotice("I need to check on HERMES. I think a new package has arrived."))

	if(HAS_TRAIT(H, TRAIT_DRUG_SUPPLY))
		H.mind.has_drug_delivery = TRUE
		to_chat(H.mind, span_smallnotice("The Guild left something for me. I should check HERMES for my delivery."))

	if(H.islatejoin && announce_latejoin)
		var/used_title = display_title || title
		if((H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F) && f_title)
			used_title = f_title
		scom_announce("[H.real_name] the [used_title] arrives from Kingsfield.")

	if(give_bank_account)
		if(give_bank_account > 1)
			SStreasury.create_bank_account(H, give_bank_account)
		else
			SStreasury.create_bank_account(H)
		if(noble_income)
			SStreasury.noble_incomes[H] = noble_income
			SStreasury.grant_estate_income(H, noble_income, TRUE)

	if(show_in_credits)
		SScrediticons.processing += H

	if(cmode_music)
		H.cmode_music = cmode_music

	if(social_rank)
		H.social_rank = social_rank
	if(istype(H, /mob/living/carbon/human))
		var/mob/living/carbon/human/Hu = H
		if(Hu.familytree_pref != FAMILY_NONE && !Hu.family_datum)
			addtimer(CALLBACK(SSfamilytree, TYPE_PROC_REF(/datum/controller/subsystem/familytree, AddLocal), H, Hu.familytree_pref), 5 SECONDS)

	var/department = SSjob.bitflag_to_department(department_flag, obsfuscated_job)
	if (!hidden_job)
		var/mob/living/carbon/human/Hu = H
		if (istype(H, /mob/living/carbon/human))
			if (obsfuscated_job)
				GLOB.actors_list["Wanderers"] += list("[H.mobid]" = "[H.real_name] as the [Hu.dna.species.name] Adventurer<BR>")
			else
				GLOB.actors_list[department] += list("[H.mobid]" = "[H.real_name] as the [Hu.dna.species.name] [H.mind.assigned_role]<BR>")
		else
			if (obsfuscated_job)
				GLOB.actors_list["Wanderers"] += list("[H.mobid]" = "[H.real_name] as Adventurer<BR>")
			else
				GLOB.actors_list[department] += list("[H.mobid]" = "[H.real_name] as [H.mind.assigned_role]<BR>")

	if(islist(advclass_cat_rolls))
		hugboxify_for_class_selection(H)

	log_admin("[department] >> [H.key]/([H.real_name]) has joined as [H.mind.assigned_role].")

/datum/controller/subsystem/role_class_handler/finish_class_handler(mob/living/carbon/human/H, datum/advclass/picked_class, datum/class_select_handler/related_handler, plus_factor, special_session_queue)
	if(!picked_class || !related_handler || !H)
		return FALSE
	if(!(picked_class.maximum_possible_slots == -1))
		if(picked_class.total_slots_occupied >= picked_class.maximum_possible_slots)
			related_handler.rolled_class_is_full(picked_class)
			return FALSE


	H.advsetup = FALSE
	picked_class.equipme(H)
	H.invisibility = 0
	var/atom/movable/screen/advsetup/GET_IT_OUT = locate() in H.hud_used.static_inventory
	qdel(GET_IT_OUT)
	H.cure_blind("advsetup")


	if(plus_factor)
		picked_class.boost_by_plus_power(plus_factor, H)

	if(related_handler.register_id)
		add_class_register_msg(related_handler.register_id, "[H.real_name] is the [picked_class.name]", related_handler.linked_client.mob)




	related_handler.ForceCloseMenus()


	class_select_handlers.Remove(related_handler.linked_client.ckey)

	qdel(related_handler)

	adjust_class_amount(picked_class, 1)



	if(H.z121_profession)
		H.z121_profession.profession = picked_class
		H.z121_profession.class_slot_owned = TRUE
