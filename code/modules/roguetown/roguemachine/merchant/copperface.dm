/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

// DESIGN NOTE
// The copperface exists [Somewhere when it is actually mapped in]
// Prices are steeper to not necessarily give the merchant in town competition.
// The intended customers are wretches, bandits and other outlaws.
// This provides especially wretches reasons to harrass adventurers and get vital items they usually can't out of town like lockpicks, red or prosthetics

/obj/structure/roguemachine/goldface/copperface
	name = "铜面"
	desc = "不知疲倦，不问缘由，只有些许被动过手脚的痕迹。唉，可惜是用劣质铜铸成的。"
	motto = "铜面 - 人人都有价。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "copperface"
	lockid = null // Not lockable
	locked = FALSE
	max_integrity = 0 // Screw you, gamer
	profit_id = null // No one can withdraw profit from copperface
	value_record_key = STATS_COPPERFACE_VALUE_SPENT
	categories = list(
		"外交与说服", // English: Diplomacy and Persuasion
		"饮品", // English: Beverages
		"异域进口品", // English: Exotic Import
		"杂务用品", // English: General Labour
		"健康与卫生", // English: Health and Hygiene
		"自卫用品", // English: Self Defense
	)
	categories_gamer = list()
	bypass_tax = TRUE
	extra_fee = 0.5 // 50% extra fee.
