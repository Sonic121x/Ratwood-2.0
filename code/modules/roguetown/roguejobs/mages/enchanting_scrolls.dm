

/*Enchantment scrolls here. Here enchantment scroll has a component. Refer to magic_items.dm, and it's various subfolders for differant enchantment datums.
T1 Enchantments below here*/

/obj/item/enchantmentscroll
	name = "附魔卷轴"
	desc = "一张灌注了奥术附魔的卷轴。可用于某些物品，为其赋予魔力。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "enchantment"
	var/component
	possible_item_intents = list(/datum/intent/use)
	grid_width = 64
	grid_height = 32
	dropshrink = 0.8
	obj_flags_ignore = TRUE

/obj/item/enchantmentscroll/attack_obj(obj/item/O, mob/living/user)
	if(O.unenchantable)
		to_chat(user, span_warning("You cannot enchant this item."))
		return FALSE
	var/datum/component/magic_item/M = O.GetComponent(/datum/component/magic_item, component)
	if(M)
		if(length(M.magical_effects) >= M.enchanting_capacity)
			to_chat(user, span_warning("这件物品已经附魔到了极限。"))
			return FALSE
	return TRUE

/obj/item/enchantmentscroll/basic/woodcut
	name = "伐木附魔卷轴"
	desc = "一张灌注了伐木附魔的卷轴。很适合拿来砍木头。"
	component = /datum/magic_item/mundane/woodcut

/obj/item/enchantmentscroll/basic/woodcut/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon/stoneaxe))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（伐木）"
		qdel(src)
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/basic/mining
	name = "采矿附魔卷轴"
	desc = "一张灌注了采矿附魔的卷轴。很适合用来开采岩石。"
	component = /datum/magic_item/mundane/mining

/obj/item/enchantmentscroll/basic/mining/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon/pick))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（采矿）"
		qdel(src)
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/basic/xylix
	name = "赛利克斯恩典附魔卷轴"
	desc = "一张灌注了幸运附魔的卷轴。会为佩戴者带来好运。"
	component = /datum/magic_item/mundane/xylix

/obj/item/enchantmentscroll/basic/xylix/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（赛利克斯恩典）"
		qdel(src)
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/basic/light
	name = "不屈之光附魔卷轴"
	desc = "一张灌注了不屈之光附魔的卷轴。会让附魔物品散发光芒。"
	component = /datum/magic_item/mundane/unyieldinglight

/obj/item/enchantmentscroll/basic/light/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing)|| istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（不屈之光）"
		qdel(src)
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/basic/holding
	name = "储存附魔卷轴"
	desc = "一张灌注了储存附魔的卷轴。会将容器的储物空间翻倍。"
	component = /datum/magic_item/mundane/holding
	w_class = WEIGHT_CLASS_HUGE

/obj/item/enchantmentscroll/basic/holding/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/storage))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（储存）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/basic/revealing
	name = "揭示附魔卷轴"
	desc = "一张灌注了揭示附魔的卷轴。会让光源的照明范围翻倍。"
	component = /datum/magic_item/mundane/revealing

/obj/item/enchantmentscroll/basic/revealing/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/flashlight/flare/torch))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（揭示）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

//T2 Enchantments below

/obj/item/enchantmentscroll/superior/nightvision
	name = "暗视附魔卷轴"
	desc = "一张灌注了暗视附魔的卷轴。适合在黑暗中视物。"
	component = /datum/magic_item/superior/nightvision

/obj/item/enchantmentscroll/superior/nightvision/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（暗视）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/superior/unbreaking
	name = "坚固附魔卷轴"
	desc = "一张灌注了坚固附魔的卷轴。会让附魔物品更耐用，承受更多损伤。"
	component = /datum/magic_item/superior/unbreaking

/obj/item/enchantmentscroll/superior/unbreaking/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing)|| istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（坚固）"
		qdel(src)
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/superior/featherstep
	name = "羽步附魔卷轴"
	desc = "一张灌注了羽步附魔的卷轴。会让你更迅捷，脚步也更安静。"
	component = /datum/magic_item/superior/featherstep

/obj/item/enchantmentscroll/superior/featherstep/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/shoes)||istype(O,/obj/item/clothing/ring|| istype(O,/obj/item/clothing/neck/roguetown/psicross)))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（羽步）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/superior/fireresist
	name = "抗火附魔卷轴"
	desc = "一张灌注了抗火附魔的卷轴。会让你免于着火。"
	component = /datum/magic_item/superior/fireresist

/obj/item/enchantmentscroll/superior/fireresist/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（抗火）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/superior/climbing
	name = "攀蛛附魔卷轴"
	desc = "一张灌注了攀蛛附魔的卷轴。能帮助你攀上难以逾越的表面。"
	component = /datum/magic_item/superior/climbing

/obj/item/enchantmentscroll/superior/climbing/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（攀蛛）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/superior/thievery
	name = "巧手附魔卷轴"
	desc = "一张灌注了巧手附魔的卷轴。能帮助你行窃与撬锁。"
	component = /datum/magic_item/superior/thievery

/obj/item/enchantmentscroll/superior/thievery/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/gloves)||istype(O,/obj/item/clothing/ring|| istype(O,/obj/item/clothing/neck/roguetown/psicross)))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（巧手）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/superior/trekk
	name = "长步附魔卷轴"
	desc = "一张灌注了长步附魔的卷轴。能让你更轻松地穿过沼泽。"
	component = /datum/magic_item/superior/trekk

/obj/item/enchantmentscroll/superior/trekk/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/shoes)||istype(O,/obj/item/clothing/ring|| istype(O,/obj/item/clothing/neck/roguetown/psicross)))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（长步）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/superior/smithing
	name = "锻造附魔卷轴"
	desc = "一张灌注了锻造附魔的卷轴。会让你在铁砧上的锤击更加有效。"
	component = /datum/magic_item/superior/smithing

/obj/item/enchantmentscroll/superior/smithing/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon/hammer))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（锻造）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

//T3 Enchantments below

/obj/item/enchantmentscroll/greater/lifesteal
	name = "生命窃取附魔卷轴"
	desc = "一张灌注了生命窃取附魔的卷轴。击中活物时，会偶尔为你恢复伤势。"
	component = /datum/magic_item/greater/lifesteal

/obj/item/enchantmentscroll/greater/lifesteal/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（生命窃取）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/greater/lightning
	name = "雷击附魔卷轴"
	desc = "一张灌注了雷击附魔的卷轴。该附魔会电击敌人，并有几率扩散到附近的敌我双方。"
	component = /datum/magic_item/greater/lightning

/obj/item/enchantmentscroll/greater/lightning/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（雷击）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/greater/voidtouched
	name = "虚空之触附魔卷轴"
	desc = "一张灌注了虚空之触附魔的卷轴。该附魔会将敌人短暂拖入虚空，再把他们吐到附近。"
	component = /datum/magic_item/greater/void

/obj/item/enchantmentscroll/greater/voidtouched/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（虚空之触）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/greater/frostveil
	name = "霜幕附魔卷轴"
	desc = "一张灌注了霜幕附魔的卷轴。用于护甲时，会减缓击中你的敌人；用于武器时，会减缓被你击中的敌人。"
	component = /datum/magic_item/greater/frostveil

/obj/item/enchantmentscroll/greater/frostveil/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing)|| istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（霜幕）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))
/obj/item/enchantmentscroll/greater/phoenixguard
	name = "凤凰守护附魔卷轴"
	desc = "一张灌注了凤凰守护附魔的卷轴。会点燃那些攻击你的人。"
	component = /datum/magic_item/greater/phoenixguard

/obj/item/enchantmentscroll/greater/phoenixguard/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（凤凰守护）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/greater/woundclosing
	name = "伤口闭合附魔卷轴"
	desc = "一张灌注了伤口闭合附魔的卷轴。会让你定期封住伤口。"
	component = /datum/magic_item/greater/woundclosing

/obj/item/enchantmentscroll/greater/woundclosing/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/ring))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（伤口闭合）"
		qdel(src)
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/greater/returningweapon
	name = "归还武器附魔卷轴"
	desc = "一张灌注了归还武器附魔的卷轴。能让你把现有武器召回手中。"
	component = /datum/magic_item/greater/returningweapon

/obj/item/enchantmentscroll/greater/returningweapon/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/ring)|| istype(O,/obj/item/clothing/neck/roguetown/psicross)||istype(O,/obj/item/clothing/gloves))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（归还武器）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/greater/archery
	name = "箭术附魔卷轴"
	desc = "一张灌注了箭术附魔的卷轴。会提升佩戴者的箭术。"
	component = /datum/magic_item/greater/archery

/obj/item/enchantmentscroll/greater/archery/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/ring)|| istype(O,/obj/item/clothing/neck/roguetown/psicross)||istype(O,/obj/item/clothing/gloves)|| istype(O, /obj/item/clothing/wrists/roguetown/bracers))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（箭术）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

//T4 below here

/obj/item/enchantmentscroll/mythic/infernalflame
	name = "炼狱焰附魔卷轴"
	desc = "一张灌注了炼狱焰附魔的卷轴。击中对手时会将其点燃。"
	component = /datum/magic_item/mythic/infernalflame

/obj/item/enchantmentscroll/mythic/infernalflame/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/gun/ballistic/revolver/grenadelauncher)|| istype(O,/obj/item/rogueweapon)|| istype(O,/obj/item/clothing))	//bow and crossbows included
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（炼狱焰）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/mythic/freeze
	name = "冰封附魔卷轴"
	desc = "一张灌注了冰封附魔的卷轴。击中敌人时，会将其冻在冰块之中。"
	component = /datum/magic_item/mythic/freezing

/obj/item/enchantmentscroll/mythic/freeze/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/gun/ballistic/revolver/grenadelauncher)||istype(O,/obj/item/clothing)|| istype(O,/obj/item/rogueweapon))//bow and crossbows included
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（冰封）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/mythic/rewind
	name = "时序回溯附魔卷轴"
	desc = "一张灌注了时序回溯附魔的卷轴。被击中数秒后，会把你传送回受击时所在的位置。"
	component = /datum/magic_item/mythic/rewind

/obj/item/enchantmentscroll/mythic/rewind/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing)|| istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（时序回溯）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/mythic/briars
	name = "荆棘诅咒附魔卷轴"
	desc = "一张灌注了荆棘诅咒附魔的卷轴。带有此附魔的武器会造成更高伤害，但也会反过来伤及持用者。"
	component = /datum/magic_item/mythic/briarcurse

/obj/item/enchantmentscroll/mythic/briars/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（荆棘诅咒）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))

/obj/item/enchantmentscroll/mythic/chaos_storm
	name = "混沌风暴附魔卷轴"
	desc = "一张灌注了混沌附魔的卷轴。带有此附魔的武器会造成随机效果。"
	component = /datum/magic_item/mythic/chaos_storm

/obj/item/enchantmentscroll/mythic/chaos_storm/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("你展开[src]并将[O]置于其中。片刻后，奥术蓝光一闪，[src]便碎成了尘土。"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += "（混沌风暴）"
		O.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		qdel(src)
	else
		to_chat(user, span_notice("什么也没有发生。也许这张卷轴不能给[O]附魔？"))
