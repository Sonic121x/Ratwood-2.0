// ============================================================================
// 赛加奶酒酿造配方 (Kumis) —— 允许玩家用奶和盐在发酵桶中酿出奶酒。
// ----------------------------------------------------------------------------
// 现有内容：/datum/reagent/consumable/ethanol/saigamilk、商队成品瓶与预装酒桶都已存在，
//   但缺少玩家可用的酿造配方。这里补充 /datum/brewing_recipe/saigamilk。
// 发酵桶通过 subtypesof(/datum/brewing_recipe) 自动发现本配方，无需额外注册。
// ============================================================================

/datum/brewing_recipe/saigamilk
	name = "赛加奶酒"
	category = "其他"
	reagent_to_brew = /datum/reagent/consumable/ethanol/saigamilk
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/saigamilk
	bottle_name = "赛加奶酒"
	bottle_desc = "一瓶用赛加奶和盐酿成的奶酒。入口起泡、酸中带咸，是草原游牧民的常见饮品。"
	needed_reagents = list(/datum/reagent/consumable/milk = 128)
	needed_items = list(/obj/item/reagent_containers/powder/salt = 2)
	brewed_amount = 6
	per_brew_amount = 50
	brew_time = 3 MINUTES
	sell_value = 50
	helpful_hints = "先向发酵桶中加入牛奶，再放入盐。"

// 用于交易与售卖区分的成品瓶类型。
/obj/item/reagent_containers/glass/bottle/brewing_bottle/saigamilk
