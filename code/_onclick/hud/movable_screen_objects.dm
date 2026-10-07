
//////////////////////////
//Movable Screen Objects//
//   By RemieRichards	//
//////////////////////////


//Movable Screen Object
//Not tied to the grid, places it's center where the cursor is

/atom/movable/screen/movable
	var/snap2grid = FALSE
	var/moved = FALSE
	var/locked = FALSE
	var/x_off = -16
	var/y_off = -16

//Snap Screen Object
//Tied to the grid, snaps to the nearest turf

/atom/movable/screen/movable/snap
	snap2grid = TRUE


/atom/movable/screen/movable/MouseDrop(over_object, src_location, over_location, src_control, over_control, params)
	if(locked) //no! I am locked! begone!
		return
	var/list/PM = params2list(params)

	//No screen-loc information? abort.
	if(!PM || !PM["screen-loc"])
		return

	//Split screen-loc up into X+Pixel_X and Y+Pixel_Y
	var/list/screen_loc_params = splittext(PM["screen-loc"], ",")

	//Split X+Pixel_X up into list(X, Pixel_X)
	var/list/screen_loc_X = splittext(screen_loc_params[1],":")

	//Split Y+Pixel_Y up into list(Y, Pixel_Y)
	var/list/screen_loc_Y = splittext(screen_loc_params[2],":")

	if(snap2grid) //Discard Pixel Values
		screen_loc = "[screen_loc_X[1]],[screen_loc_Y[1]]"

	else //Normalise Pixel Values (So the object drops at the center of the mouse, not 16 pixels off)
		var/pix_X = text2num(screen_loc_X[2]) + x_off
		var/pix_Y = text2num(screen_loc_Y[2]) + y_off
		screen_loc = "[screen_loc_X[1]]:[pix_X],[screen_loc_Y[1]]:[pix_Y]"

	moved = screen_loc


//Debug procs
/client/proc/test_movable_UI()
	set category = "调试"
	set name = "生成可移动界面对象"

	var/atom/movable/screen/movable/M = new()
	M.name = "可移动界面对象"
	M.icon_state = "block"
	M.maptext = "可移动"
	M.maptext_width = 64

	var/screen_l = input(usr,"放在屏幕何处？（格式为 'X,Y'，例如 '1,1' 表示左下角）","生成可移动界面对象") as text|null
	if(!screen_l)
		return

	M.screen_loc = screen_l

	screen += M


/client/proc/test_snap_UI()
	set category = "调试"
	set name = "生成吸附界面对象"

	var/atom/movable/screen/movable/snap/S = new()
	S.name = "吸附界面对象"
	S.icon_state = "block"
	S.maptext = "吸附"
	S.maptext_width = 64

	var/screen_l = input(usr,"放在屏幕何处？（格式为 'X,Y'，例如 '1,1' 表示左下角）","生成吸附界面对象") as text|null
	if(!screen_l)
		return

	S.screen_loc = screen_l

	screen += S
