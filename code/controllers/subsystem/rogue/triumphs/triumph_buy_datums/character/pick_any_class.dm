/datum/triumph_buy/pick_any_class
	triumph_buy_id = "PickAny"
	desc = "获得一次自由选职业的机会，可在选择职业时跳过职业限制！警告：可能存在缺陷。"
	triumph_cost = 5
	category = TRIUMPH_CAT_CHARACTER
	pre_round_only = FALSE
	visible_on_active_menu = FALSE

// We fire this on activate, also DAMN is this nasty
/datum/triumph_buy/pick_any_class/on_activate()
	if(!SSrole_class_handler.special_session_queue[ckey_of_buyer])
		SSrole_class_handler.special_session_queue[ckey_of_buyer] = list()

	var/datum/advclass/pick_everything/turbo_slop
	if(!SSrole_class_handler.special_session_queue[ckey_of_buyer][triumph_buy_id])
		turbo_slop = new()
		turbo_slop.maximum_possible_slots = 1
		SSrole_class_handler.special_session_queue[ckey_of_buyer][triumph_buy_id] = turbo_slop
	else
		turbo_slop = SSrole_class_handler.special_session_queue[ckey_of_buyer][triumph_buy_id]
		turbo_slop.maximum_possible_slots += 1

// It should be there you know? lol 
// If not we are desyncing somehow
/datum/triumph_buy/pick_any_class/on_removal()
	SSrole_class_handler.special_session_queue[ckey_of_buyer].Remove(triumph_buy_id)


//For triumph buy pick-all
/datum/advclass/pick_everything
	name = "Pick-Classes"
	tutorial = "出生时将打开一个额外菜单，让你从所有未被禁用的职业中自由选择。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	maximum_possible_slots = 0

	outfit = null

/datum/advclass/pick_everything/post_equip(mob/living/carbon/human/H)
	..()
	var/list/possible_classes = list()
	for(var/datum/advclass/CHECKS in SSrole_class_handler.sorted_class_categories[CTAG_ALLCLASS])
		if(CTAG_DISABLED in CHECKS.category_tags)
			continue
		possible_classes += CHECKS

	var/datum/advclass/C = input(H.client, "我的职业是什么？", "冒险") as null|anything in possible_classes
	C.equipme(H)
