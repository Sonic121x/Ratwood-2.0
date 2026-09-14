// 幻化软膏：复制同装备槽衣物的视觉外观，不改变目标的实际属性。

#define Z121_TRANSMOG_USES 10

/obj/item/z121_transmog_salve
	name = "幻化软膏"
	desc = "将一件衣物的外观映照到另一件同类衣物上。"
	icon = 'modular_z121/icon/item.dmi'
	icon_state = "transmog_salve"
	w_class = WEIGHT_CLASS_SMALL
	var/uses_left = Z121_TRANSMOG_USES
	var/obj/item/clothing/appearance_source
	var/source_icon
	var/source_icon_state
	var/source_item_state
	var/source_mob_overlay_icon
	var/source_alternate_worn_layer
	var/source_worn_x_dimension
	var/source_worn_y_dimension
	var/source_color
	var/source_detail_color
	var/source_altdetail_color
	var/list/source_overlays
	var/list/source_underlays
	var/source_name

/obj/item/z121_transmog_salve/examine(mob/user)
	. = ..()
	. += span_notice("剩余使用次数：[uses_left]/[Z121_TRANSMOG_USES]。手持点击外观来源，再点击同装备槽的目标衣物。")

/obj/item/z121_transmog_salve/attack_self(mob/user)
	if(appearance_source)
		to_chat(user, span_notice("已经选定外观来源：[appearance_source]。请点击同装备槽的目标衣物。"))
	else
		to_chat(user, span_notice("请先手持软膏点击一件衣物作为外观来源。"))

/obj/item/z121_transmog_salve/pre_attack(atom/A, mob/living/user, params)
	if(!A || !user)
		return ..()
	if(!istype(A, /obj/item/clothing))
		return ..()
	var/obj/item/clothing/target = A
	if(!appearance_source)
		appearance_source = target
		source_icon = target.icon
		source_icon_state = target.icon_state
		source_item_state = target.item_state
		source_mob_overlay_icon = target.mob_overlay_icon
		source_alternate_worn_layer = target.alternate_worn_layer
		source_worn_x_dimension = target.worn_x_dimension
		source_worn_y_dimension = target.worn_y_dimension
		source_color = target.color
		source_detail_color = target.detail_color
		source_altdetail_color = target.altdetail_color
		source_overlays = target.overlays.Copy()
		source_underlays = target.underlays.Copy()
		source_name = target.name
		to_chat(user, span_notice("已记录 [target] 的外观。请再点击同装备槽的目标衣物。"))
		return TRUE

	if(target == appearance_source)
		to_chat(user, span_warning("目标不能是外观来源本身。"))
		return TRUE
	if(!(target.slot_flags & appearance_source.slot_flags))
		to_chat(user, span_warning("幻化软膏只能作用于同一装备槽的衣物。"))
		return TRUE
	if(uses_left <= 0)
		to_chat(user, span_warning("这瓶幻化软膏已经用完了。"))
		return TRUE

	// 只写入视觉字段；目标的 armor、完整度、槽位及功能字段均保持不变。
	target.icon = source_icon
	target.icon_state = source_icon_state
	target.item_state = source_item_state
	target.mob_overlay_icon = source_mob_overlay_icon
	target.alternate_worn_layer = source_alternate_worn_layer
	target.worn_x_dimension = source_worn_x_dimension
	target.worn_y_dimension = source_worn_y_dimension
	target.color = source_color
	target.detail_color = source_detail_color
	target.altdetail_color = source_altdetail_color
	target.overlays = source_overlays.Copy()
	target.underlays = source_underlays.Copy()
	target.name = source_name
	target.update_icon()

	if(ismob(target.loc))
		var/mob/M = target.loc
		M.update_inv_wear_mask()
		M.update_inv_neck()
		M.update_inv_wear_suit()
		M.update_inv_w_uniform()
		M.update_inv_wrists()
		M.update_inv_head()
		M.update_inv_gloves()
		M.update_inv_shoes()
		M.update_inv_glasses()
		M.update_inv_pants()
		M.update_inv_shirt()
		M.update_inv_armor()
		M.update_inv_cloak()

	uses_left--
	user.visible_message(span_notice("[user]将 [target] 幻化成了 [source_name] 的外观。"), span_green("我将 [target] 幻化成了 [source_name] 的外观。软膏剩余 [uses_left] 次。"))
	appearance_source = null
	if(uses_left <= 0)
		qdel(src)
	return TRUE

#undef Z121_TRANSMOG_USES
