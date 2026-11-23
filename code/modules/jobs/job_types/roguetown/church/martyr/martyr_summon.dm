/obj/effect/martyr_weapon_manifest
	name = ""
	anchored = TRUE
	density = FALSE
	mouse_opacity = FALSE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER

/obj/effect/proc_holder/spell/targeted/martyr_select_weapon
	name = "选择神赐武器"
	desc = "选择当你举起祈祷时，十神将从天而降赐予你的武器。"
	clothes_req = FALSE
	range = -1
	include_user = TRUE
	recharge_time = 0.5 SECONDS
	chargedloop = /datum/looping_sound/invokegen
	action_icon = 'icons/mob/actions/martyr.dmi'
	action_icon_state = "martyr_summon"
	overlay_state = "martyr_summon"
	overlay_icon = 'icons/mob/actions/martyr.dmi'
	invocation_type = "none"
	spell_tier = 2
	cost = 1
	antimagic_allowed = TRUE

	var/selected_weapon = /obj/item/rogueweapon/sword/long/martyr
	var/list/selected_invocations = list("阿斯特拉塔，将你裁决之剑置于我手！")
	var/obj/effect/proc_holder/spell/invoked/martyr_summon_weapon/summon_weapon

/obj/effect/proc_holder/spell/targeted/martyr_select_weapon/proc/apply_manifest_sprite(obj/effect/martyr_weapon_manifest/manifest)
	if(!manifest)
		return

	switch(selected_weapon)
		if(/obj/item/rogueweapon/sword/long/martyr)
			manifest.icon = 'icons/roguetown/weapons/swords64.dmi'
			manifest.icon_state = "martyrsword"

		if(/obj/item/rogueweapon/greataxe/steel/doublehead/martyr)
			manifest.icon = 'icons/roguetown/weapons/axes64.dmi'
			manifest.icon_state = "martyraxe"

		if(/obj/item/rogueweapon/mace/goden/martyr)
			manifest.icon = 'icons/roguetown/weapons/blunt64.dmi'
			manifest.icon_state = "martyrmace"

		if(/obj/item/rogueweapon/spear/partizan/martyr)
			manifest.icon = 'icons/roguetown/weapons/polearms64.dmi'
			manifest.icon_state = "martyrtrident"

		if(/obj/item/rogueweapon/halberd/bardiche/scythe/martyr)
			manifest.icon = 'icons/roguetown/weapons/polearms64.dmi'
			manifest.icon_state = "martyrscyth"

		else
			manifest.icon = 'icons/roguetown/weapons/polearms64.dmi'
			manifest.icon_state = "martyrscyth"

/obj/effect/proc_holder/spell/targeted/martyr_select_weapon/cast(list/targets, mob/user)
	. = ..()

	var/list/weapons_of_choice = list(
		"神赐长剑",
		"神赐战斧",
		"神赐钉锤",
		"神赐三叉戟",
		"神赐镰刀",
	)

	var/chosen_weapon = tgui_input_list(user, "哪件圣物将回应你的誓言？", "殉道者的武器", weapons_of_choice)
	if(!chosen_weapon)
		return FALSE

	switch(chosen_weapon)
		if("神赐长剑")
			selected_weapon = /obj/item/rogueweapon/sword/long/martyr
			selected_invocations = list("阿斯特拉塔，将你裁决之剑置于我手！")

		if("神赐战斧")
			selected_weapon = /obj/item/rogueweapon/greataxe/steel/doublehead/martyr
			selected_invocations = list("拉沃克斯，以力量之武器赐福于我！")

		if("神赐钉锤")
			selected_weapon = /obj/item/rogueweapon/mace/goden/martyr
			selected_invocations = list("玛勒姆，为我锻造一柄意志不灭之锤！")

		if("神赐三叉戟")
			selected_weapon = /obj/item/rogueweapon/spear/partizan/martyr
			selected_invocations = list("阿比索尔，从深渊之底赐我一柄三叉戟！")

		if("神赐镰刀")
			selected_weapon = /obj/item/rogueweapon/halberd/bardiche/scythe/martyr
			selected_invocations = list("登多尔，以根与藤为我编织武器！")

	if(summon_weapon)
		summon_weapon.invocations = selected_invocations
		summon_weapon.sync_weapon_button(user)

	return TRUE

/obj/effect/proc_holder/spell/targeted/martyr_select_weapon/proc/get_weapon_ui_state()
	switch(selected_weapon)
		if(/obj/item/rogueweapon/sword/long/martyr)
			return "martyrsword"
		if(/obj/item/rogueweapon/greataxe/steel/doublehead/martyr)
			return "martyraxe"
		if(/obj/item/rogueweapon/mace/goden/martyr)
			return "martyrmace"
		if(/obj/item/rogueweapon/spear/partizan/martyr)
			return "martyrtrident"
		if(/obj/item/rogueweapon/halberd/bardiche/scythe/martyr)
			return "martyrscyth"

	return "martyrsword"

/obj/effect/proc_holder/spell/invoked/martyr_summon_weapon
	name = "召唤神赐武器"
	desc = "将选定的武器自天而降，召入你手中。"
	clothes_req = FALSE
	recharge_time = 30 SECONDS
	chargedloop = /datum/looping_sound/invokegen
	antimagic_allowed = TRUE
	action_icon = 'icons/mob/actions/martyr.dmi'
	action_icon_state = "spell0"
	action_background_icon_state = "bg_spell"

	overlay_icon = 'icons/mob/actions/martyr.dmi'
	overlay_state = "martyrsword"
	overlay_alpha = 255

	invocations = list("阿斯特拉塔，将你裁决之剑置于我手！")
	invocation_type = "shout"
	spell_tier = 2
	cost = 10

	var/obj/effect/proc_holder/spell/targeted/martyr_select_weapon/weapon_select

/obj/effect/proc_holder/spell/invoked/martyr_summon_weapon/on_gain(mob/living/user)
	. = ..()
	sync_weapon_button(user)

/obj/effect/proc_holder/spell/invoked/martyr_summon_weapon/proc/sync_weapon_button(mob/user)
	if(!weapon_select)
		return

	var/new_state = weapon_select.get_weapon_ui_state()

	action_icon = 'icons/mob/actions/martyr.dmi'
	action_icon_state = "spell0"
	action_background_icon_state = "bg_spell"
	overlay_icon = 'icons/mob/actions/martyr.dmi'
	overlay_state = new_state
	overlay_alpha = 255

	if(action)
		if(user?.hud_used && action.viewers && action.viewers[user.hud_used])
			refresh_one_weapon_button(action.viewers[user.hud_used])
		else
			for(var/datum/hud/H as anything in action.viewers)
				refresh_one_weapon_button(action.viewers[H])

/obj/effect/proc_holder/spell/invoked/martyr_summon_weapon/proc/lightning_summon_fx(mob/living/carbon/human/user)
	for(var/mob/living/carbon/M in viewers(world.view, user))
		M.lightning_flashing = TRUE
		M.update_sight()
		addtimer(CALLBACK(M, TYPE_PROC_REF(/mob/living/carbon, reset_lightning)), 2)

	var/turf/T = get_step(get_step(user, NORTH), NORTH)
	if(T)
		T.Beam(user, icon_state = "lightning[rand(1,12)]", time = 5)

	playsound(user, 'sound/magic/lightning.ogg', 100, FALSE)

/obj/effect/proc_holder/spell/invoked/martyr_summon_weapon/cast(list/targets, mob/living/carbon/human/user = usr)
	if(!user)
		return

	if(user.real_name in GLOB.excommunicated_players)
		to_chat(user, span_warning("十神已背弃我。圣物不会回应我。"))
		return

	if(!weapon_select || !weapon_select.selected_weapon)
		to_chat(user, span_warning("我无法专注于圣物。"))
		return

	var/obj/item/current_relic = SSroguemachine.martyrweapon
	if(current_relic)
		var/datum/component/martyrweapon/old_component = current_relic.GetComponent(/datum/component/martyrweapon)
		if(old_component && old_component.is_active)
			if(old_component.current_holder != user)
				to_chat(user, span_warning("当前圣物仍处于活跃状态，无法召回。"))
			else if(old_component.current_state == 2) //2 = STATE_MARTYRULT
				to_chat(user, span_warningbig("我现在无法再召唤另一件圣物！"))
			return
		if(hascall(current_relic, "anti_stall"))
			call(current_relic, "anti_stall")()

	. = ..()

	user.visible_message(
		span_warning("[user]朝天举起一只手，闪电劈落其身！"),
		span_warning("我朝天举起手，呼唤十神的圣物！")
	)

	lightning_summon_fx(user)

	var/obj/effect/martyr_weapon_manifest/manifest = new
	weapon_select.apply_manifest_sprite(manifest)
	manifest.pixel_x = (user.used_hand == 1) ? -10 : 10
	manifest.pixel_y = 96
	manifest.alpha = 0

	user.vis_contents += manifest

	animate(manifest, alpha = 255, pixel_y = 48, time = 3)
	animate(pixel_y = 6, time = 6)
	animate(alpha = 0, pixel_y = -2, time = 2)

	sleep(1.1 SECONDS)

	if(user && (manifest in user.vis_contents))
		user.vis_contents -= manifest
	qdel(manifest)

	var/obj/item/rogueweapon/spawned_weapon = new weapon_select.selected_weapon(user.loc)

	if(user.put_in_hands(spawned_weapon))
		to_chat(user, span_notice("圣物伴着雷鸣般的轰响落入我手中。"))
	else
		to_chat(user, span_warning("我双手已满！圣物砸落在地。"))

/obj/effect/proc_holder/spell/invoked/martyr_summon_weapon/proc/refresh_one_weapon_button(atom/movable/screen/movable/action_button/B)
	if(!B)
		return

	B.icon = 'icons/mob/actions/roguespells.dmi'
	B.icon_state = "bg_spell"

	B.cut_overlays(TRUE)

	if(overlay_state)
		var/mutable_appearance/weapon_overlay = mutable_appearance(
			'icons/mob/actions/martyr.dmi',
			overlay_state,
			layer = B.layer + 0.2
		)
		weapon_overlay.alpha = overlay_alpha
		B.add_overlay(weapon_overlay)

	B.active_overlay_icon_state = overlay_state
	B.active_underlay_icon_state = null
