/client/var/list/held_mouse_side_keys = list()

/// MouseDown/Up identify the changed button. Click and drag events can carry only button flags.
/proc/mouse_side_key(list/modifiers)
	var/button = modifiers[BUTTON_CHANGED] || modifiers[BUTTON_DRAGGED]
	if(button)
		switch(button)
			if("xbutton1")
				return "MOUSE4"
			if("xbutton2")
				return "MOUSE5"
		return null
	if(modifiers[LEFT_CLICK] || modifiers[MIDDLE_CLICK] || modifiers[RIGHT_CLICK])
		return null
	if(modifiers["xbutton1"])
		return "MOUSE4"
	if(modifiers["xbutton2"])
		return "MOUSE5"
	return null

/client/proc/handle_mouse_side_binding(list/modifiers, pressed)
	var/button = mouse_side_key(modifiers)
	if(!button)
		return FALSE
	var/held_key = held_mouse_side_keys[button]
	if(held_key)
		// Use the modifiers from the original press. A new press also recovers a release lost to a popup.
		held_mouse_side_keys -= button
		keyUp(held_key)
	if(pressed)
		var/full_key = "[modifiers[ALT_CLICKED] ? "Alt" : ""][modifiers[CTRL_CLICKED] ? "Ctrl" : ""][modifiers[SHIFT_CLICKED] ? "Shift" : ""][button]"
		if(mob && prefs?.key_bindings[full_key])
			held_mouse_side_keys[button] = full_key
			press_key(full_key, TRUE)
	return TRUE

/client/DblClick(object, location, control, params)
	if(mouse_side_key(params2list(params)))
		return
	return ..()
