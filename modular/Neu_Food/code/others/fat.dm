// -------------- FAT -----------------
/obj/item/reagent_containers/food/snacks/fat
	icon = 'modular/Neu_Food/icons/others/fat.dmi'
	name = "脂肪"
	desc = "一团动物脂肪，适合用于炼制油脂和灌制香肠。"
	icon_state = "fat"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	eat_effect = /datum/status_effect/debuff/uncookedfood
	possible_item_intents = list(/datum/intent/food, /datum/intent/splash)
	fat_yield = 20

/obj/item/reagent_containers/food/snacks/fat/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("正在灌制香肠..."))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/sausage(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/fat/attack(mob/living/M, mob/user, proximity)
	if(user.used_intent.type == /datum/intent/food)
		return ..()

	if(!isliving(M) || (M != user))
		return ..()

	user.visible_message("[user]开始往[M]身上抹油", "你开始往[M]身上抹油")
	if(!do_after(user, 5 SECONDS, M))
		return
	M.apply_status_effect(/datum/status_effect/buff/oiled)

/obj/item/reagent_containers/food/snacks/fat/examine()
	. = ..()
	. += span_info("以泼洒意图对自己使用可给自己抹油，使你在暴露时变得滑溜、更难被抓住。赤脚会降低滑倒几率。")

// TALLOW is used as an intermediate crafting ingredient for other recipes.
/obj/item/reagent_containers/food/snacks/tallow
	name = "板油"
	desc = "从被宰杀的生物身上取下脂肪组织，炼去筋膜后制成一种坚硬且易于保存的 \
	油脂。"
	icon = 'modular/Neu_Food/icons/others/fat.dmi'
	icon_state = "tallow"
	tastes = list("油脂" = 1, "油" = 1, "悔意" =1)
	obj_flags = CAN_BE_HIT
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	eat_effect = /datum/status_effect/debuff/uncookedfood
	fat_yield = 5 // 5 per animal fat
	bitesize = 1
	dropshrink = 0.75
	var/wax_pigment = "white" //Default pigment for tallow, can be changed by mixing with other reagents

/obj/item/reagent_containers/food/snacks/tallow/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/soap,
		/datum/crafting_recipe/roguetown/survival/candle,
		/datum/crafting_recipe/roguetown/survival/candle/eora,
		/datum/crafting_recipe/roguetown/survival/recurvepartial,
		/datum/crafting_recipe/roguetown/survival/longbowpartial,
		/datum/crafting_recipe/roguetown/leather/container/javelinbag,
		/datum/crafting_recipe/roguetown/leather/fingerless_leather_gloves,
		/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_pants,
		/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_pants/shorts,
		/datum/crafting_recipe/roguetown/leather/armor/helmet/advanced,
		/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor,
		/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor/coat,
		/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor/jacket,
		/datum/crafting_recipe/roguetown/leather/hidebikini,
		/datum/crafting_recipe/roguetown/leather/unique/otavanleatherpants,
		/datum/crafting_recipe/roguetown/leather/unique/otavanboots,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/reagent_containers/food/snacks/tallow/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("将板油与一杯斟满的葡萄酒混合，可以制成'红板油'——一种带绯红色泽的蜡，常用于密封公爵与宗教要函。")
	. += span_info("将板油与磨碎的茶叶混合，可以制成'绿板油'——一种病态绿色的蜡，常用于密封商业与官府文书。")
	. += span_info("若想要更骇人的替代品，可以用血来代替葡萄酒，或者——若你是一位训练有素的审判庭特工——用一满筒索引器。")

/obj/item/reagent_containers/food/snacks/tallow/red
	name = "审判庭板油"
	desc = "从被宰杀的生物身上取下脂肪组织，炼去筋膜后制成一种坚硬且易于保存的 \
	油脂。随后再浸入鲜血或某种近似鲜血的东西，使其成为一种取材容易却相当阴森的蜡替代品，深受审判庭青睐。正如奥塔瓦人所说，尽情享用。"
	icon_state = "redtallow"
	tastes = list("油脂" = 1, "油" = 1, "悔意" =1, "血"=1,)
	wax_pigment = "red"

/obj/item/reagent_containers/food/snacks/tallow/black
	name = "黑板油"
	desc = "从被宰杀的生物身上取下脂肪组织，炼去筋膜后制成一种坚硬且易于保存的 \
	油脂。随后浸入灰烬或类似灰烬的物质中，使其成为一种深色的蜡替代品。散发着新印书籍与灰烬的气味。"
	icon_state = "blacktallow"
	tastes = list("油脂" = 1, "油" = 1, "悔意" = 1, "苦味" = 1)
	wax_pigment = "black"

/* //For future use, maybe?
/obj/item/reagent_containers/food/snacks/tallow/green
	name = "greentallow"
	desc = "Fatty tissue is harvested from slain creachurs and rendered of its membraneous sinew to produce a hard shelf-stable \
    grease. To satisfy the bean-counters of Azuria, it has been infused with ground tea leaves, creating a sickly green hue \
    synonymous with coin and corruption. It's the smell of a balanced ledger and dried tea."
	icon_state = "greentallow"
	tastes = list("grease" = 1, "oil" = 1, "regret" = 1, "bitterness" = 1,)
	wax_pigment = "green"
*/

/obj/item/reagent_containers/food/snacks/tallow/soft
	name = "软板油"
	desc = "加入额外脂肪软化后的炼制板油，更便于涂抹封缄。它看起来与审判庭板油相似，但没有它那份神圣认可。"
	icon_state = "softtallow"
	tastes = list("油脂" = 1, "油" = 1, "悔意" =1)

/obj/item/reagent_containers/food/snacks/tallow/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/inqarticles/indexer))
		var/obj/item/inqarticles/indexer/IND = I
		var/success
		if(HAS_TRAIT(user, TRAIT_INQUISITION))
			if(IND.full)
				if(alert(user, "要把板油浸进去吗？", "只是血而已", "要", "不要") != "不要")
					success = TRUE
					IND.fullreset(user)
				else
					return	
				if(success)
					changefood(/obj/item/reagent_containers/food/snacks/tallow/red, user)
	if(istype(I, /obj/item/ash))
		if(alert(user, "要给板油染色吗？", "只是灰烬而已", "要", "不要") != "不要")
			changefood(/obj/item/reagent_containers/food/snacks/tallow/black, user)
			qdel(I)
		else
			return
