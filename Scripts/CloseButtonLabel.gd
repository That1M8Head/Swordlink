extends Button

func _process(delta):
	match Input.get_joy_name(0):
		"XInput Gamepad":
			text = "  B = Back to Menu  "
		"PS4 Controller":
			text = "  O = Back to Menu  "
		"PS5 Controller":
			text = "  O = Back to Menu  "
		"":
			text = "  Back to Menu  "
		_:
			text = "  B = Back to Menu  "
