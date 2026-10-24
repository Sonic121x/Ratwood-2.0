#include "ethos/compatibility.dm"
#include "../code/modules/mob/living/carbon/human/species_display.dm"
#include "jobs/translation_display.dm"
/proc/get_hoard_category_display(category)
	var/static/list/display_names = list(
		"Supplies" = "补给品",
		"Medicaments" = "医疗用品",
		"Clothing" = "衣物",
		"Brigand" = "悍匪",
		"Sellsword" = "佣兵剑客",
		"Sawbones" = "锯骨郎中",
		"Knight" = "落魄骑士",
		"Hedge Knight" = "落魄骑士",
		"Mage" = "野法师",
		"Hedge Mage" = "野法师",
		"Knave" = "无赖",
		"Iconoclast" = "破像者",
		"Pioneer" = "拓荒工兵"
	)
	return display_names[category] || category
