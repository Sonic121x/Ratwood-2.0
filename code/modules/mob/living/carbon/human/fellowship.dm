/mob/living/carbon/human/verb/fellowship_verb()
	set name = "冒险团"
	set category = "IC"
	set desc = "管理你的冒险团。"
	var/datum/fellowship_ui/ui = new(src)
	ui.ui_interact(src)
