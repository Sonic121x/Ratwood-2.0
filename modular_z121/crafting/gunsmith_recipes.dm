// 普通配方默认不限制特质，枪匠配方及其后续子类共用此权限接口。
/datum/artificer_recipe
	var/z121_required_trait

/datum/artificer_recipe/proc/z121_can_craft(mob/user, feedback = FALSE)
	if(!z121_required_trait)
		return TRUE
	if(user && HAS_TRAIT(user, z121_required_trait))
		return TRUE
	if(user && feedback)
		to_chat(user, span_warning("你缺少[z121_required_trait]特质，无法制作这件物品。"))
	return FALSE

// 此基类只定义制造权限；技能、成本和分类由具体枪械配方自行指定。
/datum/artificer_recipe/z121_gunsmith
	z121_required_trait = TRAIT_Z121_GUNSMITH
