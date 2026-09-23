// Patronage writs - ported from Azure-Peak PR #7000 (economy port Step 16,
// AP source: code/modules/politics/items/patronage_writ.dm).
// Ratwood deviations:
//  - icon: AP's 'icons/roguetown/items/paper.dmi' ("paper_altprep") doesn't exist in ES;
//    uses ES's stock parchment art from misc.dmi instead.
//  - No CALENDAR_EPOCH_YEAR calendar system in ES; unsigned writs are undated.
//  - Faction labels follow this tree's conventions ("Ferentian Trading Company", "the Church").

/obj/item/patronage_writ
	name = "恩主令状"
	desc = "一份已签署的恩主令状。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "paper"
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	var/issuer_name
	var/issuer_year
	var/granted_trait
	var/faction_label = "某个未知势力"
	var/roster_cap = PATRON_CAP_MERCHANT

/obj/item/patronage_writ/proc/get_roster()
	return null

/obj/item/patronage_writ/proc/grants_residency()
	return FALSE

/obj/item/patronage_writ/proc/redemption_announcement(mob/living/carbon/human/user)
	return "[user.real_name]是[faction_label]的代理人。"

/obj/item/patronage_writ/examine(mob/user)
	. = ..()
	if(issuer_year)
		. += span_info("由[issuer_name || "不知名人士"]于[issuer_year]签署。手持使用即可成为[faction_label]的代理人。")
	else
		. += span_info("由[issuer_name || "不知名人士"]签署。手持使用即可成为[faction_label]的代理人。")

/obj/item/patronage_writ/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return ..()
	if(!granted_trait)
		to_chat(user, span_warning("这份授权书没有注明要授予哪位恩主的代理资格。"))
		return
	if(issuer_name && issuer_name == user.real_name)
		to_chat(user, span_warning("我不能任命自己为代理人 - 这份授权书必须交到他人手中。"))
		return
	if(HAS_TRAIT(user, granted_trait))
		to_chat(user, span_warning("我已在这份名册上。"))
		return
	var/list/roster = get_roster()
	if(isnull(roster))
		to_chat(user, span_warning("无法查阅名册。"))
		return
	prune_roster(roster)
	if(length(roster) >= roster_cap)
		to_chat(user, span_warning("[faction_label]的名额已满。"))
		return
	ADD_TRAIT(user, granted_trait, TRAIT_GENERIC)
	if(grants_residency())
		ADD_TRAIT(user, TRAIT_RESIDENT, "patronage_[granted_trait]")
	roster += user
	user.visible_message(span_notice("[user]在名册上签了名。"), \
		span_notice("我是[faction_label]的代理人了。"))
	playsound(get_turf(user), 'sound/misc/gold_license.ogg', 60, FALSE, -1)
	log_admin("PATRONAGE GRANTED: [key_name(user)] enrolled as [granted_trait].")
	qdel(src)

/obj/item/patronage_writ/proc/prune_roster(list/roster)
	for(var/mob/living/carbon/human/H in roster.Copy())
		if(QDELETED(H) || !HAS_TRAIT(H, granted_trait))
			roster -= H

/obj/item/patronage_writ/charter
	name = "特许状"
	desc = "一份费伦提亚贸易公司的授权书。接受它即可成为特许代理人。"
	granted_trait = TRAIT_AGENT_MERCHANT
	faction_label = "费伦提亚贸易公司"

/obj/item/patronage_writ/charter/get_roster()
	return SStreasury?.merchant_agents

/obj/item/patronage_writ/charter/grants_residency()
	return TRUE

/obj/item/patronage_writ/token
	name = "澡堂信物"
	desc = "一件加盖印章的澡堂信物。接受它即可成为代理人。"
	granted_trait = TRAIT_AGENT_BATHHOUSE
	faction_label = "澡堂"

/obj/item/patronage_writ/token/get_roster()
	return SStreasury?.bathhouse_agents

/obj/item/patronage_writ/benefactor
	name = "恩主授衔信"
	desc = "一封加盖教会印章的信函，授予持有人恩主身份。"
	granted_trait = TRAIT_AGENT_CHURCH
	faction_label = "教会"
	roster_cap = PATRON_CAP_CHURCH

/obj/item/patronage_writ/benefactor/get_roster()
	return SStreasury?.church_agents
