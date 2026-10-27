//==============================================================================
// Blessed Druid Armor
//==============================================================================

/obj/item/clothing/suit/roguetown/armor/leather/druid/blessed
	name = "受祝福的德鲁伊护甲"
	desc = "经树父仪式祝圣的德鲁伊护甲。树皮泛着微弱的生命之光，仿佛整片森林都在守望着穿戴它的人。"
	armor = ARMOR_BLACKOAK
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	color = "#73c47a"

/obj/item/clothing/suit/roguetown/armor/leather/druid/blessed/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("druid_blessed_glow", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))

/obj/item/clothing/suit/roguetown/armor/leather/druid/blessed/pickup(mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user))
		return
	if(user.patron?.type == /datum/patron/divine/dendor)
		return
	user.electrocute_act(30, src)
	user.mob_timers["kneestinger"] = world.time
	to_chat(user, span_warning("[name]排斥了我的触碰，唯有树父的虔诚信徒才有资格承载这份赠礼！"))

//==============================================================================
// Sanctified Tree Data Datum
//==============================================================================

/// Tracks per-tree ritual state, aura flags, and the per-player soulbind registry.
/datum/sanctified_tree_data
	/// Back-reference to the owning sanctified tree.
	var/obj/structure/flora/roguetree/wise/sanctified/tree
	/// Once-per-tree ritual completion flags.
	var/list/rituals_completed = list()
	/// Per-player soulbind registry: list of ckey strings.
	var/list/soulbound_players = list()
	/// Ckey of the player who just completed soulbound offerings and must now bleed to confirm.
	var/awaiting_soulbind_ckey

	// ---- Ritual state -------------------------------------------------------
	/// Currently active ritual category string, or null if none.
	var/datum/druid_ritual/active_ritual
	/// Armor held for nature's temper. Stored inside the tree until completion.
	var/obj/item/ritual_armor

	// ---- Aura state ---------------------------------------------------------
	/// TRUE once Treefather's Bulwark is completed.
	var/has_slow_aura = FALSE
	/// TRUE once Living Light is completed.
	var/has_heal_aura = FALSE
	/// Mobs currently slowed by the bulwark aura. Tracked for cleanup.
	var/list/slowed_mobs = list()
	/// dt accumulator for slow-aura 5-second ticks.
	var/slow_aura_elapsed = 0
	/// dt accumulator for heal-aura 60-second ticks.
	var/heal_aura_elapsed = 0
	/// Per-player middle-click heal cooldown: ckey -> world.time threshold (5 seconds after heal wears off).
	var/list/heal_player_cooldowns = list()

	// ---- Wedding ceremony state ------------------------------------------
	/// TRUE while an eoran bud has been offered and the tree awaits a bitten apple.
	var/wedding_active = FALSE
	/// Ckey of the player who offered the eoran bud to start the ceremony.
	var/wedding_officiant_ckey

/datum/sanctified_tree_data/New(obj/structure/flora/roguetree/wise/sanctified/owner)
	..()
	tree = owner

//==============================================================================
// Sanctified Tree
//==============================================================================
/obj/structure/flora/roguetree/wise/sanctified
	name = "圣化之树"
	desc = "一棵由树父祝圣的伟大树木。它的树皮泛着微光，周围空气回荡着原始的神圣气息。这里是德鲁伊力量的枢纽。"
	examine_plays_music = FALSE
	pixel_x = -11
	/// Base max_integrity before nearby-tree bonus.
	max_integrity = 400
	/// Disable wise-tree autonomous retaliation. The sanctified tree
	/// cooperates with its druid warden rather than lashing out autonomously.
	activated = FALSE
	// Blessed log is spawned manually in obj_destruction — suppress the inherited plain log drop.
	static_debris = list()

	/// Datum holding ritual completion flags and the soulbind registry.
	var/datum/sanctified_tree_data/tree_data
	/// If FALSE (for sanctified_wise trees), hides ritual and wedding hints in examine.
	var/show_ritual_hints = TRUE
	/// Current max_integrity bonus from nearby living trees.
	var/integrity_bonus = 0
	/// SSprocessing dt accumulator — recalculates bonus every 60 seconds.
	var/bonus_check_elapsed = 0
	/// SSprocessing dt accumulator — restores integrity periodically.
	var/integrity_regen_elapsed = 0

/obj/structure/flora/roguetree/wise/sanctified/Initialize(mapload)
	. = ..()
	tree_data = new /datum/sanctified_tree_data(src)
	set_light(3, 3, 3, l_color = "#FFD700")
	START_PROCESSING(SSprocessing, src)
	recalculate_integrity_bonus()

/obj/structure/flora/roguetree/wise/sanctified/Destroy()
	remove_filter("sanctified_outline")
	STOP_PROCESSING(SSprocessing, src)
	if(tree_data)
		// Notify and debuff any soulbound players before clearing data.
		if(length(tree_data.soulbound_players))
			curse_soulbound_players()
		// Clean up aura slow on destroy.
		for(var/mob/living/slowed_mob in tree_data.slowed_mobs)
			if(!QDELETED(slowed_mob))
				slowed_mob.remove_status_effect(/datum/status_effect/debuff/sanctified_tree_slow)
		tree_data.slowed_mobs = list()
		// Return any stored ritual armor to the ground.
		if(tree_data.ritual_armor && !QDELETED(tree_data.ritual_armor))
			tree_data.ritual_armor.forceMove(get_turf(src))
			tree_data.ritual_armor = null
		qdel(tree_data)
		tree_data = null
	return ..()

/obj/structure/flora/roguetree/wise/sanctified/obj_destruction(damage_flag)
	set_light(0)
	visible_message(span_warning("圣化之树倒下时，金色的光芒随之熄灭——树父的祝福破碎了！"))
	var/obj/item/grown/log/tree/blessed_log = new(loc)
	blessed_log.bless_log()
	return ..()

/obj/structure/flora/roguetree/wise/sanctified/process(dt)
	bonus_check_elapsed += dt
	if(bonus_check_elapsed >= 60 SECONDS)
		bonus_check_elapsed = 0
		recalculate_integrity_bonus()
	integrity_regen_elapsed += dt
	if(integrity_regen_elapsed >= 30 SECONDS)
		integrity_regen_elapsed = 0
		if(obj_integrity < max_integrity)
			obj_integrity = min(obj_integrity + 10, max_integrity)
	if(!tree_data)
		return
	if(tree_data.has_slow_aura)
		tree_data.slow_aura_elapsed += dt
		if(tree_data.slow_aura_elapsed >= 5 SECONDS)
			tree_data.slow_aura_elapsed = 0
			update_slow_aura()
	if(tree_data.has_heal_aura)
		tree_data.heal_aura_elapsed += dt
		if(tree_data.heal_aura_elapsed >= 60 SECONDS)
			tree_data.heal_aura_elapsed = 0
			pulse_heal_aura()

//==============================================================================
// Examine / Interaction// Wedding ritual procs
//==============================================================================

/// Called when a bitten apple (2 names) is offered to the sanctified tree during a wedding ceremony.
/obj/structure/flora/roguetree/wise/sanctified/proc/perform_wedding(mob/living/user, obj/item/reagent_containers/food/snacks/grown/apple/marriage_apple)
	var/mob/living/carbon/human/thegroom
	var/mob/living/carbon/human/thebride
	for(var/bite_name in marriage_apple.bitten_names)
		var/found = FALSE
		for(var/mob/living/carbon/human/viewer in viewers(src, 7))
			if(!ishuman(viewer))
				continue
			if(viewer.stat == DEAD)
				continue
			if(!viewer.client)
				continue
			if(viewer.marriedto)
				continue
			if(viewer.real_name == bite_name)
				if(!thegroom)
					thegroom = viewer
				else if(!thebride)
					thebride = viewer
				found = TRUE
				break
		if(found && thegroom && thebride)
			break

	if(!(thegroom && thebride))
		marriage_apple.become_rotten()
		to_chat(user, span_danger("树父的祝福消散了——咬过这枚果实的人不在场，或已经成婚。苹果腐烂了。"))
		tree_data.wedding_active = FALSE
		tree_data.wedding_officiant_ckey = null
		return

	var/surname = reject_bad_name(tgui_input_text(user, "请输入这对新人共同的姓氏：", "自然结合"))
	if(QDELETED(src) || QDELETED(user))
		return
	if(!surname || !length(trim(surname)))
		surname = thegroom.dna.species.random_surname()

	priority_announce("[thegroom.real_name]与[thebride.real_name]已在树父的枝叶下结为伴侣！", title = "Nature's Union!", sound = 'sound/misc/bell.ogg')

	var/list/titles = list("Sir", "Ser", "Dame", "Lord", "Lady", "Knight-Captain", "Duke", "Duchess", "Father", "Mother", "Brother", "Sister", "Prelate", "Devotee", "Votary")

	var/list/groom_name_parts = splittext(thegroom.real_name, " ")
	var/title_found = (titles.Find(groom_name_parts[1]) != 0)
	if(title_found)
		thegroom.real_name = "[groom_name_parts[1]] [groom_name_parts[2]] [surname]"
	else
		thegroom.real_name = "[groom_name_parts[1]] [surname]"

	var/list/bride_name_parts = splittext(thebride.real_name, " ")
	title_found = (titles.Find(bride_name_parts[1]) != 0)
	if(title_found)
		thebride.real_name = "[bride_name_parts[1]] [bride_name_parts[2]] [surname]"
	else
		thebride.real_name = "[bride_name_parts[1]] [surname]"

	to_chat(thegroom, span_notice("你们共同的新姓氏是[surname]。"))
	to_chat(thebride, span_notice("你们共同的新姓氏是[surname]。"))

	thegroom.marriedto = thebride.real_name
	thebride.marriedto = thegroom.real_name
	thegroom.adjust_triumphs(1)
	thebride.adjust_triumphs(1)

	visible_message(span_green("[src.name]绽放出耀眼的金光——登多尔与伊欧拉共同祝福这段姻缘！"))
	playsound(get_turf(src), 'sound/misc/bell.ogg', 80, FALSE)
	qdel(marriage_apple)
	tree_data.wedding_active = FALSE
	tree_data.wedding_officiant_ckey = null
//==============================================================================

/obj/structure/flora/roguetree/wise/sanctified/examine(mob/living/carbon/human/user)
	. = ..()
	var/tree_count = 0
	for(var/obj/structure/flora/newtree/counted_tree in range(5, src))
		if(!counted_tree.burnt)
			tree_count++
	for(var/obj/structure/flora/roguetree/counted_tree in range(5, src))
		if(istype(counted_tree, /obj/structure/flora/roguetree/wise) || istype(counted_tree, /obj/structure/flora/roguetree/burnt) || istype(counted_tree, /obj/structure/flora/roguetree/stump))
			continue
		tree_count++
	. += span_info("[src]从附近[tree_count]棵活树中汲取力量，获得[integrity_bonus]点额外耐久。")
	. += span_info("耐久：[round(obj_integrity)]/[max_integrity]")
	if(show_ritual_hints)
		. += span_info("使用登多尔护符打开仪式菜单，即可开始德鲁伊仪式或“自然结合”婚礼；两位新人必须各咬同一个苹果一口，再将它献给这棵树，以缔结婚约。")
	if(!ishuman(user))
		return
	if(user.patron?.type != /datum/patron/divine/dendor)
		return
	if(show_ritual_hints)
		. += span_notice("将登多尔护符贴近这棵树，即可开始或取消树父恩赐仪式。")
		. += span_notice("也可以佩戴护符，以空手触摸意图打开仪式菜单。")
		. += span_notice("仪式进行期间，手持所需物品点击这棵树即可献上供品。")
	if(show_ritual_hints && tree_data?.active_ritual)
		. += span_notice("当前恩赐仪式：[tree_data.active_ritual.name]")
		. += span_notice("[tree_data.active_ritual.get_ritual_examine()]")
	if(tree_data?.has_slow_aura)
		. += span_info("一道守护结界驱逐着意图亵渎这片林地的人。")
	if(tree_data?.has_heal_aura)
		. += span_info("这棵树散发着疗愈灵光。站在树旁并用鼠标中键点击它，即可引导它的疗愈之力。")

/obj/structure/flora/roguetree/wise/sanctified/attack_hand(mob/living/carbon/human/user)
	if(!ishuman(user))
		return ..()
	if(tree_data?.awaiting_soulbind_ckey && user.ckey == tree_data.awaiting_soulbind_ckey && show_ritual_hints)
		attempt_soulbind(user)
		return
	// Touch intent with empty hand while wearing the Dendor amulet opens the ritual menu.
	if(!user.get_active_held_item())
		var/has_dendor_amulet = FALSE
		var/list/worn_items = user.get_all_slots() // This proc actually returns a list of items worn
		if(locate(/obj/item/clothing/neck/roguetown/psicross/dendor) in worn_items)
			has_dendor_amulet = TRUE
		if(!has_dendor_amulet)
			return
		if(!show_ritual_hints)
			to_chat(user, span_warning("这棵受祝福的树已赐出力量，无法再举行仪式。"))
			return ..()
		if(user.patron?.type != /datum/patron/divine/dendor)
			to_chat(user, span_warning("只有登多尔的信徒才能与这棵圣树交流。"))
			return
		open_ritual_menu(user)

/obj/structure/flora/roguetree/wise/sanctified/attackby(obj/item/attacking_item, mob/living/user, params)
	// Bitten apple: completes the Nature's Union wedding ceremony.
	if(tree_data?.wedding_active && istype(attacking_item, /obj/item/reagent_containers/food/snacks/grown/apple))
		var/obj/item/reagent_containers/food/snacks/grown/apple/marriage_apple = attacking_item
		if(length(marriage_apple.bitten_names) < 2)
			to_chat(user, span_warning("两位新人都必须咬过这个苹果，才能将它献给这棵树。"))
			return
		perform_wedding(user, marriage_apple)
		return

	// Dendor amulet: entry point for ritual menu.
	if(istype(attacking_item, /obj/item/clothing/neck/roguetown/psicross/dendor))
		if(!show_ritual_hints)
			to_chat(user, span_warning("这棵受祝福的树已赐出力量，无法再举行仪式。"))
			return
		if(!ishuman(user))
			return
		var/mob/living/carbon/human/human_user = user
		if(human_user.patron?.type != /datum/patron/divine/dendor)
			to_chat(user, span_warning("只有登多尔的信徒才能与这棵圣树交流。"))
			return
		open_ritual_menu(user)
		return

	// While a ritual is active, offerings are made by clicking the tree with an item in-hand.
	if(tree_data?.active_ritual && ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(human_user.patron?.type == /datum/patron/divine/dendor)
			if(offer_item(user))
				return
	return ..()

//==============================================================================
// Integrity Bonus
//==============================================================================

/*
 * Recounts living trees within 10 tiles and updates max_integrity.
 * Qualifying trees: /obj/structure/flora/newtree (not burnt) and
 * /obj/structure/flora/roguetree (not wise, burnt, or stump subtypes).
 * Each tree contributes +10 integrity, capped at +200 (20 trees).
 */
/obj/structure/flora/roguetree/wise/sanctified/proc/recalculate_integrity_bonus()
	var/tree_count = 0
	for(var/obj/structure/flora/newtree/counted_tree in range(10, src))
		if(!counted_tree.burnt)
			tree_count++
	for(var/obj/structure/flora/roguetree/counted_tree in range(10, src))
		if(istype(counted_tree, /obj/structure/flora/roguetree/wise))
			continue  // exclude wise and sanctified subtypes
		if(istype(counted_tree, /obj/structure/flora/roguetree/burnt))
			continue
		if(istype(counted_tree, /obj/structure/flora/roguetree/stump))
			continue
		tree_count++
	var/new_bonus = min(tree_count * 10, 200)
	if(new_bonus == integrity_bonus)
		return
	integrity_bonus = new_bonus
	max_integrity = 400 + integrity_bonus
	obj_integrity = min(obj_integrity, max_integrity)

//==============================================================================
// Sanctified Wise Tree
// A sacred (wise) tree blessed by a Dendorite acolyte into a sanctified wise tree.
// Has the slow aura and heal aura active from creation, but cannot receive rituals, soulbind, or officiate weddings.
//==============================================================================
/obj/structure/flora/roguetree/wise/sanctified/wise
	name = "圣化睿木"
	desc = "一棵由登多尔侍僧亲自祝福的古老圣树。树父的力量流淌在它的根须中，散发疗愈之力，驱逐意图亵渎林地的人，而更深层的奥秘依然封存着。"
	examine_plays_music = TRUE
	show_ritual_hints = FALSE

/obj/structure/flora/roguetree/wise/sanctified/wise/Initialize(mapload)
	. = ..()
	// Both auras are active from creation — no rituals needed.
	tree_data.has_slow_aura = TRUE
	tree_data.has_heal_aura = TRUE
	// Replace the standard golden glow with the living-light green (normally granted by ritual).
	set_light(5, 5, 5, l_color = "#44AA44")
	add_filter("sanctified_outline", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 60, "size" = 1))

//==============================================================================
// Ritual Framework
//==============================================================================

/// Returns a list of rituals that can be started
/obj/structure/flora/roguetree/wise/sanctified/proc/open_ritual_menu(mob/living/user)
	if(!tree_data)
		return

	if(tree_data.wedding_active)
		// Nature's Union ceremony is active — offer cancellation.
		var/choice = tgui_alert(user, "这棵树上正在举行一场“自然结合”婚礼。树父的祝福此刻正连结着两道灵魂。\n\n要取消这场婚礼吗？", "圣化之树", list("保留仪式", "取消仪式"))
		if(choice == "取消仪式" && !QDELETED(src) && !QDELETED(user))
			tree_data.wedding_active = FALSE
			tree_data.wedding_officiant_ckey = null
			to_chat(user, span_warning("婚礼仪式已被解散。树父收回了他的祝福。"))
		return

	if(tree_data.active_ritual)
		// Show progress and only allow cancellation from the amulet menu.
		var/text = "[tree_data.active_ritual.name] 正在进行中。\n\n手持物品点击这棵树即可献上供品。"
		for(var/line in tree_data.active_ritual.get_plaintext_examine())
			text += "\n[line]"
		text += "\n\n要取消此仪式吗？"
		var/choice = alert(user, text, "圣化之树", "保留仪式", "取消仪式")
		if(choice != "取消仪式" || QDELETED(src) || QDELETED(user))
			return
		cancel_ritual(user)
		return

	// No active ritual, so let's start one
	var/list/possible_rituals = list()
	var/list/ritual_names = list()
	for(var/datum/druid_ritual/new_ritual as anything in subtypesof(/datum/druid_ritual))
		new_ritual = new new_ritual
		if(!new_ritual.can_see_ritual(user))
			continue
		if(new_ritual.unique_tree_rite && (locate(new_ritual) in tree_data.rituals_completed))
			new_ritual.name = "[new_ritual.name]（已完成）"
		possible_rituals += new_ritual.name
		ritual_names[new_ritual.name] = new_ritual

	var/choice = tgui_input_list(user, "选择要举行的仪式：", "圣化之树仪式", possible_rituals)
	var/datum/druid_ritual/selected_ritual = ritual_names[choice]
	if(isnull(selected_ritual) || QDELETED(src) || QDELETED(user))
		return

	if(!selected_ritual.can_start_ritual(user))
		to_chat(user, span_info("该仪式已在这棵树上完成过，无法重复举行。"))
		return

	selected_ritual.prepare_tracker()
	if(!confirm_start_ritual(user, selected_ritual))
		return
	tree_data.active_ritual = selected_ritual
	selected_ritual.ritual_holder = tree_data
	to_chat(user, span_notice("我开始举行仪式。手持供品点击这棵树即可献上。只有在需要取消时，才使用护符。"))

/obj/structure/flora/roguetree/wise/sanctified/proc/confirm_start_ritual(mob/living/user, datum/druid_ritual/selected_ritual)
	var/text = "开始 [selected_ritual.name]？\n\n所需供品："
	for(var/line in selected_ritual.get_plaintext_examine())
		text += "\n[line]"
	var/choice = alert(user, text, "圣化之树恩赐", "开始", "取消")
	return (choice == "开始")

/obj/structure/flora/roguetree/wise/sanctified/proc/offer_item(mob/living/user)
	if(!tree_data?.active_ritual)
		return FALSE
	var/obj/item/held = user.get_active_held_item()
	if(!held)
		to_chat(user, span_warning("我手里没有任何可供奉的东西。"))
		return FALSE

	// Support taking items from a held storage container (sack, satchel, bag).
	if(held.GetComponent(/datum/component/storage))
		// Bulk mode: for every unfulfilled key, drain all matching items from the sack at once.
		var/any_taken = FALSE
		// Snapshot contents so deletions during iteration are safe.
		var/list/sack_contents = held.contents.Copy()
		for(var/obj/item/sack_item in sack_contents)
			if(tree_data.active_ritual.accept_offering(sack_item, user, silent = TRUE))
				any_taken = TRUE
		if(!any_taken)
			to_chat(user, span_warning("这棵树现在不需要那个容器里的任何东西。"))
			return FALSE
		playsound(get_turf(src), 'sound/magic/churn.ogg', 40, FALSE)
		tree_data.active_ritual.check_ritual_complete(user)
		return TRUE

	if(tree_data.active_ritual.accept_offering(held, user, silent = FALSE))
		tree_data.active_ritual.check_ritual_complete(user)
		return TRUE
	return FALSE

/obj/structure/flora/roguetree/wise/sanctified/proc/cancel_ritual(mob/living/user)
	if(!tree_data?.active_ritual)
		return
	if(tree_data.ritual_armor && !QDELETED(tree_data.ritual_armor))
		tree_data.ritual_armor.forceMove(get_turf(user))
		to_chat(user, span_notice("献上的护甲回到了我脚边。"))
		tree_data.ritual_armor = null
	to_chat(user, span_warning("我取消了 [tree_data.active_ritual.name] 仪式。所有进度都已丢失。"))
	tree_data.active_ritual = null

/datum/druid_ritual
	abstract_type = /datum/druid_ritual
	/// Reference to the tree that this ritual is a part of
	var/datum/sanctified_tree_data/ritual_holder
	/// Name of the ritual, how it shows up in the UI
	var/name = "Abstract Ritual"
	/// Tier of the ritual, you need equal or greater skill to be elligible to start/complete the ritual
	var/druid_ritual_tier = SKILL_LEVEL_NONE
	/// How much XP the ritual gives upon completion
	var/experience_payout = 0
	/// TRUE if the ritual is once-per-tree
	var/unique_tree_rite = FALSE // Repeatable rituals by default
	/// If the rite isn't repeatable, mark as completed
	var/rite_completed = FALSE

	/// Spell this ritual grants on completion
	var/granted_spell

	/// Assoc list of [typepaths we need] to [amount needed].
	/// If one of the items in the list is a list, it's treated as 'any of these items will work'
	var/list/specific_offerings

	//---- If specific_offerings isn't set, we have to handle things on a more specific basis
	/// List of types that this ritual can accept
	var/list/elligible_offerings
	/// Amount of offerings needed
	var/required_amount
	/// What this ritual will ask for when starting the ritual
	var/offering_description

	/// List that keeps track of how many offerings we've already given to the tree
	var/list/offering_tracker

/// Checks what rituals the user is able to see, used to build the list to display to the user
/datum/druid_ritual/proc/can_see_ritual(mob/druid)
	if(!druid.mind)
		return FALSE
	var/druidic_level = druid.get_skill_level(/datum/skill/magic/druidic)
	if(druidic_level >= druid_ritual_tier)
		return TRUE
	return FALSE

/// Checks if the user is elligible to even start the ritual. Returns TRUE if elligible
/datum/druid_ritual/proc/can_start_ritual(mob/druid)
	if(!druid.mind)
		return FALSE
	if(unique_tree_rite && rite_completed)
		return FALSE
	var/druidic_level = druid.get_skill_level(/datum/skill/magic/druidic)
	if(druidic_level < druid_ritual_tier)
		return FALSE
	if(granted_spell)
		if(locate(granted_spell) in druid.mind.spell_list)
			to_chat(druid, span_warning("树父的繁花赠礼已在我体内，不能重复接受这份祝福。"))
			return FALSE
	return TRUE

/// Copies our list of requirements once the ritual actually begins
/datum/druid_ritual/proc/prepare_tracker()
	offering_tracker = list()
	if(!isnull(specific_offerings))
		offering_tracker = specific_offerings.Copy()
		return
	if(!isnull(elligible_offerings))
		offering_tracker = 0

/// Checks if the item offered to the tree meets our criteria. Returns TRUE if the item is accepted and consumed
/datum/druid_ritual/proc/accept_offering(obj/item/offering, mob/living/user, silent = FALSE)
	if(!isnull(specific_offerings))
		for(var/key in offering_tracker)
			if(islist(key)) // If it's a list, check if it matches something in the list
				if(!is_type_in_list(offering, key))
					continue
				else if(offering_tracker[key] <= 0) // Found in the list, check if it's needed
					if(!silent)
						to_chat(user, span_warning("这棵树现在不需要[offering.name]。"))
					return FALSE
			else if(istype(offering, key)) // Key isn't a list, check if the type matches directly
				if(offering_tracker[key] <= 0)
					if(!silent)
						to_chat(user, span_warning("这棵树现在不需要[offering.name]。"))
					return FALSE
			else
				continue // Not a key list and doesn't match a type
			// Ok, we found the item in our list, now we can track it and delete the item
			offering_tracker[key]--
			qdel(offering)
			if(!silent)
				playsound(get_turf(user), 'sound/magic/churn.ogg', 40, FALSE)
			return TRUE
	if(!isnull(elligible_offerings)) // Most of these lists will have custom handling, this just covers the generic case
		for(var/key in offering_tracker)
			if(islist(key))
				if(!is_type_in_list(offering, key))
					continue
				else if(offering_tracker[key] <= 0) // Found in the list, check if it's needed
					if(!silent)
						to_chat(user, span_warning("这棵树现在不需要[offering.name]。"))
					return FALSE

			else if(istype(offering, key))
				if(offering_tracker[key] <= 0)
					if(!silent)
						to_chat(user, span_warning("这棵树现在不需要[offering.name]。"))
					return FALSE
			else
				continue // No matches
			// Ok, we found the item in our list, now we can track it and delete the item
			offering_tracker[key]++
			qdel(offering)
			if(!silent)
				playsound(get_turf(user), 'sound/magic/churn.ogg', 40, FALSE)
			return TRUE
	return FALSE

/// Checks if all the criteria are fulfilled, and calls on_complete once elligible
/datum/druid_ritual/proc/check_ritual_complete(mob/living/user)
	for(var/key in offering_tracker)
		if(offering_tracker[key] > 0)
			return FALSE // Unfulfilled requirement
	on_complete(user)

/// Grants rewards when the ritual is completed
/datum/druid_ritual/proc/on_complete(mob/living/user)
	playsound(get_turf(user), 'sound/ambience/noises/mystical (4).ogg', 70, TRUE)
	user.visible_message(span_green("[user.name]完成了神圣的仪式，[name]绽放出耀眼的金光！"))
	ritual_holder.rituals_completed |= src
	ritual_holder.active_ritual = null
	if(experience_payout > 0 && user.mind)
		user.mind.add_sleep_experience(/datum/skill/magic/druidic, experience_payout)
	on_complete_rewards(user) // Per ritual custom rewards
	return

/// Pays out ritual-specific rewards
/datum/druid_ritual/proc/on_complete_rewards(mob/living/user)
	return

/// Returns the current ritual progress
/datum/druid_ritual/proc/get_ritual_examine()
	var/list/examine_list = list()
	if(!isnull(specific_offerings))
		for(var/key in offering_tracker)
			var/target = specific_offerings[key] // Maximum amount
			var/current = target - offering_tracker[key] // Copy list means ex: 10 - 10 = 0 contributed
			var/english_text

			if(islist(key))
				var/list/key_list = key
				var/list/key_text_list = list()
				for(var/atom/possible_type as anything in key_list)
					key_text_list += "[initial(possible_type.name)]"
				english_text = english_list(key_text_list, and_text = "或")

			else
				var/atom/key_atom = key
				english_text = initial(key_atom.name)

			if(current >= target)
				examine_list += span_notice("[english_text]：[current]/[target]（已满足）<br>")
			else
				examine_list += span_warning("[english_text]：[current]/[target]<br>")
	return examine_list.Join()

/// Returns the current ritual progress but in plaintext
/datum/druid_ritual/proc/get_plaintext_examine()
	var/list/examine_list = list()
	if(!isnull(specific_offerings))
		for(var/key in offering_tracker)
			var/target = specific_offerings[key] // Maximum amount
			var/current = target - offering_tracker[key] // Copy list means ex: 10 - 10 = 0 contributed
			var/english_text

			if(islist(key))
				var/list/key_list = key
				var/list/key_text_list = list()
				for(var/atom/possible_type as anything in key_list)
					key_text_list += "[initial(possible_type.name)]"
				english_text = english_list(key_text_list, and_text = "或")

			else
				var/atom/key_atom = key
				english_text = initial(key_atom.name)

			if(current >= target)
				examine_list += "[english_text]：[current]/[target]（已满足）"
			else
				examine_list += "[english_text]：[current]/[target]"
	return examine_list

//--- DENDORS HARVEST
/datum/druid_ritual/dendors_harvest
	name = "登多尔的丰收"
	experience_payout = 5
	druid_ritual_tier = SKILL_LEVEL_NONE // Starting point
	required_amount = 6
	offering_description = "任意新鲜或腐烂的农作物"
	/// Static list of produce
	var/static/list/produce_subtypes = subtypesof(/obj/item/reagent_containers/food/snacks/grown)
	/// If the ritual was only satisfied with berries, it's an alternate payout
	var/berries_only = TRUE

/datum/druid_ritual/dendors_harvest/New()
	. = ..()
	elligible_offerings = produce_subtypes.Copy()
	elligible_offerings |= /obj/item/natural/shellplant/pumpkin

/datum/druid_ritual/dendors_harvest/prepare_tracker()
	offering_tracker = list("food_item" = required_amount)

/datum/druid_ritual/dendors_harvest/accept_offering(obj/item/offering, mob/living/user, silent = FALSE)
	if(offering_tracker["food_item"] <= 0)
		return
	if(!is_type_in_list(offering, elligible_offerings))
		return FALSE
	if(!istype(offering, /obj/item/reagent_containers/food/snacks/grown/berries))
		berries_only = FALSE
	offering_tracker["food_item"]--
	qdel(offering)
	if(!silent)
		playsound(get_turf(user), 'sound/magic/churn.ogg', 40, FALSE)
	return TRUE

/datum/druid_ritual/dendors_harvest/check_ritual_complete(mob/living/user)
	if(offering_tracker["food_item"] <= 0)
		on_complete(user)

/datum/druid_ritual/dendors_harvest/get_ritual_examine()
	return span_warning("农作物：[(required_amount - offering_tracker["food_item"])]/[required_amount]<br>")

/datum/druid_ritual/dendors_harvest/get_plaintext_examine()
	var/list/examine_list = list()
	examine_list += "农作物：[(required_amount - offering_tracker["food_item"])]/[required_amount]"
	return examine_list

/// Dendor's Harvest: seed bounty (repeatable).
/// Offerings: 6 any fruit/grain/vegetable food items (rotten okay).
/// Reward (normal): 1 random misc seed + 1 tree seed (5% sakura, 10% pine, 85% regular).
/// Reward (berry special case, all 5 berries): 1 wild bush seed + 50% chance flower seed.
/datum/druid_ritual/dendors_harvest/on_complete_rewards(mob/living/user)
	var/turf/user_turf = get_turf(user)
	if(berries_only)
		// Berry special case: all offerings were berries → wild thorny berry hedge seed + possible flower
		new /obj/item/seeds/bush(user_turf)
		if(prob(50))
			new /obj/item/seeds/flower(user_turf)
		to_chat(user, span_green("树根翻涌着荆棘般的能量，一颗野生树篱幼苗种子滚落而出。"))
		return
	// Normal reward: 1 misc seed from Dendor's garden + 1 tree seed
	var/misc = pickweight(list(
		/obj/item/seeds/tea                          = 10,
		/obj/item/seeds/coffee                       = 10,
		/obj/item/herbseed/manabloom                 = 8,
		/obj/item/seeds/swampweed                    = 8,
		/obj/item/seeds/apple                        = 6,
		/obj/item/seeds/pear                         = 6,
		/obj/item/seeds/plum                         = 6,
		/obj/item/seeds/strawberry                   = 5,
		/obj/item/seeds/blackberry                   = 5,
		/obj/item/seeds/raspberry                    = 5,
		/obj/item/seeds/tomato                       = 5,
		/obj/item/seeds/potato                       = 5,
		/obj/item/seeds/onion                        = 5,
		/obj/item/seeds/cabbage                      = 5,
		/obj/item/seeds/wheat                        = 5,
		/obj/item/seeds/garlick                      = 5,
		/obj/item/seeds/turnip                       = 5,
		/obj/item/seeds/rice                         = 5,
		/obj/item/seeds/cucumber                     = 5,
		/obj/item/seeds/eggplant                     = 5,
		/obj/item/seeds/carrot                       = 5,
		/obj/item/seeds/wheat/oat                    = 5,
		/obj/item/seeds/sugarcane                    = 4,
		/obj/item/seeds/poppy                        = 4,
		/obj/item/seeds/nut                          = 4,
		/obj/item/seeds/lemon                        = 4,
		/obj/item/seeds/lime                         = 4,
		/obj/item/seeds/tangerine                    = 4,
		/obj/item/seeds/pumpkin                      = 3,
		/obj/item/seeds/berryrogue                   = 3
	))
	new misc(user_turf)
	// Tree seed: 5% sakura, 10% pine, 85% regular
	var/tree_type = pickweight(list(
		/obj/item/seeds/treesap/sakura = 5,
		/obj/item/seeds/treesap/pine   = 10,
		/obj/item/seeds/treesap        = 85
	))
	new tree_type(user_turf)
	to_chat(user, span_green("种子自树根间簌簌落下，登多尔的收成一如既往地慷慨。"))

//--- NATURES UNION (Marriage ritual)
/datum/druid_ritual/natures_union
	name = "自然结合"
	experience_payout = 25
	druid_ritual_tier = SKILL_LEVEL_NOVICE
	specific_offerings = list(/obj/item/clothing/head/peaceflower = 1)
	offering_description = "伊欧拉和平花"

/// Nature's Union: begins a wedding ceremony (repeatable).
/// Offering: 1 eoran peace flower. The betrothed must each bite the same apple,
/// then offer it to the tree to complete the pact.
/datum/druid_ritual/natures_union/on_complete_rewards(mob/living/user)
	if(ritual_holder.wedding_active)
		to_chat(user, span_warning("这棵树下已经在举行婚礼了。"))
		return
	ritual_holder.wedding_active = TRUE
	ritual_holder.wedding_officiant_ckey = user.ckey
	user.visible_message(span_green("一朵和平花飘落至[ritual_holder.tree.name]的树根旁，唤起了登多尔与伊欧拉的祝福。两位新人现在可以献上共同咬过的苹果，在树下结为伴侣。"))
	to_chat(user, span_notice("婚礼开始了。两位新人应各咬同一个苹果一口，再将它献给这棵树以缔结婚约。献上苹果的人将决定共同的姓氏。"))

//---- FLORAL CONJURATION
/datum/druid_ritual/floral_conjuration
	name = "花卉塑成"
	unique_tree_rite = TRUE // One spell per tree
	experience_payout = 100
	druid_ritual_tier = SKILL_LEVEL_NOVICE
	specific_offerings = list(
		/obj/item/alch/atropa = 1,
		/obj/item/alch/matricaria = 1,
		/obj/item/alch/symphitum = 1,
		/obj/item/alch/taraxacum = 1,
		/obj/item/alch/euphrasia = 1,
		/obj/item/alch/paris = 1,
		/obj/item/alch/calendula = 1,
		/obj/item/alch/mentha = 1,
		/obj/item/alch/urtica = 1,
		/obj/item/alch/salvia = 1,
		/obj/item/alch/hypericum = 1,
		/obj/item/alch/benedictus = 1,
		/obj/item/alch/valeriana = 1,
		/obj/item/alch/artemisia = 1,
		/obj/item/alch/rosa = 1,
		/obj/item/reagent_containers/food/snacks/grown/manabloom = 1,
	)
	offering_description = "每种药草各一份"
	granted_spell = /obj/effect/proc_holder/spell/self/conjure_floral_seed

/// Floral Conjuration: grants the Conjure Floral Seed spell (once per tree, once per person).
/// Offerings: one of every herb (atropa through rosa, 15 total).
/datum/druid_ritual/floral_conjuration/on_complete_rewards(mob/living/carbon/human/user)
	if(!ishuman(user))
		to_chat(user, span_warning("唯有人形生灵才能接受树父的繁花赠礼。"))
		return
	if(!user.mind)
		return
	// Once-per-person: don't grant the spell if they already have it.
	for(var/obj/effect/proc_holder/spell/self/conjure_floral_seed/floral_spell in user.mind.spell_list)
		to_chat(user, span_warning("我已经懂得如何造化花种，不能重复接受这份祝福。"))
		return
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/conjure_floral_seed)
	to_chat(user, span_green("花卉塑成的知识流入我的脑海，我可以借树父之力唤来种子了。"))

//---- FUNGAL VIGIL
/datum/druid_ritual/fungal_vigil
	name = "菌灵守望"
	experience_payout = 25
	druid_ritual_tier = SKILL_LEVEL_APPRENTICE
	specific_offerings = list(
		list(/obj/item/reagent_containers/food/snacks/grown/manabloom, /obj/item/magic/manacrystal) = 10
	)
	offering_description = "法绽花或结晶化魔力"

/// Fungal Vigil: kneestinger ring + 30-min vigil buff to nearby mobs (repeatable).
/// Offerings: 10 mana blooms OR crystalized mana.
/// Buff: longstrider + +2 Perception + +1 Speed + kneestinger immunity, 30 minutes.
/datum/druid_ritual/fungal_vigil/on_complete_rewards(mob/living/user)
	var/turf/spawn_turf = get_turf(ritual_holder.tree)
	// Plant kneestingers in the 4 cardinal directions around the tree.
	for(var/cardinal_direction in GLOB.cardinals)
		var/turf/adj = get_step(spawn_turf, cardinal_direction)
		if(adj && !isclosedturf(adj) && !locate(/obj/structure/glowshroom) in adj)
			new /obj/structure/glowshroom(adj)
	// Buff nearby non-dead pantheon followers except excluded patrons.
	for(var/mob/living/carbon/human/follower in range(6, ritual_holder.tree))
		if(!is_valid_vigil_follower(follower))
			continue
		if(follower.stat == DEAD)
			continue
		if(follower.patron?.type == /datum/patron/divine/dendor)
			follower.apply_status_effect(/datum/status_effect/buff/dendor_vigil/dendorite)
		else
			follower.apply_status_effect(/datum/status_effect/buff/dendor_vigil)
	to_chat(user, span_green("膝刺菇环绕而生，树父的守望强化了祂的信徒。"))

/datum/druid_ritual/fungal_vigil/proc/is_valid_vigil_follower(mob/living/carbon/human/follower)
	if(!follower)
		return FALSE
	// Psydon followers have no patron datum — identified by trait.
	if(HAS_TRAIT(follower, TRAIT_PSYDONITE))
		return FALSE
	// Old-god worshippers and all inhumen (Zizo, Baotha, Graggar, Matthios) patrons are excluded.
	if(istype(follower.patron, /datum/patron/old_god))
		return FALSE
	if(istype(follower.patron, /datum/patron/inhumen))
		return FALSE
	return TRUE

//==============================================================================
// Dendor's Vigil Status Effect (applied by Fungal Vigil)
//==============================================================================

/atom/movable/screen/alert/status_effect/buff/dendor_vigil
	name = "登多尔的守望"
	desc = "树父的祝福令我步履轻快，保护我免受自然障碍侵扰。"
	icon_state = "buff"

/datum/status_effect/buff/dendor_vigil
	id = "dendor_vigil"
	alert_type = /atom/movable/screen/alert/status_effect/buff/dendor_vigil
	effectedstats = list("perception" = 2, "speed" = 1)
	duration = 30 MINUTES

/datum/status_effect/buff/dendor_vigil/dendorite
	effectedstats = list("perception" = 2, "speed" = 2, "willpower" = 1)

/datum/status_effect/buff/dendor_vigil/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_green("树父的守望庇护着我，我步履轻快，荆棘也无法刺伤我。"))

/datum/status_effect/buff/dendor_vigil/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_warning("树父的守望从我身上消退了。"))

//---- LIVING LIGHT
/datum/druid_ritual/living_light
	name = "活体灵光"
	unique_tree_rite = TRUE // Provides an AOE heal aura
	experience_payout = 100
	druid_ritual_tier = SKILL_LEVEL_APPRENTICE
	specific_offerings = list(
		list(/obj/item/alch/sinew, /obj/item/alch/viscera, /obj/item/alch/bonemeal, /obj/item/skull) = 10,
		/obj/item/ash = 10,
		/obj/item/compost = 10,
	)

/// Living Light: passive healing aura + middle-click manual heal (once per tree).
/// Offerings: 10 mixed sinew/viscera/tailbone/bone/skull + 10 ash + 10 compost.
/// Aura: wide green glow, periodic healing for Dendor followers.
/datum/druid_ritual/living_light/on_complete_rewards(mob/living/user)
	ritual_holder.has_heal_aura = TRUE
	ritual_holder.tree.set_light(5, 5, 5, l_color = "#44AA44")
	ritual_holder.tree.add_filter("sanctified_outline", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 60, "size" = 1))
	ritual_holder.tree.visible_message(span_green("温暖的翠绿灵光自[src.name]绽放而出。树父的生命之力开始流向敬奉祂的人。"))

//---- TIMBERS TITHE
/datum/druid_ritual/timbers_tithe
	name = "林木什一"
	experience_payout = 10
	druid_ritual_tier = SKILL_LEVEL_APPRENTICE
	specific_offerings = list(
		list(/obj/item/seeds/treesap, /obj/structure/tree_sapling) = 5
	)
	offering_description = "任意树苗"

// Spawn 2 blessed logs at the player's feet as the Treefather's gift.
/datum/druid_ritual/timbers_tithe/on_complete_rewards(mob/living/user)
	var/turf/user_turf = get_turf(user)
	for(var/i in 1 to 2)
		var/obj/item/grown/log/tree/log = new(user_turf)
		log.bless_log()
	to_chat(user, span_green("在树父的力量下，树枝脱落后又重新生长，受祝福的原木落在了我的脚边。"))

//---- TREEFATHERS BULWARK
#define BOULDER_AMOUNT 5
#define STONE_AMOUNT 15

/datum/druid_ritual/treefathers_bulwark
	name = "树父壁垒"
	unique_tree_rite = TRUE // Increases integrity
	experience_payout = 100
	druid_ritual_tier = SKILL_LEVEL_JOURNEYMAN
	elligible_offerings = list(
		/obj/item/natural/rock,
		/obj/item/natural/stone,
	) // Special handling
	offering_description = "巨石或小石头" // 5 Boulders or 15 Stones

/datum/druid_ritual/treefathers_bulwark/prepare_tracker()
	offering_tracker = list(
		/obj/item/natural/rock = BOULDER_AMOUNT,
		/obj/item/natural/stone = STONE_AMOUNT
	)

/datum/druid_ritual/treefathers_bulwark/accept_offering(obj/item/offering, mob/living/user, silent = FALSE)
	if(offering_tracker[offering.type] <= 0)
		return
	if(!is_type_in_list(offering, elligible_offerings))
		return FALSE
	offering_tracker[offering.type]--
	if(!silent)
		playsound(get_turf(user), 'sound/magic/churn.ogg', 40, FALSE)
	qdel(offering)
	return TRUE

/datum/druid_ritual/treefathers_bulwark/check_ritual_complete(mob/living/user)
	for(var/key in offering_tracker)
		if(offering_tracker[key] <= 0) // First one to hit 0 marks as complete
			on_complete(user)
			break

/datum/druid_ritual/treefathers_bulwark/get_ritual_examine()
	var/list/examine_list = list()
	examine_list += span_warning("巨石：[(BOULDER_AMOUNT - offering_tracker[/obj/item/natural/rock])]/[BOULDER_AMOUNT]<br>")
	examine_list += span_warning("或")
	examine_list += span_warning("石头：[(STONE_AMOUNT - offering_tracker[/obj/item/natural/stone])]/[STONE_AMOUNT]<br>")

	return examine_list.Join()

/datum/druid_ritual/treefathers_bulwark/get_plaintext_examine()
	var/list/examine_list = list()
	examine_list += "巨石：[(BOULDER_AMOUNT - offering_tracker[/obj/item/natural/rock])]/[BOULDER_AMOUNT]"
	examine_list += "或"
	examine_list += "石头：[(STONE_AMOUNT - offering_tracker[/obj/item/natural/stone])]/[STONE_AMOUNT]"
	return examine_list

/// Treefather's Bulwark: slow aura + integrity boost (once per tree).
/// Offerings: 5 enchanted stones (magic_power 5+) OR boulders.
/// Reward: +100 integrity, -4 speed debuff aura to non-Dendor mobs within 5 tiles.
/datum/druid_ritual/treefathers_bulwark/on_complete_rewards(mob/living/user)
	ritual_holder.has_slow_aura = TRUE
	ritual_holder.tree.max_integrity += 100
	ritual_holder.tree.obj_integrity = min(ritual_holder.tree.obj_integrity + 100, ritual_holder.tree.max_integrity)
	ritual_holder.tree.visible_message(span_green("[ritual_holder.tree.name]的树皮变得如铁木般坚硬。一道无声的结界笼罩了它，意图亵渎它的人将寸步难行。"))

#undef BOULDER_AMOUNT
#undef STONE_AMOUNT

//---- Soulbind
/datum/druid_ritual/soulbind
	name = "魂缚"
	unique_tree_rite = TRUE // You can only soulbind to 1 tree. Ever
	experience_payout = 100
	druid_ritual_tier = SKILL_LEVEL_JOURNEYMAN
	specific_offerings = list(
		/obj/item/leechtick_bloated = 1,
		list(/obj/item/natural/bone, /obj/item/alch/bone) = 4,
	)

/datum/druid_ritual/soulbind/on_complete_rewards(mob/living/user)
	. = ..()
	on_soulbind(user)

/// Sets the tree into soulbind-ready state.
/// The player must then attack the tree with harm intent + empty hand + bleeding arm to confirm.
/datum/druid_ritual/soulbind/proc/on_soulbind(mob/living/user)
	if(!istype(user))
		to_chat(user, span_warning("只有活人才能与这棵树缔结魂缚。"))
		return
	if(user.ckey in ritual_holder.soulbound_players)
		to_chat(user, span_warning("我已与这棵树缔结魂缚。"))
		return
	// Check once-per-player: has this player soulbound to any sanctified tree?
	if(HAS_TRAIT(user, TRAIT_DENDOR_SOULBOUND))
		to_chat(user, span_userdanger("我的灵魂已经绑定在一棵圣化之树上，无法再次魂缚。"))
		return
	ritual_holder.awaiting_soulbind_ckey = user.ckey
	to_chat(user, span_warning("仪式已准备就绪。要完成魂缚，我必须在手臂流血时空手以伤害意图攻击这棵树。"))

/// Triggered when a player attacks the tree with harm intent + empty hand + bleeding arm.
/obj/structure/flora/roguetree/wise/sanctified/proc/attempt_soulbind(mob/living/carbon/human/user)
	if(!tree_data)
		return
	if(tree_data.awaiting_soulbind_ckey != user.ckey)
		return
	if(HAS_TRAIT(user, TRAIT_DENDOR_SOULBOUND))
		to_chat(user, span_userdanger("我的灵魂已经有所归属，无法再次魂缚。"))
		return
	if(user.ckey in tree_data.soulbound_players)
		to_chat(user, span_warning("我已与这棵树缔结魂缚。"))
		return

	// Check intent
	if(user.used_intent?.type != INTENT_HARM)
		to_chat(user, span_warning("我必须用染血的手掌击打这棵树，才能完成魂缚。"))
		return
	// Check empty active hand
	if(user.get_active_held_item())
		to_chat(user, span_warning("我必须空着手才能完成魂缚。"))
		return
	// Check arm bleeding
	var/obj/item/bodypart/r_arm = user.get_bodypart(BODY_ZONE_R_ARM)
	var/obj/item/bodypart/l_arm = user.get_bodypart(BODY_ZONE_L_ARM)
	if(!(r_arm?.get_bleed_rate() > 0) && !(l_arm?.get_bleed_rate() > 0))
		to_chat(user, span_warning("我的手臂必须正在流血，才能以鲜血缔结魂缚。"))
		return

	to_chat(user, span_notice("我将流血的手掌按在神圣的树皮上，把自己的灵魂系在这棵圣化之树上。"))
	if(!do_after(user, 3 SECONDS, target = src))
		return
	if(QDELETED(src) || QDELETED(user))
		return
	if(user.ckey in tree_data.soulbound_players || HAS_TRAIT(user, TRAIT_DENDOR_SOULBOUND))
		return

	// Finalize bind
	var/confirm = tgui_alert(user, "你将把灵魂绑定在这棵圣化之树上。若此树被毁，你的全部属性都将遭受永久且不可逆的削弱。要继续吗？", "魂缚", list("是", "否"))
	if(confirm != "是" || QDELETED(src) || QDELETED(user))
		to_chat(user, span_warning("我退出了这场神圣的契约。"))
		return

	// 50 brute to active arm
	var/active_zone = user.active_hand_index == 1 ? BODY_ZONE_R_ARM : BODY_ZONE_L_ARM
	var/obj/item/bodypart/active_arm = user.get_bodypart(active_zone)
	if(active_arm)
		active_arm.receive_damage(50, 0)
	else
		user.adjustBruteLoss(50, 0)

	// Mark as soulbound
	ADD_TRAIT(user, TRAIT_DENDOR_SOULBOUND, "SOULBIND")
	tree_data.soulbound_players |= user.ckey
	tree_data.awaiting_soulbind_ckey = null

	// Grant soulbind spells
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/summon_lesser_dryad)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/lesser_dryad_special)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order/lesser_dryad)

	visible_message(span_boldwarning("[user.name]将手按在树皮上，一道金光闪过，契约就此缔结！"))
	playsound(get_turf(src), 'sound/ambience/noises/mystical (4).ogg', 70, TRUE)
	to_chat(user, span_green("我的灵魂已与这棵圣化之树相连。若它倒下，我也会随之失去自己的一部分。"))

/// Applies the permanent soulbind-broken debuff to all online soulbound players.
/// Called from Destroy() before tree_data is cleared.
/obj/structure/flora/roguetree/wise/sanctified/proc/curse_soulbound_players()
	for(var/ckey in tree_data.soulbound_players)
		for(var/mob/living/carbon/human/victim in GLOB.alive_mob_list)
			if(victim.ckey != ckey)
				continue
			victim.apply_status_effect(/datum/status_effect/debuff/soulbind_broken)
			victim.add_stress(/datum/stressevent/soulbind_tree_loss)
			REMOVE_TRAIT(victim, TRAIT_DENDOR_SOULBOUND, "SOULBIND")
			victim.mind.RemoveSpell(/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad)
			victim.mind.RemoveSpell(/obj/effect/proc_holder/spell/targeted/lesser_dryad_special)
			victim.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/minion_order/lesser_dryad)
			break

// Soulbind Broken Status Effect (permanent, applied on tree destruction)
/datum/status_effect/debuff/soulbind_broken
	id = "soulbind_broken"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/soulbind_broken
	effectedstats = list("strength" = -4, "speed" = -4, "perception" = -4, "intelligence" = -4, "constitution" = -4)
	duration = -1

/datum/status_effect/debuff/soulbind_broken/on_apply()
	. = ..()
	playsound(owner, 'sound/magic/soulsteal.ogg', 80, FALSE)
	to_chat(owner, span_userdanger("我的灵魂被撕下了一角，神圣联结已然破碎。我虚弱到了极点。"))

/atom/movable/screen/alert/status_effect/debuff/soulbind_broken
	name = "魂缚破碎"
	desc = "我的灵魂被撕下了一角，肉体与心智都因此衰弱。"
	icon_state = "debuff"

/datum/stressevent/soulbind_tree_loss
	timer = 60 MINUTES
	stressadd = 5
	desc = span_boldred("与我缔结魂缚的树倒下了。我感到自己的一部分被永远撕去了。")

//---- Harvest Bloomstone
/datum/druid_ritual/harvest_bloomstone
	name = "丰收花石"
	unique_tree_rite = TRUE // One stone per tree
	experience_payout = 50
	druid_ritual_tier = SKILL_LEVEL_EXPERT
	specific_offerings = list(
		/obj/item/natural/rock = 1,
		list(/obj/item/natural/cured/essence, /obj/item/grown/log/tree/small/essence, /obj/item/natural/stone) = 1, //XANTODO Custom handling on the stone
		/obj/item/alch/blessedseedpowder = 1,
	)

/datum/druid_ritual/harvest_bloomstone/accept_offering(obj/item/offering, mob/living/user, silent = FALSE)
	if(istype(offering, /obj/item/natural/stone))
		var/obj/item/natural/stone/offered_stone = offering
		if(offered_stone.magic_power < 5)
			to_chat(user, span_warning("石头的魔力必须达到+5，才能作为仪式供品。"))
			return FALSE
	return ..()

/// Harvest Bloomstone: a 20-use blessed seed powder stone (once per tree).
/// Offerings: 1 boulder + 1 enchanted stone (magic_power 10+) + 5 blessed seed powders.
/// Requires Expert Druidic Trickery to initiate (gated in open_ritual_menu).
/datum/druid_ritual/harvest_bloomstone/on_complete_rewards(mob/living/user)
	var/turf/user_turf = get_turf(user)
	var/obj/item/alch/bloomstone/new_stone = new(user_turf)
	user.put_in_hands(new_stone)
	to_chat(user, span_green("树根托起一块发光的石头，丰收花石随之升入我手中，充盈着树父祝福的能量。"))

//---- Fey Weaving
/datum/druid_ritual/fey_weaving
	name = "妖精编织"
	experience_payout = 50
	druid_ritual_tier = SKILL_LEVEL_EXPERT
	specific_offerings = list(
		list(/obj/item/magic/artifact, /obj/item/magic/leyline) = 1,
		/obj/item/alch/blessedseedpowder = 1,
	)

/// mushroom fey circle seeds (repeatable).
/// Offerings: 1 runed artifact or leyline shard + 4 blessed seed powder. Reward: 2 mushroom_fey seeds.
/datum/druid_ritual/fey_weaving/on_complete_rewards(mob/living/user)
	. = ..()
	var/turf/user_turf = get_turf(user)
	new /obj/item/seeds/mushroom_fey(user_turf)
	new /obj/item/seeds/mushroom_fey(user_turf)
	to_chat(user, span_green("两捧妖精蘑菇孢子从树根间升起，树父嘉奖了你的耐心。"))

/datum/druid_ritual/natures_temper
	name = "自然淬炼"
	unique_tree_rite = TRUE // Gives an armor set, can't mass print these
	experience_payout = 200
	druid_ritual_tier = SKILL_LEVEL_MASTER
	specific_offerings = list(
		/obj/item/reagent_containers/food/snacks/zizo_bane = 5,
		/obj/item/magic/artifact = 2,
		/obj/item/clothing/suit/roguetown/armor/leather/druid = 1,
		/obj/item/natural/head/volf = 1,
		list(/obj/item/natural/head/honeyspider, /obj/item/natural/head/mirespider) = 1,
		/obj/item/seeds/treesap = 1,
		/obj/item/alch/blessedseedpowder = 1,
		/datum/reagent/water/blessed = 30,
	)

/datum/druid_ritual/natures_temper/accept_offering(obj/item/offering, mob/living/user, silent)
	// Special handling for the armor
	if(istype(offering, /obj/item/clothing/suit/roguetown/armor/leather/druid))
		if(offering_tracker[offering.type] <= 0)
			to_chat(user, span_warning("这棵树一次只能淬炼一件护甲。"))
			return FALSE
		offering_tracker[offering.type]--
		ritual_holder.ritual_armor = offering
		offering.forceMove(ritual_holder.tree)
		if(!silent)
			playsound(get_turf(user), 'sound/magic/churn.ogg', 40, FALSE)
		return TRUE
	// Special handling for the blessed water
	if(offering?.reagents?.has_reagent(/datum/reagent/water/blessed))
		if(offering_tracker[/datum/reagent/water/blessed] <= 0)
			to_chat(user, span_warning("这棵树已经收到了足够的圣水。"))
			return FALSE
		var/amount_removed = offering.reagents.remove_reagent(/datum/reagent/water/blessed, offering_tracker[/datum/reagent/water/blessed])
		offering_tracker[/datum/reagent/water/blessed] -= amount_removed
		if(!silent)
			playsound(get_turf(user), 'sound/magic/churn.ogg', 40, FALSE)
		return TRUE
	return ..() // Everything else should work like normal

/// Nature's Temper: blessed druid armor + possible elven armor piece (once per tree).
/// Offerings: 5 zizo bane + 2 runed artifacts + druid armor + volf head + spider head +
///             tree seed + blessed seed powder + 30+ drams holy water.
/datum/druid_ritual/natures_temper/on_complete_rewards(mob/living/user)
	var/turf/user_turf = get_turf(user)
	if(!ritual_holder.ritual_armor || QDELETED(ritual_holder.ritual_armor))
		to_chat(user, span_warning("供奉的德鲁伊护甲遗失了，有什么东西打断了仪式。"))
		return
	// Destroy the offered druid armor.
	qdel(ritual_holder.ritual_armor)
	ritual_holder.ritual_armor = null
	// Yield blessed druid armor (upgraded chest).
	var/obj/item/clothing/suit/roguetown/armor/leather/druid/blessed/blessed_armor = new(user_turf)
	to_chat(user, span_green("[blessed_armor.name]自仪式中升起，树父已将活生生的力量祝入这件护甲。"))
	// 50% chance: random wood armor piece from elven black oak mercenaries (excluding chest).
	if(prob(50))
		var/list/bonus_pool = list(/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/druidic, /obj/item/clothing/gloves/roguetown/elven_gloves/druidic, /obj/item/clothing/shoes/roguetown/boots/elven_boots/druidic, /obj/item/clothing/cloak/forrestercloak/blessed)
		var/bonus_type = pick(bonus_pool)
		var/obj/item/bonus = new bonus_type(user_turf)
		to_chat(user, span_green("树根间还生出了[bonus.name]，这是额外的赠礼。"))

/datum/druid_ritual/winged_rebirth
	name = "有翼重生"
	unique_tree_rite = TRUE // One unlocked form per tree
	experience_payout = 0 // Need legendary so we don't even bother
	druid_ritual_tier = SKILL_LEVEL_LEGENDARY
	specific_offerings = list(
		/obj/item/natural/feather = 10,
		/obj/item/alch/bonemeal = 10,
		/obj/item/natural/cured/essence = 1,
		/obj/item/alch/bloomstone = 1,
	)

/datum/druid_ritual/winged_rebirth/accept_offering(obj/item/offering, mob/living/user, silent)
	// Special handling, make sure to delete the bloomstone
	if(istype(offering, /obj/item/alch/bloomstone) && (offering_tracker[/obj/item/alch/bloomstone] > 0))
		var/obj/item/alch/bloomstone/bloom_offering = offering
		bloom_offering.charges = 0
	return ..()

/// Winged Rebirth: choose a winged form and add it to Beast Form choices (once per tree).
/// Offerings: 10 feathers, 10 bonedust, 1 essence of wilderness, 1 harvest bloomstone.
/datum/druid_ritual/winged_rebirth/on_complete_rewards(mob/living/carbon/human/user)
	if(!ishuman(user))
		to_chat(user, span_warning("唯有人形生灵才能接受树父赐下的诡术祝福。"))
		return
	if(!user.mind)
		return
	var/obj/effect/proc_holder/spell/self/wildshape/ws = user.mind.get_spell(/obj/effect/proc_holder/spell/self/wildshape)
	if(!ws)
		to_chat(user, span_warning("我得先拥有野兽形态神迹，才能束缚新的形态。"))
		return

	var/already_has_bat  = (/mob/living/carbon/human/species/wildshape/bat  in ws.possible_shapes)
	var/already_has_crow = (/mob/living/carbon/human/species/wildshape/crow in ws.possible_shapes)
	if(already_has_bat && already_has_crow)
		to_chat(user, span_notice("这些有翼形态已经栖息在我的灵魂之中了。"))
		return

	if(!already_has_bat)
		ws.possible_shapes += /mob/living/carbon/human/species/wildshape/bat
	if(!already_has_crow)
		ws.possible_shapes += /mob/living/carbon/human/species/wildshape/crow
	to_chat(user, span_green("蝙蝠与乌鸦的形态知识在我灵魂中扎下了根。我现在能通过野兽形态化作它们了。"))

//==============================================================================
// Aura Procs
//==============================================================================

/// Applies or removes the bulwark slow on non-Dendor mobs within 5 tiles.
/// Called every 5 seconds when has_slow_aura is TRUE.
/// Applies a -4 speed stat debuff via status effect (8-second duration),
/// refreshed each tick so it stays active while in range.
/obj/structure/flora/roguetree/wise/sanctified/proc/update_slow_aura()
	var/list/in_range = list()
	for(var/mob/living/carbon/human/human_in_range in range(5, src))
		if(human_in_range?.patron?.type == /datum/patron/divine/dendor)
			continue
		if(human_in_range.stat != CONSCIOUS || human_in_range.incapacitated())
			continue
		in_range |= human_in_range
	// Remove modifier from mobs that left range or are now Dendor-eligible.
	// Collect removals first — mutating slowed_mobs during iteration skips elements in BYOND.
	var/list/to_remove = list()
	for(var/mob/living/slowed_mob in tree_data.slowed_mobs)
		if(QDELETED(slowed_mob) || !(slowed_mob in in_range))
			continue
		slowed_mob?.remove_status_effect(/datum/status_effect/debuff/sanctified_tree_slow)
		to_remove += slowed_mob
	tree_data.slowed_mobs -= to_remove
	// Apply/refresh debuff on mobs in range.
	for(var/mob/living/carbon/human/human_in_range in in_range)
		human_in_range.apply_status_effect(/datum/status_effect/debuff/sanctified_tree_slow)
		tree_data.slowed_mobs |= human_in_range

/// Heals Dendor followers within 5 tiles periodically like a healing miracle.
/// Also heals non-undead animals and lesser dryads in range.
/// Called every 60 seconds when has_heal_aura is TRUE.
/obj/structure/flora/roguetree/wise/sanctified/proc/pulse_heal_aura()
	var/healed_any = FALSE
	for(var/mob/living/carbon/human/human_in_range in range(5, src))
		if(human_in_range.patron?.type != /datum/patron/divine/dendor)
			continue
		if(human_in_range.stat == DEAD)
			continue
		if(human_in_range.has_status_effect(/datum/status_effect/buff/healing))
			continue
		human_in_range.apply_status_effect(/datum/status_effect/buff/healing, 2.5, FALSE, /datum/patron/divine/dendor)
		new /obj/effect/temp_visual/heal_rogue(get_turf(human_in_range))
		healed_any = TRUE
	// Also heal non-undead animals and lesser dryads within range.
	for(var/mob/living/simple_animal/animal_in_range in range(5, src))
		if(animal_in_range.mob_biotypes & MOB_UNDEAD)
			continue
		if(animal_in_range.stat == DEAD)
			continue
		if(animal_in_range.has_status_effect(/datum/status_effect/buff/healing))
			continue
		animal_in_range.apply_status_effect(/datum/status_effect/buff/healing, 2.5, FALSE, /datum/patron/divine/dendor)
		new /obj/effect/temp_visual/heal_rogue(get_turf(animal_in_range))
		healed_any = TRUE
	if(healed_any)
		playsound(get_turf(src), 'sound/magic/churn.ogg', 30, FALSE)

//==============================================================================
// Middle-Click Manual Heal
//==============================================================================

/// Middle-click handler for cat5 healing aura.
/// Applies a healing miracle to the Dendor follower. Per-player cooldown: 5 seconds after effect ends.
/obj/structure/flora/roguetree/wise/sanctified/MiddleClick(mob/living/carbon/human/user, params)
	if(!tree_data?.has_heal_aura)
		return
	if(!ishuman(user))
		return
	if(user.patron?.type != /datum/patron/divine/dendor)
		return
	if(user.stat != CONSCIOUS || user.incapacitated())
		return
	if(user.has_status_effect(/datum/status_effect/buff/healing))
		to_chat(user, span_warning("树父的温暖已经在我体内流动了。"))
		return
	var/cooldown_until = tree_data.heal_player_cooldowns[user.ckey]
	if(cooldown_until && world.time < cooldown_until)
		to_chat(user, span_warning("这棵树赐予我的疗愈尚未恢复，再等一会儿。"))
		return
	if(get_dist(user, src) > 1)
		to_chat(user, span_warning("我必须贴近这棵树，才能汲取它的力量。"))
		return
	to_chat(user, span_notice("我将双掌贴在神圣的树皮上，引导树父的暖流。"))
	if(!do_after(user, 3 SECONDS, target = src))
		return
	if(QDELETED(src))
		return
	if(user.has_status_effect(/datum/status_effect/buff/healing))
		to_chat(user, span_warning("树父的温暖已经在我体内流动了。"))
		return
	user.apply_status_effect(/datum/status_effect/buff/healing, 2.5, FALSE, /datum/patron/divine/dendor)
	new /obj/effect/temp_visual/heal_rogue(get_turf(user))
	playsound(get_turf(src), 'sound/magic/churn.ogg', 50, FALSE)
	to_chat(user, span_green("树父的温暖流入了我的伤口。"))
	// Per-player cooldown: 5 seconds after the 10-second effect expires
	tree_data.heal_player_cooldowns[user.ckey] = world.time + 15 SECONDS

/// Temporary -4 speed debuff applied by the Treefather's Bulwark aura.
/// Duration is 8 seconds — slightly longer than the 5-second aura tick —
/// so it stays on continuously while the player remains in range.
/datum/status_effect/debuff/sanctified_tree_slow
	id = "sanctified_tree_slow"
	duration = 8 SECONDS
	effectedstats = list(STATKEY_SPD = -4, STATKEY_STR = -2)

/datum/status_effect/debuff/sanctified_tree_slow/on_apply()
	. = ..()
	to_chat(owner, span_warning("靠近这棵树时，沉重的压迫与盘结树根缠住了我的脚步，让我的行动慢了下来。"))
