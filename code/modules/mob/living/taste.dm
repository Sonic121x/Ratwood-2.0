#define DEFAULT_TASTE_SENSITIVITY 15

/mob/living
	var/last_taste_time
	var/last_taste_text

/mob/living/proc/get_taste_sensitivity()
	return DEFAULT_TASTE_SENSITIVITY

/mob/living/carbon/get_taste_sensitivity()
	var/obj/item/organ/tongue/tongue = getorganslot(ORGAN_SLOT_TONGUE)
	if(istype(tongue) && !HAS_TRAIT(src, TRAIT_AGEUSIA))
		. = tongue.taste_sensitivity
	else
		. = 101 // can't taste anything without a tongue

// non destructively tastes a reagent container
/mob/living/proc/taste(datum/reagents/from)
	if(last_taste_time + 50 < world.time)
		var/taste_sensitivity = get_taste_sensitivity()
		var/text_output = from.generate_taste_message(taste_sensitivity)
		// We dont want to spam the same message over and over again at the
		// person. Give it a bit of a buffer.
		if(hallucination > 50 && prob(25))
			text_output = pick("蜘蛛","梦境","噩梦","未来","过去","胜利",\
			"失败","痛苦","极乐","复仇","毒药","时间","空间","死亡","生命","真相","谎言","正义","记忆",\
			"遗憾","自己的灵魂","苦难","音乐","噪音","鲜血","饥饿","美式生活")
		if(text_output != last_taste_text || last_taste_time + 100 < world.time)
			to_chat(src, span_info("我尝到了[text_output]。"))
			// "something indescribable" -> too many tastes, not enough flavor.

			last_taste_time = world.time
			last_taste_text = text_output

#undef DEFAULT_TASTE_SENSITIVITY
