GLOBAL_LIST_EMPTY(steward_export_machines)

/// Marker placed in the Crown warehouse. When the Steward fulfills an equipment standing
/// order, the economy subsystem iterates items in `view(1, M)` around each registered
/// machine - confined to a 3x3 footprint per machine to avoid world-wide scans.
/// Mapped invisible/indestructible; mappers drop one per warehouse cluster.
/obj/structure/roguemachine/steward_export
	name = "宫廷总管出口机"
	desc = "一台安置在王室文书统计出口货物之处附近的机器。放在机器收取范围内的货物会计入王室常设订单。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "ballooner"
	density = FALSE
	anchored = TRUE
	max_integrity = 0
	blade_dulling = DULLING_BASH
	resistance_flags = FIRE_PROOF | LAVA_PROOF | INDESTRUCTIBLE | UNACIDABLE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/steward_export/Initialize(mapload)
	. = ..()
	GLOB.steward_export_machines += src

/obj/structure/roguemachine/steward_export/Destroy()
	GLOB.steward_export_machines -= src
	return ..()
