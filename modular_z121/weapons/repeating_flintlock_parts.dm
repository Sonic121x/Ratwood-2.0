// 连发燧枪零件只借用现有外观，材质与组装状态由零件自身保存。
/obj/item/z121_flintlock_part
	name = "连发燧枪零件"
	desc = "用于组装连发燧枪的零件。"
	w_class = WEIGHT_CLASS_NORMAL
	var/material_name = "铁"
	var/range_bonus = 0
	var/penetration_bonus = 0
	var/accuracy_bonus = 0
	var/jam_modifier = 0

/obj/item/z121_flintlock_part/examine(mob/user)
	. = ..()
	. += span_notice("材质：[material_name]；射程修正：[range_bonus * 100]%；穿透修正：[penetration_bonus * 100]%；精确度修正：[accuracy_bonus * 100]%；故障率修正：[jam_modifier] 个百分点。")

/obj/item/z121_flintlock_part/proc/can_assemble(mob/user, obj/item/part)
	if(QDELETED(src) || QDELETED(part) || !user || !user.is_holding(part) || !user.canUseTopic(src, BE_CLOSE))
		return FALSE
	// 必须直接放在有桌面的地面格，背包内或手持零件不算桌面组装。
	if(!isturf(loc) || (!(locate(/obj/structure/table) in loc) && !(locate(/obj/machinery/artificer_table) in loc)))
		to_chat(user, span_warning("我得先把[src]放到桌面上。"))
		return FALSE
	return TRUE

/obj/item/z121_flintlock_part/receiver
	name = "铁机匣"
	icon = 'icons/roguetown/items/ore.dmi'
	icon_state = "ingotiron"
	jam_modifier = 3
	var/gear_material
	var/gears_installed = 0

/obj/item/z121_flintlock_part/receiver/examine(mob/user)
	. = ..()
	. += span_notice("已安装齿轮：[gears_installed]/3；齿轮材质：[gear_material ? gear_material : "尚未选择"]。需装入三枚同材质齿轮。")

/obj/item/z121_flintlock_part/receiver/attackby(obj/item/I, mob/user, params)
	var/new_material
	if(istype(I, /obj/item/roguegear/bronze))
		new_material = "青铜"
	else if(istype(I, /obj/item/roguegear/wood))
		new_material = "木制"
	else
		return ..()
	if(!can_assemble(user, I) || gears_installed >= 3)
		return
	if(gear_material && gear_material != new_material)
		to_chat(user, span_warning("这个机匣只能继续装入[gear_material]齿轮。"))
		return
	if(!user.transferItemToLoc(I, src))
		return
	gear_material = new_material
	gears_installed++
	qdel(I)
	to_chat(user, span_notice("我装入了一枚[gear_material]齿轮（[gears_installed]/3）。"))
	if(gears_installed == 3)
		var/obj/item/z121_flintlock_part/unfinished/frame = new(loc)
		frame.material_name = material_name
		frame.range_bonus = range_bonus
		frame.penetration_bonus = penetration_bonus
		frame.jam_modifier = jam_modifier
		frame.gear_material = gear_material
		to_chat(user, span_notice("机匣已组装完毕，现在可以安装长枪管。"))
		qdel(src)

/obj/item/z121_flintlock_part/receiver/steel
	name = "钢机匣"
	material_name = "钢"
	icon_state = "ingotsteel"
	range_bonus = 0.19
	penetration_bonus = 0.23
	jam_modifier = 0

/obj/item/z121_flintlock_part/receiver/blacksteel
	name = "黑钢机匣"
	material_name = "黑钢"
	icon_state = "ingotblacksteel"
	range_bonus = 0.30
	penetration_bonus = 0.25
	jam_modifier = -5

/obj/item/z121_flintlock_part/barrel
	name = "铁长枪管"
	icon = 'modular_helmsguard/icons/obj/items/arquebus_items.dmi'
	icon_state = "ramrod"
	item_state = "ramrod"
	range_bonus = 0.10
	accuracy_bonus = 0.07

/obj/item/z121_flintlock_part/barrel/steel
	name = "钢长枪管"
	material_name = "钢"
	accuracy_bonus = 0.15

/obj/item/z121_flintlock_part/barrel/blacksteel
	name = "黑钢长枪管"
	material_name = "黑钢"
	range_bonus = 0.15
	accuracy_bonus = 0.50

/obj/item/z121_flintlock_part/unfinished
	name = "未完成的连发燧枪"
	desc = "已安装三枚齿轮的机匣，还需要在桌面上安装一根长枪管。"
	icon = 'modular_helmsguard/icons/weapons/fusil.dmi'
	icon_state = "fusil"
	item_state = "fusil"
	pixel_x = -16
	pixel_y = -16
	w_class = WEIGHT_CLASS_BULKY
	var/gear_material = "青铜"

/obj/item/z121_flintlock_part/unfinished/examine(mob/user)
	. = ..()
	. += span_notice("齿轮：[gear_material]×3；整组故障率修正：[gear_material == "木制" ? 3 : 0] 个百分点。尚未安装长枪管。")

/obj/item/z121_flintlock_part/unfinished/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/z121_flintlock_part/barrel))
		return ..()
	if(!can_assemble(user, I))
		return
	var/obj/item/z121_flintlock_part/barrel/barrel = I
	if(!user.transferItemToLoc(barrel, src))
		return
	var/obj/item/gun/ballistic/z121_repeating_flintlock/gun = new(loc)
	gun.receiver_material = material_name
	gun.barrel_material = barrel.material_name
	gun.gear_material = gear_material
	gun.range_bonus = range_bonus + barrel.range_bonus
	gun.penetration_bonus = penetration_bonus
	gun.accuracy_bonus = barrel.accuracy_bonus
	gun.jam_chance = clamp(gun.base_failure_chance + jam_modifier + (gear_material == "木制" ? 3 : 0), 1, 100)
	user.visible_message(span_notice("[user]完成了连发燧枪的组装。"))
	qdel(barrel)
	qdel(src)
