#define GOLDEN_FINGER_CKEY "kukuling"
#define GOLDEN_FINGER_SOURCE "z121_golden_finger"

// 管理身份可在同一具身体上解除或恢复。只查这一个连接，不遍历在线玩家。
SUBSYSTEM_DEF(z121_golden_finger)
	name = "金手指"
	flags = SS_NO_INIT
	wait = 1 SECONDS
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME

/datum/controller/subsystem/z121_golden_finger/fire(resumed = FALSE)
	var/client/player = GLOB.directory[GOLDEN_FINGER_CKEY]
	if(!player)
		return
	if(player.can_use_golden_finger())
		player.verbs |= /client/proc/z121_golden_finger
	else
		player.verbs -= /client/proc/z121_golden_finger
		QDEL_NULL(player.golden_finger_panel)

/client/var/datum/z121_golden_finger/golden_finger_panel

/client/proc/can_use_golden_finger()
	return ckey == GOLDEN_FINGER_CKEY && check_rights_for(src, R_ADMIN)

/client/proc/z121_golden_finger()
	set name = "金手指"
	set category = "IC"
	if(!can_use_golden_finger())
		return
	if(!ishuman(mob))
		to_chat(src, span_warning("需要控制人形角色才能使用金手指。"))
		return
	if(QDELETED(golden_finger_panel) || !golden_finger_panel.can_edit(mob))
		QDEL_NULL(golden_finger_panel)
		golden_finger_panel = new(mob)
	golden_finger_panel.ui_interact(mob)

/datum/z121_golden_finger
	var/mob/living/carbon/human/owner
	var/client/player
	var/datum/admins/permission_holder
	var/list/trait_catalog = list()

/datum/z121_golden_finger/New(mob/living/carbon/human/user)
	. = ..()
	owner = user
	player = user.client
	permission_holder = player.holder
	RegisterSignal(user, list(COMSIG_MOB_LOGOUT, COMSIG_QDELETING), PROC_REF(end_session))
	for(var/define_name in GLOB.all_traits)
		trait_catalog[GLOB.all_traits[define_name]] = define_name
	for(var/trait in GLOB.roguetraits)
		if(!(trait in trait_catalog))
			trait_catalog[trait] = trait

/datum/z121_golden_finger/proc/end_session()
	SIGNAL_HANDLER
	qdel(src)

/datum/z121_golden_finger/Destroy()
	SStgui.close_uis(src)
	if(owner)
		UnregisterSignal(owner, list(COMSIG_MOB_LOGOUT, COMSIG_QDELETING))
	if(player?.golden_finger_panel == src)
		player.golden_finger_panel = null
	owner = null
	player = null
	permission_holder = null
	return ..()

/datum/z121_golden_finger/proc/can_edit(mob/user)
	return !QDELETED(owner) && user == owner && player && user.client == player && player.mob == owner && player.golden_finger_panel == src && player.holder == permission_holder && player.can_use_golden_finger()

/datum/z121_golden_finger/ui_state(mob/user)
	return can_edit(user) ? GLOB.always_state : GLOB.never_state

/datum/z121_golden_finger/ui_status(mob/user, datum/ui_state/state)
	return can_edit(user) ? UI_INTERACTIVE : UI_CLOSE

/datum/z121_golden_finger/ui_interact(mob/user, datum/tgui/ui)
	if(!can_edit(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GoldenFinger", "金手指")
		ui.open()

// 目录既是界面数据来源，也是服务端领取白名单。配方使用稳定的类型路径区分同名药剂。
/datum/z121_golden_finger/proc/item_catalog()
	var/static/list/catalog
	if(catalog)
		return catalog
	catalog = list()
	var/coin = /obj/item/roguecoin/gold
	catalog["[coin]"] = list("type" = coin, "name" = "泽纳里金币", "category" = "钱币")
	for(var/datum/alch_cauldron_recipe/recipe as anything in GLOB.alch_cauldron_recipes)
		if(length(recipe.output_reagents))
			var/label = recipe.name
			if(length(recipe.output_reagents) == 1)
				var/datum/reagent/product = recipe.output_reagents[1]
				var/product_name = get_stat_display_name(initial(product.name))
				if(product_name != label)
					label = "[label]（[product_name]）"
			catalog["[recipe.type]"] = list("name" = label, "category" = "药水", "contents" = recipe.output_reagents)
	for(var/datum/alch_refining_formula/formula as anything in get_alch_refining_formulas())
		if(length(formula.output_reagents))
			catalog["[formula.type]"] = list("name" = formula.name, "category" = "药水", "contents" = formula.output_reagents, "booze" = formula.get_boozepwr())
	var/datum/reagent/vitae = /datum/reagent/medicine/vitae_essence
	catalog["[vitae]"] = list("name" = initial(vitae.name), "category" = "药水", "contents" = list(/datum/reagent/medicine/vitae_essence = 1))

	// 单独装瓶、台面调制和特殊交互的成品保留原物品类型与剂量。
	var/list/bottles = list(
		/obj/item/lovepotion,
		/obj/item/reagent_containers/glass/bottle/revival,
		/obj/item/reagent_containers/glass/bottle/frankenbrew,
		/obj/item/reagent_containers/glass/bottle/sleep = /datum/reagent/sleep_powder,
		/obj/item/reagent_containers/glass/bottle/rogue/poison = /datum/reagent/toxin/killersice,
		/obj/item/reagent_containers/glass/bottle/rogue/gasification_body = /datum/reagent/gasification_body_potion,
		/obj/item/reagent_containers/glass/bottle/rogue/blood_tonic = /datum/reagent/medicine/blood_tonic,
		/obj/item/reagent_containers/glass/bottle/rogue/lactation_enhancer = /datum/reagent/medicine/lactation_enhancer,
		/obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure = /datum/reagent/rotcure,
		/obj/item/reagent_containers/glass/bottle/alchemical/spidervenom_paralytic = /datum/reagent/toxin/spidervenom_paralytic,
		/obj/item/reagent_containers/glass/bottle/alchemical/blessedwater = /datum/reagent/water/blessed,
		/obj/item/reagent_containers/glass/bottle/alchemical/fermented_crab = /datum/reagent/fermented_crab,
	)
	for(var/obj/item/bottle as anything in bottles)
		var/datum/reagent/filling = bottles[bottle]
		catalog["[bottle]"] = list("type" = bottle, "name" = filling ? initial(filling.name) : initial(bottle.name), "category" = "药水")
	var/list/gems = subtypesof(/obj/item/roguegem) - list(/obj/item/roguegem/random, /obj/item/roguegem/randomgeode)
	gems += subtypesof(/obj/item/gem_device)
	gems += typesof(/obj/item/pearl)
	gems += list(/obj/item/riddleofsteel, /obj/item/carvedgem/rose/rawrose, /obj/item/carvedgem/shell/rawshell, /obj/item/carvedgem/chitin/rawchitin)
	for(var/obj/item/gem as anything in gems)
		catalog["[gem]"] = list("type" = gem, "name" = initial(gem.name), "category" = "宝石")
	return catalog

/datum/z121_golden_finger/proc/claim_item(id)
	var/list/catalog = item_catalog()
	var/list/entry = catalog[id]
	var/turf/spot = get_turf(owner)
	if(!entry || !spot)
		return FALSE
	var/obj/item/item
	var/list/contents = entry["contents"]
	var/item_type = entry["type"]
	if(contents)
		var/total = 0
		for(var/reagent in contents)
			total += contents[reagent]
		if(total <= 0)
			return FALSE
		var/obj/item/reagent_containers/glass/bottle/rogue/bottle = new(spot)
		for(var/reagent in contents)
			var/list/data = entry["booze"] ? list("boozepwr" = entry["booze"]) : null
			bottle.reagents.add_reagent(reagent, bottle.volume * contents[reagent] / total, data)
		item = bottle
	else if(item_type == /obj/item/roguecoin/gold)
		item = new /obj/item/roguecoin/gold(spot, 20)
	else
		item = new item_type(spot)
	var/held = owner.put_in_hands(item)
	to_chat(owner, span_notice("已领取[entry["name"]]，[held ? "已放入手中" : "已放在脚边"]。"))
	return TRUE

/datum/z121_golden_finger/ui_static_data(mob/user)
	if(!can_edit(user))
		return list()
	var/list/traits = list()
	for(var/id in trait_catalog)
		traits += list(list("id" = id, "symbol" = trait_catalog[id]))
	var/list/items = list()
	var/list/catalog = item_catalog()
	for(var/id in catalog)
		var/list/entry = catalog[id]
		items += list(list("id" = id, "name" = entry["name"], "category" = entry["category"]))
	return list("catalog" = traits, "items" = items)

/datum/z121_golden_finger/ui_data(mob/user)
	if(!can_edit(user))
		return list()
	var/list/stats = list()
	for(var/id in MOBSTATS)
		stats += list(list("id" = id, "name" = get_stat_display_name(id), "value" = owner.get_stat(id)))
	var/list/owned = list()
	for(var/trait in owner.status_traits)
		owned += trait
	var/datum/skill_holder/holder = owner.ensure_skills()
	var/list/skills = list()
	for(var/path in SSskills.all_skills)
		var/datum/skill/skill = GetSkillRef(path)
		var/datum/skill/category = skill.abstract_type
		skills += list(list("id" = "[path]", "name" = skill.name, "category" = initial(category.name), "base" = holder.known_skills[skill] || 0, "effective" = holder.get_skill_level(path)))
	return list("stats" = stats, "owned" = owned, "skills" = skills)

/datum/z121_golden_finger/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || !ui || ui.user != usr || !can_edit(usr))
		return
	var/id = params["id"]
	if(!istext(id))
		return FALSE
	var/value = params["value"]
	switch(action)
		if("claim_item")
			return claim_item(id)
		if("set_stat", "step_stat")
			if(!(id in MOBSTATS) || !isnum(value))
				return FALSE
			if(action == "step_stat")
				if(value != 1 && value != -1)
					return FALSE
				value += owner.get_stat(id)
			if(value != round(value) || value < 1 || value > 20)
				return FALSE
			z121_stat_delta(owner, id, value - z121_stat_total(owner, id))
			owner.update_stamina()
			owner.updatehealth()
		if("add_trait")
			if(!(id in trait_catalog) || HAS_TRAIT(owner, id))
				return FALSE
			ADD_TRAIT(owner, id, GOLDEN_FINGER_SOURCE)
		if("remove_trait")
			if(!HAS_TRAIT(owner, id))
				return FALSE
			var/list/sources = owner.status_traits[id]
			for(var/source in sources.Copy())
				REMOVE_TRAIT(owner, id, source)
		if("set_skill")
			var/path = text2path(id)
			if(!(path in SSskills.all_skills) || !isnum(value) || value != round(value) || value < SKILL_LEVEL_NONE || value > SKILL_LEVEL_LEGENDARY)
				return FALSE
			var/datum/skill_holder/holder = owner.ensure_skills()
			var/datum/skill/skill = GetSkillRef(path)
			if((holder.known_skills[skill] || 0) != value)
				var/list/brackets = holder.get_xp_brackets(value)
				holder.adjust_experience(path, brackets[1] - (holder.skill_experience[skill] || 0), TRUE)
		else
			return FALSE
	return TRUE

#undef GOLDEN_FINGER_SOURCE
#undef GOLDEN_FINGER_CKEY
