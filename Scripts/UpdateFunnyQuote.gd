extends Label

func _ready():
	var quotes = [
		"Try not getting hit next time.",
		"Oh, come on! What do you call that?",
		"RIP In Pieces",
		"The devil may not cry, but you sure do.",
		"There isn't an easy mode. Sorry.",
		"What the frick is a Glitchfall, anyway?",
		"Don't worry, it's just a demo!",
		"You have an evade button for a reason.",
		"Did you jump into a demon? Happens all the time.",
		"Not big surprise",
		"In my medical opinion, that hat looks ridiculous.",
		"Don't tell me you just stood there doing nothing.",
		"No, this isn't how you're supposed to play the game.",
		"At least you didn't clip through the floor and fall.",
		"Did you forget where the attack button was?",
		"You're dead.\nYour friends are dead.\nYour virtual horse is dead.\nThe flowers are dead.\nHalf-Life 3 got deconfirmed.\nYou suck at cooking.\nLive with it.",
	]
	if Input.get_joy_name(0) == "" and not DisplayServer.is_touchscreen_available():
		# If the player is using a keyboard and no touch screen
		quotes.append_array([
			"Maybe invest in an actual controller.",
			"Keyboard controls? Really?",
			"You do not get brownie points for using a keyboard.",
			"Is your controller dead or something?",
			"Press Alt-F4 for free iPod",
		])
	text = quotes[randi_range(0, len(quotes) - 1)]

