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
	return zone == BODY_ZONE_HEAD ? "头部" : (zone == BODY_ZONE_CHEST ? "胸部" : (zone == BODY_ZONE_PRECISE_STOMACH ? "腹部" : (list("body" = "身体", "torso" = "躯干", "foreleg" = "前肢", "leg" = "腿部", "tail" = "尾巴", "wing" = "翅膀", "snout" = "口鼻", "beak" = "喙", "belly" = "腹部", "claw" = "爪子", "arm" = "手臂", "hand" = "手部", "foot" = "足部", "bladed arm" = "刃臂")[zone] || zone)))

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
					return "手指"
				return "双手"
			else
				return "双臂"
		if(BODY_ZONE_PRECISE_L_HAND)
			if(closeby && !combat)
				if(squinting)
					return "手指"
				return "双手"
			else
				return "双臂"
		if(BODY_ZONE_PRECISE_R_INHAND)
			if(closeby && !combat)
				if(squinting)
					return "手指"
				return "双手"
			else
				return "双臂"
		if(BODY_ZONE_PRECISE_L_INHAND)
			if(closeby && !combat)
				if(squinting)
					return "手指"
				return "双手"
			else
				return "双臂"
		if(BODY_ZONE_L_ARM)
			if(closeby && !combat)
				if(grabbing)
					return "腋窝"
				return "肩膀"
			if(closeby && squinting && strength && combat && combattarget)
				return "肱二头肌"
			else
				return "双臂"
		if(BODY_ZONE_R_ARM)
			if(closeby && !combat)
				if(grabbing)
					return "腋窝"
				return "肩膀"
			if(closeby && squinting && strength && combat && combattarget)
				return "肱二头肌"
			else
				return "双臂"
		if(BODY_ZONE_L_LEG)
			if(closeby && !combat)
				if(squinting)
					return "大腿"
				return "膝盖"
			if(closeby && squinting && strength && combat && combattarget)
				return "小腿"
			else
				return "双腿"
		if(BODY_ZONE_R_LEG)
			if(closeby && !combat)
				if(squinting)
					return "大腿"
				return "膝盖"
			if(closeby && squinting && strength && combat && combattarget)
				return "小腿"
			else
				return "双腿"
		if(BODY_ZONE_PRECISE_L_FOOT)
			if(ontheground && closeby && squinting && uncovered)
				if(combat)
					return "脚趾"
				return "脚底"
			if(turnedaround && closeby && !combat && uncovered)
				return "脚踝"
			if(closeby && !combat)
				if(!uncovered)
					return "鞋子"
				return "双脚"
			return "双腿"
		if(BODY_ZONE_PRECISE_R_FOOT)
			if(ontheground && closeby && squinting && uncovered)
				if(combat)
					return "脚趾"
				return "脚底"
			if(turnedaround && closeby && !combat && uncovered)
				return "脚踝"
			if(closeby && !combat)
				if(!uncovered)
					return "鞋子"
				return "双脚"
			return "双腿"
		if(BODY_ZONE_PRECISE_STOMACH)
			if(!turnedaround)
				if(closeby && squinting && strength && combat && combattarget && uncovered)
					return "腹肌"
				if(closeby && !combat)
					if(squinting)
						return "腰部"
					if(grabbing)
						return "肚子"
					return "腹部"
			if(closeby && !combat)
				return "腰背"
			else
				return "身体"
		if(BODY_ZONE_CHEST)
			if(!turnedaround)
				if(closeby && squinting && strength && combat && combattarget && uncovered)
					return "胸肌"
				if(closeby && !combat)
					if(squinting && uncovered)
						return "乳房"
					return "胸部"
			if(closeby && squinting && strength && combat && combattarget && uncovered)
				return "背阔肌"
			if(closeby && !combat && !self)
				return "背部"
			else
				return "身体"
		if(BODY_ZONE_PRECISE_GROIN)
			if((turnedaround && !self) || (self && !squinting && combat))
				if(closeby && grabbing && squinting && ontheground && !combat && uncovered && !self)
					return "肛门"
				return "屁股"
			if(closeby && !combat)
				if(squinting)
					if(dicked && pussied)
						if(uncovered)
							return "阴茎和阴户"
						else
							return "裆部隆起"
					else if(dicked)
						if(uncovered)
							return "阴茎"
						else
							return "裆部隆起"
					else if(pussied)
						if(uncovered)
							return "阴户"
						else
							return "裆部轮廓"
				return "裆部"
			if(squinting && combat)
				return "胯部"
			else
				return "腹股沟"
		if(BODY_ZONE_PRECISE_NECK)
			if(self)
				return FALSE
			if(closeby && !turnedaround && !combat)
				return "颈部"
			return "头部"
		if(BODY_ZONE_PRECISE_EARS)
			if(self)
				return FALSE
			if(closeby && !combat && uncovered)
				return "耳朵"
			else
				return "头部"
		if(BODY_ZONE_PRECISE_R_EYE)
			if(self)
				return FALSE
			if(closeby && !turnedaround && !combat && uncovered)
				if(squinting)
					return "脸颊"
				return "眼睛"
			else
				return "头部"
		if(BODY_ZONE_PRECISE_L_EYE)
			if(self)
				return FALSE
			if(closeby && !turnedaround && !combat && uncovered)
				if(squinting)
					return "脸颊"
				return "眼睛"
			else
				return "头部"
		if(BODY_ZONE_PRECISE_NOSE)
			if(self)
				return FALSE
			if(closeby && !turnedaround && !combat && uncovered)
				return "鼻子"
			else
				return "头部"
		if(BODY_ZONE_HEAD)
			if(self)
				return FALSE
			if(closeby && !turnedaround && !combat && uncovered)
				if(squinting)
					return "下巴"
				return "面部"
			else
				return "头部"
		if(BODY_ZONE_PRECISE_SKULL)
			if(self)
				return FALSE
			if(closeby && !combat && uncovered)
				if(squinting && !turnedaround)
					return "额头"
				return "头发"
			else
				return "头部"
		if(BODY_ZONE_PRECISE_MOUTH)
			if(self)
				return FALSE
			if(closeby && !turnedaround && uncovered)
				if(!combat)
					if(squinting)
						if(prob(1))
							return "诱人的双唇"
						return "嘴唇"
					return "嘴巴"
				return "下颌"
			else
				return "头部"
	return parse_zone(zone)
