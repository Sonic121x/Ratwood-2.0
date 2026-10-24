/obj/effect/proc_holder/spell/self/light
	name = "照明术"
	desc = "召唤一颗凝聚的光球。"
	overlay_state = "light"
	releasedrain = 50
	chargetime = 1
	recharge_time = 30 SECONDS
	warnie = "spellwarning"
	movement_interrupt = FALSE
	no_early_release = FALSE
	chargedloop = null
	sound = 'sound/magic/whiteflame.ogg'
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane //can be arcane, druidic, blood, holy
	cost = 1
	miracle = FALSE

	invocations = list("光辉，凝现。") // Summon Light
	invocation_type = "whisper" //can be none, whisper, emote and shout

	var/obj/item/item
	var/item_type = /obj/item/flashlight/flare/light
	var/delete_old = TRUE //TRUE to delete the last summoned object if it's still there, FALSE for infinite item stream weeeee

/obj/effect/proc_holder/spell/self/light/cast(list/targets, mob/user = usr)
	if (delete_old && item && !QDELETED(item))
		QDEL_NULL(item)
	if(user.dropItemToGround(user.get_active_held_item()))
		user.put_in_hands(make_item(), TRUE)
		user.visible_message(span_info("一颗光球在[user]手中凝聚！"), span_info("你凝聚出一颗纯粹的光球！"))
	return TRUE

/obj/effect/proc_holder/spell/self/light/Destroy()
	if(item)
		qdel(item)
	return ..()

/obj/effect/proc_holder/spell/self/light/proc/make_item()
	item = new item_type
	var/mutable_appearance/magic_overlay = mutable_appearance('icons/obj/projectiles.dmi', "gumball")
	item.add_overlay(magic_overlay)
	return item
