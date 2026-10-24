/datum/action/cooldown/spell/readomen
	name = "解读征兆"
	desc = "解读世界秘密的法术。有征兆与宝珠两种模式。\n\
	征兆模式下，施法会模糊地解读地脉，判断当前哪个神系占据主导。\n\
	宝珠模式下，施法会召出智慧宝珠。\n\
	持宝珠点击，即可让它回答你心中最深的疑问。"
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	button_icon_state = "readomen"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("我欲知晓。") // I wonder why
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	charge_time = 1 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 1 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/current_mode = 1
	var/list/modes = list(
		list("name" = "解读征兆", "tag" = "征兆", "icon" = "readomen", "invocation" = "叩问苍穹！"),
		list("name" = "智慧宝珠", "tag" = "宝珠", "icon" = "readomen", "invocation" = "雷霆，击敌！"),
	)

	var/list/reign_messages = list(
		/datum/faith/divine = list(
			/datum/faith/divine = "地脉平静，等待着被塑造。",
			/datum/faith/inhumen = "地脉受到控制，仿佛潜能被压抑着。",
			/datum/faith/old_god = "地脉平平无奇，仍可施以更多控制。",
		),
		/datum/faith/inhumen = list(
			/datum/faith/inhumen = "地脉已准备好迎接变革，目睹它时，你的灵辉充满激动。",
			/datum/faith/divine = "地脉不稳定，有什么正在使其中的魔力波动。",
			/datum/faith/old_god = "地脉正在被汲取，有什么在操纵普赛顿。",
		),
		/datum/faith/old_god = list(
			/datum/faith/divine = "地脉暗淡，或许正在愈合。",
			/datum/faith/inhumen = "地脉之力遭到削弱，这是对奥术的侮辱。",
			/datum/faith/old_god = "地脉正如其应有的模样，平静而完美均衡。",
		)
	)

	var/obj/item/rogueweapon/conjured_orb = null

/datum/action/cooldown/spell/readomen/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/readomen/proc/apply_mode(index)
	var/list/mode = modes[index]
	name = mode["name"]
	button_icon_state = mode["icon"]
	invocations = list(mode["invocation"])
	build_all_button_icons()
	update_mode_maptext(mode["tag"])

/datum/action/cooldown/spell/readomen/toggle_alt_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	to_chat(user, span_notice("[name]：[modes[current_mode]["name"]]模式。"))
	return TRUE

/datum/action/cooldown/spell/readomen/proc/update_mode_maptext(tag)
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(tag)
		holder.maptext_x = 5
		holder.color = GLOW_COLOR_LIGHTNING

/datum/action/cooldown/spell/readomen/cast()
	. = ..()

	var/mob/living/carbon/human/H = owner
	if(current_mode == 1)
		cast_omen(H)
	else
		cast_orb(H)
	return TRUE

/datum/action/cooldown/spell/readomen/proc/cast_omen(mob/living/user)
	var/dominant_faith = GLOB.dominant_faith_tracker.dominant_faith
	user.visible_message(span_info("[user]的双眼短暂翻向脑后！"), span_info("你的双眼翻向脑后！"))
	if(!istype(user) || !user.patron || ispath(user.patron.associated_faith, /datum/faith/godless))
		to_chat(user, "<span class='warning'>不知为何，我无法清楚感知地脉。</span>")
		return FALSE
	if(ispath(dominant_faith, /datum/faith/old_god))
		to_chat(user, span_blue(replacetext(reign_messages[user.patron.associated_faith][dominant_faith], "$patron", get_god_name(user.patron))))
	else if(ispath(user.patron.associated_faith, dominant_faith))
		to_chat(user, span_boldgreen(replacetext(reign_messages[user.patron.associated_faith][dominant_faith], "$patron", get_god_name(user.patron))))
	else
		to_chat(user, span_warningbig(replacetext(reign_messages[user.patron.associated_faith][dominant_faith], "$patron", get_god_name(user.patron))))



/datum/action/cooldown/spell/readomen/proc/cast_orb(atom/cast_on)
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	if(src.conjured_orb)
		qdel(conjured_orb)
	var/obj/item/R = new /obj/item/orbofwisdom(user.drop_location())
	R.AddComponent(/datum/component/conjured_item, null, FALSE, user, src)
	user.put_in_hands(R)
	src.conjured_orb = R
	return TRUE

/obj/item/orbofwisdom
	name = "智慧宝珠"
	desc = "据说其中囚禁着因傲慢狂妄而获罪的巫师『全能者米尼斯特』的精魂。他的重罚是沦为一件简单工具，回答普赛顿所有魔导师提出的任何问题。（持宝珠点击即可解答疑问）"
	w_class = WEIGHT_CLASS_NORMAL
	force = 10
	icon = 'icons/roguetown/rav/obj/cult.dmi'
	color = "#72cbff"
	icon_state = "sphere0"
	item_state = "sphere0"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	possible_item_intents = list(/datum/intent/use)

/obj/item/orbofwisdom/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()

	var/turf/T = get_turf(src)
	var/list/florish_message = list("真是个绝妙的问题……", "唔……容我深思此问……", "呸，我的智慧竟浪费在这种问题上……", "好吧，我想我可以考虑一下……", "你知道我从前可是大宗师吗？", "我想念我的妻子……", "哼！容我沉思……呼——嗖呼——呼嗖——", "什么？非得让我思考这个？好吧……", "我的本领本该用于远胜这等浅薄问题的大事……唉……", "是，是，我会回答你的问题，蠢货……")
	var/list/arcyne_wisdom = list("答案是肯定的。", "也许？尚不确定。", "对——极——了。", "绝不，现在放开我。", "No.", "我太累了，待会儿再问。", "我本来早该成巫妖了，却得回答你这愚蠢的问——行，随你。", "或许该换位魔导师来问。", "不，你这怪人。", "或许。或许吧……")

	if(!HAS_TRAIT(user, TRAIT_ARCYNE))
		visible_message(span_warningbig("蠢货，你又不是巫师，法律并未要求我回答你的问题，立刻放开我。"))
		user.dropItemToGround(src)
		playsound(src, 'sound/combat/hits/onglass/glassbreak (2).ogg', 100)
		qdel(src)
		return
	else
		visible_message(span_say("[src]吼道：\"[pick(florish_message)]\""))
		sleep(rand(1 SECONDS, 5 SECONDS))
		visible_message(span_say("[src]答道：\"[pick(arcyne_wisdom)]\""))
		sleep(2 SECONDS)
		visible_message(span_say("[src]说道：\"现在，我得走了。还有别的巫师需要我的智慧。\""))
		sleep(1 SECONDS)
		playsound(src, 'sound/combat/tempo_loss.ogg', 100)
		visible_message(span_emote("[src]噗地化作一团烟雾消失。"))
		if(T)
			var/mutable_appearance/poof = mutable_appearance('icons/effects/effects.dmi', "mist", layer = 10)
			T.add_overlay(poof)
			addtimer(CALLBACK(T, TYPE_PROC_REF(/atom, cut_overlay), poof), 1 SECONDS)
		qdel(src)
		return
