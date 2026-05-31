/particles/weather/leaves
	icon_state	= list("leaf1"=7, "leaf2"=1, "leaf3"=1)
	spin		= 6
	position 	= generator("box", list(-500,-256,0), list(400,500,0))
	gravity 	= list(0, -1, 0.1)
	friction    = 0.3
	transform 	= null
	lifespan = 55
	fadein = 6
	//Weather effects, max values
	maxSpawning            = 25
	minSpawning            = 3
	wind                   = 2


/particles/weather/leaves/sakura
	icon_state	= "petals1"
	position 	= generator("box", list(-500,-256,0), list(400,500,0))
	gravity 	= list(0, -1, 0.1)
	friction 	= 0.5
	transform 	= null
	lifespan = 55
	fadein = 6
	//Weather effects, max values
	maxSpawning            = 30
	minSpawning            = 5
	wind                   = 1

/datum/particle_weather/leaves_gentle
	name = "强风"
	desc = "风势渐起，卷动漫天落叶。"
	particleEffectType = /particles/weather/leaves
	warning_message = span_greenannounce("轻风穿过大地上的林间。")
	late_warning_message = span_greenannounce("一阵突如其来的狂风将落叶卷得到处纷飞。")
	scale_vol_with_severity = TRUE

	minSeverity = 1
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 40
	target_trait = PARTICLEWEATHER_LEAVES

/datum/particle_weather/leaves_storm
	name = "狂风"
	desc = "猛烈的风暴卷起成片树叶。"
	particleEffectType = /particles/weather/leaves
	warning_message = span_greenannounce("狂风穿越整片林地，席卷大地。")
	late_warning_message = span_greenannounce("A sudden gust scatters leaves wildly through the air.")
	scale_vol_with_severity = TRUE

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 20
	target_trait = PARTICLEWEATHER_LEAVES

/datum/particle_weather/sakura_gentle
	name = "宁静花风"
	desc = "柔和的风吹拂着花木，带来片片花瓣。"
	particleEffectType = /particles/weather/leaves/sakura
	warning_message = span_greenannounce("柔和的风穿过繁花之树，花意弥漫四周。")
	late_warning_message = span_greenannounce("A sudden gust scatters leaves wildly through the air.")
	scale_vol_with_severity = TRUE

	minSeverity = 1
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 0
	target_trait = PARTICLEWEATHER_SAKURA

/datum/particle_weather/sakura_storm
	name = "盛放花风"
	desc = "更猛烈的花风卷起漫天花瓣。"
	particleEffectType = /particles/weather/leaves/sakura
	warning_message = span_greenannounce("强劲的风掠过繁花之树，卷起漫天花瓣。")
	late_warning_message = span_greenannounce("A sudden gust scatters leaves wildly through the air.")
	scale_vol_with_severity = TRUE

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 0
	target_trait = PARTICLEWEATHER_SAKURA
