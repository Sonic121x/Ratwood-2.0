// ============================================================================
// 魔法扫帚：雕像领取点（仅限 sonic121x）
// ----------------------------------------------------------------------------
// 账号 ckey = "sonic121x" 的玩家，左键点击【任意】/obj/structure/fluff/statue
// 及其所有子类型，都可以领取一把魔法扫帚；每个 ckey 每回合限领一次。
//
// 不需要专门放一尊特殊雕像：普通的天使/骑士/神像等装饰雕像都能触发。
// 领取记录保存在全局列表里，回合结束/重启后重置。
// ============================================================================

/// 允许领取魔法扫帚的 ckey（ckey 已归一化为小写）。
#define FLYING_BROOM_CLAIM_CKEY "sonic121x"

/// 已经领取过的 ckey；每回合重置。
GLOBAL_LIST_INIT(flying_broom_claimed_ckeys, list())

/obj/structure/fluff/statue/attack_hand(mob/living/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.ckey)
		return
	if(ckey(H.ckey) != FLYING_BROOM_CLAIM_CKEY)
		return
	if(ckey(H.ckey) in GLOB.flying_broom_claimed_ckeys)
		to_chat(H, span_warning("你已经从雕像处领取过魔法扫帚了。"))
		return

	var/obj/item/broom/flying/broom = new /obj/item/broom/flying()
	if(!H.put_in_hands(broom))
		qdel(broom)
		to_chat(H, span_warning("我的双手没有空位，拿不下魔法扫帚。"))
		return

	GLOB.flying_broom_claimed_ckeys += ckey(H.ckey)
	H.visible_message(
		span_notice("[H] 从雕像上取下一把魔法扫帚。"),
		span_notice("我从雕像上取下了魔法扫帚。"),
	)
	playsound(get_turf(src), 'sound/magic/whiteflame.ogg', 50, TRUE)

// ----------------------------------------------------------------------------
// 保留一尊可选的特殊雕像类型，方便地图上做视觉标记；它继承上面的任意雕像领取逻辑。
// ----------------------------------------------------------------------------
/obj/structure/fluff/statue/flying_broom
	name = "魔法扫帚雕像"
	desc = "一尊古老石像，手中紧握着一把缠绕蓝色魔力的扫帚。"
	icon_state = "bstatue"
	anchored = TRUE
	density = FALSE
	max_integrity = 9999
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
