/datum/job/roguetown/councillor
	title = "Councillor"
	flag = COUNCILLOR
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_ages = ALL_AGES_LIST
	allowed_races = RACES_TOLERATED_UP
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_COUNCILLOR
	tutorial = "你也许是继承了这个位置，也许是拿钱买来的，又或者真是凭本事获任的, 真叫人不敢细想。不管怎样，你如今都是王权在政务上的助手与代理人。无论是协助总管、治安官、王冠本身，还是单纯享用城堡里的免费饭食，你每天的职责都可能不同。你或许只是阶梯最底下一阶，但这一阶依旧高踞于镇上其他所有人之上。"
	whitelist_req = FALSE
	outfit = /datum/outfit/job/roguetown/councillor
	advclass_cat_rolls = list(CTAG_COUNCILLOR = 2)

	give_bank_account = 40
	noble_income = 20
	min_pq = 1 //Probably a bad idea to have a complete newbie advising the monarch
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_noble.ogg'
	social_rank = SOCIAL_RANK_NOBLE
	job_traits = list(TRAIT_NOBLE, TRAIT_SEEPRICES_SHITTY)
	job_subclasses = list(
		/datum/advclass/councillor,
		/datum/advclass/councillor/huntmaster
	)

/datum/advclass/councillor
	name = "参议"
	tutorial = "你也许是继承了这个位置，也许是拿钱买来的，又或者真是凭本事获任的, 真叫人不敢细想。不管怎样，你如今都是王权在政务上的助手与代理人。无论是协助总管、治安官、王冠本身，还是单纯享用城堡里的免费饭食，你每天的职责都可能不同。你或许只是阶梯最底下一阶，但这一阶依旧高踞于镇上其他所有人之上。"
	outfit = /datum/outfit/job/roguetown/councillor/basic
	category_tags = list(CTAG_COUNCILLOR)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_STR = -1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
	)

/datum/advclass/councillor/huntmaster
	name = "御猎官"
	tutorial = "你为王室组织狩猎。你熟知森林与猎物，也知道如何让狩猎队全员生还。"
	outfit = /datum/outfit/job/roguetown/councillor/huntmaster
	category_tags = list(CTAG_COUNCILLOR)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 1,
		STATKEY_SPD = 1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/hunting = SKILL_LEVEL_MASTER,
	)
	traits_applied = list(TRAIT_MASTERFUL_HUNTER, TRAIT_SURVIVAL_EXPERT)

/datum/outfit/job/roguetown/councillor
	job_bitflag = BITFLAG_ROYALTY

/datum/outfit/job/roguetown/councillor/basic/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/councillor
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/storage/keyring/steward // If this turns out to be overbearing re:stewardry bump down to the clerk keyring instead.
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel
	cloak = /obj/item/clothing/cloak/stabard/surcoat/councillor
	backpack_contents = list()
	if(SSmapping.current_map.map_name == "Rockhill")
		armor = /obj/item/clothing/suit/roguetown/armor/leather/newkeep/councillor
		cloak = null
	if(SSmapping.current_map.map_name == "Desert Town")
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/councillor
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		cloak = null
	if(SSroguemachine.ministry_bureau) // No bureau mapped in, no ministries to be had.
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/petition_ministry, H)

/datum/outfit/job/roguetown/councillor/huntmaster/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/trou/beltpants
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backr = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/roguekey/manor
	beltr = /obj/item/quiver/arrows
	cloak = /obj/item/clothing/cloak/half/red
	backpack_contents = list(
		/obj/item/hunting_map/white_stag = 1,
		/obj/item/hunting_map/boars = 1,
		/obj/item/storage/keyring = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
	)
	if(SSmapping.current_map.map_name == "Desert Town")
		shoes = /obj/item/clothing/shoes/roguetown/shalal
		head = /obj/item/clothing/head/roguetown/tagelmust

// ===== MINISTRIES =====

GLOBAL_LIST_INIT(ministry_charters, list(
	"Guildmaster" = /datum/ministry/guild,
	"Bishop" = /datum/ministry/church,
	"Bathmaster" = /datum/ministry/night,
	"Inquisitor" = /datum/ministry/inquisition,
	"Court Magician" = /datum/ministry/mage,
	"Head Physician" = /datum/ministry/physician,
	"Innkeeper" = /datum/ministry/innkeeper,
	"Merchant" = /datum/ministry/merchant
))

/mob/living/carbon/human
	var/datum/ministry/ministry_active
	var/datum/ministry/ministry_partner
	var/datum/ministry/ministry_pending // Finalized by clicking on the bureau.
	var/ministry_spent // We already trained the skills. Lock to reforming this one only.

/datum/ministry
	var/name = "部务"
	var/display_title = "大臣"
	var/income_bonus = 20
	var/list/ministry_keys = list()
	var/list/archive_traits = list()
	var/list/archive_skills = list()
	var/ring_type
	var/mob/living/carbon/human/councillor
	var/mob/living/carbon/human/partner
	var/obj/item/clothing/ring/minister/ring
	var/obj/item/paper/scroll/ministry_writ/writ
	var/active = FALSE

/datum/ministry/Destroy()
	councillor = null
	partner = null
	ring = null
	writ = null
	return ..()

/datum/ministry/proc/archive_bonus(mob/living/carbon/human/H)
	return

// Duplicating some HERMES logic here for mailing the writ.
// If the HERMES can't take it, the writ lands on the fallback turf for the councillor to deliver.
// The calling proc already confirmed the ministry's partner exists.
/proc/post_to_ministry(obj/item/parcel, datum/ministry/ministry, notice, turf/fallback)
	var/mob/living/carbon/human/recipient = ministry.partner
	parcel.mailer = "[ministry.councillor.real_name], [ministry.display_title]"
	parcel.mailedto = recipient.real_name
	parcel.update_icon()
	var/obj/item/roguemachine/mastermail/master = SSroguemachine.hermailermaster
	if(!master)
		parcel.forceMove(fallback || get_turf(recipient))
		to_chat(ministry.councillor, span_warning("领地中没有邮务长，我得亲自递送这份委任状。"))
		return
	parcel.forceMove(master.loc)
	var/datum/component/storage/storage = master.GetComponent(/datum/component/storage)
	if(!storage?.handle_item_insertion(parcel, prevent_warning = TRUE))
		parcel.forceMove(fallback || get_turf(recipient))
		to_chat(ministry.councillor, span_warning("赫尔墨斯不知为何无法递送委任状。我得亲自把它交给[recipient.mind.assigned_role] [recipient.name]。"))
		return
	master.new_mail = TRUE
	master.update_icon()
	recipient.apply_status_effect(/datum/status_effect/ugotmail)
	recipient.playsound_local(recipient, 'sound/misc/mail.ogg', 100, FALSE, -1)
	if(notice)
		to_chat(recipient, span_notice(notice))

/proc/ministry_roster()
	var/obj/structure/roguemachine/ministry_bureau/bureau = SSroguemachine.ministry_bureau
	bureau.prune_ministries()
	var/list/lines = list()
	for(var/job_title in GLOB.ministry_charters)
		var/charter = GLOB.ministry_charters[job_title]
		var/datum/ministry/M = bureau.active_ministries[charter]
		if(M)
			lines += "[job_title]——由[M.councillor?.real_name || "一位大臣"]辅佐。"
			continue
		var/mob/living/carbon/human/holder
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.mind?.assigned_role == job_title && !QDELETED(H))
				holder = H
				break
		if(!holder)
			lines += "[job_title]——无人担任此职。"
		else if(holder.ministry_partner)
			lines += "[job_title]——已有任命人选。"
		else if(holder.stat == DEAD)
			lines += "[job_title]——已死，但尚未离去。"
		else
			lines += "[job_title]——可申请任职。"
	return lines

/datum/ministry/guild
	name = "工艺部"
	display_title = "工艺大臣"
	ministry_keys = list(/obj/item/roguekey/crafterguild)
	archive_traits = list(TRAIT_SEEPRICES, TRAIT_SMITHING_EXPERT)
	archive_skills = list(
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/smelting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE
	)
	ring_type = /obj/item/clothing/ring/minister/guild

/datum/ministry/church
	name = "教务部"
	display_title = "教务大臣"
	ministry_keys = list(/obj/item/roguekey/church, /obj/item/roguekey/graveyard)
	archive_traits = list(TRAIT_RITUALIST, TRAIT_VOTARY)
	archive_skills = list(/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE)
	ring_type = /obj/item/clothing/ring/minister/church

/datum/ministry/church/archive_bonus(mob/living/carbon/human/H)
	H.put_in_hands(new /obj/item/ritechalk(get_turf(H)))
	if(!H.patron || istype(H.patron, /datum/patron/godless))
		to_chat(H, span_warning("我竟然没有信仰，真奇怪。"))
		return
	if(H.devotion)
		H.devotion.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_2)
		to_chat(H, span_notice("档案加深了我对[H.patron.name]的虔诚。"))
		return
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_2)
	to_chat(H, span_notice("档案唤醒了我的信仰。我初次听见[H.patron.name]恩赐的低语。"))

/datum/ministry/night
	name = "夜务部"
	display_title = "夜务大臣"
	ministry_keys = list(/obj/item/roguekey/nightmaiden)
	archive_traits = list(TRAIT_CICERONE, TRAIT_GOODLOVER)
	archive_skills = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE
	)
	ring_type = /obj/item/clothing/ring/minister/night

/datum/ministry/inquisition
	name = "正信部"
	display_title = "正信大臣"
	ministry_keys = list(/obj/item/roguekey/inquisition)
	archive_traits = list(TRAIT_STEELHEARTED)
	archive_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT
	)
	ring_type = /obj/item/clothing/ring/minister/inquisition

/datum/ministry/inquisition/archive_bonus(mob/living/carbon/human/H)
	if(H.devotion)
		if(!istype(H.patron, /datum/patron/old_god))
			to_chat(H, span_warning("我已归属于比普赛顿更有生气的信条。我的靴中空空如也，格外显眼。"))
			return
		H.devotion.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
		to_chat(H, span_notice("档案再次印证了我的誓约。坚忍。"))
		return
	H.set_patron(/datum/patron/old_god)
	var/datum/devotion/C = new /datum/devotion(H, GLOB.patronlist[/datum/patron/old_god])
	C.grant_miracles(H, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
	to_chat(H, span_notice("档案深处蒙尘的笔记让我想起旧神的誓约。普赛顿必定仍活着！"))

/datum/ministry/mage
	name = "奥术部"
	display_title = "奥术大臣"
	ministry_keys = list(/obj/item/roguekey/tower)
	archive_traits = list(TRAIT_ALCHEMY_EXPERT)
	archive_skills = list(
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE
	)
	ring_type = /obj/item/clothing/ring/minister/mage

/datum/ministry/mage/archive_bonus(mob/living/carbon/human/H)
	if(!H.mind)
		return
	if(!H.mind.has_spell(/datum/action/cooldown/spell/touch/prestidigitation))
		H.mind.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation, H)
	to_chat(H, span_notice("档案向我传授前任大臣的奥术秘法。我感到潜藏的力量在涌动。"))

/datum/ministry/physician
	name = "医务部"
	display_title = "医务大臣"
	ministry_keys = list(/obj/item/roguekey/physician, /obj/item/roguekey/courtphysician)
	archive_traits = list(TRAIT_EMPATH, TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
	archive_skills = list(
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN
	)
	ring_type = /obj/item/clothing/ring/minister/physician

/datum/ministry/physician/archive_bonus(mob/living/carbon/human/H)
	H.put_in_hands(new /obj/item/storage/belt/rogue/surgery_bag/full/physician(get_turf(H)))
	to_chat(H, span_notice("前任大臣的外科工具包在档案深处积满灰尘。照着留下的笔记，我或许能派上用场。"))

/datum/ministry/innkeeper
	name = "民务部"
	display_title = "民务大臣"
	ministry_keys = list(/obj/item/roguekey/tavern)
	archive_traits = list(TRAIT_CICERONE, TRAIT_EMPATH, TRAIT_TAVERN_FIGHTER)
	archive_skills = list(/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN)
	ring_type = /obj/item/clothing/ring/minister/innkeeper

/datum/ministry/merchant
	name = "商贸部"
	display_title = "商贸大臣"
	income_bonus = 70 // Trade Ministry is the weakest so more income helps cope
	ministry_keys = list(/obj/item/roguekey/shop)
	archive_traits = list(TRAIT_SEEPRICES, TRAIT_CICERONE)
	archive_skills = list(/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN)
	ring_type = /obj/item/clothing/ring/minister/merchant

// ===== PETITION SPELL =====

/obj/effect/proc_holder/spell/self/petition_ministry
	name = "申请部职"
	desc = "向一位势力首领自荐，作为其在城堡中的代言人。附近无人时施放可查看哪些职位仍然空缺。"
	overlay_state = "recruit_titlegrant"
	antimagic_allowed = TRUE
	recharge_time = 100
	var/petition_range = 3

/obj/effect/proc_holder/spell/self/petition_ministry/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/councillor = user
	if(councillor.ministry_active)
		to_chat(councillor, span_warning("我已经担任公职。"))
		return
	if(councillor.ministry_pending)
		to_chat(councillor, span_notice("我的委任已经获准。去议事厅的事务台宣誓就任吧。"))
		return

	var/obj/structure/roguemachine/ministry_bureau/bureau = SSroguemachine.ministry_bureau
	bureau.prune_ministries()
	var/list/prospects = list()
	for(var/mob/living/carbon/human/head in (get_hearers_in_view(petition_range, councillor) - councillor))
		var/charter = GLOB.ministry_charters[head.mind?.assigned_role]
		if(!charter || head.stat == DEAD)
			continue
		if(councillor.ministry_spent && councillor.ministry_spent != charter)
			continue
		if(head.ministry_partner)
			continue
		if(bureau.active_ministries[charter])
			continue
		prospects[head.name] = head
	if(!length(prospects))
		if(councillor.ministry_spent)
			var/datum/ministry/spent = councillor.ministry_spent
			to_chat(councillor, span_warning("我只学过一种行当。只有新的[initial(spent.display_title)]任命人会接纳我。"))
		else
			to_chat(councillor, span_warning("这里没有能让我寻求支持的人。"))
		for(var/line in ministry_roster())
			to_chat(councillor, span_notice(line))
		return

	var/picked = input(councillor, "我要寻求谁的支持？", "[name]") as null|anything in prospects
	if(!picked)
		return
	var/mob/living/carbon/human/head = prospects[picked]
	if(QDELETED(head) || !(head in get_hearers_in_view(petition_range, councillor)))
		to_chat(councillor, span_warning("对方已经离开。"))
		return
	INVOKE_ASYNC(src, PROC_REF(propose), councillor, head)

/obj/effect/proc_holder/spell/self/petition_ministry/proc/propose(mob/living/carbon/human/councillor, mob/living/carbon/human/head)
	var/charter = GLOB.ministry_charters[head.mind?.assigned_role]
	if(!charter)
		return
	var/datum/ministry/charter_ref = charter
	councillor.say("[head.real_name]，请让我在城堡中代您发声。")
	var/answer = alert(head, "[councillor.real_name]申请担任我的[initial(charter_ref.display_title)]。对方将学到部分本行知识，并获得我所辖场所的一些钥匙。作为回报，我会得到一份可与其传话的委任状。", "部务", "拒绝", "接受")
	if(answer != "接受") //Default option is refusal
		to_chat(councillor, span_warning("[head.real_name]拒绝了我的申请。"))
		to_chat(head, span_notice("我拒绝这份申请。"))
		return
	if(QDELETED(councillor) || QDELETED(head) || councillor.stat == DEAD || head.stat == DEAD)
		return
	if(!(head in get_hearers_in_view(petition_range, councillor)))
		to_chat(councillor, span_warning("我现在离得太远了！"))
		to_chat(head, span_warning("事情还未谈妥，对方就走开了。"))
		return
	if(councillor.ministry_active || councillor.ministry_pending || head.ministry_partner)
		to_chat(head, span_warning("事情已有变化，这项安排已经失效。"))
		return
	if(councillor.ministry_spent && councillor.ministry_spent != charter)
		to_chat(head, span_warning("此人学的是另一种完全不同的行当。"))
		return
	if(SSroguemachine.ministry_bureau.active_ministries[charter])
		to_chat(head, span_warning("本部已经有大臣就任了。"))
		return

	var/datum/ministry/proto = new charter()
	councillor.ministry_pending = proto
	head.ministry_partner = proto
	proto.councillor = councillor
	proto.partner = head

	head.visible_message(span_notice("[head.real_name]将[councillor.real_name]纳为心腹。"))
	to_chat(head, span_notice("我接受这份申请。对方宣誓就任后，委任状会寄给我。"))
	to_chat(councillor, span_notice("[head.real_name]同意了。去议事厅的事务台宣誓就任吧。"))

// ===== WRIT OF MINISTRY =====

/obj/item/paper/scroll/ministry_writ
	name = "大臣委任状"
	desc = "一份盖印见证的委任文书。"
	icon_state = "contractsigned"
	open = TRUE
	textper = 150
	var/ministry_type
	var/open_name
	var/obj/item/clothing/ring/minister/paired_ring
	var/speech_cooldown = 0
	var/speech_cooldown_time = 10 SECONDS

/obj/item/paper/scroll/ministry_writ/Destroy()
	if(paired_ring)
		paired_ring.paired_writ = null
		paired_ring = null
	return ..()

/obj/item/paper/scroll/ministry_writ/proc/finalize(mob/living/carbon/human/minister, mob/living/carbon/human/partner, datum/ministry/M)
	ministry_type = M.type
	open_name = "[M.name]委任状"
	name = open_name
	desc = "任命[minister.real_name]担任[M.display_title]的文书。"
	var/datum/job/ruler = SSjob.GetJobType(/datum/job/roguetown/lord)
	var/ruler_title = ruler?.display_title || ruler?.title || "大公"
	info = "<font face=\"[FOUNTAIN_PEN_FONT]\" color=#14103f>"
	info += "<center><b>大臣委任状</b></center><hr/>"
	info += "兹告：[partner.real_name]，[partner.mind?.assigned_role || "本镇居民"]，\
			将[ruler_title]的参议[minister.real_name]纳为心腹，\
			授予其<b>[M.display_title]</b>的职务与特权。<br/><br/>"
	info += "该大臣应在议事厅中为本部发声。展开此委任状并对其说话，\
			无论对方身在何处，都能传达。<br/><br/>"
	info += "签署人：<br/>"
	info += "[minister.real_name]，[SSmapping.map_adjustment.realm_name]的[M.display_title]"
	info += "</font>"
	update_icon_state()

/obj/item/paper/scroll/ministry_writ/examine(mob/user)
	. = ..()
	if(paired_ring && open)
		. += span_notice("对着它说话，就能联系大臣。")

/obj/item/paper/scroll/ministry_writ/update_icon_state()
	if(mailer)
		return ..()
	if(!open)
		icon_state = "scroll_closed"
		name = "卷轴"
		return
	icon_state = "contractsigned"
	name = open_name || initial(name)

/obj/item/paper/scroll/ministry_writ/attack_self(mob/user)
	// Let the parent clear the mail wrapper first, otherwise read() stays blocked.
	if(mailer || !open || !paired_ring || !ishuman(user))
		return ..()
	var/mob/living/carbon/human/H = user
	if(!H.ministry_partner || H.ministry_partner.partner != H)
		return ..()
	if(!can_speak_ministry(H))
		return
	H.changeNext_move(CLICK_CD_INTENTCAP)
	visible_message(span_notice("[H]对着委任状低语。"))
	var/msg = input(H, "给我的大臣传话。", "大臣密语……") as null|text
	if(!msg)
		return
	if(!can_speak_ministry(H))
		return
	if(H.ministry_partner?.partner != H || !open || mailer)
		to_chat(H, span_warning("这份委任状已不属于我，无法再用它传话。"))
		return
	speech_cooldown = world.time + speech_cooldown_time
	H.whisper(msg)
	paired_ring.relay_ministry_message(msg)

/obj/item/paper/scroll/ministry_writ/proc/can_speak_ministry(mob/living/carbon/human/H)
	if(H.restrained() || H.incapacitated())
		to_chat(H, span_warning("受束缚或失去行动能力时，我无法使用它！"))
		return FALSE
	if(world.time < speech_cooldown)
		to_chat(H, span_warning("上次使用留下的墨迹尚未平息。"))
		return FALSE
	if(QDELETED(paired_ring))
		to_chat(H, span_warning("委任状没有配对的印戒，联系已经断开。"))
		return FALSE
	if(!paired_ring.find_items_mob_carrier())
		to_chat(H, span_warning("我的大臣没有携带印戒，话语无人接收。"))
		return FALSE
	if(find_items_mob_carrier() != H)
		to_chat(H, span_warning("委任状已离开我的手。"))
		return FALSE
	return TRUE

/obj/item/paper/scroll/ministry_writ/proc/relay_ministry_message(msg)
	playsound(src, 'sound/misc/scom.ogg', 80, FALSE, -1)
	say("<font color='#C8A84B'>[msg]</font>")

/obj/item/paper/scroll/ministry_writ/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!message)
		return
	if(!language)
		language = get_default_language()
	if(isitem(loc))
		var/obj/item/I = loc
		I.send_speech(message, 1, I, , spans, message_language = language)
		return
	send_speech(message, 1, src, , spans, message_language = language)

// Minister's signet, paired to the partner's writ like a two-way SCOM.
/obj/item/clothing/ring/minister
	name = "大臣印戒"
	desc = "带有大臣职务标记的印戒。将它抵在唇边，便能与任命人交谈。"
	icon_state = "signet"
	sellprice = 100
	slot_flags = ITEM_SLOT_RING
	var/obj/item/paper/scroll/ministry_writ/paired_writ
	var/speech_cooldown = 0
	var/speech_cooldown_time = 10 SECONDS

/obj/item/clothing/ring/minister/Destroy()
	if(paired_writ)
		paired_writ.paired_ring = null
		paired_writ = null
	return ..()

/obj/item/clothing/ring/minister/attack_self(mob/user)
	. = ..()
	attack_right(user)

/obj/item/clothing/ring/minister/attack_right(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.ministry_active || H.ministry_active.councillor != H)
		to_chat(H, span_warning("印戒在我手中冰冷而沉寂，它不属于我。"))
		return
	if(!can_speak_ministry(H))
		return
	H.changeNext_move(CLICK_CD_INTENTCAP)
	visible_message(span_notice("[H]将印戒抵在嘴边。"))
	var/msg = input(H, "对着印戒说话。", "大臣密语……") as null|text
	if(!msg)
		return
	if(!can_speak_ministry(H))
		return
	if(H.ministry_active?.councillor != H)
		to_chat(H, span_warning("印戒变得冰冷，我已不再担任此职。"))
		return
	speech_cooldown = world.time + speech_cooldown_time
	H.whisper(msg)
	paired_writ.relay_ministry_message(msg)

/obj/item/clothing/ring/minister/proc/can_speak_ministry(mob/living/carbon/human/H)
	if(H.restrained() || H.incapacitated())
		to_chat(H, span_warning("受束缚或失去行动能力时，我无法使用它！"))
		return FALSE
	if(world.time < speech_cooldown)
		to_chat(H, span_warning("印戒的金属还留着上次使用的余热。"))
		return FALSE
	if(QDELETED(paired_writ))
		to_chat(H, span_warning("印戒没有配对的委任状，联系已经断开。"))
		return FALSE
	if(!paired_writ.find_items_mob_carrier())
		to_chat(H, span_warning("没有人携带委任状，话语无人接收。"))
		return FALSE
	if(find_items_mob_carrier() != H)
		to_chat(H, span_warning("印戒已离开我的手。"))
		return FALSE
	return TRUE

/obj/item/clothing/ring/minister/proc/relay_ministry_message(msg)
	playsound(src, 'sound/misc/scom.ogg', 80, FALSE, -1)
	say("<font color='#C8A84B'>[msg]</font>")

/obj/item/clothing/ring/minister/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!message)
		return
	if(!language)
		language = get_default_language()
	if(isitem(loc))
		var/obj/item/I = loc
		I.send_speech(message, 1, I, , spans, message_language = language)
		return
	send_speech(message, 1, src, , spans, message_language = language)

/obj/item/clothing/ring/minister/guild
	name = "工艺大臣印戒"
	desc = "一枚磨损的印戒，仍留着公会炉火熏出的烟痕。"

/obj/item/clothing/ring/minister/church
	name = "教务大臣印戒"
	desc = "适合众神殿祭司佩戴的神圣戒指，如今却沾染了宫廷政治的污浊。"
	icon_state = "signet_silver"

/obj/item/clothing/ring/minister/night
	name = "夜务大臣印戒"
	desc = "一枚低调光滑的戒指。小心别让它沉到浴池底下。"

/obj/item/clothing/ring/minister/inquisition
	name = "正信大臣印戒"
	desc = "带有审判庭标记的印戒。一种坚忍的时尚选择，尽管有些过时。"
	icon_state = "signet_silver"

/obj/item/clothing/ring/minister/mage
	name = "奥术大臣印戒"
	desc = "一枚触感微温、刻有奥术符文的戒指。"

/obj/item/clothing/ring/minister/physician
	name = "医务大臣印戒"
	desc = "一枚刻有宫廷医师职务所用佩斯特拉卷须纹章的戒指。"

/obj/item/clothing/ring/minister/innkeeper
	name = "民务大臣印戒"
	desc = "一枚带有旅店酒龙头标记的戒指，刀具与砧板在光亮表面留下划痕。"

/obj/item/clothing/ring/minister/merchant
	name = "商贸大臣印戒"
	desc = "一枚带有商人公会聚财标记的戒指。"
