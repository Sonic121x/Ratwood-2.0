From 88a9ea8f44156e0d7c19263ce11a94ef22f9f099 Mon Sep 17 00:00:00 2001
From: WitherVictor <number42@yeah.net>
Date: Fri, 22 May 2026 17:08:55 +0800
Subject: [PATCH] a

---
 .../code/modules/spells/orison.dm             | 78 +++++++++----------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/modular_azurepeak/code/modules/spells/orison.dm b/modular_azurepeak/code/modules/spells/orison.dm
index 2523e18240..eabb747d28 100644
--- a/modular_azurepeak/code/modules/spells/orison.dm
+++ b/modular_azurepeak/code/modules/spells/orison.dm
@@ -16,12 +16,12 @@
 	hand_path = /obj/item/melee/touch_attack/orison
 
 /obj/item/melee/touch_attack/orison
-	name = "\improper lesser prayer"
-	desc = "The fundamental teachings of theology return to you:\n \
-		<b>Fill</b>: Beseech your Divine to create a small quantity of water in a container that you touch for some devotion.\n \
-		<b>Touch</b>: Direct a sliver of divine thaumaturgy into your being, causing your voice to become LOUD when you next speak. Known to sometimes scare the rats inside the SCOMlines. Can be used on light sources at range, and it will cause them flicker.\n \
-		<b>Use</b>: Issue a prayer for illumination, causing you or another living creature to begin glowing with light for five minutes - this stacks each time you cast it, with no upper limit. Using thaumaturgy on a person will remove this blessing from them, and MMB on your praying hand will remove any light blessings from yourself.\n \
-		<b>Shove</b>: Lay hands upon an adjacent creature to channel divine restorative power through your touch. Both you and your target must remain still for the channeling to continue."
+	name = "\improper 次级祈祷"
+	desc = "神学的基本教义涌回你的脑海：\n \
+		<b>Fill</b>: 向你的神祇恳求，在你触碰的容器中创造少量水，消耗一定的信仰值。\n \
+		<b>Touch</b>: 将一丝神圣奇术引入自身，使你下次开口时声音变得洪亮。据说有时能吓到 SCOM 管线里的老鼠。可以远程用于光源，使其闪烁。\n \
+		<b>Use</b>: 发出祈求光明的祷告，使你或另一个活物开始发光，持续五分钟——此效果可叠加，无上限。对某人使用次级祈祷的 Touch 意图会移除其身上的此祝福，用中键点击祈祷之手则会移除你自身所有的光明祝福。\n \
+		<b>Shove</b>: 将手按在相邻的生物身上，通过你的触碰引导神圣的恢复之力。你和你的目标都必须保持静止，引导才能继续。"
 	catchphrase = null
 	possible_item_intents = list(/datum/intent/fill, INTENT_HELP, /datum/intent/use, INTENT_DISARM)
 	icon = 'icons/mob/roguehudgrabs.dmi'
@@ -43,7 +43,7 @@
 	. = ..()
 	if (user.has_status_effect(/datum/status_effect/light_buff))
 		user.remove_status_effect(/datum/status_effect/light_buff)
-		user.visible_message(span_notice("[user] closes [user.p_their()] eyes, and the holy light surrounding them retreats into their chest and disappears."), span_notice("I relinquish the gift of [user.patron.name]'s light."))
+		user.visible_message(span_notice("[user]闭上了[user.p_their()]的眼睛，环绕其周身的圣光缩回胸口，消失不见。"), span_notice("我放弃了 [user.patron.name] 赐予的光明恩赐。"))
 		return
 
 /obj/item/melee/touch_attack/orison/afterattack(atom/target, mob/living/carbon/human/user, proximity)
@@ -121,25 +121,25 @@
 	var/holy_skill = user.get_skill_level(attached_spell.associated_skill)
 	var/cast_time = 35 - (holy_skill * 3)
 	if (!thing.Adjacent(user))
-		to_chat(user, span_info("I need to be next to [thing] to channel a blessing of light!"))
+		to_chat(user, span_info("我需要靠近[thing]才能引导光明祝福！"))
 		return
 
 	if(!isliving(thing))
-		to_chat(user, span_notice("Only living creachers can bear the blessing of [user.patron.name]'s light."))
+		to_chat(user, span_notice("只有活物才能承受 [user.patron.name] 之光的祝福。"))
 		return
 
 	if(thing != user)
-		user.visible_message(span_notice("[user] reaches gently towards [thing], beads of light glimmering at [user.p_their()] fingertips..."), span_notice("Blessed [user.patron.name], I ask but for a light to guide the way..."))
+		user.visible_message(span_notice("[user]轻轻地朝[thing]伸出手，指尖闪烁着光点……"), span_notice("神圣的 [user.patron.name]，我只求一束光明指引前路..."))
 	else
-		user.visible_message(span_notice("[user] closes [user.p_their()] eyes and places a glowing hand upon [user.p_their()] chest..."), span_notice("Blessed [user.patron.name], I ask but for a light to guide the way..."))
+		user.visible_message(span_notice("[user]闭上眼睛，将发光的手按在胸口..."), span_notice("神圣的 [user.patron.name]，我只求一束光明指引前路..."))
 
 	if(!do_after(user, cast_time, target = thing))
 		return
 	var/mob/living/living_thing = thing
 	if (living_thing.has_status_effect(/datum/status_effect/light_buff))
-		user.visible_message(span_notice("The holy light emanating from [living_thing] becomes brighter!"), span_notice("I feed further devotion into [living_thing]'s blessing of light."))
+		user.visible_message(span_notice("从[living_thing]身上散发出的圣光变得更加明亮！"), span_notice("我向[living_thing]的光明祝福注入了更多的虔诚。"))
 	else
-		user.visible_message(span_notice("A gentle illumination suddenly blossoms into being around [living_thing]!"), span_notice("I grant [living_thing] a blessing of light."))
+		user.visible_message(span_notice("一片柔和的光辉突然在[living_thing]周身绽放！"), span_notice("我给予[living_thing]一份光明的祝福。"))
 
 	var/light_power = clamp(4 + (holy_skill - 3), 4, 7)
 	living_thing.apply_status_effect(/datum/status_effect/light_buff, light_power)
@@ -167,15 +167,15 @@
 	if (thing == user)
 		// give us a buff that makes our next spoken thing really loud and also cause any linked, un-muted scom to shriek out the phrase at a 15% chance
 		var/cast_time = 50 - (holy_skill * 5)
-		user.visible_message(span_notice("[user] lowers [user.p_their()] head solemnly, whispered prayers spilling from [user.p_their()] lips..."), span_notice("O holy [user.patron.name], share unto me a sliver of your power..."))
+		user.visible_message(span_notice("[user]庄严地低下头，低声的祈祷从唇间流淌而出..."), span_notice("噢，神圣的 [user.patron.name]，请分与我一丝你的力量..."))
 		
 		if (!user.has_status_effect(/datum/status_effect/thaumaturgy))
 			if (do_after(user, cast_time, target = user))
 				user.apply_status_effect(/datum/status_effect/thaumaturgy, holy_skill)
-				user.visible_message(span_notice("[user] throws open [user.p_their()] eyes, suddenly emboldened!"), span_notice("A feeling of power wells up in my throat: speak, and many will hear!"))
+				user.visible_message(span_notice("[user]猛地睁开双眼，顿时勇气倍增！"), span_notice("一股力量感涌上我的喉咙：开口吧，众人必将听见！"))
 				return thaumaturgy_devotion
 		else
-			to_chat(user, span_notice("I'm already empowered with divine thaumaturgy!"))
+			to_chat(user, span_notice("我已经被神圣奇术所增强！"))
 			return
 	else
 		// make a light source flicker, and others around it within a radius	
@@ -191,7 +191,7 @@
 						mobile_light.turn_off()
 						user.devotion?.update_devotion(-1)
 
-			to_chat(user, span_notice("I direct the weight of my faith towards nearby flames, causing them to flicker!"))
+			to_chat(user, span_notice("我将信仰的力量导向周围的火焰，令它们摇曳！"))
 			
 			return thaumaturgy_devotion
 		else if (isturf(thing))
@@ -203,24 +203,24 @@
 				did_flicker = TRUE
 
 			if (did_flicker)
-				to_chat(user, span_notice("I direct the weight of my faith towards nearby flames, causing them to flicker!"))
+				to_chat(user, span_notice("我将信仰的力量导向周围的火焰，令它们摇曳！"))
 
 				return thaumaturgy_devotion
 			else
-				to_chat(user, span_notice("My faith finds no flames to show its passage..."))
+				to_chat(user, span_notice("我的信仰找不到火焰来证明其存在..."))
 				qdel(src)
 		else if (isliving(thing))
 
 			var/mob/living/living_thing = thing
 			if (living_thing.has_status_effect(/datum/status_effect/light_buff))
 				living_thing.remove_status_effect(/datum/status_effect/light_buff)
-				user.visible_message(span_notice("[user] issues a reserved gesture towards [living_thing], and the holy light leaves [living_thing.p_them()]."), span_notice("I gesture towards [living_thing], and [living_thing.p_their()] blessing of light recedes."))
+				user.visible_message(span_notice("[user]向[living_thing]做了一个克制的手势，圣光便离开了[living_thing.p_them()]。"), span_notice("我向[living_thing]示意，[living_thing.p_their()]身上的光明祝福便消退了。"))
 				return
 			else
-				to_chat(user, span_notice("My divine thaumaturgy can only augment my own voice, or dismiss the blessing of light on others."))
+				to_chat(user, span_notice("我的神圣奇术只能增强自己的声音，或驱散他人身上的光明祝福。"))
 				return
 		else
-			to_chat(user, span_warning("I can only direct thaumaturgical prayers towards myself, the ground, and any nearby light sources."))
+			to_chat(user, span_warning("我只能将奇术祈祷导向自己、地面和周围的光源。"))
 			return
 
 /datum/reagent/water/blessed
@@ -295,24 +295,24 @@
 	var/cast_time = 40 - (holy_skill * 4)
 	
 	if (!thing.Adjacent(user))
-		to_chat(user, span_info("I need to be next to [thing] to lay hands upon them!"))
+		to_chat(user, span_info(to_chat(user, span_info("我需要靠近[thing]才能按住[user.p_their()]的手！"))))
 		return
 	
 	if (!isliving(thing))
-		to_chat(user, span_notice("I can only channel healing through living beings."))
+		to_chat(user, span_notice("我只能通过活物传导治愈之力。"))
 		return
 	
 	var/mob/living/target = thing
 	
 	if (target.stat == DEAD)
-		to_chat(user, span_warning("The dead are beyond my reach..."))
+		to_chat(user, span_warning("死者非我所能触及..."))
 		return
 	
 	if (target.has_status_effect(/datum/status_effect/buff/lay_hands))
-		to_chat(user, span_notice("[target] is already receiving the laying of hands."))
+		to_chat(user, span_notice("[target]已经在接受治疗了。"))
 		return
 	
-	user.visible_message(span_notice("[user] places [user.p_their()] hands upon [target], divine power beginning to gather..."), span_notice("I lay my hands upon [target], channeling [user.patron.name]'s restorative power..."))
+	user.visible_message(span_notice("[user]将[user.p_their()]的双手按在[target]身上，神圣之力开始汇聚..."), span_notice("我将双手按在[target]身上，引导 [user.patron.name] 的治愈之力..."))
 	
 	// Initial channel to establish the connection
 	if (do_after(user, cast_time, target = target))
@@ -321,7 +321,7 @@
 		// Devotion cost per tick scales down with skill: 3 to 1
 		var/devotion_per_tick = clamp(4 - holy_skill, 1, 20)
 		
-		user.visible_message(span_notice("Divine energy suffuses [target] as [user]'s channeling takes hold!"), span_notice("The connection is established - [user.patron.name]'s power flows through me into [target]."))
+		user.visible_message(span_notice("神圣能量弥漫在[target]周身，[user]的引导开始生效！"), span_notice("连接已建立——[user.patron.name] 的力量通过我流向[target]。"))
 		
 		// Continuous healing loop - keeps going as long as both stay still and adjacent
 		var/first_application = TRUE
@@ -330,17 +330,17 @@
 		while(do_after(user, tick_time, target = target))
 			// Check if we have enough devotion to continue
 			if (user.devotion?.devotion < devotion_per_tick)
-				to_chat(user, span_warning("My devotion is exhausted - I can no longer maintain the channeling!"))
+				to_chat(user, span_warning("我的虔诚已经耗尽——我无法继续维持引导！"))
 				break
 			
 			// Break if target dies
 			if (target.stat == DEAD)
-				to_chat(user, span_warning("[target] has passed beyond my healing touch..."))
+				to_chat(user, span_warning("[target]已经超出了我治愈之触的范围..."))
 				break
 			
 			// Break if no longer adjacent
 			if (!target.Adjacent(user))
-				to_chat(user, span_warning("I am too far from [target] - the blessing fades!"))
+				to_chat(user, span_warning("我离[target]太远了——祝福消退了！"))
 				break
 			
 			// Apply or refresh the healing effect
@@ -350,11 +350,11 @@
 			user.devotion?.update_devotion(-devotion_per_tick)
 			
 			if (first_application)
-				to_chat(user, span_notice("I maintain my focus, channeling [user.patron.name]'s restorative power through my hands..."))
+				to_chat(user, span_notice("我保持着专注，通过双手引导 [user.patron.name] 的治愈之力..."))
 				first_application = FALSE
 		
 		// When the loop ends (player moved or stopped)
-		user.visible_message(span_notice("[user] withdraws [user.p_their()] hands from [target], the divine energy fading."), span_notice("I release my concentration and the channeling ends."))
+		user.visible_message(span_notice("[user]将手从[target]身上收回，神圣能量随之消散。"), span_notice("我松开专注，引导结束。"))
 		
 		return lay_hands_devotion
 	
@@ -363,15 +363,15 @@
 /obj/item/melee/touch_attack/orison/proc/create_water(atom/thing, mob/living/carbon/human/user)
 	// normally we wouldn't use fatigue here to keep in line w/ other holy magic, but we have to since water is a persistent resource
 	if (!thing.Adjacent(user))
-		to_chat(user, span_info("I need to be closer to [thing] in order to try filling it with water."))
+		to_chat(user, span_info("我需要更靠近[thing]才能试着往里面注水。"))
 		return
 
 	if (thing.is_refillable())
 		if (thing.reagents.holder_full())
-			to_chat(user, span_warning("[thing] is full."))
+			to_chat(user, span_warning("[thing]已经满了。"))
 			return
 		
-		user.visible_message(span_info("[user] closes [user.p_their()] eyes in prayer and extends a hand over [thing] as water begins to stream from [user.p_their()] fingertips..."), span_notice("I utter forth a plea to [user.patron.name] for succour, and hold my hand out above [thing]..."))
+		user.visible_message(span_info("[user]闭上双眼祈祷，将手伸向[thing]，水从[user.p_their()]的指尖涌出..."), span_notice("我向 [user.patron.name] 发出祈求，将手伸向[thing]上方..."))
 
 		var/holy_skill = user.get_skill_level(attached_spell.associated_skill)
 		var/drip_speed = 56 - (holy_skill * 8)
@@ -403,10 +403,10 @@
 		var/obj/item/natural/cloth/the_cloth = thing
 		var/holy_skill = user.get_skill_level(attached_spell.associated_skill)
 		if(the_cloth.wet >= holy_skill * 5) // Don't reduce the wetness if someone better than you already blessed it
-			to_chat(user, span_warning("I cannot soak this cloth any further"))
+			to_chat(user, span_warning("我无法再把这布弄得更湿了"))
 			return
 		the_cloth.wet = holy_skill * 5
-		user.visible_message(span_info("[user] closes [user.p_their()] eyes in prayer, beads of moisture coalescing in [user.p_their()] hands to moisten [the_cloth]."), span_notice("I utter forth a plea to [user.patron.name] for succour, and will moisture into [the_cloth]. I should be able to clean with it properly now."))
+		user.visible_message(span_info("[user]闭上双眼祈祷，水珠在手中凝聚，打湿了[the_cloth]。"), span_notice("我向 [user.patron.name] 发出祈求，将水分注入[the_cloth]。现在我应该能用它好好清洁了。"))
 		return water_moisten
 	else
-		to_chat(user, span_info("I'll need to find a container that can hold water."))
+		to_chat(user, span_info("我得找个能盛水的容器。"))
-- 
2.54.0.windows.1

