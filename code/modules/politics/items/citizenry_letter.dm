// Letter of Citizenry - ported from Azure-Peak #6849 (code/modules/politics/items/citizenry_letter.dm).
// Printed by the Nerve Master (steward.dm "printresidency"); claiming it grants TRAIT_RESIDENT,
// which places the bearer under the Golden Bull's protections and the Burgher poll category.
// Ratwood deviations: "Citizen of Azuria" -> "Citizen of the Vale"; AP's paper.dmi doesn't exist
// in ES, so this uses ES's stock parchment art from misc.dmi (same as patronage_writ.dm).

#define TRAIT_CITIZENRY_LETTER "citizenry_letter"

/obj/item/citizenry_letter
	name = "市民资格文书"
	desc = "一封来自神经主的密封文书，上面有宫廷总管的签名。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "paper"
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	var/issuer_name
	var/issuer_year

/obj/item/citizenry_letter/examine(mob/user)
	. = ..()
	var/signature = issuer_name || "神经主"
	var/year = issuer_year || CALENDAR_EPOCH_YEAR
	. += span_info("文书上写着：<i>\"凡阅此文书者皆应知悉：持有者一经接受本文书，即获登记为谷地公民，并晋为市民，享有《王田金玺诏书》赋予该身份的保障，同时承担相应义务。\"</i>")
	. += span_info("<i>签署于 [year] 年，签署人：[signature]。</i>")
	. += span_notice("将其拿在手中并点击鼠标左键，即可接受文书授予的权利。")

/obj/item/citizenry_letter/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return ..()
	if(HAS_TRAIT(user, TRAIT_RESIDENT))
		to_chat(user, span_warning("我已经是谷地公民了。"))
		return
	if(user.job == "Steward" || user.job == "Grand Duke")
		to_chat(user, span_warning("这封文书是给别人的，我必须交给对方。"))
		return
	user.visible_message(span_notice("[user]展开文书，接受了印玺授予的资格。"), \
		span_notice("我接受本文书授予的公民权与市民资格。"))
	ADD_TRAIT(user, TRAIT_RESIDENT, TRAIT_CITIZENRY_LETTER)
	playsound(get_turf(user), 'sound/misc/gold_license.ogg', 60, FALSE, -1)
	qdel(src)

#undef TRAIT_CITIZENRY_LETTER
