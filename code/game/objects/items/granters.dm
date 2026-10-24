
///books that teach things (intrinsic actions like bar flinging, spells like fireball or smoke, or martial arts)///

/obj/item/book/granter
	due_date = 0 // Game time in deciseconds
	unique = 1   // 0  Normal book, 1  Should not be treated as normal book, unable to be copied, unable to be modified
	var/list/remarks = list() //things to read about while learning.
	var/pages_to_mastery = 3 //Essentially controls how long a mob must keep the book in his hand to actually successfully learn
	var/reading = FALSE //sanity
	var/oneuse = TRUE //default this is true, but admins can var this to 0 if we wanna all have a pass around of the rod form book
	var/used = FALSE //only really matters if oneuse but it might be nice to know if someone's used it for admin investigations perhaps

/obj/item/book/granter/proc/turn_page(mob/user)
	playsound(user, pick('sound/blank.ogg'), 30, TRUE)
	if(do_after(user,50, user))
		if(remarks.len)
			to_chat(user, span_notice("[pick(remarks)]"))
		else
			to_chat(user, span_notice("我继续读了下去……"))
		return TRUE
	return FALSE

/obj/item/book/granter/proc/recoil(mob/user) //nothing so some books can just return

/obj/item/book/granter/proc/already_known(mob/user)
	return FALSE

/obj/item/book/granter/proc/on_reading_start(mob/user)
	to_chat(user, span_notice("我开始阅读[name]……"))

/obj/item/book/granter/proc/on_reading_stopped(mob/user)
	to_chat(user, span_notice("我停止了阅读……"))

/obj/item/book/granter/proc/on_reading_finished(mob/user)
	to_chat(user, span_notice("我读完了[name]！"))

/obj/item/book/granter/proc/onlearned(mob/user)
	used = TRUE


/obj/item/book/granter/attack_self(mob/living/user)
	if(reading)
		to_chat(user, span_warning("我已经在读这本了！"))
		return FALSE
	if(!user.can_read(src))
		return FALSE
	if(already_known(user))
		return FALSE
/*	AZURE PEAK REMOVAL -- UNUSED ANYWAY
	if(user.STAINT < 12)
			to_chat(user, span_warning("这些蔓延交错的符文我根本无法理解！"))
			return FALSE */
	if(used && oneuse)
		to_chat(user, span_warning("这眼知识之泉本就不是为让人啜饮两次而存在的！"))
		recoil(user)
		return FALSE
	on_reading_start(user)
	reading = TRUE
	for(var/i=1, i<=pages_to_mastery, i++)
		if(!turn_page(user))
			reading = FALSE
			on_reading_stopped()
			return FALSE
	if(do_after(user, 50, user))
		reading = FALSE
		on_reading_finished(user)
		return TRUE
	reading = FALSE //failsafe
	return FALSE

/obj/item/book/granter/spell
	grid_width = 64
	grid_height = 32

	var/spell
	var/spellname = "召来虫群"

/obj/item/book/granter/spell/already_known(mob/user)
	if(!spell)
		return TRUE
	if(user.mind.has_spell(spell, specific = TRUE))
		to_chat(user, span_warning("这本我已经读过了！"))
		return TRUE
	return FALSE

/obj/item/book/granter/spell/on_reading_start(mob/user)
	to_chat(user, span_notice("我开始阅读有关施放[spellname]的内容……"))

/obj/item/book/granter/spell/on_reading_finished(mob/user)
	to_chat(user, span_notice("我感觉自己已经掌握了足够的心得，能够施放[spellname]了！"))
	var/datum/S = new spell
	user.mind.AddSpell(S)
	user.log_message("学会了法术 [spellname] ([S])", LOG_ATTACK, color="orange")
	onlearned(user)

/obj/item/book/granter/spell/random
	icon_state = "random_book"

/obj/item/book/granter/spell/random/Initialize(mapload)
	. = ..()
	var/static/banned_spells = list(/obj/item/book/granter/spell/mimery_blockade)
	var/real_type = pick(subtypesof(/obj/item/book/granter/spell) - banned_spells)
	new real_type(loc)
	return INITIALIZE_HINT_QDEL

///ACTION BUTTONS///

/obj/item/book/granter/action
	var/granted_action
	var/actionname = "抓虫" //might not seem needed but this makes it so you can safely name action buttons toggle this or that without it fucking up the granter, also caps

/obj/item/book/granter/action/already_known(mob/user)
	if(!granted_action)
		return TRUE
	for(var/datum/action/A in user.actions)
		if(A.type == granted_action)
			to_chat(user, span_warning("关于[actionname]的内容我早就全都懂了！"))
			return TRUE
	return FALSE

/obj/item/book/granter/action/on_reading_start(mob/user)
	to_chat(user, span_notice("我开始阅读有关[actionname]的内容……"))

/obj/item/book/granter/action/on_reading_finished(mob/user)
	to_chat(user, span_notice("我感觉自己已经把[actionname]掌握得相当不错了！"))
	var/datum/action/G = new granted_action
	G.Grant(user)
	onlearned(user)

//Crafting Recipe books

/obj/item/book/granter/crafting_recipe
	var/list/crafting_recipe_types = list()

/obj/item/book/granter/crafting_recipe/on_reading_finished(mob/user)
	. = ..()
	if(!user.mind)
		return
	for(var/crafting_recipe_type in crafting_recipe_types)
		var/datum/crafting_recipe/R = crafting_recipe_type
		user.mind.teach_crafting_recipe(crafting_recipe_type)
		to_chat(user,span_notice("我学会了如何制作[initial(R.name)]。"))


/obj/item/book/granter/trait
	var/granted_trait = null
	var/required_language = null

/obj/item/book/granter/trait/attack_self(mob/living/user)
	if(required_language && !user.has_language(required_language))
		to_chat(user, span_warning("这本书里的文字我完全看不明白。"))
		return FALSE
	return ..()

/obj/item/book/granter/trait/already_known(mob/user)
	if(!granted_trait)
		return TRUE
	if(HAS_TRAIT(user, granted_trait))
		to_chat(user, span_warning("这些技法我已经会了！"))
		return TRUE
	return FALSE

/obj/item/book/granter/trait/on_reading_start(mob/user)
	to_chat(user, span_notice("我开始钻研其中的图示与书写技法……"))

/obj/item/book/granter/trait/on_reading_finished(mob/user)
	to_chat(user, span_notice("我感觉自己已经掌握了[name]中记述的技法。"))
	ADD_TRAIT(user, granted_trait, TRAIT_GENERIC)
	onlearned(user)


/obj/item/book/granter/trait/kazengunite_smith
	name = "风郡锻造传书"
	desc = "一本磨损严重的风郡锻造技法手册，满布图示与文字。封面印有寇肯流派的标记。需要懂得风郡语才能解读。"
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "basic_book_0"
	granted_trait = TRAIT_KAZENGUNITE_SMITH
	required_language = /datum/language/kazengunese
	pages_to_mastery = 10
	remarks = list(
		"开篇章节讲述了玉钢的冶炼法：将富含铁质的砂矿缓缓投入粘土炉中，让炉火三昼夜不熄，炼出块炼钢。唯有如此，才称得上真正的风郡钢。",
		"接下来一大段都在解释锻炼法：先将钢块打碎，按含碳量分类，再在锤下反复折叠。每折一次，层数便翻倍。书中警告不可过度折叠，因为次数太多反会烧掉工匠苦苦追求的品质。",
		"书里详细图解了甲伏锻法：以较硬的钢包裹较软的钢芯，再用锤锻焊合。硬刃负责持锋，软背负责吸震。两者缺一不可。",
		"另有数页专讲覆土工序，即淬火前将黏土与木炭调成的糊料涂在刀身上。刀背涂厚，刃口涂薄。正是这种差异冷却塑造了硬化区，也就是刃纹。",
		"关于烧入的记述尤为生动：刀身加热至不再吸附磁石后，便将刃口先行投入水中。作者告诫铁匠，要相信钢色，而非心跳的次数。",
		"护甲章节先从小札讲起：每一片甲片都不过拇指大小，却要在组装前反复打孔、上漆。书中特意强调，漆并非装饰，而是防锈的护甲。",
		"随后便是威毛的详细说明：用丝绳或皮绳把小札交错串连成排。这种编法能把冲击分散到整片甲面。作者指出，只要有一排系得不正，经不起一下重击便会垮掉。",
		"兜盔部分讲的是钵体的成形：以三角形钢板沿边铆接，再收出向上的峰形。每一枚铆钉都必须铆平后再上漆。只要有一颗翘起，便会勾住来刃。",
		"还有一段虽短却精确地讲解了籠手的结构：手背与手指处以小块长方钢板配合链甲铆接，手腕内侧则衬以软垫布料。钢铁只该保护真正需要保护的地方。",
		"最后一章论及护喉，即以细小链环配合加硬护领制成，并用丝绳在喉前系紧。作者说，这是最常被忽视的一件护具，也往往是最致命的疏漏。",
	)

//! --BLACKSTONE SCROLLS-- !/
/obj/item/book/granter/spell/fly
	name = "飞行术卷轴"
	desc = "教你施展飞行术。"
	spell = /datum/action/cooldown/spell/fly
	spellname = "飞行术"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scrolldarkred"
	oneuse = TRUE
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound = 'sound/blank.ogg'
	remarks = list("凌空而起……", "心念轻盈……", "升入苍穹……")

/obj/item/book/granter/spell/fly/onlearned(mob/living/carbon/user)
	..()
	if(oneuse)
		name = "被抽空的卷轴"
		desc = "这张卷轴曾写满魔法经文，如今其中知识已被他人抽走，表面空空如也。它已经毫无用处。"
		icon_state = "scroll"
		user.visible_message(span_warning("[src]上的魔法墨迹被硬生生抽离了！"))
