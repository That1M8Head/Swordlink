extends TextureRect

func _ready():
	const dark_color: Color = "#525252"

	if DisplayServer.is_dark_mode():
		modulate = dark_color
