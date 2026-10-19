/datum/food_recipe/sandwich
	abstract_type = /datum/food_recipe/sandwich
	book_category = FOOD_CAT_SANDWICH

// Hardtack + Chocolate -> Half Cookie (Chocolate)
/datum/food_recipe/baked/half_cookie_chocolate
	name = "巧克力曲奇面团"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/chocolate/slice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookie_raw

// Hardtack + Raisins -> Half Cookie (Raisin)
/datum/food_recipe/baked/half_cookie_raisin
	name = "葡萄干曲奇面团"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisins
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookier_raw

// Hardtack + Caramel -> Half Cookie (Caramel)
/datum/food_recipe/baked/half_cookie_caramel
	name = "焦糖曲奇面团"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/caramel
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookiec_raw

// Hardtack + Dragée -> Half Cookie (Dragée)
/datum/food_recipe/baked/half_cookie_dragee
	name = "糖丸曲奇面团"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/dragee
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/halfcookied_raw

// Bread Slice + Salami -> Salumoi Sandwich
/datum/food_recipe/sandwich/salami
	name = "烟熏香肠面包"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami/slice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sandwich/salami

// Bread Slice + Cheese Slice -> Cheese Bread
/datum/food_recipe/sandwich/cheese
	name = "奶酪面包"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheddarslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sandwich/cheese

// Bread Slice + Salo -> Salo Bread
/datum/food_recipe/sandwich/salo
	name = "盐腌肥膘面包"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/fat/salo/slice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sandwich/salo

// Bread Slice + Bacon -> Bacon Bread
/datum/food_recipe/sandwich/bacon
	name = "培根面包"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sandwich/bacon

// Toast + Butter -> Buttered Toast
/datum/food_recipe/sandwich/buttered_toast
	name = "黄油吐司"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/butterslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast/buttered

// Toast + Fried Egg -> Egg Toast
/datum/food_recipe/sandwich/egg_toast
	name = "鸡蛋吐司"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sandwich/egg

// Toast + Jamtallow Slice -> Jamtallowed Toast
/datum/food_recipe/sandwich/jamtallowed_toast
	name = "黑莓果酱吐司"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/jamtallowslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast/jamtallowed_slice

// Toast + Marmalade Slice -> Marmaladed Toast
/datum/food_recipe/sandwich/marmaladed_toast
	name = "橘子酱吐司"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/marmaladeslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast/marmaladed_slice

// Toast + Ham -> Ham Bread
/datum/food_recipe/sandwich/ham
	name = "火腿面包"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/ham/sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/sandwich/ham

// Bun + Sausage -> Grenzelbun (Hotdog)
/datum/food_recipe/sandwich/grenzelbun
	name = "格伦泽尔面包肠"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/bun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/bun_grenz

// Bun + Cheese Wedge -> Raston
/datum/food_recipe/sandwich/raston
	name = "奶酪夹心面包"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/bun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/bun_raston

// Bun + Jamtallow Slice -> Jamtallowed Bun
/datum/food_recipe/sandwich/jamtallowed_bun
	name = "黑莓果酱面包"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/bun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/jamtallowslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/bun_jamtallow

// Bun + Marmalade Slice -> Marmaladed Bun
/datum/food_recipe/sandwich/marmaladed_bun
	name = "橘子酱面包"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/bun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/marmaladeslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/bun_marmalade

// Crossbun + Jamtallow -> Jamtallowed Crossbun
/datum/food_recipe/sandwich/jamtallowed_crossbun
	name = "黑莓果酱十字面包"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/crossbun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/jamtallowslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/crossbun_jamtallowed

// Crossbun + Marmalade -> Marmaladed Crossbun
/datum/food_recipe/sandwich/marmaladed_crossbun
	name = "橘子酱十字面包"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/crossbun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/marmaladeslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/crossbun_marmaladed

// Psycrossbun + Jamtallow -> Jamtallowed Psycrossbun
/datum/food_recipe/sandwich/jamtallowed_psycrossbun
	name = "黑莓果酱普赛圣十字面包"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/psycrossbun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/jamtallowslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/psycrossbun_jamtallowed

// Psycrossbun + Marmalade -> Marmaladed Psycrossbun
/datum/food_recipe/sandwich/marmaladed_psycrossbun
	name = "橘子酱普赛圣十字面包"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/psycrossbun
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/marmaladeslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/psycrossbun_marmaladed

// Half Raisin Dough + Raisins -> Raw Raisin Loaf
/datum/food_recipe/baked/raisin_bread_complete
	name = "葡萄干面团"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/rbread_half
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisins
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/rbreaduncooked

// Half Apple Dough + Apple Slices -> Raw Apple Loaf
/datum/food_recipe/baked/apple_bread_complete
	name = "苹果面团"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/abread_half
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/abreaduncooked
