extends Panel

enum DIFFICULTY {
	FRAMECAPPED,
	BOOSTED,
	OVERCLOCKED,
	GLITCHFALL
}

var selected_option_index: int

func _ready():
	select_option(DIFFICULTY.BOOSTED)

func _input(event):
	if not visible:
		return
	if event.is_action_pressed("MenuBack"):
		get_node("/root/MainMenu/MenuBack").play()
		hide()
	else:
		if event.is_action_pressed("MenuUp") and Input.is_action_just_pressed("MenuUp"):
			select_previous_option()
		elif event.is_action_pressed("MenuDown") and Input.is_action_just_pressed("MenuDown"):
			select_next_option()
		elif event.is_action_pressed("MenuConfirm"):
			execute_selected_option()

func select_option(index):
	$Message/DifficultyOptions.get_children()[selected_option_index].modulate = Color(1, 1, 1)
	selected_option_index = index
	update_tooltip()
	$Message/DifficultyOptions.get_children()[selected_option_index].modulate = Color(0, .5, 1)

func select_next_option():
	get_node("/root/MainMenu/MenuMove").play()
	select_option((selected_option_index + 1) % $Message/DifficultyOptions.get_children().size())

func select_previous_option():
	get_node("/root/MainMenu/MenuMove").play()
	select_option((selected_option_index - 1 + $Message/DifficultyOptions.get_children().size()) % $Message/DifficultyOptions.get_children().size())
	
func update_tooltip():
	var tooltip = $Message/Tooltip
	var description: String
	match selected_option_index:
		DIFFICULTY.FRAMECAPPED:
		DIFFICULTY.BOOSTED:
		DIFFICULTY.OVERCLOCKED:
		DIFFICULTY.GLITCHFALL:
	tooltip.text = description

func execute_selected_option():
	var difficulty_handler = get_node("/root/DifficultyHandling")
	difficulty_handler.level = selected_option_index
	start_game()

func start_game():
	get_tree().change_scene_to_file("res://game.tscn")
