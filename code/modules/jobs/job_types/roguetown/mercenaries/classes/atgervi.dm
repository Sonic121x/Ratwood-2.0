/datum/advclass/mercenary/atgervi
	name = "巴阿图尔"//mongolian honorific meaning valiant warrior/champion
	tutorial = "你是格隆恩高地的一名那兀惕。身为战士兼商旅，你们深入兹班图帝国的远征事迹，将永远被史家铭记。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/atgervi
	subclass_languages = list(/datum/language/gronnic)
	cmode_music = 'sound/music/combat_vagarian.ogg'
	class_select_category = CLASS_CAT_GRONN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/atgervi
	allowed_patrons = ALL_GRONNIC_PATRONS //Subvariant of the 'ALL_INHUMEN_PATRONS' tag, with Abyssor and Dendor as situational additions. Do not add any more to this, no matter what.


/datum/outfit/job/roguetown/mercenary/atgervi/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你是格隆恩高地的一名那兀惕。身为战士兼商旅，你们深入兹班图帝国的远征事迹，将永远被史家铭记。"))
	if(H.mind?.current)
		H.mind.current.faction += "[H.name]_faction"
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi
	gloves = /obj/item/clothing/gloves/roguetown/angle/atgervi
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/gronn
	pants = /obj/item/clothing/under/roguetown/trou/leather/atgervi
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
	backr = /obj/item/rogueweapon/shield/atgervi
	backl = /obj/item/storage/backpack/rogue/satchel/black
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle //They didn't have neck protection before.
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn
		if(/datum/patron/inhumen/matthios)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn
		if(/datum/patron/inhumen/baotha)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/gronn
		if(/datum/patron/divine/abyssor)
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn
		if(/datum/patron/divine/dendor)
			id = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn
		else
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/special //Failsafe. Gives a specially-fluffed version of Zizo's talisman, which can be reinterpreted as needed.

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_2)	//Capped to T1 miracles

	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.merctype = 1

/datum/advclass/mercenary/atgervi/shaman
	name = "扎伊兰萨满"//Zayran is the term for a high ranking male shaman in Tengrism.
	tutorial = "你是一名扎伊兰，是北境空原的高阶萨满。你们是凶悍的战士，不靠空洞的祈祷，而是借由仪式性的暴力与名为「腾格里」的兽灵沟通。"
	outfit = /datum/outfit/job/roguetown/mercenary/atgervishaman
	subclass_languages = list(/datum/language/gronnic)
	cmode_music = 'sound/music/combat_shaman2.ogg'
	traits_applied = list(TRAIT_STRONGBITE, TRAIT_CIVILIZEDBARBARIAN, TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_INT = -1,
		STATKEY_PER = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/mercenary/atgervi_shaman
	allowed_patrons = ALL_GRONNIC_PATRONS //Variant of the 'ALL_INHUMEN_PATRONS' tag, with Abyssor and Dendor as situational additions. Do not add any more to this, no matter what.

/datum/outfit/job/roguetown/mercenary/atgervishaman/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(0)
	to_chat(H, span_warning("你是一名扎伊兰，是北境空原的高阶萨满。你们是凶悍的战士，不靠空洞的祈祷，而是借由仪式性的暴力与名为「腾格里」的兽灵沟通。"))
	if(H.mind?.current)
		H.mind.current.faction += "[H.name]_faction"
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

	head = /obj/item/clothing/head/roguetown/helmet/leather/shaman_hood
	gloves = /obj/item/clothing/gloves/roguetown/plate/atgervi
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/atgervi
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/trou/leather/atgervi
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/flashlight/flare/torch
	H.put_in_hands(new /obj/item/rogueweapon/handclaw/gronn, FALSE)
	
	var/techniques = list("腾空飞踢 - 击退与额外伤害", "锁喉摔 - 体力伤害", "碎颚摔 - 眩晕减益", "头槌 - 易伤减益") // cool wrestling moves
	var/technique_choice = input(H,"选择你的技法。", "将敌人摔出去") as anything in techniques
	switch(technique_choice)
		if("腾空飞踢 - 击退与额外伤害")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
		if("锁喉摔 - 体力伤害")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
		if("碎颚摔 - 眩晕减益")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
		if("头槌 - 易伤减益")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn
		if(/datum/patron/inhumen/matthios)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn
		if(/datum/patron/inhumen/baotha)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/gronn
		if(/datum/patron/divine/abyssor)
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn
		if(/datum/patron/divine/dendor)
			id = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn
		else
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/special //Failsafe. Gives a specially-fluffed version of Zizo's talisman, which can be reinterpreted as needed.

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles.
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/stoneaxe/hurlbat = 1
		)
	H.merctype = 1

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi
	name = "那兀惕锁甲袍"
	desc = "格隆恩佣兵引以为傲的护具，以锁链与皮革精巧结合而成，编成一件厚实而坚韧的防护外袍。"
	icon_state = "atgervi_raider_mail"
	item_state = "atgervi_raider_mail"
	max_integrity = 400

/obj/item/clothing/suit/roguetown/armor/leather/heavy/atgervi
	name = "萨满外袍"
	desc = "一件覆着毛皮的防护外袍，往往由亲手缝制而成，象征着扎伊兰萨满的第二道试炼。敬奉豹兽，便意味着渴求更多。"
	icon_state = "atgervi_shaman_coat"
	item_state = "atgervi_shaman_coat"

/obj/item/clothing/under/roguetown/trou/leather/atgervi
	name = "毛皮裤"
	desc = "厚实的毛皮长裤，专为抵御最刺骨的寒风而制，也能在野兽与人类的牙爪之下提供一层像样的防护。"
	icon_state = "atgervi_pants"
	item_state = "atgervi_pants"
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/gloves/roguetown/angle/atgervi
	name = "毛衬皮手套"
	desc = "厚实而填衬充足的手套，为最酷烈的气候与荒野中最凶猛的野兽而制。"
	icon_state = "atgervi_raider_gloves"
	item_state = "atgervi_raider_gloves"
	color = "#ffffff"

/obj/item/clothing/gloves/roguetown/plate/atgervi
	name = "兽爪拳甲"
	desc = "一对骇人的覆甲利爪，是萨满严守不外传的古老传统。其上镌饰着他们所敬奉之神与所摒弃之神的符号。"
	icon_state = "atgervi_shaman_gloves"
	item_state = "atergvi_shaman_gloves"
	unarmed_bonus = 1.25

/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi
	name = "鸮形盔"
	desc = "一顶精心锻造、形如猫头鹰面容的钢盔，并加缀锁链以遮护面部与颈项，抵御连番打击。"
	icon_state = "atgervi_raider"
	item_state = "atgervi_raider"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/atgervi.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	block2add = null
	worn_x_dimension = 32
	worn_y_dimension = 48

/obj/item/clothing/head/roguetown/helmet/leather/saiga/atgervi
	name = "驼鹿兜帽"
	desc = "一顶看似朴拙却异常结实的皮革兜帽，上面带着一对沉重巨大的鹿角。这是扎伊兰萨满第四重试炼的奖赏，唯有独自在最终狩猎中猎杀一头咧嘴驼鹿，并以其头颅制成兜帽者，方能佩戴。"
	icon_state = "atgervi_shaman"
	item_state = "atgervi_shaman"
	flags_inv = HIDEEARS|HIDEFACE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/atgervi.dmi'
	flags_inv = HIDEEARS
	bloody_icon = 'icons/effects/blood64.dmi'
	worn_x_dimension = 32
	worn_y_dimension = 48
	experimental_inhand = FALSE
	experimental_onhip = FALSE
	dropshrink = 0.8

/obj/item/clothing/shoes/roguetown/boots/leather/atgervi
	name = "巴阿图尔皮靴"
	desc = "一双结实耐穿的皮靴，既能撑过战斗，也扛得住北地冰寒。"
	icon_state = "atgervi_boots"
	item_state = "atgervi_boots"

/obj/item/rogueweapon/shield/atgervi
	name = "鸢盾"
	desc = "一面硕大却轻便的木盾，中央包着钢制凸钉，更便于拨偏来袭的打击。"
	icon_state = "atgervi_shield"
	item_state = "atgervi_shield"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	force = 15
	throwforce = 10
	dropshrink = 0.8
	coverage = 80
	attacked_sound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 300
	experimental_inhand = FALSE

/obj/item/rogueweapon/shield/atgervi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("onback")
				return list("shrink" = 0.7,"sx" = -17,"sy" = -15,"nx" = -15,"ny" = -15,"wx" = -12,"wy" = -15,"ex" = -18,"ey" = -15,"nturn" = 0,"sturn" = 0,"wturn" = 180,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 1,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi
	name = "胡须战斧"
	desc = "一柄既可单手也可双手挥使的大斧，斧刃下缘带着夸张的勾形突出，既能撕开血肉，也能残暴地扯裂护甲。"
	icon_state = "atgervi_axe"
	item_state = "atgervi_axe"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	wlength = WLENGTH_LONG
	experimental_onhip = TRUE
	wdefense = 5
	max_blade_int = 250
	force = 26
	force_wielded = 33

/obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -9,"sy" = -8,"nx" = 9,"ny" = -7,"wx" = -7,"wy" = -8,"ex" = 3,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 2,"sy" = -8,"nx" = -6,"ny" = -3,"wx" = 3,"wy" = -4,"ex" = 4,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -44,"sturn" = 45,"wturn" = 47,"eturn" = 33,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.6,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 180,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

///////////////////////////////
// GRONN-SPECIFIC PSICROSSES //
///////////////////////////////

/obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
	name = "雕刻护符" //plotting talisman
	desc = "'狩猎，钻研猎物，摸清它的行踪，传承先祖的智慧，让族人与自己变得强大。认识世界，否则便归于消亡。'	</br>	</br>谋略之狼象征进取与求知的美德，使故土面临的阻碍与威胁皆可克服。洞悉野兽与青铜的真理，便能减轻未来的艰辛。但切莫沾染魔法，玩火总会有人被灼伤。"
	icon_state = "gronnzizo"

/obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/gronn
	name = "雕刻护符" //relishing talisma
	desc = "'满溢的欲望，无尽的渴求，胜利的荣光，爱人的拥抱。拥抱花豹，否则便忘却你的力量。'	</br>	</br>享乐之豹象征爱与荣耀的美德，无论身在战场还是家园。享受肉欲、美酒与香料，但须警惕过度放纵，那会令人萎靡不振、懒散迟钝。过于安逸便会变得软弱，而这份软弱会让你沦为花豹的美餐。"
	icon_state = "gronnbaotha"

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn
	name = "雕刻护符" //starving talisman
	desc = "'饥饿，毁灭，迫近的霜寒，吾敌之敌。喂饱巨熊，否则便被吞噬。'	</br>	</br>饥饿之熊象征的并非美德，而是不惜一切求得繁盛的必要。贪婪并非罪过，而是美德；唯有如此，才能使故土不再遭受贫穷与饥荒。劫掠、抢夺，夺取他人不愿与你分享的财富，但别忘了，每一个选择都会带来后果。"
	icon_state = "gronnmatthios"

/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn
	name = "雕刻护符" //grinning talisman
	desc = "'战争，搏杀，暴力，胜利的狂喜，受人敬仰的荣耀。击败敌人，否则便与之同赴黄泉。'	</br>	</br>狞笑驼鹿象征力量与支配的美德，使人能熬过故土的凛冽暴雪，也能抵御劫掠同胞的敌人。桀骜不驯，势不可挡，但切莫在狂乱中迷失自我；就连驼鹿也曾被锁链束缚。无故杀害同胞，锁链便会收紧，你的灵魂也将被鹿角贯穿。"
	icon_state = "gronngraggar"

/obj/item/clothing/neck/roguetown/psicross/dendor/gronn
	name = "雕刻护符" //volfskinned talisman
	desc = "'地上的世界，遍布利齿如刀的植物与腐败的尸骸。从丛林到荒漠，就连石头也属于自然。怀着应有的敬意聆听它的呼唤，否则便陷入疯狂。'	</br>	</br>披狼皮者象征自然与节制的美德，教人同世界及其中的灵体和谐共处。摘下一颗杰克莓，便种下一粒种子；猎杀一头野兽，便物尽其用。但务必有所节制：毫无敬意、不知回报地索取，只会为故土招来厄运。然而，若彻底投入原始野性，也会丧失人性——更甚者，会变成自己所猎杀的野兽。"
	icon_state = "gronndendor"

/obj/item/clothing/neck/roguetown/psicross/abyssor/gronn
	name = "雕刻护符" //hadal talisman
	desc = "'深处的混沌，冰冷漆黑的水压与碾碎一切的重负。化作洋流，驾驭波涛。掌好风帆，在风暴中坚守，否则便被卷入永无止境的漂泊。'	</br>	</br>盘旋海怪并不象征美德，而是一位真实的存在：故土海域的守护者，遍身触腕，如其统御的大海一般变幻莫测。接纳人生的无常，便能在最需要时得到好运与垂怜。但切莫因此自暴自弃，否则你也会与其他人一同被卷入深渊。"
	icon_state = "gronnabyssor"

/obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/special
	name = "雕刻护符" //familial talisman
	desc = "'过往的回忆，未来的梦想。一尊兽形神物，雕刻着故土之外无人能懂的力量。同胞，愿你航行顺遂。'"

/// Generic version of the matthios gronn necklace that has no examine highlights. Purely for loadout drip
/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn/generic
	name = "兽牙项链" //starving talisman, (non-gronnic, generic)
	desc = "一条挂着巨大獠牙的项链。又或者，那其实是一枚硕大的爪子？"

//
