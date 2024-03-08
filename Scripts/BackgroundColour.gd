extends ColorRect

func _ready():
	const light_color: Color = "#798c9b"
	const dark_color: Color = "#525252"
	
	if DisplayServer.is_dark_mode():
		color = dark_color
		get_parent().get_node("Stage").modulate = dark_color
	else:
		color = light_color
		get_parent().get_node("Stage").modulate = "white"
