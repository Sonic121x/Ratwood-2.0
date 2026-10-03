/datum/language/codespeak
	name = "Codespeak"
	desc = ""
	key = "14"
	default_priority = 0
	flags = TONGUELESS_SPEECH
	icon_state = "codespeak"

/datum/language/codespeak/scramble(input)
	var/lookup = check_cache(input)
	if(lookup)
		return lookup

	. = ""
	var/list/words = list()
	while(length(.) < length(input))
		words += generate_code_phrase(return_list=TRUE)
		. = jointext(words, ", ")

	. = capitalize(.)

	var/input_ending = copytext(input, length(input))

	var/static/list/endings
	if(!endings)
		endings = list("!", "?", ".")

	if(input_ending in endings)
		. += input_ending

	add_to_cache(input, .)

/obj/item/codespeak_manual
	name = "codespeak manual"
	desc = ""
	icon = 'icons/obj/library.dmi'
	icon_state = "book2"
	var/charges = 1

/obj/item/codespeak_manual/attack_self(mob/living/user)
	if(!isliving(user))
		return

	if(user.has_language(/datum/language/codespeak))
		to_chat(user, span_boldwarning("我开始翻阅[src]，但我已经懂得暗语了。"))
		return

	to_chat(user, span_boldannounce("我开始翻阅[src]，暗号与应答忽然涌入我的脑海。"))
	user.grant_language(/datum/language/codespeak)

	use_charge(user)

/obj/item/codespeak_manual/attack(mob/living/M, mob/living/user)
	if(!istype(M) || !istype(user))
		return
	if(M == user)
		attack_self(user)
		return

	playsound(loc, "punch", 25, TRUE, -1)

	if(M.stat == DEAD)
		M.visible_message(span_danger("[user]用[src]拍打[M]毫无生气的尸体。"), span_danger("[user]用[src]拍打我毫无生气的尸体。"), span_hear("我听到拍打声。"))
	else if(M.has_language(/datum/language/codespeak))
		M.visible_message(span_danger("[user]用[src]敲打[M]的脑袋！"), span_danger("[user]用[src]敲打我的脑袋！"), span_hear("我听到拍打声。"))
	else
		M.visible_message(span_notice("[user]用[src]敲打[M]的脑袋，传授暗语！"), span_boldnotice("[user]用[src]敲打我时，暗号与应答涌入我的脑海。"), span_hear("我听到拍打声。"))
		M.grant_language(/datum/language/codespeak)
		use_charge(user)

/obj/item/codespeak_manual/proc/use_charge(mob/user)
	charges--
	if(!charges)
		var/turf/T = get_turf(src)
		T.visible_message(span_warning("[src]的封面与内容开始变换！"))

		qdel(src)
		var/obj/item/book/manual/random/book = new(T)
		user.put_in_active_hand(book)

/obj/item/codespeak_manual/unlimited
	name = "deluxe codespeak manual"
	charges = INFINITY
