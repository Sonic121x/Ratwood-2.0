// Zadpack supply packs + restock/cage purchase items - ported from Azure-Peak PR #7000
// (code/modules/cargo/packsrogue/merchant/zadpack.dm).
/datum/supply_pack/rogue/zadpack
	group = "扎德鸟包" // English: Zadpacks
	crate_name = "受训扎德鸟货箱"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/zadpack/merchant
	name = "受训扎德鸟包"
	cost = ZADPACK_PRICE_MERCHANT
	contains = list(/obj/item/zadpack)
	not_in_public = TRUE

/datum/supply_pack/rogue/zadpack/bathhouse
	name = "隐秘扎德鸟包"
	group = "隐秘扎德鸟" // English: Discreet Zads
	cost = ZADPACK_PRICE_BATHHOUSE
	contains = list(/obj/item/zadpack)
	contraband = TRUE

/datum/supply_pack/rogue/zadpack/cheap_bombs
	name = "瓶装炸弹（批量）"
	cost = 35
	contains = list(
		/obj/item/bomb,
		/obj/item/bomb,
		/obj/item/bomb,
		/obj/item/bomb,
		/obj/item/bomb,
	)
	not_in_public = TRUE

/datum/supply_pack/rogue/zadpack/new_cage
	name = "备用扎德鸟笼"
	cost = ZADCOTE_NEW_CAGE_COST_MAMMON
	contains = list(/obj/item/zadcage)
	not_in_public = TRUE

/datum/supply_pack/rogue/zadpack/new_cage_bathhouse
	name = "隐秘扎德鸟笼"
	group = "隐秘扎德鸟" // English: Discreet Zads
	cost = ZADCOTE_NEW_CAGE_COST_MAMMON
	contains = list(/obj/item/zadcage)
	contraband = TRUE

/datum/crown_import/zad_pack
	name = "宫廷扎德鸟包"
	desc = "一群由王室出资饲养、训练有素的传信扎德鸟。对扎德鸟舍使用，即可补充其中的储备鸟群。"
	item_type = /obj/item/zadpack
	base_cost = ZADPACK_PRICE_STEWARD

/datum/crown_import/zad_cage
	name = "备用扎德鸟笼"
	desc = "一个尚未绑定任何扎德鸟舍的备用柳条笼。对你的势力经营的任意扎德鸟舍使用，即可占用一个栏位。"
	item_type = /obj/item/zadcage
	base_cost = ZADCOTE_NEW_CAGE_COST_MAMMON

/obj/item/zadpack
	name = "受训扎德鸟包"
	desc = "一小箱训练有素、喂养充足的扎德鸟，随时可以入舍。对扎德鸟舍使用，即可补充储备鸟群。"
	icon = 'icons/roguetown/clothing/storage.dmi'
	icon_state = "deliverypackage3"
	item_state = "deliverypackage"
	w_class = WEIGHT_CLASS_NORMAL
	var/bundle_size = ZADPACK_BUNDLE_SIZE

/obj/item/zadpack/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return ..()
	if(!istype(target, /obj/item/roguemachine/zadcote))
		return ..()
	var/obj/item/roguemachine/zadcote/cote = target
	if(!cote.can_restock(user))
		to_chat(user, span_warning("只有扎德鸟舍的所有者可以为其补充鸟群。"))
		return
	cote.restock(bundle_size)
	to_chat(user, span_notice("[bundle_size]只新扎德鸟加入储备，鸟舍里响起了啁啾声。"))
	playsound(cote.loc, 'sound/misc/hiss.ogg', 50, FALSE, -1)
	qdel(src)
