// 投影只记录类型，不保留原件引用或复制运行时状态。
#define PROJECTION_MEMORY_LIMIT 12
#define PROJECTION_ACTIVE_LIMIT 4
#define PROJECTION_LIFETIME (5 MINUTES)

/datum/action/cooldown/spell/z121/self/projection_spell
	name = "投影魔术"
	desc = "以心描摹兵刃的结构，将亲手解析过的武器铭刻于记忆，再循着记忆中的纹路，以魔力重铸其形。自剑脊至锋刃，自外形至骨架，唯有真正理解之物，方能于掌中再现。\n\n铁与钢、青铜与白银，乃至深沉的黑钢，皆可成为心中剑冢的一部分。然而，刀剑、长枪、弓弩与坚盾，皆可循其形理重现；唯有火器的机巧、神器背负的奇迹，以及兵刃中寄宿的异能，无法被这道术式解明。\n\n投影虽为赝作，锋刃依然足以迎敌。只是借魔力而生之物终非实物，待那一缕维系形体的魔力散尽，掌中的兵刃也将如碎光般消逝。"
	spell_tier = 3
	point_cost = 5
	primary_resource_cost = 40
	hold_drain = 0
	// 引导由菜单选择后的 do_after 完成，不能再叠加鼠标蓄力。
	charge_time = 0
	cooldown_time = 15 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_NO_MOVE
	gesture_required = TRUE
	associated_skill = /datum/skill/magic/arcane
	xp_gain = TRUE
	button_icon = 'modular_z121/icon/custompell.dmi'
	button_icon_state = "projection_spell"
	invocations = list("投影展开——循记忆铸其骨，以魔力现其锋！")
	invocation_type = "shout"
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	sound = 'sound/magic/whiteflame.ogg'
	var/list/memorized_templates = list()
	var/list/projected_weapons = list()
	var/projection_busy = FALSE
	var/projecting = FALSE
	var/chant_spoken = FALSE
	var/pending_template
	var/mob/living/analyzing_user
	var/obj/item/analyzing_weapon
	var/analysis_interrupted = FALSE
	// 黑名单按继承关系阻止特殊效果；普通新武器和外观变体自动开放。
	var/static/list/special_templates = list(
		/obj/item/rogueweapon/lordscepter,
		/obj/item/rogueweapon/woodstaff/aries,
		/obj/item/rogueweapon/mace/stunmace,
		/obj/item/rogueweapon/mace/maul/grand/malum,
		/obj/item/rogueweapon/spear/keep_standard,
		/obj/item/rogueweapon/spear/militia,
		/obj/item/rogueweapon/huntingknife/idagger/steel/profane,
		/obj/item/rogueweapon/sword/sabre/freifechter,
		/obj/item/rogueweapon/sword/long/judgement,
		/obj/item/rogueweapon/sword/long/exe/berserk/dragonslayer,
		/obj/item/rogueweapon/greatsword/moonlight_greatsword,
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/z121_magic,
		/obj/item/rogueweapon/shield/steam,
		/obj/item/rogueweapon/shield/tower/metal/zizo,
		/obj/item/rogueweapon/flail/peasantwarflail/matthios,
		/obj/item/rogueweapon/huntingknife/idagger/steel/kris/zizo,
		/obj/item/rogueweapon/huntingknife/combat/messer/graggar,
		/obj/item/rogueweapon/huntingknife/idagger/steel/matthios,
		/obj/item/rogueweapon/huntingknife/idagger/steel/rondel/baotha,
		/obj/item/rogueweapon/greataxe/steel/doublehead/graggar,
		/obj/item/rogueweapon/spear/billhook/zizo,
		/obj/item/rogueweapon/spear/partizan/baotha,
		/obj/item/rogueweapon/greatsword/avantyne,
		/obj/item/rogueweapon/sword/long/zizo,
		/obj/item/rogueweapon/sword/arming/zizo,
		/obj/item/rogueweapon/sword/rapier/zizo,
		/obj/item/rogueweapon/sword/long/kriegmesser/zizo,
	)

/datum/action/cooldown/spell/z121/self/projection_spell/Destroy()
	clear_analysis()
	dispel_projections()
	memorized_templates.Cut()
	return ..()

/datum/action/cooldown/spell/z121/self/projection_spell/Remove(mob/living/user)
	dispel_projections()
	return ..()

// 按钮必须在投影冷却期间继续允许打开管理菜单。
/datum/action/cooldown/spell/z121/self/projection_spell/z121_ready(mob/user)
	return !projecting || ..()

/datum/action/cooldown/spell/z121/self/projection_spell/Trigger(trigger_flags)
	var/mob/living/user = owner
	if(projection_busy || !valid_projection_user(user))
		return FALSE
	projection_busy = TRUE
	z121_choose_targets(user)
	if(!QDELETED(src))
		projection_busy = FALSE
		projecting = FALSE
		chant_spoken = FALSE
		pending_template = null
	return TRUE

/datum/action/cooldown/spell/z121/self/projection_spell/proc/valid_projection_user(mob/living/user)
	return !QDELETED(src) && !QDELETED(user) && owner == user && !user.incapacitated() && can_cast_spell(TRUE) && get_turf(user)

// 弓弩在主线也继承 /gun，必须先单独识别，不能笼统禁止 /gun。
/datum/action/cooldown/spell/z121/self/projection_spell/proc/is_projection_template(template)
	if(!ispath(template, /obj/item))
		return FALSE
	var/is_bow_weapon = ispath(template, /obj/item/gun/ballistic/revolver/grenadelauncher/bow) || ispath(template, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow) || ispath(template, /obj/item/gun/ballistic/revolver/grenadelauncher/sling)
	if(!is_bow_weapon && !ispath(template, /obj/item/rogueweapon) && !ispath(template, /obj/item/clothing/gloves/roguetown/knuckles))
		return FALSE
	// 剑鞘与炮兵观测器虽使用 rogueweapon 父类，本身不是武器。
	if(ispath(template, /obj/item/rogueweapon/scabbard) || ispath(template, /obj/item/rogueweapon/palantir))
		return FALSE
	var/obj/item/weapon_type = template
	if(!initial(weapon_type.name) || (initial(weapon_type.item_flags) & (ABSTRACT | DROPDEL)))
		return FALSE
	var/template_text = "[template]/"
	if(findtext(template_text, "/relic/") || findtext(template_text, "/preblessed/"))
		return FALSE
	for(var/special_type in special_templates)
		if(ispath(template, special_type))
			return FALSE
	return TRUE

/datum/action/cooldown/spell/z121/self/projection_spell/proc/can_analyze(obj/item/weapon)
	if(!istype(weapon) || QDELETED(weapon) || !is_projection_template(weapon.type) || (weapon.item_flags & (ABSTRACT | DROPDEL)))
		return FALSE
	if(weapon.GetComponent(/datum/component/conjured_item) || weapon.GetComponent(/datum/component/cursed_item))
		return FALSE
	var/datum/component/skill_blessed/skill_effect = weapon.GetComponent(/datum/component/skill_blessed)
	if(skill_effect?.unique)
		return FALSE
	var/datum/component/silverbless/blessing = weapon.GetComponent(/datum/component/silverbless)
	return !blessing?.is_blessed

/datum/action/cooldown/spell/z121/self/projection_spell/proc/remember_template(template)
	if(!is_projection_template(template) || (template in memorized_templates) || length(memorized_templates) >= PROJECTION_MEMORY_LIMIT)
		return FALSE
	memorized_templates += template
	return TRUE

/datum/action/cooldown/spell/z121/self/projection_spell/proc/template_choices()
	var/list/choices = list()
	for(var/template in memorized_templates)
		var/obj/item/weapon_type = template
		// 同名兵刃用记忆序号区分，不向玩家显示内部类型路径。
		choices["[initial(weapon_type.name)] · [length(choices) + 1]"] = template
	return choices

/datum/action/cooldown/spell/z121/self/projection_spell/get_spell_statistics(mob/living/user)
	. = ..()
	. += span_info("结构解析：3秒；投影引导：2秒。")
	. += span_info("记忆容量：12种；同时投影：4把；投影寿命：5分钟。")

/datum/action/cooldown/spell/z121/self/projection_spell/z121_choose_targets(mob/user = usr)
	var/operation = input(user, "选择投影魔术的操作", name) as null|anything in list("解析手持武器", "投影记忆", "遗忘模板", "解除全部投影")
	if(!operation || !valid_projection_user(user))
		return
	switch(operation)
		if("解析手持武器")
			analyze_weapon(user)
		if("投影记忆")
			project_memory(user)
		if("遗忘模板")
			var/list/choices = template_choices()
			if(!length(choices))
				to_chat(user, span_notice("我尚未记忆任何武器。"))
				return
			var/choice = input(user, "选择要遗忘的模板，已有投影不会消失。", name) as null|anything in choices
			if(choice && valid_projection_user(user))
				memorized_templates -= choices[choice]
				to_chat(user, span_notice("我让这件兵刃的结构从记忆中淡去。"))
		if("解除全部投影")
			dispel_projections()
			to_chat(user, span_notice("我解除了所有尚存的投影。"))

/datum/action/cooldown/spell/z121/self/projection_spell/proc/analysis_continues(mob/living/user, obj/item/weapon)
	return !analysis_interrupted && valid_projection_user(user) && user.get_active_held_item() == weapon && can_analyze(weapon)

/datum/action/cooldown/spell/z121/self/projection_spell/proc/interrupt_analysis(datum/source)
	SIGNAL_HANDLER
	analysis_interrupted = TRUE

/datum/action/cooldown/spell/z121/self/projection_spell/proc/clear_analysis()
	if(analyzing_user)
		UnregisterSignal(analyzing_user, list(COMSIG_CARBON_SWAPHANDS, COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	if(analyzing_weapon)
		UnregisterSignal(analyzing_weapon, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	analyzing_user = null
	analyzing_weapon = null

/datum/action/cooldown/spell/z121/self/projection_spell/proc/analyze_weapon(mob/living/user)
	var/obj/item/weapon = user.get_active_held_item()
	if(!can_analyze(weapon))
		to_chat(user, span_warning("这件物品并非可解析的兵器，或蕴含着无法重现的力量。"))
		return
	if(weapon.type in memorized_templates)
		to_chat(user, span_notice("我已经记住了这种武器的结构。"))
		return
	if(length(memorized_templates) >= PROJECTION_MEMORY_LIMIT)
		to_chat(user, span_warning("记忆已满，我需要先遗忘一个模板。"))
		return
	if(!z121_check(TRUE, user))
		return
	analysis_interrupted = FALSE
	analyzing_user = user
	analyzing_weapon = weapon
	RegisterSignal(user, list(COMSIG_CARBON_SWAPHANDS, COMSIG_MOVABLE_MOVED, COMSIG_QDELETING), PROC_REF(interrupt_analysis))
	RegisterSignal(weapon, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING), PROC_REF(interrupt_analysis))
	user.say("结构，解析。以目识其形，以心铭其骨。", forced = "spell")
	var/completed = do_after(user, 3 SECONDS, target = weapon, extra_checks = CALLBACK(src, PROC_REF(analysis_continues), user, weapon))
	if(QDELETED(src))
		return
	clear_analysis()
	if(!completed || !analysis_continues(user, weapon) || !z121_check(TRUE, user))
		to_chat(user, span_warning("解析中断，兵刃的结构未能铭刻于心。"))
		return
	if(remember_template(weapon.type))
		to_chat(user, span_notice("我记住了[weapon]的结构（[length(memorized_templates)]/[PROJECTION_MEMORY_LIMIT]）。"))

/datum/action/cooldown/spell/z121/self/projection_spell/proc/project_memory(mob/living/user)
	var/list/choices = template_choices()
	if(!length(choices))
		to_chat(user, span_warning("我需要先解析一件武器。"))
		return
	var/choice = input(user, "选择要投影的武器", name) as null|anything in choices
	if(!choice || !valid_projection_user(user))
		return
	if(length(projected_weapons) >= PROJECTION_ACTIVE_LIMIT)
		to_chat(user, span_warning("我已经维持了四把投影，无法再构筑新的兵刃。"))
		return
	projecting = TRUE
	pending_template = choices[choice]
	if(!z121_check(TRUE, user))
		return
	invocation(user)
	var/completed = do_after(user, 2 SECONDS, target = user, extra_checks = CALLBACK(src, PROC_REF(valid_projection_user), user))
	if(QDELETED(src))
		return
	if(!completed || !valid_projection_user(user))
		to_chat(user, span_warning("魔力的纹路散开，投影未能成形。"))
		return
	// 只在完成引导后预留并结算冷却，菜单取消不触碰已有冷却。
	if(!z121_check(FALSE, user))
		return
	if(!z121_cast_selected(null, user = user) && !QDELETED(src))
		z121_cancel(user)

/datum/action/cooldown/spell/z121/self/projection_spell/invocation(mob/user = usr)
	if(chant_spoken)
		return
	. = ..()
	chant_spoken = TRUE

/datum/action/cooldown/spell/z121/self/projection_spell/z121_apply(atom/cast_on)
	var/mob/living/user = owner
	if(!projection_busy || !projecting || QDELETED(user) || user.incapacitated() || owner != user)
		return FALSE
	var/obj/item/weapon = create_projection(pending_template, user.drop_location())
	if(!weapon)
		return FALSE
	user.put_in_hands(weapon)
	user.visible_message(span_notice("[user] 指间的魔力凝成了一柄泛着微光的兵刃。"), span_notice("记忆中的兵刃沿着魔力的纹路凝为实体。"))
	..()
	return TRUE

/datum/action/cooldown/spell/z121/self/projection_spell/proc/create_projection(template, turf/destination)
	if(!destination || !is_projection_template(template) || !(template in memorized_templates) || length(projected_weapons) >= PROJECTION_ACTIVE_LIMIT)
		return null
	var/obj/item/weapon = new template(destination)
	// 同时复核原生组件：预祝福和其他特殊模板不得借记忆接口绕过检查。
	if(!can_analyze(weapon))
		qdel(weapon)
		return null
	weapon.apply_quality(null, null, ITEM_QUALITY_STANDARD)
	weapon.blade_dulling = DULLING_SHAFT_CONJURED
	weapon.metalizer_result = null
	if(istype(weapon, /obj/item/gun/ballistic))
		var/obj/item/gun/ballistic/ranged_weapon = weapon
		QDEL_NULL(ranged_weapon.chambered)
		if(ranged_weapon.magazine)
			for(var/obj/item/ammo as anything in ranged_weapon.magazine.stored_ammo.Copy())
				qdel(ammo)
			ranged_weapon.magazine.stored_ammo.Cut()
		ranged_weapon.update_icon()
	weapon.AddComponent(/datum/component/conjured_item, "#78dfff")
	weapon.AddComponent(/datum/component/z121_projection_lifetime, PROJECTION_LIFETIME)
	projected_weapons += weapon
	RegisterSignal(weapon, COMSIG_QDELETING, PROC_REF(on_projection_deleted))
	return weapon

/datum/action/cooldown/spell/z121/self/projection_spell/proc/on_projection_deleted(obj/item/weapon)
	SIGNAL_HANDLER
	projected_weapons -= weapon
	UnregisterSignal(weapon, COMSIG_QDELETING)

/datum/action/cooldown/spell/z121/self/projection_spell/proc/dispel_projections()
	for(var/obj/item/weapon as anything in projected_weapons.Copy())
		qdel(weapon)
	projected_weapons.Cut()

// 寿命附着在投影本体；换持有者、收纳、掉线均不会重置计时。
/datum/component/z121_projection_lifetime
	var/expiry_timer

/datum/component/z121_projection_lifetime/Initialize(duration = PROJECTION_LIFETIME)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	expiry_timer = addtimer(CALLBACK(src, PROC_REF(expire)), duration, TIMER_STOPPABLE)
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/z121_projection_lifetime/Destroy()
	deltimer(expiry_timer)
	return ..()

/datum/component/z121_projection_lifetime/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_notice("这是以魔力重现的临时投影，会在成形五分钟后消散。")

/datum/component/z121_projection_lifetime/proc/expire()
	var/obj/item/weapon = parent
	weapon.visible_message(span_notice("投影的轮廓渐渐破碎，化作散落的魔力微光。"))
	qdel(weapon)

#undef PROJECTION_MEMORY_LIMIT
#undef PROJECTION_ACTIVE_LIMIT
#undef PROJECTION_LIFETIME
