/datum/advclass/mercenary/newmoon
	name = "新月咒剑士"
	tutorial = "兹班图的新月咒剑士，是拉尔维斯廷某片未知地域中一座已然覆灭的诺克修道院的幸存者，\
	那曾是兹班图帝国境内十神最后一处重要据点。\
	在腐朽之灾的重压下，他们的修院生活与虔诚信念迅速崩塌，被迫从孤绝苦修的日子跌入普通佣兵的生涯；\
	沦为普通佣兵；诺克的赐福在斩杀怪物与凡人时都颇为有用。 \
	无论出于何种缘由，你如今来到了这片地界，向出价最高者献上自己的技艺。知识即力量。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/tabaxi,
		/datum/species/anthromorph,
		/datum/species/demihuman,
		/datum/species/elf/wood,
		/datum/species/tieberian
	)
	outfit = /datum/outfit/job/roguetown/mercenary/newmoon
	cmode_music = 'sound/music/combat_desertrider.ogg'
	class_select_category = CLASS_CAT_ZYBANTU
	subclass_languages = list(/datum/language/celestial)
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = -2,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 6)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
	)

	extra_context = "该分支仅限：塔巴西 | 兽裔 | 半兽裔 | 木精灵 | 提夫林。"

/datum/outfit/job/roguetown/mercenary/newmoon
	allowed_patrons = list(/datum/patron/divine/noc)

/datum/outfit/job/roguetown/mercenary/newmoon/pre_equip(mob/living/carbon/human/H)
	..()
	r_hand = /obj/item/rogueweapon/sword/sabre/newmoon
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	head = /obj/item/clothing/head/roguetown/roguehood/reinforced/newmoon
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/newmoon
	armor = /obj/item/clothing/suit/roguetown/armor/leather/newmoon_jacket
	beltr = /obj/item/rogueweapon/scabbard/sword
	beltl = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/neck/roguetown/psicross/noc

	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/roguegem/amethyst = 1,
		/obj/item/lockpick = 1,
		)

	to_chat(H, span_warning("你初始拥有武器绑定。记得绑定武器，才能使用你的能力并积累奥术动量。"))

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.chant = "blade"

	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
		H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
		H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
		H.mind.AddSpell(new /datum/action/cooldown/spell/blade_storm)
		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

//Their sabre. Peel capable when off. Does burn when on. OldRW rage inducing classic, returned.
//Now properly inflicts burn wounds, on top of the burn type damage. Very painful.
/obj/item/rogueweapon/sword/sabre/newmoon
	name = "寒雾军刀"
	desc = "一柄缭绕着亮蓝色冻雾的纤薄军刀。仅仅握住这把刀，都让人觉得手指快要被冻伤。"
	icon = 'icons/roguetown/weapons/32.dmi'
	icon_state = "nm_saber"
	force = 22//Dropped to 14 when on. Fire damage is a hell of a thing. -8, overall.
	max_integrity = 200//+50
	max_blade_int = 150//-50
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/strike)
	damtype = BRUTE
	light_color = LIGHT_COLOR_BLUE
	var/on = FALSE

/datum/intent/sword/freeze
	name = "冰封"
	icon_state = "insmoke"//Is it funny yet? Get it?
	attack_verb = list("冰封")
	animname = "chop"
	hitsound = list('sound/combat/hits/pick/genpick (1).ogg')
	penfactor = 60
	swingdelay = 8//+2
//	damfactor = 1.2//Not with new wounds!!!!
	blade_class = BCLASS_BURN

/obj/item/rogueweapon/sword/sabre/newmoon/update_icon()
	if(on)
		icon_state = "nm_saber_freeze"
	else
		icon_state = "nm_saber"

/obj/item/rogueweapon/sword/sabre/newmoon/attack_self(mob/user)
	if(on)
		on = FALSE
		damtype = BRUTE
		possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/strike)
		force = 22
	else
		user.visible_message(span_warning("[user] 的刀刃亮起了幽蓝寒焰。"))
		on = TRUE
		damtype = BURN
		possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/freeze, /datum/intent/sword/strike)
		force = 14//Remember, BURN DAMAGE.
	playsound(user, pick('sound/magic/magic_nulled.ogg'), 100, TRUE)
	if(user.a_intent)
		var/datum/intent/I = user.a_intent
		if(istype(I))
			I.afterchange()
	user.update_a_intents()
	update_icon()

//The clothing.
/obj/item/clothing/suit/roguetown/armor/leather/newmoon_jacket
	name = "新月 外袍"
	desc = "这件青绿色外袍轻便、华丽，却仍有相当的防护性。它是 新月 圣团的标志装束，胸前中央还缀着一枚 诺克 护符。"
	icon_state = "newmoon_jacket"
	item_state = "newmoon_jacket"
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER

/obj/item/clothing/head/roguetown/roguehood/reinforced/newmoon
	color = "#78a3c9"

/obj/item/clothing/suit/roguetown/shirt/tunic/newmoon
	color = "#78a3c9"
