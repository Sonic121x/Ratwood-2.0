/datum/decree/indenture_of_war
	id = DECREE_INDENTURE_OF_WAR
	name = "军役契约"
	category = DECREE_CATEGORY_ANCIENT
	mechanical_text = "规定军人的最低日薪：执法官60玛门，骑士／军士长40玛门，府卫／守林人20玛门，侍从10玛门。"
	/// Per-rank mandated daily wage. Steward cannot set below these amounts while the Indenture
	/// stands, and any existing below-floor wage is bumped up at activation. Military ranks only -
	/// courtiers, healers, scholars, and civilian staff are not covered by this charter.
	var/static/list/wage_floors = list(
		"Marshal" = 60,
		"Knight" = 40,
		"Sergeant" = 40,
		"Man at Arms" = 20,
		"Warden" = 20,
		"Squire" = 10,
	)
	flavor_text = {"兹由谷地王室与领地武装人员订立本军役契约，约定如下：

王室应依本契约所列军阶，按日向军人支付应得薪饷，不得阻挠或拖延。领地执法官每日六十玛门，骑士四十玛门，军士长亦为四十玛门，府卫二十玛门，守林人二十玛门，侍从十玛门。本契约有效期间，薪饷不得低于上述数额。

作为回报，领地武装人员应忠实为公爵效力，并服从公爵副官及军官一切合法合理的命令。若武装人员违反本契约，应由公爵裁处。若王室违反本契约，扣留所承诺的薪饷，或将薪饷降至本契约所定数额以下，则军人的效忠誓言即告解除，王室须为背弃承诺承担责任。

为昭信守，谷地王室于本契约加盖印玺，领地武装人员亦以各自印章为证。

本契约经王室印玺颁行。"}
	revoke_text = "%RULER%已毁弃军役契约。军人的效忠誓言即告解除，王室武装人员可自由决定是否效力——愿驻军铭记，究竟是谁先撕毁了约定。"
	restore_text = "%RULER%已重订军役契约。军饷得到承诺，效忠誓言亦告成立——双方相互约束。"

/datum/decree/indenture_of_war/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(40, 120)

/datum/decree/indenture_of_war/apply_wage_floor(job_title, current_floor)
	var/mandated = wage_floors[job_title] || 0
	return max(current_floor, mandated)

/datum/decree/indenture_of_war/wage_floored_jobs()
	return wage_floors

/datum/decree/indenture_of_war/on_restore()
	. = ..()
	SStreasury.steward_machine?.enforce_wage_floors()
