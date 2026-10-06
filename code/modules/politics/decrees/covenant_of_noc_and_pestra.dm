/datum/decree/noc_pestra_covenant
	id = DECREE_NOC_PESTRA_COVENANT
	name = "诺克与佩斯特拉盟约"
	category = DECREE_CATEGORY_NEW
	mechanical_text = "限制大学与药剂行人员的人头税，并保障其最低工资：宫廷法师40玛门币、档案员20玛门币、法师仆从10玛门币、宫廷医师80玛门币、药剂师40玛门币。"
	/// Jobs covered by the scholarly half of the covenant (Noc's mantle).
	var/static/list/university_jobs = list(
		"Court Magician",
		"Archivist",
		"Magicians Associate", 
	)
	/// Jobs covered by the healing half of the covenant (Pestra's mantle).
	var/static/list/apothecary_jobs = list(
		"Apothecary",
		"Head Physician", 
	)
	var/static/list/wage_floors = list(
		"Court Magician" = 40,
		"Archivist" = 20,
		"Magicians Associate" = 10,
		"Head Physician" = 40,
		"Apothecary" = 15,
	)
	flavor_text = {"本《诺克与佩斯特拉盟约》，于诺克警醒的目光与佩斯特拉慈悲的手掌之下立誓，规定：盟约有效期间，大学学者与药剂行医者所负人头税不得超过最低税额，并应由王室财库支付其应得的合理最低薪资。

作为回报，大学的特许学者应守护、保存王国的学识，并传授给品行端正、才智明敏之人，因为诺克赐予人类魔法与智慧，正是为让我们将其传承。药剂行的特许医者作为佩斯特拉的使者，应治疗每一位登门臣民，无论乞丐还是市民，不得因伤者缺少钱币而拒绝医治，因为佩斯特拉慈悲，教我们医术，是为让我们彼此照料。

于诺克与佩斯特拉见证之下，钤王室之印颁行。"}
	revoke_text = "%RULER%已中止《诺克与佩斯特拉盟约》。谷地的学者与医者现在须全额承担王室的普通税负——诺克与佩斯特拉不妨思量，失去特许的双手后，祂们的慈悲还能延续多久。"
	restore_text = "%RULER%已确认《诺克与佩斯特拉盟约》。谷地的学者与医者重获庇护，使王国得以同时保全学识与慈悲。"

/datum/decree/noc_pestra_covenant/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(20, 60)

/// Returns TRUE if the payer is a member of one of the two chartered rosters.
/datum/decree/noc_pestra_covenant/proc/is_protected(mob/living/payer)
	if(!active || !payer)
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_OUTLAW))
		return FALSE
	if(payer.job in university_jobs)
		return TRUE
	if(payer.job in apothecary_jobs)
		return TRUE
	return FALSE

/datum/decree/noc_pestra_covenant/apply_poll_tax_cap(mob/living/payer, poll_category, current_rate)
	if(!is_protected(payer))
		return current_rate
	return min(current_rate, NOC_PESTRA_POLL_CAP)

/datum/decree/noc_pestra_covenant/apply_wage_floor(job_title, current_floor)
	var/mandated = wage_floors[job_title] || 0
	return max(current_floor, mandated)

/datum/decree/noc_pestra_covenant/wage_floored_jobs()
	return wage_floors

/datum/decree/noc_pestra_covenant/on_restore()
	. = ..()
	SStreasury.steward_machine?.enforce_wage_floors()
