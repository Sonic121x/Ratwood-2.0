// 扩展现有检查链，同时覆盖正反两个选择顺序与旧版恶习。
/datum/preferences/check_vice_pick_conflict(vice_type, show_message = FALSE, mob/user = null)
	var/reason
	if(vice_type == /datum/charflaw/z121_sin/lust && !sexable)
		reason = "难餍之心需要开启成人功能。"
	if(vice_type == /datum/charflaw/z121_sin/lust && !(age in list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)))
		reason = "只有成年角色可以选择难餍之心。"
	if(vice_type == /datum/charflaw/z121_sin/gluttony && (TRAIT_NOHUNGER in pref_species.inherent_traits))
		reason = "无需进食的种族不能选择腹中空洞。"
	if(reason)
		if(show_message && user)
			to_chat(user, span_warning(reason))
		return TRUE
	return ..()

/datum/preferences/check_vice_vice_conflict(vice_type, list/selected_vices, show_message = FALSE, mob/user = null)
	var/list/pairs = list(
		list(/datum/charflaw/z121_sin/greed, /datum/charflaw/greedy),
		list(/datum/charflaw/z121_sin/lust, /datum/charflaw/addiction/lovefiend))
	for(var/list/pair in pairs)
		if((vice_type == pair[1] && (pair[2] in selected_vices)) || (vice_type == pair[2] && (pair[1] in selected_vices)))
			if(show_message && user)
				to_chat(user, span_warning("这两个恶习的需求重复，不能同时选择。"))
			return TRUE
	return ..()

// 核心钱币文件的局部宏已解除；同步检查同时校验这个容量。
#define Z121_ETHOS_MAX_COIN_STACK 20
// 货币拆分和合并不能抹去“已用于慷慨奖励”的来源标记。
/obj/item/roguecoin
	var/z121_ethos_rewarded_quantity

/obj/item/roguecoin/proc/z121_ethos_rewarded_coins()
	// 兼容改动前的整堆标记；新记录按枚数保存。
	if(isnull(z121_ethos_rewarded_quantity))
		z121_ethos_rewarded_quantity = z121_ethos_gift_rewarded ? quantity : 0
	return clamp(z121_ethos_rewarded_quantity, 0, quantity)

/obj/item/roguecoin/proc/z121_ethos_set_coin_rewards(amount)
	z121_ethos_rewarded_quantity = clamp(amount, 0, quantity)
	z121_ethos_gift_rewarded = z121_ethos_rewarded_quantity > 0

/obj/item/roguecoin/merge(obj/item/roguecoin/G, mob/user)
	if(G == src)
		return
	if(!G || G.base_type != base_type)
		return ..()
	var/amount = min(G.quantity, Z121_ETHOS_MAX_COIN_STACK - quantity)
	if(amount <= 0)
		return ..()
	var/own_rewarded = z121_ethos_rewarded_coins()
	var/given_rewarded = G.z121_ethos_rewarded_coins()
	var/moved_rewarded = min(amount, given_rewarded)
	. = ..()
	z121_ethos_set_coin_rewards(own_rewarded + moved_rewarded)
	if(!QDELETED(G))
		G.z121_ethos_set_coin_rewards(given_rewarded - moved_rewarded)

/obj/item/roguecoin/attack_right(mob/user)
	if(user.get_active_held_item())
		return call(src, /atom/proc/attack_right)(user)
	if(quantity == 1)
		if(HAS_TRAIT(user, TRAIT_BLACKLEG))
			switch(alert(user, "你想把下一次掷硬币操纵成什么结果？", "赛利克斯", "正面", "反面", "公平游戏"))
				if("正面")
					rigged_outcome = 1
				if("反面")
					rigged_outcome = 2
				if("公平游戏")
					rigged_outcome = 0
		return
	var/obj/item/roguecoin/new_coin = new type()
	var/rewarded = z121_ethos_rewarded_coins()
	var/moved_rewarded = min(1, rewarded)
	new_coin.set_quantity(1)
	new_coin.z121_ethos_set_coin_rewards(moved_rewarded)
	set_quantity(quantity - 1)
	z121_ethos_set_coin_rewards(rewarded - moved_rewarded)
	new_coin.heads_tails = last_merged_heads_tails
	user.put_in_hands(new_coin)
	playsound(loc, 'sound/foley/coinphy (2).ogg', 100, TRUE, -2)

/obj/item/roguecoin/attack_hand(mob/user)
	if(user.get_inactive_held_item() == src && quantity > 1)
		var/amt_text = "（1 到 [quantity]）"
		var/amount = input(user, "要分出多少[plural_name]？[amt_text]", null, round(quantity / 2, 1)) as null|num
		if(QDELETED(user) || QDELETED(src) || !user.Adjacent(src))
			return
		amount = round(clamp(amount, 0, quantity), 1)
		if(!amount)
			return
		if(amount >= quantity)
			return z121_ethos_pickup(user)
		var/obj/item/roguecoin/new_coins = new type()
		var/rewarded = z121_ethos_rewarded_coins()
		var/moved_rewarded = min(amount, rewarded)
		new_coins.set_quantity(amount)
		new_coins.z121_ethos_set_coin_rewards(moved_rewarded)
		new_coins.heads_tails = last_merged_heads_tails
		set_quantity(quantity - amount)
		z121_ethos_set_coin_rewards(rewarded - moved_rewarded)
		user.put_in_hands(new_coins)
		playsound(loc, 'sound/foley/coins1.ogg', 100, TRUE, -2)
		return
	return z121_ethos_pickup(user)

#undef Z121_ETHOS_MAX_COIN_STACK

