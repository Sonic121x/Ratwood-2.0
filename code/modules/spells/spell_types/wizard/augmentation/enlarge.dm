/datum/action/cooldown/spell/augment_buff/enlarge
	name = "巨化术"
	desc = "暂时将目标变成魁梧巨大的形态，使其能撞破门扉。对本就巨大的族人无效。只能用于结社同伴。"
	fluff_desc = "尽管实战价值有限，变巨术却出奇受欢迎。根据格伦泽霍夫天穹战争学院的一项学生调查，超过七成男性法师即使当天没有准备此法术，也能飞快背出咒文。"
	button_icon_state = "enlarge"

	invocations = list("膨胀壮大吧！")
	invocation_type = INVOCATION_SHOUT
	cooldown_time = 2 MINUTES

	point_cost = 1

/datum/action/cooldown/spell/augment_buff/enlarge/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("那不是有效目标！"))
		return FALSE

	var/mob/living/carbon/target = cast_on
	if(target != H && !shares_fellowship(H, target))
		to_chat(H, span_warning("[target]不是我的结社同伴！"))
		return FALSE

	if(HAS_TRAIT(target, TRAIT_BIGGUY))
		to_chat(H, span_warning("对方已经太大，无法继续变巨！"))
		return FALSE

	ADD_TRAIT(target, TRAIT_BIGGUY, MAGIC_TRAIT)
	target.transform = target.transform.Scale(1.25, 1.25)
	target.transform = target.transform.Translate(0, (0.25 * 16))
	target.update_transform()
	to_chat(target, span_warning("我感觉自己比平时高大得多，简直能直接撞穿一扇门！"))
	target.visible_message("[target]的身体膨胀变大了！")
	addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = 60 SECONDS)
	return TRUE

/datum/action/cooldown/spell/augment_buff/enlarge/proc/remove_buff(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_BIGGUY, MAGIC_TRAIT)
	target.transform = target.transform.Translate(0, -(0.25 * 16))
	target.transform = target.transform.Scale(1/1.25, 1/1.25)
	target.update_transform()
	to_chat(target, span_warning("我突然感觉自己缩小了。"))
	target.visible_message("[target]的身体迅速缩小了！")
