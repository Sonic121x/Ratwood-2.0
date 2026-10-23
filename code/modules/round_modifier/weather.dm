/datum/round_modifier/clear
	name = "Clear Skies"
	desc = "没什么有意思的天气。"
	incompatible = list(/datum/round_modifier/fog, /datum/round_modifier/stormy)
	weather_weights = list(
		/datum/particle_weather/rain_storm = 0,
		/datum/particle_weather/snow_storm = 0,
		/datum/particle_weather/dry_thunderstorm = 0,
		/datum/particle_weather/fog = 0,
		/datum/particle_weather/snow_gentle = 0,
		/datum/particle_weather/heat_wave = 0,
	)

/datum/round_modifier/fog
	name = "Fog"
	desc = "要起雾了。"
	weather_weights = list(/datum/particle_weather/fog = 4)
	incompatible = list(/datum/round_modifier/stormy)

/datum/round_modifier/stormy
	name = "Stormy"
	desc = "要下暴雨了。"
	weight = 8
	min_chaos = 2
	weather_weights = list(
		/datum/particle_weather/rain_storm = 4,
		/datum/particle_weather/snow_storm = 3,
		/datum/particle_weather/dry_thunderstorm = 3,
	)
