extends Label

func _process(delta):
	match Input.get_joy_name(0):
		"XInput Gamepad":
			text = "Press Menu to return to menu"
		"PS4 Controller":
			text = "Press Options to return to menu"
		"PS5 Controller":
			text = "Press Options to return to menu"
		"":
			if DisplayServer.is_touchscreen_available():
				text = "Touch anywhere to return to menu"
			else:
				text = "Press Esc to return to menu"
		_:
			text = "Press JOY_BUTTON_START to return to menu"
