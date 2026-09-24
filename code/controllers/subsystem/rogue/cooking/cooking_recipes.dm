/datum/food_recipe
	abstract_type = /datum/food_recipe
	var/name = "通用配方"
	/// What item is used to start a recipe, e.g a piece of raw steak
	var/base_item = null
	/// Ingredients in order of completion
	var/list/ingredients = list()
	/// Resulting item
	var/result_type = null
	/// Whether or not this needs to be cooked
	var/needs_cooking = FALSE
	/// How long it takes to add items
	var/time_per_step = 2 SECONDS
	/// Experience per step per int
	var/experience_per_step = 0.5
	/// Economy bucket used by the pricing engine.
	var/display_category = ITEM_CAT_FOODSTUFF_FRESH
	/// Encyclopedia sidebar bucket. One of the FOOD_CAT_* defines.
	var/book_category = FOOD_CAT_COMBINATION

/datum/food_recipe/proc/generate_html(mob/user)
	var/html = "<h2>[name]</h2>"

	var/atom/base = base_item
	if(base)
		html += "<p><b>起始材料：</b> [icon2html(new base, user)] [initial(base.name)]</p>"

	if(length(ingredients))
		html += "<h3>然后依次加入：</h3><ul>"
		for(var/i in 1 to length(ingredients))
			var/entry = ingredients[i]
			if(ispath(entry, /datum/reagent))
				var/amt = ingredients[entry]
				var/datum/reagent/R = entry
				html += "<li>[amt] [UNIT_FORM_STRING(amt)]的[initial(R.name)]</li>"
			else
				var/atom/A = entry
				html += "<li>[icon2html(new A, user)] [initial(A.name)]</li>"
		html += "</ul>"

	var/atom/result = result_type
	if(result)
		html += "<p><b>产物：</b> [icon2html(new result, user)] [initial(result.name)]</p>"
		var/result_details = describe_food_result(result)
		if(result_details)
			html += result_details

	if(needs_cooking)
		html += "<p>组装完成后仍需加热：放入炉灶上的煎锅，或放进烤炉烘烤。</p>"

	html += "<p>未计入烹饪技能加成时，每步约需 [time_per_step / 10] 秒。</p>"

	if(SScooking?.recipe_index && result_type)
		var/list/follow_ups = SScooking.recipe_index[result_type]
		if(length(follow_ups))
			html += "<h3>可继续加工为：</h3><ul>"
			for(var/datum/food_recipe/F in follow_ups)
				html += "<li>[F.name]</li>"
			html += "</ul>"

	return html

/proc/describe_food_result(atom/result_path)
	if(!ispath(result_path, /obj/item/reagent_containers/food/snacks))
		return ""
	var/obj/item/reagent_containers/food/snacks/proto = new result_path()
	var/list/lines = list()

	switch(proto.faretype)
		if(FARE_IMPOVERISHED)
			lines += "品质：粗劣（饥不择食时才会吃）。"
		if(FARE_POOR)
			lines += "品质：简陋（穷人的饭食）。"
		if(FARE_NEUTRAL)
			lines += "品质：普通（尚可的饭食）。"
		if(FARE_FINE)
			lines += "品质：精致。"
		if(FARE_LAVISH)
			lines += "品质：奢华。"

	var/nutriment_total = 0
	var/list/declared_reagents = proto.list_reagents
	if(islist(declared_reagents))
		nutriment_total += declared_reagents[/datum/reagent/consumable/nutriment] || 0
	var/list/declared_bonus = proto.bonus_reagents
	if(islist(declared_bonus))
		nutriment_total += declared_bonus[/datum/reagent/consumable/nutriment] || 0
	if(nutriment_total > 0)
		lines += "营养：[nutrition_unit_label(nutriment_total)]（[nutriment_total] 单位）。"

	var/list/other_reagents = list()
	if(islist(declared_reagents))
		for(var/r_path in declared_reagents)
			if(r_path == /datum/reagent/consumable/nutriment)
				continue
			var/datum/reagent/R = r_path
			other_reagents += "[initial(R.name)] ([declared_reagents[r_path]]u)"
	if(length(other_reagents))
		lines += "还含有：[other_reagents.Join(", ")]。"

	var/buff_desc = describe_food_effect(proto.eat_effect)
	if(buff_desc)
		lines += "食用效果：[buff_desc]。"
	var/extra_desc = describe_food_effect(proto.extra_eat_effect)
	if(extra_desc)
		lines += "额外效果：[extra_desc]。"

	var/atom/slice_target = proto.slice_path
	if(slice_target)
		var/count = proto.slices_num || 1
		lines += "可切成 [count] 份[initial(slice_target.name)]。"

	qdel(proto)

	if(!length(lines))
		return ""
	return "<p>[lines.Join("<br>")]</p>"

/proc/describe_food_effect(effect_path)
	if(!ispath(effect_path, /datum/status_effect))
		return null
	var/datum/status_effect/S = effect_path
	var/label
	var/alert_path = initial(S.alert_type)
	if(ispath(alert_path, /atom))
		var/atom/A = alert_path
		label = initial(A.name)
	if(!label)
		label = initial(S.id) || "[effect_path]"

	var/list/parts = list("<b>[label]</b>")
	var/duration = initial(S.duration)
	if(duration && duration > 0)
		parts += "持续[duration_label(duration)]"
	return parts.Join(" ")

/proc/duration_label(deciseconds)
	var/seconds = deciseconds / 10
	if(seconds >= 60)
		var/minutes = round(seconds / 60)
		return "[minutes] minute[minutes == 1 ? "" : "s"]"
	return "[seconds] 秒"

/proc/nutrition_unit_label(amount)
	if(amount >= NUTRITION_FIVE_MEALS)
		return "五餐或更多"
	if(amount >= NUTRITION_THREE_AND_HALF_MEALS)
		return "三餐半"
	if(amount >= NUTRITION_TWO_AND_HALF_MEALS)
		return "两餐半"
	if(amount >= NUTRITION_TWO_MEALS)
		return "两餐"
	if(amount >= NUTRITION_MEAL_AND_HALF)
		return "一餐半"
	if(amount >= NUTRITION_MEAL_AND_QUARTER)
		return "一又四分之一餐"
	if(amount >= NUTRITION_FULL_MEAL)
		return "一整餐"
	if(amount >= NUTRITION_THREE_QUARTER_MEAL)
		return "四分之三餐"
	if(amount >= NUTRITION_HALF_MEAL)
		return "半餐"
	if(amount >= NUTRITION_QUARTER_MEAL)
		return "四分之一餐"
	return "一小口"

