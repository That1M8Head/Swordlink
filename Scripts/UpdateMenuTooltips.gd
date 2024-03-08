extends Label

func _process(delta):
	match Input.get_joy_name(0):
		"XInput Gamepad":
			text = "D-Pad Up/Down = Select | A = Confirm"
		"PS4 Controller":
			text = "D-Pad Up/Down = Select | X = Confirm"
		"PS5 Controller":
			text = "D-Pad Up/Down = Select | X = Confirm"
		"":
			text = "Arrows Up/Down = Select | Enter = Confirm"
		_:
			text = "JOY_BUTTON_DPAD_UP/DOWN = Select | JOY_BUTTON_A = Confirm"
