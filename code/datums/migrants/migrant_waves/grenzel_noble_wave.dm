/datum/migrant_wave/grenzel_envoy
	name = "格伦泽尔霍夫特使团"
	max_spawns = 1
	weight = 50
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/grenzel/envoy = 1,
	)
	optional_roles = list(
		/datum/migrant_role/grenzel/bodyguard = 2,
		/datum/migrant_role/grenzel/priest = 1,
	)
	min_optional_fills = 0
	greet_text = "你们是来自格伦泽尔霍夫特的使团，带着护卫与神父一同出行，代表自己的祖国。"
