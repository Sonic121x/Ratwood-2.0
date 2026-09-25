/proc/parse_zone(zone, obj/item/bodypart/affecting = null)
	// this helps adapt older code
	if(affecting?.body_zone == BODY_ZONE_TAUR)
		return "兽形下身"
	switch(zone)
		if(BODY_ZONE_PRECISE_R_HAND)
			return "右手"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "左手"
		if(BODY_ZONE_L_ARM)
			return "左臂"
		if(BODY_ZONE_R_ARM)
			return "右臂"
		if(BODY_ZONE_L_LEG)
			return "左腿"
		if(BODY_ZONE_R_LEG)
			return "右腿"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "左脚"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "右脚"
		if(BODY_ZONE_TAUR)
			return "兽形下身"
		if(BODY_ZONE_PRECISE_NECK)
			return "咽喉"
		if(BODY_ZONE_PRECISE_GROIN)
			return "腹股沟"
		if(BODY_ZONE_PRECISE_EARS)	//we want the chatlog to say 'grabbed his ear' not 'grabbed his ears' etc
			return "耳朵"
		if(BODY_ZONE_PRECISE_R_EYE)
			return "右眼"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "左眼"
		if(BODY_ZONE_PRECISE_NOSE)
			return "鼻子"
		if(BODY_ZONE_PRECISE_R_INHAND)
			return "右手"
		if(BODY_ZONE_PRECISE_L_INHAND)
			return "左手"
		if(BODY_ZONE_PRECISE_SKULL)
			return "颅骨"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "嘴巴"
	return zone == BODY_ZONE_HEAD ? "头部" : (zone == BODY_ZONE_CHEST ? "胸部" : (zone == BODY_ZONE_PRECISE_STOMACH ? "腹部" : zone))

/proc/parse_organ_slot(slot)
	switch(slot)
		if(ORGAN_SLOT_BRAIN)
			return "大脑"
		if(ORGAN_SLOT_APPENDIX)
			return "阑尾"
		if(ORGAN_SLOT_RIGHT_ARM_AUG)
			return "右臂植入物"
		if(ORGAN_SLOT_LEFT_ARM_AUG)
			return "左臂植入物"
		if(ORGAN_SLOT_STOMACH)
			return "胃"
		if(ORGAN_SLOT_STOMACH_AID)
			return "胃部辅助器"
		if(ORGAN_SLOT_BREATHING_TUBE)
			return "呼吸管"
		if(ORGAN_SLOT_EARS)
			return "耳朵"
		if(ORGAN_SLOT_EYES)
			return "眼睛"
		if(ORGAN_SLOT_LUNGS)
			return "肺"
		if(ORGAN_SLOT_HEART)
			return "心脏"
		if(ORGAN_SLOT_ZOMBIE)
			return "僵尸腺体"
		if(ORGAN_SLOT_THRUSTERS)
			return "推进器"
		if(ORGAN_SLOT_HUD)
			return "眼部植入物"
		if(ORGAN_SLOT_LIVER)
			return "肝脏"
		if(ORGAN_SLOT_TONGUE)
			return "舌头"
		if(ORGAN_SLOT_VOICE)
			return "声带"
		if(ORGAN_SLOT_ADAMANTINE_RESONATOR)
			return "精金共鸣器"
		if(ORGAN_SLOT_HEART_AID)
			return "心脏辅助器"
		if(ORGAN_SLOT_BRAIN_ANTIDROP)
			return "脑部防脱手植入物"
		if(ORGAN_SLOT_BRAIN_ANTISTUN)
			return "脑部抗眩晕植入物"
		if(ORGAN_SLOT_TAIL)
			return "尾巴"
		if(ORGAN_SLOT_PARASITE_EGG)
			return "寄生虫卵"
		if(ORGAN_SLOT_REGENERATIVE_CORE)
			return "再生核心"
	return slot

/proc/parse_zone_fancy(zone, combat, combattarget, closeby, turnedaround, ontheground, grabbing, squinting, uncovered, dicked, pussied, strength, self = FALSE)
	switch(zone)
		if(BODY_ZONE_PRECISE_R_HAND)
			if(closeby && !combat)
				if(squinting)
					return "fingers"
				return "hands"
			else
				return "arms"
		if(BODY_ZONE_PRECISE_L_HAND)
			if(closeby && !combat)
				if(squinting)
					return "fingers"
				return "hands"
			else
				return "arms"
		if(BODY_ZONE_PRECISE_R_INHAND)
			if(closeby && !combat)
				if(squinting)
					return "fingers"
				return "hands"
			else
				return "arms"
		if(BODY_ZONE_PRECISE_L_INHAND)
			if(closeby && !combat)
				if(squinting)
					return "fingers"
				return "hands"
			else
				return "arms"
		if(BODY_ZONE_L_ARM)
			if(closeby && !combat)
				if(grabbing)
					return "armpits"
				return "shoulders"
			if(closeby && squinting && strength && combat && combattarget)
				return "biceps"
			else
				return "arms"
		if(BODY_ZONE_R_ARM)
			if(closeby && !combat)
				if(grabbing)
					return "armpits"
				return "shoulders"
			if(closeby && squinting && strength && combat && combattarget)
				return "biceps"
			else
				return "arms"
		if(BODY_ZONE_L_LEG)
			if(closeby && !combat)
				if(squinting)
					return "thighs"
				return "knees"
			if(closeby && squinting && strength && combat && combattarget)
				return "calves"
			else
				return "legs"
		if(BODY_ZONE_R_LEG)
			if(closeby && !combat)
				if(squinting)
					return "thighs"
				return "knees"
			if(closeby && squinting && strength && combat && combattarget)
				return "calves"
			else
				return "legs"
		if(BODY_ZONE_PRECISE_L_FOOT)
			if(ontheground && closeby && squinting && uncovered)
				if(combat)
					return "toes"
				return "soles"
			if(turnedaround && closeby && !combat && uncovered)
				return "ankles"
			if(closeby && !combat)
				if(!uncovered)
					return "shoes"
				return "feet"
			return "legs"
		if(BODY_ZONE_PRECISE_R_FOOT)
			if(ontheground && closeby && squinting && uncovered)
				if(combat)
					return "toes"
				return "soles"
			if(turnedaround && closeby && !combat && uncovered)
				return "ankles"
			if(closeby && !combat)
				if(!uncovered)
					return "shoes"
				return "feet"
			return "legs"
		if(BODY_ZONE_PRECISE_STOMACH)
			if(!turnedaround)
				if(closeby && squinting && strength && combat && combattarget && uncovered)
					return "abs"
				if(closeby && !combat)
					if(squinting)
						return "waist"
					if(grabbing)
						return "belly"
					return "stomach"
			if(closeby && !combat)
				return "lower back"
			else
				return "body"
		if(BODY_ZONE_CHEST)
			if(!turnedaround)
				if(closeby && squinting && strength && combat && combattarget && uncovered)
					return "pecs"
				if(closeby && !combat)
					if(squinting && uncovered)
						return "breasts"
					return "chest"
			if(closeby && squinting && strength && combat && combattarget && uncovered)
				return "lats"
			if(closeby && !combat && !self)
				return "back"
			else
				return "body"
		if(BODY_ZONE_PRECISE_GROIN)
			if((turnedaround && !self) || (self && !squinting && combat))
				if(closeby && grabbing && squinting && ontheground && !combat && uncovered && !self)
					return "asshole"
				return "ass"
			if(closeby && !combat)
				if(squinting)
					if(dicked && pussied)
						if(uncovered)
							return "cock and slit"
						else
							return "bulge"
					else if(dicked)
						if(uncovered)
							return "cock"
						else
							return "bulge"
					else if(pussied)
						if(uncovered)
							return "slit"
						else
							return "camel toe"
				return "crotch"
			if(squinting && combat)
				return "hips"
			else
				return "groin"
		if(BODY_ZONE_PRECISE_NECK)
			if(self)
				return FALSE
			if(closeby && !turnedaround && !combat)
				return "neck"
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			if(self)
				return FALSE
			if(closeby && !combat && uncovered)
				return "ears"
			else
				return "head"
		if(BODY_ZONE_PRECISE_R_EYE)
			if(self)
				return FALSE
			if(closeby && !turnedaround && !combat && uncovered)
				if(squinting)
					return "cheeks"
				return "eyes"
			else
				return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			if(self)
				return FALSE
			if(closeby && !turnedaround && !combat && uncovered)
				if(squinting)
					return "cheeks"
				return "eyes"
			else
				return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			if(self)
				return FALSE
			if(closeby && !turnedaround && !combat && uncovered)
				return "nose"
			else
				return "head"
		if(BODY_ZONE_HEAD)
			if(self)
				return FALSE
			if(closeby && !turnedaround && !combat && uncovered)
				if(squinting)
					return "chin"
				return "face"
			else
				return "head"
		if(BODY_ZONE_PRECISE_SKULL)
			if(self)
				return FALSE
			if(closeby && !combat && uncovered)
				if(squinting && !turnedaround)
					return "forehead"
				return "hair"
			else
				return "head"
		if(BODY_ZONE_PRECISE_MOUTH)
			if(self)
				return FALSE
			if(closeby && !turnedaround && uncovered)
				if(!combat)
					if(squinting)
						if(prob(1))
							return "seductive lips"
						return "lips"
					return "mouth"
				return "jaw"
			else
				return "head"
	return zone
