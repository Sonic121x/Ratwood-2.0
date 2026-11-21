// 兔子怀表：枪火击溃的专用无限弹匣。
/obj/item/ammo_box/magazine/z121_rabbit_watch
	name = "兔子怀表"
	desc = "一枚黄铜怀表。表盖内侧刻着一只奔跑的兔子，无论取出多少子弹，逆转的时间都会替它补上下一发。"
	icon = 'modular_z121/icon/rabbitwatch.dmi'
	icon_state = "Rabbit Watch"
	item_state = "Rabbit Watch"
	w_class = WEIGHT_CLASS_SMALL
	ammo_type = /obj/item/ammo_casing/caseless/bullet/grapeshot
	caliber = "grapeshot"
	max_ammo = 1
	start_empty = FALSE
	multiload = FALSE

// 每次取弹前先确认机芯里有一枚，保证弹匣永远有下一发。
/obj/item/ammo_box/magazine/z121_rabbit_watch/get_round(keep = FALSE)
	if(!stored_ammo.len)
		stored_ammo += new ammo_type(src)
	return ..(keep)

// 不能把怀表当成弹药盒倒出弹药。
/obj/item/ammo_box/magazine/z121_rabbit_watch/attack_self(mob/user)
	to_chat(user, span_notice("兔子怀表的指针稳定转动，弹药不会耗尽，你的时间也不会。"))
	return

// 机芯自补，不需要手工装填。
/obj/item/ammo_box/magazine/z121_rabbit_watch/can_load(mob/user)
	return FALSE

// 保持说明文字，不让通用弹匣刷新清空它。
/obj/item/ammo_box/magazine/z121_rabbit_watch/update_icon()
	return
