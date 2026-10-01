// For storing roguebin and fermenting barrel or something

// Bin
/obj/item/roguebin/water/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/water,500)
	update_icon()

/obj/item/roguebin/water/gross/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/water/gross,500)
	update_icon()

// Water
/obj/structure/fermentation_keg/random/water
	name = "水桶"

/obj/structure/fermentation_keg/random/water/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/water, rand(0,900))

/obj/structure/fermentation_keg/random/beer/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, rand(0,900))

/obj/structure/fermentation_keg/water
	name = "水桶"

/obj/structure/fermentation_keg/water/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/water,900)

/obj/structure/fermentation_keg/beer
	desc = "一只装着普通自酿啤酒的木桶，酒劲较低。"

/obj/structure/fermentation_keg/beer/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, 900)


// Alcohol 
/obj/structure/fermentation_keg/zagul
	desc = "一只带有海岸扎古尔标记的木桶。里面是本地酒坊出产的扎古尔酿，一种极其廉价的拉格啤酒。"

/obj/structure/fermentation_keg/zagul/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/zagul,900)

/obj/structure/fermentation_keg/blackgoat
	desc = "一只带有黑山羊克里克纹章的木桶。里面是用杰克莓酿成的酸果啤酒，口感酸爽。"

/obj/structure/fermentation_keg/blackgoat/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/blackgoat,900)

/obj/structure/fermentation_keg/hagwoodbitter
	desc = "一只带有鬼木苦啤纹章的木桶。这大概是从被格伦泽尔霍夫特占领的佐恩地区出口的东西里，最不苦的一样。"

/obj/structure/fermentation_keg/hagwoodbitter/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/hagwoodbitter,900)



/obj/structure/fermentation_keg/jagt
	desc = "一只带有赛加雄鹿标记的木桶。里面的深色猎饮是目前能弄到的、产自格伦泽尔霍夫特最烈的酒。这种草本烈酒，足以把任何病都烧出去。"

/obj/structure/fermentation_keg/jagt/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/jagdtrunk,900)

/obj/structure/fermentation_keg/sourwine
	desc = "一只装着格伦泽尔霍夫特经典酸酒的木桶。里面是以矿泉水稀释过的极酸葡萄酒。"

/obj/structure/fermentation_keg/sourwine/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/sourwine,900)

/obj/structure/fermentation_keg/whitewine
	desc = "一只装着奥塔瓦奢侈酒品的木桶。里面是口感偏甜的白葡萄酒，常用来衬托并增强食物的鲜香。年份越稀有，就越难寻得。越靠近王都，原料的名称往往也越浮夸。"

/obj/structure/fermentation_keg/whitewine/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/whitewine,900)

/obj/structure/fermentation_keg/redwine
	desc = "一只装着奥塔瓦奢侈酒品的木桶。里面的红葡萄酒最初用于普赛顿圣餐，后来在奥塔瓦广受喜爱，几乎每顿饭都会拿它佐餐。"

/obj/structure/fermentation_keg/redwine/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/redwine,900)


/obj/structure/fermentation_keg/onion
	desc = "一只令人意外地没有制造者标记的木桶。木头上刻着\"ONI-N\"，其中的字母\"O\"似乎被彻底刮掉了。可疑。桶身还贴着一张纸，上面画着一群老鼠在抵挡成堆乞丐、守卫满是酒瓶地窖的图案。"

/obj/structure/fermentation_keg/onion/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/onion,900)

/obj/structure/fermentation_keg/saigamilk
	desc = "一只带有奔跑赛加标记的木桶。里面是用赛加奶和盐酿成的博欣阿尔希，乃草原游牧民的常见饮品。"

/obj/structure/fermentation_keg/saigamilk/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/saigamilk,900)

/obj/structure/fermentation_keg/kgsunsake
	desc = "一只带有金天鹅标记的木桶。里面是以稻米酿成的半透明浅蓝色纯米吟酿，深受风玄军阀与贵族喜爱。"

/obj/structure/fermentation_keg/kgsunsake/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/kgunsake,900)


/obj/structure/fermentation_keg/avarrice
	desc = "一只带有简单标记的木桶。里面是用阿瓦尔草原所产稻米酿制的马克科利尔，一种浑浊的白色米酒。"

/obj/structure/fermentation_keg/avarrice/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/avarrice,900)


/obj/structure/fermentation_keg/gronmead
	desc = "一只带有盾少女酒坊标记的木桶。里面是深红色的拉格纳酿蜜酒，以格隆高地特产的红莓精制而成。"

/obj/structure/fermentation_keg/gronmead/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/gronnmead,900)

/obj/structure/fermentation_keg/coffee
	desc = "一只带有咖啡杯标记的木桶。里面是浓烈苦涩的咖啡，能让身心恢复活力。"

/obj/structure/fermentation_keg/coffee/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/caffeine/coffee, 900)

/obj/structure/fermentation_keg/tea
	desc = "一只写着几个风玄文字的木桶，标明了桶内茶叶的年份。茶是一种温和清爽、能让身心平静的饮品。希望装在木桶里储存后，\
	它的品质依然完好。"

/obj/structure/fermentation_keg/tea/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/caffeine/tea, 900)

/obj/structure/fermentation_keg/rose_tea
	desc = "一只带有玫瑰标记的木桶。里面是用玫瑰泡制的普通玫瑰茶，清爽安神，并有轻微的恢复效果。"

/obj/structure/fermentation_keg/rose_tea/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/water/rosewater, 900)
