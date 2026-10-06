// A bathhouse cousin of the HEADEATER: swallows treasures instead of skulls and
// spirits them away to the Nightmistress's vault. Every consignment is entered
// into the BRASSFACE's Hoard ledger, and the hoard pays interest on the vault's
// contents via the BMtreasury subsystem.
/obj/structure/roguemachine/headeater/treasureseeker
	name = "寻宝机"
	desc = "食首机的同类，黄铜喉管经浴场改装后，口味也温和了些。喂它一件饰物，宝贝就会被送往夜主的宝库，宝藏会记下它的价值。它只为浴场的人张嘴。"

/obj/structure/roguemachine/headeater/treasureseeker/examine_extra(mob/user)
	. = list()
	. += span_info("手持物品左键点击，将其送往夜主的宝库。右键点击则送走它嘴下那一格中的所有物品。")
	. += span_smallnotice("它只为浴场张嘴——夜主、她的员工和宣誓效忠的代理人。")
	. += span_smallnotice("每次寄存都会记入黄铜面的宝藏账册，宝库中的财宝会产生利息。")
	. += span_smallnotice("它拒绝废物——只吞下能为宝藏带来收益的物品，将无价值的饰物、散钱和容器留在原处。")

/// Only the Bathhouse's own may consign to the hoard: the Nightmistress and her
/// bathworkers by employment, and sworn agents by their patronage writ.
/obj/structure/roguemachine/headeater/treasureseeker/proc/is_bathhouse_consignor(mob/user)
	if(!user)
		return FALSE
	if(user.job in GLOB.bathhouse_positions) // Bathmaster/Nightmistress and Bathhouse Attendants.
		return TRUE
	return HAS_TRAIT(user, TRAIT_AGENT_BATHHOUSE)

/// Collects the open floor turfs of the Nightmistress's vault area.
/obj/structure/roguemachine/headeater/treasureseeker/proc/get_vault_turfs()
	var/area/vault_area = GLOB.areas_by_type[/area/rogue/outdoors/exposed/bath/vault]
	if(!vault_area)
		return list()
	var/list/turfs = list()
	for(var/turf/open/floor/vault_floor in vault_area)
		turfs += vault_floor
	return turfs

/// Records one consigned item in the hoard ledger. Returns the item's appraised value.
/obj/structure/roguemachine/headeater/treasureseeker/proc/log_consignment(obj/item/I, mob/user)
	var/value = I.get_real_price() || 0
	SSBMtreasury.add_hoard_log("deposit", I.name, value, user.real_name)
	return value

/// Records a bulk consignment of same-type items as a single ledger line - count and
/// combined value, so a pile doesn't spam the ledger with one row per item.
/obj/structure/roguemachine/headeater/treasureseeker/proc/log_bulk_consignment(item_name, count, total_value, mob/user)
	if(count <= 0)
		return
	SSBMtreasury.add_hoard_log("deposit", "[item_name] x[count]", total_value, user.real_name)

/// Message for stuff appearing in the room so that it is not just out of nowhere
/obj/structure/roguemachine/headeater/treasureseeker/proc/announce_arrival(obj/item/I, turf/destination)
	if(!destination)
		return
	for(var/mob/M in hearers(7, destination))
		to_chat(M, span_notice("一道金光闪过，[I]突然出现在宝库的地面上。"))

/// Same as above but for multiple items at once to stop message spam
/obj/structure/roguemachine/headeater/treasureseeker/proc/announce_bulk_arrival(turf/destination, count)
	if(!destination || count <= 0)
		return
	for(var/mob/M in hearers(7, destination))
		to_chat(M, span_notice("一道金光闪过，[count]件财宝突然出现在宝库的地面上。"))

/obj/structure/roguemachine/headeater/treasureseeker/attackby(obj/item/I, mob/user, params)
	var/mob/living/L = user
	if(istype(L) && L.used_intent && L.used_intent.type == INTENT_HARM)
		return // Harm intent bashes the machine; heads and dross alike are refused.
	if(!is_bathhouse_consignor(user))
		to_chat(user, span_warning("[src]紧闭着黄铜大嘴——宝藏只听命于浴场。"))
		return TRUE
	if(!SSBMtreasury.generates_profit(I))
		to_chat(user, span_warning("[src]嗅了嗅[I]，不屑地抬起黄铜鼻子——宝藏对这种废物毫无兴趣。"))
		return TRUE
	var/list/turfs = get_vault_turfs()
	if(!length(turfs))
		to_chat(user, span_warning("[src]发出空洞的咔嗒声——无法通往夜主的宝库。"))
		return TRUE
	var/turf/destination = pick(turfs)
	if(!user.transferItemToLoc(I, destination))
		to_chat(user, span_warning("[I]粘在你的手上了！"))
		return TRUE
	log_consignment(I, user)
	announce_arrival(I, destination)
	playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
	to_chat(user, span_danger("[src]一口吞下[I]，将它送往夜主的宝库。"))
	return TRUE

/obj/structure/roguemachine/headeater/treasureseeker/attack_right(mob/user)
	// The sprite is pixel-shifted over its base turf (as the headeater's is), so the
	// parent sweeps get_turf(src) - do the same rather than stepping off by dir.
	if(!is_bathhouse_consignor(user))
		to_chat(user, span_warning("[src]紧闭着黄铜大嘴——宝藏只听命于浴场。"))
		return
	var/turf/front = get_turf(src)
	if(!front)
		return
	var/list/to_ship = list()
	var/rejected = 0
	for(var/obj/item/I in front.contents)
		if(I.anchored)
			continue
		if(!SSBMtreasury.generates_profit(I)) // Dross is left behind.
			rejected++
			continue
		to_ship += I
	if(!length(to_ship))
		if(rejected)
			to_chat(user, span_warning("[src]对面前的废物抬起黄铜鼻子——这里没有能增加宝藏收益的东西。"))
		else
			to_chat(user, span_info("[src]面前的地上没有任何闪亮的财宝。"))
		return
	var/list/turfs = get_vault_turfs()
	if(!length(turfs))
		to_chat(user, span_warning("[src]发出空洞的咔嗒声——无法通往夜主的宝库。"))
		return
	var/shipped = 0
	var/turf/last_destination
	var/obj/item/last_item
	var/list/bulk_counts = list() // item name -> count
	var/list/bulk_values = list() // item name -> combined value
	for(var/obj/item/I in to_ship)
		if(I.loc != front) // Something else grabbed it mid-gulp.
			continue
		last_destination = pick(turfs)
		I.forceMove(last_destination)
		var/value = I.get_real_price() || 0
		bulk_counts[I.name] = (bulk_counts[I.name] || 0) + 1
		bulk_values[I.name] = (bulk_values[I.name] || 0) + value
		last_item = I
		shipped++	// Itemise one treasure; group a haul into one ledger line per type.
	if(shipped == 1)
		log_consignment(last_item, user)
	else
		for(var/item_name in bulk_counts)
			log_bulk_consignment(item_name, bulk_counts[item_name], bulk_values[item_name], user)
	// A single treasure is named; a haul is summarised - the itemised record
	// lives in the BRASSFACE Hoard ledger.
	if(shipped == 1)
		announce_arrival(last_item, last_destination)
	else if(shipped > 1)
		announce_bulk_arrival(last_destination, shipped)
	if(shipped)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		to_chat(user, span_danger("[src]一口吞下[shipped]件财宝，将它们送往夜主的宝库。"))
		if(rejected)
			to_chat(user, span_warning("[src]将[rejected]件杂物留在原处——宝藏对这种废物毫无兴趣。"))
