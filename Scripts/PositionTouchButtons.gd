extends Node2D

func _process(delta):
	var viewport_size = get_viewport_rect().size
	var buttons_height = 700

	var left_position = Vector2(80, buttons_height)
	$Left.position = left_position

	var right_position = Vector2(viewport_size.x - 80, buttons_height)
	$Right.position = right_position
