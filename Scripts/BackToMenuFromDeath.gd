extends Control

func _process(delta):
	if Input.is_action_just_pressed("Menu"):
		get_tree().change_scene_to_file("res://menu.tscn")
		
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		get_tree().change_scene_to_file("res://menu.tscn")
