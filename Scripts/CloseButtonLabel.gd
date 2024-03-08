extends Button

func _process(delta):
	match Input.get_joy_name(0):
		"XInput Gamepad":
			text = "B = Close"
		"PS4 Controller":
			text = "O = Close"
		"PS5 Controller":
			text = "O = Close"
		"":
			text = "Close"
		_:
			text = "JOY_BUTTON_B = Close"
