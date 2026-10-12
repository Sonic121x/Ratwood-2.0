// 身体回归仍使用角色当前的美德、高潮记录和心情期限。
/datum/z121_return_snapshot/restore(mob/living/carbon/human/H, preparing = FALSE)
	var/datum/z121_ethos/R = H.z121_get_ethos()
	R?.capture_moods()
	. = ..()
	if(R)
		R.effects_active = FALSE
		R.sync_traits()
		R.sync_effects()
