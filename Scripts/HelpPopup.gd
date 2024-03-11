extends ColorRect

var current_page = 1
var total_pages = 3

func _ready():
	$MenuSelect.play()

func _input(event):
	if event.is_action_pressed("MenuBack"):
		back_to_menu()
	if event.is_action_pressed("MenuUp"):
		if current_page > 1:
			$MenuMove.play()
			current_page -= 1
	if event.is_action_pressed("MenuDown"):
		if current_page < total_pages:
			$MenuMove.play()
			current_page += 1

func _on_button_pressed():
	back_to_menu()
	
func back_to_menu():
	$MenuBack.play()
	get_tree().change_scene_to_file("res://menu.tscn")

func _process(delta):
	for i in range(1, total_pages + 1):
		var page = get_node("Pages/Page" + str(i))
		if i == current_page:
			page.show()
		else:
			page.hide()
	
	$PageDisplay.text = "Page " + str(current_page)

