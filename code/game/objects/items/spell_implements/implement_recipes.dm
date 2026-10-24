// Staff recipes - arcana crafting, multiple gems map to same tier
/datum/crafting_recipe/roguetown/arcana/staff
	abstract_type = /datum/crafting_recipe/roguetown/arcana/staff

/datum/crafting_recipe/roguetown/arcana/staff/lesser_toper
	name = "次级法杖（托珀石）"
	result = /obj/item/rogueweapon/woodstaff/implement
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/yellow = 1)

/datum/crafting_recipe/roguetown/arcana/staff/lesser_amethyst
	name = "次级法杖（紫水晶）"
	result = /obj/item/rogueweapon/woodstaff/implement/amethyst
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/amethyst = 1)

/datum/crafting_recipe/roguetown/arcana/staff/greater_emerald
	name = "高等法杖（翠晶）"
	result = /obj/item/rogueweapon/woodstaff/implement/greater
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/green = 1)

/datum/crafting_recipe/roguetown/arcana/staff/greater_sapphire
	name = "高等法杖（蓝晶）"
	result = /obj/item/rogueweapon/woodstaff/implement/greater/sapphire
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/violet = 1)

/datum/crafting_recipe/roguetown/arcana/staff/greater_quartz
	name = "高等法杖（石英）"
	result = /obj/item/rogueweapon/woodstaff/implement/greater/quartz
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/blue = 1)

/datum/crafting_recipe/roguetown/arcana/staff/greater_ruby
	name = "高等法杖（隆兹石）"
	result = /obj/item/rogueweapon/woodstaff/implement/greater/ruby
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/ruby = 1)

/datum/crafting_recipe/roguetown/arcana/staff/grand_diamond
	name = "大师法杖（多佩尔石）"
	result = /obj/item/rogueweapon/woodstaff/implement/grand
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/diamond = 1)

/datum/crafting_recipe/roguetown/arcana/staff/grand_riddle
	name = "大师法杖（钢之谜）"
	result = /obj/item/rogueweapon/woodstaff/implement/grand/riddle
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/riddleofsteel = 1)

// Tome recipes - arcana crafting, small log + gem
/datum/crafting_recipe/roguetown/arcana/tome
	abstract_type = /datum/crafting_recipe/roguetown/arcana/tome

/datum/crafting_recipe/roguetown/arcana/tome/lesser_toper
	name = "次级法典（托珀石）"
	result = /obj/item/rogueweapon/spellbook
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/yellow = 1)

/datum/crafting_recipe/roguetown/arcana/tome/lesser_amethyst
	name = "次级法典（紫水晶）"
	result = /obj/item/rogueweapon/spellbook
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/amethyst = 1)

/datum/crafting_recipe/roguetown/arcana/tome/greater_emerald
	name = "高等法典（翠晶）"
	result = /obj/item/rogueweapon/spellbook/greater
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/green = 1)

/datum/crafting_recipe/roguetown/arcana/tome/greater_sapphire
	name = "高等法典（蓝晶）"
	result = /obj/item/rogueweapon/spellbook/greater
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/violet = 1)

/datum/crafting_recipe/roguetown/arcana/tome/greater_quartz
	name = "高等法典（石英）"
	result = /obj/item/rogueweapon/spellbook/greater
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/blue = 1)

/datum/crafting_recipe/roguetown/arcana/tome/greater_ruby
	name = "高等法典（隆兹石）"
	result = /obj/item/rogueweapon/spellbook/greater
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/ruby = 1)

/datum/crafting_recipe/roguetown/arcana/tome/grand_diamond
	name = "大师法典（多佩尔石）"
	result = /obj/item/rogueweapon/spellbook/grand
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/roguegem/diamond = 1)

/datum/crafting_recipe/roguetown/arcana/tome/grand_riddle
	name = "大师法典（钢之谜）"
	result = /obj/item/rogueweapon/spellbook/grand
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/riddleofsteel = 1)

// Blacksteel staff upgrade - the alchemical frame reaches grand output from a cheaper gem
/datum/crafting_recipe/roguetown/arcana/blacksteel_upgrade
	name = "强化黑钢法杖（翠晶）"
	result = /obj/item/rogueweapon/woodstaff/implement/grand/blacksteel
	reqs = list(/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel = 1,
				/obj/item/roguegem/green = 1)
