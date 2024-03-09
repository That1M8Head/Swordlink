extends Control

func _ready():
	var message = $Background/Error/Box/InnerBoxMargin/ErrorMessage
	if DisplayServer.is_touchscreen_available():
		message.text = message.text.replace("RESTART_INSTRUCTION", "Touch the screen")
	elif Input.get_joy_name(0) == "":
		message.text = message.text.replace("RESTART_INSTRUCTION", "Press left mouse button")
	else:
		message.text = message.text.replace("RESTART_INSTRUCTION", "Press start button")

func _process(delta):
	if Input.is_action_just_pressed("Menu"):
		get_tree().change_scene_to_file("res://menu.tscn")
	if Input.is_action_just_pressed("ROMWack"):
		open_debugger()

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		if event.position.y < get_viewport().size.y / 3:
			get_tree().change_scene_to_file("res://debugger.tscn")
		else:
			get_tree().change_scene_to_file("res://menu.tscn")
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			open_debugger()
		else:
			get_tree().change_scene_to_file("res://menu.tscn")

func open_debugger():
	get_tree().change_scene_to_file("res://debugger.tscn")
