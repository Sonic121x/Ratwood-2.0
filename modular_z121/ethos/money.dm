// 钱币、钱袋及背包的真实归属由容器链决定；银行与地面物品不计入。
/proc/z121_ethos_money_owner(atom/location)
	while(location && !isturf(location) && !isarea(location))
		if(ishuman(location))
			return QDELETED(location) ? null : location
		location = location.loc
	return null

/proc/z121_ethos_sync_money(atom/location)
	var/mob/living/carbon/human/H = z121_ethos_money_owner(location)
	var/datum/z121_ethos/R = H?.z121_get_ethos()
	if(R?.sins["greed"])
		R.sync_greed()

/datum/z121_ethos/proc/sync_greed()
	if(!body || QDELETED(body))
		return
	var/poor = sins["greed"] && world.time >= born_at + 10 MINUTES && z121_ethos_money(body) < 50
	toggle_effect(/datum/status_effect/z121_ethos/greed, poor)
	toggle_mood(/datum/stressevent/z121_ethos/greed, poor)

// 数量变化以及任意层级钱币容器的移动都在本次操作内同步。
/obj/item/roguecoin/Initialize(mapload, coin_amount)
	. = ..()
	z121_ethos_sync_money(loc)

/obj/item/roguecoin/set_quantity(new_quantity)
	. = ..()
	z121_ethos_sync_money(loc)

/atom/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(!isturf(src) && !isarea(src) && (istype(AM, /obj/item/roguecoin) || length(AM?.contents)))
		z121_ethos_sync_money(src)

/atom/Exited(atom/movable/AM, atom/newLoc)
	. = ..()
	if(!isturf(src) && !isarea(src) && (istype(AM, /obj/item/roguecoin) || length(AM?.contents)))
		z121_ethos_sync_money(src)

// 移入空空间时核心先发出退出通知、后清空位置，须在最终移出后再次同步。
/atom/movable/doMove(atom/destination)
	var/atom/old_location = loc
	. = ..()
	if(. && !destination && (istype(src, /obj/item/roguecoin) || length(contents)))
		z121_ethos_sync_money(old_location)
