#define BLUEPRINT_LIBRARY_FILE "data/blueprint_library.json"
var/global/list/blueprint_library_cache = load_blueprint_library()
GLOBAL_LIST_INIT(blueprint_buildable_types, init_blueprint_buildable_types())

/proc/init_blueprint_buildable_types()
	var/list/temp_types = list(
	"wood_floor" = list(
		"name" = "木地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/ruinedwood,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "wooden_floor"
	),
	"wood_floor_polished" = list(
		"name" = "抛光木地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/wood,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/floor,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "wooden_floor2"
	),
	"floor_herringbone_weathered" = list(
		"name" = "风化人字纹地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/ruinedwood/herringbone,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/floorhw,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "herringbonewood"
	),
	"floor_herringbone_stamped" = list(
		"name" = "压纹人字纹地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/ruinedwood/chevron,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/floorhs,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "weird2"
	),
	"floor_slanted" = list(
		"name" = "斜纹木地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/ruinedwood/spiral,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/floorslanted,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "weird1"
	),
	"platform_wood" = list(
		"name" = "木平台",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/ruinedwood/platform,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/platform,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "wooden_floor"
	),
	"floor_hay" = list(
		"name" = "干草地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/hay,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/hay,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "hay"
	),
	"floor_twig" = list(
		"name" = "树枝地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/twig,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/twig,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "twig"
	),
	"platform_twig" = list(
		"name" = "树枝平台",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/twig/platform,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/twigplatform,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "twig"
	),
	"stone_floor" = list(
		"name" = "石块地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/blocks,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/block,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "blocks"
	),
	"stone_floor_new" = list(
		"name" = "新石地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/blocks/newstone/alt,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/newstone,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "bluestone"
	),
	"stone_hex_floor" = list(
		"name" = "六角石地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/hexstone,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/hexstone,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "hexstone"
	),
	"stone_herringbone_floor" = list(
		"name" = "人字纹石地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/herringbone,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/herringbone,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "herringbone"
	),
	"cobblestone_floor" = list(
		"name" = "鹅卵石地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/cobble,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/cobble,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "cobblestone1"
	),
	"cobblerock_road" = list(
		"name" = "块石路面",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/cobblerock,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/cobblerock,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "cobblerock"
	),
	"redstone_floor" = list(
		"name" = "大块红石地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/blocks/stonered,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/redstone,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "stoneredlarge"
	),
	"tiny_redstone_floor" = list(
		"name" = "小块红石地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/blocks/stonered/tiny,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/tinyredstone,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "stoneredtiny"
	),
	"marble_floor" = list(
		"name" = "大理石地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/churchmarble,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/marblefloor,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "church_marble"
	),
	"bluestone_slabs" = list(
		"name" = "青石板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/blocks/bluestone,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/bluestone2,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "bluestone2"
	),
	"concrete_slab" = list(
		"name" = "大石板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/concrete,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/concreteslab,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "concretefloor1"
	),
	"floor_masonic" = list(
		"name" = "石匠装饰地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/tile/masonic,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/masonic,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "masonic"
	),
	"floor_masonic_alt" = list(
		"name" = "石匠反色地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/tile/masonic/inverted,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/masonicalt,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "masonicsingleinvert"
	),
	"floor_masonic_spiral" = list(
		"name" = "石匠螺旋地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/tile/masonic/spiral,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/masonicspiral,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "masonicspiral"
	),
	"floor_blue_tiles" = list(
		"name" = "蓝色大地砖",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/tile/bfloorz,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/bluelargetile,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "bfloorz"
	),
	"floor_church_red_brick" = list(
		"name" = "红色石匠砖",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/churchbrick,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/churchredbrick,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "church_brick"
	),
	"floor_harem_green" = list(
		"name" = "后宫绿砖",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/tile/harem1,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/haremgreenbricks,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "harem1"
	),
	"floor_harem_red" = list(
		"name" = "后宫红砖",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/tile/harem,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/haremredbricks,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "harem"
	),
	"floor_harem_pink" = list(
		"name" = "后宫粉砖",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/tile/harem2,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/harempink,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "harem2"
	),
	"floor_brick" = list(
		"name" = "砖地板",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/tile/brick,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/brick/floor,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "bricktile"
	),
	"druid_grass" = list(
		"name" = "德鲁伊草地",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/grass,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/druidic_grass/grass,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "grass"
	),
	"druid_grass_red" = list(
		"name" = "红色德鲁伊草地",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/grassred,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/druidic_grass/grassred,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "grass_red"
	),
	"druid_grass_yellow" = list(
		"name" = "黄色德鲁伊草地",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/grassyel,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/druidic_grass/grassyel,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "grass_yel"
	),
	"druid_grass_cold" = list(
		"name" = "寒地德鲁伊草地",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/grasscold,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/druidic_grass/grasscold,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "grass_cold"
	),
	"druid_grass_desert" = list(
		"name" = "沙漠草地",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/desert_grass,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/druidic_grass/desert_grass,
		"icon_file" = 'modular_deserttown/icons/desertfloor.dmi',
		"icon_state" = "desertgrass"
	),
	"druid_grass_purple" = list(
		"name" = "紫色德鲁伊草地",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/rogue/grasspurple,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/druidic_grass/grasspurple,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "grass_purple"
	),
	"carpet_inn" = list(
		"name" = "旅店地毯",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/carpet/inn,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/carpet,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "carpet"
	),
	"carpet_purple" = list(
		"name" = "紫色地毯",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/carpet/purple,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/carpet/purple,
		"icon_file" = 'icons/turf/floors/carpet_purple.dmi',
		"icon_state" = "carpet"
	),
	"carpet_red" = list(
		"name" = "红色地毯",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/carpet/red,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/carpet/red,
		"icon_file" = 'icons/turf/floors/carpet_red.dmi',
		"icon_state" = "carpet"
	),
	"carpet_royal" = list(
		"name" = "皇家黑色地毯",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/carpet/royalblack,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/carpet/royalblack,
		"icon_file" = 'icons/turf/floors/carpet_royalblack.dmi',
		"icon_state" = "carpet"
	),
	"carpet_stellar" = list(
		"name" = "星辰地毯",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /turf/open/floor/carpet/stellar,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/carpet/stellar,
		"icon_file" = 'icons/turf/floors/carpet_stellar.dmi',
		"icon_state" = "carpet"
	),
	"bear_rug" = list(
		"name" = "熊皮地毯",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /obj/structure/bearpelt,
		"reqs" = /datum/crafting_recipe/roguetown/structure/bearrug,
		"icon_file" = 'icons/turf/floors/bear.dmi',
		"icon_state" = "bear"
	),
	"fox_rug" = list(
		"name" = "狐皮地毯",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /obj/structure/foxpelt,
		"reqs" = /datum/crafting_recipe/roguetown/structure/foxrug,
		"icon_file" = 'icons/turf/floors/animal_rugs.dmi',
		"icon_state" = "fox"
	),
	"lynx_rug" = list(
		"name" = "山猫皮地毯",
		"category" = "Floors & Pathways",
		"layer_type" = "floor",
		"build_order" = 1,
		"path" = /obj/structure/bobcatpelt,
		"reqs" = /datum/crafting_recipe/roguetown/structure/bobcatrug,
		"icon_file" = 'icons/turf/floors/animal_rugs.dmi',
		"icon_state" = "bobcat"
	),
	"wood_wall" = list(
		"name" = "木墙",
		"category" = "Walls & Roofs",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/wood,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/wall,
		"icon_file" = 'icons/turf/walls/roguewood.dmi',
		"icon_state" = "wood"
	),
	"wood_wall_fancy" = list(
		"name" = "精致木墙",
		"category" = "Walls & Roofs",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/decowood,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/fancy,
		"icon_file" = 'icons/turf/roguewall.dmi',
		"icon_state" = "decowood"
	),
	"wood_wall_dark" = list(
		"name" = "深色木墙",
		"category" = "Walls & Roofs",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/wooddark,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/darkwoodwall,
		"icon_file" = 'icons/turf/walls/roguewood.dmi',
		"icon_state" = "wood"
	),
	"tent_wall" = list(
		"name" = "帐篷墙",
		"category" = "Walls & Roofs",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/tent,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/tentwall,
		"icon_file" = 'icons/turf/roguewall.dmi',
		"icon_state" = "tent"
	),
	"stone_wall" = list(
		"name" = "石墙",
		"category" = "Walls & Roofs",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/stone,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/wall,
		"icon_file" = 'icons/turf/walls/stone_wall.dmi',
		"icon_state" = "stone"
	),
	"stone_wall_brick" = list(
		"name" = "石砖墙",
		"category" = "Walls & Roofs",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/stonebrick,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/brick,
		"icon_file" = 'icons/turf/walls/stonebrick.dmi',
		"icon_state" = "stonebrick"
	),
	"stone_wall_brick_light" = list(
		"name" = "石砖墙（带灯笼）",
		"category" = "Walls & Roofs",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/stonebrick/stonebricklight,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/brick/bricklight,
		"icon_file" = 'icons/turf/walls/stonebrick.dmi',
		"icon_state" = "stonebrick"
	),
	"stone_wall_craft" = list(
		"name" = "砌筑石墙",
		"category" = "Walls & Roofs",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/craftstone,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/craft,
		"icon_file" = 'icons/turf/walls/craftstone.dmi',
		"icon_state" = "box"
	),
	"stone_wall_deco" = list(
		"name" = "装饰石墙",
		"category" = "Walls & Roofs",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/decostone,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/decorated,
		"icon_file" = 'icons/turf/roguewall.dmi',
		"icon_state" = "decostone-b"
	),
	"brick_wall" = list(
		"name" = "砖墙",
		"category" = "Walls & Roofs",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/brick,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/brick/wall,
		"icon_file" = 'icons/turf/walls/brick_wall.dmi',
		"icon_state" = "brick"
	),
	"roof_wood" = list(
		"name" = "木屋顶",
		"category" = "Walls & Roofs",
		"layer_type" = "wall",
		"build_order" = 4,
		"path" = /turf/open/floor/rogue/rooftop,
		"reqs" = list(/obj/item/natural/wood/plank = 1),
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "roof"
	),
	"wood_window_murderhole" = list(
		"name" = "木制射孔",
		"category" = "Windows & Glass",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/wood/window,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/murderhole,
		"icon_file" = 'icons/turf/walls/roguewood.dmi',
		"icon_state" = "woodwindow"
	),
	"dark_wood_window_murderhole" = list(
		"name" = "深色木制射孔",
		"category" = "Windows & Glass",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/wooddark/window,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/wood/darkwoodwindow,
		"icon_file" = 'icons/turf/walls/roguewood.dmi',
		"icon_state" = "woodwindow"
	),
	"stone_window_murderhole" = list(
		"name" = "石制射孔",
		"category" = "Windows & Glass",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/stone/window,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/stone/window,
		"icon_file" = 'icons/turf/walls/stone_wall.dmi',
		"icon_state" = "stonewindow"
	),
	"brick_window_murderhole" = list(
		"name" = "砖制射孔",
		"category" = "Windows & Glass",
		"layer_type" = "wall",
		"build_order" = 2,
		"path" = /turf/closed/wall/mineral/rogue/brick/window,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/brick/window,
		"icon_file" = 'icons/turf/walls/brick_wall.dmi',
		"icon_state" = "brickwindow"
	),
	"window_glass_static" = list(
		"name" = "固定玻璃窗",
		"category" = "Windows & Glass",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/roguewindow,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/roguewindow,
		"icon_file" = 'icons/roguetown/misc/roguewindow.dmi',
		"icon_state" = "window-solid"
	),
	"window_glass_openable" = list(
		"name" = "可开启窗户",
		"category" = "Windows & Glass",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/roguewindow/openclose,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/roguewindow/dynamic,
		"icon_file" = 'icons/roguetown/misc/roguewindow.dmi',
		"icon_state" = "woodwindowdir"
	),
	"window_glass_reinforced" = list(
		"name" = "加固窗户",
		"category" = "Windows & Glass",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/roguewindow/openclose/reinforced,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/roguewindow/reinforced,
		"icon_file" = 'icons/roguetown/misc/roguewindow.dmi',
		"icon_state" = "reinforcedwindowdir"
	),
	"window_brick_reinforced" = list(
		"name" = "加固砖窗",
		"category" = "Windows & Glass",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/roguewindow/openclose/reinforced/brick,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/brick/window/openclose,
		"icon_file" = 'icons/roguetown/misc/roguewindow.dmi',
		"icon_state" = "reinforcedwindowdir"
	),
	"window_stained_psydon" = list(
		"name" = "普赛顿彩绘玻璃窗",
		"category" = "Windows & Glass",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/roguewindow/stained/silver,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/roguewindow/stone,
		"icon_file" = 'icons/roguetown/misc/roguewindow.dmi',
		"icon_state" = "stained-silver"
	),
	"stairs_wood" = list(
		"name" = "木楼梯（向上）",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 3,
		"requires_floor" = TRUE,
		"path" = /obj/structure/stairs,
		"reqs" = list(/obj/item/grown/log/tree/small = 2),
		"icon_file" = 'icons/obj/stairs.dmi',
		"icon_state" = "stairs"
	),
	"stairs_wood_down" = list(
		"name" = "木楼梯（向下）",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 3,
		"requires_floor" = TRUE,
		"path" = /obj/structure/stairs/d,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stairsd,
		"icon_file" = 'icons/obj/stairs.dmi',
		"icon_state" = "stairs"
	),
	"stairs_stone" = list(
		"name" = "石楼梯（向上）",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 3,
		"requires_floor" = TRUE,
		"path" = /obj/structure/stairs/stone,
		"reqs" = list(/obj/item/natural/stone = 2),
		"icon_file" = 'icons/obj/stairs.dmi',
		"icon_state" = "stonestairs"
	),
	"stairs_stone_down" = list(
		"name" = "石楼梯（向下）",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 3,
		"requires_floor" = TRUE,
		"path" = /obj/structure/stairs/stone/d,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stonestairsd,
		"icon_file" = 'icons/obj/stairs.dmi',
		"icon_state" = "stonestairs"
	),
	"ladder" = list(
		"name" = "梯子",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 3,
		"requires_floor" = TRUE,
		"path" = /obj/structure/ladder,
		"reqs" = list(/obj/item/grown/log/tree/small = 2),
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "ladder11"
	),
	"wall_ladder" = list(
		"name" = "壁梯",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 3,
		"requires_floor" = TRUE,
		"path" = /obj/structure/wallladder,
		"reqs" = /datum/crafting_recipe/roguetown/structure/wallladder,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "ladderwall"
	),
	"door_wood" = list(
		"name" = "木门",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/mineral_door/wood,
		"reqs" = /datum/crafting_recipe/roguetown/structure/door,
		"icon_file" = 'icons/roguetown/misc/doors.dmi',
		"icon_state" = "woodhandle"
	),
	"door_wood_deadbolt" = list(
		"name" = "插销木门",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/mineral_door/wood/deadbolt,
		"reqs" = /datum/crafting_recipe/roguetown/structure/doorbolt,
		"icon_file" = 'icons/roguetown/misc/doors.dmi',
		"icon_state" = "wooddir"
	),
	"door_wood_fancy" = list(
		"name" = "精致木门",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/mineral_door/wood/fancywood,
		"reqs" = /datum/crafting_recipe/roguetown/structure/fancydoor,
		"icon_file" = 'icons/roguetown/misc/doors.dmi',
		"icon_state" = "fancy_wood"
	),
	"door_wood_glass" = list(
		"name" = "木框玻璃门",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/mineral_door/wood/window,
		"reqs" = /datum/crafting_recipe/roguetown/structure/glassdoor,
		"icon_file" = 'icons/roguetown/misc/doors.dmi',
		"icon_state" = "woodwindow"
	),
	"door_metal_donjon" = list(
		"name" = "城堡金属门",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/mineral_door/wood/donjon,
		"reqs" = /datum/crafting_recipe/roguetown/structure/donjon,
		"icon_file" = 'icons/roguetown/misc/doors.dmi',
		"icon_state" = "donjondir"
	),
	"door_cell_bars" = list(
		"name" = "牢房栅栏门",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/mineral_door/bars,
		"reqs" = /datum/crafting_recipe/roguetown/structure/celldoor,
		"icon_file" = 'icons/roguetown/misc/doors.dmi',
		"icon_state" = "bars"
	),
	"door_swing" = list(
		"name" = "双向摆门",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/mineral_door/swing_door,
		"reqs" = /datum/crafting_recipe/roguetown/structure/swing_door,
		"icon_file" = 'icons/roguetown/misc/doors.dmi',
		"icon_state" = "woodhandle"
	),
	"door_stone" = list(
		"name" = "石门",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/mineral_door/wood/donjon/stone,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stonedoor,
		"icon_file" = 'icons/roguetown/misc/doors.dmi',
		"icon_state" = "stone"
	),
	"tent_door" = list(
		"name" = "帐篷门",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/roguetent,
		"reqs" = /datum/crafting_recipe/roguetown/turfs/tentdoor,
		"icon_file" = 'icons/turf/roguewall.dmi',
		"icon_state" = "tent_door1"
	),
	"fence_palisade" = list(
		"name" = "木栅栏",
		"category" = "Doors & Stairs",
		"layer_type" = "border",
		"build_order" = 3,
		"path" = /obj/structure/fluff/railing/fence,
		"reqs" = /datum/crafting_recipe/roguetown/structure/fence,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "fence"
	),
	"railing_wood" = list(
		"name" = "木栏杆",
		"category" = "Doors & Stairs",
		"layer_type" = "border",
		"build_order" = 3,
		"path" = /obj/structure/fluff/railing/wood,
		"reqs" = /datum/crafting_recipe/roguetown/structure/railing,
		"icon_file" = 'icons/obj/railing.dmi',
		"icon_state" = "woodrailing"
	),
	"border_wood" = list(
		"name" = "木围栏",
		"category" = "Doors & Stairs",
		"layer_type" = "border",
		"build_order" = 3,
		"path" = /obj/structure/fluff/railing/border,
		"reqs" = /datum/crafting_recipe/roguetown/structure/border,
		"icon_file" = 'icons/obj/railing.dmi',
		"icon_state" = "border"
	),
	"border_corner" = list(
		"name" = "围栏转角",
		"category" = "Doors & Stairs",
		"layer_type" = "border",
		"build_order" = 3,
		"path" = /obj/structure/fluff/railing/corner,
		"reqs" = /datum/crafting_recipe/roguetown/structure/bordercorner,
		"icon_file" = 'icons/obj/railing.dmi',
		"icon_state" = "border"
	),
	"mineshaft_support" = list(
		"name" = "矿道支架",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/barricade/mineshaft,
		"reqs" = /datum/crafting_recipe/roguetown/structure/mineshaft_support,
		"icon_file" = 'icons/obj/structures.dmi',
		"icon_state" = "woodenbarricade_mineshaft"
	),
	"passage_bars" = list(
		"name" = "金属通道门",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/bars/passage,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/passage,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "passage0"
	),
	"passage_shutters" = list(
		"name" = "通道闸门",
		"category" = "Doors & Stairs",
		"layer_type" = "obj",
		"build_order" = 2,
		"path" = /obj/structure/bars/passage/shutter,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/shutters,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "shutter0"
	),
	"table_wood" = list(
		"name" = "木桌",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/wood/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/table,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "tablewood1"
	),
	"table_wood_alt" = list(
		"name" = "粗制木桌",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/wood/poor/alt_alt,
		"reqs" = /datum/crafting_recipe/roguetown/structure/tablewood3,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "tablewood_alt"
	),
	"table_metallic_fancy" = list(
		"name" = "加固木桌",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/wood,
		"reqs" = /datum/crafting_recipe/roguetown/structure/actualfancytable,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "tablewood1"
	),
	"table_ornate" = list(
		"name" = "华丽木桌",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/fine,
		"reqs" = /datum/crafting_recipe/roguetown/structure/ornatetable,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "tablefine"
	),
	"table_long" = list(
		"name" = "长桌",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/wood/long_table,
		"reqs" = /datum/crafting_recipe/roguetown/structure/longtable,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "longtable"
	),
	"table_long_mid" = list(
		"name" = "长桌中段",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/wood/long_table/mid,
		"reqs" = /datum/crafting_recipe/roguetown/structure/longtable,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "longtable_mid"
	),
	"table_large" = list(
		"name" = "大桌",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/wood/large_table,
		"reqs" = /datum/crafting_recipe/roguetown/structure/largetable,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "largetable"
	),
	"table_stone" = list(
		"name" = "石桌",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/church,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stonetable,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "churchtable"
	),
	"table_finestone" = list(
		"name" = "精制石桌",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/finestone,
		"reqs" = /datum/crafting_recipe/roguetown/structure/finestonetable,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "stonetable_small"
	),
	"table_operating" = list(
		"name" = "手术台",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/optable,
		"reqs" = /datum/crafting_recipe/roguetown/structure/operatingtable,
		"icon_file" = 'icons/obj/surgery.dmi',
		"icon_state" = "optable"
	),
	"chair_wood" = list(
		"name" = "木椅",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/item/chair/rogue/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/chair,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "chair2"
	),
	"chair_fancy" = list(
		"name" = "精致椅子",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/item/chair/rogue/fancy/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/fancychair,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "chair1"
	),
	"stool_wood" = list(
		"name" = "吧台凳",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/item/chair/stool/bar/rogue/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stool,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "barstool"
	),
	"throne_small" = list(
		"name" = "小王座",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/chair/wood/rogue/throne,
		"reqs" = /datum/crafting_recipe/roguetown/structure/chairthrone,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "thronechair"
	),
	"bench_park" = list(
		"name" = "公园长椅中段",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/chair/hotspring_bench,
		"reqs" = /datum/crafting_recipe/roguetown/structure/parkbenchmiddle,
		"icon_file" = 'icons/obj/structures/hotspring.dmi',
		"icon_state" = "parkbench_sofamiddle"
	),
	"bench_park_L" = list(
		"name" = "公园长椅左段",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/chair/hotspring_bench/left,
		"reqs" = /datum/crafting_recipe/roguetown/structure/parkbenchmiddle,
		"icon_file" = 'icons/obj/structures/hotspring.dmi',
		"icon_state" = "parkbench_sofaend_left"
	),
	"bench_park_R" = list(
		"name" = "公园长椅右段",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/chair/hotspring_bench/right,
		"reqs" = /datum/crafting_recipe/roguetown/structure/parkbenchmiddle,
		"icon_file" = 'icons/obj/structures/hotspring.dmi',
		"icon_state" = "parkbench_sofaend_right"
	),
	"couch_red" = list(
		"name" = "红色沙发左段",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/chair/bench/couch,
		"reqs" = /datum/crafting_recipe/roguetown/structure/couchleft,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "redcouch"
	),
	"couch_red_r" = list(
		"name" = "红色沙发右段",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/chair/bench/coucha/r,
		"reqs" = /datum/crafting_recipe/roguetown/structure/couchleft,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "couchablackaright"
	),
	"couch_black" = list(
		"name" = "黑色沙发左段",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/chair/bench/couchablack,
		"reqs" = /datum/crafting_recipe/roguetown/structure/blackcouchleft,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "couchablackaleft"
	),
	"couch_black_r" = list(
		"name" = "黑色沙发右段",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/chair/bench/couchablack/r,
		"reqs" = /datum/crafting_recipe/roguetown/structure/blackcouchleft,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "couchablackaright"
	),
	"couch_ultima" = list(
		"name" = "乌尔蒂玛沙发左段",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/chair/bench/ultimacouch,
		"reqs" = /datum/crafting_recipe/roguetown/structure/ultimacouchleft,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "ultimacouchleft"
	),
	"couch_ultima_r" = list(
		"name" = "乌尔蒂玛沙发右段",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/chair/bench/ultimacouch/r,
		"reqs" = /datum/crafting_recipe/roguetown/structure/ultimacouchleft,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "ultimacouchright"
	),
	"bed_straw" = list(
		"name" = "草床",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bed/rogue/shit,
		"reqs" = /datum/crafting_recipe/roguetown/structure/strawbed,
		"icon_file" = 'icons/roguetown/misc/beds.dmi',
		"icon_state" = "shitbed"
	),
	"bed_inn" = list(
		"name" = "旅店床铺",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bed/rogue/inn,
		"reqs" = /datum/crafting_recipe/roguetown/structure/bed,
		"icon_file" = 'icons/roguetown/misc/beds.dmi',
		"icon_state" = "inn_bed"
	),
	"bed_wool" = list(
		"name" = "羊毛床",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bed/rogue/inn/wool,
		"reqs" = /datum/crafting_recipe/roguetown/structure/woolbed,
		"icon_file" = 'icons/roguetown/misc/beds.dmi',
		"icon_state" = "woolbed"
	),
	"bed_double" = list(
		"name" = "双人床",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bed/rogue/inn/double,
		"reqs" = /datum/crafting_recipe/roguetown/structure/doublebed,
		"icon_file" = 'icons/roguetown/misc/beds.dmi',
		"icon_state" = "double"
	),
	"bed_double_wool" = list(
		"name" = "双人羊毛床",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bed/rogue/inn/wooldouble,
		"reqs" = /datum/crafting_recipe/roguetown/structure/wooldoublebed,
		"icon_file" = 'icons/roguetown/misc/beds.dmi',
		"icon_state" = "double"
	),
	"curtain_red" = list(
		"name" = "红色帘幕",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/curtain/red,
		"reqs" = /datum/crafting_recipe/roguetown/structure/curtainred,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "curtain-open"
	),
	"curtain_blue" = list(
		"name" = "蓝色帘幕",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/curtain/blue,
		"reqs" = /datum/crafting_recipe/roguetown/structure/curtainblue,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "curtain-open"
	),
	"curtain_dir" = list(
		"name" = "定向帘幕",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/curtain/directional/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/curtaindirectional,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "curtain-open"
	),
	"mirror_wood" = list(
		"name" = "壁镜",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/mirror,
		"reqs" = /datum/crafting_recipe/roguetown/structure/mirror,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "mirror"
	),
	"mirror_fancy" = list(
		"name" = "精致镜子",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/mirror/fancy,
		"reqs" = /datum/crafting_recipe/roguetown/structure/fancymirror,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "fancymirror"
	),
	"floor_clock" = list(
		"name" = "落地钟",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/clock,
		"reqs" = /datum/crafting_recipe/roguetown/structure/floorclock,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "clock"
	),
	"wall_clock" = list(
		"name" = "挂钟",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/wallclock,
		"reqs" = /datum/crafting_recipe/roguetown/structure/wallclock,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "wallclock"
	),
	"telescope" = list(
		"name" = "望远镜",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/telescope,
		"reqs" = /datum/crafting_recipe/roguetown/structure/telescope,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "telescope"
	),
	"globe" = list(
		"name" = "地球仪",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/globe,
		"reqs" = /datum/crafting_recipe/roguetown/structure/globe,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "globe"
	),
	"floor_pillows" = list(
		"name" = "坐垫",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/pillow/red,
		"reqs" = /datum/crafting_recipe/roguetown/structure/redpillows,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "pillow"
	),
	"display_stand" = list(
		"name" = "人台",
		"category" = "Furniture",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/mannequin,
		"reqs" = /datum/crafting_recipe/roguetown/structure/display_stand,
		"icon_file" = 'icons/obj/mannequin.dmi',
		"icon_state" = "coat_hanger"
	),
	"chest_wood" = list(
		"name" = "木箱",
		"category" = "Storage",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/closet/crate/chest/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/chest,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "chest3s"
	),
	"closet_wood" = list(
		"name" = "木柜",
		"category" = "Storage",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/closet/crate/roguecloset,
		"reqs" = /datum/crafting_recipe/roguetown/structure/closet,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "closet"
	),
	"dresser_drawer" = list(
		"name" = "床头柜",
		"category" = "Storage",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/closet/crate/drawer,
		"reqs" = /datum/crafting_recipe/roguetown/structure/drawer5,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "drawer5"
	),
	"dresser_long" = list(
		"name" = "长衣柜",
		"category" = "Storage",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/closet/crate/drawer/drawer2,
		"reqs" = /datum/crafting_recipe/roguetown/structure/drawer1,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "drawer2"
	),
	"rack_wood" = list(
		"name" = "武器架",
		"category" = "Storage",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/rack/rogue,
		"reqs" = /datum/crafting_recipe/roguetown/structure/rack,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "rack"
	),
	"wall_shelf" = list(
		"name" = "壁架",
		"category" = "Storage",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/rack/rogue/shelf,
		"reqs" = /datum/crafting_recipe/roguetown/structure/wallshelf,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "shelf"
	),
	"barrel_wood" = list(
		"name" = "木桶",
		"category" = "Storage",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fermentation_keg/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/barrel,
		"icon_file" = 'icons/obj/brewing.dmi',
		"icon_state" = "barrel_tapless"
	),
	"coffin_wood" = list(
		"name" = "木棺",
		"category" = "Storage",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/closet/crate/coffin,
		"reqs" = /datum/crafting_recipe/roguetown/structure/coffin,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "casket"
	),
	"sleep_coffin" = list(
		"name" = "吸血鬼寝棺",
		"category" = "Storage",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/closet/crate/coffin/vampire,
		"reqs" = /datum/crafting_recipe/roguetown/structure/sleepcoffin,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "vcasket"
	),
	"wicker_basket" = list(
		"name" = "柳条篮",
		"category" = "Storage",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/closet/crate/chest/wicker,
		"reqs" = /datum/crafting_recipe/roguetown/structure/wicker,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "wicker"
	),
	"wooden_bin" = list(
		"name" = "木料箱",
		"category" = "Storage",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/item/roguebin,
		"reqs" = /datum/crafting_recipe/roguetown/roguebin,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "washbin1"
	),
	"minecart" = list(
		"name" = "矿车",
		"category" = "Storage",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/closet/crate/miningcar,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/minecart,
		"icon_file" = 'icons/obj/track.dmi',
		"icon_state" = "minecart"
	),

	"fireplace_north" = list(
		"name" = "壁炉",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/campfire/fireplace/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/fireplace,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "wallfire1"
	),
	"fireplace_blue" = list(
		"name" = "蓝焰壁炉",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/campfire/fireplace/crafted/blue,
		"reqs" = /datum/crafting_recipe/roguetown/structure/fireplace/blue,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "wallfire1"
	),
	"torch_holder" = list(
		"name" = "壁挂火炬架",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/torchholder,
		"reqs" = /datum/crafting_recipe/roguetown/structure/torchholder,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "torchwall1"
	),
	"torch_standing" = list(
		"name" = "立式火盆",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/firebowl/standing,
		"reqs" = /datum/crafting_recipe/roguetown/structure/standing,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "standing1"
	),
	"torch_standing_blue" = list(
		"name" = "蓝焰立式火盆",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/firebowl/standing/blue,
		"reqs" = /datum/crafting_recipe/roguetown/structure/standingblue,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "standing1"
	),
	"brazier_stump" = list(
		"name" = "树桩火盆",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/firebowl/stump,
		"reqs" = /datum/crafting_recipe/roguetown/structure/brazier,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "stumpfire1"
	),
	"torch_lantern_standing" = list(
		"name" = "立式石灯",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/torchholder/hotspring/standing,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stonelanternstanding,
		"icon_file" = 'icons/obj/structures/hotspring.dmi',
		"icon_state" = "stonelantern_standing1"
	),
	"torch_lantern_ground" = list(
		"name" = "落地石灯",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/torchholder/hotspring,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stonelantern,
		"icon_file" = 'icons/obj/structures/hotspring.dmi',
		"icon_state" = "stonelantern1"
	),
	"wall_candles" = list(
		"name" = "壁挂蜡烛",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/candle,
		"reqs" = /datum/crafting_recipe/roguetown/structure/wallcandle,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "wallcandle1"
	),
	"wall_candles_blue" = list(
		"name" = "蓝焰壁挂蜡烛",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/candle/blue,
		"reqs" = /datum/crafting_recipe/roguetown/structure/wallcandleblue,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "wallcandle1"
	),
	"floor_candles" = list(
		"name" = "落地蜡烛",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/candle/floorcandle,
		"reqs" = /datum/crafting_recipe/roguetown/structure/floorcandle,
		"icon_file" = 'icons/roguetown/items/lighting.dmi',
		"icon_state" = "floorcandle1"
	),
	"campfire" = list(
		"name" = "营火",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/campfire,
		"reqs" = /datum/crafting_recipe/roguetown/structure/campfire,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "badfire1"
	),
	"dense_campfire" = list(
		"name" = "大型营火",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/campfire/densefire,
		"reqs" = /datum/crafting_recipe/roguetown/structure/densefire,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "badfire1"
	),
	"hearth" = list(
		"name" = "炉灶",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/hearth,
		"reqs" = /datum/crafting_recipe/roguetown/structure/cookpit,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "hearth1"
	),
	"oven" = list(
		"name" = "烤炉",
		"category" = "Heating & Lighting",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/oven,
		"reqs" = /datum/crafting_recipe/roguetown/structure/oven,
		"icon_file" = 'icons/roguetown/misc/lighting.dmi',
		"icon_state" = "oven1"
	),
	"anvil_iron" = list(
		"name" = "铁砧",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/anvil,
		"reqs" = /datum/crafting_recipe/roguetown/structure/anvil,
		"icon_file" = 'icons/roguetown/misc/forge.dmi',
		"icon_state" = "anvil"
	),
	"forge" = list(
		"name" = "锻炉",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/forge,
		"reqs" = /datum/crafting_recipe/roguetown/structure/forge,
		"icon_file" = 'icons/roguetown/misc/forge.dmi',
		"icon_state" = "forge0"
	),
	"smelter_ore" = list(
		"name" = "矿石熔炉",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/smelter,
		"reqs" = /datum/crafting_recipe/roguetown/structure/smelter,
		"icon_file" = 'icons/roguetown/misc/forge.dmi',
		"icon_state" = "cavesmelter0"
	),
	"smelter_bloomery" = list(
		"name" = "块炼炉",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/smelter/hiron,
		"reqs" = /datum/crafting_recipe/roguetown/structure/smelterhiron,
		"icon_file" = 'icons/roguetown/misc/forge.dmi',
		"icon_state" = "hironsmelter0"
	),
	"smelter_bronze" = list(
		"name" = "青铜熔炉",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/smelter/bronze,
		"reqs" = /datum/crafting_recipe/roguetown/structure/smelterbronze,
		"icon_file" = 'icons/roguetown/misc/forge.dmi',
		"icon_state" = "cavesmelter0"
	),
	"smelter_great" = list(
		"name" = "大型熔炉",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/smelter/great,
		"reqs" = /datum/crafting_recipe/roguetown/structure/greatsmelter,
		"icon_file" = 'icons/roguetown/misc/forge.dmi',
		"icon_state" = "smelter0"
	),
	"grindwheel" = list(
		"name" = "磨刀轮",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/grindwheel,
		"reqs" = /datum/crafting_recipe/roguetown/structure/sharpwheel,
		"icon_file" = 'icons/roguetown/misc/forge.dmi',
		"icon_state" = "grindwheel"
	),
	"artificer_table" = list(
		"name" = "工匠工作台",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/artificer_table,
		"reqs" = /datum/crafting_recipe/roguetown/structure/art_table,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "art_table"
	),
	"loom" = list(
		"name" = "织布机",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/loom,
		"reqs" = /datum/crafting_recipe/roguetown/structure/loom,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "loom"
	),
	"potters_wheel" = list(
		"name" = "陶轮",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/ceramicswheel,
		"reqs" = /datum/crafting_recipe/roguetown/structure/ceramicswheel,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "potwheel"
	),
	"dye_station" = list(
		"name" = "染色台",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/gear_painter,
		"reqs" = /datum/crafting_recipe/roguetown/structure/dyestation,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "dyestation"
	),
	"alchemy_station" = list(
		"name" = "炼金台",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/alch,
		"reqs" = /datum/crafting_recipe/roguetown/structure/alch,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "alch"
	),
	"cauldron_alchemy" = list(
		"name" = "炼金坩埚",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/light/rogue/cauldron,
		"reqs" = /datum/crafting_recipe/roguetown/structure/cauldronalchemy,
		"icon_file" = 'icons/roguetown/misc/alchemy.dmi',
		"icon_state" = "cauldron1"
	),
	"cooling_table" = list(
		"name" = "冷却台",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/table/cooling,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/coolingtable,
		"icon_file" = 'icons/roguetown/misc/tables.dmi',
		"icon_state" = "tablewood_alt"
	),
	"distiller" = list(
		"name" = "铜制蒸馏器",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fermentation_keg/distiller,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/distiller,
		"icon_file" = 'icons/obj/distillery.dmi',
		"icon_state" = "distillery"
	),
	"autosmither" = list(
		"name" = "自动锻造机",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/autosmither,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/smither,
		"icon_file" = 'icons/obj/autosmithy.dmi',
		"icon_state" = "1"
	),
	"autogrinder" = list(
		"name" = "自动研磨机",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/autogrinder,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/autogrinder,
		"icon_file" = 'icons/obj/autogrinder.dmi',
		"icon_state" = "mill_off"
	),
	"windmill" = list(
		"name" = "风车",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/windmill,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/windmill,
		"icon_file" = 'icons/roguetown/misc/windmill.dmi',
		"icon_state" = "1"
	),
	"grille" = list(
		"name" = "地板格栅",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bars/grille,
		"reqs" = /datum/crafting_recipe/roguetown/structure/floorgrille,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "floorgrille"
	),
	"floordoor" = list(
		"name" = "地板活板门",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/floordoor,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/trapdoor,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "floorhatch1"
	),
	"lever" = list(
		"name" = "机械拉杆",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/lever,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/lever,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "leverwall0"
	),
	"pressure_plate" = list(
		"name" = "压力板",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/pressure_plate,
		"reqs" = /datum/crafting_recipe/roguetown/structure/pressure_plate,
		"icon_file" = 'icons/roguetown/misc/traps.dmi',
		"icon_state" = "pressureplate"
	),
	"eng_launcher" = list(
		"name" = "工程师发射器",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/englauncher,
		"reqs" = /datum/crafting_recipe/roguetown/structure/activator,
		"icon_file" = 'icons/roguetown/misc/engineering_structure.dmi',
		"icon_state" = "activator"
	),
	"bars_metal" = list(
		"name" = "金属栅栏",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bars,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/bars,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "bars"
	),
	"bars_cemetery" = list(
		"name" = "墓地栅栏",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bars/cemetery,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/bars/cemetery,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "cemetery"
	),
	"bars_shop" = list(
		"name" = "商店栅栏",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bars/shop,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/shopbars,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "barsbent"
	),
	"rcom_radio" = list(
		"name" = "RCOM终端",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/roguemachine/scomm/receive_only,
		"reqs" = /datum/crafting_recipe/roguetown/structure/rcom,
		"icon_file" = 'icons/roguetown/misc/machines.dmi',
		"icon_state" = "scomm1"
	),
	"millstone" = list(
		"name" = "石磨",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/item/millstone,
		"reqs" = /datum/crafting_recipe/roguetown/structure/millstone,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "millstone"
	),
	"tanning_rack" = list(
		"name" = "鞣皮架",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/machinery/tanningrack,
		"reqs" = /datum/crafting_recipe/roguetown/structure/tanningrack,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "dryrack"
	),
	"apiary_beehive" = list(
		"name" = "蜂箱",
		"category" = "Crafting & Machinery",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/apiary,
		"reqs" = /datum/crafting_recipe/roguetown/structure/apiary,
		"icon_file" = 'icons/obj/structures/apiary.dmi',
		"icon_state" = "beebox-empty"
	),
	"wall_deco_stone" = list(
		"name" = "石墙装饰",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/walldeco/stone,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stonewalldeco,
		"icon_file" = 'icons/roguetown/misc/decoration.dmi',
		"icon_state" = "walldec1"
	),
	"hanging_chains" = list(
		"name" = "悬挂锁链",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/walldeco/chains,
		"reqs" = /datum/crafting_recipe/roguetown/structure/hangingchains,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "chains1"
	),
	"cross_pantheon_wood" = list(
		"name" = "木制十字架",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/crafted,
		"reqs" = /datum/crafting_recipe/roguetown/structure/psycrss,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "psycrosscrafted"
	),
	"cross_pantheon_stone" = list(
		"name" = "石制十字架",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stonepsycrss,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "psycross"
	),
	"cross_psydon_wood" = list(
		"name" = "木制普赛顿十字架",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/psycrucifix,
		"reqs" = /datum/crafting_recipe/roguetown/structure/psycruci,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "psycruci"
	),
	"cross_psydon_stone" = list(
		"name" = "石制普赛顿十字架",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/psycrucifix/stone,
		"reqs" = /datum/crafting_recipe/roguetown/structure/stonepsycruci,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "psycruci_r"
	),
	"cross_psydon_silver" = list(
		"name" = "银制普赛顿十字架",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/psycrucifix/silver,
		"reqs" = /datum/crafting_recipe/roguetown/structure/silverpsycruci,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "psycruci_s"
	),
	"cross_zizo_wood" = list(
		"name" = "木制倒十字架",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/zizocross,
		"reqs" = /datum/crafting_recipe/roguetown/structure/zizo_shrine,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_zizo"
	),
	"cross_zizo_stone" = list(
		"name" = "石制倒十字架",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/zizocross/stone,
		"reqs" = /datum/crafting_recipe/roguetown/structure/zizo_shrine/stone,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_zizo"
	),
	"cross_zizo_gold" = list(
		"name" = "金制倒十字架",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/zizocross/golden,
		"reqs" = /datum/crafting_recipe/roguetown/structure/zizo_shrine/gold,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_zizo_u"
	),
	"cross_graggar_stone" = list(
		"name" = "石制格拉加尔十字架",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/graggar,
		"reqs" = /datum/crafting_recipe/roguetown/structures/psycross/graggar,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_graggar"
	),
	"cross_matthios_stone" = list(
		"name" = "石制马西奥斯十字架",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/matthios,
		"reqs" = /datum/crafting_recipe/roguetown/structures/psycross/matthios,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_matthios"
	),
	"cross_baotha_stone" = list(
		"name" = "石制巴奥莎十字架",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/baotha,
		"reqs" = /datum/crafting_recipe/roguetown/structures/psycross/baotha,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_baotha"
	),
	"cross_necra_stone" = list(
		"name" = "石制内克拉十字架",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/psycross/crafted/necra,
		"reqs" = /datum/crafting_recipe/roguetown/structures/psycross/necra,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "cross_necra"
	),
	"training_dummy" = list(
		"name" = "训练假人",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/statue/tdummy,
		"reqs" = /datum/crafting_recipe/roguetown/structure/dummy,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "p_dummy"
	),
	"custom_sign" = list(
		"name" = "木制标牌",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/customsign,
		"reqs" = /datum/crafting_recipe/roguetown/structure/sign,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "sign"
	),
	"sign_zizo" = list(
		"name" = "齐佐标牌",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/iconsign/zizosign,
		"reqs" = /datum/crafting_recipe/roguetown/structure/sign/zizoiconsign,
		"icon_file" = 'icons/roguetown/misc/signs.dmi',
		"icon_state" = "signdeath"
	),
	"sign_psydon" = list(
		"name" = "普赛顿标牌",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/iconsign/psycrosssign,
		"reqs" = /datum/crafting_recipe/roguetown/structure/sign/psydoniconsign,
		"icon_file" = 'icons/roguetown/misc/signs.dmi',
		"icon_state" = "signlife"
	),
	"sign_smith" = list(
		"name" = "铁匠铺招牌",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/iconsign/smithsign,
		"reqs" = /datum/crafting_recipe/roguetown/structure/sign/smithsign,
		"icon_file" = 'icons/roguetown/misc/signs.dmi',
		"icon_state" = "signdwarf"
	),
	"sign_inn" = list(
		"name" = "旅店招牌",
		"category" = "Religion & Statues",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/iconsign/innsign,
		"reqs" = /datum/crafting_recipe/roguetown/structure/sign/innsign,
		"icon_file" = 'icons/roguetown/misc/signs.dmi',
		"icon_state" = "signmug"
	),
	"spike_pit_trap" = list(
		"name" = "尖刺陷坑",
		"category" = "Defense & Traps",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/spike_pit,
		"reqs" = /datum/crafting_recipe/roguetown/structure/spike_pit,
		"icon_file" = 'icons/turf/roguefloor.dmi',
		"icon_state" = "spike_pit"
	),
	"head_stake" = list(
		"name" = "木桩上的头颅",
		"category" = "Defense & Traps",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/fluff/headstake,
		"reqs" = /datum/crafting_recipe/roguetown/structure/headstake,
		"icon_file" = 'icons/roguetown/items/natural.dmi',
		"icon_state" = "headstake"
	),
	"pillory_stocks" = list(
		"name" = "枷锁",
		"category" = "Defense & Traps",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/pillory,
		"reqs" = /datum/crafting_recipe/roguetown/structure/pillory,
		"icon_file" = 'modular/icons/obj/pillory.dmi',
		"icon_state" = "pillory_single"
	),
	"meathook_hanging" = list(
		"name" = "悬挂肉钩",
		"category" = "Defense & Traps",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/meathook,
		"reqs" = /datum/crafting_recipe/roguetown/structure/meathook,
		"icon_file" = 'icons/roguetown/misc/tallstructure.dmi',
		"icon_state" = "meathook"
	),
	"noose_hanging" = list(
		"name" = "悬挂绞索",
		"category" = "Defense & Traps",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/noose,
		"reqs" = /datum/crafting_recipe/roguetown/structure/noose,
		"icon_file" = 'modular/icons/obj/gallows.dmi',
		"icon_state" = "noose"
	),
	"gallows_hanging" = list(
		"name" = "绞刑台",
		"category" = "Defense & Traps",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/noose/gallows,
		"reqs" = /datum/crafting_recipe/roguetown/structure/gallows,
		"icon_file" = 'modular/icons/obj/gallows.dmi',
		"icon_state" = "gallows"
	),
	"handcart_wagon" = list(
		"name" = "手推车",
		"category" = "Defense & Traps",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/handcart,
		"reqs" = /datum/crafting_recipe/roguetown/structure/handcart,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "cart-empty"
	),
	"wooden_horse" = list(
		"name" = "木马刑具",
		"category" = "Defense & Traps",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/wooden_horse,
		"reqs" = /datum/crafting_recipe/roguetown/structure/wooden_horse,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "wooden_horse"
	),
	"torture_table" = list(
		"name" = "刑讯台",
		"category" = "Defense & Traps",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bondage/torture_table,
		"reqs" = /datum/crafting_recipe/roguetown/structure/torture_table,
		"icon_file" = 'icons/roguetown/misc/64x64.dmi',
		"icon_state" = "tort_table"
	),
	"x_pillory" = list(
		"name" = "X形刑架",
		"category" = "Defense & Traps",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bondage/x_pillory,
		"reqs" = /datum/crafting_recipe/roguetown/structure/x_pillory,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "x_pillory"
	),
	"chains_bondage" = list(
		"name" = "壁挂镣铐",
		"category" = "Defense & Traps",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/bondage/chains,
		"reqs" = /datum/crafting_recipe/roguetown/structure/chains,
		"icon_file" = 'icons/roguetown/misc/structure.dmi',
		"icon_state" = "CHAINS"
	),
	"trap_sawblade" = list(
		"name" = "锯刃陷阱",
		"category" = "Defense & Traps",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/trap/saw_blades,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/sawbladetrap,
		"icon_file" = 'icons/roguetown/misc/traps.dmi',
		"icon_state" = "saw_trap_plate"
	),
	"trap_flame" = list(
		"name" = "火焰陷阱",
		"category" = "Defense & Traps",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/trap/flame,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/flametrap,
		"icon_file" = 'icons/roguetown/misc/traps.dmi',
		"icon_state" = "trap_plate"
	),
	"trap_shock" = list(
		"name" = "电击陷阱",
		"category" = "Defense & Traps",
		"layer_type" = "obj",
		"build_order" = 3,
		"path" = /obj/structure/trap/shock,
		"reqs" = /datum/crafting_recipe/roguetown/engineering/shocktrap,
		"icon_file" = 'icons/roguetown/misc/traps.dmi',
		"icon_state" = "shock_trap_plate"
	)
)
	for(var/key in temp_types)
		var/list/info = temp_types[key]
		if(ispath(info["reqs"], /datum/crafting_recipe))
			var/craft_path = info["reqs"]
			var/datum/crafting_recipe/dummy = new craft_path()
			var/list/actual_reqs = list()
			for(var/req_key in dummy.reqs)
				actual_reqs[req_key] = dummy.reqs[req_key]
			info["reqs"] = actual_reqs
			qdel(dummy)

	return temp_types

/proc/get_blueprint_reqs(list/info)
	if(islist(info["reqs"]))
		return info["reqs"]
	return list()

/proc/get_blueprint_static_tgui_data()
	var/list/data = list()
	var/list/types_data = list()

	for(var/key in GLOB.blueprint_buildable_types)
		var/list/info = GLOB.blueprint_buildable_types[key]
		var/atom/build_path = info["path"]

		var/i_file = info["icon_file"] || initial(build_path.icon)
		var/i_state = info["icon_state"] || initial(build_path.icon_state)

		if(!info["image"])
			var/icon/I = icon(i_file, i_state, SOUTH, 1)
			info["image"] = icon2base64(I)

		var/list/reqs_list = get_blueprint_reqs(info)
		var/reqs_text = ""
		for(var/r_path in reqs_list)
			var/obj/item/temp = r_path
			reqs_text += "[initial(temp.name)] x[reqs_list[r_path]], "
		if(length(reqs_text) > 2)
			reqs_text = copytext(reqs_text, 1, length(reqs_text) - 1)

		types_data[key] = list(
			"name" = info["name"],
			"category" = info["category"],
			"layer_type" = info["layer_type"],
			"reqs_text" = reqs_text,
			"image" = info["image"]
		)

	data["buildable_types"] = types_data
	return data

#define MAX_SPELL_RADIUS 10

/proc/load_blueprint_library()
	if(!fexists(BLUEPRINT_LIBRARY_FILE))
		return list()
	var/json = file2text(BLUEPRINT_LIBRARY_FILE)
	if(!json)
		return list()
	return json_decode(json) || list()

/proc/save_blueprint_library()
	var/json = json_encode(blueprint_library_cache)
	var/temp_file = "[BLUEPRINT_LIBRARY_FILE].tmp"

	fdel(temp_file)
	text2file(json, temp_file)

	if(fexists(temp_file))
		fdel(BLUEPRINT_LIBRARY_FILE)
		fcopy(temp_file, BLUEPRINT_LIBRARY_FILE)
		fdel(temp_file)

/proc/calculate_blueprint_reqs_text(list/design_data)
	var/list/totals = list()
	for(var/entry in design_data)
		var/b_type = entry["type"]
		var/list/info = GLOB.blueprint_buildable_types[b_type]
		if(!info) continue
		var/list/reqs = get_blueprint_reqs(info)
		for(var/r_path in reqs)
			totals[r_path] += reqs[r_path]

	var/reqs_text = ""
	for(var/r_path in totals)
		var/obj/item/temp = r_path
		reqs_text += "[initial(temp.name)] x[totals[r_path]], "
	if(length(reqs_text) > 2)
		reqs_text = copytext(reqs_text, 1, length(reqs_text) - 1)
	return reqs_text ? reqs_text : "无需材料"

/proc/handle_blueprint_library_act(action, params, mob/user, datum/tgui/ui)
	if(action == "save_to_library")
		var/bp_name = trim(params["name"])
		if(!bp_name || length(bp_name) > 32)
			to_chat(user, span_warning("蓝图名称无效（须为1-32个字符）。"))
			return TRUE

		var/list/packed_data = params["packed_data"]
		var/max_floors = clamp(text2num(params["max_floors"]) || 2, 2, 4)
		var/list/safe_data = list()

		for(var/b_type in packed_data)
			var/list/coords = packed_data[b_type]
			for(var/coord_str in coords)
				var/list/parts = splittext(coord_str, ",")
				if(length(parts) < 3) continue
				
				var/dx = text2num(parts[1])
				var/dy = text2num(parts[2])
				var/dz = text2num(parts[3])
				var/ddir = length(parts) >= 4 ? text2num(parts[4]) : 2

				if(!isnum(dx) || !isnum(dy) || !isnum(dz) || !isnum(ddir))
					continue

				if(abs(dx) > MAX_SPELL_RADIUS || abs(dy) > MAX_SPELL_RADIUS)
					continue

				safe_data += list(list(
					"x" = dx,
					"y" = dy,
					"z" = dz,
					"type" = b_type,
					"dir" = ddir
				))

		if(!length(safe_data))
			to_chat(user, span_warning("无法将空白蓝图保存至蓝图库！"))
			return TRUE

		var/user_count = 0
		for(var/entry in blueprint_library_cache)
			if(entry["author_ckey"] == user.ckey)
				user_count++

		if(user_count >= 3)
			to_chat(user, span_warning("你在蓝图库中最多只能保存3份蓝图！请先删除一份旧蓝图。"))
			return TRUE

		var/list/new_bp = list(
			"id" = "[user.ckey]_[world.realtime]_[rand(1,1000)]",
			"name" = sanitize(bp_name),
			"author_name" = user.real_name ? "[user.real_name] ([user.key])" : user.key,
			"author_ckey" = user.ckey,
			"max_floors" = max_floors,
			"reqs_summary" = calculate_blueprint_reqs_text(safe_data),
			"grid" = safe_data
		)

		blueprint_library_cache += list(new_bp)
		save_blueprint_library()
		
		to_chat(user, span_notice("蓝图‘[bp_name]’已保存至蓝图库！"))
		if(ui) ui.send_full_update()
		return TRUE

	if(action == "delete_library_blueprint")
		var/bp_id = params["id"]
		var/list/found_entry = null
		for(var/entry in blueprint_library_cache)
			if(entry["id"] == bp_id)
				found_entry = entry
				break

		if(!found_entry)
			return TRUE

		if(found_entry["author_ckey"] != user.ckey)
			to_chat(user, span_warning("你只能删除自己的蓝图！"))
			return TRUE

		blueprint_library_cache -= list(found_entry)
		save_blueprint_library()
		
		to_chat(user, span_notice("蓝图已从蓝图库中删除。"))
		if(ui) ui.send_full_update()
		return TRUE

	return FALSE


/proc/init_blueprint_icons()
	for(var/key in GLOB.blueprint_buildable_types)
		var/list/info = GLOB.blueprint_buildable_types[key]
		if(info["image"]) continue

		var/atom/build_path = info["path"]
		var/i_file = info["icon_file"] || initial(build_path.icon)
		var/i_state = info["icon_state"] || initial(build_path.icon_state)

		var/icon/I = icon(i_file, i_state, SOUTH, 1)
		info["image"] = icon2base64(I)

		CHECK_TICK

/proc/get_blueprint_target_turf(turf/origin, dx, dy, dz)
	if(!origin) return null
	var/turf/base_turf = locate(origin.x + dx, origin.y + dy, origin.z)
	if(!base_turf) return null

	var/turf/target_turf = base_turf
	if(dz > 0)
		for(var/i = 1 to dz)
			var/turf/above = get_step_multiz(target_turf, UP)
			if(!above)
				above = locate(target_turf.x, target_turf.y, target_turf.z + 1)
			target_turf = above
			if(!target_turf || target_turf.z > world.maxz) break

	if(target_turf && target_turf.z > world.maxz)
		return null

	return target_turf

/proc/check_blueprint_placement_valid(turf/origin_turf, mob/user, list/design_data, max_floors)
	if(!origin_turf || !length(design_data))
		return FALSE

	var/list/future_grid = list()
	var/list/future_types = list()

	for(var/entry in design_data)
		var/dx = isnum(entry["x"]) ? entry["x"] : text2num(entry["x"])
		var/dy = isnum(entry["y"]) ? entry["y"] : text2num(entry["y"])
		var/dz = isnum(entry["z"]) ? entry["z"] : (text2num(entry["z"]) || 0)
		if(dz >= max_floors) continue

		var/b_type = entry["type"]
		var/list/info = GLOB.blueprint_buildable_types[b_type]
		if(!info) continue

		var/key = "[dx]_[dy]_[dz]"
		if(!future_grid[key])
			future_grid[key] = list()
			future_types[key] = list()
		future_grid[key] += info["layer_type"]
		future_types[key] += b_type

	for(var/entry in design_data)
		var/dx = isnum(entry["x"]) ? entry["x"] : text2num(entry["x"])
		var/dy = isnum(entry["y"]) ? entry["y"] : text2num(entry["y"])
		var/dz = isnum(entry["z"]) ? entry["z"] : (text2num(entry["z"]) || 0)
		if(dz >= max_floors) continue

		var/b_type = entry["type"]
		var/list/info = GLOB.blueprint_buildable_types[b_type]
		if(!info) continue

		var/turf/target_turf = get_blueprint_target_turf(origin_turf, dx, dy, dz)
		if(!target_turf)
			to_chat(user, span_warning("空间不足：蓝图超出了世界边界！"))
			return FALSE

		if(info["requires_floor"])
			var/key = "[dx]_[dy]_[dz]"
			var/has_planned_floor = ("floor" in future_grid[key])
			var/has_real_floor = isfloorturf(target_turf) && !istype(target_turf, /turf/open/transparent/openspace) && !istype(target_turf, /turf/open/water)
			if(!has_planned_floor && !has_real_floor)
				to_chat(user, span_warning("位于([target_turf.x], [target_turf.y])的[info["name"]]需要下方有坚实的地板！"))
				return FALSE

		if(isclosedturf(target_turf))
			to_chat(user, span_warning("无法建造：([target_turf.x], [target_turf.y])处已有墙体（[target_turf.name]）！"))
			return FALSE

		for(var/obj/structure/S in target_turf)
			if(S.density || istype(S, /obj/structure/mineral_door) || istype(S, /obj/structure/stairs) || istype(S, /obj/structure/blueprint_site))
				to_chat(user, span_warning("空间不足：([target_turf.x], [target_turf.y])处有障碍物（[S.name]）！"))
				return FALSE

		for(var/obj/machinery/M in target_turf)
			if(M.density)
				to_chat(user, span_warning("空间不足：机械（[M.name]）挡住了位置！"))
				return FALSE

	return TRUE

/obj/effect/blueprint_ghost
	name = "蓝图投影"
	desc = "规划中建筑的全息框架。"
	anchored = TRUE
	density = FALSE
	alpha = 140
	color = "#4da6ff"
	layer = ABOVE_NORMAL_TURF_LAYER
	mouse_opacity = 0
	var/obj/structure/blueprint_site/master
	var/list/entry_data

/obj/structure/blueprint_site
	name = "建筑工地"
	desc = "用锤子敲击以进行建造。将所需材料放在附近。"
	icon = 'icons/turf/roguewall.dmi'
	icon_state = "decowood"
	density = FALSE
	anchored = TRUE

	var/list/unbuilt_entries = list()
	var/list/active_ghosts = list()
	var/list/required_resources = list()
	var/total_tiles_count = 0
	var/built_tiles_count = 0
	var/max_floors = 2

/obj/structure/blueprint_site/examine(mob/user)
	. = ..()
	var/percent = total_tiles_count > 0 ? round((built_tiles_count / total_tiles_count) * 100) : 0
	. += span_notice("施工进度：<b>[percent]%</b>（[built_tiles_count]/[total_tiles_count]个部件）。")

	var/missing = ""
	for(var/res in required_resources)
		if(required_resources[res] > 0)
			var/obj/item/temp = res
			missing += "[initial(temp.name)]: [required_resources[res]] pcs. "

	if(missing != "")
		. += span_warning("缺少材料：[missing]")
	else
		. += span_info("所有材料都已吸收！继续挥锤施工吧。")

/obj/structure/blueprint_site/proc/setup_design(list/data, mob/user)
	total_tiles_count = length(data)
	built_tiles_count = 0

	for(var/entry in data)
		var/b_type = entry["type"]
		var/dz = isnum(entry["z"]) ? entry["z"] : (text2num(entry["z"]) || 0)
		if(dz >= max_floors) continue

		var/list/info = GLOB.blueprint_buildable_types[b_type]
		if(!info) continue

		var/list/reqs_list = get_blueprint_reqs(info)
		for(var/res_path in reqs_list)
			var/cost = reqs_list[res_path]
			if(!required_resources[res_path])
				required_resources[res_path] = 0
			required_resources[res_path] += cost

		unbuilt_entries += list(entry)

	sortTim(unbuilt_entries, GLOBAL_PROC_REF(cmp_build_priority))

/proc/cmp_build_priority(list/a, list/b)
	var/za = isnum(a["z"]) ? a["z"] : (text2num(a["z"]) || 0)
	var/zb = isnum(b["z"]) ? b["z"] : (text2num(b["z"]) || 0)
	if(za != zb)
		return za - zb

	var/info_a = GLOB.blueprint_buildable_types[a["type"]]
	var/info_b = GLOB.blueprint_buildable_types[b["type"]]
	var/cat_a = info_a ? info_a["build_order"] : 9
	var/cat_b = info_b ? info_b["build_order"] : 9
	return cat_a - cat_b

/obj/structure/blueprint_site/proc/can_solidify_target(turf/target_turf, mob/user, list/entry)
	if(!target_turf) return FALSE

	var/b_type = entry ? entry["type"] : null
	var/list/info = b_type ? GLOB.blueprint_buildable_types[b_type] : null
	var/incoming_dir = entry && isnum(entry["dir"]) ? entry["dir"] : (text2num(entry?["dir"]) || 2)
	var/is_border_build = (info && info["layer_type"] == "border")

	if(info && info["requires_floor"])
		if(!isfloorturf(target_turf) || istype(target_turf, /turf/open/transparent/openspace) || istype(target_turf, /turf/open/water))
			to_chat(user, span_warning("下方没有坚实的地板，无法建造[info["name"]]！"))
			return FALSE

	for(var/mob/living/M in target_turf)
		to_chat(user, span_warning("([target_turf.x], [target_turf.y])处的生物（[M.name]）挡住了施工位置！请让其移开。"))
		return FALSE

	for(var/obj/item/I in target_turf)
		to_chat(user, span_warning("([target_turf.x], [target_turf.y])处的物品（[I.name]）挡住了施工位置！请清理该区域。"))
		return FALSE

	for(var/obj/structure/S in target_turf)
		if(S == src || istype(S, /obj/effect/blueprint_ghost))
			continue

		if(is_border_build && ((S.flags_1 & ON_BORDER_1) || istype(S, /obj/structure/fluff/railing)))
			if(S.dir != incoming_dir)
				continue

		if(((S.flags_1 & ON_BORDER_1) || istype(S, /obj/structure/fluff/railing)) && !is_border_build)
			continue

		if(S.density)
			to_chat(user, span_warning("([target_turf.x], [target_turf.y])处的结构（[S.name]）挡住了施工位置！"))
			return FALSE

	return TRUE

/obj/structure/blueprint_site/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/rogueweapon/hammer))
		user.changeNext_move(CLICK_CD_MELEE)

		pull_resources()

		var/missing = ""
		for(var/res in required_resources)
			if(required_resources[res] > 0)
				var/obj/item/temp = res
				missing += "[initial(temp.name)]: [required_resources[res]] pcs. "

		if(missing != "")
			to_chat(user, span_warning("缺少材料！请将以下材料放在附近地面上：[missing]"))
			playsound(src, 'sound/items/bsmithfail.ogg', 50, 1)
			return TRUE

		var/batch_size = 3

		if(length(active_ghosts))
			for(var/i in 1 to batch_size)
				if(!length(active_ghosts)) break

				var/obj/effect/blueprint_ghost/G = active_ghosts[1]
				var/turf/target_turf = get_turf(G)

				if(!can_solidify_target(target_turf, user, G.entry_data))
					playsound(src, 'sound/items/bsmithfail.ogg', 50, 1)
					return TRUE

				solidify_ghost()

		if(length(unbuilt_entries))
			for(var/i in 1 to batch_size)
				if(!length(unbuilt_entries)) break
				spawn_next_ghost()

		if(user.mind)
			user.mind.add_sleep_experience(/datum/skill/craft/carpentry, (user.STAINT * 0.3))

		playsound(src, 'sound/items/bsmith4.ogg', 100, 1)

		var/percent = total_tiles_count > 0 ? round((built_tiles_count / total_tiles_count) * 100) : 0
		user.visible_message(span_notice("[user]挥锤敲打着建筑工地。"), span_notice("你正在施工……（<b>[percent]%</b>）"))

		if(!length(active_ghosts) && !length(unbuilt_entries))
			finish_site(user)

		return TRUE
	return ..()

/obj/structure/blueprint_site/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!isliving(user) || user.incapacitated())
		return

	user.visible_message(
		span_warning("[user]开始拆除[src]……"),
		span_notice("你开始拆除[src]……")
	)

	if(do_after(user, 10 SECONDS, target = src))
		user.visible_message(
			span_warning("[user]彻底拆除了[src]！"),
			span_notice("你拆除了建筑工地。")
		)
		qdel(src)

/obj/structure/blueprint_site/proc/spawn_next_ghost()
	if(!length(unbuilt_entries)) return

	var/list/entry = unbuilt_entries[1]
	unbuilt_entries.Cut(1, 2)

	var/b_type = entry["type"]
	var/dx = isnum(entry["x"]) ? entry["x"] : text2num(entry["x"])
	var/dy = isnum(entry["y"]) ? entry["y"] : text2num(entry["y"])
	var/dz = isnum(entry["z"]) ? entry["z"] : (text2num(entry["z"]) || 0)
	var/chosen_dir = isnum(entry["dir"]) ? entry["dir"] : (text2num(entry["dir"]) || 2)

	var/list/info = GLOB.blueprint_buildable_types[b_type]
	if(!info) return

	var/atom/build_path = info["path"]
	var/i_file = info["icon_file"] || initial(build_path.icon)
	var/i_state = info["icon_state"] || initial(build_path.icon_state)

	var/turf/target_turf = get_blueprint_target_turf(get_turf(src), dx, dy, dz)
	if(target_turf)
		var/obj/effect/blueprint_ghost/G = new(target_turf)
		G.icon = i_file
		G.icon_state = i_state
		G.setDir(chosen_dir)
		G.name = "蓝图：[info["name"]]"
		G.master = src
		G.entry_data = entry
		active_ghosts += G

/obj/structure/blueprint_site/proc/solidify_ghost()
	if(!length(active_ghosts)) return

	var/obj/effect/blueprint_ghost/G = active_ghosts[1]
	active_ghosts.Cut(1, 2)

	if(QDELETED(G)) return

	var/list/entry = G.entry_data
	var/b_type = entry["type"]
	var/chosen_dir = isnum(entry["dir"]) ? entry["dir"] : (text2num(entry["dir"]) || 2)
	var/list/info = GLOB.blueprint_buildable_types[b_type]
	var/turf/target_turf = get_turf(G)

	qdel(G)

	if(target_turf && info)
		var/build_path = info["path"]

		if(ispath(build_path, /turf))
			if(!(ispath(build_path, /turf/closed) && isclosedturf(target_turf)))
				var/turf/new_turf = target_turf.PlaceOnTop(build_path, flags = CHANGETURF_INHERIT_AIR)
				if(new_turf)
					new_turf.setDir(chosen_dir)
		else if(ispath(build_path, /atom/movable))
			var/atom/movable/AM = new build_path(target_turf)
			AM.setDir(chosen_dir)
			if(hascall(AM, "OnCrafted"))
				AM.OnCrafted(chosen_dir)

		built_tiles_count++

/obj/structure/blueprint_site/proc/pull_resources()
	var/has_needed = FALSE
	for(var/res in required_resources)
		if(required_resources[res] > 0)
			has_needed = TRUE
			break
	if(!has_needed) return

	for(var/obj/item/I in range(3, src))
		if(!isturf(I.loc))
			continue

		if(istype(I, /obj/item/natural/bundle))
			var/obj/item/natural/bundle/B = I
			if(required_resources[B.stacktype] && required_resources[B.stacktype] > 0)
				var/needed = required_resources[B.stacktype]
				var/take = min(B.amount, needed)
				B.amount -= take
				required_resources[B.stacktype] -= take
				if(B.amount <= 0)
					qdel(B)
				else
					B.update_bundle()
		else
			for(var/res_path in required_resources)
				if(required_resources[res_path] > 0 && istype(I, res_path))
					required_resources[res_path] -= 1
					qdel(I)
					break

/obj/structure/blueprint_site/proc/finish_site(mob/user)
	visible_message(span_notice("<b>[src]已完工！建筑已全部建成！</b>"))
	playsound(src, 'sound/foley/Building-01.ogg', 100, 1)
	qdel(src)


/mob
	var/list/arcyne_blueprint_data = list()
	var/arcyne_blueprint_floors = 2

/obj/effect/proc_holder/spell/self/architect_plan
	name = "建筑师的构想"
	desc = "展开脑海中的蓝图以规划建筑。设计将保存在你的记忆中。"
	action_icon = 'icons/mob/actions/roguespells.dmi'
	action_icon_state = "spell0"
	panel = "Spells"
	recharge_time = 0
	var/list/scanned_grid = list()

/obj/effect/proc_holder/spell/self/architect_plan/ui_state(mob/user)
	return GLOB.always_state

/obj/effect/proc_holder/spell/self/architect_plan/ui_host(mob/user)
	return user

/obj/effect/proc_holder/spell/self/architect_plan/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/obj/effect/proc_holder/spell/self/architect_plan/cast(list/targets, mob/living/user = usr)
	if(user)
		ui_interact(user)
	return TRUE

/obj/effect/proc_holder/spell/self/architect_plan/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BlueprintPlanner", name)
		ui.open()

/obj/effect/proc_holder/spell/self/architect_plan/ui_static_data(mob/user)
	var/list/data = get_blueprint_static_tgui_data()
	data["max_radius"] = MAX_SPELL_RADIUS
	data["library_blueprints"] = blueprint_library_cache
	return data

/obj/effect/proc_holder/spell/self/architect_plan/ui_data(mob/user)
	var/list/data = list()
	if(ismob(user))
		data["saved_grid"] = user.arcyne_blueprint_data
		data["saved_floors"] = user.arcyne_blueprint_floors
		data["scanned_grid"] = scanned_grid
		data["user_ckey"] = user.ckey
	return data

/obj/effect/proc_holder/spell/self/architect_plan/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.) return

	var/mob/living/L = usr
	if(!istype(L)) return

	if(handle_blueprint_library_act(action, params, L, ui))
		return TRUE

	if(action == "scan_terrain")
		var/radius = min(params["radius"] || MAX_SPELL_RADIUS, MAX_SPELL_RADIUS)
		var/max_z = clamp(text2num(params["max_floors"]) || 2, 2, 4)
		var/turf/center = get_turf(L)
		var/list/scanned = list()
		for(var/dx in -radius to radius)
			for(var/dy in -radius to radius)
				for(var/dz in 0 to max_z - 1)
					var/turf/T = get_blueprint_target_turf(center, dx, dy, dz)
					if(!T) continue

					var/is_blocked = FALSE
					if(isclosedturf(T))
						is_blocked = TRUE
					else
						for(var/obj/O in T)
							if(O.density && (istype(O, /obj/structure) || istype(O, /obj/machinery)))
								is_blocked = TRUE
								break

					if(is_blocked)
						scanned += list(list("x"=dx, "y"=dy, "z"=dz, "layer"="wall"))
					else if(!istype(T, /turf/open/transparent/openspace) && !istype(T, /turf/open/water))
						scanned += list(list("x"=dx, "y"=dy, "z"=dz, "layer"="floor"))

		scanned_grid = scanned
		return TRUE

	if(action == "save_design")
		var/list/packed_data = params["packed_data"]
		var/list/safe_data = list()
		for(var/b_type in packed_data)
			var/list/coords = packed_data[b_type]
			for(var/coord_str in coords)
				var/list/parts = splittext(coord_str, ",")
				if(length(parts) < 3) continue

				var/dx = text2num(parts[1])
				var/dy = text2num(parts[2])
				var/dz = text2num(parts[3])
				var/ddir = length(parts) >= 4 ? text2num(parts[4]) : 2

				if(!isnum(dx) || !isnum(dy) || !isnum(dz) || !isnum(ddir))
					continue

				if(abs(dx) > MAX_SPELL_RADIUS || abs(dy) > MAX_SPELL_RADIUS)
					continue

				safe_data += list(list(
					"x" = dx,
					"y" = dy,
					"z" = dz,
					"type" = b_type,
					"dir" = ddir
				))

		L.arcyne_blueprint_data = safe_data
		L.arcyne_blueprint_floors = clamp(text2num(params["max_floors"]) || 2, 2, 4)
		to_chat(L, span_notice("建筑设计已存入记忆！"))
		SStgui.close_uis(src)
		return TRUE

	if(action == "clear_design")
		L.arcyne_blueprint_data = list()
		to_chat(L, span_notice("建筑设计已从记忆中清除。"))
		return TRUE

/obj/effect/proc_holder/spell/targeted/architect_conjure
	name = "矩阵具现"
	desc = "将记忆中的建筑矩阵具现于目标区域。"
	action_icon = 'icons/mob/actions/roguespells.dmi'
	action_icon_state = "shieldsparkles"
	panel = "Spells"
	recharge_time = 300
	releasedrain = 10
	sparks_amt = 2
	invocation_type = "whisper"
	invocations = list("Struo et Creo...", "Forma Materia...")
	range = 1

/obj/effect/proc_holder/spell/targeted/architect_conjure/choose_targets(mob/user = usr)
	to_chat(user, span_notice("你准备将矩阵具现。<b>鼠标中键点击</b>目标地面以施法。"))
	add_ranged_ability(user, null, TRUE)

/obj/effect/proc_holder/spell/targeted/architect_conjure/InterceptClickOn(mob/living/caller, params, atom/A)
	if(..()) return TRUE
	
	var/turf/T = get_turf(A)
	if(!T) return TRUE

	if(get_dist(caller, T) > range)
		to_chat(caller, span_warning("太远了！"))
		return TRUE

	if(get_turf(caller) != T && !caller.Adjacent(T))
		to_chat(caller, span_warning("你无法越过障碍触及该区域！"))
		return TRUE
		
	perform(list(T), user=caller)
	remove_ranged_ability(span_notice("你释放了编织的魔力。"))
	return FALSE

/obj/effect/proc_holder/spell/targeted/architect_conjure/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/turf/T = targets[1]
	if(!T || !user)
		return FALSE

	if(!length(user.arcyne_blueprint_data))
		to_chat(user, span_warning("你的脑海中空空如也……请先施放‘建筑师的构想’。"))
		revert_cast(user)
		return FALSE

	if(!check_blueprint_placement_valid(T, user, user.arcyne_blueprint_data, user.arcyne_blueprint_floors))
		to_chat(user, span_warning("放置位置无效！矩阵啪的一声崩解了。"))
		revert_cast(user)
		return FALSE

	var/obj/structure/blueprint_site/site = new(T)
	site.max_floors = user.arcyne_blueprint_floors
	site.setup_design(user.arcyne_blueprint_data, user)

	user.visible_message(
		span_notice("[user]具现出了一座[user.arcyne_blueprint_floors]层建筑的矩阵！"),
		span_notice("你编织奥术之流，成功具现出了一座[user.arcyne_blueprint_floors]层建筑的矩阵！")
	)
	return TRUE

#undef MAX_SPELL_RADIUS
