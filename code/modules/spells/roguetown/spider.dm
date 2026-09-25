
/obj/effect/proc_holder/spell/targeted/spiderconjur
	name = "结网术"
	range = 8
	overlay_state = "null"
	releasedrain = 5
	recharge_time = 30
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/webspin.ogg'
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/targeted/spiderconjur/cast(list/targets,mob/user = usr)
	. = ..()
	if(isopenturf(user.loc))
		var/turf/open/T = user.loc
		var/foundwall
		for(var/X in GLOB.cardinals)
			var/turf/TU = get_step(T, X)
			if(TU && isclosedturf(TU))
				foundwall = TRUE
				break
		if(foundwall)
			if(!locate(/obj/structure/spider/stickyweb) in T)
				new /obj/structure/spider/stickyweb(T)
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/self/spin_web
	antimagic_allowed = TRUE
	ignore_cockblock = TRUE
	sound = 'sound/misc/nutriment.ogg'
	overlay_icon = 'icons/mob/actions/roguespells.dmi'
	var/web_type = /obj/structure/spider/stickyweb/thin
	var/spin_time = 4 SECONDS
	var/stamina_cost = 30
	var/web_name = "薄蛛网"

/obj/effect/proc_holder/spell/self/spin_web/cast(mob/living/user)
	var/turf/web_turf = get_turf(user)
	if(!isopenturf(web_turf))
		return TRUE
	user.visible_message(span_notice("[user]开始织出一张[web_name]。"))
	if(!do_after(user, spin_time, target = user, progress = TRUE))
		revert_cast(user)
		return FALSE
	if(locate(/obj/structure/spider/stickyweb) in web_turf)
		return TRUE
	user.stamina_add(stamina_cost)
	new web_type(web_turf)
	return TRUE

/obj/effect/proc_holder/spell/self/spin_web/thin
	name = "织薄蛛网"
	desc = "在你所在的位置织出一张半透明的蛛网。"
	overlay_state = "webthin"
	recharge_time = 15 SECONDS

/obj/effect/proc_holder/spell/self/spin_web/dense
	name = "织密蛛网"
	desc = "在你所在的位置织出一张厚实、不透光的蛛网。"
	overlay_state = "webdense"
	recharge_time = 30 SECONDS
	web_type = /obj/structure/spider/stickyweb/thick
	spin_time = 8 SECONDS
	stamina_cost = 60
	web_name = "密蛛网"

/// Drow Merc mount summon spells, spider spells of a different kind.

/mob/living/carbon/human
	/// Kept separate from the Equestrian virtue's mount.
	var/datum/weakref/spiderborn_mount

/proc/is_spiderborn_mount_area(area/place)
	if(!place)
		return FALSE
	return place.outdoors \
		|| istype(place, /area/rogue/under/underdark) \
		|| istype(place, /area/rogue/under/underdarker)

/obj/effect/proc_holder/spell/self/call_spider_mount
	name = "召唤蛛骑"
	desc = "将你备好鞍具的蛛骑同伴召唤到身边。可在户外或幽暗地域使用。"
	school = "transmutation"
	overlay_state = "book1"
	chargedrain = 0
	chargetime = 0

/obj/effect/proc_holder/spell/self/call_spider_mount/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user) || !HAS_TRAIT(user, TRAIT_SPIDERBORN))
		revert_cast(user)
		return FALSE

	if(user.spiderborn_mount)
		to_chat(user, span_warning("我已经召唤过我心爱的小家伙了。"))
		revert_cast(user)
		return FALSE

	if(!isturf(user.loc) || !is_spiderborn_mount_area(get_area(user)))
		to_chat(user, span_warning("我必须身处户外或幽暗地域，才能召唤我的蛛骑。"))
		revert_cast(user)
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/rogue/drider/spider = new /mob/living/simple_animal/hostile/retaliate/rogue/drider/tame/saddled(get_turf(user))
	spider.owner = user
	user.spiderborn_mount = WEAKREF(spider)

	user.AddSpell(new /obj/effect/proc_holder/spell/self/saddleborn/sendaway/spiderborn)
	user.AddSpell(new /obj/effect/proc_holder/spell/self/saddleborn/whistle/spiderborn)

	user.visible_message(
		span_notice("[user]尖啸一声，[spider]便窸窣爬到了他身侧。"),
		span_notice("我一声尖啸唤来蛛骑，它便窸窣爬到我身侧。")
	)
	playsound(user, 'sound/magic/saddleborn-call.ogg', 150, FALSE, 5)

	if(!user.buckled)
		spider.buckle_mob(user, TRUE)
		setup_saddleborn_mount_move_delay(user, spider)

	qdel(src)
	return TRUE

/obj/effect/proc_holder/spell/self/saddleborn/sendaway/spiderborn
	name = "蛛骑：遣返"
	desc = "在户外或幽暗地域时，将你的蛛骑遣走。"

/obj/effect/proc_holder/spell/self/saddleborn/sendaway/spiderborn/get_mount(mob/living/carbon/human/user)
	if(!ishuman(user) || !HAS_TRAIT(user, TRAIT_SPIDERBORN))
		return null
	return user.spiderborn_mount?.resolve()

/obj/effect/proc_holder/spell/self/saddleborn/whistle/spiderborn
	name = "蛛骑：召回"
	desc = "将你的蛛骑召到身边。与那些可怜的地表坐骑不同，高贵的蛛骑不为险恶地形或野兽之类的琐事所扰；它本身就是一方霸主。"

/obj/effect/proc_holder/spell/self/saddleborn/whistle/spiderborn/get_mount(mob/living/carbon/human/user)
	if(!ishuman(user) || !HAS_TRAIT(user, TRAIT_SPIDERBORN))
		return null
	return user.spiderborn_mount?.resolve()
