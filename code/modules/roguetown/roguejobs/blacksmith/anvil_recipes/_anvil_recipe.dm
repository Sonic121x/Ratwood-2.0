/datum/anvil_recipe
	abstract_type = /datum/anvil_recipe
	var/name
	var/category = "杂项"
	var/list/additional_items = list()
	var/material_quality = 0 // Quality of the bar(s) used. Accumulated per added ingot.
	var/num_of_materials = 1 // Total number of materials used. Quality divided among them.
	var/skill_quality = 0 // Accumulated per hit based on calculations, will decide final result.
	var/appro_skill = /datum/skill/craft/blacksmithing
	var/atom/req_bar
	var/atom/req_blade
	var/using_blade = FALSE
	var/atom/movable/created_item
	var/createditem_num = 1 // How many units to make.
	var/craftdiff = 0
	var/needed_item
	var/needed_item_text
	var/quality_mod = 0
	var/progress
	var/max_progress = 100
	var/i_type
	var/bar_health = 100 // Current material bar health, reduced by failures. At 0 HP it is deleted.
	var/numberofhits = 0 // Increased every time you hit the bar, the more you have to hit the bar the less quality of the product.
	var/numberofbreakthroughs = 0 // How many good hits we got on the metal, advances recipes 50% faster, reduces number of hits total, and restores bar_health
	var/smith_skill_level = 0 // Highest skill level of any smith who landed a hit on this bar. Used to clamp final tier.
	var/skip_quality = FALSE
	var/min_input_quality = null
	var/datum/parent
	// Whether this recipe will be hidden from recipe books
	var/hides_from_books = FALSE
	var/req_trait = null
	var/rotations_required = 1

/datum/anvil_recipe/New(datum/P, using_blade = FALSE, ...)
	. = ..()

/datum/anvil_recipe/proc/track_input_quality(obj/item/I)
	if(!istype(I) || !I.has_item_quality)
		return
	if(isnull(min_input_quality) || I.item_quality < min_input_quality)
		min_input_quality = I.item_quality

/datum/anvil_recipe/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=new_recipe;size=500x810")

/datum/anvil_recipe/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	user << browse_rsc('html/book.png')
	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
		<body>
		  <div>
		    <h1>[icon2html(new created_item, user)][name]</h1>
			<h4>描述： [initial(created_item.desc)]</h4>
			<div>
		"}
	var/obj/item/clothing/suit/roguetown/armor/bookarmor = initial(new created_item)
	var/obj/item/rogueweapon/bookweapon = initial(created_item)

	if(!(bookarmor.armor == "")&&!isnull(bookarmor.armor) )
		var/obj/item/clothing/C = initial(new created_item)
		if(C.body_parts_covered)
			html += "\n<b>覆盖部位： </b>"
			html += " | "
			for(var/zone in body_parts_covered2organ_names(C.body_parts_covered))
				html += "<b>[capitalize(zone)]</b> | "
		html += "耐久： [bookarmor.max_integrity]<br>"
		if(bookarmor.armor_class == ARMOR_CLASS_HEAVY)
			html += "<b>护甲等级： </b>重甲<br>"
		if(bookarmor.armor_class == ARMOR_CLASS_MEDIUM)
			html += "<b>护甲等级： </b>中甲<br>"
		if(bookarmor.armor_class == ARMOR_CLASS_LIGHT)
			html += "<b>护甲等级： </b>轻甲<br>"
	else if (!isnull(bookweapon) && bookweapon.force>1)
		html += "战斗属性<br>"
		if(bookweapon.minstr)
			html += "\n<b>最低力量：</b> [bookweapon.minstr]<br>"

		if(bookweapon.force)
			html += "\n<b>威力：</b> [bookweapon.force]<br>"
		if(bookweapon.gripped_intents && !bookweapon.wielded)
			if(bookweapon.force_wielded)
				html += "\n<b>双手威力：</b> [bookweapon.force_wielded]<br>"

		if(bookweapon.wbalance)
			html += "\n<b>平衡： </b>"
			if(bookweapon.wbalance == WBALANCE_HEAVY)
				html += "沉重<br>"
			if(bookweapon.wbalance == WBALANCE_SWIFT)
				html += "迅捷<br>"


		if(bookweapon.wlength != WLENGTH_NORMAL)
			html += "\n<b>长度：</b> "
			switch(bookweapon.wlength)
				if(WLENGTH_SHORT)
					html += "短<br>"
				if(WLENGTH_LONG)
					html += "长<br>"
				if(WLENGTH_GREAT)
					html += "巨型<br>"

		if(bookweapon.has_altgrip_modes())
			var/alt_grip_names = bookweapon.get_altgrip_names()
			html += "\n<b>握法：变换握法（手持时右键／快捷键）"
			if(alt_grip_names)
				html += ": [alt_grip_names]"
			html += "</b><br>"
		if(bookweapon.gripped_intents)
			html += "\n<b>双手：是</b><br>"

		var/shafttext = get_blade_dulling_text(bookweapon, verbose = TRUE)
		if(shafttext)
			html += "\n<b>杆柄：</b> [shafttext] <br>"

		if(bookweapon.twohands_required)
			html += "\n<b>笨重</b><br>"
		if(bookweapon.can_parry)
			html += "\n<b>防御：</b> [bookweapon.wdefense]<br>"
		if(bookweapon.associated_skill && bookweapon.associated_skill.name)
			html += "\n<b>技能：</b> [bookweapon.associated_skill.name]<br>"

		if(bookweapon.intdamage_factor != 1 && bookweapon.force >= 5)
			html += "\n<b>耐久伤害：</b> [bookweapon.intdamage_factor * 100]%<br>"


	if(craftdiff > 0)
		html += "<h1></h1>适用于 [SSskills.level_names_plain[craftdiff]] 级熟练度<br>"
	else
		html += "<h1></h1>适用于所有熟练度<br>"

	if(appro_skill == /datum/skill/craft/engineering) // SNOWFLAKE!!!
		html += "工程制造<br>"

	html += {"<div>
		      <strong>需求</strong>
			  <br>"}

	html += "[icon2html(new req_bar, user)] 先将 [initial(req_bar.name)] 放上铁砧。<br>"
	html += "锤打材料。<br>"
	for(var/atom/path as anything in additional_items)
		html += "[icon2html(new path, user)] 然后加入 [initial(path.name)]<br>"
		html += "锤打材料。<br>"

	html += {"
		</div>
		<div>
		"}

	if(createditem_num > 1)
		html += "<strong class=class='scroll'>最终得到</strong> <br> [createditem_num] [icon2html(new created_item, user)]  [initial(created_item.name)]<br>"
	else
		html += "<strong class=class='scroll'>最终得到</strong> <br> [icon2html(new created_item, user)]   [initial(created_item.name)]<br>"

	if(created_item.sellprice)
		html += "<strong class=class='scroll'>普通品质下可卖出 [created_item.sellprice] 玛门</strong> <br>"
	else
		html += "<strong class=class='scroll'>该物品无法用于出口</strong> <br>"

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html
