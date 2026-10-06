/obj/structure/roguemachine/lottery_roguetown
	name = "赛利克斯的鸿运"
	desc = "一个深不见底、能成就也能毁掉人的巨洞。来玩吧！"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "lottery"
	density = FALSE
	pixel_y = 32
	light_outer_range = 5
	light_color = "#1b7bf1"
	var/gamblingprice = 0
	var/checkchatter = 0
	var/chatterbox = 0

//ensure these two are the same, or else first roll will be fucky
	var/gamblingprob = 60
	var/gamblingbaseprob = 60

	var/diceroll = 100
	var/maxtithing = 100
	var/mintithing = 5
	var/stopgambling = 0
	var/probpenalty = 2
	var/oldtithe = 0


/obj/structure/roguemachine/lottery_roguetown/attack_hand(mob/living/user) //empty hand

	src.say("你当前的贡金是 [src.gamblingprice] 玛门。要来转一把吗？")
	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	return

/obj/structure/roguemachine/lottery_roguetown/attackby(obj/item/roguecoin/P, mob/living/user)

	. = ..()

	if(src.stopgambling == 1)
		return
	if(istype(P, /obj/item/roguecoin/gilbranze))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))	
		return
	if(istype(P, /obj/item/roguecoin))
		if(src.gamblingprice + (P.sellprice * P.quantity) > src.maxtithing)
			say("这会让起始贡金超过 [src.maxtithing] 玛门。")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		if(src.gamblingprice + (P.sellprice * P.quantity) < src.mintithing)
			say("这低于 [src.mintithing] 玛门。")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return

		else
			src.gamblingprice += (P.sellprice * P.quantity)
			qdel(P)
			src.say("你当前的贡金现在是 [src.gamblingprice] 玛门。要来转一把吗？")
			playsound(src, 'sound/misc/machinequestion.ogg', 100, FALSE, -1)
			return


/obj/structure/roguemachine/lottery_roguetown/MiddleClick(mob/living/user, params) //LET'S GO GAMBLING
//checks - is it time to go gambling??
	if(src.stopgambling == 1)
		return
	if(src.gamblingprice == 0)
		src.say(pick("心急的傻瓜；想赌掉性命，你得先有玛门。", "你还欠着什一税呢。", "没有土地的领主，根本算不上领主。"))
		src.stopgambling = 1
		sleep(20)
		src.stopgambling = 0
		return


	else
		src.diceroll = rand(1,100)
		src.say(pick("转呀转，转不停，停在哪里只有我知情。", "孩子，赛利克斯正对你的愚蠢微笑。", "命运之轮，转了又转。", "哦，你这可怜的傻瓜。", "我们之中总有一个要吃苦头。", "我笑，你哭；我泣，你欢呼……", "我来做你的小丑，为你表演……", "来赌一把吧！", "转了一圈又一圈，满眼尽是愚蠢。", "与破败和财富共舞吧。"))
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		playsound(src, 'sound/misc/letsgogambling.ogg', 100, FALSE, -1)
		src.gamblingprob += (user.STALUC - src.probpenalty)
		src.stopgambling = 1

		src.checkchatter -= 1

//thug shaker
		var/oldx = pixel_x
		animate(src, pixel_x = oldx+1, time = 1)
		animate(pixel_x = oldx-1, time = 1)
		animate(pixel_x = oldx, time = 1)
		sleep(50)

//let's actually go gambling and determine results
		if(src.gamblingprob > src.diceroll)
			src.oldtithe = src.gamblingprice
			src.gamblingprice *= pick(1.1, 1.1, 1.1, 1.1, 1.2, 1.2, 1.2, 1.4, 1.4, 2)
			src.gamblingprice = round(src.gamblingprice)

			peasant_betting()
			letsgogamblinggamblers()
			src.say(pick("运筹得当，贵族大人！你的农民什一税现在是[src.gamblingprice]玛门。再玩一次？", "今年大丰收——农民什一税涨到[src.gamblingprice]玛门了。再转我一次？",))

			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			src.gamblingprob = src.gamblingbaseprob
			src.oldtithe = src.gamblingprice //this is redundant but i feel like bad things will happen if i don't do this :T
			sleep(15)
			src.stopgambling = 0
			return

		else
			src.say(pick("十号牌，命运之轮——逆位。", "城堡。啊，凶兆！", "蝗虫的丰收……！", "看着我的眼睛，轻声诉说你的苦楚。", "哎，真该死。", "傻瓜。可怜的傻瓜。", "你的眼睛从头颅里淌出来，口水从嘴边滴落。", "神圣的愚蠢。", "你和当年的我一样；一个失败者，一个怪胎。"))
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
			sleep(20) //really make them THINK about their life choices up to this point
			src.say(pick("傻瓜之王，你的土地荒芜了。再玩一次？", "神圣的喜剧。再玩一次？", "下次一定能赢。再玩一次？", "哈哈——……啊哈哈！再来！再玩一次，小丑！", "可怜的乞丐！再转我一次？"))
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
			src.gamblingprob = src.gamblingbaseprob
			src.gamblingprice = 0
			src.oldtithe = 0
			sleep(15)
			src.stopgambling = 0
			return



/obj/structure/roguemachine/lottery_roguetown/attack_right(mob/living/user) //how the fuck do i
	. = ..()

	if(!ishuman(user))
		return
	if(src.stopgambling == 1)
		return

	else
		if(gamblingprice <= 0)
			say("可怜的小东西，你一枚硬币都没有。")
			return
		if(gamblingprice < 0)
			say("你的平民贡金是负数。")
			return
		var/list/choicez = list()
		if(gamblingprice > 10)
			choicez += "GOLD"
		if(gamblingprice > 5)
			choicez += "SILVER"
		choicez += "BRONZE"
		var/selection = input(user, "进行选择", src) as null|anything in choicez
		if(!selection)
			return
		var/mod = 1
		if(selection == "GOLD")
			mod = 10
		if(selection == "SILVER")
			mod = 5
		var/coin_amt = input(user, "大人，你有 [src.gamblingprice] 玛门贡金。你可以提取 [floor(gamblingprice/mod)] 枚[selection]币。", src) as null|num
		coin_amt = round(coin_amt)
		if(coin_amt < 1)
			return
		if(!Adjacent(user))
			return
		if(src.stopgambling == 1) // double check because it's possible to have input field open before starting gambling
			return
		if((coin_amt*mod) > gamblingprice)
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		else
			budget2change(coin_amt*mod, user, selection)
			gamblingprice -= coin_amt*mod



/obj/structure/roguemachine/lottery_roguetown/proc/peasant_betting()

	if(src.gamblingprice == oldtithe)
		src.gamblingprice += pick(1,1,1,1,2,2)


/obj/structure/roguemachine/lottery_roguetown/proc/letsgogamblinggamblers()

	if(src.checkchatter > 1) //procs any time it's under 1
		return

	if(prob(90))
		return

	chatterbox = rand(1,12)

	switch(chatterbox)
		if(1)
			src.say("我仍记得雨水落在皮肤上的感觉。")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("风吹过我的毛皮……还是头发来着？无论如何……")
			playsound(src, 'sound/misc/machinequestion.ogg', 100, FALSE, -1)
		if(2)
			src.say("崇拜神明是有害的。")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(20)
			src.say("但这惩罚还不如别人受的那么糟！哈哈哈！")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(3)
			src.say("有些命运比死亡更可怕……")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("……尤其对一个自以为是国王的卑微傻瓜而言。")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		if(4)
			src.say("当然，她没料到自己的机器会杀死她。")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("……不过，也很难说之后发生的事没有让她获益。")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		if(5)
			src.say("哦，普赛顿？")
			playsound(src, 'sound/misc/machinequestion.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("说实话，这场争论真让我普赛“顿”感厌倦！哈哈哈——……不好笑？太早了？好吧。")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(6)
			src.say("你知道吗，小丑，那些教团信众的想法倒是不错。")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("就没人替那些爱慕亡者、厌恶税收、沉迷药物的杀人犯考虑一下吗？！")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		if(7)
			src.say("……好了，别指望我陪你聊天。")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("一直都是我一个人在说。")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		if(8)
			src.say("你闻不到空气中的恶臭吗？真可怕。")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("以前可没这么糟。腐烂和脓液。唉，算了。")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		if(9)
			src.say("你闻不到空气中的恶臭吗，傻瓜？真可怕。")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("我真不懂你怎么会闻不到。腐烂和脓液。唉，算了。")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		if(10)
			src.say("也许你该见好就收，小丑。")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("……毕竟，你们这伙人正是被贪婪拖进了这场麻烦。")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		if(11)
			src.say("一位父亲和儿子坐着马车穿过森林。突然，齐佐的诅咒！车轴断了！")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("父亲死了，可儿子——儿子还活着！他被送到附近村庄的医师那里。")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("一见到他，医师就倒吸——……什么叫你早就听过这个了？")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		else
			src.say("我？我是什么大人物吗……？哦，不是。")
			playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
			sleep(25)
			src.say("我不过是个卑微的小丑，和你一样！哈哈哈！")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)

	sleep(40)
	src.checkchatter = rand(1,11) //hope he doesn't have pocket aces
