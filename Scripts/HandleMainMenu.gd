extends Control

var selected_option_index = 0

func _ready():
	set_exit_label()
	select_option(selected_option_index)
	get_tree().set_quit_on_go_back(false)

func _input(event):
	if $ExitPopup.visible:
		if event.is_action_pressed("ExitConfirm") or event.is_action_pressed("MenuConfirm"):
			get_tree().quit()
		elif event.is_action_pressed("ExitCancel") or event.is_action_pressed("MenuBack"):
			$MenuBack.play()
			$ExitPopup.hide()
	else:
		if event.is_action_pressed("MenuUp") and Input.is_action_just_pressed("MenuUp"):
			select_previous_option()
		elif event.is_action_pressed("MenuDown") and Input.is_action_just_pressed("MenuDown"):
			select_next_option()
		elif event.is_action_pressed("MenuConfirm"):
			execute_selected_option()

func select_option(index):
	$MenuOptions.get_children()[selected_option_index].modulate = Color(1, 1, 1)
	selected_option_index = index
	$MenuOptions.get_children()[selected_option_index].modulate = Color(0, .5, 1)  # Highlight selected option

func select_next_option():
	$MenuMove.play()
	select_option((selected_option_index + 1) % $MenuOptions.get_children().size())

func select_previous_option():
	$MenuMove.play()
	select_option((selected_option_index - 1 + $MenuOptions.get_children().size()) % $MenuOptions.get_children().size())

func execute_selected_option():
	# Execute the action corresponding to the selected option
	match selected_option_index:
		0:
			start_new_game()
		1:
			open_options_menu()
		2:
			exit_game()

func start_new_game():
	get_tree().change_scene_to_file("res://game.tscn")

func open_options_menu():
	get_tree().change_scene_to_file("res://help.tscn")

func exit_game():
	$MenuSelect.play()
	$ExitPopup.show()

func set_exit_label():
	$MenuOptions/ExitGame.text = "EXIT TO " + OS.get_name().to_upper()
