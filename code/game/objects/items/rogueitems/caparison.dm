/obj/item/caparison
	name = "鞍饰毯"
	desc = "一块用于装饰鞍具的布毯。这一款适合赛加羚羊。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "caparison"
	var/caparison_icon = 'icons/roguetown/mob/monster/saiga.dmi'
	var/caparison_state = "caparison"
	var/detail_state
	var/list/detail_types
	var/list/symbol_types
	var/female_caparison_state = "caparison-f"
	gender = NEUTER
	var/list/valid_animal_types = list(/mob/living/simple_animal/hostile/retaliate/rogue/saiga)

/obj/item/caparison/attack(mob/living/M, mob/living/user)
	if(!issimple(M))
		to_chat(user, span_warning("[src]只能用于动物！"))
		return
	if(!is_type_in_list(M, valid_animal_types))
		to_chat(user, span_warning("[src]不能用于[M]！它只适合特定动物。"))
		return

	var/mob/living/simple_animal/animal = M
	if(animal.adult_growth)
		to_chat(user, span_warning("[animal]尚未成年，无法披上鞍饰毯！"))
		return
	if(animal.ccaparison)
		to_chat(user, span_warning("[animal]已经披着鞍饰毯了！"))
		return
	if(!animal.ssaddle)
		to_chat(user, span_warning("必须先给[animal]装上鞍具，才能披上鞍饰毯！"))
		return

	user.visible_message(span_notice("[user]正给[animal]披上鞍饰毯……"), span_notice("我开始给[animal]披上鞍饰毯……"))
	if(!do_after(user, 5 SECONDS, TRUE, animal))
		return

	animal.ccaparison = src
	forceMove(animal)
	animal.update_icon()
	user.visible_message(span_notice("[user]给[animal]披上了鞍饰毯。"), span_notice("我给[animal]披上了鞍饰毯。"))

/obj/item/caparison/rmb_self(mob/user)
	attack_right(user)

/obj/item/caparison/attack_right(mob/user)
	if(!length(detail_types))
		return

	var/list/possible_detail_types = list("无" = null) + detail_types.Copy()
	if(length(symbol_types))
		possible_detail_types += list("纹章" = null)

	var/chosen_design = input(user, "选择一种图案。", "Caparison Design") as null|anything in possible_detail_types
	if(!chosen_design)
		return

	if(chosen_design == "纹章")
		var/chosen_symbol = input(user, "选择一种纹章。", "Caparison Design") as null|anything in symbol_types
		if(!chosen_symbol)
			return
		detail_state = symbol_types[chosen_symbol]
	else
		detail_state = detail_types[chosen_design]

	var/list/colors_to_pick = list()
	if(GLOB.lordprimary)
		colors_to_pick["城堡主色"] = GLOB.lordprimary
	if(GLOB.lordsecondary)
		colors_to_pick["城堡辅色"] = GLOB.lordsecondary
	var/list/color_map_list = GLOB.colorlist
	colors_to_pick += color_map_list.Copy()

	var/primary_color = input(user, "选择一种主色。", "Caparison Design") as null|anything in colors_to_pick
	if(!primary_color)
		return
	color = colors_to_pick[primary_color]

	if(chosen_design != "无")
		if(chosen_design != "纹章")
			var/secondary_color = input(user, "选择一种辅色。", "Caparison Design") as null|anything in colors_to_pick
			if(!secondary_color)
				return
			detail_color = colors_to_pick[secondary_color]
		else
			detail_color = COLOR_WHITE

//////////////////////
// SUBTYPES - SAIGA //
//////////////////////

/obj/item/caparison/psy
	name = "普赛顿鞍饰毯"
	desc = "一块用于装饰鞍具的布毯，上面饰有普赛顿十字。这一款适合赛加羚羊。"
	caparison_state = "psy_caparison"
	female_caparison_state = "psy_caparison-f"

/obj/item/caparison/astrata
	name = "阿斯特拉塔鞍饰毯"
	desc = "一块用于装饰鞍具的布毯，上面饰有阿斯特拉塔十字。这一款适合赛加羚羊。"
	caparison_state = "astra_caparison"
	female_caparison_state = "astra_caparison-f"

/obj/item/caparison/eora
	name = "伊欧拉鞍饰毯"
	desc = "一块用于装饰鞍具的布毯，上面饰有伊欧拉之心。这一款适合赛加羚羊。"
	caparison_state = "eora_caparison"
	female_caparison_state = "eora_caparison-f"

/obj/item/caparison/azure
	name = "蔚蓝鞍饰毯"
	desc = "一块用于装饰鞍具的布毯，采用公爵的纹章配色。这一款适合赛加羚羊。"
	caparison_state = "azure_caparison"
	female_caparison_state = "azure_caparison-f"

/obj/item/caparison/heartfelt
	name = "赤心鞍饰毯"
	desc = "一块用于装饰鞍具的布毯，采用赤心的纹章配色。这一款适合赛加羚羊。"
	caparison_state = "heartfelt_caparison"
	female_caparison_state = "heartfelt_caparison-f"

/////////////////////////
// SUBTYPES - FOGBEAST //
/////////////////////////

/obj/item/caparison/fogbeast
	name = "鞍饰毯"
	desc = "一块用于装饰鞍具的布毯。这一款适合雾兽。"
	caparison_icon = 'icons/roguetown/mob/monster/fogbeast.dmi'
	valid_animal_types = list(/mob/living/simple_animal/hostile/retaliate/rogue/fogbeast)
	color = COLOR_WHITE
	detail_types = list("四分格" = "quad")
	symbol_types = list("普赛顿十字" = "psycross", "阿斯特拉塔" = "astrata")

/obj/item/caparison/fogbeast/azure
	name = "蔚蓝鞍饰毯"
	desc = "一块用于装饰鞍具的布毯，采用公爵的纹章配色。这一款适合雾兽。"
	caparison_state = "azure_caparison"
	female_caparison_state = "azure_caparison"
