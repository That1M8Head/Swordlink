extends TextEdit

var base_message: String = """rom-wack
-> PC: yes SR: stuffed USP: it sure does point SSP: it also points XCPT: fell off stage TASK: rom-wack
-> DR: the doctor will see you now
-> AR: why would you want AR in a 2D hack-and-slash
-> SF: my favourite one is SFIV
"""

var shutup: bool

func _ready():
	text = base_message
	call_deferred("grab_focus")
	startup_hints()
	reset_caret_position()
	if Input.get_joy_name(0) != "":
		speak_output("ROMWack will not work with your %s. Please use a keyboard." % Input.get_joy_name(0))

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		DisplayServer.virtual_keyboard_show(get_line(get_line_count()))
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ENTER:
		get_viewport().set_input_as_handled()
		handle_enter_keypress()

func handle_enter_keypress():
	var caret_at_bottom = get_caret_line() == get_line_count() - 1
	if caret_at_bottom:
		process_command(get_line(get_line_count() - 1), true)
	else:
		var line = get_line(get_caret_line())
		reset_caret_position()
		process_command(line, false)
	reset_caret_position()

func startup_hints():
	command_output("Welcome to ROMWack! Type some commands or type some GDScript expressions.")
	command_output(" Type \"cmds\" for a list of built-in commands. All other input will be treated as a GDScript expression.")
	command_output("To return to Swordlink: Glitchfall Chronicles, type \"exit\" followed by the enter key.")

func process_command(command: String, linebreak: bool):
	if linebreak:
		text += "\n"
	match command.to_lower():
		"clear":
			text = ""
		"cmds":
			var commands_msg = [
				"== Useful Commands ==",
				"clear - Clear the buffer",
				"cmds - Display this message",
				"exit - Return to Swordlink: Glitchfall Chronicles",
				"rom-wack - Reset this program",
				"shutdown - Exit the game entirely",
				"== Fun Commands ==",
				"ls - List fake directories",
				"random - Output a random number",
				"wack - Wack the ROM",
				"== Talking to ROMWack ==",
				"hello - Say hello to her",
				"help - Get \"help\" from her",
				"joel - Confirm your character's name",
				"man - Incorrectly call her a man",
				"me - Present yourself to her",
				"name - Ask for her name",
				"ping - Prompt her to say \"pong\"",
				"run - Try to run away from her",
				"woman - Correctly call her a woman",
				"you - Ask who she is",
				"=== All other inputs will be treated as GDScript. ===",
			]
			for cmd in commands_msg:
				command_output(cmd)
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
				"Did you know? This is practically a developer console.",
			]
			speak_output(messages[randi_range(0, len(messages) - 1)])
		"joel":
			speak_output("Yes, that's you.")
		"man":
			speak_output("No, I'm actually a woman.")
		"me":
			if OS.has_environment("USER"):
				speak_output("You're %s, right?" % OS.get_environment("USER"))
			else:
				speak_output("I can't seem to find your $USER...")
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
			if not shutup:
				command_output("ROMWack has been shut up.")
				shutup = true
			else:
				command_output("Error: ROMWack has already been shut up.")
				command_output("Run rom-wack to reset.")
		"wack":
			command_output("Wacking ROM...")
			await(get_tree().create_timer(3).timeout)
			speak_output("The ROM has successfully been wacked.")
		"woman":
			speak_output("Correct.")
		"you":
			speak_output("My name's ROMWack. I was named after the old Amiga debugger.")
		_:
			return_output(express(command))

func express(command) -> String:
	if command.begins_with("print("):
		speak_output("print() won't work here - use command_output()")
	if command.begins_with("speak_output("):
		speak_output("You're not allowed to control what I say.")
		return "Error: tried to run speak_output()"
	if command.begins_with("return_output("):
		speak_output("Last I checked, you weren't a return value.")
		return "Error: tried to manually return a value"
	var expression = Expression.new()
	var error = expression.parse(command)
	if error != OK:
		return "Error: " + expression.get_error_text()
	var result = expression.execute([], self)
	if not expression.has_execute_failed():
		return str(result)
	else:
		return "Error: " + expression.get_error_text()

func command_output(output: String):
	text += "-> " + output + "\n"
	reset_caret_position()

func return_output(output: String):
	text += "<- " + output + "\n"
	reset_caret_position()

func speak_output(output: String):
	if shutup:
		command_output("Error: ROMWack cannot speak.")
		command_output("Run rom-wack to reset.")
		return
	text += "ROMWack says: " + output + "\n"
	reset_caret_position()

func reset_caret_position():
	set_caret_line(get_line_count())

func return_to_menu():
	get_tree().change_scene_to_file("res://menu.tscn")
