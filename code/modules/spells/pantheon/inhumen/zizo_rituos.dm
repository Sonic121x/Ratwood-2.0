/datum/action/cooldown/spell/zizo
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	spell_color = GLOW_COLOR_ZIZO
	ignore_armor_penalty = TRUE
	attunement_school = null
	primary_resource_type = SPELL_COST_DEVOTION
	secondary_resource_type = SPELL_COST_STAMINA
	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	zizo_spell = TRUE
	spell_tier = 0
	point_cost = 0
	required_items = list(/obj/item/clothing/neck/roguetown/psicross)

///////////////////
// T3 - Rituos	//
///////////////////
// - Zizo's Lesser Work. A single painful ritual that grants the caster a choice:

// Progress: Arcyne knowledge (2 minor aspects, 4 utilities). No skeletonization. -- Kunai: I made this more distinctive from Undeath, now it also gives you some traits to give a better progress vibe.
// Unlife: Full skeletonization (minus head) + MOB_UNDEAD, grants bonechill and raise_deadite. -- Kunai: We already have raise_deadite, so it's a moot point to give them the Necromancer version of it. Just gave them bonemend and a few more traits to give the vibe of a 'half-lich'.
// Both paths grant undead language and TRAIT_ARCYNE. One-time use - cannot be cast again after completion.

//SOEP -- Undeath gets: miracle-raise undead, bone catacalysm + raise deadite + classic undeath traits. Offensive varient w/ silver weakness and stamina-control for functional immortality.
//SOEP -- Progress gets: rapid skill leveling, ability to consume lux into health and stamina, more utility points for casting. Defensive varient w/ focus on talent and assistance.

/datum/action/cooldown/spell/zizo/rituos
	name = "仪式术"
	desc = "践行齐佐的一项小功业——以一次痛苦的仪式撕开通向力量的道路。选择进步以获取奥术知识，或选择不死以拥抱亡灵之身。"
	fluff_desc = "这是秘会最神圣的齐佐小功业。舍弃软弱与凡俗生命，拥抱她为你安排的使命。信徒在痛苦中献出心智或血肉，让齐佐剥去凡人脆弱，塑成她升华的映像。有人放弃思想以换取禁忌知识，有人舍弃血肉以迎接不死的寂静。鲜有人能承受至她所期望的模样。恩赐消退时，信徒只会被告知一个真理：牺牲还不够。"
	button_icon_state = "rituos"
	charge_sound = 'sound/magic/chargingold.ogg'
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_NO_MOVE
	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_message = "<font color=red>齐佐！齐佐！齐佐！"
	charge_required = TRUE
	charge_time = 10 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	cooldown_time = 3 MINUTES
	primary_resource_cost = 100
	secondary_resource_cost = 100
	sound = 'sound/magic/swap.ogg'
	var/anti_spam

/datum/action/cooldown/spell/zizo/rituos/cast(atom/cast_on)
	. = ..()

	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/user = owner

	if(anti_spam)
		return TRUE

	anti_spam = TRUE

	var/path_choice = tgui_alert(user, "你要踏上小功业的哪条道路？", "小功业", list("进步", "亡生", "取消"))

	if(!path_choice || path_choice == "Cancel")
		reset_spell_cooldown()
		anti_spam = FALSE
		return TRUE

	if(user.stat != CONSCIOUS)
		return FALSE

	user.visible_message(span_boldwarning("[user]仰起[user.p_their()]的头，奥术能量在[user.p_their()]周身噼啪作响！"))
	user.grant_language(/datum/language/undead)

	if(!src.run_ritual_chant(user, path_choice))
		anti_spam = FALSE
		return TRUE

	ADD_TRAIT(user, TRAIT_ARCYNE, "[type]")

	if(user.mind?.has_antag_datum(/datum/antagonist/vampire))
		user.visible_message(span_boldwarning("[user]的祈祷没有得到回应！"))
		user.mind?.RemoveSpell(src)
		qdel(src)
		anti_spam = FALSE
		return TRUE

	switch(path_choice)
		if("进步")
			src.apply_progress_path(user)
		if("亡生")
			src.apply_unlife_path(user)

	user.mind?.RemoveSpell(src)
	qdel(src)
	anti_spam = FALSE
	return TRUE

/datum/action/cooldown/spell/zizo/rituos/proc/run_ritual_chant(mob/living/carbon/human/user, path_choice)
	var/list/chant_lines

	switch(path_choice)
		if("进步")
			chant_lines = list(
				",w 齐佐！齐佐！齐佐！赐我不受桎梏的洞见！",
				",w 剥去我的停滞与无知！",
				",w 打碎虚妄认知的锁链！",
				",w 让启示涌入这脆弱的心智！",
				",w 我献出心智，以成就祢的功业！",
			)

		if("亡生")
			chant_lines = list(
				",w 齐佐！齐佐！齐佐！剥去我骨上的血肉！",
				",w 除去凡俗生命的枷锁！",
				",w 让脆弱的凡躯不再阻碍使命！",
				",w 以死亡不朽的形貌重塑我！",
				",w 我献出这具躯壳，以成就祢的功业！",
			)

	for(var/i in 1 to length(chant_lines))
		user.say(chant_lines[i], forced = "spell", language = /datum/language/common)
		user.adjustBruteLoss(15)
		if(path_choice == "进步")
			user.emote(pick("whimper", "painmoan", "gag", "choke"))
		else
			user.emote(pick("painscream", "superagony", "paincrit", "choke"))
		if(i > 1)
			shake_camera(user, min(i * 2, 3), i)

		if(!do_after(user, 3 SECONDS, target = user))
			to_chat(user, span_warning("仪式崩溃了。齐佐移开了目光。"))
			return FALSE

	return TRUE

/datum/action/cooldown/spell/zizo/rituos/proc/apply_progress_path(mob/living/carbon/human/user)
	user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)

	if(user.mind)
		user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 6))
		new /obj/effect/temp_visual/zizorite(get_turf(user))
		ADD_TRAIT(user, TRAIT_STEELHEARTED, "[type]")
		ADD_TRAIT(user, TRAIT_JACKOFALLTRADES, "[type]")
		ADD_TRAIT(user, TRAIT_SELF_SUSTENANCE, "[type]")
		ADD_TRAIT(user, TRAIT_WARLOCK, "[type]")
		ADD_TRAIT(user, TRAIT_UNLYCKERABLE, "[type]")
		ADD_TRAIT(user, TRAIT_NOWW, "[type]")
		grant_poke_spell_zizo(user)

	user.visible_message(
		span_boldwarning("奥术符文烙上[user]的皮肤，闪着病态的光芒，随后隐入血肉！"),
		span_notice("小功业已成！奥术知识涌入我的心智——我能看见魔法本身的脉络！")
	)

	to_chat(user, span_purple("你完美完成了仪式。按理说，如今你该是一位真正的魔导师……然而……"))
	sleep(30)
	to_chat(user, "<i>……为何我仍只能浅尝奥术，难以理解更深之处？我究竟欠缺什么？</i>")

/datum/action/cooldown/spell/zizo/rituos/proc/apply_unlife_path(mob/living/carbon/human/user)

	user.mob_biotypes |= MOB_UNDEAD

	ADD_TRAIT(user, TRAIT_NOMOOD, "[type]")
	ADD_TRAIT(user, TRAIT_NOPAIN, "[type]")
	ADD_TRAIT(user, TRAIT_NOHUNGER, "[type]")
	ADD_TRAIT(user, TRAIT_NOBREATH, "[type]")
	ADD_TRAIT(user, TRAIT_TOXIMMUNE, "[type]")
	ADD_TRAIT(user, TRAIT_BLOODLOSS_IMMUNE, "[type]")
	ADD_TRAIT(user, TRAIT_LIMBATTACHMENT, "[type]")
	ADD_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, "[type]")
	ADD_TRAIT(user, TRAIT_SILVER_WEAK, "[type]")
	ADD_TRAIT(user, TRAIT_UNLYCKERABLE, "[type]")
	ADD_TRAIT(user, TRAIT_WARLOCK, "[type]")
	ADD_TRAIT(user, TRAIT_NOWW, "[type]")

	for(var/obj/item/bodypart/part in user.bodyparts)
		if(istype(part, /obj/item/bodypart/head))
			continue

		part.skeletonize(FALSE)
		user.update_body_parts()
		playsound(user.loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)
		new /obj/effect/temp_visual/zizorite(get_turf(user))
		sleep(15)

	var/obj/item/bodypart/torso = user.get_bodypart(BODY_ZONE_CHEST)
	playsound(user.loc, 'sound/misc/lava_death.ogg', 100, FALSE)
	torso?.skeletonize(FALSE)

	var/obj/item/organ/eyes/eyes = user.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(user,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(user)
	user.update_body_parts()

	user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)

	if(user.mind)
		user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4))
		user.mind.AddSpell(new /datum/action/cooldown/spell/bonechill)
		user.mind.AddSpell(new /datum/action/cooldown/spell/bonemend)
		grant_poke_spell_zizo(user)

	user.visible_message(
		span_boldwarning("[user]的血肉在死灵之焰中烧尽，露出白骨，被小功业吞噬！"),
		span_notice("小功业已成！我舍弃了血肉——连死亡本身也响应我的呼唤！")
	)

	to_chat(user, span_purple("你完美完成了仪式。如今你该是一位真正的巫妖……然而……"))
	sleep(30)
	to_chat(user, "<i>……凡俗的残迹仍依附着我……？为什么？</i>")
