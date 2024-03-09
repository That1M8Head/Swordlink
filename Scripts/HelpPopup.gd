extends ColorRect

func _input(event):
	if event.is_action_pressed("MenuBack"):
		visible = false

func _process(delta):
	var move_command: String
	var jump_command: String
	var shift_command: String
	var attack_command: String
	var special_command: String
	var evade_command: String
	var menu_command: String
	
	match Input.get_joy_name(0):
		"XInput Gamepad":
			move_command = "Left Stick"
			jump_command = "A"
			shift_command = "RB/RT"
			attack_command = "Y"
			special_command = "X"
			evade_command = "B"
			menu_command = "Start"
		"PS4 Controller":
			move_command = "Left Stick"
			jump_command = "Cross"
			shift_command = "R1/R2"
			attack_command = "Triangle"
			special_command = "Square"
			evade_command = "Circle"
			menu_command = "Options"
		"PS5 Controller":
			move_command = "Left Stick"
			jump_command = "Cross"
			shift_command = "R1/R2"
			attack_command = "Triangle"
			special_command = "Square"
			evade_command = "Circle"
			menu_command = "Options"
		"":
			if DisplayServer.is_touchscreen_available():
				move_command = "◀/▶"
				jump_command = "▲"
				shift_command = "M"
				attack_command = "Sword"
				special_command = "Thrust"
				evade_command = "Dash"
				menu_command = "BACK"
			else:
				move_command = "←/→ or A/D"
				jump_command = "Space"
				shift_command = "Shift"
				attack_command = "Z or LMB"
				special_command = "X or RMB"
				evade_command = "C"
				menu_command = "Esc"
		_:
			move_command = "Left Stick"
			jump_command = "A"
			shift_command = "R1/R2"
			attack_command = "Y"
			evade_command = "X"
			menu_command = "Start"
	
	var controls = $HBoxContainer/Controls
	var controls_replaced = controls.text
	controls_replaced = controls_replaced.replace("{MOV}", move_command)
	controls_replaced = controls_replaced.replace("{JMP}", jump_command)
	controls_replaced = controls_replaced.replace("{SHIFT}", shift_command)
	controls_replaced = controls_replaced.replace("{EVADE}", evade_command)
	controls_replaced = controls_replaced.replace("{ATK}", attack_command)
	controls_replaced = controls_replaced.replace("{SPEC}", special_command)
	controls_replaced = controls_replaced.replace("{MENU}", menu_command)
	controls.text = controls_replaced

func _on_button_pressed():
	visible = false
