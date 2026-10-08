// 独立食典沿用配方书外观，目录缓存由所有副本共享，阅读状态仍属于各本书。
/obj/item/recipe_book/z121_cookbook
	name = "庖厨食典"
	desc = "一本详述成品饮食、肉类来源与基础食材的庖厨参考书，按类别与品质编排。"
	icon_state = "book2_0"
	base_icon_state = "book2"
	can_spawn = TRUE
	var/static/datum/z121_cookbook_catalog/catalog

/obj/item/recipe_book/z121_cookbook/generate_categories()
	if(!catalog)
		catalog = new
	categories = list("全部") + catalog.sections

/obj/item/recipe_book/z121_cookbook/generate_html(mob/user)
	user << browse_rsc('html/book.png')
	var/html = {"
		<!DOCTYPE html>
		<html lang="zh-CN"><head>
		<meta charset="UTF-8"><meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>庖厨食典</title>
		<style>
			body { margin: 25px 40px; color: #3e2723; background: #dfcca5 url('book.png') no-repeat fixed; background-size: 100% 100%; font-family: 'Microsoft YaHei', SimSun, sans-serif; }
			h1 { text-align: center; margin: 0 0 12px; border-bottom: 2px solid #795438; padding-bottom: 10px; }
			.layout { display: flex; height: 650px; }
			.sidebar { width: 32%; padding: 10px 15px 10px 0; border-right: 1px solid #795438; overflow-y: auto; }
			.main { flex: 1; padding: 10px 0 10px 25px; overflow-y: auto; line-height: 1.7; }
			input, select { box-sizing: border-box; width: 100%; margin: 0 0 10px; padding: 8px; color: #3e2723; border: 1px solid #795438; background: #f5ead2; font: inherit; }
			.section h2 { font-size: 17px; margin: 16px 0 6px; }
			.entry { display: block; text-decoration: none; padding: 7px 4px; border-bottom: 1px dotted #a68a62; color: #3e2723; }
			.entry:hover, .selected { background: #d2b48c; }
			.quality { color: #6a4b32; font-size: 12px; }
			.method { margin-bottom: 18px; padding-bottom: 12px; border-bottom: 1px solid #b49871; }
			.method h3 { margin-bottom: 4px; }
			ul, ol { padding-left: 24px; }
			p { margin: 8px 0; }
		</style></head><body><h1>庖厨食典</h1><div class="layout"><div class="sidebar">
		<label for="category">栏目</label><select id="category" onchange="filterEntries()">
	"}
	for(var/category in categories)
		html += "<option value='[html_encode(category)]'[category == current_category ? " selected" : ""]>[html_encode(category)]</option>"
	html += "</select><label for='search'>搜索名称或材料</label><input id='search' type='text' maxlength='100' value='[html_encode(search_query)]' oninput='filterEntries()' onkeyup='filterEntries()' placeholder='输入食物、饮品或材料名称'>"
	for(var/category in catalog.sections)
		html += "<div class='section' data-category='[html_encode(category)]'><h2>[html_encode(category)]</h2>"
		for(var/datum/z121_cookbook_entry/entry in catalog.entries_by_section[category])
			// 搜索材料时使用纯文本，避免匹配到标签名称或隐藏的技术路径。
			html += "<a class='entry[entry == current_recipe ? " selected" : ""]' data-search='[entry.search_text]' href='byond://?src=\ref[src];action=view_entry&entry=[entry.id]' onclick='return openEntry(this)'>[entry.title]"
			if(entry.quality_text)
				html += " <span class='quality'>（[entry.quality_text]）</span>"
			html += "</a>"
		html += "</div>"
	html += "<p id='no-matches' style='display:none'>未找到匹配的条目。</p></div><div class='main'>"
	if(istype(current_recipe, /datum/z121_cookbook_entry) && (current_recipe in catalog.entries))
		var/datum/z121_cookbook_entry/entry = current_recipe
		html += "<h2>[entry.title]</h2><p>栏目：[entry.category]"
		if(entry.quality_text)
			html += "　品质：[entry.quality_text]"
		html += "</p>"
		html += entry.body_html
	else
		html += "<h2>从炉火到餐桌</h2><p>选择左侧栏目，查阅食物、饮品的制作方法，或了解肉类与基础食材的来源。可同时按栏目及名称、材料搜索。</p><p>成品栏目只列完成的饮食；配方中的材料名称可能包括待烹调的坯子。书中不另列半成品制作条目。</p><p>各类成品按品质由高到低编排。食物品质分为奢华、精致、普通、简陋、粗劣；汤品与饮品采用自身的品质等级。未定义品质的条目置于栏目末尾。</p><p>所列耗时为基础值，实际加工速度会受到技能影响。完成加热后及时取出，以免烧焦。</p>"
	html += {"
		</div></div><script>
		function filterEntries() {
			var category = document.getElementById('category').value;
			var query = document.getElementById('search').value.toLowerCase();
			var sections = document.getElementsByClassName('section');
			var total = 0;
			for (var i = 0; i < sections.length; i++) {
				var section = sections\[i\];
				var matchesCategory = category === '全部' || section.getAttribute('data-category') === category;
				var links = section.getElementsByClassName('entry');
				var count = 0;
				for (var j = 0; j < links.length; j++) {
					var link = links\[j\];
					var visible = matchesCategory && link.getAttribute('data-search').indexOf(query) !== -1;
					link.style.display = visible ? 'block' : 'none';
					if (visible) count++;
				}
				section.style.display = count ? 'block' : 'none';
				total += count;
			}
			document.getElementById('no-matches').style.display = total ? 'none' : 'block';
		}
		function openEntry(link) {
			window.location.href = link.href + '&category=' + encodeURIComponent(document.getElementById('category').value) + '&query=' + encodeURIComponent(document.getElementById('search').value);
			return false;
		}
		filterEntries();
		</script></body></html>
	"}
	return html

// 不调用父类的通用链接处理器，避免任意类型路径进入本书详情。
/obj/item/recipe_book/z121_cookbook/Topic(href, href_list)
	if(usr != current_reader || !usr?.canUseTopic(src, BE_CLOSE))
		return
	if(href_list["action"] != "view_entry")
		return
	var/index = text2num(href_list["entry"])
	if(!isnum(index) || index != round(index) || index < 1 || index > length(catalog.entries))
		return
	var/category = href_list["category"]
	if(category in categories)
		current_category = category
	search_query = copytext(href_list["query"] || "", 1, 101)
	current_recipe = catalog.entries[index]
	current_reader << browse(generate_html(current_reader), "window=recipe;size=1000x810")

// 新装备子类型在原厨师装备准备完毕后追加书籍，不替换其余随身物品。
/datum/outfit/job/roguetown/cook/basic/z121_cookbook

/datum/outfit/job/roguetown/cook/basic/z121_cookbook/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backpack_contents = backpack_contents ? backpack_contents.Copy() : list()
	backpack_contents[/obj/item/recipe_book/z121_cookbook] = 1

/datum/advclass/cook
	outfit = /datum/outfit/job/roguetown/cook/basic/z121_cookbook

/datum/supply_pack/rogue/luxury/z121_cookbook
	name = "庖厨食典"
	cost = 20
	static_cost = TRUE
	contains = list(/obj/item/recipe_book/z121_cookbook)
