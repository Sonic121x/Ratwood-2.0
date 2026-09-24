/datum/z121_world_modulation
	var/spell_query = ""
	var/spell_filter = "all"
	var/spell_page = 1
	var/spell_owned_only = FALSE

/datum/z121_world_modulation/proc/owned_spells(mob/user)
	var/list/result = list()
	if(user.mind)
		result |= user.mind.spell_list
	result |= user.mob_spell_list
	return result

/datum/z121_world_modulation/proc/spell_data(mob/user)
	var/list/owned = owned_spells(user)
	var/list/rows = list()
	var/list/known = list()
	for(var/obj/effect/proc_holder/spell/S as anything in owned)
		if(QDELETED(S))
			continue
		known[S.type] = TRUE
		if(spell_owned_only)
			rows += list(list("id" = REF(S), "name" = S.name, "description" = S.desc, "path" = "[S.type]", "miracle" = S.miracle, "owned" = TRUE))
	if(!spell_owned_only)
		for(var/obj/effect/proc_holder/spell/path as anything in z121_world_spell_presets())
			rows += list(list("id" = "[path]", "path" = "[path]", "name" = initial(path.name), "description" = initial(path.desc), "miracle" = initial(path.miracle), "owned" = !!known[path]))
	var/list/matches = list()
	for(var/list/row as anything in rows)
		if((spell_filter == "miracles" && !row["miracle"]) || (spell_filter == "spells" && row["miracle"]))
			continue
		if(length(spell_query) && !findtext("[row["name"]] [row["description"]] [row["path"]]", spell_query))
			continue
		row["description"] = html_decode(GLOB.html_tags.Replace(row["description"] || "", ""))
		matches += list(row)
	var/pages = max(1, CEILING(length(matches) / 24, 1))
	spell_page = clamp(spell_page, 1, pages)
	var/list/page_rows = list()
	for(var/index = 1 + (spell_page - 1) * 24; index <= min(spell_page * 24, length(matches)); index++)
		page_rows += list(matches[index])
	return list("rows" = page_rows, "page" = spell_page, "pages" = pages, "total" = length(matches), "has_mind" = !!user.mind)

/datum/z121_world_modulation/proc/change_spell(mob/living/user, action, id)
	if(!istext(id))
		return
	var/list/owned = owned_spells(user)
	if(action == "add_spell")
		if(!user.mind)
			notice = "当前角色没有心智，不能添加法术。"
			return
		var/path = text2path(id)
		if(!(path in z121_world_spell_presets()))
			return
		for(var/obj/effect/proc_holder/spell/S as anything in owned)
			if(S.type == path)
				notice = "已经拥有此法术。"
				return
		var/obj/effect/proc_holder/spell/added = new path
		// 免费授予不应通过学习界面的退款入口生成法术点。
		added.refundable = FALSE
		user.mind.AddSpell(added, user)
		notice = "已添加：[added.name]。"
		audit("[notice] [path]")
		return
	// 只接受当前角色实际拥有的实例引用，不允许按客户端路径批量删法术。
	for(var/obj/effect/proc_holder/spell/S as anything in owned)
		if(REF(S) != id || QDELETED(S))
			continue
		var/spell_name = S.name
		var/spell_path = S.type
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.devotion?.granted_spells -= S
			var/datum/z121_profession_record/P = H.z121_profession
			if(P)
				var/datum/weakref/key = WEAKREF(S)
				P.spells -= key
				P.detached_spells -= key
				P.bard_spells -= key
				P.owned_devotion?.granted_spells -= S
				P.shared_devotion?.granted_spells -= S
		user.mind?.spell_list -= S
		user.mob_spell_list -= S
		qdel(S)
		notice = "已移除：[spell_name]。"
		audit("[notice] [spell_path]")
		return
