From c654b0177fdf1e5b720f583c3b9bccf0f00d8ecd Mon Sep 17 00:00:00 2001
From: WitherVictor <number42@yeah.net>
Date: Tue, 26 May 2026 16:35:45 +0800
Subject: [PATCH] =?UTF-8?q?=E7=BF=BB=E8=AF=91=E8=82=A5=E7=9A=82?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

---
 code/game/objects/items/soap.dm | 42 ++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/code/game/objects/items/soap.dm b/code/game/objects/items/soap.dm
index 029ae005d0..80cb2292ab 100644
--- a/code/game/objects/items/soap.dm
+++ b/code/game/objects/items/soap.dm
@@ -1,6 +1,6 @@
 /obj/item/soap
-	name = "soap"
-	desc = "One of Pestra's more humble and unassuming gifts. Take care not to slip!"
+	name = "肥皂"
+	desc = "佩斯特拉谦卑朴素的恩赐之一。小心别滑倒！"
 	gender = PLURAL
 	icon = 'icons/obj/items_and_weapons.dmi'
 	icon_state = "soap"
@@ -22,26 +22,26 @@
 /obj/item/soap/examine(mob/user)
 	. = ..()
 	var/max_uses = initial(uses)
-	var/msg = "It looks freshly-made."
+	var/msg = "它看起来刚做好。"
 	if(uses != max_uses)
 		var/percentage_left = uses / max_uses
 		switch(percentage_left)
 			if(0 to 0.15)
-				msg = "There's just a tiny bit left of what it used to be; You're not sure it'll last much longer."
+				msg = "它只剩下一丁点儿了，你不确定它还能撑多久。"
 			if(0.15 to 0.30)
-				msg = "It's dissolved quite a bit, but there's still some life to it."
+				msg = "它已经融化了不少，不过还能再用一阵子。"
 			if(0.30 to 0.50)
-				msg = "It's past its prime, but it's definitely still good."
+				msg = "它已经过了最佳状态，但绝对还能用。"
 			if(0.50 to 0.75)
-				msg = "It's started to get a little smaller than it used to be, but it'll definitely still last for a while."
+				msg = "它开始比原来小了一圈，但肯定还能用很长时间。"
 			else
-				msg = "It's seen some light use, but it's still pretty fresh."
+				msg = "它有些许使用痕迹，但还相当新。"
 	. += span_notice("[msg]")
 
 /obj/item/soap/proc/decreaseUses(mob/user)
 	uses--
 	if(uses <= 0)
-		to_chat(user, span_warning("[src] crumbles into tiny bits!"))
+		to_chat(user, span_warning("[src]碎裂成了小碎片！"))
 		qdel(src)
 
 /obj/item/soap/afterattack(atom/target, mob/user, proximity)
@@ -52,31 +52,31 @@
 	if(!proximity || !check_allowed_items(target, target_self=1))
 		return
 	if(istype(target, /obj/effect/decal/cleanable))
-		user.visible_message(span_notice("[user] begins to scrub \the [target.name] out with [src]."), span_warning("I begin to scrub \the [target.name] out with [src]..."))
+		user.visible_message(span_notice("[user]开始用[src]擦掉[target.name]。"), span_warning("我开始用[src]擦掉[target.name]..."))
 		if(do_after(user, src.cleanspeed, target = target))
-			to_chat(user, span_notice("I scrub \the [target.name] out."))
+			to_chat(user, span_notice("我擦掉了[target.name]。"))
 			qdel(target)
 			decreaseUses(user)
 
 	else if(ishuman(target) && user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
 		var/mob/living/carbon/human/H = user
-		user.visible_message(span_warning("\the [user] washes \the [target]'s mouth out with [src.name]!"), span_notice("I wash \the [target]'s mouth out with [src.name]!")) //washes mouth out with soap sounds better than 'the soap' here			if(user.zone_selected == "mouth")
+		user.visible_message(span_warning("[user]用[src.name]洗了[target]的嘴巴！"), span_notice("我用[src.name]洗了[target]的嘴巴！"))
 		H.lip_style = null //removes lipstick
 		H.update_body()
 		decreaseUses(user)
 		return
 	else if(istype(target, /obj/structure/roguewindow))
-		user.visible_message(span_notice("[user] begins to clean \the [target.name] with [src]..."), span_notice("I begin to clean \the [target.name] with [src]..."))
+		user.visible_message(span_notice("[user]开始用[src]清洁[target.name]..."), span_notice("我开始用[src]清洁[target.name]..."))
 		if(do_after(user, src.cleanspeed, target = target))
-			to_chat(user, span_notice("I clean \the [target.name]."))
+			to_chat(user, span_notice("我擦干净了[target.name]。"))
 			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
 			target.set_opacity(initial(target.opacity))
 			decreaseUses(user)
 	else
-		user.visible_message(span_notice("[user] begins to clean \the [target.name] with [src]..."), span_notice("I begin to clean \the [target.name] with [src]..."))
+		user.visible_message(span_notice("[user]开始用[src]清洁[target.name]..."), span_notice("我开始用[src]清洁[target.name]..."))
 		if(do_after(user, src.cleanspeed, target = target))
 			wash_atom(target,CLEAN_MEDIUM)
-			to_chat(user, span_notice("I clean \the [target.name]."))
+			to_chat(user, span_notice("我擦干净了[target.name]。"))
 			for(var/obj/effect/decal/cleanable/C in target)
 				qdel(C)
 			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
@@ -90,16 +90,16 @@
 	if(!istype(bathspot, /turf/open/water/bath) && !locate(/obj/structure/hotspring) in bathspot)
 		return
 	if(ishuman(target))
-		visible_message(span_info("[user] begins washing [target] with the [src]."))
+		visible_message(span_info("[user]开始用[src]给[target]洗澡。"))
 		if(do_after(user, 50))
 			wash_atom(target,CLEAN_MEDIUM)
 			if(HAS_TRAIT(user, TRAIT_GOODLOVER))
-				visible_message(span_info("[user] expertly cleans and soothes [target] with the [src]."))
-				to_chat(target, span_love("I feel so relaxed and clean!"))
+				visible_message(span_info("[user]熟练地用[src]把[target]清洗得干干净净，令其浑身舒泰。"))
+				to_chat(target, span_love("我感觉好放松，好干净！"))
 				target.add_stress(/datum/stressevent/bathcleaned)
 			else
-				visible_message(span_info("[user] tries their best to scrub [target] with the [src]."))
-				to_chat(target, span_warning("That's a bit nicer, I guess."))
+				visible_message(span_info("[user]尽力用[src]给[target]擦洗了一番。"))
+				to_chat(target, span_warning("还行吧，确实舒服一点了。"))
 				target.add_stress(/datum/stressevent/bath)
 			var/datum/charflaw/malodorous/malodorous_flaw = target.get_flaw(/datum/charflaw/malodorous)
 			malodorous_flaw?.on_bath(target)
-- 
2.53.0

