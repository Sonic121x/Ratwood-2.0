// 主材料与追加的两枚同材质锭合计三枚；枪管只消耗主材料一枚。
/datum/artificer_recipe/z121_flintlock
	i_type = "连发燧枪零件"
	appro_skill = /datum/skill/craft/engineering
	hammers_per_item = 10
	skill_level = 2

/datum/artificer_recipe/z121_flintlock/receiver_iron
	name = "铁机匣（铁锭×3）"
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/z121_flintlock_part/receiver

/datum/artificer_recipe/z121_flintlock/receiver_steel
	name = "钢机匣（钢锭×3）"
	required_item = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/z121_flintlock_part/receiver/steel
	skill_level = 3

/datum/artificer_recipe/z121_flintlock/receiver_blacksteel
	name = "黑钢机匣（黑钢锭×3）"
	required_item = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/z121_flintlock_part/receiver/blacksteel
	skill_level = 4

/datum/artificer_recipe/z121_flintlock/barrel_iron
	name = "铁长枪管（铁锭×1）"
	required_item = /obj/item/ingot/iron
	created_item = /obj/item/z121_flintlock_part/barrel

/datum/artificer_recipe/z121_flintlock/barrel_steel
	name = "钢长枪管（钢锭×1）"
	required_item = /obj/item/ingot/steel
	created_item = /obj/item/z121_flintlock_part/barrel/steel
	skill_level = 3

/datum/artificer_recipe/z121_flintlock/barrel_blacksteel
	name = "黑钢长枪管（黑钢锭×1）"
	required_item = /obj/item/ingot/blacksteel
	created_item = /obj/item/z121_flintlock_part/barrel/blacksteel
	skill_level = 4
