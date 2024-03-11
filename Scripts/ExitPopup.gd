extends Panel
	
func get_labels() -> Array:
	var confirm_label: String
	var cancel_label: String
	match Input.get_joy_name(0):
		"XInput Gamepad":
			confirm_label = "A"
			cancel_label = "B"
		"PS4 Controller":
			confirm_label = "Cross"
			cancel_label = "Circle"
		"PS5 Controller":
			confirm_label = "Cross"
			cancel_label = "Circle"
		"":
			if DisplayServer.is_touchscreen_available():
				confirm_label = "OK"
				cancel_label = "BACK"
			else:
				confirm_label = "Y"
				cancel_label = "N"
		_:
			confirm_label = "A"
			cancel_label = "B"
	return [confirm_label, cancel_label]
	
func get_exit_message() -> String:
	var messages = [
		"Where the peck are you going?",
		"Alright, leave. See if I care.",
		"Just because it's only five seconds long...",
		"Don't quit now! We're still spending your money!",
		"I wouldn't leave if I were you. %s is much worse." % OS.get_name(),
		"I'd leave; this is just some demons in one level. What a bore.",
		"The programmer has a nap. Hold out! Programmer!",
		"Did you know about the developer console Easter egg?",
	]
	return messages[randi_range(0, messages.size() - 1)]

func _ready():
	set_text()
	
func _visibility_changed():
	set_text()
	
func set_text():
	$Message/Title.text = get_exit_message()
	$Message/Confirm.text = "Press %s to quit the game." % get_labels()[0]
	$Message/Cancel.text = "Press %s to return to menu." % get_labels()[1]
