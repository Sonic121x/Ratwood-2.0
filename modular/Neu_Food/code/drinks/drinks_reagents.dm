/datum/reagent/water/rosewater
	name = "玫瑰茶"
	description = "以玫瑰花瓣浸泡而成，带有轻微的恢复效果。"
	reagent_state = LIQUID
	color = "#f398b6"
	taste_description = "花香甜味"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/water/rosewater/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.5  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.1, FALSE)
		M.adjustToxLoss(-2, FALSE)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/water/rosewater_spiced
	name = "五香玫瑰茶"
	description = "以五香玫瑰花瓣泡制而成，有助于重振体内的体液，提供适度的生命恢复与解毒效果。"
	reagent_state = LIQUID
	color = "#F2638C"
	taste_description = "花香辛味"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/water/rosewater_spiced/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.8  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.46  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.46  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.2, FALSE)
		M.adjustToxLoss(-3, FALSE)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

// Reagents system don't have the idea of solute and solvent so we need a type for each
/datum/reagent/consumable/caffeine/
	name = "咖啡因"
	description = "你为什么会看到这个？"
	hydration_factor = 5
	overdose_threshold = 60

/datum/reagent/consumable/caffeine/on_mob_life(mob/living/carbon/M)
	. = ..()
	M.energy_add(5) // 1/6th of mana pot
	M.apply_status_effect(/datum/status_effect/buff/vigorized)
	M.sate_addiction(/datum/charflaw/addiction/caffiend)

/datum/reagent/consumable/caffeine/overdose_process(mob/living/carbon/M)
	. = ..()
	M.Jitter(2)
	if(prob(5))
		M.heart_attack()
	
/datum/reagent/consumable/caffeine/coffee
	name = "咖啡"
	description = "咖啡豆煮成的热饮，带着一丝苦味，能提振精神。"
	reagent_state = LIQUID
	color = "#482000"
	taste_description = "焦糖般的苦味" // coffee has so many flavors I am going for one
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 200
	quality = DRINK_NICE

/datum/reagent/consumable/caffeine/coffee_spiced
	name = "五香咖啡"
	description = "以五香咖啡豆煮成的热饮，略带一丝苦味。能适度恢复元气。"
	reagent_state = LIQUID
	color = "#8C4221"
	taste_description = "焦糖般的辛味"
	metabolization_rate = 0.5
	alpha = 200
	quality = DRINK_GOOD

/datum/reagent/consumable/caffeine/coffee_spiced/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.15, FALSE)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/consumable/caffeine/tea
	name = "茶"
	description = "茶叶煮成的热饮，略带一丝苦味，口感顺滑。"
	reagent_state = LIQUID
	color = "#508141" // Deeper green to make it look better
	taste_description = "顺滑的草木气息" // Yeah, uh.
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173
	quality = DRINK_NICE

/datum/reagent/consumable/caffeine/tea_spiced
	name = "五香茶"
	description = "以五香茶叶煮成的热饮。略带一丝苦味。口感顺滑，令人恢复元气。"
	reagent_state = LIQUID
	color = "#788C41" // Deeper green to make it look better
	taste_description = "辛香的草木气息"
	metabolization_rate = 0.5
	alpha = 173
	quality = DRINK_GOOD

/datum/reagent/consumable/caffeine/tea_spiced/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.15, FALSE)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/consumable/poppy_milk
	name = "罂粟奶"
	description = "浸入罂粟后的饮液，喝下后会让你的口舌与神智一同麻木。喝上一杯以上可能不太利于健康......"
	reagent_state = LIQUID
	color = "#dbd7d5"
	taste_description = "瞬间的麻木感"
	metabolization_rate = REAGENTS_METABOLISM
	overdose_threshold = 25 // one cup is safe, anything more and it's an OD
	alpha = 200
	quality = DRINK_NICE

/datum/reagent/consumable/poppy_milk/on_mob_life(mob/living/carbon/M)
	M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.apply_status_effect(/datum/status_effect/buff/ozium)
	return ..()

/datum/reagent/consumable/poppy_milk/overdose_process(mob/living/M)
	M.adjustToxLoss(3, FALSE)
	..()
	return ..()

// Tea ported from Vanderlin from Misc Fixes PR #862
/datum/reagent/consumable/golden_calendula_tea
	name = "金盏花茶"
	description = "一种清爽的茶饮，很适合舒缓伤势并缓解疲劳。"
	color = "#b38e17"
	taste_description = "草本风味"
	quality = DRINK_VERYGOOD
	alpha = 173

/datum/reagent/consumable/golden_calendula_tea/on_mob_life(mob/living/carbon/M)
	M.energy_add(5)
	if(M.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		M.adjust_blood_volume(5)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1) //at a metabolism of .5 U a tick this translates to 120WHP healing with 20 U Most wounds are unsewn 15-100. This is powerful on single wounds but rapidly weakens at multi wounds.
	if(volume > 0.99)
		M.adjustBruteLoss(-0.75  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustFireLoss(-0.75  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustOxyLoss(-0.25, FALSE)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.75  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
	return ..()

/datum/reagent/consumable/chocolate
	name = "热巧克力"
	description = "丝滑细腻、浓郁醇厚。提供适度的生命恢复与少量耐力恢复。"
	color = "#3F291C"
	taste_description = "粘喉的甜味，配以浓郁温暖的余韵"
	quality = DRINK_GOOD
	alpha = 250

/datum/reagent/consumable/chocolate/on_mob_life(mob/living/carbon/M)
	M.energy_add(1)
	if(M.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		M.adjust_blood_volume(1)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustFireLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustOxyLoss(-0.15, FALSE)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
	return ..()

/datum/reagent/consumable/spiced_chocolate
	name = "五香巧克力"
	description = "难以置信地丝滑细腻、浓郁醇厚。提供可观的生命恢复与少量耐力恢复。"
	color = "#6D472F"
	taste_description = "浓郁、香甜与一丝刺激喉咙的辛味不可思议地交融在一起"
	quality = DRINK_VERYGOOD
	alpha = 250

/datum/reagent/consumable/spiced_chocolate/on_mob_life(mob/living/carbon/M)
	M.energy_add(2)
	if(M.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		M.adjust_blood_volume(2)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.5  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustFireLoss(-0.5  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustOxyLoss(-0.15, FALSE)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.5  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.5  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
	return ..()

/datum/reagent/consumable/soothing_valerian_tea
	name = "舒缓缬草茶"
	description = "一种清爽的茶饮，很适合缓解疲劳并减轻压力。"
	color = "#3b9146"
	quality = DRINK_FANTASTIC
	taste_description = "草本风味"
	alpha = 173

/datum/reagent/consumable/soothing_valerian_tea/on_mob_life(mob/living/carbon/M)
	M.energy_add(3)
	return ..()
