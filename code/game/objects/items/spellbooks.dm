/* Spellbook
Intended to be a reward or a goal for pure mage, allowing them to rebind their aspect spells.
*/

/obj/item/rogueweapon/spellbook
	base_implement_name = "次级法典"
	var/open = FALSE
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "spellbookbrown_0"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	grid_width = 32
	grid_height = 32
	var/base_icon_state = "spellbookbrown"
	var/unique = TRUE
	firefuel = 2 MINUTES
	dropshrink = 0.6
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	force = 20
	throwforce = 10
	w_class = WEIGHT_CLASS_SMALL
	sharpness = IS_BLUNT
	can_parry = FALSE
	wlength = WLENGTH_SHORT
	wdefense = 1
	max_integrity = 200
	integrity_failure = 0.3
	sewrepair = TRUE
	anvilrepair = null
	associated_skill = /datum/skill/combat/arcyne
	possible_item_intents = list(/datum/intent/mace/strike/wood, /datum/intent/mace/smash/wood)
	name = "\improper 次级奥术法典"
	desc = "一本闪着光芒、噼啪作响的书，满是令人凝视时头痛的符文与符号。可重新绑定法相法术。"
	special = /datum/special_intent/arcyne_descent
	implement_tier = IMPLEMENT_TIER_LESSER
	implement_refund = IMPLEMENT_REFUND_LESSER
	sellprice = 34
	var/picked // if the book has had it's style picked or not
	var/curpage = 1
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME | CLAMP_BREAK

/obj/item/rogueweapon/spellbook/greater
	base_implement_name = "高等法典"
	name = "\improper 高等奥术法典"
	desc = "装帧精良、镶有优质聚能宝石的奥术法典。可重新绑定法相法术，并返还相当一部分施法能量。"
	force = 22
	max_integrity = 100
	sellprice = 42
	implement_tier = IMPLEMENT_TIER_GREATER
	implement_refund = IMPLEMENT_REFUND_GREATER

/obj/item/rogueweapon/spellbook/grand
	base_implement_name = "大师法典"
	name = "\improper 大师奥术法典"
	desc = "镶有卓越宝石的杰作奥术法典。可重新绑定法相法术，并将消耗的施法能量精炼后返还给持有者。"
	force = 25
	max_integrity = 120
	sellprice = 121
	implement_tier = IMPLEMENT_TIER_GRAND
	implement_refund = IMPLEMENT_REFUND_GRAND

/obj/item/rogueweapon/spellbook/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/spellbook/examine(mob/user)
	. = ..()
	. += span_notice("阅读它可以重新绑定你的法相法术。")
	if(implement_refund)
		. += span_notice("施法时手持此法器会留下余留专注，在 20 秒内将法术资源消耗的 [round(implement_refund * 100)]% 返还为能量。")

/obj/item/rogueweapon/spellbook/attack_self(mob/living/carbon/human/user)
	if(!open)
		attack_right(user)
		return
	read(user)
	user.update_inv_hands()

/obj/item/rogueweapon/spellbook/rmb_self(mob/user, keybind = FALSE)
	attack_right(user)
	return

/obj/item/rogueweapon/spellbook/proc/read(mob/user)
	change_spells()
	return FALSE

/obj/item/rogueweapon/spellbook/proc/change_spells(mob/user = usr)
	var/datum/mind/user_mind = user.mind
	if(!user_mind)
		return
	if(!LAZYLEN(user_mind.mage_aspect_config))
		to_chat(user, span_warning("我缺乏使用它所需的奥术训练。"))
		return
	var/datum/aspect_picker/picker = new(user, FALSE, user_mind.mage_aspect_config)
	picker.ui_interact(user)

/obj/item/rogueweapon/spellbook/attack_right(mob/user)
	if(!picked)
		var/list/designlist = list("green", "yellow", "brown", "steel", "gem", "skin", "mimic", "wyrdbark", "sunfire", "abyssal", "cinder", "vessel", "edgebound", "sovereign")
		var/the_time = world.time
		var/design = tgui_input_list(user, "选择一种样式。","奥术秘典样式", designlist)
		if(!design)
			return
		if(world.time > (the_time + 30 SECONDS))
			return
		base_icon_state = "spellbook[design]"
		update_icon()
		picked = TRUE
		switch(design) //super lazy but idrc
			if ("green")
				return
			if ("yellow")
				return
			if ("brown") //preserve default name and desc for the basic options
				return
			if ("steel")
				desc = "金属法典上排列着符文与炼金符号。可用于解除法术绑定。"
			if ("gem")
				desc = "书页如同通向浩瀚星空的窗户。可用于解除法术绑定。"
			if ("skin")
				desc = "亵渎符号遍布这本法术书——书页上滴落的是血吗？可用于解除法术绑定。"
			if ("mimic")
				desc = "这本书似乎反过来在阅读你。可用于解除法术绑定。"
			if ("wyrdbark")
				desc = "由树心木与妖精魔法构成，翻开时落叶飞舞。可用于解除法术绑定。"
			if ("sunfire")
				desc = "阿斯特拉塔的光辉从施法羊皮纸中倾泻而出。可用于解除法术绑定。"
			if ("abyssal")
				desc = "触感冰冷麻木；仅仅看着它，就令你倍感渺小。可用于解除法术绑定。"
			if ("cinder")
				desc = "莎草纸间飘着烟雾，传来闷燃的噼啪声，却从不着火。可用于解除法术绑定。"
			if ("vessel")
				desc = "一瓶塞紧的墨水，拔开瓶塞便会化作完整的法典。可用于解除法术绑定。"
				name = "\improper 奥术容器" //calling it 'vessel tome' is weird as fuck
				return
			if ("edgebound")
				desc = "粗犷、结实而实用；战斗法师还能奢求什么？可用于解除法术绑定。"
			if ("sovereign")
				desc = "庄严华贵，令你忍不住想用某种敬称来称呼它。可用于解除法术绑定。"
		name = "\improper [design]法典"
		return
	if(!open)
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		open = FALSE
		playsound(loc, 'sound/items/book_close.ogg', 100, FALSE, -1)
	curpage = 1
	update_icon()
	user.update_inv_hands()

/obj/item/rogueweapon/spellbook/update_icon()
	icon_state = "[base_icon_state]_[open]"
