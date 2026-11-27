#define ORIGIN_KAISER_WILHELM_FORTRESS "威廉皇帝堡"
#define TRAIT_GERMANY_WARCRY "德意志战吼"

/datum/origin/kaiser_wilhelm_fortress
	name = ORIGIN_KAISER_WILHELM_FORTRESS
	desc = "雄踞于北境的冰川峡湾之间，这座宏伟堡垒居住着众多族群，效忠于帝国的日耳曼裔守备军、流亡至此的旧贵族，世代在冻土上凿冰捕鱼的当地原住民。"
	short_desc = "雄踞于北境冰川峡湾之间的宏伟堡垒，帝国守备军、流亡旧贵族与当地原住民在此共居。"
	origin_title = ORIGIN_KAISER_WILHELM_FORTRESS
	origin_language = /datum/language/grenzelhoftian
	origin_traits = list(TRAIT_GERMANY_WARCRY, TRAIT_COLD_RESISTANCE)
	map_x = 120
	map_y = 384
	map_label = ORIGIN_KAISER_WILHELM_FORTRESS

/datum/stressevent/prejudice/fortress_against_kazengun
	desc = span_red("我刚看见一个风郡人！")

/atom/movable/screen/alert/status_effect/buff/kaiser_battle_cry
	name = "德意志战吼"
	desc = "德意志的号令仍在我血脉中回响，这点痛楚压不垮我！"
	icon_state = "buff"

/datum/status_effect/buff/kaiser_battle_cry
	id = "kaiser_battle_cry"
	alert_type = /atom/movable/screen/alert/status_effect/buff/kaiser_battle_cry
	duration = 1 MINUTES
	status_type = STATUS_EFFECT_REFRESH

/datum/controller/subsystem/custom_bootstrap/proc/register_z121_fortress()
	GLOB.roguetraits[TRAIT_GERMANY_WARCRY] = span_info("在威廉皇帝堡，没有战吼便不算开战！一声德意志战吼令人斗志昂扬！")
	GLOB.all_traits["TRAIT_GERMANY_WARCRY"] = TRAIT_GERMANY_WARCRY

	var/datum/origin/kazengun/kazengun = GLOB.origins[/datum/origin/kazengun]
	kazengun.hated_by = list(ORIGIN_KAISER_WILHELM_FORTRESS)
	kazengun.prejudice_stress = /datum/stressevent/prejudice/fortress_against_kazengun
	kazengun.prejudice_examine = span_red("一个风郡人……我可不想和这人打交道。")

	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_CREATED, PROC_REF(on_fortress_mob_created))
	for(var/mob/living/carbon/human/person in GLOB.mob_list)
		person.register_fortress_warcry_verb()

/datum/controller/subsystem/custom_bootstrap/proc/on_fortress_mob_created(datum/source, mob/created)
	SIGNAL_HANDLER
	if(ishuman(created))
		var/mob/living/carbon/human/person = created
		person.register_fortress_warcry_verb()

/mob/living/carbon/human/proc/register_fortress_warcry_verb()
	RegisterSignal(src, list(SIGNAL_ADDTRAIT(TRAIT_GERMANY_WARCRY), SIGNAL_REMOVETRAIT(TRAIT_GERMANY_WARCRY)), PROC_REF(update_fortress_warcry_verb))
	update_fortress_warcry_verb()

/mob/living/carbon/human
	COOLDOWN_DECLARE(fortress_warcry_cooldown)

/mob/living/carbon/human/proc/update_fortress_warcry_verb(datum/source, trait)
	SIGNAL_HANDLER
	if(HAS_TRAIT(src, TRAIT_GERMANY_WARCRY))
		verbs |= /mob/living/carbon/human/proc/fortress_warcry
	else
		verbs -= /mob/living/carbon/human/proc/fortress_warcry

/mob/living/carbon/human/proc/fortress_warcry()
	set name = "德意志战吼"
	set category = "发声"

	emote("fortresswarcry", intentional = TRUE)

/datum/emote/living/fortress_warcry
	key = "fortresswarcry"
	key_third_person = "fortresswarcrys"
	message = "发出振奋人心的战吼！"
	message_muffled = "发出一声闷闷的呐喊！"
	emote_type = EMOTE_AUDIBLE
	mob_type_allowed_typecache = /mob/living/carbon/human

/datum/emote/living/fortress_warcry/run_emote(mob/living/carbon/human/user, params, type_override, intentional)
	if(!can_run_emote(user, TRUE, TRUE) || !HAS_TRAIT(user, TRAIT_GERMANY_WARCRY))
		return FALSE
	if(!COOLDOWN_FINISHED(user, fortress_warcry_cooldown))
		to_chat(user, span_notice("我得缓口气，才能再次战吼。"))
		return FALSE

	var/atom/movable/speaker = user
	if(isdullahan(user))
		var/datum/species/dullahan/species = user.dna.species
		if(species.headless && species.my_head)
			speaker = species.my_head

	COOLDOWN_START(user, fortress_warcry_cooldown, 3 SECONDS)

	user.apply_status_effect(/datum/status_effect/buff/kaiser_battle_cry)

	if(user.silent || HAS_TRAIT(user, TRAIT_MUTE) || HAS_TRAIT(user, TRAIT_PERMAMUTE) || HAS_TRAIT(user, TRAIT_BAGGED) || user.mouth?.muteinmouth || !is_emote_muffled(user))
		var/muffled_shout = format_warcry_message(user, speaker, message_muffled)
		user.log_message(muffled_shout, LOG_EMOTE)
		speaker.audible_message(muffled_shout, log_seen = SEEN_LOG_EMOTE, log_seen_msg = muffled_shout)
		return TRUE

	var/static/list/warcries = list(
		'modular_z121/kaiser_wilhelm/voice/01-vorwaerts.ogg' = "Vorwärts!",
		'modular_z121/kaiser_wilhelm/voice/02-vorwaerts.ogg' = "Vorwäääärts!",
		'modular_z121/kaiser_wilhelm/voice/03-los-los-los.ogg' = "Los, los, los!",
		'modular_z121/kaiser_wilhelm/voice/04-aus-dem-weg.ogg' = "Aus dem Weg!",
		'modular_z121/kaiser_wilhelm/voice/05-geh-weg.ogg' = "Geh weg!",
		'modular_z121/kaiser_wilhelm/voice/06-vorwaerts.ogg' = "VORWÄÄÄÄÄÄRRTS!!!",
		'modular_z121/kaiser_wilhelm/voice/07-attacke.ogg' = "ATTAAAACKE!",
		'modular_z121/kaiser_wilhelm/voice/08-machen-sie-ihnen-die-hoelle-heiss.ogg' = "Machen Sie ihnen die Hölle heiß!",
		'modular_z121/kaiser_wilhelm/voice/09-gebt-ihnen-stahl.ogg' = "Gebt ihnen Stahl, Jungs!",
	)
	var/clip = pick(warcries)
	var/subtitle = warcries[clip]
	var/shout = format_warcry_message(user, speaker, message)
	user.log_message(shout, LOG_EMOTE)

	playsound(speaker, clip, snd_vol, FALSE, snd_range, soundping = soundping)
	speaker.audible_message(shout, hearing_distance = world.view - 1, runechat_message = subtitle, log_seen = SEEN_LOG_EMOTE, log_seen_msg = shout, custom_spans = list("emote", "fortress-warcry"))
	return TRUE

/datum/emote/living/fortress_warcry/proc/format_warcry_message(mob/living/carbon/human/user, atom/movable/speaker, text)
	var/name_span = "<b>[speaker]</b>"
	var/name_color = user.get_voice_color()
	if(name_color)
		name_span = "<span style='color:#[name_color];text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>[speaker]</b></span>"
	return "[name_span] [text]"

#undef TRAIT_GERMANY_WARCRY
#undef ORIGIN_KAISER_WILHELM_FORTRESS
