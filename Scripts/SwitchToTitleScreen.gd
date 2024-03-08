extends Control

func _ready():
	await($VelocityLogo/AnimationPlayer.animation_finished)
	go_to_menu()

func _input(event):
	var touched = event is InputEventScreenTouch and event.pressed
	var start_button_pressed = event.is_action_pressed("MenuConfirm") or event.is_action_pressed("Menu")
	if start_button_pressed or touched:
		go_to_menu()

func go_to_menu():
	$VelocityLogo/AnimationPlayer.stop()
	get_tree().change_scene_to_file("res://menu.tscn")
