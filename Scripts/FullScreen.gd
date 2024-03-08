extends Node

func _process(delta):
	var full_screen = DisplayServer.window_get_mode()
	if Input.is_action_just_pressed("FullScreen"):
		if full_screen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
