/proc/format_poison_log_details(mob/living/target, addition, object_text, combat_fields)
	var/detail = addition ? " [addition]" : ""
	if(istext(addition) && dd_hasprefix_case(addition, "with "))
		detail = "（使用试剂：[copytext(addition, 6)]）"
	var/health = istype(target) ? "（剩余生命值：[target.health]）" : ""
	return "[object_text][detail][combat_fields][health]"
