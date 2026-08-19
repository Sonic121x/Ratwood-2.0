/*	........   Reagents   ................ */// These are for the pot, if more vegetables are added and need to be integrated into the pot brewing you need to add them here
/datum/reagent/consumable/soup // so you get hydrated without the flavor system messing it up. Works like water with less hydration
	var/hydration = 6
/datum/reagent/consumable/soup/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!HAS_TRAIT(H, TRAIT_NOHUNGER))
			H.adjust_hydration(hydration)
	if(M.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		M.adjust_blood_volume(10)
	..()

/datum/reagent/consumable/soup/porridge
	name = "粥"
	description = "谷物加水煮软而成，很适合平民果腹。"
	reagent_state = LIQUID
	color = "#F8F0E3"
	nutriment_factor = 15
	metabolization_rate = 0.5 // half as fast as normal, last twice as long
	taste_description = "粥香"
	taste_mult = 3
	hydration = 2

/datum/reagent/consumable/soup/porridge/oatmeal
	name = "燕麦粥"
	description = "很适合平民的一餐。"
	taste_description = "燕麦香"
	color = "#c38553"

/datum/reagent/consumable/soup/porridge/thick
	name = "浓稠粥"
	description = "适合自耕农的一餐。"
	taste_description = "浓稠的粥香"
	color = "#9E6B43"
	nutriment_factor = 25
	alpha = 200

/datum/reagent/consumable/soup/porridge/pudding
	name = "浆果布丁粥"
	description = "适合贵族的一餐。"
	taste_description = "松软甜腻的面团感，伴着焦糖化的浆果"
	color = "#8E4074"
	nutriment_factor = 30
	metabolization_rate = 0.8
	alpha = 222
	quality = DRINK_GOOD

/datum/reagent/consumable/soup/porridge/thickpudding
	name = "浓稠浆果布丁粥"
	description = "适合国王的一餐。"
	taste_description = "松软甜腻的面团感、焦糖化的浆果，以及一丝芬芳"
	color = "#8C1564"
	nutriment_factor = 35
	metabolization_rate = 0.6
	alpha = 222
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/soup/porridge/frostedpudding
	name = "糖霜布丁粥"
	description = "适合贵族的一餐。"
	taste_description = "松软甜腻的面团感和丝绒般的糖霜"
	color = "#8C88C6"
	nutriment_factor = 35
	metabolization_rate = 0.8
	alpha = 222
	quality = DRINK_GOOD

/datum/reagent/consumable/soup/porridge/thickfrostedpudding
	name = "浓稠糖霜布丁粥"
	description = "适合国王的一餐。"
	taste_description = "松软甜腻的面团感、丝绒般的糖霜，以及一丝果香"
	color = "#604E8E"
	nutriment_factor = 40
	metabolization_rate = 0.6
	alpha = 222
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/soup/porridge/poisonfrostedpudding //Evil variant for poisoned jackberry treats.
	name = "糖霜布丁粥"
	description = "适合贵族的一餐。"
	taste_description = "松软甜腻的面团感和发苦的糖霜"
	color = "#8C88C6"
	nutriment_factor = 35
	metabolization_rate = 0.8
	alpha = 222
	quality = DRINK_GOOD

/datum/reagent/consumable/soup/porridge/thickpoisonfrostedpudding //Ditto.
	name = "浓稠糖霜布丁粥"
	description = "适合国王的一餐。"
	taste_description = "松软甜腻的面团感、发苦的糖霜，以及一丝灼烧感"
	color = "#604E8E"
	nutriment_factor = 40
	metabolization_rate = 0.6
	alpha = 222
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/soup/porridge/fudgepudding
	name = "巧克力布丁粥"
	description = "适合贵族的一餐。"
	taste_description = "松软甜腻的面团感和绵密的软糖"
	color = "#6B4A51"
	nutriment_factor = 35
	metabolization_rate = 0.8
	alpha = 222
	quality = DRINK_GOOD

/datum/reagent/consumable/soup/porridge/thickfudgepudding
	name = "浓稠巧克力布丁粥"
	description = "适合国王的一餐。"
	taste_description = "松软甜腻的面团感、绵密的软糖，以及一丝草本气息"
	color = "#44242A"
	nutriment_factor = 40
	metabolization_rate = 0.6
	alpha = 222
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/soup/porridge/congee
	name = "米粥"
	description = "把米加水煮到软烂而成。在东方，穷人和病人都会吃它；在这里，它常被视为养身食物。"
	color = "#F8F0E3"

/datum/reagent/consumable/soup/porridge/frycongee
	name = "炒米粥"
	description = "在锅里轻炒过的米饭。作为煎制食物却出奇地软，不过稍微更顶饱一些。"
	color = "#F7E2C0"
	nutriment_factor = 20
	alpha = 200

/datum/reagent/consumable/soup/veggie
	name = "蔬菜汤"
	description = "煮熟、捣碎，然后炖成一锅。"
	reagent_state = LIQUID
	nutriment_factor = 10
	taste_mult = 4
	hydration = 8

/datum/reagent/consumable/soup/veggie/potato
	name = "土豆汤"
	color = "#869256"
	taste_description = "土豆汤底"

/datum/reagent/consumable/soup/veggie/thickpotato
	name = "浓稠土豆汤"
	color = "#AE9256"
	taste_description = "绵密的土豆汤底"
	nutriment_factor = 15
	metabolization_rate = 0.8
	alpha = 200

/datum/reagent/consumable/soup/veggie/thickfrypotato
	name = "烤土豆汤"
	color = "#968563"
	taste_description = "浓稠黄油汤底里，藏着绵密可口的土豆"
	nutriment_factor = 20
	metabolization_rate = 0.8
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/veggie/onion
	name = "洋葱汤"
	color = "#a6b457"
	taste_description = "煮洋葱味"

/datum/reagent/consumable/soup/veggie/thickonion
	name = "浓稠洋葱汤"
	color = "#96924F"
	taste_description = "咸香的洋葱"
	nutriment_factor = 15
	metabolization_rate = 0.8
	alpha = 200

/datum/reagent/consumable/soup/veggie/thickfryonion
	name = "烤洋葱汤"
	color = "#B29252"
	taste_description = "清淡汤底里，藏着软糯可口的洋葱"
	nutriment_factor = 20
	metabolization_rate = 0.8
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/veggie/cabbage
	name = "卷心菜汤"
	color = "#859e56"
	taste_description = "寡淡卷心菜味"

/datum/reagent/consumable/soup/veggie/thickcabbage
	name = "浓稠卷心菜汤"
	color = "#687A43"
	taste_description = "咸香的卷心菜"
	nutriment_factor = 15
	metabolization_rate = 0.8
	alpha = 200

/datum/reagent/consumable/soup/veggie/thickfrycabbage
	name = "烤卷心菜汤"
	color = "#685D34"
	taste_description = "咸鲜汤底里，藏着浓郁可口的卷心菜"
	nutriment_factor = 15
	metabolization_rate = 0.8
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/veggie/turnip
	name = "芜菁汤"
	color = "#becf9d"
	taste_description = "煮芜菁味"

/datum/reagent/consumable/soup/veggie/thickturnip
	name = "浓稠芜菁汤"
	color = "#AFCE71"
	taste_description = "咸香的芜菁"
	nutriment_factor = 15
	metabolization_rate = 0.8
	alpha = 200

/datum/reagent/consumable/soup/purebutter
	name = "纯黄油"
	color = "#FFE88F"
	taste_description = "腻人到发指的黄油，以及体内一阵猛烈的翻腾"
	hydration = 1
	nutriment_factor = 40
	metabolization_rate = 4
	alpha = 222

/datum/reagent/consumable/soup/lemon
	name = "柠檬汁"
	color = "#FFE88F"
	taste_description = "酸得让人皱脸的明亮柠檬味"
	hydration = 8
	nutriment_factor = 8
	metabolization_rate = 1.2
	quality = DRINK_NICE

/datum/reagent/consumable/soup/lime
	name = "青柠汁"
	color = "#BAE88F"
	taste_description = "酸得让人皱脸的明亮青柠味"
	hydration = 8
	nutriment_factor = 8
	metabolization_rate = 1.2
	quality = DRINK_NICE

/datum/reagent/consumable/soup/pear
	name = "梨汁"
	color = "#BAAE8F"
	taste_description = "清爽脆甜的梨味"
	hydration = 8
	nutriment_factor = 8
	metabolization_rate = 1.2
	quality = DRINK_NICE

/datum/reagent/consumable/soup/apple
	name = "苹果汁"
	color = "#E0BE6D"
	taste_description = "清爽脆甜的苹果味"
	hydration = 8
	nutriment_factor = 8
	metabolization_rate = 1.2
	quality = DRINK_NICE

/datum/reagent/consumable/soup/tangerine_marmalade
	name = "柑橘汁"
	color = "#f0935d"
	taste_description = "甜到极致的柑橘味"
	hydration = 8
	nutriment_factor = 8
	metabolization_rate = 1.2
	quality = DRINK_NICE

/datum/reagent/consumable/soup/bone_broth
	name = "骨头汤"
	color = "#7F6556"
	taste_description = "滋养身心的温暖"
	nutriment_factor = 10
	hydration = 10
	metabolization_rate = 0.6

//

/datum/reagent/consumable/soup/stew
	name = "浓炖"
	description = "凡是能入口的料头，几乎都被炖进这里面了。"
	reagent_state = LIQUID
	nutriment_factor = 20
	taste_mult = 4

/datum/reagent/consumable/soup/stew/hardtack
	name = "硬饼干炖汤"
	description = "适合士兵的一餐。"
	taste_description = "咸味粥糊里泡软的脆片"
	color = "#9E6B43"
	nutriment_factor = 15
	alpha = 200

/datum/reagent/consumable/soup/stew/hardtacksalo
	name = "肥膘硬饼炖汤"
	description = "适合冒险者的一餐。"
	taste_description = "咸味粥糊、酥脆的肉块，以及格外油润的汤底"
	color = "#9E4643"
	nutriment_factor = 15
	metabolization_rate = 0.4 //Lowest nutriment factor for stew, but sticks to your guts like proper comfort food.
	alpha = 220

/datum/reagent/consumable/soup/stew/thickhardtacksalo
	name = "浓稠肥膘硬饼炖汤"
	description = "适合传奇人物的一餐。"
	taste_description = "浓稠的咸味粥糊、酥脆的肉块、油润的汤底，以及喉间久久不散的暖意"
	color = "#7A3534"
	nutriment_factor = 20
	metabolization_rate = 0.4 //Lowest nutriment factor for stew, but sticks to your guts like proper comfort food.
	alpha = 220

/datum/reagent/consumable/soup/stew/egg
	name = "蛋花汤"
	color = "#dedbaf"
	taste_description = "蛋汤味"

/datum/reagent/consumable/soup/stew/fryegg
	name = "浓稠蛋花汤"
	color = "#DDC689"
	taste_description = "绵密的蛋汤"
	nutriment_factor = 30
	metabolization_rate = 1.2 //A little quicker, for breakfast!

/datum/reagent/consumable/soup/stew/thickfryegg
	name = "炒蛋杂烩炖汤"
	color = "#B78F71"
	taste_description = "绵密的蛋块伴着酥脆肉丁"
	nutriment_factor = 35
	metabolization_rate = 1.2 //A little quicker, for breakfast!
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/lavishfryegg
	name = "奢华蛋杂烩炖汤"
	color = "#B5934A"
	taste_description = "丰盛绵密的蛋块、酥脆肉丁和浓郁的奶酪美味"
	nutriment_factor = 40
	metabolization_rate = 1.2 //A little quicker, for breakfast!
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/cheese
	name = "奶酪浓汤"
	description = "浓稠的奶酪汤，口感绵密，喝下去很是熨帖。"
	color = "#c4be70"
	taste_description = "绵密奶酪味"

/datum/reagent/consumable/soup/stew/thickcheese
	name = "奶酪火锅"
	description = "浓稠得离谱的奶酪汤。绵密、熨帖，奢侈至极。"
	color = "#c4be70"
	taste_description = "丝绒般的奶酪"
	nutriment_factor = 30 //You're throwing an entire wheel of cheese into this thing. It'd be criminal if you didn't get something in return!
	metabolization_rate = 0.6
	quality = DRINK_GOOD
	alpha = 222

/datum/reagent/consumable/soup/stew/parmesan
	name = "陈年奶酪汤"
	description = "一碗浓稠的陈年奶酪汤。绵密而熨帖。"
	color = "#A8AA70"
	taste_description = "绵密的陈年奶酪"
	metabolization_rate = 0.8

/datum/reagent/consumable/soup/stew/thickparmesan
	name = "陈年奶酪火锅"
	description = "浓稠得离谱的陈年奶酪汤。绵密、熨帖，奢侈至极。"
	color = "#A8AA70"
	taste_description = "丝绒般的陈年奶酪"
	metabolization_rate = 0.6
	nutriment_factor = 40
	quality = DRINK_VERYGOOD
	alpha = 222

/datum/reagent/consumable/soup/stew/chicken
	name = "鸡肉炖汤"
	color = "#baa21c"
	taste_description = "鸡肉味"

/datum/reagent/consumable/soup/stew/thickchicken
	name = "浓稠鸡肉炖汤"
	color = "#BA841C"
	taste_description = "咸香的鸡肉"
	nutriment_factor = 30

/datum/reagent/consumable/soup/stew/bakedchicken
	name = "炸鸟排炖汤"
	color = "#A0781C"
	taste_description = "咸香的鸡肉伴着酥脆的鸡皮碎"
	metabolization_rate = 0.8
	quality = DRINK_NICE

/datum/reagent/consumable/soup/stew/bakedthickchicken
	name = "浓稠炸鸟排炖汤"
	color = "#8F6119"
	taste_description = "鲜嫩的鸡肉伴着酥脆的鸡皮碎"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/veggiethickchicken
	name = "蔬菜炸鸟排炖汤"
	color = "#8F6916"
	taste_description = "咸香的鸡肉、慢烤蔬菜、酥脆的鸡皮碎，以及一丝久久不散的暖意"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/pepperchicken
	name = "胡椒辛香炸鸟排炖汤"
	color = "#A0421C"
	taste_description = "鲜嫩可口的鸡肉、酥脆的鸡皮碎，以及一丝让舌尖发麻的辛味"
	nutriment_factor = 35
	metabolization_rate = 0.8
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/lavishchicken
	name = "奢华炸鸟排炖汤"
	color = "#A0421C"
	taste_description = "丰盛鲜嫩的鸡肉、酥脆的鸡皮碎、黄油般的醇厚，以及一丝让舌尖发麻的辛味"
	nutriment_factor = 40
	metabolization_rate = 0.6
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/meat
	name = "肉炖汤"
	color = "#80432a"
	taste_description = "肉香"

/datum/reagent/consumable/soup/stew/frymeat
	name = "慢炖肉汤"
	color = "#7F3518"
	taste_description = "慢火烤制的肉香"
	metabolization_rate = 0.8
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/stew/veggiefrymeat
	name = "蔬菜慢炖肉汤"
	color = "#633012"
	taste_description = "咸香的肉块、慢烤蔬菜，以及清新浓郁的余味"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/pepperfrymeat
	name = "胡椒辛香慢炖肉汤"
	color = "#892214"
	taste_description = "鲜嫩可口的肉块，以及一丝让舌尖发麻的辛味"
	nutriment_factor = 35
	metabolization_rate = 0.8
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/lavishfrymeat
	name = "奢华慢炖肉汤"
	color = "#722616"
	taste_description = "丰盛鲜嫩的肉块、浓郁咸鲜的汤底，以及一丝让舌尖发麻的辛味"
	nutriment_factor = 40
	metabolization_rate = 0.6
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/pork
	name = "肥肉炖汤"
	color = "#80432a"
	taste_description = "软嫩咸香的猪肉"

/datum/reagent/consumable/soup/stew/thickpork
	name = "肥美慢炖肉汤"
	color = "#7F3518"
	taste_description = "慢火烤制的猪肉香"
	metabolization_rate = 0.8

/datum/reagent/consumable/soup/stew/frypork
	name = "酥脆肥肉炖汤"
	color = "#633012"
	taste_description = "咸香的猪肉伴着酥脆碎"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/stew/thickfrypork
	name = "酥脆肥美慢炖肉汤"
	color = "#892214"
	taste_description = "入口即化的软嫩猪肉伴着酥脆碎"
	nutriment_factor = 35
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/viscera_broth
	name = "下水炖汤"
	color = "#B65571"
	taste_description = "味道强烈得怪异，带着一丝咸鲜的余味"
	nutriment_factor = 15

/datum/reagent/consumable/soup/stew/slop
	name = "泔水"
	color = "#18130E"
	taste_description = "烧焦的杂碎带着砂砾般的余味，还有一丝后悔"
	nutriment_factor = 10

/datum/reagent/consumable/soup/stew/fish
	name = "鱼炖汤"
	color = "#c7816e"
	taste_description = "鱼鲜味"

/datum/reagent/consumable/soup/stew/fryfish
	name = "烤鱼炖汤"
	color = "#C6725D"
	taste_description = "轻柔绵密的汤底里，躺着层层分明的鱼肉"
	nutriment_factor = 25
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/stew/veggiefryfish
	name = "蔬菜烤鱼炖汤"
	color = "#C67C78"
	taste_description = "轻柔绵密的汤底里，躺着层层分明的鱼肉与慢烤蔬菜"
	nutriment_factor = 30
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/pepperfryfish
	name = "胡椒辛香鱼炖汤"
	color = "#C65D5D"
	taste_description = "锐利绵密的汤底里，躺着层层分明的鱼肉与让舌尖发麻的香料"
	nutriment_factor = 35
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/lavishfryfish
	name = "奢华鱼炖汤"
	color = "#C17070"
	taste_description = "丰盛绵密的汤底里，躺着层层分明的鱼肉，带着微妙的甜意"
	nutriment_factor = 40
	metabolization_rate = 0.8
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/evilfryfish
	name = "邪恶鱼炖汤"
	color = "#FF3200"
	taste_description = "铺天盖地的恐惧感、进步的窃窃私语，以及出乎意料的浓郁余味"
	nutriment_factor = 66
	metabolization_rate = 6

/datum/reagent/consumable/soup/stew/rabbit
	name = "卡比特炖汤"
	color = "#c59182"
	taste_description = "卡比特肉味"

/datum/reagent/consumable/soup/stew/fryrabbit
	name = "烤卡比特炖汤"
	color = "#BC7A6F"
	taste_description = "慢火烤制的卡比特肉，带着出乎意料的宜人余味"
	metabolization_rate = 0.8
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/stew/veggiefryrabbit
	name = "蔬菜烤卡比特炖汤"
	color = "#A35D46"
	taste_description = "咸香的卡比特肉、焦糖化的蔬菜，以及醇厚而收敛的余味"
	metabolization_rate = 0.8
	nutriment_factor = 30
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/volf
	name = "沃尔夫炖汤"
	color = "#80432a"
	taste_description = "野味十足的肉"

/datum/reagent/consumable/soup/stew/fryvolf
	name = "沃尔夫烤肉炖汤"
	color = "#7F3518"
	taste_description = "慢火烤制、野味十足的肉"
	metabolization_rate = 0.8
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/stew/veggiefryvolf
	name = "蔬菜沃尔夫烤肉炖汤"
	color = "#633012"
	taste_description = "咸鲜野味的肉块、慢烤蔬菜，以及令人愉悦的温热余味"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/kingvolf
	name = "国王炖汤"
	color = "#892214"
	taste_description = "软嫩野味的肉块、爽脆的蔬菜，以及一丝让舌尖发麻的辛味"
	nutriment_factor = 35
	metabolization_rate = 0.8
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/bisque
	name = "浓海鲜汤"
	color = "#FFA74F" // Bisque like color I know bisque's more complicated than that 
	taste_description = "贝甲鲜味"

/datum/reagent/consumable/soup/stew/frybisque
	name = "烤浓海鲜汤"
	color = "#ffb74f"
	taste_description = "烤制的贝类，安卧在咸鲜顺滑的汤海之中"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/lavishfrybisque
	name = "奢华浓海鲜汤"
	color = "#FFC688"
	taste_description = "丰盛的烤贝类、咸鲜顺滑的汤底，以及一丝辛香黄油的醇厚"
	nutriment_factor = 35
	metabolization_rate = 0.6
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/seafoodbroil
	name = "海烩浓汤"
	color = "#FFA74F"
	taste_description = "绵密的贝肉，偶尔来一点脆响"
	nutriment_factor = 25
	alpha = 200

/datum/reagent/consumable/soup/stew/fryseafoodbroil
	name = "烤海烩浓汤"
	color = "#ffb74f"
	taste_description = "绵密细腻的汤底里，躺着烤制的贝肉"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 222

/datum/reagent/consumable/soup/stew/lavishfryseafoodbroil
	name = "奢华海烩浓汤"
	color = "#FFE3D9"
	taste_description = "丰盛绵密的汤底，带着一丝湿润的蛤肉味"
	nutriment_factor = 35
	metabolization_rate = 0.6
	quality = DRINK_VERYGOOD
	alpha = 222

/datum/reagent/consumable/soup/stew/meatrice
	name = "烤肉炒米粥"
	color = "#E5C099"
	taste_description = "软烂咸鲜的米粥，伴着大块嫩肉"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 250

/datum/reagent/consumable/soup/stew/eggrice
	name = "鸡蛋炒米粥"
	color = "#F7C997"
	taste_description = "软烂咸鲜的米粥，伴着绵密的蛋黄和酥脆的蛋块"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 250

/datum/reagent/consumable/soup/stew/shrimprice
	name = "烤虾炒米粥"
	color = "#F7D5BE"
	taste_description = "软烂咸鲜的米粥，伴着咸鲜而克制的贝肉"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 250

/datum/reagent/consumable/soup/stew/cheeserice
	name = "融酪炒米粥"
	color = "#F7E297"
	taste_description = "软烂咸鲜的米粥，被浓郁的奶酪美味浸透"
	nutriment_factor = 25
	metabolization_rate = 0.6
	quality = DRINK_NICE
	alpha = 250

/datum/reagent/consumable/soup/stew/lavishfryrice
	name = "奢华慢炖肉米粥"
	color = "#E0AF97"
	taste_description = "丰盛如枕的米粥，伴着慢炖肉块，带着一丝黄油与奶酪的气息"
	nutriment_factor = 35
	metabolization_rate = 0.6
	quality = DRINK_VERYGOOD
	alpha = 250

/datum/reagent/consumable/soup/stew/yucky
	name = "怪味炖汤"
	color = "#9e559c"
	taste_description = "强烈得压倒一切的怪味，带着一丝微妙的酸涩余味"

/datum/reagent/consumable/soup/stew/fryyucky
	name = "怪味慢炖肉汤"
	color = "#9E6D84"
	taste_description = "一块令人愉悦的硬气肉，介于沃尔夫肉与鸡肉之间"
	nutriment_factor = 30
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/stew/berry
	name = "浆果炖汤"
	color = "#863333"
	taste_description = "甜浆果味"

/datum/reagent/consumable/soup/stew/berry_poisoned
	name = "浆果炖汤"
	color = "#863333"
	taste_description = "苦得可疑的浆果味"

/datum/reagent/consumable/soup/stew/garlick_soup
	name = "蒜汤"
	color = "#FAF9F6"
	taste_description = "通窍的清爽"

/datum/reagent/consumable/soup/stew/cucumber_soup
	name = "黄瓜汤"
	color = "#98fb98"
	taste_description = "丰盈的黄瓜"

/datum/reagent/consumable/soup/stew/thickcucumber_soup
	name = "浓稠黄瓜汤"
	color = "#98fb98"
	taste_description = "浓郁而厚实的黄瓜"
	nutriment_factor = 25

/datum/reagent/consumable/soup/stew/eggplant_soup
	name = "茄子汤"
	color = "#fff8e3"
	taste_description = "鲜美的茄子"

/datum/reagent/consumable/soup/stew/aubergine_soup
	name = "茄丁炖汤"
	color = "#D9E4E3"
	taste_description = "软嫩的茄子伴着烤碎肉丁"
	nutriment_factor = 25
	metabolization_rate = 0.8
	quality = DRINK_NICE

/datum/reagent/consumable/soup/stew/lavishaubergine_soup
	name = "奢华茄丁炖汤"
	color = "#D9C6E3"
	taste_description = "丰盛软嫩的茄子、烤碎肉丁，以及绵密的汤底"
	nutriment_factor = 35
	metabolization_rate = 0.6
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/carrot_stew
	name = "胡萝卜炖汤"
	color = "#f26818"
	taste_description = "咸香的胡萝卜"

/datum/reagent/consumable/soup/stew/thickcarrot_stew
	name = "烤胡萝卜炖汤"
	color = "#f26818"
	taste_description = "咸香而焦糖化的胡萝卜"
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/stew/nutty_stew
	name = "坚果炖汤"
	color = "#807b78"
	taste_description = "坚果香"

/datum/reagent/consumable/soup/stew/tomato_soup
	name = "番茄汤"
	color = "#db5230"
	taste_description = "家的味道"
	metabolization_rate = 0.5 // half as fast as normal, last twice as long - it is the best soup after all

/datum/reagent/consumable/soup/stew/plum_soup
	name = "李子汤"
	color = "#9c305b"
	taste_description = "甜李子味"

/datum/reagent/consumable/soup/stew/squash_soup
	name = "南瓜汤"
	color = "#C98C42"
	taste_description = "秋日般的温暖怀抱"
	metabolization_rate = 0.8
	nutriment_factor = 15

/datum/reagent/consumable/soup/stew/frysquash_soup
	name = "烤南瓜汤"
	color = "#D3702E"
	taste_description = "胸中燃起的炉火般的暖意，以及宜人的咸鲜余味"
	metabolization_rate = 0.8
	nutriment_factor = 20
	quality = DRINK_NICE

/datum/reagent/consumable/soup/stew/survival_broth
	name = "砖汤"
	color = "#693346"
	taste_description = "暖心暖胃的浓稠咸香，偶尔迸出丝丝甜意与辛香"
	nutriment_factor = 30
	alpha = 222

/datum/reagent/consumable/soup/stew/thicksurvival_broth
	name = "浓稠砖汤"
	color = "#681936"
	taste_description = "暖心暖胃的浓稠咸鲜，迸发着甜意与辛香"
	nutriment_factor = 45
	alpha = 250

/datum/reagent/consumable/soup/stew/saltmeat_stew
	name = "咸肉炖汤"
	color = "#693346"
	taste_description = "咸得压倒一切，带着一丝咸鲜与肉香"
	nutriment_factor = 20
	alpha = 250

// Copy pasted from berry poison, but stew metabolizes much faster so it is less deadly. You CAN use it as a source of hydration / nutrition if you are desperate enough???
/datum/reagent/consumable/soup/stew/berry_poisoned/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(0.5)
		else
			M.add_nausea(3) // so one berry or one dose (one clunk of extracted poison, 5u) will make you really sick and a hair away from crit.
			M.adjustToxLoss(2)
	return ..()

/datum/reagent/consumable/soup/porridge/poisonfrostedpudding/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(0.5)
		else
			M.add_nausea(3)
			M.adjustToxLoss(2)
	return ..()

/datum/reagent/consumable/soup/porridge/thickpoisonfrostedpudding/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(0.5)
		else
			M.add_nausea(3)
			M.adjustToxLoss(2)
	return ..()

/datum/reagent/consumable/soup/stew/slop/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(0.5)
		else
			M.add_nausea(3) // Slightly less lethal than eating actual poison.
			M.adjustToxLoss(1)
	return ..()

/datum/reagent/consumable/soup/purebutter/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(0.5)
		else
			M.add_nausea(3) // Slightly less lethal than eating actual poison.
			M.adjustToxLoss(0.5)
	return ..()

// Chicken stew functions like a lesser health potion. Why? Well, because what's a better way to nurse away a cold - or life-threatening wound - with some delicious chicken soup?
/datum/reagent/consumable/soup/stew/chicken/on_mob_life(mob/living/carbon/M)
	M.energy_add(1)
	if(M.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		M.adjust_blood_volume(1)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustFireLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustOxyLoss(-0.1, FALSE)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
	..()

/datum/reagent/consumable/soup/stew/bakedchicken/on_mob_life(mob/living/carbon/M)
	M.energy_add(1)
	if(M.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		M.adjust_blood_volume(2)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.15  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustFireLoss(-0.15 * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustOxyLoss(-0.15, FALSE)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.15  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.15  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
	..()

/datum/reagent/consumable/soup/stew/thickchicken/on_mob_life(mob/living/carbon/M)
	M.energy_add(1)
	if(M.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		M.adjust_blood_volume(2)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.15  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustFireLoss(-0.15 * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustOxyLoss(-0.15, FALSE)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.15  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.15  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
	..()

/datum/reagent/consumable/soup/stew/bakedthickchicken/on_mob_life(mob/living/carbon/M)
	M.energy_add(1)
	if(M.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		M.adjust_blood_volume(3)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.2  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustFireLoss(-0.2 * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustOxyLoss(-0.15, FALSE)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.2  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.2  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
	..()

/datum/reagent/consumable/soup/stew/veggiethickchicken/on_mob_life(mob/living/carbon/M)
	M.energy_add(1)
	if(M.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		M.adjust_blood_volume(3)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.2  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustFireLoss(-0.2  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustOxyLoss(-0.15, FALSE)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.2  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.2  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
	..()

/datum/reagent/consumable/soup/stew/pepperchicken/on_mob_life(mob/living/carbon/M)
	M.energy_add(1)
	if(M.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		M.adjust_blood_volume(4)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.25  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustFireLoss(-0.25  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustOxyLoss(-0.15, FALSE)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.25  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.25  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
	..()

/datum/reagent/consumable/soup/stew/lavishchicken/on_mob_life(mob/living/carbon/M)
	M.energy_add(1)
	if(M.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		M.adjust_blood_volume(5)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(2)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustFireLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
		M.adjustOxyLoss(-0.15, FALSE)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER, FALSE)
	..()
