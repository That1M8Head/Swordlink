extends Camera2D

var movement_speed = 600
var edge_margin = 150

func _process(delta):
	position.x = get_parent().velocity.x / 2.5
	"""
	# Get the player's position
	var player_position = get_parent().get_node("Joel").global_position

	# Get the size of the viewport
	var viewport_size = get_viewport_rect().size

	# Calculate the boundaries of the viewport, considering the zoom level
	var left_boundary = position.x - viewport_size.x / 2 / zoom.x + edge_margin
	var right_boundary = position.x + viewport_size.x / 2 / zoom.x - edge_margin
	var top_boundary = position.y - viewport_size.y / 2 / zoom.y + edge_margin
	var bottom_boundary = position.y + viewport_size.y / 2 / zoom.y - edge_margin

	# Adjust camera position based on player's position relative to viewport edges
	if player_position.x < left_boundary:
		position.x -= movement_speed * delta
	elif player_position.x > right_boundary:
		position.x += movement_speed * delta
	
	if player_position.y < top_boundary:
		position.y -= movement_speed * delta
	elif player_position.y > bottom_boundary:
		position.y += movement_speed * delta
	"""

