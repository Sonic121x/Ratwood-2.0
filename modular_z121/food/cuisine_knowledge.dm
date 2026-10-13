#define TRAIT_Z121_CUISINE "美食知识"

/proc/register_z121_cuisine_trait()
	GLOB.roguetraits[TRAIT_Z121_CUISINE] = span_info("我熟悉《风味美食录》中的备料与火候，能够制作春卷、狼肉火锅、东坡肉、刀削面和包子。")

/obj/item/book/rogue/z121_cuisine
	name = "风味美食录"
	desc = "一本记载异域面点与炖煮技艺的线装食谱。手持研读十秒即可掌握美食知识，传授成功后书页便会散尽。"
	icon = 'modular_z121/icon/food.dmi'
	icon_state = "cookbook_0"
	base_icon_state = "cookbook"
	var/studying = FALSE

/obj/item/book/rogue/z121_cuisine/attack_self(mob/living/user)
	if(studying || !user.mind || user.stat || user.get_active_held_item() != src)
		return
	if(HAS_TRAIT(user, TRAIT_Z121_CUISINE))
		to_chat(user, span_notice("你已经掌握了书中的美食知识，无需再次研读。"))
		return
	studying = TRUE
	open = TRUE
	update_icon()
	user.update_inv_hands()
	to_chat(user, span_notice("你翻开《风味美食录》，细细揣摩其中的备料与火候。"))
	var/success = do_after(user, 10 SECONDS, target = src)
	if(QDELETED(src))
		return
	studying = FALSE
	open = FALSE
	update_icon()
	if(!success || QDELETED(user) || !user.mind || user.get_active_held_item() != src || HAS_TRAIT(user, TRAIT_Z121_CUISINE))
		return
	ADD_TRAIT(user, TRAIT_Z121_CUISINE, "z121_cuisine_book")
	to_chat(user, span_nicegreen("你掌握了美食知识！书中的技艺已铭记于心，泛黄的书页随之散尽。"))
	qdel(src)

// 检视中的阅读链接也进入同一学习流程，不调用普通书籍的识字门槛或随机正文。
/obj/item/book/rogue/z121_cuisine/Topic(href, href_list)
	if(href_list["read"] && isliving(usr) && usr.canUseTopic(src, BE_CLOSE))
		attack_self(usr)

/obj/item/book/rogue/z121_cuisine/read(mob/user)
	if(isliving(user))
		attack_self(user)

/datum/loadout_item/z121_cuisine_book
	name = "《风味美食录》"
	desc = "研读十秒后获得美食知识，解锁六种中式料理；成功学习后消耗书籍。"
	path = /obj/item/book/rogue/z121_cuisine
	triumph_cost = 3
