// TEMPERANCE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/timesoldier/temperance/uniform // ts just a padded gamby 🥀
	name = "士兵制服"
	desc = "<span class='yellow'><i>我还记得第一次穿上这件破旧衣服的时候。它已经陪伴我大约十五年了。那时穿着还有点大，如今却正合身。</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "uniform"
	item_state = "uniform"
	shiftable = FALSE

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/timesoldier/temperance/eb_armor // hauberk reskin, except stronger since it's light.
	name = "制式护甲"
	desc = "<span class='yellow'><i>工匠公会的工程师们终于弄明白如何在自动铁匠铺里制造廉价、易于生产的护甲后，这就成了我们大多数人的标准装备。</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "EB_armor"
	item_state = "EB_armor"
	armor_class = ARMOR_CLASS_LIGHT
	body_parts_covered = CHEST|GROIN

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/timesoldier/temperance/eb_armor/Initialize(mapload)
	. = ..()
	var/datum/component/item_equipped_movement_rustle/rustle = GetComponent(/datum/component/item_equipped_movement_rustle)
	if(rustle)
		rustle.rustle_sounds = list(
			'modular/timesoldier/sounds/gear1.ogg',
			'modular/timesoldier/sounds/gear2.ogg',
			'modular/timesoldier/sounds/gear3.ogg',
			'modular/timesoldier/sounds/gear4.ogg'
		)

/obj/item/clothing/mask/rogue/facemask/steel/confessor/timesoldier/temperance/redmask // Confessor mask reskin!
	name = "奥塔瓦防毒面具"
	desc = "<span class='yellow'><i>奥塔瓦人很有创造力，几十年前就有了自己的面具，直到最近才肯把图纸交给我们这些'贱民'。齐佐信徒开始使用齐佐灾祸毒气喷吐器之类的恶毒玩意儿后，这些面具就作为标准装备发给了所有人。 <br>面具通常还装有一些钢板，提供额外防护。</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "redmask"
	item_state = "redmask"
	flags_inv = HIDEFACE|HIDESNOUT|HIDEFACIALHAIR

/obj/item/clothing/head/roguetown/veiled/timesoldier/temperance/veil // Nurse's veil reskin. though for some reason it's more fancy than I thought so I have to neuter some detail tags
	name = "死亡面纱"
	desc = "<span class='yellow'><i>几年前，佩斯特拉的瘟疫修士最初把这东西交给了我们。对'射手'来说，这真是恩赐，帮我们抵御了腐烂的恶臭。不过，随着时间流逝，面具也失去了实际效用。<br>反正我早已习惯死亡的气味了。</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "veil"
	item_state = "veil"
	detail_tag = null
	altdetail_tag = null

/obj/item/clothing/cloak/poncho/timesoldier/temperance/poncho
	name = "雨披"
	desc = "<span class='yellow'><i>我曾在战壕里坐了两天多。一直守着同一个位置，俯瞰同一片地方。让我活下来的只有风干肉条，以及这件好东西。<br>不过，它挡不住巨鼠的啃咬。</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "poncho_s"
	item_state = "poncho"
	color = null

/obj/item/clothing/shoes/roguetown/boots/footwraps/padded/timesoldier/temperance/boots //reskinned padded footwraps
	name = "衬垫长靴"
	desc = "<span class='yellow'><i>虽然穿着不舒服，我还是渐渐喜欢上了这双靴子。紧，但又不至于太紧，在泥里连续站上几个星期后，它们也就松了。</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "EB_boots_wrapped"
	item_state = "EB_boots_wrapped"


// ARSONIST

/obj/item/clothing/head/roguetown/helmet/leather/timesoldier_arsonist
	name = "纵火者兜帽"
	desc = "一顶经过强化、能耐受高温与损伤的硬皮兜帽。它完全包裹头部与面孔，让佩戴者看起来更像恶魔而非人类。"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	icon = 'modular/timesoldier/sprites/gear.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "arsonist"
	item_state = "arsonist"

	// slightly tougher than a regular hardened leather helmet.
	max_integrity = 175

	// full head + face coverage, replacing the need for a separate mask.
	body_parts_covered = HEAD|HAIR|EARS|NOSE|MOUTH|EYES
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEMASK|HIDESNOUT

/obj/item/clothing/suit/roguetown/armor/leather/studded/timesoldier_arsonist
	name = "纵火者外套"
	desc = "为战场纵火狂打造的铆钉皮外套；耐磨实用，足以经受火星与搏斗的摧残。"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	mob_overlay_icon = 'modular/timesoldier/sprites/clothing/onmob.dmi'
	icon_state = "arsoncoat"
	item_state = "arsoncoat"

	// slightly tougher than the base studded leather parent.
	max_integrity = 250
