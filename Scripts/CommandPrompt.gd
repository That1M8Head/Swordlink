extends TextEdit

var base_message: String = """rom-wack
PC: yes SR: stuffed USP: it sure does point SSP: it also points XCPT: fell off stage TASK: rom-wack
DR: the doctor will see you now
AR: why would you want AR in a 2D hack-and-slash
SF: my favourite one is SFIV
new-rom-wack
-> Welcome to the new ROMWack! We decided to make some changes and now ROMWack is a proper command environment.
-> To return to Swordlink: Glitchfall Chronicles, type "exit" followed by the enter key.
"""

var shutup: bool

func _ready():
	text = base_message
	call_deferred("grab_focus")
	reset_caret_position()
	if Input.get_joy_name(0) != "":
		speak_output("ROMWack will not work with your %s. Please use a keyboard." % Input.get_joy_name(0))
	if DisplayServer.is_touchscreen_available():
		speak_output("Your on-screen keyboard's Enter key will not work. Use the touch button at the top right instead.")

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		DisplayServer.virtual_keyboard_show(get_line(get_line_count()))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Enter"):
		if not Input.is_key_pressed(KEY_ENTER):
			text += "\n"
		process_command(get_line(get_line_count() - 2))
	reset_caret_position()

func process_command(command: String):
	match command.to_lower():
		"clear":
			text = ""
		"ls":
			command_output("total 3")
			command_output("drwxr-xr-x    2 rom-wack    rom-wack        40 Mar  7 20:21 crap")
			command_output("drwxr-xr-x    2 rom-wack    rom-wack        40 Mar  7 20:21 junk")
			command_output("drwxr-xr-x    2 rom-wack    rom-wack        40 Mar  7 20:21 crappy junk")
		"exit":
			command_output("Exiting ROMWack and returning you to Swordlink: Glitchfall Chronicles...")
			await(get_tree().create_timer(1.5).timeout)
			call_deferred("return_to_menu")
		"hello":
			speak_output("Hi! :)")
		"help":
			var messages = [
				"Oh, I'm sure you can figure it out.",
				"You know, back in the Amiga days, they didn't have a help command.",
				"Sorry, but I also forgot how to use myself. Help me.",
				"Velocity wrote this whole damn command prompt instead of making the game...",
				"Just poke around with random commands and see what you find.",
				"Do you know who ate all the doughnuts?",
				"Did you know? Your protagonist's name is Joel.",
				"plae DMC2 is the beast, donte is good and bets in geaem play game pl,.z",
				"Boy, I sure hope the full version of Swordlink retains this Easter egg!",
				"Did you know? This game was originally going to be called \"Guy with a Sword\".",
				"Velocity better get at LEAST 90 marks for this.",
				"Why do we all have to wear these ridiculous ties?",
			]
			command_output(messages[randi_range(0, len(messages) - 1)])
		"joel":
			speak_output("Yes, that's you.")
		"man":
			speak_output("No, I'm actually a woman.")
		"me":
			speak_output("What about you?")
		"name":
			speak_output("ROMWack")
		"ping":
			speak_output("pong")
		"random":
			command_output(str(randi_range(0, 255)))
		"rom-wack":
			get_tree().reload_current_scene()
		"run":
			speak_output("There is nowhere you can run.")
		"shutdown":
			command_output("Exiting ROMWack and shutting down...")
			await(get_tree().create_timer(1.5).timeout)
			get_tree().quit()
		"shutup":
			shutup = true
		"sudo":
			command_output("")
		"wack":
			command_output("Wacking ROM...")
			await(get_tree().create_timer(3).timeout)
			speak_output("The ROM has successfully been wacked.")
		"woman":
			speak_output("Correct.")
		"you":
			speak_output("My name's ROMWack. I was named after the old Amiga debugger.")
		_:
			if len(command) > 127:
				speak_output("Command too long.")
			else:
				command_output("Unknown command: " + command)

func command_output(output: String):
	text += "-> " + output + "\n"
	reset_caret_position()

func speak_output(output: String):
	if not shutup:
		text += "ROMWack says: " + output + "\n"
	reset_caret_position()

func reset_caret_position():
	set_caret_line(get_line_count())

func return_to_menu():
	get_tree().change_scene_to_file("res://menu.tscn")
