extends TouchScreenButton

func _process(delta):
	var viewport_size = get_viewport_rect().size
	var buttons_height = 50

	position = Vector2(viewport_size.x - 320, buttons_height)
